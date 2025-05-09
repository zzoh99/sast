package com.hr.common.scheduler;

import java.io.InputStream;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.hr.common.logger.Log;
import com.hr.common.util.DateUtil;
import com.hr.common.util.mail.SmtpMailUtil;

@Controller
@RequestMapping(value="/Schedule.do", method=RequestMethod.POST )
public class ScheduleController {
	
	@Inject
	public ScheduleService scheduleService;

	@Value("${mail.server}") private String mailServer;
	@Value("${mail.user}") 	 private String mailUser;
	@Value("${mail.passwd}") private String mailPasswd;
	@Value("${mail.tester}") private String mailTester;
	
	@SuppressWarnings("unchecked")
	public void smtpScheduler() throws Exception {  //[벽산]사용안함  
		try {
			Map<?, ?> paramMap = new HashMap<String, Object>();
			List<?>  sendList = scheduleService.getSendDataList(paramMap);
			
			Iterator<?> it = sendList.iterator();
			
			while(it != null && it.hasNext()) {
				Map<String, Object> sendMap = (Map<String, Object>) it.next();
				String enterCd = String.valueOf(sendMap.get("enterCd"));
				String seq = String.valueOf(sendMap.get("seq"));
				String rcvName = String.valueOf(sendMap.get("rcvName"));
				String mailTitle = String.valueOf(sendMap.get("title"));
				String mailTo = String.valueOf(sendMap.get("sendAddr"));
				String content = String.valueOf(sendMap.get("contents"));
				
				String[] tmp = rcvName.split(";");
				String formName = rcvName;
				String mailForm = rcvName;
				
				if(tmp.length == 2) {
					formName = tmp[1];
					mailForm = tmp[0];
				}
				
				sendMessage(enterCd, seq, formName, mailForm, mailTitle, mailTo, content);
			}
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
			throw e;
		}
	}
	 //[벽산]사용안함  
	public int sendMessage(String enterCd, String seq, String formName, String mailForm, String mailTitle, String mailTo, String content) throws Exception {
		
		Log.Debug("enterCd : " + enterCd);
		Log.Debug("seq : " + seq);
		Log.Debug("formName : " + formName);
		Log.Debug("mailTitle" + mailTitle);
		Log.Debug("mailTo : " + mailTo);
		Log.Debug("content : " + content);
		
		String result = "N";
		SmtpMailUtil mUtil = new SmtpMailUtil(mailServer, mailUser, mailPasswd, mailForm);
		try {
			result = mUtil.sendEmail(formName, mailTitle, mailTo, content, null, mailTester);
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
		}
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("enterCd", enterCd);
		paramMap.put("seq", seq);
		paramMap.put("result", result);
		
		Log.Debug("enterCd : " + enterCd + ", seq : " + seq + " >> " + paramMap.toString());
		
		return scheduleService.updateSMTP(paramMap);
	}
	
//	@Scheduled(cron="50 50 23 31 12 *")// ex : 매년 12월 31일 23시 50분 50초[초 분 시 일 월 주]
//	@Scheduled(cron="0 0 1 * * ? ")// 운영 : 매일 1시 [초 분 시 일 월 주]
//	@Scheduled(cron="0 0/5 * * * ?")// 5분마다 실행
	public void getSecomDataBatch() throws Exception {
		Log.DebugStart();
		
		//서버IP 가져오기
		InetAddress local;
		try {
			local = InetAddress.getLocalHost();
			String serverIp = local.getHostAddress();
			Log.Debug("\r\n ===> Server IP : "+serverIp);
			
			//스케쥴 실행할 서버 IP 가져오기
			InputStream is = getClass().getResourceAsStream("/opti.properties");
			Properties props = new Properties();
			try {
				props.load(is);
				String ip1 = props.getProperty("schedule.ip1") != null ? props.getProperty("schedule.ip1").trim():"";
				String ip2 = props.getProperty("schedule.ip2") != null ? props.getProperty("schedule.ip2").trim():"";
				if(serverIp != null && !serverIp.equals(ip1) && !serverIp.equals(ip2)){ //개발, 운영서버 IP
					return; //실행 안함.
				}
				
			} catch (Exception ex) {
				Log.Error(ex.getLocalizedMessage());
				//ex.printStackTrace();
			}

		} catch (UnknownHostException e1) {
			Log.Error(e1.getLocalizedMessage());
			//e1.printStackTrace();
		}
		

		String curTime = DateUtil.getDateTime();
		
		Log.Debug("\r\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
		+"\r\n▒▒▒▒▒▒▒▒▒▒▒▒▒      Schedule   실행      [ "+curTime+" ] ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
		+"\r\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒");

		int resultCnt = 0;
		
		try{
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("ssnEnterCd", "BS"); //회사코드
			paramMap.put("ssnSabun",  "Schedule");
			
			Map<String, Object> map = scheduleService.getScheduleLastTime(paramMap);
			
			paramMap.put("searchYmd", DateUtil.getDate() ); //기준날짜
			paramMap.put("eTime", curTime ); //현재시간
			paramMap.put("sTime", map.get("lastTime") ); //마지막 업데이트 시간
			
			Map<String, Object> resultMap = scheduleService.getSecomData(paramMap);
			
			if ("0".equals(String.valueOf(resultMap.get("Code")) )) {
				scheduleService.saveScheduleLastTime(paramMap);
			}
			
			Log.Debug("result : "+resultCnt);
		}catch(Exception e){
			Log.Debug(e.getLocalizedMessage());
		}
		Log.DebugEnd();
	}

	/**
	 * 세콤 출퇴근시간 가져오기 - [TimeCard관리]에서 호출
	 * @param session
	 * @param request
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=getSecomData", method = RequestMethod.POST )
	public ModelAndView getSecomData(
			HttpSession session,  HttpServletRequest request,
			@RequestParam Map<String, Object> paramMap ) throws Exception {
		// comment 시작
		Log.DebugStart();
		paramMap.put("ssnSabun",  session.getAttribute("ssnSabun"));
		paramMap.put("ssnEnterCd",session.getAttribute("ssnEnterCd"));

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try{
		
			String enterCd = String.valueOf(session.getAttribute("ssnEnterCd"));

			//Todo 회사코드별 커스텀 영역
			if( enterCd.equals("BS")) { //벽산
				
				//기간
				String searchSdate = String.valueOf(paramMap.get("searchSdate"));
				String searchEdate = String.valueOf(paramMap.get("searchEdate"));

				DateFormat df = new SimpleDateFormat("yyyyMMdd");

				//Date타입으로 변경
				Date d1 = df.parse( searchSdate );
				Date d2 = df.parse( searchEdate );

				Calendar c1 = Calendar.getInstance();
				Calendar c2 = Calendar.getInstance();
				
				c1.setTime( d1 ); c2.setTime( d2 );

				while( c1.compareTo( c2 ) !=1 ){
					String searchYmd = DateUtil.getDateTime(c1, "yyyyMMdd");

					Log.Debug("\r\n ===> searchYmd : "+searchYmd);
					paramMap.put("searchYmd", searchYmd);
					resultMap = scheduleService.getSecomData(paramMap);
					
					//시작날짜 + 1 일
					c1.add(Calendar.DATE, 1);
				}
				
			}else {
				resultMap.put("Code", "");
				resultMap.put("Message", "");
			}
			
		}catch(Exception e){
			resultMap.put("Code", "-1");
			resultMap.put("Message", "처리 중 오류가 발생했습니다.("+e.getMessage()+")");
		}

		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		mv.addObject("Result", resultMap);
		Log.DebugEnd();
		return mv;
	}
}
