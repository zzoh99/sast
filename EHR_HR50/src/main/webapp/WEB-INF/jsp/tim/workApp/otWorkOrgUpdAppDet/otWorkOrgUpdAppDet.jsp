<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>연장근무변경신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%/*

사무직 : 개인연장근무신청
       
생산직 : 조직장, 반장, 근무담당자가 일괄 신청

*/%>
<script type="text/javascript">
var searchApplCd    = "${searchApplCd}"; 
var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var applYn	         = "";
var gPRow = "";
var pGubun = "";


	$(function() {

		parent.iframeOnLoad(220);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchSabun").val(searchApplSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#searchApplCd").val(searchApplCd); 
		
		if( searchApplCd == "110" ){ /* 110:연장근무사전신청, 111:연장근무변경신청 */
			$("#searchApplGubun").val("B"); //사전신청	
		}else{
			$("#searchApplGubun").val("A"); //변경신청
		}

		applStatusCd = parent.$("#applStatusCd").val();  //신청서상태
		applYn = parent.$("#applYn").val(); //결재자 여부

		//----------------------------------------------------------------
		
		//Sheet 초기화 ---------------------------------------------------
		init_sheet();
		//-----------------------------------------------------------------
		
		// 신청, 임시저장
		if(authPg == "A") {

			$("#divTimeSheet").show();
			$("#DIV_timeSheet").hide();
			//근무시간 콤보-----------------------------------------------------------------------------------------------------------------------------
			var timeList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkTimeCdList&searchUseYn=Y", false).codeList, "");
			$("#viewTimeCd").html(timeList[2]);
			
			$("#viewTimeCd").bind("change", function(){
				showTimeSheet(1);
			}); //근무시간보기
			
			
			if(applStatusCd == "") { //최초 입력 시에만 수정 가능함. 임시저장상태에서는 못하게 함.
				
				$("#btnClear, #btnDel").show();
				
				$("#searchOrgCd").bind("change", function(){
					//신청권한 (0:개인, 1:부서)
					var orgAuth = $("#searchOrgCd option:selected").attr("orgAuth");
					var workType = $("#searchOrgCd option:selected").attr("workType"); //A: 사무직, B: 생산직
					$("#searchOrgAuth").val(orgAuth);
					$("#searchWorkType").val(workType);
					
					if( $("#searchOrgAuth").val() == "0" ){
						$("#btnClear, #btnDel").hide();
					}else{
						$("#btnClear, #btnDel").show();
					}
					 
					doAction("SearchList");
				});
			
				var stdYmd = "<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-1)%>";
				$("#searchYmdBase").val(stdYmd); 
				//근무일
				$("#searchYmd").datepicker2({
					startdate:"searchYmdBase",
					onReturn:function(date){
						initOrgCdCombo(); //조직콤보
					}
				}).val(stdYmd);
				
			}
			
			initOrgCdCombo();

			sheet1.SetEditable(1);
		}else{
			sheet1.SetColHidden( "sDelete",  1);
			sheet1.SetEditable(0); sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
	    }

		doAction("Search");

	});

	//조직 콤보
	function initOrgCdCombo(){
		if( $("#searchYmd").val() == "" ) return;

		sheet1.RemoveAll();
		var obj = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getOtWorkOrgUpdAppDetOrgCdList&"+ $("#searchForm").serialize(), false).codeList;
		
		var orgCdList = convCodeCols(obj, "orgAuth,workType", "");
		$("#searchOrgCd").html(orgCdList[2]).change();	
	
		
		
	}

	function init_sheet(){
		var kf = (authPg == "R")?0:1;
		var v=0;
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:25, MergeSheet:msHeaderOnly,FrozenCol:0,FrozenColRight:0};

		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		initdata1.Cols = [];	
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",					Type:"${sNoTy}",    Hidden:0,  Width:45,  	Align:"Center", 	SaveName:"sNo" };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",   Hidden:0,  Width:45, 	Align:"Center", 	SaveName:"sDelete" , Sort:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",					Type:"${sSttTy}",   Hidden:1,  Width:45, 	Align:"Center", 	SaveName:"sStatus" , Sort:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",					Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  	SaveName:"sabun",	   	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",					Type:"Popup",		Hidden:0,  Width:50,   Align:"Center",  	SaveName:"name",	   	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",					Type:"Text",		Hidden:0,  Width:50,   Align:"Center",  	SaveName:"jikweeNm",	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"직군|직군",					Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  	SaveName:"workType",	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='workSchedule_lb_dbl' mdef='근무\n스케줄|근무\n스케줄'/>",	Type:"Text",		Hidden:0,  Width:50, 	Align:"Center", 	SaveName:"timeNm",		KeyField:kf, Format:"",     UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='gntCd' mdef='근태|근태'/>",					Type:"Text",		Hidden:0,  Width:50, 	Align:"Center", 	SaveName:"gntNm",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
		
		initdata1.Cols[v++] = {Header:"<sht:txt mid='workteamCd_V1346' mdef='근무조|근무조'/>",				Type:"Text",		Hidden:1,  Width:80,   	Align:"Center",  	SaveName:"workOrgCd",	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='workSchedule_dbl' mdef='근무스케줄|근무스케줄'/>",		Type:"Text",		Hidden:1,  Width:80,   	Align:"Center",  	SaveName:"timeCd",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='weekOtTimeSum' mdef='주 연장시간|합계'/>",          	Type:"Text",		Hidden:0,  Width:50,	Align:"Center",  	SaveName:"weekOtTime",	KeyField:0,  Format:"",   Edit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='weekOtTimeRemains' mdef='주 연장시간|잔여'/>",        	Type:"Text",		Hidden:0,  Width:50,	Align:"Center",  	SaveName:"weekOtTimeRem",	KeyField:0,  Format:"",   Edit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='termOtTimeSum' mdef='단위기간 연장시간|합계'/>",		Type:"Text",		Hidden:0,  Width:50,	Align:"Center",  	SaveName:"termOtTime",	KeyField:0,  Format:"",   Edit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='termOtTimeRemains' mdef='단위기간 연장시간|잔여'/>",		Type:"Text",		Hidden:0,  Width:50,	Align:"Center",  	SaveName:"termOtTimeRem",	KeyField:0,  Format:"",   Edit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='termDate_dbl' mdef='단위기간|단위기간'/>",			Type:"Text",		Hidden:1,  Width:100,	Align:"Center",  	SaveName:"termDate",	KeyField:0,  Format:"",   Edit:0 };
		
		initdata1.Cols[v++] = {Header:"<sht:txt mid='beginShm_lb_dbl' mdef='출근\n기준시간|출근\n기준시간'/>",	Type:"Date",		Hidden:0,  Width:50,	Align:"Center",  	SaveName:"beginShm",	KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='inTime_V2' mdef='출근시간|출근시간'/>",			Type:"Date",		Hidden:0,  Width:50,	Align:"Center",  	SaveName:"reqSHm",		KeyField:kf,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0,   EditLen:5};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='outTime_V2' mdef='퇴근시간|퇴근시간'/>",			Type:"Date",		Hidden:0,  Width:50,	Align:"Center",  	SaveName:"reqEHm",		KeyField:kf,  Format:"Hm",   UpdateEdit:1,   InsertEdit:1,   EditLen:5};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='requestOtHour_lb|req' mdef='연장근무 신청시간|사전'/>", Type:"NullFloat",	Hidden:0,  Width:50,	Align:"Center",  	SaveName:"bfRequestHour", KeyField:0, Format:"",   	UpdateEdit:0,   InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='requestOtHour_lb|chg' mdef='연장근무 신청시간|변경'/>", Type:"Float",	Hidden:0,  Width:50,	Align:"Center",  	SaveName:"requestHour", KeyField:kf, Format:"",   	UpdateEdit:0,   InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='reasonCdV1' mdef='신청사유|신청사유'/>",			Type:"Text",		Hidden:0,  Width:160,   Align:"Left",   	SaveName:"reason",		KeyField:0,  Format:"",     UpdateEdit:1,   InsertEdit:1,   EditLen:200 };
		
		IBS_InitSheet(sheet1, initdata1);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetUseDefaultTime(0);
		//sheet1.SetDataRowHeight(30);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
	

		sheet1.SetRangeBackColor(0,sheet1.SaveNameCol("reqEHm"),1,sheet1.SaveNameCol("reqEHm"), "#fdf0f5");  //분홍이

		$(window).smartresize(sheetResize); sheetInit();

	}

	// Action
	
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/OtWorkOrgUpdApp.do?cmd=getOtWorkOrgUpdAppDetMap", $("#searchForm").serialize(),false);
			if(data.Message != "" ){
				alert(data.Message);
				return;
			}
			if ( data != null && data.DATA != null ){ 

				$("#searchYmd").val( formatDate(data.DATA.ymd, "-") );

				$("#searchOrgCd").html("<option value='"+data.DATA.orgCd+"'>"+data.DATA.orgNm+"</option>");
				
			}
			doAction("SearchList");

			break;
		case "SearchList": //대상자리스트
			if( $("#searchYmd").val() == "" ) return;
			
			if( $("#searchOrgCd").val() == ""){
				sheet1.RemoveAll();	
				return;
			}
			var sXml = sheet1.GetSearchData("${ctx}/OtWorkOrgUpdApp.do?cmd=getOtWorkOrgUpdAppDetList", $("#searchForm").serialize()+"&searchType=list" );
			//sXml = replaceAll(sXml,"ShtCellEdit", "#Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
		case "Clear": //초기화
			if( $("#searchYmd").val() == "" ) return;
			
			if( $("#searchOrgCd").val() == ""){
				sheet1.RemoveAll();	
				return;
			}
			var sXml = sheet1.GetSearchData("${ctx}/OtWorkOrgUpdApp.do?cmd=getOtWorkOrgUpdAppDetList", $("#searchForm").serialize()+"&searchType=clear" );
			//sXml = replaceAll(sXml,"ShtCellEdit", "#Edit");
			sheet1.LoadSearchData(sXml );
			break;
		case "Del": //대상자 외 삭제 

			//사전신청 시간과 변경 시청이 다른 대상자 
	  		var i = sheet1.HeaderRows();
	  		while ( i < sheet1.RowCount()+sheet1.HeaderRows()) {
	  			if( sheet1.GetCellValue(i, "requestHour") == "" || sheet1.GetCellValue(i, "bfRequestHour") == sheet1.GetCellValue(i, "requestHour")){
					sheet1.RowDelete(i);
	  			}else{
		  			i++;	
	  			}
	  		}
			break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( sheet1.RowCount() == 0 ) return;
			// 입력 폼 값 셋팅
			var param = "sabun="+sheet1.GetCellValue(sheet1.HeaderRows(), "sabun")+"&searchYmd="+$("#searchYmd").val();
			var data = ajaxCall( "${ctx}/OtWorkOrgUpdApp.do?cmd=getOtWorkOrgUpdAppDetTerDate", param,false);
			if(data.Message != "" ){
				alert(data.Message);
				return;
			}
			if ( data != null && data.DATA != null ){ 
				$("#span_termDate").html(data.DATA.termDate);
			}

			sheetResize();

			resizeSheetHeight(sheet1, "R");
			
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function sheet1_OnChange(Row, Col, Value) {
		try{
			var colName = sheet1.ColSaveName(Col);
			if(sheet1.ColSaveName(Col) == "sDelete" ) {
				if (Value == 1){
					sheet1.RowDelete(Row);
				}
			}else if(sheet1.ColSaveName(Col) == "reqEHm" ) {
				if( Value.length == 4 ){
					setSheetWorkTime(Row);
				}
			}

		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	function sheet1_OnKeyUp(Row, Col) {
		try{
			var colName = sheet1.ColSaveName(Col);
			if( sheet1.ColSaveName(Col) == "reqEHm") {
				if( sheet1.GetEditText().length == 4 ){
					sheet1.SetEndEdit(1);//편집끝
					setSheetWorkTime(Row);
				}
			}
		}catch(ex){
			alert("OnKeyDown Event Error : " + ex);
		}
	}


	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if( NewRow < sheet1.HeaderRows() ) return;
			$("#viewTimeCd").val( sheet1.GetCellValue(NewRow, "timeCd") );
			if($("#DIV_timeSheet").css("display") != "none" && authPg == "A"){
				searchTimeSheet();
			}
		} catch (ex) {
			alert("sheet1 OnSelectCell Event Error " + ex);
		}
	}


	
	//-----------------------------------------------------------------------------------
	// 출퇴근 입력시, 기본근무.... 시간 set
	// 주단위, 단위기간 연장근무 한도 시간 및 연장근무시간 가져 오기.
	function setSheetWorkTime(Row){
		if( sheet1.GetCellValue(Row, "reqSHm") == "" || sheet1.GetCellValue(Row, "reqEHm") == "" ) {
			sheet1.SetCellValue(Row, "requestHour",     "") ;
			return;
		}
		var param = "searchSabun=" + sheet1.GetCellValue(Row, "sabun")
		  + "&searchYmd=" + $("#searchYmd").val()
		  + "&searchSHm=" + sheet1.GetCellValue(Row, "reqSHm")
		  + "&searchEHm=" + sheet1.GetCellValue(Row, "reqEHm");

		var workTimeList = ajaxCall("${ctx}/OtWorkOrgUpdApp.do?cmd=getOtWorkOrgUpdAppDetTimeMap", param, false);
		if(workTimeList.Message != "" ){
			alert("연장근무시간 조회 시 오류가 발생 했습니다.");
			return;
		}
		if (workTimeList != null && workTimeList.DATA != null) {
			sheet1.SetCellValue(Row, "requestHour",     workTimeList.DATA.requestHour) ;
		}else{
			sheet1.SetCellValue(Row, "requestHour",     "") ;
		}
	}
	
	
	
	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;
		
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		
		return ch;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {

		sheet1.SetEndEdit(1);//편집끝
		
		var returnValue = false;
		try {

			if ( authPg == "R" )  {
				return true;
			} 
			
			// 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }

			
			if(sheet1.RowCount() == 0){
				alert("신청 대상자가 없습니다.");
				return false;
			}

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				sheet1.SetCellValue(i, "sStatus", "U");
			}

	        IBS_SaveName(document.searchForm,sheet1);
			var saveStr = sheet1.GetSaveString(0);
			if(saveStr=="KeyFieldError"){
				return false;
			}

			//신청시간 및 연장근무 한도 체크 
			var chkTime = ajaxCall("${ctx}/OtWorkOrgUpdApp.do?cmd=getOtWorkOrgUpdAppDetCheckTime", saveStr+"&"+$("#searchForm").serialize(),false);
			if(chkTime.Message != "" ){
				alert("신청시간 및 연장근무 한도 체크 시 오류가 발생 했습니다.");
				return false;
			}
			if(chkTime.DATA != null && chkTime.DATA.chkList != ""){
				alert(replaceAll(chkTime.DATA.chkList,"/n","\n"));
				
				return false;
			}
			
			/* 대상자별  체크 */
			//기 신청건 체크 
			var chkDup = ajaxCall("${ctx}/OtWorkOrgUpdApp.do?cmd=getOtWorkOrgUpdAppDetDupCnt", saveStr+"&"+$("#searchForm").serialize(),false);
			if(chkDup.Message != "" ){
				alert("기 신청건 체크 시 오류가 발생 했습니다.");
				return false;
			}
			if(chkDup.DATA != null && chkDup.DATA.dupCnt != "null" && chkDup.DATA.dupCnt != "0"){
				alert("동일한 일자에 신청내역이 있습니다.\n"+chkDup.DATA.dupList);
				return false;
			}
			
			var data = eval("("+sheet1.GetSaveData("${ctx}/OtWorkOrgUpdApp.do?cmd=saveOtWorkOrgUpdAppDet", saveStr+"&"+$("#searchForm").serialize())+")");

            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }
            

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}
	

	//---------------------------------------------------------------------------------------------------------------
	// 근무시간 Sheet
	//---------------------------------------------------------------------------------------------------------------
	
	function showTimeSheet(isShow){
		
		if( isShow == 1 ){
			$("#DIV_timeSheet").show();
			searchTimeSheet();
		}else{
			if($("#DIV_timeSheet").css("display") != "none"){

				var bodyHeight = $("body").outerHeight() - timeSheet.GetSheetHeight(); 
				
				$("#DIV_timeSheet").css("height", "0px");
				$("#DIV_timeSheet").hide();

				parent.$("#authorFrame").height(bodyHeight);
			}
			
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// 근무시간 Sheet
	//---------------------------------------------------------------------------------------------------------------
	function searchTimeSheet() {

		var param = "ymd="+$("#searchYmd").val().replace(/-/gi,"")
		          + "&timeCd="+$("#viewTimeCd").val();
		
		var headerList = ajaxCall("${ctx}/OtWorkOrgUpdApp.do?cmd=getPsnlWorkScheduleMgrDayWorkHeaderList", param, false);
		if (headerList != null && headerList.DATA != null) {

			timeSheet.Reset();

			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:2, MergeSheet:msHeaderOnly};
			initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			initdata.Cols = [];
			initdata.Cols[0]  = {Header:"color|color",	Type:"Text",    Hidden:1,   Width:0,	Align:"Center", ColMerge:0,   SaveName:"rgbCd" };
			initdata.Cols[1]  = {Header:"근무|근무",		Type:"Text",    Hidden:0,   Width:100,	Align:"Center", ColMerge:0,   SaveName:"workText",	UpdateEdit:0 };

			var i = 0 ;
			var oldYmColCnt = 0;
			var oldYm = "";
			for(; i<headerList.DATA.length; i++) {
				initdata.Cols[i+2] = {Header:headerList.DATA[i].hhText+"|"+headerList.DATA[i].mm+"  ",	Type:"Text",	Hidden:0,	Width:20,	Align:"Left",	ColMerge:1,	SaveName:headerList.DATA[i].colName,	Focus:0, Edit:0};
			}
			IBS_InitSheet(timeSheet, initdata);
			timeSheet.FitColWidth();

			timeSheet.SetSelectionMode(0);
			timeSheet.SetCountPosition(0);
			timeSheet.SetDataBackColor("#ffffff");
			timeSheet.SetDataAlternateBackColor(timeSheet.GetDataBackColor());

			for(var j = 0 ; j<headerList.DATA.length; j++) {
				timeSheet.SetCellFontSize(1, headerList.DATA[j].colName, 8);
			}
			timeSheet.DoSearch( "${ctx}/OtWorkOrgUpdApp.do?cmd=getPsnlWorkScheduleMgrDayWorkList", param );

		}
	}	
	//---------------------------------------------------------------------------------------------------------------
	// 근무시간 Sheet Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function timeSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for (var i=2; i<=timeSheet.LastRow(); i++){
				for(var j=0; j<=timeSheet.LastCol(); j++){
					if( timeSheet.ColSaveName(j).substring(0, 2) == "sn" && timeSheet.GetCellValue(i, j) != "") {
						timeSheet.SetCellBackColor(i, j, timeSheet.GetCellValue(i, "rgbCd"));
						timeSheet.SetCellValue(i, j, "");
					}
				}
			}
			//sheetResize();
			timeSheet.FitColWidth();
			resizeSheetHeight(timeSheet,"R"); //시트행 갯수에 맞게 시트 높이 설정 
		} catch (ex) {
			alert("timeSheet OnSearchEnd Event Error : " + ex);
		}
	}
	
	
</script>

</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchSabun"		name="searchSabun"	 	value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	value=""/>
	<input type="hidden" id="searchOrgAuth"		name="searchOrgAuth"	value=""/>
	<input type="hidden" id="searchWorkType"	name="searchWorkType"	value=""/>
	<input type="hidden" id="searchYmdBase"		name="searchYmdBase"	value=""/>
	<input type="hidden" id="searchApplGubun"	name="searchApplGubun"	value=""/>
		
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="200px" />
			<col width="120px" />
			<col width="" />
		</colgroup> 
	
		<tr>
			<th><tit:txt mid="104060" mdef="근무일" /></th>
			<td colspan="3">
				<input id="searchYmd" name="searchYmd" type="text" class="${dateCss} ${required} w70" readonly maxlength="10" />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid="104279" mdef="부서" /></th>
			<td>
				<select id="searchOrgCd" name="searchOrgCd" class="${selectCss} ${required}" ${disabled}></select>
			</td>
			<th><tit:txt mid="termDate" mdef="단위기간" /></th>
			<td>
				<span id="span_termDate"></span>
			</td>
		</tr>
	</table>
	</form>
	<div class="sheet_title">
		<ul>
			<li id="empTitle" class="txt"><tit:txt mid="103863" mdef="대상자" /></li>
			<li class="btn">
				<a href="javascript:doAction('Del');"   class="btn outline_gray" id="btnDel" style="display:none;">대상자 외 삭제</a>
				<a href="javascript:doAction('Clear');" class="btn outline_gray" id="btnClear" style="display:none;"><tit:txt mid="112391" mdef="초기화" /></a>
			</li>
		</ul>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "300px"); </script>
		
	<div id="divTimeSheet" style="display:none;">
		<div class="sheet_title">
		<ul>
			<li class="txt">일 근무스케쥴 상세내역</li>
			<li class="btn">
                 <b><tit:txt mid="103861" mdef="근무시간" /> : </b><select id="viewTimeCd" name="viewTimeCd"></select>
                 <a href="javascript:showTimeSheet(1);" class="btn filled" ><tit:txt mid="113578" mdef="보기" /></a>
                 <a href="javascript:showTimeSheet(0);" class="btn outline_gray" ><tit:txt mid="104157" mdef="닫기" /></a>
			</li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("timeSheet", "100%", "0px", "${ssnLocaleCd}"); </script>
	</div>
	
</div>
		
</body>
</html>