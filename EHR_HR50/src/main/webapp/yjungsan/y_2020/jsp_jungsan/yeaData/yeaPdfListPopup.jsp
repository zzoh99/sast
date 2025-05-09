<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>담당자-임직원 FeedBack</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%
Map paramMap = StringUtil.getRequestMap(request);
Map mp = StringUtil.getParamMapData(paramMap);
String searchWorkYy = (String)mp.get("workYy");
String searchAdjustType = (String)mp.get("adjustType");
String searchSabun = (String)mp.get("sabun");
String searchAuthPg = (String)mp.get("authPg");
%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var flag = "0";	
	
	$(function() {
		$("#searchWorkYy").val("<%=searchWorkYy%>");
		$("#searchAdjustType").val("<%=searchAdjustType%>");
		$("#searchSabun").val("<%=searchSabun%>");
		$("#searchAuthPg").val("<%=searchAuthPg%>");
		
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			$("#searchWorkYy").val(arg["searchWorkYy"]);
			$("#searchAdjustType").val(arg["searchAdjustType"]);
			$("#searchSabun").val(arg["searchSabun"]);
			$("#searchAuthPg").val(arg["authPg"]);
		}else{
			var searchWorkYy 	 = "";
			var searchAdjustType = "";
			var searchSabun      = "";
			var searchAuthPg      = "";
			
			searchWorkYy 	 = p.popDialogArgument("searchWorkYy");
			searchAdjustType = p.popDialogArgument("searchAdjustType");
			searchSabun      = p.popDialogArgument("searchSabun");
			searchAuthPg     = p.popDialogArgument("authPg");
			
			$("#searchWorkYy").val(searchWorkYy);   		
			$("#searchAdjustType").val(searchAdjustType);
			$("#searchSabun").val(searchSabun);   		
			$("#searchAuthPg").val(searchAuthPg);
		}
		
		var managerEditable = "1";
		var employeeEditable = "0";
		if($("#searchAuthPg").val() == "R") {
			var managerEditable = "0";
			var employeeEditable = "1";
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
			{Header:"반영여부",			Type:"Text",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"fileapply",		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"파일보기",			Type:"Html",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"file_link",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"파일삭제",			Type:"Html",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"delfile_link",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		
        
	    $(window).smartresize(sheetResize); sheetInit();
	    doAction1("Search");
	  
	});
	
	$(function(){
	    $(".close").click(function() {
	    	self.close();
	    });
	});
	
	//연말정산 pdf파일
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=selectYeaDataPdfList", $("#sheetForm").serialize() ); 
			break;
		}
	}	

	//조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			
			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				/*******************FilePath설정******************************************************************************/
				<%
				String nfsUploadPath = StringUtil.getPropertiesValue("NFS.HRFILE.PATH");
				String wasPath = StringUtil.getPropertiesValue("WAS.PATH");
				if(nfsUploadPath != null && nfsUploadPath.length() > 0) {
				%>
				var type = "1";
				var filePath = "<%=nfsUploadPath%>"+sheet1.GetCellValue(i,"file_path")+"/"+sheet1.GetCellValue(i,"file_name");
				<%
				} else if(wasPath != null && wasPath.length() > 0) {
			    %>
			    var type = "1";
				var filePath = "<%=wasPath%>"+sheet1.GetCellValue(i,"file_path")+"/"+sheet1.GetCellValue(i,"file_name");
				<%
					} else {
				%>
				var type = "";
				var filePath = "<%=serverBaseUrl%>"+sheet1.GetCellValue(i,"file_path")+"/"+sheet1.GetCellValue(i,"file_name");
				<%
					}
				%>
				/*************************************************************************************************************/
				sheet1.SetCellValue(i,"file_link","<a href=\"javascript:openPdfViewPopup('"+type+"','"+filePath+"')\" class='basic'>보기</a>");
				if(sheet1.GetCellValue(i, "fileapply") == "N") {
					sheet1.SetCellValue(i,"delfile_link","<a href=\"javascript:deletePdf('"+i+"', '"+filePath+"')\" class='basic'>삭제</a>");
				} else {
					sheet1.SetCellValue(i,"delfile_link","&nbsp;");
				}
			}	
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				var rv = new Array(1);
				if(p.popReturnValue) p.popReturnValue(rv);
				
				doAction1("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	//pdf 업로드 팝업
	function openPdfViewPopup(type, filePath){
		if(!isPopup()) {return;}
		
		if(type == "1") {
			var args = [];
			args["filePath"] = filePath;
			openPopup("<%=jspPath%>/common/pdfViewPop.jsp?authPg=<%=authPg%>", args, "1024","768");
		} else {
			openPopup(filePath,"","1024","768");
		}
	}
	
	//pdf 업로드 파일 삭제
	function deletePdf(row, filePath){
	
		if(sheet1.GetCellValue(row, "fileapply") == "Y"){
			alert("반영 데이터가 존재하여 삭제 할 수 없습니다.");
			return;
		}
		
		var params = "";
		params += "&fileUrl="      + filePath;
		params += "&doc_type="     + sheet1.GetCellValue(row, "doc_type");
		params += "&doc_seq="      + sheet1.GetCellValue(row, "doc_seq");
		params += "&searchWorkYy=" + $("#searchWorkYy").val();
		params += "&searchAdjustType=" + $("#searchAdjustType").val();
		params += "&searchSabun="  + $("#searchSabun").val();
		
		var rtnResult  = ajaxCall("<%=jspPath%>/yeaData/yeaDataPdfRst.jsp?cmd=deleteFile",params,false);
		
		if(rtnResult.Result.Code == "1"){
			flag = "1"
			doAction1("Search");
		}
	}
	
	function fn_close(){
		if(flag == "1") p.popReturnValue("Y");
		p.self.close();
	}
	
</script>

</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>PDF</li>
				<!--<li class="close"></li>-->
			</ul>
		</div>

        <div class="popup_main">
		    <form id="sheetForm" name="sheetForm">
				<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
				<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
				<input type="hidden" id="searchSabun" name="searchSabun" value="" />
				<input type="hidden" id="searchAuthPg" name="searchAuthPg" value="" />
				<input type="hidden" id="searchTemp" name="searchTemp" value="" />
		    </form>
        
			<div class="inner">
				<div class="sheet_title">
				<ul>
		            <li class="txt">PDF 파일 목록</li>
		            <li class="btn">
		              <a href="javascript:doAction1('Down2Excel')" class="basic">다운로드</a>
		            </li>
		        </ul>
		        </div>    
			</div>
			
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:fn_close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>	
	</div>
</body>
</html>