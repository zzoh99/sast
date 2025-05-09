<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>신물기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%
String uploadType = "pht004";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>

<!-- 파일업로드 관련  -->
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//기준일자 날짜형식, 날짜선택 시 
		$("#searchYmd").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});
		
		//-------------------------------------------------------------------------------------------
		//파일 업로드
        //-------------------------------------------------------------------------------------------		
        var options = $.extend(true, ${fConfig}, {
			context:"${ctx}",
			event:{
				success: function(jsonData) {
					if(jsonData.data !== undefined && jsonData.data !== null && jsonData.data.length > 0) {
						sheet2.SetCellValue(gPRow, "giftImgSeq", jsonData.data[0].fileSeq);
						sheet2.SetCellValue(gPRow, "giftImg", "/SignPhotoOut.do?enterCd=${sessionScope.ssnEnterCd}&fileSeq="+jsonData.data[0].fileSeq);
						doAction2("Save");
					}
					$("#fileuploader").fileupload("setCount",0);
				},
				error: function(jsonData) {
					alert(jsonData.msg);
				}
			}
		}),
        params = {
                'uploadType' :"${uploadType}",
                'fileSeq' : '',
                'sabun' : ''
            };
    
        $("#fileuploader").fileupload("init", options, params);
		//-------------------------------------------------------------------------------------------
		
		
		//Sheet 초기화
		init_sheet1(); init_sheet2();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

		

	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"선물종류",		Type:"Combo",	Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"giftTypeCd",	KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
			{Header:"선물신청제목",		Type:"Text",	Hidden:0, Width:250, Align:"Left",		ColMerge:0,	SaveName:"title",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"시작일",			Type:"Date",	Hidden:0, Width:90,	 Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1, EndDateCol:"edate"},
			{Header:"종료일",			Type:"Date",	Hidden:0, Width:90,	 Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1, StartDateCol:"sdate"},
			{Header:"배송지",			Type:"Combo",	Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"addrGubun",	KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			
			{Header:"대상자선택",		Type:"Popup",	Hidden:0, Width:200, Align:"Left",	  	ColMerge:0,	SaveName:"searchDesc",  KeyField:0,	Format:"", 		UpdateEdit:1,   InsertEdit:1 },
			{Header:"비고",			Type:"Text",	Hidden:0, Width:250, Align:"Left",		ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			
			{Header:"Hidden",	 Hidden:1, SaveName:"searchSeq"},
			{Header:"Hidden",	 Hidden:1, SaveName:"giftSeq"},
			

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);//sheet1.SetCountPosition(4);

		sheet1.SetColProperty("addrGubun",  	{ComboText:"집(현주소)|회사", ComboCode:"A|B"} ); //배송지
		
	}

	function getCommonCodeList() {
		//공통코드 한번에 조회
		let grpCds = "B76510";
		let parmas = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", parmas, false).codeList, "");
		sheet1.SetColProperty("giftTypeCd",  	{ComboText:"|"+codeLists["B76510"][0], ComboCode:"|"+codeLists["B76510"][1]} ); //선물구분
	}
	//Sheet 초기화
	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"선물코드",		Type:"Text",	Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"giftCd",		KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
			{Header:"선물명",			Type:"Text",	Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"giftNm",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"선물상세설명",		Type:"Text",	Hidden:0, Width:250, Align:"Left",		ColMerge:0,	SaveName:"giftDesc",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"선물이미지",		Type:"Image",	Hidden:0, Width:80,	 Align:"Center",	ColMerge:0,	SaveName:"giftImg", 	Edit:0, ImgWidth:80, ImgHeight:100, Sort:0  },
			{Header:"이미지등록",		Type:"Html",	Hidden:0, Width:60,  Align:"Center",	ColMerge:0,	SaveName:"btnAdd", 	 	Sort:0 , Cursor:"Pointer" },
			
			{Header:"Hidden",	 Hidden:1, SaveName:"giftImgSeq"},
			{Header:"Hidden",	 Hidden:1, SaveName:"giftSeq"},
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);//sheet2.SetCountPosition(4);

		sheet2.SetDataRowHeight(100);
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/GiftStd.do?cmd=getGiftStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal()){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/GiftStd.do?cmd=saveGiftStd", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "giftSeq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}

	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/GiftStd.do?cmd=getGiftStdDtlList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet2,"giftCd", true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/GiftStd.do?cmd=saveGiftStdDtl", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet2.DataInsert(0);
				break;
			case "Copy":
				var row = sheet2.DataCopy();
				sheet2.SetCellValue(row, "giftCd", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
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

	//팝업 셀 클릭 시 
	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "searchDesc") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "pwrSrchMgrPopup";

				var args 	= new Array();
				args["srchBizCd"] = "09";
				args["srchType"] = "3";
				args["srchDesc"] = "대상";
				
			//	var rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup", args, "850","620");
	            let layerModal = new window.top.document.LayerModal({
	                  id : 'pwrSrchMgrLayer'
	                  , url : '/Popup.do?cmd=viewPwrSrchMgrLayer'
	                  , parameters : args
	                  , width : 1100
	                  , height : 520
	                  , title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>'
	                  , trigger :[
	                      {
	                          name : 'pwrTrigger'
	                          , callback : function(result){
	                        	  getReturnValue(result);
	                          }
	                      }
	                  ]
	              });
	              layerModal.show();
			
			}

			
		} catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	//셀 선택시
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if( NewRow >= sheet1.HeaderRows() && OldRow != NewRow ){
				$("#searchGiftSeq").val(sheet1.GetCellValue(NewRow,"giftSeq"));
		    	doAction2("Search");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	//셀 클릭 시 
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var colName = sheet2.ColSaveName(Col);
        var args    = new Array();
        if(colName == "btnAdd" && Row >=sheet1.HeaderRows()) {
        	gPRow = Row;
        	$("#fileuploader").click();
        }
	}
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 리턴 호출 함수
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(rv) {
		//var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "pwrSrchMgrPopup"){
			sheet1.SetCellValue(gPRow, "searchSeq", 	rv["searchSeq"] );
			sheet1.SetCellValue(gPRow, "searchDesc",	rv["searchDesc"] );
	    }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="uploadForm" name="uploadForm">
		<input id="fileSeq" name="fileSeq" type="hidden" />
		<input id="uploadType" name="uploadType" type="hidden" value="${uploadType}"/>
	</form>
	<div style="display:none;"><div id="fileuploader" ></div></div>
	<form name="sheet1Form" id="sheet1Form" method="post">
	<input type="hidden" id="searchGiftSeq" name="searchGiftSeq" />
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준일자</th>
			<td>
				<input type="text" id="searchYmd" name="searchYmd" class="date2" value=""/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="top">
		<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">선물기준관리</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "30%"); </script>
	</div>
	<div class="top">
	<div class="inner">
	<div class="sheet_title">
		<ul>
			<li class="txt">선물리스트</li>
			<li class="btn">
				<a href="javascript:doAction2('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction2('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction2('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
	</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "70%"); </script>
	</div>

</div>
</body>
</html>
