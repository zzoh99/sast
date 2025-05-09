<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ include file="../../../common_jungsan/jsp/pathPropRd.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head><base target="_self"><title>e-HR</title>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->

<script src="/common/plugin/ReportingServer/html5/js/jquery-1.11.0.min.js"></script>
<script src="/common/plugin/ReportingServer/html5/js/crownix-viewer.min.js"></script>
<link rel="stylesheet" type="text/css" href="/common/plugin/ReportingServer/html5/css/crownix-viewer.min.css">
</head>

<body style="margin:0;height:100%">
<div id="crownix-viewer" style="position:absolute;width:100%;height:100%"></div>

<script>

m2soft.crownix.Layout.setTheme('White');

window.onload = function() {
    
	if (!checkParam()) return;
    
	var rdUrl      = "${baseURL}";
    var baseRdPath = "/html/report/";
	var rdAgent    = "/DataServer/rdagent.jsp";
    var rdService  = "/ReportingServer/service";
    
    rdService = rdUrl + rdService;
    
    setRdSessionInfo();
    
    var	param  = "/rfn [" + rdUrl + rdAgent + "] /rsn [pth] ";
    	param  = param + "/" + $("#ParamGubun", parent.document).val() + " "; //rp또는 rv로 넘어온다.
        param  = param + $("#Param", parent.document).val();
        
    /* 파라미터 변조 체크를 위한 securityKey 를 파라미터로 전송 함 */
	var securityKey = $("#SecurityKey", parent.document).val();
	    
	//인사 쪽 보안 배포가 안된 경우 제증명 화면에서 원천징수영수증, 원천징수부 호출 시 오류 때문에 /rv, /rp 모두 securityKey 파라미터로 전송.
	if ( $("#ParamGubun", parent.document).val()=="rp" ) {
		if ( param.indexOf("/rv") > -1 ) {
	    	param = param.replace("/rv", " ["+securityKey+"] /rv securityKey["+securityKey+"] ");
	    } else {
	    	param += " ["+securityKey+"] /rv securityKey["+securityKey+"] ";
	    }
	} else {
		param += " securityKey["+securityKey+"] /rp ["+securityKey+"] ";
	}

	var mrd = rdUrl + baseRdPath + $("#Mrd", parent.document).val(); //루트를 제외한 RD경로 및 파일명 매칭
	
    var viewer = new m2soft.crownix.Viewer(rdService, 'crownix-viewer');

    viewer.openFile(mrd, param, {defaultZoom: 1.0, exportMethod : 'get'});
};

function checkParam() {
    
	if( !( $("#ParamGubun", parent.document).val() == "rp" || $("#ParamGubun", parent.document).val() == "rv" || $("#ParamGubun", parent.document).val() == "" ) ) {
		alert("개발오류입니다.\n파라매터 중 rdParamGubun값은 rp또는rv이어야 합니다.") ;
		return false;
	} else if( $("#ParamGubun", parent.document).val() == "" ) { $("#ParamGubun", parent.document).val("rp") ; }//값이 넘어오지 않으면 기본 rp

	return true;
}

function setRdSessionInfo() {
	
    var sessionParam = "" ;
	$("#ParamGubun", parent.document).val() == "rv" ? sessionParam = " NgmSsoName[JSESSIONID] NgmSsoData["+"<%=(String)session.getId()%>"+"]" : sessionParam = " /rv NgmSsoName[JSESSIONID] NgmSsoData["+"<%=(String)session.getId()%>"+"]" ;
	$("#Param", parent.document).val( $("#Param", parent.document).val() + sessionParam ) ;
}

</script>

</body>
</HTML>
