<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가진척관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var classCdPointList = "";
	$(function() {
		
		//평가명 변경 시
		$("#searchAppraisalCd").bind("change",function(event){
			setSearchClear(); //셋팅값 clear
			try{
				var data = ajaxCall("${ctx}/AppEvalProgressMng.do?cmd=getAppEvalProgressMngMap1"
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
				appGroupList	 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppGroupCdList1&" + "searchAppraisalCd=" + $("#searchAppraisalCd").val(), false).codeList, "전체");// 평가그룹
				sheet1.SetColProperty("appGroupCd",		{ComboText:"|"+appGroupList[0], 		ComboCode:"|"+appGroupList[1]} );
				$("#searchGroupCd").html(""+appGroupList[2]);

				// 평가척도
				var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCd&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "전체"); // 평가등급
				classCdPointList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassPoint&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "전체"); // 평가등급
				sheet1.SetColProperty("appFinClassCd",	{ComboText:"|"+classCdList[0], 		ComboCode:"|"+classCdList[1]} );
				sheet1.SetColProperty("finClassCd",		{ComboText:"|"+classCdList[0], 		ComboCode:"|"+classCdList[1]} );
				if (isPgmGubun("ZG")) {
					$("#searchFinClassCd").html(classCdList[2]);
				}
				doAction1("Search");
				sheet1.RemoveAll();
			}catch(e){}
		});

		$("#searchAppStatus, #searchFinClassCd").bind("change",function(event){
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
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		var isHidden = isPgmGubun("ZG") ? 1 : 0;
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			//{Header:"\n삭제|\n삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			//{Header:"\n선택|\n선택",								Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"chk",				KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			
			{Header:"피평가자|사번",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|성명",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|조직코드",		Type:"Text",		Hidden:1,		Width:150,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|평가소속",		Type:"Popup",		Hidden:0,		Width:60,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|평가대상그룹명",
										Type:"Text",		Hidden:1,		Width:180,	Align:"Left",	ColMerge:1,	SaveName:"appGroupCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|평가그룹",
										Type:"Text",		Hidden:isHidden,Width:180,	Align:"Left",	ColMerge:1,	SaveName:"appGroupNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:1},
			{Header:"피평가자|직책명",		Type:"Text",		Hidden:1,		Width:80,	Align:"Left",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직책",		Type:"Combo",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"jikchakCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직위명",		Type:"Text",		Hidden:1,		Width:80,	Align:"Left",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직위",		Type:"Combo",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"jikweeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가ID",				Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"진행상태|진행상태",		Type:"Combo",		Hidden:isHidden,Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appStatusCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:0}
		];
		
		//initdata.Cols.push({Header:"진행상태|진행상태",		Type:"Combo",		Hidden:isHidden,		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appStatusCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1});
		if (isPgmGubun("ZA")) { // 목표설정관리
			$("#txt").html("목표설정준비");
			initdata.Cols.push({Header:"목표확인|목표확인",		Type:"Image",		Hidden:0,		Width:35,		Align:"Center",		ColMerge:0,		SaveName:"detail",		Cursor:"Pointer" });
			initdata.Cols.push({Header:"1차합의자|사번",		Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zaSabun",		UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"1차합의자|성명",		Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zaName",		UpdateEdit:0,	InsertEdit:0});
			sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
		} else if (isPgmGubun("ZB")) { // 중간면담관리
			$("#txt").html("중간점검준비");
			initdata.Cols.push({Header:"본인중간면담|사번",		Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zbSabun0",	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"본인중간면담|성명",		Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zbName0",		UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"1차 중간점검자|사번",	Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zbSabun1",	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"1차 중간점검자|성명",	Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zbName1",		UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"2차 중간점검자|사번",	Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zbSabun2",	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"2차 중간점검자|성명",	Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zbName2",		UpdateEdit:0,	InsertEdit:0});
		} else if (isPgmGubun("ZC")) { // 평가관리(1차)
			$("#txt").html("평가준비");
			initdata.Cols.push({Header:"1차 평가자|사번",	Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zcSabun1",	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"1차 평가자|성명",	Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zcName1",		UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"1차 평가자|점수",	Type:"Float",		Hidden:0,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"app1stScr",	UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
			initdata.Cols.push({Header:"1차 평가결과|평균점수",	Type:"Float",		Hidden:0,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"app1stScr2",	UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
			initdata.Cols.push({Header:"1차 평가결과|순위",		Type:"Float",		Hidden:0,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"app1stRk",	UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:0});
		} else if (isPgmGubun("ZD")) { // 평가관리(2차)
			$("#txt").html("평가준비");
			initdata.Cols.push({Header:"2차 평가자|사번",		Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zdSabun1",		UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"2차 평가자|성명",		Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"zdName1",			UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"2차 평가자|등급",		Type:"Combo",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"app2ndClassCd",	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"1차 평가결과|평균점수",	Type:"Float",		Hidden:0,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"app1stScr",		UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
			initdata.Cols.push({Header:"1차 평가결과|순위",		Type:"Float",		Hidden:0,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"app1stRk",		UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:0});
			//{Header:"진행상태|진행상태",		Type:"Combo",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appStatusCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1}/
		} else if (isPgmGubun("ZE")) { // 이의신청
			$("#txt").html("이의신청");
			initdata.Cols.push({Header:"2차 평가|등급",		 	Type:"Text",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"app2ndClassCd",	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"1차 평가결과|평균점수",	Type:"Float",		Hidden:0,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"app1stScr",		UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
			initdata.Cols.push({Header:"1차 평가결과|순위",	 	Type:"Float",		Hidden:0,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"app1stRk",		UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:0});
			initdata.Cols.push({Header:"평가결과|등급",			Type:"Combo",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"appFinClassCd",	UpdateEdit:1,	InsertEdit:0});
			initdata.Cols.push({Header:"평가결과|점수",			Type:"Float",		Hidden:1,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"appFinClassPoint",UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
			initdata.Cols.push({Header:"이의신청|이의신청내용",	Type:"Text",		Hidden:0,		Width:200,		Align:"Left",		ColMerge:0,		SaveName:"selfFeedMemo",	UpdateEdit:1,	InsertEdit:1, 	EditLen:4000,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"이의신청|첨부파일",	 	Type:"Html",		Hidden:0,		Width:80,		Align:"Center",		ColMerge:0,		SaveName:"btnFile",			UpdateEdit:1,	InsertEdit:1,   Cursor:"Pointer"});
			initdata.Cols.push({Header:"이의신청|첨부파일번호",	Type:"Text",		Hidden:1,		Width:80,		Align:"Center",		ColMerge:0,		SaveName:"feedFileSeq",		UpdateEdit:1,	InsertEdit:1});
		} else if (isPgmGubun("ZF")) { // 평가마감
			$("#txt").html("평가마감");
			initdata.Cols.push({Header:"OPEN 여부|OPEN 여부",	Type:"CheckBox",	Hidden:1,		Width:70,		Align:"Center",		ColMerge:0,		SaveName:"openYn",			UpdateEdit:1,	InsertEdit:0,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:1});
			initdata.Cols.push({Header:"평가결과|등급",			Type:"Combo",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"appFinClassCd",	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"평가결과|점수",			Type:"Float",		Hidden:1,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"appFinClassPoint",UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
			initdata.Cols.push({Header:"최종결과|등급",			Type:"Combo",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"finClassCd",		UpdateEdit:1,	InsertEdit:0});
			initdata.Cols.push({Header:"최종결과|점수",			Type:"Float",		Hidden:1,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"point",			UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
		} else if (isPgmGubun("ZG")) { // 평가결과
			$("#txt").html("평가결과");
			initdata.Cols.push({Header:"OPEN 여부|OPEN 여부",	Type:"CheckBox",	Hidden:0,		Width:70,		Align:"Center",		ColMerge:0,		SaveName:"openYn",			UpdateEdit:1,	InsertEdit:0,	TrueValue:"Y", FalseValue:"N",	HeaderCheck:1});
			initdata.Cols.push({Header:"최종결과|등급",			Type:"Combo",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"finClassCd",		UpdateEdit:1,	InsertEdit:0});
			initdata.Cols.push({Header:"최종결과|점수",			Type:"Float",		Hidden:1,		Width:80,		Align:"Right",		ColMerge:0,		SaveName:"point",			UpdateEdit:0,	InsertEdit:0,	Format:"NullFloat", EditLen:5, PointCount:2});
		} 
		
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");

		var jikchakList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");	//직책
		var jikweeList 	 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");	//직위
		var appStatusList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","P10018"), ""); // 평가상태
		var app2ndClassCdList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","P00001"), ""); // 평가등급
		
		sheet1.SetColProperty("jikchakCd",		{ComboText:"|"+jikchakList[0], 		ComboCode:"|"+jikchakList[1]} );
		sheet1.SetColProperty("jikweeCd",		{ComboText:"|"+jikweeList[0], 		ComboCode:"|"+jikweeList[1]} );
		sheet1.SetColProperty("appStatusCd",	{ComboText:"|"+appStatusList[0], 	ComboCode:"|"+appStatusList[1]} );
		sheet1.SetColProperty("app2ndClassCd",	{ComboText:"|"+app2ndClassCdList[0], 	ComboCode:"|"+app2ndClassCdList[1]} );
		$("#searchAppStatus").html("<option value=''>전체</option>"+appStatusList[2]);
		$("#btnAppStatus").html("<option value=''>선택</option>"+appStatusList[2]);
		
		//Autocomplete	

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

		sheet1.DoSearch("${ctx}/AppEvalProgressMng.do?cmd=getAppEvalProgressMngList", $("#sheet1Form").serialize());
		break;

	case "Save":		//저장
		if(sheet1.FindStatusRow("I") != ""){
			if(!dupChk(sheet1,"appraisalCd|sabun", true, true)){break;}
		}
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppEvalProgressMng.do?cmd=saveAppEvalProgressMng1", $("#sheet1Form").serialize());
		break;

	case "Clear":		//Clear
		sheet1.RemoveAll();
		break;

	case "Down2Excel":	//엑셀내려받기
		sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
		break;

	case "SaveAppStatus": //선택상태변경
		var btnAppStatus = $("#btnAppStatus").val();
		if (btnAppStatus == "") {
			alert("변경할 평가상태를 선택해 주시기 바랍니다.");
			$("#btnAppStatus").focus();
			return;
		}
		
		var sRow = sheet1.FindCheckedRow("chk");
		if( sRow == "" ){
			alert("대상을 선택 해주세요.");
			return;
		}

		var arrRow = sRow.split("|");
		for(var i=0; i<arrRow.length ; i++){
			sheet1.SetCellValue(arrRow[i], "appStatusCd", btnAppStatus);
		}
		
		doAction1("Save");
		break;
	case "AppFin":
		if ( $("#searchAppraisalCd").val() == "" ) {
			alert("평가명을 선택해 주세요");
			return;
		}
		if(confirm("" + $("#searchAppraisalCd option:selected").text() +"를 평가마감 하시겠습니까?\n(최종결과 정보는 삭제 후 새로 생성 됩니다.)")){
			$("#searchYn").val("Y");
			//showOverlay(0, "피평가자를 생성 중입니다.<br>잠시만 기다려주세요.");
			var data = ajaxCall("${ctx}/AppEvalProgressMng.do?cmd=prcAppEvalProgressMngFin",$("#sheet1Form").serialize(),false);
			if(data.Result.Code == null) {
				alert("처리되었습니다.");
				$(".isFin").hide();
				doAction1("Search");
				//hideOverlay();
			} else {
		    	alert(data.Result.Message);
		    	//hideOverlay();
			}		
		}
		break;
	case "leadershipCreate":
		var sRowStr = sheet1.FindCheckedRow("chk");
		//자바 스크립트 배열로 만들기
		var arr = sRowStr.split("|");
		if (arr.length < 1) {
			alert("선택된 평가자가 없습니다.");
			return false;
		}
		
		if (!confirm("선택한 평가자에게 리더쉽지표를 생성 하시겠습니까?")) {
			return false;
		}
		
		for (i=0; i<arr.length; i++) {
			var row = arr[i];
			sheet1.SetCellValue(row, "sStatus", "U");
		}
		
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppEvalProgressMng.do?cmd=saveAppEvalProgressMngleadership", $("#sheet1Form").serialize(),0,0);
		
		break;
	case "leadershipDelete":
		var sRowStr = sheet1.FindCheckedRow("chk");
		//자바 스크립트 배열로 만들기
		var arr = sRowStr.split("|");
		if (arr.length < 1) {
			alert("선택된 평가자가 없습니다.");
			return false;
		}
		
		if (!confirm("선택한 평가자에게 리더쉽지표를 삭제 하시겠습니까?")) {
			return false;
		}
		
		for (i=0; i<arr.length; i++) {
			var row = arr[i];
			sheet1.SetCellValue(row, "sStatus", "U");
		}
		
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppEvalProgressMng.do?cmd=deleteAppEvalProgressMngleadership", $("#sheet1Form").serialize(),0,0);
		
		break;
	}
}

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		
		for(var i=sheet1.HeaderRows();i<sheet1.RowCount()+sheet1.HeaderRows();i++){
			if(sheet1.GetCellValue(i,"feedFileSeq") == ''){
				sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>', false);
				sheet1.SetCellValue(i, "sStatus", 'R', false);
			}else{
				sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>', false);
				sheet1.SetCellValue(i, "sStatus", 'R', false);
			}
			//sheet1.SetCellImage(i, "detailGuide", 0, false)
			//sheet1.SetCellValue(i, "sStatus", "", false)
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
		if(sheet1.ColSaveName(Col) == "btnFile"){
			var param = [];
			param["fileSeq"] = sheet1.GetCellValue(Row,"feedFileSeq");
			if(sheet1.GetCellValue(Row,"btnFile") != ""){

				gPRow = Row;
				pGubun = "viewPopup";
			
				var authPgTemp="${authPg}";
				openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=evalProgress", param, "740","620");
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
			////pGubun = "AppEvalProgressMngPop";
			//openPopup("${ctx}/AppEvalProgressMng.do?cmd=viewAppEvalProgressMngPop", args, "550","520");
			
			var args = new Array();
			args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");

			gPRow = Row;
			pGubun = "AppEvalProgressMngPop";

			//openPopup("${ctx}/AppEvalProgressMng.do?cmd=viewAppEvalProgressMngPop", args, "350","500");
			openPopup("${ctx}/AppEvalProgressMng.do?cmd=viewAppEvalProgressMngPop", args, "550","520");
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

function sheet1_OnChange(Row, Col, Value){
	try {
		var sSaveName = sheet1.ColSaveName(Col);
		if(sSaveName == "finClassCd"){
			var point = 0;
			if (Value) {
				point = classCdPointList[4].split("|").filter(obj => obj.startsWith("["+Value+"]"))[0].substr(Value.length + 2);
			} else {
				point = "";
			}
			sheet1.SetCellValue(Row, "point", point);	
		} else if (sSaveName == "appFinClassCd")  {
			var point = 0;
			if (Value) {
				point = classCdPointList[4].split("|").filter(obj => obj.startsWith("["+Value+"]"))[0].substr(Value.length + 2);
			} else {
				point = "";
			}
			sheet1.SetCellValue(Row, "appFinClassPoint", point);	
			
		}
	} catch(ex){
		alert("OnChange Event Error : " + ex);
	}
}

// 
//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');
	if(pGubun == "org") {
    	$("#searchOrgNm").val(rv["orgNm"]);
    	doAction1("Search");
    } else if (pGubun == "group") {
    	$("#searchGroupCd").val(rv["appGroupNm"]);
    	doAction1("Search");
    } else if (pGubun == "viewPopup") {
    	if(rv["fileCheck"] == "exist"){
			sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
			sheet1.SetCellValue(gPRow, "feedFileSeq", rv["fileSeq"]);
		}else{
			sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			sheet1.SetCellValue(gPRow, "feedFileSeq", "");
		}
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
    } else if(pGubun == "AppEvalProgressMngPop") {
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
		//pGubun = "AppEvalProgressMngPop";
		openPopup("${ctx}/AppEvaluateeMgr.do?cmd=viewAppEvaluateeMgrPop", args, "550","520");		
		//openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
	}
}

function isPgmGubun(psPgmGubun) {
	return $("#searchPgmGubun").val() == psPgmGubun;
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
		<input type="hidden" name="searchPgmGubun"		id="searchPgmGubun"	value="${map.searchPgmGubun}" />
		<input type="hidden" name="searchBaseYmd" id="searchBaseYmd">
		<input type="hidden" name="updYn" id="updYn">
		<input type="hidden" name="searchYn" id="searchYn">
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
<c:if test="${map.searchPgmGubun != 'ZG'}" >							
							<span>평가상태</span>
							<select name="searchAppStatus" id="searchAppStatus">
							</select>
</c:if>
<c:if test="${map.searchPgmGubun == 'ZG'}" >
							<span>등급</span>
							<select name="searchFinClassCd" id="searchFinClassCd">
							</select>
</c:if>								
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
							<li id="txt" class="txt"></li>
							<li class="btn">
								<!-- <a href="javascript:createRcpt()" id="btnRcpt" class="button authA isFin">피평가자생성</a> -->
								<!-- <a href="javascript:deleteAll()" id="btnDelete" class="basic authA">전체삭제</a> -->
								
<c:if test="${map.searchPgmGubun == 'ZF'}" >
								<a href="javascript:doAction1('AppFin')" 	class="button authA isFin">평가마감</a>
</c:if>
<c:if test="${map.searchPgmGubun != 'ZG'}" >								
								<span class="isFin">* 평가상태 </span><select id="btnAppStatus" name="btnAppStatus" class="isFin"></select>
								<a href="javascript:doAction1('SaveAppStatus')" class="basic authA isFin">선택상태변경</a>
</c:if>
<c:if test="${map.searchPgmGubun == 'ZA'}" >								
								<a href="javascript:doAction1('leadershipCreate')" class="basic authA isFin pink">리더쉽지표생성</a>
								<a href="javascript:doAction1('leadershipDelete')" class="basic authA isFin pink">리더쉽지표삭제</a>
</c:if>															
								<a href="javascript:doAction1('Save')" 	class="basic authA isFin">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic">다운로드</a>
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