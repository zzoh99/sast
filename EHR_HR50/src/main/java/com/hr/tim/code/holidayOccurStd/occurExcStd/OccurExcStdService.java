package com.hr.tim.code.holidayOccurStd.occurExcStd;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * 하계휴가차감기준 Service
 *
 * @author bckim
 *
 */
@Service("OccurExcStdService")
public class OccurExcStdService{

	@Inject
	@Named("Dao")
	private Dao dao;
}