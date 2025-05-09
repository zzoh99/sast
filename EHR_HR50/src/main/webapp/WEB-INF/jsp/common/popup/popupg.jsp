<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.StringUtil" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self">
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>e-HR </title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>

<%
		String strData = request.getParameter("Data");
%>

<script type="text/javascript">

$(function() {

	$(window).resize(function(){
		var elem = $(this);
		resize_iframe();
		//$('#window-info').text( 'window width: ' + elem.width() + ', height: ' + elem.height() );

	});

	$("head").append("<link rel='shortcut icon' type='image/x-icon' href='../../common/images/icon/favicon_<%=session.getAttribute("ssnEnterCd")%>.ico' />");
	$(document).attr("title","<%=StringUtil.nvl((String)session.getAttribute("ssnEnterNm"))%> <%=StringUtil.nvl((String)session.getAttribute("ssnAlias"))%> 팝업");

	var arr = $.parseJSON('{<%=StringUtil.reverse2QUOT(strData)%>}');

		$("<form></form>",{id:"iPublicForm",name:"iPublicForm",method:"post"}).appendTo('body');
		for (key in arr) {

		if(arr[key].constructor.toString().indexOf("String")>0){

			var dm = "";
			if(arr[key]=="[object Object]"){
			}
			else{
					$("#iPublicForm").append($('<input type="hidden"/>').attr({  "id" : key, "name" : key , "value" : unescape(arr[key]) }));
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

function popDialogArgumentAll(){
	var form = document.getElementById('iPublicForm');
	var len = form.elements.length;
	var objRtn = {};

	for (i = 0; i < len; i++) {
		if((form.elements[i].tagName).toLowerCase() == 'input') {
			objRtn[form.elements[i].id] = form.elements[i].value;
		}
	}

	return objRtn;
}

function popReturnValue(rv){
	var returnValue = "";
	var i = 0;

	for(key in rv) {
		if(key != "contains"){
			if(typeof rv[key] == "object") {
				//alert("return value 값이 object 입니다.");
				//return;
			//}
			} else if(typeof rv[key] != 'undefined' && rv[key] != null) {
				rv[key] = rv[key].toString().replace(/\"/gi,'\\"');
				rv[key] = rv[key].toString().replace(/'/gi,"\'");
				rv[key] = rv[key].toString().replace(/\r\n/gi,"\n");
				rv[key] = rv[key].toString().replace(/\n/gi,"\\n");
				rv[key] = rv[key].toString().replace(/\t/gi,"    ");
			}

			returnValue = returnValue + ((i==0) ? "\"" : ",\"") +[key]+"\":\""+rv[key]+"\"";
		}
		i++;
	}

	if ((window.opener != null) && (!window.opener.closed)){
		if(window.opener.globalWindowRtnFn != null) {
			window.opener.globalWindowRtnFn(rv);
		} else {
			window.opener.getReturnValue(returnValue);
		}
		}
}

//리스트 배열로 만들어진 데이터를 화면에서 처리하기 위함
function popReturnValue2(rv){
window.opener.getReturnValue(rv);
}

</script>
</head>
<body class="bodywrap">


<iframe name="iPublicFrame" id="iPublicFrame" src="" scrolling="no" marginwidth="0" marginheight="0" frameborder="0" height="100%" width="100%" style="width:100%;height:100%;overflow:hidden"></iframe>

</body>
</html>
