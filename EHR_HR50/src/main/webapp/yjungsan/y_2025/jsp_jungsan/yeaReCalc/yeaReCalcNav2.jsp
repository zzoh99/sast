<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>재정산계산 > 계산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%
	Map mp = StringUtil.getRequestMap(request);
	Map paramMap = StringUtil.getParamMapData(mp);
%>
<script type="text/javascript">
	//급여계산중이거나, 급여계산취소 중이면 true
	var waitFlag    = false;
	var msg = "";

    var chkFull = false;

	var gPRow  = "";
	var pGubun = "";
	
	var adjustTypeList ;
	var re_reason ;
	
	var sheetheight = 0;

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"총건수",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"t_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"대상건수",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"all_884_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"재계산작업대상건수",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"p_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"재계산작업완료건수",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"마감건수",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_y_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"미마감건수",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_n_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22};
		initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
		initdata3.Cols = [
			{Header:"No|No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제|삭제",		Type:"<%=sDelTy%>",   Hidden:1,  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태|상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"엑셀업로드중|엑셀업로드중", Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"loadXlsYn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			   			
			{Header:"사번|사번",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명",		Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

			{Header:"사업장|사업장",	Type:"Combo",	    Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"귀속년도|귀속년도",	Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		        KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"정산코드|정산코드",	Type:"Text",		Hidden:1,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산구분|정산구분",	Type:"Combo",		Hidden:0,   Width:70,	Align:"Center",	ColMerge:0, SaveName:"adjust_type_nm",      KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"계산명|계산명",	Type:"Combo",		Hidden:0,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
			{Header:"선택|선택",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"re_cre",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"최종 / 재정산|상태",	    Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pay_people_status",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|마감\n여부",	Type:"Combo",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"final_close_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|구분",      	Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"gubun",  		        KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|차수",	    Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"re_seq",	 	    KeyField:0,	Format:"",	    PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|귀속종료일",	Type:"Date",	    Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ret_ymd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"최종 / 재정산|추징일",	    Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"re_ymd", 			KeyField:0,	Format:"Ymd",   PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
			{Header:"최종 / 재정산|사유",	    Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"re_reason", 		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"최종 / 재정산|메모",	    Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"memo",  		    KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"최종 / 재정산|작업일시",	    Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"",   	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종 / 재정산|작업자",	    Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"chkid",  			KeyField:0,	Format:"",   	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
		]; IBS_InitSheet(sheet3, initdata3); sheet3.SetEditable("<%=editable%>"); sheet3.SetVisible(true); sheet3.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet3", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet3.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
        adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), "전체");        
        re_reason      = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","YEA996"), "");
        
        var payPeopleStatusList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00125"), "");
        var bizPlaceCdList      = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
        var pay_action_cd       = stfConvCode( codeList("<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaPayActionCdList&searchYear=<%=yeaYear%>&cmbSabun=&cmbAdjType=","") , "");
        
        sheet3.SetColProperty("gubun", 	           {ComboText:"|최종|수정(이력)",             ComboCode:"|F|H"});		
		sheet3.SetColProperty("adjust_type_nm",    {ComboText:"|"+adjustTypeList[0],      ComboCode:"|"+adjustTypeList[1]} );
        sheet3.SetColProperty("pay_people_status", {ComboText:"|삭제됨|"+payPeopleStatusList[0], ComboCode:"|-DDD|"+payPeopleStatusList[1]} );
        sheet3.SetColProperty("final_close_yn",    {ComboText:"|Y|N", ComboCode:"|Y|N"} );
        sheet3.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCdList[0], ComboCode:"|"+bizPlaceCdList[1]} );
        sheet3.SetColProperty("pay_action_cd",     {ComboText:"|"+pay_action_cd[0], ComboCode:"|"+pay_action_cd[1]} );        
        sheet3.SetColProperty("re_reason",         {ComboText:"|"+re_reason[0], ComboCode:"|"+re_reason[1]} );
        sheet3.SetColProperty("org_re_reason",     {ComboText:"|"+re_reason[0], ComboCode:"|"+re_reason[1]} );
        
        //$("#searchAdjustType").html(adjustTypeList[2]).val("3"); //퇴직정산으로 초기 세팅
        $("#searchAdjustType").html(adjustTypeList[2]); //전체로 초기 세팅
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        
		/* 2018-07-12 계산 중 Dialog 출력 START */
		$( "#progressCover" ).dialog({
		      resizable: false,
		      height: 90,
		      width: 240,
		      modal: true
	    });
		$(".ui-dialog-titlebar").hide();

		$( "#progressCover" ).dialog('close');
		/* 2018-07-12 계산 중 Dialog 출력 END */
		
        $("#searchWorkYy, #searchSbNm").bind("keyup",function(event){
            if( event.keyCode == 13){
            	sheetSearch();
            }
        });

    	sheet3.SetSheetHeight($(window).height() - 338);
        $(window).smartresize(sheetResize); sheetInit();
        
        //sheetSearch();        
    	doAction2("Search");
		getCpnMonpay();
		doAction3("Search");
		
	});

	function doAction2(sAction) {
		switch (sAction) {
	    case "Search":
	    	sheet2.DoSearch( "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaReCalcSheet2List", $("#sheetForm").serialize() );
	    	break;
		}
	}

	function doAction3(sAction) {
		switch (sAction) {
	    case "Search":
			if(waitFlag) return;
			
        	var param = $("#sheetForm").serialize() 
                      + "&mSearchReSeq="+($("#searchReSeq").val()==null?"":getMultiSelect($("#searchReSeq").val()));
        	
	    	sheet3.DoSearch( "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaReCalcSheet3List", param);
	    	break;
	    		    	            
        case "Save":
    		if(waitFlag) return;

        	var reSeq1Rows = "";
        	var closedRows = "";
        	var recalcRows = "";
        	
    		for(var inti=sheet3.HeaderRows(); inti<=sheet3.LastRow(); inti++) {
    			if ( "Y" == sheet3.GetCellValue(inti,"re_cre") ) { // 선택 건만 체크
    				if ( "1" != sheet3.GetCellValue(inti,"re_seq") ) { //1회차 체크
 		    			if (reSeq1Rows != "") reSeq1Rows = reSeq1Rows + ", " ;
 		    			reSeq1Rows = reSeq1Rows + (inti-sheet3.HeaderRows()+1) ;
 		    		}
					if ( "Y" == sheet3.GetCellValue(inti,"final_close_yn") ) {
 		    			if (closedRows != "") closedRows = closedRows + ", " ; //마감 여부 체크
 		    			closedRows = closedRows + (inti-sheet3.HeaderRows()+1) ;
 		    		}
					if ( "J" != sheet3.GetCellValue(inti,"pay_people_status") ) { //작업완료 상태 체크
 		    			if (recalcRows != "") recalcRows = recalcRows + ", " ;
 		    			recalcRows = recalcRows + (inti-sheet3.HeaderRows()+1) ;
 		    		} 
    			}
    		}

			if (reSeq1Rows != "") reSeq1Rows = "\n1회차 자료는 최초 원본 백업용이므로 재계산을 진행할 수 없습니다. (" + reSeq1Rows + " 행)\n" ;			
			if (closedRows != "") closedRows = "\n이미 마감된 자료가 선택되었습니다. 마감 취소 후 진행하십시오. (" + closedRows + " 행)\n" ;
			if (recalcRows != "") recalcRows = "\n작업완료 상태인 건만 작업대상(재계산) 상태로 변경할 수 있습니다. (" + recalcRows + " 행)\n" ;
			
			recalcRows = reSeq1Rows + closedRows + recalcRows ;
			
			if (recalcRows != "") {
				alert(recalcRows);
				return
			}
			
        	sheet3.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=saveYeaReCalcSheet3", $("#sheetForm").serialize());            
            break;
			
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet3.Down2Excel(param);
			break;
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
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
	    		for(var inti=sheet3.HeaderRows(); inti<=sheet3.LastRow(); inti++) 
	    		{
	    			if ( "-DDD" == sheet3.GetCellValue(inti,"pay_people_status") ) {
	    				sheet3.SetRowEditable(inti, 0);  //실제 삭제할 경우 원본 자료 매핑에 문제가 있음. 플래그 처리로 변경. 20241119
						sheet3.SetRowFontColor(inti, "#CCCCCC");
						sheet3.SetCellFontColor(inti, "pay_people_status", "#000000");
	    			} else {	    			
		    			if ( "F" == sheet3.GetCellValue(inti,"gubun") )
		    			{
							sheet3.SetCellFontColor(inti, "gubun",  "#0000FF"); // 최종은 폰트색상 파란색
							sheet3.SetCellFontColor(inti, "re_seq", "#0000FF");
		    			}
	    			}
	    		}
			}

			//$("#search884").val("");
			$("#searchPayPeopleStatus").val("");
			$("#searchCloseYn").val("");
			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

    // 저장 후 메시지
    function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
			
            if(Code == 1) {
            	sheetSearch();
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

	//쉬트 조회
	function sheetSearch() {
		doAction2("Search");
		getCpnMonpay();
		doAction3("Search");
	}

	// 총급여생성 체크(재계산작업/재계산작업 취소 관련 저장 체크)
	function fn_payMonChkYn(){
		if($("#searchBizPlaceCd").val().length > 0){
			alert("사업장을 전체로 선택해 주십시오.\n총급여생성은 관리자만 할 수 있습니다.");
			if($("#payMonChk").is(":checked") == true) $(':checkbox[name=payMonChk]').prop("checked", false);
			else $(':checkbox[name=payMonChk]').prop("checked", true);
			return;
		}
	}

	//작업대상자가 존재하는지 체크
	function checkPCnt(){
		if(parseInt(sheet2.GetCellText(1, "p_cnt")) <= 0){
			alert("작업 대상 건수이 없습니다.\n대상자를 선택하여 저장 버튼을 클릭하신 후 다시 진행하십시오.");
			return false;
		} else {
			return true;
		}
	}

	//총급여합산(연급여생성)조회
	function getCpnMonpay(){

        var monpayYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_MONPAY_RETRY_YN&searchWorkYy="+$("#searchWorkYy").val(), "queryId=getYeaSystemStdData",false).codeList;
        var monpayReYn = "Y";

		if(monpayYn[0].code_nm != "N") {
			$("input:radio[name='cpn_monpay_return_yn']:input[value='"+monpayReYn+"']").attr("checked",true);
		} else {
			monpayReYn = "N";
			$("input:radio[name='cpn_monpay_return_yn']:input[value='"+monpayReYn+"']").attr("checked",true);
		}
	}

	//대상 정보
	function setPeopleStatusCnt() {
		$("#people884Cnt").html(sheet2.GetCellText(1, "all_884_cnt")+" 건") ;
		$("#peoplePCnt").html(sheet2.GetCellText(1, "p_cnt")+" 건") ;
		$("#peopleJCnt").html(sheet2.GetCellText(1, "j_cnt")+" 건") ;
		$("#finalCloseYCnt").html(sheet2.GetCellText(1, "final_y_cnt")+" 건") ;
		$("#finalCloseNCnt").html(sheet2.GetCellText(1, "final_n_cnt")+" 건") ;
	}

	//(퇴직)연말정산 재계산작업
	function doJob(){

		if(waitFlag) return;
		//if(checkClose()) return;
		if(!checkPCnt()) return;

		payFlag = "TRUE";
		taxFlag = "TRUE";
		msg		= "";

		if(!$("#payMonChk").is(":checked")){
			if(!$("#taxMonChk").is(":checked")){
				alert("작업을 선택해주세요. ( 총급여 생성하기 / 세금 계산하기 )");
				return;
			} else {
				msg = "(퇴직)연말정산계산";
				payFlag = "FALSE";
				taxFlag = "TRUE";
			}
		} else {
			msg = "총급여합산";
			if(!$("#taxMonChk").is(":checked")){
				payFlag = "TRUE";
				taxFlag = "FALSE";

			} else {
				msg =  "총급여합산,(퇴직)연말정산계산";
				payFlag = "TRUE";
				taxFlag = "TRUE";
			}
		}
		
		if(confirm($("#searchWorkYy").val()+" 년 "+msg+" 재작업을 시작하시겠습니까?\n작업 대상 건수은 " + sheet2.GetCellText(1, "p_cnt") + "건입니다.")){
			if(taxFlag == "TRUE" && payFlag == "TRUE") {					
				$( "#jobMode" ).val('A');
			} else if(payFlag == "TRUE") {
				$( "#jobMode" ).val('P');
			} else if(taxFlag == "TRUE") {
				$( "#jobMode" ).val('T');
			}
			
	   	    ajaxCall("<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=prcYearEndRecalTax",$("#sheetForm").serialize()
   	    			,true
   	    			,function(){
						waitFlag = true;
						$( "#progressCover" ).dialog('open');
   	    			}
   	    			,function(){
						waitFlag = false ;
						$( "#progressCover" ).dialog('close');
						doAction2('Search');
						doAction3('Search');
   	    			}
   	    	);
		}
	}

	//마감
	function finish(){

		if(waitFlag) return;

    	var finishCnt = 0;
    	for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
    		if( sheet3.GetCellValue(i, "re_cre") == "Y" && sheet3.GetCellValue(i, "final_close_yn") == "Y" ){
    			alert("이미 재정산 마감된 건을 선택하셨습니다. (" + (i -sheet3.HeaderRows()+1) + "행)");
    	        return;
    		} else if( sheet3.GetCellValue(i, "re_cre") == "Y" && sheet3.GetCellValue(i, "pay_people_status") != "J" ){
    			alert("재정산 작업완료가 아닌 상태의 건을 선택하셨습니다. (" + (i -sheet3.HeaderRows()+1) + "행)");
    	        return;
    		}
    		if( sheet3.GetCellValue(i, "re_cre") == "Y" && sheet3.GetCellValue(i, "pay_people_status") == "J" ){
    			finishCnt = 1 ;
    		} 
    	}
    	if (finishCnt > 0) {
    		sheet3.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=finishYeaReCalcSheet3&type=Y", $("#sheetForm").serialize());
    	} else {
    		alert("마감할 대상이 선택되지 않았습니다.\n재정산 작업완료 상태의 건을 선택하신 후 다시 진행하십시오.");
    	}
	}

	//마감취소
	function cancel(){

		if(waitFlag) return;

    	var finishCnt = 0;
    	for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
    		if( sheet3.GetCellValue(i, "re_cre") == "Y" && sheet3.GetCellValue(i, "final_close_yn") == "Y" ){
    			finishCnt = 1 ;
    		} else if( sheet3.GetCellValue(i, "re_cre") == "Y" && sheet3.GetCellValue(i, "final_close_yn") != "Y" ){
    			finishCnt = i * -1 ;
    	        break;
    		}
    	}
    	if (finishCnt < 0) {
     		alert("재정산 마감되지 않은 건을 선택하셨습니다. (" + (finishCnt * -1 -sheet3.HeaderRows()+1) + "행)");
     	} else if (finishCnt > 0) {
    		sheet3.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=finishYeaReCalcSheet3&type=N", $("#sheetForm").serialize());
    	} else {
    		alert("마감 취소할 대상이 선택되지 않았습니다.\n재정산 마감 완료된 건을 선택하신 후 다시 진행하십시오.");
    	}
	}
	
</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">

	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="menuNm" name="menuNm" />
		<input type="hidden" id="search884" name="search884" value="Y" />
		<input type="hidden" id="searchPayPeopleStatus" name="searchPayPeopleStatus" value="<%=((paramMap.get("searchPayPeopleStatus")==null)?"":paramMap.get("searchPayPeopleStatus"))%>" />
		<input type="hidden" id="searchCloseYn" name="searchCloseYn" value="<%=((paramMap.get("searchCloseYn")==null)?"":paramMap.get("searchCloseYn"))%>" />
		<input type="hidden" id="jobMode" name="jobMode" />
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" />
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="<%=((paramMap.get("searchAdjustType")==null)?"":paramMap.get("searchAdjustType"))%>" />
		<input type="hidden" id="searchGubun" name="searchGubun" value="<%=((paramMap.get("searchGubun")==null)?"":paramMap.get("searchGubun"))%>" />
		<input type="hidden" id="searchReSeq" name="searchReSeq" value="<%=((paramMap.get("searchReSeq")==null)?"":paramMap.get("searchReSeq"))%>" />
		<input type="hidden" id="searchBizPlaceCd" name="searchBizPlaceCd" value="<%=((paramMap.get("searchBizPlaceCd")==null)?"":paramMap.get("searchBizPlaceCd"))%>" />
		<input type="hidden" id="searchSbNm" name="searchSbNm" value="<%=((paramMap.get("searchSbNm")==null)?"":paramMap.get("searchSbNm"))%>" />
		<input type="hidden" id="searchDDD" name="searchDDD" value="<%=((paramMap.get("searchDDD")==null)?"":paramMap.get("searchDDD"))%>" />
	</form>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main hidebox">
		<colgroup>
			<col width="60%" />
			<col width="1%" />
			<col width="39%" />
		</colgroup>
		<tr>
			<td class="top center">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">재계산작업진행</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="30%" />
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th>총급여생성</th>
						<td colspan="3" class="left">
							<span id="chkTmp1">
								<input type="checkbox" class="checkbox" id="payMonChk" name="payMonChk" onchange="javascript:fn_payMonChkYn();" value="N" style="vertical-align: middle;">
								<label for="payMonChk" class="red"><strong>총급여 생성하기</strong></label>&nbsp;&nbsp;&nbsp;
							</span>
							<input type="radio"	class="radio" name="cpn_monpay_return_yn" id="cpn_monpay_return_yn1" value="Y">
							<label for="cpn_monpay_return_yn1">삭제후재생성</label>&nbsp;&nbsp;&nbsp;
							<input type="radio" class="radio" name="cpn_monpay_return_yn" id="cpn_monpay_return_yn2" value="N">
							<label for="cpn_monpay_return_yn2">신규만생성</label>
						</td>
					</tr>
					<tr>
						<th>세금계산</th>
                        <td class="left">
							<span>
								<input type="checkbox" class="checkbox" id="taxMonChk" name="taxMonChk" value="N" style="vertical-align: middle;">
								<label for="taxMonChk" class="red"><strong>세금 계산하기</strong></label>&nbsp;&nbsp;
							</span>
						</td>                    
						<th>대상선정 건수
						<br><font style="font-weight:normal">재계산 대상으로 등록된 건수</font></th>
						<td id="people884Cnt" class="right"> </td>
					</tr>
					<tr>
						<th>작업대상 건수
						<br><font style="font-weight:normal">작업대상(재계산) 상태의 재계산 대상 건수</font></th>
						<td id="peoplePCnt" class="right"> </td>
						<th>작업완료 건수
						<br><font style="font-weight:normal">작업완료 상태의 재계산 대상 건수</font></th>
						<td id="peopleJCnt" class="right"> </td>
					</tr>
					<tr>
						<th>미마감 건수
						<br><font style="font-weight:normal">마감되지 않은 재계산 대상 건수</font></th>
						<td id="finalCloseNCnt" class="right"> </td>
						<th>마감 건수
						<br><font style="font-weight:normal">마감된 재계산 대상 건수</font></th>
						<td id="finalCloseYCnt" class="right"> </td>
					</tr>
					<tr>
						<td colspan="4" class="center">
							<a href="javascript:doJob();" class="basic authA">작업대상 재계산</a>
							<%--<a href="javascript:cancelJob();"	class="basic authA">세금계산 취소</a> P_CPN_YEAREND_CANCEL 프로시저 내에 TCPN771을 UPDATE하는 로직이 있으므로 버튼을 제공하지 않는다 --%>
						</td>
					</tr>
				</table>
			</td>
			<td>
			</td>
			<td class="top">
				<div class="h25"></div>
				<div class="explain">
					<div class="title">재계산작업설명</div>
					<div class="txt">
						<ul>
						    <li>[<b>대상자선정</b>] 화면에서 등록한 <b>작업대상(재계산)</b>을 재계산합니다.</li>
						    	
					        <li>필요에 따라 총급여합산이나 <b>세금계산</b>을 <b>체크</b>하고 <b>재계산 작업</b> 버튼을 클릭합니다.</li>
						        <li style="padding-left:13px;">- 총급여합산 : 연급여내역관리의 <u>기존 내역을 제거</u>하고 급여 자료를 재반영합니다.</li>
						        <li style="padding-left:13px;">- 세금계산 : 근로소득세액을 세법에 따라 계산합니다.</li>

					        <li>자료 검증이 완료되면 [<b>대상자정보수정</b>] 화면에서 <b>재정산마감</b>을 체크하고 <b>저장</b> 버튼을 클릭합니다.</li>
					        <li>(<b>재정산마감</b>을 체크해제하고 <b>저장</b> 버튼을 눌러 <b>재계산 작업</b>을 다시 진행할 수 있습니다.)</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet2", "100%", "0px"); </script>
	</span>
	
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">재계산 대상</li>
				<li class="btn">
					<a href="javascript:finish();"	class="basic authA" title="선택된 대상자의 재계산 결과를 마감합니다">재계산 마감</a>
					<a href="javascript:cancel();"	class="basic authA" title="선택된 대상자의 재계산 결과 마감을 취소합니다">재계산 마감 취소</a>
					<a href="javascript:doAction3('Save')" class="basic btn-white" title="선택된 대상자의 상태를 작업완료에서 작업대상(재계산)으로 변경합니다">작업대상(재계산) 저장</a>
					&nbsp;
					<a href="javascript:doAction3('Down2Excel')"	class="basic btn-white" >다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet3", "100%", "190px"); </script>
	
</div>
</body>
</html>