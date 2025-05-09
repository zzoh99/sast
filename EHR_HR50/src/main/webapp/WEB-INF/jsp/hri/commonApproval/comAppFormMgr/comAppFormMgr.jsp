<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청서항목관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%--//CkEditor Setting--%>
<script src="${ctx}/common/plugin/ckeditor5/ckeditor5-41.4.2/ckeditor.js"></script>
<style>
	/*CkEditor Setting Style*/
	.ck-editor__editable {
		min-height: 640px;
		max-height: 640px;
	}
	.ck-source-editing-area textarea{
    	min-height: 640px;
		max-height: 640px;
        overflow:auto!important;
    }
</style>
<%
Map<String, Object> editorMap = new HashMap<String, Object>();
editorMap.put("minusHeight", "50");
editorMap.put("formNm", "sheet1Form");
editorMap.put("contentNm", "contents");
request.setAttribute("editor", editorMap);
%>
<script type="text/javascript">
	//CkEditor Setting
	//getData : window.instanceEditor.getData()
	//modify(setData) : window.instanceEditor.setData()
	//save : window.instanceEditor.customMethods.save(form)

	//CKEDITOR 전역 선언
	window.top.CKEDITOR = CKEDITOR;

	var gPRow = "";
	var pGubun = "";
	var itemList;

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#searchYmd").blur(function(){
			doAction1("Search");
		});

		$("#searchYmd").datepicker2();
		
		//에디터
		//submitCall($("#sheet1Form"),"ifrm1","post","/ComAppFormMgr.do?cmd=viewIframeEditor&height=34"); //height :  전체에서 차감할 높이

		//Sheet 초기화
		init_sheet1();init_sheet2(); init_sheet3();
		sheetInit();
		//$(window).smartresize(sheetResize);
		// 브라우저 사이즈가 변경될 때 마다 sheet, editor 높이 조정
		$(window).smartresize(function(){
			sheetResize();
		})
		
		doAction1("Search");
		doAction2("Search");
		
	});
	
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:1,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,				Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"신청서",	Type:"Combo",		Hidden:0,  				Width:100,	Align:"Center",	 SaveName:"applCd",	 	KeyField:1,   Format:"", UpdateEdit:0,	InsertEdit:1 },
			{Header:"형태",		Type:"Combo",		Hidden:0,  				Width:100,	Align:"Center",	 SaveName:"applTypeCd",	KeyField:1,   Format:"", UpdateEdit:1,	InsertEdit:1 },
			{Header:"상세",		Type:"Image",     	Hidden:0, 				Width:45,   Align:"Center",  SaveName:"btnView", 	KeyField:0,   Format:"", UpdateEdit:0, InsertEdit:0, Cursor:"Pointer" },
			
			
			{Header:"Hidden",	Type:"Text",		Hidden:1, SaveName:"contents" },
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images	/icon/icon_write.png");

		//신청서코드 콤보
        var applCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComAppFormMgrApplCdList",false).codeList, "");
		sheet1.SetColProperty("applCd", {ComboText:"|"+applCdList[0], ComboCode:"|"+applCdList[1]} );
		
		//신청서타입
		var applTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","Z80220"), "전체");
		sheet1.SetColProperty("applTypeCd", {ComboText:applTypeCd[0], ComboCode:applTypeCd[1]} );
		
	}

	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"항목명",		Type:"Text",  Hidden:0, Width:80, Align:"Center", SaveName:"itemNm",		KeyField:0, Format:"",  Edit:0 },
			{Header:"설명",		Type:"Text",  Hidden:0, Width:150, Align:"Center", SaveName:"itemDesc",	KeyField:0, Format:"",  Edit:0 },
  			{Header:"Hidden", Hidden:1, SaveName:"code"}
  		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
	}


	function init_sheet3(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,				Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"컬럼명",		Type:"Text",	Hidden:0,  Width:100,	Align:"Center",	 SaveName:"columnNm",	 	KeyField:1,   Format:"", 		UpdateEdit:1,	InsertEdit:1 },
			{Header:"컬럼형태",	Type:"Combo",		Hidden:0,  Width:60,	Align:"Center",	 SaveName:"columnTypeCd",	KeyField:1,   Format:"", 		UpdateEdit:1,	InsertEdit:1 },
			{Header:"포맷",		Type:"Combo",		Hidden:0,  Width:60,	Align:"Center",	 SaveName:"columnFormat",	KeyField:1,   Format:"", 		UpdateEdit:1,	InsertEdit:1 },
			{Header:"컬럼넓이",	Type:"Text",		Hidden:0,  Width:60,	Align:"Center",	 SaveName:"columnWidth",	KeyField:0,   Format:"Number",  UpdateEdit:1,	InsertEdit:1 },
			{Header:"컬럼정렬",	Type:"Combo",		Hidden:0,  Width:60,	Align:"Center",	 SaveName:"columnAlign",	KeyField:0,   Format:"",  		UpdateEdit:1,	InsertEdit:1 },
			{Header:"입력최대값",	Type:"Text",	Hidden:0,  Width:60,	Align:"Center",	 SaveName:"maxLength",	 	KeyField:0,   Format:"Number",  UpdateEdit:1,	InsertEdit:1 },
			{Header:"필수여부",	Type:"CheckBox",	Hidden:0,  Width:55,	Align:"Center",	 SaveName:"keyfieldYn",		KeyField:0,   Format:"", 		UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"기본값구분",	Type:"Combo",	Hidden:0,  Width:130,	Align:"Center",	 SaveName:"defGubun",	 	KeyField:0,   Format:"", 		UpdateEdit:1,	InsertEdit:1 },
			{Header:"기본값",		Type:"Combo",	Hidden:0,  Width:200,	Align:"Left",	 SaveName:"defValue",	 	KeyField:0,   Format:"", 		UpdateEdit:1,	InsertEdit:1 },
			{Header:"콤보선택",	Type:"Popup",		Hidden:0,  Width:100,	Align:"Center",	 SaveName:"searchItemNm",	KeyField:0,   Format:"",  		UpdateEdit:0,	InsertEdit:0 },
			{Header:"팝업구분",	Type:"Combo",		Hidden:0,  Width:100,	Align:"Center",	 SaveName:"popupItemCd",	KeyField:0,   Format:"",  		UpdateEdit:0,	InsertEdit:0 },
			{Header:"컬럼위치",	Type:"Combo",		Hidden:0,  Width:100,	Align:"Center",	 SaveName:"layoutSeq",	 	KeyField:1,   Format:"Number",  UpdateEdit:1,	InsertEdit:1 },
			
			{Header:"신청화면\n보여주기", Type:"CheckBox",	Hidden:0,  Width:55,	Align:"Center",	 SaveName:"appViewYn",		KeyField:0,   Format:"", 		UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N", ToolTip:"신청리스트 시트에 표시 여부" },
			{Header:"승인화면\n보여주기", Type:"CheckBox",	Hidden:0,  Width:55,	Align:"Center",	 SaveName:"aprViewYn",		KeyField:0,   Format:"", 		UpdateEdit:1,	InsertEdit:1, TrueValue:"Y", FalseValue:"N", ToolTip:"승인리스트 시트에 표시 여부" },
			
			
			{Header:"Hidden",	Hidden:1, SaveName:"applCd" },
			{Header:"Hidden",	Hidden:1, SaveName:"seq" },
			{Header:"Hidden",	Hidden:1, SaveName:"searchItemCd" },
			
		]; IBS_InitSheet(sheet3, initdata1);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		sheet3.SetDataAlternateBackColor(sheet3.GetDataBackColor()); //홀짝 배경색 같게

		//공통코드 한번에 조회
		var grpCds = "Z80210,Z80230,Z80240,Z80250,Z80260";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		sheet3.SetColProperty("columnTypeCd", 	{ComboText:"|"+codeLists["Z80210"][0], ComboCode:"|"+codeLists["Z80210"][1]} ); //컬럼형태
		sheet3.SetColProperty("layoutSeq", 		{ComboText:"|"+codeLists["Z80230"][0], ComboCode:"|"+codeLists["Z80230"][1]} ); //컬럼위치
		sheet3.SetColProperty("columnFormat", 	{ComboText:codeLists["Z80240"][0], ComboCode:codeLists["Z80240"][1]} ); //컬럼포맷
		sheet3.SetColProperty("popupItemCd", 	{ComboText:codeLists["Z80250"][0], ComboCode:codeLists["Z80250"][1]} ); //팝업구분
		sheet3.SetColProperty("columnAlign", 	{ComboText:codeLists["Z80260"][0], ComboCode:codeLists["Z80260"][1]} ); //컬럼정렬
		
		
		//기본값구분
		sheet3.SetColProperty("defGubun", {ComboText:"|시스템항목|직접입력", ComboCode:"|0|1"} );

		//기본값(시스템항목)
		itemList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComAppItemMgrComboList",false).codeList, "");
		sheet3.SetColProperty("defValue", {ComboText:"|"+itemList[0], ComboCode:"|"+itemList[1]} );
		
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/ComAppFormMgr.do?cmd=getComAppFormMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet1,"applCd", false, true)){break;}
				//CkEditor Setting modify
				$("#ckEditorContentArea").val(window.instanceEditor.getData());
				sheet1.SetCellValue(sheet1.GetSelectRow(), "contents", $("#ckEditorContentArea").val());
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/ComAppFormMgr.do?cmd=saveComAppFormMgr", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "applCd", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/ComAppItemMgr.do?cmd=getComAppItemMgrList", $("#sheet1Form").serialize() );
				break;
		}
	}
	

	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				sheet3.DoSearch( "${ctx}/ComAppFormMgr.do?cmd=getComAppFormMgrColList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet3,"layoutSeq", false, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet3);
				sheet3.DoSave( "${ctx}/ComAppFormMgr.do?cmd=saveComAppItemMgrCol", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet3.DataInsert(-1);
				sheet3.SetCellValue(row, "seq", "");
				break;
			case "Copy":
				var row = sheet3.DataCopy();
				sheet3.SetCellValue(row, "seq", "");
				changeColumnType(row);
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet3.Down2Excel(param);
				break;
			case "Preview":

				if(!isPopup()) {return;}

				var args 	= new Array();

				args["searchApplCd"]	= $("#searchApplCd").val();
				args["searchApplNm"]	= $("#searchApplNm").val();

				let modalLayer = new window.top.document.LayerModal({
					id: 'comAppFormMgrPreviewLayer',
					url: '/ComAppFormMgr.do?cmd=viewComAppFormMgrPreview&authPg=A',
					parameters: args,
					width: 1000,
					height: 700,
					title: '공통신청서 미리보기',
					trigger: [
						{
							name: 'comAppFormMgrPreviewLayerTrigger',
							callback: function(rv) {
							}
						}
					]
				});
				modalLayer.show();

				break;
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( sheet1.RowCount() == 0 ){

				window.instanceEditor.setData("");
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {

			if( OldRow != NewRow ){
				$("#searchApplCd").val(sheet1.GetCellValue(NewRow, "applCd"));
				$("#searchApplNm").val(sheet1.GetCellText(NewRow, "applCd"));
				$("#applTitle1, #applTitle2").html(sheet1.GetCellText(NewRow, "applCd"));
				
				if( sheet1.GetCellValue( NewRow, "applTypeCd") == "HTML" ){
					$("#divDATA, .btnData").hide();$("#divHTML, .btnHtml").show();

					window.instanceEditor.setData("");

					var contents = nvlStr(sheet1.GetCellValue(NewRow, "contents"));
					//CkEditor Setting modify
					window.instanceEditor.setData(contents);

				}else if( sheet1.GetCellValue( NewRow, "applTypeCd") == "DATA" ){
					$("#divHTML, .btnHtml").hide();$("#divDATA, .btnData").show();
					doAction3("Search");
				}

				sheetResize();
			}
		} catch (ex) {
			alert("sheet1_OnSelectCell Event Error : " + ex);
		}
	}
	

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			
			if( sheet1.ColSaveName(Col) == "btnView" ){

				$("#applTitle1, #applTitle2").html(sheet1.GetCellText(Row, "applCd"));

				var contents = nvlStr(sheet1.GetCellValue(Row, "contents"));
				//CkEditor Setting modify
				window.instanceEditor.setData(contents);
			}

			if( sheet1.GetCellValue( Row, "applTypeCd") == "HTML" ){
				
				$("#divDATA, .btnData").hide();$("#divHTML, .btnHtml").show();

				var contents = nvlStr(sheet1.GetCellValue(Row, "contents"));

				//CkEditor Setting modify
				window.instanceEditor.setData(contents);
			}else if( sheet1.GetCellValue( Row, "applTypeCd") == "DATA" ){
				$("#divHTML, .btnHtml").hide();$("#divDATA, .btnData").show();
				doAction3("Search");
			}
			
		} catch (ex) {
			alert("sheet1_OnSelectCell Event Error : " + ex);
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			$("#exItemTxt").val("@@"+sheet2.GetCellValue(Row, "itemNm")+"@@");
		} catch (ex) {
			alert("sheet1_OnSelectCell Event Error : " + ex);
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet3 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
			
			for(var i = sheet3.HeaderRows(); i < sheet3.RowCount()+sheet3.HeaderRows() ; i++) {
				changeColumnType(i);
				changeDefGubun(i);
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction3("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	// 팝업 셀 클릭 시 
	function sheet3_OnPopupClick(Row,Col) {
		try {
			var saveName = sheet3.ColSaveName(Col); 
			if( saveName == "searchItemNm" && sheet3.GetCellValue(Row, "columnTypeCd") == "Combo"){

				if(!isPopup()) {return;}

				gPRow = Row;

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
							, callback : function(rv){
								sheet3.SetCellValue(gPRow, "searchItemCd", 	rv["searchItemCd"] );
								sheet3.SetCellValue(gPRow, "searchItemNm", 	rv["searchItemNm"] );
							}
						}
					]
				});
				layerModal.show();
			}
			
			
		} catch (ex) {
			alert("OnPopupClick Event Error " + ex);
		}
	}
	
	// 값 변경 시
	function sheet3_OnChange(Row, Col, Value) {
		try {
			var saveName = sheet3.ColSaveName(Col); 
			
			if( saveName == "columnTypeCd" ){
				changeColumnType(Row);
				
			}else if( saveName == "defGubun" ){
				sheet3.SetCellValue(Row,"defValue","");
				changeDefGubun(Row);
			}
			
			
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
		
	}
	function changeDefGubun(Row){

		sheet3.SetCellEditable(Row,"defValue",1);
		if( sheet3.GetCellValue(Row, "defGubun") == "0" ){ //시스템 항목
			var info = {Type: "Combo", ComboText:"|"+itemList[0], ComboCode:"|"+itemList[1]};
			sheet3.InitCellProperty(Row, "defValue" ,info);
		}else{ //직접입력
			var info = {Type: "Text"};
			sheet3.InitCellProperty(Row, "defValue" ,info);
			
			if( sheet3.GetCellValue(Row, "defGubun") == "" ){
				sheet3.SetCellEditable(Row,"defValue",0);
			}
		}
	}
	function changeColumnType(Row){

		

		sheet3.SetCellEditable(Row,"searchItemNm",0); 
		sheet3.SetCellEditable(Row,"popupItemCd",0);
		sheet3.SetCellEditable(Row,"keyfieldYn",1);
		sheet3.SetCellEditable(Row,"maxLength",1);
		sheet3.SetCellEditable(Row,"columnFormat",1);
		
		switch (sheet3.GetCellValue(Row, "columnTypeCd")) {
			case "Text":
				sheet3.SetCellEditable(Row,"defGubun",1);
				sheet3.SetCellEditable(Row,"defValue",1);
				
				sheet3.SetCellValue(Row,"searchItemNm","");
				sheet3.SetCellValue(Row,"searchItemCd","");

				sheet3.SetCellValue(Row,"popupItemCd","");
				break;
			case "Label":
				sheet3.SetCellEditable(Row,"defGubun",1);
				sheet3.SetCellEditable(Row,"defValue",1);
				
				sheet3.SetCellEditable(Row,"keyfieldYn",0); 
				sheet3.SetCellValue(Row,"keyfieldYn",""); 

				sheet3.SetCellEditable(Row,"maxLength",0);
				sheet3.SetCellValue(Row,"maxLength",""); 
				
				sheet3.SetCellValue(Row,"searchItemNm",""); 
				sheet3.SetCellValue(Row,"searchItemCd",""); 

				sheet3.SetCellValue(Row,"popupItemCd","");
				
				break;
			case "Combo":
				sheet3.SetCellEditable(Row,"searchItemNm",1); 
				
				sheet3.SetCellEditable(Row,"defGubun",0);
				sheet3.SetCellEditable(Row,"defValue",0);
				sheet3.SetCellValue(Row,"defGubun","");
				sheet3.SetCellValue(Row,"defValue","");
				
				sheet3.SetCellEditable(Row,"columnFormat",0);
				sheet3.SetCellValue(Row,"columnFormat","N");

				sheet3.SetCellValue(Row,"popupItemCd","");
				break;
			case "Popup":

				sheet3.SetCellEditable(Row,"popupItemCd",1);
				
				sheet3.SetCellEditable(Row,"defGubun",0);
				sheet3.SetCellEditable(Row,"defValue",0);
				sheet3.SetCellValue(Row,"defGubun","");
				sheet3.SetCellValue(Row,"defValue","");
				
				sheet3.SetCellValue(Row,"searchItemNm","");
				sheet3.SetCellValue(Row,"searchItemCd","");
				
				sheet3.SetCellEditable(Row,"columnFormat",0);
				sheet3.SetCellValue(Row,"columnFormat","N");
				break;
				
			case "TextArea":
				sheet3.SetCellEditable(Row,"defGubun",0);
				sheet3.SetCellEditable(Row,"defValue",0);
				sheet3.SetCellValue(Row,"defGubun","");
				sheet3.SetCellValue(Row,"defValue","");
				
				sheet3.SetCellEditable(Row,"columnFormat",0);
				sheet3.SetCellValue(Row,"columnFormat","N");

				sheet3.SetCellValue(Row,"searchItemNm","");
				sheet3.SetCellValue(Row,"searchItemCd","");

				sheet3.SetCellValue(Row,"popupItemCd","");
				break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	function nvlStr(pVal) {
		if (pVal == null) return "";
		return pVal;
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sheet1Form" id="sheet1Form" method="post">
		<input type="hidden" id="contents" name="contents" />
		<input type="hidden" id="searchApplCd" name="searchApplCd" />
		<input type="hidden" id="searchApplNm" name="searchApplNm" />
		<!-- //CkEditor Setting -->
		<input type="hidden" id="ckEditorContentArea" name="content">
	</form>

	<table class="sheet_main">
	<colgroup>
		<col width="300px" />
		<col width="" />
		<col width="300px" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="sheet_title inner">
			<ul>
				<li class="txt">신청서</li>
				<li class="btn">
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
					<a href="javascript:doAction1('Search')" 		class="btn dark">조회</a>
				</li>
			</ul>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "380px", "100%"); </script>
			
			<div class="explain spacingN inner">
				<div class="txt">
					<ul>
						<li>※ <b>[신청결재 > 신청결재관리 > 신청서코드관리 ]</b>에서 신청서를 먼저 등록 해주세요.</li>
						<li>※ 신청서의 업무구분은 "공통신청결재"로 등록해야 합니다. </li> 
					</ul>
				</div>

			</div>			
		</td>
		<td class="sheet_right">
			<div id="divHTML" style="position:absolute; left:310px; top:0px;  right:310px; bottom:0; display:none;">
				<div class="sheet_title inner">
					<ul>
						<li class="strong spacingN" style="font-size:14px; color:#3f4145;">[ 신청서 : <span  id="applTitle1"></span> ]</li>
						<li class="btn">
							<a href="javascript:doAction1('Save');" 		class="basic authA btnHtml">저장</a>
						</li>
					</ul>
				</div>
				<%-- //CkEditor Setting modify--%>
				<%@ include file="/WEB-INF/jsp/common/plugin/Ckeditor/include_editor.jsp"%>
			</div>	
			<div id="divDATA" style="position:absolute; left:310px; top:0px;  right:0; bottom:0; display:none;">
				
				<div class="sheet_title inner">
					<ul>
						<li class="strong spacingN" style="font-size:14px; color:#3f4145;">[ 신청서 : <span  id="applTitle2"></span> ]</li>
						<li class="btn">
							<a href="javascript:doAction3('Copy')" 			class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction3('Insert')" 		class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction3('Save');" 		class="btn soft authA">저장</a>
							<a href="javascript:doAction3('Preview');" 		class="btn filled authA">미리보기</a>
						</li>
					</ul>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "100%"); </script>
			</div>			
		</td>	
		<td class="sheet_right btnHtml" style=" display:none;">
			<div class="sheet_title inner">
			<ul>
				<li class="txt">시스템항목</li>
				<li class="btn"></li>
			</ul>
			<div style="color:blue;padding-top:5px;">* 항목명 앞뒤에 @@를 붙여서 사용</div>
			<div style="padding-top:5px;"><input type="text" id="exItemTxt" name="exItemTxt" class="w90p" /></div>
			</div>
			<script type="text/javascript">createIBSheet("sheet2", "300px", "100%"); </script>
		
		</td>
	</tr>
	</table>
</div>
</body>
</html>
