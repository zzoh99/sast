<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>피평가자관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var vSearchEvlYy = "";
	var gPRow = "";
	var pGubun = "";

	$(function() {
		//평가명 변경 시
		$("#searchAppraisalCd").bind("change",function(event){
			setSearchClear(); //셋팅값 clear
			try{
				var data = ajaxCall("${ctx}/AppEvaluatorMgr.do?cmd=getAppEvaluatorMgrMap1"
							, "searchAppraisalCd=" + $("#searchAppraisalCd").val()
							, false);
				if(data.resultMap != null) {
					var appSYmd = data.resultMap.appSYmd;
					var appEYmd = data.resultMap.appEYmd;
					var baseYmd = data.resultMap.baseYmd;
					var currymd = data.resultMap.currymd;
					var appTypeCd = data.resultMap.appTypeCd;
					var appraisalYy = data.resultMap.appraisalYy;
					var finYn = data.resultMap.finYn;
					
					$("#span_searchAppYmd").html(formatDate(appSYmd,"-")+" ~ "+formatDate(appEYmd,"-"));
					$("#searchBaseYmdView").val(baseYmd);
					$("#span_searchBaseYmdView").html(formatDate($('#searchBaseYmdView').val(),"-"));
					$("#appTypeCd").val(appTypeCd);
					$("#searchAppraisalYy").val(appraisalYy);
					
					$(".isFin").hide();
					if (finYn == "N") { // 해당일정의 마감여부가 Y이면 수정이 불가능 하다.
						$(".isFin").show();
					}
				}

				// 평가자그룹
				var appGroupList	 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppGroupCdList1&" + "searchAppraisalCd=" + $("#searchAppraisalCd").val(), false).codeList, "전체");// 평가그룹
				sheet1.SetColProperty("appGroupCd",		{ComboText:"|"+appGroupList[0], 		ComboCode:"|"+appGroupList[1]} );
				$("#searchGroupCd").html(""+appGroupList[2]);
				doAction1("Search");
			}catch(e){}
		});

		$("#searchAppTypeCd").bind("change", function(event){
			doAction1("Search");
		});

		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13) {
				doAction1("Search"); $(this).focus();
			}
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			<!--{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:1,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },-->
			
			{Header:"피평가자|사번",		Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|성명",		Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|조직코드",	Type:"Text",		Hidden:1,					Width:100,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|평가소속",	Type:"Popup",		Hidden:0,					Width:180,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|평가대상그룹명",
											Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appGroupCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|평가그룹",
											Type:"Popup",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appGroupNm",	KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직책명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직책",		Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikchakCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직위명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직위",		Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikweeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},

			{Header:"평가자구분|평가자구분",Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appTypeCd",	KeyField:1,				UpdateEdit:0,	InsertEdit:1},
			{Header:"차수|차수",			Type:"Int",	  		Hidden:0,  					Width:50,	Align:"Right", 	ColMerge:0, SaveName:"appSeq",		KeyField:1,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
			{Header:"평가자|사번",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appSabun",	KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|성명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appSabunNm",	KeyField:0,				UpdateEdit:1,	InsertEdit:1},
			{Header:"평가자|조직코드",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appOrgCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|조직",			Type:"Popup",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|직책명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appJikchakNm",KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|직책",			Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appJikchakCd",KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|직위명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appJikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가자|직위",			Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appJikweeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"차수별가중치|차수별가중치",Type:"Float",	Hidden:0,					Width:80,	Align:"Right",	ColMerge:0,	SaveName:"seqWeig",		KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"평가완료여부|평가완료여부",Type:"CheckBox",Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appFinYn",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		TrueValue:"Y", 	FalseValue:"N", HeaderCheck:0},
			{Header:"비고|비고",			Type:"Text",		Hidden:0,					Width:350,	Align:"Left",	ColMerge:1,	SaveName:"note",		KeyField:0,				UpdateEdit:1,	InsertEdit:1, 	 EditLen:1000},
			{Header:"평가|평가",			Type:"Text",		Hidden:1,					Width:0,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,},
			
			{Header:"",						Type:"Text",		Hidden:1,					Width:100,	Align:"Left",	ColMerge:1,	SaveName:"chiefSabun",	KeyField:0,},
			{Header:"",						Type:"Text",		Hidden:1,					Width:100,	Align:"Left",	ColMerge:1,	SaveName:"chiefSabun2",	KeyField:0,},
			//appraisalCd
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");

		var jikchakList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");	//직책
		var jikweeList 	 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");	//직위
		var appTypeList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00002"), ""); // 평가자구분
		var appBaseList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00008"), ""); // 평가자기준
		var setItemGrpList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), ""); // 고정항목그룹

		sheet1.SetColProperty("jikchakCd",		{ComboText:"|"+jikchakList[0], 		ComboCode:"|"+jikchakList[1]} );
		sheet1.SetColProperty("jikweeCd",		{ComboText:"|"+jikweeList[0], 		ComboCode:"|"+jikweeList[1]} );
		sheet1.SetColProperty("appJikchakCd",	{ComboText:"|"+jikchakList[0], 		ComboCode:"|"+jikchakList[1]} );
		sheet1.SetColProperty("appJikweeCd",	{ComboText:"|"+jikweeList[0], 		ComboCode:"|"+jikweeList[1]} );
		sheet1.SetColProperty("appFinYn",		{ComboText:"|완료|", 					ComboCode:"|Y|N"} );
		sheet1.SetColProperty("appTypeCd",		{ComboText:"|"+appTypeList[0], 		ComboCode:"|"+appTypeList[1]} );
		$("#searchAppTypeCd").html("<option value=''>전체</option>"+appTypeList[2]);
		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "appSabunNm",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"appSabunNm", rv["name"]);
						sheet1.SetCellValue(gPRow,"appSabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
						
						sheet1.SetCellValue(gPRow,"appJikchakCd", rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"appJikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"appJikweeCd", rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"appJikweeNm", rv["jikweeNm"]);
					}
				}
			]
		});

		var appraisalCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();

		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});
</script>

<script type="text/javascript">
/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	//removeErrMsg();
	switch(sAction){
	case "Search":		//조회
		if ($("#searchAppraisalCd").val() == "") {
			alert("평가명을 선택해 주시기 바랍니다.");
			$("#searchAppraisalCd").focus();
			return;
		}

		sheet1.DoSearch("${ctx}/AppEvaluatorMgr.do?cmd=getAppEvaluatorMgrList1", $("#sheet1Form").serialize());
		break;

	case "Save":		//저장
		if(sheet1.FindStatusRow("I") != ""){
			if(!dupChk(sheet1,"appraisalCd|sabun|appTypeCd|appSeq|appSabun", false, true)){break;}
		}
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppEvaluatorMgr.do?cmd=saveAppEvaluatorMgr1", $("#sheet1Form").serialize());
		break;

	case "Insert":		//입력
		if ($("#searchAppraisalCd").val() == "") {
			alert("평가명을 선택해 주시기 바랍니다.");
			$("#searchAppraisalCd").focus();
			return;
		}
		if(!isPopup()) {return;}

		var args	= new Array();
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["searchOrgNm"] = $("#searchOrgNm").val();
		args["searchSabunName"] = $("#searchSabunName").val();
		args["searchGroupCd"] = $("#searchGroupCd").val();
		gPRow = Row;
		pGubun = "appPeopleMgrAppSabunPop";
		openPopup("${ctx}/AppEvaluatorMgr.do?cmd=viewAppEvaluatorMgrAppSabunPop&authPg=${authPg}", args, "850","520");
		
		/*
		var Row = sheet1.DataInsert(0);
		sheet1.SetCellValue(Row, "appStatusCd", "A0"); //A0 : 목표작성중
		sheet1.SetCellValue(Row, "appraisalCd",$("#searchAppraisalCd").val());
		sheet1.SetCellValue(Row, "appStepCd",$("#searchAppStepCd").val());
		sheet1.SetCellValue(Row, "targetYn", "Y");
		*/
		break;

	case "Copy":		//행복사
		var Row = sheet1.DataCopy();
		sheet1.SetCellValue(Row, "appSabun", "");
		sheet1.SetCellValue(Row, "appSabunNm", "");
		sheet1.SetCellValue(Row, "appOrgCd", "");
		sheet1.SetCellValue(Row, "appOrgNm", "");
		sheet1.SetCellValue(Row, "appJikchakNm", "");
		sheet1.SetCellValue(Row, "appJikchakCd", "");
		sheet1.SetCellValue(Row, "appJikweeNm", "");
		sheet1.SetCellValue(Row, "appJikweeCd", "");
		sheet1.SetCellValue(Row, "appFinYn", "");
		break;
	case "Clear":		//Clear
		sheet1.RemoveAll();
		break;

	case "Down2Excel":	//엑셀내려받기
		sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
		break;

	case "LoadExcel":	//엑셀업로드
		var params = {Mode:"HeaderMatch", WorkSheetNo:1};
		sheet1.LoadExcel(params);
		break;
	}
}

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		// 차수에따른 상급자 체크 
		for (i=sheet1.GetDataFirstRow(); i<=sheet1.GetDataLastRow();i++) {
			var appTypeCd = sheet1.GetCellValue(i, "appTypeCd");
			var sabun = sheet1.GetCellValue(i, "sabun");
			var appSeq = sheet1.GetCellValue(i, "appSeq");
			var appSabun = sheet1.GetCellValue(i, "appSabun");
			var chiefSabun = sheet1.GetCellValue(i, "chiefSabun");
			var chiefSabun2 = sheet1.GetCellValue(i, "chiefSabun2");
			var bcc = "#f7f8e0";
			if (["01", "03", "05"].indexOf(appTypeCd) > -1 && (((appSeq == "1" && sabun != chiefSabun && appSabun != chiefSabun) || (appSeq == "1" && sabun == chiefSabun && appSabun != chiefSabun2))
					|| (appSeq == "2" && appSabun != chiefSabun2))) {
				sheet1.SetRowBackColor(i, bcc);
			} else if (appTypeCd == "07" && ((appSeq == "1" && sabun != chiefSabun && appSabun != chiefSabun2) || (appSeq == "1" && sabun == chiefSabun && appSabun != chiefSabun2))) {
				sheet1.SetRowBackColor(i, bcc);
			} else {
				sheet1.SetRowBackColor(i, "");
			}
		}
		
		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != "") {
			alert(Msg);
		}
		if ( Code != "-1" ) {
			doAction1("Search");
		}
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{
		if ( Row < sheet1.HeaderRows()   ) return;
		if ( sheet1.ColSaveName(Col) == "detail" ) { //평가자 상세

			if(sheet1.GetCellValue(Row,"sStatus") == "I" ) {
				alert("입력중입니다. 저장후 입력하여 주십시오.");
			} else {
				if(!isPopup()) {return;}

				var args	= new Array();
				args["searchAppraisalCd"] = sheet1.GetCellValue(Row,"appraisalCd");
				args["searchAppStepCd"] = sheet1.GetCellValue(Row,"appStepCd");
				args["searchAppOrgCd"] = sheet1.GetCellValue(Row,"appOrgCd");
				args["searchAppOrgNm"] = sheet1.GetCellValue(Row,"appOrgNm");
				args["searchSabun"] = sheet1.GetCellValue(Row,"sabun");
				args["searchName"] = sheet1.GetCellValue(Row,"name");
				args["appTypeCd"] = $("#appTypeCd").val();
				args["searchAppraisalNm"] = $("#searchAppraisalCd option:selected").text();
				gPRow = Row;
				pGubun = "AppEvaluatorMgrAppSabunPop";

				openPopup("${ctx}/AppEvaluatorMgr.do?cmd=viewAppEvaluatorMgrAppSabunPop&authPg=${authPg}", args, "850","520");
			}

		}
	}catch(ex){
		alert("OnClick Event Error : " + ex);
	}
}

//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
function sheet1_OnPopupClick(Row, Col){
	try{
		if( sheet1.ColSaveName(Col) == "name" ) {
			if(!isPopup()) {return;}

			var args	= new Array();

			gPRow = Row;
			pGubun = "employeePopup";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
		}else if( sheet1.ColSaveName(Col) == "orgNm" ) {
			if(!isPopup()) {return;}

			var args	= new Array();
			args["searchAppraisalCd"] 	= $("#searchAppraisalCd").val();
			args["searchAppStepCd"] 	= $("#searchAppStepCd").val();

			gPRow = Row;
			pGubun = "orgTreePopup";

			//openPopup("/Popup.do?cmd=orgTreePopup", args, "680","520");
			openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
		}else if( sheet1.ColSaveName(Col) == "appGroupNm" ) {
			if(!isPopup()) {return;}
			
			//var args = new Array();
			//args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
			////pGubun = "AppPeopleMgrPop";
			//openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "550","520");
			
			var args = new Array();
			args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");

			gPRow = Row;
			pGubun = "AppPeopleMgrPop";

			//openPopup("${ctx}/AppEvaluatorMgr.do?cmd=viewAppPeopleMgrPop", args, "350","500");
			openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "550","520");
		}else if(sheet1.ColSaveName(Col) == "appSabun1Nm"){
			if(!isPopup()) {return;}

			var args	= new Array();

			gPRow = Row;
			pGubun = "employeePopup1";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
		}else if(sheet1.ColSaveName(Col) == "appSabun2Nm"){
			if(!isPopup()) {return;}

			var args	= new Array();

			gPRow = Row;
			pGubun = "employeePopup2";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
		}

	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
}

// 대상자생성
function createRcpt(){
	alert("추후 개발 예정입니다.");
	return false;
	
	if ( $("#searchAppraisalCd").val() == "" ) {
		alert("평가명을 선택해 주세요");
		return;
	}

	if ( $("#searchBaseYmdView").val() == "" ) {
		alert("대상자생성기준일을 평가일정 프로그램에서 입력해 주세요");
		return;
	}

	if(confirm("평가자를 생성 하시겠습니까?")){
		//showOverlay(0, "피평가자를 생성 중입니다.<br>잠시만 기다려주세요.");
		$("#searchBaseYmd").val( $("#searchBaseYmdView").val().replace(/-/g, "") );
		var data = ajaxCall("${ctx}/AppEvaluatorMgr.do?cmd=prcAppPeopleCreateMgr",$("#sheet1Form").serialize(),false);
		if(data.Result.Code == null) {
			alert("처리되었습니다.");
			doAction1("Search");
			//hideOverlay();
		} else {
	    	alert(data.Result.Message);
	    	//hideOverlay();
		}		
	}
	
	/*
	if(confirm("평가대상자 및 1차평가자 생성 작업을 하시겠습니까? \n 기존 셋업된 데이터가 초기화 됩니다.")){
		if(confirm("기정의된 평가방법, 평가SHEET구분 의 변경사항 존재시 덮어쓰시겠습니까?")){
			$("#updYn").val("Y");
		} else{
			$("#updYn").val("N");
		}

		$("#searchBaseYmd").val( $("#searchBaseYmdView").val().replace(/-/g, "") );

		var data = ajaxCall("${ctx}/AppEvaluatorMgr.do?cmd=prcAppEvaluatorMgr1",$("#sheet1Form").serialize(),false);
		if(data.Result.Code == null) {
			alert("처리되었습니다.");
			doAction1("Search");
		} else {
	    	alert(data.Result.Message);
		}
	}
	*/
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');
	if(pGubun == "org") {
    	$("#searchOrgNm").val(rv["orgNm"]);
    	doAction1("Search");
    } else if (pGubun == "group") {
    	$("#searchGroupCd").val(rv["appGroupNm"]);
    	doAction1("Search");
    } else if (pGubun == "appPeopleMgrAppSabunPop") {
    	if( rv["LIST"] != null && rv["LIST"] != undefined ) {
			var LIST = eval(rv["LIST"]);
			if( LIST != null && LIST != undefined && LIST.length > 0 ) {
				var item = null;
				//sheet1.RemoveAll();
				//sheet1.CheckAll("sDelete","1");
				
				for( var i = 0; i < LIST.length; i++) {
					item = LIST[i];
					var row = sheet1.DataInsert(0);
					sheet1.SetCellValue(row, "sabun", 	item.sabun);
					sheet1.SetCellValue(row, "name", 	item.name);
					sheet1.SetCellValue(row, "orgNm", 	item.orgNm);
					sheet1.SetCellValue(row, "appGroupNm", 	item.appGroupNm);
					sheet1.SetCellValue(row, "jikchakCd", 	item.jikchakCd);
					sheet1.SetCellValue(row, "jikchakNm", 	item.jikchakNm);
					sheet1.SetCellValue(row, "jikweeCd", 	item.jikweeCd);
					sheet1.SetCellValue(row, "jikweeNm", 	item.jikweeNm);
					sheet1.SetCellValue(row, "appraisalCd", 	item.appraisalCd);
				}
			}
		}
    } else if(pGubun == "AppEvaluatorMgrAppSabunPop"){
		doAction1("Search");
    } else if(pGubun == "employeePopup") {
		sheet1.SetCellValue(gPRow,"name",(rv["name"]));
		sheet1.SetCellValue(gPRow,"sabun",(rv["sabun"]));
		sheet1.SetCellValue(gPRow,"alias",(rv["alias"]));
		//sheet1.SetCellValue(gPRow,"appOrgNm",(rv["orgNm"]));
		//sheet1.SetCellValue(gPRow,"appOrgCd",(rv["orgCd"]));
		sheet1.SetCellValue(gPRow,"jikgubNm",(rv["jikgubNm"]));
		sheet1.SetCellValue(gPRow,"jikgubCd",(rv["jikgubCd"]));
		sheet1.SetCellValue(gPRow,"jikweeNm",(rv["jikweeNm"]));
		sheet1.SetCellValue(gPRow,"jikweeCd",(rv["jikweeCd"]));
		sheet1.SetCellValue(gPRow,"jikchakNm",(rv["jikchakNm"]));
		sheet1.SetCellValue(gPRow,"jikchakCd",(rv["jikchakCd"]));
		sheet1.SetCellValue(gPRow,"jobCd",(rv["jobCd"]));
		sheet1.SetCellValue(gPRow,"workType",(rv["workType"]));
		sheet1.SetCellValue(gPRow,"workTypeNm",(rv["workTypeNm"]));
    } else if(pGubun == "employeePopup1") {
		sheet1.SetCellValue(gPRow,"appSabun1Nm",(rv["name"]));
		sheet1.SetCellValue(gPRow,"appSabun1",(rv["sabun"]));
		sheet1.SetCellValue(gPRow,"appOrgCd1",(rv["orgCd"]));
    } else if(pGubun == "employeePopup2") {
		sheet1.SetCellValue(gPRow,"appSabun2Nm",(rv["name"]));
		sheet1.SetCellValue(gPRow,"appSabun2",(rv["sabun"]));
		sheet1.SetCellValue(gPRow,"appOrgCd2",(rv["orgCd"]));
    } else if(pGubun == "orgTreePopup") {
		sheet1.SetCellValue(gPRow,"orgNm",(rv["orgNm"]));
		sheet1.SetCellValue(gPRow,"orgCd",(rv["orgCd"]));
    } else if(pGubun == "AppPeopleMgrPop") {
		sheet1.SetCellValue(gPRow,"appGroupCd",(rv["appGroupCd"]));
		sheet1.SetCellValue(gPRow,"appGroupNm",(rv["appGroupNm"]));
    } else if(pGubun == "appPeopleCreatePop") {
    } else if(pGubun == "sheetAutocompleteEmp") {

    	sheet1.SetCellValue(gPRow,"name", rv["name"]);
    	sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);

    	sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
    	sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);

    	sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
    	sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);

    	sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
    	sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);

    	sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
    	sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);

    	sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
    	sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);

    	sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
    	sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);

    	sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
    	sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
	}
}
// 날짜 포맷을 적용한다..
function formatDate(strDate, saper) {
	if(strDate == "") {
		return strDate;
	}

	if(strDate.length == 10) {
		return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
	} else if(strDate.length == 8) {
		return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
	}
}
//
function setSearchClear(){
	$("#span_searchAppYmd").html("");
	$("#searchBaseYmdView").val("");
	$("#span_searchBaseYmdView").html("");
}

function popup(opt){
	pGubun = opt;
	if(opt == "org"){
		openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");	
	} else if (opt == "group") {
		var args = new Array();
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		//pGubun = "AppPeopleMgrPop";
		openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "550","520");		
		//openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
	}
}

function clearCode(num) {

	if(num == 1) {
		$("#searchOrgCd").val("");
		$("#searchOrgNm").val("");
		//doAction1("Search");
	} else {
		$('#searchGroupCd').val("");
		$('#searchGroupNm').val("");
	}
}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" name="searchBaseYmd" id="searchBaseYmd">
		<input type="hidden" name="updYn" id="updYn">
		<input type="hidden" name="appTypeCd" id="appTypeCd">
		<input type="hidden" name="searchAppraisalYy" id="searchAppraisalYy">

		<div class="sheet_search sheet_search_o outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td colspan="1">
							<span>평가시행기간</span>
							<span id="span_searchAppYmd" class="txt" style="font-weight:normal"></span>
						</td>
						<td><span>대상자생성기준일 </span>
							<input type="hidden" id="searchBaseYmdView" name="searchBaseYmdView" />
							<span id="span_searchBaseYmdView" class="txt" style="font-weight:normal"></span>
						</td>
					</tr>
					<tr>
						<td>
							<span>성명/사번</span>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
						</td>
						<td>
							<span>평가소속</span>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly/>
							<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						</td>
						<td>
							<span>평가그룹</span>
							<input id="searchGroupCd" name="searchGroupCd" type="text" class="text" readonly/>
							<a onclick="javascript:popup('group')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode(2)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
							<!-- <select name="searchGroupCd" id="searchGroupCd"></select> -->
						</td>
						<td>
							<span>평가자구분</span>
							<select name="searchAppTypeCd" id="searchAppTypeCd">
							</select>
						</td>
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
							<li id="txt" class="txt">평가자관리
							</li>
							<li class="btn">
								<a href="javascript:createRcpt()" id="btnRcpt" class="button authA isFin">평가자생성</a>
								<!-- <a href="javascript:deleteAll()" id="btnDelete" class="basic authA">전체삭제</a> -->
								<a href="javascript:doAction1('Insert')" class="basic authA isFin">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA isFin">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA isFin">저장</a>
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