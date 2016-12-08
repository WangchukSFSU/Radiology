/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.fragment.controller;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class ModalitySoftwareAvalabilityFragmentController {
	
	public void controller(FragmentModel model) throws Exception {
	}
	
	public void contactRadiologist(@RequestParam(value = "message", required = false) String message) {
		
		final String username = "tibwangchuk@gmail.com";
		final String password = "TznWangchuk80";
		
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		try {
			
			Message message1 = new MimeMessage(session);
			message1.setFrom(new InternetAddress("tibwangchuk@gmail.com"));
			message1.setRecipients(Message.RecipientType.TO, InternetAddress.parse("tenzin.wangchuk@yahoo.com"));
			message1.setSubject("Modality Software Avalaibility");
			message1.setText("Dear Radiologist," + "\n\n " + message);
			
			Transport.send(message1);
			System.out.println("SSSeeennnttt");
			
		}
		catch (MessagingException e) {
			throw new RuntimeException(e);
		}
		
	}
	
}
