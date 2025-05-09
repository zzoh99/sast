package com.hr.pap.evaluation.mboTargetApr;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;
/**
 * 목표등록,중간점검승인 Service
 * 
 * @author JCY
 *
 */
@Service("MboTargetAprService")  
public class MboTargetAprService{
	@Inject
	@Named("Dao")
	private Dao dao;

}