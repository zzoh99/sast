<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {

		//Master Sheet(sheet1)
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sResult' mdef='결과'/>",	Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },

			{Header:"<sht:txt mid='popwin' mdef='직급'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",    		KeyField:1,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='항목코드'/>",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"elementCd",   		KeyField:1,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='항목'/>",		Type:"Popup",	Hidden:0,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"elementNm",			KeyField:1,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='popwin' mdef='Status'/>",	Type:"Combo",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"changeStatus",		KeyField:0,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='인상방법'/>",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"increaseType",		KeyField:0,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='금액(비율)'/>",	Type:"Float",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"increaseMonRate",		KeyField:0,	CalcLogic:"",   Format:"Float",	PointCount:3,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='popwin' mdef='적용방법'/>",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applyType",			KeyField:0,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='절상/사구분'/>",	Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"updownType",			KeyField:0,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='단위'/>",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"updownUnit",			KeyField:0,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='1호봉금액'/>",		Type:"Int",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"oneHobongMon",		KeyField:0,	CalcLogic:"",   Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='popwin' mdef='시작일자'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",				KeyField:1,	CalcLogic:"",   Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='종료일자'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",				KeyField:0,	CalcLogic:"",   Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		];

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 직급
		var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "전체");
		sheet1.SetColProperty("jikgubCd", 			{ComboText:jikgubCdList[0], ComboCode:jikgubCdList[1]} );
		// Status
		var changeStatusList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00023"), "전체");
		sheet1.SetColProperty("changeStatus", 		{ComboText:"|"+changeStatusList[0], ComboCode:"|"+changeStatusList[1]} );
		// 인상방법
		var increaseTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00019"), "전체");
		sheet1.SetColProperty("increaseType", 			{ComboText:increaseTypeList[0], ComboCode:increaseTypeList[1]} );
		// 적용방법
		var applyTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00021"), "전체");
		sheet1.SetColProperty("applyType", 			{ComboText:applyTypeList[0], ComboCode:applyTypeList[1]} );
		// 절상/사구분
		var updownTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00005"), "");
		sheet1.SetColProperty("updownType", 			{ComboText:updownTypeList[0], ComboCode:updownTypeList[1]} );
		// 단위
		var updownUnitList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00006"), "");
		sheet1.SetColProperty("updownUnit", 			{ComboText:updownUnitList[0], ComboCode:updownUnitList[1]} );


		//Detail Sheet(sheet2)
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sResult' mdef='결과'/>",	Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),Width:"${sRstWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sResult" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },

			{Header:"<sht:txt mid='popwin' mdef='직급'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='항목코드'/>",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='항목명'/>",		Type:"Popup",	Hidden:0,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='popwin' mdef='호봉'/>",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"salClass",    KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='시간단위'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"timeUnit",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='금액'/>",		Type:"Int",		Hidden:0,	Width:135,	Align:"Right",	ColMerge:0,	SaveName:"salMon",		KeyField:0,	CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:22 },
			{Header:"<sht:txt mid='popwin' mdef='통화'/>",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"currencyCd",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='월단위금액'/>",	Type:"Int",		Hidden:0,	Width:140,	Align:"Right",	ColMerge:0,	SaveName:"monthMon",	KeyField:0,	CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:22 },
			{Header:"<sht:txt mid='popwin' mdef='시작일자'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='종료일자'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='popwin' mdef='임금인상대상자'/>",	Type:"Html",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"payUpSawon",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }

		];
		IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		// 직급
		var jikgubCdList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "전체");
		sheet2.SetColProperty("jikgubCd", 			{ComboText:"|"+jikgubCdList2[0], ComboCode:"|"+jikgubCdList2[1]} );
		// 호봉
		var salClassList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C10000"), "");
		sheet2.SetColProperty("salClass",	{ComboText:"|"+salClassList[0], ComboCode:"|"+salClassList[1]}	);

		// 시간단위
		var timeUnitList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00010"), "");
		sheet2.SetColProperty("timeUnit",	{ComboText:"|"+timeUnitList[0], ComboCode:"|"+timeUnitList[1]}	);
		// 통화
		var currencyCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), "");
		sheet2.SetColProperty("currencyCd",	{ComboText:"|"+currencyCdList[0], ComboCode:"|"+currencyCdList[1]}	);

		//화면구성

		//$("#searchSdate").html();

		$("#searchJikgubCd").html(jikgubCdList[2]) ;
		$("#searchJikgubCd").bind("change",function(event){
			reloadSearchSdate();
			doAction1("Search");
		});

		$("#searchSdate").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchYear").bind("chage",function(event){
			doAction1("Search");
		});

		reloadSearchSdate();

		//mDays 계산
		var searchMDays = ajaxCall("${ctx}/PayTblExchangeMgr.do?cmd=getSearchMDays","&searchGlobalValueCd=10" ,false );
		if(searchMDays.DATA.length > 0){
			alert( JSON.stringify(searchMDays) );
		}else{
			$("#mDays").val("30");
		}


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		//doAction2("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 	 	sheet1.DoSearch( "${ctx}/PayTblExchangeMgr.do?cmd=getPayTblExchangeMasterList", $("#srchFrm").serialize() ); break;
			case "Save":
				if(!dupChk(sheet1,"jikgubCd|elementCd|elementNm|sdate", false, true)){break;}
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/PayTblExchangeMgr.do?cmd=savePayTblExchangeMaster", $("#srchFrm").serialize()); break;
			case "Insert":	var newRow = sheet1.DataInsert(0);
							sheet1.SetCellValue(newRow, "changeStatus", "A");
							sheet1.SetCellValue(newRow, "sdate", "${ssnBaseDate}");
							sheet1.SetCellValue(newRow, "increaseMonRate", 0);
							sheet1.SetCellValue(newRow, "oneHobongMon", 0);

							break;
			case "Copy":	var Row = sheet1.DataCopy();
							break;
			case "Clear":	sheet1.RemoveAll(); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();

			if( sheet1.LastRow() > 0 ) {
				$("#searchJikgubCdDetail").val( sheet1.GetCellValue(1,"jikgubCd") ) ;
	            $("#searchElementCdDetail").val( sheet1.GetCellValue(1,"elementCd") ) ;
	            $("#searchSdateDetail").val( sheet1.GetCellValue(1,"sdate") ) ;

			}else{
				var searchJikgubCd = $("#searchJikgubCd").val();
				var searchElementCd = $("#searchElementCd").val();
				var searchSdate = $("#searchSdate").val();

				$("#searchJikgubCdDetail").val(searchJikgubCd);
				$("#searchElementCdDetail").val(searchElementCd);
				$("#searchSdateDetail").val(searchSdate);

			}
			doAction2("Search");
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트 (shift+Insert KEY : 입력 , shift+Delete KEY : 입력상태의 선택행 삭제 )
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction1("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row,"sStatus") == "I"){
				sheet1.SetCellValue(Row,"sDelete","1");
			}
		}catch(ex){
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
        try{
            if( sheet1.GetCellValue(Row,"sStatus") != "I" && sheet1.ColSaveName(Col) != "sDelete" ){

	            $("#searchJikgubCdDetail").val( sheet1.GetCellValue(Row,"jikgubCd") ) ;
	            $("#searchElementCdDetail").val( sheet1.GetCellValue(Row,"elementCd") ) ;
	            $("#searchSdateDetail").val( sheet1.GetCellValue(Row,"sdate") ) ;

	            if( sheet1.ColSaveName(Col) == "jikgubCd"  || sheet1.ColSaveName(Col) == "elementCd"
	            	|| sheet1.ColSaveName(Col) == "elementNm" || sheet1.ColSaveName(Col) == "changeStatus" ){

	                doAction2("Search");
	            }


            }
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }

	function sheet1_OnPopupClick(Row, Col){
        try{
        	if(Row > 0 && sheet1.ColSaveName(Col) == "elementNm" && sheet1.GetCellValue(Row,"sStatus") == "I"){
				// elementSearchPopup("sheet");
				elementSearchPopup("sheet", Row);
             }


        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.GetCellValue(Row,"sdate") != "" && sheet1.GetCellValue(Row,"edate") != "") {
				if(sheet1.GetCellValue(Row,"sdate") > sheet1.GetCellValue(Row,"edate")) {
					alert("시작일은 종료일보다 작거나 같아야합니다.");
					sheet1.SetCellValue(Row,"edate","",0);
					return;
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	/*
		* ------------- sheet2 ------------- *
	*/
	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/PayTblExchangeMgr.do?cmd=getPayTblExchangeDetailList", $("#srchFrm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.srchFrm, sheet2);
			sheet2.DoSave( "${ctx}/PayTblExchangeMgr.do?cmd=savePayTblExchangeDetail", $("#srchFrm").serialize()); break;
		case "Copy":
			var Row = sheet2.DataCopy();
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }


			for(var i = 0; i < sheet2.RowCount(); i++) {

				if(sheet2.GetCellValue(i+1,"payUpSawon") == ""){
					sheet2.SetCellValue(i+1, "payUpSawon", '<btn:a css="basic" mid='' mdef="보기"/>');
					sheet2.SetCellValue(i+1, "sStatus", 'R');
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}

	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	// 셀에서 키보드가 눌렀을때 발생하는 이벤트 (shift+Insert KEY : 입력 , shift+Delete KEY : 입력상태의 선택행 삭제 )
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction2("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row,"sStatus") == "I"){
				sheet2.SetCellValue(Row,"sDelete","1");
			}
		}catch(ex){
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	  function sheet2_OnChange(Row, Col, Value){
	  try{
	   // checkSEDate(sheet2, Row, Col, "");

	    if( sheet2.ColSaveName(Col) == "salMon" ){
	        // 월단위 금액 : 입력된 금액과 시간단위에 따라 자동 계산되어 Display된다
	        // 기준금액
	        var salMon = sheet2.GetCellValue(Row, "salMon");

	    	// 시간단위
	        var timeUnit = sheet2.GetCellValue(Row, "timeUnit");

	        sheet2.SetCellValue(Row, "monthMon",calcMonthMon(salMon, timeUnit));

	    }
	    if(sheet2.GetCellValue(Row,"sdate") != "" && sheet2.GetCellValue(Row,"edate") != "") {
			if(sheet2.GetCellValue(Row,"sdate") > sheet2.GetCellValue(Row,"edate")) {
				alert("시작일은 종료일보다 작거나 같아야합니다.");
				sheet2.SetCellValue(Row,"edate","",0);
				return;
			}
	    }

	  }catch(ex){alert("OnChange Event Error : " + ex);}
	}

	//변경내역 Detail	(sheet2)셀 클릭시 이벤트
	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(Row > 0 && sheet2.ColSaveName(Col) == "payUpSawon" ){

				var args    = new Array();

				args ["jikgubCd"] = sheet2.GetCellValue(Row, "jikgubCd");
				args ["elementCd"] = sheet2.GetCellValue(Row, "elementCd");
				args ["elementNm"] = sheet2.GetCellValue(Row, "elementNm");
				args ["salClass"] = sheet2.GetCellValue(Row, "salClass");
				args ["sdate"] = sheet2.GetCellValue(Row, "sdate");

				pGubun = "payUpStaffPopup";
				var rv = openPopup("${ctx}/Popup.do?cmd=payUpStaffPopup&authPg=${authPg}", args, "850","550");

			}

		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}

	}


	/*
	script
	*/
	// 항목검색 팝업
	function elementSearchPopup(type, row) {

		let elementCd = '';
		let elementNm = '';
		if(type === 'sheet'){
			elementCd = sheet1.GetCellValue(row, "elementCd");
			elementNm = sheet1.GetCellValue(row, "elementNm");
		}else{
			elementCd = $('#searchElementCd').val();
			elementNm = (elementCd === '') ? '' : $('#searchElementNm').val();
		}

		let layerModal = new window.top.document.LayerModal({
			id : 'payElementLayer'
			, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
			, parameters : {
				elementCd : elementCd
				, elementNm : elementNm
				, elementType : 'A'
				, searchType : type
			}
			, width : 860
			, height : 520
			, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
			, trigger :[
				{
					name : 'payTrigger'
					, callback : function(result){
						$('#searchElementCd').val(result.resultElementCd);
						$('#searchElementNm').val(result.resultElementNm);

						reloadSearchSdate();
						doAction1("Search");
					}
				}
				, {
					name : 'payTrigger2'
					, callback : function(result){
						sheet1.SetCellValue(row, "elementCd",   result.resultElementCd);
						sheet1.SetCellValue(row, "elementNm",   result.resultElementNm);
					}
				}
			]
		});
		layerModal.show();

		<%--var w		= 840;--%>
		<%--var h		= 520;--%>
		<%--var url		= "${ctx}/PayElementPopup.do?cmd=payElementPopup";--%>
		<%--var args	= new Array();--%>

		<%--args["elementType"] = "A"; // 수당--%>

		<%--if(!isPopup()) {return;}--%>
		<%--gPRow = sheet1.GetSelectRow();--%>

		<%--if(type == "sheet"){--%>
		<%--	pGubun = "payElementPopupSheet";--%>
		<%--}else{--%>
		<%--	pGubun = "payElementPopupSearch";--%>
		<%--}--%>
		<%--openPopup(url+"&authPg=R", args, w, h);--%>

	}

	// 직급 및 항목에 따른 시작일자(sdate)
	function reloadSearchSdate(){
		var searchJikgubCd = $("#searchJikgubCd").val();
		var searchElementCd = $("#searchElementCd").val();

		var cpnSdate = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnSdate&searchJikgubCd="+searchJikgubCd+"&searchElementCd="+searchElementCd, false).codeList, "전체");

		$("#searchSdate").find("option").remove();
		$("#searchSdate").html(cpnSdate[2]);
	}

	// 변경내역  Master 작업
	function detailReset(){

		var Row = sheet1.GetSelectRow();

		var jikgubCd = sheet1.GetCellValue(Row,"jikgubCd");
		var elementCd = sheet1.GetCellValue(Row,"elementCd");
		var sdate = sheet1.GetCellValue(Row,"sdate");

		var updated = false;

		var dataList = ajaxCall("${ctx}/PayTblExchangeMgr.do?cmd=getPayTblExchangeMasterOperation","&jikgubCd="+jikgubCd+"&elementCd="+elementCd+"&sdate="+sdate ,false );
		var i = 0;
		var j = 0;
		//alert( sheet2.RowCount() + ",    " + dataList.DATA.length);
		for(i; i < dataList.DATA.length; i ++){
			if (sheet2.GetCellValue(i+1, "jikgubCd")     == dataList.DATA[i].jikgubCd
				&& sheet2.GetCellValue(i+1, "elementCd") == dataList.DATA[i].elementCd
				&& sheet2.GetCellValue(i+1, "salClass")  == dataList.DATA[i].salClass
				&& sheet2.GetCellValue(i+1, "sdate")      == dataList.DATA[i].sdate ) {

				sheet2.SetCellValue(i+1, "sStatus", "U");
				sheet2.SetCellValue(i+1, "jikgubCd", dataList.DATA[i].jikgubCd);
				sheet2.SetCellValue(i+1, "elementCd", dataList.DATA[i].elementCd);
				sheet2.SetCellValue(i+1, "elementNm", dataList.DATA[i].elementNm);
				sheet2.SetCellValue(i+1, "salClass",  dataList.DATA[i].salClass);
				sheet2.SetCellValue(i+1, "timeUnit", dataList.DATA[i].timeUnit);
				sheet2.SetCellValue(i+1, "currencyCd", dataList.DATA[i].currencyCd);
				sheet2.SetCellValue(i+1, "sdate", dataList.DATA[i].sdate);
				sheet2.SetCellValue(i+1, "edate", dataList.DATA[i].edate);
				sheet2.SetCellValue(i+1, "payUpSawon", '<btn:a css="basic" mid='' mdef="보기"/>');
				//sheet2.SetCellValue(i+1, "salMon", calcSalMon( parseInt(dataList.DATA[i].salClass), parseInt(dataList.DATA[i].salMon)) );
				//sheet2.SetCellValue(i+1, "monthMon", dataList.DATA[i].monthMon);
				
				var salMon1 = calcSalMon(parseInt(dataList.DATA[i].salClass), parseInt(dataList.DATA[i].salMon));
				sheet2.SetCellValue(i + 1, "salMon", salMon1);
				sheet2.SetCellValue(i + 1, "monthMon", calcMonthMon(parseInt(salMon1), dataList.DATA[i].timeUnit));

				updated = true;
			}else {
				
				if( i >= sheet2.RowCount() ){

					var newRow = sheet2.DataInsert(i+1);
											
					//sheet2.SetCellValue(newRow, "sStatus", "I");
					sheet2.SetCellValue(newRow, "jikgubCd", dataList.DATA[i].jikgubCd);
					sheet2.SetCellValue(newRow, "elementCd", dataList.DATA[i].elementCd);
					sheet2.SetCellValue(newRow, "elementNm", dataList.DATA[i].elementNm);
					sheet2.SetCellValue(newRow, "salClass",  dataList.DATA[i].salClass);
					sheet2.SetCellValue(newRow, "timeUnit", dataList.DATA[i].timeUnit);
					sheet2.SetCellValue(newRow, "currencyCd", dataList.DATA[i].currencyCd);
					sheet2.SetCellValue(newRow, "sdate", dataList.DATA[i].sdate);
					sheet2.SetCellValue(newRow, "edate", dataList.DATA[i].edate);
					sheet2.SetCellValue(newRow, "payUpSawon", '<btn:a css="basic" mid='' mdef="보기"/>');
					
					//sheet2.SetCellValue(newRow, "salMon", parseInt(dataList.DATA[i].salMon) );
					//sheet2.SetCellValue(newRow, "monthMon", parseInt(dataList.DATA[i].monthMon) );
					
					var salMon1 = calcSalMon( parseInt(dataList.DATA[i].salClass), parseInt(dataList.DATA[i].salMon));
					
					sheet2.SetCellValue(newRow, "salMon", salMon1  );
					sheet2.SetCellValue(newRow, "monthMon", calcMonthMon( parseInt( salMon1 ), dataList.DATA[i].timeUnit ));
				}

				updated = true;
			}

		}

		if(!updated){

			for(var i = 0; i < dataList.DATA.length; i ++){
				var newRow = sheet2.DataInsert(i);

				sheet2.SetCellValue(newRow, "jikgubCd", dataList.DATA[i].jikgubCd);
				sheet2.SetCellValue(newRow, "elementCd", dataList.DATA[i].elementCd);
				sheet2.SetCellValue(newRow, "elementNm", dataList.DATA[i].elementNm);
				sheet2.SetCellValue(newRow, "salClass",  dataList.DATA[i].salClass);
				sheet2.SetCellValue(newRow, "timeUnit", dataList.DATA[i].timeUnit);
				sheet2.SetCellValue(newRow, "currencyCd", dataList.DATA[i].currencyCd);
				sheet2.SetCellValue(newRow, "sdate", dataList.DATA[i].sdate);
				sheet2.SetCellValue(newRow, "edate", dataList.DATA[i].edate);
				sheet2.SetCellValue(newRow, "payUpSawon", '<btn:a css="basic" mid='' mdef="보기"/>');
				
				var salMon = calcSalMon( parseInt(dataList.DATA[i].salClass), parseInt(dataList.DATA[i].salMon));
				
				sheet2.SetCellValue(newRow, "salMon", salMon);
				sheet2.SetCellValue(newRow, "monthMon", calcMonthMon( parseInt( salMon ), dataList.DATA[i].timeUnit ));

			}
		}
	}

	function fingUpdownUnit(updownUnitCode) {

		var result = 0;

		switch(updownUnitCode) {

			case	"1"	: result = 0.1;		break;
			case	"2"	: result = 0.01;	break;
			case	"3"	: result = 0.001;	break;
			case	"4"	: result = 0.0001;	break;
			case	"0"	: result = 1;		break;
			case	"-1": result = 10;		break;
			case	"-2": result = 100;		break;
			case	"-3": result = 1000;	break;
			case	"-4": result = 10000;	break;
			default	: result = 0;

		}
		return result;
	}

	/**
	 * 급여계산
	 * hobong : 호봉. salClass
	 * salMon : 기준 금액. salMon
	 */
	function calcSalMon(hobong, salMon) {

		/**
		 * 급여계산
		 * sal1Mon : 1호봉 금액
		 * salClass : 호봉
		 * incMonRate : 인상 금액 또는 인상률
		 * incType : 균등금액에 의한 인상 또는 인상률에 의한 인상
		 * updownType : 끝자리 처리 방법. 절상(1), 절사(3), 사사오입(5)
		 * updownUnit : 끝자리 처리 단위. 1, 10, 100
		 */
		var updownUnit = fingUpdownUnit(sheet1.GetCellValue(sheet1.GetSelectRow(), "updownUnit"));
		var updownType = sheet1.GetCellValue(sheet1.GetSelectRow(), "updownType");
		var sal1Mon = sheet1.GetCellValue(sheet1.GetSelectRow(), "oneHobongMon");
		var incMonRate = sheet1.GetCellValue(sheet1.GetSelectRow(), "increaseMonRate");
		var incType = sheet1.GetCellValue(sheet1.GetSelectRow(), "increaseType");
		var applyType = sheet1.GetCellValue(sheet1.GetSelectRow(), "applyType");

		var resultMon;
		
		if (hobong < 1) {
			return 0;
		}

		// 균등배부 : 급여테이블 화면에서 설정한 기존의 정보인 TCPN002 테이블 데이터를 기반으로 sheet1의 금액(비율) 설정 값과 가공한다.
		// 비율배부 : 급여테이블 화면에서 설정한 기존의 정보인 TCPN002 테이블 데이터는 무시하고 sheet1의 1호봉금액 및 금액(비율) 설정 값으로 가공한다. 
		switch(applyType) {
			// 균등배부일 경우 현재의 금액(SHEET_DATA.SAL_MON)에 인상금액을 추가한다.
			case "EQU_DISTR" :
				// 인상방법에 따라 계산 방식이 달라진다.
				switch(incType) {
					// 금액에 따른 인상일 경우 현재의 금액에 인상금액을 추가하면 된다.
					case "MON" :
						resultMon = salMon + parseInt(incMonRate);
						break;

					// 비율에 따른 인상일 경우 현재의 금액에 비율을 곱한 값을 추가한다.
					case "RATE" :
						var incRate = parseFloat(incMonRate);
						resultMon = salMon * (1 + incRate);
						
						break;

					default :
						resultMon = 0;
						break;
				}
				break;

			// 비율배부일 경우 1호봉 기준금액(parent.sht1.ONE_HOHONG_MONEY)에 따라 각 호봉별 금액을 순차적으로 계산한다.
			case "RATE_DISTR" :

				sal1Mon = parseInt(sal1Mon);
				// 인상방법에 따라 계산 방식이 달라딘다.
				switch(incType) {
					// 금액에 따른 인상일 경우
					case "MON" :
						resultMon = sal1Mon + (hobong) * parseInt(incMonRate);
						break;

					// 비율에 따른 인상일 경우
					case "RATE" :
						var incRate = parseFloat(incMonRate);
						// 2호봉 금액
						var tmpResultMon = sal1Mon * (1 + incRate);
						for (var i=1; i<hobong; i++) {
							tmpResultMon = tmpResultMon * (1 + incRate);
						}
						resultMon = tmpResultMon;
						break;

					default :
						resultMon = 0;
						break;
				}
				break;

			default :
				resultMon = 0;
				break;
		}

		if (resultMon == 0 || updownUnit <= 0) {
			return resultMon;
		}

		// 끝자리 추출
		var mod = resultMon % updownUnit;
		// 끝자리 처리 단위 이상의 값만 추출
		resultMon = resultMon - mod;

		switch(updownType) {
			case "1" : // 절상
				if (mod > 0) {
					resultMon = resultMon + updownUnit;
				}
				break;

			case "3" : // 절하
				// 절하일 경우 나머지를 제거한 값
				// resultMon = resultMon;
				break;

			case "5" : // 사사오입
				// 나머지를 끝자리 처리 단위로 나눈 결과를 반올림 하였을 때 1의 값이 나오면 절상의 경우와 동일
				if (Math.round(parseFloat(mod)/parseFloat(updownUnit)) == 1) {
					resultMon = resultMon + updownUnit;
				}
				// 그렇지 않으면 절하의 경우와 동일
		}
		//alert(resultMon);
		
		//console.log('resultMon : ' + resultMon);
		return resultMon;
	}


	/**
	 * 월단위 금액 : 입력된 금액과 시간단위에 따라 자동 결정된다
	 * salMon : 기준금액
	 * timeUnit :  시간단위 (Y: 연봉, M: 월급, D: 일급, H:시급)
	 * mDays : 월 근무일수
	 */
	function calcMonthMon(salMon, timeUnit) {

		var monthMon = 0;
		var mDays = $("#mDays").val();

		// 시간단위가 연봉일 경우 : 월단위금액 = 기준금액 / 12
		if (timeUnit == "Y") {
			monthMon = salMon / 12;
		// 시간단위가 월급일 경우 : 월단위금액 = 기준금액
		} else if (timeUnit == "M") {
			monthMon = salMon;
		// 시간단위가 일급일 경우 : 월단위금액 = 기준금액 * 월근무일수
		} else if (timeUnit == "D") {
			monthMon = salMon * mDays;
		// 시간단위가 시급일 경우 : 월단위금액 = 기준금액 * 월근무일수 * 8
		} else if (timeUnit == "H") {
			monthMon = salMon * mDays * 8;
		}

		return monthMon;
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payElementPopupSheet"){
            sheet1.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
            sheet1.SetCellValue(gPRow, "elementNm",   rv["elementNm"] );

	    }
	    if(pGubun == "payElementPopupSearch"){
	    	$("#searchElementCd").val(rv["elementCd"]);
            $("#searchElementNm").val(rv["elementNm"]);

            reloadSearchSdate();
            doAction1("Search");
	    }
	}

	// 급여테이블 반영 (P_CPN_BASE_SALCHANGE)
	function payTableApply(){
		var Row = sheet1.GetSelectRow();

		var jikgubCd = sheet1.GetCellValue(Row,"jikgubCd");
		var elementCd = sheet1.GetCellValue(Row,"elementCd");
		var sdate = sheet1.GetCellValue(Row,"sdate");

		if (confirm("급여테이블에 반영하시겠습니까?")) {
			params = "jikgubCd="+jikgubCd+"&elementCd="+elementCd+"&sdate="+sdate;

			ajaxCallCmd = "prcCpnBaseSalchange";
			var msg = callProc( params , ajaxCallCmd ) ;

			if(msg != "S") {
				alert( "급여테이블에 반영이 처리되지 않았습니다.\n [" + msg + "]");
				return;
			}else{
				alert("급여테이블에 반영이 완료되었습니다.");
				doAction1('Search');
			}
		}
	}

	// 개인 반영 (P_CPN_BASE_EMPSAL_UPD)
	function personalApply() {

		var Row = sheet1.GetSelectRow();

		var jikgubCd = sheet1.GetCellValue(Row,"jikgubCd");
		var elementCd = sheet1.GetCellValue(Row,"elementCd");
		var sdate = sheet1.GetCellValue(Row,"sdate");

		if (confirm("개인반영하시겠습니까?")) {

			params = "jikgubCd="+jikgubCd+"&elementCd="+elementCd+"&sdate="+sdate;

			ajaxCallCmd = "prcCpnBaseEmpsalUpd";
			var msg = callProc( params , ajaxCallCmd ) ;

			if(msg != "S") {
				alert( "개인반영이 처리되지 않았습니다.\n [" + msg + "]");
				return;
			}else{
				alert("개인반영이 완료되었습니다.");
				doAction1('Search');
			}
		}
	}

	//call procedure
	function callProc(params, ajaxCallCmd) {
		var msg;

		var data = ajaxCall("${ctx}/PayTblExchangeMgr.do?cmd="+ajaxCallCmd,params,false);

		//alert(JSON.stringify(data));

		if(data.Result.Code != "-1"){
			msg = "S";
		}else{
			msg = data.Result.Message;
		}
		return msg;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input id="searchJikgubCdDetail" name="searchJikgubCdDetail" type="hidden" class=""/>
		<input id="searchElementCdDetail" name="searchElementCdDetail" type="hidden" class=""/>
		<!-- 기준금액 및 시간단위에 따라 월단위금액을 계산하기 위해 필요한 월근무일수 -->
        <input type="hidden" id="mDays" name="mDays" value="0">
        <input type="hidden" id="mHour" name="mHour" value="0">
        <input type="hidden" id="searchSdateDetail" name="searchSdateDetail">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th class="hide">년도</th> 
						<td class="hide"><input id="searchYear" name="searchYear" type="text" class="text w40" maxlength="4"/> </td>
						<th><tit:txt mid='' mdef='직급' /></th>
						<td><select id="searchJikgubCd" name="searchJikgubCd"> </select> </td>
						<th><tit:txt mid='' mdef='항목명' /></th>
						<td>
							<input id="searchElementCd" name="searchElementCd" type="hidden" class="text" />
							<input id="searchElementNm" name="searchElementNm" type="text" class="text" readonly="readonly" onclick="elementSearchPopup('search');" value="선택하세요" />
							<img src="/common/images/icon/icon_search.png" onclick="elementSearchPopup('search');" style=" cursor:pointer;"  /></td>
						<th><tit:txt mid='' mdef='시작일' /></th>
						<td>
							<select id="searchSdate" name="searchSdate">
								<option value="" selected>전체</option>
							</select>
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt"><tit:txt mid='' mdef='변경내역  Master'/></li>
            <li class="btn">
				<btn:a href="javascript:doAction1('Insert')"	css="basic authR" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy')"		css="basic authR" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');"		css="basic authR" mid='save' mdef="저장"/>
				<btn:a href="javascript:detailReset();"			css="basic authR" mid='' mdef="작업"/>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt"><tit:txt mid='' mdef='변경내역 Detail'/></li>
            <li class="btn">
            	<btn:a href="javascript:doAction2('Search');" 		css="basic authR" mid='search' mdef="조회"/>
				<btn:a href="javascript:doAction2('Save');" 		css="basic authR" mid='save' mdef="저장"/>
    
				<!-- 프로시져 에러로 인한 임시 주석처리
                <btn:a href="javascript:payTableApply();" 			css="basic authA" mid='' mdef="급여테이블반영"/>
				<btn:a href="javascript:personalApply();" 			css="basic authA" mid='' mdef="개인반영"/>-->
				<btn:a href="javascript:doAction2('Down2Excel');" 	css="basic authR" mid='download' mdef="다운로드"/>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
    <div class="outer">
		<p><font color="black" size="2">
			&nbsp;<b># 작업 순서 및 주의 사항</b><br>
			&nbsp;&nbsp; 1. 조회조건을 선택하십시오. [주의 : 하단의 <b>'변경내역 Detail'</b>의 시작일자 및 종료일자를 임의로 변경하시지 마십시오.]<br>
			&nbsp;&nbsp; 2. 상단의 <b>'변경내역 Master'</b>에 데이터를 입력합니다. [주의: <b>Status</b>를 <b>'급여테이블반영전'</b>으로 선택하여 저장하십시오.]<br>
			&nbsp;&nbsp; 3. 상단의 <b>'변경내역 Master'</b>의 저장 버튼을 클릭합니다.<br>
			&nbsp;&nbsp; 4. 상단의 <b>'변경내역 Master'</b>의 작업 버튼을 클릭합니다. [하단의 <b>'변경내역 Detail'</b>에 해당 내역이 반영되어 나타납니다.]<br>
			&nbsp;&nbsp; 5. 하단의 <b>'변경내역 Detail</b>'의 내역이 맞는지 확인 후 저장 버튼을 클릭합니다.<br>
			&nbsp;&nbsp; 6. 하단의 <b>'변경내역 Detail'</b>의 급여테이블반영 버튼을 클릭합니다. [상단의 <b>'변경내역 Master'</b>의 <b>Status</b>가 <b>'급여테이블반영'</b>으로 자동 변경됩니다.]<br>
			&nbsp;&nbsp; 7. 왼쪽 메뉴 중 <b>'급여테이블관리'</b>를 선택하여 해당 작업이 정상적으로 반영되었는지 확인하시기 바랍니다.
		</font></p>
	</div>
    <iframe id="hIframe" name="hIframe" width="0" height="0" style="visibility:hidden;"></iframe>
</div>
</body>
</html>
