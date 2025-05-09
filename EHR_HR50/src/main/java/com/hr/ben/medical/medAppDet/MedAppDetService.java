package com.hr.ben.medical.medAppDet;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 의료비신청 세부내역 Service
 *
 * @author bckim
 *
 */
@Service("MedAppDetService")
public class MedAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;
}