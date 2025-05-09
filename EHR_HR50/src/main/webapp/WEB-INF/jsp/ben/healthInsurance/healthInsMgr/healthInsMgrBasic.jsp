<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='basicInfo' mdef='기본사항'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 건강보험기본사항
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
		{Header:"<sht:txt mid='orderSeq' mdef='순서|순서'/>",			Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sDate' mdef='시작일자|시작일자'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10, EndDateCol:"edate" },
		{Header:"<sht:txt mid='edateV7' mdef='종료일자|종료일자'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol:"sdate" },
		{Header:"<sht:txt mid='socChangeCdV1' mdef='변동코드|변동코드'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"socChangeCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='socStateCdV1' mdef='불입상태|불입상태'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"socStateCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='reductionRate' mdef='감면율|감면율'/>",				Type:"Float",		Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"reductionRate",	KeyField:0,	Format:"Float",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='reductionRate2' mdef='장기요양\n감면율|장기요양\n감면율'/>",	Type:"Float",		Hidden:0,				Width:60,			Align:"Right",	ColMerge:0,	SaveName:"reductionRate2",	KeyField:0,	Format:"Float",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='gradeV2' mdef='등급|등급'/>",					Type:"Text",		Hidden:1,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"grade",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='hiMon' mdef='보수월액|보수월액'/>",			Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"rewardTotMon",	KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon4' mdef='보험료|건강'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon4",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon5' mdef='보험료|장기요양'/>",				Type:"Int",			Hidden:0,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon5",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='totalMon' mdef='보험료|총액'/>",CalcLogic:"|mon4|+|mon5|",Type:"Int",	Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"totalMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='mon1V1' mdef='산정보험료|건강'/>",				Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon1",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon2V1' mdef='산정보험료|장기요양'/>",			Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon2",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='mon3' mdef='산정보험료|총액'/>",				Type:"Int",			Hidden:1,					Width:100,			Align:"Right",	ColMerge:0,	SaveName:"mon3",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",					Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	//------------------------------------- 변동내역 그리드 콤보 -------------------------------------//
	// 변동코드(B10190)
	var socChangeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10190"), "");
	sheet1.SetColProperty("socChangeCd", {ComboText:"|"+socChangeCd[0], ComboCode:"|"+socChangeCd[1]});

	// 불입상태(B10130)
	var socStateCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10130"), "");
	sheet1.SetColProperty("socStateCd", {ComboText:"|"+socStateCd[0], ComboCode:"|"+socStateCd[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#acqYmd").datepicker2();
	$("#lossYmd").datepicker2();

	if (parent.$("#searchUserId").val() != null && parent.$("#searchUserId").val() != "") {
		$("#sabun").val(parent.$("#searchUserId").val());
		doAction1("Search");
	}
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if (parent.$("#searchUserId").val() == "") {
		alert("<msg:txt mid='alertSepCalcBasicMgr1' mdef='대상자를 선택하십시오.'/>");
		parent.$("#searchUserId").focus();
		return false;
	}

	if (sAction == "SaveBasicInfo") {
		// 시작일자와 종료일자 체크
		if ($("#acqYmd").val() != "" && $("#lossYmd").val() != "") {
			if (!checkFromToDate($("#acqYmd"),$("#lossYmd"),"취득일","상실일","YYYYMMDD")) {
				return false;
			}
		}
	} else if (sAction == "Save") {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=2; i<=rowCnt+1; i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			$("#sabun").val(parent.$("#searchUserId").val());

			// 기본사항조회
			var basicInfo = ajaxCall("${ctx}/HealthInsMgr.do?cmd=getHealthInsMgrBasicMap", $("#sheet1Form").serialize(), false);

			$("#identityNo"	).val("");
			$("#acqYmd"		).val("");
			$("#lossYmd"	).val("");

			if (basicInfo.Map != null) {
				basicInfo = basicInfo.Map;
				$("#identityNo"	).val(basicInfo.identityNo);
				$("#acqYmd"		).val(basicInfo.acqYmd);
				$("#lossYmd"	).val(basicInfo.lossYmd);
			}

			// 변동내역 조회
			sheet1.DoSearch("${ctx}/HealthInsMgr.do?cmd=getHealthInsMgrChangeList", $("#sheet1Form").serialize());
			break;

		case "SaveBasicInfo":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchUserId").val());

			if (confirm("저장하시겠습니까?")) {
				// 기본사항저장
				var result = ajaxCall("${ctx}/HealthInsMgr.do?cmd=saveHealthInsMgrBasic",$("#sheet1Form").serialize(),false);

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (parseInt(result["Result"]["Code"]) > 0) {
						alert("<msg:txt mid='alertSaveOkV1' mdef='저장 되었습니다.'/>");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("<msg:txt mid='109500' mdef='저장 오류입니다.'/>");
				}
			}
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
			// 변동내역 저장
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/HealthInsMgr.do?cmd=saveHealthInsMgrChange", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#sabun").val(parent.$("#searchUserId").val());

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "sabun",$("#sabun").val());
			sheet1.SetCellValue(Row, "sdate","${curSysYyyyMMdd}");
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			sheet1.SetCellValue(Row, "seq","");
			sheet1.SetCellValue(Row, "totalMon","");
			sheet1.SetCellValue(Row, "mon3","");
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); doAction1("Search"); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnChange(Row, Col, Value) {
	 try{
		var sSaveName = sheet1.ColSaveName(Col);

		if(sSaveName == "rewardTotMon" || sSaveName == "reductionRate" || sSaveName == "reductionRate2"){

			var params = "&searchRewardTotMon="+Number(sheet1.GetCellValue(Row, "rewardTotMon")) ;
				params = params + "&reductionRate="+Number(sheet1.GetCellValue(Row, "reductionRate")) ;
				params = params + "&reductionRate2="+Number(sheet1.GetCellValue(Row, "reductionRate2")) ;

			var result = ajaxCall("${ctx}/HealthInsMgr.do?cmd=getSelfMonLongTermCareF_CPN_GET_UPDOWN_MON"+params,"",false);
			var selfMon = result["Map"] != null ? result["Map"]["selfMon"] : 0 ;
			var longtermcareMon = result["Map"] != null ? result["Map"]["longtermcareMon"] : 0 ;

			sheet1.SetCellValue(Row, "mon4", selfMon) ;
			sheet1.SetCellValue(Row, "mon5", longtermcareMon) ;
			//sheet1.SetCellValue(Row, "totalMon", selfMon+longtermcareMon) ;
		}
	}catch(ex){alert("OnChange Event Error : " + ex);}
}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='basicInfo' mdef='기본사항'/></li>
							<li class="btn">
								<a href="javascript:doAction1('SaveBasicInfo')"	class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<form id="sheet1Form" name="sheet1Form">
		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />
		</colgroup>
		<tr>
			<th><tit:txt mid='113041' mdef='증번호'/></th>
			<td colspan="3"> <input type="text" id="identityNo" name="identityNo" class="text" value="" style="width:150px" />
							 <input type="hidden" id="sabun" name="sabun" class="text" value="" /> </td>
		</tr>
		<tr>
			<th><tit:txt mid='111955' mdef='취득일'/></th>
			<td> <input type="text" id="acqYmd" name="acqYmd" class="date2" value="" /> </td>
			<th><tit:txt mid='114463' mdef='상실일'/></th>
			<td> <input type="text" id="lossYmd" name="lossYmd" class="date2" value="" /> </td>
		</tr>
		</table>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='staPenMgrBasic' mdef='변동내역'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('Copy')"			class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Insert')"		class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Save')"			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
