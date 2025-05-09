package com.hr.eis.statsSrch.grpStatsPresetMng;

import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hr.common.com.ComController;
import com.hr.eis.statsSrch.statsPresetMng.StatsPresetMngService;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 통계그래프 > 권한그룹별 통계구성 관리 컨트롤러
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/GrpStatsPresetMng.do", method= RequestMethod.POST )
public class GrpStatsPresetMngController extends ComController {

	@Inject
	@Named("StatsPresetMngService")
	private StatsPresetMngService statsPresetMngService;
	
	/**
	 * 권한그룹별 통계구성 관리 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewGrpStatsPresetMng", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewGrpStatsPresetMng() throws Exception {
		return "eis/statsSrch/grpStatsPresetMng/grpStatsPresetMng";
	}
}
