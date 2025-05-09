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
	var vsSsnEnterCd = "<%=removeXSS(ssnEnterCd, '1')%>";
	
	$(function() {
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		$("#searchSbNm").val( 		$("#searchKeyword", parent.document).val() 		) ;
		
	});
	
	$(function() {
	
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"선택",		Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직명",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"귀속년도",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산구분",	Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일구분",	Type:"Combo",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"file_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일순번",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_seq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일경로",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_path",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"file_name",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"attr1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"업로드일자",	Type:"Text",		Hidden:0,	Width:142,	Align:"Center",	ColMerge:0,	SaveName:"upload_date",	KeyField:0,	Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"삭제",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"del_btn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"다운",		Type:"Html",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"down_btn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
		var fileTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y", "YEA001"), "전체" );
		//var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
		
		sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		sheet1.SetColProperty("file_type",    {ComboText:"|"+fileTypeList[0], ComboCode:"|"+fileTypeList[1]} );
		
		$("#searchFileType").html(fileTypeList[2]).val("");
		
		$(window).smartresize(sheetResize); sheetInit();
		
		/*	close_0	본인마감전. close_1 대상자아님. close_2 본인마감. close_3 담당자마감. close_4 최종마감	*/
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		
		if(orgAuthPg == "R" && empStatus != "close_0") {
            sheet1.SetColHidden("del_btn", true);
		}else{
			sheet1.SetColHidden("del_btn", false);
		}
		doAction1("Search");
	});
	
	function doAction1(sAction, formCd) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataAddFileRst.jsp?cmd=selectYeaDataAddFileList", $("#sheetForm").serialize() ); 
			break;
		case "PDF":
			downloadFile('A', '0');
			break;
		case "DEL":
			deleteFile('A', '0');
			break;
		case "Reload":
			location.href = location.href;
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); 
			break;
		}
	}
 	
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				var fileType = sheet1.GetCellValue(i,"file_type");
				var fileName = sheet1.GetCellValue(i,"file_name");
				sheet1.SetCellValue(i,"del_btn","<a href=\"javascript:deleteFile('B', '"+i+"')\" class='basic'>삭제</a>");
				sheet1.SetCellValue(i,"down_btn","<a href=\"javascript:downloadFile('B', '"+i+"')\" class='basic'>다운</a>");
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function comma(str) {
		if ( str == "" ) return 0;
		
		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	//파일 업로드 팝업
	function openFileUploadPopup(){
		
		var args = [];
		args["searchWorkYy"] 		= $("#searchWorkYy").val();
		args["searchAdjustType"] 	= $("#searchAdjustType").val();
		args["searchSabun"] 		= $("#searchSabun").val();
		args["searchSbNm"] 			= $("#searchSbNm").val();
		args["searchFileType"] 		= $("#searchFileType").val();
		
		if(!isPopup()) {return;}
		pGubun = "fileUploadPop";
		var rv = openPopup("<%=jspPath%>/yeaData/yeaDataAddFileUploadPop.jsp",args,'750','500');
	}
	
	//파일 다운로드
	function downloadFile(type, row) {
		var arr = new Array();
		var obj = new Object();
		
		if(type == 'A') {
			var sCheckRow = sheet1.FindCheckedRow("ibsCheck");
			
			if ( sCheckRow == "" ){
				alert("선택된 내역이 없습니다.");
				return;
			}
			
			$(sCheckRow.split("|")).each(function(index,value){
				obj = new Object();
				obj.fileType = sheet1.GetCellValue(value,"file_type");
				obj.fileName = sheet1.GetCellValue(value,"attr1");
				obj.dbFileName = sheet1.GetCellValue(value,"file_name");
				obj.sabun = sheet1.GetCellValue(value,"sabun");
				arr.push(obj);
			});
			
		} else {
			obj.fileType = sheet1.GetCellValue(row,"file_type");
			obj.fileName = sheet1.GetCellValue(row,"attr1");
			obj.dbFileName = sheet1.GetCellValue(row,"file_name");
			obj.sabun = sheet1.GetCellValue(row,"sabun");
			arr.push(obj);
		}
		
		if(arr.length > 0) {
			$("#pWorkYy").val($("#searchWorkYy").val());
			$("#pValue").val(JSON.stringify(arr));
			$("#pfrm").attr("action", "<%=jspPath%>/yeaData/yeaDataAddFileDownload.jsp");
			$("#pfrm").submit();
		}
		
	}
	
	//파일 삭제
	function deleteFile(type, row) {
		if(confirm("선택한 파일을 삭제하시겠습니까?")) {
			var arr = new Array();
			var obj = new Object();
			var params = "";
			var pValue = "";
			
			if(type == 'A') {
				var sCheckRow = sheet1.FindCheckedRow("ibsCheck");
				
				if ( sCheckRow == "" ){
					alert("선택된 내역이 없습니다.");
					return;
				}
				
				$(sCheckRow.split("|")).each(function(index,value){
					obj = new Object();
					obj.sabun = sheet1.GetCellValue(value,"sabun");
					obj.workYy = sheet1.GetCellValue(value,"work_yy");
					obj.adjustType = sheet1.GetCellValue(value,"adjust_type");
					obj.fileType = sheet1.GetCellValue(value,"file_type");
					obj.fileSeq = sheet1.GetCellValue(value,"file_seq");
					obj.fileName = sheet1.GetCellValue(value,"file_name");
					arr.push(obj);
				});
				
			} else {
				obj.sabun = sheet1.GetCellValue(row,"sabun");
				obj.workYy = sheet1.GetCellValue(row,"work_yy");
				obj.adjustType = sheet1.GetCellValue(row,"adjust_type");
				obj.fileType = sheet1.GetCellValue(row,"file_type");
				obj.fileSeq = sheet1.GetCellValue(row,"file_seq");
				obj.fileName = sheet1.GetCellValue(row,"file_name");
				arr.push(obj);
			}
			
			pValue = JSON.stringify(arr);
			
			params += "&searchWorkYy=" + $("#searchWorkYy").val();
			params += "&pValue="      + pValue;
			
			var rtnResult = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddFileRst.jsp?cmd=deleteYeaDataAddFileList",params,false);
			
			if(rtnResult.Result.Code == "1"){
				doAction1("Search");
			}
		}	
	}
	
	function goSearch(fileType){
		if(fileType == null || fileType == undefined || fileType.length == 0) {
			$("#searchFileType").val("");
		} else {
			$("#searchFileType").val(fileType);
		}
		doAction1("Search");
	}
	
</script>	
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper" id="topNav">
	<form name="sheetForm" id="sheetForm" method="post">
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchSbNm" name="searchSbNm" value="" />
	<div class="sheet_search outer" style="margin-top:8px; ">
		<div>
        <table>
	        <tr>
	        	<td>
	        		<span>파일구분:</span>
					<select id="searchFileType" name ="searchFileType" onChange="javascript:doAction1('Search');" class="box"></select>
	            </td>
	            <td>
		            <div class="inner" id="div_button">
						<div class="sheet_title" style="white-space:nowrap;overflow:hidden;">
						<ul>
							<li class="right">
								<span>&nbsp;&nbsp;</span>
<!-- 								<span><a href="javascript:doAction1('Search');" class="basic authR">조회</a></span> -->
							</li>
						</ul>
						</div>
					</div>
	            </td>
	        </tr>
        </table>
        </div>
   	</div>
	<div class="outer">
		<div class="sheet_title" style="margin-top:0px; padding-top:0px;">
		<ul>
			<li class="txt">증빙자료관리</li>
			<li class="btn">
				<span><font class="txt" style="color: red; text-overflow: ellipsis; white-space: nowrap;">&nbsp;원본제출이 원칙이며 원본은 5년간 보관해주시기 바랍니다.&nbsp;</font></span>				
				<a href="javascript:openFileUploadPopup();" 	class="button authR">파일 등록</a>
				<a href="javascript:doAction1('PDF');" 			class="button authR">파일다운로드</a>
				<a href="javascript:doAction1('DEL');" 			class="button authR">파일삭제</a>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<div style="height:410px"><script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script></div>
	</form>
</div>
<iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrm" name="pfrm" target="hiddenIframe" action="" method="post" >
<input type="hidden" id="pValue" name="pValue" />
<input type="hidden" id="pWorkYy" name="pWorkYy" />
</form>
</body>
