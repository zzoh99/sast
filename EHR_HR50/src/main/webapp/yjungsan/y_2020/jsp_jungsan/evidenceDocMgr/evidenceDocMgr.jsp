<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>PDF관리-테스트</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		
		$("#searchWorkYy").mask('0000');

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"선택",		Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직명",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사업장",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"biz_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"귀속년도",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정산구분",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
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

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";
		
		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");	
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}				
		sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		sheet1.SetColProperty("file_type",    {ComboText:"|"+fileTypeList[0], ComboCode:"|"+fileTypeList[1]} );
		sheet1.SetColProperty("biz_place_cd",    {ComboText:"|"+bizPlaceCdList[0], ComboCode:"|"+bizPlaceCdList[1]} );

		$("#searchAdjustType").html(adjustTypeList[2]).val("");
		$("#searchFileType").html(fileTypeList[2]).val("");
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]).val("");

		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");

		/* $("#searchWorkYy,#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchAdjustType").bind("change",function(event){
			doAction1("Search");
		}); */

	});
	
	$(function(){
		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1("Search");
			}
		});
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if (!chkInVal(sAction)) {break;}
						sheet1.DoSearch( "<%=jspPath%>/evidenceDocMgr/evidenceDocMgrRst.jsp?cmd=selectEvidenceDocMgrList", $("#sendForm").serialize(), 1 ); 
						break;
		case "PDF":
						downloadFile('A', '0');
						break;
		case "DEL":
						deleteFile('A', '0');
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
						sheet1.Down2Excel(param);
						break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
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
	
	function chkInVal(sAction) {
		if ($("#searchWorkYy").val() == "") {
			alert("귀속년도를 입력하십시오.");
			$("#searchWorkYy").focus();
			return false;
		}

		return true;
	}
	
	//pdf 업로드 팝업
	function openFileUploadPopup(){
		
		var args = [];
		args["searchWorkYy"] = $("#searchWorkYy").val();
		args["searchAdjustType"] = $("#searchAdjustType").val();
		args["searchSabun"] = $("#searchSabun").val();
		
		if(!isPopup()) {return;}
		pGubun = "fileUploadPop";
		var rv = openPopup("<%=jspPath%>/evidenceDocMgr/evidenceFileUploadPop.jsp",args,'750','500');
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
			$("#pfrm").attr("action", "<%=jspPath%>/evidenceDocMgr/evidenceFileDownload.jsp");
			$("#pfrm").submit();
		}
		
	}
	
	//파일 삭제
	function deleteFile(type, row) {
		if(confirm("선탁한 파일을 삭제하시겠습니까?")) {
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
					obj.sabun = sheet1.GetCellValue(value,"sabun");
					arr.push(obj);
				});
				
			} else {
				obj.sabun = sheet1.GetCellValue(row,"sabun");
				obj.workYy = sheet1.GetCellValue(row,"work_yy");
				obj.adjustType = sheet1.GetCellValue(row,"adjust_type");
				obj.fileType = sheet1.GetCellValue(row,"file_type");
				obj.fileSeq = sheet1.GetCellValue(row,"file_seq");
				obj.fileName = sheet1.GetCellValue(row,"file_name");
				obj.sabun = sheet1.GetCellValue(row,"sabun");
				arr.push(obj);
			}
			
			pValue = JSON.stringify(arr);
			
			params += "&searchWorkYy=" + $("#searchWorkYy").val();
			params += "&pValue="      + pValue;
			
			var rtnResult = ajaxCall("<%=jspPath%>/evidenceDocMgr/evidenceDocMgrRst.jsp?cmd=deleteEvidenceDocMgrList",params,false);
			
			if(rtnResult.Result.Code == "1"){
				doAction1("Search");
			}
		}	
	}
	
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sendForm" id="sendForm" method="post">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>귀속년도</span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center required" maxlength="4" style="width: 35px;" value="<%=yeaYear%>" />
							<%}else{%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center required readonly" maxlength="4" style="width: 35px;" value="<%=yeaYear%>" readonly/>
							<%}%>							
							
						</td>
						<td>
							<span>정산구분</span>
							<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
						<td>
							<span>사업장</span>
							<select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>						
						<td>
							<span>파일구분</span>
							<select id="searchFileType" name ="searchFileType" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>						
						<td>
							<span>사번/성명</span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
						<td> 
	                        <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> 
	                    </td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">증빙자료관리</li>
				<li class="btn">
<!-- 				    <a href="javascript:openFileUploadPopup();" 	class="button authA">PDF 등록</a> -->
					<a href="javascript:doAction1('PDF');" 			class="button authA">파일다운로드</a>
					<a href="javascript:doAction1('DEL');" 			class="button authA">파일삭제</a>
					<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
<iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrm" name="pfrm" target="hiddenIframe" action="" method="post" >
<input type="hidden" id="pValue" name="pValue" />
<input type="hidden" id="pWorkYy" name="pWorkYy" />
</form>
</body>
</html>
