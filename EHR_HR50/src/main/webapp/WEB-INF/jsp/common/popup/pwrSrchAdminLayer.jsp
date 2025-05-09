<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- 버튼제어가 안되서 추가함 -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>

<script type="text/javascript">
	var openSheet 		= null;
	var srchSeq 		= null;
	var openChartType	= null;
	var elemDetail 		= null;
	var selectSheet 	= null;
	var saveMsgFlag1 	= true ;//pwrSrchAdminLayerSheet1저장 후 메시지 출력여부
	var saveMsgFlag2 	= true ;//pwrSrchAdminLayerSheet2저장 후 메시지 출력여부
	var saveMsgFlag3 	= true ;//pwrSrchAdminLayerSheet3저장 후 메시지 출력여부
	var gPRow 			= "";
	var pGubun 			= "";

	$(function() {

		//tab event
		$('div#tabs ul.tab_bottom li').on('click', function() {
			$('div#tabs ul.tab_bottom li').removeClass('active');
			$(this).addClass('active');
			var index = $(this).index();
			$('div#tabs div.content').addClass('hide');
			$('div#tabs div.content:eq(' + index + ')').removeClass('hide');
			sheetResize();
		});
		
		createIBSheet3(document.getElementById('pwrSrchAdminLayerSheet1-wrap'), "pwrSrchAdminLayerSheet1", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('pwrSrchAdminLayerSheet2-wrap'), "pwrSrchAdminLayerSheet2", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('pwrSrchAdminLayerSheet3-wrap'), "pwrSrchAdminLayerSheet3", "100%", "100%", "${ssnLocaleCd}");
		const modal = window.top.document.LayerModalUtility.getModal('pwrSrchAdminLayer');
		$("#srchDesc").val(modal.parameters.searchDesc);
		$("#srchSeq").val(modal.parameters.searchSeq);
		openChartType = modal.parameters.chartType;
		srchSeq = modal.parameters.searchSeq;
		
		var inqTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var valueTypeCd	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20030"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var operTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S50020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		var alignCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20100"), "",-1);
		var initdata = {};

		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		];IBS_InitSheet(pwrSrchAdminLayerSheet1, initdata);pwrSrchAdminLayerSheet1.SetCountPosition(4); pwrSrchAdminLayerSheet1.SetVisible(true);
		pwrSrchAdminLayerSheet1.SetColProperty("ascDesc", {ComboText:"올림차순|내림차순",	ComboCode:"ASC|DESC"} );
		pwrSrchAdminLayerSheet1.SetColProperty("align", {ComboText:alignCd[0], 		ComboCode:alignCd[1]} );
		pwrSrchAdminLayerSheet1.SetColProperty("inqType", {ComboText:inqTypeCd[0], 		ComboCode:inqTypeCd[1]} );
		pwrSrchAdminLayerSheet1.SetColProperty("mergeYn", {ComboText:"N|Y",	ComboCode:"N|Y"} );
		pwrSrchAdminLayerSheet1.SetColProperty("subSumType", {ComboText:" |기준|소계|평균",	ComboCode:"-|STD|SUM|AVG"} );
		pwrSrchAdminLayerSheet1.SetColProperty("chartStd", {ComboText:" |기준|기준(값)|퍼센트(%)",	ComboCode:" |KEY|VALUE|PER"} );


		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		];IBS_InitSheet(pwrSrchAdminLayerSheet2, initdata);pwrSrchAdminLayerSheet2.SetCountPosition(4); pwrSrchAdminLayerSheet2.SetVisible(true);
		pwrSrchAdminLayerSheet2.SetColProperty("andOr", 	{ComboText:"AND|OR", ComboCode:"AND|OR"} );
		pwrSrchAdminLayerSheet2.SetColProperty("operator", {ComboText:operTypeCd[0], ComboCode:operTypeCd[1]} );
		pwrSrchAdminLayerSheet2.SetColProperty("valueType",{ComboText:valueTypeCd[0], ComboCode:valueTypeCd[1]} );


		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" , Sort:0},
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",      	Hidden:0,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"searchSeq", 		KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='conditionDesc' mdef='쿼리설명'/>",	Type:"Text",      	Hidden:0,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"conditionDesc",  	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
            {Header:"<sht:txt mid='sqlSyntaxV1' mdef='쿼리'/>",		Type:"Text",      	Hidden:0,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"adminSqlSyntax",  KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:99999999999 },
        ];IBS_InitSheet(pwrSrchAdminLayerSheet3, initdata);pwrSrchAdminLayerSheet3.SetCountPosition(4); pwrSrchAdminLayerSheet3.SetVisible(true);

		//$(window).smartresize(sheetResize);
		sheetInit();

	    $( "#tabs" ).tabs({
			activate: function( event, ui ) {
	    		if( ui.oldPanel.attr("id") == "tabs-1" ) {
	    			saveMsgFlag3 = false ;
	    			doAction3('sqlSave');
	    		} else { saveMsgFlag3 = true ; }
	    		//sheetResize();
	    	}
	    });

		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	});

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	pwrSrchAdminLayerSheet1.DoSearch( "${ctx}/PwrSrchAdminPopup.do?cmd=getPwrSrchAdminPopupElemList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(pwrSrchAdminLayerSheet1.FindStatusRow("I") != ""){
			    if(!dupChk(pwrSrchAdminLayerSheet1,"columnNm", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,pwrSrchAdminLayerSheet1);
			pwrSrchAdminLayerSheet1.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=savePwrSrchAdminPopupElem", $("#sheetForm").serialize() );
			break;
		case "Insert":
			var Row = pwrSrchAdminLayerSheet1.DataInsert(0);
			pwrSrchAdminLayerSheet1.SetCellValue(Row,"searchSeq",srchSeq);
			break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":	pwrSrchAdminLayerSheet2.DoSearch( "${ctx}/PwrSrchAdminPopup.do?cmd=getPwrSrchAdminPopupConditionList", $("#sheetForm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.sheetForm,pwrSrchAdminLayerSheet2);
			pwrSrchAdminLayerSheet2.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=savePwrSrchAdminPopupCondition", $("#sheetForm").serialize() ); break;
		case "Insert":	var Row = pwrSrchAdminLayerSheet2.DataInsert(0); break;
		}
	}

	function doAction3(sAction) {
		switch (sAction) {
		case "Search":	pwrSrchAdminLayerSheet3.DoSearch( "${ctx}/PwrSrchAdminPopup.do?cmd=getPwrSrchAdminPopupElemDetailList",$("#sheetForm").serialize() ); break;
		case "sqlSave":
			 var Row = pwrSrchAdminLayerSheet3.DataInsert(0);
			 if( !checkQeury($("#sqlTxt").val()) ) { return ; }
			 else {
				mvUserConfitionElement() ;
			 }
            if(pwrSrchAdminLayerSheet2.FindStatusRow("I|S|D|U") != ""){
				saveMsgFlag2 = false ; //저장메시지 출력 하지 않음
				IBS_SaveName(document.sheetForm,pwrSrchAdminLayerSheet2);
				pwrSrchAdminLayerSheet2.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=savePwrSrchAdminPopupCondition",$("#sheetForm").serialize(), -1, false );
				pwrSrchAdminLayerSheet2.SetColHidden(1, true) ;
            }

 			pwrSrchAdminLayerSheet3.SetCellValue(Row,"adminSqlSyntax",	$("#sqlTxt").val() );
			pwrSrchAdminLayerSheet3.SetCellValue(Row,"srchSeq",			$("#srchSeq").val() );
			IBS_SaveName(document.sheetForm,pwrSrchAdminLayerSheet3);
			pwrSrchAdminLayerSheet3.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=updatePwrSrchAdminPopupSql" ,$("#sheetForm").serialize(), -1, false);
			break;
		case "sqlDescSave":
			var Row = pwrSrchAdminLayerSheet3.DataInsert(0);
			pwrSrchAdminLayerSheet3.SetCellValue(Row,"conditionDesc",	$("#sqlDescTxt").val() );
			IBS_SaveName(document.sheetForm,pwrSrchAdminLayerSheet3);
			pwrSrchAdminLayerSheet3.DoSave("${ctx}/PwrSrchAdminPopup.do?cmd=updatePwrSrchAdminPopupSqlDesc" ,$("#sheetForm").serialize());
			break;
		}
	}

	function pwrSrchAdminLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize(); }
		catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function pwrSrchAdminLayerSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "" && saveMsgFlag1) {
				alert(Msg) ;
			} else {
				saveMsgFlag1 = false ;
			}
		}
		catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}

	function pwrSrchAdminLayerSheet1_OnChange(Row,Col,Value){
		if(pwrSrchAdminLayerSheet1.ColSaveName(Col) == "subSumType") {
			if(Value == "STD") {
				var stdColCnt = 0;
				for(var i = 1 ; i <= pwrSrchAdminLayerSheet1.LastRow() ; i++){
					if(pwrSrchAdminLayerSheet1.GetCellValue(i, "subSumType") == "STD") {
						stdColCnt++;
					}
				}
				if(stdColCnt > 1) {
					alert("<msg:txt mid='alertStdOneSetting' mdef='기준컬럼은 한개이상 설정 불가합니다.'/>");
					pwrSrchAdminLayerSheet1.SetCellValue(Row,Col, "-");
					return;
				}
			}

			if(Value == "SUM" || Value == "AVG") {
				if(pwrSrchAdminLayerSheet1.GetCellValue(Row, "inqType") != "Float" && pwrSrchAdminLayerSheet1.GetCellValue(Row, "inqType") != "Number") {
					alert("<msg:txt mid='alertNotInteger' mdef='숫자형이 아닌 컬럼에 지정 불가합니다.'/>");
					pwrSrchAdminLayerSheet1.SetCellValue(Row,Col,"-");
					return;
				}
			}
		}
		
		//차트기준설정 값이 한개만 들어가게 변경
		if ( pwrSrchAdminLayerSheet1.ColSaveName(Col) == "chartStd") {
			for(var i = pwrSrchAdminLayerSheet1.HeaderRows(); i < pwrSrchAdminLayerSheet1.RowCount()+pwrSrchAdminLayerSheet1.HeaderRows() ; i++) {
				if (i != Row && Value == pwrSrchAdminLayerSheet1.GetCellValue(i, "chartStd")) {
					pwrSrchAdminLayerSheet1.SetCellValue(i, "chartStd", "");
				}
			}
		}
	}

	function pwrSrchAdminLayerSheet2_OnPopupClick(Row, Col){
		try {
			if(Row > 0 && pwrSrchAdminLayerSheet2.ColSaveName(Col) == "searchItemNm"){
				if(!isPopup()) {return;}
				<%--var url 	= "${ctx}/PwrSrchElemPopup.do?cmd=pwrSrchElemLayer";--%>
				<%--var args 	= new Array();--%>
				<%--var rv = openPopup(url,args,640,580);--%>
				<%--if(rv!=null){--%>
				<%--}--%>
				gPRow = Row;
				pGubun = "pwrSrchElemPopup";
				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchElemLayer'
					, url : '/PwrSrchElemPopup.do?cmd=pwrSrchElemLayer'
					, parameters : {}
					, width : 640
					, height : 580
					, title : '조건검색 코드항목 조회'
					, trigger :[
						{
							name : 'pwrSrchElemLayerTrigger'
							, callback : function(result){
								pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "searchItemCd", 	result.searchItemCd);
								pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "searchItemNm", 	result.searchItemNm);
								pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "searchItemDesc", result.searchItemDesc);
								pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "itemMapType", 	result.itemMapType);
								pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "prgUrl", 		result.prgUrl);
								pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "sqlSyntax", 	result.sqlSyntax);
							}
						}
					]
				});
				layerModal.show();
	    	}
			if(Row > 0 && pwrSrchAdminLayerSheet2.ColSaveName(Col) == "inputValueDesc"){
				if(!isPopup()) {return;}
		    	var args 	= new Array();
				// args["sheet"] 	= "pwrSrchAdminLayerSheet2";
				args["operator"] = pwrSrchAdminLayerSheet2.GetCellText(Row, "operator").toUpperCase();
				args["valueType"]    = pwrSrchAdminLayerSheet2.GetCellValue(Row, "valueType");
				args["searchItemCd"]  = pwrSrchAdminLayerSheet2.GetCellValue(Row, "searchItemCd");
				args["inputValue"]  = pwrSrchAdminLayerSheet2.GetCellValue(Row, "inputValue");
				args["inputValueDesc"]  = pwrSrchAdminLayerSheet2.GetCellValue(Row, "inputValueDesc");
				args["adminFlag"] 	= "yes";

				gPRow = Row;
				pGubun = "pwrSrchInputValueLayer";
				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchInputValueLayer'
					, url : '${ctx}/PwrSrchInputValuePopup.do?cmd=viewPwrSrchInputValueLayer&authPg=${authPg}&adminFlag=Yes'
					, parameters : args
					, width : 840
					, height : 680
					, title : '조회업무 조회'
					, trigger :[
						{
							name : 'pwrSrchInputValueTrigger'
							, callback : function(result){
								getReturnValue(result);
								//pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc", result.valDesc);
							}
						}
					]
				});
				layerModal.show();
		    }

		} catch (ex) { alert("OnPopupClick Event Error " + ex); }
	}

	//팝업 콜백 함수.
	function getReturnValue(result) {
		if(pGubun == "pwrSrchInputValueLayer"){
			let ymd 		= result.ymd;
			let ym			= result.ym;
			let sYmd 		= result.sYmd;
			let eYmd 		= result.eYmd;
			let sYm 		= result.sYm;
			let eYm 		= result.eYm;
			let sVal 		= result.sVal;
			let eVal 		= result.eVal;
			let vall 		= result.vall;
			let valDesc 	= result.valDesc;
			let resNo		= result.resNo;
			let etcData 	= result.etcData;
			let likeOpt		= result.likeOpt;

			if(pwrSrchAdminLayerSheet2.GetCellText(gPRow, "operator").toUpperCase() == "BETWEEN"){
				if(pwrSrchAdminLayerSheet2.GetCellValue(gPRow, "valueType") == "dfDateYmd"){
					if(sYmd != "" && eYmd != ""){
						if(checkDateCtl("",sYmd, eYmd)){
							pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue","'"+sYmd.split("-").join("")+"'" + " AND " + "'"+eYmd.split("-").join("")+"'");
							pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",sYmd + "일에서 " + eYmd+"일까지");
						}else{
							return;
						}
					}else if(sYmd == "" && eYmd == ""){
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue",checkLike('','all'));
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc","");
					}else{
						alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
						return;
					}
				}else if(pwrSrchAdminLayerSheet2.GetCellValue(gPRow, "valueType") == "dfDateYm"){
					if(sYm != "" && eYm != ""){
						if(checkDateCtl("",sYm, eYm)){
							pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue","'"+sYm.split("-").join("")+"'" + " AND " + "'"+eYm.split("-").join("")+"'");
							pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",sYm + "월에서 " + eYm+"월까지");
						}else{
							return;
						}
					}else if(sYm == "" && eYm == ""){
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue",checkLike('','all'));
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc","");
					}else{
						alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
						return;
					}
				}else{
					pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue","'"+sVal+"'" + " AND " + "'"+eVal+"'");
					pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",sVal + "에서 " + eVal+"까지");
				}
			}else{
				if(pwrSrchAdminLayerSheet2.GetCellValue(gPRow, "searchItemCd") != ""){
					pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue",checkLike(vall, likeOpt ));
					pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",valDesc);
				}else{
					if(pwrSrchAdminLayerSheet2.GetCellValue(gPRow, "valueType") == "dfDateYmd"){
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue","'"+ymd.split("-").join("")+"'");
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",ymd);
					}else if(pwrSrchAdminLayerSheet2.GetCellValue(gPRow, "valueType") == "dfDateYm"){
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue","'"+ym.split("-").join("")+"'");
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",ym);
					}else if(pwrSrchAdminLayerSheet2.GetCellValue(gPRow, "valueType") == "dfIdNo"){
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue","'"+resNo+"'");
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",resNo);
					}else if(pwrSrchAdminLayerSheet2.GetCellValue(gPRow, "valueType") == "dfNumber"){
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue",etcData);
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",etcData);
					}else{
						if(pwrSrchAdminLayerSheet2.GetCellText(gPRow, "operator").toUpperCase() == "IN"
								|| pwrSrchAdminLayerSheet2.GetCellText(gPRow, "operator").toUpperCase() == "NOT IN"){
							pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue","("+etcData+")");
						}else{
							pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValue",checkLike(etcData,  likeOpt));
						}
						pwrSrchAdminLayerSheet2.SetCellValue(gPRow, "inputValueDesc",etcData);
					}
				}
			}
		}
	}

	function pwrSrchAdminLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } 
			for(row = 1 ; row <= pwrSrchAdminLayerSheet2.LastRow() ; row++){
	            if(pwrSrchAdminLayerSheet2.GetCellValue(row, "valueType") == "dfCode"){
	            	pwrSrchAdminLayerSheet2.SetCellEditable(row,"searchItemNm",true);
	            }else if( pwrSrchAdminLayerSheet2.GetCellValue(row, "valueType") == "dfCompany"
	                   || pwrSrchAdminLayerSheet2.GetCellValue(row, "valueType") == "dfSabun"
	                   || pwrSrchAdminLayerSheet2.GetCellValue(row, "valueType") == "dfBaseDate"
	                   || pwrSrchAdminLayerSheet2.GetCellValue(row, "valueType") == "dfToday"
		               || pwrSrchAdminLayerSheet2.GetCellValue(row, "valueType") == "dfSearchTy"
			           || pwrSrchAdminLayerSheet2.GetCellValue(row, "valueType") == "dfGrpCd"){
	       			pwrSrchAdminLayerSheet2.SetCellEditable(row,"searchItemNm",false);
	           		pwrSrchAdminLayerSheet2.SetCellEditable(row,"valueType",false);
	            	pwrSrchAdminLayerSheet2.SetCellEditable(row,"inputValueDesc",false);
	            }
	        }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function pwrSrchAdminLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "" && saveMsgFlag2) {
				alert(Msg) ;
			} else {
				saveMsgFlag2 = false ;
			}
		}
		catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	
	function pwrSrchAdminLayerSheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
		    selectSheet = pwrSrchAdminLayerSheet2;
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	function pwrSrchAdminLayerSheet2_OnChange(Row,Col,Value){
		try{
			if(Row > 0 && pwrSrchAdminLayerSheet2.ColSaveName(Col) == "operator"){
		        pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue",checkLike(''));
		        pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","");
		        checkIsNull(pwrSrchAdminLayerSheet2, Row, Col);
		    }else if(Row > 0 && pwrSrchAdminLayerSheet2.ColSaveName(Col) == "valueType"){
		        if(Value == "dfCode"){
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",true);
		        }else{
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchAdminLayerSheet2.SetCellValue(Row,"searchItemCd","");
		            pwrSrchAdminLayerSheet2.SetCellValue(Row,"searchItemNm","");
		        }
		        if(Value == "dfCompany"){
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue","dfCompany");
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","해당 회사");
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValue",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSabun"){
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue","dfSabun");
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","해당 담당자");
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValue",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfBaseDate"){
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue","dfBaseDate");
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","적용일자");
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValue",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSearchTy"){
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue","dfSearchTy");
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","조회타입");
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValue",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfGrpCd"){
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue","dfGrpCd");
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","권한코드");
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValue",false);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValueDesc",false);
		        }else if(Value == "dfSelSabun"){
					pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue","dfSelSabun");
					pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","선택 사용자");
					pwrSrchAdminLayerSheet2.SetCellEditable(Row,"searchItemNm",false);
					pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValue",false);
					pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValueDesc",false);
				}else{
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue",checkLike(""));
		            pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","");
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValue",true);
		            pwrSrchAdminLayerSheet2.SetCellEditable(Row,"inputValueDesc",true);
		        }
		    }else if(Row > 0 && pwrSrchAdminLayerSheet2.ColSaveName(Col) == "searchItemCd"){
		        pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue",checkLike(""));
		        pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","");
		    }
		    if(pwrSrchAdminLayerSheet2.GetCellText(Row, "operator").indexOf("NULL") != -1){
		        pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValue","");
		        pwrSrchAdminLayerSheet2.SetCellValue(Row, "inputValueDesc","");
		    }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	
	function pwrSrchAdminLayerSheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			$("#sqlTxt").val( pwrSrchAdminLayerSheet3.GetCellValue(1,"adminSqlSyntax"));
			$("#sqlDescTxt").val( pwrSrchAdminLayerSheet3.GetCellValue(1,"conditionDesc") );
			pwrSrchAdminLayerSheet3.RemoveAll();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function pwrSrchAdminLayerSheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "" && saveMsgFlag3) {
				alert(Msg) ;
			} else {
				saveMsgFlag3 = false ;
			}
			doAction2('Search') ;
			pwrSrchAdminLayerSheet3.RemoveAll();
		}
		catch (ex) { alert("OnSaveEnd Event Error "+ex); }
	}
	
	function openResult(){
		if(!isPopup()) {return;}
		let layerModal = new window.top.document.LayerModal({
			id : 'pwrResultLayer'
			, url : '${ctx}/PwrSrchResultPopup.do?cmd=viewPwrSrchResultLayer&authPg=${authPg}'
			, parameters : { srchSeq: $("#srchSeq").val() }
			, width : 940
			, height : 580
			, title : '검색결과 조회'
		});
		layerModal.show();
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

        if(pwrSrchAdminLayerSheet2.RowCount() > 0){
            for(i = 1 ; i <= pwrSrchAdminLayerSheet2.RowCount() ; i++){
                pwrSrchAdminLayerSheet2.SetCellValue(i, "sStatus", "D") ;
            }
        }

        for(i = 0 ; i < columnNmList.length ; i++){
            if(columnNmList[i] != ""){
                if(checkDup(pwrSrchAdminLayerSheet2, "columnNm", columnNmList[i])){
                    pwrSrchAdminLayerSheet2Insert(columnNmList[i]);
                }else{
                    var row = pwrSrchAdminLayerSheet2.FindText("columnNm", columnNmList[i]);
                    if(pwrSrchAdminLayerSheet2.GetCellValue(row, "sStatus") == "D"){
                    	pwrSrchAdminLayerSheet2.SetCellValue(row, "sStatus", "R") ;
                    }
                }
            }
        }
    }
    
    function pwrSrchAdminLayerSheet2Insert(columnNm){
        var Row = pwrSrchAdminLayerSheet2.DataInsert(pwrSrchAdminLayerSheet2.LastRow()+1);
        pwrSrchAdminLayerSheet2.SetCellValue( Row, "searchSeq", $("#srchSeq").val() ) ;
        pwrSrchAdminLayerSheet2.SetCellValue( Row, "columnNm", columnNm ) ;
        pwrSrchAdminLayerSheet2.SetCellValue( Row, "condType", "U" ) ;
        pwrSrchAdminLayerSheet2.SetCellValue( Row, "inputValue", "''" ) ;
    }
    
    /**************************************
     * 검색할 항목 찾기
     */
    function searchViewElement(gbn){
    	if(pwrSrchAdminLayerSheet1.RowCount() > 0) { alert("<msg:txt mid='alertNoDataOk' mdef='해당 기능은 데이터가 없는 상태에서만 사용 가능합니다.'/>") ; return ; }
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
	            pwrSrchAdminLayerSheet1Insert(columnNmList[i]);
	            pwrSrchAdminLayerSheet1.SetCellValue(i+1, "sStatus", "I") ;
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
     
     function pwrSrchAdminLayerSheet1Insert(columnNm){
		 var Row = pwrSrchAdminLayerSheet1.DataInsert(-1);
         pwrSrchAdminLayerSheet1.SetCellValue(Row, "searchSeq", srchSeq) ;

         /* "가 들어있는 경우 없애준다. */
     	 var columnNmStr = columnNm.trim().replace(/"/g, "") ;

         pwrSrchAdminLayerSheet1.SetCellValue(Row, "columnNm", columnNmStr) ;
         pwrSrchAdminLayerSheet1.SetCellValue(Row, "seq", Row*10) ;
     }
     
    /*
	* 쿼리문에서 파라매터가 자동으로 추가 되도록 하는 로직 종료  by JSG ---------------------------------------------------
	*/

	function pwrSrchAdminLayerSheet1_OnPopupClick(Row, Col){
		try{
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
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
							<btn:a href="javascript:openResult();" css="btn filled" mid='110710' mdef="검색결과"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		</form>

		<div class="h15 outer"></div>

		<div id="tabs" style="height: auto;">
			<ul class="outer tab_bottom mt-16">
				<li class="active">Sql구분</li>
				<li>조회항목 설정</li>
				<li>조회조건 설명</li>
				<li>사용자입력 조건항목 설정</li>
			</ul>
			<div id="tabs-1" class="content">
				<div class="ibsheet" fixed="false" sheet_count="1" realHeight="50">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='112727' mdef='Sql구분'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction3('sqlSave');" css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
					<textarea id="sqlTxt" name="sqlTxt" class="w100p" style="height:92%;"></textarea>
				</div>
			</div>

			<div id="tabs-2" class="hide content">
				<div class="sheet_title inner">
					<ul>
						<li class="txt"><tit:txt mid='104254' mdef='조회항목 설정'/></li>
						<li class="btn">
							<!-- Sql구문으로 부터 검색 항목을 끌어오는 로직을 Call하는 버튼 by JSG -->
							<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
							<btn:a href="javascript:searchViewElement('')" css="btn outline-gray authR" mid='111625' mdef="자동생성(기본)"/>
							<btn:a href="javascript:searchViewElement('ALL')" css="btn outline-gray authR" mid='111460' mdef="자동생성(전체)"/>
							<btn:a href="javascript:doAction1('Save')" css="btn filled authA" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction1('Search')" css="btn dark authR" mid='110697' mdef="조회"/>
						</li>
					</ul>
				</div>
				<div id="pwrSrchAdminLayerSheet1-wrap"></div>
				<!-- <script type="text/javascript"> createIBSheet("pwrSrchAdminLayerSheet1", "100%", "100%", "${ssnLocaleCd}"); </script> -->
			</div>

			<div id="tabs-3" class="hide content">
				<div>
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='114528' mdef='조회조건 설명'/></li>
							<li class="btn">
								<a href="javascript:doAction3('sqlDescSave');" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
					<textarea id="sqlDescTxt" name="sqlDescTxt" rows="27" class="w100p"></textarea>
				</div>
			</div>


			<div id="tabs-4" class="hide content">
				<div class="sheet_title inner">
					<ul>
						<li class="txt"><tit:txt mid='pwrSrchAdminUser3' mdef='사용자입력 조건항목 설정'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction2('Save')" css="btn filled authA" mid='110708' mdef="저장"/>
							<btn:a href="javascript:doAction2('Search')" css="btn dark authR" mid='110697' mdef="조회"/>
						</li>
					</ul>
				</div>
				<div id="pwrSrchAdminLayerSheet2-wrap"></div>
				<!-- <script type="text/javascript"> createIBSheet("pwrSrchAdminLayerSheet2", "100%", "100%", "${ssnLocaleCd}"); </script> -->
			</div>
		</div>
		
		<div class="hide">
			<div id="pwrSrchAdminLayerSheet3-wrap"></div>
			<!-- <script type="text/javascript"> createIBSheet("pwrSrchAdminLayerSheet3", "0", "0", "${ssnLocaleCd}"); </script> -->
		</div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('pwrSrchAdminLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>
</html>
