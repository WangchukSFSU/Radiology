/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dcm4che.tool.storescu;

import java.io.File; 
import java.util.List; 
 
import org.dcm4che.data.Attributes; 
import org.dcm4che.data.Tag; 
import org.dcm4che.data.UID; 
import org.dcm4che.tool.storescu.DicomInputStream;
import org.dcm4che.util.SafeClose; 
 
/**
 * @author Gunter Zeilinger <gunterze@gmail.com> 
 * 
 */ 
public abstract class DicomFiles { 
 
    public interface Callback { 
        boolean dicomFile(File f, long dsPos, String tsuid, Attributes ds) 
                throws Exception; 
    } 
 
    public static void scan(List<String> fnames, Callback scb) { 
        for (String fname : fnames) 
            scan(new File(fname), scb); 
    } 
 
    private static void scan(File f, Callback scb) { 
        if (f.isDirectory()) { 
            for (String s : f.list()) 
                scan(new File(f, s), scb); 
            return; 
        } 
        DicomInputStream in = null; 
        try { 
            in = new DicomInputStream(f); 
            in.setIncludeBulkData(false); 
            Attributes fmi = in.readFileMetaInformation(); 
            String tsuid = fmi != null 
                    ? fmi.getString(Tag.TransferSyntaxUID, null) 
                            : in.explicitVR()  
                            ? in.bigEndian() 
                                    ? UID.ExplicitVRBigEndian 
                                            : UID.ExplicitVRLittleEndian 
                                            : UID.ImplicitVRLittleEndian; 
            long dsPos = in.getPosition(); 
            Attributes ds = in.readDataset(-1, Tag.PixelData); 
            boolean b = scb.dicomFile(f, dsPos, tsuid, ds); 
            System.out.print(b ? '.' : 'I'); 
        } catch (Exception e) { 
            System.out.println(); 
            System.out.println("Failed to scan file " + f + ": " + e.getMessage()); 
            e.printStackTrace(System.out); 
        } finally { 
            SafeClose.close(in); 
        } 
    } 
}

