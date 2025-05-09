<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>재정산계산 > 대상자</title>
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

	var gPRow  = "";
	var pGubun = "";
	
	var adjustTypeList ;
	var re_reason ;
	
	var sheetheight = 0;

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22};
		initdata3.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
		initdata3.Cols = [
			{Header:"No|No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제|삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태|상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"엑셀업로드중|엑셀업로드중", Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"loadXlsYn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			   			
			{Header:"사번|사번",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명",		Type:"Popup",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

			<%-- ------------------------------------------------------- --%>
			<%-- 현재 TCPN811.ADJUST_TYPE에 1(연말정산), 3(퇴직정산)에 매핑된 자료 --%>
			<%-- ------------------------------------------------------- --%>
			{Header:"사업장|사업장",	        Type:"Combo",	    Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"귀속\n년도|귀속\n년도",	    Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		        KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"정산코드\n백업입력\n최종→this|정산코드\n백업입력\n최종→this",	Type:"Text",		Hidden:1,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type_inst",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산코드\n복사대상\nthis→최종|정산코드\n복사대상\nthis→최종",	Type:"Text",		Hidden:1,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type_orig",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산코드|정산코드",	        Type:"Text",		Hidden:1,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산\n구분|정산\n구분",	    Type:"Combo",		Hidden:0,   Width:50,	Align:"Center",	ColMerge:0, SaveName:"adjust_type_nm",      KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"계산명|계산명",	        Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
			{Header:"선택|선택",		        Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"re_cre",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"최종 / 재정산|상태",	    Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"pay_people_status",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|마감\n여부",	Type:"Combo",	    Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"final_close_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|구분",      	Type:"Combo",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"gubun",  		        KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|차수",	    Type:"Text",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"re_seq",	 	    KeyField:0,	Format:"",	    PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종 / 재정산|귀속종료일",	Type:"Date",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ret_ymd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"최종 / 재정산|추징일",	    Type:"Date",		Hidden:0,	Width:75,	Align:"Center",	ColMerge:0,	SaveName:"re_ymd", 			KeyField:0,	Format:"Ymd",   PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"최종 / 재정산|사유",	    Type:"Combo",		Hidden:0,	Width:75,	Align:"Center",	ColMerge:0,	SaveName:"re_reason", 		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"최종 / 재정산|메모",	    Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"memo",  		    KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"최종 / 재정산|작업일시",	    Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"",   	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종 / 재정산|작업자",	    Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"chkid",  			KeyField:0,	Format:"",   	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			<%-- ----------------------------------------------------------------------------------------- --%>
			<%-- TCPN811.ADJUST_TYPE가 1R1(연말정산 1차 재정산자료의 원본), 3R2(퇴직정산 2차 재정산자료의 원본) 등의 원본 자료 --%>
			<%-- ----------------------------------------------------------------------------------------- --%>
			{Header:"재정산 원본|정산구분",	Type:"Text",	Hidden:1,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"org_adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"재정산 원본|차수",	    Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"org_re_seq",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"재정산 원본|계산명",	Type:"Text",	Hidden:0,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"org_pay_action_nm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재정산 원본|귀속종료일",	Type:"Date",    Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"org_ret_ymd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"재정산 원본|추징일",	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"org_re_ymd", 			KeyField:0,	Format:"Ymd",   PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재정산 원본|사유",	    Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"org_re_reason", 		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재정산 원본|메모",	    Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"org_memo",  		    KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재정산 원본|작업일시",	Type:"Text",	Hidden:0,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"org_chkdate",			KeyField:0,	Format:"",   	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재정산 원본|작업자",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"org_chkid",  			KeyField:0,	Format:"",   	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"최종발령|그룹입사일",	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"hrm_gemp_ymd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"최종발령|입사일",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"hrm_emp_ymd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"최종발령|퇴사일",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"hrm_ret_ymd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"최종발령|소속",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"hrm_org_nm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
			
			/*
			{Header:"주민번호",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",				KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			
			{Header:"호칭",		Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급",		Type:"Text",		Hidden:Number("${jgHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위",		Type:"Text",		Hidden:Number("${jwHdn}"),					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사원구분",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직군",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직책",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직위",			Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직급",			Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"재직상태",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"코스트센터",		Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
			{Header:"임금유형명",		Type:"Combo",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payType",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
			*/
		]; IBS_InitSheet(sheet3, initdata3); sheet3.SetEditable("<%=editable%>"); sheet3.SetVisible(true); sheet3.SetCountPosition(4);
		
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
                
        doAction3("ToggleHiddenCol"); //항목 접기 상태로 초기화
        
        //$(window).smartresize(sheetResize); 
        sheetInit();
        sheetSearch();

	});

	function doAction3(sAction) {
		switch (sAction) {
	    case "Search":       
        	var param = $("#sheetForm").serialize() 
	                  + "&mSearchReSeq="+($("#searchReSeq").val()==null?"":getMultiSelect($("#searchReSeq").val()));
	    	sheet3.DoSearch( "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaReCalcSheet3List", param );
	    	break;
	    	
        case "Insert":
        	if (sheet3.RowCount() <= 0) {
        		alert("조회된 자료가 없습니다. 자료 조회를 먼저 진행하십시오.");
        		return;
        	}
        	var newRow = sheet3.DataInsert(0) ;
   			sheet3.SetCellValue(newRow,"work_yy", $("#searchWorkYy").val(), 0); // change 이벤트는 발생 안 함
        	sheet3.SetCellValue(newRow,"pay_people_status", "PM", 0) ;
        	sheet3.SetCellValue(newRow,"final_close_yn", "N", 0) ;
   			
            break;

        case "Copy":
        	if (sheet3.RowCount() <= 0) {
        		alert("조회된 자료가 없습니다. 자료 조회를 먼저 진행하십시오.");
        		return;
        	}
        	var oldRow  = sheet3.GetSelectRow() ;
    		var sabun   = sheet3.GetCellValue(oldRow,"sabun") ;
    		var adjType = sheet3.GetCellValue(oldRow,"adjust_type_nm") ;
        	
        	if (sabun == "") {
        		alert("대상자 사번이 지정되지 않았습니다.\n대상 행의 사번을 먼저 지정한 후에 다시 진행하십시오.");
        		return;
        	} else if (adjType == "") {
        		alert("대상 정산구분이 지정되지 않았습니다.\n대상 행의 정산구분을 먼저 지정한 후에 다시 진행하십시오.");
        		return;
        	} else if (sheet3.GetCellValue(oldRow, "pay_action_cd") == "") {
        		alert("대상 계산명이 지정되지 않았습니다.\n대상 행의 계산명을 먼저 지정한 후에 다시 진행하십시오.");
        		return;
        	} else if (sheet3.GetCellValue(oldRow, "work_yy") == "") {
        		alert("대상 귀속년도가 지정되지 않았습니다.\n대상 행의 귀속년도를 먼저 지정한 후에 다시 진행하십시오.");
        		return;
        	} 

        	if (chkInputExists("", sabun, adjType)) return; //재정산 입력은 pk당 1건씩만 입력하자

        	if (sheet3.GetCellEditable(oldRow, "adjust_type_nm")) {
        		if (confirm("차수 연산을 위하여 원본의 대상 정보(사번/정산구분/계산명)를\n더이상 변경할 수 없게 됩니다. 계속 진행하시겠습니까?")) {
        			sheet3.SetCellEditable(oldRow, "name", 0);
	        		sheet3.SetCellEditable(oldRow, "adjust_type_nm", 0);
        			sheet3.SetCellEditable(oldRow, "pay_action_cd", 0);
        		} else {
        			return;
        		}
        	} 
        	
        	var newRow = sheet3.DataCopy() ;
        	sheet3.SetCellValue(newRow,"pay_people_status", "PM", 0) ;
        	sheet3.SetCellValue(newRow,"final_close_yn", "N", 0) ;
        	
        	sheet3.SetCellValue(newRow,"org_re_seq", sheet3.GetCellValue(oldRow, "re_seq"), 0) ;
        	sheet3.SetCellValue(newRow,"org_pay_action_nm", sheet3.GetCellText(oldRow, "pay_action_cd"), 0) ;
        	sheet3.SetCellValue(newRow,"org_ret_ymd", sheet3.GetCellValue(oldRow, "ret_ymd"), 0) ;
        	sheet3.SetCellValue(newRow,"org_re_ymd", sheet3.GetCellValue(oldRow, "re_ymd"), 0) ;
        	sheet3.SetCellValue(newRow,"org_re_reason", sheet3.GetCellValue(oldRow, "re_reason"), 0) ;
        	sheet3.SetCellValue(newRow,"org_memo", sheet3.GetCellValue(oldRow, "memo"), 0) ;
        	sheet3.SetCellValue(newRow,"org_chkdate", sheet3.GetCellValue(oldRow, "chkdate"), 0) ;
        	sheet3.SetCellValue(newRow,"org_chkid", sheet3.GetCellValue(oldRow, "chkid"), 0) ;
        	
        	/*
        	sheet3.SetCellValue(newRow,"hrm_gemp_ymd", "", 0) ;
        	sheet3.SetCellValue(newRow,"hrm_emp_ymd", "", 0) ;
        	sheet3.SetCellValue(newRow,"hrm_ret_ymd", "", 0) ;
        	sheet3.SetCellValue(newRow,"hrm_org_nm", "", 0) ;
        	*/
        	
			sheet3.SetCellEditable(newRow, "re_ymd", 1);    //최초 정상 계산건은 추징일 수정할 필요 없음. tcpn811만 있음. TCPN884없음.
			sheet3.SetCellEditable(newRow, "re_reason", 1); //최초 정상 계산건은 사유 수정할 필요 없음
			sheet3.SetCellEditable(newRow, "memo", 1);      //최초 정상 계산건은 메모 수정할 필요 없음
        	
   			resetReSeq(oldRow, newRow);
        		
            break;
            
        case "Save":
        	var origYn = "";
        	for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
        		if( sheet3.GetCellValue(i, "re_cre") == "Y" && sheet3.GetCellValue(i, "re_seq") == "1" ){
        			sheet3.SetCellValue( i, "re_cre", "" ) ;
        			origYn = (origYn.length > 0) ? origYn + "," : origYn ; 
        			origYn = origYn + (i - sheet3.HeaderRows()) + "행";
        		}
        	}
        	if (origYn != "") {
        		alert("선택하신 " + origYn + "은 원본 자료입니다.\n입력 또는 복사 버튼을 통해서 재정산 건수으로 먼저 등록하세요.");
        	} else {
        		sheet3.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=saveYeaReCalcSheet3", $("#sheetForm").serialize());
        	}
            
            break;
                                    
        case "Down2Template":
            var titleText  = "작성방법 \n 1. 사번, 귀속년도, 정산구분은 필수입니다.\n" +
            			     " 2. 저장시 해당 Row 삭제 저장 후 Upload 해주시기 바랍니다.\n" +
            			     " 3. 작성기준 \n" ;

			var codeCdNm = "";
			var codeNm = adjustTypeList[0].split("|"); 
			var codeCd = adjustTypeList[1].split("|");
			for ( var i=0; i<codeCd.length; i++ ) {
				if(i == codeCd.length-1){
					codeCdNm += codeCd[i] + "-" + codeNm[i] + "";
				}else{
					codeCdNm += codeCd[i] + "-" + codeNm[i] + " , ";
				}
			}
			titleText += " * 정산구분 : " + codeCdNm + " \n";
			
			codeCdNm = ""
			codeNm = re_reason[0].split("|"); 
			codeCd = re_reason[1].split("|");
			for ( var i=0; i<codeCd.length; i++ ) {
				if(i == codeCd.length-1){
					codeCdNm += codeCd[i] + "-" + codeNm[i] + "";
				}else{
					codeCdNm += codeCd[i] + "-" + codeNm[i] + " , ";
				}
			}
			titleText += " * 재정산 사유 : " + codeCdNm + " \n";
			
			titleText += " * 재정산 추징일 : YYYY-MM-DD \n";
			
			var param  = {DownCols:'sabun|name|work_yy|adjust_type_nm|re_ymd|re_reason|memo',SheetDesign:1,Merge:1,DownRows:'0|1',FileName:'Template',SheetName:'sheet3',TitleText:titleText,UserMerge:"0,0,1,7", ExcelRowHeight:100 ,menuNm:$(document).find("title").text()};
			sheet3.Down2Excel(param);
			break;
			
		case "LoadExcel":
			var	params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet3.LoadExcel(params);
			break;
			
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet3.Down2Excel(param);
			break;

        case "ToggleHiddenCol":
        	var bln = true ;
			if (sheet3.GetColHidden("org_re_seq")) {
				bln = false ;
				$("#btnToggleHiddenCol").html("◀ 항목 접기");
			} else {
				$("#btnToggleHiddenCol").html("▶ 항목 펼치기");
			}
			
		  //sheet3.SetColHidden("org_adjust_type",  bln) ;  //재정산 원본|정산구분
			sheet3.SetColHidden("org_re_seq",       bln) ;  //재정산 원본|차수
			sheet3.SetColHidden("org_pay_action_nm",bln) ;  //재정산 원본|계산명
			sheet3.SetColHidden("org_ret_ymd",      bln) ;  //재정산 원본|귀속종료일
			sheet3.SetColHidden("org_re_ymd",       bln) ;  //재정산 원본|추징일
			sheet3.SetColHidden("org_re_reason",    bln) ;  //재정산 원본|사유
			sheet3.SetColHidden("org_memo",         bln) ;  //재정산 원본|메모
			sheet3.SetColHidden("org_chkdate",      bln) ;  //재정산 원본|작업일시
			sheet3.SetColHidden("org_chkid",        bln) ;  //재정산 원본|작업자
			sheet3.SetColHidden("hrm_gemp_ymd",     bln) ;  //최종발령|그룹입사일
			sheet3.SetColHidden("hrm_emp_ymd",      bln) ;  //최종발령|입사일
			sheet3.SetColHidden("hrm_ret_ymd",      bln) ;  //최종발령|퇴사일
			sheet3.SetColHidden("hrm_org_nm",       bln) ;  //최종발령|소속
			break;
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
							sheet3.SetCellEditable(inti, "sDelete", 0) ; //최초 정상 계산건은 삭제할 수 없음.
		    			}
		    			
						if ( "1" == sheet3.GetCellValue(inti,"re_seq") )
		    			{
							sheet3.SetCellEditable(inti, "re_ymd", 0);    //최초 정상 계산건은 추징일 수정할 필요 없음. tcpn811만 있음. TCPN884없음.
							sheet3.SetCellEditable(inti, "re_reason", 0); //최초 정상 계산건은 사유 수정할 필요 없음
							sheet3.SetCellEditable(inti, "memo", 0);      //최초 정상 계산건은 메모 수정할 필요 없음
							
							sheet3.SetCellEditable(inti, "sDelete", 0) ; //최초 정상 계산건은 삭제할 수 없음.
							sheet3.SetCellEditable(inti, "re_cre", 0) ;  //최초 정상 계산건은 재정산할 수 없음. (수정이력 자료 1건은 생겨야 함)
		    			}
	    			}
	    		}
			}

			$("#search884").val("");
			$("#searchPayPeopleStatus").val("");
			$("#searchCloseYn").val("");
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//팝업 클릭시 발생
	function sheet3_OnPopupClick(Row,Col) {
		try {
			if(sheet3.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet3_OnChange(Row, Col, Value){		
		if ("Y" == sheet3.GetCellValue(Row,"loadXlsYn")) {
			return; // 엑셀 업로드 중인 건이면 체크 로직 skip
		}
		
		var colSvNm = sheet3.ColSaveName(Col);
		var sabun   = sheet3.GetCellValue(Row,"sabun") ;
		var adjType = sheet3.GetCellValue(Row,"adjust_type_nm") ;
		
		if(colSvNm == "sabun" || colSvNm == "adjust_type_nm" ) 
		{
			//특정 셀의 콤보 항목 바꾸기
			var strUrl = "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaPayActionCdList&searchYear=<%=yeaYear%>" + "&cmbSabun=" + sabun + "&cmbAdjType=" + adjType ;
			var pay_action_cd = stfConvCode( codeList(strUrl,"") , "");
			sheet3.CellComboItem(Row,"pay_action_cd",{ComboText:"|"+pay_action_cd[0], ComboCode:"|"+pay_action_cd[1]});
		} 
		else if ( colSvNm == "pay_action_cd" )
		{	
			if ( Value != "" && (sabun == "" || adjType == "") ) 
			{
				alert("성명과 정산구분을 먼저 지정하신 후 다시 진행하십시오.");
				sheet3.SetCellValue(Row, "pay_action_cd", "", 0); //change 이벤트 발생 제외
				return;
			} 
			else if (sheet3.GetCellEditable(Row, "pay_action_cd")) {
				 //재정산 입력은 pk당 1건씩만 입력하자
				if (chkInputExists(Row, sabun, adjType)) 
				{
					sheet3.SetCellValue(Row, "adjust_type", "", 0);
					sheet3.SetCellValue(Row, "adjust_type_nm", "", 0);
					sheet3.SetCellValue(Row, "pay_action_cd", "", 0);    				
					return;
				} 
				else if (confirm("차수 연산을 위하여 대상 정보(사번/정산구분/계산명)를\n더이상 변경할 수 없게 됩니다. 계속 진행하시겠습니까?")) 
				{
    				resetReSeq(Row, Row); //다른 행에 있는 최종 회차를 조정한다.
        		} else {
    				sheet3.SetCellValue(Row, "pay_action_cd", "", 0); //change 이벤트 발생 제외
        			return;
        		}
			}
		}
		else if(colSvNm  == "gubun") 
		{
			if (Value == "F") { // 최종
				sheet3.SetCellValue(Row, "re_seq",  "", 0); //change 이벤트 발생 제외
			}
		} 
		else if(colSvNm  == "re_seq") 
		{
			if (sheet3.GetCellValue(Row,"gubun") == "H") { // 이력(수정)
				if (typeof Value !== 'undefined' && Value < 1) {
					alert(sheet3.GetCellText(Row,"gubun") + "은 1차수 이상부터 등록 가능합니다.");
				}
			}
		}
		
		if(colSvNm  == "adjust_type_nm" || colSvNm  == "gubun" || colSvNm  == "re_seq") 
		{
			if (sheet3.GetCellValue(Row,"gubun") == "H") { // 이력(수정)
				sheet3.SetCellValue(Row, "adjust_type", adjType + "R" + sheet3.GetCellValue(Row,"re_seq"), 0); //change 이벤트 발생 제외
			} else {
				sheet3.SetCellValue(Row, "adjust_type", adjType, 0); //change 이벤트 발생 제외
			}
		}
	}

    function sheet3_OnLoadExcel() {
        var errMsg  = "";
        
        var sabun   = "";
        var adjType = "";

	    try {
            for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++) {

        		sabun   = sheet3.GetCellValue(i,"sabun") ;
        		adjType = sheet3.GetCellValue(i,"adjust_type_nm") ;
        		
            	if (chkInputExists(i, sabun, adjType)) {
            		return;
            	}

   				sheet3.SetCellEditable(i, "name", 0);
   				sheet3.SetCellEditable(i, "adjust_type_nm", 0);
   				sheet3.SetCellEditable(i, "pay_action_cd", 0);
            	
       			//특정 셀의 콤보 항목 바꾸기
       			var strUrl = "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaPayActionCdList&searchYear=<%=yeaYear%>" + "&cmbSabun=" + sabun + "&cmbAdjType=" + adjType ;
       			var pay_action_cd = stfConvCode( codeList(strUrl,"") , "");
       			sheet3.CellComboItem(i,"pay_action_cd",{ComboText:pay_action_cd[0], ComboCode:pay_action_cd[1]});
       			if (pay_action_cd[1] != "") {
       				var acts = pay_action_cd[1].split("|") ;
       				if (acts != null && acts.length > 0) {
       					sheet3.SetCellValue(i,"pay_action_cd",acts[0], 0);
       				}
       			}

            	sheet3.SetCellValue(i, "loadXlsYn", "Y", 0) ;  //change 이벤트 발생 제외	 
            	sheet3.SetCellValue(i, "adjust_type", adjType, 0) ;
            	sheet3.SetCellValue(i, "adjust_type_orig", adjType, 0) ;
            	sheet3.SetCellValue(i, "gubun", "F", 0) ;
            	sheet3.SetCellValue(i, "pay_people_status", "PM", 0) ;
            	sheet3.SetCellValue(i, "final_close_yn", "N", 0) ;
   				sheet3.SetCellFontColor(i, "gubun",  "#0000FF");
   				sheet3.SetCellFontColor(i, "re_seq", "#0000FF");
            }
            if (errMsg != "") {
            	alert(errMsg); 
            }
        } catch(ex) {
            alert("OnLoadExcel Event Error " + ex);
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
		doAction3("Search");
	}

	//사원 조회
	function openEmployeePopup(Row){
	    try{
		    var args    = new Array();

		    if(!isPopup()) {return;}
		    gPRow = Row;
		    pGubun = "employeePopup";

		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	     
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet3.SetCellValue(gPRow, "name", 	            rv["name"] );
			sheet3.SetCellValue(gPRow, "sabun",             rv["sabun"] );
			sheet3.SetCellValue(gPRow, "business_place_cd", rv["business_place_cd"] );
			sheet3.SetCellValue(gPRow, "hrm_gemp_ymd", 	    rv["gemp_ymd"] );
			sheet3.SetCellValue(gPRow, "hrm_emp_ymd", 	    rv["emp_ymd"] );
			sheet3.SetCellValue(gPRow, "hrm_ret_ymd", 	    rv["ret_ymd"] );
			sheet3.SetCellValue(gPRow, "hrm_org_nm",        rv["org_nm"] );
		}
	}

	//신규입력이나 복사에 따른 재정산 입력은 pk당 1건만 등록하자
	function chkInputExists(Row, sabun, adjType) {
		for(var inti=sheet3.HeaderRows(); inti<=sheet3.LastRow(); inti++) 
		{
			if ( Row != inti && "I" == sheet3.GetCellValue(inti,"sStatus")
					&& sabun == sheet3.GetCellValue(inti,"sabun")
					&& adjType == sheet3.GetCellValue(inti,"adjust_type_nm")
					&& "<%=yeaYear%>" == sheet3.GetCellValue(inti,"work_yy") )
			{
				alert((inti-1) + "번째 행에 동일 건이 입력되어 있습니다.");
				return true;
			}
		}
		return false;
	}	
	
	//신규입력이나 복사에 따른 재정산 차수 등 조정 작업
	function resetReSeq(oRow, nRow) {
		var oldRow     = oRow;
    	var oldReSeq   = "";
    	var oldSabun   = sheet3.GetCellValue(oldRow,"sabun") ;
    	var oldWorkYy  = sheet3.GetCellValue(oldRow,"work_yy") ;
    	var oldAdjType = sheet3.GetCellValue(oldRow,"adjust_type_inst") ;
    	oldAdjType     = (oldAdjType == "") ? sheet3.GetCellValue(oldRow,"adjust_type") : oldAdjType ;
    	var adjType    = sheet3.GetCellValue(oldRow,"adjust_type_nm") ;
    	//-------------------------------------------------------------------
    	// 1. 최종으로 되어 있는 구row의 정보를 조정 (표시만 조정해서 보여줌)
    	//-------------------------------------------------------------------
    	if (oRow == nRow || "H" == sheet3.GetCellValue(oldRow,"gubun")) { //신규입력 또는 원본이 수정(이력)인 경우
        	//다른 행에 최종 자료가 있다면, 그 행을 "수정(이력)"으로 표시해야 함
    		for(var inti=sheet3.HeaderRows(); inti<=sheet3.LastRow(); inti++) 
    		{
    			if ( nRow != inti && "F" == sheet3.GetCellValue(inti,"gubun")
    					&& oldSabun == sheet3.GetCellValue(inti,"sabun")
    					&& oldWorkYy == sheet3.GetCellValue(inti,"work_yy") )
    			{
    				oldRow = inti ;
    				break;
    			}
    		}
    	}
    	if (oldRow != nRow && oldRow != "") { //다른 행에 최종 자료가 있다면, 그 행을 "수정(이력)"으로 표시.
    		oldReSeq = sheet3.GetCellValue(oldRow,"re_seq") ;
        	if (oldReSeq == "") { oldReSeq = "1"; }
        	//sheet3.SetCellValue(oldRow,"adjust_type", adjType+"R"+oldReSeq, 0); //pk변경없음        	
        	sheet3.SetCellValue(oldRow,"gubun","H", 0);
        	sheet3.SetCellValue(oldRow,"re_seq",oldReSeq, 0);
        	var fClr = sheet3.GetCellFontColor(oldRow, "sabun");
    		sheet3.SetCellFontColor(oldRow, "gubun",  fClr); // 폰트색상원복
    		sheet3.SetCellFontColor(oldRow, "re_seq", fClr);
        	if(sheet3.GetCellValue(oldRow,"sStatus") == "U") {
        		//주의!!!!! DB처리는 PKG_CPN_YEA_2024_EMP.P_CPN_YEA_RECAL_EMP에서 수행해야 하므로 change 이벤트를 발생 시키지는 않음.
        		//기존 자료의 pk가 변경되면 TCPN8__ 백업자료도 업데이트 해야 하기 때문에 PK가 변경되지 않도록 수정 상태를 초기화한다. 
        		//단, 입력 상태는 무방하므로 초기화하지 않음.
        		sheet3.SetCellValue(oldRow,"sStatus","R", 0);
        	}
    	}
    	
    	//------------------------------------------------------------------- 
    	// 2. 신규 row의 정보를 조정
    	//-------------------------------------------------------------------
    	sheet3.SetCellValue(nRow,"gubun", "F", 0);
		sheet3.SetCellValue(nRow,"adjust_type_orig", oldAdjType, 0); // PKG_CPN_YEA_2024_EMP.P_CPN_YEA_RECAL_EMP에서 백업할 원본 추출용. null이면 최종 자료를 백업.
		sheet3.SetCellValue(nRow,"adjust_type_inst", adjType+"R"+oldReSeq, 0); //백업자료 입력할 pk
		sheet3.SetCellValue(nRow,"adjust_type", adjType, 0);	
		if (oldReSeq == "") {
			sheet3.SetCellValue(nRow,"re_seq", "", 0); // 엑셀로 업로드 된 경우, 다른 행의 정보를 조합하여 차수를 구성할 수 없음.
		} else {
			sheet3.SetCellValue(nRow,"re_seq", parseInt(oldReSeq) + 1, 0);
		}
		//sheet3.SetCellValue(nRow,"pay_people_status", "C", 0);  // 신규입력은 null하고 DB저장되면 C로 세팅
		sheet3.SetCellValue(nRow,"final_close_yn", "N", 0);  // change 이벤트는 발생 안 함
		sheet3.SetCellValue(nRow,"chkdate", "", 0);  // change 이벤트는 발생 안 함
		sheet3.SetCellValue(nRow,"chkid", "", 0);  // change 이벤트는 발생 안 함
		sheet3.SetCellFontColor(nRow, "gubun",  "#0000FF"); // 최종은 폰트색상 파란색
		sheet3.SetCellFontColor(nRow, "re_seq", "#0000FF");
			
		//구row의 정보를 조정했으므로 신규행의 key값을 변경할 수 없도록 수정불가 처리
		sheet3.SetCellEditable(nRow, "name", 0); 
		sheet3.SetCellEditable(nRow, "adjust_type_nm", 0);
		sheet3.SetCellEditable(nRow, "pay_action_cd", 0); 
	}



</script>

</head>
<body class="hidden">
<div class="wrapper">
	
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="menuNm" name="menuNm" />
		<input type="hidden" id="search884" name="search884" value="<%=((paramMap.get("search884")==null)?"":paramMap.get("search884"))%>" />
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
	
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">연말(퇴직)정산 전체 내역</li>
				<li class="btn">
				    다음의 자료는 삭제할 수 없습니다 : <b><font color="blue">최종</font></b>, 최초원본(<b><font color="blue">1</font>차수</b>), [재정산계산]<b><font color="blue">마감</font></b>
					<a href="javascript:doAction3('Down2Template')" class="basic btn-download">양식다운로드</a>
				    <a href="javascript:doAction3('LoadExcel')"   	class="basic btn-upload">업로드</a>
					<a href="javascript:doAction3('Insert')"		class="basic btn-white" >입력</a>
					<a href="javascript:doAction3('Copy')"		    class="basic btn-white" >복사</a>
					<a href="javascript:doAction3('Save')"			class="basic btn-white" >저장</a>
					<a href="javascript:doAction3('Down2Excel')"	class="basic btn-white" >다운로드</a>
					&nbsp;					
					<a href="javascript:doAction3('ToggleHiddenCol')"	class="basic btn-white" id="btnToggleHiddenCol" >항목 펼치기</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet3", "100%", "100%"); </script>
	
</div>
</body>
</html>