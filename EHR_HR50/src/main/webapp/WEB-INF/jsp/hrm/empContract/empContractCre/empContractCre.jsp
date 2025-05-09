<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- <%@ page import="com.hr.common.util.DateUtil" %> -->
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	
	// 계약서 유형 코드 목록
	var contTypeList = null;
	var searchStatusCd  = null;
	
	// 입력항목 속성 정보
	var eleInfo = null;

	$(function() {

		// $("#searchYmd").datepicker2();
		//====================================================================================================================================
		getCommonCodeList();
		$("#searchStdDateFrom").datepicker2({startdate:"searchStdDateTo", onReturn: getCommonCodeList});
		$("#searchStdDateTo").datepicker2({enddate:"searchStdDateFrom", onReturn: getCommonCodeList});

		//엔터키 조회
		$("#searchSabunNameAlias, #searchStdDateFrom, #searchStdDateTo, #searchOrgNm").on("keyup", function(e) {
			if(e.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchAgreeYn").bind("change", function (e) {
			doAction1("Search");
		});


		//====================================================================================================================================

		//IBsheet1 init
		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제", 	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"상태", 	Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"배포",			Type:"CheckBox",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"distributeYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"출력",			Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",			Type:"Text",   Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"sabun",         KeyField:1, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"성명",			Type:"Text",   Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"name",          KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"소속",			Type:"Text",   Hidden:0,   Width:120,  Align:"Center",   ColMerge:0, SaveName:"orgNm",         KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"직위",			Type:"Text",   Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"jikweeNm",      KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"직급",			Type:"Text",   Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"jikgubNm",      KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"직책",			Type:"Text",   Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"jikchakNm",     KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"재직상태",		Type:"Combo",  Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"statusCd",      KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"기준일자",		Type:"Date",   Hidden:0,   Width:90,   Align:"Center",   ColMerge:0, SaveName:"stdDate",       KeyField:1, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"계약서 유형",		Type:"Combo",  Hidden:0,   Width:150,  Align:"Center",   ColMerge:0, SaveName:"contType",      KeyField:1, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"동의여부",		Type:"Combo",   Hidden:0,   Width:140,  Align:"Center",   ColMerge:0, SaveName:"agreeYn",       KeyField:0, Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:1 },
			{Header:"동의일자",		Type:"Text",   Hidden:0,   Width:180,  Align:"Center",   ColMerge:0, SaveName:"agreeDate",  KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"rk",          Type:"rk",   Hidden:1,   Width:100,  Align:"Center",      ColMerge:0, SaveName:"rk",             KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("statusCd", 		{ComboText:"|"+searchStatusCd[0], 		ComboCode:"|"+searchStatusCd[1]} );
		sheet1.SetColProperty("agreeYn",  {ComboText:"|Y|N", ComboCode:"|Y|N"} );
		
		//setSheetAutocompleteEmp( "sheet1", "name" );

		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchStdDateFrom").val();
		let baseEYmd = $("#searchStdDateTo").val();

		searchStatusCd  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010", baseSYmd, baseEYmd), "전체");//재직상태(H10010)
		$("#searchStatusCd").html(searchStatusCd[2]);
		// 계약서 유형
		contTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","Z00001", baseSYmd, baseEYmd), "선택");
		sheet1.SetColProperty("contType", 			{ComboText:"|"+contTypeList[0], ComboCode:"|"+contTypeList[1]} );
		$("#searchContType").html( contTypeList[2] ).bind("change", function(event) {
			// 선택 계약서 유형에 따른 시트 컬럼 및 계약서유형별 항목 정보 셋팅
			initSheet();
			doAction1("Search");
		});
	}
	
	// 선택 계약서 유형에 따른 시트 컬럼 및 계약서유형별 항목 정보 셋팅
	function initSheet() {
		
		// 시트 초기화
		sheet1.Reset();

		// 초기화
		eleInfo = null;
		var eleNmList = "";
		var eleColList = "";
		$("#eleNmList").val("");
		$("#eleColList").val("");
		
		//IBsheet1 init
		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"상태",			Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			
			{Header:"배포",			Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"distributeYn",  KeyField:0, Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"선택",			Type:"DummyCheck",  Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"chk",           KeyField:0, Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:0, EditLen:100 },
			{Header:"세부\n내역",		Type:"Image",       Hidden:0,   Width:40,   Align:"Center",   ColMerge:0, SaveName:"detail",        KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"사번",			Type:"Text",        Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"sabun",         KeyField:1, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"성명",			Type:"Text",        Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"name",          KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"소속",			Type:"Text",        Hidden:0,   Width:150,  Align:"Center",   ColMerge:0, SaveName:"orgNm",         KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"직위",			Type:"Text",        Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"jikweeNm",      KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"직급",			Type:"Text",        Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"jikgubNm",      KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"직책",			Type:"Text",        Hidden:0,   Width:80,   Align:"Center",   ColMerge:0, SaveName:"jikchakNm",     KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"재직상태",		Type:"Combo",       Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"statusCd",      KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"기준일자",		Type:"Date",        Hidden:0,   Width:90,   Align:"Center",   ColMerge:0, SaveName:"stdDate",       KeyField:1, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"계약서 유형",	Type:"Combo",       Hidden:0,   Width:180,  Align:"Center",   ColMerge:0, SaveName:"contType",      KeyField:1, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"동의여부",		Type:"Combo",        Hidden:0,   Width:80,  Align:"Center",   ColMerge:0, SaveName:"agreeYn",       KeyField:0, Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:1 },
			{Header:"동의일자",		Type:"Text",        Hidden:0,   Width:160,  Align:"Center",   ColMerge:0, SaveName:"agreeDate",     KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"RD경로",		Type:"Text",        Hidden:1,   Width:100,	Align:"Right",    ColMerge:0, SaveName:"rdMrd",         KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"이메일",		Type:"Text",        Hidden:1,   Width:100,	Align:"Center",   ColMerge:0, SaveName:"mailId",        KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"rk",           Type:"Text",        Hidden:1,   Width:0,     Align:"Center",   ColMerge:0, SaveName:"rk",           KeyField:0, Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 }
		];

		// 선택된 계약서 유형이 존재하는 경우 진행
		if($("#searchContType").val() != "") {
			var data = ajaxCall("${ctx}/EmpContractEleMgr.do?cmd=getEmpContractEleMgrList",$("#srchFrm").serialize() ,false);
			//console.log('initEleInfo', data);

			if(data != null && data != undefined && data.DATA != null && data.DATA != undefined && data.DATA.length > 0) {
				eleInfo = new Object();
				
				var item = null;
				
				for(var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					//console.log('item', item.eleNm);
					eleInfo[item.eleNm] = item;
					
					if(i > 0) {
						eleNmList += "@";
						eleColList += "@";
					}
					
					eleNmList += item.eleNm;
					eleColList += "attrVal"+i;

					// 컬럼 정보 추가
					let type = "Text";
					// if (item.eleFormatCd == "03") {
					// 	type = "Date";
					// }
					initdata.Cols.push({Header:item.eleNm,	Type:type, Hidden:0, Width:150, Align:"Center", ColMerge:0, SaveName:"attrVal"+i, KeyField:0, Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:500 });
				}
				
				eleInfo["LIST"] = data.DATA;
			}
		}
		//console.log('eleInfo', eleInfo);
		
		// 컬럼 추가
		initdata.Cols.push({Header:"NM_ARR", Type:"Text", Hidden:1, Width:100, Align:"Center", ColMerge:0, SaveName:"eleNmArr", KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 });
		initdata.Cols.push({Header:"CD_ARR", Type:"Text", Hidden:1, Width:100, Align:"Center", ColMerge:0, SaveName:"eleCdArr", KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 });
		initdata.Cols.push({Header:"VALUE_ARR", Type:"Text", Hidden:1, Width:100, Align:"Center", ColMerge:0, SaveName:"eleValueArr", KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 });

		IBS_InitSheet(sheet1, initdata);
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		
		sheet1.SetColProperty("contType",	{ComboText:"|"+contTypeList[0],		ComboCode:"|"+contTypeList[1]} );
		sheet1.SetColProperty("statusCd",	{ComboText:"|"+searchStatusCd[0], 	ComboCode:"|"+searchStatusCd[1]} );
		sheet1.SetColProperty("agreeYn",  {ComboText:"|Y|N", ComboCode:"|Y|N"} );

		if($("#searchContType").val() == "" || data == null || data.DATA == null || data.DATA.length == 0) {
			$(window).smartresize(sheetResize);
			sheetInit();
		}

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						//sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						//sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					}
				}
			]
		});
		
		$("#eleNmList").val(eleNmList);
		$("#eleColList").val(eleColList);
	}

	/* IB시트 함수 */
	function doAction1(sAction) {
		var searchContType = $("#searchContType option:selected").val();
		if ( searchContType == "" ){
			alert("계약서 유형을 선택해주세요.");
			return;
		}

		switch (sAction) {
		case "Search":

			sheet1.DoSearch( "${ctx}/EmpContractCre.do?cmd=getEmpContractCreList", $("#srchFrm").serialize() );
			break;
		case "Save":
			//중복 체크 (변수 : "컬럼명|컬럼명")
			if(!dupChk(sheet1,"", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/EmpContractCre.do?cmd=saveEmpContractCre", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SelectCell(row, "name");
			sheet1.SetCellValue(row, "stdDate", <%=DateUtil.getCurrentTime("yyyyMMdd")%>);
			sheet1.SetCellValue(row,"agreeYn", "N");
			sheet1.SetCellEditable(row,"agreeYn", false);
			if($("#searchContType").val() != "") {
				sheet1.SetCellValue(row, "contType", $("#searchContType").val());
			}
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "stdDate", "");
			//sheet1.SetCellValue( Row, "PK컬럼", "" );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var d = new Date();
			var fName = "계약서배포_" + d.getTime();
			var param = { FileName:fName, DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "DownTemplate":
			var downCols = "sabun|stdDate|contType";
			if($("#searchContType").val() != "") {
				var saveNm      = null;
				for(var j = 0; j < sheet1.LastCol(); j++) {
					saveNm = sheet1.ColSaveName(j);
					if(saveNm.indexOf("attrVal") > -1) {
						downCols += "|" + saveNm;
					}
				}
			}
			var d = new Date();
			var fName = "계약서배포(업로드양식)_" + d.getTime();
			sheet1.Down2Excel({ FileName:fName, SheetDesign:1, Merge:1, DownRows:"0", DownCols:downCols});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "Create":

			var searchContType = $("#searchContType option:selected").val();
			var searchYmd = $("#searchYmd").val();

			if ( searchContType == "" ){
				alert("계약서 유형을 선택해주세요.");
				break;
			}
			if ( searchYmd == "" ){
				alert("생성기준일을 입력해주세요.");
				break;
			}

			if (!confirm("기존 데이터는 유지됩니다. \r\n생성하시겠습니까?")){break;}

			var data = ajaxCall("${ctx}/EmpContractCre.do?cmd=excTargetCreate",$("#srchFrm").serialize() ,false);

			if(data.Result != null && data.Result.Code > 0) {
				alert(data.Result.Message);;
				doAction1("Search");
			} else {
				alert(data.Result.Message);
			}
			break;
		}
	}

	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			
			// 선택된 계약서 유형이 존재하는 경우 진행
			if($("#searchContType").val() != "" && sheet1.RowCount() > 0) {
				var value = null;
				var arr = null;
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
					// 동적컬럼
					value = sheet1.GetCellValue(i, "eleValueArr");
					if(value && value != null && value != "") {
						arr = value.split("@");
						if(arr != null && arr != undefined && arr.length > 0) {
							for(var j = 0; j < arr.length; j++) {
								sheet1.SetCellValue(i, "attrVal" + j, arr[j].trim());
							}
						}
						sheet1.SetCellValue(i, "sStatus", "R");
					}
					
					// 동여의부가 Y인 경우 수정 불가
					/*
					if( sheet1.GetCellValue(i,"agreeYn") == "Y" ) { // 승인
						sheet1.SetRowEditable(i, false);
					} else  {
						sheet1.SetRowEditable(i, true);
					}
					*/
					if( sheet1.GetCellValue(i,"agreeYn") != "Y" ) { // 동의 일때만 해제 가능하도록
						sheet1.SetCellEditable(i,"agreeYn", false);
					} 
				}
			}

			//sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	// 팝업 클릭시 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			//사원검색
			switch(sheet1.ColSaveName(Col)){
				case "name":
					if(!isPopup()) {return;}

					sheet1.SelectCell(Row,"name");

					gPRow = Row;
					pGubun = "employeePopup";

					openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "740","520");
					break;
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	// 셀 선택 시 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol, isDelete) {
		try{
			if(OldRow > -1 && OldCol > -1) {
				// 계약서 내용 입력 항목 값 서식에 맞게 변환
				convertValueForFormat(OldRow, OldCol, sheet1.GetCellValue(OldRow, OldCol));
			}

			if(NewRow > -1 && NewCol > -1) {
				// 계약서 내용 입력 항목 값 편집값으로 변환
				reverseValueForFormat(NewRow, NewCol, sheet1.GetCellValue(NewRow, NewCol));
			}
			
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	// 셀 편집한 직후 이벤트
	function sheet1_OnAfterEdit(Row, Col) {
		try{
			// 계약서 내용 입력 항목 값 서식에 맞게 변환
			// convertValueForFormat(Row, Col, sheet1.GetCellValue(Row, Col));
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	
	// 셀 클릭 시 이벤트
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if( sheet1.ColSaveName(Col) == "detail"  && Row >= sheet1.HeaderRows() ) {
			/*계약서 RD팝업*/
			rdPopup(Row) ;
		}
	}

	
	// 계약서 내용 입력 항목 값 서식에 맞게 변환
	function convertValueForFormat(Row, Col, Value) {
		var saveNm      = sheet1.ColSaveName(Col);
		var headerNm    = null;
		var eleFormatCd = null;
		var convVal     = null;

		if(saveNm.indexOf("attrVal") > -1 && Value != "") {
			headerNm    = sheet1.GetCellValue(0, saveNm);
			eleFormatCd = eleInfo[headerNm].eleFormatCd;
			if(eleFormatCd == "01") {			// 숫자(1000단위 콤마 자동입력)
				if(isOnlyNumber(Value, true)) {
					sheet1.SetCellValue(Row, Col, getCommaText(Value), false);
				} else {
					alert("숫자만 입력 가능합니다.");
					sheet1.SelectCell(Row, Col);
				}
			} else if(eleFormatCd == "02") {	// 숫자(한글금액자동입력)
				if(isOnlyNumber(Value, true)) {
					sheet1.SetCellValue(Row, Col, getCommaText(Value), false);
					
					// 한글형식금액 항목이 존재하는 경우
					var hangulEle = eleInfo[headerNm + "_한글"];
					if(hangulEle != null && hangulEle != undefined) {
						var hangulEleSaveNm = getSaveNmByColName(headerNm + "_한글");
						sheet1.SetCellValue(Row, hangulEleSaveNm, convertNumToHangul(Value, false, false), false);
					}
					
				} else {
					alert("숫자만 입력 가능합니다.");
					sheet1.SelectCell(Row, Col);
				}
			} else if(eleFormatCd == "03") {	// 날짜
				convVal = Value.replace(/\s/g, ""); // 공백제거
				convVal = convVal.replace(/-/g, ""); // '-' 제거
				convVal = convVal.replace(/년/g, ""); // '년' 제거
				convVal = convVal.replace(/월/g, ""); // '월' 제거
				convVal = convVal.replace(/일/g, ""); // '일' 제거
					
				var isInvalid = false;
				if(isOnlyNumber(convVal, false) && (convVal.length == 6 || convVal.length == 8)) {
					// YYMMDD
					var datePattern1 = /^\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/;
					// YYYYMMDD
					var datePattern2 = /^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/;
					
					if( datePattern1.test(convVal) ) {
						convVal = "20" + convVal.substring(0, 2) + "년 " + convVal.substring(2, 4)  + "월 " + convVal.substring(4, 6) + "일";
					} else if ( datePattern2.test(convVal) ) {
						convVal = convVal.substring(0, 4) + "년 " + convVal.substring(4, 6)  + "월 " + convVal.substring(6, 8) + "일";
					} else {
						isInvalid = true;
					}
				} else {
					isInvalid = true;
				}
				
				if(isInvalid) {
					alert("날짜 형식의 경우  YYYYMMDD or YYMMDD or YYYY-MM-DD or YY-MM-DD 형식만 입력 가능합니다.");
					sheet1.SelectCell(Row, Col);
				} else {
					sheet1.SetCellValue(Row, Col, convVal, false);
				}
			}
		}
	}
	
	// 계약서 내용 입력 항목 값 편집값으로 변환
	function reverseValueForFormat(Row, Col, Value) {
		var saveNm      = sheet1.ColSaveName(Col);
		var headerNm    = null;
		var eleFormatCd = null;
		var convVal     = null;
		
		if(saveNm.indexOf("attrVal") > -1 && Value != "") {
			headerNm    = sheet1.GetCellValue(0, saveNm);
			eleFormatCd = eleInfo[headerNm].eleFormatCd;
			
			if(eleFormatCd == "01") {			// 숫자(1000단위 콤마 자동입력)
				sheet1.SetCellValue(Row, Col, Value.replace(/,/g, ""), false);
			} else if(eleFormatCd == "02") {	// 숫자(한글금액자동입력)
				sheet1.SetCellValue(Row, Col, Value.replace(/,/g, ""), false);
			} else if(eleFormatCd == "03") {	// 날짜
				if( Value.indexOf("년") > -1 && Value.indexOf("월") > -1 && Value.indexOf("일") > -1 ) {
					var year  = Value.substring(0, Value.indexOf("년")).trim();
					var month = Value.substring(Value.indexOf("년") + 1, Value.indexOf("월")).trim();
					var day = Value.substring(Value.indexOf("월") + 1, Value.indexOf("일")).trim();
					// convVal = year + "" + ((Number(month) < 10) ? "0" + month : month) + "" + ((Number(day) < 10) ? "0" + day : day);
					convVal = year + "" + month + "" + day;
					sheet1.SetCellValue(Row, Col, convVal, false);
				}
			}
		}
	}
	
	// 컬럼명에 해당하는 SaveName 반환
	function getSaveNmByColName(matchHeaderNm) {
		var saveNm      = null;
		var headerNm    = null;
		var returnVal   = null;
		
		for(var i = 0; i < sheet1.LastCol() + 1; i++) {
			saveNm   = sheet1.ColSaveName(i);
			headerNm = sheet1.GetCellValue(0, saveNm);
			
			if(headerNm == matchHeaderNm) {
				returnVal   = saveNm;
				break;
			}
		}
		
		return returnVal;
	}
	
	// 숫자만 입력되어 있는지 체크
	function isOnlyNumber(val, removeComma) {
		var reg = /^\d+$/;
		if(removeComma) val = val.replace(/,/g, "");
		return reg.test(val);
	}
 	
 	//콤마찍기.
	function getCommaText(val) { 
		var strValue = new String(val);
		
		strValue = strValue.replace(/\D/g,"");

		if (strValue.substr(0,1)==0 ) {
			strValue = strValue.substr(1);
		}

		var l = strValue.length-3;
		while(l>0) {
			strValue = strValue.substr(0,l)+","+strValue.substr(l);
			l -= 3;
		}
		
		return strValue;
	}
 	
 	// 숫자 한글문자로 변환
	function convertNumToHangul(num, prefix_flag, won_flag) {
		var hanA = new Array("","일","이","삼","사","오","육","칠","팔","구","십");
		var danA = new Array("","십","백","천","","십","백","천","","십","백","천","","십","백","천");
		var result = "";

		if(num != null && num != undefined && num.length > 0) {
			// 소수점 절삭
			if(num.indexOf(".") > -1) {
				num = num.substring(0, num.indexOf("."));
			}
			num = num.replace(/-/g, "");
			num = num.replace(/,/g, "");

			for(i=0; i<num.length; i++) {
				str = "";
				han = hanA[num.charAt(num.length-(i+1))];

				if(han != "") str += han+danA[i];
				if(i == 4)    str += "만";
				if(i == 8)    str += "억";
				if(i == 12)   str += "조";

				result = str + result; 
			}

			if(num != 0) {
				if(prefix_flag) result = "금" + result;
				if(won_flag) result += "원";
			}
		}

		return result;
	}
	
	// 계약서 내용 입력항목 전체 형식 변환 처리
	function allConvertFormat() {
		// 선택된 계약서 유형이 존재하는 경우 진행
		if($("#searchContType").val() != "" && sheet1.RowCount() > 0) {
			var saveNm      = null;
			var headerNm    = null;
			var eleFormatCd = null;
			var Value       = null;
			
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
				for(var j = 0; j < sheet1.LastCol(); j++) {
					saveNm = sheet1.ColSaveName(j);
					Value  = sheet1.GetCellValue(i, j);
					
					if(saveNm.indexOf("attrVal") > -1 && Value != "") {
						headerNm    = sheet1.GetCellValue(0, saveNm);
						eleFormatCd = eleInfo[headerNm].eleFormatCd;

						if(eleFormatCd == "01") {			// 숫자(1000단위 콤마 자동입력)
							if(isOnlyNumber(Value, true)) {
								sheet1.SetCellValue(i, j, getCommaText(Value), false);
							} else if(!isOnlyNumber(Value, true)) {
								alert("숫자만 입력 가능합니다.");
								sheet1.SelectCell(i, j);
							}
						} else if(eleFormatCd == "02") {	// 숫자(한글금액자동입력)
							if(isOnlyNumber(Value, true)) {
								// 한글형식금액 항목이 존재하는 경우
								var hangulEle = eleInfo[headerNm + "_한글"];
								if(hangulEle != null && hangulEle != undefined) {
									var hangulEleSaveNm = getSaveNmByColName(headerNm + "_한글");
									/*
									if( sheet1.GetCellValue(i, hangulEleSaveNm) == "" ) {
										sheet1.SetCellValue(i, hangulEleSaveNm, convertNumToHangul(Value.replace(/,/g, ""), false, false));
									}
									*/
									sheet1.SetCellValue(i, hangulEleSaveNm, convertNumToHangul(Value.replace(/,/g, ""), false, false), false);
								}
							} else {
								alert("숫자만 입력 가능합니다.");
								sheet1.SelectCell(i, j);
							}
						
							if(isOnlyNumber(Value, false)) {
								sheet1.SetCellValue(i, j, getCommaText(Value), false);
							}
						} else if(eleFormatCd == "03") {	// 날짜
							if( !(Value.indexOf("년") > -1 && Value.indexOf("월") > -1 && Value.indexOf("일") > -1) ) {
								convVal = Value.replace(/\s/g, ""); // 공백제거
								convVal = convVal.replace(/-/g, ""); // '-' 제거
								convVal = convVal.replace(/년/g, ""); // '년' 제거
								convVal = convVal.replace(/월/g, ""); // '월' 제거
								convVal = convVal.replace(/일/g, ""); // '일' 제거
									
								var isInvalid = false;
								if(isOnlyNumber(convVal) && (convVal.length == 6 || convVal.length == 8)) {
									// YYMMDD
									var datePattern1 = /^\d{2}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/;
									// YYYYMMDD
									var datePattern2 = /^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[0-1])$/;
									
									if( datePattern1.test(convVal) ) {
										convVal = "20" + convVal.substring(0, 2) + "년 " + Number(convVal.substring(2, 4))  + "월 " + Number(convVal.substring(4, 6)) + "일";
									} else if ( datePattern2.test(convVal) ) {
										convVal = convVal.substring(0, 4) + "년 " + Number(convVal.substring(4, 6))  + "월 " + Number(convVal.substring(6, 8)) + "일";
									} else {
										isInvalid = true;
									}
								} else {
									isInvalid = true;
								}
								
								if(isInvalid) {
									alert("날짜 형식의 경우  YYYYMMDD or YYMMDD or YYYY-MM-DD or YY-MM-DD 형식만 입력 가능합니다.");
									sheet1.SelectCell(i, j);
								} else {
									sheet1.SetCellValue(i, j, convVal, false);
								}
							}
						}
						
					}
				}
			}
		}
	}
	
	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "sheetAutocompleteEmp") {
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
		}
	}
	
	function rdPopup(Row){
		if(!isPopup()) {return;}
		
		var contType=$("#searchContType").val();
		if (contType=="") {
			alert("계약서 유형을 선택하세요");
			return;
		}
		
		<%--var w 		= 900;--%>
		<%--var h 		= 970;--%>
		<%--var url 	= "${ctx}/RdPopup.do";--%>
		<%--var args 	= new Array();--%>
		
		<%--args["rdTitle"] = "계약서" ;//rd Popup제목--%>
		<%--args["rdMrd"] = sheet1.GetCellValue(Row, "rdMrd");//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명--%>
		<%--args["rdParam"] = "[${ssnEnterCd}] [(('"+sheet1.GetCellValue(Row, "sabun")+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "stdDate")+"'))] [${baseURL}]" ; //rd파라매터--%>
		<%--args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)--%>
		<%--args["rdToolBarYn"] = "Y" ;//툴바여부--%>
		<%--args["rdZoomRatio"] = "100" ;//확대축소비율--%>

		<%--args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장--%>
		<%--args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄--%>
		<%--args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀--%>
		<%--args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드--%>
		<%--args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트--%>
		<%--args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글--%>
		<%--args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF--%>

		<%--gPRow = Row;--%>
		<%--pGubun = "rdPopup";--%>
		<%--var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창--%>

		let searchList = [];
		let rdMrd = '';
		let rkList = [];
		rkList.push(sheet1.GetCellValue(Row, 'rk'));

		const data = {
			rk : rkList
		};
		window.top.showRdLayer('/EmpContractCre.do?cmd=getEncryptRd', data);
	}
	
	function rdPopup2(){
		
		if(!isPopup()) {return;}

		if(sheet1.CheckedRows("chk") == 0) {
			alert("<msg:txt mid='110453' mdef='출력할 데이터를 선택하여 주십시오.'/>");
			return;
		}
		
		var sRow = sheet1.FindCheckedRow("chk"); 
		var arrRow1 = [];
		var arrRow2 = [];
		var arrRow3 = [];
		var searchRdMrd = "";
		//args["rdParam"] = "[${ssnEnterCd}] [(('"+sheet1.GetCellValue(Row, "sabun")+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "stdDate")+"'))] [${baseURL}]" ; //rd파라매터
		$(sRow.split("|")).each(function(index,value){
			arrRow1[index] = sheet1.GetCellValue(value,"sabun");
			arrRow2[index] = sheet1.GetCellValue(value,"contType");
			arrRow3[index] = sheet1.GetCellValue(value,"stdDate");
			searchRdMrd    = sheet1.GetCellValue(value, "rdMrd");
		});
		
		var searchTarget = "(";
		for(var i=0; i<arrRow1.length; i++) {
			if(i != 0) searchTarget += ",";
			searchTarget += "('"+arrRow1[i]+"'"; 
			searchTarget += ",'"+arrRow2[i]+"'"; 
			searchTarget += ",'"+arrRow3[i]+"')"; 
		} 
		searchTarget += ")";
		
		var w 		= 840;
		var h 		= 1000;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		
		args["rdTitle"] = "계약서" ;//rd Popup제목
		args["rdMrd"] = searchRdMrd;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[${ssnEnterCd}] ["+searchTarget+"] [${baseURL}]"  ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF
		

		gPRow = "";
		pGubun = "rdPopup2";
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		
		/*
		if(rv!=null){
			//return code is empty
		}
		*/
		
	}

	function showRd(){
		if(sheet1.CheckedRows("chk") === 0) {
			alert("<msg:txt mid='110453' mdef='출력할 데이터를 선택하여 주십시오.'/>");
			return;
		}
		const checkedRow = sheet1.FindCheckedRow("chk");
		let searchList = [];
		let rdMrd = '';
		let rkList = [];
		$(checkedRow.split("|")).each(function(index,value){
			rdMrd = '/' + sheet1.GetCellValue(value, "rdMrd");
			searchList.push('(\'' + sheet1.GetCellValue(value,"sabun")
					+ '\',\'' + sheet1.GetCellValue(value,"contType")
					+ '\',\'' + sheet1.GetCellValue(value, "stdDate") + '\')');
			rkList[index] = sheet1.GetCellValue(value, 'rk');
		});

		let parameters = Utils.encase('${ssnEnterCd}') + ' ';
		parameters += Utils.encase('(' + searchList.join(',') + ')') + ' ';
		parameters += Utils.encase('${imageBaseUrl}');

		//암호화 할 데이터 생성
		/*
		const data = {
			rdMrd : rdMrd
			, parameterType : 'rp'//rp 또는 rv
			, parameters : parameters
		};
		window.top.showRdLayer(data);*/
        const data = {
               rk : rkList
        };
		window.top.showRdLayer('/EmpContractCre.do?cmd=getEncryptRd', data);
		
	}
	
	/**
	* 메일발송
	*/
	function sendMail(){
		var sabuns = "";

		var sRow = sheet1.FindCheckedRow("chk");
		if( sRow == "" ){
			alert("대상을 선택 해주세요.");
			return;
		}

		var names = "";
		var mailIds = "";
		var arrRow = sRow.split("|");
		for(var i=0; i<arrRow.length ; i++){
			if (sheet1.GetCellValue(arrRow[i], "mailId") != "" ){
				names    += sheet1.GetCellValue(arrRow[i], "name") + "|";
				mailIds  += sheet1.GetCellValue(arrRow[i], "mailId") + "|";
			}
		}
		names    = names.substr(0, names.length - 1);
		mailIds  = mailIds.substr(0, mailIds.length - 1);

		fnSendMailPop(names, mailIds);

		return;
	}

	/**
	 * Mail 발송 팝업 창 호출
	 */
	function fnSendMailPop(names,mailIds){
		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"] = names;
		args["mailIds"] = mailIds;
		args["sender"] = "${ssnName}";
		args["bizCd"] = "99999";
		args["authPg"] = "${authPg}";

		var url = "${ctx}/SendPopup.do?cmd=viewMailMgrLayer";
		let layerModal = new window.top.document.LayerModal({
			id : 'mailMgrLayer'
			, url : url
			, parameters : args
			, width : 900
			, height : 700
			, title : 'MAIL 발신'
			, trigger :[
				{
					name : 'mailMgrTrigger'
					, callback : function(result){

					}
				}
			]
		});
		layerModal.show();
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="eleNmList" name="eleNmList" />
		<input type="hidden" id="eleColList" name="eleColList" />

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>계약서 유형 </th>
			<td> <select id="searchContType" name="searchContType" class="box" ></select>
			</td>
			<th>기준일 </th>
			<td>
				<input type="text" id="searchStdDateFrom" name ="searchStdDateFrom" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-01-01")%>"/> ~
				<input type="text" id="searchStdDateTo" name ="searchStdDateTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-12-31")%>"/>
			</td>
		</tr>
		<tr>
			<th>소속</th>
			<td>
				<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
			</td>
			<th>사번/성명 </th>
			<td>
				 <input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<th>재직상태</th>
			<td>
				<select id="searchStatusCd" name="searchStatusCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<th>동의여부</th>
			<td>
				<select id="searchAgreeYn" name="searchAgreeYn" class="box">
					<option value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a></td>
		</tr>
		</table>
		</div>
	</div>


	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="outer">
				<div class="sheet_title">
				<ul>
					<li class="txt">계약서 배포</li>
					<li class="btn">
						생성기준일 :&nbsp;<input type="text" id="searchYmd" name="searchYmd" class="center date" value="${curSysYyyyMMddHyphen}" />
						<a href="javascript:doAction1('Create')" 		class="btn soft thinner authA">전사원생성</a>

						<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray thinner authR">다운로드</a>
						<a href="javascript:doAction1('DownTemplate')" 	class="btn outline-gray thinner authR">양식다운로드</a>
						<a href="javascript:doAction1('LoadExcel')" 	class="btn outline-gray thinner authR">업로드</a>
						<a href="javascript:doAction1('Copy')" 			class="btn outline-gray thinner authA">복사</a>
						<a href="javascript:doAction1('Insert')" 		class="btn outline-gray thinner authA">입력</a>

						<a href="javascript:sendMail();" 				class="btn soft thinner authA">메일발송</a>
						<a href="javascript:allConvertFormat();" 		class="btn soft thinner authR">입력항목 형식 맞춤</a>
						<a href="javascript:showRd()" 					class="btn soft thinner authA">일괄출력</a>
						<a href="javascript:doAction1('Save')" 			class="btn filled thinner authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
	</tr>
	</table>
	</form>
</div>

</body>
</html>