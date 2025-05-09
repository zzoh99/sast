package com.hr.tra.lectureFee.lectureFeeAppDet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 사내강사료신청 세부내역 Service
 */
@Service("LectureFeeAppDetService")
public class LectureFeeAppDetService{

	@Inject
	@Named("Dao")
	private Dao dao;

}