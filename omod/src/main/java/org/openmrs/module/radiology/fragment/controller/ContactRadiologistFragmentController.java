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
import org.openmrs.Patient;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author youdon
 */
public class ContactRadiologistFragmentController {
	
	public void controller(FragmentModel model, @RequestParam(value = "returnUrl", required = false) String returnUrl,
			@RequestParam(value = "patientId", required = false) Patient patient,
			@RequestParam(value = "orderId", required = false) Integer id) {
		
		String PatientName = patient.getNames()
				.toString();
		String patientName = PatientName.substring(1, PatientName.length() - 1);
		System.out.println("id  id " + id);
		System.out.println("returnUrl  returnUrl " + returnUrl);
		System.out.println("patient  patient " + patient);
		model.addAttribute("returnUrl", returnUrl);
		model.addAttribute("patient", patient);
		model.addAttribute("patientID", patient.getPatientId());
		model.addAttribute("patientname", patientName);
		model.addAttribute("patientdob", patient.getBirthdate());
		model.addAttribute("patientid", patient.getId());
		model.addAttribute("radiologistemailaddress", "radiologistemailaddress@gmail.com");
		model.addAttribute("subject", "Enquire Patient Observation");
	}
	
	public void sendEmailToRadiologist(@RequestParam(value = "recipient", required = false) String recipient,
			@RequestParam(value = "subject", required = false) String subject,
			@RequestParam(value = "message", required = false) String message) {
		
		System.out.println("POST POST POST POST");
		System.out.println("POST POST POST POST recipient" + recipient);
		System.out.println("POST POST POST POST subject" + subject);
		System.out.println("POST POST POST POST message" + message);
		// return "redirect:radiology/radiologyOrder.page";
		
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
			message1.setSubject("Testing Subject");
			message1.setText("Dear Mail Crawler," + "\n\n No spam to my email, please!");
			
			Transport.send(message1);
			
			System.out.println("Done");
			
		}
		catch (MessagingException e) {
			throw new RuntimeException(e);
		}
		
	}
	
}
