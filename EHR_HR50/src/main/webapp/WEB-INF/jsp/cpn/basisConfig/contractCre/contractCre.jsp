<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='contractCre' mdef='급여계약서배포'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
             {Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",     	Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
//			 {Header:"선택",										Type:"DummyCheck",	Hidden:0,  Width:50,   Align:"Center",	ColMerge:0,	  SaveName:"chk",			KeyField:0,	  UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
             {Header:"세부\n내역",									Type:"Image",		Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"detail",        KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
             //{Header:"<sht:txt mid='nonAgreeYnV1' mdef='미동의'/>",	Type:"CheckBox",	Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"disagreeYn",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	TrueValue:"Y", FalseValue:"N" },
             {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",  	Type:"Text",		Hidden:0,  Width:100,  Align:"Left",	ColMerge:1,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
             {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",  	Type:"Text",		Hidden:0,  Width:60,   Align:"Center",	ColMerge:1,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
             {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",  	Type:"Text",		Hidden:0,  Width:70,   Align:"Center",	ColMerge:1,   SaveName:"name",			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",  	Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:70,   Align:"Center",	ColMerge:1,   SaveName:"alias",	  KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
             {Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",  		Type:"Text",		Hidden:Number("${jgHdn}"),  Width:70,   Align:"Center",	ColMerge:1,   SaveName:"jikgubNm",	  KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
             {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",  	Type:"Text",		Hidden:Number("${jwHdn}"),  Width:70,   Align:"Center",	ColMerge:1,   SaveName:"jikweeNm",	  KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
             {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",      	Hidden:0,  Width:90,   Align:"Center",  ColMerge:1,   SaveName:"sdate",			KeyField:1,   CalcLogic:"",   Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
 			 {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",      	Hidden:0,  Width:90,   Align:"Center",  ColMerge:1,   SaveName:"edate",			KeyField:1,   CalcLogic:"",   Format:"Ymd", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
 			 {Header:"동의일자",									Type:"Text",   		Hidden:0,  Width:120,  Align:"Center",  ColMerge:0,   SaveName:"agreeDate",     KeyField:0,   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
             {Header:"동의여부",									Type:"Combo",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"agreeYn",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10},
             {Header:"선택",										Type:"DummyCheck",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"chk",      		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1  },
             {Header:"기본연봉",  									Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"baseYearMon",	KeyField:0,   CalcLogic:"",   Format:"",  	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"식대연봉",  									Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"foodYearMon",	KeyField:0,   CalcLogic:"",   Format:"",  	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"공장수당연봉",  								Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"factoryYearMon",KeyField:0,   CalcLogic:"",   Format:"",  	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"성과연봉",  									Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"bonusYearMon",	KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"연봉총액",  									Type:"Int",			Hidden:0,  Width:90,   Align:"Right",	ColMerge:1,   SaveName:"totYearMon",	KeyField:0,   CalcLogic:"|baseYearMon|+|factoryYearMon|+|foodYearMon|+|bonusYearMon|",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
             {Header:"기본급",  									Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"baseMon",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"식대",  										Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"foodMon",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"공장근무수당",  								Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"factoryMon",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"성과급",  									Type:"Int",			Hidden:0,  Width:80,   Align:"Right",	ColMerge:1,   SaveName:"bonusMon",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"월급여총액",  								Type:"Int",			Hidden:0,  Width:90,   Align:"Right",	ColMerge:1,   SaveName:"totMonthMon",	KeyField:0,   CalcLogic:"|baseMon|+|factoryMon|+|foodMon|+|bonusMon|",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
             {Header:"계약서 유형",									Type:"Combo",		Hidden:1,  Width:140,  Align:"Center",  ColMerge:1,   SaveName:"contType",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
             {Header:"동의시간",									Type:"Text",   		Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"agreeDate",     KeyField:0,   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
             {Header:"급여유형",									Type:"Combo",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"payType",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
             {Header:"rdMrd",  										Type:"Text",		Hidden:1,  Width:60,   Align:"Center",	ColMerge:1,   SaveName:"rdMrd",			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; 
		
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
                         
        // 계약서유형
  		var contTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=CPN","Z00001"), "<tit:txt mid='103895' mdef='전체'/>");
  		sheet1.SetColProperty("contType", 			{ComboText:"|"+contTypeList[0], ComboCode:"|"+contTypeList[1]} );
  		sheet1.SetColProperty("agreeYn",  {ComboText:"|Y|N", ComboCode:"|Y|N"} );
  		var payTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110"), "<tit:txt mid='103895' mdef='전체'/>");
  		sheet1.SetColProperty("payType", 			{ComboText:"|"+payTypeList[0], ComboCode:"|"+payTypeList[1]} );
  		
  		//기준일자
  		$("#searchDate").datepicker2({});
		$("#searchDate").mask("1111-11-11");
		
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		
		doAction("Search");		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "alias",	rv["alias"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
					}
				}
			]
		});		
		
		$(window).smartresize(sheetResize); sheetInit();
	});
	
	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/ContractCre.do?cmd=getContractCreList", $("#sheetForm").serialize() ); break;
		case "Save":
// 			if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/ContractCre.do?cmd=saveContractCre", $("#sheetForm").serialize()); break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "agreeYn", "N");
			sheet1.SelectCell(row, "name");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "agreeYn", "N");
			sheet1.SetCellValue(row, "agreeDate", "");
			sheet1.SelectCell(row, 6);
			break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28"});
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	    if( sheet1.ColSaveName(Col) == "detail"	&& Row >= sheet1.HeaderRows() ) {
	    	if (sheet1.GetCellValue(Row,"sStatus") != "R") {
	    		alert("수정 사항이 있습니다.\n저장 후 출력하시기 바랍니다.");
	    		return;
	    	}
	    	
	    	/*계약서 RD팝업*/
	    	//rdPopup("S", Row);
	    	rdPopup(Row);
	    }
	}
	
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.GetCellValue(Row,"sdate") != "" && sheet1.GetCellValue(Row,"edate") != "") {
				if(sheet1.GetCellValue(Row,"sdate") > sheet1.GetCellValue(Row,"edate")) {
					alert("<msg:txt mid='109513' mdef='시작일은 종료일보다 작거나 같아야합니다.'/>");
					sheet1.SetCellValue(Row,"edate","",0);
					return;
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	function sheet1_OnPopupClick(Row, Col){
        try{
        
          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();
          /*
          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");
          */
          if(colName == "name") {
        	  if(!isPopup()) {return;}
        	  gPRow = Row;
        	  pGubun = "employeePopup";           
              var rv = openPopup("/Popup.do?cmd=employeePopup", args, "840","520");   
          }    
        
        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }
	
    function employeePopup(){
        try{
        	if(!isPopup()) {return;}

			gPRow = "";
			pGubun = "searchEmployeePopup";

			var args    = new Array();
			openPopup("/Popup.do?cmd=employeePopup", args, "840","520");
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }
    
    function rdPopup(Row) {
		if(!isPopup()) {return;}

  		var w 		= 840;
		var h 		= 1000;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		args["rdTitle"]      = "급여계약서" ;	//rd Popup제목
		args["rdMrd"] 		 = sheet1.GetCellValue(Row, "rdMrd");																				//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		//args["rdParam"] 	 = "[${ssnEnterCd}] ["+sheet1.GetCellValue(Row, "sabun")+"] ["+sheet1.GetCellValue(Row, "sdate")+"] [${baseURL}]" ; //rd파라매터
		args["rdParam"] = "[${ssnEnterCd}] [(('"+sheet1.GetCellValue(Row, "sabun")+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "sdate")+"'))] [${baseURL}]" ; //rd파라매터
		args["rdParamGubun"] = "rp";		//파라매터구분(rp/rv)
		args["rdToolBarYn"]  = "Y";			//툴바여부
		args["rdZoomRatio"]  = "100";		//확대축소비율

		args["rdSaveYn"] 	 = "Y";			//기능컨트롤_저장
		args["rdPrintYn"] 	 = "Y";			//기능컨트롤_인쇄
		args["rdExcelYn"] 	 = "Y";			//기능컨트롤_엑셀
		args["rdWordYn"] 	 = "Y";			//기능컨트롤_워드
		args["rdPptYn"] 	 = "Y";			//기능컨트롤_파워포인트
		args["rdHwpYn"] 	 = "Y";			//기능컨트롤_한글
		args["rdPdfYn"] 	 = "Y";			//기능컨트롤_PDF
		
		gPRow  = "";
		pGubun = "rdPopup";
		
		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}
    
function rdPopup2(){
		
		if(!isPopup()) {return;}

		if(sheet1.CheckedRows("chk") == 0) {
			alert("<msg:txt mid='110453' mdef='출력할 데이터를 선택하여 주십시오.'/>");
			return;
		}
		
		var sRow = sheet1.FindCheckedRow("chk"); 
		var arrRow1 = [];
		var arrRow2 = [];
		var arrRow3 = [];
		var searchRdMrd = "";
		//args["rdParam"] = "[${ssnEnterCd}] [(('"+sheet1.GetCellValue(Row, "sabun")+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "stdDate")+"'))] [${baseURL}]" ; //rd파라매터
		$(sRow.split("|")).each(function(index,value){
			arrRow1[index] = sheet1.GetCellValue(value,"sabun");
			arrRow2[index] = sheet1.GetCellValue(value,"contType");
			arrRow3[index] = sheet1.GetCellValue(value,"sdate");
			searchRdMrd    = sheet1.GetCellValue(value, "rdMrd");
		});
		
		var searchTarget = "(";
		for(var i=0; i<arrRow1.length; i++) {
	        if(i != 0) searchTarget += ",";
	        searchTarget += "('"+arrRow1[i]+"'"; 
	        searchTarget += ",'"+arrRow2[i]+"'"; 
	        searchTarget += ",'"+arrRow3[i]+"')"; 
	    } 
		searchTarget += ")";
		
  		var w 		= 840;
		var h 		= 1000;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		
		args["rdTitle"] = "전자동의서" ;//rd Popup제목
		args["rdMrd"] = searchRdMrd;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[${ssnEnterCd}] ["+searchTarget+"] [${baseURL}]"  ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF
		

		gPRow = "";
		pGubun = "rdPopup2";
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		
	}
    
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
            sheet1.SetCellValue(gPRow, "name",   rv["name"] );
            sheet1.SetCellValue(gPRow, "alias",   rv["alias"] );
            sheet1.SetCellValue(gPRow, "sabun",   rv["sabun"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "jikweeNm",   rv["jikweeNm"] );
            sheet1.SetCellValue(gPRow, "orgNm",   rv["orgNm"] );
		}else if(pGubun == "searchEmployeePopup"){
			$("#searchSabun").val(rv["sabun"]);
	        $("#searchName").val(rv["name"]);
		}
	}
	
	function callProc() {
		
		if( $("#searchDate").val() == "" ) { alert("<msg:txt mid='alertContractCre1' mdef='급여계약서 생성을 위한 기준일자를 입력하여 주십시오.'/>") ; return ; }

		if(!confirm("동의하지 않은 기존데이터는 지워집니다. \n생성하시겠습니까?")) { return ; }
		
		var params = "searchDate="+$("#searchDate").val()+"&searchSabun="+$("#searchSabun").val() ;
		var ajaxCallCmd = "callP_CPN_CONTRACT_CREATE" ;
		
    	var data = ajaxCall("/ContractCre.do?cmd="+ajaxCallCmd,params,false);
    	
    	if(data.Result.Code == null) {
    		msg = "급여계약서가 생성되었습니다." ;
    		doAction("Search") ;
    	} else {
	    	msg = "급여계약서 생성도중 : "+data.Result.Message;
    	}
    	
    	alert(msg) ;
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td><input type="text" id="searchDate" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" name="searchDate" class="date2" /></td>
						<th><tit:txt mid='104450' mdef='성명 '/></th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text readonly" readonly/>
							<input id="searchSabun" name ="searchSabun" type="hidden"/>
							<a onclick="javascript:employeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
							<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
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
							<li id="txt" class="txt">연봉계약서배포</li>
							<li class="btn">
								<a href="javascript:callProc();" class="pink authA">연봉계약서 생성</a>
								<a href="javascript:rdPopup2()" class="basic authA">일괄출력</a>
								<a href="javascript:doAction('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction('Copy')" class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
                                <a href="javascript:doAction('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
