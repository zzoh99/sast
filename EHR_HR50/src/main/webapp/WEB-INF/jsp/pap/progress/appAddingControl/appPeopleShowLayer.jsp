<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>조직 리스트 조회</title>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;

	$(function() {
		modal = window.top.document.LayerModalUtility.getModal('appPeopleShowLayer');

		$(".close, #close").click(function() {
			closeCommonLayer('appPeopleShowLayer');
		});

		var enterCd = "";

	    if( modal != undefined ) {
			$("#appraisalCd").val(modal.parameters.searchAppraisalCd);
			$("#gubun").val(modal.parameters.searchGubun);
	    	enterCd    = modal.parameters.enterCd;

	    }
	    var shtHid = 1;
	    if( $("#gubun").val() == "2" ) shtHid = 0;

		var dupleHid = 1;
		if( $("#gubun").val() == "1" ) dupleHid = 0;

		createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");

		//$("#searchEnterCd").val(dialogArguments["enterCd"]) ;
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"No",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"삭제",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
				{Header:"상태",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
				{Header:"성명",       Type:"Text",      Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"name",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"사번",       Type:"Text",      Hidden:0,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"sabun",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
				{Header:"제외사유",   Type:"Text",      Hidden:shtHid,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"memo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
				{Header:"주관부서 수",   Type:"Text",      Hidden:dupleHid,  Width:50,  Align:"CENTER",    ColMerge:0,   SaveName:"dupleCnt",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0},
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();
		sheet1.SetSheetHeight($(".modal_body").height());

	    doAction("Search");

	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			if( $("#gubun").val() == "2" ){
				sheet1.DoSearch( "${ctx}/Popup.do?cmd=getAppPeopleShowPopExList", $("#sheet1Form").serialize() );
			}else{
				sheet1.DoSearch( "${ctx}/Popup.do?cmd=getAppPeopleShowPopList", $("#sheet1Form").serialize() );
			}

			break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
<%--		<div class="popup_title">--%>
<%--			<ul>--%>
<%--				<li>대상자보기</li>--%>
<%--				<li class="close"></li>--%>
<%--			</ul>--%>
<%--		</div>--%>
		<div class="modal_body">
			<form id="sheet1Form" name="sheet1Form" tabindex="1">
				<input type="hidden" name="appraisalCd" id="appraisalCd" />
				<input type="hidden" name="gubun" id="gubun" />
				<input type="hidden" id="searchEnterCd" name="searchEnterCd" />
				<div id="sheet1-wrap"></div>
			</form>
		</div>

		<div class="modal_footer">
			<a id="close" class="btn outline_gray">닫기</a>
		</div>
	</div>
</body>
</html>



