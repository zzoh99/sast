package com.hr.api.m.tra.lectureRst;

import com.hr.common.logger.Log;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 사내강사료신청 Controller 
 * 
 * @author 이름
 *
 */
@RestController
@RequestMapping(value="/api/v5/lectureRst")
public class ApiLectureRstController {

	@Inject
	@Named("ApiLectureRstService")
	private ApiLectureRstService apiLectureRstService;

	/**
	 * 사내강사료신청 단건 조회
	 * 
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/getLectureRstAppDetMoMap")
	public Map<String, Object> getLectureRstAppDetMoMap(
			HttpSession session,  HttpServletRequest request, 
			@RequestBody Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();

		List<?> list = null;
		String Message = "";

		Log.Debug(paramMap.toString());
		try{
			list = apiLectureRstService.getLectureRstAppDetMoMap(paramMap, session);
		}catch(Exception e){
			Message="조회에 실패하였습니다.";
		}

		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("Message", Message);

		return result;
	}

}
