/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dcm4che.tool.storescu;

import java.util.HashMap; 
import java.util.Properties; 
 
import org.dcm4che.data.UID; 
import org.dcm4che.net.pdu.CommonExtendedNegotiation; 
import org.dcm4che.util.StringUtils; 
 
/**
 * @author Gunter Zeilinger <gunterze@gmail.com> 
 * 
 */ 
class RelatedGeneralSOPClasses { 
 
    private final HashMap<String,CommonExtendedNegotiation> commonExtNegs = 
            new HashMap<String,CommonExtendedNegotiation>(); 
 
    public void init(Properties props) { 
        for (String cuid : props.stringPropertyNames()) 
            commonExtNegs.put(cuid, new CommonExtendedNegotiation(cuid, 
                    UID.StorageServiceClass, 
                    StringUtils.split(props.getProperty(cuid), ','))); 
    } 
 
    public CommonExtendedNegotiation getCommonExtendedNegotiation(String cuid) { 
        CommonExtendedNegotiation commonExtNeg = commonExtNegs.get(cuid); 
        return commonExtNeg != null 
                ? commonExtNeg 
                : new CommonExtendedNegotiation(cuid, UID.StorageServiceClass); 
    } 
}
