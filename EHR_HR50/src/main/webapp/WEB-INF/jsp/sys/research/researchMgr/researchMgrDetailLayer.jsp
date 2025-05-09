<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	createIBSheet3(document.getElementById('researchMgrDetailLayerSheet3-wrap'), "researchMgrDetailLayerSheet3", "100%", "100%", "${ssnLocaleCd}");
	createIBSheet3(document.getElementById('researchMgrDetailLayerSheet4-wrap'), "researchMgrDetailLayerSheet4", "100%", "100%", "${ssnLocaleCd}");

	const modal = window.top.document.LayerModalUtility.getModal('researchMgrDetailLayer');

	$("#stateCd").html(modal.parameters.comboStateCd || '');
	$("#researchSymd").val(modal.parameters.researchSymd || '');
	$("#researchEymd").val(modal.parameters.researchEymd || '');
	$("#noticeLvl").val(modal.parameters.noticeLvl || '');
	$("#signYn").val(modal.parameters.signYn || '');
	$("#openYn").val(modal.parameters.openYn || '');
	$("#stateCd").val(modal.parameters.stateCd || '');
	$("#researchNm").val(modal.parameters.researchNm || '');
	$("#memo").val(modal.parameters.memo || '');
	$("#researchSeq").val(modal.parameters.researchSeq || '');

	$("#researchSymd").datepicker2({startdate:"researchEymd"});
	$("#researchEymd").datepicker2({enddate:"researchSymd"});

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='orgNm_V3435' mdef='소속도'/>",		Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,    TreeCol:1 },
		{Header:"<sht:txt mid='orgCdV1' mdef='소속코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",			Type:"CheckBox",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"chkBx",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(researchMgrDetailLayerSheet3, initdata);researchMgrDetailLayerSheet3.SetCountPosition(4);

	researchMgrDetailLayerSheet3.SetSheetHeight(250);
	researchMgrDetailLayerSheet4.SetSheetHeight(250);


	initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
       	{Header:"<sht:txt mid='dbItemCd' mdef='코드'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"code",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='noticeLvl' mdef='조사레벨'/>",	Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",		Type:"CheckBox",Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"chkBx",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(researchMgrDetailLayerSheet4, initdata);researchMgrDetailLayerSheet4.SetCountPosition(4);


	$("#noticeLvl").change(function(){
		if( $(this).val() == "ORG" ){
			doAction1("Search");
			$("#elseSheet").hide();
			$("#orgSheet").show();
		}else if($(this).val()=="ALL"){
			$("#orgSheet").hide();
			$("#elseSheet").hide();
		}else{
			doAction2("Search");
			$("#orgSheet").hide();
			$("#elseSheet").show();
		}
	}).trigger("change");

	initFileUploadIframe("researchMgrDetailLayerUploadForm", modal.parameters.fileSeq, "", "${authPg}");
});

function save() {
	const p = {
		researchSymd : $("#researchSymd").val(),
		researchEymd : $("#researchEymd").val(),
		noticeLvl : $("#noticeLvl").val(),
		signYn : $("#signYn").val(),
		openYn : $("#openYn").val(),
		stateCd : $("#stateCd").val(),
		researchNm : $("#researchNm").val(),
		memo : $("#memo").val()
	};
	var modal = window.top.document.LayerModalUtility.getModal('researchMgrDetailLayer');
	modal.fire('researchMgrDetailLayerTrigger', p).hide();
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":  researchMgrDetailLayerSheet3.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrOrgList"); break;
		case "Insert":
						IBS_SaveName(document.sheetForm,researchMgrDetailLayerSheet3);
						researchMgrDetailLayerSheet3.DoSave("${ctx}/ResearchMgr.do?cmd=insertResearchMgrNotice", $("#sheetForm").serialize() );  break;
	}
}
function doAction2(sAction) {
	switch (sAction) {
		case "Search":  researchMgrDetailLayerSheet4.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrNoticeLvl", $("#sheetForm").serialize()); break;
		case "Insert":
						IBS_SaveName(document.sheetForm,researchMgrDetailLayerSheet4);
						researchMgrDetailLayerSheet4.DoSave("${ctx}/ResearchMgr.do?cmd=insertResearchMgrNotice", $("#sheetForm").serialize() );  break;
	}
}
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		var orgList = ajaxCall("${ctx}/ResearchMgr.do?cmd=getResearchMgrNoticeLvlList",$("#sheetForm").serialize(),false);

		if(orgList == null || orgList.DATA.length < 1) {sheetResize(); return; }
		var orgData = orgList.DATA;
		for(var i=1; i<researchMgrDetailLayerSheet3.LastRow(); i++){
			for(var x=0; x<orgData.length; x++){
				if(researchMgrDetailLayerSheet3.GetCellValue(i,"orgCd")==orgData[x].noticeItem ){
					researchMgrDetailLayerSheet3.SetCellValue(i,"chkBx",1);
					researchMgrDetailLayerSheet3.SetCellValue(i,"sStatus", "R");
				}
			}
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
function researchMgrDetailLayerSheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		var orgList = ajaxCall("${ctx}/ResearchMgr.do?cmd=getResearchMgrNoticeLvlList",$("#sheetForm").serialize(),false);

		if(orgList == null || orgList.DATA.length < 1) {sheetResize(); return; }
		var orgData = orgList.DATA;
		for(var i=1; i<researchMgrDetailLayerSheet4.LastRow(); i++){
			for(var x=0; x<orgData.length; x++){
				if(researchMgrDetailLayerSheet4.GetCellValue(i,"code")==orgData[x].noticeItem ){
					researchMgrDetailLayerSheet4.SetCellValue(i,"chkBx",1);
					researchMgrDetailLayerSheet4.SetCellValue(i,"sStatus", "R");
				}
			}
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
function researchMgrDetailLayerSheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheetForm" name="sheetForm" >
			<input id="researchSeq" name="researchSeq" type="hidden"/>
			<table class="table">
				<colgroup>
					<col width="15%" />
					<col width="20%" />
					<col width="15%" />
					<col width="20%" />
					<col width="15%" />
					<col width="20%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='113464' mdef='시작일자'/></th>
					<td>
						<input id="researchSymd" name="researchSymd" type="text" class="date2" />
					</td>
					<th><tit:txt mid='113295' mdef='종료일자'/></th>
					<td>
						<input id="researchEymd" name="researchEymd" type="text" class="date2" />
					</td>
					<th><tit:txt mid='112241' mdef='설문조사레벨'/></th>
					<td>
						<select id="noticeLvl" name="noticeLvl" >
							<option value="ALL"><tit:txt mid='113667' mdef='전인원'/></option>
							<option value="ORG"><tit:txt mid='104279' mdef='소속'/></option>
							<option value="H20010"><tit:txt mid='104471' mdef='직급'/></option>
							<option value="H20020"><tit:txt mid='103785' mdef='직책'/></option>
							<option value="H20030"><tit:txt mid='104104' mdef='직위'/></option>
						</select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='112242' mdef='기명여부'/></th>
					<td>
						<select id="signYn" >
							<option value="Y"><tit:txt mid='112243' mdef='기명'/></option>
							<option value="N"><tit:txt mid='112575' mdef='무기명'/></option>
						</select>
					</td>
					<th><tit:txt mid='113296' mdef='공개여부'/></th>
					<td>
						<select id="openYn" >
							<option value="Y"><tit:txt mid='113297' mdef='공개'/></option>
							<option value="N"><tit:txt mid='113668' mdef='비공개'/></option>
						</select>
					</td>
					<th><tit:txt mid='114732' mdef='설문진행여부'/></th>
					<td>
						<select id="stateCd" ></select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='103918' mdef='제목'/></th>
					<td colspan="5">
						<input id="researchNm" name="researchNm" type="text" class="text" style="width:99%;"/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104276' mdef='목적'/></th>
					<td colspan="5">
						<textarea id="memo" name="memo" style="width:99%;height:50px"></textarea>
					</td>
				</tr>

			</table>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr id="orgSheet" style="display:none">
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='114354' mdef='공지레벨'/></li>
								<li class="btn">
									<a href="javascript:doAction1('Insert')" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
								</li>
							</ul>
						</div>
					</div>
					<div id="researchMgrDetailLayerSheet3-wrap"></div>
				<%--					<script type="text/javascript"> createIBSheet("researchMgrDetailLayerSheet3", "100%", "30%", "${ssnLocaleCd}"); </script>--%>
				</td>
			</tr>
 			<tr id="elseSheet" style="display:none">
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='114354' mdef='공지레벨'/></li>
								<li class="btn">
									<a href="javascript:doAction2('Insert')" class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
								</li>
							</ul>
						</div>
					</div>
					<div id="researchMgrDetailLayerSheet4-wrap"></div>

				<%--					<script type="text/javascript"> createIBSheet("researchMgrDetailLayerSheet4", "100%", "30%", "${ssnLocaleCd}"); </script>--%>
				</td>
			</tr>
		</table>
		<div>
			<iframe id="researchMgrDetailLayerUploadForm" name="researchMgrDetailLayerUploadForm" frameborder="0" class="author_iframe" style="height:200px;"></iframe>
		</div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('researchMgrDetailLayer');" css="gray large" mid='close' mdef="닫기"/>
		<btn:a href="javascript:save();" css="btn outline_gray" mid='ok' mdef="확인"/>
	</div>
</div>

</body>
</html>
