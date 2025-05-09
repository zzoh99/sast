<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수이행상황신고서</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",					Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"<%=sDelTy%>", Hidden:1,                       Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"<%=sSttTy%>", Hidden:1,                       Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus",	Sort:0 },
			{Header:"사번|사번",					Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:1,	SaveName:"sabun",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명",					Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:1,	SaveName:"name",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사업장|사업장",				Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:1,	SaveName:"business_place_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"소득구분|소득구분",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:1,	SaveName:"tax_ele_category_nm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"소득세부구분|소득세부구분",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_nm",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"코드|코드",					Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_cd",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"급여일자|급여일자",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"pay_action_nm",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"총지급액|총지급액",			Type:"Int",			Hidden:0,					Width:120,			Align:"Right",	ColMerge:0,	SaveName:"payment_mon",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"징수세액|소득세",				Type:"Int",			Hidden:0,					Width:120,			Align:"Right",	ColMerge:0,	SaveName:"paye_itax_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"징수세액|농특세",				Type:"Int",			Hidden:0,					Width:120,			Align:"Right",	ColMerge:0,	SaveName:"paye_atax_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

		// 사업장(TCPN121)
		var bizPlaceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "전체");
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCd[0], ComboCode:"|"+bizPlaceCd[1]});

		$(window).smartresize(sheetResize);
		sheetInit();

		// 검색 > 문서번호 Combo 삽입
		var taxDocNoCd = stfConvCode( codeList("<%=jspPath%>/earnIncomeCreDataMgr/earnIncomeCreDataMgrRst.jsp?cmd=selectEarnIncomeTaxDocNoCodeList",""), "");
		$("#taxDocNo").html(taxDocNoCd[2]);
		// 검색 > 사업장 Combo 삽입
		$("#businessPlaceCd").html(bizPlaceCd[2]);
		
		// 이벤트 바인딩
		$("#taxDocNo, #businessPlaceCd").bind("change",function(event) {
			doAction1("Search");
		});
		$("#sabunName").bind("keyup",function(event) {
			if (event.keyCode == 13) {
				doAction1("Search");
			}
		});

		if($("option", "#taxDocNoCd").size() > 0) {
			doAction1("Search");
		}
	});



	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchSbNm").val($("#searchKeyword").val());
			sheet1.DoSearch( "<%=jspPath%>/earnIncomeCreDataMgr/earnIncomeCreDataMgrRst.jsp?cmd=selectEarnIncomeCreDataMgrList", $("#sheetForm").serialize() );
			break;
		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>문서번호</span> <select id="taxDocNo" name="taxDocNo"> </select> </td>
						<td> <span>사업장</span> <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
						<td> <span>사번/성명</span> <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">생성대상자 정보(근로/퇴직)</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>