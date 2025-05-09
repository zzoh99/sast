<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='workCdV4' mdef='근무시간코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"timeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='reqSHm' mdef='시작시간'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"shm",		KeyField:1,	Format:"Hm",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='reqEHm' mdef='종료시간'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ehm",		KeyField:1,	Format:"Hm",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='2017082900846' mdef='최초인정\n시간(분)'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"stdMin",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='2017082900847' mdef='인정단위\n(분)'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"unit",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='2017082900839' mdef='승인필요\n여부'/>",		Type:"CheckBox",Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applyYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='seqV2' mdef='순서'/>",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		var workCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "");
		sheet1.SetColProperty("workCd", 	{ComboText:workCdList[0], ComboCode:workCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "searchTimeCd="+parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"timeCd");
			sheet1.DoSearch( "${ctx}/DayWorkTimeMgr.do?cmd=getDayWorkTimeMgrList", param );
			break;
		case "Save":
			if(!dupChk(sheet1,"timeCd|workCd|seq", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/DayWorkTimeMgr.do?cmd=saveDayWorkTimeMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			if(parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"timeCd") == "") {
				alert("<msg:txt mid='109497' mdef='근무시간코드가 설정되지 않았습니다.'/>");
				return;
			}
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"timeCd",parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"timeCd"));
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
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

</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">일일근무스케쥴</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>