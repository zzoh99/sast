<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%
String uploadType = "businessPlace";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:6,MergeSheet:msNone};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='businessPlaceCdV1' mdef='사업장코드'/>",			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"businessPlaceCd",      	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"sdate",                  	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"edate",                  	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='mapTypeCd_V3437' mdef='소속매핑구분코드'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"mapTypeCd",            	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='businessPlaceNm_V3438' mdef='소속매핑코드명'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"businessPlaceNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='businessPlaceEngNm' mdef='소속매핑코드영문명'/>",	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"businessPlaceEngNm",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='regino_V2' mdef='사업장등록번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"regino",                 	KeyField:0,   CalcLogic:"",   Format:"SaupNo",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='president_V2986' mdef='사업자명'/>", 			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"president",              	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='engpresident' mdef='영문사업자명'/>", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"engpresident",           	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='comtype' mdef='업종'/>", 				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"comtype",                	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='engcomtype' mdef='업종(영문)'/>", 			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"engcomtype",             	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='businessType' mdef='종목'/>", 				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"item",                   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
            {Header:"<sht:txt mid='engitem' mdef='종목(영문)'/>", 			Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"engitem",                	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='hiNo' mdef='건강보험관리번호'/>", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"hiNo",                  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='npNo' mdef='국민연금관리번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"npNo",                  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='epNo' mdef='고용보험관리번호'/>", 	    Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"epNo",                  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='aiNo' mdef='산재보험관리번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"aiNo",                  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='locationCd_V462' mdef='LOCATION코드'/>", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"locationCd",            	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='telNoV2' mdef='대표전화번호'/>", 	    Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"telNo",                 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='taxNo' mdef='세무서번호'/>", 	    	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"taxNo",                 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='officeNm_V3348' mdef='세무서명'/>", 	    	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"officeNm",              	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='officeEngNm' mdef='영문세무서명'/>", 	    Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"officeEngNm",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='otaxAccountNo' mdef='원천세계좌번호'/>", 		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"otaxAccountNo",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eUnionNm' mdef='고용보험사무조합명칭'/>", 	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"eUnionNm",             	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eUnionNo' mdef='고용보험사무조합번호'/>", 	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"eUnionNo",             	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eUnionUnderNo' mdef='고용보험하수급인관리번호'/>",Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"eUnionUnderNo",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		    {Header:"<sht:txt mid='mainPlaceYn' mdef='주사업장여부'/>",    		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"mainPlaceYn",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		    {Header:"<sht:txt mid='zip' mdef='우편번호'/>",			Type:"Text", 	  Hidden:0,  Width:65,   Align:"Center",  ColMerge:0,   SaveName:"zip",             		KeyField:0,   CalcLogic:"",   Format:"PostNo",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"<sht:txt mid='address' mdef='주소'/>",				Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"addr",            		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
            {Header:"<sht:txt mid='engAddr' mdef='영문주소'/>", 			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"engAddr",         		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
            {Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:6,MergeSheet:msNone};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"사업장코드", 		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"businessPlaceCd",              	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사업장명", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"businessPlaceNm",              	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgMapItemBpCdList",false).codeList, "");	//소속구분항목(급여사업장)
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, " ");	//LOCATION
		$("#locationCd").html(locationCd[2]);
		$(window).smartresize(sheetResize); sheetInit();
		doAction2("Search");
	});

	$(function() {
		$("#sdate").datepicker2({startdate:"edate"});
		$("#edate").datepicker2({enddate:"sdate"});

		$("#locationCd").change(function(){
			$("#searchLocationCd").val($("#locationCd option:selected").val());
	    	var locationCall =  ajaxCall("${ctx}/PayComMgr.do?cmd=getCorpInfoMgrLocationMap",$("#srchFrm").serialize(),false);

	    	if( locationCall.DATA != null ) {
		    	$("#zip").val(locationCall.DATA.zip);
		    	$("#addr").val(locationCall.DATA.addr);
		    	$("#engAddr").val(locationCall.DATA.engAddr);
	    	}
		});

		$("#zip").mask("111-111");
		$("#regino").mask("111-11-11111");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PayComMgr.do?cmd=getPayComMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}
			setSheet1Data();
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PayComMgr.do?cmd=savePayComMgr", $("#srchFrm").serialize() );

		break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "businessPlaceCd"); break;		
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/PayComMgr.do?cmd=getPayComMgrMasterList", $("#srchFrm").serialize() ); break; 
		case "Down2Excel":	sheet2.Down2Excel(); break;
		}		
	}
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } getSheet1Data(); sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } if(Code > 0) doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
    function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try{
            if(OldRow != NewRow){
            	$("#searchBusinessPlaceCd").val(sheet2.GetCellValue(NewRow,"businessPlaceCd"));
                doAction1("Search");
            }
        }catch(ex){alert("OnSelectCell Event Error : " + ex);}
     }

	// 시트에서 폼으로 세팅.
	function getSheet1Data() {

		var row = sheet1.LastRow();

		if(row == 0) {
			var businessPlaceCd = $("#searchBusinessPlaceCd").val();
			$(":input").val("");
			$("#searchBusinessPlaceCd").val(businessPlaceCd);
			$("#mapTypeCd").val('100'); // 신규사업장등록하는 경우

		}else{

		$("#searchBusinessPlaceCd").val(sheet1.GetCellValue(row, "businessPlaceCd"));
        $("#sdate").val(sheet1.GetCellText(row, "sdate"));
        $("#edate").val(sheet1.GetCellText(row, "edate"));
        $("#mapTypeCd").val(sheet1.GetCellValue(row, "mapTypeCd"));
        $("#businessPlaceNm").val(sheet1.GetCellValue(row, "businessPlaceNm"));
        $("#businessPlaceEngNm").val(sheet1.GetCellValue(row, "businessPlaceEngNm"));
        $("#regino").val(sheet1.GetCellText(row, "regino"));
        $("#president").val(sheet1.GetCellValue(row, "president"));
        $("#engpresident").val(sheet1.GetCellValue(row, "engpresident"));
        $("#comtype").val(sheet1.GetCellValue(row, "comtype"));
        $("#engcomtype").val(sheet1.GetCellValue(row, "engcomtype"));
        $("#item").val(sheet1.GetCellValue(row, "item"));
        $("#engitem").val(sheet1.GetCellValue(row, "engitem"));
        $("#hiNo").val(sheet1.GetCellValue(row, "hiNo"));
        $("#npNo").val(sheet1.GetCellValue(row, "npNo"));
        $("#epNo").val(sheet1.GetCellValue(row, "epNo"));
        $("#aiNo").val(sheet1.GetCellValue(row, "aiNo"));
        $("#locationCd").val(sheet1.GetCellValue(row, "locationCd"));
        $("#telNo").val(sheet1.GetCellValue(row, "telNo"));
        $("#taxNo").val(sheet1.GetCellValue(row, "taxNo"));
        $("#officeNm").val(sheet1.GetCellValue(row, "officeNm"));
        $("#officeEngNm").val(sheet1.GetCellValue(row, "officeEngNm"));
        $("#otaxAccountNo").val(sheet1.GetCellValue(row, "otaxAccountNo"));
        $("#eUnionNm").val(sheet1.GetCellValue(row, "eUnionNm"));
        $("#eUnionNo").val(sheet1.GetCellValue(row, "eUnionNo"));
        $("#eUnionUnderNo").val(sheet1.GetCellValue(row, "eUnionUnderNo"));
        $("#mainPlaceYn").val(sheet1.GetCellValue(row, "mainPlaceYn"));

        $("#zip").val(sheet1.GetCellText(row, "zip"));
        $("#addr").val(sheet1.GetCellValue(row, "addr"));
        $("#engAddr").val(sheet1.GetCellValue(row, "engAddr"));
        
        if(sheet1.GetCellValue(row,"fileSeq") != ""){
			$("#filebtn > a").text("다운로드");
			$("#fileSeq").val(sheet1.GetCellValue(row,"fileSeq"));
		}else{
			$("#filebtn > a").text("첨부파일");
			$("#fileSeq").val("");
		}
        
        var authPgTemp="${authPg}";
		if(authPgTemp != 'A'){
			if(sheet1.GetCellValue(row,"fileSeq") == ""){
				$("#filebtn").hide();
			}
		}
        
		}
	}

	// 폼에서 시트로 세팅.
	function setSheet1Data() {
		var row = null;
		if( sheet1.RowCount() == 0 ) row = sheet1.DataInsert(0);
		else row = sheet1.LastRow();

		sheet1.SetCellValue(row, "businessPlaceCd", $("#searchBusinessPlaceCd").val());
        sheet1.SetCellValue(row, "sdate", $("#sdate").val());
        sheet1.SetCellValue(row, "edate", $("#edate").val());
        sheet1.SetCellValue(row, "mapTypeCd", $("#mapTypeCd").val());
        sheet1.SetCellValue(row, "businessPlaceNm", $("#businessPlaceNm").val());
        sheet1.SetCellValue(row, "businessPlaceEngNm", $("#businessPlaceEngNm").val());
        sheet1.SetCellValue(row, "regino", $("#regino").val());
        sheet1.SetCellValue(row, "president", $("#president").val());
        sheet1.SetCellValue(row, "engpresident", $("#engpresident").val());
        sheet1.SetCellValue(row, "comtype", $("#comtype").val());
        sheet1.SetCellValue(row, "engcomtype", $("#engcomtype").val());
        sheet1.SetCellValue(row, "item", $("#item").val());
        sheet1.SetCellValue(row, "engitem", $("#engitem").val());
        sheet1.SetCellValue(row, "hiNo", $("#hiNo").val());
        sheet1.SetCellValue(row, "npNo", $("#npNo").val());
        sheet1.SetCellValue(row, "epNo", $("#epNo").val());
        sheet1.SetCellValue(row, "aiNo", $("#aiNo").val());
        sheet1.SetCellValue(row, "locationCd", $("#locationCd option:selected").val());
        sheet1.SetCellValue(row, "telNo", $("#telNo").val());
        sheet1.SetCellValue(row, "taxNo", $("#taxNo").val());
        sheet1.SetCellValue(row, "officeNm", $("#officeNm").val());
        sheet1.SetCellValue(row, "officeEngNm", $("#officeEngNm").val());
        sheet1.SetCellValue(row, "otaxAccountNo", $("#otaxAccountNo").val());
        sheet1.SetCellValue(row, "eUnionNm", $("#eUnionNm").val());
        sheet1.SetCellValue(row, "eUnionNo", $("#eUnionNo").val());
        sheet1.SetCellValue(row, "eUnionUnderNo", $("#eUnionUnderNo").val());
        sheet1.SetCellValue(row, "mainPlaceYn", $("#mainPlaceYn option:selected").val());

        sheet1.SetCellValue(row, "fileSeq", $("#fileSeq").val());

	}

	function chkInVal() {
		
		if ( $("#regino").val() == "" ){
			alert("사업자등록번호는 필수 입력값입니다.");
			return false;
		}
		
		var sdate = $("#sdate").val();
		var edate = $("#edate").val();

		if(sdate == ""){
			alert("<tit:txt mid='2017082500558' mdef='유효기간 시작일자는 필수입력 사항입니다.'/>");
			$("#sdate").focus();
			return false;
		}

		/** 유효기간 확인 **/
		if( sdate != "" && edate != "" ){
			var _chk = checkFromToDate($("#sdate"), $("#edate"), "", "", "YYYYMMDD");

			return _chk;
		}

		return true;
	}

	// 첨부파일 등록	
	function attachFile(seq){
		if(!isPopup()) {return;}
		var url =  '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=businessPlace';
		var param = { fileSeq: $("#fileSeq").val() };
		let layerModal = new window.top.document.LayerModal({
            id : 'fileMgrLayer'
          , url : url
          , parameters : param
          , width : 740
          , height : 620
          , title : '파일 업로드'
          , trigger :[
              {
                    name : 'fileMgrTrigger'
                  , callback : function(result){
                	  getReturnValue(result);
                  }
              }
          ]
      });
      layerModal.show(); 
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		if(returnValue["fileCheck"] == "exist"){
			$("#filebtn > a").text("다운로드");
			$("#fileSeq").val(returnValue["fileSeq"]);
		}else{
			$("#filebtn > a").text("첨부");
			$("#fileSeq").val("");
		}
	}


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" name="searchLocationCd" id="searchLocationCd">		
		<input type="hidden" id="fileSeq" name="fileSeq"  value="">	
		<input type="hidden" id="searchBusinessPlaceCd" name="searchBusinessPlaceCd"  value="">
	</form>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="20%" />
		<col width="80%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">사업장</li>
					<li class="btn">
						<a href="javascript:doAction2('Search')" 	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
		</td>
		<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='114178' mdef='사업장관리'/></li>
						<li class="btn">
							<span id="filebtn"><btn:a href="javascript:attachFile('1');" css="btn outline-gray" mid='attachFile' mdef="첨부파일"/></span>
							<a href="javascript:doAction1('Save');" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
					</div>
				</div>
				<div class="payComTableWrap">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<!-- 사업장 폼 시작 -->
				<input type="hidden" name="mapTypeCd" id="mapTypeCd">
				<tr>
				    <td style="height:100%;">
				    <table border="0" cellpadding="0" cellspacing="0" class="default inner">
				    <colgroup>
				        <col width="17%" />
				        <col width="17%" />
				        <col width="17%" />
				        <col width="17%" />
				        <col width="17%" />
				        <col width="" />
				    </colgroup>
				    <tr>
				        <th><tit:txt mid='113824' mdef='사업장'/></th>
				        <td>
				            <input name="businessPlaceNm" type="TEXT" id="businessPlaceNm" class="text w100p">
		
				        </td>
				        <th><tit:txt mid='113824' mdef='사업장'/>(<tit:txt mid='112803' mdef='영문'/>)</th>
				        <td>
				            <input name="businessPlaceEngNm" type="text" id="businessPlaceEngNm" class="text w100p" />
				        </td>
				        <th><tit:txt mid='112065' mdef='사업자명'/></th>
				        <td>
				            <input name="president" type="text" id="president"  class="text w100p"/>
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='104479' mdef='사업자등록번호'/></th>
				        <td>
				        <input name="regino" type="text" id="regino" class="text w100p required" />
				        </td>
				        <th><tit:txt mid='114179' mdef='영문사업자명'/></th>
				        <td>
				            <input name="engpresident" type="text" id="engpresident" class="text w100p" />
				        </td>
				        <th><tit:txt mid='113119' mdef='업태'/></th>
				        <td>
				            <input name="comtype" type="text" id="comtype" class="text w100p" />
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='112066' mdef='종목'/></th>
				        <td>
				        <input name="item" type="text" id="item" class="text w100p" /></td>
				        <th><tit:txt mid='114558' mdef='업태(영문)'/></th>
				        <td>
				        <input name="engcomtype" type="text" id="engcomtype" class="text w100p" />
				        </td>
				        <th><tit:txt mid='112755' mdef='종목(영문)'/></th>
				        <td>
				            <input name="engitem" type="text"  id="engitem" class="text w100p" />
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='112756' mdef='건강보험 관리번호'/></th>
				        <td>
				        <input name="hiNo" type="text" id="hiNo" class="text w100p" />
				        </td>
				        <th><tit:txt mid='113469' mdef='국민연금 관리번호'/></th>
				        <td>
				            <input name="npNo" type="text" id="npNo" class="text w100p" />
				        </td>
				        <th><tit:txt mid='112411' mdef='산재보험번호'/></th>
				        <td>
				            <input name="aiNo" type="text" id="aiNo" class="text w100p" />
				        </td>
				    </tr>
				    </table>
		<br />
				    <table border="0" cellpadding="0" cellspacing="0" class="default inner">
				    <colgroup>
				        <col width="25%" />
				        <col width="25%" />
				        <col width="25%" />
				        <col width="" />
				    </colgroup>
				    <tr>
				        <th class="center"><tit:txt mid='114559' mdef='고용보험관리번호'/></th>
				        <th class="center"><tit:txt mid='112067' mdef='고용보험사무조합명칭'/></th>
				        <th class="center"><tit:txt mid='113470' mdef='고용보험사무조합번호'/></th>
				        <th class="center"><tit:txt mid='112412' mdef='고용보험하수급인관리번호'/></th>
				    </tr>
				    <tr>
				        <td><input name="epNo" type="text" id="epNo" class="text center w100p"/></td>
				        <td><input name="eUnionNm" type="text" id="eUnionNm" class="text center w100p" /></td>
				        <td><input name="eUnionNo" type="text" id="eUnionNo" class="text center w100p"/></td>
				        <td><input name="eUnionUnderNo" type="text" id="eUnionUnderNo" class="text center w100p"/></cd>
				    </tr>
				    </table>
		<br />
				    <table border="0" cellpadding="0" cellspacing="0" class="default inner">
				    <colgroup>
				        <col width="20%" />
				        <col width="" />
				    </colgroup>
				    <tr>
				        <th><tit:txt mid='112757' mdef='주사업장여부'/></th>
				        <td>
				        	<select naim="mainPlaceYn" id="mainPlaceYn">
				        		<option value=""></option>
				        		<option value="Y" selectde>YES</option>
				        		<option value="N">NO</option>
				        	</select>
				        </td>
				    </tr>
				    <tr>
				        <th>Location</th>
				        <td><select name="locationCd" id="locationCd"></select>
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='114180' mdef='대표전화번호'/></th>
				        <td>
				        <input name="telNo" type="text" id="telNo" class="text w100" />
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='112055' mdef='우편번호'/></th>
				        <td>
				        <input name="zip" type="text" id="zip" class="text transparent w100" readonly>
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='112068' mdef='소재지(한글)'/></th>
				        <td>
				        <input name="addr" type="text" id="addr" class="text transparent w100p" readonly>
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='112758' mdef='소재지(영문)'/></th>
				        <td>
				                <input name="engAddr" type="text" id="engAddr" class="text transparent w100p" readonly>
				        </td>
				    </tr>
				    <tr>
				        <th><tit:txt mid='contPeriod' mdef='유효기간'/></th>
				        <td>
				        <input name="sdate" type="text" id="sdate" class="date2 center required" size="10" />
				        ~
				        <input name="edate" type="text" id="edate" class="date2 center required" size="10" />
				        </td>
				    </tr>
				    </table>
		<br />
				    <table border="0" cellpadding="0" cellspacing="0" class="default inner">
				    <colgroup>
				        <col width="25%" />
				        <col width="25%" />
				        <col width="25%" />
				        <col width="" />
				    </colgroup>
				    <tr>
				        <th class="center"><tit:txt mid='112069' mdef='세무서번호'/></th>
				        <th class="center"><tit:txt mid='113471' mdef='세무서명(한글)'/></th>
				        <th class="center"><tit:txt mid='114181' mdef='세무서명(영문)'/></th>
				        <th class="center"><tit:txt mid='112414' mdef='원천세 계좌번호'/></th>
				    </tr>
				    <tr>
				        <td><input name="taxNo" type="text" id="taxNo" class="text center w100p"/></td>
				        <td><input name="officeNm" type="text" id="officeNm" class="text center w100p"/></td>
				        <td><input name="officeEngNm" type="text" id="officeEngNm" class="text center w100p"/></td>
				        <td><input name="otaxAccountNo" type="text" id="otaxAccountNo" class="text center w100p"/></td>
				    </tr>
				    </table>
				    </td>
				</tr>
				<!-- 사업장 폼 끝 -->
			</table>
			</div>
		</td>
	</tr>
	</table>
</div>
	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</div>
</body>
</html>