<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var compAprList = "";
var closeYn = "Y"
var papAdminYn = "${sessionScope.ssnPapAdminYn}";

var orgGradeCdList  = null;

$(function() {
	
	//성명,사번
	$("#searchAppSabun").val("${sessionScope.ssnSabun}");
	$("#searchAppName").val("${sessionScope.ssnName}");
	$("#searchKeyword").val("${sessionScope.ssnName}");
	$("#span_searchName").html("${sessionScope.ssnName}");
	
	if ( "${map.searchAppSeqCd}" == "" ) {
		$("#searchAppSeqCd").val("0");
	}
	
	//=========================================================================================================================================
	orgGradeCdList  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "전체");//조직평가등급코드(P00001)
	//=========================================================================================================================================
	
	var hdnType1 = 1;
	var hdnType2 = 1;
	var hdnType3 = 1;
	if($("#searchAppSeqCd").val() == "6") {
		hdnType1 = 0;
		hdnType2 = 0;
		hdnType3 = 0;
	}else if($("#searchAppSeqCd").val() == "2") {
		hdnType1 = 0;
		hdnType2 = 0;
		hdnType3 = 1;
	}else{
		hdnType1 = 0;
		hdnType2 = 1;
		hdnType3 = 1;
	}

	// sheetItem init
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	// 평가등급 항목 관리 시트 설정
	initdata.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

		{Header:"<sht:txt mid='appraisalCd_V6338' mdef='평가명'/>",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"<sht:txt mid='2023082501228' mdef='평가등급코드'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"<sht:txt mid='2023082501229' mdef='평가등급코드명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"<sht:txt mid='seq_V3516' mdef='순번'/>",				Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='note_V2853' mdef='비고'/>",				Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 }
	]; IBS_InitSheet(sheetItem, initdata);sheetItem.SetEditable("${editable}");sheetItem.SetVisible(true);
	
	// sheet1 init
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='workorgNm' mdef='소속'/>",				Type:"Text",	 Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501230' mdef='조직등급'/>",		Type:"Text",	 Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgGradeCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetUnicodeByte(3);
	
	// sheet2 init
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sStatus V3' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"<sht:txt mid='detail_V6269' mdef='평가|평가'/>",					Type:"Image",	 Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"result",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='201707270000002' mdef='진행상태|진행상태'/>",			Type:"Combo",	 Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appStatusCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
		{Header:"<sht:txt mid='empnameList' mdef='대상자|대상자'/>",				Type:"Text",	 Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501239' mdef='완료업무\n(핵심과제)|완료업무\n(핵심과제)'/>",		Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"taskCnt",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501238' mdef='종합수준'/>|★",					Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"level1Rate",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501238' mdef='종합수준'/>|★★",				Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"level2Rate",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501238' mdef='종합수준'/>|★★★",				Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"level3Rate",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501238' mdef='종합수준'/>|★★★★",				Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"level4Rate",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501238' mdef='종합수준'/>|★★★★★",			Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"level5Rate",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501237' mdef='리뷰결과|훌륭해요'/>",			Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"exRate",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501236' mdef='리뷰결과|좋아요'/>",				Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gdRate",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501235' mdef='리뷰결과|격려해요'/>",			Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enRate",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501232' mdef='1차등급|1차등급'/>",				Type:"Combo",	 Hidden:hdnType1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"app1stClassCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501231' mdef='2차등급|2차등급'/>",				Type:"Combo",	 Hidden:hdnType2,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"app2ndClassCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='20170816000058' mdef='최종등급|최종등급'/>",			Type:"Combo",	 Hidden:1,			Width:70,	Align:"Center",	ColMerge:0,	SaveName:"app3rdClassCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='20170816000058' mdef='최종등급|최종등급'/>",			Type:"Combo",	 Hidden:hdnType3,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appFinalClassCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		
		{Header:"평가ID",					Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"평가소속코드",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"평가소속명",					Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직위",						Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",						Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(1);sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);

	sheet2.SetEditEnterBehavior("newline");
	sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");
	sheet2.SetDataLinkMouse("detail", 1);
	sheet2.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색
	
	//평가상태코드(P30019)
	var comboList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30019"), "전체");
	sheet2.SetColProperty("appStatusCd", {ComboText: "|"+comboList[0], ComboCode: "|"+comboList[1]} );
	
	//평가상태코드(P30019)
	var comboList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=A","P00001"), "전체");
	sheet2.SetColProperty("app1stClassCd", {ComboText: "|"+comboList2[0], ComboCode: "|"+comboList2[1]} );
	sheet2.SetColProperty("app2ndClassCd", {ComboText: "|"+comboList2[0], ComboCode: "|"+comboList2[1]} );
	sheet2.SetColProperty("app3rdClassCd", {ComboText: "|"+comboList2[0], ComboCode: "|"+comboList2[1]} );
	sheet2.SetColProperty("appFinalClassCd", {ComboText: "|"+comboList2[0], ComboCode: "|"+comboList2[1]} );
	
	//평가명
	var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
	$("#searchAppraisalCd").html(appraisalCdList[2]);
	setAppOrgCdCombo();
	
	// 조회조건 이벤트 등록
	$("#searchAppraisalCd").bind("change",function(event){
		setAppOrgCdCombo();
	});
	
	// 조회조건 이벤트 등록
	$("#searchAppOrgCd").bind("change",function(event){
		doAction("Search");
	});
	
	//차수별 제목 변경
	if($("#searchAppSeqCd").val() == "1") {
		$("#apptxt").html("<tit:txt mid='2023082501241' mdef='1차 종합평가'/>");
	} else if($("#searchAppSeqCd").val() == "2") {
		$("#apptxt").html("<tit:txt mid='' mdef='2차 종합평가'/>");
	} else {
		$("#apptxt").html("<tit:txt mid='appRateTab2' mdef='종합평가'/>");
		$("#btnSave").html("<tit:txt mid='114030' mdef='확정'/>");
	}

	$(window).smartresize(sheetResize); sheetInit();
	
	doActionItem("Search");
});

//평가소속 setting(평가명 change, 성명 팝업 선택 후)
function setAppOrgCdCombo() {
	$("#searchAppOrgCd").html("");

	var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&"
		,"queryId=getAppManagerOrgCdList"
		+"&searchAppraisalCd="+$("#searchAppraisalCd").val()
		+"&searchSabun="+$("#searchAppSabun").val()
		+"&searchAppStepCd="+$("#searchAppStepCd").val()
		+"&searchAppYn=Y"
		,false).codeList, ""); // 평가소속
	
	$("#searchAppOrgCd").html(appOrgCdList[2]);
	$("#searchAppOrgCd").change();
}

// 임직원조회 자동완성 결과 세팅 처리
function setEmpPage(){
	$("#searchName").val($("#searchKeyword").val());
	$("#searchAppSabun").val($("#searchUserId").val());
	setAppOrgCdCombo();
}

//공통 체크
function commCheck(){
	if($("#searchAppraisalCd").val() == "") {
		alert("<msg:txt mid='110470' mdef='평가명이 존재하지 않습니다.'/>");
		$("#searchAppOrgCd").focus();
		return false;
	}

	if($("#searchAppOrgCd").val() == ""){
		alert("<msg:txt mid='109905' mdef='평가소속이 존재하지 않습니다.'/>");
		$("#searchAppOrgCd").focus();
		return false;
	}
	
	return true;
}

function doAction(sAction){
	switch(sAction){
		case "Search":
			doActionItem("Search");
			break;
	}
}

//sheetItem Action
function doActionItem(sAction) {
	switch (sAction) {
		case "Search":
			sheetItem.DoSearch( "${ctx}/AppGradeRateStd.do?cmd=getAppGradeRateStdClassItemList", $("#empForm").serialize() );
			break;
	}
}

//조회 후 에러 메시지
function sheetItem_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		//평가종류에 따라 조직평가등급이 다르기 때문에 속한 데이터만 가져오게 작업
		var appraisalCount = 0;
		var searchText = $("#searchAppraisalCd").val();
		var searchChar = "A";
		var pos = searchText.indexOf(searchChar);
		while(pos !== -1){
			appraisalCount++;
			pos = searchText.indexOf(searchChar, pos + 1); // 첫 번째 a 이후의 인덱스부터 a를 찾습니다.
		}
		var note1 = "";
		if(appraisalCount == 1) {
			note1 = "A";
		}
		// sheet1 재설정
		initSheet1();

		if(sheetItem.RowCount() > 0) {
			doAction1("Search");
			doAction2("Search");
		}

		sheetResize();
	} catch (ex) {
		alert("sheetItem OnSearchEnd Event Error : " + ex);
	}
}

//배분기준표 컬럼 재설정
function initSheet1() {
	// 시트 초기화
	sheet1.Reset();

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata1.Cols = [
		{Header:"<sht:txt mid='workorgNm' mdef='소속'/>",			Type:"Text",	 Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='2023082501230' mdef='조직등급'/>",	Type:"Text",	 Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgGradeCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
	];

	// 컬럼 추가
	var appClassCdList = "";
	for(var i = 1; i < sheetItem.RowCount()+1; i++) {
		var colHeaderNm = sheetItem.GetCellValue(i, "appClassNm");
		var colSaveNm  = "appClassCd_";
		var colSaveNm2 = "appRate_";

		// 컬럼 정보 추가
		initdata1.Cols.push({Header:colHeaderNm, Type:"Int",	Hidden:1, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + i,          KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 });
		initdata1.Cols.push({Header:colHeaderNm, Type:"Text",	Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm2 + i,         KeyField:0, Format:"", PointCount:2, UpdateEdit:0, InsertEdit:0, EditLen:10 });

		if(i > 1) {
			appClassCdList += "@";
		}
		appClassCdList += sheetItem.GetCellValue(i, "appClassCd");
		
		initdata1.Cols.push({Header:"<sht:txt mid='empCnt_V1' mdef='인원'/>",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"cntArr",			KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		initdata1.Cols.push({Header:"<sht:txt mid='retInsRateV1' mdef='비율'/>",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"rateArr",			KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		initdata1.Cols.push({Header:"<sht:txt mid='rateSum_V6645' mdef='합계'/>",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"total",			KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
	}
	// 시트 컬럼 재설정 적용
	IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

	// 콤보박스 컬럼 설정
	sheet1.SetColProperty("orgGradeCd", 	{ComboText:"|"+orgGradeCdList[0],		ComboCode:"|"+orgGradeCdList[1]} );

	$(window).smartresize(sheetResize); sheetInit();

	$("#appClassCdList").val(appClassCdList);
}

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	switch(sAction){
		case "Search":
			
			if(!commCheck()) return;
			
			sheet1.DoSearch( "${ctx}/OkrAppFinal1st2nd.do?cmd=getOkrAppFinalGradeRateList", $("#empForm").serialize() );
			break;
	}
}

//<!-- 조회 후 에러 메시지 -->
function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	try{
		// 세부 등급별 인원수 데이터 삽입 처리
		if(sheet1.RowCount() > 0) {
			var headerArr = $("#appClassCdList").val().split("@");
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				var cntArr = sheet1.GetCellValue( i, "cntArr" );
				var rateArr = sheet1.GetCellValue( i, "rateArr" );
				var total = sheet1.GetCellValue( i, "total" );
				if(cntArr != "") {
					var valArr = cntArr.split("@");
					var valArr2 = rateArr.split("@");
					var rate = "";
					for(var j = 0; j < headerArr.length; j++) {
						if( valArr != null && valArr != undefined && valArr[j] != null && valArr[j] != undefined ) {
							//sheet1.SetCellValue( i, "appClassCd_" + (j+1), valArr[j] );
							rate = 0;
							if(total > 0) {
								if(parseInt(valArr[j]) > 0 ){
									rate = Round((parseInt(valArr[j])/parseInt(total))*100,2)+'%';
								}else{
									rate = rate+'%';
								}
							}else{
								rate = valArr2[j];
							}
							sheet1.SetCellValue( i, "appRate_" + (j+1), rate );
						}
					}
					sheet1.SetCellValue( i, "sStatus", "R" );
				}
			}
		}
	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
}
	
function doAction2(sAction) {
	switch (sAction) {
	case "Search":
		sheet2.DoSearch( "${ctx}/OkrAppFinal1st2nd.do?cmd=getOkrAppFinal1st2ndList", $("#empForm").serialize() );
		break;
		
	case "Save" :
	
		if(sheet2.RowCount() > 0) {
			
			var targetCnt = 0; //미대상 건수
			
			for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++) {
				var appStatusCd = sheet2.GetCellValue(i, "appStatusCd");
				var appClassCd = "";
				var name = sheet2.GetCellValue(i, "name");
				
				if(appStatusCd == "11") {
					var msg = "<msg:txt mid='2023082501242' mdef='## 님의 #차 평가를 진행해주세요.'/>";
					var msgReplace = msg.replace('##',name);
					var msgResult = msgReplace.replace('#',$("#searchAppSeqCd").val());
					alert(msgResult);
					return;
				}
				
				//차수별 체크로직 추가
				if($("#searchAppSeqCd").val() == "1") {
					appClassCd = sheet2.GetCellValue(i, "app1stClassCd");
					if(appStatusCd == "11" || appClassCd == "") {
						var msg = "<msg:txt mid='2023082501245' mdef='## 님의 1차평가를 진행해주세요.'/>";
						var msgReplace = msg.replace('##',name);
						alert(msgReplace);
						return;
					}else{
						if(appStatusCd != "21") {
							//alert("1차평가완료되었습니다.");
							//return;
							targetCnt++;
						}
					}
				} else if($("#searchAppSeqCd").val() == "2") {
					appClassCd = sheet2.GetCellValue(i, "app2ndClassCd");
					if(appStatusCd == "23" || appClassCd == "") {
						var msg = "<msg:txt mid='2023082501244' mdef='## 님의 2차평가를 진행해주세요.'/>";
						var msgReplace = msg.replace('##',name);
						alert(msgReplace);
						return;
					}else{
						if(appStatusCd != "31") {
							//alert("2차평가완료되었습니다.");
							//return;
							targetCnt++;
						}
					}
				} else {
					appClassCd = sheet2.GetCellValue(i, "app3rdClassCd");
					if(appStatusCd == "33" || appClassCd == "") {
						var msg = "<msg:txt mid='2023082501243' mdef='## 님의 최종평가를 진행해주세요.'/>";
						var msgReplace = msg.replace('##',name);
						alert(msgReplace);
						return;
					}else{
						if(appStatusCd != "91") {
							//alert("최종평가완료되었습니다.");
							//return;
							targetCnt++;
						}
					}
				}
			}
		}
		
		if(sheet2.RowCount() == 0 || sheet2.RowCount() == targetCnt){
			alert("평가완료 대상이 존재하지 않습니다.");
			return;
		}
		
		if (confirm("평가완료 하시겠습니까?")) {
			var params = "searchAppraisalCd="+ $("#searchAppraisalCd").val() +
			 "&searchAppOrgCd=" + $("#searchAppOrgCd").val() + 
			 "&searchAppSabun=" + $("#searchAppSabun").val() + 
			 "&searchAppSeqCd=" + $("#searchAppSeqCd").val()

			var ajaxCallCmd = "prcP_PAPN_TPAP450_UPDATE";
			
			var data = ajaxCall("/OkrAppFinal1st2nd.do?cmd="+ajaxCallCmd,params,false);
			
			if(data == null || data.Result == null) {
				msg = procName+"를 사용할 수 없습니다." ;
				return msg ;
			}
			
			//alert(data.Result.Code);
			//정상처리
			if(data.Result.Code == "0") {
				alert(data.Result.Message);
				doAction("Search");
			}else{
				alert(data.Result.Message);
				doAction("Search");
			}
		}
		break;
		
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet2);
		var param = {DownCols:downcol, SheetDesign:1, Merge:1};
		sheet2.Down2Excel(param);
		break;
	}
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != "") alert(Msg);

		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{
		if(Row <= 1) return;
		if(sheet2.ColSaveName(Col) == "result" ){
			
			//평가가 완료 되지 않았을 경우
			if ( $("#searchAppSeqCd").val() == "2" ) {
				if ( sheet1.GetCellValue(Row, "appStatusCd") == "11" || sheet1.GetCellValue(Row, "appStatusCd") == "21" ) {
					alert("<msg:txt mid='109415' mdef='1차평가가 완료되지 않았습니다.'/>");
					return;
				}
			} else if( $("#searchAppSeqCd").val() == "6" ) {
				if ( sheet1.GetCellValue(Row, "appStatusCd") == "11" || sheet1.GetCellValue(Row, "appStatusCd") == "21" ) {
					alert("<msg:txt mid='109415' mdef='1차평가가 완료되지 않았습니다.'/>");
					return;
				} else if(sheet1.GetCellValue(Row, "appStatusCd") == "31" ) {
					alert("<msg:txt mid='2023082501233' mdef='2차평가가 완료되지 않았습니다.'/>");
					return;
				}
			}
			
			if(!isPopup()) {return;}
			var url = "${ctx}/OkrAppFinal1st2nd.do?cmd=viewOkrAppFinal1st2ndPop";
			var args = new Array();

			args["searchAppraisalCd"]		= sheet2.GetCellValue(Row, "appraisalCd");
			args["searchSabun"]				= sheet2.GetCellValue(Row, "sabun");
			args["searchAppOrgCd"]			= sheet2.GetCellValue(Row, "appOrgCd");
			args["searchAppStatusCd"]		= sheet2.GetCellValue(Row, "appStatusCd");
			args["searchOrgNm"]				= sheet2.GetCellValue(Row, "appOrgNm");
			args["searchName"]				= sheet2.GetCellValue(Row, "name");
			args["searchJikweeNm"]			= sheet2.GetCellValue(Row, "jikweeNm");
			args["searchAppSeqCd"]			= $("#searchAppSeqCd").val();
			args["searchAppStepCd"]			= $("#searchAppStepCd").val();
			
			if($("#searchAppSeqCd").val() == "1") {
				if(sheet2.GetCellValue(Row, "appStatusCd") == "11" || sheet2.GetCellValue(Row, "appStatusCd") == "21"){
					args["authPg"] = "A";
				}else{
					args["authPg"] = "R";
				}
			} else if($("#searchAppSeqCd").val() == "2") {
				if(sheet2.GetCellValue(Row, "appStatusCd") == "23" || sheet2.GetCellValue(Row, "appStatusCd") == "31"){
					args["authPg"] = "A";
				}else{
					args["authPg"] = "R";
				}
			} else {
				if(sheet2.GetCellValue(Row, "appStatusCd") == "33" || sheet2.GetCellValue(Row, "appStatusCd") == "91"){
					args["authPg"] = "A";
				}else{
					args["authPg"] = "R";
				}
			}
			
			gPRow = "";
			pGubun = "okrAppFinal1st2ndView";

			openPopup(url,args,1000,700);
		}
	}catch(ex){
		alert("OnClick Event Error : " + ex);
	}
}

//특정자리 반올림
function Round(n, pos) {
	var digits = Math.pow(10, pos);
	var sign = 1;
	if (n < 0) {
		sign = -1;
	}

	// 음수이면 양수처리후 반올림 한 후 다시 음수처리
	n = n * sign;
	var num = Math.round(n * digits) / digits;
	num = num * sign;
	return num.toFixed(pos);
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');
	if(pGubun == "okrAppFinal1st2ndView") {
		doAction("Search");
	}
}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="${map.searchAppStepCd}">
		<input type="hidden" name="searchAppSeqCd"		id="searchAppSeqCd"		value="${map.searchAppSeqCd}">
		<input type="hidden" name="searchAppSabun"		id="searchAppSabun" />
		<input type="hidden" name="searchAppStatusCd"	id="searchAppStatusCd" />
		<input type="hidden" name="searchOrgCd"			id="searchOrgCd" />
		<input type="hidden" name="searchOrgNm"			id="searchOrgNm" />
		<input type="hidden" name="searchAppYn"			id="searchAppYn" />
		<input type="hidden" name="searchAppraisalYn"	id="searchAppraisalYn" />
		<input type="hidden" name="searchStatusCd"		id="searchStatusCd" />
		
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
		<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
		<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		
		<input type="hidden" id="searchAdminYn" 	name="searchAdminYn" 		value="" />
		<input type="hidden" id="appClassCdList" name="appClassCdList" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span class="w40"><tit:txt mid='111888' mdef='평가명'/></span>
							<select id="searchAppraisalCd" name="searchAppraisalCd" class="required" required></select>
						</td>
						<td>
							<span class="w80"><tit:txt mid='112259' mdef='평가소속'/></span>
							<select id="searchAppOrgCd" name="searchAppOrgCd" class="required" required></select>
						</td>
						<td><span><tit:txt mid='113683' mdef='평가자'/></span>
							<input id="searchAppSabun" name ="searchAppSabun" type="hidden" class="text"	/>
							<input id="searchAppName" name ="searchAppName" type="hidden" class="text"	/>
							<!-- <input type="text" id="searchKeyword" name="searchKeyword" class="text w100" style="ime-mode:active"/> -->
							<c:choose>
								<c:when test="${ sessionScope.ssnPapAdminYn == 'Y' }">
										<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
								</c:when>
								<c:otherwise>
										<input type="hidden" id="searchKeyword" name="searchKeyword" />
										<span id="span_searchName" class="txt pap_span f_normal"></span>
								</c:otherwise>
							</c:choose>
						</td>
						<td>
							<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
							<li id="txt" class="txt"><tit:txt mid='2023082501234' mdef='평가배분표'/></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "30%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td>
				<div class="inner mat10">
					<div class="sheet_title">
						<ul>
							<li id="apptxt" class="txt"></li>
							<li class="btn">
								<a href="javascript:doAction2('Save')"		 id="btnSave" class="blue large"><tit:txt mid='114380' mdef='평가완료'/></a>
								<a href="javascript:doAction2('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "70%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<div class="hide">
		<script type="text/javascript"> createIBSheet("sheetItem", "100%", "0%", "kr"); </script>
		</div>
	</table>
</div>
</body>
</html>
