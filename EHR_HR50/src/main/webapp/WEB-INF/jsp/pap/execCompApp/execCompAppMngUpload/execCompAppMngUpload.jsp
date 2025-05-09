<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:9,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			 {Header:"No|No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", 	ColMerge:0,  	SaveName:"sNo" },
			 {Header:"삭제|삭제",						Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", 	ColMerge:0,  	SaveName:"sDelete" },
			 {Header:"상태|상태",						Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", 	ColMerge:0,  	SaveName:"sStatus" },
			 {Header:"연도|연도", 						Type:"Number", 		Hidden:1,  					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"year", 			KeyField:0, Format:"",			UpdateEdit:0, InsertEdit:1,	 PointCount:0,   EditLen:4 },
			 {Header:"기준일자|기준일자",				Type:"Date",		Hidden:0,  					Width:100,			Align:"Center",		ColMerge:0,		SaveName:"stdDt",			KeyField:0,	Format:"Ymd",		UpdateEdit:1, InsertEdit:1,	 PointCount:0,   EditLen:10 },
			 {Header:"구분|구분",						Type:"Text",  		Hidden:0,  					Width:80,   		Align:"Left",  		ColMerge:0,		SaveName:"gubun",       	KeyField:0, Format:"",  		UpdateEdit:1, InsertEdit:1,	 PointCount:0,   EditLen:30 },
			 {Header:"사번|사번",						Type:"Text",  	    Hidden:0,  					Width:80,   		Align:"Center",  	ColMerge:0,   	SaveName:"sabun",      		KeyField:1, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:13 },
			 {Header:"이름|이름",						Type:"Text",  		Hidden:0,  					Width:80,   		Align:"Center",  	ColMerge:0,   	SaveName:"name",       		KeyField:1, Format:"",  		UpdateEdit:0, InsertEdit:1,	 PointCount:0,   EditLen:100 },
			 {Header:"소속|소속",						Type:"Text",       	Hidden:0,  					Width:80,  			Align:"Center",    	ColMerge:0,   	SaveName:"enterCd",     	KeyField:1, Format:"",  		UpdateEdit:0, InsertEdit:1,	 PointCount:0,   EditLen:100 },
			 {Header:"조직|조직",						Type:"Text",       	Hidden:0,  					Width:300,  		Align:"Left",    	ColMerge:0,   	SaveName:"orgNm",      		KeyField:0, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:100 },
			 {Header:"그룹직급|그룹직급",				Type:"Text",       	Hidden:0,  					Width:70,  			Align:"Center",    	ColMerge:0,   	SaveName:"grpGikgub",  		KeyField:0, Format:"",  		UpdateEdit:1, InsertEdit:1,	 PointCount:0,   EditLen:100 },
			 {Header:"리더십역량 평가 (종합)|고객중심", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"collScr01", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2},
			 {Header:"리더십역량 평가 (종합)|주인정신", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"collScr02", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (종합)|소통/협업", 	Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"collScr03", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (종합)|본질/과정", 	Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"collScr04", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (종합)|역량총점", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"collScr05", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (상향)|고객중심", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"upperScr01", 		KeyField:0, Format:"NullFloat",	UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (상향)|주인정신", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"upperScr02", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (상향)|소통/협업", 	Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"upperScr03", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (상향)|본질/과정", 	Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"upperScr04", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십역량 평가 (상향)|역량총점", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"upperScr05", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"하향|하향", 						Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"lowerScr", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"수평|수평", 						Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"horizScr", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더만족도|리더만족도", 			Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"leaderScr", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"본인|본인", 						Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"selfScr",	 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"리더십유형|두드러지는", 			Type:"Text", 		Hidden:0, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"leaderDiv01", 	KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1, 				 EditLen:30},
			 {Header:"리더십유형|필요한", 				Type:"Text", 		Hidden:0, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"leaderDiv02", 	KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1, 				 EditLen:30},
			 {Header:"업무스타일|두드러지는", 			Type:"Text", 		Hidden:0, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"jobstDiv01", 		KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1, 				 EditLen:30 },
			 {Header:"업무스타일|필요한", 				Type:"Text", 		Hidden:0, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"jobstDiv02", 		KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1, 				 EditLen:30 },
			 {Header:"업무스타일상세|소통", 				Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"jobstDetail01", 	KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"업무스타일상세|대인관계", 			Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"jobstDetail02", 	KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"업무스타일상세|혁신추구", 			Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"jobstDetail03", 	KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"업무스타일상세|추진력", 			Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"jobstDetail04", 	KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"평가자수|전체", 					Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCnt01", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"평가자수|상향", 					Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCnt02", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"평가자수|하향", 					Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCnt03", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"평가자수|수평", 					Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCnt04", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"평가자수|본인", 					Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCnt05", 		KeyField:0, Format:"NullFloat", UpdateEdit:1, InsertEdit:1,  PointCount:2 },
			 {Header:"주관식자료 raw|강점", 				Type:"Text", 		Hidden:0, 					Width:300, 			Align:"Left", 	ColMerge:0,		SaveName:"note01", 			KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1, 				 EditLen:10000 },
			 {Header:"주관식자료 raw|약점", 				Type:"Text", 		Hidden:0, 					Width:300, 			Align:"Left", 	ColMerge:0,		SaveName:"note02", 			KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1,					 EditLen:10000},
			 {Header:"<sht:txt mid='btnFile' mdef='첨부파일|첨부파일'/>",	
				 									Type:"Html",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			 {Header:"파일순번", 						Type:"Text", 		Hidden:1, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"fileSeq", 		KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1 },
			 {Header:"비고", 							Type:"Text", 		Hidden:1, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"note", 			KeyField:0, Format:"", 			UpdateEdit:1, InsertEdit:1 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var param = "&searchCodeNm=1";
		var codeLists = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getEmpInfoChangeTableMgrCodeList"+param, false).codeList, "code,codeNm", " ");
		sheet1.SetColProperty("empTable",  	{ComboText:"|"+codeLists[0], ComboCode:"|"+codeLists[1]} ); //담당자
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		$("#searchYear").bind("keyup",function(event){
        	makeNumber(this,"A");
    		if( event.keyCode == 13){
    			doAction1("Search");
    		}
    	});
		
		doAction1("Search");
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "orgNm",		rv["allOrgNm"] == null || rv["allOrgNm"].trim() == "" ? rv["allOrgNm"] : rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "enterCd",	rv["enterCd"]);
					}
				}
			]
		});		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchYear").val() == ""){
				alert("<msg:txt mid='109901' mdef='평가년도를 입력하세요.'/>");
				return;
			}			
			sheet1.DoSearch( "${ctx}/ExecCompAppMngUpload.do?cmd=getExecCompAppMngUploadList", $("#sheetForm").serialize()); break;
		case "Save": 		
			if(!dupChk(sheet1,"sabun|name|enterCd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/ExecCompAppMngUpload.do?cmd=savePsnalLangMgr", $("#sheet1Form").serialize()); break;
		case "Insert":		
			var vnNewIndex = sheet1.DataInsert(0);
			sheet1.SetCellValue(vnNewIndex, "year", $("#searchYear").val());
			sheet1.SetCellValue(vnNewIndex, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>', false);
			sheet1.SetCellValue(vnNewIndex, "stdDt", ${curSysYyyyMMdd});
			//sheet1.SelectCell(vnNewIndex, "stdDt"); 
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 })); 
			break;
		case "LoadExcel":
			//debugger
			//var params = {ColumnMapping:'|||1|2|4|3||||'};
			//sheet1.LoadExcel(params); 
			//var params = {ColumnMapping:'||||||||1|2|3'};
			sheet1.LoadExcel({ ColumnMapping:'0||||1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36', StartRow: "2"});
			//sheet1.LoadExcel({ ColumnMapping:'1|1|1|1|1|2|3|4|5|6', StartRow: "4"});
			//sheet1.LoadExcel();
			break;
		}
	}
	
	function sheet1_OnLoadExcel() {
		var rowCnt = sheet1.RowCount();
		for(var i=sheet1.HeaderRows();i<sheet1.RowCount()+sheet1.HeaderRows();i++){
			//sheet1.SetCellValue(i, "note01", "", false);
			//sheet1.SetCellValue(i, "note02", "", false);
			
			sheet1.SetCellValue(i, "year", $("#searchYear").val());
			sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>', false);
			sheet1.SetCellValue(i, "collScr01", sheet1.GetCellValue(i, "collScr01") != "" ? sheet1.GetCellValue(i, "collScr01").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "collScr02", sheet1.GetCellValue(i, "collScr02") != "" ? sheet1.GetCellValue(i, "collScr02").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "collScr03", sheet1.GetCellValue(i, "collScr03") != "" ? sheet1.GetCellValue(i, "collScr03").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "collScr04", sheet1.GetCellValue(i, "collScr04") != "" ? sheet1.GetCellValue(i, "collScr04").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "collScr05", sheet1.GetCellValue(i, "collScr05") != "" ? sheet1.GetCellValue(i, "collScr05").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "upperScr01", sheet1.GetCellValue(i, "upperScr01") != "" ? sheet1.GetCellValue(i, "upperScr01").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "upperScr02", sheet1.GetCellValue(i, "upperScr02") != "" ? sheet1.GetCellValue(i, "upperScr02").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "upperScr03", sheet1.GetCellValue(i, "upperScr03") != "" ? sheet1.GetCellValue(i, "upperScr03").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "upperScr04", sheet1.GetCellValue(i, "upperScr04") != "" ? sheet1.GetCellValue(i, "upperScr04").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "upperScr05", sheet1.GetCellValue(i, "upperScr05") != "" ? sheet1.GetCellValue(i, "upperScr05").toFixed(2) : null, false);
			
			sheet1.SetCellValue(i, "lowerScr",  	sheet1.GetCellValue(i, "lowerScr") != "" ? sheet1.GetCellValue(i, "lowerScr").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "horizScr",  	sheet1.GetCellValue(i, "horizScr") != "" ? sheet1.GetCellValue(i, "horizScr").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "leaderScr", 	sheet1.GetCellValue(i, "leaderScr") != "" ? sheet1.GetCellValue(i, "leaderScr").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "selfScr",   	sheet1.GetCellValue(i, "selfScr") != "" ? sheet1.GetCellValue(i, "selfScr").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "jobstDetail01", sheet1.GetCellValue(i, "jobstDetail01") != "" ?sheet1.GetCellValue(i, "jobstDetail01").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "jobstDetail02", sheet1.GetCellValue(i, "jobstDetail02") != "" ?sheet1.GetCellValue(i, "jobstDetail02").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "jobstDetail03", sheet1.GetCellValue(i, "jobstDetail03") != "" ?sheet1.GetCellValue(i, "jobstDetail03").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "jobstDetail04", sheet1.GetCellValue(i, "jobstDetail04") != "" ?sheet1.GetCellValue(i, "jobstDetail04").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "apprCnt01", sheet1.GetCellValue(i, "apprCnt01") != "" ? sheet1.GetCellValue(i, "apprCnt01").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "apprCnt02", sheet1.GetCellValue(i, "apprCnt02") != "" ? sheet1.GetCellValue(i, "apprCnt02").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "apprCnt03", sheet1.GetCellValue(i, "apprCnt03") != "" ? sheet1.GetCellValue(i, "apprCnt03").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "apprCnt04", sheet1.GetCellValue(i, "apprCnt04") != "" ? sheet1.GetCellValue(i, "apprCnt04").toFixed(2) : null, false);
			sheet1.SetCellValue(i, "apprCnt05", sheet1.GetCellValue(i, "apprCnt05") != "" ? sheet1.GetCellValue(i, "apprCnt05").toFixed(2) : null, false);
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if (Msg != ""){ 
				alert(Msg); 
			} 
			
            for(var i=sheet1.HeaderRows();i<sheet1.RowCount()+sheet1.HeaderRows();i++){
				if(sheet1.GetCellValue(i,"fileSeq") == ''){
					sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>', false);
					sheet1.SetCellValue(i, "sStatus", 'R', false);
				}else{
					sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>', false);
					sheet1.SetCellValue(i, "sStatus", 'R', false);
				}
            	//sheet1.GetCellValue(i,"");
            }			
			
			sheetResize(); 
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if(Msg != ""){ 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search");
		}catch(ex){ 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
	
	function sheet1_OnPopupClick(Row, Col) {
		try{
		
			var colName = sheet1.ColSaveName(Col);
			if (Row >= sheet1.HeaderRows()) {
				if (colName == "name") {
					// 사원검색 팝입
					empSearchPopup(Row, Col);
				}
			}
		} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}
	
	var gPRow = "";
	// 사원검색 팝입
	function empSearchPopup(Row, Col) {
		if(!isPopup()) {return;}

		var w		= 840;
		var h		= 520;
		var url		= "/Popup.do?cmd=employeePopup";
		var args	= new Array();
		args["sType"] = "G";

		gPRow = Row;
		pGubun = "employeePopup";

		openPopup(url+"&authPg=R", args, w, h);
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');
		if (rv) {
			sheet1.SetCellValue(gPRow, "enterCd", rv["enterCd"]);
			sheet1.SetCellValue(gPRow, "enterNm", rv["enterNm"]);
			
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			
			sheet1.SetCellValue(gPRow, "handPhone", rv["handPhone"]);
			sheet1.SetCellValue(gPRow, "mailId", rv["mailId"]);
			
		}

	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){

					gPRow = Row;
					pGubun = "viewPopup";

					var authPgTemp="${authPg}";
					openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=ccr", param, "740","620");
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	//파일 신청 끝
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(rv.pGubun == "viewPopup"){
			if(rv != null){
				if(rv["fileCheck"] == "exist"){
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
				}else{
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", "");
				}
			}
	    }
	}
	
</script>
</head>
<body class="hidden">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span><tit:txt mid='' mdef='평가년도'/></span>
							<!-- select name="searchYear" id="searchYear" onChange="javaScript:doAction1('Search');doAction2('Search');"></select -->
							<input type="text"   id="searchYear"  name="searchYear" value="${curSysYear}" class="text required" style="ime-mode:disabled" maxLength=4/>
						</td>
						
						<td><span><tit:txt mid='' mdef='성명/사번'/></span> 
							<input id="searchSabunName" name ="searchSabunName" type="text" class="text" /> 
						</td>
						<td>
							<span><tit:txt mid='' mdef='조직명'/></span>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
						
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
							<li id="txt" class="txt">임원다면평가(업로드)</li>
							<li class="btn">
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authR">업로드</a>
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>