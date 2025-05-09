<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>일근무관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow  = "";
var popGubun = "";
var headerStartCnt = 0;
var locationCdList = "";
var workClassCdList = "";

	$(function() {
		// 조회조건 설정
		$("#searchSymd").val("${curSysYyyyMMddHyphen}");
		$("#searchEymd").val("${curSysYyyyMMddHyphen}");

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = "<tit:txt mid='103895' mdef='전체'/>";
		if ("${ssnSearchType}" != "A"){
			allFlag = "";

			var searchOrgUrl = "queryId=getTSYS319orgList";
	        var searchOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", searchOrgUrl,false).codeList, "");
			$("#searchOrgCd").html(searchOrgCdList[2]);
		}
		var bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", url,false).codeList, allFlag);
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		//근무지 관리자권한만 전체근무지 보이도록, 그외는 권한근무지만.
		url     = "queryId=getLocationCdListAuth";
		allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}

		if(allFlag) {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchLocationCd").html(locationCdList[2]);

        $("#searchSymd").datepicker2({
        	startdate:"searchEymd",
   			onReturn:function(date){
				getCommonCodeList();
   			}
        });
        $("#searchEymd").datepicker2({
        	enddate:"searchSymd",
   			onReturn:function(date){
				getCommonCodeList();
   			}
        });

        $("#searchSabunName, #searchSymd, #searchEymd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
			if( event.keyCode == 8 || event.keyCode == 46){  //back/del
				clearCode(2);
			}
		});

		$("#btnAllSearch").on("click", function() {
			$("#searchRowSabun, #searchRowYmd").val("");
			doAction1("Search");
		});

		getCommonCodeList();

		initSheet1();
		initSheet2();
		initSheet3();
		$(window).smartresize(sheetResize);sheetInit();
	});

	function getCommonCodeList() {
		//공통코드 한번에 조회
		let baseSYmd = $("#searchSymd").val();
		let baseEYmd = $("#searchEymd").val();

		workClassCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmWorkClassCdComboList",false).codeList, "전체");
		$('#searchWorkClassCd').append(workClassCdList[2]);

		let grpCds = "H10030,H20030,H20010,H10050";
		let params = "grpCd=" + grpCds
					+ "&baseSYmd=" + baseSYmd
					+ "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params,false).codeList, "전체");
		$("#searchManageCd").html(codeLists['H10030'][2]);
		$("#searchJikweeCd").html(codeLists['H20030'][2]);
		$("#searchJikgubCd").html(codeLists['H20010'][2]);
		$("#searchWorkType").html(codeLists['H10050'][2]);
	}

	function initSheet1() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol : 8};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", SaveName:"sNo" },
			{Header:"상태|상태",					Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", SaveName:"sStatus" , Sort:0},
			{Header:"근무일|근무일",				Type:"Date",		Hidden:0,  	Width:90,	Align:"Center",		SaveName:"ymd",				KeyField:1,  Format:"Ymd",  UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"요일|요일",					Type:"Text",		Hidden:0,  	Width:40,	Align:"Center",		SaveName:"dayNm",			KeyField:0,  Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속",					Type:"Text",		Hidden:0,  	Width:150,	Align:"Left",  		SaveName:"orgNm",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"사번|사번",					Type:"Text",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"sabun",		   	KeyField:1,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"성명|성명",					Type:"Text",		Hidden:0,  	Width:70,	Align:"Center",  	SaveName:"name",		   	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"직위|직위",					Type:"Text",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"jikweeNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"직급|직급",					Type:"Text",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"jikgubNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"직책|직책",					Type:"Text",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"jikchakNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"사원구분|사원구분",			Type:"Text",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"manageNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"직군|직군",					Type:"Text",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"workTypeNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"근무유형|근무유형",			Type:"Combo",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"workClassCd",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 },
			{Header:"TimeCard|출근",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",  	SaveName:"tcInHm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0 },
			{Header:"TimeCard|퇴근",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",  	SaveName:"tcOutHm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0 },
			{Header:"인정근무시간|출근",			Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"inHm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0,   EditLen:5 },
			{Header:"인정근무시간|퇴근",			Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"outHm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0,   EditLen:5 },
			{Header:"인정\n시간|인정\n시간",		Type:"Text",		Hidden:0,  Width:50,   	Align:"Center", 	SaveName:"realWorkTime",	KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"타임카드\n누락|타임카드\n누락",		Type:"CheckBox",	Hidden:0,		Width:50,   	Align:"Center", 	SaveName:"timeCardFlag",	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 },
			{Header:"근무\n마감|근무\n마감",				Type:"CheckBox",	Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"closeYn",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:1},
			{Header:"기본\n근무|기본\n근무",				Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"basicMmW",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"연장\n근무|연장\n근무",				Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"otMmW",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"심야\n근무|심야\n근무",				Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"ltnMmW",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"휴일\n기본근무|휴일\n기본근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"basicMmH",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"휴일\n연장근무|휴일\n연장근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"otMmH",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"휴일\n심야근무|휴일\n심야근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"ltnMmH",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"휴무일\n기본근무|휴무일\n기본근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"basicMmNh",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"휴무일\n연장근무|휴무일\n연장근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"otMmNh",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"휴무일\n심야근무|휴무일\n심야근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"ltnMmNh",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, },
			{Header:"지각\n여부|지각\n여부",				Type:"CheckBox",	Hidden:0,		Width:50,   	Align:"Center", 	SaveName:"lateYn",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 },
			{Header:"조퇴\n여부|조퇴\n여부",				Type:"CheckBox",	Hidden:0,		Width:50,   	Align:"Center", 	SaveName:"leaveEarlyYn",	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 },
			{Header:"결근\n여부|결근\n여부",				Type:"CheckBox",	Hidden:0,		Width:50,   	Align:"Center", 	SaveName:"absenceYn",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 },
			{Header:"비고|비고",							Type:"Text",		Hidden:0,  		Width:150,		Align:"Left",   	SaveName:"note",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:1,   EditLen:200 }

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetUseDefaultTime(0);
		sheet1.SetEditableColorDiff(1);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

		sheet1.SetColProperty("workClassCd",  		{ComboText:workClassCdList[0], ComboCode:workClassCdList[1]} );
	}

	function initSheet2() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol : 10};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", SaveName:"sDelete" , Sort:0},
			{Header:"상태|상태",					Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", SaveName:"sStatus" , Sort:0},
			{Header:"근무일|근무일",				Type:"Date",		Hidden:0,  	Width:80,	Align:"Center",		SaveName:"ymd",				KeyField:1,  Format:"Ymd",  UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"근무|근무",					Type:"Combo",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"workCd",			KeyField:1,  Format:"",     UpdateEdit:1,   InsertEdit:1 },
			{Header:"계획|시작일",				Type:"Date",		Hidden:0,  	Width:90,	Align:"Center",		SaveName:"planSymd",		KeyField:1,  Format:"Ymd",  UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계획|시작시간",				Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"planShm",			KeyField:1,  Format:"Hm",   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"계획|종료일",				Type:"Date",		Hidden:0,  	Width:90,	Align:"Center",		SaveName:"planEymd",		KeyField:1,  Format:"Ymd",  UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계획|종료시간",				Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"planEhm",			KeyField:0,  Format:"Hm",   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"계획|계획시간(분)",			Type:"Number",		Hidden:0,  	Width:65,	Align:"Center",  	SaveName:"planMm",			KeyField:0,  Format:"",  UpdateEdit:0,   InsertEdit:0,   EditLen:5 },
			{Header:"인정|시작일",				Type:"Date",		Hidden:0,  	Width:90,	Align:"Center",		SaveName:"realSymd",		KeyField:0,  Format:"Ymd",  UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"인정|시작시간",				Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"realShm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0,   EditLen:5 },
			{Header:"인정|종료일",				Type:"Date",		Hidden:0,  	Width:90,	Align:"Center",		SaveName:"realEymd",		KeyField:0,  Format:"Ymd",  UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"인정|종료시간",				Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"realEhm",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0,   EditLen:5 },
			{Header:"인정|인정시간(분)",			Type:"Number",		Hidden:0,  	Width:65,	Align:"Center",  	SaveName:"realMm",			KeyField:0,  Format:"",	UpdateEdit:0,   InsertEdit:0,   EditLen:5 },
			{Header:"비고|비고",					Type:"Text",		Hidden:0,  	Width:150,	Align:"Left",   	SaveName:"note",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:1,   EditLen:200 },

			// Hidden
			{Header:"사번",			Type:"Hidden",		Hidden:1,  SaveName:"sabun"},
			{Header:"WRK_DTL_ID",	Type:"Hidden",		Hidden:1,  SaveName:"wrkDtlId"},

		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetCountPosition(4);

		const workCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmWorkCdComboList",false).codeList, "");
		sheet2.SetColProperty("workCd", {ComboText:workCdList[0], ComboCode:workCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
	}

	function initSheet3() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol : 4};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", SaveName:"sDelete" , Sort:0},
			{Header:"상태",				Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", SaveName:"sStatus" , Sort:0},
			{Header:"근무일",			Type:"Date",		Hidden:0,  	Width:80,	Align:"Center",		SaveName:"ymd",				KeyField:1,  Format:"Ymd",  UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"출근일",			Type:"Date",		Hidden:0,  	Width:90,	Align:"Center",		SaveName:"inYmd",			KeyField:1,  Format:"Ymd",  UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"출근시간",			Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"inHm",			KeyField:1,  Format:"Hm",   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"퇴근일",			Type:"Date",		Hidden:0,  	Width:90,	Align:"Center",		SaveName:"outYmd",			KeyField:1,  Format:"Ymd",  UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"퇴근시간",			Type:"Date",		Hidden:0,  	Width:60,	Align:"Center",  	SaveName:"outHm",			KeyField:1,  Format:"Hm",   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"이석\n여부",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center", 	SaveName:"awayYn",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 },
			{Header:"비고",				Type:"Text",		Hidden:0,  	Width:150,	Align:"Left",   	SaveName:"memo",			KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:1,   EditLen:200 },
			// Hidden
			{Header:"사번",		Type:"Hidden",		Hidden:1,  SaveName:"sabun"},
			{Header:"Seq",		Type:"Hidden",		Hidden:1,  SaveName:"seq"},

		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetCountPosition(4);
		$(window).smartresize(sheetResize); sheetInit();
	}

	// 필수값/유효성 체크
	function chkInVal() {
		// 시작일자와 종료일자 체크
		if ($("#searchSymd").val() != "" && $("#searchEymd").val() != "") {
			if (!checkFromToDate($("#searchSymd"),$("#searchEymd"),"근무일","근무일","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if(!chkInVal()){break;}
				sheet1.DoSearch( "${ctx}/WtmDailyWorkMgr.do?cmd=getWtmDailyWorkMgrList", $("#sheetForm").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheetForm,sheet1);
				sheet1.DoSave( "${ctx}/WtmDailyWorkMgr.do?cmd=updateWtmDailyWorkMgrCloseYn", $("#sheetForm").serialize());
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if (sheet1.RowCount() !== 0 ){
				sheet1.SetSelectRow(sheet1.HeaderRows());

				const searchRowYmd = $("#searchRowYmd").val();
				const searchRowSabun = $("#searchRowSabun").val();
				if(searchRowYmd && searchRowSabun) {
					for (var i = sheet1.HeaderRows() ; i < sheet1.HeaderRows() + sheet1.RowCount() ; i++) {
						if(sheet1.GetCellValue(i, "ymd").replace(/-/gi, "") === searchRowYmd && sheet1.GetCellValue(i, "sabun") === searchRowSabun ) {
							sheet1.SetSelectRow(i);
							clickSheet1(i);
							break;
						}
					}
				} else {
					clickSheet1(sheet1.HeaderRows());
				}
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if( Code > -1 ) doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;

			if(gPRow !== Row) {
				gPRow = Row;
				clickSheet1(Row);
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function clickSheet1(Row) {
		$("#searchRowYmd").val(sheet1.GetCellValue(Row, "ymd"));
		$("#searchRowSabun").val(sheet1.GetCellValue(Row, "sabun"));
		doAction2('Search')
		doAction3('Search')
	}
	//-----------------------------------------------------------------------------------
	//		sheet2 이벤트
	//-----------------------------------------------------------------------------------
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				if(!chkInVal()){break;}
				const selectSabun = $("#searchRowSabun").val() === "" ? sheet1.GetCellValue( sheet1.GetSelectRow(), "sabun") : $("#searchRowSabun").val();
				const selectYmd = $("#searchRowYmd").val() === "" ? sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd") : $("#searchRowYmd").val();
				var param = "&selectSabun="+selectSabun
							+ "&selectYmd="+selectYmd;
				sheet2.DoSearch( "${ctx}/WtmDailyWorkMgr.do?cmd=getWtmDailyWorkMgrWrkDtlList", $("#sheetForm").serialize() + param );
				break;
			case "Save":
				IBS_SaveName(document.sheetForm,sheet2);
				var param = "&selectSabun="+sheet1.GetCellValue( sheet1.GetSelectRow(), "sabun")
						+ "&selectYmd="+sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd");
				sheet2.DoSave( "${ctx}/WtmDailyWorkMgr.do?cmd=saveWtmDailyWorkMgrWrkDtl", $("#sheetForm").serialize() + param);
				break;
			case "Insert":
				if (sheet1.GetSelectRow() < 0) {
					alert("Master 데이터를 선택해주시기 바랍니다.");
					return;
				} else {
					var Row = sheet2.DataInsert(0);
					sheet2.SetCellValue(Row, "sabun", sheet1.GetCellValue( sheet1.GetSelectRow(), "sabun"));
					sheet2.SetCellValue(Row, "ymd", sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd"));
					sheet2.SetCellValue(Row, "planSymd", sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd"));
					sheet2.SetCellValue(Row, "planEymd", sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd"));
				}
				break;
			case "Copy":
				var Row = sheet2.DataCopy();
				sheet2.SetCellValue(Row, "realSymd", "");
				sheet2.SetCellValue(Row, "realEymd", "");
				sheet2.SetCellValue(Row, "realMm", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet2.Down2Excel(param);
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if( Code > -1 ) {
				sheet2.RemoveAll();
				doAction1("Search");
			}
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀 변경 시
	function sheet2_OnChange(Row, Col, Value) {
		try {
			const saveName = sheet2.ColSaveName(Col);
			if(saveName === "planSymd" || saveName === "planShm" || saveName === "planEymd" || saveName === "planEhm") {
				// 소요시간 계산
				const symd = sheet2.GetCellValue(Row, "planSymd").replace(/-/gi, "");
				const shm = sheet2.GetCellValue(Row, "planShm").replace(/:/gi, "");
				const eymd = sheet2.GetCellValue(Row, "planEymd").replace(/-/gi, "");
				const ehm = sheet2.GetCellValue(Row, "planEhm").replace(/:/gi, "");
				if(symd && shm && eymd && ehm) {
					const planMm = calcMm(symd, shm, eymd, ehm);
					sheet2.SetCellValue(Row, "planMm", planMm)
				}
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet3 이벤트
	//-----------------------------------------------------------------------------------
	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				if(!chkInVal()){break;}
				const selectSabun = $("#searchRowSabun").val() === "" ? sheet1.GetCellValue( sheet1.GetSelectRow(), "sabun") : $("#searchRowSabun").val();
				const selectYmd = $("#searchRowYmd").val() === "" ? sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd") : $("#searchRowYmd").val();
				var param = "&selectSabun="+selectSabun
						+ "&selectYmd="+selectYmd;

				sheet3.DoSearch( "${ctx}/WtmDailyWorkMgr.do?cmd=getWtmDailyWorkMgrInoutList", $("#sheetForm").serialize() + param);
				break;
			case "Save":
				var param = "&selectSabun="+sheet1.GetCellValue( sheet1.GetSelectRow(), "sabun")
						+ "&selectYmd="+sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd");
				IBS_SaveName(document.sheetForm,sheet3);
				sheet3.DoSave( "${ctx}/WtmDailyWorkMgr.do?cmd=saveWtmDailyWorkMgrInout", $("#sheetForm").serialize() + param);
				break;
			case "Insert":
				if (sheet1.GetSelectRow() < 0) {
					alert("Master 데이터를 선택해주시기 바랍니다.");
					return;
				} else {
					var Row = sheet3.DataInsert(0);
					sheet3.SetCellValue(Row, "sabun", sheet1.GetCellValue( sheet1.GetSelectRow(), "sabun"));
					sheet3.SetCellValue(Row, "ymd", sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd"));
					sheet3.SetCellValue(Row, "inYmd", sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd"));
					sheet3.SetCellValue(Row, "outYmd", sheet1.GetCellValue( sheet1.GetSelectRow(), "ymd"));
				}
				break;
			case "Copy":
				sheet3.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet3.Down2Excel(param);
				break;
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if( Code > -1 ) {
				sheet3.RemoveAll();
				doAction1("Search");
			}
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

        let layerModal = new window.top.document.LayerModal({
            id : 'orgLayer'
            , url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
            , parameters : {}
            , width : 740
            , height : 520
            , title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
            , trigger :[
                {
                    name : 'orgTrigger'
                    , callback : function(result){
                        if(!result.length) return;
                        $("#searchOrgCd").val(result[0].orgCd);
                        $("#searchOrgNm").val(result[0].orgNm);
                    }
                }
            ]
        });
        layerModal.show();
	}

	function clearCode(num) {

		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
		} else {
			$('#name').val("");
		}
	}

	// 소요시간 계산 함수
	function calcMm(symd, shm, eymd, ehm) {
		const sDateTime = makeDateFormat(symd);
		const eDateTime = makeDateFormat(eymd);

		sDateTime.setHours(shm.substring(0, 2), shm.substring(2, 4));
		eDateTime.setHours(ehm.substring(0, 2), ehm.substring(2, 4));

		// 시간 차이 계산 (밀리초 단위)
		const timeDifferenceMs = eDateTime - sDateTime;

		// 밀리초를 분 단위로 변환
		return timeDifferenceMs / (1000 * 60);
	}
</script>
</head>
<body>
<div class="wrapper">
	<input id="searchRowSabun" name="searchRowSabun" type="hidden" >
	<input id="searchRowYmd" name="searchRowYmd" type="hidden" >
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<table>
				<tr>
					<th><tit:txt mid='104060' mdef='근무일'/></th>
					<td>
						<input type="text" id="searchSymd" name="searchSymd" class="date2 required center" /> ~
						<input type="text" id="searchEymd" name="searchEymd" class="date2 required center" />
					</td>
					<th class="hide"><tit:txt mid='104281' mdef='근무지'/></th>
					<td class="hide">
						<select id="searchLocationCd" name="searchLocationCd"> </select>
					</td>	 
					<th><tit:txt mid='114399' mdef='사업장'/></th>
					<td>
						<select id="searchBizPlaceCd" name="searchBizPlaceCd" > </select>
					</td>
					<th>근무유형</th>
					<td>
						<select id="searchWorkClassCd" name="searchWorkClassCd" > </select>
					</td>
				</tr>
				<tr>
					<th>직급</th>
					<td>
						<select id="searchJikgubCd" name="searchJikgubCd" > </select>
					</td>
					<th><tit:txt mid='103784' mdef='사원구분'/></th>
					<td>
						<select id="searchManageCd" name="searchManageCd" > </select>
					</td>
					<th>직군</th>
					<td>
						<select id="searchWorkType" name="searchWorkType" > </select>
					</td>
					<th><tit:txt mid='2017082900947' mdef='출퇴근누락'/></th>
					<td>
						<input type="checkbox" id="searchTimeCheck" name="searchTimeCheck" class="checkbox" value="Y" />
					</td>
				</tr>	
				<tr>
					<th><tit:txt mid='104279' mdef='소속'/></th>
					<td>
					<c:choose>
					<c:when test="${ssnSearchType =='A'}">
						<input type="hidden" id="searchOrgCd" name="searchOrgCd" />
						<input type="text" id="searchOrgNm" name="searchOrgNm"  class="text readonly w100" readonly/><a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
					</c:when>
					<c:otherwise>
						<select id="searchOrgCd" name="searchOrgCd" > </select>
					</c:otherwise>
					</c:choose>
						<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/><tit:txt mid='112471' mdef='하위포함'/>
					</td>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td>
						<input type="text" id="searchSabunName" name="searchSabunName" class="text w100" style="ime-mode:active;" />
					</td>
					<th><tit:txt mid='2017082900949' mdef='지각여부'/></th>
					<td>
						<input type="checkbox" id="searchLateCheck" name="searchLateCheck" class="checkbox" value="Y"/>
					</td>
					<th><tit:txt mid='2017082900949' mdef='근무시간한도체크'/></th>
					<td>
						<input type="checkbox" id="checkLimitYn" name="checkLimitYn" class="checkbox" value="Y" checked/>
					</td>
					<td><btn:a id="btnAllSearch" css="btn dark" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
		</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
	<tr>
		<td class="sheet_left" colspan="2">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='2017082900950' mdef='일근무관리'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
							<btn:a href="javascript:doAction1('Save');"       	css="btn filled authA" mid="save" mdef="저장"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "60%","${ssnLocaleCd}"); </script>
		</td>
	</tr>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">일 근무 상세 관리</li>
						<li class="btn">
							<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
							<a href="javascript:doAction2('Copy')" 	class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction2('Insert')" class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction2('Save')" 	class="btn filled authA">저장</a>
							<a href="javascript:doAction2('Search')" id="btnSearch" class="btn dark authR">조회</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "40%","${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">출퇴근 기록 관리</li>
						<li class="btn">
							<a href="javascript:doAction3('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
							<a href="javascript:doAction3('Copy')" 	class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction3('Insert')" class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction3('Save')" 	class="btn filled authA">저장</a>
							<a href="javascript:doAction3('Search')" class="btn dark authR">조회</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet3", "50%", "40%","${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>