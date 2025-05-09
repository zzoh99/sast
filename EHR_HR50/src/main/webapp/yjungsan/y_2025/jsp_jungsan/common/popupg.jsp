<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>

<!DOCTYPE html>
<html class="bodywrap"><head><base target="_self"><title>e-HR</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>

<%
     String strData = request.getParameter("Data");
     strData = strData.replaceAll("\\\\","");
     strData = strData.replaceAll("&", "");

	 //팝업화면에 동일 회사명이 2번 중복 표기되는 버그 수정
     String strEntNm = removeXSS(session.getAttribute("ssnEnterNm"),'1') ;
     String strEntAlias = removeXSS(session.getAttribute("ssnAlias"),'1') ;
     
     if(strEntNm == null || strEntNm.length() < 1 ) strEntNm = "";
     if(strEntAlias == null || strEntAlias.length() < 1 ) strEntAlias = "";     
     if(!strEntNm.equals(strEntAlias)) {
    	 strEntNm = strEntNm + " " + strEntAlias;
     }
%>

<script type="text/javascript">
$(function() {

	$("head").append("<link rel='shortcut icon' type='image/x-icon' href='../../common/images/icon/favicon_<%=removeXSS(session.getAttribute("ssnEnterCd"),'1')%>.ico' />");

	$(document).attr("title","<%=strEntNm%> 팝업");
	var arr = $.parseJSON(unescape('{<%=strData%>}'));

    $("<form></form>",{id:"iPublicForm",name:"iPublicForm",method:"post"}).appendTo('body');
    for (key in arr) {

		if(arr[key].constructor.toString().indexOf("String")>0){

			var dm = "";
			if(arr[key]=="[object Object]"){
			}
			else{
				$("#iPublicForm").append($('<input type="hidden"/>').attr({  "id" : key, "name" : key , "value" : arr[key] }));
			}
		}
    }

    var url = $("#url").val();
    if( url == undefined || url == "") return;

    var pageUrl = url.split("?")[0];
    if( url.split("?")[1] != undefined ) {
        var _ary = url.split("?")[1].split("&");
        var _temp;
        var _len = _ary.length;

        for( var i = 0 ; i < _len ; i++ ) {
            _temp = _ary[i].split("=");
            $("#iPublicForm").append($('<input type="hidden"/>').attr({ "id" : _temp[0] ,"name" : _temp[0] , "value" : _temp[1] }));
        }
    }
    submitCall($("#iPublicForm"),"iPublicFrame","POST",pageUrl+"?cmd="+ $("#cmd").val());

    resize_iframe();

});

function resize_iframe(){
	try{
		$('#iPublicFrame').css("height", $(this).contents().find("body").height() + "px");
	}catch(e){
		return;
	}
}

function popDialogArgument(id){
	var rtStr = null;
	try{
		rtStr= document.getElementById(id).value;
	}catch(e){
		rtStr= null;
	}

    return(rtStr);

}

function popDialogSheet(id){
	var rtSeet = eval("window.opener."+id);
    return(rtSeet);
}

function popReturnValue(rv){

	var returnValue = "";
	var i = 0;
	for(key in rv) {
		if(key != "contains"){
			returnValue = returnValue + ((i==0) ? "\"" : ",\"") +[key]+"\":\""+rv[key]+"\"";
		}
		i++;
	}


	if ((window.opener != null) && (!window.opener.closed)){
		window.opener.getReturnValue(returnValue);
    }

}
/*************************************************************
* 2021.04.07 로그관리
* saveReasonReValue
* 다운로드 사유 팝업에서 사유 저장 return
* EXCEL  : callDown2Excel (ibsheetinfo.js   )
* RD     : callDownRD     (rdPopupIframe.jsp)
* FILE   : callDownFile   (해당 화면                   )
*            - selfInputHisMgr.jsp
*            - evidenceDocMgr.jsp
*            - withHoldRcptPdfUpload.jsp
*            - yeaDataAddFile.jsp
*************************************************************/
function saveReasonReValue(rv,pm){

    var returnValue = "";
    var i = 0;
    for(key in rv) {
        if(key != "contains"){
            returnValue = returnValue + ((i==0) ? "\"" : ",\"") +[key]+"\":\""+rv[key]+"\"";
        }
        i++;
    }
    if(rv){
        if(pm == "E"){
            if ((window.opener != null) && (!window.opener.closed)){
                window.opener.callDown2Excel(rv);
            }
        }else if(pm == "F"){
            if ((window.opener != null) && (!window.opener.closed)){
                window.opener.callDownFile(rv);
            }
        }else if(pm == "P"){
            if ((window.opener != null) && (!window.opener.closed)){
                window.opener.callDownRD(rv);
            }
        }
    }
}


</script>
</head>
<body class="bodywrap">

<iframe name="iPublicFrame" id="iPublicFrame" src="" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" height="100%" width="100%" style="width:100%;height:100%;overflow:hidden"></iframe>

</body>
</html>