<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112882' mdef='직무분류표'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='workType_v' mdef='직군'/>",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobMType_v' mdef='직렬'/>",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobMType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobDType_v' mdef='직종'/>",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobDType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobCd_v' mdef='직무'/>",			Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='taskCd_v' mdef='과업'/>",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"taskCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
			{Header:"<sht:txt mid='sdate_v' mdef='시작일자'/>",		Type:"Date",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10, EndDateCol:"edate"},
			{Header:"<sht:txt mid='edate_v' mdef='종료일자'/>",		Type:"Date",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol:"sdate" },
			
			{Header:"<sht:txt mid='seq_v' mdef='순서'/>",	Type:"Text",	Hidden:0,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
		// 콥보 리스트
		/* ########################################################################################################################################## */
		var jobMTypeParam = "&searchJobType=10010&codeType=1";
		var jobMType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobMTypeParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var jobDTypeParam = "&searchJobType=10020&codeType=1";
		var jobDType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobDTypeParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var taskCdParam = "&searchJobType=10040&codeType=1";
		var taskCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+taskCdParam, false).codeList
		            , "code,codeNm"
		            , " ");

		sheet1.SetColProperty("jobMType", 		{ComboText:"|"+jobMType[0], ComboCode:"|"+jobMType[1]} );	//직렬코드
		sheet1.SetColProperty("jobDType", 		{ComboText:"|"+jobDType[0], ComboCode:"|"+jobDType[1]} );	//직종코드
		sheet1.SetColProperty("jobCd", 			{ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );			//직무코드
		sheet1.SetColProperty("taskCd", 		{ComboText:"|"+taskCd[0], ComboCode:"|"+taskCd[1]} );		//과업코드
		/* ########################################################################################################################################## */
		
		$("#searchSdate").datepicker2();

		$("#searchSdate").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search") ;

	});

	function getCommonCodeList() {
		var workType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050", $("#searchSdate").val()), "");
		sheet1.SetColProperty("workType", 		{ComboText:workType[0], ComboCode:workType[1]} );			//직무형태
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
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
			var sXml = sheet1.GetSearchData("${ctx}/JobSchemeMgrBS.do?cmd=getJobSchemeMgrBSList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml);
        	break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}
			if(!dupChk(sheet1,"workType|jobMType|jobDType|jobCd|taskCd|sdate", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/JobSchemeMgrBS.do?cmd=saveJobSchemeMgrBS" ,$("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search") ;
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='103906' mdef='기준일자 '/>  </th>
						<td>  <input id="searchSdate" name="searchSdate" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112882' mdef='직무분류표'/></li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
				<btn:a href="javascript:doAction1('Copy');" 		css="btn outline-gray authA" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="btn outline-gray authA" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid='110708' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
