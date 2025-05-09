<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@page import="java.util.ResourceBundle"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>교육이력관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%
String uploadType = "edu001";

FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>

<!-- FileUpload javascript libraries ------------------------------------------------------------>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Org/IBOrgSharp5/lib/jquery.blockUI.js"></script>

<!--  FileUpload css files ------------------------------------------------------------------------->
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">

	$(function() {
		
		//Cancel 버튼 처리 
		$(".fileuploader").click(function(){
			var sRowStr = sheet1.GetSelectionRows("/");
			if(sheet1.GetCellValue(sRowStr, "sStatus") == "I"){
				alert("교육동영상 저장 후 파일등록이 가능합니다.");
	 			e.preventDefault();
			}
		});
		
		$("#searchEduMBranchCd").bind("change", function() {
			doAction1("Search");
		});
		
		$("#searchEduTitle,#searchFileNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
	
		$("#searchSYmd").datepicker2({startdate:"searchEYmd", onReturn: getCommonCodeList});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd", onReturn: getCommonCodeList});
	
		//Sheet 초기화
		inist_sheet1();
		inist_sheet2();
		sheetInit();
		
		doAction1("Search");
		
	});
	
	function inist_sheet1() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"파일순번",		Type:"Text",		Hidden:1,  	Width:50, 	Align:"Center", SaveName:"fileSeq", KeyField:0, UpdateEdit:0, InsertEdit:0, Sort:0 },
			{Header:"교육분류코드",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center", ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:1,	Format:"",    	UpdateEdit:1, InsertEdit:1 },
			{Header:"교육명",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"title",			KeyField:0,	Format:"",		UpdateEdit:1, InsertEdit:1,	EditLen:400 },
			{Header:"파일명",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center", ColMerge:0,	SaveName:"fileNm",			KeyField:0,	Format:"",    	UpdateEdit:0, InsertEdit:0 },
			{Header:"파일\n등록",	Type:"Html",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fileYn",			KeyField:0,	Format:"",		UpdateEdit:0, InsertEdit:0,	EditLen:100},
//			{Header:"세부\r\n내역",	Type:"Image",     	Hidden:0,  	Width:40,   Align:"Center", ColMerge:0, SaveName:"detail", 			KeyField:0, Format:"",      UpdateEdit:0, InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
// 			{Header:"교육\n타입",	Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fileType",		KeyField:0,	Format:"",		UpdateEdit:1, InsertEdit:1,	EditLen:1 },
			{Header:"교육시작일",	Type:"Date",	  	Hiddㄴen:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",			KeyField:1, Format:"Ymd",	UpdateEdit:1, InsertEdit:1 , EndDateCol:"eYmd"},
			{Header:"교육종료일",	Type:"Date",	  	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",			KeyField:0, Format:"Ymd",	UpdateEdit:1, InsertEdit:1 , StartDateCol:"sYmd"},
			{Header:"검색설명코드",	Type:"Text",      	Hidden:1,  	Width:80,   Align:"Center",	ColMerge:0, SaveName:"searchSeq",     	KeyField:0, Format:"",   	UpdateEdit:1, InsertEdit:1,   EditLen:10 },
            {Header:"대상자",	Type:"PopupEdit", 	Hidden:0,  	Width:150,  Align:"Left",	ColMerge:0, SaveName:"searchSeqNm",   	KeyField:0, Format:"",   	UpdateEdit:1, InsertEdit:1,   EditLen:100 },

            {Header:"영상링크",		Type:"Text",      	Hidden:0,  	Width:200,  Align:"Left",	ColMerge:0, SaveName:"urlLink",     	KeyField:0, Format:"",   	UpdateEdit:1, InsertEdit:1,   EditLen:400 },
            {Header:"교육링크",		Type:"Text",      	Hidden:0,  	Width:200,  Align:"Left",	ColMerge:0, SaveName:"eduLink",     	KeyField:0, Format:"",   	UpdateEdit:1, InsertEdit:1,   EditLen:400 },
            {Header:"영상\n보기",	Type:"Image",      	Hidden:1,  	Width:40,   Align:"Left",	ColMerge:0, SaveName:"urlLinkYn",     	KeyField:0, Format:"",   	UpdateEdit:1, InsertEdit:1,   EditLen:400 },
            
            {Header:"교육목적",		Type:"Image",     	Hidden:0,  	Width:60,   Align:"Center", ColMerge:0, SaveName:"note2", 			KeyField:0, Format:"",      UpdateEdit:0, InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"교육목적TEXT",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0, Format:"",		UpdateEdit:0, InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");

		getCommonCodeList();
		
// 		sheet1.SetColProperty("fileType",  	{ComboText:"|동영상|유튜브", ComboCode:"|1|2"} );
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	};

	function getCommonCodeList() {
		//공통코드 한번에 조회
		let grpCds = "L10015";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchSYmd").val() + "&baseEYmd=" + $("#searchEYmd").val();
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "");

		sheet1.SetColProperty("eduMBranchCd",  	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );
		$("#searchEduMBranchCd").html("<option value=''>전체</option>"+codeLists["L10015"][2]);  // 교육구분
	}
	
	function inist_sheet2() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [

			{Header:"No",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo", Sort:0 },
// 			{Header:"선택",			Type:"CheckBox",	Hidden:Number("${sDelHdn}"),	Width:45,			Align:"Center",	SaveName:"sChk" , Sort:0},
			{Header:"선택",			Type:"CheckBox",	Hidden:0,	Width:45,			Align:"Center",	SaveName:"sChk" , Sort:0},
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus" ,Sort:0 },
// 			{Header:"회사명",			Type:"Text",		Hidden:1,	Width:10,			Align:"Center",	SaveName:"enterCd", UpdateEdit:0 },
 			{Header:"파일번호",			Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	SaveName:"fileSeq", UpdateEdit:0 },
 			{Header:"파일순번",			Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	SaveName:"seqNo", 	UpdateEdit:0 },
 			{Header:"파일명",			Type:"Text",		Hidden:0,	Width:100,			Align:"Left",	SaveName:"rFileNm", UpdateEdit:0 },
// 			{Header:"저장파일명",		Type:"Text",		Hidden:1,	Width:10,			Align:"Left",	SaveName:"sFileNm", UpdateEdit:0 },
			{Header:"용량(KByte)",	Type:"Int",			Hidden:1,	Width:100,			Align:"right",	SaveName:"fileSize",UpdateEdit:0 },
			{Header:"파일크기",			Type:"Int",			Hidden:0,	Width:100,			Align:"right",	SaveName:"vfileSize",UpdateEdit:0, CalcLogic:"|fileSize|/1000", Format:"#,##\\kb" },
			{Header:"등록일",			Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	SaveName:"chkdate", UpdateEdit:0 },
			{Header:"등록자",			Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	SaveName:"chkId", 	UpdateEdit:0 },
			{Header:"다운로드",			Type:"Image",		Hidden:0,	Width:45,			Align:"Center",	SaveName:"download",UpdateEdit:0 ,	Cursor:"Pointer", Sort:0}
		]; IBS_InitSheet(supSheet, initdata1);supSheet.SetEditableColorDiff (0);
		supSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$(window).smartresize(sheetResize);
		sheetInit();
		
		//파일첨부 버튼 생성
		var options = $.extend(true, ${fConfig}, {
			btn : {
				browse : {
					title : "파일선택",
					class : "browse-btn"
				}
			},
			context:"${ctx}",
			event:{
				success: function(jsonData) {
					$.unblockUI();
					if(jsonData.data !== undefined && jsonData.data !== null && jsonData.data.length > 0) {
						$("#uploadForm>#fileSeq").val(jsonData.data[0].fileSeq);
						doFileAction("Search");
// 						doAction1("Search");
					}
				},
				error: function(jsonData) {
					$.unblockUI();
				},beforeSubmit : function(options) {
					$.blockUI({message:"<img src='/common/images/common/InfLoading.gif'/>",css:{border:'0px solid #ffffff'},overlayCSS:{backgroundColor:"#ffffff"}});
					options.el.hide();
					return true;
				}
			},
			localeCd:"${ssnLocaleCd}"
		}),
		params = {
			'uploadType' : $("#uploadType").val(),
			'fileSeq' : getUpLoadFileSeq
		};

		$("#fileuploader").fileupload("init", options, params);
		
	};
	
	
	function upLoadInit(fileSeq,filePath){
		if(fileSeq !=- null && fileSeq !== "") {
			$("#uploadForm>#fileSeq").val(fileSeq);
			doFileAction("Search");
// 			doAction1("Search");
		}
	}
	
	
	function getUpLoadFileSeq(){
		return $("#uploadForm>#fileSeq").val();
	}

	function chkInVal(sAction) {

		switch (sAction) {
			case "Search" :
				if( $("#searchSYmd").val() != "" && $("#searchEYmd").val() != "" ){
					if(!checkFromToDate($("#searchSYmd"), $("#searchEYmd"), "교육기간", "교육기간", "YYYYMMDD")) {
						$("#searchEYmd").focus();
						$("#searchEYmd").select();
						return false;
					}
				}
				break;
			case "Save" :
				for (var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {
					if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
						if (sheet1.GetCellValue(i, "sYmd") != null && sheet1.GetCellValue(i, "eYmd") != "") {
							var sdate = sheet1.GetCellValue(i, "sYmd");
							var edate = sheet1.GetCellValue(i, "eYmd");
							if (parseInt(sdate) > parseInt(edate)) {
								alert("<msg:txt mid='110396' mdef='교육시작일자가 종료일자보다 큽니다.'/>");
								sheet1.SelectCell(i, "eYmd");
								return false;
							}
						}
					}
				}
				break;
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal(sAction)) {break;}
			sheet1.DoSearch("${ctx}/EduContentsMgr.do?cmd=getEduContentsMgr", $("#sheet1Form").serialize() );break;
        case "Save":
			if(!chkInVal(sAction)) {break;}
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/EduContentsMgr.do?cmd=saveEduContentsMgr", $("#sheet1Form").serialize());
        	break;

        case "Insert":
            var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"fileSeq",fileSeq);
			  for(var i = 1; i < sheet1.RowCount()+1; i++) {
                if( sheet1.GetCellValue(i, "eduMBranchCd") != "C") {
                    sheet1.SetCellEditable(i,"eduLink", 0);
                } 
            }

            break;

        case "Copy":
            var row = sheet1.DataCopy();
            sheet1.SetCellValue(row, "fileSeq", "");
        	break;
		}
	}
	
	//첨부파일 관련
	function doFileAction(sAction) {
		switch (sAction) {
			case "Search":  supSheet.DoSearch( "${ctx}/fileuploadJFileUpload.do?cmd=jFileList", $("#uploadForm").serialize() ); break;
			case "Del":
				var rows = supSheet.FindCheckedRow("sChk");
				if(rows == "" && $("#uploadType").val() != "") {
					if(confirm("전체 삭제를 하시겠습니까?")) {
						$.filedelete($("#uploadType").val(), {"fileSeq" : $("#fileSeq").val()});
					}
				} else {
					var rowarr = rows.split("|");
					var params = [];

					for(var i=0;i<rowarr.length;i++) {
						params[i] = supSheet.GetRowJson(rowarr[i]);
					}

					$.filedelete($("#uploadType").val(), params, function(code, message) {
						if(code == "success") {
							doFileAction("Search");
							doAction1("Search");
						} else {
							var msg = (message ? message : "삭제에 실패하였습니다.");
							alert(msg);
						}
					});
				}
				break;
			case "download" :
				var rows = supSheet.FindCheckedRow("sChk");
				if(rows==""){
					alert("선택된 파일이 없습니다.");
					return;
				}
				if(rows == "" && $("#uploadType").val() != "") {
					if(confirm("전체 다운로드를 하시겠습니까?")) {
						$.filedownload($("#uploadType").val(), {"fileSeq" : $("#fileSeq").val()});
					}
				} else {
					var rowarr = rows.split("|");
					var params = [];
					for(var i=0;i<rowarr.length;i++) {
						params[i] = supSheet.GetRowJson(rowarr[i]);
					}
					$.filedownload($("#uploadType").val(), params);
				}
				break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		
		try {
			  for(var i = 1; i < sheet1.RowCount()+1; i++) {
                  if( sheet1.GetCellValue(i, "eduMBranchCd") != "C") {
                      sheet1.SetCellEditable(i,"eduLink", 0);
                  } 
              }
			
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	//값을 편집한 직후 이벤트가 발생한다.
	function sheet1_OnAfterEdit(Row, Col) {
		try{
			
			if(sheet1.GetCellValue(Row, "eduMBranchCd") != "C" ){
				sheet1.SetCellValue(Row,"eduLink", "");
				sheet1.SetCellEditable(Row,"eduLink", 0);
			}else{
				sheet1.SetCellEditable(Row,"eduLink", 1);
			}
		}catch(ex){alert("OnAfterEdit Event Error : " + ex);}
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
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		if( OldRow != NewRow ) {
			$("#fileSeq").val(sheet1.GetCellValue(NewRow, "fileSeq"));
// 			$("#uploadType").val(sheet1.GetCellValue(NewRow, "fileType"));
			doFileAction("Search");
		}
	}
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if(Row > 0 && sheet1.ColSaveName(Col) == "detail" && sheet1.GetCellValue(Row,"sStatus") != "I"){
		    	//동영상보기 팝업
				eduContentsMgrPopup(Row);
		    }else if (sheet1.ColSaveName(Col) == "note2"){
		    	eduContentsNoteUpdatePopup(Row);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	/**
	 * 동영상보기 window open event
	 */
	function eduContentsMgrPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 720;
		var h 		= 700;
		var url 	= "${ctx}/EduContentsMgr.do?cmd=viewEduContentsMgrPopup&authPg=${authPg}";
		var args 	= new Array();
		args["fileSeq"] 		= sheet1.GetCellValue(Row, "fileSeq");
		args["eduMBranchCd"] 	= sheet1.GetCellValue(Row, "eduMBranchCd");
		args["fileNm"] 			= sheet1.GetCellValue(Row, "fileNm");
		args["fileYn"] 			= sheet1.GetCellValue(Row, "fileYn");
		args["detail"] 			= sheet1.GetCellText(Row, "detail");
// 		args["fileType"] 		= sheet1.GetCellText(Row, "fileType");
		args["sFileNm"] 		= sheet1.GetCellValue(Row, "sFileNm");
		args["urlLink"] 		= sheet1.GetCellValue(Row, "urlLink");
		args["eduLink"] 		= sheet1.GetCellValue(Row, "eduLink");
		args["sYmd"] 			= sheet1.GetCellValue(Row, "sYmd");
		args["eYmd"] 			= sheet1.GetCellValue(Row, "eYmd");
		args["searchSeq"] 		= sheet1.GetCellValue(Row, "searchSeq");
		args["searchSeqNm"] 	= sheet1.GetCellValue(Row, "searchSeqNm");
		args["note"] 			= sheet1.GetCellValue(Row, "note");
	

		openPopup(url,args,w,h, function(rv){
			if (rv["saveYn"] == "Y"){
				doFileAction("Search");
			}
		});
	}
	
	function eduContentsNoteUpdatePopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 400;
		var h 		= 350;
		var args 	= new Array();
		args["note"] 			= sheet1.GetCellValue(Row, "note");

		let layerModal = new window.top.document.LayerModal({
			id : 'eduContentsNoteUpdateLayer'
			, url : '/EduContentsMgr.do?cmd=viewEduContentsNoteUpdateLayer&authPg=${authPg}'
			, parameters : args
			, width : w
			, height : h
			, title : '교육목적입력'
			, trigger :[
				{
					name : 'eduContentsNoteUpdateLayerTrigger'
					, callback : function(rv){
						sheet1.SetCellValue(Row, "note", rv["note"] );
					}
				}
			]
		});
		layerModal.show();
	}

	
	
	
// 	Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{

		  var colName = sheet1.ColSaveName(Col);
		  var args    = new Array();
		  args["srchBizCd"]   = "05"; // 교육관리
		  args["searchSeq"]   = sheet1.GetCellValue(Row, "searchSeq");
          args["searchDesc"]  = sheet1.GetCellValue(Row, "searchSeqNm");

		  var rv = null;
		  if(colName == "searchSeqNm") {
			  if(!isPopup()) {return;}
			  gPRow = Row;
			  pGubun = "pwrSrchMgrPopup";

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
						  , callback : function(rv){
							  sheet1.SetCellValue(gPRow, "searchSeq",   rv["searchSeq"] );
							  sheet1.SetCellValue(gPRow, "searchSeqNm", rv["searchDesc"] );
						  }
					  }
				  ]
			  });
			  layerModal.show();
		  }else if(colName == "languageNm"){
        	  lanuagePopup(Row, "sheet1", "tcpn051", "languageCd", "languageNm", "payNm");
          }

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	//-----------------------------------------------------------------------------------
	//		supSheet 이벤트
	//-----------------------------------------------------------------------------------
	function supSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
			$("#fileuploader").fileupload('setCount', supSheet.RowCount());
		  	if(supSheet.RowCount() == 0) {
		    	//alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
		  	}
		  	supSheet.FocusAfterProcess = false;
			setSheetSize(supSheet);
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	function supSheet_OnClick(Row, Col, Value) {
		try{
			if(Row > 0 && supSheet.ColSaveName(Col) == "download" ){
				$.filedownload($("#uploadType").val(), supSheet.GetRowJson(Row));
			}
			if(Row > 0 && supSheet.ColSaveName(Col) == "sChk" ){
				if(supSheet.GetCellValue(Row, "sStatus")!="I"){
					supSheet.SetCellValue(Row, "sStatus","");
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function supSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function supSheet_OnResize(lWidth, lHeight) {
		try { 
			setSheetSize(supSheet); 
		}catch(ex){
			alert("OnResize Event Error : " + ex); 
		}
	}
	
 	// checkbox 선택시 계약일 전체기간으로 설정
 	$(function(){
 		$("#searchWholePeriod").click(function(){
 			if($("input:checkbox[id='searchWholePeriod']").is(":checked") == true){
 				$("#searchSYmd").val('');
 				$("#searchEYmd").val('');
 			}else{
				$("#searchSYmd").val('<%=DateUtil.getCurrentTime("yyyy-MM-01")%>');
				$("#searchEYmd").val('<%=DateUtil.getLastDateOfMonth(DateUtil.getCurrentTime("yyyy-MM-dd"))%>');
 			}
 		})
 	});
 	
</script>

</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="sheet1Form" name="sheet1Form" >
	<input id="selectFileSeq" name="selectFileSeq" type="hidden" />
<!-- 	<input id="selectFileType" name="selectFileType" type="hidden" /> -->
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>교육기간</th>
			<td>
				<input id="searchSYmd" name="searchSYmd" type="text" class="date2" value=""/>&nbsp;&nbsp;~&nbsp;&nbsp;
				<input id="searchEYmd" name="searchEYmd" type="text" class="date2" value=""/>
			</td>
			<th>교육분류</th>
			<td>
				<select id="searchEduMBranchCd" name="searchEduMBranchCd"> </select>
			</td>
		</tr>
		<tr>
			<th>교육명</th>
			<td>
				<input id="searchEduTitle" name ="searchEduTitle" type="text" class="text w100"/>
			</td>
			<th>파일명</th>
			<td>
				<input id="searchFileNm" name ="searchFileNm" type="text" class="text w110"/>
			</td>
			
			<th>전체기간세팅</th>
			<td>
				<input id="searchWholePeriod" name="searchWholePeriod" type="checkbox" class="checkbox" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<form id="uploadForm" name="uploadForm">
		<input id="fileSeq" name="fileSeq" type="hidden" />
		<input id="uploadType" name="uploadType" type="hidden" value="edu001"/>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">교육동영상관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA" >복사</a>
								<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA" >입력</a>
								<a href="javascript:doAction1('Save')" 			class="btn filled authA" >저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "70%");</script>
			</td>
		</tr>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">교육자료</li>
							<li class="btn">
								<ul>
									<li style="float: left;">
										<a href="javascript:doFileAction('download');"  class="btn outline-gray authA">선택 다운로드</a>
									</li>
									<li style="float: left;">
										<a href="javascript:doFileAction('Del');" 		class="btn outline-gray authA">삭제</a>
									</li>
								<c:if test="${fileBtn!='N'}">
									<li style="float: left;">
										<div id='fileuploader' class="fileuploader" align='right' style="padding-top: 1px;"></div>
									</li>
								</c:if>
								</ul>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("supSheet","100%","30%");</script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>