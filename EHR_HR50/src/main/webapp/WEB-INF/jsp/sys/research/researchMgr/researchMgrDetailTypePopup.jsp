<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var researchSeq = null;
var questionSeq = null;
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.popDialogArgumentAll();
	researchSeq 	= arg["researchSeq"];
	questionSeq 	= arg["questionSeq"];

	$("#rSeq").val(researchSeq);
	$("#qSeq").val(questionSeq);

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		{Header:"<sht:txt mid='researchSeq' mdef='설문지순번'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"researchSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='questionSeq' mdef='질문순번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"questionSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='itemSeq' mdef='질문항목순번'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"itemSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='displaySeq' mdef='선택지순서'/>",	Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"displaySeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='rightPoint' mdef='예상점수'/>",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"rightPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='itemNm' mdef='선택지내용'/>",	Type:"Text",	Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"itemNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet5, initdata);sheet5.SetCountPosition(4);

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});

	$(window).smartresize(sheetResize);
	sheetInit();
	doAction5("Search");
});

function doAction5(sAction) {
	switch (sAction) {
		case "Search":  sheet5.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrDetailTypeList", $("#sheetForm").serialize()); break;

		case "Save":
						IBS_SaveName(document.sheetForm,sheet5);
						sheet5.DoSave( "${ctx}/ResearchMgr.do?cmd=saveResearchMgrDetailType", $("#sheetForm").serialize() );  break;
		case "Insert":
			var iRow = sheet5.DataInsert(sheet5.LastRow()+1);
			sheet5.SelectCell(iRow, 4);
			sheet5.SetCellValue(iRow, "researchSeq",researchSeq);
			sheet5.SetCellValue(iRow, "questionSeq",questionSeq);
			break;
		case "Copy":
			var cRow = sheet5.DataCopy();
			sheet5.SetCellValue(cRow, "itemSeq","");
			break;
	}
}
function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg);}
		doAction5("Search");
		sheetResize();
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='114733' mdef='절문선택지 설정'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<form id="sheetForm" name="sheetForm" >
				<input id="rSeq" name="rSeq" type="hidden"/>
				<input id="qSeq" name="qSeq" type="hidden"/>
			</form>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt"><tit:txt mid='114006' mdef='질문 선택지'/></li>
									<li class="btn">
										<btn:a href="javascript:doAction5('Search')" css="basic authA" mid='search' mdef="조회"/>
										<btn:a href="javascript:doAction5('Insert')" css="basic authA" mid='insert' mdef="입력"/>
										<btn:a href="javascript:doAction5('Copy')" css="basic authA" mid='copy' mdef="복사"/>
										<a href="javascript:doAction5('Save')" class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript"> createIBSheet("sheet5", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li>
						<btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
