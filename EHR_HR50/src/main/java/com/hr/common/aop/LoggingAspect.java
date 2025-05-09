package com.hr.common.aop;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.junit.Assume;
import org.springframework.beans.factory.annotation.Autowired;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.common.logger.Log;
import com.hr.common.util.SessionUtil;
import com.hr.common.util.StringUtil;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import javax.servlet.http.HttpServletRequest;

@Aspect
public class LoggingAspect {

	@Autowired
	private LoggingDao loggingDao;

	@Autowired
	private HttpServletRequest request;

	@Autowired
	private RequestMappingHandlerMapping handlerMapping;

//	@Autowired
//	private QueryService queryService;

	@Before("execution(* com.hr.common.dao.Dao.*(..))")
	public void Before(JoinPoint joinPoint)  {
		Log.Debug("Before aspect");
		/*
		try{
			if( SessionUtil.getRequestAttribute("ssnEnterCd") == null ) return;
		}catch(Exception e){
			return; // 세션이 널일 경우 //
		}

		String enterCd = (String) SessionUtil.getRequestAttribute("ssnEnterCd");
		String controllerName = (String)SessionUtil.getRequestAttribute("logController");
		String methodName = joinPoint.getSignature().getName();

		if(enterCd == null){//로그인 없이
			return;
		}

		if(controllerName == null){//로그인 없이
			return;
		}

		if(controllerName.equals( "CommonCodeController")
		|| controllerName.equals( "SampleController") // Sample
		|| controllerName.equals( "ImageUploadController") // iamge
		|| controllerName.equals( "ImageUploadTorg903Controller") // iamge
		|| controllerName.equals( "SecurityMgrController") // iamge
		){
			return;
		}

		//판단 매개 변수
		if(joinPoint.getArgs() == null){//인자가 없습니다.
			return;
		}

		if(!(methodName.equals("getList") || methodName.equals("getMap"))){
			return;
		}
		/*

		Class<? extends Object> clazz = joinPoint.getTarget().getClass();
		String methodNameTest = joinPoint.getSignature().getName();
		Object[] arguments = joinPoint.getArgs();


		StringBuilder argBuf = new StringBuilder();
		StringBuilder argValueBuf = new StringBuilder();
		int is = 0;
		for (Object argument : arguments) {
			String argClassName = argument.getClass().getSimpleName();
			if (is > 0) {
				argBuf.append(", ");
			}
			argBuf.append(argClassName + " arg" + ++is);
			argValueBuf.append(".arg" + is + " : " + argument.toString() + "\n");
		}

		if (is == 0) {
			argValueBuf.append("No arguments\n");
		}

		StringBuilder messageBuf = new StringBuilder();
		messageBuf.append("before executing {} ({}) method");
		messageBuf.append("\n-------------------------------------------------------------------------------\n");
		messageBuf.append(" {} -------------------------------------------------------------------------------");

		Logger logger = LoggerFactory.getLogger(clazz);
		logger.debug(
				messageBuf.toString(),
				new Object[]{methodName, argBuf.toString(), argValueBuf.toString()});


		Debug.log(joinPoint.getArgs() + " 으로 " + joinPoint.getSignature().getName() + "()메서드 시작");

		Signature signature = joinPoint.getSignature();
		Object target = joinPoint.getTarget();
		Object[] argsl = joinPoint.getArgs();

		Debug.log("Signature : " + signature.toString());
		Debug.log("target : " + target.toString());
		Debug.log("name : " + signature.getName());
		Debug.log("longName : " + signature.toLongString());
		Debug.log("shortName : " + signature.toShortString());

		for(int i=0; i < argsl.length; i++){
			Debug.log("args[" + i + "] : " + argsl[i].toString());
		}

		Object[] args = joinPoint.getArgs();
		Map paramMap = (Map)args[1];
		String queryId = (String)args[0];
		String methodNm = joinPoint.getSignature().getName();


		String ssnChkList = "ssnEnterCd,ssnSabun,ssnGrpCd,ssnMenuId,ssnSearchType,sabun,searchSabun";
		String tempChk[] = ssnChkList.split(",");

		HashMap<String, Object> logParam = new HashMap<String, Object>();
		for(int i = 0; i < tempChk.length; i++) {
			logParam.put(tempChk[i], (String)paramMap.get(tempChk[i]));
		}

		logParam.remove("ssnEnterCd");  logParam.put("ssnEnterCd", enterCd);
		logParam.remove("ssnSabun");    logParam.put("ssnSabun"	 ,SessionUtil.getRequestAttribute("ssnSabun"));
		logParam.remove("ssnGrpCd");    logParam.put("ssnGrpCd"	 ,SessionUtil.getRequestAttribute("ssnGrpCd"));
		logParam.put("ssnMenuId"	, SessionUtil.getRequestAttribute("ssnMenuId"));
		logParam.put("ssnSearchType", SessionUtil.getRequestAttribute("ssnSearchType"));
		logParam.put("logIp", 			SessionUtil.getRequestAttribute("logIp") );

		try {
			logParam.put("logRequestUrl", 		URLDecoder.decode(String.valueOf(SessionUtil.getRequestAttribute("logRequestUrl")),"UTF-8") );
			//logParam.put("logRequestBaseUrl", 	URLDecoder.decode(String.valueOf(SessionUtil.getRequestAttribute("logRequestBaseUrl")),"UTF-8") );
			logParam.put("logReferer", 			URLDecoder.decode(String.valueOf(SessionUtil.getRequestAttribute("logReferer")),"UTF-8") );
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		logParam.put("logQueryId", 		queryId );
		logParam.put("logController", 	controllerName );
		logParam.put("logJob", 			methodNm );
		logParam.put("logParameter", 	logParam.toString() );



		//ToDo
		String authK = "0";
		boolean blnRet = true;

		try {
			Map<?, ?> ynAuth = (Map<?, ?>) loggingDao.execute("getAuthCheckMap",logParam );
			authK =  ((Map) ((List<?>)ynAuth.get("#result-set-1")).get(0)).get("cnt").toString();

			if (!authK.equals("1")){ //Is true == 1 and false == 0
				blnRet = false;
				Log.Debug("잘못된 조회 입니다." + logParam.toString() + "=>>"+ authK );
				//hrow new Exception("잘못된 조회 입니다.");
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			Log.Error(e.getMessage());
			//Log.Debug(e.getLocalizedMessage());
		}
		Log.Debug("동작그만...1 이면 통과함 ..");

		Assume.assumeTrue(blnRet);
*/
		Assume.assumeTrue(true);
	}

	// 사후충고(반드시 정상 리턴 후 호출)
// SpringBoardDAO의 모든메소드중 파라미터가 1개 있는 메소드가 충고받을 포인트컷
// 본 게시판에는 리스트보기와 , getSql() 만 메소드 파라미터가 없어 충고 적용 안됨
	@After("execution(* com.hr.common.dao.Dao.*(..))")
	public void logAfterReturning(JoinPoint joinPoint) throws Exception {

		Log.Debug("aop start");

		try{
			Log.Debug("After aspect1=ssnEnterCd IS "+ SessionUtil.getRequestAttribute("ssnEnterCd") );
			if( SessionUtil.getRequestAttribute("ssnEnterCd") == null ) return;
		}catch(Exception e){
			Log.Debug("After aspect1=ssnEnterCd IS Exception" );
			return; // 세션이 널일 경우 //
		}

		String enterCd = (String) SessionUtil.getRequestAttribute("ssnEnterCd");
		String logRequestBaseUrl = StringUtil.getRelativeUrl(request).trim();
		Optional<RequestMappingInfo> optional = handlerMapping.getHandlerMethods().keySet().stream().filter(v -> v.getMatchingCondition(request) != null).findAny();
		String controllerName = "";
		if (optional.isPresent()) {
			controllerName = handlerMapping.getHandlerMethods().get(optional.get()).getBeanType().getSimpleName();
		}
		String logRefererBaseUrl = request.getHeader("referer");


		Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");
		Log.Debug("logRequestUrl■■■■■> "+ logRequestBaseUrl);
		Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");


		if(enterCd == null){//로그인 없이
			Log.Debug("After aspect1=enterCd IS ISNULL" );
			return;
		}

		if(controllerName == null){//로그인 없이
			Log.Debug("After aspect1=controllerName IS ISNULL" );
			return;
		}

		if(logRequestBaseUrl == null){//페이지 정보 없으면
			Log.Debug("After aspect1=logRequestBaseUrl IS ISNULL" );
			return;
		}


		if(controllerName.equals( "CommonCodeController")
				//|| controllerName.equals( "SampleController") // Sample
				//|| controllerName.equals( "ImageUploadController") // iamge
				//|| controllerName.equals( "ImageUploadTorg903Controller") // iamge
				|| controllerName.equals( "LoginController") // login
				|| controllerName.equals( "SecurityMgrController") // iamge
				|| controllerName.equals( "LicenseController") // license
		){
			Log.Debug("After aspect1=logRequestBaseUrl IS equals"+ controllerName );
			return;
		}

		//판단 매개 변수
		if(joinPoint.getArgs() == null){//인자가 없습니다.
			Log.Debug("After aspect1=joinPoint IS NULL");
			return;
		}

		String methodNm = joinPoint.getSignature().getName();

		Object[] args = joinPoint.getArgs();
		String queryId = (String)args[0];
		Object paramMap = args[1];

		//Log.Debug("paramMap.toString()="+paramMap.toString());

		if(paramMap instanceof Map) {
			Log.Debug("paramMap instanceof Map");
			((Map)paramMap).remove("localeCd1");
			((Map)paramMap).remove("localeCd2");
			((Map)paramMap).remove("s_SAVENAME");
		}



		long start = System.currentTimeMillis();
		//내용 가져오는 조작

		Map<String, Object> logParam = new HashMap<String, Object>();
		logParam.put("logEnterCd",		SessionUtil.getRequestAttribute("ssnEnterCd") );
		logParam.put("logJob", 			methodNm );
		logParam.put("logIp", 			SessionUtil.getRequestAttribute("logIp") );
		logParam.put("logRequestUrl", 	SessionUtil.getRequestAttribute("logRequestUrl") );
		logParam.put("logRequestBaseUrl", 	logRequestBaseUrl );
		//logParam.put("logController", 	SessionUtil.getRequestAttribute("logController") );

		logParam.put("logController", 	controllerName );
		logParam.put("logParameter", 	paramMap.toString() );
		logParam.put("logQueryId", 		queryId );
		logParam.put("logGrpCd", 		SessionUtil.getRequestAttribute("ssnGrpCd") );
		logParam.put("logSabun", 		SessionUtil.getRequestAttribute("ssnSabun") );


		//관리자가 사용자변경 후 작업 시 메모에 남김.
		String adminSabun = (String)SessionUtil.getRequestAttribute("ssnAdminSabun");
		String ssnSabun = (String)SessionUtil.getRequestAttribute("ssnSabun");
		if( adminSabun != null && !adminSabun.equals(ssnSabun) ){
			logParam.put("logMemo", "Admin Sabun : "+adminSabun );
		}else{
			logParam.put("logMemo", "");
		}

		try {

			String str = (String)logParam.get("logRequestBaseUrl");

			//step2
			if( queryId != null && ( queryId.equals("getAuthQueryMap")||
					queryId.equals("getDecryptUrl")||
					queryId.equals("getColumInfo"))){
				return;
			}
/*
			Map mm = (Map)paramMap;
			//if(StringUtil.stringValueOf( (String) ObjToMap(paramMap).get("s_THISPG") ).equals("")){
			if(StringUtil.stringValueOf( mm.get("s_THISPG") ).equals("")){

				Log.Debug("aop log retrun ■■■■■  s_THISPG is null retrun ");
				return;

			}
*/
			String cutLogRefererBaseUrl = logRefererBaseUrl != null ? logRefererBaseUrl.substring(logRefererBaseUrl.lastIndexOf("/")):null;

			Log.Debug("cutLogRefererBaseUrl■■■■■ "+ cutLogRefererBaseUrl);

			if( StringUtil.stringValueOf((String )logParam.get("logRequestBaseUrl")).equals("") ){
				Log.Debug("aop log retrun ■■■■■  logRequestBaseUrl is null retrun ");
				return;
			}

			//Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");
			//Log.Debug("logRequestUrl■■■■■ "+ logRequestBaseUrl);
			//Log.Debug("■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■");

			String queryString = "";

			if(!controllerName.equals( "LoginController")) {
				queryString = loggingDao.getQueryString(queryId, paramMap);
			}
			
			Map<?, ?> logMgrMap = loggingDao.getMap("getLogMgrY", logParam); 
			String logYn = logMgrMap != null && logMgrMap.get("cnt") != null ? logMgrMap.get("cnt").toString():"0"; 

			if(controllerName.equals( "LoginController"))
				logYn = "1";

			if(!logYn.equals("0")){
				ObjectMapper mapper = new ObjectMapper();
				Map<?, ?> logMgrSeqMap = loggingDao.getMap("getLogMgrSeqMap",logParam);
				String logSeq =  logMgrSeqMap != null && logMgrSeqMap.get("seq") != null ? logMgrSeqMap.get("seq").toString():""; 
				logParam.put("logSeq", logSeq);
				//실행 쿼리
				if(queryId != null && queryId.equals("getDecryptUrl")) {
					logParam.put("logQueryString","");
				} else {
					logParam.put("logQueryString",queryString);
				}
				//IPv4방식
				//logParam.put("logIp", 			Inet4Address.getLocalHost().getHostAddress() );
				logParam.put("logIp", 			SessionUtil.getRequestAttribute("logIp") );
				//prarameter Json String 으로 저장
				logParam.put("logParameter", 	mapper.writeValueAsString(paramMap) );
				logParam.put("logRefererUrl", cutLogRefererBaseUrl);
				loggingDao.execute("insertLogMgr", logParam);
				loggingDao.execute("updateLogMgr", logParam);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			Log.Debug(e.getLocalizedMessage());
		}


		Log.Debug("aop end");
	}

	@SuppressWarnings({ "unchecked", "rawtypes", "finally" })
	public Map ObjToMap(Object obj) {

		Map resultMap = new HashMap();

		try {

			Field[] fields = obj.getClass().getDeclaredFields();
			for ( int i=0; i <=fields.length -1 ; i++ ) {
				fields[i].setAccessible(true);
				resultMap.put(fields[i].getName(), fields[i].get(obj));
			}

		}catch( IllegalArgumentException e ) {
			Log.Debug(e.getLocalizedMessage());
			resultMap = null;
		}catch (IllegalAccessException e) {
			Log.Debug(e.getLocalizedMessage());
			resultMap = null;
		}finally {
			return resultMap;
		}
	}

	private String ObjToString(Object p) {

		String str = "";

		if (p == null) {
			str = "";
		} else {
			str = p.toString();
		}

		return str;
	}


}