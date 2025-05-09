<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104431' mdef='인사기본(직무이력)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";
	var searchUserEnterCdParam;

	$(function() {

		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			$("#btnSave").hide();
		}
		searchUserEnterCdParam = "&enterCd="+$("#hdnEnterCd").val();

		var initdata1 = {};
// 		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};	ColMerge=1 하면 merge 됨
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='eduSYmd' mdef='대표직무\n여부'/>",	Type:"CheckBox",Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"titleYn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			
			{Header:"<sht:txt mid='jobCd_v' mdef='직렬'/>",				Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobMType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobCd_v' mdef='직종'/>",				Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobDType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobCd_v' mdef='직무'/>",				Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='taskCd_v' mdef='과업'/>",			Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"taskCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
			{Header:"<sht:txt mid='jobCd' mdef='비고'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");
		//sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		
		// 콥보 리스트
		/* ########################################################################################################################################## */
		var jobMTypeParam = "&searchJobType=10010&codeType=1"+searchUserEnterCdParam;
		var jobMType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobMTypeParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var jobDTypeParam = "&searchJobType=10020&codeType=1"+searchUserEnterCdParam;
		var jobDType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobDTypeParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var jobCdParam = "&searchJobType=10030&codeType=1"+searchUserEnterCdParam;
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var taskCdParam = "&searchJobType=10040&codeType=1"+searchUserEnterCdParam;
		var taskCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+taskCdParam, false).codeList
		            , "code,codeNm"
		            , " ");

		sheet1.SetColProperty("jobMType", 		{ComboText:"|"+jobMType[0], ComboCode:"|"+jobMType[1]} );	//직렬코드
		sheet1.SetColProperty("jobDType", 		{ComboText:"|"+jobDType[0], ComboCode:"|"+jobDType[1]} );	//직종코드
		sheet1.SetColProperty("jobCd", 			{ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );			//직무코드
		sheet1.SetColProperty("taskCd", 		{ComboText:"|"+taskCd[0], ComboCode:"|"+taskCd[1]} );		//과업코드
		/* ########################################################################################################################################## */
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchSdate").datepicker2();
		$("#searchEdate").datepicker2();
		
		var date = new Date();
		
		var lastDay = ( new Date( date.getFullYear(), "12", 0) ).getDate();
		
		$("#searchSdate").val(date.getFullYear()+"-01"+"-01");
		$("#searchEdate").val(date.getFullYear()+"-12"+"-"+lastDay);
		
		setEmpPage();
		
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/PsnalJobHist.do?cmd=getPsnalJobHistList", $("#sheet1Form").serialize() + "&searchUserEnterCd="+$("#hdnEnterCd").val() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml);
        	break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			
			sheet1.SetCellEditable(row,"jobDType",false);
			sheet1.SetCellEditable(row,"jobCd",false);
			sheet1.SetCellEditable(row,"taskCd",false);
			break;
		case "Save":
			if(!dupChk(sheet1,"sdate|jobCd|taskCd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalJobHist.do?cmd=savePsnalJobHist" ,$("#sheet1Form").serialize());
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
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 직무 이벤트
	function sheet1_OnChange(Row, Col, Value){
		try {
			
			var sSaveName = sheet1.ColSaveName(Col);
			
			if(sSaveName == "jobMType"){
				
				var jobMTypeParam = "&searchJobType=10020&codeType=1&searchJobCd="+Value+searchUserEnterCdParam;
				var jobMType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobMTypeParam, false).codeList
			            , "code,codeNm"
			            , " ");
				
				sheet1.SetCellEditable(Row,"jobDType",true);
				sheet1.SetCellValue(Row,"jobDType","");
				sheet1.CellComboItem(Row,"jobDType",{ComboText:" ", ComboCode:" "});	// 콤보 초기화
				
				if(jobMType[0]){
					sheet1.CellComboItem(Row,"jobDType",{ComboText:"|"+jobMType[0], ComboCode:"|"+jobMType[1]});
				}else{
					sheet1.CellComboItem(Row,"jobDType",{ComboText:" ", ComboCode:" "});	// 콤보 초기화
				}
				
				if(!Value){
					sheet1.CellComboItem(Row,"jobDType",{ComboText:" ", ComboCode:" "});	// 콤보 초기화
					sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
					
					sheet1.SetCellEditable(Row,"jobDType",false);
					sheet1.SetCellEditable(Row,"jobCd",false);
					sheet1.SetCellEditable(Row,"taskCd",false);
				}
				
				sheet1.SetCellValue(Row,"searchApplSeq",$('#searchApplSeq').val());
				sheet1.SetCellValue(Row,"searchApplSabun",$('#searchApplSabun').val());
				sheet1.SetCellValue(Row,"orgCd",$('#orgCd').val());
				
				sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
				sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
				
				sheet1.SetCellEditable(Row,"jobCd",false);
				sheet1.SetCellEditable(Row,"taskCd",false);
			}
			
			if(sSaveName == "jobDType"){
				
				var jobDTypeParam = "&searchJobType=10030&codeType=1&searchJobCd="+Value+searchUserEnterCdParam;
				var jobDType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobDTypeParam, false).codeList
			            , "code,codeNm"
			            , " ");
				
				sheet1.SetCellEditable(Row,"jobCd",true);
				sheet1.SetCellValue(Row,"jobCd","");
				
				if(jobDType[0]){
					sheet1.CellComboItem(Row,"jobCd",{ComboText:"|"+jobDType[0], ComboCode:"|"+jobDType[1]});
				}else{
					sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
				}
				
				if(!Value){
					sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
					
					sheet1.SetCellEditable(Row,"jobCd",false);
					sheet1.SetCellEditable(Row,"taskCd",false);
				}
				
				sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
				
				sheet1.SetCellEditable(Row,"taskCd",false);
				
			}
		
			if(sSaveName == "jobCd"){
				
				var taskCdParam = "&searchJobType=10040&codeType=1&searchJobCd="+Value+searchUserEnterCdParam;
				var taskCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+taskCdParam, false).codeList
				            , "code,codeNm"
				            , " ");

				sheet1.SetCellEditable(Row,"taskCd",true);
				sheet1.SetCellValue(Row,"taskCd","");
				
				if(taskCd[0]){
					sheet1.CellComboItem(Row,"taskCd",{ComboText:"|"+taskCd[0], ComboCode:"|"+taskCd[1]});
				}else{
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
				}
				
				if(!Value){
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
					sheet1.SetCellEditable(Row,"taskCd",false);
				}
				
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	function setEmpPage(){
		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		doAction1("Search");
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td colspan="2"> 
				<span><tit:txt mid='112528' mdef='가입일자'/></span> 
				<input type="text" id="searchSdate" name="searchSdate" class="date2"  /> ~
				<input type="text" id="searchEdate" name="searchEdate" class="date2" /> 
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112882' mdef='직무이력'/></li>
			<li class="btn">
				<span id="btnSave">
					<btn:a href="javascript:doAction1('Insert');" 		css="basic authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction1('Copy');" 		css="basic authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction1('Save');" 		css="basic authA" mid='110708' mdef="저장"/>
				</span>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
