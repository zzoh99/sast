<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>부서근무스케쥴신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%/*
		선택근무제(WORK_GRP_CD=A1)은 한도체크 불가 함. 
*/%>
<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var applYn	         = "";
var timeCdMap, timeColorMap, workLmtObj;

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
		if(authPg == "A"){
			$("#divTimeSheet").show();
			
			init_saveSheet(); //저장용 시트
		}
				
		// 신청
		if(authPg == "A" && applStatusCd == "" ) {
			
			//기준일자
			$("#searchYmd").datepicker2({
				onReturn:function(date){
					
					sheet1.RemoveAll();	
					initOrgCdCombo(); //조직콤보
					
				}
			}).val(addDate("d", 1, "${curSysYyyyMMddHyphen}", "-"));  

			
			//조직 콤보 변경 시
			$("#searchOrgCd").bind("change", function(){

				//신청권한 (0:개인, 1:부서)
				var orgAuth = $("#searchOrgCd option:selected").attr("orgAuth");
				$("#searchOrgAuth").val(orgAuth);
				
				initWorkOrgCombo(); //근무조 및 신청단위 콤보 생성
			
			});
			
			//근무조 콤보 변경 시
			$("#searchWorkOrgCd").bind("change", function(){

				var obj = $("#searchWorkOrgCd option:selected");
				$("#workGrpCd").val( obj.attr("workGrpCd") );
				$("#intervalCd").val( obj.attr("intervalCd") );
				$("#dayGrcodeCd").val( obj.attr("dayGrcodeCd") );
				$("#termGubun").val( obj.attr("termGubun") );
				$("#tempSabun").val( obj.attr("sabun") );
				
				initDayGubunCombo();  //신청단위 콤보
			
			});
			
			
			//신청단위 변경 시
			$("#dayGubunCd").bind("change", function(){
				initWorkTermCombo(); // 근무기간 콤보
			});
			
			//근무기간 변경시 시트 생성
			$("#workTerm").bind("change", function(){
				init_sheet(); //근무스케쥴 조회
			
			});
			
	    }else if(authPg == "A" ){
	    	//부서, 근무조, 신청단위, 근무기간 ...수정 불가
	    	$("#searchYmd").removeClass("required").addClass("transparent");
	    	$("#searchOrgCd, #searchWorkOrgCd, #dayGubunCd, #workTerm").css("width", "100%");
	    	$("#searchOrgCd, #searchWorkOrgCd, #dayGubunCd, #workTerm").removeClass("required").addClass("transparent").addClass("hideSelectButton").attr("disabled", "disabled");
	    }

		doAction("Search");

	});

	//---------------------------------------------------------------------------------------------------------------
	// 콤보생성
	//---------------------------------------------------------------------------------------------------------------
	//1. 조직 콤보
	function initOrgCdCombo(){
		if( $("#searchYmd").val() == "" ) return;
		
		var obj = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkScheduleOrgAppDetOrgList&"+ GetParamAll("searchForm"), false).codeList, "orgAuth", "");
		$("#searchOrgCd").html(obj[2]).change();	
		
	}
	
	//2.근무조 콤보 생성
	function initWorkOrgCombo(){
		if( $("#searchYmd").val() == "" || $("#searchOrgCd").val() == "" ) return;

		var obj = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkScheduleOrgAppDetWorkOrg&"+ GetParamAll("searchForm"), false).codeList
				, "workGrpCd,workOrgCd,workOrgNm,intervalCd,dayGrcodeCd,termGubun,sabun", "");
		$("#searchWorkOrgCd").html(obj[2]).change();	
	}

	//3.신청단위 콤보 생성
	function initDayGubunCombo(){
		if( $("#dayGrcodeCd").val() == "" ) return;
		//신청단위
		var obj = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList",$("#dayGrcodeCd").val()), "");
		$("#dayGubunCd").html(obj[2]).change();

	}
	
	//4.근무기간 콤보 생성
	function initWorkTermCombo(){

		//근무기간 콤보
		var param = "&searchSabun="+$("#tempSabun").val()  // 팀내 대표자 사번
		          + "&searchWorkGrpCd="+$("#workGrpCd").val()
		          + "&searchYmd="+$("#searchYmd").val().replace(/-/gi,"")
		          + "&searchCnt="+$("#dayGubunCd").val()
		          + "&searchGubun=APP";
		
		var workTermCdList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTimWeekTermCodeList"+param, false).codeList
				           , "sYmd,eYmd,WorkOrgCd,selYn"
				           , "");
		$("#workTerm").html(workTermCdList[2]).change();
	}


	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/WorkScheduleOrgApp.do?cmd=getWorkScheduleOrgAppDet", GetParamAll("searchForm"),false);

			if ( data != null && data.DATA != null ){ 

				$("#searchYmd").val( formatDate(data.DATA.ymd, "-") );
				$("#note").val( data.DATA.note );
				$("#workGrpCd").val( data.DATA.workGrpCd );
				$("#intervalCd").val( data.DATA.intervalCd );
				$("#searchSYmd").val( data.DATA.sdate );
				$("#searchEYmd").val( data.DATA.edate );
				$("#termGubun").val( data.DATA.termGubun );
				$("#searchOrgAuth").val( data.DATA.orgAuth );
				
				//부서
				$("#searchOrgCd").html("<option value='"+data.DATA.orgCd+"'>"+data.DATA.orgNm+"</option>");
				//근무조
				$("#searchWorkOrgCd").html("<option value='"+data.DATA.workOrgCd+"'>"+data.DATA.workOrgNm+"</option>");
				
				//신청단위
				var dayGubunCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList",data.DATA.dayGrcodeCd), "");
				$("#dayGubunCd").html(dayGubunCdList[2]);
				$("#dayGubunCd").val(data.DATA.dayGubunCd);
				
				$("#workTerm").html("<option value='"+data.DATA.sdate+"_"+data.DATA.edate+"' sYmd="+data.DATA.sdate+" eYmd="+data.DATA.edate+">"+data.DATA.workTerm+"</option>");

				
				
				init_sheet(); //근무스케쥴 조회
				
			
			}else{
				//부서콤보 생성
				initOrgCdCombo();
			}


			break;
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet1
	//---------------------------------------------------------------------------------------------------------------
	var titleList;
	function init_sheet(){

		$("#searchSYmd").val( $("#workTerm option:selected").attr("sYmd") );
		$("#searchEYmd").val( $("#workTerm option:selected").attr("eYmd") );		

		//근무시간 콤보-----------------------------------------------------------------------------------------------------------------------------
		var params= "&searchUseYn=Y&searchWorkOrgCd="+ $("#searchWorkOrgCd").val()+"&searchYmd="+ $("#searchSYmd").val();
		var timeCdData = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTimTimeCdCodeList"+ params, false).codeList; 
		
		//공휴시 근무시간 콤보 ( 휴일근무시간 중에서만 선택 가능 ) 
		params = params +"&searchWorkYn=Y";
		var holTimeList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTimTimeCdCodeList"+ params, false).codeList, ""); 
		
		var timeAllList = convCodeCols(timeCdData, "timeHour,workYn,rgbColor", "");
		$("#viewTimeCd").html(timeAllList[2]).bind("change", function(){
			showTimeSheet(1);
		}); //근무시간보기
		

		//근무시간계산을 위한 Map
		timeCdMap = {}, timeColorMap = {};;
		for(var i in timeCdData){
			if( timeCdData[i].workYn == "Y" ){ //휴일근무시간이면
				timeCdMap[timeCdData[i].code] = 0;	
			}else{
				timeCdMap[timeCdData[i].code] = timeCdData[i].timeHour;
			}
			//근무시간 배경색상
			timeColorMap[timeCdData[i].code] = timeCdData[i].rgbColor;
		}

		// --------------------------------------------------------------------------------------------------------
		// 근무한도 조회
		// --------------------------------------------------------------------------------------------------------
		workLmtObj = ajaxCall("${ctx}/WorkScheduleOrgApp.do?cmd=getWorkScheduleOrgAppDetLimit", GetParamAll("searchForm"),false);

		//--------------------------------------------------------------------------------------------------------------------------------------

		titleList = ajaxCall("${ctx}/WorkScheduleOrgApp.do?cmd=getWorkScheduleOrgAppDetHeaderList", GetParamAll("searchForm"), false);
		if (titleList != null && titleList.DATA != null) {
			
			sheet1.Reset();
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:4};
			initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
			initdata.Cols = [];
			var v = 0 ;
			initdata.Cols[v++] = {Header:"No",	Type:"${sNoTy}",Hidden:0, Width:45, Align:"Center", SaveName:"sNo", Sort:0};
			initdata.Cols[v++] = {Header:"상태",	Type:"Status",	Hidden:1, Width:45, Align:"Center", SaveName:"sStatus"};
			initdata.Cols[v++] = {Header:"사번", Type:"Text", 	Hidden:1, Width:70, Align:"Center", SaveName:"sabun", KeyField:0, Format:"", Edit:0};//, BackColor:"#f4f4f4"};
			initdata.Cols[v++] = {Header:"성명", Type:"Text", 	Hidden:0, Width:70, Align:"Center", SaveName:"name", KeyField:0, Format:"", Edit:0};//, BackColor:"#f4f4f4"};
			initdata.Cols[v++] = {Header:"직위", Type:"Text", 	Hidden:0, Width:70, Align:"Center", SaveName:"jikweeNm", KeyField:0, Format:"", Edit:0};//, BackColor:"#f4f4f4"};
			
			var cnt = 1, idx1 = 1, idx2 = 1, hdn1 = 0;
			var sType = "AutoSum";
			if( $("#searchOrgAuth").val() == "0" ) sType = "Int"; //본인신청 시에는 합계행 숨김
			if( $("#workGrpCd").val() == 'A1')  hdn1 = 1; //선택근무제는 잔여시간 숨김
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
					initdata.Cols[v++] = {Header:"주\n근무\n시간", Type:sType, Hidden:0, Width:50, Align:"Center", SaveName:"weekTimeHour"+idx1, KeyField:0, Format:"", Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:"주\n잔여\n시간", Type:sType, Hidden:hdn1, Width:50, Align:"Center", SaveName:"weekTimeRem"+idx1, KeyField:0, Format:"", Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:"주\n근무\n일수", Type:sType, Hidden:1, Width:50, Align:"Center", SaveName:"weekTimeDay"+idx1 , Edit:0};
					initdata.Cols[v++] = {Header:"주\n전체\n일수", Type:sType, Hidden:1, Width:50, Align:"Center", SaveName:"weekTimeDayAll"+idx1, Edit:0 };
					idx1++;
				}
				//단위기간 근무시간 합산  
				if( titleList.DATA[i].termYn == "Y" && $("#intervalCd").val() != "7" &&  $("#workGrpCd").val() != 'A1'){  //주단위 일 때만 단위 기간 체크 + 선택근무제는 단위기간 표시 안함. 
					initdata.Cols[v++] = {Header:"단위\n근무\n시간", Type:sType, Hidden:0, Width:50, Align:"Center", SaveName:"termTimeHour"+idx2, KeyField:0, Format:"", Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:"단위\n잔여\n시간", Type:sType, Hidden:hdn1, Width:50, Align:"Center", SaveName:"termTimeRem"+idx2, KeyField:0, Format:"", Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:"단위\n근무\n일수", Type:sType, Hidden:1, Width:50, Align:"Center", SaveName:"termTimeDay"+idx2 , Edit:0};
					initdata.Cols[v++] = {Header:"단위\n전체\n일수", Type:sType, Hidden:1, Width:50, Align:"Center", SaveName:"termTimeDayAll"+idx2 , Edit:0};
					idx2++;
				}
				
				cnt++;
			}
			
			IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
			sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
			//sheet1.SetDataRowHeight(30);
			sheet1.SetHeaderRowHeight(50); // 헤더행 높이

			
			
			if( authPg == "A" ){
				//sheet1.SetDataBackColor("#fdf0f5");
				sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor());
				sheet1.SetEditable(1);
				
				//sheet1.DoSearch( "${ctx}/WorkScheduleOrgAppDet.do?cmd=getWorkScheduleOrgAppDetList", GetParamAll("searchForm"));
				
			}else{
				sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
				sheet1.SetEditable(0);

			}


			var sXml = sheet1.GetSearchData("${ctx}/WorkScheduleOrgApp.do?cmd=getWorkScheduleOrgAppDetList", GetParamAll("searchForm") );
			sXml = replaceAll(sXml,"BackColor", "#BackColor");
			sheet1.LoadSearchData(sXml );
			$(window).smartresize(sheetResize); sheetInit();
		}

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
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"workSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"workYmd"},
  			{Header:"Hidden",	Type:"Text",   Hidden:0, SaveName:"timeCd"},
		]; IBS_InitSheet(saveSheet, initdata);
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
			
			
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				calcWorkTime(i); //근무시간 계산	
			}
			

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		 try{

			 if( Row < sheet1.HeaderRows() ) return;

			 if( sheet1.ColSaveName(Col).substring(0,2) == "td") { //날짜
			
				sheet1.SetCellBackColor(Row, Col, timeColorMap[Value]);
				
				if( timeCdMap[Value] > 0 ) {
					sheet1.SetCellFontColor(Row, Col,"#000") ;  //근무
				}else{ 
					sheet1.SetCellFontColor(Row, Col,"#FF0000") ; //휴일
				}

				 
				calcWorkTime(Row); //근무시간 계산
			 }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	
	
	//--------------------------------------------------------------------------------
	//주 근무시간, 단위 근무시간 계산
	//--------------------------------------------------------------------------------
	function calcWorkTime(Row){

		try {
			var weekTimeHour = 0, weekDayCnt = 0, weekDayAllCnt = 0;
			var termTimeHour = 0, termDayCnt = 0, termDayAllCnt = 0;
			
			var idx1 = 1, idx2 = 1;
			//한도 시간
			var iWeekWorkTotal = null, iUnitWorkTotal = null, iAvgDayWkLmt = null;
			if( $("#workGrpCd").val() != 'A1') { 
				if( workLmtObj.DATA.weekWorkTotal != null ) iWeekWorkTotal = parseFloat(workLmtObj.DATA.weekWorkTotal);
				if( workLmtObj.DATA.unitWorkTotal != null ) iUnitWorkTotal = parseFloat(workLmtObj.DATA.unitWorkTotal);
				if( workLmtObj.DATA.avgDayWkLmt   != null ) iAvgDayWkLmt   = parseFloat(workLmtObj.DATA.avgDayWkLmt);
			}
			
			for(i = 0 ; i<titleList.DATA.length; i++) {
				var saveName = titleList.DATA[i].saveName;
				var dayTimeHour = Number( timeCdMap[sheet1.GetCellValue(Row, saveName)] ); //일자별 근무시간
				
				weekTimeHour += dayTimeHour;
				termTimeHour += dayTimeHour;
				
				if( sheet1.GetCellValue(Row, saveName) != ""){
					if( dayTimeHour > 0 ){ //휴일제외 근무일수( 휴일이면 0시간임 )
						weekDayCnt++; termDayCnt++;
					}
					weekDayAllCnt++; termDayAllCnt++;
				}
				
				//주단위 근무시간 합산 
				if( titleList.DATA[i].weekYn == "Y" ){
					
					//console.log(cnt+"==> idx1:"+idx1+"==> weekTimeHour:"+weekTimeHour);
					sheet1.SetCellValue(Row, "weekTimeHour"+idx1, weekTimeHour, 0);  // 주 근무시간
					
					//근무일수
					sheet1.SetCellValue(Row, "weekTimeDay"+idx1,     weekDayCnt,    0);  //주 근무일수
					sheet1.SetCellValue(Row, "weekTimeDayAll"+idx1,  weekDayAllCnt, 0);  //주 전체일수
					
					//잔여시간
					if( workLmtObj.DATA.gubun == 'W' && iWeekWorkTotal != null ){ //주단위
						sheet1.SetCellValue(Row, "weekTimeRem"+idx1, (iWeekWorkTotal - weekTimeHour), 0);
					}else if( workLmtObj.DATA.gubun == 'M' && iAvgDayWkLmt != null ){ //월단위
						sheet1.SetCellValue(Row, "weekTimeRem"+idx1, ((iAvgDayWkLmt*weekDayCnt) - weekTimeHour), 0);
					}
					
					weekTimeHour = 0; weekDayCnt = 0; weekDayAllCnt = 0; 
					idx1++;
				}
				//단위기간 근무시간 합산 
				if( titleList.DATA[i].termYn == "Y" && $("#intervalCd").val() != "7" ){ //주단위 일대만 단위기간 표시
					//console.log(cnt+"==> idx2:"+idx2+"==> termTimeHour:"+termTimeHour);
					sheet1.SetCellValue(Row, "termTimeHour"+idx2, termTimeHour, 0);  //단위기간 근무시간
					//근무일수
					sheet1.SetCellValue(Row, "termTimeDay"+idx2,     termDayCnt,    0); //단위기간 근무일수
					sheet1.SetCellValue(Row, "termTimeDayAll"+idx2,  termDayAllCnt, 0); //단위기간 전체일수
					
					//잔여시간
					if( workLmtObj.DATA.gubun == 'W' && iUnitWorkTotal != null ){ //주단위
						sheet1.SetCellValue(Row, "termTimeRem"+idx2, (iUnitWorkTotal - termTimeHour), 0);
					}else if( workLmtObj.DATA.gubun == 'M' && iAvgDayWkLmt != null ){ //월단위
						sheet1.SetCellValue(Row, "termTimeRem"+idx2, ((iAvgDayWkLmt*termDayCnt) - termTimeHour), 0);
					}
					
					termTimeHour = 0; termDayCnt = 0; termDayAllCnt = 0; 
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
		
		var sabuns = IBS_GetColValue(sheet1, "sabun");
		var data = ajaxCall("${ctx}/WorkScheduleOrgApp.do?cmd=getWorkScheduleOrgAppDetDupCnt", GetParamAll("searchForm")+sabuns,false);
		
		if(data.DATA != null && data.DATA.dupCnt != "null" && data.DATA.dupCnt != "0"){
			alert("해당 기간에 신청 중인 스케줄이 있습니다.\n처리완료 후 신청 해주세요.\n("+data.DATA.msg+")");
			ch =  false; return false;
		}

		if( ch == false )  return false;
		
		
		// --------------------------------------------------------------------------------------------------------
		// 선택근무제는 실근무 전에는 근무시간을 알 수 없으므로 근무시간 체크 하지 않음
		// --------------------------------------------------------------------------------------------------------
		if( $("#workGrpCd").val() == 'A1')  return true;
		
		// --------------------------------------------------------------------------------------------------------
		// 근무한도 조회
		// --------------------------------------------------------------------------------------------------------
		//var lmt = ajaxCall("${ctx}/WorkScheduleOrgAppDet.do?cmd=getWorkScheduleOrgAppDetLimit", GetParamAll("searchForm"),false);
		if( workLmtObj.DATA == null ) return true;
		var lmt = workLmtObj;

		// --------------------------------------------------------------------------------------------------------
		// 일 근무시간 체크
		// --------------------------------------------------------------------------------------------------------
		if( lmt.DATA.sumDayWkLmt ){
			var	iSumDayWkLmt = Number(lmt.DATA.sumDayWkLmt);  //기본한도_일_기본
  			for(var row = sheet1.HeaderRows(); row < sheet1.RowCount()+sheet1.HeaderRows() ; row++) {
  	  			var i = 0;
	  			var tg = "["+ sheet1.GetCellValue(row, "name") +"] ";
	  	  		while ( i < titleList.DATA.length ) {
	  	  			var saveName = titleList.DATA[i].saveName;
	  	  			
	  	  			if( lmt.DATA.sumDayWkLmt && Number( timeCdMap[sheet1.GetCellValue(row, saveName)] ) > iSumDayWkLmt ){
	  	  				alert(tg+sheet1.GetCellValue(0, saveName).split("\n").join("") + "의 기본근무는 " + iSumDayWkLmt + "시간을 넘길 수 없습니다.\n(신청시간 : "+timeCdMap[sheet1.GetCellValue(row, saveName)] +"시간)");
	  	  				i = 999; ch =  false;
	  	  			}
	  				i++;
	  	  		}
  			}
		}

		if( ch == false )  return false;

		//console.log("sumWeekWkLmt:"+lmt.DATA.sumWeekWkLmt);
		// --------------------------------------------------------------------------------------------------------
		// 주 근무시간 체크 
		// --------------------------------------------------------------------------------------------------------
		if( lmt.DATA.sumWeekWkLmt ){
			var	iSumWeekWkLmt = Number(lmt.DATA.sumWeekWkLmt);  //기본한도_주_기본
  			for(var row = sheet1.HeaderRows(); row < sheet1.RowCount()+sheet1.HeaderRows() ; row++) {
  		  		var i = 1;
  				var tg = "["+ sheet1.GetCellValue(row, "name") +"] ";
		  		while ( sheet1.GetCellValue(row, "weekTimeHour"+i)  != "-1") {
		  			//console.log(lmt.DATA.sumWeekWkLmt +":"+sheet1.GetCellValue(row, "weekTimeHour"+i));
		  			if( lmt.DATA.sumWeekWkLmt && Number(sheet1.GetCellValue(row, "weekTimeHour"+i)) > iSumWeekWkLmt ){
						alert(tg+"주 기본근무시간은 "+iSumWeekWkLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+sheet1.GetCellValue(row, "weekTimeHour"+i)+"시간)");
						sheet1.SelectCell(row, "weekTimeHour"+i);  
						ch =  false; return false;
					}
	
		  			
		  		  	i++;
		  		}
  			}
		}

		if( ch == false )  return false;
		
  		// --------------------------------------------------------------------------------------------------------
		// 단위기간 일 평균한도 체크
		// --------------------------------------------------------------------------------------------------------
		if( lmt.DATA.avgDayWkLmt || lmt.DATA.avgWeekWkLmt ){
			var	iAvgDayWkLmt = Number(lmt.DATA.avgDayWkLmt);  //평균한도_일_기본
			
  			for(var row = sheet1.HeaderRows(); row < sheet1.RowCount()+sheet1.HeaderRows() ; row++) {
  		  		var i = 1, j = 1;  
  				var tg = "["+ sheet1.GetCellValue(row, "name") +"] ";
  				
		  		while ( sheet1.GetCellValue(row, "termTimeDay"+i)  != "-1") {
		  			var iCnt = Number(sheet1.GetCellValue(row, "termTimeDay"+i)) ; //단위기간 근무일수
		  			var iSumDayWtLmt =  iAvgDayWkLmt * iCnt;  //기본근무 기준시간 : 휴일제외 근무일수로 구함
		  				  			
					if( lmt.DATA.avgDayWkLmt && Number(sheet1.GetCellValue(row, "termTimeHour"+i)) > iSumDayWtLmt ){
						alert(tg+"단위기간 기본근무시간은 "+iSumDayWtLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+sheet1.GetCellValue(row, "termTimeHour"+i)+"시간)");
						ch =  false; return false;
					}
	
					//주 평균한도 체크 ( 단위기간이 주단위 일 때만 체크  )
					if( $("#termGubun").val() == "W" ){
						if( lmt.DATA.avgWeekWkLmt ) {
							var	iAvgWeekWkLmt = Number(lmt.DATA.avgWeekWkLmt);  //평균한도_주_기본
							//console.log("iAvgWeekWkLmt:"+iAvgWeekWkLmt + ", iAvgWeekOtLmt:"+iAvgWeekOtLmt);
				  			
							var weekCnt = 0;
							var iSumWtTime = 0;
					  		while ( sheet1.GetCellValue(row, "weekTimeHour"+j)  != "-1" && sheet1.SaveNameCol("weekTimeHour"+j) < sheet1.SaveNameCol("termTimeDay"+i) ) {
					  			if( sheet1.GetCellValue(row, "weekTimeDayAll"+j) == "7"){ // 일주일 전체 있을 때만( 중도입사자, 부서이동자는 전부 있지 않음 ) 
					  				weekCnt++;
					  				iSumWtTime = iSumWtTime + Number(sheet1.GetCellValue(row, "weekTimeHour"+j)); //주 기본근무시간 
					  			}
					  			
					  			j++;
					  		}
					  		
					  		//console.log("weekCnt : "+weekCnt+ ", iSumWtTime:"+iSumWtTime + ", iSumOtTime:"+iSumOtTime);
					  		
							if( weekCnt > 0 ){
								// 주 평균 
					  			var iAvgWt =  iSumWtTime / weekCnt;  
						  		
								if( lmt.DATA.avgWeekWkLmt && iAvgWt > iAvgWeekWkLmt ){
									alert(tg+"단위기간 주 평균 기본근무시간은 "+iAvgWeekWkLmt+"시간을 넘길 수 없습니다.\n(신청시간 : "+iSumWtTime+"시간 / "+weekCnt+"주)");
									ch =  false; return false;
								}
							}
				  			
				  		}
						
					}
					
		  		  	i++;
		  		}
  			}
		}
  		// --------------------------------------------------------------------------------------------------------
	  		
		return ch;
	}

	//
	function makeSaveSheet(){
		saveSheet.RemoveAll();
		saveSheet.RenderSheet(0);
		for(var row = sheet1.HeaderRows(); row < sheet1.RowCount()+sheet1.HeaderRows() ; row++) {
			for( var col=2; col <= sheet1.LastCol() ; col ++){
				var saveName = sheet1.ColSaveName(col);
				if( saveName.substring(0,2) == "td" && saveName.length == 10 ){ //근무코드
		 			var nrow = saveSheet.DataInsert();
		 			var workYmd = sheet1.ColSaveName(col).substring(2);
		 			saveSheet.SetCellValue(nrow, "workYmd", workYmd);
		 			saveSheet.SetCellValue(nrow, "workSabun", sheet1.GetCellValue(row, "sabun") );
		 			saveSheet.SetCellValue(nrow, "timeCd", sheet1.GetCellValue(row, col) );
				}
			}
		}
		saveSheet.RenderSheet(1);
		
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

			var sabuns = IBS_GetColValue(sheet1, "sabun");
	        var saveStr = saveSheet.GetSaveString(0);
			//저장할 내역이 없거나 저장 validation에서 오류가 발생한 경우
			if (saveStr === "" || saveStr === "KeyFieldError") return;
			IBS_SaveName(document.searchForm, saveSheet);
            var rtn = eval("("+sheet1.GetSaveData("${ctx}/WorkScheduleOrgApp.do?cmd=saveWorkScheduleOrgAppDet", GetParamAll("searchForm")+"&"+saveStr+sabuns )+")");

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
			var bodyHeight = $("body").outerHeight() - timeSheet.GetSheetHeight(); 
			
			$("#DIV_timeSheet").css("height", "0px");
			$("#DIV_timeSheet").hide();

			parent.$("#authorFrame").height(bodyHeight);
			
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// 근무시간 Sheet
	//---------------------------------------------------------------------------------------------------------------
	function searchTimeSheet() {

		var param = "ymd="+$("#searchYmd").val().replace(/-/gi,"")
		          + "&timeCd="+$("#viewTimeCd").val();
		
		var headerList = ajaxCall("${ctx}/WorkScheduleOrgApp.do?cmd=getPsnlWorkScheduleMgrDayWorkHeaderList", param, false);
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

			
			timeSheet.DoSearch( "${ctx}/WorkScheduleOrgApp.do?cmd=getPsnlWorkScheduleMgrDayWorkList", param );

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

	/**
		disabled 포함 Form 데이터 리턴
	**/
	function GetParamAll(formId){
		var t = $("#"+formId);
		var disabled = t.find(":disabled").removeAttr("disabled");
		var params = t.serialize();
		disabled.attr("disabled", "disabled");
		return params;
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
	<input type="hidden" id="intervalCd"		name="intervalCd"	 	 value=""/> <!--단위기간 -->
	<input type="hidden" id="termGubun"			name="termGubun"	 	 value=""/> <!--단위구분 M:월단위, W:주단위 -->
	<input type="hidden" id="tempSabun"			name="tempSabun"	 	 value=""/> <!--팀내 대표자 사번-(근무기간 조회 시 사용)-->
	
	<input type="hidden" id="dayGrcodeCd"		name="dayGrcodeCd"	 	 value=""/>
	<input type="hidden" id="searchSYmd" 		name="searchSYmd" 		 value=""/>
	<input type="hidden" id="searchEYmd" 		name="searchEYmd" 		 value=""/>
	<input type="hidden" id="searchOrgAuth" 	name="searchOrgAuth" 	 value=""/>
	
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
			<td colspan="3">
				<input id="searchYmd" name="searchYmd" type="text" class="${dateCss} ${required} w70 spacingN " readonly maxlength="10" />
			</td>
		</tr>
		<tr>
			<th>부서</th>
			<td>
				<select id="searchOrgCd" name="searchOrgCd" class="${selectCss} ${required} spacingN" ${disabled}></select>
			</td>
			<th>근무조</th>
			<td>
				<select id="searchWorkOrgCd" name="searchWorkOrgCd" class="${selectCss} ${required} spacingN" ${disabled}></select>
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
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "330px", "${ssnLocaleCd}"); </script>
	<div class="hide">
		<script type="text/javascript"> createIBSheet("saveSheet", "100%", "0px", "${ssnLocaleCd}"); </script>
	</div>	
	
	<div id="divTimeSheet" style="display:none;">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='103861' mdef='근무시간'/></li>
			<li class="btn">
                 <select id="viewTimeCd" name="viewTimeCd"></select> 
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