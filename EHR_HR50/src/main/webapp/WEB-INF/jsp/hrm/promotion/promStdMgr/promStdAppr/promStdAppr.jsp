<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103801' mdef='평가'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var config = {SearchMode:smLazyLoad,Page:22}; 
		var info = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		var headers = [
			{Text:"No|삭제|상태|승진명부코드|SEQ|구분|Y-1|Y-1|Y-1|Y-2|Y-2|Y-2|Y-3|Y-3|Y-3|Y-4|Y-4|Y-4|Y-5|Y-5|Y-5|합계",Align:"Center"},
		    {Text:"No|삭제|상태|승진명부코드|SEQ|구분|성과|역량|소계|성과|역량|소계|성과|역량|소계|성과|역량|소계|성과|역량|소계|합계",Align:"Center"}
		];
		
		var cols = [
			{Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
			{Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
			{Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adtYyCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"perfmRate1",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"comptRate1",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sum1",		KeyField:0,	Format:"Number",	CalcLogic:"|perfmRate1|+|comptRate1|",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"comptRate2",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"perfmRate2",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sum2",		KeyField:0,	Format:"Number",	CalcLogic:"|perfmRate2|+|comptRate2|",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"perfmRate3",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"comptRate3",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sum3",		KeyField:0,	Format:"Number",	CalcLogic:"|perfmRate3|+|comptRate3|",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"comptRate4",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"perfmRate4",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sum4",		KeyField:0,	Format:"Number",	CalcLogic:"|perfmRate4|+|comptRate4|",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"perfmRate5",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"comptRate5",	KeyField:0,	Format:"Number",	CalcLogic:"",							PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sum5",		KeyField:0,	Format:"Number",	CalcLogic:"|perfmRate5|+|comptRate5|",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sum",			KeyField:0,	Format:"Number",	CalcLogic:"|perfmRate1|+|comptRate1|+|perfmRate2|+|comptRate2|+|perfmRate3|+|comptRate3|+|perfmRate4|+|comptRate4|+|perfmRate5|+|comptRate5|", PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; 

		sheet1.SetConfig(config);
		sheet1.InitHeaders(headers, info);
		sheet1.InitColumns(cols);
		
		sheet1.SetMergeSheet(msHeaderOnly);
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		
		var userCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20650"), "");
		
		sheet1.SetColProperty("adtYyCd", 		{ComboText:userCd[0], ComboCode:userCd[1]} );
		
		sheet1.SetFocusAfterProcess(0);
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});
	
	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getPromStdApprList", "pmtCd="+pmtCd ); 
			break;
		case "Save":
			var sRow = sheet1.FindStatusRow("I|U");
			var arrRow = sRow.split(";");
			for (var i = 0; i < arrRow.length; i++){
				if(arrRow[i] != "" && sheet1.GetCellValue(arrRow[i],"sum") != "100") {
					alert((arrRow[i]-1)+"번째 행의 총합계가 100 이 아닙니다.");
					return;
				}				
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/SaveData.do?cmd=savePromStdAppr", $("#sheet1Form").serialize()); 
			break;
		case "Insert":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			
			if(pmtCd == "") {
				alert("<msg:txt mid='110176' mdef='[승진기준]을 선택하여 주십시오.'/>");
				return;
			}
			
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"pmtCd",pmtCd);			
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"seq","");
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
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
			<li class="txt"><tit:txt mid='103801' mdef='평가'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
