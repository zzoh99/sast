<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="hidden">
<head>
    <title>연간소득</title>
    <%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
    <script type="text/javascript">
	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD

        let now = new Date();
        $("#srchYear").val(now.getFullYear() - 1);

        // 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",   Hidden:1,  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
			{Header:"상태",				Type:"${sSttTy}",   Hidden:1,  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"년도",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"workYy",			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
			{Header:"월별\n내역",		Type:"Image",     	Hidden:0,  	Width:60,   Align:"Center",	ColMerge:0,	  SaveName:"detail",          	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
			{Header:"정산구분",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,   SaveName:"adjustType",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
			{Header:"성명",			    Type:"Text",		Hidden:0,  	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"name",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"소속",			    Type:"Text",		Hidden:0,  	Width:80,	Align:"Left",	ColMerge:0,   SaveName:"orgNm",   			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"급여액",				Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"payMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"상여액",			    Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"bonusMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"인정상여",		    	Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"etcBonusMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"주식매수선택권\n행사이익",	Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"stockBuyMon",		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"우리사주조합\n인출금",		Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"stockUnionMon",  	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"임원퇴직소득금액\n한도초과액",		Type:"AutoSum",     Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"imwonRetOverMon",  	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"총급여",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"total",				KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|payMon|+|bonusMon|+|etcBonusMon|+|stockBuyMon|+|stockUnionMon|" },
			{Header:"생산\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"notaxWorkMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"notaxAbroadMon",  KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"식대\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxFoodMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"차량\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxCarMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxFornMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"연구활동\n비과세",		Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxResearchMon",KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"출산보육\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxBabyMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"수련보조수당\n비과세",	Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxTrainMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"일직료\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxNightdutyMon",KeyField:0,  CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"취재수당\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxReporterMon",KeyField:0,  CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"기타\n비과세",			Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxEtcMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"비과세계",				Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notaxTotal",		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|notaxWorkMon|+|notaxAbroadMon|+|notaxFoodMon|+|notaxCarMon|+|notaxFornMon|+|notaxResearchMon|+|notaxBabyMon|+|notaxTrainMon|+|notaxNightdutyMon|+|notaxReporterMon|+|notaxEtcMon|" },
			{Header:"국민연금",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"penMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"사립학교교직원연금",		    Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etcMon1",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"공무원연금",		    	Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etcMon2",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"군인연금",		    	Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etcMon3",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"별정우체국연금",		    Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etcMon4",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"건강보험",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"helMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"고용보험",		    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"empMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"소득세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"incomeTaxMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"지방소득세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0,   SaveName:"inhbtTaxMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"농특세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0,   SaveName:"ruralTaxMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"감면\n세액",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"exmptTaxMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인납세보전",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgnTaxPlusMon", KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외지급일자",			Type:"Date",     	Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgnPayYmd",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"외화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgnMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"원화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgnNtaxMon",   	KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//{Header:"기타금액2",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etcMon2",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			//{Header:"기타금액3",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"etcMon3",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"기부금",				Type:"AutoSum",     Hidden:0, 	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"laborMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"기타소득_과세",				Type:"AutoSum",     Hidden:0, 	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"taxMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"기타소득_비과세",				Type:"AutoSum",     Hidden:0, 	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"notaxMon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);

		sheet1.SetCountPosition(4);
        sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		// 2번 그리드
        var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"년도",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"workYy",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"정산구분",	Type:"Combo",      	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"adjustType",   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소득구분명",	Type:"Combo",      	Hidden:0,  Width:90,	Align:"Center",	ColMerge:0,   SaveName:"adjElementCd",KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"지급월",		Type:"Date",      	Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"ym",   			KeyField:0,   CalcLogic:"",   Format:"Ym",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:7 },
			{Header:"총액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"비과세액or감면세액",	Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"notaxMon",  	KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"과세액",		Type:"AutoSum",		Hidden:0,  Width:80,	Align:"Right",  ColMerge:0,   SaveName:"taxMon",		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);

		sheet2.SetCountPosition(0);


        var adjustTypeList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd=C00303",false).codeList, "전체");
        var adjTypeCmbList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(), "queryId=getYearEndItems",false).codeList, "전체");

		$("#srchAdjustType").html(adjustTypeList["C00303"][2]).val("1");
		sheet1.SetColProperty("adjustType",    {ComboText:adjustTypeList["C00303"][0], ComboCode:adjustTypeList["C00303"][1]} );

		sheet2.SetColProperty("adjustType",	{ComboText:"|"+adjustTypeList["C00303"][0], ComboCode:"|"+adjustTypeList["C00303"][1]} );
        sheet2.SetColProperty("adjElementCd",	{ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );

    	// 사업장(권한 구분)
    	var ssnSearchType = "${ssnSearchType}";
    	var bizPlaceCdList = "";

    	if(ssnSearchType == "A"){
            bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getBizPlaceCdList",false).codeList, "전체");
        }else{
            bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getBizPlaceCdAuthList",false).codeList, "");
        }

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");
	});

	$(function() {
		$("#srchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#srchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
			var param = $("#srchFrm").serialize();
			sheet1.DoSearch( "/YearIncomeMgr.do?cmd=getYearIncomeMgrList", param );
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        }
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
            if (Msg != "") {
                alert(Msg);
            }
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
            if (Msg != "") {
                alert(Msg);
            }
			if(Code > 0) {
				doAction1('Search');
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 클릭시 발생.
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
				yearIncomeMgrPopup(Row) ;
		    }
		}catch(ex){
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	//Sheet Action2
    function doAction2(sAction) {

   		switch (sAction) {
        case "Search":
		    var adjElementCdList = stfConvCode( codeList("/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "");

			sheet2.SetColProperty("adjElementCd",    {ComboText:"|"+adjElementCdList[0], ComboCode:"|"+adjElementCdList[1]} );

			var param = "cmd=selectYearIncomeEachMgrEtc&srchYear=srchYear&srchAdjustType=srchAdjustType&srchSabun=srchSabun";
			sheet2.DoSearch( "/yearIncomeEachMgr/yearIncomeEachMgrRst.jsp", param, 1 );
     	   	break;
		}
    }


  	//클릭시 발생
    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
    	try{
    		if(sheet1.GetSelectRow() > 0) {
    			if(OldRow != NewRow){

    				var str = "";
    				str += "(  ";
    				str += "사번 : ";
    				str += sheet1.GetCellValue(NewRow, "sabun");
    				str += ", 성명 : ";
    				str += sheet1.GetCellValue(NewRow, "name");
    				str += "  )";

    				$("#yearIncomeMgrEtcInfo").show();
    				$("#yearIncomeMgrEtcInfo").html(str);

    				var param = "srchYear="+sheet1.GetCellValue(NewRow, "workYy")
    				+"&srchAdjustType="+sheet1.GetCellValue(NewRow, "adjustType")
    				+"&srchSabun="+sheet1.GetCellValue(NewRow, "sabun");

    				sheet2.DoSearch( "/YearIncomeMgr.do?cmd=getYearIncomeMgrEtc", param, 1 );
    			}
    		}

    	}catch(ex){
    		alert("OnClick Event Error : " + ex);
    	}
    }

    //조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
    	try {
            if (Msg != "") {
                alert(Msg);
            }
    		sheetResize();
    	} catch (ex) {
    		alert("OnSearchEnd Event Error : " + ex);
    	}
    }


	var pGubun = "";

	/**
	 * 월별 내역 팝업
	 */
	function yearIncomeMgrPopup(Row){

  		var w 		= 800;
		var h 		= 700;
		var url 	= "/yearIncomeMgr/yearIncomeMgrPopup.jsp?authPg=${authPg}";
		var args 	= new Array();
		args["srchSabun"] 		= sheet1.GetCellValue(Row, "sabun");
		args["srchAdjustType"] 	= sheet1.GetCellValue(Row, "adjustType");
		args["srchYear"] 		= sheet1.GetCellValue(Row, "workYy");
		args["titleName"] 		= sheet1.GetCellValue(Row, "name");

		if(!isPopup()) {return;}
		pGubun = "yearIncomeMgrPopup";
		var rv = openPopup(url,args,w,h);
		/*
		if(rv!=null){
			doAction1('Search') ;
		}
		*/
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "yearIncomeMgrPopup" ){
			doAction1('Search') ;
		}
	}
</script>
</head>
<body class="bodywrap" style="overflow-y: auto;">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
        <tr>
            <td>
            	<span>년도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="srchYear" name ="srchYear" type="text" class="text center" maxlength="4" style="width:20%"/>
				<%}else{%>
					<input id="srchYear" name ="srchYear" type="text" class="text center" maxlength="4" style="width:20%"/>
				<%}%>
			</td>
			<td>
				<span>작업구분</span>
				<select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
            <td>
                <span>사업장</span>
                <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
            </td>
			<td>
				<span>사번/성명</span>
				<input id="srchSbNm" name ="srchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
			</td>
            <td>
            	<a href="javascript:doAction1('Search');" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">연간소득</li>
            <li class="btn">
              <a href="javascript:doAction1('Down2Excel')" class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "400px"); </script>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기타소득사항&nbsp;&nbsp;<span id="yearIncomeMgrEtcInfo" class="txt" style="display: none;"></span></li>
            <li class="btn"></li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "200px"); </script>
</div>
</body>
</html>