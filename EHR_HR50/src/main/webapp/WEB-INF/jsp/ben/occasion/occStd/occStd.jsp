<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>경조기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//기준일자 날짜형식, 날짜선택 시
		$("#searchYmd").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});

		//직군구분코드 선택 시
		$("#searchWorkType").on("change", function(e) {
			doAction1("Search");
		});


		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");


	});

	//Sheet 초기화
	function init_sheet1(){
		var kf = 1;
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

<c:if test="${authPg == 'R' }">
		kf = 0;
</c:if>
		initdata1.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"직군구분|직군구분",				Type:"Combo",		Hidden:0,				Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workType",		KeyField:kf,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"경조구분|경조구분",				Type:"Combo",		Hidden:0,				Width:100,	Align:"Center",	ColMerge:0,	SaveName:"occCd",			KeyField:kf,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"가족구분|가족구분",				Type:"Combo",		Hidden:0,				Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famCd",			KeyField:kf,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },

			{Header:"경조금|경조금",				Type:"Int",			Hidden:0,				Width:80,	Align:"Right",	ColMerge:0,	SaveName:"occMon",			KeyField:0,	Format:"#,###\\원",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"휴가일수\n(영업일기준)|휴가일수\n(영업일기준)",
												Type:"Int",			Hidden:0,				Width:60,	Align:"Center",	ColMerge:0,	SaveName:"occHoliday",		KeyField:0,	Format:"##\\일",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 },
			{Header:"근속월수|근속월수",				Type:"Int",			Hidden:0,				Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workMonth",		KeyField:0,	Format:"##\\개월이상",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 },
			{Header:"지원물품|꽃바구니",				Type:"CheckBox",	Hidden:0,				Width:60,	Align:"Center",	ColMerge:0,	SaveName:"flowerBasketYn",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"지원물품|경조화환",				Type:"CheckBox",	Hidden:0,				Width:60,	Align:"Center",	ColMerge:0,	SaveName:"wreathYn",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"지원물품|상조용품",				Type:"CheckBox",	Hidden:0,				Width:60,	Align:"Center",	ColMerge:0,	SaveName:"outfitYn",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"지원물품|상조깃발",				Type:"CheckBox",	Hidden:1,				Width:60,	Align:"Center",	ColMerge:0,	SaveName:"giftYn",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },

			{Header:"중복체크\n여부|중복체크\n여부",	Type:"CheckBox",	 Hidden:"${sDelHdn}",	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dupChkYn",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"사용\n여부|사용\n여부",			Type:"CheckBox",	Hidden:"${sDelHdn}",	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"시작일|시작일",				Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"occSdate",		KeyField:kf,Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1, EndDateCol:"occEdate"},
			{Header:"종료일|종료일",				Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"occEdate",		KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1, StartDateCol:"occSdate"},
			{Header:"증빙서류|증빙서류",				Type:"Text",		Hidden:0, 				Width:150,  Align:"Left",	ColMerge:0,	SaveName:"evidenceDoc",		KeyField:0,	Format:"", 				PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"참고사항\n(근태신청시 사용)|참고사항\n(근태신청시 사용)",
												Type:"Text",		Hidden:0,				Width:250,	Align:"Left",	ColMerge:0,	SaveName:"timAppDesc",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고|비고",					Type:"Text",		Hidden:0,				Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 }

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 직군구분상태
		getComboList();
<c:if test="${authPg == 'R' }">
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
</c:if>
	}

	function getComboList() {
		let grpCds = "H10050";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		$("#searchWorkType").html(codeLists["H10050"][2]);
	}
	function getCommonCodeList() {
		//공통코드 한번에 조회
		var grpCds = "B60020,B60030,H10050";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		sheet1.SetColProperty("occCd",  	{ComboText:"|"+codeLists["B60020"][0], ComboCode:"|"+codeLists["B60020"][1]} ); //경조구분
		sheet1.SetColProperty("famCd",  	{ComboText:"|"+codeLists["B60030"][0], ComboCode:"|"+codeLists["B60030"][1]} ); //가족구분
		sheet1.SetColProperty("workType",  	{ComboText:"|"+codeLists["H10050"][0], ComboCode:"|"+codeLists["H10050"][1]} ); //직군구분
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "occEdate") != null && sheet1.GetCellValue(i, "occEdate") != "") {
					var occSdate = sheet1.GetCellValue(i, "occSdate");
					var occEdate = sheet1.GetCellValue(i, "occEdate");
					if (parseInt(occSdate) > parseInt(occEdate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "occEdate");
						return false;
					}
				}
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/OccStd.do?cmd=getOccStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal()){break;}
				if(!dupChk(sheet1,"workType|occCd|famCd|occSdate", true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/OccStd.do?cmd=saveOccStd", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "useYn", "Y");
				sheet1.SetCellValue(row, "dupChkYn", "Y");
				break;
			case "Copy":
				var row = sheet1.DataCopy();
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
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sheet1Form" id="sheet1Form" method="post">
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준일자</th>
			<td>
				<input type="text" id="searchYmd" name="searchYmd" class="date2" value="${curSysYyyyMMddHyphen}"/>
			</td>
<c:if test="${ssnGrpCd != '99' }">
			<th>직군구분</th>
			<td>
				<select id="searchWorkType" name="searchWorkType"></select>
			</td>
</c:if>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>

	<div class="sheet_title inner">
		<ul>
			<li class="txt">경조기준관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
