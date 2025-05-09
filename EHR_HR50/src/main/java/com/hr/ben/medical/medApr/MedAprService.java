package com.hr.ben.medical.medApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 의료비승인 Service
 * 
 * @author 이름
 *
 */
@Service("MedAprService")  
public class MedAprService{
	@Inject
	@Named("Dao")
	private Dao dao;
}