package com.hr.common.popup.rdPopup;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import org.springframework.stereotype.Service;
import com.hr.common.dao.Dao;
import com.hr.common.logger.Log;

/**
 * MRD 공통팝업 Service
 * by JSG
 * @author JSG
 *
 */
@SuppressWarnings("unused")
@Service("RdPopupService")
public class RdPopupService{
	@SuppressWarnings("unused")
	@Inject
	@Named("Dao")
	private Dao dao;


}