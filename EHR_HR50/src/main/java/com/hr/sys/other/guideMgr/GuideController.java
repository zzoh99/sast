package com.hr.sys.other.guideMgr;
import javax.inject.Inject;
import javax.inject.Named;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
/**
 * 메뉴명 Controller 
 * 
 * @author 이름
 *
 */
@Controller
@RequestMapping(value="/Guide.do", method=RequestMethod.POST ) 
public class GuideController {
	/**
	 * 패캐지 가이드 
	 */
	@Inject
	@Named("GuideService")
	private GuideService guideService;

	/**
	 * Sample1
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSample1", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSample1() throws Exception {
		return "sys/other/guide/viewSample1";
	}
	/**
	 * Sample2
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSample2", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSample2() throws Exception {
		return "sys/other/guide/viewSample2";
	}

	/**
	 * Sample3
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSample3", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSample3() throws Exception {
		return "sys/other/guide/viewSample3";
	}

	/**
	 * Sample4
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSample4", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSample4() throws Exception {
		return "sys/other/guide/viewSample4";
	}

	
	/**
	 * Sample5
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSample5", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSample5() throws Exception {
		return "sys/other/guide/viewSample5";
	}
	
	/**
	 * Sample5 샘플 
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewSample5i", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewSample5i() throws Exception {
		return "sys/other/guide/viewSample5_iframe";
	}
		
	
}
