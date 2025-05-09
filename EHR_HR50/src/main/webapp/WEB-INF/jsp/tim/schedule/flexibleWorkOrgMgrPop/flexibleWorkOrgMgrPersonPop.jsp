<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	$(function() {
		var sDateList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getOrgSchemeSdate",false).codeList, "");

		var initdata = {};
		initdata = {};
		initdata.Cfg = {SearchMode:smGeneral, Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"조직도명",		Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"orgChartNm",	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 },
			{Header:"시작일",			Type:"Text",	Hidden:1,  Width:0,		Align:"Center",	ColMerge:0,   SaveName:"sdate",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"상위조직코드",	Type:"Text", 	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"priorOrgCd",	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"조직코드",		Type:"Text", 	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"orgCd",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"조직도",			Type:"Text", 	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50,    TreeCol:1 },
			{Header:"직속\n여부",		Type:"Text", 	Hidden:1,  Width:0,		Align:"Center",	ColMerge:0,   SaveName:"directYn",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"순서",			Type:"Int", 	Hidden:1,  Width:0,		Align:"Right",	ColMerge:0,   SaveName:"seq",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"인원",			Type:"Int", 	Hidden:1,  Width:50,	Align:"Right",	ColMerge:0,   SaveName:"empCnt1",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"조직장사번",		Type:"Text", 	Hidden:1,  Width:0,		Align:"Center",	ColMerge:0,   SaveName:"orgChiefSabun",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"조직장",			Type:"Text", 	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"orgChiefName",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"화상조직도",		Type:"Int",		Hidden:1,  Width:0,		Align:"Right",	ColMerge:0,   SaveName:"empCnt2",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"프로필",		Type:"Text",		Hidden:1,  Width:40,	Align:"Center",	ColMerge:0,   SaveName:"profile",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"사번",		Type:"Text",		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"scopeValue",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",		Type:"Text", 		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"scopeValueNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",		Type:"Text", 		Hidden:0,  Width:130,	Align:"Left",	ColMerge:0,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",		Type:"Text", 		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",		Type:"Text", 		Hidden:0,  Width:90,	Align:"Center",	ColMerge:0,   SaveName:"jikgubNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",		Type:"Int", 		Hidden:1,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"jikgubNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"파트",		Type:"Int", 		Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"partNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사원구분",	Type:"Text", 		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"manageNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"등록",		Type:"CheckBox",	Hidden:0,  Width:45,	Align:"Center",	ColMerge:0,   SaveName:"chk",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});

		$("#searchOrgChartNm").bind("change",function(event){
			doAction1("Search");
		});

		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

		$("#searchSDate").html(sDateList[2]);

		$("#searchBaseDate").datepicker2();

		$("#searchBaseDate").val("${curSysYyyyMMddHyphen}");

		var arg = p.popDialogArgumentAll();

	    if( arg != undefined ) {
		    $("#searchUseGubun").val(arg["searchUseGubun"]);
		    $("#searchItemValue1").val(arg["searchItemValue1"]);
		    $("#searchItemValue2").val(arg["searchItemValue2"]);
		    $("#searchItemValue3").val(arg["searchItemValue3"]);
		    $("#searchAuthScopeCd").val(arg["searchAuthScopeCd"]);
	    }

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		$("#searchOrgChartNm").val( $("#searchSDate option:selected").text().split("[")[0] );

		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/FlexibleWorkOrgMgrPop.do?cmd=getFlexibleWorkOrgMgrPopList4", $("#srchFrm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			if( $("#searchType").is(":checked") == false ){
				sheet2.DoSearch( "${ctx}/FlexibleWorkOrgMgrPop.do?cmd=getFlexibleWorkOrgMgrPopList5", $("#srchFrm").serialize() ); break;
			} else {
				sheet2.DoSearch( "${ctx}/FlexibleWorkOrgMgrPop.do?cmd=getFlexibleWorkOrgMgrPopList6", $("#srchFrm").serialize() ); break;
			}

		case "Save":
			for(i=1; i<=sheet2.LastRow(); i++){
		        if( sheet2.GetCellValue(i,"chk") == "1" ) {
		        	sheet2.SetCellValue(i,"sStatus", "I");
		        } else {
		        	sheet2.SetCellValue(i,"sStatus", "D");
		        }
			};
			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave( "${ctx}/FlexibleWorkOrgMgrPop.do?cmd=saveFlexibleWorkOrgMgrPop", $("#srchFrm").serialize()); break;

		case "Down2Excel":	sheet2.Down2Excel(); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheet1.SelectCell(1, "orgNm");
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 셀 선택시
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if( sheet1.ColSaveName(NewCol) == "orgNm" || sheet1.ColSaveName(NewCol) == "empCnt1" ) {
				//조직원수 또는 조직원수(하위포함) 의 구분으로 조직원 리스트 조회 구분
				$("#searchOrgCd").val(sheet1.GetCellValue(NewRow, "orgCd"));
				doAction2("Search");
			}
		} catch (ex) { alert("OnSelectCell Event Error : " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>사용자 권한범위 설정(성명)</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id=srchFrm name=srchFrm>
	        <input id="searchUseGubun" 		name="searchUseGubun" 		type="hidden" />
			<input id="searchItemValue1" 		name="searchItemValue1" 		type="hidden" />
			<input id="searchItemValue2" 		name="searchItemValue2" 		type="hidden" />
			<input id="searchItemValue3" 		name="searchItemValue3" 		type="hidden" />
			<input id="searchAuthScopeCd" 		name="searchAuthScopeCd" 		type="hidden" />
			<input id="searchOrgChartNm" 		name="searchOrgChartNm" 		type="hidden" />
			<input id="searchOrgCd" 			name="searchOrgCd" 				type="hidden" />
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>조직도</th>
				<td>
					<select id="searchSDate" name="searchSDate"></select>
				</td>
				<th>기준일</th>
				<td>
					<input id="searchBaseDate" name ="searchBaseDate" type="text" class="date2" />
				</td>
               	<td>
				<a href="javascript:doAction1('Search');" id="btnSearch" class="button">조회</a>
				</td>
			</tr>
			</table>
			</div>
		</div>
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="w100p">
		<tbody>
		<colgroup>
			<col width=30%></col>
			<col width=10px></col>
			<col width=*></col>
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">조직명
							<div class="util">
							<ul>
								<li	id="btnPlus"></li>
								<li	id="btnStep1"></li>
								<li	id="btnStep2"></li>
								<li	id="btnStep3"></li>
							</ul>
							</div>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
			<td>&nbsp;</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">조직원
						</li>
						<li class="btn">
							<input type="checkbox" class="checkbox" id="searchType" name="searchType" onClick="doAction2('Search');" style="vertical-align:middle;"/>하위조직포함
							<a href="javascript:doAction2('Search')" class="button">조회</a>
							<a href="javascript:doAction2('Save')" class="basic authA">저장</a>
							<a href="javascript:doAction2('Down2Excel')" class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
			</td>
		</tr>
		</tbody>
		</table>

		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:p.self.close();" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>

</body>
</html>