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
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"직급",		Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },     
			{Header:"성별",		Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"sexType",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },     
			{Header:"항목코드",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },     
			{Header:"항목명",		Type:"Popup",     Hidden:0,  Width:130	,Align:"Left",    ColMerge:0,   SaveName:"elementNm",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },     
			{Header:"시간단위",	Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"timeUnit",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },     
			{Header:"통화단위",	Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },     
			{Header:"시작일자",	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"종료일자",	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		];

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
			
		sheet1.SetColProperty("sexType", 			{ComboText:"|전체|남자|여자", ComboCode:"|0|1|2"} );
		
		//Detail Sheet(sheet2)
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"직급",		Type:"Combo",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },     
			{Header:"성별",		Type:"Text",      Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"sexType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },                               
			{Header:"항목코드",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },                              
			{Header:"호봉",		Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"salClass",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },                                  
			{Header:"직위",		Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },                              
			{Header:"금액",		Type:"Int",       Hidden:0,  Width:135,  Align:"Right",   ColMerge:0,   SaveName:"salMon",      KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },                              
			{Header:"월단위금액",	Type:"Int",       Hidden:0,  Width:140,  Align:"Right",   ColMerge:0,   SaveName:"monthMon",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },              
			{Header:"MAX",		Type:"Int",       Hidden:1,  Width:140,  Align:"Right",   ColMerge:0,   SaveName:"maxMon",		KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },              
			{Header:"시작일자",	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"종료일자",	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		]; 
		IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		getCommonJikgubCdList();

		$("#searchBaseDate").change(function () {
			getCommonJikgubCdList();
		});

		$("#searchJikgubCd").bind("change",function(event){
			doAction1("Search");
		});
		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchYear").val("<%=DateUtil.getCurrentTime("yyyy")%>") ;
		$(window).smartresize(sheetResize); sheetInit();


		//기준일자 날짜형식, 날짜선택 시
		$("#searchBaseDate").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});

		doAction1("Search");
	});

	function getCommonJikgubCdList() {
		var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010", $("#searchBaseDate").val()), "전체");
		//화면구성
		$("#searchJikgubCd").html(jikgubCdList[2]) ;
	}

	function getCommonCodeList() {
		// 직급
		var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010", $("#searchBaseDate").val()), "전체");
		sheet1.SetColProperty("jikgubCd", 			{ComboText:"|"+jikgubCdList[0], ComboCode:"|"+jikgubCdList[1]} );
		// 시간단위
		var timeUnitList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00010", $("#searchBaseDate").val()), "");
		sheet1.SetColProperty("timeUnit", 			{ComboText:"|"+timeUnitList[0], ComboCode:"|"+timeUnitList[1]} );
		// 통화단위
		var currencyCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030", $("#searchBaseDate").val()), "");
		sheet1.SetColProperty("currencyCd", 			{ComboText:"|"+currencyCdList[0], ComboCode:"|"+currencyCdList[1]} );

		// 직급
		var jikgubCdList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010", $("#searchBaseDate").val()), "전체");
		sheet2.SetColProperty("jikgubCd", 			{ComboText:"|"+jikgubCdList2[0], ComboCode:"|"+jikgubCdList2[1]} );

		// 호봉
		var salClassList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C10000", $("#searchBaseDate").val()), "");
		sheet2.SetColProperty("salClass",	{ComboText:"|"+salClassList[0], ComboCode:"|"+salClassList[1]}	);
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/PayTblGrpMgr.do?cmd=getPayTblGrpMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
			if(!dupChk(sheet1,"jikgubCd|sexType|elementCd|elementNm|sdate", false, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PayTblGrpMgr.do?cmd=savePayTblGrpMgr", $("#srchFrm").serialize()); break;
		case "Insert":	var newRow = sheet1.DataInsert(0); 
						break;
		case "Copy":	var Row = sheet1.DataCopy();
						break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|4|5|6|7|8|9|10"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
			// OnClick이벤트 -> OnSelectCell이벤트 변경에 따라 중복 조회 되므로 주석처리
			//if( sheet1.LastRow() > 0 ) {
			//	$("#sheet1JikgubCd").val( sheet1.GetCellValue(1,"jikgubCd") ) ;
	        //    $("#sheet1ElementCd").val( sheet1.GetCellValue(1,"elementCd") ) ;
	        //    $("#sheet1SexType").val( sheet1.GetCellValue(1,"sexType") ) ;
	        //    $("#searchSdate").val( sheet1.GetCellValue(1,"sdate") ) ;
			//	doAction2('Search') ;
			//}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 클릭 시 마다 sheet2를 조회하게 되어 sheet1의 콤보를 선택할 수 없음.
	//function sheet1_OnClick(Row, Col, Value) {
    //    try{
    //        if(sheet1.GetCellValue(Row,"sStatus") != "I" && sheet1.ColSaveName(Col) != "sDelete" ){
	//            $("#sheet1JikgubCd").val( sheet1.GetCellValue(Row,"jikgubCd") ) ;
	//            $("#sheet1ElementCd").val( sheet1.GetCellValue(Row,"elementCd") ) ;
	//            $("#sheet1SexType").val( sheet1.GetCellValue(Row,"sexType") ) ;
	//            $("#searchSdate").val( sheet1.GetCellValue(Row,"sdate") ) ;
    //            doAction2("Search");
    //        }
    //    }catch(ex){alert("OnClick Event Error : " + ex);}
    //}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if (NewRow < sheet1.HeaderRows()) return;
			if (OldRow == NewRow) return;
			
			$("#sheet1JikgubCd").val(sheet1.GetCellValue(NewRow, "jikgubCd"));
			$("#sheet1ElementCd").val(sheet1.GetCellValue(NewRow, "elementCd"));
			$("#sheet1SexType").val(sheet1.GetCellValue(NewRow, "sexType"));
			$("#searchSdate").val(sheet1.GetCellValue(NewRow, "sdate"));
			
			doAction2("Search");
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
        try{
        	if(Row > 0 && sheet1.ColSaveName(Col) == "elementNm" && sheet1.GetCellValue(Row,"sStatus") == "I"){
             	elementSearchPopup(Row, Col);
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
		case "Search": 	 	sheet2.DoSearch( "${ctx}/PayTblGrpMgr.do?cmd=getPayTblGrpMgrList2", $("#srchFrm").serialize() ); break;
		case "Save": 		
			if(sheet1.LastRow() < 1) { alert("급여테이블 Master 데이터를 선택하여 주십시오.") ; return ;}
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I") { alert("급여테이블 Master 데이터를 먼저 저장해 주세요"); return; }
			for(var i = 1; i < sheet2.RowCount()+1; i++ ) {
				if( sheet2.GetCellValue(i, "jikgubCd") == "") {
					sheet2.SetCellValue(i, "jikgubCd", sheet1.GetCellValue(sheet1.GetSelectRow(),"jikgubCd") ) ;
				} 
				if(sheet2.GetCellValue(i, "sexType") == "" ) {
					sheet2.SetCellValue(i, "sexType", sheet1.GetCellValue(sheet1.GetSelectRow(),"sexType") ) ;
				}
				if(sheet2.GetCellValue(i, "elementCd") == "" ) {
					sheet2.SetCellValue(i, "elementCd", sheet1.GetCellValue(sheet1.GetSelectRow(),"elementCd") ) ;
				}
			}
			if(!dupChk(sheet2,"jikgubCd|sexType|elementCd|salClass|sdate", false, true)){break;}
			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave( "${ctx}/PayTblGrpMgr.do?cmd=savePayTblGrpMgr2", $("#srchFrm").serialize()); break;
		case "Insert":	if(sheet1.LastRow() < 1) { alert("급여테이블 Master 데이터를 선택하여 주십시오.") ; return ;}
						else if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I") { alert("급여테이블 Master 데이터를 먼저 저장해 주세요"); return; }
						else if(sheet1.GetCellValue(sheet1.GetSelectRow(),"jikgubCd") == "") { alert("직급 자료를 선택해 주세요") ; return ; }
						var newRow = sheet2.DataInsert(0); 
						sheet2.SetCellValue(newRow, "jikgubCd", sheet1.GetCellValue(sheet1.GetSelectRow(),"jikgubCd"));
						sheet2.SetCellValue(newRow, "elementCd", sheet1.GetCellValue(sheet1.GetSelectRow(),"elementCd"));
						sheet2.SetCellValue(newRow, "sexType", sheet1.GetCellValue(sheet1.GetSelectRow(),"sexType"));
						sheet2.SetCellValue(newRow, "sdate", sheet1.GetCellValue(sheet1.GetSelectRow(),"sdate"));
						break;
		case "Copy":	var Row = sheet2.DataCopy();
						break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"6|8|9|11|12"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
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
	        var timeUnit = sheet1.GetCellValue(sheet1.GetSelectRow(), "timeUnit");
	        
	        // 월단위금액
	        var monthMon = 0;
	        
	        // 월근무일수
	        var mDays = $("#mDays").val();
	        
	        // 일인정시간
	        var mHour = $("#mHour").val();
	        
	        // 시간단위가 연봉일 경우 : 월단위금액 = 기준금액 / 12
	        if (timeUnit == "Y") {
	            monthMon = salMon / 12;
	        // 시간단위가 월급일 경우 : 월단위금액 = 기준금액
	        } else if (timeUnit == "M") {
	            monthMon = salMon;
	        // 시간단위가 일급일 경우 : 월단위금액 = 기준금액 * 월근무일수
	        } else if (timeUnit == "D") {
	            monthMon = salMon * mDays;
	        // 시간단위가 시급일 경우 : 월단위금액 = 기준금액 * 월근무일수 * 일인정시간
	        } else if (timeUnit == "H") {
	            monthMon = salMon * mDays * mHour;
	        }
	        
	        sheet2.SetCellValue(Row, "monthMon",monthMon);
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
	
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
	
	/*
	script
	*/
	// 항목검색 팝업
	function elementSearchPopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'payElementLayer'
			, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
			, parameters : {
				elementCd : sheet1.GetCellValue(Row, "elementCd")
				, elementNm : sheet1.GetCellValue(Row, "elementNm")
				, elementType : 'A'
			}
			, width : 860
			, height : 520
			, title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>'
			, trigger :[
				{
					name : 'payTrigger'
					, callback : function(result){
						sheet1.SetCellValue(Row, "elementCd",   result.resultElementCd);
						sheet1.SetCellValue(Row, "elementNm",   result.resultElementNm);
					}
				}
			]
		});
		layerModal.show();




		// var w		= 840;
		// var h		= 520;
		// var url		= "/PayElementPopup.do?cmd=payElementPopup";
		// var args	= new Array();
		//
		// args["elementType"] = "A"; // 수당
		//
		// if(!isPopup()) {return;}
		// gPRow = Row;
		// pGubun = "payElementPopup";
		// openPopup(url+"&authPg=R", args, w, h);

		/*
		if (result) {
			var elementCd	= result["elementCd"];
			var elementNm	= result["elementNm"];

			sheet1.SetCellValue(Row, "elementCd", elementCd);
			sheet1.SetCellValue(Row, "elementNm", elementNm);
		}
		*/
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payElementPopup"){
            sheet1.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
            sheet1.SetCellValue(gPRow, "elementNm",   rv["elementNm"] );
	    }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input id="sheet1JikgubCd" name="sheet1JikgubCd" type="hidden" class=""/> 
		<input id="sheet1ElementCd" name="sheet1ElementCd" type="hidden" class=""/> 
		<input id="sheet1SexType" name="sheet1SexType" type="hidden" class=""/> 
		<!-- 기준금액 및 시간단위에 따라 월단위금액을 계산하기 위해 필요한 월근무일수 -->
        <input type="hidden" name="mDays" value="0">
        <input type="hidden" name="mHour" value="0">
        <input type="hidden" id="searchSdate" name="searchSdate">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<!--  <td> <th>년도</th> <input id="searchYear" name="searchYear" type="text" class="text w40" maxlength="4"/> </td>-->
						<th><tit:txt mid='103906' mdef='기준일자'/>  </th>
						<td>  <input id="searchBaseDate" name="searchBaseDate" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
						<th>직급 </th>
						<td>  <select id="searchJikgubCd" name="searchJikgubCd"> </select> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">급여테이블 Master</li>
            <li class="btn">
				<a href="javascript:doAction1('DownTemplate')" class="basic authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" class="basic authA">업로드</a>
				<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">급여테이블 Detail</li>
            <li class="btn">
            	<a href="javascript:doAction2('Search')" id="btnSearch" class="button">조회</a>
				<a href="javascript:doAction2('DownTemplate')" class="basic authA">양식다운로드</a>
				<a href="javascript:doAction2('LoadExcel')" class="basic authA">업로드</a>
				<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
				<a href="javascript:doAction2('Copy')" 	class="basic authA">복사</a>
				<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>
				<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
</div>
</body>
</html>
