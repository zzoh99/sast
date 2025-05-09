<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='104191' mdef='소급대상 급여일자별 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 월별급여지급현황
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
	         		{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	         		{Header:"<sht:txt mid='detail_V3350' mdef='세부'/>",	Type:"Image",	Hidden:1,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"detail",		Cursor:"Pointer" },
	         		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0},
	         		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0},
	         		{Header:"<sht:txt mid='payActionCd' mdef='급여일자'/>",	Type:"Date",	Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	         		{Header:"<sht:txt mid='giveGubun' mdef='지급구분'/>",	Type:"Text",	Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	         		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	         		{Header:"<sht:txt mid='payActionCdV8' mdef='payActionCd'/>",	Type:"Text",Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"rtrPayActionCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	         	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
	sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	$(window).smartresize(sheetResize);
	setIframeHeight();
	sheetInit();

	if (parent != null && parent != "null" &&
		parent.$("#sabun").val() != null && parent.$("#sabun").val() != "null" &&
		parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "null" &&
		parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {

		$("#sabun").val(parent.$("#searchUserId").val());
		$("#payActionCd").val(parent.$("#payActionCd").val());

		doAction1("Search");
	}
});

//탭 높이 변경
function setIframeHeight() {
	var h = $(".sheet_main").height()-4 ;

	$("#ifrmRetroDetailPop").css("height", h);
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			$("#sabun"		).val("");
			$("#payActionCd").val("");

			if (parent.$("#sabun").val() != null && parent.$("#sabun").val() != "null" &&
				parent.$("#payActionCd").val() != null && parent.$("#payActionCd").val() != "null" &&
				parent.$("#sabun").val() != "" && parent.$("#payActionCd").val() != "") {
				$("#sabun"		).val(parent.$("#sabun").val());
				$("#payActionCd").val(parent.$("#payActionCd").val());

				sheet1.DoSearch("${ctx}/RetroPersonal.do?cmd=getRetroPersonalDtlList", $("#sheet1Form").serialize());
			}
			break;
	}
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		if (Row < sheet1.HeaderRows()) return;
		
		$("#rtrPayActionCd").val(sheet1.GetCellValue(Row, "rtrPayActionCd"));
		sheetResize();
		submitCall($("#sheet1Form"),"ifrmRetroDetailPop","post","/RetroPersonal.do?cmd=viewRetroDetailPop");

	} catch (ex) {
		alert("OnClick Event Error : " + ex);
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
// 		sheetResize();
		sheet1_OnClick(1,1);
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="sabun" name="sabun" class="text" value="" />
		<input type="hidden" id="payActionCd" name="payActionCd" value="" />
		<input type="hidden" id="rtrPayActionCd" name="rtrPayActionCd" value="" />
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="15%" id="col1"/>
			<col width="85%" id="col2"/>
		</colgroup>
		<tr>
			<td style="vertical-align:top;">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='104191' mdef='소급대상 급여일자별 조회'/></li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "90%", "${ssnLocaleCd}"); </script>
			</td>
			<td style="vertical-align:top;">
				<iframe id="ifrmRetroDetailPop" name="ifrmRetroDetailPop" src='${ctx}/common/hidden.html' frameborder='0' class="w100p" style="border:1px solid #f0f0f0; height:450px"></iframe>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
