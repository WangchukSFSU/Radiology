/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db.hibernate;

import java.util.List;
import org.hibernate.SessionFactory;
import org.openmrs.module.radiology.RadiologyModalityList;
import org.openmrs.module.radiology.RadiologyReportList;
import org.openmrs.module.radiology.db.RadiologyModalityListDAO;
import org.openmrs.module.radiology.db.RadiologyReportListDAO;

/**
 * @author youdon
 */

public class RadiologyReportListDAOImpl implements RadiologyReportListDAO {
	
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
	public RadiologyReportList saveReportList(RadiologyReportList report) {
		sessionFactory.getCurrentSession()
				.saveOrUpdate(report);
		return report;
	}
	
	@Override
	public List<RadiologyReportList> getAllReport() {
		return sessionFactory.getCurrentSession()
				.createCriteria(RadiologyReportList.class)
				.list();
	}
	
	@Override
	public RadiologyReportList getReport(Integer id) {
		return (RadiologyReportList) sessionFactory.getCurrentSession()
				.get(RadiologyReportList.class, id);
	}
	
	@Override
	public RadiologyReportList getReportUUID(String reportuuid) {
		return (RadiologyReportList) sessionFactory.getCurrentSession()
				.get(RadiologyReportList.class, reportuuid);
	}
}
