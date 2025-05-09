<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html> <head> <title><tit:txt mid='104039' mdef='인사기본(기본)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";
	
	$(function() {
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='famres' mdef='주민등록번호'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nameV1' mdef='한글성명'/>",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sexType' mdef='성별코드'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sexTypeNm' mdef='성별명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sexTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nationalCd' mdef='국적코드'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nationalNm' mdef='국적명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='cname' mdef='한자성명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"cname",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='locationCdV1' mdef='근무지코드'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='locationNm' mdef='근무지명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ename1' mdef='영문성명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ename1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ymd3' mdef='소속발령일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ymd3",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='lunType' mdef='음력양력코드'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='lunTypeNm_V4300' mdef='음력양력명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lunTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='retYmd' mdef='퇴직일'/>",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='traYmd' mdef='면수습일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ctitleChgYmd' mdef='직위변경일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ctitleChgYmd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='fpromYmd' mdef='직급변경일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fpromYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='resignReasonCd_V6191' mdef='퇴직후진로사유코드'/>",Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resignReasonCd",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='resignReasonNm_V6190' mdef='퇴직후진로사유명'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resignReasonNm",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jobNmV1' mdef='담당업무'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"myWork",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='yearYmd' mdef='연차기산일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"yearYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetFocusAfterProcess(0);
		
		//남/여 구분(1:남 2:여)
		var userCd1 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H00010"), " ");
		//국적
		var userCd2 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20290"), " ");
		//퇴직진로/사유
		var userCd3 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H40100"), " ");
		//근무지
		var userCd4 = convCode( codeList("${ctx}/PsnalBasicPop.do?cmd=getPsnalBasicPopLocationCodeList&enterCd="+enterCd+"&dbLink="+dbLink,""), " ");
		
		$("#hdnSabun").val($("#searchUserId",parent.document).val());

		doAction1("Search");
	});
	
	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "enterCd="+enterCd
						+"&sabun="+sabun
						+"&dbLink="+dbLink;
			sheet1.DoSearch( "${ctx}/PsnalBasicPop.do?cmd=getPsnalBasicPopList", param); 
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			getSheetData();
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
		
		$('#resNo1').val(sheet1.GetCellValue(row,"resNo").substring(0,6));
		$('#resNo2').val("*******");
		
		$('#name').val(sheet1.GetCellValue(row,"name"));
		$('#sexType').val(sheet1.GetCellValue(row,"sexType"));
		$('#sexTypeNm').val(sheet1.GetCellValue(row,"sexTypeNm"));
		$('#nationalCd').val(sheet1.GetCellValue(row,"nationalCd"));
		$('#nationalNm').val(sheet1.GetCellValue(row,"nationalNm"));
		$('#cname').val(sheet1.GetCellValue(row,"cname"));
		$('#gempYmd').val(sheet1.GetCellText(row,"gempYmd"));
		$('#locationCd').val(sheet1.GetCellValue(row,"locationCd"));
		$('#locationNm').val(sheet1.GetCellValue(row,"locationNm"));
		$('#ename1').val(sheet1.GetCellValue(row,"ename1"));
		$('#empYmd').val(sheet1.GetCellText(row,"empYmd"));
		$('#ymd3').val(sheet1.GetCellText(row,"ymd3"));
		$('#birYmd').val(sheet1.GetCellText(row,"birYmd"));
		$('#lunType').val(sheet1.GetCellValue(row,"lunType"));
		$('#lunTypeNm').text(sheet1.GetCellValue(row,"lunTypeNm"));
		$('#retYmd').val(sheet1.GetCellText(row,"retYmd"));
		$('#traYmd').val(sheet1.GetCellText(row,"traYmd"));
		$('#ctitleChgYmd').val(sheet1.GetCellText(row,"ctitleChgYmd"));
		$('#fpromYmd').val(sheet1.GetCellText(row,"fpromYmd"));
		$('#resignReasonCd').val(sheet1.GetCellValue(row,"resignReasonCd"));
		$('#resignReasonNm').val(sheet1.GetCellValue(row,"resignReasonNm"));
		$('#myWork').val(sheet1.GetCellValue(row,"myWork"));
		$('#yearYmd').val(sheet1.GetCellText(row,"yearYmd"));
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

<body>
<div class="wrapper">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='104103' mdef='기본'/></li>
		</ul>
		</div>
	</div>
	<form id="infoFrom" name="infoFrom">
		<table border="0" cellpadding="0" cellspacing="0" class="default">
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
			<th><tit:txt mid='104206' mdef='주민등록번호'/></th>
			<td><input id="resNo1" name="resNo1" type="text" class="text transparent date" maxlength="6" readonly style="width:60px;">-
			<input id="resNo2" name="resNo2" type="text" class="text transparent date" maxlength="7" readonly style="width:70px;">
			</td>
			<th><tit:txt mid='103938' mdef='한글성명'/></th>
			<td><input id="name" name="name" type="text" class="text transparent required w100p" maxlength="30" readonly></td>
			<th><tit:txt mid='104011' mdef='성별'/></th>
			<td>
				<input id="sexType" name="sexType" type="hidden" class="text transparent" readonly>
				<input id="sexTypeNm" name="sexTypeNm" type="text" class="text transparent" readonly>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104303' mdef='국적'/></th>
			<td>
				<input id="nationalCd" name="nationalCd" type="hidden" class="text transparent" readonly>
				<input id="nationalNm" name="nationalNm" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='104040' mdef='한자성명'/></th>
			<td><input id="cname" name="cname" type="text" class="text transparent w100p" maxlength="30" readonly></td>
			<th><tit:txt mid='104473' mdef='그룹입사일'/></th>
			<td><input id="gempYmd" name="gempYmd" type="text" class="text transparent" readonly></td>
		</tr>
		<tr>
			<th><tit:txt mid='104281' mdef='근무지'/></th>
			<td>
				<input id="locationCd" name="locationCd" type="hidden" class="text transparent" readonly>
				<input id="locationNm" name="locationNm" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='104533' mdef='영문성명'/></th>
			<td><input id="ename1" name="ename1" type="text" class="text transparent w100p" maxlength="50" readonly></td>
			<th><tit:txt mid='103881' mdef='입사일'/></th>
			<td><input id="empYmd" name="empYmd" type="text" class="text transparent" readonly></td>
		</tr>
		<tr>
			<th><tit:txt mid='103882' mdef='소속발령일'/></th>
			<td><input id="ymd3" name="ymd3" type="text" class="text transparent" readonly></td>
			<th><tit:txt mid='104294' mdef='생년월일'/></th>
			<td>
				<input id="birYmd" name="birYmd" type="text" class="text transparent" readonly>
				<input id="lunType" name="lunType" type="hidden" class="text transparent" readonly>
				<span id="lunTypeNm" name="lunTypeNm" ></span>
			</td>
			<th><tit:txt mid='104369' mdef='퇴직일'/></th>
			<td><input id="retYmd" name="retYmd" type="text" class="text transparent" readonly></td>
		</tr>
		<tr>
			<th><tit:txt mid='103939' mdef='면수습일'/></th>
			<td><input id="traYmd" name="traYmd" type="text" class="text transparent" readonly></td>
			<th><tit:txt mid='104534' mdef='직위변경일'/></th>
			<td><input id="ctitleChgYmd" name="ctitleChgYmd" type="text" class="text transparent" readonly></td>
			<th><tit:txt mid='104234' mdef='직급변경일'/></th>
			<td><input id="fpromYmd" name="fpromYmd" type="text" class="text transparent" readonly></td>
		</tr>
		<tr>
			<th><tit:txt mid='104134' mdef='연차기산일'/></th>
			<td><input id="yearYmd" name="yearYmd" type="text" class="text transparent" readonly></td>
			<th><tit:txt mid='103940' mdef='퇴직후진로/사유'/></th>
			<td colspan="3">
				<input id="resignReasonNm" name="resignReasonNm" type="text" class="text transparent" readonly>
				<input id="resignReasonCd" name="resignReasonCd" type="hidden" class="text transparent" readonly>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='103800' mdef='담당업무'/></th>
			<td colspan="5"><input id="myWork" name="myWork" type="text" class="text transparent w100p" maxlength="1000" readonly></td>
		</tr>
		</table>
	</form>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>
