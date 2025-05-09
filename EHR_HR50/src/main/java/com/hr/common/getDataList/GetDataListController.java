package com.hr.common.getDataList;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.atuhTable.AuthTableService;
import com.hr.common.logger.Log;
import com.nhncorp.lucy.security.xss.XssPreventer;

/**
 * GET DATA LIST TYPE Controller
 *
 * @author RYU SIOONG
 *
 */
@Controller
@RequestMapping(value="/GetDataList.do", method=RequestMethod.POST )
public class GetDataListController {

	/**
	 * GET DATA LIST TYPE 서비스
	 */
	@Inject
	@Named("GetDataListService")
	private GetDataListService getDataListService;
	
	
	@Inject
	@Named("AuthTableService")
	private AuthTableService authTableService;

	@RequestMapping
	public ModelAndView getDataList(
			HttpSession session, HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		paramMap.put("ssnLocaleCd", session.getAttribute("ssnLocaleCd"));
		
		// xss 따옴표 변환 2023-11-08
		if(paramMap.containsKey("columnInfo")) {
			paramMap.put("columnInfo", XssPreventer.unescape(paramMap.get("columnInfo").toString()));
		}
		
		Map<?, ?> query = authTableService.getAuthQueryMap(paramMap);
		if(query != null) {
			Log.Debug("query.get=> "+ query.get("query"));
			paramMap.put("query", query.get("query"));
		}
		
		List<?> list = new ArrayList<Object>();
		String Message = "";

		try{
			list = getDataListService.getDataList(paramMap);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("DATA", list);
		mv.addObject("Message", Message);

		Log.DebugEnd();
		return mv;
	}
	
}