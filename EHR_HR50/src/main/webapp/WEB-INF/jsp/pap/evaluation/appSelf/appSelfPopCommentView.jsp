<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의견보기팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
	<%--var p = eval("${popUpStatus}");--%>
	var modal = "";
	var sheetHeigth = $(".modal_body").height() - $("#sheet1Form").height() -2;

	$(function() {
		createIBSheet3(document.getElementById('mysheet-wrap'), "appSelfPopCommentViewSheet", "100%", "100%", "${ssnLocaleCd}");
		modal = window.top.document.LayerModalUtility.getModal('appSelfPopCommentViewLayer');
		$(".close, #close").click(function() {
			closeCommonLayer('appSelfPopCommentViewLayer');
		});

		// var arg = p.popDialogArgumentAll();
	    if( modal != undefined ) {
		    $("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
		    $("#searchSabun").val(modal.parameters.searchSabun);
		    $("#searchAppOrgCd").val(modal.parameters.searchAppOrgCd);
		    $("#searchAppStepCd").val(modal.parameters.searchAppStepCd);
	    }
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"No"		,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제"		,Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
				{Header:"상태"		,Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
				{Header:"단계"		,Type:"Text",	Hidden:0,	Width:25,	Align:"Center",	ColMerge:1,	SaveName:"stepNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
				{Header:"상태"		,Type:"Text",	Hidden:0,	Width:25,	Align:"Center",	ColMerge:1,	SaveName:"statusNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
				{Header:"등록자"		,Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
				{Header:"의견"		,Type:"Text",	Hidden:0,	Width:110,	Align:"Letf",	ColMerge:1,	SaveName:"appComment",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1, Wrap:1},
				{Header:"등록일시"	,Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"regTime",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(appSelfPopCommentViewSheet, initdata);appSelfPopCommentViewSheet.SetEditable(false);appSelfPopCommentViewSheet.SetVisible(true);appSelfPopCommentViewSheet.SetCountPosition(4);appSelfPopCommentViewSheet.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();
		appSelfPopCommentViewSheet.SetSheetHeight(sheetHeigth);
		doAction1("Search");
	});

	function doAction1(sAction){
		//removeErrMsg();
		switch(sAction){
			case "Search":		//조회
				appSelfPopCommentViewSheet.DoSearch("${ctx}/EvaMain.do?cmd=getAppSelfPopCommentView", $("#appSelfPopCommentViewSheetForm").serialize());
				break;
		}
	}

	//조회 후 에러 메시지
	function appSelfPopCommentViewSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form" >
		<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" />
		<input id="searchSabun" name="searchSabun" type="hidden" />
		<input id="searchAppOrgCd" name="searchAppOrgCd" type="hidden" />
		<input id="searchAppStepCd" name="searchAppStepCd" type="hidden" />
		</form>

<%--		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>--%>
		<div id="mysheet-wrap"></div>
	</div>
	<div class="modal_footer">
		<a id="close" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>