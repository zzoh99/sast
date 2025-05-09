package com.hr.common.util.mail;

import com.hr.common.logger.Log;
import com.hr.common.util.StringUtil;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Iterator;


public class MailUtil {

	private final int MAIL_FORM_CNT = 2;		//메일의 개수

	private String [] MAIL_FORM_HEADER = null;	//메일 form header
	private String [] MAIL_FORM_FOOTER = null;	//메일 form footer

	private HashMap MAIL_MAPPING_MAP = null;		//메일 맵핑정보

	private HashMap MAIL_FORM_MAP = null;		//메일 form의 map

	public MailUtil(HttpServletRequest request){
		this.MAIL_FORM_HEADER = initMakeFormHeader();
		this.MAIL_FORM_FOOTER = initMakeFormFooter();

		this.MAIL_FORM_MAP = new HashMap();
		//this.MAIL_FORM_MAP.put("00", 0);		//인턴쉽 학격자 발표
		//this.MAIL_FORM_MAP.put("01", 1);		//신입사원 합격자 발표

		this.MAIL_MAPPING_MAP = new HashMap();
		//this.MAIL_MAPPING_MAP.put("|EMS_M_NAME|", "<IMG alt=${EMS_M_NAME} src='http://ems.wooriwm.com/img/kor/ems_send_but13.gif'>");
		//this.MAIL_MAPPING_MAP.put("|EMS_M_EMAIL|", "${EMS_M_EMAIL}");
		this.MAIL_MAPPING_MAP.put("\"/common/images/", "\"http://"+ request.getServerName() +"/common/images/");

	}

	/**
	 * GS SHOP EHR 이메일 양식에 따른 변경 작업
	 * 작업자: 강찬구
	 * 작업일시: 2012- 10 -25
	 * 작업내용: 메일 HEARDER 문구 변경
	 */
	public String[] initMakeFormHeader(){
		String [] headStr = new String[1];
		StringBuffer str = new StringBuffer();

		str.append("<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'> 	");
		str.append("<html xmlns='http://www.w3.org/1999/xhtml'>                          ");
		str.append("<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><title>이수시스템(주) e-HR</title> ");

		str.append("<style type='text/css'><!--body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0px;font-family: '돋움' 'dotum'}");
		str.append("table { border-spacing:0px; border:0; border-collapse:collapse; margin:0px; padding:0px;}");
		str.append("th, td { margin:0px; padding:0px; word-break:break-all; font-size:12px; color: #5a5b5c;  line-height:17px; }");
		str.append("a:link, a:visited, a:active {text-decoration:none;color:#8b8d8e;} ");
		str.append("a:hover {text-decoration:underline;color:#00b5ad;}");
		str.append("a,img,input,button{outline: none;selector-dummy:expression(this.hideFocus=true);}");
		str.append("div{text-align:left}--></style></head>");

		str.append("<body><table width='100%'><tr><td style='text-align:center;'><table width='650'><tr><td width='590' valign='top'> ");
		//str.append("<div style='height:30px'></div><div style='text-align:right'><img src='http://ehr.pantech.co.kr/common/images/common/logo_PTCH.gif /></div><div style='border-bottom:5px solid #bed730;margin-top:15px;'></div>");
		str.append("<div style='margin-top:15px;'></div><div style='height:33px'></div>");

		headStr[0] = str.toString();

		return headStr;
	}

	/**
	 * GS SHOP EHR 이메일 양식에 따른 변경 작업
	 * 작업자: 강찬구
	 * 작업일시: 2012- 10 -25
	 * 작업내용: 메일 BODY 문구 변경
	 */
	public String[] initMakeFormFooter(){
		String [] footerStr = new String[1];
		StringBuffer str = new StringBuffer();

		//1.신입사원 합격자 발표
		str.setLength(0);
		str.append("<div style='color:#2c2a1a;font-weight:bold;margin:15px 0 7px 0;padding-left:7px;'></div>");
		str.append("<table style='width:100%'><colgroup><col width='*' /><col width='30%' /><col width='30%' /><col width='30%' /></colgroup>");

		str.append("<div style='color:#5a5b5c;margin:30px 0 7px 0;align:left;'><strong>담당자 :</strong> 인사팀</div>");
		str.append("<div style='color:#5a5b5c;margin:20px 0 7px 0;align:left;'><strong>인사시스템 바로가기 :</strong> <a href='http://ehr.pantech.co.kr' target=_blank rel=nofollow>http://ehr.pantech.co.kr</a></div>");
		str.append("<div style='color:#8b8d8e;font-size:11px;margin:50px 0 7px 0;text-align:center'>본 메일은 발신 전용으로 회신되지 않습니다.</div>");
		str.append("<div style='border-bottom:3px solid #bed730;margin-top:20px;'></div>");
		str.append("<div style='color:#8b8d8e;font-size:11px;margin:20px 0 7px 0; align:left;'>");
		str.append("	주식회사 팬택.<br />");
		str.append("서울시 마포구 상암동 DMC, I-2 팬택계열 R&D 센터 .<br />");
		str.append("COPYRIGHT (C) PANTECH Co., Ltd.. All RIGHTS RESERVED.");
		str.append("</div></td></tr></table></td></tr></table></body></html>");
		footerStr[0] = str.toString();
		return footerStr;
	}

	/**
	 * 메일 본문 셋팅
	 * @param type
	 * @param content
	 * @return
	 */
	public String getMailContent(String type, String content){
		Log.Debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++getMailContent");
		String str = "";	//본문

		//int mailFormType = (Integer) this.MAIL_FORM_MAP.get(type);	//메일 타입
		//str += this.MAIL_FORM_HEADER[mailFormType];
		/**
		 * 맵핑정보 셋팅
		 */
		Iterator it = this.MAIL_MAPPING_MAP.keySet().iterator();
		while(it.hasNext()){
			String key = (String) it.next();
			//import org.anyframe.util.StringUtil; 하면 content 값이 없어짐
			//content = StringUtil.replace(content, key, (String) this.MAIL_MAPPING_MAP.get(key));

			content = StringUtil.stringReplace(content, key, (String) this.MAIL_MAPPING_MAP.get(key));
		}
		str = content;
		//str += this.MAIL_FORM_FOOTER[mailFormType];
		return str;
	}
}
