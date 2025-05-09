package com.hr.sys.system.requirement.reqDefinitionPopResult;

import com.hr.common.logger.Log;
import com.hr.common.util.ParamUtils;
import com.hr.sys.system.requirement.reqDefinitionMgr.ReqDefinitionMgrService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.inject.Named;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 테스트관리 Controller
 *
 * @author EW
 * 
 */
@Controller
@RequestMapping(value="/ReqDefinitionPopResult.do", method=RequestMethod.POST )
public class ReqDefinitionPopResultController {

	/**
	 * 테스트관리 View
	 *
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewReqDefinitionPopResult", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewReqDefinitionPopResult() throws Exception {
		return "sys/system/requirement/reqDefinitionPopResult/reqDefinitionPopResult";
	}
}

