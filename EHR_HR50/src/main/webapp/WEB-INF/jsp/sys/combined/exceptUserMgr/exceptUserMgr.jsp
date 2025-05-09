<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {	
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='enterCd_V3456' mdef='소속회사'/>",			Type:"Combo",     Hidden:0,  Width:75,  Align:"Center",  ColMerge:0,   SaveName:"enterCd",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13,	Cursor:"" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",      Hidden:0,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"sabun",     		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13,	Cursor:"" },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",      Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"name",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100,Cursor:"" },
			{Header:"<sht:txt mid='ename1' mdef='영문성명'/>",			Type:"Text",      Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"ename1",    		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100,Cursor:"" },
			{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",				Type:"Combo",     Hidden:0,  Width:90,  Align:"Left",	  ColMerge:0,   SaveName:"locationCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='tLocationCd' mdef='통합소속\n근무지'/>",	Type:"Combo",     Hidden:0,  Width:90,  Align:"Left",	  ColMerge:0,   SaveName:"tLocationCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",			Type:"Text",      Hidden:1,  Width:0,  Align:"Left",    ColMerge:0,   SaveName:"orgCd",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100,Cursor:"" },
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",				Type:"Popup",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100,Cursor:"" },
			{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",			Type:"Text",      Hidden:0,  Width:110,  Align:"Center",  ColMerge:0,   SaveName:"resNo",     		KeyField:0,   CalcLogic:"",   Format:"IdNo",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13,	Cursor:"" },
			{Header:"<sht:txt mid='mailId' mdef='메일주소'/>",			Type:"Text",      Hidden:0,  Width:130,  Align:"Left",    ColMerge:0,   SaveName:"mailId",    		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100,Cursor:"" },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",				Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='tJikweeCd' mdef='통합소속\n직위'/>",		Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"tJikweeCd",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",				Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"jikchakCd", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='tJikchakCd' mdef='통합소속\n직책'/>",		Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"tJikchakCd", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",			Type:"Date",      Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"birYmd",    		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='lunType_V3211' mdef='생일구분'/>",			Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"lunType",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",			Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"manageCd",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",				Type:"Date",      Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"empYmd",    		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='fpromYmd' mdef='직급변경일'/>",			Type:"Date",      Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"fpromYmd",  		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",				Type:"Date",      Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"retYmd",    		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='agbnYn' mdef='인사연동\n예외자'/>",	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"agbnYn",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"", TrueValue:'Y', FalseValue:'N'},
			{Header:"<sht:txt mid='bgbnYn' mdef='비정규직\n연동자'/>",	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"bgbnYn",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"", TrueValue:'Y', FalseValue:'N'},
			{Header:"<sht:txt mid='cgbnYn' mdef='사외메일\n연동\n예외자'/>",	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"cgbnYn",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"", TrueValue:'Y', FalseValue:'N'},
			{Header:"<sht:txt mid='dgbnYn' mdef='사외메일\n영문이름\n사용자'/>",	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"dgbnYn",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"", TrueValue:'Y', FalseValue:'N'},
			{Header:"<sht:txt mid='pwareYn' mdef='PWARE\n사용여부'/>",	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"pwareYn",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"", TrueValue:'Y', FalseValue:'N'},
			{Header:"<sht:txt mid='pwareIdYn' mdef='PWARE계정\n사용여부'/>",	Type:"CheckBox",  Hidden:0,  Width:65,   Align:"Center",  ColMerge:0,   SaveName:"pwareIdYn", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"", TrueValue:'Y', FalseValue:'N' },
			{Header:"<sht:txt mid='outlookYn' mdef='아웃룩\n사용여부'/>",	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"outlookYn", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"", TrueValue:'Y', FalseValue:'N' },
			{Header:"<sht:txt mid='officeTel_V6910' mdef='회사전화'/>",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"officeTel", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200,Cursor:"" },
			{Header:"<sht:txt mid='homeTel' mdef='집전화'/>",				Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"homeTel",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20,	Cursor:"" },
			{Header:"<sht:txt mid='faxNo' mdef='팩스번호'/>",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"faxNo",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20,	Cursor:"" },
			{Header:"<sht:txt mid='handPhone_V4332' mdef='이동전화'/>",			Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"handPhone", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20,	Cursor:"" },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",			Type:"Popup",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"zip",       		KeyField:0,   CalcLogic:"",   Format:"PostNo",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"" },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",				Type:"Text",      Hidden:0,  Width:230,  Align:"Left",  ColMerge:0,   SaveName:"addr1",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500,Cursor:"" },
			{Header:"<sht:txt mid='addr2' mdef='상세주소'/>",			Type:"Text",      Hidden:0,  Width:230,  Align:"Left",  ColMerge:0,   SaveName:"addr2",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500,Cursor:"" },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		var tLocationCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20045"), "");	//통합소속_근무지
		var tJikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20050"), "");	//통합소속_직위
		var tJikchakCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20040"), "");	//통합소속_직책
		var jikgubCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");	//직급
		var jikchakCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");	//직책
		var jikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");	//직위
		var manageCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");	//사원구분
		var locationCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION
		var enterCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEnterCdAllList&enterCd=",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");	//LOCATION
		$("#searchEnterCd").html(enterCdList[2]);
		sheet1.SetColProperty("tLocationCd", 		{ComboText:"|"+tLocationCdList[0], ComboCode:"|"+tLocationCdList[1]} );
		sheet1.SetColProperty("tJikweeCd", 			{ComboText:"|"+tJikweeCdList[0], ComboCode:"|"+tJikweeCdList[1]} );
		sheet1.SetColProperty("tJikchakCd", 		{ComboText:"|"+tJikchakCdList[0], ComboCode:"|"+tJikchakCdList[1]} );
		sheet1.SetColProperty("jikchakCd", 			{ComboText:"|"+jikchakCdList[0], ComboCode:"|"+jikchakCdList[1]} );
		sheet1.SetColProperty("jikweeCd", 			{ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );	
		sheet1.SetColProperty("manageCd", 			{ComboText:"|"+manageCdList[0], ComboCode:"|"+manageCdList[1]} );	
		sheet1.SetColProperty("locationCd", 		{ComboText:"|"+locationCdList[0], ComboCode:"|"+locationCdList[1]} );
		sheet1.SetColProperty("lunType", 			{ComboText:"|양력|음력", ComboCode:"|1|0"} );
		sheet1.SetColProperty("enterCd", 			{ComboText:"|"+enterCdList[0], ComboCode:"|"+enterCdList[1]} );
		
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchFromEmpYmd").datepicker2({startdate:"searchToEmpYmd"});
		$("#searchToEmpYmd").datepicker2({enddate:"searchFromEmpYmd"});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/ExceptUserMgr.do?cmd=getExceptUserMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/ExceptUserMgr.do?cmd=saveExceptUserMgr", $("#srchFrm").serialize() ); break;
		case "Insert":	
			employeePopup() ;
			//var newRow = sheet1.DataInsert() ;
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "zip") {
	            var rst = openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
	            if(rst != null){
	            	sheet1.SetCellValue(Row, "zip", rst["zip"]);
	            	sheet1.SetCellValue(Row, "addr1", rst["sido"]+ " "+ rst["gugun"] +" " + rst["dong"]);
	            	sheet1.SetCellValue(Row, "addr2", rst["bunji"]);
	            }
			}
			if(sheet1.ColSaveName(Col) == "orgNm") {
				var args    = new Array();
				args["enterCd"]	        = sheet1.GetCellValue(Row, "enterCd") ;
	            var rst = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=${authPg}", args, "740","620");
	            if(rst != null){
	            	sheet1.SetCellValue(Row, "orgCd", rst["orgCd"]);
	            	sheet1.SetCellValue(Row, "orgNm", rst["orgNm"]);
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}	

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	exceptUserMgrPopup(Row);    
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}		
	}
	
	/**
	 * 상세내역 window open event
	 */
	function exceptUserMgrPopup(Row, state){
  		var w 		= 750;
		var h 		= 660;
		var url 	= "${ctx}/ExceptUserMgr.do?cmd=exceptUserMgrPopup&authPg=${authPg}";
		var args 	= new Array();
		if( state != "I" ) {
			args["enterCd"]	        = sheet1.GetCellValue(Row, "enterCd");
			args["sabun"]           = sheet1.GetCellValue(Row, "sabun");
			args["name"]            = sheet1.GetCellValue(Row, "name");
			args["ename1"]		    = sheet1.GetCellValue(Row, "ename1");
			args["locationCd"]	    = sheet1.GetCellValue(Row, "locationCd");
			args["tLocationCd"]	    = sheet1.GetCellValue(Row, "tLocationCd");
			args["orgCd"]		    = sheet1.GetCellValue(Row, "orgCd");
			args["orgNm"]		    = sheet1.GetCellValue(Row, "orgNm");
			args["resNo"]		    = sheet1.GetCellText(Row, "resNo");
			args["mailId"]		    = sheet1.GetCellValue(Row, "mailId");
			args["jikweeCd"]	    = sheet1.GetCellValue(Row, "jikweeCd");
			args["tJikweeCd"]	    = sheet1.GetCellValue(Row, "tJikweeCd");
			args["jikchakCd"]	    = sheet1.GetCellValue(Row, "jikchakCd");
			args["tJikchakCd"]	    = sheet1.GetCellValue(Row, "tJikchakCd");
			args["birYmd"]		    = sheet1.GetCellText(Row, "birYmd");
			args["lunType"]		    = sheet1.GetCellValue(Row, "lunType");
			args["manageCd"]	    = sheet1.GetCellValue(Row, "manageCd");
			args["empYmd"]		    = sheet1.GetCellText(Row, "empYmd");
			args["fpromYmd"]	    = sheet1.GetCellText(Row, "fpromYmd");
			args["retYmd"]		    = sheet1.GetCellText(Row, "retYmd");
			args["agbnYn"]		    = sheet1.GetCellValue(Row, "agbnYn");
			args["bgbnYn"]		    = sheet1.GetCellValue(Row, "bgbnYn");
			args["cgbnYn"]		    = sheet1.GetCellValue(Row, "cgbnYn");
			args["dgbnYn"]		    = sheet1.GetCellValue(Row, "dgbnYn");
			args["pwareYn"]		    = sheet1.GetCellValue(Row, "pwareYn");
			args["pwareIdYn"]	    = sheet1.GetCellValue(Row, "pwareIdYn");
			args["outlookYn"]	    = sheet1.GetCellValue(Row, "outlookYn");
			args["officeTel"]	    = sheet1.GetCellValue(Row, "officeTel");
			args["homeTel"]		    = sheet1.GetCellValue(Row, "homeTel");
			args["faxNo"]		    = sheet1.GetCellValue(Row, "faxNo");
			args["handPhone"]	    = sheet1.GetCellValue(Row, "handPhone");
			args["zip"]			    = sheet1.GetCellText(Row, "zip");
			args["addr1"]		    = sheet1.GetCellValue(Row, "addr1");
			args["addr2"]		    = sheet1.GetCellValue(Row, "addr2");
		}

		var rv = openPopup(url,args,w,h);
		if(rv!=null){
			if(state == "I") {
				var newRow = sheet1.DataInsert(0) ;
				Row = newRow ;
			}
			sheet1.SetCellValue(Row, "enterCd", 	rv["enterCd"]	 ) ;   
			sheet1.SetCellValue(Row, "sabun", 	    rv["sabun"]      ) ;
			sheet1.SetCellValue(Row, "name", 	    rv["name"]       ) ;
			sheet1.SetCellValue(Row, "ename1", 	    rv["ename1"]	 ) ;
			sheet1.SetCellValue(Row, "locationCd", 	rv["locationCd"] ) ;
			sheet1.SetCellValue(Row, "tLocationCd", rv["tLocationCd"] ) ;
			sheet1.SetCellValue(Row, "orgCd", 	    rv["orgCd"]		 ) ;
			sheet1.SetCellValue(Row, "orgNm", 	    rv["orgNm"]		 ) ;
			sheet1.SetCellValue(Row, "resNo", 	    rv["resNo"]		 ) ;
			sheet1.SetCellValue(Row, "mailId", 	    rv["mailId"]	 ) ;
			sheet1.SetCellValue(Row, "jikweeCd", 	rv["jikweeCd"]	 ) ;
			sheet1.SetCellValue(Row, "tJikweeCd", 	rv["tJikweeCd"]	 ) ;
			sheet1.SetCellValue(Row, "jikchakCd", 	rv["jikchakCd"]	 ) ;
			sheet1.SetCellValue(Row, "tJikchakCd", 	rv["tJikchakCd"]	 ) ;
			sheet1.SetCellValue(Row, "birYmd", 	    rv["birYmd"]	 ) ;
			rv["lunType"] == "1" ? sheet1.SetCellValue(Row, "lunType", 	"1"	 ) : sheet1.SetCellValue(Row, "lunType", 	"0"	 ) ; 
			//sheet1.SetCellValue(Row, "lunType", 	rv["lunType"]	 ) ;
			sheet1.SetCellValue(Row, "manageCd", 	rv["manageCd"]	 ) ;
			sheet1.SetCellValue(Row, "empYmd", 	    rv["empYmd"]	 ) ;
			sheet1.SetCellValue(Row, "fpromYmd", 	rv["fpromYmd"]	 ) ;
			sheet1.SetCellValue(Row, "retYmd", 	    rv["retYmd"]	 ) ;
			sheet1.SetCellValue(Row, "agbnYn", 		rv["agbnYn"]	 ) ;
			sheet1.SetCellValue(Row, "bgbnYn", 		rv["bgbnYn"]	 ) ;
			sheet1.SetCellValue(Row, "cgbnYn", 		rv["cgbnYn"]	 ) ;
			sheet1.SetCellValue(Row, "dgbnYn", 		rv["dgbnYn"]	 ) ;
			sheet1.SetCellValue(Row, "pwareYn", 	rv["pwareYn"]	 ) ;
			sheet1.SetCellValue(Row, "pwareIdYn", 	rv["pwareIdYn"]	 ) ;
			sheet1.SetCellValue(Row, "outlookYn", 	rv["outlookYn"]	 ) ;
			sheet1.SetCellValue(Row, "officeTel", 	rv["officeTel"]	 ) ;
			sheet1.SetCellValue(Row, "homeTel", 	rv["homeTel"]	 ) ;
			sheet1.SetCellValue(Row, "faxNo", 	    rv["faxNo"]		 ) ;
			sheet1.SetCellValue(Row, "handPhone", 	rv["handPhone"]	 ) ;
			sheet1.SetCellValue(Row, "zip", 	    replaceAll(rv["zip"],'-','')		 ) ;
			sheet1.SetCellValue(Row, "addr1", 	    rv["addr1"]		 ) ;
			sheet1.SetCellValue(Row, "addr2", 	    rv["addr2"]		 ) ;
		}
	}
	//사원 팝입
	function employeePopup(){
	    try{
	     
	     var args    = new Array();
	     if( $("#searchEnterCd").val() == "" ) { alert("<msg:txt mid='110370' mdef='등록할 예외사용자의 소속회사를 선택하십시오.'/>") ; $("#searchEnterCd").focus() ; return ;}
			args["searchEnterCd"]	        = $("#searchEnterCd").val() ;
	     var rv = openPopup("/Popup.do?cmd=employeePopup", args, "840","520");   
	        if(rv!=null){
	        	
				var newRow = sheet1.DataInsert(0) ;
				Row = newRow ;
				
	        	sheet1.SetCellValue(newRow, "enterCd", 		$("#searchEnterCd").val()) ;	
	        	sheet1.SetCellValue(newRow, "sabun", 		rv["sabun"] 	) ;	
	        	sheet1.SetCellValue(newRow, "name", 		rv["name"] 		) ;
	        	sheet1.SetCellValue(newRow, "empYmd", 		rv["empYmd"] 	) ;	
	        	sheet1.SetCellValue(newRow, "retYmd", 		rv["retYmd"] 	) ;	
	        	sheet1.SetCellValue(newRow, "jikchakCd", 	rv["jikchakCd"] ) ;	
	        	sheet1.SetCellValue(newRow, "jikweeCd", 	rv["jikweeCd"] 	) ;
	        	sheet1.SetCellValue(newRow, "manageCd", 	rv["manageCd"]	) ;	
	        	sheet1.SetCellValue(newRow, "orgCd", 		rv["orgCd"]    	) ;
	        	sheet1.SetCellValue(newRow, "orgNm", 		rv["orgNm"]    	) ;
	        	sheet1.SetCellValue(newRow, "locationCd", 	rv["locationCd"]) ;	
	        	sheet1.SetCellValue(newRow, "resNo", 		rv["resNo"]		) ;
	        	sheet1.SetCellValue(newRow, "birYmd", 		rv["birYmd"]	) ;
	        	sheet1.SetCellValue(newRow, "lunType", 		rv["lunType"]	) ;
	        }
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td><tit:txt mid='112561' mdef='소속회사'/></td>
						<td>				
							<select id="searchEnterCd" name="searchEnterCd" onchange="">
							</select> 	
						</td>
						<td><tit:txt mid='112562' mdef='예외구분'/></td>
						<td>				
							<select id="searchExptGbn" name="searchExptGbn" onchange="">
								<option value=""> 전체 </option>
								<option value="A"> 인사연동 예외처리자 </option>
								<option value="B"> 비정규직 중 연동대상자 </option>
								<option value="C"> 사외메일 연동예외자 </option>
								<option value="D"> 사외메일 영문이름 사용자 </option>
							</select> 	
						</td>
					</tr>
					<tr>
						<td><tit:txt mid='104330' mdef='사번/성명'/></td>
						<td> <input type="text" id="searchSbNm" name="searchSbNm" class="text"> </td>
						<td><tit:txt mid='103881' mdef='입사일'/></td>
						<td> <input type="text" id="searchFromEmpYmd" name="searchFromEmpYmd" class="date2" /> ~ <input type="text" id="searchToEmpYmd" name="searchToEmpYmd" class="date2" /> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112230' mdef='예외사용자관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
