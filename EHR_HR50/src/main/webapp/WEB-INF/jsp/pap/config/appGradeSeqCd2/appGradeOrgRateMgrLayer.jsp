<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head><title>평가그룹인원 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<script type="text/javascript">
	//var p 	= eval("${popUpStatus}");
	//var arg = p.popDialogArgumentAll();

	$(function(){
		createIBSheet3(document.getElementById('mysheet-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
    		{Header:"평가대상자|성명"	,Type:"Text",     	Hidden:0,  Width:60,	Align:"Center",	ColMerge:0,   SaveName:"name1",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가대상자|사번"	,Type:"Text",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"sabun",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가대상자|소속"	,Type:"Text",     	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,   SaveName:"appOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가대상자|직급"	,Type:"Text",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"jikgubNm1",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가대상자|직책"	,Type:"Text",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"jikchakNm1",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
    		{Header:"평가자|성명"		,Type:"Text",     	Hidden:0,  Width:60,	Align:"Center",	ColMerge:0,   SaveName:"name2",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가자|사번"		,Type:"Text",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appSabun",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가자|소속"		,Type:"Text",     	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가자|직급"		,Type:"Text",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"jikgubNm2",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가자|직책"		,Type:"Text",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"jikchakNm2",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		var sheetHeight = $(".modal_body").height() - $("#srchFrm").height() - $(".sheet_title").height() - 2;
		sheet1.SetSheetHeight(sheetHeight);

		var modal = window.top.document.LayerModalUtility.getModal('appGradeOrgRateMgrLayer');

			$("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
			$("#searchAppSeqCd").val(modal.parameters.searchAppSeqCd);
			$("#searchAppGroupCd").val(modal.parameters.searchAppGroupCd);


		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppGradeSeqCd2.do?cmd=getAppGradeOrgRateMgrPopList1", $("#srchFrm").serialize() ); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param = {DownCols:downcol, SheetDesign:1, Merge:1};
							sheet1.Down2Excel(param);
							break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="srchFrm" name="srchFrm">
				<input type="hidden" id="searchAppraisalCd"	name="searchAppraisalCd"	/>
				<input type="hidden" id="searchAppSeqCd"	name="searchAppSeqCd"		/>
				<input type="hidden" id="searchAppGroupCd"	name="searchAppGroupCd"		/>
			</form>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt">평가그룹인원</li>
									<li class="btn">
										<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
									</li>
								</ul>
							</div>
						</div>
						<div id="mysheet-wrap"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('appGradeOrgRateMgrLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>
</body>
</html>