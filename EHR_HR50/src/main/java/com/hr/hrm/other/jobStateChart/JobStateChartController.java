package com.hr.hrm.other.jobStateChart;

import java.util.Map;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.com.ComController;
import com.hr.common.logger.Log;
import com.hr.common.rd.EncryptRdService;

/**
 * 통계그래프 > 통계 조회 Controller
 * @author gjyoo
 *
 */
@Controller
@RequestMapping(value="/JobStateChart.do", method=RequestMethod.POST )
public class JobStateChartController extends ComController {
	
	@Inject
	@Named("JobStateChartService")
	private JobStateChartService statsSrchService;

	@Inject
    @Named("EncryptRdService")
    private EncryptRdService encryptRdService;

	
	/**
	 * 통계 조회 View
	 * 
	 * @return Stringm
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewJobStateChart", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewStatsMng() throws Exception {
		return "hrm/other/jobStateChart/jobStateChart";
	}
	
	/**
	 * 대상자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobList", method = RequestMethod.POST )
	public ModelAndView getJobList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}/**
	 * 대상자 다건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getJobEmpList", method = RequestMethod.POST )
	public ModelAndView getJobEmpList(
			HttpSession session,  HttpServletRequest request, 
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		return getDataList(session, request, paramMap);
	}

	 /**
     * RD 데이터 암호화
     * @param session
     * @param request
     * @param paramMap
     * @return
     * @throws Exception
     */
    @RequestMapping(params="cmd=getEncryptRd", method = RequestMethod.POST )
    public ModelAndView getEncryptRd(
            HttpSession session, HttpServletRequest request
            , @RequestBody Map<String, Object> paramMap) throws Exception{
        Log.DebugStart();
   
        String mrdPath = "/hrm/empcard/SuccessorCard.mrd";
        String param = "/rp " + paramMap.get("parameters");

        ModelAndView mv = new ModelAndView();
        mv.setViewName("jsonView");
        try {
            mv.addObject("DATA", encryptRdService.encrypt(mrdPath, param));
            mv.addObject("Message", "");
        } catch (Exception e) {
            mv.addObject("Message", "암호화에 실패했습니다.");
        }

        Log.DebugEnd();
        return mv;
    }
}
