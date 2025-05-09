package com.hr.tim.code.holidayOccurStd.occurStd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 휴가 발생조건 Service
 *
 * @author bckim
 *
 */
@Service("OccurStdService")
public class OccurStdService{

	@Inject
	@Named("Dao")
	private Dao dao;
}