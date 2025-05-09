<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='authorityV1' mdef='권한그룹'/></title>
<script type="text/javascript">
	$(function() {

		const modal = window.top.document.LayerModalUtility.getModal('workflowAuthGrpLayer');
		var args = modal.parameters;
		var proCd = args["proCd"];

		$("#searchProCd").val(proCd);

		createIBSheet3(document.getElementById('workflowAuthGrpLayerSht-wrap'), "workflowAuthGrpLayerSht", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
	  		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='proCd' mdef='프로세스코드'/>",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",   ColMerge:0,   SaveName:"proCd",		KeyField:1, UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='grpCd' mdef='권한그룹코드'/>",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",   ColMerge:0,   SaveName:"grpCd",		KeyField:1, UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='grpNm_V1182' mdef='권한그룹명'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",   ColMerge:0,   SaveName:"grpNm",		KeyField:0, UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",   ColMerge:0,   SaveName:"chk",			KeyField:0, UpdateEdit:1, InsertEdit:0, TrueValue:'Y', FalseValue:'N' }
		]; IBS_InitSheet(workflowAuthGrpLayerSht, initdata);workflowAuthGrpLayerSht.SetEditable("${editable}");workflowAuthGrpLayerSht.SetVisible(true);workflowAuthGrpLayerSht.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
	    doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			workflowAuthGrpLayerSht.DoSearch( "${ctx}/Workflow.do?cmd=getWorkflowAuthGrpPopList", $("#workflowAuthGrpLayerFrm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.workflowAuthGrpLayerFrm,workflowAuthGrpLayerSht);
			workflowAuthGrpLayerSht.DoSave( "${ctx}/Workflow.do?cmd=saveWorkflowAuthGrpPopList", $("#workflowAuthGrpLayerFrm").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function workflowAuthGrpLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function workflowAuthGrpLayerSht_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(Code >= 1) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>
</head>

<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="workflowAuthGrpLayerFrm" name="workflowAuthGrpLayerFrm" tabindex="1">
			<input id="searchProCd" name="searchProCd" type="hidden" >
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='authorityV1' mdef='권한그룹'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
						</div>
					</div>
					<div id="workflowAuthGrpLayerSht-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('workflowAuthGrpLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>

</div>
</body>
</html>
