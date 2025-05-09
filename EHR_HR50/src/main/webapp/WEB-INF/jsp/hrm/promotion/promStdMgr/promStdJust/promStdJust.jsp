<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103905' mdef='상벌'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='pmtCd_V1' mdef='승진명부코드'/>",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
			{Header:"<sht:txt mid='prizeCd' mdef='포상사항'/>",		Type:"Combo",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"prizeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='plusPoint' mdef='가점(회당)'/>",		Type:"Float",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"plusPoint",	KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20250"), "");
		sheet1.SetColProperty("prizeCd", 			{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata2.Cols = [
     		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='pmtCd_V1' mdef='승진명부코드'/>",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
   			{Header:"<sht:txt mid='punishCd' mdef='징계사항'/>",		Type:"Combo",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"punishCd",KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='minusPoint' mdef='감점(회당)'/>",	Type:"Float",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"minusPoint",KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		var userCd2 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20270"), "");
		sheet2.SetColProperty("punishCd", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata3.Cols = [
     		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='pmtCd_V1' mdef='승진명부코드'/>",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
   			{Header:"<sht:txt mid='punishCd' mdef='근태사항'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='minusPoint' mdef='감점(회당)'/>",	Type:"Float",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"minusPoint",KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		
		sheet3.SetColProperty("gntCd", 		{ComboText:"|지각|조퇴|무결|병결", ComboCode:"|L10|L20|A1|B2"} );
		
		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata4.Cols = [
     		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='pmtCd_V1' mdef='승진명부코드'/>",Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
   			{Header:"<sht:txt mid='type' mdef='구분'/>",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"gubun", KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd", KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='licenseCd' mdef='자격증'/>",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"licenseCd",KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='calculator' mdef='필수/선택'/>",	Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"calculator",KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);
		
		// 본사/지점(W20050)
		var gubun = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20050"), "");
		sheet4.SetColProperty("gubun", {ComboText:"전체|"+gubun[0], ComboCode:"ALL|"+gubun[1]});
		
		// 직위코드(H20030)
		var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
		sheet4.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});
		
		//자격증코드(H20160) 
		var licenseCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20160"), "");
		sheet4.SetColProperty("licenseCd", 			{ComboText:"|"+licenseCd[0], ComboCode:"|"+licenseCd[1]} );
		
		//연산자
		sheet4.SetColProperty("calculator", 		{ComboText:"필수|선택", ComboCode:"A|O"} );

		sheet1.SetFocusAfterProcess(0);
		sheet2.SetFocusAfterProcess(0);
		sheet3.SetFocusAfterProcess(0);
		sheet4.SetFocusAfterProcess(0);
		
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
		doAction4("Search");
		
		$(window).smartresize(sheetResize); sheetInit();
		
		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			if( pmtCd && pmtCd != null && pmtCd == "-1" ) pmtCd = "";
			sheet1.DoSearch( "${ctx}/PromStdMgr.do?cmd=getPromStdJustPrizeList", "pmtCd="+pmtCd );
			break;
		case "Save":
			if(!dupChk(sheet1,"prizeCd", true, true)){break;}  
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PromStdMgr.do?cmd=savePromStdJustPrize", $("#sheet1Form").serialize());
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
			sheet1.DataCopy(); 
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "가감점(포상사항)_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			if( pmtCd && pmtCd != null && pmtCd == "-1" ) pmtCd = "";
			sheet2.DoSearch( "${ctx}/PromStdMgr.do?cmd=getPromStdJustPunishList", "pmtCd="+pmtCd );
			break;
		case "Save":
			
			if(!dupChk(sheet2,"punishCd", true, true)){break;}  
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/PromStdMgr.do?cmd=savePromStdJustPunish", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			
			if(pmtCd == "") {
				alert("<msg:txt mid='110176' mdef='[승진기준]을 선택하여 주십시오.'/>");
				return;
			}
			
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row,"pmtCd",pmtCd);
			break;
		case "Copy":
			sheet2.DataCopy(); 
			break;
		case "Clear":		
			sheet2.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "가감점(징계사항)_" + d.getTime();
			sheet2.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}
	
	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			if( pmtCd && pmtCd != null && pmtCd == "-1" ) pmtCd = "";
			sheet3.DoSearch( "${ctx}/PromStdMgr.do?cmd=getPromStdJustGntList", "pmtCd="+pmtCd );
			break;
		case "Save":
			
			if(!dupChk(sheet3,"gntCd", true, true)){break;}  
			IBS_SaveName(document.sheet1Form,sheet3);
			sheet3.DoSave( "${ctx}/PromStdMgr.do?cmd=savePromStdJustGnt", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			
			if(pmtCd == "") {
				alert("<msg:txt mid='110176' mdef='[승진기준]을 선택하여 주십시오.'/>");
				return;
			}
			
			var row = sheet3.DataInsert(0);
			sheet3.SetCellValue(row,"pmtCd",pmtCd);
			break;
		case "Copy":
			sheet3.DataCopy(); 
			break;
		case "Clear":		
			sheet3.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet3.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}
	
	//Sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			if( pmtCd && pmtCd != null && pmtCd == "-1" ) pmtCd = "";
			sheet4.DoSearch( "${ctx}/PromStdMgr.do?cmd=getPromStdLicenseList", "pmtCd="+pmtCd );
			break;
		case "Save":
			if(!dupChk(sheet4,"pmtCd|jikweeCd|licenseCd", true, true)){break;}  
			IBS_SaveName(document.sheet1Form,sheet4);
			sheet4.DoSave( "${ctx}/PromStdMgr.do?cmd=savePromStdLicense", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var pmtCd = parent.sheet1.GetCellValue(parent.sheet1.GetSelectRow(),"pmtCd");
			
			if(pmtCd == "") {
				alert("<msg:txt mid='110176' mdef='[승진기준]을 선택하여 주십시오.'/>");
				return;
			}
			
			var row = sheet4.DataInsert(0);
			sheet4.SetCellValue(row,"pmtCd",pmtCd);
			break;
		case "Copy":
			sheet4.DataCopy(); 
			break;
		case "Clear":		
			sheet4.RemoveAll(); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet4);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet4.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}

			doAction2("Search");
			doAction3("Search");			
			doAction4("Search");	
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
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			
			doAction2("Search");				
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			
			doAction3("Search");				
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	

	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			
			doAction4("Search");				
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
		<!-- <col width="34%" /> -->
	</colgroup>
	<tr>
		<td  class="sheet_left hide">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='payRateTab3Std' mdef='근태정보'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction3('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
							<btn:a href="javascript:doAction3('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction3('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction3('Save');" css="btn filled authA" mid='save' mdef="저장"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='104200' mdef='포상사항'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
							<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='payRateTab3Std' mdef='징계사항'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction2('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
							<btn:a href="javascript:doAction2('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction2('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='save' mdef="저장"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_left hide">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='payRateTab3Std' mdef='자격사항'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction4('Insert');" css="basic authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction4('Copy');" css="basic authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction4('Save');" css="basic authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction4('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet4", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
