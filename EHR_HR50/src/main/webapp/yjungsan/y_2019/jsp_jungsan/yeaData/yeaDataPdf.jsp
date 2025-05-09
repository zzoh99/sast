<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html> <html><head> <title>교육비</title>
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
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	//도움말
    var helpText1;
	
    var vsSsnEnterCd = "<%=removeXSS(ssnEnterCd, '1')%>";
	
	
    helpText1 = "* 국세청 연말정산간소화서비스 사이트에서 아래의 이미지에 해당하는 PDF를 다운로드 하셔서 등록하시기 바랍니다.<br>";
	
	$(function() {
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
			doAction("Search");
			doAction2("Search");
		});
		
		var a1CdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfA1&"+ $("#sheetForm").serialize(), ""), "전체");
		$("#a1").html(a1CdList[2]);
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
			{Header:"반영제외",		Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"del_check",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N", Sort:0 },
			{Header:"반영",		Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"app_check",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N", Sort:0 },
			{Header:"년도",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"순번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"자료구분",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"doc_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업무구분코드",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"form_cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업무구분",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"form_nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"처리결과",		Type:"Text",		Hidden:0,	Wrap:"true",Width:120,	Align:"Center",	ColMerge:1,	SaveName:"error_log",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"자료순번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"내용",		Type:"Text",		Hidden:0,	Wrap:"true",Width:270,	Align:"Left",	ColMerge:1,	SaveName:"contents",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"처리상태",		Type:"Combo",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"status_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"반영제외자",	Type:"Combo",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"except_gubun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }			
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		//연말정산 pdf 파일 쉬트.
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata3.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"년도",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"파일타입",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"doc_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일시퀀스",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"doc_seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일패스",			Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"file_path",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"file_name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등록일시",			Type:"Text",		Hidden:0,	Width:142,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"반영여부",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileapply",		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"파일보기",			Type:"Html",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"file_link",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"파일삭제",			Type:"Html",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"delfile_link",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetCountPosition(0);
		
		var formCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getPdfFormCdList") , "전체");
		//처리상태
		sheet2.SetColProperty("status_cd",	{ComboText:"반영|미반영|반영불가|반영제외", ComboCode:"S|N|E|D"} );
		
		var exceptGubun = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00346"), "");
		//반영제외자
		sheet2.SetColProperty("except_gubun",	{ComboText:"|"+exceptGubun[0], ComboCode:"|"+exceptGubun[1]} );
		
		$(window).smartresize(sheetResize); 
		sheetInit();
		
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
				$("#btnIns > .pdfAmt").text( comma(map.ins_amt) );					$("#btnIns > .pdfCnt").text("반영("+ map.ins_cnt +"), 미반영("+ map.ins_cnt_err +")");
				$("#btnMed > .pdfAmt").text( comma(map.med_amt) );					$("#btnMed > .pdfCnt").text("반영("+ map.med_cnt +"), 미반영("+ map.med_cnt_err +")");
				$("#btnEdu > .pdfAmt").text( comma(map.edu_amt) );					$("#btnEdu > .pdfCnt").text("반영("+ map.edu_cnt +"), 미반영("+ map.edu_cnt_err +")");
				$("#btnCreditCard > .pdfAmt").text( comma(map.credit_card_amt) );	$("#btnCreditCard > .pdfCnt").text("반영("+ map.credit_card_cnt +"), 미반영("+ map.credit_card_cnt_err +")");
				$("#btnCheckCard > .pdfAmt").text( comma(map.check_card_amt) );		$("#btnCheckCard > .pdfCnt").text("반영("+ map.check_card_cnt +"), 미반영("+ map.check_card_cnt_err +")");
				$("#btnCash > .pdfAmt").text( comma(map.cash_amt) );				$("#btnCash > .pdfCnt").text("반영("+ map.cash_cnt +"), 미반영("+ map.cash_cnt_err +")");
				$("#btnPen > .pdfAmt").text( comma(map.pen_amt) );					$("#btnPen > .pdfCnt").text("반영("+ map.pen_cnt +"), 미반영("+ map.pen_cnt_err +")");
				$("#btnHou > .pdfAmt").text( comma(map.hou_amt) );					$("#btnHou > .pdfCnt").text("반영("+ map.hou_cnt +"), 미반영("+ map.hou_cnt_err +")");
				$("#btnHouSav > .pdfAmt").text( comma(map.hou_sav_amt) );			$("#btnHouSav > .pdfCnt").text("반영("+ map.hou_sav_cnt +"), 미반영("+ map.hou_sav_cnt_err +")");
				$("#btnLongSav > .pdfAmt").text( comma(map.long_sav_amt) );			$("#btnLongSav > .pdfCnt").text("반영("+ (parseInt(map.long_sav_cnt,10) + parseInt(map.venture_cnt,10)) +"), 미반영("+ (parseInt(map.long_sav_cnt_err,10) + parseInt(map.venture_cnt_err,10)) +")");
				$("#btnEtc > .pdfAmt").text( comma(map.etc_amt) );					$("#btnEtc > .pdfCnt").text("반영("+ map.etc_cnt +"), 미반영("+ map.etc_cnt_err +")");
				$("#btnDon > .pdfAmt").text( comma(map.dong_amt) );					$("#btnDon > .pdfCnt").text("반영("+ map.dong_cnt +"), 미반영("+ map.dong_cnt_err +")");
				$("#btnZeroPay > .pdfAmt").text( comma(map.zero_pay_amt) );					$("#btnZeroPay > .pdfCnt").text("반영("+ map.zero_pay_cnt +"), 미반영("+ map.zero_pay_cnt_err +")");
				
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
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param); 
			break;
		}
	}
	
 	//연말정산 pdf파일 상세
	function doAction2(sAction, formCd) {
		switch (sAction) {
		case "Search":
			$("#searchFormCd0, #searchFormCd1, #searchFormCd2, #searchFormCd3, #searchFormCd4, #searchFormCd5, #searchFormCd6, #searchFormCd7, #searchFormCd8, #searchFormCd9").val("");
			
			if ( formCd != undefined && formCd != "" ) {
				$("#formCd").val(formCd);
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
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
								sheet2.SetRowBackColor(i, "#c0d1d3") ;
								sheet2.SetCellBackColor(i, "app_check", "#b5e5ea") ;
							}
						}
					}
					else {
						sheet2.SetCellEditable(i, "app_check", 0) ;
						sheet2.SetCellEditable(i, "del_check", 0) ;
					}
					
					//2019-11-08. 반영 미반영 라인 컬러링
					if(statusCd == "S") {
						sheet2.SetCellBackColor(i, "status_cd", "#FDD7E4") ; //PigPink
					} else if(statusCd == "E") { //반영불가
						sheet2.SetCellBackColor(i,"status_cd", "#DB5079") ; //Blush
						//sheet2.SetCellBackColor(i, "app_check", "#b5e5ea") ;
					} else if(statusCd == "D") { //반영제외
						sheet2.SetCellBackColor(i,"status_cd", "#FFa6C9") ;//Carnation Pink
					} else { //미반영
						sheet2.SetCellBackColor(i,"status_cd", "#FC80A5") ;//Tickle Me Pink
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
	
	function goAction(){
		if($("#upload").val() == "") {
			alert("소득공제 업로드 파일을 선택해주세요.");
			return;
		}

		if( $("#upload").val() != "" ){
				var ext = $('#upload').val().split('.').pop().toLowerCase();
				if($.inArray(ext, ['pdf']) == -1) {
					alert('pdf 파일만 업로드 할수 있습니다.');
					return;
				}
		}
		
		var vsSearchSabun      = $("#searchSabun").val();
		var vsSearchAdjustType = $("#searchAdjustType").val();
		
		$("#paramSabun").val(vsSearchSabun);
		$("#paramAdjustType").val(vsSearchAdjustType);
		
		$("#progressCover").show();
		$("#pdfUpload").hide("fast");
		$("#buttonPlus").show("fast");
		$("#buttonMinus").hide("fast");
		
		if(vsSsnEnterCd == "KYBS"){
			//복호화 업로드
			$("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadDRMRst.jsp"}).submit();
			
		}else{
			
			$("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"yeaDataPdfUploadRst.jsp"}).submit();
		
		}
		parent.getYearDefaultInfoObj();
		goDetailCount(); // 건수 조회
		
		
	}
	
	function procYn(err,message){
		$("#progressCover").hide();
		
		if(err=="Y"){
			alert(message);
		} else {
			alert(message);
		}
	}
	
	/* pdf등록 버튼 기능 */
    $(document).ready(function(){
    	//pdf등록+ 버튼 숨기기
    	$("#buttonMinus").hide("fast");
		$("#pdfUpload").hide("fast");
		$("#infoLayer").hide("fast");
		$("#buttonInfoMinus").hide("fast");
		//$("#pdfList").hide("fast");
		
    	//pdf등록+ 버튼 선택시 pdf등록- 버튼 호출 
    	$("#buttonPlus").live("click",function(){
	    		var btnId = $(this).attr('id'); 
	    		if(btnId == "buttonPlus"){
	    			$("#buttonMinus").show("fast");
	    			$("#buttonPlus").hide("fast");
	    		}
    	});
    	
    	//pdf등록 안내+ 버튼 선택시 pdf등록안내- 버튼 호출 
    	$("#buttonInfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id'); 
	    		if(btnId == "buttonInfoPlus"){
	    			$("#buttonInfoMinus").show("fast");
	    			$("#buttonInfoPlus").hide("fast");
	    		}
    	});
    	
    	//pdf등록- 버튼 선택시 pdf등록+ 버튼 호출
    	$("#buttonMinus").live("click",function(){
    			var btnId = $(this).attr('id'); 
	    		if(btnId == "buttonMinus"){
	    			$("#buttonPlus").show("fast");
	    			$("#buttonMinus").hide("fast");
	    		}
		});
    	
    	//pdf등록안내- 버튼 선택시 pdf등록안내+ 버튼 호출
    	$("#buttonInfoMinus").live("click",function(){
    			var btnId = $(this).attr('id'); 
	    		if(btnId == "buttonInfoMinus"){
	    			$("#buttonInfoPlus").show("fast");
	    			$("#buttonInfoMinus").hide("fast");
	    		}
		});
    	
    	//pdf등록+ 선택시 화면 호출 
    	$("#buttonPlus").click(function(){
            $("#pdfUpload").show("slow");
            $("#infoLayer").show("fast");
        });
    	
    	
    	//pdf등록안내+ 선택시 화면 호출
    	$("#buttonInfoPlus").click(function(){
            $("#infoLayer").show("fast");
        });
    	
    	//pdf등록- 선택시 화면 숨김 
    	$("#buttonMinus").click(function(){
            $("#pdfUpload").hide("fast");
            $("#infoLayer").hide("fast");
        });
    	
    	//pdf등록안내- 선택시 화면 숨김
    	$("#buttonInfoMinus").click(function(){
	            $("#infoLayer").hide("fast");
        });
    });
	
	//PDF등록 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#buttonInfoMinus").hide("fast");
    		$("#buttonInfoPlus").show("fast");
    	}
    });
	
  	//조회 후 에러 메시지 
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			
			for(var i = 1; i < sheet3.RowCount()+1; i++) {
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
				sheet3.SetCellValue(i,"file_link","<a href=\"javascript:openPrint('"+filePath+"')\" class='basic'>보기</a>");
				if(sheet3.GetCellValue(i, "fileapply") == "N") {
					sheet3.SetCellValue(i,"delfile_link","<a href=\"javascript:deletePdf('"+i+"', '"+filePath+"')\" class='basic'>삭제</a>");
				} else {
					sheet3.SetCellValue(i,"delfile_link","&nbsp;");
				}
			}	
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
  	
  	//PDF 파일 보기 버튼 변경
	function sheet3_OnClick(Row, Col, Value){
		var confirm = "<a href=\"#\" class='basic'>보기</a>";
		
	   	if( sheet3.ColSaveName(Col) == "file_link" ) {
   			/* if(Value == nConfirm ){ */
	   			sheet3.SetCellValue(Row,"file_link",confirm);
	   		/* } */	
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
		
		var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=deleteFile",params,false);
		
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
			$("#spanMsg").html(
				"반영=" + detailCount.Data.status_a
				+ ", 미반영=" + detailCount.Data.status_b
				+ ", 반영제외=" + detailCount.Data.status_c
				+ ", 반영불가=" + detailCount.Data.status_d
			);
		}
	}
  
	
</script>	
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper" id="topNav">
	<form id="uploadForm" method="post"  enctype="multipart/form-data">
		<!-- PDF 등록 파일업로드 Start -->
		<input type="hidden" id="paramYear" name="paramYear" value="2012"/>
		<input type="hidden" id="paramSabun" name="paramSabun" value="<%=removeXSS(session.getAttribute("ssnSabun"), '1')"/>
		<input type="hidden" id="paramAdjustType" name="paramAdjustType" value="1"/>
		<table border="0" cellpadding="0" cellspacing="0" class="default outer" id="pdfUpload" style="display:none">
		    <colgroup>
		        <col width="70%" />
		        <col width="20%" />
		        <col width="10%" />
		    </colgroup>
		    <tr>
		        <th class="center">파일찾기</th>
		        <th class="center">비밀번호</th>
		        <th class="center">업로드</th>
		    </tr>
		    <tr>
		        <td class="center"><input type="file" id="upload" name="upload" class="text" style="width:100%;"></td>
		        <td class="right"><input type="text" id="paramPwd" name="paramPwd" class="text w100p right"/></td>
		        <td class="center"><a href="javascript:goAction();" class="basic" title="전자문서 제출">업로드</a></td>
		    </tr>
	    </table>
		<!-- PDF 등록 파일업로드 End -->
	</form>
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
	<!-- Sample Ex&Image Start -->
	<div class="outer" id="infoLayer" style="display:none">
		<table>
			<tr>
				<td style="padding:10px 5px 5px 5px;">&nbsp;&nbsp;<font color="red">* 국세청 연말정산간소화서비스 사이트에서 아래의 이미지에 해당하는 PDF를 다운로드 하셔서 등록하시기 바랍니다.</font></td>
			</tr>
			<tr>
				<td style="padding:10px 5px 5px 5px;">&nbsp;&nbsp;<font color="red">* PDF 자료를 국세청에서 다운받을 때 비밀번호를 설정하였을 경우, 해당 비밀번호를 입력하셔야 합니다.</font></td>
			</tr>
			<tr>
				<td style="padding:5px;"><img src="../../../common_jungsan/images/common/pdf_popup_2019.jpg" border="0" style="vertical-align:middle;width:100%;height:100%"></td>
			</tr>
			<tr>
				<td style="padding:10px 5px 5px 5px;">&nbsp;&nbsp;* 찾아보기 버튼을 클릭하여 PDF파일을 선택하신 후, 업로드 버튼을 클릭하여 주시기 바랍니다.
				<br/>&nbsp;&nbsp;&nbsp;&nbsp; PDF파일은 각 인적공제 인원별로 최종 자료만 업로드 됩니다.(각 인원단위 삭제 후 덮어쓰기 개념)<br/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[본인+배우자 업로드 후 본인의 PDF자료만 재 업로드 시 본인의 데이터만 삭제후 업로드 됩니다.]<br/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[본인의 모든 자료(보험료/신용카드 등) 업로드 후 보험료 PDF만 다시 받아 재 업로드 시 본인 자료 삭제 후 보험료 데이터만 업로드 됩니다.]
				</td>
			</tr>
		</table>
	</div>
	<!-- Sample Ex&Image End -->
	<!-- PDF 파일 목록 Start -->
	<div class="outer" id="pdfFileList">
		<div class="sheet_title">
			<ul>
	            <li class="txt">연말정산  PDF 파일 목록</li>
	            <li class="btn"><a href="javascript:doAction3('Down2Excel')" class="basic">다운로드</a></li>
	        </ul>
			<ul>
				<li class="btn">
					<!-- <a href="javascript:openPdfUploadPopup();" class="blue authA">PDF 등록 원본</a> -->
					<a href="javascript:void(0);" class="blue authA" id="buttonPlus"><b>PDF 등록+</b></a>
		            <a href="javascript:void(0);" class="blue authA" id="buttonMinus" style="display:none"><b>PDF 등록-</b></a>
		            <a href="#layerPopup" class="cute_gray" id="buttonInfoPlus"><b>PDF 등록안내+</b></a>
		            <a href="#layerPopup" class="cute_gray" id="buttonInfoMinus" style="display:none"><b>PDF 등록안내-</b></a>
				</li>
			</ul>
        </div>
        <div><script type="text/javascript">createIBSheet("sheet3", "100%", "200px"); </script></div>
	</div>
	<!-- PDF 파일 목록 End -->
	<div style="margin:5px 15px 10px 15px; display:none;">
		<ul>
			<li class="txt">
			☞ PDF 파일은 전체본에 한해 업로드가 가능합니다.(의료비, 기부금 등 개별적인 PDF 파일은 업로드 불가능합니다.)<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;본인 명의의 PDF파일만 업로드가 가능합니다.(배우자 등 타인 명의의 PDF는 업로드 불가능합니다.<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;본인명의의 PDF에 부양가족 자료가 포함될 수 있도록 국세청 홈페이지에서 조정하시기 바랍니다.)
			</li>
		</ul>
	</div>
	<div class="outer">
		<table style="width:100%;">
			<colgroup>
				<col width="14%">
				<col width="14%">
				<col width="14%">
				<col width="14%">
				<col width="14%">
				<col width="15%">
				<col width="%">
			</colgroup>
			<tr>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'A102Y');" class="pdf" id="btnIns">
						<span class="pdfItem">보험료</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'B101Y');" class="pdf" id="btnMed">
						<span class="pdfItem">의료비</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'C102Y,C202Y,C301Y,C401Y');" class="pdf" id="btnEdu">
						<span class="pdfItem">교육비</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'G107Y');" class="pdf" id="btnCreditCard">
						<span class="pdfItem">신용카드</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'G307Y');" class="pdf" id="btnCheckCard">
						<span class="pdfItem">직불카드</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'G207M');" class="pdf" id="btnCash">
						<span class="pdfItem">현금영수증</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'G407Y');" class="pdf" id="btnZeroPay">
						<span class="pdfItem">제로페이</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
			</tr>
			<tr>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'E102Y,E101Y,F101Y,F102Y');" class="pdf" id="btnPen">
						<span class="pdfItem">연금계좌</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'J101Y,J203Y,J401Y');" class="pdf" id="btnHou">
						<span class="pdfItem">주택자금</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'D101Y,J301Y');" class="pdf" id="btnHouSav">
						<span class="pdfItem">저축</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'N101Y,Q101Y,Q201Y');" class="pdf" id="btnLongSav">
						<span class="pdfItem">장기집합투자증권저축/<br/>벤처기업투자신탁</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'K101M');" class="pdf" id="btnEtc">
						<span class="pdfItem">소기업/소상공인 공제부금</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;">
					<a href="javascript:doAction2('Search', 'L102Y');" class="pdf" id="btnDon">
						<span class="pdfItem">기부금</span>
						<span class="pdfAmt"></span>
						<span class="pdfCnt"></span>
					</a>
				</td>
				<td style="padding:5px;"></td>
			</tr>			
		</table>
		
		<div class="sheet_title" style="margin-top:0px; padding-top:0px;">
		<ul>
			<li class="txt" style="font-weight:normal;">
				구분:
				<select id="formCd">
					<option value="" selected>전체</option>
					<!-- <option value="0000">인적공제</option> --><!-- 2019-11-08. 인적공제 비활성화 처리 -->
					<option value="A102Y">보험료</option>
					<option value="B101Y">의료비</option>
					<option value="C102Y,C202Y,C301Y,C401Y">교육비</option>
					<option value="G107Y">신용카드</option>
					<option value="G307Y">직불카드</option>
					<option value="G207M">현금영수증</option>
					<option value="G407Y">제로페이</option><!-- 2019-12-09. 제로페이 추가 -->
					<option value="E102Y,E101Y,F101Y,F102Y">연금계좌</option>
					<option value="J101Y,J203Y,J401Y">주택자금</option>
					<option value="D101Y,J301Y">저축</option>
					<option value="N101Y,Q101Y,Q201Y">장기집합투자증권저축/벤처기업투자신탁</option><!-- 2019-11-28. 벤처기업투자신탁 추가 -->
					<option value="K101M">소기업/소상공인 공제부금</option>
					<option value="L102Y">기부금</option>
				</select>
				&nbsp;상태:
				<select id="statusCd">
					<option value="">전체</option>	
					<option value="S">반영</option>
					<option value="N">미반영</option>
					<option value="E">반영불가</option>
					<option value="D">반영제외</option>
				</select>
				&nbsp;내용:
				<input type="text" id="contents" class="text" style="width:100px;"/>
				&nbsp;인적공제 인원:
				<select id="a1" name="a1">
					<option value="">전체</option>	
					<option value="S">반영</option>
					<option value="N">미반영</option>
					<option value="E">반영불가</option>
					<option value="D">반영제외</option>
				</select>
			</li>
			<li class="btn">
				<font color="red"><b><span id="spanMsg"></span></b></font>
				<a href="javascript:doAction('Search'); doAction2('Search');"		class="basic authR">조회</a>
				<a href="javascript:doAction2('Save');"								class="basic authA">저장</a>
				<a href="javascript:doAction2('Down2Excel');"						class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<div style="height:410px"><script type="text/javascript">createIBSheet("sheet2", "100%", "410px"); </script></div>
	</form>
	<iframe id="ifrmPdfUpload" name="ifrmPdfUpload" width="0" height="0" src="" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
</div>
</body>
</html>