<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>교육비</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	
	$(function() {
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();
		
		$("#contents").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction2("Search");
			}
		});
		$("#formCd,#statusCd").bind("change",function(event){
			doAction2("Search");
		});
	});
	
	$(function() {
		
 		var inputEdit = 0 ;
 		var applEdit = 0 ;
 		if( orgAuthPg == "A") {
 			inputEdit = 0 ;
 			applEdit = 1 ;
 		} else {
 			inputEdit = 1 ;
 			applEdit = 0 ;
 		}		
 		
		//연말정산 pdf 파일 쉬트.
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"년도",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"파일타입",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"doc_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일시퀀스",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"doc_seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일패스",			Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"file_path",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"file_name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등록일시",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"파일보기",			Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"file_link",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		
		//연말정산 pdf 파일 상세 쉬트
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
   			{Header:"No",		Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"반영제외",		Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"del_check",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N", Sort:0 },
			{Header:"적용",		Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"app_check",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N", Sort:0 },
			{Header:"년도",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"순번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"자료구분",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"doc_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업무구분코드",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"form_cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업무구분",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"form_nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"자료순번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"내용",		Type:"Text",		Hidden:0,	Width:270,	Align:"Left",	ColMerge:1,	SaveName:"contents",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"처리상태",		Type:"Combo",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"status_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"처리결과",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"error_log",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		var formCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getPdfFormCdList") , "전체");
		
		sheet2.SetColProperty("status_cd",	{ComboText:"반영|미반영|오류|반영제외", ComboCode:"S|N|E|D"} );
	
		$("#formCd").html(formCdList[2]);
		
		$(window).smartresize(sheetResize); 
		sheetInit();
		
		doAction1("Search");
	});
	
	//연말정산 pdf파일
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfList", $("#sheetForm").serialize() ); 
			break;
		}
	}	
	
 	//연말정산 pdf파일 상세
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchFormCd").val($("#formCd").val());
			$("#searchStatusCd").val($("#statusCd").val());
			$("#searchContents").val($("#contents").val());
			
			sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfDetailList", $("#sheetForm").serialize() ); 
			break;
		case "Save":
			if(!parent.checkClose())return;
			
			sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=saveYeaDataPdf"); 
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
			
			if(Code == 1) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					var filePath = "<%=serverBaseUrl%>"+sheet1.GetCellValue(i,"file_path")+"/"+sheet1.GetCellValue(i,"file_name");
					sheet1.SetCellValue(i,"file_link","<a href=\"javascript:openPdfViewPopup('"+filePath+"')\" class='basic'>보기</a>");
				}	
				
				doAction2("Search");
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	} 	
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			
			if (Code == 1) { 
				for(var i = 1; i < sheet2.RowCount()+1; i++) {
					var statusCd = sheet2.GetCellValue(i, "status_cd");
					if(statusCd == "S") {
						sheet2.SetCellEditable(i, "app_check", 0) ;
					} else if(statusCd == "N" || statusCd == "D" || statusCd == "E") {
						sheet2.SetCellEditable(i, "del_check", 0) ;
					}
				}
				
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
						+ ", 오류=" + detailCount.Data.status_d
					);
				}
			}
			sheetResize(); 
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			
			if(Code == 1) {
				doAction2("Search");
			}
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	var pGubun = "";
	
	//pdf 업로드 팝업
	function openPdfUploadPopup(){
		
		var args = [];
		args["searchWorkYy"] = $("#searchWorkYy").val();
		args["searchAdjustType"] = $("#searchAdjustType").val();
		args["searchSabun"] = $("#searchSabun").val();
		
		if(!isPopup()) {return;}
		pGubun = "pdfUploadPop";
		var rv = openPopup("<%=jspPath%>/common/pdfUploadPop.jsp",args,"480","280");
		/*
		if(rv == "Y") {
			doAction1("Search");
		}
		*/
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "pdfUploadPop" ){
			if( (rv != null) && (rv[0] == "Y") ) {
				doAction1("Search");
			}
		}
	}
	
	//pdf 업로드 팝업
	function openPdfViewPopup(url){
		if(!isPopup()) {return;}
		var rv = openPopup(url,"","700","600");
	}

	function sheetChangeCheck() {
		var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D")
							+ sheet2.RowCount("I") + sheet2.RowCount("U") + sheet2.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}
	</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">

	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="" />
	<input type="hidden" id="searchContents" name="searchContents" value="" />
	<input type="hidden" id="searchFormCd" name="searchFormCd" value="" />
	</form>	
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">PDF 등록</li>
			<li class="btn">
				<a href="javascript:openPdfUploadPopup();" class="blue authA">PDF 등록</a>
			</li>
		</ul>
		</div>
	</div>
	<div style="height:60px;">
	<script type="text/javascript">createIBSheet("sheet1", "100%", "60px"); </script>
	</div>
	<div style="margin:5px 15px 10px 15px;">
		<ul>
			<li class="txt">
			☞ PDF 파일은 전체본에 한해 업로드가 가능합니다.(의료비, 기부금 등 개별적인 PDF 파일은 업로드 불가능합니다.)<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;본인 명의의 PDF파일만 업로드가 가능합니다.(배우자 등 타인 명의의 PDF는 업로드 불가능합니다.<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;본인명의의 PDF에 부양가족 자료가 포함될 수 있도록 국세청 홈페이지에서 조정하시기 바랍니다.)
			</li>
		</ul>
	</div>
	
	<div class="outer">
		<div class="sheet_title" style="margin-bottom:0px; padding-bottom:0px;">
		<ul>
			<li class="txt">PDF 내용</li>
			<li class="txt"><font color="red"><b><span id="spanMsg"></span></b></font></li>
		</ul>
		</div>
		<div class="sheet_title" style="margin-top:0px; padding-top:0px;">
		<ul>
			<li class="txt" style="width:60%; font-weight:normal;">
				업무구분:
				<select id="formCd">
				</select>
				&nbsp;&nbsp;처리상태:
				<select id="statusCd">
					<option value="">전체</option>
					<option value="S">반영</option>
					<option value="N">미반영</option>
					<option value="E">오류</option>
					<option value="D">반영제외</option>
				</select>
				&nbsp;&nbsp;내용:
				<input type="text" id="contents" class="text" style="width:100px;"/>
			</li>
			<li class="btn">
				<a href="javascript:doAction2('Search');"		class="basic authR">조회</a>
				<a href="javascript:doAction2('Save');"			class="basic authA">저장</a>
				<a href="javascript:doAction2('Down2Excel');"	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<div style="height:410px">
	<script type="text/javascript">createIBSheet("sheet2", "100%", "410px"); </script>
	</div>
</div>
</body>
</html>