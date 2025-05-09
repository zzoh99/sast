<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>

<link rel="stylesheet" type="text/css" href="/assets/css/modal.css">
<link rel="stylesheet" type="text/css" href="/assets/css/salary.css">

<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
	

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var mode = "";
	var payCdParams="";

	$(function() {
		$("#searchMonthFrom").datepicker2({ymonly:true});
		$("#searchMonthTo").datepicker2({ymonly:true});
		$("#searchMonthFrom, #searchMonthTo").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",				 	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				 	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", 	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"급여\n계산|급여\n계산",     	Type:"Image",     Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"calc", Sort:0, KeyField:0 },
            {Header:"세부\n내역|세부\n내역",     	Type:"Image",     Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"selectImg",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"급여계산코드|급여계산코드",   	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"payActionCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"급여계산명|급여계산명",     	Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    ColMerge:1,   SaveName:"payActionNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"귀속년월|귀속년월",       		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"payYm",          KeyField:1,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"급여구분|급여구분",       		Type:"Combo",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:1,   SaveName:"payCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"RUN_TYPE|RUN_TYPE",      	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"runType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"지급일자|지급일자",       		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"paymentYmd",     KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"마감\n여부|마감\n여부",     	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"closeYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"급여기준|시작일",				Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"ordSymd",        KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"급여기준|종료일",				Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"ordEymd",        KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"근태기준년월|근태기준년월",   	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"timeYm",         KeyField:0,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"세금계산|방법",   			Type:"Combo",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"calTaxMethod",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"세금계산|기간별정산시\n대상 급여일자 지정여부",  	Type:"CheckBox",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"taxPeriordChoiceYn",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, TrueValue:"Y", FalseValue:"N"  },
            {Header:"세금계산|기간별정산시\n세부내역",     	Type:"Image",     Hidden:0,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"cntDetail",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"세금계산|기간별정산시\n대상 급여일자",  	Type:"Text",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"cnt",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"세금계산|기간별정산시\n귀속시작월",        	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"calTaxSym",      KeyField:0,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"세금계산|기간별정산시\n귀속종료월",        	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"calTaxEym",      KeyField:0,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"세금계산|가중치(%)",      	Type:"Float",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"addTaxRate",     KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
            {Header:"상여|산정기간(F)",    		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"bonSymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"상여|산정기간(T)",    		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"bonEymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"상여|근태기간(F)",    		Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"gntSymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"상여|근태기간(T)",    		Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"gntEymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"상여|적용일수",       		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"bonCalType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"상여|적용구분",       		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"bonApplyType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"상여|지급율(액)",     		Type:"Float",     Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"bonMonRate",     KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
            {Header:"지급방법|지급방법",       		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"paymentMethod",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"대상자|대상자",         		Type:"Int",       Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"manCnt",         KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },

            {Header:"비고Hidden|비고Hidden",     	Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"bigo",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"안내사항|안내사항",           	Type:"Image",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"detail",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
            {Header:"지급일|지급일",         		Type:"Text",      Hidden:1,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"day",         KeyField:0,   CalcLogic:"",   Format:"",   PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 }  ];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetDataLinkMouse("detail",1);
		sheet1.SetDataLinkMouse("cntDetail",1);
		sheet1.SetDataLinkMouse("calc",1);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	    sheet1.SetColProperty("closeYn", 			{ComboText:"|Y|N", ComboCode:"|Y|N"} );

		// 조회조건
		var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList"+payCdParams,false).codeList, "전체");
		$("#searchPayCd").html(searchPayCdList[2]);

		$("#col1,#col2,#col3,#col4").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); 
		sheetInit();
		doAction1("Search");
	});

	function getLastDayOfMonth(yearMonth) {
		const [year, month] = yearMonth.split('-').map(Number);
		const lastDate = new Date(year, month, 0);

		const yearStr = lastDate.getFullYear().toString();
		const monthStr = (lastDate.getMonth() + 1).toString().padStart(2, '0');
		const dayStr = lastDate.getDate().toString().padStart(2, '0');

		return yearStr + '-' + monthStr + '-' + dayStr;
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchMonthFrom").val() + "-01";
		let baseEYmd = getLastDayOfMonth($("#searchMonthTo").val());
		// 급여코드
		var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList"+payCdParams,false).codeList, "전체");
		sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );


		// 세금계산방법
		var calTaxMethodList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00110", baseSYmd, baseEYmd), "");
		sheet1.SetColProperty("calTaxMethod", {ComboText:"|"+calTaxMethodList[0], ComboCode:"|"+calTaxMethodList[1]} );

		// 적용일수
		var bonCalTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00160", baseSYmd, baseEYmd), "");
		sheet1.SetColProperty("bonCalType", {ComboText:"|"+bonCalTypeList[0], ComboCode:"|"+bonCalTypeList[1]} );

		// 적용구분
		var bonApplyTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00019", baseSYmd, baseEYmd), "");
		sheet1.SetColProperty("bonApplyType", {ComboText:"|"+bonApplyTypeList[0], ComboCode:"|"+bonApplyTypeList[1]} );

		// 지급방법
		var paymentMethodList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00016", baseSYmd, baseEYmd), "");
		sheet1.SetColProperty("paymentMethod", {ComboText:"|"+paymentMethodList[0], ComboCode:"|"+paymentMethodList[1]} );
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			sheet1.RemoveAll();
			sheet1.DoSearch( "${ctx}/PayCalculator.do?cmd=getPayDayMgrList" + payCdParams, $("#sheetForm").serialize() ); break;
		case "Save":

			for ( var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
				if(sheet1.GetCellValue(i,"payCd").substring(0,1) != "S" && sheet1.GetCellValue(i,"payCd").substring(0,1) != "Y" && sheet1.GetCellValue(i,"calTaxMethod") == ""){
					alert("세금계산 방법을 선택하여 주시기 바랍니다.");
					sheet1.SelectCell(i, "calTaxMethod");
					return;
				}

				if(sheet1.GetCellValue(i,"calTaxMethod") == "E" && (sheet1.GetCellValue(i,"calTaxSym") == "" || sheet1.GetCellValue(i,"calTaxEym") == "")){
					alert("기간별정산을 선택했을 경우, 정산시작연월과 종료연월을 선택하셔야 합니다.");
					if(sheet1.GetCellValue(i,"calTaxSym") == ""){
						sheet1.SelectCell(i, "calTaxSym");
					}else if(sheet1.GetCellValue(i,"calTaxEym") == ""){
						sheet1.SelectCell(i, "calTaxEym");
					}
					return;
				}
			}

			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PayCalculator.do?cmd=savePayDayMgr", $("#sheetForm").serialize()); break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SelectCell(row, 4);
			sheet1.SetCellValue(row, "detail", 0);
			if(mode == "retire") {
				sheet1.SetCellValue(row, "calTaxMethod", "G"); //세금계산방법
			}
			
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
            sheet1.SelectCell(Row, 5);
          	sheet1.SetCellValue(Row, "payActionCd","");
          	sheet1.SetCellValue(Row, "closeYn","");
          	if(mode == "retire") {
				sheet1.SetCellValue(Row, "calTaxMethod", "G"); //세금계산방법
			}
            break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
					sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	function sheet1EditableInit( Row ){

		var calTaxMethod = sheet1.GetCellValue ( Row, "calTaxMethod" );

		if ( calTaxMethod == "E" ){

			sheet1.SetCellEditable ( Row, "taxPeriordChoiceYn", 1 );
			sheet1.SetCellValue ( Row, "calTaxSym", "" );
			sheet1.SetCellValue ( Row, "calTaxEym", "" );
			sheet1.SetCellEditable ( Row, "calTaxSym", 1 );
			sheet1.SetCellEditable ( Row, "calTaxEym", 1 );


		}else{

			sheet1.SetCellValue    ( Row, "taxPeriordChoiceYn", "" )
			sheet1.SetCellEditable ( Row, "taxPeriordChoiceYn", 0  );
			sheet1.SetCellValue ( Row, "calTaxSym", "" );
			sheet1.SetCellValue ( Row, "calTaxEym", "" );
			sheet1.SetCellEditable ( Row, "calTaxSym", 0 );
			sheet1.SetCellEditable ( Row, "calTaxEym", 0 );
		}
	}

	function sheet1Editable( Row ){

		var calTaxMethod = sheet1.GetCellValue ( Row, "calTaxMethod" );

		if ( calTaxMethod == "E" ){

			sheet1.SetCellEditable ( Row, "taxPeriordChoiceYn", 1 );
			sheet1.SetCellEditable ( Row, "calTaxSym", 1 );
			sheet1.SetCellEditable ( Row, "calTaxEym", 1 );


		}else{

			sheet1.SetCellEditable ( Row, "taxPeriordChoiceYn", 0  );
			sheet1.SetCellEditable ( Row, "calTaxSym", 0 );
			sheet1.SetCellEditable ( Row, "calTaxEym", 0 );
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				sheet1.SetCellValue(i, 'calc', '0');
				sheet1.SetCellValue(i, 'sStatus', 'R');
				sheet1Editable( i );
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
			if (Code > 0) {
				doAction1("Search");
			}
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	function sheet1_OnChange(Row, Col, Value) {

	    var sSaveName = sheet1.ColSaveName(Col);

		// 대상년월 변경
		// 1. 지급일자 변경
		// 2. 급여계산명 변경
		if(sSaveName == "payYm" || sSaveName == "payCd"){
// 			대상 년월
			var payYm = sheet1.GetCellValue(Row, "payYm");
//          급여구분
			var payCd = sheet1.GetCellValue(Row, "payCd");

			if(payYm != "" && payCd != ""){

				var data = ajaxCall("${ctx}/PayCalculator.do?cmd=getPayDayMgrMap","selectPayCd="+payCd+"&selectPayYm="+payYm,false);
				if(data.DATA != null && data.DATA != undefined) {
					// 			RUN_TYPE
					var runType = data.DATA.runType;
					sheet1.SetCellValue(Row, "runType", runType);

					// 			일자
					var day = data.DATA.paymentDd;
					sheet1.SetCellValue(Row, "day", day);

					//			지급일자 년월
					var paymentYm = data.DATA.paymentYm;

					if(payYm != ""){
						if(sheet1.GetCellValue(Row, "day") != ""){
							sheet1.SetCellValue(Row, "paymentYmd", paymentYm+sheet1.GetCellValue(Row, "day"));
							sheet1.SetCellValue(Row, "payActionNm", paymentYm.substr(0, 4)+"."+paymentYm.substr(4, 2)+"."+sheet1.GetCellValue(Row, "day")+" "+sheet1.GetCellText(Row, "payCd"));
						}

						var date = ajaxCall("${ctx}/CommonCode.do?cmd=getLastDate", "ymd="+payYm.substr(0, 4)+"-"+payYm.substr(4, 2)+"-"+"01",false);

						if(date.map != null && date.map != undefined) {
							// 시작일자 셋팅
							sheet1.SetCellValue(Row, "ordSymd", payYm+"01");
							// 종료일자 셋팅
							sheet1.SetCellValue(Row, "ordEymd", date.map.lastDay);
							// 근태기준년월 셋팅
							sheet1.SetCellValue(Row, "timeYm", payYm);
						}

					}
				}
			}

		}

		if(sSaveName == "paymentYmd"){
			var date = sheet1.GetCellValue(Row, "paymentYmd");
			if(sheet1.GetCellValue(Row, "payCd")!=""){
				sheet1.SetCellValue(Row, "payActionNm", date.substr(0, 4)+"."+date.substr(4, 2)+"."+date.substr(6,2)+" "+sheet1.GetCellText(Row, "payCd"));
			}
		}

		if ( sSaveName == "calTaxMethod" ){
			sheet1EditableInit( Row );
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
        try {
            var colName = sheet1.ColSaveName(Col);
            var rv = null;

            if (colName == 'calc' && Row > 1) {
                const payActionCd = sheet1.GetCellValue(Row, 'payActionCd');
    			callIframe(payActionCd);
            }

            if(colName == "detail" && Row > 1 ) {

				let layerModal = new window.top.document.LayerModal({
					id : 'payDayMgrLayer'
					, url : '/PayCalculator.do?cmd=viewPayDayMgrLayer&authPg=${authPg}'
					, parameters : {
						bigo : sheet1.GetCellValue(Row, "bigo")
					}
					, width : 900
					, height : 340
					, title : '비고'
					, trigger : [
						{
							name : 'payDayMgrTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, "bigo", result.bigo);
							}
						}
					]
				});
				layerModal.show();

            	<%--if(!isPopup()) {return;}--%>
            	<%--gPRow = Row;--%>
            	<%--var args    = new Array();--%>
                <%--args["bigo"]   = sheet1.GetCellValue(Row, "bigo");--%>
            	<%--pGubun = "payDayMgrPopup";--%>
                <%--openPopup("/PayCalculator.do?cmd=payDayMgrPopup&authPg=${authPg}", args, "900","340");--%>
            }

            if(colName == "cntDetail"  && Row > 1 ) {
            	var sheet1Status = sheet1.GetCellValue( Row, "sStatus");
            	if (  sheet1Status == "I" || sheet1Status == "U" || sheet1Status == "D" ){
            		alert("입력, 수정, 또는 삭제중입니다.\r\n저장 후 클릭하세요.");
            		return;
            	}else{
	            	var calTaxMethod = sheet1.GetCellValue( Row, "calTaxMethod" );
	            	var taxPeriordChoiceYn = sheet1.GetCellValue( Row, "taxPeriordChoiceYn" );
	            	if ( calTaxMethod == "E" && taxPeriordChoiceYn == "Y" ){

						let layerModal = new window.top.document.LayerModal({
							id : 'payDayMgrLayer2'
							, url : '${ctx}/PayCalculator.do?cmd=viewPayDayMgrLayer2&authPg=${authPg}'
							, parameters : {
								payActionCd : sheet1.GetCellValue ( Row, "payActionCd" )
							}
							, width : 1400
							, height : 750
							, title : '기간별정산시 대상 급여일자'
							, trigger : [
								{
									name : 'payDayMgrTrigger2'
									, callback : function(result){
										doAction1("Search");
									}
								}
							]
						});
						layerModal.show();

		            	<%--if(!isPopup()) {return;}--%>
		            	<%--gPRow = Row;--%>

		            	<%--var args    = new Array();--%>
		            	<%--args["payActionCd"] = sheet1.GetCellValue ( Row, "payActionCd" );--%>

		            	<%--pGubun = "payDayMgrPop";--%>
		    			<%--openPopup("${ctx}/PayCalculator.do?cmd=viewPayDayMgrPop&authPg=${authPg}", args, "1600","750");--%>
	            	}else{
	            		alert("세금계산방법이 기간별정산이면서, \r\n왼쪽 칼럼[기간별정산시 대상 급여일자 지정여부]에 체크해야 세부내역을 입력할 수 있습니다.");
	            		return;
	            	}
            	}
            }

          }catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payDayMgrPopup"){
            sheet1.SetCellValue(gPRow, "bigo",   rv["bigo"] );
	    }else if (pGubun == "payDayMgrPop"){
			doAction1("Search");
	    }
	}

	function callIframe(payActionCd) {
		const uri = '/PayCalculator.do?cmd=viewPayCalcTabs&payActionCd=' + payActionCd;
		const top = window.top;
		const name = window.name;
		if (top.parent) {
			if (typeof top.parent.submitCall != 'undefind') {
				const form = top.parent.$('#subForm');
				top.parent.submitCall(form, name, 'post', uri);
			}
		}
	}
	
</script>
</head>
<body class="iframe_content white">
	<!--  main_content tab_layout -->
	<div>
		<main class="main_tab_content bg_gray white salary_calculation_list_wrap">
			<section class="sheet_section">
				<div class="header outer">
		          <h3 class="table_title">급여 리스트</h3>
		        </div>
		        <form id="sheetForm" name="sheetForm">
			        <table class="default outer">
			          <tbody>
			            <tr>
			              <th>
			                급여구분
			              </th>
			              <td>
			                <select id="searchPayCd" name="searchPayCd"> </select>
			              </td>
			              <th>
			                대상년월
			              </th>
			              <td class="targetYn">
			                <input id="searchMonthFrom" name ="searchMonthFrom" type="text" class="date2" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-12)%>"/>
							~
							<input id="searchMonthTo" name ="searchMonthTo" type="text" class="date2" value="<%=DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),0)%>"/>
			                <button type="button" onClick="doAction1('Search')" class="btn dark check">조회</button>
			              </td>
			            </tr>
			          </tbody>
			        </table>
		        </form>
		        <div class="sheet_top_area outer">
		          <span class="salary_date">급여일자관리</span>
		          <span class="btn_wrap">
		          	<button type="button" class="btn outline_gray" onClick="doAction1('Insert')">입력</button>
		          	<button type="button" class="btn outline_gray" onClick="doAction1('Copy')">복사</button>
		          	<button type="button" class="btn outline_gray" onClick="doAction1('Save')">저장</button>
		            <button type="button" class="btn outline_gray" onClick="doAction1('Down2Excel')">다운로드</button>
		          </span>
		        </div>
		        <div>
		        	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
		        </div>
	        </section>
		</main>
	</div>
</body>
</html>