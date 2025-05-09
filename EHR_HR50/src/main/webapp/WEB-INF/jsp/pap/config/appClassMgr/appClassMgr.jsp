<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	$(function() {

		// 평가ID 콤보 조회
		var searchAppraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C,AA",false).codeList, "");

		// 평가차수 콤보 조회
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote3=Y",false).codeList, "전체");
		//==============================================================================================================================

		//공통코드 한번에 조회
		var grpCds = "P00005,P10003"; 
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");

		$("#searchAppraisalCd").html(searchAppraisalCd[2]);
		$("#searchAppTypeCd").html(codeLists["P10003"][2]);
		$("#searchAppStepCd").html(codeLists["P00005"][2]);
		//$("#searchAppTypeCd").html((codeLists != null && codeLists.size > 0)?codeLists["P10003"][2]:'');
		//$("#searchAppStepCd").html((codeLists != null && codeLists.size > 0)?codeLists["P00005"][2]:'');
		$("#searchAppSeqCd").html(appSeqCdList[2]);

		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가명",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가종류",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가단계",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가차수",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가등급코드",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가등급코드명",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"순번",			Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",			Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetColProperty("appraisalCd", 			{ComboText:searchAppraisalCd[0], ComboCode:searchAppraisalCd[1]} );
		//if(codeLists != null && codeLists.size > 0) {
		sheet1.SetColProperty("appTypeCd", {ComboText: codeLists["P10003"][0], ComboCode: codeLists["P10003"][1]});
		sheet1.SetColProperty("appStepCd", {ComboText: codeLists["P00005"][0], ComboCode: codeLists["P00005"][1]});
		//}
		sheet1.SetColProperty("appSeqCd", 			{ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );
		
		//var appClassCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "P00001"), "");	// 평가등급
		//sheet1.SetColProperty("appClassCd", {ComboText:appClassCd[0], ComboCode:appClassCd[1]});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AppClassMgr.do?cmd=getAppClassMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"appraisalCd|appTypeCd|appStepCd|appSeqCd|appClassCd", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppClassMgr.do?cmd=saveAppClassMgr", $("#srchFrm").serialize()); break;
		case "Insert":
			var searchAppraisalCd = $("#searchAppraisalCd option:selected").val();
			var row = sheet1.DataInsert(0);
			if(searchAppraisalCd != "") {
				sheet1.SetCellValue( row, "appraisalCd", searchAppraisalCd);
			}
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select id="searchAppraisalCd" name="searchAppraisalCd" class="box required" onchange="javascript:doAction1('Search');"></select>
						</td>
						<td class="hide">
							<span>평가종류</span>
							<select id="searchAppTypeCd" name="searchAppTypeCd" class="box required" onchange="javascript:doAction1('Search');"></select>
						</td>
						<td>
							<span>평가단계</span>
							<select id="searchAppStepCd" name="searchAppStepCd" class="box required" onchange="javascript:doAction1('Search');"></select>
						</td>
						<td>
							<span>평가차수</span>
							<select id="searchAppSeqCd" name="searchAppSeqCd" class="box required" onchange="javascript:doAction1('Search');"></select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">차수별 평가등급관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction1('Copy')" 	class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>