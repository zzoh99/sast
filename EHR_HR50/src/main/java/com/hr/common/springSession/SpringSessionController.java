package com.hr.common.springSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value="/SpringSession.do", method= RequestMethod.POST )
public class SpringSessionController {

	@Autowired
	private SpringSessionService springSessionService;
}
