package com.hr.common.editor;

import com.hr.common.logger.Log;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

/**
 * 공통 에디터 관리
 *
 */
@Controller
@RequestMapping(value="/Editor.do", method=RequestMethod.POST )
public class EditorController {

	/**
	 * CkEditor iframe
	 *
	 * @param paramMap
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewCkEditor", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewCkEditor( HttpSession session,  HttpServletRequest request, @RequestParam Map<String, Object> paramMap ) throws Exception {
		Log.DebugStart();
		Log.Debug("viewCkEditor =====");
		return "common/editor/ckEditor";
	}

}