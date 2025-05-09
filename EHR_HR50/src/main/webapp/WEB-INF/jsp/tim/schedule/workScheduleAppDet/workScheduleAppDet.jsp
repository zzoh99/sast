<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>근무스케쥴신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var applYn	         = "";
var timeCdMap;

	$(function() {

		parent.iframeOnLoad(450);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchSabun").val(searchApplSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();  //신청서상태
		applYn = parent.$("#applYn").val(); //결재자 여부

		
		//-----------------------------------------------------------------
		// 신청
		if(authPg == "A" && applStatusCd == "" ) {
			$("#divTimeSheet").show();
			$("#DIV_timeSheet").hide();
			
			init_saveSheet(); //저장용 시트
			
			//기준일자
			$("#ymd").datepicker2({
				onReturn:function(date){
					/*if( date <= "${curSysYyyyMMddHyphen}"){
						alert("당일 포함 지난 일자는 신청 할 수 없습니다.");
						$("#ymd").val("");
						$("#dayGubunCd").html("");
						$("#workTerm").html("");
						sheet1.RemoveAll();	
						return;
					}else{*/
						sheet1.RemoveAll();	
						initWorkOrg();
					//}
				}
			}).val(addDate("d", 1, "${curSysYyyyMMddHyphen}", "-"));  
			 
			
			//신청단위 변경 시
			$("#dayGubunCd").bind("change", function(){
				initWorkTermCombo(); // 근무기간 콤보
				init_sheet(); //근무스케쥴 조회
			});
			
			//근무기간 변경시 시트 생성
			$("#workTerm").bind("change", function(){
				init_sheet(); //근무스케쥴 조회
			
			});
	    }

		doAction("Search");

	});
	
	//근무조 및 신청단위 콤보 생성
	function initWorkOrg(){
		if( $("#ymd").val() == "" ) return;

		var data = ajaxCall( "${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppDetWorkOrg", $("#searchForm").serialize(),false);

		if ( data != null && data.DATA != null ){
			$("#workGrpCd").val( data.DATA.workGrpCd );
			$("#workOrgCd").val( data.DATA.workOrgCd );
			$("#span_workOrgNm").html( data.DATA.workOrgNm );
			$("#intervalCd").val( data.DATA.intervalCd );
			$("#termGubun").val( data.DATA.termGubun );
			$("#workType").val( data.DATA.workType );
			
			
			//신청단위
			var dayGubunCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList",data.DATA.dayGrcodeCd), "");
			$("#dayGubunCd").html(dayGubunCdList[2]);

			$("#dayGubunCd").change();
			
		}else{
			alert($("#ymd").val()+"에 근무스케쥴이 생성되지 않았습니다.\n담당자에게 문의 해주세요.");
			$("#ymd").val("");
			return;
		}
		
	}
	
	//근무기간 콤보 생성
	function initWorkTermCombo(){

		//근무기간 콤보
		var param = "&searchSabun="+$("#searchSabun").val()
		          + "&searchWorkGrpCd="+$("#workGrpCd").val()
		          + "&searchYmd="+$("#ymd").val().replace(/-/gi,"")
		          + "&searchCnt="+$("#dayGubunCd").val()
		          + "&searchGubun=APP";
		
		var workTermCdList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTimWeekTermCodeList"+param, false).codeList
				           , "sYmd,eYmd,WorkOrgCd,selYn"
				           , "");
		$("#workTerm").html(workTermCdList[2]);
	}

	//---------------------------------------------------------------------------------------------------------------
	// 저장 시 사용하는 시트
	//---------------------------------------------------------------------------------------------------------------
	function init_saveSheet(){
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
		
		initdata.Cols = [
			{Header:"상태",		Type:"Status", Hidden:0, SaveName:"sStatus"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"workYmd"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"bfTimeCd"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"afTimeCd"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"otTime"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"gntStat"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"gntPlan"}
		]; IBS_InitSheet(saveSheet, initdata);
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1
	//---------------------------------------------------------------------------------------------------------------
	var titleList;
	function init_sheet(){

		$("#searchSYmd").val( $("#workTerm option:selected").attr("sYmd") );
		$("#searchEYmd").val( $("#workTerm option:selected").attr("eYmd") );		

		//근무시간 콤보-----------------------------------------------------------------------------------------------------------------------------
		var params= "&searchUseYn=Y&searchWorkOrgCd="+ $("#workOrgCd").val()+"&searchYmd="+ $("#searchSYmd").val();
		var timeCdData = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTimTimeCdCodeList"+ params, false).codeList; 
		
		//공휴시 근무시간 콤보 ( 휴일근무시간 중에서만 선택 가능 ) 
		params = params +"&searchWorkYn=Y";
		var holTimeList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTimTimeCdCodeList"+ params, false).codeList, ""); 
		
		var timeAllList = convCodeCols(timeCdData, "timeHour", "");
		$("#viewTimeCd").html(timeAllList[2]).bind("change", function(){
			showTimeSheet(1);
		}); //근무시간보기
		

		//근무시간계산을 위한 Map
		timeCdMap = {};
		for(var i in timeCdData){
			if( timeCdData[i].workYn == "Y" ){ //휴일근무시간이면
				timeCdMap[timeCdData[i].code] = 0;	
			}else{
				timeCdMap[timeCdData[i].code] = timeCdData[i].timeHour;
			}
			
		}
		//--------------------------------------------------------------------------------------------------------------------------------------
		

		titleList = ajaxCall("${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppDetHeaderList", $("#searchForm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {
			
			sheet1.Reset();
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:2};
			initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
			initdata.Cols = [];
			var v = 0 ;
			initdata.Cols[v++] = {Header:"상태",	Type:"Status",	Hidden:1, Width:45, Align:"Center", SaveName:"sStatus"};
			initdata.Cols[v++] = {Header:"구분", Type:"Html", 	Hidden:0, Width:70, Align:"Center", SaveName:"gubun", KeyField:0, Format:"", Edit:0, BackColor:"#f4f4f4"};
			
			var cnt = 1, idx1 = 1, idx2 = 1;
			for(i = 0 ; i<titleList.DATA.length; i++) {
				var title = titleList.DATA[i].md+"\n"+titleList.DATA[i].wk;
				initdata.Cols[v++] = {Header:title, Type:"Combo", Hidden:0, Width:90, Align:"Center", SaveName:titleList.DATA[i].saveName, Edit:titleList.DATA[i].colEdit, ComboText:timeAllList[0], ComboCode:timeAllList[1]};
				
				if( titleList.DATA[i].workYn == "Y" ){//휴일
					if( titleList.DATA[i].holidayYn == "Y" ){//공휴일이면 휴일근무시간 중에서 선택가능. ( 공휴일 휴일은 기본근무로 바꿀 수 없음. [휴일관리]에서 공휴일을 변경 하거나 휴일근무신청으로 근무를 신청 해야함) 
						initdata.Cols[v-1].ComboText = holTimeList[0];
						initdata.Cols[v-1].ComboCode = holTimeList[1];	
					}else{
						initdata.Cols[v-1].ComboText = timeAllList[0];
						initdata.Cols[v-1].ComboCode = timeAllList[1];	
					} 
					initdata.Cols[v-1].FontColor = "red";
				    
				}
				//주단위 근무시간 합산 
				if( titleList.DATA[i].weekYn == "Y" ){
					initdata.Cols[v++] = {Header:"주\n근무\n시간", Type:"Int", Hidden:0, Width:50, Align:"Center", SaveName:"weekTimeHour"+idx1, KeyField:0, Format:"", Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:"주\n근무\n일수", Type:"Int", Hidden:1, Width:50, Align:"Center", SaveName:"weekTimeDay"+idx1 };
					idx1++;
				}
				//단위기간 근무시간 합산
				if( titleList.DATA[i].termYn == "Y" && $("#intervalCd").val() != "7" ){  //주단위 일 때만 단위 기간 체크
					initdata.Cols[v++] = {Header:"단위\n근무\n시간", Type:"Int", Hidden:0, Width:50, Align:"Center", SaveName:"termTimeHour"+idx2, KeyField:0, Format:"", Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:"단위\n근무\n일수", Type:"Int", Hidden:1, Width:50, Align:"Center", SaveName:"termTimeDay"+idx2 };
					idx2++;
				}
				
				cnt++;
			}
			
			/*
			//공휴시 인정근무시간 
			for(i = 0 ; i<titleList.DATA.length; i++) {
				initdata.Cols[v++] = {Header:"Hidden", Type:"Float", Hidden:1, SaveName:titleList.DATA[i].saveName+"HolHour", Edit:0 }; //공휴시 인정근무시간
			}*/
			
			IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
			sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
			sheet1.SetDataRowHeight(36);
			sheet1.SetHeaderRowHeight(50); // 헤더행 높이

			
			
			if( authPg == "A" ){
				sheet1.SetDataBackColor("#fdf0f5");
				sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor());
				sheet1.SetEditable(1);
				
				$(window).smartresize(sheetResize); sheetInit();
				
				sheet1.DoSearch( "${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppDetList", $("#searchForm").serialize());
				
			}else{
				sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
				sheet1.SetEditable(0);

				$(window).smartresize(sheetResize); sheetInit();

				var sXml = sheet1.GetSearchData("${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppDetList", $("#searchForm").serialize() );
				sXml = replaceAll(sXml,"BackColor", "#BackColor");
				sheet1.LoadSearchData(sXml );
			}
			
		}

	}	

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppDet", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 

				$("#ymd").val( formatDate(data.DATA.ymd, "-") );
				$("#note").val( data.DATA.note );
				$("#workGrpCd").val( data.DATA.workGrpCd );
				$("#workOrgCd").val( data.DATA.workOrgCd );
				$("#span_workOrgNm").html( data.DATA.workOrgNm );
				$("#intervalCd").val( data.DATA.intervalCd );
				$("#searchSYmd").val( data.DATA.sdate );
				$("#searchEYmd").val( data.DATA.edate );
				$("#termGubun").val( data.DATA.termGubun );
				
				//신청단위
				var dayGubunCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList",data.DATA.dayGrcodeCd), "");
				$("#dayGubunCd").html(dayGubunCdList[2]);
				$("#dayGubunCd").val(data.DATA.dayGubunCd);
				
				if(authPg == "R") {
					$("#workTerm").html("<option value='"+data.DATA.sdate+"_"+data.DATA.edate+"' sYmd="+data.DATA.sdate+" eYmd="+data.DATA.edate+">"+data.DATA.workTerm+"</option>");

				}else{
					
					initWorkTermCombo(); // 근무기간 콤보
					
					$("#workTerm").val(data.DATA.sdate+"_"+data.DATA.edate);
				}
				
				init_sheet(); //근무스케쥴 조회
				
			
			}else{
				initWorkOrg();
			}


			break;
		}
	}

	//--------------------------------------------------------------------------------
	//  sheet1 Events
	//--------------------------------------------------------------------------------
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			resizeSheetHeight(sheet1, "R"); //시트행 갯수에 맞게 시트 높이 설정 ( 아래 CellProperty 이후에 하면 안됨 시트 버그 같음 ..)

			//수정 불가 라인
			sheet1.SetRowEditable(1, 0); // 변경전 라인
			sheet1.SetRowEditable(3, 0); // 근태현황 라인
			
			var info = {Type: "Text", Align: "Center", ComboText:"", ComboCode:""};
			var info2 = {Type: "Float", Align: "Center", ComboText:"", ComboCode:"", Format:"#0.#\\시간"};
					
			sheet1.RenderSheet(0);
			for( var col=2; col <= sheet1.LastCol() ; col ++){
				var saveName = sheet1.ColSaveName(col);
				if( saveName.substring(0,2) == "td" && saveName.length == 10 ){ //근무코드
					sheet1.InitCellProperty(3, col, info); //근태현황
					sheet1.InitCellProperty(4, col, info); //근태계획
					sheet1.InitCellProperty(5, col, info2); //연장계획(시간)
					//console.log(saveName+":"+sheet1.GetCellValue(5,col));
					
					//연장계획 휴일 수정 가능하도록
					var ymd = sheet1.ColSaveName(col).substring(2); 
					if( ymd > "${curSysYyyyMMdd}" && sheet1.GetColFontColor(col) == "red" ) { //휴일 글자색 red
						sheet1.SetCellEditable(5, col, 1);
					}
					
				}
			}

			sheet1.RenderSheet(1);
			
			calcWorkTime(); //근무시간 계산

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		 try{
			 if( (Row == 2 || Row == 5 )  && sheet1.ColSaveName(Col).substring(0,2) == "td") { //날짜
				calcWorkTime(); //근무시간 계산
			 }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	
	
	//--------------------------------------------------------------------------------
	//주 근무시간, 단위 근무시간 계산
	//--------------------------------------------------------------------------------
	function calcWorkTime(){

		try {
			var afWeekTimeHour = 0, bfWeekTimeHour = 0, weekDayCnt = 0, weekDayAllCnt = 0;
			var afTermTimeHour = 0, bfTermTimeHour = 0, termDayCnt = 0, termDayAllCnt = 0;
			var weekOtHour = 0, termOtHour = 0;    // 연장근무시간
			
			var idx1 = 1, idx2 = 1;
			
			for(i = 0 ; i<titleList.DATA.length; i++) {
				var saveName = titleList.DATA[i].saveName;

				bfWeekTimeHour += Number( timeCdMap[sheet1.GetCellValue(1, saveName)] );// + Number(sheet1.GetCellValue(1, saveName+"HolHour")); //변경 전
				afWeekTimeHour += Number( timeCdMap[sheet1.GetCellValue(2, saveName)] );// + Number(sheet1.GetCellValue(2, saveName+"HolHour")); //변경 후
				bfTermTimeHour += Number( timeCdMap[sheet1.GetCellValue(1, saveName)] );// + Number(sheet1.GetCellValue(1, saveName+"HolHour")); //변경 전
				afTermTimeHour += Number( timeCdMap[sheet1.GetCellValue(2, saveName)] );// + Number(sheet1.GetCellValue(2, saveName+"HolHour")); //변경 후
				
				weekOtHour += Number(sheet1.GetCellValue(5, saveName));
				termOtHour += Number(sheet1.GetCellValue(5, saveName));
				
				//if( titleList.DATA[i].planWorkYn == "N" ){ //근무일수
					weekDayCnt++; termDayCnt++;
				//}
				weekDayAllCnt++; termDayAllCnt++;

				//주단위 근무시간 합산 
				if( titleList.DATA[i].weekYn == "Y" ){
					
					//console.log(cnt+"==> idx1:"+idx1+"==> bfWeekTimeHour:"+bfWeekTimeHour+"==> afWeekTimeHour:"+afWeekTimeHour);
					sheet1.SetCellValue(1, "weekTimeHour"+idx1, bfWeekTimeHour, 0); bfWeekTimeHour = 0;
					sheet1.SetCellValue(2, "weekTimeHour"+idx1, afWeekTimeHour, 0); afWeekTimeHour = 0;
					sheet1.SetCellValue(5, "weekTimeHour"+idx1, weekOtHour, 0);     weekOtHour = 0;
					
					//근무일수
					sheet1.SetCellValue(2, "weekTimeDay"+idx1,  weekDayCnt, 0);     weekDayCnt = 0;    //주 근무일수
					sheet1.SetCellValue(5, "weekTimeDay"+idx1,  weekDayAllCnt, 0);  weekDayAllCnt = 0; //주 전체일수
					idx1++;
				}
				//단위기간 근무시간 합산 
				if( titleList.DATA[i].termYn == "Y" && $("#intervalCd").val() != "7" ){ //주단위 일대만 단위기간 표시
					//console.log(cnt+"==> idx2:"+idx2+"==> bfTermTimeHour:"+bfTermTimeHour+"==> afTermTimeHour:"+afTermTimeHour);
					sheet1.SetCellValue(1, "termTimeHour"+idx2, bfTermTimeHour, 0); bfTermTimeHour = 0;
					sheet1.SetCellValue(2, "termTimeHour"+idx2, afTermTimeHour, 0); afTermTimeHour = 0;
					sheet1.SetCellValue(5, "termTimeHour"+idx2, termOtHour, 0);     termOtHour = 0;
					//근무일수
					sheet1.SetCellValue(2, "termTimeDay"+idx2,  termDayCnt, 0);     termDayCnt = 0;    //단위기간 근무일수
					sheet1.SetCellValue(5, "termTimeDay"+idx2,  termDayAllCnt, 0);  termDayAllCnt = 0; //단위기간 전체일수
					idx2++;
				}
				
			}
			
			
		}catch(ex){alert("calcWorkTime(근무시간계산) Error : " + ex);}
		
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

		if( ch == false )  return false;
		
		// --------------------------------------------------------------------------------------------------------
		// 기 신청건 체크 
		// --------------------------------------------------------------------------------------------------------
		var data = ajaxCall("${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppDetDupCnt", $("#searchForm").serialize(),false);

		if(data.DATA != null && data.DATA.dupCnt != "null" && data.DATA.dupCnt != "0"){
			alert("해당 기간에 신청 중이 스케줄이 있습니다.");
			ch =  false; return false;
		}

		if( ch == false )  return false;
		

		// --------------------------------------------------------------------------------------------------------
		// 근무한도 조회
		// --------------------------------------------------------------------------------------------------------
		var lmt = ajaxCall("${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppDetLimit", $("#searchForm").serialize(),false);
		if( lmt.DATA == null ) return true;
		
		// --------------------------------------------------------------------------------------------------------
		// 일 근무시간 체크
		// --------------------------------------------------------------------------------------------------------
		if( lmt.DATA.sumDayWkLmt != null || lmt.DATA.sumDayOtLmt != null ){
			var	iSumDayWkLmt = Number(lmt.DATA.sumDayWkLmt);  //기본한도_일_기본
			var	iSumDayOtLmt = Number(lmt.DATA.sumDayOtLmt);  //기본한도_일_연장
				
  			var i = 0;
  	  		while ( i < titleList.DATA.length ) {
  	  			var saveName = titleList.DATA[i].saveName;
  	  			
  	  			if( lmt.DATA.sumDayWkLmt != null && Number( timeCdMap[sheet1.GetCellValue(2, saveName)] ) > iSumDayWkLmt ){
  	  				alert(sheet1.GetCellValue(0, saveName).split("\n").join("") + "의 기본근무는 " + iSumDayWkLmt + "시간을 넘길 수 없습니다.\n(신청시간 : "+timeCdMap[sheet1.GetCellValue(2, saveName)] +"시간)");
  	  				i = 999; ch =  false;
  	  			}
  	  			if( lmt.DATA.sumDayOtLmt != null && Number( timeCdMap[sheet1.GetCellValue(5, saveName)] ) > iSumDayOtLmt ){
	  				alert(sheet1.GetCellValue(0, saveName).split("\n").join("") + "의 연장근무는 " + iSumDayOtLmt + "시간을 넘길 수 없습니다.\n(신청시간 : "+timeCdMap[sheet1.GetCellValue(5, saveName)] +"시간)");
	  				i = 999; ch =  false;
	  			}
  				i++;
  	  		}
		}

		if( ch == false )  return false;
		
		// --------------------------------------------------------------------------------------------------------
		// 주 근무시간 체크 
		// --------------------------------------------------------------------------------------------------------
		if( lmt.DATA.sumWeekWkLmt != null || lmt.DATA.sumWeekOtLmt != null ){
			var	iSumWeekWkLmt = Number(lmt.DATA.sumWeekWkLmt);  //기본한도_주_기본
			var	iSumWeekOtLmt = Number(lmt.DATA.sumWeekOtLmt);  //기본한도_주_연장
	  		var i = 1;
	  		while ( sheet1.GetCellValue(2, "weekTimeHour"+i)  != "-1") {
	  			
	  			if( lmt.DATA.sumWeekWkLmt != null  != "" && Number(sheet1.GetCellValue(2, "weekTimeHour"+i)) > iSumWeekWkLmt ){
					alert("주 기본근무시간은 "+iSumWeekWkLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+sheet1.GetCellValue(2, "weekTimeHour"+i)+"시간)");
					sheet1.SelectCell(2, "weekTimeHour"+i);  
					ch =  false; return false;
				}

	  			if( lmt.DATA.sumWeekOtLmt != null && Number(sheet1.GetCellValue(5, "weekTimeHour"+i)) > iSumWeekOtLmt ){
					alert("주 연장근무시간은 "+iSumWeekOtLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+sheet1.GetCellValue(5, "weekTimeHour"+i)+"시간)");
					sheet1.SelectCell(5, "weekTimeHour"+i);  
					ch =  false; return false;
				}
	  			
	  		  	i++;
	  		}
		
		}

		if( ch == false )  return false;
		
  		// --------------------------------------------------------------------------------------------------------
		// 단위기간 일 평균한도 체크
		// --------------------------------------------------------------------------------------------------------
		if( lmt.DATA.avgDayWkLmt || lmt.DATA.avgDayOtLmt || lmt.DATA.avgWeekWkLmt || lmt.DATA.avgWeekOtLmt ){
			var	iAvgDayWkLmt = Number(lmt.DATA.avgDayWkLmt);  //평균한도_일_기본
			var	iAvgDayOtLmt = Number(lmt.DATA.avgDayOtLmt);  //평균한도_일_연장
			
	  		var i = 1, j = 1;  
	  		while ( sheet1.GetCellValue(2, "termTimeDay"+i)  != "-1") {
	  			var iCnt1 = Number(sheet1.GetCellValue(2, "termTimeDay"+i)) ; //근무일수
	  			var iCnt2 = Number(sheet1.GetCellValue(5, "termTimeDay"+i)) ; //전체일수
	  			var iSumDayWtLmt =  iAvgDayWkLmt * iCnt1;  //기본근무 기준시간 : 휴일제외 근무일수로 구함
	  			var iSumDayOtLmt =  iAvgDayOtLmt * iCnt2;  //연장근무 기준시간 : 휴일포험 전체일수로 구함  
	  				  			
				if( lmt.DATA.avgDayWkLmt && Number(sheet1.GetCellValue(2, "termTimeHour"+i)) > iSumDayWtLmt ){
					alert("단위기간 기본근무시간은 "+iSumDayWtLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+sheet1.GetCellValue(2, "termTimeHour"+i)+"시간)");
					ch =  false; return false;
				}
				if( lmt.DATA.avgDayWkLmt && Number(sheet1.GetCellValue(5, "termTimeHour"+i)) > iSumDayOtLmt ){
					alert("단위기간 연장근무시간은 "+iSumDayOtLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+sheet1.GetCellValue(5, "termTimeHour"+i)+"시간)");
					ch =  false; return false;
				}

				//주 평균한도 체크 ( 단위기간이 주단위 일 때만 체크  )
				if( $("#termGubun").val() == "W" ){
					if( lmt.DATA.avgWeekWkLmt != null || lmt.DATA.avgWeekOtLmt != null ){
						var	iAvgWeekWkLmt = Number(lmt.DATA.avgWeekWkLmt);  //평균한도_주_기본
						var	iAvgWeekOtLmt = Number(lmt.DATA.avgWeekOtLmt);  //평균한도_주_연장
						//console.log("iAvgWeekWkLmt:"+iAvgWeekWkLmt + ", iAvgWeekOtLmt:"+iAvgWeekOtLmt);
			  			
						var weekCnt = 0;
						var iSumWtTime = 0, iSumOtTime = 0;
				  		while ( sheet1.GetCellValue(2, "weekTimeHour"+j)  != "-1" && sheet1.SaveNameCol("weekTimeHour"+j) < sheet1.SaveNameCol("termTimeDay"+i) ) {
				  			if( sheet1.GetCellValue(5, "weekTimeDay"+j) == "7"){ // 일주일 전체 있을 때만 
				  				weekCnt++;
				  				iSumWtTime = iSumWtTime + Number(sheet1.GetCellValue(2, "weekTimeHour"+j)); //주 기본근무시간 
				  				iSumOtTime = iSumOtTime + Number(sheet1.GetCellValue(5, "weekTimeHour"+j)); //주 연장근무시간
				  			}
				  			
				  			j++;
				  		}
				  		
				  		//console.log("weekCnt : "+weekCnt+ ", iSumWtTime:"+iSumWtTime + ", iSumOtTime:"+iSumOtTime);
				  		
						if( weekCnt > 0 ){
							// 주 평균 
				  			var iAvgWt =  iSumWtTime / weekCnt;  
				  			var iAvgOt =  iSumOtTime / weekCnt;  
					  		
							if( lmt.DATA.avgWeekWkLmt != null && iAvgWt > iAvgWeekWkLmt ){
								alert("단위기간 주 평균 기본근무시간은 "+iAvgWeekWkLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+iSumWtTime+"시간 / "+weekCnt+"주)");
								ch =  false; return false;
							}
							if( lmt.DATA.avgWeekOtLmt != null && iAvgOt > iAvgWeekOtLmt ){
								alert("단위기간 주 평균 연장근무시간은 "+iAvgWeekOtLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+iSumOtTime+"시간 / "+weekCnt+"주)");
								ch =  false; return false;
							}
						}
			  			
			  		}
					
				}
				
	  		  	i++;
	  		}
		}
  		// --------------------------------------------------------------------------------------------------------
	  		
		return ch;
	}

	//
	function makeSaveSheet(){
		saveSheet.RemoveAll();

		for( var col=2; col <= sheet1.LastCol() ; col ++){
			var saveName = sheet1.ColSaveName(col);
			if( saveName.substring(0,2) == "td" && saveName.length == 10 ){ //근무코드
	 			var row = saveSheet.DataInsert();
	 			var workYmd = sheet1.ColSaveName(col).substring(2);
	 			saveSheet.SetCellValue(row, "workYmd", workYmd);
	 			saveSheet.SetCellValue(row, "bfTimeCd", sheet1.GetCellValue(1, col) );
	 			saveSheet.SetCellValue(row, "afTimeCd", sheet1.GetCellValue(2, col) );
	 			saveSheet.SetCellValue(row, "gntStat", sheet1.GetCellValue(3, col) );
	 			saveSheet.SetCellValue(row, "gntPlan", sheet1.GetCellValue(4, col) );
	 			saveSheet.SetCellValue(row, "otTime", sheet1.GetCellValue(5, col) );
			}
		}
		
	}
	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		var returnValue = false;
		try {
			sheet1.SetEndEdit(1); //시트 편집상태를 종료한다.
			
			if ( authPg == "R" )  {
				return true;
			} 
			
			// 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }
			if( sheet1.RowCount() == 0 ){
				alert("신청할 내용이 없습니다.");
				return false;
			}
			
			if( sheet1.FindStatusRow("U") == "" ){
				alert("변경된 내용이 없습니다.");
				return false;
			}
	        
			//저장 데이터
			makeSaveSheet();
			
	        var saveStr = saveSheet.GetSaveString(0);
            IBS_SaveName(document.searchForm, saveSheet);
            var rtn = eval("("+sheet1.GetSaveData("${ctx}/WorkScheduleApp.do?cmd=saveWorkScheduleAppDet", $("#searchForm").serialize()+"&"+saveStr )+")");
            
            if(rtn.Result.Code < 1) {
                alert(rtn.Result.Message);
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

		var param = "ymd="+$("#ymd").val().replace(/-/gi,"")
		          + "&timeCd="+$("#viewTimeCd").val();
		
		var headerList = ajaxCall("${ctx}/PsnlWorkScheduleMgr.do?cmd=getPsnlWorkScheduleMgrDayWorkHeaderList", param, false);
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
				initdata.Cols[i+2] = {Header:headerList.DATA[i].hhText+"|"+headerList.DATA[i].mm,	Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:headerList.DATA[i].colName,	Focus:0, Edit:0};
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
			
			timeSheet.DoSearch( "${ctx}/PsnlWorkScheduleMgr.do?cmd=getPsnlWorkScheduleMgrDayWorkList", param );

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
			sheetResize();
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
	<input type="hidden" id="searchSabun"		name="searchSabun"	 	 value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	
	<input type="hidden" id="workGrpCd"			name="workGrpCd"	 	 value=""/> <!--근무그룹 -->
	<input type="hidden" id="workOrgCd"			name="workOrgCd"	 	 value=""/> <!--근무조 -->
	<input type="hidden" id="intervalCd"		name="intervalCd"	 	 value=""/> <!--단위기간 -->
	<input type="hidden" id="termGubun"			name="termGubun"	 	 value=""/> <!--단위구분 M:월단위, W:주단위 -->
	<input type="hidden" id="workType"			name="workType"	 	 	 value=""/> <!--직군 A:사무직, B:생산직 -->
	
	<input type="hidden" id="dayGrcodeCd"		name="dayGrcodeCd"	 	 value=""/>
	<input type="hidden" id="searchSYmd" 		name="searchSYmd" 		 value=""/>
	<input type="hidden" id="searchEYmd" 		name="searchEYmd" 		 value=""/>
	
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
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
			<th>기준일자</th>
			<td>
				<input id="ymd" name="ymd" type="text" class="${dateCss} ${required} w70 spacingN " readonly maxlength="10" />
			</td>
			<th>근무조</th>
			<td>
				<span id="span_workOrgNm"></span>
			</td>
		</tr>
		<tr>
			<th>신청단위</th>
			<td>
				<select id="dayGubunCd" name="dayGubunCd" class="${selectCss} ${required} spacingN" ${disabled}> </select>
			</td>
			<th>근무기간</th>
			<td>
				<select id="workTerm" name="workTerm" class="${selectCss} ${required} spacingN" ${disabled}> </select>
			</td>
		</tr>
		<tr>
			<th>신청사유</th>
			<td colspan="3" >
				<textarea rows="2" id="note" name="note" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
	</form>
	
	<div class="h10"></div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "250px", "${ssnLocaleCd}"); </script>
	<div class="hide">
		<script type="text/javascript"> createIBSheet("saveSheet", "100%", "0px", "${ssnLocaleCd}"); </script>
	</div>	
	
	<div id="divTimeSheet" style="display:none;">
		<div class="sheet_title">
		<ul>
			<li class="txt">일 근무시간 상세내역</li>
			<li class="btn">
                 <b>근무시간 : </b><select id="viewTimeCd" name="viewTimeCd"></select> 
                 <a href="javascript:showTimeSheet(1);" class="btn filled" >보기</a>
                 <a href="javascript:showTimeSheet(0);" class="btn outline_gray" >닫기</a>
			</li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("timeSheet", "100%", "0px", "${ssnLocaleCd}"); </script>
	</div>
	
</div>
		
</body>
</html>