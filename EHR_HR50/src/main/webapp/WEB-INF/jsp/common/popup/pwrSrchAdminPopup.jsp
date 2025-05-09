<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var openSheet 		= null;
	var srchSeq 		= null;
	var openChartType	= null;
	var elemDetail 		= null;
	var selectSheet 	= null;
	var saveMsgFlag1 	= true ;//sheet1저장 후 메시지 출력여부
	var saveMsgFlag2 	= true ;//sheet2저장 후 메시지 출력여부
	var saveMsgFlag3 	= true ;//sheet3저장 후 메시지 출력여부
	var gPRow 			= "";
	var pGubun 			= "";

	$(function() {
		var arg = p.popDialogArgumentAll();

		if( arg != undefined ) {
			openSheet = p.popDialogSheet(arg["openSheet"]);
		}
		//openSheet = dialogArguments["openSheet"];

		srchSeq = openSheet.GetCellValue( openSheet.GetSelectRow(), "searchSeq" ) ;
		$("#srchDesc").val(openSheet.GetCellValue( openSheet.GetSelectRow(), "searchDesc" ));
		$("#srchSeq").val(srchSeq);
		
		openChartType = openSheet.GetCellValue( openSheet.GetSelectRow(), "chartType" ) ;
		
		var inqTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var valueTypeCd	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20030"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var operTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S50020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var alignCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20100"), "",-1);
		var initdata = {};

		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5'    mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus'       mdef='상태'/>",		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='searchSeqV1'   mdef='검색순번'/>",	Type:"Text",		Hidden:1,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"searchSeq",	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",		Hidden:0,  	Width:180,  Align:"Left",    ColMerge:0,   SaveName:"columnNm",		KeyField:0, Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq'      mdef='순서'/>",		Type:"Float",		Hidden:0,  	Width:70,	Align:"Center",  ColMerge:0,   SaveName:"seq",    		KeyField:0, Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertE1it:1,   EditLen:20 },
			{Header:"<sht:txt mid='orderBySeq'    mdef='정렬순서'/>",	Type:"Text",		Hidden:1,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orderBySeq",  	KeyField:0, Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='ascDesc'       mdef='정렬구분'/>",	Type:"Combo",		Hidden:0,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ascDesc", 		KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='inqType'       mdef='조회형태'/>",	Type:"Combo",		Hidden:0,  	Width:120,	Align:"Center",  ColMerge:0,   SaveName:"inqType", 		KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='mergeYn'       mdef='병합여부'/>",	Type:"Combo",		Hidden:0,  	Width:80,	Align:"Center",  ColMerge:0,   SaveName:"mergeYn", 		KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='subSumType'    mdef='소계여부'/>",	Type:"Combo",		Hidden:0,  	Width:80,	Align:"Center",  ColMerge:0,   SaveName:"subSumType", 	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"Align",											Type:"Combo",		Hidden:0,  	Width:50,	Align:"Center",  ColMerge:0,   SaveName:"align", 		KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"Width",											Type:"Text",		Hidden:0,  	Width:50,	Align:"Center",  ColMerge:0,   SaveName:"widthRate", 	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },			
			{Header:"<sht:txt mid='chartStd'  mdef='차트기준설정'/>",	Type:"Combo",		Hidden:(openChartType ? 0 : 1),  	Width:70,	Align:"Center",  ColMerge:0,   SaveName:"chartStd", 	KeyField:0, Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }			
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4); sheet1.SetVisible(true);
		sheet1.SetColProperty("ascDesc", {ComboText:"올림차순|내림차순",	ComboCode:"ASC|DESC"} );
		sheet1.SetColProperty("align", {ComboText:alignCd[0], 		ComboCode:alignCd[1]} );
		sheet1.SetColProperty("inqType", {ComboText:inqTypeCd[0], 		ComboCode:inqTypeCd[1]} );
		sheet1.SetColProperty("mergeYn", {ComboText:"N|Y",	ComboCode:"N|Y"} );
		sheet1.SetColProperty("subSumType", {ComboText:" |기준|소계|평균",	ComboCode:"-|STD|SUM|AVG"} );
		sheet1.SetColProperty("chartStd", {ComboText:" |기준|기준(값)|퍼센트(%)",	ComboCode:" |KEY|VALUE|PER"} );

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'            mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus'        mdef='상태'/>",		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" , Sort:0},
			{Header:"<sht:txt mid='searchSeqV1'    mdef='검색순번'/>", 	Type:"Text",	Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemNm'  mdef='항목명'/>", 		Type:"Text",	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,	SaveName:"columnNm", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='itemMapType'    mdef='항목맵핑구분'/>", 	Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"itemMapType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='prgUrl'         mdef='프로그램URL'/>", 	Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"prgUrl",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='sqlSyntax' 	   mdef='SQL문'/>", 		Type:"Text",	Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"sqlSyntax",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='operator'       mdef='연산자'/>", 		Type:"Combo",   Hidden:0,  Width:80,	Align:"Center", ColMerge:0,	SaveName:"operator",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='valueType'      mdef='조건입력방법'/>",	Type:"Combo",   Hidden:0,  Width:130,	Align:"Center", ColMerge:0,	SaveName:"valueType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='searchItemCdV1' mdef='코드항목CD'/>", 	Type:"Text",    Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"searchItemCd",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='searchItemNmV1' mdef='코드선택'/>",		Type:"Popup",   Hidden:0,  Width:150,	Align:"Left",   ColMerge:0,	SaveName:"searchItemNm",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='inputValue'     mdef='조건값'/>", 		Type:"Text",    Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"inputValue",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='inputValue'     mdef='조건값'/>", 		Type:"Popup",   Hidden:0,  Width:200,  	Align:"Left",   ColMerge:0,	SaveName:"inputValueDesc", KeyField:0,CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='andOrV1'        mdef='AND/\nOR'/>", 	Type:"Combo",   Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"andOr",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"표시여부",		Type:"CheckBox",	Hidden:0, Width:55,	Align:"Center",	ColMerge:0,	SaveName:"viewYn",	KeyField:0,	Format:"", UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
            {Header:"<sht:txt mid='agreeSeq'       mdef='순서'/>",		Type:"Float",   Hidden:0,  Width:55,    	Align:"Center", ColMerge:0,	SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='condType'      mdef='조건항목구분'/>", 	Type:"Text",    Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"condType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		];IBS_InitSheet(sheet2, initdata);sheet2.SetCountPosition(4); sheet2.SetVisible(true);
		sheet2.SetColProperty("andOr", 	{ComboText:"AND|OR", ComboCode:"AND|OR"} );
		sheet2.SetColProperty("operator", {ComboText:operTypeCd[0], ComboCode:operTypeCd[1]} );
		sheet2.SetColProperty("valueType",{ComboText:valueTypeCd[0], ComboCode:valueTypeCd[1]} );


		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" , Sort:0},
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",      	Hidden:0,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"searchSeq", 		KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='conditionDesc' mdef='쿼리설명'/>",	Type:"Text",      	Hidden:0,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"conditionDesc",  	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
            {Header:"<sht:txt mid='sqlSyntaxV1' mdef='쿼리'/>",		Type:"Text",      	Hidden:0,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"adminSqlSyntax",  KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:99999999999 },
        ];IBS_InitSheet(sheet3, initdata);sheet3.SetCountPosition(4); sheet3.SetVisible(true);

		$(window).smartresize(sheetResize); sheetInit();

	    $(".close").click(function() { p.self.close(); });
	    $( "#tabs" ).tabs({activate:
	    	function( event, ui ) {
	    		if( ui.oldPanel.attr("id") == "tabs-1" ) {
	    			saveMsgFlag3 = false ;
	    			doAction3('sqlSave');
	    		} else { saveMsgFlag3 = true ; }
	    		sheetResize();
	    	}
	    });

		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
		//elemDetail = ajaxCall("${ctx}/PwrSrchAdminPopup.do?cmd=getPwrSrchAdminPopupElemDetailList",$("#sheetForm").serialize(),false);


	});
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	sheet1.DoSearch( "${ctx}/PwrSrchAdminPopup.do?cmd=getPwrSrchAdminPopupElemList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
			    if(!dupChk(sheet1,"columnNm", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=savePwrSrchAdminPopupElem", $("#sheetForm").serialize() );
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row,"searchSeq",srchSeq);
			break;
		}
	}
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":	sheet2.DoSearch( "${ctx}/PwrSrchAdminPopup.do?cmd=getPwrSrchAdminPopupConditionList", $("#sheetForm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=savePwrSrchAdminPopupCondition", $("#sheetForm").serialize() ); break;
		case "Insert":	var Row = sheet2.DataInsert(0); break;
		}
	}

	function doAction3(sAction) {
		switch (sAction) {
		case "Search":	sheet3.DoSearch( "${ctx}/PwrSrchAdminPopup.do?cmd=getPwrSrchAdminPopupElemDetailList",$("#sheetForm").serialize() ); break;
		case "sqlSave":
			var Row = sheet3.DataInsert(0);
			if( !checkQeury($("#sqlTxt").val()) ) { return ; }
			else {
				/* 사용자입력 조건항목 자동설정 by JSG */
				mvUserConfitionElement() ;
			}
			/*
			 if(sheet1.FindStatusRow("I|S|D|U") != ""){
                	 saveMsgFlag1 = false ; //저장메시지 출력 하지 않음
                	 sheet1.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=savePwrSrchAdminPopupElem", "", -1, false );
             }
			*/
             if(sheet2.FindStatusRow("I|S|D|U") != ""){
                 //if(confirm("사용자조회조건도 저장하시겠습니까?")){
                	 saveMsgFlag2 = false ; //저장메시지 출력 하지 않음
                	 IBS_SaveName(document.sheetForm,sheet2);
                	 sheet2.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=savePwrSrchAdminPopupCondition",$("#sheetForm").serialize(), -1, false );
                	 sheet2.SetColHidden(1, true) ;
                 //}
             }

 			sheet3.SetCellValue(Row,"adminSqlSyntax",	$("#sqlTxt").val() );
			sheet3.SetCellValue(Row,"srchSeq",			$("#srchSeq").val() );
			IBS_SaveName(document.sheetForm,sheet3);
			sheet3.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=updatePwrSrchAdminPopupSql" ,$("#sheetForm").serialize(), -1, false);
			break;
		case "sqlDescSave":
			var Row = sheet3.DataInsert(0);
			sheet3.SetCellValue(Row,"conditionDesc",	$("#sqlDescTxt").val() );
			IBS_SaveName(document.sheetForm,sheet3);
			sheet3.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=updatePwrSrchAdminPopupSqlDesc" ,$("#sheetForm").serialize());
			break;
		}
	}

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize(); }
		catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "" && saveMsgFlag1) {
				alert(Msg) ;
			} else {
				saveMsgFlag1 = false ;
			}
		}
		catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}

	function sheet1_OnChange(Row,Col,Value){
		if(sheet1.ColSaveName(Col) == "subSumType") {
			if(Value == "STD") {
				var stdColCnt = 0;
				for(var i = 1 ; i <= sheet1.LastRow() ; i++){
					if(sheet1.GetCellValue(i, "subSumType") == "STD") {
						stdColCnt++;
					}
				}
				if(stdColCnt > 1) {
					alert("<msg:txt mid='alertStdOneSetting' mdef='기준컬럼은 한개이상 설정 불가합니다.'/>");
					sheet1.SetCellValue(Row,Col, "-");
					return;
				}
			}

			if(Value == "SUM" || Value == "AVG") {
				if(sheet1.GetCellValue(Row, "inqType") != "Float" && sheet1.GetCellValue(Row, "inqType") != "Number") {
					alert("<msg:txt mid='alertNotInteger' mdef='숫자형이 아닌 컬럼에 지정 불가합니다.'/>");
					sheet1.SetCellValue(Row,Col,"-");
					return;
				}
			}
		}
		
		//차트기준설정 값이 한개만 들어가게 변경
		if ( sheet1.ColSaveName(Col) == "chartStd") {
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if (i != Row && Value == sheet1.GetCellValue(i, "chartStd")) {
					sheet1.SetCellValue(i, "chartStd", "");
				}
			}
		}


	}

	function sheet2_OnPopupClick(Row, Col){
		console.log('sheet2 popup click event');
		
		try {
			if(Row > 0 && sheet2.ColSaveName(Col) == "searchItemNm"){
				//if(!isPopup()) {return;}

				var url 	= "${ctx}/PwrSrchElemPopup.do?cmd=pwrSrchElemPopup";
				var args 	= new Array();

				gPRow = Row;
				pGubun = "pwrSrchElemPopup";

				var rv = openPopup(url,args,640,580);
				if(rv!=null){
				}
	    	}
			if(Row > 0 && sheet2.ColSaveName(Col) == "inputValueDesc"){
				//if(!isPopup()) {return;}

		    	var args 	= new Array();
				args["sheet"] 	= "sheet2";
				var url	= "${ctx}/PwrSrchInputValuePopup.do?cmd=pwrSrchInputValuePopup&authPg=${authPg}&adminFlag=Yes";
				openPopup(url, args, "840","680");
		    }

		} catch (ex) { alert("OnPopupClick Event Error " + ex); }
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "pwrSrchElemPopup") {
			sheet2.SetCellValue(gPRow, "searchItemCd", 	rv["searchItemCd"] );
			sheet2.SetCellValue(gPRow, "searchItemNm", 	rv["searchItemNm"] );
			sheet2.SetCellValue(gPRow, "searchItemDesc", rv["searchItemDesc"] );
			sheet2.SetCellValue(gPRow, "itemMapType", 	rv["itemMapType"] );
			sheet2.SetCellValue(gPRow, "prgUrl", 		rv["prgUrl"] );
			sheet2.SetCellValue(gPRow, "sqlSyntax", 	rv["sqlSyntax"] );
       }
	}

	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } 
			for(row = 1 ; row <= sheet2.LastRow() ; row++){
	            if(sheet2.GetCellValue(row, "valueType") == "dfCode"){
	            	sheet2.SetCellEditable(row,"searchItemNm",true);
	            }else if( sheet2.GetCellValue(row, "valueType") == "dfCompany"
	                   || sheet2.GetCellValue(row, "valueType") == "dfSabun"
	                   || sheet2.GetCellValue(row, "valueType") == "dfBaseDate"
	                   || sheet2.GetCellValue(row, "valueType") == "dfToday"
		               || sheet2.GetCellValue(row, "valueType") == "dfSearchTy"
			           || sheet2.GetCellValue(row, "valueType") == "dfGrpCd"){
	       			sheet2.SetCellEditable(row,"searchItemNm",false);
	           		sheet2.SetCellEditable(row,"valueType",false);
	            	sheet2.SetCellEditable(row,"inputValueDesc",false);
	            }
	        }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "" && saveMsgFlag2) {
				alert(Msg) ;
			} else {
				saveMsgFlag2 = false ;
			}
		}
		catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
		    selectSheet = sheet2;
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	function sheet2_OnChange(Row,Col,Value){
		try{
			if(Row > 0 && sheet2.ColSaveName(Col) == "operator"){
		        sheet2.SetCellValue(Row, "inputValue",checkLike(''));
		        sheet2.SetCellValue(Row, "inputValueDesc","");
		        checkIsNull(sheet2, Row, Col);
		    }else if(Row > 0 && sheet2.ColSaveName(Col) == "valueType"){
		        if(Value == "dfCode"){
		            sheet2.SetCellEditable(Row,"searchItemNm",true);
		        }else{
		            sheet2.SetCellEditable(Row,"searchItemNm",false);
		            sheet2.SetCellValue(Row,"searchItemCd","");
		            sheet2.SetCellValue(Row,"searchItemNm","");
		        }
		        if(Value == "dfCompany"){
		            sheet2.SetCellValue(Row, "inputValue","dfCompany");
		            sheet2.SetCellValue(Row, "inputValueDesc","해당 회사");
		            sheet2.SetCellEditable(Row,"searchItemNm",false);
		            sheet2.SetCellEditable(Row,"inputValue",false);
		            sheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSabun"){
		            sheet2.SetCellValue(Row, "inputValue","dfSabun");
		            sheet2.SetCellValue(Row, "inputValueDesc","해당 담당자");
		            sheet2.SetCellEditable(Row,"searchItemNm",false);
		            sheet2.SetCellEditable(Row,"inputValue",false);
		            sheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfBaseDate"){
		            sheet2.SetCellValue(Row, "inputValue","dfBaseDate");
		            sheet2.SetCellValue(Row, "inputValueDesc","적용일자");
		            sheet2.SetCellEditable(Row,"searchItemNm",false);
		            sheet2.SetCellEditable(Row,"inputValue",false);
		            sheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSearchTy"){
		            sheet2.SetCellValue(Row, "inputValue","dfSearchTy");
		            sheet2.SetCellValue(Row, "inputValueDesc","조회타입");
		            sheet2.SetCellEditable(Row,"searchItemNm",false);
		            sheet2.SetCellEditable(Row,"inputValue",false);
		            sheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfGrpCd"){
		            sheet2.SetCellValue(Row, "inputValue","dfGrpCd");
		            sheet2.SetCellValue(Row, "inputValueDesc","권한코드");
		            sheet2.SetCellEditable(Row,"searchItemNm",false);
		            sheet2.SetCellEditable(Row,"inputValue",false);
		            sheet2.SetCellEditable(Row,"inputValueDesc",false);    
		        }else{
		            sheet2.SetCellValue(Row, "inputValue",checkLike(""));
		            sheet2.SetCellValue(Row, "inputValueDesc","");
		            sheet2.SetCellEditable(Row,"inputValue",true);
		            sheet2.SetCellEditable(Row,"inputValueDesc",true);
		        }
		    }else if(Row > 0 && sheet2.ColSaveName(Col) == "searchItemCd"){
		        sheet2.SetCellValue(Row, "inputValue",checkLike(""));
		        sheet2.SetCellValue(Row, "inputValueDesc","");
		    }
		    if(sheet2.GetCellText(Row, "operator").indexOf("NULL") != -1){
		        sheet2.SetCellValue(Row, "inputValue","");
		        sheet2.SetCellValue(Row, "inputValueDesc","");
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			$("#sqlTxt").val( sheet3.GetCellValue(1,"adminSqlSyntax"));
			$("#sqlDescTxt").val( sheet3.GetCellValue(1,"conditionDesc") );
			sheet3.RemoveAll();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "" && saveMsgFlag3) {
				alert(Msg) ;
			} else {
				saveMsgFlag3 = false ;
			}
			doAction2('Search') ;
			sheet3.RemoveAll();
		}
		catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	function openResult(){
		if(!isPopup()) {return;}

		var url	= "${ctx}/PwrSrchResultPopup.do?cmd=pwrSrchResultPopup&authPg=${authPg}";
		openPopup(url, window, "940","580");
	}
	function checkLike(str){
        var SelectRow = selectSheet.GetSelectRow();
        if(selectSheet.GetCellText(SelectRow, "operator").toUpperCase() == "LIKE"
           || selectSheet.GetCellText(SelectRow, "operator").toUpperCase() == "NOT LIKE" ){
            str = "'%"+str+"%'";
        }else{
            str = "'"+str+"'";
        }
        return str;
    }
	function checkIsNull(sht, Row, Col){
        if( sht.GetCellText(Row, Col).toUpperCase() == "IS NULL"
         || sht.GetCellText(Row, Col).toUpperCase() == "IS NOT NULL"){
             sht.SetCellEditable(Row,"valueType",false);
             sht.SetCellEditable(Row,"inputValue",false);
            sht.SetCellEditable(Row,"searchItemNm",false);
            sht.SetCellEditable(Row,"inputValueDesc",false);
        }else{
            sht.SetCellEditable(Row,"valueType",true);
            sht.SetCellEditable(Row,"inputValue",true);
            sht.SetCellEditable(Row,"searchItemNm",true);
            sht.SetCellEditable(Row,"inputValueDesc",true);

            if(sht.GetCellValue(Row, "valueType") != "dfCode") {
            	sht.SetCellEditable(Row,"searchItemNm",false);
        	}
        }
    }
	/*
	* 쿼리문에서 파라매터가 자동으로 추가 되도록 하는 로직 시작 by JSG ---------------------------------------------------
	*/
	function checkQeury(query){
        var tmpQuery = trim(query.toUpperCase());
            tmpQuery = tmpQuery.substring(0,20);
        if(tmpQuery.indexOf("SELECT") == -1 ){
        	alert("<msg:txt mid='alertSqlTabSelect' mdef='SQL구분 탭 : SELECT문만 가능합니다.'/>");
            return false;
        }else{
            return true;
        }
    }
	function trim(src){
        for(;src.indexOf(" ") > -1;){
            src = src.replace(" ","");
        }
        for(;src.indexOf("\n") > -1;){
            src = src.replace("\n","");
        }
        for(;src.indexOf("\r") > -1;){
            src = src.replace("\r","");
        }
        return src;
    }
	function checkDup(targetSheet, col, value){
        var row = targetSheet.FindText(col, value);
        if(row == -1){
            return true;
        }else{
            return false;
        }
    }
	/*
     * 쿼리문에 변경 가능 문자(조건들) 시트에 입력
     */
    function mvUserConfitionElement(){
        var adminSqlSyntax = $("#sqlTxt").val();
        for(;adminSqlSyntax.indexOf("&&") > -1;){
            adminSqlSyntax       = adminSqlSyntax.replace("&&","@@");
        }
        var columnNmList = new Array();
        for(i=0;adminSqlSyntax.indexOf("@@") != -1;i++){
            sIdx             = adminSqlSyntax.indexOf("@@");
            if(sIdx < adminSqlSyntax.lastIndexOf("@@")){
                adminSqlSyntax     = adminSqlSyntax.substring(sIdx+2, adminSqlSyntax.length);
                eIdx             = adminSqlSyntax.indexOf("@@");
                columnNm         = adminSqlSyntax.substring(0, eIdx);
                columnNmList[i] = columnNm;
                if(adminSqlSyntax.length > 0){
                    adminSqlSyntax  = adminSqlSyntax.substring(eIdx+2, adminSqlSyntax.length);
                }
            }
        }

        if(sheet2.RowCount() > 0){
            for(i = 1 ; i <= sheet2.RowCount() ; i++){
                sheet2.SetCellValue(i, "sStatus", "D") ;
            }
        }

        for(i = 0 ; i < columnNmList.length ; i++){
            if(columnNmList[i] != ""){
                if(checkDup(sheet2, "columnNm", columnNmList[i])){
                    sheet2Insert(columnNmList[i]);
                }else{
                    var row = sheet2.FindText("columnNm", columnNmList[i]);
                    if(sheet2.GetCellValue(row, "sStatus") == "D"){
                    	sheet2.SetCellValue(row, "sStatus", "R") ;
                    }
                }
            }
        }
    }
    function sheet2Insert(columnNm){
        var Row = sheet2.DataInsert(sheet2.LastRow()+1);
        sheet2.SetCellValue( Row, "searchSeq", $("#srchSeq").val() ) ;
        sheet2.SetCellValue( Row, "columnNm", columnNm ) ;
        sheet2.SetCellValue( Row, "condType", "U" ) ;
        sheet2.SetCellValue( Row, "inputValue", "''" ) ;
    }
    /**************************************
     * 검색할 항목 찾기
     */
    function searchViewElement(gbn){
    	if(sheet1.RowCount() > 0) { alert("<msg:txt mid='alertNoDataOk' mdef='해당 기능은 데이터가 없는 상태에서만 사용 가능합니다.'/>") ; return ; }
    	if(!confirm("끌어온 데이터는 정확하지 않을 수 있으므로 반드시 확인하여 주십시오.")){ return ; }

    	/* 컨마가 특수문자로 들어가있는 경우 일반 컨마로 바꿔준다. */
    	$("#sqlTxt").val( $("#sqlTxt").val().replace(/，/g, ",")) ;

        var adminSqlSyntax         = $("#sqlTxt").val();
        if( checkQeury(adminSqlSyntax) ) {
	        	adminSqlSyntax = getSelect(adminSqlSyntax, gbn);
        }
        else { return ; }

        var columnNmList         = new Array();
        var removeColumnNmList     = new Array();

        for(i=0;adminSqlSyntax.length > 0;i++){
            eIdx             = adminSqlSyntax.indexOf(",");
            if(eIdx > -1){
                columnNmList[i] = findAlias(adminSqlSyntax.substring(0, eIdx));
                adminSqlSyntax = adminSqlSyntax.substring(eIdx+1, adminSqlSyntax.length);
            }else{
                columnNmList[i] = findAlias(adminSqlSyntax);
                adminSqlSyntax = "";
            }
        }
        for(i = 0 ; i < columnNmList.length ; i++){
            columnNmList[i] = trim(columnNmList[i]);
            /* 컨마로 구분한 데이터가 없는값 이거나 각종 함수에 쓰이는 기호는 제외 */
        	if( (columnNmList[i] != "" && columnNmList[i] != "NULL" ) &&
        			(columnNmList[i].indexOf('(') == -1 &&
      				 columnNmList[i].indexOf(')') == -1 &&
      				 columnNmList[i].indexOf('/') == -1 &&
      				 columnNmList[i].indexOf('*') == -1 &&
      				 columnNmList[i].indexOf('+') == -1 &&
      				 columnNmList[i].indexOf('-') == -1
        			)
        	) {
	            sheet1Insert(columnNmList[i]);
	            sheet1.SetCellValue(i+1, "sStatus", "I") ;
        	}
        }

    }
    /**
     * Select와 From문장 사이 항목 찾기
     */
     function getSelect(src, gbn){
          var query = src.toUpperCase();
          /* SELECT ~ FROM 의 영역은 첫 SELECT 부터 마지막 FROM으로 잡는다.
           * 그러므로 인라인뷰와 같은 행위를 테이블로 사용하는 경우 잘못나오나, 해당 부분은 수정하면 된다.
          */
         var sIdx   = query.indexOf("SELECT");
         var eIdx   = ( gbn == "ALL" ? query.lastIndexOf("FROM") : query.indexOf("FROM") ) ;
         query = query.substring(sIdx+6, eIdx);
         return query;
     }
     /**
      * 문장에서 Alias 찾기
      */
     function findAlias(src){
         var query = src.toUpperCase();
         if(query.indexOf(")") > -1){
             query = query.substring(query.indexOf(")")+1, query.length);
         }
         var idx   = query.indexOf(" AS ");
         if(idx > -1){
             query = query.substring(idx+4, query.length);
         }else{
             if(query.indexOf("'") > -1){
                 query = "";
             }else{
                 query = query.substring(0, query.length);
             }
         }
          return query;
     }
     function sheet1Insert(columnNm){
         var Row = sheet1.DataInsert(-1);
         sheet1.SetCellValue(Row, "searchSeq", srchSeq) ;

         /* "가 들어있는 경우 없애준다. */
     	 var columnNmStr = columnNm.trim().replace(/"/g, "") ;

         sheet1.SetCellValue(Row, "columnNm", columnNmStr) ;
         sheet1.SetCellValue(Row, "seq", Row*10) ;
     }
    /*
	* 쿼리문에서 파라매터가 자동으로 추가 되도록 하는 로직 종료  by JSG ---------------------------------------------------
	*/

	function sheet1_OnPopupClick(Row, Col){
		try{
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='pwrSrchMgr' mdef='조건검색'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<form id="sheetForm" name="sheetForm">
		<input id="srchSeq" name="srchSeq" type="hidden"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='srchDesc' mdef='조회업무'/></th>
						<td>
							<input id="srchDesc" type="text" class="text" style="width:300px;"/>
						</td>
						<td>
							<btn:a href="javascript:openResult();" css="button" mid='110710' mdef="검색결과"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		</form>

		<div class="h15 outer"></div>

		<div id="tabs">
			<ul class="outer tab_bottom">
				<li><btn:a href="#tabs-1" mid='111458' mdef="Sql구분"/></li>
				<li><btn:a href="#tabs-2" mid='110868' mdef="조회항목 설정"/></li>
				<li><btn:a href="#tabs-3" mid='110711' mdef="조회조건 설명"/></li>
				<li><btn:a href="#tabs-4" mid='111298' mdef="사용자입력 조건항목 설정"/></li>
			</ul>
			<div id="tabs-1">
				<div class="ibsheet" fixed="false" sheet_count="1" realHeight="100">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112727' mdef='Sql구분'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction3('sqlSave');" css="basic authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
					<textarea id="sqlTxt" name="sqlTxt" class="w100p" style="height:92%;"></textarea>
				</div>
			</div>

			<div id="tabs-2">
				<div class="sheet_title inner">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='104254' mdef='조회항목 설정'/></li>
						<li class="btn">
							<!-- Sql구문으로 부터 검색 항목을 끌어오는 로직을 Call하는 버튼 by JSG -->
							<btn:a href="javascript:searchViewElement('')" css="pink authR" mid='111625' mdef="자동생성(기본)"/>
							<btn:a href="javascript:searchViewElement('ALL')" css="pink authR" mid='111460' mdef="자동생성(전체)"/>

							<btn:a href="javascript:doAction1('Search')" css="button authR" mid='110697' mdef="조회"/>
							<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
							<btn:a href="javascript:doAction1('Save')" css="basic authA" mid='110708' mdef="저장"/>
						</li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</div>

			<div id="tabs-3">
				<div class="ibsheet" fixed="false" sheet_count="1" realHeight="100">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='114528' mdef='조회조건 설명'/></li>
							<li class="btn">
								<a href="javascript:doAction3('sqlDescSave');" class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
					<textarea id="sqlDescTxt" name="sqlDescTxt" rows="27" class="w100p"></textarea>
				</div>
			</div>


			<div id="tabs-4">
				<div class="sheet_title inner">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='pwrSrchAdminUser3' mdef='사용자입력 조건항목 설정'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Search')" css="button authR" mid='110697' mdef="조회"/>
						<btn:a href="javascript:doAction2('Save')" css="basic authA" mid='110708' mdef="저장"/>
					</li>
				</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
			</div>
		</div>

		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
		<div class="hide">
			<script type="text/javascript"> createIBSheet("sheet3", "0", "0", "${ssnLocaleCd}"); </script>
		</div>
	</div>
</div>
</body>
</html>
