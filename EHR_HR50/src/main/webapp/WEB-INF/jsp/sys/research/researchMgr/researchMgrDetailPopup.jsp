<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.popDialogArgumentAll();

	$("#stateCd").html(arg["comboStateCd"]);
	$("#researchSymd").val(	arg["researchSymd"]);
	$("#researchEymd").val(	arg["researchEymd"]);
	$("#noticeLvl").val(arg["noticeLvl"]);
	$("#signYn").val(arg["signYn"]);
	$("#openYn").val(arg["openYn"]);
	$("#stateCd").val(arg["stateCd"]);
	$("#researchNm").val(arg["researchNm"]);
	$("#memo").val(arg["memo"]);
	$("#researchSeq").val(arg["researchSeq"]);

	$("#researchSymd").datepicker2({startdate:"researchEymd"});
	$("#researchEymd").datepicker2({enddate:"researchSymd"});

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='orgNm_V3435' mdef='소속도'/>",		Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100,    TreeCol:1 },
		{Header:"<sht:txt mid='orgCdV1' mdef='소속코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",			Type:"CheckBox",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"chkBx",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet3, initdata);sheet3.SetCountPosition(4);


	initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
       	{Header:"<sht:txt mid='dbItemCd' mdef='코드'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"code",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='noticeLvl' mdef='조사레벨'/>",	Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",		Type:"CheckBox",Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"chkBx",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet4, initdata);sheet4.SetCountPosition(4);



// 	if( $("#noticeLvl").val()== "ORG" ){
// 		doAction1("Search");
// 		$("#orgSheet").show();
// 	}else{
// 		doAction2("Search");
// 		$("#elseSheet").show();
// 	}

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

	upLoadInit(arg["fileSeq"],"${hri}");

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
});

function save() {

	var returnValue = [];

	returnValue["researchSymd"] = $("#researchSymd").val();
	returnValue["researchEymd"] = $("#researchEymd").val();
	returnValue["noticeLvl"] 	= $("#noticeLvl").val();
	returnValue["signYn"] 		= $("#signYn").val();
	returnValue["openYn"] 		= $("#openYn").val();
	returnValue["stateCd"] 		= $("#stateCd").val();
	returnValue["researchNm"] 	= $("#researchNm").val() ;
	returnValue["memo"] 		= $("#memo").val();

	p.popReturnValue(returnValue);
	p.window.close();
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":  sheet3.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrOrgList"); break;
		case "Insert":
						IBS_SaveName(document.sheetForm,sheet3);
						sheet3.DoSave("${ctx}/ResearchMgr.do?cmd=insertResearchMgrNotice", $("#sheetForm").serialize() );  break;
	}
}
function doAction2(sAction) {
	switch (sAction) {
		case "Search":  sheet4.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrNoticeLvl", $("#sheetForm").serialize()); break;
		case "Insert":
						IBS_SaveName(document.sheetForm,sheet4);
						sheet4.DoSave("${ctx}/ResearchMgr.do?cmd=insertResearchMgrNotice", $("#sheetForm").serialize() );  break;
	}
}
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		var orgList = ajaxCall("${ctx}/ResearchMgr.do?cmd=getResearchMgrNoticeLvlList",$("#sheetForm").serialize(),false);

		if(orgList == null || orgList.DATA.length < 1) {sheetResize(); return; }
		var orgData = orgList.DATA;
		for(var i=1; i<sheet3.LastRow(); i++){
			for(var x=0; x<orgData.length; x++){
				if(sheet3.GetCellValue(i,"orgCd")==orgData[x].noticeItem ){
					sheet3.SetCellValue(i,"chkBx",1);
					sheet3.SetCellValue(i,"sStatus", "R");
				}
			}
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		var orgList = ajaxCall("${ctx}/ResearchMgr.do?cmd=getResearchMgrNoticeLvlList",$("#sheetForm").serialize(),false);

		if(orgList == null || orgList.DATA.length < 1) {sheetResize(); return; }
		var orgData = orgList.DATA;
		for(var i=1; i<sheet4.LastRow(); i++){
			for(var x=0; x<orgData.length; x++){
				if(sheet4.GetCellValue(i,"code")==orgData[x].noticeItem ){
					sheet4.SetCellValue(i,"chkBx",1);
					sheet4.SetCellValue(i,"sStatus", "R");
				}
			}
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div class="popup_title">
		<ul>
			<li><tit:txt mid='113294' mdef='설문조사 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
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
									<a href="javascript:doAction1('Insert')" class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet3", "100%", "30%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
 			<tr id="elseSheet" style="display:none">
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='114354' mdef='공지레벨'/></li>
								<li class="btn">
									<a href="javascript:doAction2('Insert')" class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet4", "100%", "30%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div>
			<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
		</div>
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:save();" css="pink large" mid='ok' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
