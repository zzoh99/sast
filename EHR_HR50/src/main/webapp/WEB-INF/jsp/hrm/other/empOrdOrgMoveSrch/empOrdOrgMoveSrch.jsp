<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:4, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",  		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	MinWidth:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo"},
			//{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",   	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),MinWidth:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			//{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",   	Type:"${sSttTy}",	Hidden:0,					MinWidth:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },

			//{Header:"근무지코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:1,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			//{Header:"근무지",		Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:1,	SaveName:"locationNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			//{Header:"조직",		Type:"Text",	Hidden:1,	MinWidth:150,	Align:"Left",	ColMerge:1,	SaveName:"priorOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사진|사진",					Type:"Image",	Hidden:0,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photo",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"사번|사번",					Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명",					Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"현 소속 (현재일 기준)|소속코드",		Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"현 소속 (현재일 기준)|소속",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직책",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직위",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직급",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직무",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직구분",		Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"현 소속 (현재일 기준)|계약유형",		Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"현 소속 (현재일 기준)|재직상태",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"기준 소속 (기준일 기준)|소속코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|소속",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"stdOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|직책",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"stdJikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|직위",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"stdJikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|직급",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"stdJikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|직무",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"stdJobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|직구분",		Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|계약유형",	Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|재직상태",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"stdStatusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|발령시작일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|발령종료일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"이전 소속 (기준일 기준)|소속코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이전 소속 (기준일 기준)|소속",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"prevOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이전 소속 (기준일 기준)|직책",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"prevJikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이전 소속 (기준일 기준)|직위",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"prevJikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이전 소속 (기준일 기준)|직급",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"prevJikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이전 소속 (기준일 기준)|직무",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"prevJobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이전 소속 (기준일 기준)|직구분",		Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이전 소속 (기준일 기준)|계약유형",	Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이전 소속 (기준일 기준)|재직상태",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"prevStatusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이전 소속 (기준일 기준)|발령시작일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"prevSdate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이전 소속 (기준일 기준)|발령종료일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"prevEdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"이후 소속 (기준일 기준)|소속코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이후 소속 (기준일 기준)|소속",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"nextOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이후 소속 (기준일 기준)|직책",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"nextJikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이후 소속 (기준일 기준)|직위",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"nextJikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이후 소속 (기준일 기준)|직급",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"nextJikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이후 소속 (기준일 기준)|직무",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"nextJobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이후 소속 (기준일 기준)|직구분",		Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이후 소속 (기준일 기준)|계약유형",	Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이후 소속 (기준일 기준)|재직상태",	Type:"Combo",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"nextStatusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이후 소속 (기준일 기준)|발령시작일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"nextSdate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이후 소속 (기준일 기준)|발령종료일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"nextEdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
			
			];IBS_InitSheet(sheet1, initdata);
			sheet1.SetEditable(false);
			sheet1.SetCountPosition(4);
			sheet1.SetEditableColorDiff(0); //기본색상 출력
			sheet1.FitColWidth();
		
		getCommonCodeList();

		getStatusCd();
		
		$("#searchYmd").datepicker2({
			onReturn: getStatusCd
		});
		$("#sdate, #edate").datepicker2();

		$("#searchOrgNm, #searchSabunName").on("keyup", function(e) {
			if(e.keyCode == 13) {
				doAction("Search");
			}
		});

		$("#searchPhotoYn").on("click", function(e) {
			doAction("Search");
		});
		//$("#searchPhotoYn").attr('checked', 'checked');

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(60);

		$(window).smartresize(sheetResize);
		sheetInit();
		//doAction("Search");
	});

	function getStatusCd() {
		let baseSYmd = $("#searchYmd").val();
		// 재직상태
		var searchStatusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), "전체");
		$("#searchStatusCd").html(searchStatusCdList[2]);
		//$("#searchStatusCd").val("AA");
		$("#searchStatusCd").select2({
			//placeholder: "전체",
			maximumSelectionSize:100
		});
		$("#searchStatusCd").select2("val", ["AA","CA"]);
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchYmd").val();
		// 직책코드(H20020)
		var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020", baseSYmd), "");
		sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

		// 직위코드(H20030)
		var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd), "");
		sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

		// 직구분코드(H10050)
		var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd), "");
		sheet1.SetColProperty("workType", {ComboText:workType[0], ComboCode:workType[1]});

		// 직급코드(H20010)
		var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010", baseSYmd), " ");
		sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

		var jobCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getJobCdList",false).codeList, "");
		sheet1.SetColProperty("jobCd", {ComboText:"|"+jobCdList[0], ComboCode:"|"+jobCdList[1]});

		// 계약유형코드(H10030)
		var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd), "");
		sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

		// 재직상태코드(H10010)
		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), "");
		sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

		// 본사지점구분(W20050)
		var inoutType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20050", baseSYmd), "");
		sheet1.SetColProperty("inoutType", {ComboText:"|"+inoutType[0], ComboCode:"|"+inoutType[1]});

		// 조직구분(W20030)
		var objectType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20030", baseSYmd), "");
		sheet1.SetColProperty("objectType", {ComboText:"|"+objectType[0], ComboCode:"|"+objectType[1]});

		// 조직업무구분(W20070)
		var orgWorkCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20070", baseSYmd), "");
		sheet1.SetColProperty("orgWorkCd", {ComboText:"|"+orgWorkCd[0], ComboCode:"|"+orgWorkCd[1]});

		// 조직그룹분류(W20060)
		var groupTypeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20060", baseSYmd), "");
		sheet1.SetColProperty("groupTypeCd", {ComboText:"|"+groupTypeCd[0], ComboCode:"|"+groupTypeCd[1]});
	}

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			if($("#searchYmd").val() == "" ){
				alert("기준일자는 필수조회조건입니다.");
				break;
			}

			if($("#searchYmd").val() == "" && $("#searchOrgNm").val() == "" && $("#searchSabunName").val() == ""){
				alert("조회시 기준일자, 소속, 사번/성명중 하나는 입력 하셔야 합니다.");
				break;
			}
			$("#statusCd").val(($("#searchStatusCd").val()==null?"":getMultiSelect($("#searchStatusCd").val())));
			
			sheet1.DoSearch( "${ctx}/EmpOrdOrgMoveSrch.do?cmd=getEmpOrdOrgMoveSrchList", $("#empForm").serialize() ); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			var d = new Date();
			var fName = "이동발령이력조회_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if($("#searchPhotoYn").is(":checked") == true) {
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			} else {
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
				doAction("Search");}
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="empForm" name="empForm" >
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>기준일자</th>
							<td>
								<input id="searchYmd" name="searchYmd" maxlength="10" type="text" class="text date2 required" value="${curSysYyyyMMddHyphen}"/>
							</td>
							<th>발령기간</th>
							<td>
								<input id="sdate" name="sdate" maxlength="10" type="text" class="text date2" value=""/>
								~
								<input id="edate" name="edate" maxlength="10" type="text" class="text date2" value=""/>
							</td>
							<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
							<td>
								<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox" class="checkbox"/>
							</td>
						</tr>
						<tr>
							<th>소속</th>
							<td>
								<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" />
							</td>
							<th>사번/성명</th>
							<td>
								<input type="text" id="searchSabunName" name="searchSabunName" class="text" value="" />
							</td>
							<th>재직구분</th>
							<td>
								<select id="searchStatusCd" name="searchStatusCd" class="box" multiple></select>
								<input type="hidden" id="statusCd" name="statusCd"/>
							</td>
							<td>
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
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
								<li class="txt">이동발령이력조회</li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel')" 	css="btn outline-gray authA" mid='down2excel' mdef="다운로드"/>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>