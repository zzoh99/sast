<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>

<spring:eval var="rdUrl" expression="@environment.getProperty('rd.url')"/>
<spring:eval var="rdRsn" expression="@environment.getProperty('rd.servicename')"/>
<spring:eval var="rdMrd" expression="@environment.getProperty('rd.mrd')"/>
<c:if test="${hostIp=='127.0.0.1' || hostIp=='0:0:0:0:0:0:0:1'}">
<%
//local 일때는 서버의  mrd 파일을 읽어들임
%>

<spring:eval var="rdMrd" expression="@environment.getProperty('rd.mrd')"/>
</c:if>
<c:if test="${pageContext.request.scheme == 'https' }">
<c:set var="rdUrl" 			value='${rdUrl.replace("http:", "https:")}'/>
<c:set var="rdMrd" 			value='${rdMrd.replace("http:", "https:")}'/>
</c:if>
<!DOCTYPE html>
<html style="margin:0;height:100%">
<head><meta charset="utf-8">
<%
String baseRdPath 		= "/html/report/" ;
%>
<script src="${rdUrl}/ReportingServer/html5/js/jquery-1.11.0.min.js"></script>
<script src="${rdUrl}/ReportingServer/html5/js/crownix-viewer.min.js"></script>
<link rel="stylesheet" type="text/css" href="${rdUrl}/ReportingServer/html5/css/crownix-viewer.min.css">
<style type="text/css">
/* Nanum 나눔고딕으로 작성한경우에도 표시되도록 함.  */
 @font-face {
  font-family: 'Nanum Gothic';
  font-style: normal;
  font-weight: 300;
  src: url('/common/font/NanumGothic-Regular.eot');
  src: url('/common/font/NanumGothic-Regular.eot?#iefix') format('embedded-opentype'),
       url('/common/font/NanumGothic-Regular.woff2') format('woff2'),
       url('/common/font/NanumGothic-Regular.woff') format('woff'),
       url('/common/font/NanumGothic-Regular.ttf') format('truetype');
}
/* body { font-family:"Nanum Gothic", sans-serif !important; } */
/* body * { font-family:"Nanum Gothic", sans-serif !important; } */
</style>
</head>
<body style="margin:0;height:100%">
<div id="crownix-viewer" style="position:absolute;width:100%;height:100%"></div>
<script>
window.onload = function(){
	var rdUrl = "${rdUrl}" ;
	var rsn = "${rdRsn}" ;

	 var rdAgent = "/DataServer/rdagent.jsp" ;

	var	mrd    = "";
	var	param  = "/rfn ["+rdUrl+rdAgent+"] /rsn ["+rsn+"] /rreportopt [256] /rmmlopt [1] ";
		param  = param +"/" + $("#ParamGubun", parent.document).val() + " ";//rp또는 rv로 넘어온다.

		reportFileNm= "${rdMrd}<%=baseRdPath%>" + $("#Mrd", parent.document).val();//루트를 제외한 RD경로 및 파일명 매칭
		param		= param + $("#Param", parent.document).val(); //파라매터 넘김

		/* 파라미터 변조 체크를 위한 securityKey 를 파라미터로 전송 함 */
		if( $("#ParamGubun", parent.document).val() == "rp" ){
			param =  param + "[${securityKey}] /rv securityKey[${securityKey}]";
		}else{ //rv
			param =  param + " securityKey[${securityKey}]";
		}
        // alert(reportFileNm);
        // alert(rdUrl);
        // alert(param);
		mrd			= reportFileNm;

		//alert(mrd);
		//alert(param);

	var viewer = new m2soft.crownix.Viewer('${rdUrl}/ReportingServer/service', 'crownix-viewer');
    viewer.setParameterEncrypt(11);
    //viewer.openFile(mrd, param, {'defaultZoom': 1, 'defaultZoomCentre':'LEFTTOP'});

	//툴바 item hide 처리
	var hideItem = toolbarItem();
	for (var i = 0, len = hideItem.length; i < len; i++) {
		viewer.hideToolbarItem (["ratio",hideItem[i]]);
	}

    if('${rdParam.c}' === 'Y') {
        viewer.openFile('${rdParam.p}', '${rdParam.d}');
    } else {
	    viewer.openFile(mrd, param);
    }

};

window.onbeforeunload = function(e) {
	if( parent.returnResult != null ) {
		parent.returnResult() ;
	}
};

function toolbarItem() {
	// 툴바 hide
	var hideItem 	= new Array();
	var itemNum     = 0;

	var array=[
               {name:'SaveYn',		type:'save',		defaultShowYn:'Y'},	//기능컨트롤_저장
               {name:'PrintYn',		type:'print',		defaultShowYn:'Y'},	//기능컨트롤_인쇄
               {name:'PrintPdfYn',	type:'print_pdf',	defaultShowYn:'Y'},	//기능컨트롤_PDF인쇄
               {name:'ExcelYn',		type:'xls',			defaultShowYn:'Y'},	//기능컨트롤_엑셀
               {name:'WordYn',		type:'doc',			defaultShowYn:'Y'},	//기능컨트롤_워드
               {name:'PptYn',		type:'ppt',			defaultShowYn:'Y'},	//기능컨트롤_파워포인트
               {name:'HwpYn',		type:'hwp',			defaultShowYn:'Y'},	//기능컨트롤_한글
               {name:'PdfYn',		type:'pdf',			defaultShowYn:'Y'}	//기능컨트롤_PDF
       ];

	for(var i=0;i<array.length;i++){
		if ( ( $("#"+array[i].name, parent.document).length > 0 && $("#"+array[i].name, parent.document).val() == "N" ) ||
			 ( $("#"+array[i].name, parent.document).length > 0 && $("#"+array[i].name, parent.document).val() != "Y" && array[i].defaultShowYn == "N") ||
			 ( $("#"+array[i].name, parent.document).length < 1 && array[i].defaultShowYn == "N") ){

			hideItem[itemNum] = array[i].type;
			itemNum ++;
		}
	}
	return hideItem;
}
</script>
</body>
</HTML>
