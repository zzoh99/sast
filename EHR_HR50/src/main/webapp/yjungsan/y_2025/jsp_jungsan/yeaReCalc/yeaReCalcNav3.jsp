<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>대상자정보수정</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%
	String ssnSearchType = (String)session.getAttribute("ssnSearchType");

	Map mp = StringUtil.getRequestMap(request);
	Map paramMap = StringUtil.getParamMapData(mp);
%>
<script type="text/javascript">
	$(function() {
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		$("#searchYear").val("<%=yeaYear%>") ;
        
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",                   Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"선택",		            Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"set_final",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"삭제",                  Type:"<%=sDelTy%>",   Hidden:1,  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",                  Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"work_yy",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"재정산\n상태",	        Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pay_people_status",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"재정산\n마감",            Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",        ColMerge:0,   SaveName:"final_close_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N"},
            {Header:"성명",                  Type:"Popup",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"name",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100, FontColor:"#0000ff" },
            {Header:"사번",                  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"sabun",                 KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"정산구분",               Type:"Combo",       Hidden:0,  Width:80,     Align:"Center",    ColMerge:0,   SaveName:"adjust_type_nm", KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"정산구분",		        Type:"Text",		Hidden:1,  Width:80,	Align:"Center",	 ColMerge:1,   SaveName:"adjust_type", KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"재정산\n구분",            Type:"Combo",		Hidden:0,  Width:70,	Align:"Center",	 ColMerge:0,   SaveName:"gubun",	      KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"재정산\n차수",	        Type:"Int",		    Hidden:0,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"re_seq",	      KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },            
            {Header:"계산명",                 Type:"Combo",      Hidden:0,  Width:150,  Align:"Center",         ColMerge:0,   SaveName:"pay_action_cd",         KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사업장",                 Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"business_place_nm",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사업장코드",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_cd",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"조직코드",               Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"org_cd",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"부서명",                Type:"Text",      Hidden:0,  Width:120,  Align:"Left",          ColMerge:0,   SaveName:"org_nm",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"세액계산방식",            Type:"Combo",     Hidden:0,  Width:110,  Align:"Center",        ColMerge:0,   SaveName:"tax_type",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"외국인\n단일세율적용",     Type:"Combo",     Hidden:0,  Width:110,  Align:"Center",        ColMerge:0,   SaveName:"foreign_tax_type",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"감면기간F",             Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"reduce_s_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"감면기간T",             Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"reduce_e_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"inputCloseYn",          Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"input_close_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"apprvYn",               Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"apprv_yn",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"houseOwnerYn",          Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"house_owner_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"주택취득일",            Type:"Date",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"house_get_ymd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"전용면적",              Type:"Float",     Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"house_area",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"공시시가",              Type:"Int",       Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"official_price",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"국가코드",              Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"national_cd",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10 },
            {Header:"국가명",                Type:"Text",      Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"national_nm",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 },
            {Header:"결과확인여부",          Type:"Text",      Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"result_confirm_yn",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"주택소유수",            Type:"Text",      Hidden:1,  Width:100,  Align:"Right",         ColMerge:0,   SaveName:"house_cnt",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"귀속시작일",            Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"adj_s_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"귀속종료일",            Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"adj_e_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"신고제외\n여부",         Type:"CheckBox",  Hidden:0,  Width:100,   Align:"Center",        ColMerge:0,   SaveName:"except_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N"},            
            {Header:"재정산\n추징일",	    Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"re_ymd", 			KeyField:0,	Format:"Ymd",   PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"재정산\n사유",	    Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"re_reason", 		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"재정산\n메모",	    Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"memo",  		    KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }			

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
	        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
	        
		var payPeopleStatusList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00125"), "");
        var nationalCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20295"), "");
		var foreignTaxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y&searchYear=<%=yeaYear%>","C00170"), "");
		var taxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00450"), "");
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
        var pay_action_cd       = stfConvCode( codeList("<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaPayActionCdList&searchYear=<%=yeaYear%>&cmbSabun=&cmbAdjType=","") , "");
				
        sheet1.SetColProperty("pay_people_status", {ComboText:"|삭제됨|"+payPeopleStatusList[0], ComboCode:"|-DDD|"+payPeopleStatusList[1]} );        
		sheet1.SetColProperty("national_cd",    {ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );
		sheet1.SetColProperty("foreign_tax_type",    {ComboText:"|"+foreignTaxTypeList[0], ComboCode:"|"+foreignTaxTypeList[1]} );
		sheet1.SetColProperty("tax_type",    {ComboText:"|"+taxTypeList[0], ComboCode:"|"+taxTypeList[1]} );
        sheet1.SetColProperty("adjust_type_nm",  	{ComboText:"|연말정산|퇴직정산", ComboCode:"|1|3"});
		sheet1.SetColProperty("gubun", 	            {ComboText:"|최종|수정(이력)",        ComboCode:"|F|H"});
		sheet1.SetColProperty("pay_action_cd",     {ComboText:"|"+pay_action_cd[0], ComboCode:"|"+pay_action_cd[1]} );  
		
		$("#searchAdjustType").html(adjustTypeList[2]).val("");
		
        // 사업장(권한 구분)
		var ssnSearchType  = "<%=ssnSearchType%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();
        
        doAction1("Search");
				
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
        case "Search":      //조회        
        	var param = $("#sheetForm").serialize() 
        	          + "&mSearchReSeq="+($("#searchReSeq").val()==null?"":getMultiSelect($("#searchReSeq").val()));
            sheet1.DoSearch( "<%=jspPath%>/yeaReCalc/yeaReCalcPeopleRst.jsp?cmd=selectYeaReCalcPeopleList", param);
            break;
        case "Save":        //저장
        	sheet1.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcPeopleRst.jsp?cmd=saveYeaReCalcPeople", $("#sheetForm").serialize() );
            break;
        case "chgFinal":    //최종으로변경    		
            var retVailid = isSetFinal() ; // "최종으로변경"할 대상이 선택됐는지 체크
        
        	if (retVailid == 0) {
        		alert("최종으로 변경할 수정(이력)이 선택되지 않았습니다.\n최종으로 변경할 수정(이력)을 먼저 선택하십시오.") ;
        		return;
        	} else if (retVailid < 0) {
        		alert("동일 대상의 수정(이력)이 중복 선택 되었습니다.\n최종 자료로 변경할 수정(이력)을 대상자별 한 건만 선택하십시오.") ;
        		return;
        	} else if (!confirm("수정(이력) 자료를 최종 자료로 변경하시겠습니까? (총 " + retVailid + "인)")) {
        		return;
        	}
        	
        	sheet1.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcPeopleRst.jsp?cmd=chgFinalYeaReCalcPeople", { Param : $("#sheetForm").serialize(), Quest : 0 } );
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
        }
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if(Code == 1) {
            	var rowCnt = sheet1.RowCount()+1;
                for(var i = 1; i < rowCnt; i++) {
                	if ( "-DDD" == sheet1.GetCellValue(i,"pay_people_status") ) {
	    				sheet1.SetRowEditable(i, 0);  //실제 삭제할 경우 원본 자료 매핑에 문제가 있음. 플래그 처리로 변경. 20241119
						sheet1.SetRowFontColor(i, "#CCCCCC");
						sheet1.SetCellFontColor(i, "pay_people_status", "#000000");
	    			} else {
	                	//마감이거나, 최초 정상 계산건은 수정할 수 없음.
	   					if ( "Y" == sheet1.GetCellValue(i,"final_close_yn") || "1" == sheet1.GetCellValue(i,"re_seq") ) {
	   						sheet1.SetRowEditable(i, 0);
	   	    			}
	
	   	    			if ( "F" == sheet1.GetCellValue(i,"gubun") ) {
	   	   				    // 최종은 폰트색상 파란색
	   						sheet1.SetCellFontColor(i, "gubun",  "#0000FF");
	   						sheet1.SetCellFontColor(i, "re_seq", "#0000FF");
	   	    			} else {
	   	    			    //수정(이력)은 "최종으로변경" 선택할 수 있도록.
	   	    				sheet1.SetCellEditable(i, "set_final", 1);
	   	    			}
	    			}
                }
            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
        	alertMessage(Code, Msg, StCode, StMsg);

            if(Code == 1) {
                doAction1("Search") ;
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
	
	var gPRow  = "";
	var pGubun = "";

	//값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		//저장 시 날짜 시작/종료 Validation 20240717
	  	try {
			if(Col == sheet1.SaveNameCol("reduce_s_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "reduce_e_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "reduce_s_ymd"),sheet1.GetCellValue(Row, "reduce_e_ymd"))){
						alert("감면기간 시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "reduce_s_ymd", OldValue);
						return false;
					}
				}
			}else if(Col == sheet1.SaveNameCol("reduce_e_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "reduce_s_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "reduce_s_ymd"),sheet1.GetCellValue(Row, "reduce_e_ymd"))){
						alert("감면기간 시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "reduce_e_ymd", OldValue);
						return false;
					}
				}
			}else if(Col == sheet1.SaveNameCol("adj_s_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "adj_e_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "adj_s_ymd"),sheet1.GetCellValue(Row, "adj_e_ymd"))){
						alert("귀속시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "adj_s_ymd", OldValue);
						return false;
					}
				}
			}
			else if(Col == sheet1.SaveNameCol("adj_e_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "adj_s_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "adj_s_ymd"),sheet1.GetCellValue(Row, "adj_e_ymd"))){
						alert("귀속시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "adj_e_ymd", OldValue);
						return false;
					}
				}
			}
		} catch (e) {
			
		}	
	}

	function sheet1_OnMouseDown(Button, Shift, X, Y) {
		//특정 셀의 콤보 항목 바꾸기
		var adjType = sheet1.GetCellValue(sheet1.MouseRow(),"adjust_type_nm") ;
		var strUrl  = "<%=jspPath%>/yeaReCalc/yeaReCalcRst.jsp?cmd=selectYeaPayActionCdList2&searchYear=<%=yeaYear%>" + "&cmbAdjType=" + adjType ;
		var pay_action_cd = stfConvCode( codeList(strUrl,"") , "");
		sheet1.CellComboItem(sheet1.MouseRow(),"pay_action_cd",{ComboText:"|"+pay_action_cd[0], ComboCode:"|"+pay_action_cd[1]});
	}
	
	//쉬트 조회
	function sheetSearch() {
		doAction1("Search");
	}

	// 일자 비교 함수
	function isAfter(date1, date2) {
	    return date1*1 > date2*1;
	}

	// "최종으로변경"할 대상이 선택됐는지 체크
	function isSetFinal() {		
    	var cntSel = 0;
		var arr = new Array();
    	
        for(var i = 1; i < sheet1.RowCount()+1; i++) {    		
			if ( "Y" == sheet1.GetCellValue(i,"set_final") ) {
	    		var thisVal = sheet1.GetCellValue(i,"adjust_type_nm") + "_" + sheet1.GetCellValue(i,"sabun") ;
	    		
				if (i > 1) { //처음은 중복체크 스킵
					for(var j = 0; j < arr.length; j++) {
						if (arr[j] == thisVal) { //중복
							cntSel = -1;
						    return cntSel ;
						}
					}
				}
				arr.push(thisVal);
				cntSel++;
   			}
        }
        
	    return cntSel ;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

        // 연말정산계산에서 선택한 사업장과 다른 사업장의 사용자 선택 시 초기화
        if(rv["business_place_cd"] != $("#searchBizPlaceCd").val() && $("#searchBizPlaceCd").val().length > 0){
        	alert("사업장에 속한 인원이 아닙니다.");
            sheet1.SetCellValue(gPRow, "business_place_cd", "");
            sheet1.SetCellValue(gPRow, "name", "");
            sheet1.SetCellValue(gPRow, "sabun", "");
            sheet1.SetCellValue(gPRow, "org_cd", "");
            sheet1.SetCellValue(gPRow, "org_nm", "");
        }
	}
	
</script>
</head>
<body class="bodywrap">
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
	
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li id="strSheetTitle" class="txt">재계산 대상 내역</li>
            <li class="btn">
            	다음의 자료는 수정할 수 없습니다 : 최초원본(<b><font color="blue">1차수</font></b>), [재정산계산]<b><font color="blue">마감</font></b>
                <a href="javascript:doAction1('Save')"  class="basic btn-save authA">저장</a>
            	<a href="javascript:doAction1('chgFinal')"  class="basic btn-red out-line authA">선택 자료를 최종으로 변경</a>
                <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</form>
</div>
</body>
</html>