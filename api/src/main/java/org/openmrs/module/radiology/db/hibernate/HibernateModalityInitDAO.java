/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db.hibernate;

import java.util.List;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;

import org.openmrs.module.radiology.ModalityInit;

import org.openmrs.module.radiology.db.ModalityInitDAO;

/**
 *
 * @author youdon
 */
/**
 * The default implementation of {@link DepartmentDAO}.
 */
public class HibernateModalityInitDAO implements ModalityInitDAO {
	
	protected final Log log = LogFactory.getLog(this.getClass());
	
	private SessionFactory sessionFactory;
	
	/**
	 * @param sessionFactory the sessionFactory to set
	 */
	public void setSessionFactory(SessionFactory sessionFactory) {
		this.sessionFactory = sessionFactory;
	}
	
	/**
	 * @return the sessionFactory
	 */
	public SessionFactory getSessionFactory() {
		return sessionFactory;
	}
	
	/**
	 * @see org.openmrs.module.department.api.db.DepartmentDAO#getAllDepartments()
	 */
	
	/**
	 * @see org.openmrs.module.department.api.DepartmentService#getDepartment(java.lang.Integer)
	 */
	@Override
	public ModalityInit getModalityInit(Integer modalityId) {
		return (ModalityInit) sessionFactory.getCurrentSession()
				.get(ModalityInit.class, modalityId);
	}
	
	/**
	 * @see org.openmrs.module.department.api.db.DepartmentDAO#saveDepartment(org.openmrs.module.department.Department)
	 */
	
	/**
	 * @see org.openmrs.module.department.api.db.DepartmentDAO#purgeDepartment(org.openmrs.module.department.Department)
	 */
	
	@Override
	public List<ModalityInit> getAllModalityInit() {
		return sessionFactory.getCurrentSession()
				.createCriteria(ModalityInit.class)
				.list();
	}
	
	@Override
	public ModalityInit saveModalityInit(ModalityInit modalityinit) {
		sessionFactory.getCurrentSession()
				.save(modalityinit);
		return modalityinit;
	}
	
	@Override
	public void purgeModalityInit(ModalityInit modalityinit) {
		sessionFactory.getCurrentSession()
				.delete(modalityinit);
	}
	
}
