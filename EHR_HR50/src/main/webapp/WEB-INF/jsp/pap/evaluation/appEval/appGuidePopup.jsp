<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/cookie.js"></script>

<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		if (convertParam.type == "guide") {
			//$("#title").html("작성가이드");
			doAction1("Search");
		} else if (convertParam.type == "appMidResult") {
			//$("#title").html("중간점검");
			$("#guide").html(unescape(convertParam.text));
		}
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var appraisalCd = convertParam.appraisalCd;
				var appTypeCd = convertParam.appTypeCd ? convertParam.appTypeCd : convertParam.appStatus;
				var params = "";
				params += "&appraisalCd=" + appraisalCd;
				params += "&appTypeCd=" + appTypeCd;
				//params += "&languageCd=" + $("#languageCd").val();
				tempInfo = ajaxCall("${ctx}/AppEval.do?cmd=getAppGuideList", params, false);
				if( tempInfo != null && tempInfo != undefined && tempInfo.DATA != null && tempInfo.DATA != undefined ) {
					var data = tempInfo.DATA;
					$("#guide").html(data[0].guide ? data[0].guide : "");
				}
	            break;
		}
    } 
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value) {
		try{
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	
	function onView(){
		sheetResize();
	}
	
</script>

</head>
<body>
<div class="wrapper">
 	<div class="explain" style="overflow: auto; height:calc(100% - 45px); background-color: white;">
		<div class="title" style="display: none;"></div>
		<div class="txt">
			<pre id="guide" style="white-space: pre-wrap; height:100%;"></pre>
		</div>
	</div>		
</div>
</body>
</html>



