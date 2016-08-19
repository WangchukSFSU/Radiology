/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db.hibernate;

import java.util.List;
import org.hibernate.SessionFactory;
import org.openmrs.module.radiology.RadiologyStudyList;
import org.openmrs.module.radiology.db.RadiologyStudyListDAO;

/**
 * @author youdon
 */

public class RadiologyStudyListDAOImpl implements RadiologyStudyListDAO {
	
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
	public RadiologyStudyList saveStudyList(RadiologyStudyList studyList) {
		sessionFactory.getCurrentSession()
				.saveOrUpdate(studyList);
		return studyList;
	}
	
	@Override
	public List<RadiologyStudyList> getAllStudy() {
		return sessionFactory.getCurrentSession()
				.createCriteria(RadiologyStudyList.class)
				.list();
	}
	
	@Override
	public RadiologyStudyList getStudy(Integer id) {
		return (RadiologyStudyList) sessionFactory.getCurrentSession()
				.get(RadiologyStudyList.class, id);
	}
}
