/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.openmrs.module.radiology.db;

import java.util.List;

import org.openmrs.module.radiology.ModalityInit;

/**
 *
 * @author youdon
 */

/**
 * Database methods for {@link DepartmentService}.
 */
public interface ModalityInitDAO {
	
	/**
	 * @see org.openmrs.module.department.api.DepartmentService#getAllDepartments()
	 */
	List<ModalityInit> getAllModalityInit();
	
	/**
	 * @see org.openmrs.module.department.api.DepartmentService#getDepartment(java.lang.Integer)
	 */
	ModalityInit getModalityInit(Integer modalityId);
	
	/**
	 * @see org.openmrs.module.department.api.DepartmentService#saveDepartment(org.openmrs.module.department.Department)
	 */
	ModalityInit saveModalityInit(ModalityInit modalityinit);
	
	/**
	 * @see org.openmrs.module.department.api.DepartmentService#purgeDepartment(org.openmrs.module.department.Department)
	 */
	void purgeModalityInit(ModalityInit modalityinit);
	
}
