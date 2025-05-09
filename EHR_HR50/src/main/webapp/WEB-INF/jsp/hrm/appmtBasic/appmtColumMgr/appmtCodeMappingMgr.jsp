<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='113885' mdef='인사기본사항매핑'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",				Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"mapGb",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='traYmdV3' mdef='직위코드'/>",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"codeVal",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='jikweeYn' mdef='직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",				Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"mapGb",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='jikgubCdV2' mdef='직급코드'/>",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"codeVal",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='jikgubYn' mdef='직급'/>",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata3.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",				Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"mapGb",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='codeVal' mdef='Paygroup코드'/>",		Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"codeVal",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"Paygroup",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata4.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",				Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"mapGb",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='payCdV5' mdef='급여구분코드'/>",		Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"codeVal",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='payCd' mdef='급여구분'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);
		
		var manageCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");
		var workType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");
		
		$('#manageCd').html(manageCd[2]);
		$('#workType').html(workType[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});
	
	$(function() {
		$("#manageCd,#workType").change(function(){
			doAction1("Search");
		});
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = $("#mySheetForm").serialize();
			
			sheet1.DoSearch( "${ctx}/GetDataLiat.do?cmd=getAppmtCodeMappingList", param+"&mapGb=H20030" );
			sheet2.DoSearch( "${ctx}/GetDataLiat.do?cmd=getAppmtCodeMappingList", param+"&mapGb=H20010" );
			sheet3.DoSearch( "${ctx}/GetDataLiat.do?cmd=getAppmtCodeMappingList", param+"&mapGb=H20060" );
			sheet4.DoSearch( "${ctx}/GetDataLiat.do?cmd=getAppmtCodeMappingList", param+"&mapGb=H10110" );
			break;
		case "Save":
			var param = $("#mySheetForm").serialize();
			
			var saveStr = sheet1.GetSaveString(1);
			saveStr += "&"+sheet2.GetSaveString(1);
			saveStr += "&"+sheet3.GetSaveString(1);
			saveStr += "&"+sheet4.GetSaveString(1);
			
			rtn = eval("("+sheet1.GetSaveData("${ctx}/AppmtColumMgr.do?cmd=saveAppmtCodeMapping", saveStr, param)+")");
			
			sheet1.LoadSaveData(rtn);			
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
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='103784' mdef='사원구분'/></th>
				<td>
					<select id="manageCd" name="manageCd"></select>
				</td>
				<th><tit:txt mid='112608' mdef='직군'/></th>
				<td>
					<select id="workType" name="workType"></select>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
				</td>				
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='113885' mdef='인사기본사항매핑'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="25%" />
		<col width="25%" />
		<col width="25%" />
		<col width="" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_left sheet_right">
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_left sheet_right">
			<script type="text/javascript"> createIBSheet("sheet3", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_left sheet_right">
			<script type="text/javascript"> createIBSheet("sheet4", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>	
	
</div>
</body>
</html>
