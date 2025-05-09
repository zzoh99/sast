<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%--<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>


<script type="text/javascript">

	<%--var p = eval("${popUpStatus}");--%>
	var checkType="";
	var payActionCd="";
	var payActionNm="";


	$(function() {
		createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%");
		const modal = window.top.document.LayerModalUtility.getModal('payCalcErrorLayer');
		payActionCd = modal.parameters.payActionCd || '';
		payActionNm = modal.parameters.payActionNm || '';
		$("#payActionCd").val(payActionCd);
		$("#payActionNm").text(payActionNm);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"순서",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"Object명",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"objectNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"error위치",	Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"errLocation",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"error내용",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"errLog",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500, Wrap:1}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		var sheetHeight = $(".modal_body").height() - $(".tab_bottom").height();
		sheet1.SetSheetHeight(sheetHeight);
		doAction1("Search");
	});

	/*Sheet1 Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/PayCalcCre.do?cmd=getPayCalcCreErrorList", $("#sheet1Form").serialize() );
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
		<div class="modal_body">
			<form id="sheet1Form" name="sheet1Form" >
				<input type="hidden" id="payActionCd" name="payActionCd" />
			</form>
        	<div id="tabs">
				<ul class="outer tab_bottom"></ul>
				<div id="sheet1-wrap"></div>
			</div>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('payCalcErrorLayer');" class="btn outline_gray">닫기</a>
		</div>
	</div>
</body>
</html>