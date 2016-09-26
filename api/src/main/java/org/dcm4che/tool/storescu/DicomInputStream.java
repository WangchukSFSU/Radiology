/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dcm4che.tool.storescu;

import java.io.BufferedInputStream; 
import java.io.EOFException; 
import java.io.File; 
import java.io.FileInputStream; 
import java.io.FileOutputStream; 
import java.io.FilterInputStream; 
import java.io.IOException; 
import java.io.InputStream; 
import java.io.ObjectInputStream; 
import java.net.URI; 
import java.net.URISyntaxException; 
import java.util.ArrayList; 
import java.util.Arrays; 
import java.util.Collections; 
import java.util.List; 
import java.util.zip.Inflater; 
import java.util.zip.InflaterInputStream; 
 
import org.dcm4che.data.Attributes; 
import org.dcm4che.data.BulkDataLocator; 
import org.dcm4che.data.ElementDictionary; 
import org.dcm4che.data.Fragments; 
import org.dcm4che.data.ItemPointer; 
import org.dcm4che.data.Sequence; 
import org.dcm4che.data.Tag; 
import org.dcm4che.data.UID; 
import org.dcm4che.data.VR; 
import org.dcm4che.io.DicomStreamException;
import org.dcm4che.util.ByteUtils; 
import org.dcm4che.util.SafeClose; 
import org.dcm4che.util.StreamUtils; 
import org.dcm4che.util.TagUtils; 
import org.slf4j.Logger; 
import org.slf4j.LoggerFactory; 
 
/**
 * @author Gunter Zeilinger <gunterze@gmail.com> 
 */ 
public class DicomInputStream extends FilterInputStream 
    implements DicomInputHandler { 
 
    private static final Logger LOG =  
        LoggerFactory.getLogger(DicomInputStream.class); 
 
    private static final String UNEXPECTED_NON_ZERO_ITEM_LENGTH = 
        "Unexpected item value of {} #{} @ {}"; 
    private static final String UNEXPECTED_ATTRIBUTE = 
        "Unexpected attribute {} #{} @ {}"; 
    private static final String MISSING_TRANSFER_SYNTAX = 
        "Missing Transfer Syntax (0002,0010) - assume Explicit VR Little Endian"; 
    private static final String MISSING_FMI_LENGTH = 
        "Missing or wrong File Meta Information Group Length (0002,0000)"; 
    private static final String NOT_A_DICOM_STREAM =  
        "Not a DICOM Stream"; 
    private static final String IMPLICIT_VR_BIG_ENDIAN = 
        "Implicit VR Big Endian encoded DICOM Stream"; 
    private static final String DEFLATED_WITH_ZLIB_HEADER = 
        "Deflated DICOM Stream with ZLIB Header"; 
 
    private static final int ZLIB_HEADER = 0x789c; 
    private static final int ALLOC_INC = 0x4000000; // 64 MiB 
 
    private String uri; 
    private String tsuid; 
    private byte[] preamble; 
    private Attributes fileMetaInformation; 
    private boolean hasfmi; 
    private boolean bigEndian; 
    private boolean explicitVR; 
    private boolean includeBulkData = true; 
    private boolean includeBulkDataLocator; 
    private long pos; 
    private long fmiEndPos = -1L; 
    private long tagPos; 
    private long markPos; 
    private int tag; 
    private VR vr; 
    private int length; 
    private DicomInputHandler handler = this; 
    private Attributes bulkData; 
    private final byte[] buffer = new byte[12]; 
    private ItemPointer[] itemPointers = {}; 
    private int level; 
 
    private boolean catBlkFiles; 
    private String blkFilePrefix = "blk"; 
    private String blkFileSuffix; 
    private File blkDirectory; 
    private ArrayList<File> blkFiles; 
    private String blkURI; 
    private FileOutputStream blkOut; 
    private long blkOutPos; 
 
    public static Attributes defaultBulkData() { 
        Attributes bulkData = new Attributes(7); 
        bulkData.setNull(Tag.PixelDataProviderURL, VR.UT); 
        bulkData.setNull(Tag.AudioSampleData, VR.OB); 
        bulkData.setNull(Tag.CurveData, VR.OB); 
        Attributes wfsqitem = new Attributes(1); 
        bulkData.newSequence(Tag.WaveformSequence, 1).add(wfsqitem); 
        bulkData.setNull(Tag.SpectroscopyData, VR.OF); 
        wfsqitem.setNull(Tag.WaveformData, VR.OB); 
        bulkData.setNull(Tag.OverlayData, VR.OB); 
        bulkData.setNull(Tag.PixelData, VR.OB); 
        return bulkData; 
    } 
 
    public DicomInputStream(InputStream in, String tsuid) throws IOException { 
        super(in); 
        switchTransferSyntax(tsuid); 
    } 
 
    public DicomInputStream(InputStream in) throws IOException { 
        super(in.markSupported() ? in : new BufferedInputStream(in)); 
        guessTransferSyntax(); 
    } 
 
    public DicomInputStream(File file) throws IOException { 
        this(new FileInputStream(file)); 
        uri = file.toURI().toString(); 
    } 
 
    public final String getURI() { 
        return uri; 
    } 
 
    public final void setURI(String uri) { 
        if (uri != null) 
            try { 
                new URI(uri); 
            } catch (URISyntaxException e) { 
                throw new IllegalArgumentException(e.getMessage()); 
            } 
        this.uri = uri; 
    } 
 
    public final boolean isIncludeBulkData() { 
        return includeBulkData; 
    } 
 
    public final void setIncludeBulkData(boolean includeBulkData) { 
        this.includeBulkData = includeBulkData; 
        if (includeBulkData) 
            includeBulkDataLocator = false; 
    } 
 
    public final boolean isIncludeBulkDataLocator() { 
        return includeBulkDataLocator; 
    } 
 
    public final void setIncludeBulkDataLocator(boolean includeBulkDataLocator) { 
        this.includeBulkDataLocator = includeBulkDataLocator; 
        if (includeBulkDataLocator) 
            includeBulkData = false; 
    } 
 
    public final String getBulkDataFilePrefix() { 
        return blkFilePrefix; 
    } 
 
    public final void setBulkDataFilePrefix(String blkFilePrefix) { 
        this.blkFilePrefix = blkFilePrefix; 
    } 
 
    public final String getBulkDataFileSuffix() { 
        return blkFileSuffix; 
    } 
 
    public final void setBulkDataFileSuffix(String blkFileSuffix) { 
        this.blkFileSuffix = blkFileSuffix; 
    } 
 
    public final File getBulkDataDirectory() { 
        return blkDirectory; 
    } 
 
    public final void setBulkDataDirectory(File blkDirectory) { 
        this.blkDirectory = blkDirectory; 
    } 
 
    public final boolean isConcatenateBulkDataFiles() { 
        return catBlkFiles; 
    } 
 
    public final void setConcatenateBulkDataFiles(boolean catBlkFiles) { 
        this.catBlkFiles = catBlkFiles; 
    } 
 
    public final List<File> getBulkDataFiles() { 
        if (blkFiles != null) 
            return blkFiles; 
        else 
            return Collections.emptyList(); 
    } 
 
    public final Attributes getBulkDataAttributes() { 
        return bulkData; 
    } 
 
    public final void setBulkDataAttributes(Attributes bulkData) { 
        this.bulkData = bulkData; 
    } 
 
    public final void setDicomInputHandler(DicomInputHandler handler) { 
        if (handler == null) 
            throw new NullPointerException("handler"); 
        this.handler = handler; 
    } 
 
    public final void setFileMetaInformationGroupLength(byte[] val) { 
        fmiEndPos = pos + ByteUtils.bytesToInt(val, 0, bigEndian); 
    } 
 
    public final byte[] getPreamble() { 
        return preamble; 
    } 
 
    public Attributes getFileMetaInformation() throws IOException { 
        readFileMetaInformation(); 
        return fileMetaInformation; 
    } 
 
    public final int level() { 
        return level; 
    } 
 
    public final int tag() { 
        return tag; 
    } 
 
    public final VR vr() { 
        return vr; 
    } 
 
    public final int length() { 
        return length; 
    } 
 
    public final long getPosition() { 
        return pos; 
    } 
 
    public void setPosition(long pos) { 
        this.pos = pos; 
    } 
 
    public long getTagPosition() { 
        return tagPos; 
    } 
 
    public final boolean bigEndian() { 
        return bigEndian; 
    } 
 
    public final boolean explicitVR() { 
        return explicitVR; 
    } 
 
    @Override 
    public void close() throws IOException { 
        SafeClose.close(blkOut); 
        super.close(); 
    } 
 
    @Override 
    public synchronized void mark(int readlimit) { 
        super.mark(readlimit); 
        markPos = pos; 
    } 
 
    @Override 
    public synchronized void reset() throws IOException { 
        super.reset(); 
        pos = markPos; 
    } 
 
    @Override 
    public final int read() throws IOException { 
        int read = super.read(); 
        if (read >= 0) 
            pos++; 
        return read; 
    } 
 
    @Override 
    public final int read(byte[] b, int off, int len) throws IOException { 
        int read = super.read(b, off, len); 
        if (read > 0) 
            pos += read; 
        return read; 
    } 
 
    @Override 
    public final int read(byte[] b) throws IOException { 
        return read(b, 0, b.length); 
    } 
 
    @Override 
    public final long skip(long n) throws IOException { 
        long skip = super.skip(n); 
        pos += skip; 
        return skip; 
    } 
 
    public void skipFully(long n) throws IOException { 
        StreamUtils.skipFully(this, n); 
    } 
 
    public void readFully(byte b[]) throws IOException { 
        readFully(b, 0, b.length); 
    } 
 
    public void readFully(byte b[], int off, int len) throws IOException { 
        StreamUtils.readFully(this, b, off, len); 
    } 
 
    public void readHeader() throws IOException { 
        byte[] buf = buffer; 
        tagPos = pos;  
        readFully(buf, 0, 8); 
        switch(tag = ByteUtils.bytesToTag(buf, 0, bigEndian)) { 
        case Tag.Item: 
        case Tag.ItemDelimitationItem: 
        case Tag.SequenceDelimitationItem: 
           vr = null; 
           break; 
        default: 
            if (explicitVR) { 
                vr = VR.valueOf(ByteUtils.bytesToVR(buf, 4)); 
                if (vr.headerLength() == 8) { 
                    length = ByteUtils.bytesToUShort(buf, 6, bigEndian); 
                    return; 
                } 
                readFully(buf, 4, 4); 
            } else { 
                vr = VR.UN; 
            } 
        } 
        length = ByteUtils.bytesToInt(buf, 4, bigEndian); 
    } 
 
    public Attributes readCommand() throws IOException { 
        if (bigEndian || explicitVR) 
            throw new IllegalStateException( 
                    "bigEndian=" + bigEndian + ", explicitVR=" + explicitVR ); 
        Attributes attrs = new Attributes(9); 
        readAttributes(attrs, -1, -1); 
        return attrs; 
    } 
 
    public Attributes readDataset(int len, int stopTag) throws IOException { 
        handler.startDataset(this); 
        readFileMetaInformation(); 
        Attributes attrs = new Attributes(bigEndian, 64); 
        readAttributes(attrs, len, stopTag); 
        attrs.trimToSize(); 
        handler.endDataset(this); 
        return attrs; 
    } 
 
    public Attributes readFileMetaInformation() throws IOException { 
        if (!hasfmi) 
            return null;  // No File Meta Information 
        if (fileMetaInformation != null) 
            return fileMetaInformation;  // already read 
 
        Attributes attrs = new Attributes(bigEndian, 9); 
        while (pos != fmiEndPos) { 
            mark(12); 
            readHeader(); 
            if (TagUtils.groupNumber(tag) != 2) { 
                LOG.warn(MISSING_FMI_LENGTH); 
                reset(); 
                break; 
            } 
             if (vr != null) { 
                if (vr == VR.UN) 
                    vr = ElementDictionary.getStandardElementDictionary() 
                            .vrOf(tag); 
                handler.readValue(this, attrs); 
            } else 
                skipAttribute(UNEXPECTED_ATTRIBUTE); 
        } 
        fileMetaInformation = attrs; 
 
        String tsuid = attrs.getString(Tag.TransferSyntaxUID, null); 
        if (tsuid == null) { 
            LOG.warn(MISSING_TRANSFER_SYNTAX); 
            tsuid = UID.ExplicitVRLittleEndian; 
        } 
        switchTransferSyntax(tsuid); 
        return attrs; 
    } 
 
    public void readAttributes(Attributes attrs, int len, int stopTag) 
            throws IOException { 
        boolean undeflen = len == -1; 
        boolean hasStopTag = stopTag != -1; 
        long endPos =  pos + (len & 0xffffffffL); 
        while (undeflen || this.pos < endPos) { 
            try { 
                readHeader(); 
            } catch (EOFException e) { 
                if (undeflen && pos == tagPos) 
                    break; 
                throw e; 
            } 
            if (hasStopTag && tag == stopTag) 
                break; 
            if (vr != null) { 
                boolean prevBigEndian = bigEndian; 
                boolean prevExplicitVR = explicitVR; 
                try { 
                    if (vr == VR.UN) { 
                        bigEndian = false; 
                        explicitVR = false; 
                        vr = ElementDictionary.vrOf(tag, 
                                attrs.getPrivateCreator(tag)); 
                        if (vr == VR.UN && length == -1) 
                            vr = VR.SQ; // assumes UN with undefined length are SQ, 
                                        // will fail on UN fragments! 
                    } 
                    handler.readValue(this, attrs); 
                } finally { 
                    bigEndian = prevBigEndian; 
                    explicitVR = prevExplicitVR; 
                } 
            } else 
                skipAttribute(UNEXPECTED_ATTRIBUTE); 
        } 
    } 
 
    @Override 
    public void readValue(DicomInputStream dis, Attributes attrs) 
            throws IOException { 
        checkIsThis(dis); 
        if (length == 0) { 
            if (includeBulkData || includeBulkDataLocator || isBulkData(attrs)) 
                attrs.setNull(tag, vr); 
        } else if (vr == VR.SQ) { 
            readSequence(length, attrs, tag); 
        } else if (length == -1) { 
            readFragments(attrs, tag, vr); 
        } else if (length == BulkDataLocator.MAGIC_LEN 
                && super.in instanceof ObjectInputStream) { 
            attrs.setValue(tag, vr, BulkDataLocator.deserializeFrom( 
                    (ObjectInputStream) super.in)); 
        } else if (includeBulkData || !isBulkData(attrs)){ 
            byte[] b = readValue(); 
            if (!TagUtils.isGroupLength(tag)) { 
                if (bigEndian != attrs.bigEndian()) 
                    vr.toggleEndian(b, false); 
                attrs.setBytes(tag, vr, b); 
            } else if (tag == Tag.FileMetaInformationGroupLength) 
                setFileMetaInformationGroupLength(b); 
        } else if (includeBulkDataLocator) { 
            attrs.setValue(tag, vr, createBulkDataLocator()); 
        } else { 
            skipFully(length); 
        } 
    } 
 
    public BulkDataLocator createBulkDataLocator() throws IOException { 
            BulkDataLocator locator; 
        if (uri != null && !(super.in instanceof InflaterInputStream)) { 
            locator = new BulkDataLocator(uri, tsuid, pos, length); 
            skipFully(length); 
        } else { 
            if (blkOut == null) { 
                File blkfile = File.createTempFile(blkFilePrefix, 
                        blkFileSuffix, blkDirectory); 
                if (blkFiles == null) 
                    blkFiles = new ArrayList<File>(); 
                blkFiles.add(blkfile); 
                blkURI = blkfile.toURI().toString(); 
                blkOut = new FileOutputStream(blkfile); 
                blkOutPos = 0L; 
            } 
            try { 
                StreamUtils.copy(this, blkOut, length); 
            } finally { 
                if (!catBlkFiles) { 
                    SafeClose.close(blkOut); 
                    blkOut = null; 
                } 
            } 
            locator = new BulkDataLocator(blkURI, 
                    (super.in instanceof InflaterInputStream) 
                            ? UID.ExplicitVRLittleEndian 
                            : tsuid, 
                     blkOutPos, length); 
            blkOutPos += length; 
        } 
        return locator; 
    } 
 
    public boolean isBulkData(Attributes attrs) { 
        if (TagUtils.isPrivateCreator(tag)) 
            return false; 
        int grtag = TagUtils.groupNumber(tag); 
        if (grtag < 8) 
            return false; 
        if (bulkData == null) 
            bulkData = DicomInputStream.defaultBulkData(); 
        Attributes item = bulkData; 
        for (int i = 0; i < level; i++) { 
            ItemPointer ip = itemPointers[i]; 
            Sequence sq = (Sequence) 
                    item.getValue(ip.privateCreator, ip.sequenceTag); 
            if (sq == null) 
                return false; 
            item = sq.get(0); 
        } 
        int tag0 = ((grtag &= 0xff01) == 0x5000 || grtag == 0x6000) 
                ? tag & 0xff00ffff : tag; 
        return item.contains(attrs.getPrivateCreator(tag), tag0); 
    } 
 
    public boolean isBulkDataFragment() { 
        if (tag != Tag.Item) 
            return false; 
        if (bulkData == null) 
            bulkData = DicomInputStream.defaultBulkData(); 
        Attributes item = bulkData; 
        for (int i = 0; i < level; i++) { 
            ItemPointer ip = itemPointers[i]; 
            Object value = item.getValue(ip.privateCreator, ip.sequenceTag); 
            if (value instanceof Sequence) 
                item = ((Sequence) value).get(0); 
            else 
                return value != null; 
        } 
        return false; 
    } 
 
    @Override 
    public void readValue(DicomInputStream dis, Sequence seq) 
            throws IOException { 
        checkIsThis(dis); 
        if (length == 0) { 
            seq.add(new Attributes(seq.getParent().bigEndian(), 0)); 
            return; 
        } 
        Attributes attrs = new Attributes(seq.getParent().bigEndian()); 
        seq.add(attrs); 
        readAttributes(attrs, length, Tag.ItemDelimitationItem); 
        attrs.trimToSize(); 
    } 
 
    @Override 
    public void readValue(DicomInputStream dis, Fragments frags) 
            throws IOException { 
        checkIsThis(dis); 
        if (length == 0) { 
            if (includeBulkData || includeBulkDataLocator || 
                    isBulkDataFragment()) 
                frags.add(ByteUtils.EMPTY_BYTES); 
        } else if (length == BulkDataLocator.MAGIC_LEN 
                && super.in instanceof ObjectInputStream) { 
            frags.add(BulkDataLocator.deserializeFrom( 
                    (ObjectInputStream) super.in)); 
        } else if (includeBulkData && !includeBulkDataLocator  
                || !isBulkDataFragment()){ 
            byte[] b = readValue(); 
            if (bigEndian != frags.bigEndian()) 
                vr.toggleEndian(b, false); 
            frags.add(b); 
        } else if (includeBulkDataLocator) { 
            frags.add(createBulkDataLocator()); 
        } else { 
            skipFully(length); 
        } 
    } 
 
    @Override 
    public void startDataset(DicomInputStream dis) { 
    } 
 
    @Override 
    public void endDataset(DicomInputStream dis) { 
    } 
 
    private void checkIsThis(DicomInputStream dis) { 
        if (dis != this) 
            throw new IllegalArgumentException("dis != this"); 
    } 
 
    private void skipAttribute(String message) throws IOException { 
        LOG.warn(message, 
                 new Object[] { TagUtils.toString(tag), length, tagPos }); 
        skip(length); 
    } 
 
    private void readSequence(int len, Attributes attrs, int sqtag) 
            throws IOException { 
        Sequence seq = attrs.newSequence(sqtag, 10); 
        String privateCreator = attrs.getPrivateCreator(sqtag); 
        boolean undefLen = len == -1; 
        long endPos = pos + (len & 0xffffffffL); 
        for (int i = 0; undefLen || pos < endPos; ++i) { 
            readHeader(); 
            if (tag == Tag.Item) { 
                addItemPointer(sqtag, privateCreator, i); 
                handler.readValue(this, seq); 
                removeItemPointer(); 
            } else if (tag == Tag.SequenceDelimitationItem) { 
                if (length != 0) 
                    skipAttribute(UNEXPECTED_NON_ZERO_ITEM_LENGTH); 
                break; 
            } else 
                skipAttribute(UNEXPECTED_ATTRIBUTE); 
        } 
        if (seq.isEmpty()) 
            attrs.setNull(sqtag, VR.SQ); 
        else 
            seq.trimToSize(); 
    } 
 
    private void addItemPointer(int sqtag, String privateCreator, int itemIndex) { 
        if (itemPointers.length <= level) 
            itemPointers = Arrays.copyOf(itemPointers, level + 1); 
        itemPointers[level++] = new ItemPointer(sqtag, privateCreator, itemIndex); 
    } 
 
    private void removeItemPointer() { 
        itemPointers[--level] = null; 
    } 
 
    public Attributes readItem() throws IOException { 
        readHeader(); 
        if (tag != Tag.Item) 
            throw new IOException("Unexpected attribute " 
                    + TagUtils.toString(tag) + " #" + length + " @ " + pos); 
        Attributes attrs = new Attributes(bigEndian); 
        attrs.setItemPosition(tagPos); 
        readAttributes(attrs, length, Tag.ItemDelimitationItem); 
        attrs.trimToSize(); 
        return attrs; 
    } 
 
    private void readFragments(Attributes attrs, int fragsTag, VR vr) 
            throws IOException { 
        Fragments frags = new Fragments(vr, attrs.bigEndian(), 10); 
        String privateCreator = attrs.getPrivateCreator(fragsTag); 
        for (int i = 0; true; ++i) { 
            readHeader(); 
            if (tag == Tag.Item) { 
                addItemPointer(fragsTag, privateCreator, i); 
                handler.readValue(this, frags); 
                removeItemPointer(); 
            } else if (tag == Tag.SequenceDelimitationItem) { 
                if (length != 0) 
                    skipAttribute(UNEXPECTED_NON_ZERO_ITEM_LENGTH); 
                break; 
            } else 
                skipAttribute(UNEXPECTED_ATTRIBUTE); 
        } 
        if (frags.isEmpty()) 
            attrs.setNull(fragsTag, vr); 
        else { 
            frags.trimToSize(); 
            attrs.setValue(fragsTag, vr, frags); 
        } 
    } 
 
    public byte[] readValue() throws IOException { 
        if (length < 0) 
            throw new EOFException(); // assume InputStream length < 2 GiB 
        int allocLen = Math.min(length, ALLOC_INC); 
        byte[] value = new byte[allocLen]; 
        readFully(value, 0, allocLen); 
        while (allocLen < length) { 
            int newLength = Math.min(length, allocLen + ALLOC_INC); 
            value = Arrays.copyOf(value, newLength); 
            readFully(value, allocLen, newLength - allocLen); 
            allocLen = newLength; 
        } 
        return value; 
    } 
 
    private void switchTransferSyntax(String tsuid) throws IOException { 
        this.tsuid = tsuid; 
        bigEndian = tsuid.equals(UID.ExplicitVRBigEndian); 
        explicitVR = !tsuid.equals(UID.ImplicitVRLittleEndian); 
        if (tsuid.equals(UID.DeflatedExplicitVRLittleEndian) 
                        || tsuid.equals(UID.JPIPReferencedDeflate)) { 
            if (hasZLIBHeader()) { 
                LOG.warn(DEFLATED_WITH_ZLIB_HEADER); 
                super.in = new InflaterInputStream(super.in); 
            } else 
                super.in = new InflaterInputStream(super.in, 
                        new Inflater(true)); 
        } 
    } 
 
    private boolean hasZLIBHeader() throws IOException { 
        if (!markSupported()) 
            return false; 
        byte[] buf = buffer; 
        mark(2); 
        read(buf, 0, 2); 
        reset(); 
        return ByteUtils.bytesToUShortBE(buf, 0) == ZLIB_HEADER; 
    } 
 
    private void guessTransferSyntax() throws IOException { 
        byte[] b128 = new byte[128]; 
        byte[] buf = buffer; 
        mark(132); 
        int rlen = read(b128); 
        if (rlen == 128) { 
            read(buf, 0, 4); 
            if (buf[0] == 'D' && buf[1] == 'I' 
                    && buf[2] == 'C' && buf[3] == 'M') { 
                preamble = b128.clone(); 
                if (!markSupported()) { 
                    hasfmi = true; 
                    tsuid = UID.ExplicitVRLittleEndian; 
                    bigEndian = false; 
                    explicitVR = true; 
                    return; 
                } 
                mark(128); 
                read(b128); 
            } 
        } 
        if (rlen < 8 
                || !guessTransferSyntax(b128, rlen, false) 
                && !guessTransferSyntax(b128, rlen, true)) 
            throw new DicomStreamException(NOT_A_DICOM_STREAM); 
        reset(); 
        hasfmi = TagUtils.isFileMetaInformation( 
                ByteUtils.bytesToTag(b128, 0, bigEndian)); 
    } 
 
    private boolean guessTransferSyntax(byte[] b128, int rlen, boolean bigEndian) 
            throws DicomStreamException { 
        int tag1 = ByteUtils.bytesToTag(b128, 0, bigEndian); 
        VR vr = ElementDictionary.vrOf(tag1, null); 
        if (vr == VR.UN) 
            return false; 
        if (ByteUtils.bytesToVR(b128, 4) == vr.code()) { 
            this.tsuid = bigEndian ? UID.ExplicitVRBigEndian  
                                   : UID.ExplicitVRLittleEndian; 
            this.bigEndian = bigEndian; 
            this.explicitVR = true; 
            return true; 
        } 
        int len = ByteUtils.bytesToInt(b128, 4, bigEndian); 
        if (len < 0 || 8 + len > rlen) 
            return false; 
 
        if (bigEndian) 
            throw new DicomStreamException(IMPLICIT_VR_BIG_ENDIAN); 
 
        this.tsuid = UID.ImplicitVRLittleEndian; 
        this.bigEndian = false; 
        this.explicitVR = false; 
        return true; 
    } 
 
}

