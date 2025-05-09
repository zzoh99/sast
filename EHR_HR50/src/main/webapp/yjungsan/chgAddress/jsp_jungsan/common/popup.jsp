<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>

<!DOCTYPE html>
<html class="bodywrap"><head><base target="_self"><title>e-HR</title>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<link rel="stylesheet" href="../../common/css/nanum.css" />
<link rel="stylesheet" href="../../common/theme1/css/style.css" />
<script src="../../common/js/jquery/1.8.3/jquery.min.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>

<script type="text/javascript">
var opener = null;
$(function() {

	$("head").append("<link rel='shortcut icon' type='image/x-icon' href='../common/images/icon/favicon_<%=session.getAttribute("ssnEnterCd")%>.ico' />");
	$(document).attr("title","<%=StringUtil.nvl((String)session.getAttribute("ssnEnterNm"))%> <%=StringUtil.nvl((String)session.getAttribute("ssnAlias"))%> 팝업");
	
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


/**
 * 공통 summit 호출
 *
 * @param url
 * @param params
 * @param async
 * @returns Object
 */
function submitCall(formObj, target, method, action) {
	formObj	.attr("target",target)
			.attr("method",method)
			.attr("action",action)
			.submit();
}

function opener(){
	return opener;
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

</script>
</head>
<body class="bodywrap">
<iframe name="iPublicFrame" id="iPublicFrame" src="" scrolling="yes" marginwidth="0" marginheight="0" frameborder="0" height="100%" width="100%" style="width:100%;height:100%;overflow:hidden"></iframe>
</body>
</html>