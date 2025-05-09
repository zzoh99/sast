<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112278' mdef='인사기본(교육)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='dateStr' mdef='교육기간'/>",		Type:"Text", 	Wrap:1,		Hidden:0,	Width:180,	Align:"Center",	ColMerge:0,	SaveName:"dateStr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduGroupNm' mdef='과정분류'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduGroupNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduCourseNmV1' mdef='교육과정명'/>",		Type:"Text",	Hidden:0,	Width:280,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduMetodNm' mdef='교육형태'/>",		Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"eduTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='nesYn' mdef='필수\n여부'/>",		Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"nesYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmdV1' mdef='교육시작일'/>",		Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eduSymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduEYmdV1' mdef='교육종료일'/>",		Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eduEymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='totHour' mdef='총교육시간'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"totHour",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='finEduHour' mdef='교육이수시간'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"finEduHour",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='finishYn_V3478' mdef='수료\n구분'/>",		Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"finishYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='getScore' mdef='취득학점'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"getScore",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='aprPoint' mdef='인정학점'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"aprPoint",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("nesYn", 		{ComboText:"|필수|선택", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("finishYn", 	{ComboText:"|수료|미수료", ComboCode:"|Y|N"} );
		
		var yearList = convCode( ajaxCall("/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonNSCodeList","queryId=getPsnalInfoPopEduYearList&enterCd="+enterCd+"&dbLink="+dbLink+"&sabun="+sabun,false).codeList, "");
		$("#year").html(yearList[2]) ;
		$("#year").val( "${curSysYear}" ) ;
		
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	
	});
	
	$(function() {
        $("#year").bind("keyup",function(event){
        	makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});
	
	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+sabun
						+"&enterCd="+enterCd
						+"&dbLink="+dbLink
						+"&year="+$("#year").val();
			
			sheet1.DoSearch( "${ctx}/PsnalEduPop.do?cmd=getPsnalEduPopList", param ); 
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			
			$("#txtStdScore").text(sheet1.GetEtcData("stdScore"));
			$("#txtTotScore").text(sheet1.GetEtcData("totScore"));
			
			sheetResize();
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='edu' mdef='교육'/></li>
			<li class="btn">
				교육연도
				<select id="year" name="year" class="required"></select>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="20%" />
		<col width="30%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th><tit:txt mid='114395' mdef='필수이수학점'/></th>
		<td>
			<span id="txtStdScore"></span>
		</td>
		<th><tit:txt mid='113336' mdef='연간인정학점합계'/></th>
		<td>
			<span id="txtTotScore"></span>
		</td>
	</tr>
	</tr>
	</table>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
