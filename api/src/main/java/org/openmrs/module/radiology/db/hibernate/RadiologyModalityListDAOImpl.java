/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db.hibernate;

import java.util.List;
import org.hibernate.SessionFactory;
import org.openmrs.module.radiology.RadiologyModalityList;
import org.openmrs.module.radiology.db.RadiologyModalityListDAO;

/**
 * @author youdon
 */

public class RadiologyModalityListDAOImpl implements RadiologyModalityListDAO {
	
	private SessionFactory sessionFactory;
	
	/**
	 * Set session factory that allows us to connect to the database that Hibernate knows about.
	 *
	 * @param sessionFactory
	 */
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
	/**
	 * @see org.openmrs.module.radiology.RadiologyService#saveStudy(Integer)
	 */
	@Override
	public RadiologyModalityList saveModalityList(RadiologyModalityList modality) {
		sessionFactory.getCurrentSession()
				.saveOrUpdate(modality);
		return modality;
	}
	
	@Override
	public List<RadiologyModalityList> getAllModality() {
		return sessionFactory.getCurrentSession()
				.createCriteria(RadiologyModalityList.class)
				.list();
	}
	
	@Override
	public RadiologyModalityList getModality(Integer id) {
		return (RadiologyModalityList) sessionFactory.getCurrentSession()
				.get(RadiologyModalityList.class, id);
	}
	
	@Override
	public RadiologyModalityList getModalityName(String modalityname) {
		return (RadiologyModalityList) sessionFactory.getCurrentSession()
				.get(RadiologyModalityList.class, modalityname);
	}
}
