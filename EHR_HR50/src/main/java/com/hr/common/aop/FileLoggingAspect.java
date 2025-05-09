package com.hr.common.aop;

import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.util.StringUtil;

@Aspect
public class FileLoggingAspect {
	
	public static final Logger logger = LogManager.getLogger(FileLoggingAspect.class); 
	
	/*
	 *  Dao method 실행 후   
	 * */
	@After("execution(* com.hr.common.dao.Dao.*(..))")
	public void executeDaoAfter(JoinPoint joinPoint) throws Throwable {
		String methodNm = joinPoint.getSignature().getName();
		
		List<String> logMethod = Arrays.asList("getMap","getList","delete","update","excute");
		
		if(logMethod.contains(methodNm)){
			Object[] args = joinPoint.getArgs();
			String queryId = (String)args[0];
			Object paramMap = args[1];

			logger.debug("\n======================================== dao log ========================================\n queryId:{}\n parameter:{}",queryId,paramMap.toString());
		}
	}
	
	/**
	 * login 실행 후
	 */
	@After("execution(* com.hr.sys.other.logMgr.LogMgrService.insertLog(..))")
	public void loginAfter(JoinPoint joinPoint) throws Throwable {
		Object[] args = joinPoint.getArgs();
		String queryId = (String)args[0];
		Object paramMap = args[1];

		logger.debug("\n======================================== login log ========================================\n queryId:{}\n parameter:{}",queryId,paramMap.toString());
	}
	
	/*
	 * View 실행 후
	 * */
	@After("execution(* com.hr.common.interceptor.Interceptor.postHandle(..))")
	public void callView(JoinPoint joinPoint)throws Throwable {
		Object[] args = joinPoint.getArgs();
		
		if(args.length > 3 && args[0] instanceof HttpServletRequest && args[3] instanceof ModelAndView){
			ModelAndView mav = (ModelAndView)args[3];
			if("jsonView".equals(mav.getViewName()))return;
			
			HttpServletRequest request = (HttpServletRequest)args[0];
			HttpSession session = request.getSession();
			
			String ssnSabun = String.valueOf(session.getAttribute("ssnSabun"));
			
			String reqUrl = StringUtil.getBaseUrl(request)+StringUtil.getRelativeUrl(request);
			logger.debug("\n============================== view log =================================\n request sabun:{},clientIp:{},url:{} \n response view:{}",ssnSabun,StringUtil.getClientIP(request),reqUrl,mav.getViewName());
		}
	}
}
