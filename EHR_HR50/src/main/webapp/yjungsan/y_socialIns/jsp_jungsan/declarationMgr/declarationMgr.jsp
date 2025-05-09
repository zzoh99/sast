<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>사회보험신고항목관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%
	String setDeclarationOrgCd = request.getParameter("setDeclarationOrgCd");
	String searchDeclarationOrgCdHide = "";

	if( setDeclarationOrgCd == null ) {
		setDeclarationOrgCd = "";
	} else {
		searchDeclarationOrgCdHide = "hide";
	}

%>
<!-- 직원조회 자동완성 관련 추가 삽입 -->
<style type="text/css">
	a.autocomplete {display:block; border-bottom:1px dashed #b8c6cc;}
	a.autocomplete span {white-space:nowrap; text-overflow:ellipsis; overflow:hidden; display:inline-block;color:#666;padding-left:8px}
</style>
<script src="<%=jspPath%>/common/js/empAutoComplete.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<!-- // 직원조회 자동완성 관련 추가 삽입 -->
<script type="text/javascript">

	var defaultDeclarationOrgCd = "<%=removeXSS(setDeclarationOrgCd, '1')%>";

	var colEleData       = null;
	var sheet2_name_col  = "";
	var sheet2_resno_col = "";
	var sheet2_seq_col   = "";
	var exportDownCols   = "";

	$(function() {

		// 기관구분 코드 조회
		var declarationOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","BD0001"), "전체");
		// 신고유형 코드 조회
		var declarationTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","BD0002"), "전체");

		// 조회영역 > 기관구분 option 삽입
		$("#searchDeclarationOrgCd").html(declarationOrgCdList[2]);
		if(defaultDeclarationOrgCd != "") {
			$("#searchDeclarationOrgCd").val(defaultDeclarationOrgCd);
		}

		// 조회영역 > 신고유형 option 삽입
		$("#searchDeclarationType").html(declarationTypeList[2]);

		$("#searchDeclarationOrgCd, #searchDeclarationType").change(function(){
			doAction1("Search");
		});
		$("#searchDeclarationTargetYear, #searchDeclarationTargetMonth").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			} else {
				makeNumber(this,'A');
			}
		});

		// 1번 그리드
		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata0.Cols = [
				{Header:"No|No",		Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제|삭제",		Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,	SaveName:"sDelete" , Sort:0},
				{Header:"상태|상태",		Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,	SaveName:"sStatus" , Sort:0},

				{Header:"신고서|기관구분",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_org_cd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"신고서|신고유형",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_type",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"신고일|신고일",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"target_ymd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"사업장|사업장",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"기간|시작일",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",				KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"기간|종료일",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",				KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"비고|비고",			Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"note",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
				{Header:"항목등록수",			Type:"Int",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"ele_cnt",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		];
		IBS_InitSheet(sheet1, initdata0); sheet1.SetCountPosition(4);

		// sheet1 Combo Set
		sheet1.SetColProperty("declaration_org_cd",	{ComboText:declarationOrgCdList[0], ComboCode:declarationOrgCdList[1]} );
		sheet1.SetColProperty("declaration_type",	{ComboText:declarationTypeList[0], ComboCode:declarationTypeList[1]} );

		var businessPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList"), "");
		sheet1.SetColProperty("business_place_cd",		{ComboText:businessPlaceCdList[0], ComboCode:businessPlaceCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	// 대상자 시트 컬럼 재정의
	function initTarget(Row) {

		// 컬럼 정보 조회
		var params  = "declaration_org_cd="+sheet1.GetCellValue(Row, "declaration_org_cd");
			params += "&declaration_type="+sheet1.GetCellValue(Row, "declaration_type");
			params += "&target_ymd="+sheet1.GetCellValue(Row, "target_ymd");

		exportDownCols = "";
		sheet2_seq_col = "";

		// 신고서 항목 데이터 조회
		colEleData = ajaxCall( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=getDeclarationMgrEleList", params, false );
		//console.log('colEleData', colEleData);

		if( colEleData != null && colEleData != undefined && colEleData.Data != null && colEleData.Data != undefined && colEleData.Data.length > 0 ) {

			var item             = null;
			var colItem          = null;
			var addColsForFrozen = [];
			var addCols          = [];

			var colType     = "";
			var colHidden   = 0;
			var colWidth    = 0;
			var colAlign    = "";
			var colSaveName = "";
			var colFormat   = "";
			var colEdit     = 1;
			var mappingCds  = [];

			var headerRowCntResult = null;
			var maxHeaderRows = 0;
			var sumColWidth = 0;
			var colWidths  = [];

			// 입력항목 전체 너비 계산
			for(var i = 0; i < colEleData.Data.length; i++) {
				item = colEleData.Data[i];
				// 컬럼 너비 조정
				colWidth = (parseInt(item.element_nm.length) * 10) * 1.15;
				if(colWidth < 90) {
					colWidth = 80;
				}

				colWidths.push(colWidth);

				// 입력항목타입 성명, 주민번호, 순번, 고정값은 제외
				if(item.element_type != "NAME" && item.element_type != "RESNO" && item.element_type != "SEQ" && item.element_type != "FIX_VALUE") {
					sumColWidth += colWidth;
				}
			}
			//alert(sumColWidth);

			// resize col width
			var isChangeWidth = false;
			var adjsutWidth = 0;
			if( (parseInt(sheet1.GetSheetWidth()) - 215) > sumColWidth ) {
				isChangeWidth = true;
				adjsutWidth = Math.round((parseInt(sheet1.GetSheetWidth()) - 215 - sumColWidth) / (colEleData.Data.length - 2));
			}
			//alert(isChangeWidth + "/" + adjsutWidth);

			for(var i = 0; i < colEleData.Data.length; i++) {
				item =  colEleData.Data[i];

				colAlign = "Center";
				colSaveName = "ele_" + item.display_seq;
				colFormat = "";
				colHidden = 0;
				colEdit = 1;

				if(colEleData.Data.length > 15) {
					colWidth = colWidths[i] + adjsutWidth;
				} else {
					colWidth = 120;
				}

				if(item.element_type == "CHAR") {
					colType = "Text";
				} else if(item.element_type == "NUMBER") {
					colType = "Int";
					colAlign = "Right";
				} else if(item.element_type == "SEQ") {
					colType = "Int";
					colHidden = 1;
					colAlign = "Right";
					colEdit = 0;
					sheet2_seq_col = colSaveName;
				} else if(item.element_type == "DATE") {
					colType = "Date";
					colFormat = "Ymd";
				} else if(item.element_type == "DATE_YM") {
					colType = "Date";
					colFormat = "Ym";
				} else if(item.element_type == "COMBO") {
					colType = "Combo";
					mappingCds.push({
						saveName : colSaveName,
						grcode   : item.mapping_cd
					});
				} else if(item.element_type == "FIX_VALUE") {
					colType = "Text";
					colHidden = 1;
					colEdit = 0;
				} else if(item.element_type == "NAME") {
					colType = "Text";
					colWidth = 100;
					sheet2_name_col = colSaveName;
				} else if(item.element_type == "RESNO") {
					colType = "Text";
					colWidth = 120;
					colFormat = "IdNo";
					sheet2_resno_col = colSaveName;
				}

				// set col property
				colItem = {
						Header     : item.element_nm,
						Type       : colType,
						Hidden     : colHidden,
						Width      : colWidth,
						Align      : colAlign,
						ColMerge   : 0,
						SaveName   : colSaveName,
						KeyField   : (item.element_required_yn == "Y") ? 1 : 0,
						CalcLogic  : "",
						Format     : colFormat,
						PointCount : 0,
						UpdateEdit : colEdit,
						InsertEdit : colEdit,
						EditLen    : item.element_length
				};
				addCols.push(colItem);

				if( exportDownCols != "" ) {
					exportDownCols += "|";
				}

				if( item.edi_export_yn == "Y" ) {
					exportDownCols += colSaveName;
				}

				// 헤더 Row 수 계산
				headerRowCntResult = item.element_nm.match(/\|/g);

				if( headerRowCntResult != null ) {
					if(maxHeaderRows < headerRowCntResult.length) {
						maxHeaderRows = headerRowCntResult.length;
					}
				}
			}
			maxHeaderRows++;

			//초기 상태로 변경하기
			sheet2.Reset();

			var frozenColCnt = 7 + addColsForFrozen.length;

			// 2번 그리드
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:frozenColCnt};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
			initdata.Cols = [
				{Header:parseColTitle("No", maxHeaderRows),				Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:parseColTitle("삭제", maxHeaderRows),			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,	SaveName:"sDelete" , Sort:0},
				{Header:parseColTitle("상태", maxHeaderRows),			Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,	SaveName:"sStatus" , Sort:0},
				{Header:parseColTitle("기관구분", maxHeaderRows),			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_org_cd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:parseColTitle("신고유형", maxHeaderRows),			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declaration_type",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:parseColTitle("신고일", maxHeaderRows),			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"target_ymd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:parseColTitle("사번", maxHeaderRows),			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:parseColTitle("소속", maxHeaderRows),			Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"org_nm",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:parseColTitle("직급", maxHeaderRows),			Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jikgub_nm",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:parseColTitle("직무", maxHeaderRows),			Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"job_nm",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
			];

			// 고용보험의 경우 신고서 항목에 성명항목이 없어 성명항목이 없는 경우 자동으로 컬럼 추가함.
			if(sheet2_name_col == "") {
				sheet2_name_col = "name";
				initdata.Cols.push({
					Header     : parseColTitle("성명", maxHeaderRows),
					Type       : "Popup",
					Hidden     : 0,
					Width      : 80,
					Align      : "Center",
					ColMerge   : 0,
					SaveName   : sheet2_name_col,
					KeyField   : 0,
					CalcLogic  : "",
					Format     : "",
					PointCount : 0,
					UpdateEdit : 1,
					InsertEdit : 1,
					EditLen    : 100
				});
			}

			// add cols
			for(var idx = 0; idx < addColsForFrozen.length; idx++) {
				initdata.Cols.push(addColsForFrozen[idx]);
			}

			// add cols
			for(var idx = 0; idx < addCols.length; idx++) {
				initdata.Cols.push(addCols[idx]);
			}

			IBS_InitSheet(sheet2, initdata); sheet2.SetCountPosition(4);

			// 항목타입이 콤보인 경우 매핑그룹코드의 코드 목록 셋팅
			if(mappingCds != null && mappingCds.length > 0) {
				var comboCdList = null;
				for(i = 0; i < mappingCds.length; i++) {
					comboCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", mappingCds[i].grcode), "");
					sheet2.SetColProperty(mappingCds[i].saveName, {ComboText:"|"+comboCdList[0], ComboCode:"|"+comboCdList[1]} );
				}
			}

			// 자동완성 설정
			setSheetAutocompleteEmp( "sheet2", sheet2_name_col, null , returnFunc);

			//$(window).smartresize(sheetResize); sheetInit();

			$("#area_target").removeClass("hide");

			doAction2("Search");
		}
	}

	function returnFunc(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		sheet2.SetCellValue(gPRow, "sabun",          rv["sabun"] );
		sheet2.SetCellValue(gPRow, sheet2_name_col,  rv["name"] );
		sheet2.SetCellValue(gPRow, sheet2_resno_col, rv["resNo"] );

		// SQL조회를 통한 기본값 입력 처리
		if( colEleData != null && colEleData != undefined && colEleData.Data != null && colEleData.Data != undefined && colEleData.Data.length > 0 ) {
			var data = null;
			var params  = "declaration_org_cd="+sheet2.GetCellValue(gPRow, "declaration_org_cd");
				params += "&declaration_type="+sheet2.GetCellValue(gPRow, "declaration_type");
				params += "&target_ymd="+sheet2.GetCellValue(gPRow, "target_ymd");
				params += "&sabun="+sheet2.GetCellValue(gPRow, "sabun");

			var item = null;
			for(var i = 0; i < colEleData.Data.length; i++) {
				item = colEleData.Data[i];
				// 기본값조회 SQL 이 존재하며, 기본값이 설정되지 않은 상태인 경우 진행
				if( item.default_val_in_sql == "Y" && sheet2.GetCellValue(gPRow, "ele_" + item.display_seq) == "" ) {
					// 입력항목에 설정된 SQL를 실행하여 기본값 조회 및 값 셋팅
					data = ajaxCall( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=getDefaultValForSQLSyntax", params + "&element_nm=" + item.element_nm, false );
					//console.log('data', data);
					if(data != null && data != undefined && data.Data != null && data.Data != undefined) {
						sheet2.SetCellValue(gPRow, "ele_" + item.display_seq, data.Data.val);
					}
				}
			}
		}
	}

	function parseColTitle(title, cnt) {
		var result = "";
		for(var i = 0; i < cnt; i++) {
			if( i > 0) result += "|";
			result += title;
		}
		return result;
	}

	//Sheet Action First
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":

				var searchDeclarationTargetYear = $("#searchDeclarationTargetYear").val();
				var searchDeclarationTargetMonth = $("#searchDeclarationTargetMonth").val();

				if(searchDeclarationTargetYear != "" && searchDeclarationTargetYear.length == 2) {
					$("#searchDeclarationTargetYear").val("20" + searchDeclarationTargetYear);
				}

				if(searchDeclarationTargetMonth != "" && searchDeclarationTargetMonth.length == 1) {
					$("#searchDeclarationTargetMonth").val("0" + searchDeclarationTargetMonth);
				}

				// 조회
				sheet1.DoSearch( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=getDeclarationMgrTargetList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				var saveStr = sheet1.GetSaveString(0);
				if( saveStr == "" || saveStr == "KeyFieldError" ) {
					return;
				}
				sheet1.DoSave( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=saveDeclarationMgrTarget", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "declaration_org_cd", $("#searchDeclarationOrgCd").val());
				sheet1.SetCellValue(row, "declaration_type", $("#searchDeclarationType").val());
				sheet1.SetCellValue(row, "ele_cnt", "0");
				sheet1.SelectCell(row, 3);
				break;
			case "Copy":
				var Row = sheet1.DataCopy();
				sheet1.SelectCell(Row, 5);
				break;
			case "Clear":
				sheet1.RemoveAll();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;
		}
	}

	//Sheet Action Second
	function doAction2(sAction) {

		if ( (sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus") == "I") && !(sAction=="Search") ) {
			alert("상단의 신고서목록에서 \"입력\"작업을 완료한 후에 상세목록 작업을 진행해주시기 바랍니다.	 ");
			return;
		}

		switch (sAction) {
			case "Search":
				var row     = sheet1.GetSelectRow();
				var params  = "declaration_org_cd=" + sheet1.GetCellValue(row, "declaration_org_cd");
					params += "&declaration_type=" + sheet1.GetCellValue(row, "declaration_type");
					params += "&target_ymd=" + sheet1.GetCellValue(row, "target_ymd");
				sheet2.DoSearch( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=getDeclarationMgrEleValList", params );
				break;
			case "Save":
				// 입력항목타입이 순번인 컬럼이 존재하는 경우 순번 새로 채번 후 저장함.
				if( sheet2_seq_col != "" ) {
					var resNoArr = [];
					for(var row = sheet2.HeaderRows(); row < (sheet2.RowCount() + sheet2.HeaderRows()); row++) {
						resNoArr.push(sheet2.GetCellValue(row, sheet2_resno_col) + "_" + row);
					}
					//console.log('sort before', resNoArr);
					//console.log('sort after', resNoArr.sort());

					var sortResNoArr = resNoArr.sort();
					var changeRow    = null;
					for(var i = 0; i < sortResNoArr.length; i++) {
						changeRow = parseInt(sortResNoArr[i].substring(sortResNoArr[i].indexOf("_") + 1, sortResNoArr[i].length));
						sheet2.SetCellValue(changeRow, sheet2_seq_col, (i+1));
					}
					sheet2.ColumnSort(sheet2_resno_col, "ASC");
				}

				var saveStr = sheet2.GetSaveString(0);
				if( saveStr == "" || saveStr == "KeyFieldError" ) {
					return;
				}

				sheet2.DoSave( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=saveDeclarationMgrEleVal", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row    = sheet1.GetSelectRow();
				var newRow = sheet2.DataInsert(0);
				sheet2.SetCellValue(newRow, "declaration_org_cd", sheet1.GetCellValue(row, "declaration_org_cd"));
				sheet2.SetCellValue(newRow, "declaration_type", sheet1.GetCellValue(row, "declaration_type"));
				sheet2.SetCellValue(newRow, "target_ymd", sheet1.GetCellValue(row, "target_ymd"));

				// 각 입력항목의 타입에 따른 기본값 설정
				if( colEleData != null && colEleData != undefined && colEleData.Data != null && colEleData.Data != undefined && colEleData.Data.length > 0 ) {
					var item = null;
					for(var i = 0; i < colEleData.Data.length; i++) {
						item = colEleData.Data[i];
						if(item.element_type == "FIX_VALUE") {
							sheet2.SetCellValue(newRow, "ele_" + item.display_seq, item.element_fix_value);
						}
						if(item.element_default_value != "") {
							sheet2.SetCellValue(newRow, "ele_" + item.display_seq, item.element_default_value);
						}
						// 입력형식이 순번인 경우
						if(item.element_type == "SEQ") {
							sheet2.SetCellValue(newRow, "ele_" + item.display_seq, getColMaxValue(sheet2, "ele_" + item.display_seq));
						}
					}
				}

				sheet2.SelectCell(newRow, sheet2_name_col);
				break;
			case "Copy":
				var newRow = sheet2.DataCopy();
				// 각 입력항목의 타입에 따른 기본값 설정
				if( colEleData != null && colEleData != undefined && colEleData.Data != null && colEleData.Data != undefined && colEleData.Data.length > 0 ) {
					var item = null;
					for(var i = 0; i < colEleData.Data.length; i++) {
						item = colEleData.Data[i];
						// 입력형식이 순번인 경우
						if(item.element_type == "SEQ") {
							sheet2.SetCellValue(newRow, "ele_" + item.display_seq, getColMaxValue(sheet2, "ele_" + item.display_seq));
						}
					}
				}
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet2.Down2Excel(param);
				break;
			case "ChangeStatus" :
				var colIndx = null;
				//신고여부 컬럼 index 구하기

				for(var i=0; i <= sheet2.LastCol();i++) {
					for(var j=0; j < sheet2.HeaderRows(); j++) {
						if(sheet2.GetCellValue(j, i).indexOf("신고여부") != -1 ) colIndx = i;
					}
				}

				for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
					sheet2.SetCellValue(i, colIndx, "10"); //신고
				}
				break;

			case "CreateTargetEmp":
				var row = sheet1.GetSelectRow();

				if(sheet1.GetCellValue(row, "sdate") != "" && sheet1.GetCellValue(row, "edate") != "") {
					if(confirm("대상자생성을 실행하시겠습니까?")) {
						var params  = "declaration_org_cd=" + sheet1.GetCellValue(row, "declaration_org_cd");
							params += "&declaration_type=" + sheet1.GetCellValue(row, "declaration_type");
							params += "&target_ymd=" + sheet1.GetCellValue(row, "target_ymd");
							params += "&sdate=" + sheet1.GetCellValue(row, "sdate");
							params += "&edate=" + sheet1.GetCellValue(row, "edate");

						var createResult = ajaxCall( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=executeDeclarationTargetCreate", params, false );
						if(createResult != null && createResult != undefined && createResult.Result != null && createResult.Result != undefined) {
							if(createResult.Result.Code == "1") {
								doAction2("Search");
							}
						}
					}
				} else {
					alert("생성 대상 신고서의 적용기간을 입력 및 저장 후 실행 해주십시오.");
				}

				break;
			case "Export":
				if(sheet2.RowCount() == 0){
					alert("EDI파일을 생성할 대상이 없습니다.");
					break;
				}

				var row = sheet1.GetSelectRow();
				var params  = "declaration_org_cd=" + sheet1.GetCellValue(row, "declaration_org_cd");
					params += "&declaration_type=" + sheet1.GetCellValue(row, "declaration_type");
					params += "&target_ymd=" + sheet1.GetCellValue(row, "target_ymd");

				var fileName = $("#searchDeclarationOrgCd").find(":selected").text();
					//fileName += "_" + $("#searchDeclarationType").find(":selected").text();
					fileName += "_" + sheet1.GetCellText(row, "declaration_type");
					fileName += "_" + sheet1.GetCellValue(row, "target_ymd");
					fileName += "_EDI";
					fileName += "_" + new Date().getTime();

				// 해당 신고서 출력 설정 정보 조회
				var exportInfoData = ajaxCall( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=getDeclarationInfoMap", params, false );
				//console.log('exportInfoData', exportInfoData);

				if(exportInfoData != null && exportInfoData != undefined && exportInfoData.Data != null && exportInfoData.Data != undefined) {
					if( exportInfoData.Data.export_type == "TXT" ) {
						fileName += ".txt";
						params += "&viewFileName=" + encodeURIComponent(fileName);
						params += "&delimiter=" + encodeURIComponent(exportInfoData.Data.delimiter);

						$("#txtEdiDownloadIfrm").attr("src", "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=exportTxtEdiFile&" + params);
					} else {
						fileName += ".xls";
						//alert(exportDownCols);
						var config = {
							URL:"<%=jspPath%>/declarationMgr/declarationMgrRst.jsp",
							ExtendParam:"&cmd=getDeclarationMgrEleValListForExcelEdi&" + params,
							FileName: fileName,
							DownCols: exportDownCols,
							SheetDesign:1,
							Merge:1
						};
						sheet2.DirectDown2Excel(config);
					}
				}
				break;
			case "Reflection" :
				if(confirm("사회보험 기본사항을 등록하시겠습니까?")) {
					//사회보험 기본사항 등록 프로시저 호출
					var row = sheet1.GetSelectRow();
					var params  = "declaration_org_cd=" + sheet1.GetCellValue(row, "declaration_org_cd");
						params += "&declaration_type=" + sheet1.GetCellValue(row, "declaration_type");
						params += "&target_ymd=" + sheet1.GetCellValue(row, "target_ymd");
		
					var createResult = ajaxCall( "<%=jspPath%>/declarationMgr/declarationMgrRst.jsp?cmd=executeEdiBenBasigMgr", params, false );
					if(createResult != null && createResult != undefined && createResult.Result != null && createResult.Result != undefined) {
						if(createResult.Result.Code == "1") {
							doAction2("Search");
						}
					}
				}
				break;
		 }
	}

	// 조회 후 에러 메시지
	var executeSheet1Resize = false;
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(sheet1.SearchRows() == 0) {
				alert("신고대상 신고유형에 해당하는 신고일자 데이터가 존재하지 않습니다.\n신고일자 데이터를 등록 후 진행해주시기 바랍니다.");
				if(!$("#area_target").hasClass("hide")) {
					$("#area_target").addClass("hide");
				}
			} else {
				doAction2("Search");
			}

			if(!executeSheet1Resize) {
				sheetResize();
				executeSheet1Resize = true;
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction1("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(colEleData.Data.length <= 15) {
				sheetResize();
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") {
				alert(Msg);
				doAction2("Search");
			}
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//alert("mySheetLeft_OnClick Click : \nRow:"+ Row+" \nCol:"+Col+" \nValue:"+Value+" \nCellX:"+CellX+" \nCellY:"+CellY+" \nCellW:"+CellW+" \nCellH:"+CellH );
		try{
		}catch(ex){alert("OnSelectCell Event Error : " + ex);	}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(OldRow != NewRow){
				//doAction2("Search");
				initTarget(NewRow);
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			if(sheet1.ColSaveName(Row, Col) == "sDelete") {
				if(parseInt(sheet1.GetCellValue(Row, "ele_cnt")) > 0) {
					alert("세부항목이 등록되어 있어 삭제할 수 없습니다.");
					sheet1.SetAllowCheck(0);//체크를 막는다.
				} else {
					sheet1.SetAllowCheck(1);
				}
			}
		}catch(ex){alert("sheet1_OnBeforeCheck Event Error : " + ex);	}
	}

	// 팝업	클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		try {
			if(sheet2.ColSaveName(Col) == sheet2_name_col) {
				openOwnerPopup(Row, Col);
			}
		} catch(ex) {
			alert("OnPopupClick Event Error	: " + ex);
		}
	}

	// 사원	조회
	function openOwnerPopup(Row, Col){
		try{
			gPRow  = Row;
			pGubun = "ownerPopup";

			var	args	= new Array();
			args["ownerOnlyYn"]	= "N";
			args["earnerCd"]    = $("#searchEarnerCd").val();
			args["searchName"]  = sheet2.GetCellValue(Row, Col);

			var	rv = openPopup("<%=jspPath%>/common/ownerPopup.jsp?authPg=<%=authPg%>",	args, "740","520");
		} catch(ex)	{
			alert("Open Popup Event	Error :	" + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
		if ( pGubun == "ownerPopup" ){
			sheet2.SetCellValue(gPRow, sheet2_name_col,	 rv["name"] );
			sheet2.SetCellValue(gPRow, "sabun",	 rv["sabun"] );
			sheet2.SetCellValue(gPRow, sheet2_resno_col, rv["res_no"] );
			//sheet2.SetCellValue(gPRow, "business_place_cd",		rv["business_place_cd"]	);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div class="sheet_search outer">
	<form id="sheet1Form" name="sheet1Form" >
		<div>
		<table>
		<tr>
			<td class="<%= searchDeclarationOrgCdHide %>"><span>기관구분</span>
				<select id="searchDeclarationOrgCd" name ="searchDeclarationOrgCd"></select>
			</td>
			<td><span>신고유형</span>
				<select id="searchDeclarationType" name ="searchDeclarationType"></select>
			</td>
			<td><span>신고연도</span>
				<input type="text" id="searchDeclarationTargetYear" name ="searchDeclarationTargetYear" class="text center" maxlength="4" style="width:60px;" />
			</td>
			<td><span>신고월</span>
				<input type="text" id="searchDeclarationTargetMonth" name ="searchDeclarationTargetMonth" class="text center" maxlength="2" style="width:35px;" />
			</td>
			<td><a href="javascript:doAction1('Search')" class="button">조회</a></td>
		</tr>
		</table>
		</div>
	</form>
	</div>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">신고일자</li>
			<li class="btn">
			  <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
			  <a href="javascript:doAction1('Copy')"	class="basic authA">복사</a>
			  <a href="javascript:doAction1('Save')"	class="basic authA">저장</a>
			  <a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>

	<div id="area_target" class="hide">
		<div class="outer">
			<div class="sheet_title">
			<ul>
				<li class="txt">대상자</li>
				<li class="btn">
				  <a href="javascript:doAction2('CreateTargetEmp')"	class="button">대상자생성</a>
				  <a href="javascript:doAction2('ChangeStatus')"	class="cute">신고상태로 일괄변경</a>
				  <a href="javascript:doAction2('Search')"			class="basic authA">조회</a>
				  <a href="javascript:doAction2('Insert')"			class="basic authA">입력</a>
				  <a href="javascript:doAction2('Copy')"			class="basic authA">복사</a>
				  <a href="javascript:doAction2('Save')"			class="basic authA">저장</a>
				  <a href="javascript:doAction2('Down2Excel')"		class="basic authR">다운로드</a>
				  <a href="javascript:doAction2('Export')"			class="button">EDI파일생성</a>
				  <a href="javascript:doAction2('Reflection')"		class="cute">사회보험반영</a>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
	</div>

	<iframe id="txtEdiDownloadIfrm" class="hide"></iframe>
</div>
</body>
</html>