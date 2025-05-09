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
				var data = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=getAppEvaluateeMgrMap1"
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
				sheet1.RemoveAll();
			}catch(e){}
		});

		$("#searchAppStatus").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:5, SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			//{Header:"\n선택|\n선택",								Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"chk",				KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			
			{Header:"사번|사번",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명|성명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:1},
			{Header:"입사일|입사일",		Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"empYmd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header:"현조직코드|현조직코드",Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"nowOrgCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"현소속|현소속",		Type:"Text",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"nowOrgNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header:"조직코드|조직코드",	Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가소속|평가소속",	Type:"Popup",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:1,				UpdateEdit:0,	InsertEdit:1},
			{Header:"평가대상그룹명|평가대상그룹명",
											Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appGroupCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1},
			{Header:"평가그룹|평가그룹",	Type:"Popup",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appGroupNm",	KeyField:1,				UpdateEdit:1,	InsertEdit:1},
			{Header:"직책명|직책명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:1,	InsertEdit:0},
			{Header:"직책|직책",			Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikchakCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직위명|직위명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직위|직위",			Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikweeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},

			{Header:"시작일자|시작일자",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:1,	 PointCount:0,   EditLen:10 },
			{Header:"종료일자|종료일자",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:1,	 PointCount:0,   EditLen:10 },
			{Header:"생성기준일|생성기준일",	Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"cdate",		KeyField:0,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:1,	 PointCount:0,   EditLen:10 },
			{Header:"평가대상\n여부|평가대상\n여부",				
										Type:"CheckBox",	Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"targetYn",	KeyField:0,				UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:1},
			{Header:"평가대상자\n확정여부|평가대상자\n확정여부",	
										Type:"CheckBox",	Hidden:0,					Width:90,	Align:"Center",	ColMerge:1,	SaveName:"appConfirmYn",KeyField:0,				UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:1},
			{Header:"평가상태|평가상태",							
										Type:"Combo",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appStatusCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1	},
			{Header:"평가자기준|평가자기준",							
										Type:"Combo",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appBaseCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1	},
			{Header:"고정항목그룹|고정항목그룹",							
										Type:"Combo",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"setItemGrpCd",KeyField:0,				UpdateEdit:1,	InsertEdit:1	},
			{Header:"비고|비고",			Type:"Text",		Hidden:0,					Width:350,	Align:"Left",	ColMerge:1,	SaveName:"note",		KeyField:0,				UpdateEdit:1,	InsertEdit:1, 	 EditLen:1000},
			{Header:"평가ID",				Type:"Text",		Hidden:1,					Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:1 },
			{Header:"mailId|mailId",	Type:"Text",		Hidden:1,					Width:10,	Align:"Left",	ColMerge:1,	SaveName:"mailId",		KeyField:0},
			//appraisalCd
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");

		var jikchakList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");	//직책
		var jikweeList 	 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");	//직위
		var appStatusList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","P10018"), ""); // 평가상태
		var appBaseList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00008"), ""); // 평가자기준
		var setItemGrpList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), ""); // 고정항목그룹

		sheet1.SetColProperty("jikchakCd",		{ComboText:"|"+jikchakList[0], 		ComboCode:"|"+jikchakList[1]} );
		sheet1.SetColProperty("jikweeCd",		{ComboText:"|"+jikweeList[0], 		ComboCode:"|"+jikweeList[1]} );
		sheet1.SetColProperty("appStatusCd",	{ComboText:"|"+appStatusList[0], 	ComboCode:"|"+appStatusList[1]} );
		$("#searchAppStatus").html("<option value=''>전체</option>"+appStatusList[2]);
		sheet1.SetColProperty("appBaseCd",		{ComboText:"|"+appBaseList[0], 		ComboCode:"|"+appBaseList[1]} );
		sheet1.SetColProperty("setItemGrpCd",	{ComboText:"|"+setItemGrpList[0], 	ComboCode:"|"+setItemGrpList[1]} );
		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"nowOrgNm", rv["orgNm"]);
						
						sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);
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

		sheet1.DoSearch("${ctx}/AppEvaluateeMgr.do?cmd=getAppEvaluateeMgrList1", $("#sheet1Form").serialize());
		break;

	case "Save":		//저장
		if(sheet1.FindStatusRow("I") != ""){
			if(!dupChk(sheet1,"appraisalCd|sabun", true, true)){break;}
		}
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppEvaluateeMgr.do?cmd=saveAppEvaluateeMgr1", $("#sheet1Form").serialize());
		break;

	case "Insert":		//입력
		if ($("#searchAppraisalCd").val() == "") {
			alert("평가명을 선택해 주시기 바랍니다.");
			$("#searchAppraisalCd").focus();
			return;
		}

		var Row = sheet1.DataInsert(0);
		//sheet1.SetCellValue(Row, "appStatusCd", "A0"); //A0 : 목표작성중
		sheet1.SetCellValue(Row, "appraisalCd",$("#searchAppraisalCd").val());
		sheet1.SetCellValue(Row, "appStepCd",$("#searchAppStepCd").val());
		sheet1.SetCellValue(Row, "targetYn", "Y");
		
		break;

	case "Copy":		//행복사
		var Row = sheet1.DataCopy();
		sheet1.SetCellValue(Row, "sabun", "");
		sheet1.SetCellValue(Row, "name", "");
		sheet1.SetCellValue(Row, "nowOrgNm", "");
		sheet1.SetCellValue(Row, "orgNm", "");
		
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

function doSearchEx(gubun){
	if ($("#searchAppraisalCd").val() == "") {
		alert("평가명을 선택해 주시기 바랍니다.");
		$("#searchAppraisalCd").focus();
		return;
	}
	var params = "searchAppraisalCd=" + $("#searchAppraisalCd").val()
	           + "&searchAppStepCd=" + $("#searchAppStepCd").val()
	           + "&searchExtType="+gubun;
	sheet1.DoSearch("${ctx}/AppEvaluateeMgr.do?cmd=getAppEvaluateeMgrList1", params);

}
//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		for (i=sheet1.GetDataFirstRow(); i<=sheet1.GetDataLastRow();i++) {
			var orgCd = sheet1.GetCellValue(i, "orgCd");
			var nowOrgCd = sheet1.GetCellValue(i, "nowOrgCd");
			var bcc = "#f7f8e0";
			if (orgCd != nowOrgCd) {
			//sheet1.SetCellFontColor(i, j, "black");
				sheet1.SetRowBackColor(i, bcc);
				//sheet1.SetCellFontColor(i, "orgNm", "red");
				//sheet1.SetCellBackColor(i, "orgCd", "");
			} else {
				sheet1.SetRowBackColor(i, "");
				//sheet1.SetCellFontColor(i, "orgNm", "");
				//sheet1.SetCellBackColor(i, "orgCd", "");
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
				pGubun = "AppEvaluateeMgrAppSabunPop";

				openPopup("${ctx}/AppEvaluateeMgr.do?cmd=viewAppEvaluateeMgrAppSabunPop&authPg=${authPg}", args, "850","520");
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
			////pGubun = "AppEvaluateeMgrPop";
			//openPopup("${ctx}/AppEvaluateeMgr.do?cmd=viewAppEvaluateeMgrPop", args, "550","520");
			
			var args = new Array();
			args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");

			gPRow = Row;
			pGubun = "AppEvaluateeMgrPop";

			//openPopup("${ctx}/AppEvaluateeMgr.do?cmd=viewAppEvaluateeMgrPop", args, "350","500");
			openPopup("${ctx}/AppEvaluateeMgr.do?cmd=viewAppEvaluateeMgrPop", args, "550","520");
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

	if(confirm("피평가자를 생성 하시겠습니까?")){ // 피평가자를 생성 작업을 하시겠습니까?\n 기존 셋업된 데이터가 초기화 됩니다.
		//showOverlay(0, "피평가자를 생성 중입니다.<br>잠시만 기다려주세요.");
		
		$("#searchBaseYmd").val( $("#searchBaseYmdView").val().replace(/-/g, "") );
		var data = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=prcAppPeopleCreateMgr",$("#sheet1Form").serialize(),false);
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

		var data = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=prcAppEvaluateeMgr1",$("#sheet1Form").serialize(),false);
		if(data.Result.Code == null) {
			alert("처리되었습니다.");
			doAction1("Search");
		} else {
	    	alert(data.Result.Message);
		}
	}
	*/
}

function callProc(val){

	var gb = "";
	if(val == "prcAppEvaluateeMgr3"){//KPI생성
		gb = "KPI를";
	} else if (val == "prcAppEvaluateeMgr4") { //역량생성
		gb = "역량을";
	}

	var chkRows = sheet1.FindCheckedRow("chk");
	var saveArr = chkRows.split("|");

	var param = "&appraisalCd=" + $("#searchAppraisalCd").val();
	param += "&appStepCd=" 	+ $("#searchAppStepCd").val();
	param += "&sabun=&appOrgCd=";

	if(chkRows == "") {
		if(!confirm("기존 데이터 및 평가점수가 초기화 됩니다.\n전체 대상자의 "+gb+" 생성하시겠습니까?")) return;
		param += "&tmpYn=N";

	}else{
		if(!confirm("기존 데이터 및 평가점수가 초기화 됩니다.\n선택한 대상자의 "+gb+" 생성하시겠습니까?")) return;
		var paramTmp =  "s_SAVENAME=sabun,appOrgCd";
		paramTmp += "&searchAppraisalCd=" + $("#searchAppraisalCd").val();
		paramTmp += "&searchAppStepCd=" 	+ $("#searchAppStepCd").val();
		for(var i=0; i < saveArr.length; i++){
			paramTmp += "&sabun=" 		+ sheet1.GetCellValue(saveArr[i],"sabun");
			paramTmp += "&appOrgCd=" 	+ sheet1.GetCellValue(saveArr[i],"appOrgCd");

		}

		//선택한 대상자 미리 저장.
		var dataTmp = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=saveAppEvaluateeMgrTmp", paramTmp, false);
		if(dataTmp.Result.Code != null && dataTmp.Result.Code == "0"){
			alert("처리 중 오류가 발생했습니다.");
			return;
		}else{
			param += "&tmpYn=Y";
		}
	}

	var data ;
	if(val == "prcAppEvaluateeMgr3"){//KPI생성
		data = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=prcAppEvaluateeMgr3",param,false);
	} else if (val == "prcAppEvaluateeMgr4") { //역량생성
		data = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=prcAppEvaluateeMgr4",param,false);
	}

	if(data.Result.Code != null && data.Result.Code != ""){
		alert(data.Result.Message);
	}else{
		alert("처리되었습니다.");
	}
}

// 전체삭제
function deleteAll(){
	if( !confirm("전체삭제를 하시겠습니까?") ) return;

	if ($("#searchAppraisalCd").val() == "") {
		alert("평가명을 선택해 주시기 바랍니다.");
		$("#searchAppraisalCd").focus();
		return;
	}

	var data = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=deleteAppEvaluateeMgrAll",$("#sheet1Form").serialize(),false);
	if(data.Result.Message != "") alert(data.Result.Message);
	if(data.Result.Code != "-1") doAction1("Search");

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
    } else if(pGubun == "AppEvaluateeMgrAppSabunPop"){
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
    } else if(pGubun == "AppEvaluateeMgrPop") {
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
		//pGubun = "AppEvaluateeMgrPop";
		openPopup("${ctx}/AppEvaluateeMgr.do?cmd=viewAppEvaluateeMgrPop", args, "550","520");		
		//openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
	}
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

	var url = "${ctx}/SendPopup.do?cmd=viewMailMgrPopup";
	openPopup(url, args, "900","700", function (rv){

	});
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
							<span>평가상태</span>
							<select name="searchAppStatus" id="searchAppStatus">
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
							<li id="txt" class="txt">피평가자관리
							</li>
							<li class="btn">
								<a href="javascript:sendMail();" 			class="button authA isFin">메일발송</a>
								<a href="javascript:createRcpt()" id="btnRcpt" class="button authA isFin">피평가자생성</a>
								<!-- <a href="javascript:deleteAll()" id="btnDelete" class="basic authA">전체삭제</a> -->
								<a href="javascript:doAction1('Insert')" class="basic authA isFin">입력</a>
								<!-- <a href="javascript:doAction1('Copy')" 	class="basic authA isFin">복사</a> -->
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