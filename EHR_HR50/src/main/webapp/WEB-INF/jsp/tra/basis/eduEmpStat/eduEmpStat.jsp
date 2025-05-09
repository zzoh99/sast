<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>", Type:"${sNoTy}", Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}", Align:"Center", ColMerge:0, SaveName:"sNo" },
			
			{Header:"과정ID",				Type:"Text",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"eduCourseCd",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",				Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"회차ID",				Type:"Text",	Hidden:1,	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"eduEventSeq",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduEventNm' mdef='회차명'/>",				Type:"Text",	Hidden:1,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"eduEventNm",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduSYmdV1' mdef='교육시작일'/>",			Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",			KeyField:0,	Format:"Ymd",	PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduEYmdV1' mdef='교육종료일'/>",			Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",			KeyField:0,	Format:"Ymd",	PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"eduOrgNm",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduMethodCd' mdef='시행방법'/>",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduMethodNm",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduBranchNm",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduMBranchCd' mdef='교육분류'/>",				Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"eduMBranchNm",	KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>",				Type:"Text",	Hidden:1,	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"mandatoryYn",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='inOutTypeV1' mdef='사내외구분'/>",			Type:"Text",	Hidden:0,	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"inOutTypeNm",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduHourV4' mdef='총시간'/>",				Type:"Text",	Hidden:0,	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"eduHour",			KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"교육비용",				Type:"Int",		Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"perExpenseMon",	KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='laborApplyYnV3' mdef='고용보험\n환급여부'/>",	Type:"Text",	Hidden:0,	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"laborApplyYn",	KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='laborMon' mdef='환급금액'/>",				Type:"Int",		Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"laborMon",		KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"교육인원",				Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"cnt",				KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10},
			{Header:"<sht:txt mid='eduCost' mdef='실교육비'/>",				Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"realExpenseMon",	KeyField:0,	Format:"",		PointCount:0, UpdateEdit:0,	InsertEdit:10}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		sheet1.SetCountPosition(0);

		$(window).smartresize(sheetResize); sheetInit();


		$("#searchSYmd").datepicker2({startdate:"searchEYmd", onReturn: getCommonCodeList});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd", onReturn: getCommonCodeList});

		$("#searchSYmd, #searchEYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchEduBranchCd, #searchEduMBanchCd, #searchEduMethodCd, #searchInOutType").bind("change",function(event){
			doAction1("Search");
		});


		getCommonCodeList();
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchSYmd").val();
		let baseEYmd = $("#searchEYmd").val();

		//------------------------------------- 조회조건 콤보 -------------------------------------//
		// 교육구분(L10010)
		const eduBranchCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10010", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchEduBranchCd").html(eduBranchCd[2]);

		// 교육분류(L10015)
		const eduMBanchCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10015", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchEduMBanchCd").html(eduMBanchCd[2]);

		// 시행방법(L10050)
		const eduMethodCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10050", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchEduMethodCd").html(eduMethodCd[2]);

		// 사내외구분(L20020)
		const inOutType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "L20020", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchInOutType").html(inOutType[2]);

		const mandatory 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20030", baseSYmd, baseEYmd), ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All")); //필수여부   res3
		$("#searchMandatory").html(mandatory[2]);
	}


	function chkInVal() {

		if ($("#searchSYmd").val() == "" && $("#searchEYmd").val() != "") {
			alert("<msg:txt mid='110391' mdef='교육시작일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchSYmd").val() != "" && $("#searchEYmd").val() == "") {
			alert("<msg:txt mid='110256' mdef='교육종료일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchSYmd").val() != "" && $("#searchEYmd").val() != "") {
			if (!checkFromToDate($("#searchSYmd"),$("#searchEYmd"),"교육일","교육일","YYYYMMDD")) {
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
			if($("#mandatory").prop("checked")) {
				$("#searchMandatoryYn").val("Y");
			} else {
				$("#searchMandatoryYn").val("N");
			}
			
			sheet1.DoSearch( "${ctx}/EduEmpStat.do?cmd=getEduEmpStatList", $("#sheet1Form").serialize() ); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>교육일</th>
						<td>
							<input id="searchSYmd" name ="searchSYmd" type="text" class="date2" value="${curSysYear}-01-01"/> ~
							<input id="searchEYmd" name ="searchEYmd" type="text" class="date2" value="${curSysYear}-12-31"/>
						</td>
						<th><tit:txt mid='104566' mdef='교육구분'/></th>
						<td>
							<select id="searchEduBranchCd" name="searchEduBranchCd"></select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='eduMBranchPopV1' mdef='교육분류'/></th>
						<td>
							<select id="searchEduMBanchCd" name="searchEduMBanchCd"></select>
						</td>
						<th><tit:txt mid='112703' mdef='시행방법'/></th>
						<td>
							<select id="searchEduMethodCd" name="searchEduMethodCd"></select>
						</td>
						<th>사내외구분</th>
						<td>
							<select id="searchInOutType" name="searchInOutType"></select>
						</td>
						<th class="hide"><tit:txt mid='201705040000019' mdef='필수여부'/></th>
						<td class="hide">
							<select id="searchMandatory" name="searchMandatory"></select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="btn dark" mid="110697" mdef="조회"/>
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
							<li id="txt" class="txt">과정별수강인원현황</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" css="btn outline-gray authR" mid="110698" mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>
