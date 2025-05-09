<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='' mdef='연간입퇴사자현황'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">


var gPRow = "";
var pGubun = "";
var ssnSearchType = "${ssnSearchType}";
var enterCd = "${ssnEnterCd}".toUpperCase();
	$(function() {

		if("${ssnEnterAllYn}" == "Y"){
			// $("#spEnterCombo").removeClass("hide");
			$(".spEnterCombo").removeClass("hide");
		}
		
		// 사진포함 보여주기
		/*
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}
		*/

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:8,MergeSheet:msNone};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [

			{Header:"<sht:txt mid='No' mdef='No'/>"				,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>"		,Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='gubun1' mdef='구분'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:1, SaveName:"gubun1", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='gubun2' mdef='구분'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:1, SaveName:"gubun2", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

			{Header:"<sht:txt mid='mm00' mdef='전년12월'/>"			,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm00", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm01' mdef='1월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm01", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm02' mdef='2월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm02", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm03' mdef='3월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm03", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm04' mdef='4월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm04", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm05' mdef='5월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm05", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm06' mdef='6월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm06", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm07' mdef='7월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm07", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm08' mdef='8월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm08", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm09' mdef='9월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm09", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm10' mdef='10월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm10", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm11' mdef='11월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm11", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm12' mdef='12월'/>"				,Type:"Text",      	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0, SaveName:"mm12", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='mm13' mdef='이직율/월'/>"			,Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0, SaveName:"mm13", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"<sht:txt mid='mm14' mdef='이직율/년'/>"			,Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0, SaveName:"mm14", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);
		sheet1.SetEditableColorDiff(0); //기본색상 출력

		//sheet1.SetDataRowMerge(1);



	    var initdata1 = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:8,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
			{Header:"<sht:txt mid='No' mdef='No'/>"			,Type:"${sNoTy}",	Hidden:0, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>"	,Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>"	,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='authYn' mdef='권한여부'/>" ,Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 },
			{Header:"<sht:txt mid='enterCd' mdef='회사코드'/>"		,Type:"Text",		Hidden:1,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"enterCd", UpdateEdit:0 },
			{Header:"<sht:txt mid='gubun' mdef='구분'/>"			,Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0, SaveName:"gubun", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='photo' mdef='사진'/>"   ,Type:"Image",       Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60, Cursor:"Pointer" },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>"			,Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0, SaveName:"sabun", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='name' mdef='성명'/>"			,Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0, SaveName:"name", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='orgNm' mdef='소속'/>"			,Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0, SaveName:"orgNm", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      Hidden:0,  Width:60, Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='jikweeNm' mdef='직위'/>",	    	Type:"Text",      Hidden:Number("${jwHdn}"),  Width:80, Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",	    	Type:"Text",      Hidden:Number("${jgHdn}"),  Width:80, Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='workTypeNm' mdef='직군'/>",	    Type:"Text",      Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"workTypeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='manageNm' mdef='사원구분'/>",	    Type:"Text",      Hidden:0,  Width:80, Align:"Center",  ColMerge:0,   SaveName:"manageNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
			{Header:"<sht:txt mid='ymd' mdef='입/퇴사일'/>"		,Type:"Date",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0, SaveName:"ymd", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='resignReasonNm' mdef='퇴직사유'/>"		,Type:"Text",      	Hidden:1,  Width:150,  Align:"Center",  ColMerge:0, SaveName:"resignReasonNm", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='ordDetailNm' mdef='발령상세'/>",	    	Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"ordDetailNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='ordReasonNm' mdef='발령세부사유'/>",	    	Type:"Text",      Hidden:1,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"ordReasonNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='memo' mdef='비고'/>",	    		Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"memo",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='bpCd' mdef='사업장'/>"			,Type:"Text",      	Hidden:1,  Width:60,   Align:"Center",  ColMerge:0, SaveName:"bpCd", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			

		];IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);
		sheet2.SetEditableColorDiff(0); //기본색상 출력

		// 회사코드
		var enterCdList   = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getGroupEnterCdList", false).codeList, "");
		$("#groupEnterCd").html(enterCdList[2]);
		$("#groupEnterCd").val("${ssnEnterCd}");
		$("#groupEnterCd").on("change", function(event) {
			
			//직위
			var searchJikweeCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&enterCd="+$("#groupEnterCd").val(),"H20030"), "");
			$("#searchJikweeCd").html(searchJikweeCd[2]);
			$("#searchJikweeCd").select2({
				placeholder: "전체"
				, maximumSelectionSize:100
			});
			//직책
			var searchJikchakCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&enterCd="+$("#groupEnterCd").val(),"H20020"), "");
			$("#searchJikchakCd").html(searchJikchakCd[2]);
			$("#searchJikchakCd").select2({
				placeholder: "전체"
				, maximumSelectionSize:100
			});
			//직급
			var searchJikgubCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&enterCd="+$("#groupEnterCd").val(),"H20010"), "");
			$("#searchJikgubCd").html(searchJikgubCd[2]);
			$("#searchJikgubCd").select2({
				placeholder: "전체"
				, maximumSelectionSize:100
			});
			//직군
			var searchWorkType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&enterCd="+$("#groupEnterCd").val(),"H10050"), "");
			$("#searchWorkType").html(searchWorkType[2]);
			$("#searchWorkType").select2({
				placeholder: "전체"
				, maximumSelectionSize:100
			});
			//사원구분
			var searchManageCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&enterCd="+$("#groupEnterCd").val(),"H10030"), "");
			$("#searchManageCd").html(searchManageCd[2]);
			$("#searchManageCd").select2({
				placeholder: "전체"
				, maximumSelectionSize:100
			});
			

			doAction1("Search");

		}).change();

        $(window).smartresize(sheetResize); sheetInit();


		$("#searchPhotoYn").click(function() {
			doAction2('Search')
		});

		$("#searchPhotoYn").attr('checked', 'checked');

        $("#searchYear").bind("keyup",function(event){
        	makeNumber(this,"A");
    		if( event.keyCode == 13){
				doAcation("Search");
    		}
    	});

        $("#searchMonth").bind("keyup",function(event){
        	makeNumber(this,"A");
    		if( event.keyCode == 13){
				doAction2('Search')
    		}
    	});

		init();
	});


</script>

<script type="text/javascript">
function checkList(){
	if($("#searchYear").val().length != 4){
		alert("조회 년도를 정확히 입력 해주세요");
		$("#searchYear").focus();
		return false;
	}

	if($("#searchMonth").val() != "" && Number($("#searchMonth").val()) > 12){
		alert("조회 월을 정확히 입력 해주세요");
		$("#searchMonth").focus();
		return false;
	}
	return true;
}

/**
 * Sheet 각종 처리
 */
function doAcation(sAction) {
	switch(sAction){
		case "Search":		//조회
			if( !checkList() ) return;
			doAction1("Search");
			doAction2('Search');
			break;
	}
}

function doAction1(sAction){

	switch(sAction){
	case "Search":		//조회
		if( !checkList() ) return;
		if($("#searchYear").val() != ""){
			$("#yyyyMm00").val(($("#searchYear").val() - 1) + "1201");
			$("#yyyyMm01").val($("#searchYear").val() + "0101");
			$("#yyyyMm02").val($("#searchYear").val() + "0201");
			$("#yyyyMm03").val($("#searchYear").val() + "0301");
			$("#yyyyMm04").val($("#searchYear").val() + "0401");
			$("#yyyyMm05").val($("#searchYear").val() + "0501");
			$("#yyyyMm06").val($("#searchYear").val() + "0601");
			$("#yyyyMm07").val($("#searchYear").val() + "0701");
			$("#yyyyMm08").val($("#searchYear").val() + "0801");
			$("#yyyyMm09").val($("#searchYear").val() + "0901");
			$("#yyyyMm10").val($("#searchYear").val() + "1001");
			$("#yyyyMm11").val($("#searchYear").val() + "1101");
			$("#yyyyMm12").val($("#searchYear").val() + "1201");
		}
	
		sheet1.DoSearch("${ctx}/YearEmpSta.do?cmd=getYearEmpStaList33", $("#sheet1Form").serialize());
		break;

	case "Save":		//저장

		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/YearEmpSta.do?cmd=saveAppGradeTableMgr", $("#sheet1Form").serialize());
		break;

	case "Insert":		//입력

		var Row = sheet1.DataInsert(0);
		sheet1.SetCellValue(Row, "apprasialCd",$("#searchAppTypeCd").val());	//평가명
		sheet1.SetCellValue(Row, "gubunCd","A");								//평가구분
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

	case "LoadExcel":	//엑셀업로드

		var params = {Mode:"HeaderMatch", WorkSheetNo:1, Append :1}; sheet1.LoadExcel(params);
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

		sheet1.SetCellValue(6,"mm00", sheet1.GetCellValue(6,"mm00") + "%");
		sheet1.SetCellValue(6,"mm01", sheet1.GetCellValue(6,"mm01") + "%");
		sheet1.SetCellValue(6,"mm02", sheet1.GetCellValue(6,"mm02") + "%");
		sheet1.SetCellValue(6,"mm03", sheet1.GetCellValue(6,"mm03") + "%");
		sheet1.SetCellValue(6,"mm04", sheet1.GetCellValue(6,"mm04") + "%");
		sheet1.SetCellValue(6,"mm05", sheet1.GetCellValue(6,"mm05") + "%");
		sheet1.SetCellValue(6,"mm06", sheet1.GetCellValue(6,"mm06") + "%");
		sheet1.SetCellValue(6,"mm07", sheet1.GetCellValue(6,"mm07") + "%");
		sheet1.SetCellValue(6,"mm08", sheet1.GetCellValue(6,"mm08") + "%");
		sheet1.SetCellValue(6,"mm09", sheet1.GetCellValue(6,"mm09") + "%");
		sheet1.SetCellValue(6,"mm10", sheet1.GetCellValue(6,"mm10") + "%");
		sheet1.SetCellValue(6,"mm11", sheet1.GetCellValue(6,"mm11") + "%");
		sheet1.SetCellValue(6,"mm12", sheet1.GetCellValue(6,"mm12") + "%");
		sheet1.SetCellValue(6,"mm13", sheet1.GetCellValue(6,"mm13") + "%");
		sheet1.SetCellValue(6,"mm14", sheet1.GetCellValue(6,"mm14") + "%");

		sheet1.SetMergeCell(0, 3, 1, 2);
		sheet1.SetMergeCell(1, 3, 1, 2);
		sheet1.SetMergeCell(2, 3, 1, 2);
		sheet1.SetMergeCell(3, 3, 1, 2);
		sheet1.SetMergeCell(4, 3, 1, 2);
		sheet1.SetMergeCell(6, 3, 1, 2);

		sheet1.SetCellValue(6, "sStatus", 'R');  
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){
			alert(Msg);
		}
		doAction1("Search");
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnLoadExcel() {

	for(var i = 1; i < sheet1.LastRow()+1; i++) {
		if(sheet1.GetCellValue(i,"sStatus") == "I") {
			sheet1.SetCellValue(i, "apprasialCd", $("#searchAppTypeCd").val());
			sheet1.SetCellValue(i, "gubunCd","A");								//평가구분
		}
	}
}

function doAction2(sAction){

	switch(sAction){
	case "Search":		//조회
		if( !checkList() ) return;
		checkMonth();
		sheet2.DoSearch("${ctx}/YearEmpSta.do?cmd=getYearEmpStaList2", $("#sheet1Form").serialize());
		break;

	case "Save":		//저장

		sheet2.HideSubSum();

		if(sheet2.FindStatusRow("I") != ""){
			if(!dupChk(sheet2,"appraisalCd|divideGubunCd|appGrade", true, true)){break;}
		}

		IBS_SaveName(document.sheet1Form,sheet1);
		sheet2.DoSave( "${ctx}/YearEmpSta.do?cmd=saveAppGradeTableMgr", $("#sheet1Form").serialize());
		break;

	case "Insert":		//입력

		var Row = sheet2.DataInsert(0);
		sheet2.SetCellValue(Row, "apprasialCd",$("#searchAppTypeCd").val());	//평가명
		sheet2.SetCellValue(Row, "gubunCd","B");								//평가구분
		break;

	case "Copy":		//행복사
		var Row = sheet2.DataCopy();
		break;

	case "Clear":		//Clear
		sheet2.RemoveAll();
		break;

	case "Down2Excel":	//엑셀내려받기
		sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2),SheetDesign:1,Merge:1});
		break;

	case "LoadExcel":	//엑셀업로드
		var params = {Mode:"HeaderMatch", WorkSheetNo:1, Append :1}; sheet2.LoadExcel(params);
		break;
	}
}


//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != ""){
			alert(Msg);
		}

		if($("#searchPhotoYn").is(":checked") == true){
			sheet2.SetDataRowHeight(60);
			sheet2.SetColHidden("photo", 0);
		}else{
			sheet2.SetAutoRowHeight(0);
			sheet2.SetDataRowHeight(24);
			sheet2.SetColHidden("photo", 1);
		}

		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

//저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != ""){
			alert(Msg);
		}
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet2_OnLoadExcel() {

	for(var i = 1; i < sheet2.LastRow()+1; i++) {
		if(sheet2.GetCellValue(i,"sStatus") == "I") {
			sheet2.SetCellValue(i, "apprasialCd", $("#searchAppTypeCd").val());
			sheet2.SetCellValue(i, "gubunCd","B");								//평가구분
		}
	}
}

function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	//팝업
	if(sheet2.ColSaveName(Col) == "photo" || sheet2.ColSaveName(Col) == "name"){
		
		var authYn = sheet1.GetCellValue(Row, "authYn");
		
		if( ssnSearchType =="A" ){	
			if( "${profilePopYn}"=="Y"){
				// 인사기본 팝업 
				var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
	            var args    = new Array();
	            args["sabun"]      = sheet2.GetCellValue(Row, "sabun");
	            args["enterCd"]    = "${ssnEnterCd}";
	            args["empName"]    = sheet2.GetCellValue(Row, "name");
	            args["mainMenuCd"] = "240";	            
	            args["menuCd"]     = "112";
	            args["grpCd"]       = "${ssnGrpCd}";
				openPopup(url,args,"1250","780");
				
			}else{
				var sabun  = sheet2.GetCellValue(Row,"sabun")
				var enterCd =$("#groupEnterCd").val();
				goMenu(sabun, enterCd);

			}
		}else if(ssnSearchType == "P"){
			profilePopup(Row);
		}else if(ssnSearchType == "O"){
			/* 적용안함
			var authYn = sheet1.GetCellValue(Row, "authYn");
			if(authYn == "Y"){
				if( "${profilePopYn}"=="Y"){
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = sheet1.GetCellValue(Row, "sabun");
		            args["enterCd"]    = "${ssnEnterCd}";
		            args["empName"]    = sheet1.GetCellValue(Row, "name");
		            args["mainMenuCd"] = "240";	            
		            args["menuCd"]     = "112";
		            args["grpCd"]       = "${ssnGrpCd}";
					openPopup(url,args,"1250","780");
					
				}else{
					var sabun  = sheet1.GetCellValue(Row,"sabun")
					var enterCd =$("#groupEnterCd").val();
					goMenu(sabun, enterCd);
				}
			}else{
				profilePopup(Row);
			}
			*/
		}else{
			profilePopup(Row);
		}
		
	}
}	

	/**
	 * 조직원 프로필 window open event
	 */
	 function profilePopup(Row){
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "viewEmpProfile";

  		var w 		= 610;
		var h 		= 350;
		var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
		var args 	= new Array();
		args["sabun"] 		= sheet2.GetCellValue(Row, "sabun");
		args["enterCd"] 	= sheet2.GetCellValue(Row, "enterCd");

		var rv = openPopup(url,args,w,h);
	}
	
	// 비교대상 화면으로 이동
	function goMenu(sabun, enterCd) {

        //비교대상 정보 쿠키에 담아 관리
        var paramObj = [{"key":"searchSabun", "value":sabun},{"key":"searchEnterCd", "value":enterCd}];

        //var prgCd = "View.do?cmd=viewPsnalBasicInf";
        var prgCd = "PsnalBasicInf.do?cmd=viewPsnalBasicInf";
        var location = "인사관리 > 인사정보 > 인사기본";


        var $form = $('<form></form>');
        $form.appendTo('body');
        var param1 	= $('<input name="prgCd" 	type="hidden" 	value="'+prgCd+'">');
        var param2 	= $('<input name="goMenu" 	type="hidden" 	value="Y">');
        $form.append(param1).append(param2);

    	var prgData = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getCompareEmpOpenPrgMap",$form.serialize(),false);

    	if(prgData.map == null) {
			alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			return;
		}

		if (typeof goSubPage == 'undefined') {
			// 서브페이지에서 서브페이지 호출
			if (typeof window.top.goOtherSubPage == 'function') {
				window.top.goOtherSubPage("", "", "", "", prgData.map.prgCd);
			}
		} else {
			goSubPage("", "", "", "", prgData.map.prgCd);
		}

    	// var lvl 		= prgData.map.lvl;
    	// var menuId		= prgData.map.menuId;
		// var menuNm 		= prgData.map.menuNm;
		// var menuNmPath	= prgData.map.menuNmPath;
		// var prgCd 		= prgData.map.prgCd;
		// var mainMenuNm 	= prgData.map.mainMenuNm;
		// var surl      	= prgData.map.surl;
		// parent.openContent(menuNm,prgCd,location,surl,menuId,paramObj);
	}	

function init(){
	//appendYear();
	//payComCode();

	doAcation("Search");

}


function appendYear(){

	var date = new Date();
	var year = date.getFullYear();
	var selectValue = document.getElementById("year");
	var optionIndex = 0;

	for(var i=year; i>=year-10; i--){
		$("#searchYear").append("<option value='"+i+"'>"+i+"년</option>");
	}

}


//사업장 조회
function payComCode(){

	var payComCode = ajaxCall("${ctx}/YearEmpSta.do?cmd=getPayComCode", $("#srchFrm").serialize(), false);
	if(payComCode.DATA !=""){
		//select box 옵션 삭제
		$("select[name='searchBusinessPlaceCd'] option").remove();
		$.each(payComCode.DATA, function(idx, value){
			if(idx == 0){ $("#searchBusinessPlaceCd").append("<option value=''>전체</option>"); }
			$("#searchBusinessPlaceCd").append("<option value='"+value.businessPlaceCd+"'>"+value.mapNm+"</option>");
		});
	} else {
		$("#searchBusinessPlaceCd").append("<option value=''>전체</option>");
	}

}

function searchAllChart() {

	$("#jikgubCd").val(($("#searchJikgubCd").val()==null?"":getMultiSelect($("#searchJikgubCd").val())));
	$("#workType").val(($("#searchWorkType").val()==null?"":getMultiSelect($("#searchWorkType").val())));
	$("#manageCd").val(($("#searchManageCd").val()==null?"":getMultiSelect($("#searchManageCd").val())));

	$("#jikweeCd").val(($("#searchJikweeCd").val()==null?"":getMultiSelect($("#searchJikweeCd").val())));
	$("#jikchakCd").val(($("#searchJikchakCd").val()==null?"":getMultiSelect($("#searchJikchakCd").val())));

	doAction2("Search");

}

function checkMonth(){
	if($("#searchMonth").val().length < 2 && $("#searchMonth").val() != ""){
		$("#searchMonth").val("0" + $("#searchMonth").val());
		$("#searchMonth2").val($("#searchYear").val() + $("#searchMonth").val());
	} else if($("#searchMonth").val().length == 2){
		$("#searchMonth2").val($("#searchYear").val() + $("#searchMonth").val());
	} else if($("#searchMonth").val() == "") {
		$("#searchMonth2").val($("#searchYear").val());
	}
}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="yyyyMm00" name="yyyyMm00">
	<input type="hidden" id="yyyyMm01" name="yyyyMm01">
	<input type="hidden" id="yyyyMm02" name="yyyyMm02">
	<input type="hidden" id="yyyyMm03" name="yyyyMm03">
	<input type="hidden" id="yyyyMm04" name="yyyyMm04">
	<input type="hidden" id="yyyyMm05" name="yyyyMm05">
	<input type="hidden" id="yyyyMm06" name="yyyyMm06">
	<input type="hidden" id="yyyyMm07" name="yyyyMm07">
	<input type="hidden" id="yyyyMm08" name="yyyyMm08">
	<input type="hidden" id="yyyyMm09" name="yyyyMm09">
	<input type="hidden" id="yyyyMm10" name="yyyyMm10">
	<input type="hidden" id="yyyyMm11" name="yyyyMm11">
	<input type="hidden" id="yyyyMm12" name="yyyyMm12">

	<input type="hidden" id="searchMonth2" name="searchMonth2">
	
	<input type="hidden" id="except1" name="except1"/>
	<input type="hidden" id="except2" name="except2"/>
	<input type="hidden" id="except3" name="except3"/>			

		<div class="sheet_search outer">
			<div>
				<table>
				<!--
				 <colgroup>
				    <col width="17%"/>
				    <col width="17%"/>
				    <col width="17%"/>
				    <col width="17%"/>
				    <col width="17%"/>
				    <col width="17%"/>
				 </colgroup>
				 -->
					<tr>
						<th class="spEnterCombo hide">회사</th>
						<td class="spEnterCombo hide">
							<select id="groupEnterCd" name="groupEnterCd" class="w150"></select>
						</td>
						<th><tit:txt mid='' mdef='년도'/></th>
						<td>
							<!-- select name="searchYear" id="searchYear" onChange="javaScript:doAction1('Search');doAction2('Search');"></select -->
							<input type="text"   id="searchYear"  name="searchYear" value="${curSysYear}"  class="date2 w80" style="ime-mode:disabled" maxlength="4"/>
						</td>
						<th><tit:txt mid='' mdef='월'/></th>
						<td>
							<input type="text"   id="searchMonth"  name="searchMonth" class="text w50" style="ime-mode:disabled" maxlength="2"/>
						</td>
						<th class="hide"><tit:txt mid='' mdef='사업장'/></th>
						<td class="hide">
							<select id="searchBusinessPlaceCd" name ="searchBusinessPlaceCd" onChange="javascript:doAcation('Search');" class="box"></select>
						</td>
						<th><tit:txt mid='' mdef='입/퇴사'/></th>
						<td>
							<select id="selectGubun" name ="selectGubun" onChange="javascript:doAction2('Search');" class="box">
								<option value="">전체</option>
								<option value="1">입사자</option>
								<option value="2">퇴사자</option>
							</select>
						</td>
						<!-- 
						<td colspan="2">
							<span>제외 :
							<input id="checkExcept1" name="checkExcept1" type="checkbox"  class="checkbox" />&nbsp;휴직자
							<input id="checkExcept2" name="checkExcept2" type="checkbox"  class="checkbox" />&nbsp;등기임원
							<input id="checkExcept3" name="checkExcept3" type="checkbox"  class="checkbox" />&nbsp;인턴		
							</span>
						</td>
						 -->							
					</tr>
						<tr>
							<th>직책</th>
							<td>
								<select id="searchJikchakCd" name="searchJikchakCd" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="jikchakCd" name="jikchakCd"/>
							</td>
							<th>직위</th>
							<td>
								<select id="searchJikweeCd" name="searchJikweeCd" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="jikweeCd" name="jikweeCd"/>
							</td>
							<th>직급</th>
							<td>
								<select id="searchJikgubCd" name="searchJikgubCd"" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="jikgubCd" name="jikgubCd" value=""/>
							</td>
							<th>직군</th>
							<td>
								<select id="searchWorkType" name="searchWorkType"" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="workType" name="workType" value=""/>
							</td>
							<th>사원구분</th>
							<td>
								<select id="searchManageCd" name="searchManageCd"" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="manageCd" name="manageCd" value=""/>
							</td>
							<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
							<td>
								<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
							</td>
							<td><btn:a href="javascript:doAcation('Search');" css="btn dark" mid='search' mdef="조회"/></td>
						</tr>

				</table>
			</div>
		</div>
	<table border=0 cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='' mdef='전체 이직율'/></li>
					<li class="btn"><btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/></li>
				</ul>
			</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "178px","kr"); </script>
			</td>
		</tr>
	</table>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='' mdef='입/퇴사자 정보'/></li>
					<li class="btn"><btn:a href="javascript:doAction2('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/></li>
				</ul>
			</div>

				<script type="text/javascript">createIBSheet("sheet2", "100%", "59%","kr"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>