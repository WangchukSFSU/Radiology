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
 * Admin let the Radiologist know about the modality software availability
 * 
 * @author tenzin
 */
public class ModalitySoftwareAvalabilityFragmentController {
	
	/**
	 * @param model
	 * @throws Exception
	 */
	public void controller(FragmentModel model) throws Exception {
	}
	
	/**
	 * Send email message to Radiologist
	 * 
	 * @param message message to be send to radiologist
	 */
	public void contactRadiologist(@RequestParam(value = "message", required = false) String message) {
		
		final String username = "johnDevRadio@gmail.com";
		final String password = "john1234";
		
		// replace with radiologist email address
		String recipient = "radiologistOpenmrs@gmail.com";
		
		// set up smtp server
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			
			// user authentication required
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		try {
			// Sender and receiver info with the message
			Message message1 = new MimeMessage(session);
			message1.setFrom(new InternetAddress("johnDevRadio@gmail.com"));
			message1.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
			message1.setSubject("Modality Software Avalaibility");
			message1.setText("Dear Radiologist," + "\n\n " + message);
			Transport.send(message1);
			
		}
		catch (MessagingException e) {
			throw new RuntimeException(e);
		}
		
	}
	
}
