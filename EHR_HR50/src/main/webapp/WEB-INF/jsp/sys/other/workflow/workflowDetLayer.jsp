<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script src="${ctx}/common/plugin/ckeditor5/ckeditor.js"></script>
<title><tit:txt mid='113337' mdef='워크플로우상세'/></title>
<%--<%--%>
<%--HashMap editor = new HashMap();--%>
<%--editor.put("minusHeight", "232");--%>
<%--editor.put("formNm", "workflowDetLayerFrm");--%>
<%--editor.put("contentNm", "contents");--%>
<%--request.setAttribute("editor", editor);--%>
<%--%>--%>
<script type="text/javascript">
	$(function() {
		var args = window.top.document.LayerModalUtility.getModal('workflowDetLayer').parameters;
		var proCd = args["proCd"];

		$("#searchProCd").val(proCd);

		createIBSheet3(document.getElementById('workflowDetLayerSht1-wrap'), "workflowDetLayerSht1", "100%", "200px", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('workflowDetLayerSht2-wrap'), "workflowDetLayerSht2", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
	  		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='proNm' mdef='프로세스명'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",     ColMerge:0,   SaveName:"subProNm",	KeyField:1, Format:"",			UpdateEdit:1, InsertEdit:1,	EditLen:100, MultiLineText:true },
			{Header:"<sht:txt mid='sortSeq' mdef='정렬\n순서'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",   ColMerge:0,   SaveName:"sortSeq",		KeyField:0, Format:"Number",	UpdateEdit:1, InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='description' mdef='설명'/>",			Type:"Text",		Hidden:0,	Width:350,	Align:"Left",	  ColMerge:0,   SaveName:"memo",		KeyField:0, Format:"",			UpdateEdit:1, InsertEdit:1,	EditLen:4000, MultiLineText:true },

			{Header:"<sht:txt mid='proCd' mdef='프로세스코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",   ColMerge:0,   SaveName:"proCd",		KeyField:0, Format:"",			UpdateEdit:0, InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='subProCd' mdef='하위프로세스코드'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",   ColMerge:0,   SaveName:"subProCd",	KeyField:0, Format:"",			UpdateEdit:0, InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(workflowDetLayerSht1, initdata);workflowDetLayerSht1.SetEditable("${editable}");workflowDetLayerSht1.SetVisible(true);workflowDetLayerSht1.SetCountPosition(0);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
	  		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='prgNmV1' mdef='프로그램명'/>",		Type:"Popup",		Hidden:0,	Width:100,	Align:"Left",     ColMerge:0,   SaveName:"prgNm",		KeyField:1, Format:"",			UpdateEdit:0, InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='prgCd_V6500' mdef='프로그램ID'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",   ColMerge:0,   SaveName:"prgCd",		KeyField:1, Format:"",			UpdateEdit:0, InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sortSeq' mdef='정렬\n순서'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",   ColMerge:0,   SaveName:"sortSeq",		KeyField:0, Format:"Number",	UpdateEdit:1, InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='description' mdef='설명'/>",			Type:"Text",		Hidden:0,	Width:350,	Align:"Left",     ColMerge:0,   SaveName:"memo",		KeyField:0, Format:"",			UpdateEdit:1, InsertEdit:1,	EditLen:4000, MultiLineText:true },

			{Header:"<sht:txt mid='proCd' mdef='프로세스코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",   ColMerge:0,   SaveName:"proCd",		KeyField:0, Format:"",			UpdateEdit:0, InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='subProCd' mdef='하위프로세스코드'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",   ColMerge:0,   SaveName:"subProCd",	KeyField:0, Format:"",			UpdateEdit:0, InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(workflowDetLayerSht2, initdata);workflowDetLayerSht2.SetEditable("${editable}");workflowDetLayerSht2.SetVisible(true);workflowDetLayerSht2.SetCountPosition(0);

		workflowDetLayerSht2.SetFocusAfterProcess(false);

		$(window).smartresize(sheetResize); sheetInit();

		getContents();
	    doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			workflowDetLayerSht1.DoSearch( "${ctx}/Workflow.do?cmd=getWorkflowSubList", $("#workflowDetLayerFrm").serialize(), false );
			break;
		case "Save":
			IBS_SaveName(document.workflowDetLayerFrm,workflowDetLayerSht1);
			workflowDetLayerSht1.DoSave( "${ctx}/Workflow.do?cmd=saveWorkflowSubList", $("#workflowDetLayerFrm").serialize());
			break;
		case "Insert":
			var row = workflowDetLayerSht1.DataInsert(0);
			workflowDetLayerSht1.SetCellValue(row, "proCd", $("#searchProCd").val());
			break;
		}
	}

	//Sheet Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			workflowDetLayerSht2.DoSearch( "${ctx}/Workflow.do?cmd=getWorkflowPrgList", $("#workflowDetLayerFrm").serialize(), false );
			break;
		case "Save":
			if(!dupChk(workflowDetLayerSht2,"prgCd", true, true)){break;}
			IBS_SaveName(document.workflowDetLayerFrm,workflowDetLayerSht2);
			workflowDetLayerSht2.DoSave( "${ctx}/Workflow.do?cmd=saveWorkflowPrgList", $("#workflowDetLayerFrm").serialize());
			break;
		case "Insert":
			if(workflowDetLayerSht1.GetCellValue(workflowDetLayerSht1.GetSelectRow(),"sStatus") == "I") {
				alert("<msg:txt mid='110376' mdef='프로세스를 저장후 입력하세요.'/>");
				return;
			}
			var row = workflowDetLayerSht2.DataInsert(0);
			workflowDetLayerSht2.SetCellValue(row, "proCd", $("#searchProCd").val());
			workflowDetLayerSht2.SetCellValue(row, "subProCd", $("#searchSubProCd").val());
			break;
		}
	}

	function getContents() {
		// 입력 폼 값 셋팅
		
		var data = ajaxCall("${ctx}/Workflow.do?cmd=getWorkflowMap",$("#workflowDetLayerFrm").serialize(),false);

		if(data.map == null || data.map.contents === '' ){
			$("#hiddenContents").html("&nbsp;");
		} else {
			$("#hiddenContents").html(data.map.contents);
		}

		$('#modifyContents').val($("#hiddenContents").html());
		callIframeBody("authorForm", "authorFrame");
		$('#authorFrame').on("load", function() { setIframeHeight("authorFrame"); });
	}

	function saveContents() {

		if(!confirm("저장하시겠습니까?")) {
			return;
		}

		ckReadySave("authorFrame");

	 	var rst = ajaxCall("/Workflow.do?cmd=saveWorkflowContents",$("#workflowDetLayerFrm").serialize(),false);

	 	if(rst != null && rst.Result != null){
			alert(rst.Result.Message);
	 	}
	}

	// 조회 후 에러 메시지
	function workflowDetLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

			doAction2("Search");
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function workflowDetLayerSht1_OnSaveEnd(Code, Msg, StCode, StMsg) {
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

	function workflowDetLayerSht1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow != NewRow || isDelete == true) {
				$("#searchSubProCd").val(workflowDetLayerSht1.GetCellValue(NewRow, "subProCd"));
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}


	// 조회 후 에러 메시지
	function workflowDetLayerSht2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function workflowDetLayerSht2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(Code >= 1) {
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function workflowDetLayerSht2_OnPopupClick(Row,Col) {
		try {
			if(workflowDetLayerSht2.ColSaveName(Col) == "prgNm") {
				if(!isPopup()) {return;}

				let layerModal = new window.top.document.LayerModal({
					id : 'prgMgrLayer'
					, url : "/Popup.do?cmd=viewPrgMgrLayer"
					, width : 640
					, height : 520
					, title : '프로그램관리'
					, trigger :[
						{
							name : 'prgMgrTrigger'
							, callback : function(rv){
								workflowDetLayerSht2.SetCellValue(Row, "prgNm", rv["menuNm"]);
								workflowDetLayerSht2.SetCellValue(Row, "prgCd",  rv["prgCd"]);
							}
						}
					]
				});
				layerModal.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

</script>
</head>

<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="authorForm" name="form">
			<input type="hidden" id="modifyContents" name="modifyContents"	/>
			<input type="hidden" id="height" name="height" value="400" />
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="50%" />
				<col width="15px" />
				<col width="*" />
			</colgroup>

			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='114396' mdef='프로세스정의'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
						</div>
					</div>
					<div class="inner">
						<div id="workflowDetLayerSht1-wrap"></div>
					</div>

					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112607' mdef='프로그램정의'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
						</div>
					</div>
					<div id="workflowDetLayerSht2-wrap"></div>
				</td>
				<td></td>
				<td class="sheet_right">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='104532' mdef='기타설명'/></li>
							<li class="btn">
								<btn:a href="javascript:saveContents();" css="btn filled authA" mid='save' mdef="저장"/>
							</li>
						</ul>
						</div>
					</div>

					<form id="workflowDetLayerFrm" name="workflowDetLayerFrm">
						<input id="searchProCd" name="searchProCd" type="hidden" />
						<input id="searchSubProCd" name="searchSubProCd" type="hidden" />
						<input id="contents" name="contents" type="hidden" >
						<!-- ckEditor -->
						<input type="hidden" id="ckEditorContentArea" name="content">
						<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe"></iframe>
					</form>

				</td>
			<tr>
		</table>
		<div id="hiddenContents" Style="display:none"></div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('workflowDetLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>

</div>
</body>
</html>
