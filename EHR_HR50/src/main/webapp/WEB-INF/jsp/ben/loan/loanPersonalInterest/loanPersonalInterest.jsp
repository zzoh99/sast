<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var ssnEnterCd = "${ssnEnterCd}"
	$(function() {

		$("#searchStdDate").datepicker2();

		// 대출구분항목
		var loanCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLoanCdList",false).codeList, "전체");
		$("#searchLoanCd").html(loanCd[2]);

		var initdata = {};
		initdata.Cfg = {FrozenCol:10,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelTy}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"신청서순번",	Type:"Text", 		Hidden:1, Width:80 , Align:"Center",	ColMerge:1,	SaveName:"applSeq",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
			{Header:"대출명",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"loanNm",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"대출코드",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"loanCd",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"sabun",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"소속",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMarge:0,	SaveName:"orgNm",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50},
			{Header:"시작일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"종료일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"대부이자율",	Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"interestRate",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:3,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"메모",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},
			{Header:"회사코드",	Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},

			{Header:"대출시작일",	Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"loanSYmd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},

			{Header:"신청서순번", 	Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:0,  SaveName:"applSeq" ,      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50}

		]; IBS_InitSheet( sheet1 , initdata );

		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetUnicodeByte(3);

		$(window).smartresize(sheetResize);
		sheetInit();

		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		doAction1("Search");
	});

	/**
	* Sheet 각종 처리
	*/
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/LoanPersonalInterest.do?cmd=getLoanPersonalInterest", $("#srchFrm").serialize() );
				break;
			case "Save":		//저장
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/LoanPersonalInterest.do?cmd=saveLoanPersonalInterest", $("#srchFrm").serialize());
				break;
			case "Insert":		//입력

				var Row = sheet1.DataInsert(0);

				sheet1.SelectCell(Row, "name");
				break;
			case "Copy":		//행복사

				var Row = sheet1.DataCopy();

				sheet1.SelectCell(Row, "name");
				break;
			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenImgSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {

			if (Msg != "") {
				alert(Msg);
			}

			doAction1("Search");

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 체크 되기 직전 발생.
 	function sheet1_OnBeforeCheck(Row, Col) {
		try{

	        if(sheet1.GetCellValue(Row, "sdate") == sheet1.GetCellValue(Row, "loanSYmd")) {
	        	sheet1.SetAllowCheck(true);
	        }else{
	            alert("대출 시작일의 대출이자율 자료는 삭제 할 수 없습니다.");
	            sheet1.SetAllowCheck(false);
	        }

		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>대출구분</th>
						<td>
							<select id="searchLoanCd" name="searchLoanCd" onChange="javascript:doAction1('Search')" class="box"> </select>
						</td>
						<th>소속</th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
						</td>
						<th>사번/성명</th>
						<td>
							<input id="searchName" name="searchName" type="text" class="text" />
						</td>
						<th>기준일자</th>
						<td>
							<input type="text" id="searchStdDate" name="searchStdDate" class="date2" /> </td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">개인별 대부이자율 관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Copy')" 			class="basic authA">입력</a>
								<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>