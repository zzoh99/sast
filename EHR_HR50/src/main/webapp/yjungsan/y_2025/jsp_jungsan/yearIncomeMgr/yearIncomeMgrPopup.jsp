<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html>
<html>
<head>
<title>연간소득_개별</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var p = eval("<%=popUpStatus%>");
	$(function() {
		$("#menuNm").val($(document).find("title").text());
		var arg = p.window.dialogArguments;

		var srchSabun		= "";
		var srchAdjustType	= "";
		var srchYear		= "";
		var titleName		= "";

		if( arg != undefined ) {
			// opener 그리드에서 선택된 값
			srchSabun		= arg["srchSabun"];
			srchAdjustType	= arg["srchAdjustType"];
			srchYear		= arg["srchYear"];
			titleName		= arg["titleName"];

		}else{
			srchSabun 	  	= p.popDialogArgument("srchSabun");
			srchAdjustType  = p.popDialogArgument("srchAdjustType");
			srchYear       	= p.popDialogArgument("srchYear");
			titleName 		= p.popDialogArgument("titleName");
		}

		$("#srchYear").val( srchYear );
		$("#srchSabun").val( srchSabun );
		$("#titleName").html( titleName );

        $("#reduce_s_ymd").datepicker2({startdate:"reduce_e_ymd",onReturn:function(){

            var sYy   = $("#reduce_s_ymd").val();
            var chkYy = sYy.substr(0,4);

            if(chkYy != $("#srchYear").val()){
                alert("귀속년도만 가능합니다.");
                $("#reduce_s_ymd").val("");
            }
            reduceChg(1);
        }});
        $("#reduce_e_ymd").datepicker2({enddate:"reduce_s_ymd",onReturn:function(){

            var sYy   = $("#reduce_e_ymd").val();
            var chkYy = sYy.substr(0,4);

            if(chkYy != $("#srchYear").val()){
                alert("귀속년도만 가능합니다.");
                $("#reduce_e_ymd").val("");
            }
            reduceChg(2);
        }});
        $("#reduce_s_ymd").mask("1111-11-11") ;
        $("#reduce_e_ymd").mask("1111-11-11") ;

		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",				Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
			{Header:"상태",				Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
	          <%// 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. => initdata 세팅으로 조정
	            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.%>
			{Header:"년도",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"work_yy",			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, DefaultValue:"<%=yeaYear%>" },
			{Header:"정산구분",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"년월",				Type:"Date",      	Hidden:0,  	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"ym",   				KeyField:1,   CalcLogic:"",   Format:"Ym",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
			{Header:"급여액",				Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"pay_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"상여액",			    Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"bonus_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"인정상여",		    	Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"etc_bonus_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"주식매수선택권\n행사이익",	Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"stock_buy_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"우리사주조합\n인출금",		Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"stock_union_mon",  	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"임원퇴직소득금액\n한도초과액",		Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"imwon_ret_over_mon",  	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//20240411 "직무발명한도초과액"은 key-in하지 않음. 기타소득의 "직무발명수당" 금액 있으면 세금계산할 때, 종전+주현 한도를 종합 체크해서 과세필드에 자동 업데이트 함
            {Header:"총급여",				Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"total",				KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|pay_mon|+|bonus_mon|+|etc_bonus_mon|+|stock_buy_mon|+|stock_union_mon|+|imwon_ret_over_mon|" },
			{Header:"국외근로\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:90,	Align:"Right", 	ColMerge:0,   SaveName:"notax_abroad_mon",  KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"야간근로(생산)\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:90,	Align:"Right", 	ColMerge:0,   SaveName:"notax_work_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"보육\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_baby_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"연구보조(H09)\n비과세",		Type:"AutoSum",     Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_research_mon",KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"취재수당\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_reporter_mon",KeyField:0,  CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"식대\n비과세",	    Type:"AutoSum",     Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_food_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"수련보조수당\n비과세",	Type:"AutoSum",		Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_train_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"기타비과세\n(미신고)",	Type:"AutoSum",		Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_etc_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"차량비과세\n(미신고)",	Type:"AutoSum",     Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_car_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"일직료비과세\n(미신고)",	Type:"AutoSum",		Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_nightduty_mon",KeyField:0,  CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인\n비과세",		Type:"AutoSum",		Hidden:1,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_forn_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"비과세계",				Type:"AutoSum",		Hidden:0,  	Width:90,	Align:"Right",	ColMerge:0,   SaveName:"notax_total",		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|notax_work_mon|+|notax_abroad_mon|+|notax_food_mon|+|notax_car_mon|+|notax_forn_mon|+|notax_research_mon|+|notax_baby_mon|+|notax_train_mon|+|notax_nightduty_mon|+|notax_reporter_mon|+|notax_etc_mon|" },
			{Header:"국민연금",		    	Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right",	ColMerge:0,   SaveName:"pen_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"공무원연금",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon2",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"군인연금",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon3",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"사립학교\n교직원연금",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon1",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"별정우체국\n연금",		    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon4",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"건강보험",		    	Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right",	ColMerge:0,   SaveName:"hel_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"고용보험",		    	Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right",	ColMerge:0,   SaveName:"emp_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"소득세",			    Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right",	ColMerge:0,   SaveName:"income_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"지방소득세",			    Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right",  ColMerge:0,   SaveName:"inhbt_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"농특세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0,   SaveName:"rural_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"감면\n세액",			Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"exmpt_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인납세보전",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_tax_plus_mon", KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외지급일자",			Type:"Date",     	Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_pay_ymd",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"외화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"원화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_ntax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//{Header:"기타금액2",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon2",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//{Header:"기타금액3",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon3",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//{Header:"기타금액4",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon4",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"노조비",				Type:"AutoSum",     Hidden:0, 	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"labor_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"비고",				Type:"Text",     Hidden:0, 	Width:200,	Align:"Left",	ColMerge:0,   SaveName:"memo",   		KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);

		sheet1.SetCountPosition(0);

		// 2번 그리드
        var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",		Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"work_yy",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"정산구분",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"adjust_type",   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"소득구분명",	Type:"Combo",      	Hidden:0,  Width:90,	Align:"Center",	ColMerge:0,   SaveName:"adj_element_cd",KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"지급월",		Type:"Date",      	Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"ym",   			KeyField:1,   CalcLogic:"",   Format:"Ym",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
			{Header:"총액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"비과세액or감면세액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"notax_mon",  	KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"과세액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"tax_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"감면기간시작일",Type:"Text",       Hidden:1,  Width:80,    Align:"Right",  ColMerge:0,   SaveName:"reduceSymd",    KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"감면기간종료일",Type:"Text",       Hidden:1,  Width:80,    Align:"Right",  ColMerge:0,   SaveName:"reduceEymd",    KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);

		sheet2.SetCountPosition(0);

		/* 2019. 기존:C00303 -> 원천징수부 신청도 포함 */
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchYear="+$("#srchYear").val(),"getEachAdjstTypeList") , "");
		<%--var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");--%>
	    var adjElementCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "");

		sheet2.SetColProperty("adj_element_cd",    {ComboText:"|"+adjElementCdList[0], ComboCode:"|"+adjElementCdList[1]} );

		$("#srchAdjustType").val( srchAdjustType );

        $(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		//양식다운로드 title 정의
		templeteTitle1 += "년월 : YYYY-MM   예)2013-01 \n";
		templeteTitle1 += "No : 기재할 필요 없음 \n";
	});

	$(function() {
		$("#srchYear").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				doAction2("Search");
				$(this).focus();
			}
		});

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
	});

    //Sheet Action1
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
			var param = "cmd=selectYearIncomeEachMgr&"+$("#srchFrm").serialize();
			sheet1.DoSearch( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp", param );
        	break;
        case "Save":
			// 중복체크
			if (!dupChk(sheet1, "work_yy|adjust_type|sabun|ym", true, true)) {break;}
        	sheet1.DoSave( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp?cmd=saveYearIncomeEachMgr",$("#srchFrm").serialize());
        	break;
        case "Insert":
        	if($("#srchYear").val() == "") {
        		alert("년도를 입력하여 주십시오.");
        		return ;
        	}

        	var newRow = sheet1.DataInsert(0);
       		sheet1.SetCellValue(newRow, "work_yy",		$("#srchYear").val());
       		sheet1.SetCellValue(newRow, "adjust_type",	$("#srchAdjustType").val());
       		sheet1.SetCellValue(newRow, "sabun",		$("#srchSabun").val());
       		sheet1.SetCellValue(newRow, "sStatus",		"I");
        	break;
        case "Copy":
        	sheet1.DataCopy();
        	break;
        case "Clear":
        	sheet1.RemoveAll();
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        case "Down2Template":
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,24",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":

            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.
            // 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. 
            //              work_yy     => initdata 세팅으로 조정 
            //              adjust_type => 엑셀 양식에서 key-in으로 조정
            //              sabun       => sheet1_OnLoadExcel에서 자동설정
            //sheet1.SetColProperty(0, "work_yy", { DefaultValue: $("#srchYear").val() } );
            //sheet1.SetColProperty(0, "adjust_type", { DefaultValue: $("#srchAdjustType").val() } );
            //sheet1.SetColProperty(0, "sabun", { DefaultValue: $("#srchSabun").val() } );
            
        	var params = {Mode:"HeaderMatch", WorkSheetNo:1};
        	sheet1.LoadExcel(params);
        break;
        }
    }

    //Sheet Action2
    function doAction2(sAction) {

   		switch (sAction) {
        case "Search":
			var param = "cmd=selectYearIncomeEachMgrEtc&"+$("#srchFrm").serialize();
			sheet2.DoSearch( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp", param );
     	   	break;
        case "Save":
            //감면기간 체크
            var reduceChk = false;
            var reduceMsg = "";
            var findText  = "";
            var reParam   = "";

            var eleCdFinTxt = "";
            var eleCdTotCnt = 0; //조회시 감면관련 소득구분 갯수
            var eleCdIUpCnt = 0; //입력시 감면관련 소득구분 갯수(상태:I or U)
            var eleCdDelCnt = 0; //삭제시 감면관련 소득구분 갯수(상태:D)

            for(var i=1; i <= sheet2.LastRow(); i++){
                // 감면관련 소득구분 Cnt
                eleCdFinTxt = sheet2.GetCellText(i, "adj_element_cd");
                if(eleCdFinTxt.indexOf("감면") != -1){
                    //조회 시트중 감면관련 소득구분 cnt
                    eleCdTotCnt++;
                }
                if(sheet2.GetCellValue(i,"sStatus") == "I" || sheet2.GetCellValue(i,"sStatus") == "U"){
                    
                    eleCdFinTxt = sheet2.GetCellText(i, "adj_element_cd");
                    if(eleCdFinTxt.indexOf("감면") != -1){
                        eleCdIUpCnt++;
                    }
                }else if(sheet2.GetCellValue(i,"sStatus") == "D"){
                    if($("#reduce_s_ymd").val() != "" && $("#reduce_s_ymd").val() != ""){
                        eleCdFinTxt = sheet2.GetCellText(i, "adj_element_cd");
                        if(eleCdFinTxt.indexOf("감면") != -1){
                            eleCdDelCnt++;
                        }
                    }else{
                        eleCdTotCnt = 0;
                    }
                }
            }//end for

            if(eleCdTotCnt > 0 ||eleCdIUpCnt > 0 || eleCdDelCnt > 0){
                //입력시 감면기간 체크
                if(eleCdIUpCnt > 0){
                    if($("#reduce_s_ymd").val() == "") {                    	
                        alert("감면기간을 입력해주세요.");
                        $("#reduce_s_ymd").focus();
                        return;
                    } else if($("#reduce_e_ymd").val() == ""){                    	
                        alert("감면기간을 입력해주세요.");
                        $("#reduce_e_ymd").focus();
                        return;
                    }
                }
                //수기입력시 체크
                if($("#reduce_s_ymd").val() > $("#reduce_e_ymd").val()){
                     alert("감면시작일은 종료일보다 클수없습니다.");
                     return;
                }
                if (!dateChk()){
                     alert("감면기간은 귀속년도만 가능합니다.");
                     return;
                }

                //감면기간 초기화
                if(eleCdTotCnt == eleCdDelCnt){
                    //조회된 감면관련 소득구분과 삭제하려는 감면관련 소득구분 갯수가 같을때 감면기간 초기화
                    $("#reduce_s_ymd").val("");
                    $("#reduce_e_ymd").val("");
                }
            }else{
                //감면기간 입력한 채로 소득구분 변경시 감면기간 초기화
                $("#reduce_s_ymd").val("");
                $("#reduce_e_ymd").val("");
            }
        	// 중복체크
			if (!dupChk(sheet2, "work_yy|adjust_type|sabun|adj_element_cd|ym", true, true)) {break;}

            //감면기간 저장 param
            reParam = "srchYear="+$("#srchYear").val();
            reParam += "&srchSabun="+$("#srchSabun").val();
            reParam += "&srchAdjustType="+$("#srchAdjustType").val();
            reParam += "&reduce_s_ymd="+$("#reduce_s_ymd").val();
            reParam += "&reduce_e_ymd="+$("#reduce_e_ymd").val();
            reParam += "&reduceChk=Y";
            reParam += "&menuNm="+$(document).find("title").text();

        	sheet2.DoSave( "<%=jspPath%>/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp?cmd=saveYearIncomeEachMgrEtc",reParam);
			break;
        case "Insert":
			var newRow = sheet2.DataInsert(0);
			sheet2.SetCellValue(newRow, "work_yy",		$("#srchYear").val());
			sheet2.SetCellValue(newRow, "adjust_type",	$("#srchAdjustType").val());
			sheet2.SetCellValue(newRow, "sabun",		$("#srchSabun").val());
			break;
        case "Copy":
			sheet2.DataCopy();
			break;
        case "Clear":
			sheet2.RemoveAll();
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);
			break;
        case "LoadExcel":
        	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params);
        	break;
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			if(Code == 1) {
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1('Search');
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

    // 로드 후 메시지
    function sheet1_OnLoadExcel() {
        //엑셀로부터 업로드 된 데이터에 대하여 히든 key값을 세팅한다.
        for(var i = 1; i < sheet1.RowCount()+1; i++) {
                sheet1.SetCellValue2(i, "sabun", $("#srchSabun").val());
        }
    }

	// 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {

        	for (i = 1; i < sheet2.RowCount()+1; i++){
        		if(sheet2.GetCellValue(i, "adj_element_cd") == "C010_20" ||
						sheet2.GetCellValue(i, "adj_element_cd") == "C010_22" ||
						sheet2.GetCellValue(i, "adj_element_cd") == "C010_15" ){
						sheet2.SetCellEditable(i, "notax_mon", false);
				}
        	}

        	checkCloseBtn(); //2019-11-14. 권한에 따라 버튼 처리
        	getReduceYmd();

            var findTextSE = "";
            var cntChkSE   = 0;
            if(sheet2.RowCount() > 0){
	            for(var i = 1; i < sheet2.RowCount()+1; i++) {
	                findTextSE = sheet2.GetCellText(i, "adj_element_cd");

	                if(findTextSE.indexOf("감면") != -1){
	                    cntChkSE++;
	                }
	                sheet2.SetCellValue(i,"sStatus","");
	            }
	            if(cntChkSE > 0 || isReduceYmd){
	                $("#reduceDiv").show();
	            }else{
	                $("#reduceDiv").hide();
	            }
            }else{
            	$("#reduceDiv").hide();
            }
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
        } catch(ex) {
        	alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
        		doAction2("Search");
			}
        } catch(ex) {
        	alert("OnSaveEnd Event Error " + ex);
        }
    }

    function sheet2_OnChange(Row, Col, Value, OldValue) {

    	try{
    		if(sheet2.ColSaveName(Col) == "mon"||sheet2.ColSaveName(Col) == "sDelete"){
				if(sheet2.GetCellValue(Row, "adj_element_cd") == "C010_156" ||
						sheet2.GetCellValue(Row, "adj_element_cd") == "C010_157"){
					alert("출산지원금(Q03, Q04) 관련정보는 [출산지원금내역관리]화면에서 입력해 주시길 바랍니다.");
					if(sheet2.ColSaveName(Col) == "mon") {
						sheet2.SetCellValue(Row, "mon", OldValue, 0);	
					} else {
						sheet2.SetCellValue(Row, "sDelete", OldValue, 0);	
					}
					return;
				}
			}
    		
            var params = "searchWorkYy="+$("#srchYear").val();
            params += "&searchStdCd="+sheet2.GetCellValue(Row, "adj_element_cd");
            params += "&queryId=commonSelectTaxYn";

            var result = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params,false);

            if(result.Data.code == "Y"){
            	// 총액 = 과세액 (mon == tax_mon)
            	sheet2.SetCellValue(Row, "tax_mon"  ,sheet2.GetCellValue(Row, "mon"));
            	sheet2.SetCellValue(Row, "notax_mon",		"0"                     );
            }else{
            	// 총액 = 비과세액or감면세액 (mon == notax_mon)
            	sheet2.SetCellValue(Row, "notax_mon",sheet2.GetCellValue(Row, "mon"));
            	sheet2.SetCellValue(Row, "tax_mon"  ,		"0"                     );
            }

			if(sheet2.ColSaveName(Col) == "ym"){
				if(sheet2.GetCellValue(Row, "ym") != ""){
					if(sheet2.GetCellValue(Row, "ym").substring(0,4) != $("#srchYear").val()){
						alert("대상년도와 지급월이 다릅니다. 확인해 주십시오.");
						sheet2.SetCellValue(Row, "ym", "");
					}
				}
			}
            var findText = "";
            var cnt = 0;
            if(sheet2.ColSaveName(Col) == "adj_element_cd"){
            	//출산지원금은 출산지원금내역관리 화면에서 입력 할 수 있도록 체크로직 추가
				if(sheet2.GetCellValue(Row, "adj_element_cd") == "C010_156" ||
						sheet2.GetCellValue(Row, "adj_element_cd") == "C010_157"){
					alert("출산지원금(Q03, Q04) 관련정보는 [출산지원금내역관리]화면에서 입력해 주시길 바랍니다.");
					sheet2.SetCellValue(Row, "adj_element_cd", "");
					return;
				}
            	
                for(var i = 1; i < sheet2.RowCount()+1; i++) {
                    findText = sheet2.GetCellText(i, "adj_element_cd");
                    if(findText.indexOf("감면") != -1){
                        cnt++;
                    }
                }
                if(cnt > 0 || isReduceYmd){
                    $("#reduceDiv").show();
                }else{
                    $("#reduceDiv").hide();
                }
            }
			/* 소득구분 T01, T02 외국인기술자 감면세액에 관한 로직 임시 주석 (2020-11-18)
			if(sheet2.GetCellValue(Row, "adj_element_cd") == "C010_79" || sheet2.GetCellValue(Row, "adj_element_cd") == "C010_80" ){
				alert("해당 소득구분은 자료등록( 세액감면/기타세액공제 )에서 "+"\n등록해 주시기 바랍니다.");
				sheet2.SetCellValue(Row, "adj_element_cd","");
			}
			*/
    	}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
    }

	function setValue() {
		var rv = new Array(1);

		rv["closeFlag"] = true ;

		//p.window.returnValue = rv;
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}

	//2019-11-14. 권한에 따라 버튼 처리
	function checkCloseBtn(){
		var yeaCloseParam = "searchWorkYy="+$("#srchYear").val()+"&searchAdjustType="+$("#srchAdjustType").val()+"&searchSabun="+$("#srchSabun").val();
        var yeaCloseInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectYeaDataDefaultInfo", yeaCloseParam,false);

        if(yeaCloseInfo.Result.Code == 1) {
			if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"|| yeaCloseInfo.Data.input_close_yn == "Y") {
				if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"){
					//최종마감 또는 관리자 마감일때 버튼 미노출
					$("#btn_1").hide();
		            $("#btn_2").hide();
		            sheet1.SetEditable(0);
		            sheet2.SetEditable(0);
				} else if(yeaCloseInfo.Data.input_close_yn == "Y" && comSearchType == 'P'){
					//본인마감이고 조회구분이 '자신만 조회'일때 버튼 미노출
					$("#btn_1").hide();
		            $("#btn_2").hide();
		            sheet1.SetEditable(0);
		            sheet2.SetEditable(0);
				} else {
					$("#btn_1").show();
		            $("#btn_2").show();
		            sheet1.SetEditable(1);
		            sheet2.SetEditable(1);
				}
			} else {
				$("#btn_1").show();
	            $("#btn_2").show();
	            sheet1.SetEditable(1);
	            sheet2.SetEditable(1);
			}
		}
	}
    //감면기간 조회
    function getReduceYmd(){

        $("#reduceDiv").hide();

        var data =  ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=getReduceYmd", $("#srchFrm").serialize(),false);

        if(data.Result.Code == 1) {
            if(data.Data.s_ymd != "" && data.Data.e_ymd != ""){
                $("#reduce_s_ymd").val(data.Data.s_ymd);
                $("#reduce_e_ymd").val(data.Data.e_ymd);

                $("#reduce_s_ymd").mask("1111-11-11") ;
                $("#reduce_e_ymd").mask("1111-11-11") ;
                $("#reduceDiv").show();
                isReduceYmd = true;
            }else{
                $("#reduce_s_ymd").val("");
                $("#reduce_e_ymd").val("");
                $("#reduceDiv").hide();
                isReduceYmd = false;
            }
        }
    }
    //감면기간 체크
    function dateChk(){
        var rtn = true;
        var chkSymd = $("#reduce_s_ymd").val();
        var chkEymd = $("#reduce_e_ymd").val();

        chkSymd = chkSymd.substr(0,4);
        chkEymd = chkEymd.substr(0,4);

        if(chkSymd != $("#srchYear").val()){
            rtn = false;
        }
        if(chkEymd != $("#srchYear").val()){
            rtn = false;
        }
        return rtn;
    }

    //감면기간 onchange
    function reduceChg(val){

        var finText = "";
        var colNm   = "";
        if(val == "1"){
            ymdVal = $("#reduce_s_ymd").val();
            colNm  = "reduceSymd";
        }else{
            ymdVal = $("#reduce_e_ymd").val();
            colNm  = "reduceEymd";
        }

        for(var i=1; i <= sheet2.LastRow(); i++){
            findText = sheet2.GetCellText(i, "adj_element_cd");
            if(findText.indexOf("감면") != -1){
                sheet2.SetCellValue(i,colNm,ymdVal);
            }
        }
    }
</script>
</head>

<body class="bodywrap" style="overflow-y: auto;">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>연간소득_개별<font class="black">&nbsp;&nbsp;-&nbsp;&nbsp;<span
						id="titleName"></span>님
				</font></li>
				<!--<li class="close"></li>-->
			</ul>
		</div>
		<form id="srchFrm" name="srchFrm">
			<input id="srchSabun" name="srchSabun" type="hidden" value="" /> <input
				id="srchYear" name="srchYear" type="hidden" /> <input
				id="srchAdjustType" name="srchAdjustType" type="hidden" /> <input
				type="hidden" id="menuNm" name="menuNm" value="" />
		</form>

		<div class="popup_main">
			<div>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt">연간소득_개별</li>
							<li class="btn"><span id="btn_1"> <a
									href="javascript:doAction1('Down2Template')"
									class="basic btn-download authR">양식 다운로드</a> <a
									href="javascript:doAction1('LoadExcel')"
									class="basic btn-upload authR">업로드</a> <a
									href="javascript:doAction1('Insert')" class="basic authA">입력</a>
									<a href="javascript:doAction1('Copy')" class="basic authA">복사</a>
									<a href="javascript:doAction1('Save')"
									class="basic btn-save authA">저장</a>
							</span> <a href="javascript:doAction1('Down2Excel')"
								class="basic btn-download authR">다운로드</a></li>
						</ul>
					</div>
				</div>
				<font class="red">※ 노조비는 해당 노조와 상급단체 / 총연단체(1000명 미만인 경우)가 회계 공시한 경우만 기재하십시오. (소법59조4-시행령80조)</font>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "400px"); </script>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt">기타소득사항</li>
							<li class="btn"><span id="reduceDiv"><b>감면기간&nbsp;&nbsp;&nbsp;</b><input
									id="reduce_s_ymd" name="reduce_s_ymd" class="date2"
									onchange="reduceChg(1)" /> ~ <input id="reduce_e_ymd"
									name="reduce_e_ymd" class="date2" onchange="reduceChg(2)" /></span> <span
								id="btn_2"> <a href="javascript:doAction2('Insert')"
									class="basic authA">입력</a> <a
									href="javascript:doAction2('Copy')" class="basic authA">복사</a>
									<a href="javascript:doAction2('Save')"
									class="basic btn-save authA">저장</a>
							</span> <a href="javascript:doAction2('Down2Excel')"
								class="basic btn-download authR">다운로드</a></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "200px"); </script>
			</div>
			<!-- <div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:setValue();" class="pink large">확인</a>
				<a href="javascript:p.self.close();" class="gray large">닫기</a>
			</li>
		</ul>
		</div> -->
		</div>
	</div>
</body>
</html>