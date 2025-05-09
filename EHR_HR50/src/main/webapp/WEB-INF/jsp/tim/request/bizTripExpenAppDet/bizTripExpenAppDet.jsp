<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>국내출장보고서 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var searchApplCd     = "${searchApplCd}";
var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var bizDays          = "${bizDays}";
var applStatusCd	 = "";
var pGubun           = "";
var gPRow = "";
var codeLists;

var hdn = 1, kfd = 0;

	$(function() {
		
		parent.iframeOnLoad();

		//----------------------------------------------------------------
		$("#searchApplCd").val(searchApplCd);
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplName").val(parent.$("#searchApplName").val());
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		//----------------------------------------------------------------
		
		if(applStatusCd == "11") {
			hdn = 0, kfd = 1; 
		}

		//공통코드 한번에 조회
		var grpCds = "T85200,S10030,T00862,T85101,H20010";
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, " ");

		//----------------------------------------------------------------

		
		init_sheet1();
		init_sheet2();
		init_sheet3();
		init_saveSheet();
		
		$(window).smartresize(sheetResize); sheetInit();
		//----------------------------------------------------------------
		
		// 신청, 임시저장
		if(authPg == "A") {

			$("#bizSdate").datepicker2({onReturn: function(date) {$("#bizEdate").val("");dateCheck(this);}});
			$("#bizEdate").datepicker2({enddate:"bizSdate", onReturn: function(date) {dateCheck(this);}});
			$("#bizSdate, #bizEdate").bind("blur", function() { dateCheck(this); });

			sheet1.SetEditable(1);
			sheet2.SetEditable(1);
			sheet3.SetEditable(1);
			saveSheet.SetEditable(0);
			sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
			sheet2.SetDataAlternateBackColor(sheet2.GetDataBackColor()); //홀짝 배경색 같게
			sheet3.SetDataAlternateBackColor(sheet3.GetDataBackColor()); //홀짝 배경색 같게
			
		} else if (authPg == "R") {

			sheet1.SetEditable(0); sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
			sheet2.SetEditable(0); sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
			sheet3.SetEditable(0); sheet3.SetEditableColorDiff(0); //편집불가 배경색 적용안함
			saveSheet.SetEditable(0); saveSheet.SetEditableColorDiff(0); //편집불가 배경색 적용안함
			
		}

		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		sheet2.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		sheet3.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음

		doAction("Search");
	});
	
	// 동행인 
	function init_sheet1(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:hdn,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
  			{Header:"<sht:txt mid='sabun' mdef='사번'/>", 			Type:"Text",  		Hidden:0, Width:80, Align:"Center", SaveName:"empSabun",    KeyField:0, Format:"",   Edit:0 },
  			{Header:"<sht:txt mid='name' mdef='성명'/>", 			Type:"Popup",  		Hidden:0, Width:80, Align:"Center", SaveName:"empName",     KeyField:kfd, Format:"",   InsertEdit:1, UpdateEdit:0 },
  			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>", 		Type:"Text",  		Hidden:0, Width:150, Align:"Left",   SaveName:"empOrgNm",  	 KeyField:0,   Format:"",   Edit:0 },
  			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>", 	Type:"Text",  		Hidden:Number("${jwHdn}"), Width:80, Align:"Center", SaveName:"empJikweeNm", KeyField:0,   Format:"",   Edit:0 },
  			{Header:"<sht:txt mid='jikchakNm_V5476' mdef='직책'/>", 	Type:"Text",  		Hidden:0, Width:80, Align:"Center", SaveName:"empJikchakNm", KeyField:0,   Format:"",   Edit:0 },
  			{Header:"<sht:txt mid='jikgubNm6' mdef='직급'/>", 		Type:"Text",  		Hidden:Number("${jgHdn}"), Width:80, Align:"Center", SaveName:"empJikgubNm", KeyField:0,   Format:"",   Edit:0 },
  			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>", 		Type:"Text",  		Hidden:0, Width:150, Align:"Left",   SaveName:"empNote",   KeyField:0, Format:"",   Edit:1 },

  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);

		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "empName",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "empSabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "empName", rv["name"]);
						sheet1.SetCellValue(gPRow, "empOrgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "empJikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "empJikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "empJikgubNm", rv["jikgubNm"]);
					}
				}
			]
		});
	}
	
	
	// 수행업무  
	function init_sheet2(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:hdn,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
  			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>", 	Type:"Date", 		Hidden:0, Width:90, Align:"Center", SaveName:"workSdate",     KeyField:kfd, Format:"Ymd", Edit:1 },
  			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>", 	Type:"Date",  		Hidden:0, Width:90, Align:"Center", SaveName:"workEdate",     KeyField:kfd, Format:"Ymd", Edit:1 },
  			{Header:"<sht:txt mid='departure' mdef='출발지'/>", 	Type:"Text", 		Hidden:0, Width:100, Align:"Center", SaveName:"workSPlace",     KeyField:kfd, Format:"",    Edit:1 },
  			{Header:"<sht:txt mid='destination' mdef='도착지'/>", 	Type:"Text",  		Hidden:0, Width:100, Align:"Center", SaveName:"workEPlace",     KeyField:kfd, Format:"",    Edit:1 },
  			{Header:"<sht:txt mid='majorPlace' mdef='주요방문처'/>", 	Type:"Text",  		Hidden:0, Width:100, Align:"Left",   SaveName:"workCompany",  KeyField:kfd, Format:"",    Edit:1 },
  			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>", 		Type:"Text",  		Hidden:0, Width:100, Align:"Left",   SaveName:"workNote",  KeyField:0,   Format:"",    Edit:1 },
  			
  		];
  		IBS_InitSheet(sheet2, initdata);sheet2.SetVisible(true);

	}
	
	// 출장비내역  
	function init_sheet3(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:hdn,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

  			{Header:"정산자 사번", 													Type:"Text",  		Hidden:1, Width:80,  Align:"Center", SaveName:"paySabun", KeyField:kfd, Format:"",   Edit:1 },
  			{Header:"<sht:txt mid='payer' mdef='정산자'/>", 							Type:"Text",  		Hidden:0, Width:80,  Align:"Center", SaveName:"payName",  KeyField:kfd, Format:"",   Edit:1 },
  			{Header:"<sht:txt mid='useYnV8' mdef='사용구분'/>", 						Type:"Combo",  		Hidden:0, Width:100, Align:"Center", SaveName:"payGubunCd",   KeyField:kfd, Format:"",   Edit:1 },
			{Header:"<sht:txt mid='existsFuelCard_lb' mdef='유류카드\n소지여부'/>",	Type:"CheckBox",    Hidden:0, Width:55,	 Align:"Center", SaveName:"oilCardYn",KeyField:0,	Format:"",	 Edit:0, TrueValue:"Y",	FalseValue:"N" },
  			{Header:"<sht:txt mid='useYnV8' mdef='사용구분'/>", 						Type:"Combo",  		Hidden:0, Width:80,  Align:"Center", SaveName:"oilTypeCd",KeyField:0,   Format:"",   Edit:0 },
  			{Header:"<sht:txt mid='mileageV2' mdef='주행거리'/>", 					Type:"Int",  		Hidden:0, Width:80,  Align:"Right",  SaveName:"distDriv", KeyField:0,   Format:"##\\ km",   Edit:0 },
  			{Header:"<sht:txt mid='issuePrice' mdef='단가'/>", 						Type:"Int",  		Hidden:0, Width:80,  Align:"Center", SaveName:"unitPrice",KeyField:0,   Format:"##,###\\ 원",   Edit:0 },
  			{Header:"<sht:txt mid='cost_V1' mdef='사용금액'/>(￦)", 					Type:"AutoSum",  	Hidden:0, Width:80,  Align:"Right",  SaveName:"payMon",   KeyField:kfd, Format:"",   Edit:1 },
			{Header:"<sht:txt mid='cost_V1' mdef='사용내역'/>", 						Type:"Text",  		Hidden:0, Width:150, Align:"Left",   SaveName:"useMemo",  KeyField:kfd, Format:"",   Edit:1 },
  			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>", 						Type:"Text",  		Hidden:1, Width:150, Align:"Left",   SaveName:"payNote",  KeyField:0,   Format:"",   Edit:1 },
  			
  			{Header:"최소주행거리",	Type:"Int",  		Hidden:1, Width:80,  Align:"Center",   SaveName:"lmtDistDriv",  KeyField:0,   Format:"",   Edit:1 },
  		];

  		IBS_InitSheet(sheet3, initdata);sheet3.SetVisible(true);

  		sheet3.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
  		sheet3.SetDataLinkMouse("detail", 1);

		//여비구분
		sheet3.SetColProperty("payGubunCd", {ComboText:"|"+codeLists["T85101"][0], ComboCode:"|"+codeLists["T85101"][1]} );
		sheet3.SetColProperty("oilTypeCd",  {ComboText:"|"+codeLists["T85200"][0], ComboCode:"|"+codeLists["T85200"][1]} ); //유류구분

		$(sheet3).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "payName",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet3.SetCellValue(gPRow, "paySabun", rv["sabun"]);
						sheet3.SetCellValue(gPRow, "payName", rv["name"]);
					}
				}
			]
		});
	}

	// 동행인, 출장기간, 출장경비내역 total sheet
	function init_saveSheet(){
		var initdata = {};
		initdata.Cols = [
			{Header:"상태",		Type:"Status",	SaveName:"sStatus"},
			//출장동행인
   			{Header:"사번", 				SaveName:"empSabun"},
  			{Header:"동행사유", 			SaveName:"empNote"},

  			//출장일정상세
  			{Header:"시작일자", 			SaveName:"workSdate"},
  			{Header:"종료일자", 			SaveName:"workEdate"},
  			{Header:"출발지", 			SaveName:"workSPlace"},
  			{Header:"도착지", 			SaveName:"workEPlace"},
  			{Header:"주요방문처", 			SaveName:"workCompany"},
  			{Header:"비고", 				SaveName:"workNote"},

  			//출장경비내역
  			{Header:"정산자 사번", 			SaveName:"paySabun"},
  			{Header:"여비구분", 			SaveName:"payGubunCd"},
			{Header:"유류카드\n소지여부", 	SaveName:"oilCardYn"},
  			{Header:"유류구분", 			SaveName:"oilTypeCd"},
  			{Header:"주행거리", 			SaveName:"distDriv"},
  			{Header:"단가", 				SaveName:"unitPrice"},
  			{Header:"원화금액", 			SaveName:"payMon"},
			{Header:"사용내역", 			SaveName:"useMemo"},
  			{Header:"비고", 				SaveName:"payNote"},

  		];
  		IBS_InitSheet(saveSheet, initdata);saveSheet.SetVisible(false);

	}
	
	//--------------------------------------------------------------------------------
	//  총일수 계산
	//--------------------------------------------------------------------------------
	function dateCheck(obj){
		try{
			var bizSdate = $("#bizSdate").val().replace(/-/gi, "");
			var bizEdate = $("#bizEdate").val().replace(/-/gi, "");
			
			if(bizSdate == "" || bizEdate == "") return;

			if( bizSdate > bizEdate  ) {
				alert('<msg:txt mid="110501" mdef="시작일과 종료일을 정확히 입력하세요."/>');
				$(obj).val(""); 
				return;
			}

			var bizDays = getDaysBetween(bizSdate , bizEdate ) ;
			$("#bizDays").val( bizDays ) ;
			$("#span_bizDays").html( (bizDays-1) +"박 "+(bizDays)+"일");
			
		}catch(e){		
		}
		
	}
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/BizTripExpenApp.do?cmd=getBizTripExpenAppDetMap", $("#searchForm").serialize(),false);
			if(data.Message != "" ){
				alert(data.Message); return;
			} 
			if ( data != null && data.DATA != null ){ 
				$("#occCd").val(data.DATA.occCd);

				$("#bizSdate").val(formatDate(data.DATA.bizSdate, "-"));
				$("#bizEdate").val(formatDate(data.DATA.bizEdate, "-"));
				$("#bizDays").val(String(data.DATA.bizDays));
				$("#bizPurpose").val(data.DATA.bizPurpose);
				$("#bizOnReason").val(data.DATA.bizOnReason);
				$("#bizContents").val(data.DATA.bizContents);
				$("#bizNote").val(data.DATA.bizNote);
				$("#exchgRate").val(makeComma(data.DATA.exchgRate));

				var bizDays = Number(String(data.DATA.bizDays));
				$("#span_bizDays").html( (bizDays-1) +"박 "+(bizDays)+"일");
				
			}

			sheet1.DoSearch( "${ctx}/BizTripExpenApp.do?cmd=getBizTripExpenAppDetList1", $("#searchForm").serialize() );
			sheet2.DoSearch( "${ctx}/BizTripExpenApp.do?cmd=getBizTripExpenAppDetList2", $("#searchForm").serialize() );

			var sXml = sheet3.GetSearchData("${ctx}/BizTripExpenApp.do?cmd=getBizTripExpenAppDetList3", $("#searchForm").serialize() );
			sXml = replaceAll(sXml,"oilTypeCdEdit", "oilTypeCd#Edit");
			sXml = replaceAll(sXml,"oilCardYnEdit", "oilCardYn#Edit");
			sXml = replaceAll(sXml,"distDrivEdit", "distDriv#Edit");
			sheet3.LoadSearchData(sXml );
			
			break;
		case "Insert1": // 동행인
			var row = sheet1.DataInsert(-1); 
			break;
			
			
		case "Insert2": // 출장기간 일정별 수행업무
			var row = sheet2.DataInsert(-1); 
			sheet2.SetCellValue( row, "workSdate", $("#bizSdate").val() );
			sheet2.SetCellValue( row, "workEdate", $("#bizEdate").val() );
			break;

		case "Insert3":  // 출장경비내역
			var row = sheet3.DataInsert(-1); 
			//디폴트 본인
        	sheet3.SetCellValue(row, "paySabun", $("#searchApplSabun").val());
        	sheet3.SetCellValue(row, "payName", $("#searchApplName").val());
			//gPRow = row;
			//pGubun = "empPopupSheet3";
			//var os = $( "#bizNote1" ).offset();
			//openLayerPop("emp", os.top+30 );
			break;

		case "Copy3":
			var row = sheet3.DataCopy();
			sheet3.SetCellValue(row , "payMon", "");
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
			
			if( sheet1.RowCount() == 0 ){
				//첫번째는 신청자 정보 강제 입력
				
				var row = sheet1.DataInsert(-1); 
				sheet1.SetCellValue(row, "empSabun", $("#searchApplSabun").val());
				sheet1.SetCellValue(row, "empNote", "본인");
				sheet1.SetRowEditable(row, 0); //수정 불가
				
				//유저 데이터
				var data = ajaxCall("${ctx}/BizTripExpenApp.do?cmd=getBizTripExpenAppDetUserMap","searchSabun="+searchApplSabun+"&searchApplYmd="+searchApplYmd ,false);
				if(data.Message != "" ){
					alert(data.Message); return;
				} 
				if ( data != null && data.DATA != null ){ 
					sheet1.SetCellValue(row, "empSabun",  data.DATA.sabun);
					sheet1.SetCellValue(row, "empName",  data.DATA.name);
					sheet1.SetCellValue(row, "empOrgNm", data.DATA.orgNm);
					sheet1.SetCellValue(row, "empJikweeNm", data.DATA.jikweeNm);
					sheet1.SetCellValue(row, "empJikchakNm", data.DATA.jikchakNm);
					sheet1.SetCellValue(row, "empJikgubNm", data.DATA.jikgubNm);
		  			
				}
				
			}

			sheetResize();
			resizeSheetHeight(sheet1, authPg); ////시트행 갯수에 맞게 시트 높이 설정 
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//삭제클릭 시 삭제
	function sheet1_OnBeforeCheck(Row,Col) {
		try {
			if( sheet1.ColSaveName(Col) == "sDelete" ){
				sheet1.RowDelete(Row, 0);
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	

	//--------------------------------------------------------------------------------
	//  sheet2 Events
	//--------------------------------------------------------------------------------
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
			resizeSheetHeight(sheet2, authPg); //시트행 갯수에 맞게 시트 높이 설정
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//삭제클릭 시 삭제
	function sheet2_OnBeforeCheck(Row,Col) {
		try {
			if( sheet2.ColSaveName(Col) == "sDelete" ){
				sheet2.RowDelete(Row, 0);
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	


	//--------------------------------------------------------------------------------
	//  sheet3 Events
	//--------------------------------------------------------------------------------
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			sheetResize();	
			resizeSheetHeight(sheet3, authPg); //시트행 갯수에 맞게 시트 높이 설정
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//삭제클릭 시 삭제
	function sheet3_OnBeforeCheck(Row,Col) {
		try {
			if( sheet3.ColSaveName(Col) == "sDelete" ){
				sheet3.RowDelete(Row, 0);
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 값 변경시 발생.
	function sheet3_OnChange(Row, Col, Value){
		try{
			//경비항목 변경 시
		    if( sheet3.ColSaveName(Col) == "payGubunCd") {	    		
		    	if( Value == "0" ) { //유류비
		    		sheet3.SetCellEditable(Row, "oilTypeCd", 1);
		    		sheet3.SetCellEditable(Row, "distDriv", 1);
		    		sheet3.SetCellEditable(Row, "oilCardYn", 1);
		    	}else{
		    		sheet3.SetCellEditable(Row, "oilTypeCd", 0);
		    		sheet3.SetCellEditable(Row, "distDriv", 0);
		    		sheet3.SetCellEditable(Row, "oilCardYn", 0);
		    		sheet3.SetCellValue(Row, "oilTypeCd", "" , 0);
		    		sheet3.SetCellValue(Row, "distDriv", "", 0);
		    		sheet3.SetCellValue(Row, "lmtDistDriv", "", 0);
		    		sheet3.SetCellValue(Row, "unitPrice", "", 0);
		    		sheet3.SetCellValue(Row, "oilCardYn", "", 0);
		    		
			    }
		    //유류구분 변경 시	
			}else if( sheet3.ColSaveName(Col) == "oilTypeCd" && Value != "" ) {	
				// 단가 최소주행거리 조회
				var data = ajaxCall( "${ctx}/BizTripExpenApp.do?cmd=getBizTripExpenAppDetOil", $("#searchForm").serialize()+"&oilTypeCd="+Value,false);
				if(data.Message != "" ){
					alert(data.Message); return;
				} 
				if ( data != null && data.DATA != null ){ 
		    		sheet3.SetCellValue(Row, "lmtDistDriv", data.DATA.lmtDistDriv, 0);
		    		sheet3.SetCellValue(Row, "unitPrice", data.DATA.unitPrice, 0);
				}
				
			//주행거리 입력 시 	
			}else if( sheet3.ColSaveName(Col) == "distDriv" ) {
				var lmgDistDirv = sheet3.GetCellValue(Row, "lmtDistDriv") ;
				var unitPrice = sheet3.GetCellValue(Row, "unitPrice") ;
			 	if(  Value != "" && lmgDistDirv != "" && Value < lmgDistDirv) {
			 		alert("최소 주행거리는 "+lmgDistDirv+" Km 입니다.");
			 		sheet3.SetCellValue(Row, "distDriv", "", 0);
			 		return;
			 	}

				if( Value !="" && unitPrice !="" ){
			 		sheet3.SetCellValue(Row, "payMon", Value*unitPrice, 0);
			 		return;
				}
			 	
			 	
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	
	//--------------------------------------------------------------------------------
	//  sheet1,sheet2,sheet3,상세내역 부분을 saveSheet 시트로 이동
	//--------------------------------------------------------------------------------
	function setSaveSheet(){

		saveSheet.RenderSheet(0);
		saveSheet.RemoveAll();

		//sheet1 출장동행인
		var arr1 = ["empSabun","empNote"];
        for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
        	var row = saveSheet.DataInsert(-1);
        	for( var j=0; j<arr1.length; j++){
        		saveSheet.SetCellValue(row, arr1[j], sheet1.GetCellValue(i, arr1[j]), 0);
        	}
        }

        //sheet2 출장일정상세
        var arr2 = ["workSdate","workEdate","workSPlace","workEPlace","workCompany","workNote"];
        for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
        	var row = saveSheet.DataInsert(-1);
        	for( var j=0; j<arr2.length; j++){
        		saveSheet.SetCellValue(row, arr2[j], sheet2.GetCellValue(i, arr2[j]), 0);
        	}
        }

        //sheet3 출장경비내역
        var arr3 = ["paySabun","payGubunCd","oilCardYn","oilTypeCd", "distDriv", "unitPrice", "payMon", "useMemo", "payNote"];
        for(var i = sheet3.HeaderRows(); i < sheet3.RowCount()+sheet3.HeaderRows() ; i++) {
        	var row = saveSheet.DataInsert(-1);
        	for( var j=0; j<arr3.length; j++){
        		saveSheet.SetCellValue(row, arr3[j], sheet3.GetCellValue(i, arr3[j]), 0);
        	}
        }


		saveSheet.RenderSheet(1);
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

			return ch;
		});

        if( ch ){

            if( sheet2.RowCount()  == 0 ){
            	alert("출장기간 일정별 출장지를 입력 해주세요.");
            	return false;
            }
            /*
            if( sheet3.RowCount()  == 0 ){
            	alert("출장경비내역을 입력 해주세요.");
            	return false;
            }*/

            //출장기간 유효성검사
            for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
            	var chkSdate = sheet2.GetCellValue(i, "workSdate");
            	var chkEdate = sheet2.GetCellValue(i, "workEate");
            	
            	if($("#bizSdate").val().replace(/-/g,"") > chkSdate){
                	alert('출장기간의 시작 날짜를 다시 한번 확인해 주시기 바랍니다.');
                	return false;
                }
            	if($("#bizEdate").val().replace(/-/g,"") < chkEdate){
                	alert('출장기간의 종료 날짜를 다시 한번 확인해 주시기 바랍니다.');	
                	return false;
                }
            }
            
            
            
	        for(var i = sheet3.HeaderRows(); i < sheet3.RowCount()+sheet3.HeaderRows() ; i++) {
	        	if( sheet3.GetCellValue(i, "payGubunCd") == "0" ){
	        		if( sheet3.GetCellValue(i, "oilTypeCd") == "" ){
	        			alert("유류구분은 필수 입력 항목입니다.");
	        			sheet3.SelectCell(i, "oilTypeCd");
	        			return false;
	        		}
					if( sheet3.GetCellValue(i, "distDriv") == "" ){
	        			alert("주행거리는 필수 입력 항목입니다.");
	        			sheet3.SelectCell(i, "distDriv");
						return false;
	        		}
	        	}
	        }

			//출장경비 중복 체크 
			if(!dupChk(sheet3,"paySabun|payGubunCd", true, true)){ return false; }


            //출장자
            for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
            	var param = $("#searchForm").serialize()+"&"+$("#dataForm").serialize()+"&sabun="+sheet1.GetCellValue(i, "empSabun"); 

    			//기 신청건 체크 
    			var data = ajaxCall("${ctx}/BizTripExpenApp.do?cmd=getBizTripExpenAppDetDupCnt", param,false);
    			if(data.Message != "" ){
    				alert("기 신청건 체크  시 오류가 발생 했습니다.");
    				return false;
    			}
    			if(data.DATA != null && data.DATA.dupCnt != "null" && data.DATA.dupCnt != "0"){
    				alert("[" + sheet1.GetCellValue(i, "empName") + "] 동일한 일자에 신청내역이 있습니다.");
    				return false;
    			}
            }
			
        }
        
		
		return ch;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		var returnValue = false;
		try {

			if ( authPg == "R" )  {
				return true;
			}
			
	        // 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }
            
            //필수입력 항목 체크
	        var saveStr1 = sheet1.GetSaveString(0);
            if(saveStr1.match("KeyFieldError")) { return false; }
            
	        var saveStr2 = sheet2.GetSaveString(0);
            if(saveStr2.match("KeyFieldError")) { return false; }
            
	        var saveStr3 = sheet3.GetSaveString(0);
            if(saveStr3.match("KeyFieldError")) { return false; }
			

	    	//  상세내역들을 시트로 이동
	        setSaveSheet();
	    	
            IBS_SaveName(document.searchForm, saveSheet);
            var params = $("#searchForm").serialize()+"&"+$("#dataForm").serialize()+"&"+saveSheet.GetSaveString(0);

	      	//저장
			var data = ajaxCall("${ctx}/BizTripExpenApp.do?cmd=saveBizTripExpenAppDet",params,false);

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
/*
 * 	아래코드 사용안함(참고소스로 남겨둠). common.js 의 resizeSheetHeight() 사용
	//시트행 갯수에 맞게 시트 높이 설정
	function setSheetHeight(sheet){
		if(authPg == "A") return;
		bodyHeight = parseInt(bodyHeight + 0.5);
		var ih = 50 + ( ( sheet.RowCount() ) * sheet.GetRowHeight(1) );
		if( ih < 100 ) ih = 100;
		if( sheet.FindSumRow() > -1 ) ih = ih + sheet.GetRowHeight(sheet.FindSumRow()); //합계행 여부
		sheet.SetSheetHeight(ih); 
		var hei = bodyHeight + $("#DIV_sheet1").height() + $("#DIV_sheet2").height() + $("#DIV_sheet3").height();

		parent.$("#authorFrame").height(hei);
	}

	var bodyHeight = 0;
	$( document ).ready(function() {
		$(".dh").each( function() {
			bodyHeight = bodyHeight + $(this).outerHeight() + 0.5; // 소수점 아래 높이가 무시되어 미세하게 오차가 발생해서 0.5를 더해줌.
		});
	});
*/	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplCd"		name="searchApplCd"	 	 value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchBfApplSeq"	name="searchBfApplSeq"	 value=""/>
	</form>
	
	<div class="dh sheet_title">
		<ul>
			<li id="empTitle" class="txt">출장자(동행인)</li> 
			<li class="btn"> 
				<a href="javascript:doAction('Insert1');" class="btn outline_gray authA">입력</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "130px", "${ssnLocaleCd}"); </script>
	<div class="dh h10"></div>
	
	<form name="dataForm" id="dataForm" method="post">
	<input type="hidden" id="bizCd"				name="bizCd"	 		 value="10"/>
	<input type="hidden" id="bizDays"			name="bizDays"	 		 value=""/>
	<input type="hidden" id="exchgRate"			name="exchgRate"	 	 value=""/>
	<table class="dh table">
		<colgroup>
			<col width="100px" />
			<col width="140px" />
			<col width="100px" />
			<col width="" />
		</colgroup>
	
		<tr>
			<th>출장기간</th>
			<td colspan="3">
				<input type="text" id="bizSdate" name="bizSdate" class="${dateCss} ${required} w70"  readonly maxlength="10"/>&nbsp;~&nbsp;
				<input type="text" id="bizEdate" name="bizEdate" class="${dateCss} ${required} w70" readonly maxlength="10"/>
				&nbsp;&nbsp;&nbsp;&nbsp;<span id="span_bizDays"></span>
			</td>
		</tr>
		<tr>
			<th>출장제목</th>
			<td colspan="3">
				<input type="text" id="bizPurpose" name="bizPurpose" class="${textCss} ${required} w100p" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>출장내용<br>(출장목적)</th>
			<td colspan="3"><textarea id="bizContents" name="bizContents" rows="3" class="${textCss} w100p ${required}" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		<tr>
			<th>화상회의<br>미실시사유</th>
			<td colspan="3">
				<input type="text" id="bizOnReason" name="bizOnReason" class="${textCss} ${required} w100p" ${readonly}/>
			</td>
		</tr>
	</table>
	</form>
	<div class="dh h10"></div>
	<div class="dh sheet_title">
		<ul>
			<li id="txt" class="txt">출장기간 일정별 출장지</li> 
			<li class="btn"> 
				<a href="javascript:doAction('Insert2');" class="btn outline_gray authA">입력</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "200px", "${ssnLocaleCd}"); </script>
	<div class="dh h10"></div>	
	<div class="dh sheet_title">
		<ul>
			<li id="payTitle" class="txt">출장경비내역</li> 
			<li class="btn"> 
				<a href="javascript:doAction('Insert3');" class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction('Copy3');" class="btn outline_gray authA">복사</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet3", "100%", "300px", "${ssnLocaleCd}"); </script>
	<div class="hide">
	<script type="text/javascript"> createIBSheet("saveSheet", "100%", "100px"); </script>
	</div>	
		
</div>
</body>
</html>