<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%@ include file="../../../common_jungsan/jsp/pathPropRd.jsp" %>

<!DOCTYPE html><html class="bodywrap" style="margin:0;height:100%"><head><base target="_self"><title>e-HR</title>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->

<%
String baseRdPath       = "/html/report/" ;

//local 일때는 서버의  mrd 파일을 읽어들임
String tmpIpChk = request.getRemoteAddr();
if (tmpIpChk.equals("127.0.0.1") || tmpIpChk.equals("0:0:0:0:0:0:0:1")) {
    rdBaseUrl =rdUrl;
}

%>


<script src="<%=rdUrl%>/ReportingServer/html5/js/jquery-1.11.0.min.js"></script>
<script src="<%=rdUrl%>/ReportingServer/html5/js/crownix-viewer.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=rdUrl%>/ReportingServer/html5/css/crownix-viewer.min.css">
</head>
<body style="margin:0;height:100%">
<div id="crownix-viewer" style="position:absolute;width:100%;height:100%"></div>
<script>

window.onload = function(){

//
var rdUrl   = "<%=rdUrl%>";
var rsn     = "<%=rdAliasName%>";
var rdBasePath = "<%=rdBasePath%>";
var rdAgent = "/DataServer/rdagent.jsp" ;


var mrd     = "";
var param   = "/rfn ["+rdUrl+rdAgent+"] /rsn ["+rsn+"] /rreportopt [256] ";
        param  = param +"/" + $("#ParamGubun", parent.document).val() + " ";//rp또는 rv로 넘어온다.
        reportFileNm =  "<%=mrdUrl%>" + rdBasePath+"/"+$("#Mrd", parent.document).val();//루트를 제외한 RD경로 및 파일명 매칭


        param       = param + $("#Param", parent.document).val(); //파라매터 넘김
        mrd         = reportFileNm;



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

        var viewer = new m2soft.crownix.Viewer(rdUrl+ '/ReportingServer/service', 'crownix-viewer');
        viewer.openFile(mrd, param);
};
</script>
</body>
</HTML>
