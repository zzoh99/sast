<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>자원예약관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getCommonCodeList}).val("${curSysYyyyMMHyphen}-01");
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getCommonCodeList});
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
		
		$("#searchResTypeCd, #searchResLocationCd").change(function() {
			setResSeqCombo();
			doAction1("Search");
		});

		$("#searchResSeq").change(function() {
			doAction1("Search");
		});
		
		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");


	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
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
			
			{Header:"신청정보|자원종류",		Type:"Combo",		Hidden:0, Width:100,	Align:"Center",	ColMerge:0,	 SaveName:"resTypeCd",			Format:"",    Edit:0},
			{Header:"신청정보|장소",		Type:"Combo",		Hidden:0, Width:100,	Align:"Center",	ColMerge:0,	 SaveName:"resLocationCd",		Format:"",    Edit:0},
			{Header:"신청정보|자원명",		Type:"Text",		Hidden:0, Width:100,	Align:"Center",	ColMerge:0,	 SaveName:"resNm",			Format:"",    Edit:0},
			{Header:"신청정보|시작일자",		Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sYmd", 			Format:"Ymd", Edit:0},
			{Header:"신청정보|종료일자",		Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"eYmd", 			Format:"Ymd", Edit:0},
			{Header:"신청정보|하루종일",		Type:"Text",   		Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"dayYn", 			Edit:0},
			{Header:"신청정보|시작시간",		Type:"Date",   		Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"sTime", 			Format:"Hm", Edit:0},
			{Header:"신청정보|종료시간",		Type:"Date",   		Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"eTime", 			Format:"Hm", Edit:0},
			{Header:"신청정보|제목",		Type:"Text",   		Hidden:0, Width:150, 	Align:"Left",   ColMerge:0,  SaveName:"title", 			Edit:0},
			{Header:"신청정보|내용",		Type:"Text",   		Hidden:1, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"contents", 		Edit:0},
			{Header:"신청정보|메일주소",		Type:"Text",   		Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"mailId", 		Edit:0},
			{Header:"신청정보|연락처",		Type:"Text",   		Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"phoneNo", 		Edit:0},
			

			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"}
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetUseDefaultTime(0);

		getCommonCodeList();
	    setResSeqCombo();
		
	}
	function getCommonCodeList() {
		//공통코드 한번에 조회
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		let grpCds = "B52010,B52020";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		sheet1.SetColProperty("resTypeCd",  		{ComboText:"|"+codeLists["B52010"][0], ComboCode:"|"+codeLists["B52010"][1]} );
		sheet1.SetColProperty("resLocationCd",  	{ComboText:codeLists["B52020"][0], ComboCode:codeLists["B52020"][1]} );
		$("#searchResTypeCd").html(codeLists["B52010"][2]);//자원종류
		$("#searchResLocationCd").html(codeLists["B52020"][2]); //자원위치
	}
    function setResSeqCombo(){
		//자원명
        var reqParam ="&searchResTypeCd="+$("#searchResTypeCd").val()
                     +"&searchResLocationCd="+$("#searchResLocationCd").val();
	    var resSeqList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReservationAppResCdList"+reqParam,false).codeList
                        , "note,resTypeNm,resLocationNm", "");

        $("#searchResSeq").html(resSeqList[2]);

        $("#searchResSeq").html("<option value=''>전체</option>"+resSeqList[2]);
        $("#searchResSeq").change();
    }
	
	function chkInVal() {

		if ($("#searchFrom").val() == "") {
			alert("<msg:txt mid='110391' mdef='예약 시작일 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchTo").val() == "") {
			alert("<msg:txt mid='110256' mdef='예약 시작일 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() != "") {
			if (!checkFromToDate($("#searchFrom"),$("#searchTo"),"예약일","예약일","YYYYMMDD")) {
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
				sheet1.DoSearch( "${ctx}/ReservationMgr.do?cmd=getReservationMgrList", $("#sheet1Form").serialize() );
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
			<th>자원종류 </th>
			<td>
				<select id="searchResTypeCd" name="searchResTypeCd"></select>
			</td>
			<th>장소</th>
			<td>
				<select id="searchResLocationCd" name="searchResLocationCd"></select>
			</td>
			<th>자원명</th>
			<td>
				<select id="searchResSeq" name="searchResSeq"></select>
			</td>
			<td><a href="javascript:doAction1('Search')" class="btn dark">조회</a></td>
		</tr>
		</table>
	</div>
	</form>

	<div class="sheet_title inner">
		<ul>
			<li class="txt">자원예약관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
