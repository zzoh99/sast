<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
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
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='workOrgCd' mdef='근무조'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workOrgCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ymdV9' mdef='일자'/>",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ymd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='thour' mdef='근무시간'/>",	Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"timeCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='note' mdef='비고'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		// from - to 일자 근태대상기준일(TTIM004)에서 가져오도록 처리
		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getStandDtFromTTIM004",false);
		if(data != null && data.codeList[0] != null ) {
			$("#searchSymd").val(data.codeList[0].symd);
			$("#searchEymd").val(data.codeList[0].eymd);
		}

		// 근무조
		var workOrgCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonWorkOrgCdList"), "");
		$("#searchWorkOrgCd").html(workOrgCdList[2]);
		sheet1.SetColProperty("workOrgCd", 		{ComboText:workOrgCdList[0], ComboCode:workOrgCdList[1]} );

		// 근무시간
		var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeCdList&searchShortNameFlag=Y",false).codeList, "");
		sheet1.SetColProperty("timeCd",	{ComboText:timeCdList[0], ComboCode:timeCdList[1]} );


        $("#searchSymd, #searchEymd").datepicker2({
   			onReturn:function(date){
   				doAction1("Search");
   			}
        });
		$("#searchSymd, #searchEymd").bind("keyup",function(event){
		});
		$("#searchWorkOrgCd").bind("change",function(event){
				doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/WorkPattenExMgr.do?cmd=getWorkPattenExMgrList", $("#sheet1Form").serialize() );
			break;
		case "Save":
			// 중복체크
			if (!dupChk(sheet1, "workOrgCd|ymd", false, true)) {break;}

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/WorkPattenExMgr.do?cmd=saveWorkPattenExMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":

			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();

			//sheet1.SetCellValue(row, "timeCd" , "");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"workOrgCd|ymd|timeCd|memo"});
			break;
		break;			
		}
	}

	var gPRow    = "";
	var popGubun = "";

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


	function getReturnValue(returnValue) {


	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id="sheet1Form" name="sheet1Form">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='2017082900889' mdef='근무조'/></th>
			<td>
				<select id="searchWorkOrgCd" name="searchWorkOrgCd"> </select>
			</td>
			<th><tit:txt mid='104420' mdef='기간'/> </th>
			<td>
				<input id="searchSymd" name="searchSymd" type="text" class="text required center date" /> ~
				<input id="searchEymd" name="searchEymd" type="text" class="text required center date" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid="search" mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='2017082900894' mdef='근무패턴예외관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('LoadExcel')" css="btn outline_gray authA" mid='upload' mdef="업로드"/>
				<btn:a href="javascript:doAction1('DownTemplate')" css="btn outline_gray authA" mid='down2ExcelV1' mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid="insert" mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid="copy" mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid="save" mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid="download" mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>