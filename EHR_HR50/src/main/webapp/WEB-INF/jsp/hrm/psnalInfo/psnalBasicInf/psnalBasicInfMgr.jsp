<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>인사기본(tree)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- Style -->
<!-- <link rel="stylesheet" type="text/css" href="/common/css/common.css"> -->
<!-- <link rel="stylesheet" type="text/css" href="/common/css/sub.css"> -->

<c:set var="popUpStyle"  value="" />
<c:if test="${fn:length(param.searchSabun) > 0}">
	<c:set var="ssnSabun"  value="${param.searchSabun}" />
	<c:set var="popUpStyle"  value="padding:0px;" />
</c:if>

<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
function setEmpPage() {
	showCommonTab(0);
}
function viewTab(pMenuNm) {
	return true;
}
function addTabData(pData) {
	;
}



$(function() {
	$(".header_table").removeClass("outer");

	$("#searchSabunName").on("keyup", function(event) {
		if( event.keyCode == 13) {
			doAction("Search2");
		}
	});

	$("#btnPlus").click(function() {
		sheet1.ShowTreeLevel(-1);
	});

	$("#btnStep1").click(function()	{
		sheet1.ShowTreeLevel(1, 2);
	});

	$("#btnStep2").click(function()	{
		sheet1.ShowTreeLevel(2, 3);
	});

	$("#btnStep3").click(function()	{
		sheet1.ShowTreeLevel(3, 4);
	});
	
	//Sheet 초기화
	inist_sheet1();
	inist_sheet2();
	
	$(window).smartresize(sheetResize); sheetInit();
	
	doAction("Search");
});

function inist_sheet1(){
	var initdata = {};
	initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:1, 	Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },

		{Header:"부서명",		Type:"Text",      	Hidden:0,  	Width:150, Align:"Left",    	SaveName:"orgNm",    TreeCol:1,  LevelSaveName:"sLevel" },
		{Header:"부서코드",		Type:"Text",      	Hidden:1,  	Width:70,  Align:"Center",    	SaveName:"orgCd" }
		
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함 
	sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음

}

function inist_sheet2(){
	var initdata = {};
	initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:1, 	Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },

		{Header:"사번",			Type:"Text",      	Hidden:0,  	Width:55,  Align:"Center",    	SaveName:"sabun" },
		{Header:"성명",			Type:"Text",      	Hidden:0,  	Width:60,  Align:"Center",    	SaveName:"name" },
		{Header:"직책",			Type:"Text",      	Hidden:1,  	Width:70,  Align:"Center",    	SaveName:"jikchakNm" },
		{Header:"직위",			Type:"Text",      	Hidden:1,  	Width:60,  Align:"Center",    	SaveName:"jikweeNm" },
		{Header:"직급",			Type:"Text",      	Hidden:1,  	Width:60,  Align:"Center",    	SaveName:"jikgubNm" },
		{Header:"년차",			Type:"Text",      	Hidden:1,  	Width:60,  Align:"Center",    	SaveName:"sgPoint" }
		
	]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
	sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함 
}
//Sheet Action
function doAction(sAction) {
	switch (sAction) {
	case "Search": 	 	
		sheet1.DoSearch( "${ctx}/PsnalBasicInf.do?cmd=getPsnalBasicLeftOrgList", $("#searchForm").serialize() ); 
		break;
	case "Search2": 	 	
		if( $("#searchOrgCd").val() == "" && $("#searchSabunName").val() == "") return;
		if( $("#searchSabunName").val() != "" ){
			$("#searchOrgCd").val("");
			sheet1.SetSelectRow(-1);
		}
		sheet2.DoSearch( "${ctx}/PsnalBasicInf.do?cmd=getPsnalBasicLeftEmpList", $("#searchForm").serialize() ); 
		break;
	case "Fold":
		sheet2.RenderSheet(0);
		//sheet2.SetColHidden("sNo", 1);
		//sheet2.SetColHidden("orgNm", 1);
		//sheet2.SetColHidden("jikchakNm", 1);
		sheet2.SetColHidden("jikweeNm", 1);
		//sheet2.SetColHidden("jikgubNm", 1);
		sheet2.RenderSheet(1);
		$("#fold").hide();
		$("#unfold").show();
		$("#tableLeft").hide();
		//$("#tableLeft").width("10");
		//$(".tdleft").width("10");
		//sheet2.SetSheetWidth(0);
		$("#ifmBody").css("left", "0px");
		$(".leftOrgList").hide();
		$("#searchSabunName").hide();
		$("#btnSearch").hide();
		break;
	case "UnFold":
		sheet2.RenderSheet(0);
		//sheet2.SetColHidden("sNo", 0);
		//sheet2.SetColHidden("orgNm", 0);
		//sheet2.SetColHidden("jikchakNm", 0);
		sheet2.SetColHidden("jikweeNm", 0);
		//sheet2.SetColHidden("jikgubNm", 0);
		sheet2.RenderSheet(1);
		$("#tableLeft").show();
		$("#unfold").hide();
		$("#fold").show();
		//$("#tableLeft").width("450");
		//$(".tdleft").width("220");
		//sheet2.SetSheetWidth(220);
		$("#ifmBody").css("left", "400px");
		$(".leftOrgList").show();
		$("#searchSabunName").show();
		$("#btnSearch").show();
		break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
		sheet1.Down2Excel(param);
		break;
	}
}
//---------------------------------------------------------------------------------------------------------------
// sheet1 Event
//---------------------------------------------------------------------------------------------------------------
// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("sheet1_OnSearchEnd Event Error : " + ex);
	}
}

// 셀 변경시 발생
function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
	try {
		if( NewRow < sheet1.HeaderRows() ) return;
		
		if(OldRow != NewRow) {
			$("#searchOrgCd").val(sheet1.GetCellValue(NewRow, "orgCd"));
			$("#searchSabunName").val("");
			doAction("Search2");
		}
		
	} catch (ex) {
		alert("OnSelectCell Event Error " + ex);
	}
}
//---------------------------------------------------------------------------------------------------------------
// sheet2 Event
//---------------------------------------------------------------------------------------------------------------
// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != ""){
			alert(Msg);
		}
		sheetResize();
	}catch(ex){
		alert("sheet2_OnSearchEnd Event Error : " + ex);
	}
}


// 셀 변경시 발생
function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
	try {
		if( NewRow < sheet1.HeaderRows() ) return;
		
		if(OldRow != NewRow) {
			
			$("#searchUserId").val(sheet2.GetCellValue(NewRow, "sabun"));
			getUser();
		
			//각 페이지 함수 호출
			setEmpPage();
		
		}
		
	} catch (ex) {
		alert("OnSelectCell Event Error " + ex);
	}
}
</script>
<style type="text/css">
#ifm {
	width:100%; height:100%; border:none; 
}
#ifmBody {
	position:absolute; top:0px; left:400px; right:0; bottom:0;

}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div style="position:absolute; top:0px; left:0px;display:none;z-index:999;" id="unfold">
		<a href="javascript:doAction('UnFold')" class="button authR">열기</a>
	</div>
	
	<table class="sheet_main" style="width:400px;table-layout: fixed;" id="tableLeft">
		<colgroup>
			<col class="leftOrgList" width="220px" />
			<col width=""/>
		</colgroup>
		<tr>
			<td colspan="2">
				<form id="searchForm" name="searchForm">
					<input type="hidden" id="searchSabun" name="searchSabun"/>
					<input type="hidden" id="searchOrgCd" name="searchOrgCd"/>
			
					<div class="sheet_search sheet_search_s outer">
						<table>
						<tr>
							<th>사번/성명</th>
							<td>
								<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
								<a href="javascript:doAction('Search2');" class="button" id="btnSearch">조회</a>
							</td>
						</tr>
						</table>
					</div>		
				</form>
			</td>
		</tr>
		<tr>
			<td class="leftOrgList">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">부서								
								<div class="util">
									<ul>
										<li	id="btnPlus"></li>
										<li	id="btnStep1"></li>
										<li	id="btnStep2"></li>
										<li	id="btnStep3"></li>
									</ul>
								</div>
							</li>
							<li class="btn">&nbsp;</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "220px", "100%"); </script>
			</td>
			<td class="sheet_right tdleft">
				<div class="inner">
					<div class="sheet_title tdleft">
						<ul>
							<li id="txt" class="txt">부서원</li><li class="btn">
								<a href="javascript:doAction('Fold')" 	class="basic authR" id="fold">접기</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
	
	<div id="ifmBody" style="padding-left: 10px;">
		<!-- include 기본정보 page TODO -->
		<!-- include 기본정보 테스트 중.. inchuli -->
		<div style="${popUpStyle}">
		<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
		</div>
		
		<!-- 공통탭 -->
		<%@ include file="/WEB-INF/jsp/common/include/commonTabInfo.jsp"%>
	</div>	
	
	
</div>
</body>
</html>
