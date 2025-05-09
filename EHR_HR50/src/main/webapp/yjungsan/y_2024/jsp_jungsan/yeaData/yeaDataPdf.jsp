<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html> <html><head> <title>PDF등록</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%
	String orgAuthPg  = request.getParameter("orgAuthPg");
	String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
%>

<script type="text/javascript">
	var agent = navigator.userAgent.toLowerCase();
	// 브라우저가 IE인지 체크 (드래그 앤 드롭 파일등록 관련 오류 방지)
	var isIE = false;
	if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
		isIE = true;
	}
	var orgAuthPg = "<%=orgAuthPg%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	//도움말
    var helpText1;

    var vsSsnEnterCd = "<%=ssnEnterCd%>";
    
    var pdfTypeCd;
    var counter = 0;
    var chkAll = false;
    var formData = new FormData();
    
    var chkFull = false;
    
    var bulkRegistYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_PDF_BULK_REGIST_TYPE", "queryId=getSystemStdData",false).codeList[0];
    var fileUploadTypeList = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_FILE_UPLOAD_TYPE", "queryId=getSystemStdData",false).codeList[0];
    var bulkPdfInfo;


    helpText1 = "* 국세청 연말정산간소화서비스 사이트에서 아래의 이미지에 해당하는 PDF를 다운로드 하셔서 등록하시기 바랍니다.<br>";

	$(function() {	
		if(bulkRegistYn != null){
			bulkRegistYn = bulkRegistYn.code_nm;
		}
		if(fileUploadTypeList != null){
			//fileUploadType = fileUploadTypeList.code_nm
			$("#fileUploadType").val(fileUploadTypeList.code_nm);
		} else {
			$("#fileUploadType").val('0');
		}
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;

		/* $("#spanYear").html($("#searchWorkYy").val()) ; */

		systemYY = $("#searchWorkYy", parent.document).val();

		$("#contents").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction2("Search");
			}
		});
		$("#formCd,#statusCd,#a1").bind("change",function(event){
			//doAction("Search");
			doAction2("Search");
		});

		var a1CdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfA1&"+ $("#sheetForm").serialize(), ""), "전체");
		$("#a1").html(a1CdList[2]);
		
		// DF 업로드 방식 조회 (D: 삭제후 업데이트, M: 같은 항복만 업데이트)
		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectPdfTypeCode",$("#sheetForm").serialize(),false);
		if(result.Result.Code == 1) {
			var map = result.Data[0];
			pdfTypeCd = map.val;
			
		}
		/*
		2024.01.03 : 일괄 업로드 사용 type 에 따른로직 추가
		Type이 'U'이면 일괄업로드를 통해 업로드된 파일명 보여주고, 버튼명이 "반영" 으로 변경되어 
		파일 업로드를 하지않고 바로 반영이 가능하도록 수정 
		*/
		if(bulkRegistYn == "U"){
			var selectBulkPdf = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectBulkPdf",$("#sheetForm").serialize(),false);
			if(selectBulkPdf.Result.Code == 1){
				//$("#registN").show() ;
				if(confirm("일괄등록으로 업로드 된 pdf 자료가 있습니다. 반영 버튼을 눌러 간소화 자료를 반영해주세요.")){
					bulkPdfInfo = selectBulkPdf.Data[0]
					$("#fileInfoMesage").hide() ;
					$("#fileInfoWrap").show() ;
					$("#uploadPassword").hide() ;
					$("#uploadN").hide() ;
					document.getElementById('fileNm').innerText = selectBulkPdf.Data[0].file_name;
					document.getElementById('uploadBtn').innerText = "반영";
				}else{
					document.getElementById('uploadBtn').innerText = "업로드";
				}
				//alert("일괄등록으로 업로드 된 pdf 자료가 있습니다. 반영 버튼을 눌러 간소화 자료를 반영해주세요.")
	
				//document.getElementById('fileNm').innerText = selectBulkPdf.Data[0].file_name;
				//document.getElementById('uploadBtn').innerText = "반영";
			} else{
				document.getElementById('uploadBtn').innerText = "업로드";
			}
		}
	});

	$(function() {
<%
String inputEdit = "0", applEdit = "0";
if( "Y".equals(adminYn) ) {
	inputEdit = "0";
	applEdit = "1";
} else{
	inputEdit = "1";
	applEdit = "0";
}
%>
		//연말정산 pdf 파일 상세 쉬트
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
   			{Header:"No",		Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"처리상태",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"status_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"반영\n제외",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"del_check",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N", Sort:0 },
			{Header:"반영",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"app_check",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N", Sort:0 },
			{Header:"년도",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"순번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"자료구분",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"doc_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업무구분코드",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"form_cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업무구분",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"form_nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"처리결과",		Type:"Text",		Hidden:0,	Wrap:"true",Width:300,	Align:"Center",	ColMerge:1,	SaveName:"error_log",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"자료순번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"내용",		Type:"Text",		Hidden:0,	Wrap:"true",Width:550,	Align:"Left",	ColMerge:1,	SaveName:"contents",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000, MultiLineText: 1, EnterMode: 1 },
			{Header:"반영제외자",	Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"except_gubun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		//연말정산 pdf 파일 쉬트.
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata3.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"년도",			Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"파일타입",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"doc_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일시퀀스",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"doc_seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일패스",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"file_path",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"file_name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등록일시",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"반영",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileapply",		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"파일보기",			Type:"Html",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_link",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"파일삭제",			Type:"Html",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"delfile_link",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetCountPosition(0);

		var formCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getPdfFormCdList") , "전체");
		//처리상태
		sheet2.SetColProperty("status_cd",	{ComboText:"반영|미반영|반영불가|반영제외", ComboCode:"S|N|E|D"} );

		var exceptGubun = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00346"), "");
		//반영제외자
		sheet2.SetColProperty("except_gubun",	{ComboText:"|"+exceptGubun[0], ComboCode:"|"+exceptGubun[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();

		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
//		if(orgAuthPg == "R" && (empStatus == "close_2" || empStatus == "close_3" || empStatus == "close_4")) { //임직원 조회 화면에서 본인마감 or 최종 or 담당자마감일경우
		// 20240419 본인마감일때 담당자도 pdf업로드 불가하도록 수정	
		if((empStatus == "close_2" || empStatus == "close_3" || empStatus == "close_4")) { //임직원 조회 화면에서 본인마감 or 최종 or 담당자마감일경우
			var button = document.getElementById('uploadBtn');
			button.classList.add('disabled');
			$("#btnSave").hide();
			$("#uploadBtn").hide();
			
            sheet2.SetEditable(false) ;
            sheet3.SetEditable(false) ;
		}
		
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) { //관리자페이지 && (최종 or 담당자마감일경우)
			var button = document.getElementById('uploadBtn');
			button.classList.add('disabled');
			$("#btnSave").hide();
			$("#uploadBtn").hide();
			
            sheet2.SetEditable(false) ;
            sheet3.SetEditable(false) ;
		}

		doAction("Search");
		doAction3("Search");
	});

	//연말정산 pdf내용
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchA1").val($("#a1").val());

			var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfFormCdCount", $("#sheetForm").serialize(),false);
			if(data.Result.Message != "") alert(data.Result.Message);

			parent.getYearDefaultInfoObj();

			if(data.Result.Code == 1) {
				var map = data.Data;
				
				$("#btnIns > .spent").text( comma(map.ins_amt) );                  //$("#btnIns > #cntS").text(map.ins_cnt); $("#btnIns > #cntN").text(map.ins_cnt_err);
				if(map.ins_cnt_err > 0) {
					//$("#btnIns > .none > #cntN").text(map.ins_cnt_err);
					//$("#btnIns > #cntN").html(map.ins_cnt_err);
					//document.getElementById("resultS").innerText = detailCount.Data.status_a;
					var checkS = document.querySelector('#btnIns .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnIns .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					// $("#btnIns > #cntS").text(map.ins_cnt); 2023.11.21: 반영건 갯수 안보여주도록 수정
					var checkS = document.querySelector('#btnIns .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnIns .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnMed > .spent").text( comma(map.med_amt) );					//$("#btnMed > #cntS").text(map.med_cnt); $("#btnMed > #cntN").text(map.med_cnt_err);
				if(map.med_cnt_err > 0) {
					//$("#btnMed > .none > #cntN").text(map.med_cnt_err);
					var checkS = document.querySelector('#btnMed .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnMed .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnMed .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnMed .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnEdu > .spent").text( comma(map.edu_amt) );					//$("#btnEdu > #cntS").text(map.edu_cnt); $("#btnEdu > #cntN").text(map.edu_cnt_err);
				if(map.edu_cnt_err > 0) {
					//$("#btnEdu > .none > #cntN").text(map.edu_cnt_err);
					var checkS = document.querySelector('#btnEdu .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnEdu .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnEdu .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnEdu .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnCreditCard > .spent").text( comma(map.credit_card_amt) );	//$("#btnCreditCard > #cntS").text(map.credit_card_cnt); $("#btnCreditCard > #cntN").text(map.credit_card_cnt_err);
				if(map.credit_card_cnt_err > 0) {
					//$("#btnCreditCard > .none > #cntN").text(map.credit_cnt_err);
					var checkS = document.querySelector('#btnCreditCard .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnCreditCard .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnCreditCard .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnCreditCard .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnCheckCard > .spent").text( comma(map.check_card_amt) );		//$("#btnCheckCard > #cntS").text(map.check_card_cnt); $("#btnCheckCard > #cntN").text(map.check_card_cnt_err);
				if(map.check_card_cnt_err > 0) {
					//$("#btnCreditCard > .none > #cntN").text(map.check_cnt_err);
					var checkS = document.querySelector('#btnCheckCard .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnCheckCard .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnCheckCard .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnCheckCard .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnCash > .spent").text( comma(map.cash_amt) );				//$("#btnCash > #cntS").text(map.cash_cnt); $("#btnCash > #cntN").text(map.cash_cnt_err);
				if(map.cash_cnt_err > 0) {
					//$("#btnCash > .none > #cntN").text(map.cash_cnt_err);
					var checkS = document.querySelector('#btnCash .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnCash .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnCash .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnCash .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnPen > .spent").text( comma(map.pen_amt) );					//$("#btnPen > #cntS").text(map.pen_cnt); $("#btnPen > #cntN").text(map.pen_cnt_err);
				if(map.pen_cnt_err > 0) {
					//$("#btnPen > .none > #cntN").text(map.pen_cnt_err);
					var checkS = document.querySelector('#btnPen .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnPen .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnPen .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnPen .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnHou > .spent").text( comma(map.hou_amt) );					//$("#btnHou > #cntS").text(map.hou_cnt); $("#btnHou > #cntN").text(map.hou_cnt_err);
				if(map.hou_cnt_err > 0) {
					//$("#btnPen > .none > #cntN").text(map.hou_cnt_err);
					var checkS = document.querySelector('#btnHou .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnHou .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnHou .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnHou .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnHouSav > .spent").text( comma(map.hou_sav_amt) );			//$("#btnHouSav > #cntS").text(map.hou_sav_cnt); $("#btnHouSav > #cntN").text(map.hou_sav_cnt_err);
				if(map.hou_sav_cnt_err > 0) {
					//$("#btnHouSav > .none > #cntN").text(map.hou_sav_cnt_err);
					var checkS = document.querySelector('#btnHouSav .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnHouSav .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnHouSav .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnHouSav .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnLongSav > .spent").text( comma(parseInt(map.long_sav_amt)+parseInt(map.venture_amt)) );	//$("#btnLongSav > #cntS").text(parseInt(map.long_sav_cnt,10) + parseInt(map.venture_cnt,10)); $("#btnLongSav > #cntN").text(parseInt(map.long_sav_cnt_err,10) + parseInt(map.venture_cnt_err,10));
				if(map.long_sav_cnt_err > 0 || map.venture_cnt_err > 0) {
					//$("#btnLongSav > .none > #cntN").text(parseInt(map.long_sav_cnt_err,10) + parseInt(map.venture_cnt_err,10));
					var checkS = document.querySelector('#btnLongSav .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnLongSav .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnLongSav .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnLongSav .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnEtc > .spent").text( comma(map.etc_amt) );					//$("#btnEtc > #cntS").text(map.etc_cnt); $("#btnEtc > #cntN").text(map.etc_cnt_err);
				if(map.etc_cnt_err > 0) {
					//$("#btnEtc > .none > #cntN").text(map.etc_cnt_err);
					var checkS = document.querySelector('#btnEtc .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnEtc .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnEtc .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnEtc .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				$("#btnDon > .spent").text( comma(map.dong_amt) );					//$("#btnDon > #cntS").text(map.dong_cnt); $("#btnDon > #cntN").text(map.dong_cnt_err);
				if(map.dong_cnt_err > 0) {
					//$("#btnDon > .none > #cntN").text(map.dong_cnt_err);
					var checkS = document.querySelector('#btnDon .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnDon .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnDon .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnDon .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				
				//$("#btnHdcp > #cntS").text(map.hdcp_cnt); $("#btnHdcp > #cntN").text(map.hdcp_cnt_err);
				/*
				if(map.hdcp_cnt_err > 0) {
					$("#btnHdcp > .none > #cntN").text(map.hdcp_cnt_err);
					var checkS = document.querySelector('#btnHdcp .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnHdcp .fa-exclamation.circle.bg-red');
					checkS.style.display = 'none';
					checkN.style.display = 'block';
				} else{
					var checkS = document.querySelector('#btnHdcp .fa-check.circle.bg-blue');
					var checkN = document.querySelector('#btnHdcp .fa-exclamation.circle.bg-red');
					checkS.style.display = 'block';
					checkN.style.display = 'none';
				}
				*/
			}

			break;
		}
	}

	//pdf파일 List
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			sheet3.DoSearch( "<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfList", $("#sheetForm").serialize() );
			break;
		case "Reload":
			location.href = location.href;
		case "Down2Excel":
			var downcol = "0|1|8|9";
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet3.Down2Excel(param);
			break;
		}
	}

 	//연말정산 pdf파일 상세
	function doAction2(sAction, formCd) {
		switch (sAction) {
		case "Search":
		    //doAction("Search");
			$("#searchFormCd0, #searchFormCd1, #searchFormCd2, #searchFormCd3, #searchFormCd4, #searchFormCd5, #searchFormCd6, #searchFormCd7, #searchFormCd8, #searchFormCd9").val("");
			
			if ( formCd != undefined) {
				$("#formCd").val(formCd);	
			}

			if(formCd == ''){
				chkAll = true;
			} else{
				chkAll = false;
			}
			var arrFormCd = $("#formCd").val().split(",");
			for(var i=0; i<arrFormCd.length; i++) {
				$("#searchFormCd"+ i).val(arrFormCd[i]);
			}

			$("#searchStatusCd").val($("#statusCd").val());
			$("#searchContents").val($("#contents").val());
			$("#searchA1").val($("#a1").val());

			sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfDetailList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!parent.checkClose())return;

			$("#searchFormCd0, #searchFormCd1, #searchFormCd2, #searchFormCd3, #searchFormCd4, #searchFormCd5, #searchFormCd6, #searchFormCd7, #searchFormCd8, #searchFormCd9").val("");

			if ( formCd != undefined && formCd != "" ) {
				$("#formCd").val(formCd);
			}
			var arrFormCd = $("#formCd").val().split(",");
			for(var i=0; i<arrFormCd.length; i++) {
				$("#searchFormCd"+ i).val(arrFormCd[i]);
			}

			sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=saveYeaDataPdf&orgAuthPg="+orgAuthPg, $("#sheetForm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
		} catch (ex) {
			alert("OnSearchEnd1 Event Error : " + ex);
		}
	}

	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			/*
			https://myyac.tistory.com/133 사이트 하단 컬러코드 참조 by JSG 20191125
			*/
			if (Code == 1) {
				for(var i = 1; i < sheet2.RowCount()+1; i++) {
					var fomCd = sheet2.GetCellValue(i, "form_cd");

					if(fomCd != '0000'){
						var statusCd = sheet2.GetCellValue(i, "status_cd");
						if(statusCd == "S") {
							sheet2.SetCellEditable(i, "app_check", 0) ;
						} else if(statusCd == "N" || statusCd == "D" || statusCd == "E") {
							sheet2.SetCellEditable(i, "del_check", 0) ;

							if(statusCd == "E") {
								//sheet2.SetRowBackColor(i, "#c0d1d3") ;
								//sheet2.SetCellBackColor(i, "app_check", "#b5e5ea") ;
								// 반영 불가인 건은 반영 못하도록 처리
								sheet2.SetCellEditable(i, "app_check", 0) ;
							}
						}
					}
					else {
						sheet2.SetCellEditable(i, "app_check", 0) ;
						sheet2.SetCellEditable(i, "del_check", 0) ;
					}

					//2019-11-08. 반영 미반영 라인 컬러링
					if(statusCd == "S") {
						sheet2.SetCellBackColor(i, "status_cd", "#adf2f7") ; //PigPink
					} else if(statusCd == "E") { //반영불가
						sheet2.SetCellBackColor(i,"status_cd", "#f2f0bd") ; //Blush
						//sheet2.SetCellBackColor(i, "app_check", "#b5e5ea") ;
					} else if(statusCd == "D") { //반영제외
						sheet2.SetCellBackColor(i,"status_cd", "#c7c3c4") ;//Carnation Pink
					} else { //미반영
						sheet2.SetCellBackColor(i,"status_cd", "#fad4e0") ;//Tickle Me Pink
					}


				}

				goDetailCount(); // 건수 조회
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd2 Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			parent.getYearDefaultInfoObj();
			if(Code == 1) {
				doAction("Search");
				doAction2("Search");
				doAction3("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	var pGubun = "";

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "pdfUploadPop" ){
			if( (rv != null) && (rv[0] == "Y") ) {

				var a1CdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfA1&"+ $("#sheetForm").serialize(), ""), "전체");
				$("#a1").html(a1CdList[2]);

				doAction("Search");
				parent.getYearDefaultInfoObj();
			}
		} else if ( pGubun == "pdfViewerPop") {
			if( (rv != null) && (rv[0] == "Y") ) {

                var a1CdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfA1&"+ $("#sheetForm").serialize(), ""), "전체");
                $("#a1").html(a1CdList[2]);

                doAction("Search");
                parent.getYearDefaultInfoObj();
            }
		}
	}

	function sheetChangeCheck() {
		var iTemp = sheet2.RowCount("I") + sheet2.RowCount("U") + sheet2.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}

	function comma(str) {
		if ( str == "" ) return 0;

		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	// 업로드 버튼 전, 인적공제, 기본_주소사항 확정여부 체크
	function chkConfirmed(){
		var params = "workYy="+ $("#searchWorkYy").val() + "&adjustType="+$("#searchAdjustType").val() + "&searchSabun=" + $("#searchSabun").val();;
		var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectConfirmedYn",params,false);
		if(rtnResult.Result.Code == "1"){
			var confirmedYn = rtnResult.Data[0].confirmed_yn;
			if(confirmedYn == "Y"){ 
				return true;
			} else{
				return false;
			}
			
        }
		return false;
	}

	function goAction(){
		if($('.btn-upload').hasClass('disabled')){
			return;
		}
		
		var chk = chkConfirmed();
		if(!chk) { 
			alert("주소사항과 인적공제 탭에서 확정을 하신 후 다시 시도해주세요.");
			return;
		}
		if(document.getElementById('uploadBtn').innerText == '반영'){
			// 2024.01.03 반영 로직 추가(일괄 업로드로 제공된 pdf 파일이 있을 경우)
			var form = document.createElement("form");
			form.id = "newForm";
			try{
				var input1 = document.createElement("input");
				input1.type = "text";
				input1.name = "paramSabun";
				input1.value = $("#searchSabun").val();
				
				var input2 = document.createElement("input");
				input2.type = "text";
				input2.name = "paramAdjustType";
				input2.value = $("#searchAdjustType").val();
				
				var input3 = document.createElement("input");
				input3.type = "text";
				input3.name = "paramYear";
				input3.value = $("#searchWorkYy").val();
				
				var input4 = document.createElement("input");
				input4.type = "text";
				input4.name = "filePath";
				input4.value = bulkPdfInfo.file_path;
				
				var input5 = document.createElement("input");
				input5.type = "text";
				input5.name = "fileName";
				input5.value = bulkPdfInfo.file_name;
				
				var input6 = document.createElement("input");
				input6.type = "text";
				input6.name = "fileUploadType";
				input6.value = $("#fileUploadType").val();
				
				var input7 = document.createElement("input");
				input6.type = "text";
				input6.name = "zipDocSeq";
				input6.value = bulkPdfInfo.zip_doc_seq;

				form.appendChild(input1);
				form.appendChild(input2);
				form.appendChild(input3);
				form.appendChild(input4);
				form.appendChild(input5);
				form.appendChild(input6);
				form.appendChild(input7);
				document.body.appendChild(form);
                $("#progressCover").show();
			} catch(e){

			}finally{
				$("#newForm").hide();
				// form submit
				if(vsSsnEnterCd == "KYBS"){
					//복호화 업로드
					$("#newForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRstKYBS.jsp"}).submit();

				}else if(vsSsnEnterCd == "KOH"){
					//복호화 업로드
					$("#newForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRstKOH.jsp"}).submit();

				/*}else if(vsSsnEnterCd == "MSEAT"){
		            //복호화 업로드
		            $("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRstMSEAT.jsp"}).submit();
		            */
					
				}
				else{
					$("#newForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRst.jsp"}).submit();
				}	
			}
			
		}else{
			if($("#basic").val() == "") {
				alert("소득공제 업로드 파일을 선택해주세요.");
				return;
			}
			
			if(pdfTypeCd == 'D') {
				if(!confirm("업로드 시 이전 자료는 모두 삭제 처리 됩니다. 최종 파일이 맞습니까?")) {	
					return false;
				}
			} else if(pdfTypeCd == 'M') {
				if(!confirm("업로드 시 파일 내에 포함된 대상자의 기존 자료 전체는 삭제 후 새로 적용되며(수기 입력 데이터 제외), 그 외 대상자의 자료는 보존됩니다. 업로드 하시겠습니까?")) {	
					return false;
				}
			}
			
			var vsSearchSabun      = $("#searchSabun").val();
			var vsSearchAdjustType = $("#searchAdjustType").val();

			$("#paramSabun").val(vsSearchSabun);
			$("#paramAdjustType").val(vsSearchAdjustType);

			$("#progressCover").show();
			$("#buttonPlus").show();
			$("#buttonMinus").hide();

			if(vsSsnEnterCd == "KYBS"){
				//복호화 업로드
				$("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRstKYBS.jsp"}).submit();

			}else if(vsSsnEnterCd == "KOH"){
				//복호화 업로드
				$("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRstKOH.jsp"}).submit();

			/*}else if(vsSsnEnterCd == "MSEAT"){
	            //복호화 업로드
	            $("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRstMSEAT.jsp"}).submit();
	            */
				
			}
			else{
				var form = document.getElementById('uploadForm');
				/*
			    // FormData 객체를 생성하여 폼 데이터를 가져옵니다.
			    var fD = new FormData(form);
			    
			    if(chk){
			    	formData.forEach(function(value, key) {
			    		console.log(key, value);
						fD.append('file', value);
					});
			    };
			      
			    for (var pair of formData.entries()) {
			      if(pair[0] == 'file'){
			      	fD.set('file', pair[1])
			      }
			    }
			   // FormData 객체의 값을 콘솔에 출력합니다.
			    for (var pair of fD.entries()) {
			      if (pair[1] instanceof File) {
			        console.log('File Name: ' + pair[1].name);
			      } else {
			   	    console.log('FormData Pair (' + pair[0] + ': ' + pair[1] + ')');
			   	  }
			    }
	*/			
			   if($("#fileUploadType").val() == "1"){
				   $("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRstS3.jsp"}).submit();
	           } else{
	        	   $("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRst.jsp"}).submit();
	           }
				//$("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRst.jsp"}).submit();
			}
		}		
		
		parent.getYearDefaultInfoObj();
		goDetailCount(); // 건수 조회


	}

	function procYn(err,message){
		$("#progressCover").hide();

		if(err=="Y"){
			alert(message);
		} else {
			$("#optionM").hide();
    		$("#optionD").hide();
    		$("#xrefErrorInfo").show();
			alert(message);
		}
	}

	/* pdf등록 버튼 기능 */
    $(document).ready(function(){
    	if(isIE){
    		$("#fileInfoText").text('');
    	}
    	
    	if(pdfTypeCd == 'D') {
    		$("#optionM").hide();
    		$("#optionD").show();
    	} else if(pdfTypeCd == 'M') {
    		$("#optionD").hide();
    		$("#optionM").show();
    	}
    	//pdf등록+ 버튼 숨기기
		$("#infoLayer").hide();
		$("#buttonInfoMinus").hide();

    	//pdf등록 안내+ 버튼 선택시 pdf등록안내- 버튼 호출
    	$("#buttonInfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "buttonInfoPlus"){
	    			$("#buttonInfoMinus").show();
	    			$("#buttonInfoPlus").hide();
	    		}
    	});

    	//pdf등록안내- 버튼 선택시 pdf등록안내+ 버튼 호출
    	$("#buttonInfoMinus").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "buttonInfoMinus"){
	    			$("#buttonInfoPlus").show();
	    			$("#buttonInfoMinus").hide();
	    		}
		});

    	//pdf등록안내+ 선택시 화면 호출
    	$("#buttonInfoPlus").click(function(){
            $("#infoLayer").show("fast");
        });

    	//pdf등록안내- 선택시 화면 숨김
    	$("#buttonInfoMinus").click(function(){
	            $("#infoLayer").hide("fast");
        });
    	
    	doAction2("Search", "");
    });

	//PDF등록 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#buttonInfoMinus").hide();
    		$("#buttonInfoPlus").show();
    	}
    });

  	//조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();

			for(var i = 1; i < sheet3.RowCount()+1; i++) {
				var filePath = sheet3.GetCellValue(i,"file_path")+'/'+sheet3.GetCellValue(i,"file_name");
				var file_name = sheet3.GetCellValue(i,"file_name");
				if($("#fileUploadType").val() == "1"){
					sheet3.SetCellValue(i,"file_link","<a href=\"javascript:fileDownFromS3('"+file_name+"')\" class='basic btn-download'>다운</a>");
					if(sheet3.GetCellValue(i, "fileapply") == "N") {
						sheet3.SetCellValue(i,"delfile_link","<a href=\"javascript:deletePdf('"+i+"', '"+filePath+"')\" class='basic btn-white'>삭제</a>");
					} else {
						sheet3.SetCellValue(i,"delfile_link","&nbsp;");
					}
				}else{
				/*******************FilePath설정******************************************************************************/
				<%
					String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");
				    String wfsUploadPath = StringUtil.getPropertiesValue("WAS.PATH");
					if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
				%>
					var type = "1";
					var filePath = "<%=nfsUploadPath%>"+sheet3.GetCellValue(i,"file_path")+"/"+sheet3.GetCellValue(i,"file_name");
				<%
						} else {
				%>
					var type = "";
					var filePath = "<%=wfsUploadPath%>"+sheet3.GetCellValue(i,"file_path")+"/"+sheet3.GetCellValue(i,"file_name");
				<%
						}
				%>
				/*******************FilePath설정******************************************************************************/
					sheet3.SetCellValue(i,"file_link","<a href=\"javascript:openPrint('"+filePath+"')\" class='basic btn-white out-line ico-popup'>보기</a>");
					if(sheet3.GetCellValue(i, "fileapply") == "N") {
						sheet3.SetCellValue(i,"delfile_link","<a href=\"javascript:deletePdf('"+i+"', '"+filePath+"')\" class='basic btn-white'>삭제</a>");
					} else {
						sheet3.SetCellValue(i,"delfile_link","&nbsp;");
					}
				}
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

  	/* 2021.12.01. 주석처리. 이 로직의 의미를 모르겠음.
  	//PDF 파일 보기 버튼 변경
	function sheet3_OnClick(Row, Col, Value){
		var confirm = "<a href=\"#\" class='basic btn-white out-line ico-popup'>보기</a>";

	   	if( sheet3.ColSaveName(Col) == "file_link" ) {
   			//if(Value == nConfirm ){
	   			sheet3.SetCellValue(Row,"file_link",confirm);
	   		//}
	   	}
	}*/
	
	function fileDownFromS3(fileNm){
		var params = "";
		params += "fileName="      + fileNm;
		params += "&paramYear="     + $("#searchWorkYy").val();

		var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRstS3.jsp?cmd=downFile",params,false);

		if(rtnResult.Result.Code == "1"){
			doAction3("Search");
		}

	}

  	//PDF출력
	function openPrint(filePath){
  		doAction3("Search");

		var args = [];
		args["filePath"] = filePath;
		openPopup("<%=jspPath%>/common/pdfViewPop.jsp?authPg=<%=authPg%>", args, "1024","768");
	}

	//pdf 업로드 파일 삭제
	function deletePdf(row, filePath){
		if(!parent.checkClose())return;

		if(sheet3.GetCellValue(row, "fileapply") == "Y"){
			alert("반영 데이터가 존재하여 삭제 할 수 없습니다.");
			return;
		}

		var params = "";
		params += "&fileUrl="      + filePath;
		params += "&doc_type="     + sheet3.GetCellValue(row, "doc_type");
		params += "&doc_seq="      + sheet3.GetCellValue(row, "doc_seq");
		params += "&searchWorkYy=" + $("#searchWorkYy").val();
		params += "&searchAdjustType=" + $("#searchAdjustType").val();
		params += "&searchSabun="  + $("#searchSabun").val();
		params += "&fileUploadType=" + $("#fileUploadType").val();

		if($("#fileUploadType").val() == "1"){
			var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRstS3.jsp?cmd=deleteFile",params,false);
           } else{
        	   var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=deleteFile",params,false);
           }

		if(rtnResult.Result.Code == "1"){
			flag = "1"
			doAction3("Search");
		}
	}


	function goDetailCount() {
		// 건수 조회
		var detailCount = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfDetailCount",$("#sheetForm").serialize(),false);
		if(detailCount.Message != null && detailCount.Message.length > 0) {
			alert(detailCount.Message);
			return;
		}

		if(detailCount.Data != null && detailCount.Data != "undefine") {
			//document.getElementById("resultS").innerText = detailCount.Data.status_a;
			//document.getElementById("resultN").innerText = detailCount.Data.status_b;
			/* '전체' 카드 삭제 후 주석처리
			if(chkAll){
				if(detailCount.Data.status_b > 0) {
					$("#btnAll > .none > #cntN").text(detailCount.Data.status_b);
						var checkS = document.querySelector('#btnAll .fa-check.circle.bg-blue');
						var checkN = document.querySelector('#btnAll .fa-exclamation.circle.bg-red');
						checkS.style.display = 'none';
						checkN.style.display = 'block';
					} else{
						var checkS = document.querySelector('#btnAll .fa-check.circle.bg-blue');
						var checkN = document.querySelector('#btnAll .fa-exclamation.circle.bg-red');
						checkS.style.display = 'block';
						checkN.style.display = 'none';
					}
			}
			*/

			document.getElementById("statusS").innerText = detailCount.Data.status_a == '' ? 0 : detailCount.Data.status_a;
			document.getElementById("statusN").innerText = detailCount.Data.status_b == '' ? 0 : detailCount.Data.status_b;
			document.getElementById("statusE").innerText = detailCount.Data.status_c == '' ? 0 : detailCount.Data.status_c;
			document.getElementById("statusD").innerText = detailCount.Data.status_d == '' ? 0 : detailCount.Data.status_d;
		}
	}
	
	function uploadHandler() {
		
		var fileInput = document.getElementById('basic');
		
		// 선택된 파일이 있는지 확인
        if (fileInput != null && fileInput.files != null && fileInput.files.length > 0) {
            // 첫 번째 선택된 파일의 파일명 출력
            var file = fileInput.files[0];
            var ext = file.name.split('.').pop().toLowerCase();
    		if($.inArray(ext, ['pdf']) == -1) {
    			alert('pdf 파일만 업로드 할수 있습니다.');
    			return;
    		}
    		handleFileUpload(file.name,true);
        } else {
        	alert('파일이 선택되지 않았습니다.');
        }
	}
	
	function dropHandler(event) {
        event.preventDefault();
        if(isIE){
        	var dropZone = document.getElementById('basic_drop_zone');
    		alert("Internet Explorer에서는 파일선택을 통해서만 업로드가 가능합니다.");
    		dropZone.classList.remove('highlight');
    		return;
    	}
        // 드롭된 파일 가져오기
        var files = event.dataTransfer.files;
        
        // 업로드 로직 수행
        handleFileUpload(files,false);
        $("#basic").prop('files',files);
        // 드롭된 파일 추가        
		if (files != null) {
			for (var i = 0; i < files.length; i++) {
			  formData.append('file', files[i]);
			}
		}
    }
	
	function beforeSubmit(event) {
		  event.preventDefault();  // 기본 동작 취소

		  // FormData 객체 생성
		  var formData = new FormData(document.getElementById('uploadForm'));

		  // 추가로 파일을 직접 추가하거나 수정
		  var additionalFile = document.getElementById('additionalFileInput').files[0];
		  formData.append('additionalFile', additionalFile);

		  return false;  // 제출 방지
		}
	
	function handleFileUpload(files,chk) {
		if(chk){
			$("#fileInfoWrap").show() ;
			$("#fileInfoMesage").hide() ;
			document.getElementById('fileNm').innerText = files;
		} else{
			var ext = ""; //파일 확장자
			errorCnt = 0; //초기화
			
			fileCnt = (files == null) ? 0 : files.length;
			
			for (var i = 0; i < fileCnt; i++) {
				var file = files[i];
				
				ext = file.name.split('.').pop().toLowerCase();
				if($.inArray(ext, ['pdf']) == -1) {
					alert('pdf 파일만 업로드 할수 있습니다.');
					return;
				}
				$("#fileInfoWrap").show() ;
				$("#fileInfoMesage").hide() ;
				document.getElementById('fileNm').innerText = file.name;
			}		
		}	
    }
	
	function enterDropZone(event) {
		event.preventDefault();
		counter++;
		var dropZone = document.getElementById('basic_drop_zone');
		dropZone.classList.add('highlight');
	}
	
	function leaveDropZone() {
		counter--;
		var dropZone = document.getElementById('basic_drop_zone');
        if (counter === 0) { 
          dropZone.classList.remove('highlight');
        }
	}
	
	// 클래스 변경 함수
    function changeClass(element) {
    	// 모든 엘리먼트의 클래스 변경
        var allElements = document.getElementsByClassName("upload-card");
        for (var i = 0; i < allElements.length; i++) {
            allElements[i].className = "upload-card item";
        }

        var currentClass = element.className;
        var newClass = currentClass.includes("item") ? "upload-card total" : "upload-card item";
        element.className = newClass;
    }
	
	function changeFullSize() {
		var allBoxes = document.querySelectorAll('.hidebox');
		var gridArea = document.getElementById("gridArea");
		if(!chkFull){
			for(var i=0; i< allBoxes.length; i++){
				allBoxes[i].classList.add('hide-box');
			}
			/*
	    	allBoxes.forEach(function(box) {
	   	        box.classList.remove('hide-box');
	   	    });
			*/
	    	$("#btnChangeSize").text('시트 작게보기');
	    	gridArea.className = 'wid-100 divider';
	    	sheetResize();
	    	chkFull = true;
		} else {
			for(var i=0; i< allBoxes.length; i++){
				allBoxes[i].classList.remove('hide-box');
			}
			/*
	    	allBoxes.forEach(function(box) {
	   	        box.classList.remove('hide-box');
	   	    });
			*/
	    	gridArea.className = 'wid-73 divider';
	    	$("#btnChangeSize").text('시트 크게보기');
	    	sheetResize();
	    	chkFull = false;;
		}
	}
	
	function chkMagam(e) {
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		
		if(orgAuthPg == "R" && empStatus == "close_2") { //본인마감
			e.preventDefault();
			var button = document.getElementById('uploadBtn');
			alert("마감된 상태에서 파일업로드가 불가능합니다.");
			return;
		}
		
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) { //관리자페이지 && (최종 or 담당자마감일경우)
			e.preventDefault();
			var button = document.getElementById('uploadBtn');
			alert("마감된 상태에서 파일업로드가 불가능합니다.");
			return;
		}

	}

</script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;z-index:100;"></div>
  <div class="wrapper wid-outer">
    <div class="wid-27 hidebox">
      <div class="inner-padding">
        <!-- title-wrap -->
        <div class="sheet_title">
          <ul>
              <li class="txt">연말정산 PDF 파일 업로드</li>
              <li class="btn">
                <a href="#layerPopup" class="basic btn-white out-line ico-question" id="buttonInfoPlus">PDF 등록안내+</a>
                <a href="#layerPopup" class="basic btn-white out-line ico-question" id="buttonInfoMinus" style="display:none"><b>PDF 등록안내-</b></a>
              </li>
          </ul>
        </div>
        <div class="page-guide" id="optionD" style="display:none">
          <i class="fa fa-info circle bg-red"></i> 새로운 PDF파일을 업로드 하면 기존 업로드 정보 모두 삭제됩니다.</br>
        </div>
        <div class="page-guide" id="optionM" style="display:none">
          <i class="fa fa-info circle bg-red"></i> 새로운 PDF파일 업로드시 파일 내에 포함된 대상자의 기존 자료 전체를 삭제 후 새로 적용되며(수기 입력 데이터 제외), 그 외 대상자의 자료는 보존됩니다.</br>
          <!--<i class="fa fa-info circle bg-red"></i> XREF 정보검색 오류, ByteRange 오류 발생시 국세청 PDF 원본 파일로 다운받아 재업로드 해주시기 바랍니다.-->
        </div>
        <div class="page-guide" id="xrefErrorInfo" style="display:none">
          <i class="fa fa-info circle bg-red"></i> XREF 정보검색 오류, ByteRange 오류 발생시 국세청 PDF 원본 파일로 다운받아 재업로드 해주시기 바랍니다.
        </div>
        <!-- file input -->
        <form id="uploadForm" method="post"  enctype="multipart/form-data">
        <input type="hidden" id="fileUploadType" name="fileUploadType" />
        <input type="hidden" id="paramYear" name="paramYear" value="2024"/>
		<input type="hidden" id="paramSabun" name="paramSabun" value="<%=removeXSS(session.getAttribute("ssnSabun"), '1')%>"/>
		<input type="hidden" id="paramAdjustType" name="paramAdjustType" value="1"/>
        <div class="file-upload">
          <input type="file" name="file" id="basic" class="simple-upload" onchange="uploadHandler()" onclick="chkMagam(event)">
          <div id="basic_drop_zone" class="dropZone simple-upload simple-upload-droppable" ondrop="dropHandler(event)" ondragover="event.preventDefault()" ondragenter="enterDropZone(event)" ondragleave="leaveDropZone(event)">
            <div class="inner-wrap">
              <div class="img-wrap">
                <img src="../../../common_jungsan/images/common/file-pdf-box_2x.png" alt="">
              </div>
              <div class="info-wrap">
                <a class="basic btn-white out-line btn-fileSelect" href="javascript:void(0);" onclick="document.getElementById('basic').click();">파일선택</a>
                <p class="info" id="fileInfoText">또는 간소화 PDF 파일 끌어놓기</p>
              </div>
            </div>
          </div>
          <div id="basic_progress" class="simple-upload"></div>
          <div id="basic_message">
            <p class="desc text-center" id="fileInfoMesage">선택한 파일 정보가 표시됩니다.</p>
            <div class="file-info-wrap" id="fileInfoWrap" style="display:none">
              <div class="file-info">
                <span>
                  <img src="../../../common_jungsan/images/common/file-pdf_2x.png" alt=""><span class="file-name" id="fileNm"></span>
                </span>
                <span class="status" id="uploadN" style="display:none">업로드 안됨</span>
                <span class="status" id="registN" style="display:none">반영 안됨</span>
                <span class="status upload" id="uploadS" style="display:none">업로드 됨</span>
              </div>
              <div class="password-wrap" id="uploadPassword">
                <span class="label">PDF에 암호가 있나요?</span>
                <input type="password" id="paramPwd" name="paramPwd" class="password" placeholder="비밀번호 입력">
              </div>
            </div>
          </div>
          <div class="btn-wrap text-center">
            <a href="javascript:goAction();" class="btn-upload" id="uploadBtn">업로드</a>
          </div>
        </div>
        </form>
        
        <div class="outer new" id="infoLayer" style="display:none">
    <p class="layer-title">PDF 등록 안내</p>
    <div class="layer-contents">
        <ol class="info-list">
            <li>국세청 연말정산 간소화 서비스 사이트에서 연말정산할 항목을 선택 후, 아래 이미지를 따라 <br><strong class="point-blue">[한번에 내려받기]</strong> 버튼으로 PDF를 다운로드 하세요.
                <div class="img-wrap">
                    <img src="../../../common_jungsan/images/common/pdf_popup_2023.jpg" border="0" style="vertical-align:middle;width:100%;height:100%">
                </div>
            </li>
            <li><strong>[파일선택]</strong> 또는 <strong>드래그 앤 드랍</strong>으로 파일을 불러오세요.</li>
            <li>불러온 파일을 확인하고, 국세청에서 다운받을 때 <strong>비밀번호를 설정</strong>했을 경우 <strong class="point-blue">비밀번호를 입력</strong> 하세요.</li>
            <li><strong class="point-blue">[업로드]</strong> 버튼을 클릭해 <strong>PDF 파일을 적용</strong> 합니다.
                <!-- <ul class="dot-list">
                    <li>PDF파일 한 번 업로드 시 각 인적공제 인원별 최종 자료만 업로드 됩니다. (각 인원단위 삭제 후 덮어쓰기 개념)
                        <ul class="none-list">
                            <li><strong>예시 1 )</strong> 본인+배우자 업로드 후 본인의 PDF자료만 재 업로드 시 본인의 데이터만 삭제후 업로드 됩니다.</li>
                            <li><strong>예시 2 )</strong> 본인의 모든 자료(보험료/신용카드 등) 업로드 후 보험료 PDF만 다시 받아 재 업로드 시<br>
                                모든 본인 자료 삭제 후 보험료 데이터만 업로드 됩니다.</li>
                        </ul>
                    </li>
                </ul> -->
            </li>
                        
            <li>2024년 귀속 연말정산부터 국세청에서 확인 가능한 상반기 소득 정보를 토대로 <br>
                <strong class="point-blue">연간 소득기준을 초과한 부양가족</strong>의 간소화자료는 포함되지 않습니다. <br>
                (자세한 사항은 국세청에 문의하시기 바랍니다.)
                <ul class="dot-list">
                    <li><strong>부양가족이 근로자인 경우</strong> : 총급여 500만원 초과</li>
                    <li><strong>부양가족이 근로자가 아닌 경우</strong> : 연간 소득금액 100만원 초과</li>
                    <li><strong>예외</strong> : 의료비나 장애인 특수교육비는 무관하게 자료 제공</li>
                </ul>
            </li>
        </ol>
        <div class="layer-footer">
            <!-- <input type="checkbox" id="closeToday" name="" value="" class="checkbox" disabled=""><label for="closeToday">다시 보지 않기</label> -->
            <!-- <a href="" class="basic btn-white out-line">닫기</a> -->
        </div>
    </div>
</div>
        
        <div class="collapse" id="uploadHistList">
          <div class="collapse-item">
            <div class="collapse-title">PDF 업로드 이력</div>
            <div class="collapse">
              <span class="page-guide bg-none"><i class="fa fa-info circle bg-red"></i> 인원별 최종 PDF는 삭제할 수 없습니다.</span>
              <!-- sheet -->
              <div class="sheet-wrap" id="ibsheet3"><script type="text/javascript">createIBSheet("sheet3", "100%", "300px"); </script></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div id="gridArea" class="wid-73 divider">
      <form id="sheetForm" method="post"  enctype="multipart/form-data">
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="" />
		<input type="hidden" id="searchContents" name="searchContents" value="" />
		<input type="hidden" id="searchA1" name="searchA1" value="" />
		<input type="hidden" id="searchAuthPg" name="searchAuthPg" value="" />
		<input type="hidden" id="searchTemp" name="searchTemp" value="" />
		<input type="hidden" id="searchFormCd0" name="searchFormCd0" value="" />
		<input type="hidden" id="searchFormCd1" name="searchFormCd1" value="" />
		<input type="hidden" id="searchFormCd2" name="searchFormCd2" value="" />
		<input type="hidden" id="searchFormCd3" name="searchFormCd3" value="" />
		<input type="hidden" id="searchFormCd4" name="searchFormCd4" value="" />
		<input type="hidden" id="searchFormCd5" name="searchFormCd5" value="" />
		<input type="hidden" id="searchFormCd6" name="searchFormCd6" value="" />
		<input type="hidden" id="searchFormCd7" name="searchFormCd7" value="" />
		<input type="hidden" id="searchFormCd8" name="searchFormCd8" value="" />
		<input type="hidden" id="searchFormCd9" name="searchFormCd9" value="" />
		<input type="hidden" id="menuNm" name="menuNm" value="" />
      <div class="inner-padding">
        <!-- <p class="desc">연말정산 간소화 자료를 반영해 예상 결과를 확인하세요.</p> -->
        <!-- 연말정산 결과 -->
        <div class="upload-result hidebox">
          <!-- title-wrap -->
          <div class="sheet_title">
            <ul>
                <li class="txt">연말정산 결과</li>
            </ul>
          </div>
          <!-- 결과 카드 리스트 -->
          <div class="upload-card-list">
          <!-- 
             <a href="javascript:doAction2('Search', '');">
            <div class="upload-card total" style="margin-top: 0px;" onclick="changeClass(this)">
              <span class="card-label">전체</span>
              <div class="card-cnt" id="btnAll">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt" id="cntS"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt" id="cntN"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
             -->
            <!-- 반복문 단위 -->
            <a href="javascript:doAction2('Search', 'A102Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">보험료</span>
              <div class="card-cnt" id="btnIns">
                <span class="none">
	              <i class="fa fa-check circle bg-blue" style="display:none"></i>
	              <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'B101Y,B201Y');" >
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">의료비</span>
              <div class="card-cnt" id="btnMed">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'C102Y,C202Y,C301Y,C401Y,C501Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">교육비</span>
              <div class="card-cnt" id="btnEdu">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'G112Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">신용카드</span>
              <div class="card-cnt" id="btnCreditCard">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'G312Y,G412Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">직불카드 등</span>
              <div class="card-cnt" id="btnCheckCard">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'G212M');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">현금영수증</span>
              <div class="card-cnt" id="btnCash">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'D101Y,E103Y,E101Y,F103Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">개인연금저축/연금계좌</span>
              <div class="card-cnt" id="btnPen">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
			<a href="javascript:doAction2('Search', 'J101Y,J203Y,J401Y,J501Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">주택자금/월세액</span>
              <div class="card-cnt" id="btnHou">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'J301Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">주택마련저축</span>
              <div class="card-cnt" id="btnHouSav">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'N102Y,Q101Y,Q201Y,Q301Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">장기집합투자/벤처기업투자</span>
              <div class="card-cnt" id="btnLongSav">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'K101M');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">소기업/소상공인 공제부금</span>
              <div class="card-cnt" id="btnEtc">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <a href="javascript:doAction2('Search', 'L102Y');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">기부금</span>
              <div class="card-cnt" id="btnDon">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent"></span>
              </div>
            </div>
            </a>
            <!-- 
            <a href="javascript:doAction2('Search', 'R101M');">
            <div class="upload-card item" onclick="changeClass(this)">
              <span class="card-label">장애인 증명서</span>
              <div class="card-cnt" id="btnHdcp">
                <span class="none">
                  <i class="fa fa-check circle bg-blue" style="display:none"></i>
                  <span class="cnt"></span>
                  <i class="fa fa-exclamation circle bg-red" style="display:none"></i>
                  <span class="cnt"></span>
                </span>
                <span class="spent" style="display:block"></span>
              </div>
            </div>
            </a>
             -->
          </div>
        </div>
        <!-- 연말정산 상세 내역  -->
        <div class="upload-desc divider">
          <div class="upload-desc-filter">
            <div class="inner-wrap">
              <span class="label">구분:</span>
              <span class="input-wrap" style="width: 200px;">
                <select id="formCd">
                  <option value="" selected>전체</option>
					<!-- <option value="0000">인적공제</option> --><!-- 2019-11-08. 인적공제 비활성화 처리 -->
					<option value="A102Y">보험료</option>
					<option value="B101Y,B201Y">의료비</option>
					<option value="C102Y,C202Y,C301Y,C401Y,C501Y">교육비</option>
					<option value="G112Y">신용카드</option>
					<option value="G312Y,G412Y">직불카드 등</option>
					<option value="G212M">현금영수증</option>
					<%-- <option value="G407Y">제로페이</option><!-- 2019-12-09. 제로페이 추가 --> <!-- 2020-12-02. 제로페이는 직불카드에 포함 --> --%>

					<option value="D101Y,E103Y,E101Y,F103Y">개인연금저축/연금계좌</option>
					<option value="J101Y,J203Y,J401Y,J501Y">주택자금/월세액</option>
					<option value="J301Y">주택마련저축</option>
					<option value="N102Y,Q101Y,Q201Y,Q301Y">장기집합투자증권저축/벤처기업투자신탁</option><!-- 2019-11-28. 벤처기업투자신탁 추가 -->
					<option value="K101M">소기업/소상공인 공제부금</option>
					<option value="L102Y">기부금</option>
					<option value="R101M">장애인 증명서</option>
					<option value="T101M">소득기준 초과 부양가족</option>
                </select>
              </span>
            </div>
            <div class="inner-wrap">
              <span class="label">상태:</span>
              <span class="input-wrap">
                <select id="statusCd">
                  <option value="">전체</option>
					<option value="S">반영</option>
					<option value="N">미반영</option>
					<option value="E">반영불가</option>
					<option value="D">반영제외</option>
                </select>
              </span>
            </div>
            <div class="inner-wrap">
              <span class="label">내용:</span>
              <span class="input-wrap">
                <input type="text" id="contents" class="text" placeholder="내용">
              </span>
            </div>
            <div class="inner-wrap">
              <span class="label">인적 공제인원</span>
              <span class="input-wrap">
                <select id="a1" name="a1">
                  <option value="">전체</option>
                </select>
              </span>
            </div>
            <div class="btn-wrap divider">
              <a href="javascript:doAction('Search'); doAction2('Search');" class="basic btn-white out-line">조회</a>
            </div>
          </div>
          <div>
            <div class="upload-desc-status">
              <ul class="status-list divider">
                <li>
                  <i class="fa fa-check circle bg-blue"></i>
                  <span class="label">반영</span>
                  <span class="cnt" id="statusS"></span>
                </li>
                <li>
                  <i class="fa fa-exclamation circle bg-red"></i>
                  <span class="label">미반영</span>
                  <span class="cnt" id="statusN"></span>
                </li>
                <li>
                  <i class="fa fa-times circle bg-yellow"></i>
                  <span class="label">반영불가</span>
                  <span class="cnt" id="statusE"></span>
                </li>
                <li>
                  <i class="fa fa-minus circle bg-grey"></i>
                  <span class="label">반영제외</span>
                  <span class="cnt" id="statusD"></span>
                </li>
              </ul>
              <div class="bnt-wrap ml-auto" style="margin-bottom: 3px;">
                <a href="javascript:doAction2('Down2Excel');" class="basic btn-save btn-download">엑셀 다운로드</a>
	            <a id="btnSave" href="javascript:doAction2('Save');" class="basic">변경저장</a>
	            <a id="btnChangeSize" href="javascript:changeFullSize();" class="basic btn-green out-line ico-expand">시트 크게보기</a>
              </div>
             </div>
            <div style="height:500px"><script type="text/javascript">createIBSheet("sheet2", "100%", "500px"); </script></div>
          </div>
        </div>
      </div>
      </form>
    </div>
    <iframe id="ifrmPdfUpload" name="ifrmPdfUpload" width="0" height="0" src="" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
  </div>
  <script>
  // PDF 업로드 이력
    $('.collapse-title > a').on('click', function(e){
		e.preventDefault();

		var obj = $(this).attr('href');
		$(obj).slideToggle(200);
		$(".collapse-desc").not($(obj)).slideUp(200);

	    // Rotate the icon
	    var icon = $(this).find('i.fa');
	    icon.toggleClass('rotate');
    });
  </script>

</body>
</html>