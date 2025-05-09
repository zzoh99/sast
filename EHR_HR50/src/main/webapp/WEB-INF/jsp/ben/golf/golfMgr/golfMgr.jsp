<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>골프장예약관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getComboList}).val("${curSysYyyyMMHyphen}-01");
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getComboList});
		var searchTo = getEndOfMonthDay(("${curSysYyyyMMHyphen}").split("-")[0], ("${curSysYyyyMMHyphen}").split("-")[1])
		searchTo = "${curSysYyyyMMHyphen}-"+searchTo;
		$("#searchTo").val(searchTo);
		
		$("#searchFrom, #searchTo").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
	
		$("#searchGolfCd, #searchStatusCd").on("change", function(e) {
			doAction1("Search");
		})
		
		
		
		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");


	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, FrozenColRight:4};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:1,				Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"신청일자|신청일자",		Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 			Format:"Ymd", Edit:0},
			//신청자정보
			{Header:"신청자|사번",			Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun",			Edit:0},
			{Header:"신청자|성명",			Type:"Text",   		Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"신청자|부서",			Type:"Text",   		Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"신청자|직책",			Type:"Text",   		Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"신청자|직위",			Type:"Text",   		Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"신청자|직급",			Type:"Text",   		Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			
			{Header:"신청정보|골프장",		Type:"Combo",		Hidden:0, Width:100,	Align:"Center",	ColMerge:0,	 SaveName:"golfCd",			Format:"",    Edit:0},
			{Header:"신청정보|예약일자",		Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"ymd", 			Format:"Ymd", Edit:0},
			{Header:"신청정보|희망시간대",	Type:"Date",   		Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"reqTimeSt", 		Format:"Hm", Edit:0},
			{Header:"신청정보|희망시간대",	Type:"Date",   		Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"reqTimeEd", 		Format:"Hm", Edit:0},
			{Header:"신청정보|사용자구분",	Type:"Combo",   	Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"userTypeCd",		Edit:0, ComboText:"본인|거래처", ComboCode:"0|1"},
			{Header:"신청정보|사용자명",		Type:"Text",   		Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"userNm", 		Edit:0},
			{Header:"신청정보|연락처",		Type:"Text",   		Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"phoneNo", 		Edit:0},
			{Header:"신청정보|메일주소",		Type:"Text",   		Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"mailId", 		Edit:0},
			{Header:"신청정보|기타요청사항",	Type:"Text",		Hidden:0, Width:250,	Align:"Left",	ColMerge:0,	 SaveName:"note",			Format:"",	  Edit:0},
			{Header:"신청정보|취소일자",		Type:"Text",		Hidden:0, Width:80,		Align:"Center",	ColMerge:0,	 SaveName:"cancelYmd",		Format:"Ymd", Edit:0},
			{Header:"신청정보|취소사유",		Type:"Text",		Hidden:0, Width:200,	Align:"Left",	ColMerge:0,	 SaveName:"cancelReason",	Format:"",	  Edit:0},
			
			{Header:"예약확정|예약상태",		Type:"Combo",		Hidden:0, Width:100,	Align:"Center",	ColMerge:0,	 SaveName:"statusCd",	Format:"",    Edit:1},
			{Header:"예약확정|확정시간",		Type:"Date",   		Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"confTime", Format:"Hm",  Edit:1, EditLen:5},
			{Header:"비고|비고",			Type:"Text",		Hidden:0, Width:250,	Align:"Left",	ColMerge:0,	 SaveName:"confNote",	Format:"",	  Edit:1},

			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"}
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetUseDefaultTime(0);


		//공통코드 한번에 조회
		getComboList();
		
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		let grpCds = "B51010,B51020";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");

		sheet1.SetColProperty("golfCd",  	{ComboText:"|"+codeLists["B51010"][0], ComboCode:"|"+codeLists["B51010"][1]} );
		sheet1.SetColProperty("statusCd",  	{ComboText:codeLists["B51020"][0], ComboCode:codeLists["B51020"][1]} );
	}

	function getComboList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		let grpCds = "B51010,B51020";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");

		$("#searchGolfCd").html(codeLists["B51010"][2]);
		$("#searchStatusCd").html(codeLists["B51020"][2]);
	}

	function chkInVal() {

		if ($("#searchFrom").val() == "" && $("#searchTo").val() != "") {
			alert('신청기간 시작일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() == "") {
			alert('신청기간 종료일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() != "") {
			if (!checkFromToDate($("#searchFrom"),$("#searchTo"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if(!chkInVal()){break;}
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/GolfMgr.do?cmd=getGolfMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/GolfMgr.do?cmd=saveGolfMgr", $("#sheet1Form").serialize());
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
			<th>예약일자</th>
			<td>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="">
			</td>
			<th>골프장 </th>
			<td>
				<select id="searchGolfCd" name="searchGolfCd"></select>
			</td>
			<th>예약상태 </th>
			<td>
				<select id="searchStatusCd" name="searchStatusCd"></select>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="button">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>

	<div class="sheet_title inner">
		<ul>
			<li class="txt">골프장예약관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
