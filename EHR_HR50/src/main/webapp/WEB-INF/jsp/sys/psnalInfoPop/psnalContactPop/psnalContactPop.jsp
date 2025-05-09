<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103837' mdef='인사기본(신상)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='wedYn' mdef='결혼여부'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='relCd' mdef='종교'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"relCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='hobby' mdef='취미'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='wedYmd' mdef='결혼기념일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='bloodCd' mdef='혈액형'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='specialityNote' mdef='특기'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='officeTel' mdef='사무실전화'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"officeTel",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='homeTel' mdef='집전화'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"homeTel",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='handPhone' mdef='휴대폰번호'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"handPhone",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='mailId' mdef='메일주소'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mailId",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='outMailId' mdef='외부메일주소'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"outMailId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='faxNo' mdef='팩스번호'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"faxNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='addType' mdef='주소구분'/>",	Type:"Combo",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"addType",	KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",	Type:"Popup",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"zip", 		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",		Type:"Text",      	Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"addr1",     KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"<sht:txt mid='addr2' mdef='상세주소'/>",	Type:"Text",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"addr2",  	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"note",   	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetFocusAfterProcess(false);

		//종교
		var userCd1 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20350"), "");
		//혈액형
		var userCd2 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20460"), "");
		//주소구분
		var userCd3 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20185"), "");

		sheet1.SetColProperty("wedYn", 			{ComboText:"기혼|미혼", ComboCode:"Y|N"} );
		sheet1.SetColProperty("relCd", 			{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		sheet1.SetColProperty("bloodCd", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );

		sheet2.SetColProperty("addType", 		{ComboText:userCd3[0], ComboCode:userCd3[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "enterCd="+enterCd
						+"&sabun="+sabun
						+"&dbLink="+dbLink;

			sheet1.DoSearch( "${ctx}/PsnalContactPop.do?cmd=getPsnalContactPopUserList", param );
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "enterCd="+enterCd
						+"&sabun="+sabun
						+"&dbLink="+dbLink;

			sheet2.DoSearch( "${ctx}/PsnalContactPop.do?cmd=getPsnalContactPopAddressList", param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
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
			getSheetData();
			doAction2('Search');
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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

	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {
			return;
		}

		$('#wedYnNm').val(sheet1.GetCellText(row,"wedYn"));
		$('#relCdNm').val(sheet1.GetCellText(row,"relCd"));
		$('#bloodCdNm').val(sheet1.GetCellText(row,"bloodCd"));

		$('#hobby').val(sheet1.GetCellValue(row,"hobby"));
		$('#wedYmd').val(sheet1.GetCellText(row,"wedYmd"));
		$('#specialityNote').val(sheet1.GetCellValue(row,"specialityNote"));
		$('#officeTel').val(sheet1.GetCellValue(row,"officeTel"));
		$('#homeTel').val(sheet1.GetCellValue(row,"homeTel"));
		$('#handPhone').val(sheet1.GetCellValue(row,"handPhone"));
		$('#mailId').val(sheet1.GetCellValue(row,"mailId"));
		$('#outMailId').val(sheet1.GetCellValue(row,"outMailId"));
		$('#faxNo').val(sheet1.GetCellValue(row,"faxNo"));
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "") {
			return strDate;
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='103838' mdef='개인신상'/></li>
		</ul>
		</div>
	</div>

	<form id="infoFrom" name="infoFrom">
		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='104235' mdef='결혼여부'/></th>
			<td>
				<input id="wedYnNm" name="wedYnNm" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='104541' mdef='종교'/></th>
			<td>
				<input id="relCdNm" name="relCdNm" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='103942' mdef='취미'/></th>
			<td><input id="hobby" name="hobby" type="text" class="text transparent w100p" readonly></td>
		</tr>
		<tr>
			<th><tit:txt mid='104135' mdef='결혼기념일'/></th>
			<td><input id="wedYmd" name="wedYmd" type="text" class="text transparent"></td>
			<th><tit:txt mid='104542' mdef='혈액형'/></th>
			<td>
				<input id="bloodCdNm" name="bloodCdNm" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='103839' mdef='특기'/></th>
			<td><input id="specialityNote" name="specialityNote" type="text" class="text transparent w100p" readonly></td>
		</tr>
		</table>

		<div class="outer">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='contact' mdef='연락처'/></li>
			</ul>
			</div>
		</div>

		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="11%" />
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='103943' mdef='사무실전화'/></th>
			<td><input id="officeTel" name="officeTel" type="text" class="text transparent w100p" readonly></td>
			<th><tit:txt mid='103944' mdef='집전화'/></th>
			<td><input id="homeTel" name="homeTel" type="text" class="text transparent w100p" readonly></td>
			<th><tit:txt mid='103945' mdef='휴대폰'/></th>
			<td><input id="handPhone" name="handPhone" type="text" class="text transparent w100p" readonly></td>
		</tr>
		<tr>
			<th><tit:txt mid='104041' mdef='이메일'/></th>
			<td><input id="mailId" name="mailId" type="text" class="text transparent w100p" readonly></td>
			<th><tit:txt mid='104136' mdef='사외이메일'/></th>
			<td><input id="outMailId" name="outMailId" type="text" class="text transparent w100p" readonly></td>
			<th><tit:txt mid='104428' mdef='팩스번호'/></th>
			<td><input id="faxNo" name="faxNo" type="text" class="text transparent w100p" readonly></td>
		</tr>
		</table>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='address' mdef='주소'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction2('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
