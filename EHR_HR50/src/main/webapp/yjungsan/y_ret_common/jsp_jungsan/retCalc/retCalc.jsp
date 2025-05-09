<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직금계산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
	//급여계산중이거나, 급여계산취소 중이면 true
	var waitFlag    = false;
	var msg = "";
	

	
	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				searchEmp();
			}
		});
	});
	
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"마감여부",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_close_yn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"총인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"t_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			//{Header:"대상인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"all_811_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"작업대상인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"p_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"작업완료인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
			//{Header:"마감인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_y_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			//{Header:"미마감인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_n_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
	
		
		var initdata3 = {};
		initdata3.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		initdata3.Cols = [
   			{Header:"No",				Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"마감여부",	Type:"CheckBox",		Hidden:0,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"close_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:500 , TrueValue:"Y", FalseValue:"N" },
			{Header:"대상\n상태",	Type:"Combo",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"pay_people_status",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"org_nm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"입사일",			Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"emp_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:500 },
			{Header:"그룹입사일",	Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"gemp_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:500 },
			{Header:"중간정산일",	Type:"Date",Hidden:1,Width:70,Align:"Center",ColMerge:0,	SaveName:"adj_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:500 },
			{Header:"마지막\n중간정산일",	Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"rmid_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:500 },
			{Header:"퇴사일",			Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ret_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:500 },
			{Header:"DB계좌\n전액이체",	Type:"CheckBox",	Hidden:0,Width:65,Align:"Center",	ColMerge:0,	SaveName:"db_full_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, TrueValue:"Y", FalseValue:"N" },
			{Header:"DB가입일",		Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"db_gaib_ymd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"퇴직사유",		Type:"Combo",Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ret_reason",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"임원\n여부",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"imwon_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"2011.12.31\n퇴직금(임원)",	Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"ret_mon_20111231",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"거주지국\n코드",Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"residence_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"특이사항",	Type:"Text",   	Hidden:0,	Width:150,	Align:"Left",  ColMerge:0, SaveName:"memo",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"퇴직금신고\n제외여부",		Type:"CheckBox",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"etc_010",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"1", FalseValue:"0" }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("<%=editable%>");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		
		var paymentInfo = ajaxCall("<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=selectRetCalcPayActionInfo", "", false);
		var paramSearchYm = "";
	    if (paymentInfo.Data.pay_ym != null && typeof paymentInfo.Data.pay_ym != "undefined") {
	    	paramSearchYm = paymentInfo.Data.pay_ym;
        }
		
		var payPeopleStatusList	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+paramSearchYm,"C00125"), "");
		sheet3.SetColProperty("pay_people_status",    {ComboText:"|"+payPeopleStatusList[0], ComboCode:"|"+payPeopleStatusList[1]} );

		var residenceCdList	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+paramSearchYm,"H20295"), "");
		sheet3.SetColProperty("residence_cd",    {ComboText:"|"+residenceCdList[0], ComboCode:"|"+residenceCdList[1]} );
		
		var retReasonList	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+paramSearchYm,"C00440"), "");
		sheet3.SetColProperty("ret_reason",    {ComboText:"|"+retReasonList[0], ComboCode:"|"+retReasonList[1]} );		
		sheet3.SetColProperty("imwon_yn",    {ComboText:"|Y|N", ComboCode:"|Y|N"} );
		
		$(window).smartresize(sheetResize);
		sheetInit();
		getRetCalcPayActionInfo() ;//payActionCd,Nm 가져옴
		
		
		$( "#reCalcBtn" ).hide();
	});
	
	function doAction1(sAction) {
		switch (sAction) {
	    case "Search":      
	    	sheet1.DoSearch( "<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=selectRetCalcSheet1List", $("#sheetForm").serialize() );
	    	break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
	    case "Search":      
	    	sheet2.DoSearch( "<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=selectRetCalcSheet2List", $("#sheetForm").serialize() );
	    	break;
		}
	}
		
	function doAction3(sAction) {
		switch (sAction) {
	    case "Search":      
	    	sheet3.DoSearch( "<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=selectRetCalcSheet3List", $("#sheetForm").serialize() );
	    	break;
	    /*	
	    case "ReCalc":      
	    	var reCalcFlag = false;
			for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
				if (sheet3.GetCellValue(i, "select") == "1") {
					reCalcFlag = true;
				}
			}

			if(!reCalcFlag) {
				alert("재계산 대상자를 선택해 주시기 바랍니다.");
				return;
			}
	    	
			if(confirm($("#searchPayActionNm").val()+" 재계산을 시작하시겠습니까?")){
				sheet3.DoSave("<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=prcCpnSepRetrayPayMain",$("#sheetForm").serialize(),2,0);
				sheetSearch();
			}
	    	break;
	    */	
	    case "Save":    
			for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
				if (sheet3.GetCellValue(i, "close_yn") == "Y") {
					if(sheet3.GetCellValue(i, "pay_people_status") != "J") {
						alert("작업완료된 인원에 대해서만 마감 할 수 있습니다.");
						return;
					}
				}
			}
	    	sheet3.DoSave( "<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=saveRetCalcSheet3List",$("#sheetForm").serialize());
	    	break;	    	
        case "Down2Excel":
			sheet3.Down2Excel();
			break; 	
		}
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			
			/*
			if(Code == 1) {
				setCloseImg();
			}
			*/
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				setPeopleStatusCnt();
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	//조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			/*
			for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
				if (sheet3.GetCellValue(i, "pay_people_status") == "0") {
					sheet3.SetCellEditable(i, "select", false);
				}
			}
			*/
			
	    	/*퇴직금 재계산 체크여부에 따라 버튼 표시*/
	    	/*
	    	var reCalcFlag = false;
			for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
				if (sheet3.GetCellValue(i, "select") == "1") {
					reCalcFlag = true;
				}
			}

			if(reCalcFlag) {
				$( "#reCalcBtn" ).show();
			} else {
				$( "#reCalcBtn" ).hide();
			}
			*/
	    	var closeFlag = true;
			for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
				if (sheet3.GetCellValue(i, "close_yn") == "N") {
					closeFlag = false;
				} else {
					sheet3.SetRowEditable(i, false);
					sheet3.SetCellEditable(i, "close_yn", true);
				}
				
				if(sheet3.GetCellValue(i, "pay_people_status") != "J") {
					sheet3.SetCellEditable(i, "close_yn", false);
				}
			}
			if(closeFlag) {
				$(':checkbox[name=calcuFinishedImg]').attr('checked', true);
			}else {
				$(':checkbox[name=calcuFinishedImg]').attr('checked', false);
			}
			
			alertMessage(Code, Msg, StCode, StMsg);
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//클릭시 발생
	function sheet3_OnClick(Row, Col, Value) {
		try{
			
			/*퇴직금 재계산 체크여부에 따라 버튼 표시*/
			/*
	    	var reCalcFlag = false;
			for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
				if (sheet3.GetCellValue(i, "select") == "1") {
					reCalcFlag = true;
				}
			}

			if(reCalcFlag) {
				$( "#reCalcBtn" ).show();
			} else {
				$( "#reCalcBtn" ).hide();
			}
			*/
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//값이 바뀔때 발생
	function sheet3_OnChange(Row, Col, Value, OldValue) {
		try{
			//재계산대상여부 체크시
			/*
			if( sheet3.ColSaveName(Col) == "select" && sheet3.GetCellValue(Row, "select")  == "1") {
				if(sheet3.GetCellValue(Row,"pay_people_status")=="J"){
					sheet3.SetCellValue(Row,"pay_people_status","M");
				}else{
					sheet3.SetCellValue(Row,"pay_people_status","PM");
				}
			} else if( sheet3.ColSaveName(Col) == "select" && sheet3.GetCellValue(Row, "select")  == "0") {
				if(sheet3.GetCellValue(Row,"pay_people_status")=="M"){
					sheet3.SetCellValue(Row,"pay_people_status","J");
				}else{
					sheet3.SetCellValue(Row,"pay_people_status","P");
				}
			}
			*/
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction3("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	//쉬트 조회
	function sheetSearch() {
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	}
	
	//최근급여일자 조회
	function getRetCalcPayActionInfo() {
		var paymentInfo = ajaxCall("<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=selectRetCalcPayActionInfo", "", false);

		$("#searchPayActionCd").val(paymentInfo.Data.pay_action_cd);
		$("#searchPayActionNm").val(paymentInfo.Data.pay_action_nm);
		$("#payYM").val(paymentInfo.Data.pay_ym) ;
		$("#ordYmd").val(paymentInfo.Data.ord_ymd) ;
		$("#searchPayCd").val(paymentInfo.Data.pay_cd);
		
		sheetSearch() ;
	}
	
	//마감 체크
	function checkClose(){
		
		if($("#calcuFinishedImg").is(":checked")) {
			alert("이미 마감되었습니다.");
			return true;
		} else {
			return false;
		}
	}

	//연말정산항목이 존재 확인
	function checkPayActionCd(){
		if($("#searchPayActionCd").val() == ""){
			alert("작업일자가 존재하지 않습니다.");
			return false;
		} else {
			return true;
		}
	}
	
	//대상 정보
	function setPeopleStatusCnt() {
		$("#peopleTotalCnt").html(sheet2.GetCellText(1, "t_cnt")) ;
		$("#peoplePCnt").html(sheet2.GetCellText(1, "p_cnt")) ;
		$("#peopleJCnt").html(sheet2.GetCellText(1, "j_cnt")) ;
		//$("#finalCloseYCnt").html(sheet2.GetCellText(1, "final_y_cnt")) ;
		//$("#finalCloseNCnt").html(sheet2.GetCellText(1, "final_n_cnt")) ;
	}
	
	var pGubun = "";
	
	//급여일자 검색 팝입
	function payActionSearchPopup() {
		if(waitFlag) return;

		if(!isPopup()) {return;}
		pGubun = "retCalcPayDayViewPopup";
		
		var args = new Array();
		var result = openPopup("<%=jspPath%>/retCalc/retCalcPayDayViewPopup.jsp?authPg=<%=authPg%>",args,"900","580");
		/*
		if (result) {
			$("#searchPayActionCd").val(result["payActionCd"]);
			$("#searchPayActionNm").val(result["payActionNm"]);
			$("#payYM").val(result["payYm"].substring(0,4) + "-" + result["payYm"].substring(4,6)) ;
			$("#ordYmd").val(result["ordSymd"].substring(0,4) +"-"+result["ordSymd"].substring(4,6)+"-"+result["ordSymd"].substring(6,8) + " ~ " + result["ordEymd"].substring(0,4) +"-"+result["ordEymd"].substring(4,6)+"-"+result["ordEymd"].substring(6,8)) ;
			sheetSearch() ;
		}
		*/
	}
	
	function getReturnValue(returnValue) {

		var result = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "retCalcPayDayViewPopup" ){
			$("#searchPayActionCd").val(result["payActionCd"]);
			$("#searchPayActionNm").val(result["payActionNm"]);
			$("#payYM").val(result["payYm"].substring(0,4) + "-" + result["payYm"].substring(4,6)) ;
			$("#ordYmd").val(result["ordSymd"].substring(0,4) +"-"+result["ordSymd"].substring(4,6)+"-"+result["ordSymd"].substring(6,8) + " ~ " + result["ordEymd"].substring(0,4) +"-"+result["ordEymd"].substring(4,6)+"-"+result["ordEymd"].substring(6,8)) ;
			sheetSearch() ;
		} else if ( pGubun == "progressPopup" ){
			sheetSearch();
		}
	}
	
	//작업일자 정의 팝업
	function openRetireSet() {
		if(waitFlag) return;

		var args = new Array();
		
		if(!isPopup()) {return;}
		openPopup("<%=jspPath%>/retCalc/retCalcPayDayPopup.jsp?authPg=<%=authPg%>",args,"900","580");
	}

	
	// 작업 프로그램 진행현황 팝업
	function openProcessBar(actYn) {
		var w 		= 470;
		var h 		= 300;
		var url 	= "<%=jspPath%>/common/progressPopup.jsp";
		var args    = new Array();

		args["prgCd"] = "P_CPN_SEP_PAY_MAIN";
		args["payActionCd"]	= $("#searchPayActionCd").val();
		args["payActionNm"]	= $("#searchPayActionNm").val();
		args["actYn"]	= actYn;
		
		if(!isPopup()) {return;}
		pGubun = "progressPopup";
		openPopup(url+"?authPg=<%=authPg%>", args, w, h);
		//sheetSearch();
	}
	
	//퇴직금계산 작업
	function doJob(){
		if(chkSave()) return;
		if(waitFlag) return;
		if(checkClose()) return;
		
		if(checkPayActionCd()){
			if($("#peoplePCnt").html() == "0"){
				alert("대상인원이 없습니다.");
				return;
			}
			
			if(confirm("퇴직금 계산을 시작하시겠습니까?")){
					/*
		   	    	ajaxCall("<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=prcCpnSepPayMain",$("#sheetForm").serialize()
		   	    			,true
		   	    			,function(){
								waitFlag = true;
								$("#progressCover").show();
		   	    			}
		   	    			,function(){
								waitFlag = false;
								$("#progressCover").hide();
								sheetSearch();
		   	    			}
		   	    	);		
					*/
		   	    	openProcessBar("1");
			}
		}
	}
	
	//퇴직금계산 작업 취소
	function cancelJob(){
		if(chkSave()) return;
		if(waitFlag) return;
		
		if( $("#peopleJCnt").html()*1 <= 0){
			alert("작업완료 인원이 존재하지 않습니다.") ;
			return;
		}
	
		
		if( $("#calcuFinishedImg").is(":checked")){
			alert("이미 마감된 자료입니다.") ;
			return;
		}
		
		if(checkPayActionCd()){
			if(confirm("퇴직금계산취소를 시작하시겠습니까?")){
				waitFlag = true;
				ajaxCall("<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=prcCpnSepEmpCancel",$("#sheetForm").serialize(),false);
	   	    	waitFlag = false ;
	   	    	sheetSearch();
			}
		}
	}
	
	//마감
	function finishAll(){
		if(chkSave()) return;
		if(waitFlag) return;
		if(checkClose()) return;
		
		if($("#peopleTotalCnt").html()*1 == 0){
			alert("대상인원이 존재하지 않습니다.\n마감할 수 없습니다.");
			return;
		}
		
		if($("#peopleTotalCnt").html() != $("#peopleJCnt").html()){
			alert("퇴직금계산이 완료되지 않은 인원이 있어 마감할 수 없습니다.");
			return;
		}
	
		if(checkPayActionCd()){
			var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=Y";
			//TCPN981 UPDATE! 
			ajaxCall("<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=saveFinalCloseYn",params,false);
			
			sheetSearch();
		}
	}
	
	//마감취소
	function cancelAll(){
		if(chkSave()) return;
		if(waitFlag) return;
		/*
		if( !$("#calcuFinishedImg").is(":checked")){
			alert("마감되지 않은 자료입니다.") ;
			return;
		}
		*/
		if(checkPayActionCd()){
	
			//if(sheet1.GetCellValue(1, 'final_close_yn') != "Y"){
			//	alert("마감되지않은 퇴직정산계산작업입니다.");
			//	return;
			//}		
			
			var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=N";
			//TCPN811 & TCPN983 UPDATE! 
			ajaxCall("<%=jspPath%>/retCalc/retCalcRst.jsp?cmd=saveFinalCloseYn",params,false);
			
			sheetSearch();
		}
	
	}

	//퇴직금 마감여부 체크
	function setCloseImg(){
		if(sheet1.GetCellValue(1, 'final_close_yn') == "Y") {
			$(':checkbox[name=calcuFinishedImg]').attr('checked', true);
		} else{
			$(':checkbox[name=calcuFinishedImg]').attr('checked', false);
		}	
	}
	
	function searchEmp(){
		var inputTxt = $("#searchSbNm").val();
		
		for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
			if (sheet3.GetCellValue(i, "name").indexOf(inputTxt) > -1) {
				sheet3.SelectCell(i, "name");
				return;
			}
			if (sheet3.GetCellValue(i, "sabun").indexOf(inputTxt) > -1) {
				sheet3.SelectCell(i, "sabun");
				return;
			}
		}
	}
	
	function chkSave(){
		var saveChkFlag = false;
		for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
			if (sheet3.GetCellValue(i, "sStatus") == "I" || sheet3.GetCellValue(i, "sStatus") == "U" || sheet3.GetCellValue(i, "sStatus") == "D") {
				saveChkFlag = true;
				alert("저장하지 않은 내역에 대해서 저장해 주시기 바랍니다.");
				return saveChkFlag;
			}
		}
		return saveChkFlag;
	}
</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
		<input type="hidden" id="searchPayCd" name="searchPayCd" value="">
	</form>
	<table border="0" cellspacing="0" cellpadding="0"  width="100%" class="outer">
	    <tr>
			<td class="top center">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">퇴직금계산</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer">
					<colgroup>
						<col width="10%" />
					    <col width="15%" />
					    <col width="10%" />
					    <col width="15%" />
					    <col width="10%" />
					    <col width="" />
				    </colgroup>
					<tr>
						<th class="left" > 작업일자 </th>
						<td class="left"> 
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text w200 readonly transparent" value="" readonly/>
							<a onclick="javascript:payActionSearchPopup();" href="#" class="button6"><img src="<%=imagePath%>/common/btn_search2.gif"/></a> 
						</td>
						<th class="left"> 대상연월 </th>
						<td class="left"> 
							<input type="text" id="payYM" name="payYM" class="text center transparent readonly" value="" readonly />
						</td>
						<th class="left"> 발령기준일 </th>
						<td class="left"> 
							<input type="text" id="ordYmd" name="ordYmd" class="text w100p center transparent readonly" value="" readonly />
						</td>						
					</tr>
					<tr>
						<th>총인원</th>
						<td id="peopleTotalCnt" class="center"> </td>
						<th>대상인원</th>
						<td id="peoplePCnt" class="center"> </td>
						<th>작업완료인원</th>
						<td id="peopleJCnt" class="center"> </td>						
					<tr>
						<th colspan="6" class="center">퇴직금 마감여부
							<input type="checkbox" class="checkbox" id="calcuFinishedImg" name="calcuFinishedImg" style="vertical-align:middle;" disabled>
						</th>
					</tr>
					<tr>
						<td colspan="6" class="center">
							<a href="javascript:doJob();"		class="basic authA">작업</a>
							<a href="javascript:cancelJob();"	class="basic authA">작업취소</a>						
							<a href="javascript:finishAll();"	class="basic authA">마감</a>
							<a href="javascript:cancelAll();"	class="basic authA">마감취소</a>
							&nbsp;&nbsp;
							<a href="javascript:openProcessBar('0');"	class="button1">진행상태</a>
						</td>
					</tr>
				</table>
			</td>
			<td>
			</td>
		</tr>
	</table>
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100px"); </script>
		<script type="text/javascript">createIBSheet("sheet2", "100%", "100px"); </script>
	</span>
	
	<div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">퇴직금 대상자
            	&nbsp;
            	&nbsp;
            	&nbsp;
            	<a href="javascript:doAction3('ReCalc')" 		id="reCalcBtn" name="reCalcBtn" class="button" style="display:none">재계산</a>
            	
            </li>
            	
            <li class="btn">
                                     사번 / 성명 <input type="text" id="searchSbNm" name="searchSbNm" class="text w100" value=""/>
				<a href="javascript:searchEmp();"		class="button">검색</a>
				&nbsp;&nbsp;&nbsp;
            	<a href="javascript:sheetSearch()" 			class="basic authA">조회</a>
				<a href="javascript:doAction3('Save')" 			class="basic authA">저장</a>
				<a href="javascript:doAction3('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet3", "100%", "400px"); </script>
</div>
</body>
</html>