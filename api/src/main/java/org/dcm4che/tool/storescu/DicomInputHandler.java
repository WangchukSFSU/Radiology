/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dcm4che.tool.storescu;

import java.io.IOException; 
 
import org.dcm4che.data.Attributes; 
import org.dcm4che.data.Fragments; 
import org.dcm4che.data.Sequence; 
 
public interface DicomInputHandler { 
 
    void readValue(DicomInputStream dis, Attributes attrs) 
            throws IOException; 
 
    void readValue(DicomInputStream dis, Sequence seq) 
            throws IOException; 
 
    void readValue(DicomInputStream dis, Fragments frags) 
            throws IOException; 
 
    void startDataset(DicomInputStream dis) 
            throws IOException; 
 
    void endDataset(DicomInputStream dis) 
            throws IOException; 
}

