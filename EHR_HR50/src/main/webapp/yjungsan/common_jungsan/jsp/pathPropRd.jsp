<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ page import="yjungsan.util.DateUtil"%>
<%-- -------------------------------------------------------------------------------------------------------
      1. session.jsp에서는 pathPropRd.jsp를 사용합니다.
      2. rdPopupIframe.jsp에서는 다음과 같이 사용합니다.
           IE브라우저로 activeX(OCX) 버전 RD를 사용하는 고객사는 각 사이트에서 자체 보유한 pathPropRd.jsp를 사용해야 합니다.
           그 밖의 HTML 버전 RD를 사용하는 고객사는 각 사이트에서 자체 보유한 pathPropRd_44.jsp를 사용해야 합니다.
------------------------------------------------------------------------------------------------------------ --%>
<%
    //RD 버전(1 = ActiveX, 2=html)
    String rdVersion = StringUtil.getPropertiesValue("RD.VERSION");
    String rdAliasName = StringUtil.getPropertiesValue("RD.ALIAS.NAME"); //RD alias
    String rdUrl = StringUtil.getPropertiesValue("RD.URL"); //RD url

    String mrdUrl               = StringUtil.getPropertiesValue("mrd.url"); //mrd url
    String dataServerUrl        = StringUtil.getPropertiesValue("dataServer.url"); //dataServer url
    String reportingServerUrl   = StringUtil.getPropertiesValue("reportingServer.url"); //reportingServer url

    //RD 리포트 베이스 URL
    //String rdBaseUrl = StringUtil.getBaseUrl(request);
    String rdBaseUrl = mrdUrl;

    //RD 리포트 패스정보(ROOT 기준)
    //activex : /JSP/report/
    //html : /html/report/
    String rdBasePath = "/html/report/";

    // cloud hr 인경우 패스정보 변경.
    if("Y".equals(StringUtil.getPropertiesValue("CLOUD.HR.YN"))) {
    	rdBasePath = "/cloudhr/statics/task/mrd/";
    }

    //RD 리포트 멀티뷰어 URL(html 버전에서만 사용) => JAVA 버전에 필요
    //String rdMultiViewerUrl = rdBaseUrl+"/DataServer/multiViewer";
    //String rdJars = rdMultiViewerUrl+"/javard.jar,./lib/barbecue-1.5-beta1.jar,./lib/batik-all-flex.jar,./lib/ChartDirector_s.jar,./lib/enc.jar,./lib/iText-4.2.0-m2,./lib/jai_codec.jar,./lib/poi-3.2-FINAL-20081019.jar,./lib/plugin.jar,./lib/poi-scratchpad-3.2-FINAL-20081019.jar,./lib/swfutils.jar";

    //RD 리포트 에이전트 패스정보(ROOT 기준)
    //activex : /JSP/RDServer/rdagent.jsp
    //html : /DataServer/rdagent.jsp
    String rdAgentPath = "/DataServer/rdagent.jsp";

    //RD 스크립트 URL
    //activex : rdBaseUrl/JSP/include/IE_OCX/rd_inc.jsp?docId=rdViewer&width=100P&height=100P
    //html : rdBaseUrl/common/plugin/DataServer/rdViewer_all.js
    String rdScriptUrl = rdBaseUrl+"/common/plugin/DataServer/rdViewer_all.js";

    //RD에 들어갈 도장 이미지 URL
    //activex : 이노션(rdBaseUrl/HTML/image/) 그외(rdBaseUrl/HR_FILE/CORPORATION_IMAGE/HICAR/)
    //html : rdBaseUrl/ImageDownloadTorg903.do?logoCd=2  (참고사항: html버전일경우 mrd 도장 수정해야함)
    //String rdStempImgUrl = rdBaseUrl+"/ImageDownloadTorg903.do?logoCd=2";
    String enterCd = (String)session.getAttribute("ssnEnterCd");

    String rdStempImgUrl = rdBaseUrl+"/hrfile/"+enterCd+"/company/";
    //이노션용 스탬프 이미지 파일명(다른 사이트는 ""로 처리바람)
    String rdStempImgFile = "";
    
    //********************************************************************************************************************************
    //**********************************************추가할 내용 **************************************************************************
    //소득공제서 서명패드 이미지 URL (2023.01.02)
    String rdSignImgUrl = rdBaseUrl+"/hrfile/"+enterCd;
    //********************************************************************************************************************************
    //********************************************************************************************************************************

    //연말정산 mrd 위치
    String cpnYearEndPath = "cpn/yearEnd";

    if("1".equals(StringUtil.getPropertiesValue("SYS.VERSION"))) {
        cpnYearEndPath = "cpn/year_end_ad_total";
    }
%>