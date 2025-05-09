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
		$("#searchAppStatus,#searchAppraisalCd,#searchTargetYn").bind("change",function(event){
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
		initdata.Cfg = {FrozenCol:8, SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			//{Header:"\n선택|\n선택",								Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"chk",				KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"조직코드|조직코드",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"조직|조직",			Type:"Text",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"사번|사번",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명|성명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:1},
			{Header:"직책명|직책명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직책|직책",			Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikchakCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직위명|직위명",		Type:"Text",		Hidden:1,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직위|직위",			Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikweeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가대상\n여부|평가대상\n여부",Type:"CheckBox",Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"targetYn",	KeyField:1,				UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:0},
			{Header:"수습연장\n여부|수습연장\n여부",Type:"CheckBox",Hidden:0,					Width:90,	Align:"Center",	ColMerge:1,	SaveName:"extendYn",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:0},

			{Header:"입사일|입사일",		Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"empYmd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header:"시작일|시작일",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:1,	 PointCount:0,   EditLen:10 },
			{Header:"종료일|종료일",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:1,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:1,	 PointCount:0,   EditLen:10 },
			{Header:"기준일|기준일",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"cdate",		KeyField:1,	Format:"Ymd",UpdateEdit:1, 	InsertEdit:1,	 PointCount:0,   EditLen:10 },
			{Header:"평가상태|평가상태",							
										Type:"Combo",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:1,	SaveName:"appStatusCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0	},
			
			{Header:"비고|비고",			Type:"Text",		Hidden:0,					Width:350,	Align:"Left",	ColMerge:1,	SaveName:"note",		KeyField:0,				UpdateEdit:1,	InsertEdit:1, 	 EditLen:1000},
			{Header:"평가ID",				Type:"Text",		Hidden:1,					Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:1 },
			{Header:"mailId|mailId",	Type:"Text",		Hidden:1,					Width:10,	Align:"Left",	ColMerge:1,	SaveName:"mailId",		KeyField:0},
			//appraisalCd
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");

		var jikchakList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");	//직책
		var jikweeList 	 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");	//직위
		var appStatusList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","P20017"), ""); // 평가상태

		sheet1.SetColProperty("jikchakCd",		{ComboText:"|"+jikchakList[0], 		ComboCode:"|"+jikchakList[1]} );
		sheet1.SetColProperty("jikweeCd",		{ComboText:"|"+jikweeList[0], 		ComboCode:"|"+jikweeList[1]} );
		sheet1.SetColProperty("appStatusCd",	{ComboText:"|"+appStatusList[0], 	ComboCode:"|"+appStatusList[1]} );
		$("#searchAppStatus").html("<option value=''>전체</option>"+appStatusList[2]);
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
						
						sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);
					}
				}
			]
		});

		var appraisalCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListByIntern",false).codeList, "");
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
		sheet1.DoSearch("${ctx}/InternAppEvaluateeMgr.do?cmd=getInternAppEvaluateeMgrList", $("#sheet1Form").serialize());
		break;

	case "Save":		//저장
		if(sheet1.FindStatusRow("I") != ""){
			if(!dupChk(sheet1,"appraisalCd|sabun", true, true)){break;}
		}
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/InternAppEvaluateeMgr.do?cmd=saveInternAppEvaluateeMgr", $("#sheet1Form").serialize());
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
		sheet1.SetCellValue(Row, "appStatusCd", "01");
		sheet1.SetCellValue(Row, "sdate", "${curSysYyyyMMdd}");
		sheet1.SetCellValue(Row, "edate", "${curSysYyyyMMdd}");
		sheet1.SetCellValue(Row, "cdate", "${curSysYyyyMMdd}");
		break;
	case "Copy":		//행복사
		var Row = sheet1.DataCopy();
		break;

	case "Clear":		//Clear
		sheet1.RemoveAll();
		break;

	case "Down2Excel":	//엑셀내려받기
		sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
		break;
	}
}

//조회 후 에러 메시지
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
		var data = ajaxCall("${ctx}/AppEvaluateeMgr.do?cmd=prcInternAppEvaluateeMgrCreate",$("#sheet1Form").serialize(),false);
		if(data.Result.Code == null) {
			alert("처리되었습니다.");
			doAction1("Search");
		} else {
	    	alert(data.Result.Message);
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
    }
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

function clearCode(num) {
	if(num == 1) {
		$("#searchOrgCd").val("");
		$("#searchOrgNm").val("");
		//doAction1("Search");
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
						<td>
							<span>대상여부</span>
							<select name="searchTargetYn" id="searchTargetYn">
								<option value="">전체</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
						<td>
							<span>평가상태</span>
							<select name="searchAppStatus" id="searchAppStatus">
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<span>조직</span>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly/>
							<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
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
							<li id="txt" class="txt">수습평가대상자관리
							</li>
							<li class="btn">
								<!--<a href="javascript:createRcpt()" id="btnRcpt" class="button authA isFin">평가대상자생성</a> -->
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