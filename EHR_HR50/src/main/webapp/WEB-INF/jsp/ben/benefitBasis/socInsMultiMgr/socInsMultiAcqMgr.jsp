<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
<title><tit:txt mid='2017091901156' mdef='통합취득신고관리' /></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly, FrozenCol:10};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },

			{Header:"<sht:txt mid='checkV1' mdef='선택|선택'/>",		Type:"DummyCheck",	Align:"Center",	Width:"60",	SaveName:"sCheck" },

			{Header:"가입자정보|주민등록번호",	Type:"Text",	Align:"Center",	Width:"120",	Edit:0,	SaveName:"resNo",	Format:"IdNo" },
			{Header:"가입자정보|사번",			Type:"Text",	Align:"Center",	Width:"100",	Edit:0,	SaveName:"sabun" },
			{Header:"가입자정보|성명",			Type:"Text",	Align:"Center",	Width:"100",	Edit:0,	SaveName:"name" },
			{Header:"가입자정보|입사일",		Type:"Date",	Align:"Center",	Width:"90",		Edit:0,	SaveName:"empYmd" },
			{Header:"가입자정보|신고여부",		Type:"Combo",	Align:"Center",	Width:"60",				SaveName:"reportAcqYn" },
			{Header:"가입자정보|신고일자",		Type:"Date",	Align:"Center",	Width:"100",			SaveName:"reportAcqYmd" },

			{Header:"국민연금|소득월액",		Type:"Int",		Align:"Right",	Width:"90",		Edit:0,	SaveName:"npsRewardTotMon",	Format:"Integer" },
			{Header:"국민연금|자격취득일",		Type:"Date",	Align:"Center",	Width:"100",	Edit:1,	SaveName:"nspAcqYmd",		KeyField:1 },
			{Header:"국민연금|취득월\n납부여부",	Type:"Text",	Align:"Center",	Width:"60",		Edit:0,	SaveName:"acqYn" },
			{Header:"국민연금|자격취득부호",		Type:"Combo",	Align:"Center",	Width:"150",	Edit:1,	SaveName:"nspAcqReasonCd",	KeyField:1 },
			{Header:"국민연금|자격취득부호",		Type:"Text",	Align:"Center",	Width:"120",	Edit:0,	SaveName:"nspAcqReasonCdExcel",	Hidden:1 },

			{Header:"건강보험|보수월액",		Type:"Int",		Align:"Right",	Width:"90",		Edit:0,	SaveName:"nhsRewardTotMon",	Format:"Integer" },
			{Header:"건강보험|자격취득일",		Type:"Date",	Align:"Center",	Width:"100",	Edit:1,	SaveName:"nhsAcqYmd",		KeyField:1 },
			{Header:"건강보험|자격취득부호",		Type:"Combo",	Align:"Center",	Width:"120",	Edit:1,	SaveName:"nhsAcqReasonCd",	KeyField:1 },
			{Header:"건강보험|자격취득부호",		Type:"Text",	Align:"Center",	Width:"100",	Edit:0,	SaveName:"nhsAcqReasonCdExcel",	Hidden:1 },

			{Header:"고용보험|월평균보수",		Type:"Int",		Align:"Right",	Width:"90",		Edit:0,	SaveName:"ieiRewardTotMon",	Format:"Integer" },
			{Header:"고용보험|자격취득일",		Type:"Date",	Align:"Center",	Width:"100",	Edit:1,	SaveName:"ieiAcqYmd",	KeyField:1 },
			{Header:"고용보험|직종",			Type:"Combo",	Align:"Left",	Width:"180",	Edit:1,	SaveName:"jikjongCd",	KeyField:1 },
			{Header:"고용보험|직종",			Type:"Text",	Align:"Center",	Width:"60",		Edit:0,	SaveName:"jikjongCdExcel",	Hidden:1 },
			{Header:"고용보험|주소정\n근로시간",	Type:"Int",		Align:"Center",	Width:"60",		Edit:1,	SaveName:"fixTime",			Format:"Integer",	KeyField:1,		EditLen:2 }
		]; IBS_InitSheet(mySheet1, initdata); mySheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize);
		sheetInit();

		// 여부코드(S90005)
		var acqYn = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S90005"), "");
		$("#searchAcqYn").html(acqYn[2]);
		mySheet1.SetColProperty("reportAcqYn", {ComboText:"|"+acqYn[0], ComboCode:"|"+acqYn[1]});

		// 국민연금 자격취득부호(B10030)
		var nspAcqReasonCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10030"), "");
		mySheet1.SetColProperty("nspAcqReasonCd", {ComboText:"|"+nspAcqReasonCd[0], ComboCode:"|"+nspAcqReasonCd[1]});

		// 건강보험 자격취득부호(B10010)
		var nhsAcqReasonCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10010"), "");
		mySheet1.SetColProperty("nhsAcqReasonCd", {ComboText:"|"+nhsAcqReasonCd[0], ComboCode:"|"+nhsAcqReasonCd[1]});

		// 직종코드(B10330)
		var jikjongCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y", "B10330"), "");
		mySheet1.SetColProperty("jikjongCd", {ComboText:"|"+jikjongCd[0], ComboCode:"|"+jikjongCd[1]});

		$("#searchStaYmd").val("${curSysYyyyMMHyphen}" + "-01");
		$("#searchEndYmd, #reportAcqYmd").val("${curSysYyyyMMdd}");

		$("#searchStaYmd").datepicker2({startdate:"searchEndYmd"});
		$("#searchEndYmd").datepicker2({enddate:"searchStaYmd"});
		$("#reportAcqYmd").datepicker2();

		$( "#searchKeyword" ).bind("focusout",function(event){
			if( $(this).val() == "" ){
				$( "#searchUserId" ).val( "" );
			}
		});
	});

	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				mySheet1.DoSearch( "${ctx}/SocInsMultiMgr.do?cmd=getSocInsMultiAcqMgr", $("#empForm").serialize() );
				break;

			case "Save":
				IBS_SaveName(document.empForm, mySheet1);
				mySheet1.DoSave( "${ctx}/SocInsMultiMgr.do?cmd=saveSocInsMultiAcqMgr", $("#empForm").serialize());
				break;

			case "Down2Excel":
				//var downcol = makeHiddenSkipCol(mySheet1);
				var _cols = "sDelete|sStatus|sCheck|nspAcqReasonCd|nhsAcqReasonCd|jikjongCd";
				var colsArr = _cols.split("|");
				var _skipCols = "";

				for(idx=0; idx<colsArr.length; idx++){
					_skipCols += mySheet1.SaveNameCol( colsArr[idx] ) + "|";
				}

				var downcol = makeSkipCol(mySheet1, _skipCols);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				mySheet1.Down2Excel(param);
				break;
		}
	}

	// 조회 후 에러 메시지
	function mySheet1_OnSearchEnd(Code, Msg, StCode, StMsg){
		try {
			if (Msg != "") {
				alert(Msg);
			}

			// 신고여부 Y인 경우 수정 불가
			for(var i = mySheet1.HeaderRows(); i <= mySheet1.LastRow(); i++) {
				var _reportAcqYn = mySheet1.GetCellValue(i, "reportAcqYn");

				if( _reportAcqYn == "Y" ){
					mySheet1.SetRowEditable(i, false);
				}
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function mySheet1_OnSaveEnd(Code, Msg, StCode, StMsg){
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 사유코드 변경 시 엑셀 다운로드 용 컬럼 정의
	function mySheet1_OnChange(Row, Col, Value){
		try {
			var sSaveName = mySheet1.ColSaveName(Col);

			if( sSaveName == "nspAcqReasonCd" || sSaveName == "nhsAcqReasonCd" || sSaveName == "jikjongCd" ){
				mySheet1.SetCellValue( Row, sSaveName + "Excel", Value );
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}


	// 신고일 일괄적용
	function setAcqYmd(){
		var _ymd = $("#reportAcqYmd").val();
		var sRow = mySheet1.FindCheckedRow("sCheck");

		if( _ymd == "" ){
			alert("신고일자를 입력해주세요.");
			$("#reportAcqYmd").focus();
			return false;
		}

		if(sRow == "" ){
			alert( "선택된 행이 없습니다." );
			return false;
		} else {
			var arrRow = sRow.split("|");

			for(idx=0; idx<arrRow.length; idx++){
				var _row = arrRow[idx];
				mySheet1.SetCellValue( _row, "reportAcqYn", "Y" );
				mySheet1.SetCellValue( _row, "reportAcqYmd", _ymd );
			}
		}
	}

	// 사원찾기 후
	function setEmpPage(){

	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
	<form name="empForm" id="empForm" method="post">
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th>신고여부</th>
					<td>
						<select id="searchAcqYn" name="searchAcqYn">
						</select>
					</td>
					<th>신고일자</th>
					<td>
						<input id="searchStaYmd" name="searchStaYmd" type="text" size="10" class="date2 required" value="" /> ~
						<input id="searchEndYmd" name="searchEndYmd" type="text" size="10" class="date2 required" value="" />
					</td>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td>
						<input type="text"   id="searchKeyword" name="searchKeyword" class="text" style="ime-mode:active" />
						<input type="hidden" id="searchUserId" name="searchUserId" value="" />

						<input type="hidden" id="searchEmpType" name="searchEmpType" value="I" /> <!-- Include에서  사용 -->
						<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" /> <!-- in ret -->
					</td>

					<td>
						<btn:a href="javascript:doAction1('Search')" css="button" mid='search' mdef="조회" />
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
					<ul style="padding-bottom: 7px;">
						<li class="txt">통합취득신고관리</li>
						<li class="btn">
							신고일자
							<input id="reportAcqYmd" name="reportAcqYmd" type="text" size="10" class="date2 required" value="" />
							<btn:a href="javascript:setAcqYmd();" css="button" mid='' mdef="신고일 일괄적용"/>

							<btn:a href="javascript:doAction1('Save')" css="basic" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction1('Down2Excel')" css="basic" mid='110698' mdef="다운로드"/>
						</li>
					</ul>
					</div>
				</div>

				<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	</div>
</body>
</html>
