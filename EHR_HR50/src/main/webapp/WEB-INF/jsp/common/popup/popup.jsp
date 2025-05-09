<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self">
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>e-HR </title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<script type="text/javascript">
var opener = null;
$(function() {

	$("head").append("<link rel='shortcut icon' type='image/x-icon' href='/common/images/icon/favicon_${ssnEnterCd}.ico' />");
	$(document).attr("title","${ssnAlias} 팝업");

	var arr = window.dialogArguments;
    if( arr != undefined ) {
        opener = arr["opener"];
        url = arr["url"];
    }

    $("<form></form>",{id:"iPublicForm",name:"iPublicForm",method:"post"}).appendTo('body');
    for (key in arr) {
    	//alert(key+"="+arr[key]+"==>"+arr[key].constructor);
		if(arr[key].constructor.toString().indexOf("String")>0){
    		$("#iPublicForm").append($('<input type="text"/>').attr({  "id" : key, "name" : key , "value" : arr[key] }));
		}
    }
    var url = $("#url").val();
    if( url == undefined || url == "") return;

        var pageUrl = url.split("?")[0];
    if( url.split("?")[1] != undefined ) {
        // get으로 넘어온 변수 쪼개기
        var _ary = url.split("?")[1].split("&");
        var _temp;
        var _len = _ary.length;

        for( var i = 0 ; i < _len ; i++ ) {
            _temp = _ary[i].split("=");
            //createFormObject(_temp[0], _temp[1]);
            $("#iPublicForm").append($('<input type="hidden"/>').attr({ "id" : _temp[0] ,"name" : _temp[0] , "value" : _temp[1] }));
        }
    }
    submitCall($("#iPublicForm"),"iPublicFrame","POST",pageUrl+"?cmd="+ $("#cmd").val());

});

function opener(){
	return opener;
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
	var arrRtn = [];

	for (i = 0; i < len; i++) {
		if((form.elements[i].tagName).toLowerCase() == 'input') {
			arrRtn[form.elements[i].id] = form.elements[i].value;
		}
	}

	return arrRtn;
}

function popReturnValue(rv){
	var returnValue = "";
	var i = 0;

	for(key in rv) {
		if(key != "contains"){
			if(typeof rv[key] == "object") {
				alert("return value 값이 object 입니다.");
				return;
			}

			if(typeof rv[key] != 'undefined' && rv[key] != null) {
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
</script>
</head>
<body class="bodywrap">
<iframe name="iPublicFrame" id="iPublicFrame" src="" scrolling="no" marginwidth="0" marginheight="0" frameborder="0" height="100%" width="100%" style="width:100%;height:100%;overflow:hidden"></iframe>
</body>
</html>
