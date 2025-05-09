<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var selectSheet = null;
		// 전달 받은 값
		$("#srchSeq").val("${srchSeq}");
// 		$("#srchViewCd").val("${srchViewCd}");
// 		$("#srchNiewNm").val("${srchNiewNm}");
		$("#pwrDesc").html(ajaxCall("${ctx}/PwrSrchUser.do?cmd=getPwrSrchUserDetailDescMap",$("#sheetForm").serialize(),false ).condDesc );

		var inqTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var valueTypeCd	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20030"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var operTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S50020"), "<tit:txt mid='103895' mdef='전체'/>",-1);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"searchSeq",	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",	Type:"Text",      Hidden:0,  Width:138,  Align:"Left",    ColMerge:0,   SaveName:"columnNm",	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"seq",    		KeyField:0, Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='orderBySeq' mdef='정렬순서'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orderBySeq",  KeyField:0, Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='ascDesc' mdef='정렬구분'/>",	Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ascDesc", 	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='inqType' mdef='조회형태'/>",	Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"inqType", 	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4); sheet1.SetVisible(true);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetColProperty("acsDesc", {ComboText:"올림차순|내림차순", 	ComboCode:"ASC|DESC"} );
		sheet1.SetColProperty("inqTYpe", {ComboText:inqTypeCd[0], 		ComboCode:inqTypeCd[1]} );

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>", 		Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,SaveName:"searchSeq",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>", 		Type:"Text",	Hidden:0,  Width:80,	Align:"Left",	ColMerge:0,	SaveName:"columnNm", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='searchItemCdV1' mdef='코드항목CD'/>", 	Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"itemMapType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='prgUrl_V6688' mdef='항목명구분'/>", 	Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"prgUrl",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>", 	Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"sqlSyntax",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>", 	Type:"Combo",   Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"operator",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>", 		Type:"Combo",   Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"valueType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='operator' mdef='연산자'/>", 		Type:"Text",    Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"searchItemCd",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Text",    Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"searchItemNm",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='inputValue' mdef='조건값'/>", 		Type:"Text",    Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"inputValue",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='inputValue' mdef='조건값'/>", 		Type:"Popup",   Hidden:0,  Width:360,  	Align:"Left",   ColMerge:0,	SaveName:"inputValueDesc", KeyField:0,CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"AND\nOR", 	Type:"Combo",   Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"andOr",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Text",    Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='condType' mdef='조건항목구분'/>", 	Type:"Text",    Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"condType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		];IBS_InitSheet(sheet2, initdata);sheet2.SetCountPosition(4); sheet2.SetVisible(true);
		sheet2.SetColProperty("andOr", 	{ComboText:"AND|OR", ComboCode:"AND|OR"} );
		sheet2.SetColProperty("operator", {ComboText:operTypeCd[0], ComboCode:operTypeCd[1]} );
		sheet2.SetColProperty("valueType",{ComboText:valueTypeCd[0], ComboCode:valueTypeCd[1]} );

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",      Hidden:1,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"searchSeq",		KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",      Hidden:0,  Width:120,	Align:"Left",    ColMerge:0,   SaveName:"columnNm",			KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='searchItemCdV1' mdef='코드항목CD'/>",	Type:"Text",      Hidden:1,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"itemMapType",		KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='prgUrl_V6688' mdef='항목명구분'/>",	Type:"Text",      Hidden:1,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"prgUrl",			KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='itemMapType' mdef='항목맵핑구분'/>",	Type:"Text",      Hidden:1,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"sqlSyntax",		KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>",	Type:"Combo",     Hidden:0,  Width:0,	Align:"Center",  ColMerge:0,   SaveName:"operator",			KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='sqlSyntax' mdef='SQL문'/>",			Type:"Combo",     Hidden:0,  Width:0,	Align:"Center",  ColMerge:0,   SaveName:"valueType",		KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='operator' mdef='연산자'/>",		Type:"Text",      Hidden:1,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"searchItemCd",		KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='valueType' mdef='조건입력방법'/>",	Type:"Popup",     Hidden:0,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"searchItemNm",		KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='inputValue' mdef='조건값'/>",		Type:"Text",      Hidden:1,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"inputValue",		KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='inputValue' mdef='조건값'/>",		Type:"Popup",     Hidden:0,  Width:355,	Align:"Left",    ColMerge:0,   SaveName:"inputValueDesc",	KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"AND\nOR",		Type:"Combo",     Hidden:0,  Width:0,	Align:"Center",  ColMerge:0,   SaveName:"andOr",           KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Float",     Hidden:0,  Width:0,	Align:"Center",  ColMerge:0,   SaveName:"seq",				KeyField:0,	Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='condType' mdef='조건항목구분'/>",	Type:"Text",      Hidden:1,  Width:0,	Align:"Left",    ColMerge:0,   SaveName:"condType",			KeyField:0,	Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" }
		];IBS_InitSheet(sheet3, initdata);sheet3.SetCountPosition(4);sheet3.SetVisible(true);
		sheet3.SetColProperty("andOr", 	{ComboText:"AND|OR", 		ComboCode:"AND|OR"} );
		sheet3.SetColProperty("operator", {ComboText:operTypeCd[0], 	ComboCode:operTypeCd[1]} );
		sheet3.SetColProperty("valueType",{ComboText:valueTypeCd[0], 	ComboCode:valueTypeCd[1]} );

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",      	Hidden:1,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"searchSeq",		KeyField:0, Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='viewCdV1' mdef='뷰코드'/>",	Type:"Text",      	Hidden:0,  	Width:138,  Align:"Left",    ColMerge:0,   SaveName:"viewCd",		KeyField:0, Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
			{Header:"<sht:txt mid='adminSqlSyntax' mdef='Admin쿼리'/>",	Type:"Text",      	Hidden:1,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"adminSqlSyntax",KeyField:0, Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
			{Header:"<sht:txt mid='sqlSyntaxV1' mdef='쿼리'/>",		Type:"Text",      	Hidden:1,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sqlSyntax",  	KeyField:0, Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" }
		];IBS_InitSheet(sheet4, initdata);sheet4.SetCountPosition(4);sheet4.SetVisible(true);
		sheet4.SetColProperty("inqTYpe", {ComboText:inqTypeCd[0], 		ComboCode:inqTypeCd[1]} );

// 		var authGrp 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getAthGrpMenuMgrGrpCdList","",false).codeList, "");
		$(window).smartresize(sheetResize);
		sheetInit();
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	    $( "#date" ).datepicker();
	    makeDesc();
	});
	function makeDesc(){
  		if(sheet3.GetCellValue(1, "inputValue") != ""){
            for(row = 1 ; row <= sheet3.LastRow() ; row++){
            	$("#pwrDesc").val( $("#pwrDesc").val() + "☞ "+addStrRear(sheet3.GetCellValue(row, "columnNm"))+ "  "+sheet3.GetCellValue(row, "inputValueDesc")+" ");
                if(sheet3.GetCellValue(row, "andOr") == "AND"){
                   $("#pwrDesc").val( $("#pwrDesc").val()+"이고</BR>" );
                }else{
                    document.all.pwrDesc.value = document.all.pwrDesc.value + "이거나</BR>";
                }
            }
            document.all.pwrDesc.value = document.all.pwrDesc.value + "</BR>";
        }
        if(sheet2.RowCount() > 0){
            for(row = 1 ; row <= sheet2.LastRow() ; row++){
            	$("#pwrDesc").val( $("#pwrDesc").val() + "☞ "+addStrRear(sheet3.GetCellValue(row, "columnNm"))+ "  [아래조건참조]");
                if(sheet2.GetCellValue(row, "andOr") == "AND"){
                	$("#pwrDesc").val( $("#pwrDesc").val() +"이고<br/>" );
                }else{
                	$("#pwrDesc").val( $("#pwrDesc").val() + "이거나,<br/>" );
                }
            }
        }
    }
    function addStrRear(src){
        loop = 20 - src.length*2;
        for(i=0 ; i < loop ; i++){
            src = src + " ";
        }
        return src;
    }
    function makeQuery(){
        sendQuery = "SELECT ";
        sendQuery = sendQuery + selectElement();
        sendQuery = sendQuery + "  FROM " + "__EXCHANGE__VIEW__NM__" + "\n";
        sendQuery = sendQuery + conditionStatement();
        return sendQuery;
    }
    function selectElement(){
        element = "";
        loop = sheet1.LastRow()+1;
        for(i=1 ; i < loop ; i++){
            element = element + sheet1.GetCellValue(i, "columnNm") + ",";
        }
        element = element.substring(0, element.length-1)+"\n";
        return element;
    }
    function conditionStatement(){
        condition = "";
        if(sheet3.RowCount() > 0){
            loop = sheet3.LastRow()+1;
            condition = " WHERE " + sheet3.GetCellValue(1, "columnNm") + " " +sheet3.GetCellText(1, "operator")+" " + sheet3.GetCellValue(1, "inputValue")+ "\n";
            for(i=2 ; i < loop ; i++){
                condition = condition + "   AND " + sheet3.GetCellValue(i, "columnNm") + " " +sheet3.GetCellText(i, "operator")+" " +sheet3.GetCellValue(i, "inputValue")+ "\n";
            }
        }

        if(sheet2.RowCount() > 0){
            loop = sheet2.LastRow()+1;
            if(condition.length == 0){
                condition = condition+" WHERE " + sheet2.GetCellValue(1, "columnNm") + " " +sheet2.GetCellText(1, "operator")+" " +sheet2.GetCellValue(1, "inputValue")+ "\n";
            }else{
                condition = condition+"   AND " + sheet2.GetCellValue(1, "columnNm") + " " +sheet2.GetCellText(1, "operator")+" " +sheet2.GetCellValue(1, "inputValue")+ "\n";
            }
            for(i=2 ; i < loop ; i++){
                condition = condition + "   AND " + sheet2.GetCellValue(i, "columnNm") + " " +sheet2.GetCellText(i, "operator")+" " +sheet2.GetCellValue(i, "inputValue")+ "\n";
            }
        }
        return condition;
    }
    function openResult(){

        if(sheet2.FindStatusRow("I|S|D|U") != ""){
            doAction5('Save');
        }

        searchSearchSeq = document.form.searchSearchSeq.value;
        var win=CenterWin("/JSP/popup/PwrSrchResult_popup.jsp?searchSearchSeq="+searchSearchSeq, "PwrSrchResult_popup", "scrollbars=no, status=no, width=940, height=600, top=0, left=0");
    }
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	sheet1.DoSearch( "${ctx}/PwrSrchAdminUser.do?cmd=getPwrSrchAdminUserSht1List", $("#sheetForm").serialize() ); break;
		}
	}
	//Sheet Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#srchCondType").val("U");
			sheet2.DoSearch( "${ctx}/PwrSrchAdminUser.do?cmd=getPwrSrchAdminUserSht1List", $("#sheetForm").serialize() );
			break;
		case "Save":
			var param = "&searchSeq2="+$("#srchSeq").val()+"&sqlSyntax2="+makeQuery();
			if(sheet2.GetCellValue(Row, "sStatus") != ""){
				IBS_SaveName(document.sheetForm,sheet2);
                sheet2.DoSave("${ctx}/PwrSrchUser.do?cmd=savePwrSrchUser", $("#sheetForm").serialize()+param);
            }
         	break;
		}
	}
	//Sheet Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search": 	$("#srchCondType").val("F");
						sheet2.DoSearch( "${ctx}/PwrSrchUser.do?cmd=getPwrSrchUserSht2List", $("#sheetForm").serialize() );
						break;
		}
	}
	//Sheet Action
	function doAction4(sAction) {
		switch (sAction) {
		case "Save":
			var param = "&searchSeq2="+$("#srchSeq").val()+"&sqlSyntax2="+makeQuery();
			if(sheet2.GetCellValue(Row, "sStatus") != ""){
				IBS_SaveName(document.sheetForm,sheet2);
                sheet2.DoSave("${ctx}/PwrSrchUser.do?cmd=savePwrSrchUser", $("#sheetForm").serialize()+param);
            }
            break;
		}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg){
		try{ if(Msg != "") alert(Msg); sheetResize(); }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
	  	try{
	    	// Insert KEY
	    	if(Shift == 1 && KeyCode == 45){
	    		doAction2("Insert");
	    	}
	    	//Delete KEY
	    	if(Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row,"sStatus") == "I"){
	        	sheet1.SetCellValue(Row,"sStatus","D");
	    	}
	  	}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg){
		try{
			if(Msg != "") alert(Msg); sheetResize();
			for(row = 1 ; row <= sheet2.LastRow() ; row++){
		        if(    sheet2.GetCellValue(row, "valueType") == "dfCompany"
		            || sheet2.GetCellValue(row, "valueType") == "dfSabun"
		            || sheet2.GetCellValue(row, "valueType") == "dfBaseDate"){
		        	sheet2.SetCellEditable(row, "inputValueDesc",false);
		        }
		    }
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	function sheet2_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
		        // =  =  변환삭제 [확인요망]  =  = >>sendErrMsg(ErrMsg, GetTransColText("I|U|D", "sStatus"));
		        displayErrMsg();
		    }
		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}
	function sheet2_OnChange(Row, Col, Value){
		try{
			if(    Row > 0 && sheet2.ColSaveName(Col) == "searchItemCd"
		        || sheet2.ColSaveName(Col) == "searchItemCd"
		        || sheet2.ColSaveName(Col) == "valueType"
		        || sheet2.ColSaveName(Col) == "operator"){
				sheet2.SetCellValue(Row, "inputValue","");
				sheet2.SetCellValue(Row, "inputValueDesc","");
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
		    // Insert KEY
		    if(Shift == 1 && KeyCode == 45){
		        doAction2("Insert");
		    }
		    //Delete KEY
		    if(Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row,"sStatus") == "I"){
		        sheet2.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}
// 	셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			selectSheet = sheet2;
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function sheet2_OnChange(Row, Col, Value){
		try{
			if(    Row > 0 && sheet2.ColSaveName(Col) == "searchItemCd"
		        || sheet2.ColSaveName(Col) == "searchItemCd"
		        || sheet2.ColSaveName(Col) == "valueType"
		        || sheet2.ColSaveName(Col) == "operator"){
		        sheet2.SetCellValue(Row, "inputValue","");
		        sheet2.SetCellValue(Row, "inputValueDesc","");
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	function sheet2_OnPopupClick(Row, Col){
		try{
			if(Row > 0 && sheet2.ColSaveName(Col) == "inputValueDesc"){
				var url	= "${ctx}/PwrSrchUser.do?cmd=pwrSrchUserPopup";
				var rv 	= openPopup(url, "", "640","580");
				if(rv!=null){
					mySheet.SetCellValue(Row, "inputValueDesc", 	rv["inputValueDesc"] );
				}
		    }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}


	/**
	* 상세내역 window open event
	*/
	function codeDetailPopup(Row){
  		var w 		= 640;
		var h 		= 580;
		var url 	= "${ctx}/PwrSrchCdElemtMgr.do?cmd=pwrSrchCdElemtMgrPopup"+"&searchItemCd="+mySheet.GetCellValue(Row,"searchItemCd");
		var args 	= new Array();
		args["searchItemCd"] 	= mySheet.GetCellValue(Row, "searchItemCd");
		args["searchItemNm"] 	= mySheet.GetCellValue(Row, "searchItemNm");
		args["searchItemDesc"] 	= mySheet.GetCellValue(Row, "searchItemDesc");
		args["itemMapType"] 	= mySheet.GetCellValue(Row, "itemMapType");
		args["prgUrl"] 			= mySheet.GetCellValue(Row, "prgUrl");
		args["sqlSyntax"] 		= mySheet.GetCellValue(Row, "sqlSyntax");
		//var rv = window.showModalDialog(url, args, "dialogHeight="+h+"px; dialogWidth="+w+"px; scroll=no; status=no; help=no; center=yes");
		var rv = openPopup(url,args,w,h);
		if(rv!=null){
			mySheet.SetCellValue(Row, "searchItemNm", 	rv["searchItemNm"] );
			mySheet.SetCellValue(Row, "searchItemDesc", rv["searchItemDesc"] );
			mySheet.SetCellValue(Row, "itemMapType", 	rv["itemMapType"] );
			mySheet.SetCellValue(Row, "prgUrl", 		rv["prgUrl"] );
			mySheet.SetCellValue(Row, "sqlSyntax", 		rv["sqlSyntax"] );
		}
	}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm">
		<input id="srchSeq" 		name="srchSeq" 		type="hidden"/>
		<input id="srchViewCd" 		name="srchViewCd" 	type="hidden"/>
		<input id="srchViewNm" 		name="srchViewNm" 	type="hidden"/>
		<input id="srchCondType" 	name="srchCondType" type="hidden"/>
	</form>
	<div class="explain position_top outer">
		<div class="title"><tit:txt mid='pwrSrchAdminUser2' mdef='조회조건설명'/></div>
		<div class="txt">
			<ul>
				<li>
					<div id="pwrDesc" class="scroll"></div>
				</li>
			</ul>
		</div>
	</div>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='114039' mdef='조회항목'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%","${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='112273' mdef='사용자입력 조건항목 설정'/></li>
						<li class="btn">
							<btn:a css="basic authR" onclick="javascritp:openResult();" mid='110710' mdef="검색결과"/>
							<a class="basic authA" onclick="javascritp:doAction2('Save');"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet2", "50%", "100%","${ssnLocaleCd}"); </script>
		</td>
	</table>
	<div id="tmpRow1" style="display:none">
    	<script type="text/javascript">createIBSheet("sheet3", "100%", "100%", "${ssnLocaleCd}");</script>
	</div>
	<div id="tmpRow2" style="display:none">
    	<script type="text/javascript">createIBSheet("sheet4", "100%", "100%", "${ssnLocaleCd}");</script>
	</div>
</div>
</body>
</html>
