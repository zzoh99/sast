<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>성명 범위구분지정</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function(){
		var sDateList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getOrgSchemeSdate", null, false).codeList, "");
		$("#searchSDate").html(sDateList[2]);
		$("#searchBaseDate").datepicker2();
		
		
		var searchUseGubun = p.popDialogArgument("searchUseGubun");
		var searchItemValue1 = p.popDialogArgument("searchItemValue1");
		var searchItemValue2 = p.popDialogArgument("searchItemValue2");
		var searchItemValue3 = p.popDialogArgument("searchItemValue3");
		var searchAuthScopeCd = p.popDialogArgument("searchAuthScopeCd");
		
		
		$("#searchUseGubun").val(searchUseGubun);
		$("#searchItemValue1").val(searchItemValue1);
		$("#searchItemValue2").val(searchItemValue2);
		$("#searchItemValue3").val(searchItemValue3);
		$("#searchAuthScopeCd").val(searchAuthScopeCd);
		
		var initdata = {};
		
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",	Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"조직도명",		Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"org_chart_nm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 },
			{Header:"시작일",			Type:"Text",	Hidden:1,  Width:0,		Align:"Center",	ColMerge:0,   SaveName:"sdate",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"상위조직코드",		Type:"Text", 	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"prior_org_cd",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"조직코드",		Type:"Text", 	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,   SaveName:"org_cd",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"조직도",			Type:"Text", 	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,   SaveName:"org_nm",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50,    TreeCol:1 },
			{Header:"직속\n여부",		Type:"Text", 	Hidden:1,  Width:0,		Align:"Center",	ColMerge:0,   SaveName:"direct_yn",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"순서",			Type:"Int", 	Hidden:1,  Width:0,		Align:"Right",	ColMerge:0,   SaveName:"seq",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"인원",			Type:"Int", 	Hidden:1,  Width:50,	Align:"Right",	ColMerge:0,   SaveName:"emp_cnt1",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"조직장사번",		Type:"Text", 	Hidden:1,  Width:0,		Align:"Center",	ColMerge:0,   SaveName:"org_chief_sabun",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"조직장",			Type:"Text", 	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"org_chief_name",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"화상조직도",		Type:"Int",		Hidden:1,  Width:0,		Align:"Right",	ColMerge:0,   SaveName:"emp_cnt2",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",	Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",	Type:"<%=sDelTy%>", Hidden:1,  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
			{Header:"상태",	Type:"<%=sSttTy%>", Hidden:1,  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0}, 
			{Header:"프로필",		Type:"Text",		Hidden:1,  Width:40,	Align:"Center",	ColMerge:0,   SaveName:"profile",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"사번",		Type:"Text",		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"scope_value",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",		Type:"Text", 		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"scope_value_nm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",		Type:"Text", 		Hidden:0,  Width:130,	Align:"Left",	ColMerge:0,   SaveName:"org_nm",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",		Type:"Text", 		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"jikchak_nm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",		Type:"Text", 		Hidden:0,  Width:90,	Align:"Center",	ColMerge:0,   SaveName:"jikgub_nm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",		Type:"Int", 		Hidden:1,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"jikgub_nm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"파트",		Type:"Int", 		Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"part_nm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사원구분",	Type:"Text", 		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"manage_nm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"등록",		Type:"CheckBox",	Hidden:0,  Width:45,	Align:"Center",	ColMerge:0,   SaveName:"chk",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
            ]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

    	$(window).smartresize(sheetResize); sheetInit();
    	    	
    	doAction1("Search");
    	
    	$(".close").click(function(){
			p.self.close();    		
    	});
	});
	
	//doAction 1
	function doAction1(sAction){
		$("#searchOrgChartNm").val( $("#searchSDate option:selected").text().split("[")[0] );
		
		switch(sAction){
			case "Search" :
				sheet1.DoSearch("<%=jspPath%>/workCalcStdMgr/workCalcStdMgrRst.jsp?cmd=selectWorkCalcStdMgrRngPopRstList3", $("#sheetForm").serialize());
				break;
		}
	}
	
	//doAction 2
	function doAction2(sAction){
		switch(sAction){
			case "Search" :
				if( $("#searchType").is(":checked") == false ){
					sheet2.DoSearch("<%=jspPath%>/workCalcStdMgr/workCalcStdMgrRst.jsp?cmd=selectWorkCalcStdMgrRngPopRstList4", $("#sheetForm").serialize());
				} else {
					sheet2.DoSearch("<%=jspPath%>/workCalcStdMgr/workCalcStdMgrRst.jsp?cmd=selectWorkCalcStdMgrRngPopRstList5", $("#sheetForm").serialize());
				}
				break;
			
			case "Save" :
				for(var i = 1; i < sheet2.LastRow(); i++){
					if(sheet2.GetCellValue(i, "chk") == "1") {
 						sheet2.SetCellValue(i, "sStatus", "I");
					} else {
						sheet2.SetCellValue(i, "sStatus", "D");
					}
				}
				sheet2.DoSave("<%=jspPath%>/workCalcStdMgr/workCalcStdMgrRst.jsp?cmd=saveWorkCalcStdMgrRngPop", $("#sheetForm").serialize());
				break;
		}
	}
	
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheet1.SelectCell(1, "orgNm");
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 셀 선택시
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if( sheet1.ColSaveName(NewCol) == "org_nm" || sheet1.ColSaveName(NewCol) == "emp_cnt1" ) {
				//조직원수 또는 조직원수(하위포함) 의 구분으로 조직원 리스트 조회 구분
				$("#searchOrgCd").val(sheet1.GetCellValue(NewRow, "org_cd"));
				doAction2("Search");
			}
		} catch (ex) { alert("OnSelectCell Event Error : " + ex); }
	}
	
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction2("Search");

		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');
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
		<form id=sheetForm name=sheetForm>
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
				<td>
					<span>조직도</span>
					<select id="searchSDate" name="searchSDate"></select>
				</td>
				<td>
					<span>기준일</span>
					<input id="searchBaseDate" name ="searchBaseDate" type="text" class="date2" value="<%=curSysYyyyMMddHyphen%>"/>
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