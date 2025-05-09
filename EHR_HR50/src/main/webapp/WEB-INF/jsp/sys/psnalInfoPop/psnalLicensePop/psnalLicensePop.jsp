<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104238' mdef='인사기본(자격)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";

	$(function() {
		var config = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		var info = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		var headers = [
			{Text:"No|삭제|상태|사번|일련번호|자격증코드|자격증명|등급|취득일|만료일|발행기관|자격증번호|수당지급\n시작일|수당지급\n종료일",Align:"Center"}
		];

		var cols = [
			{Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Popup",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"licenseGrade",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"licSYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"licEYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"officeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"allowSymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"allowEymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		];
		
		sheet1.SetConfig(config);
		sheet1.InitHeaders(headers, info);
		sheet1.InitColumns(cols);
		
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		
		var userCd2 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20170"), "");
		var userCd3 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20175"), "");
		
		sheet1.SetColProperty("licenseGrade", 	{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		sheet1.SetColProperty("officeCd", 		{ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	
	});
	
	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+sabun
						+"&enterCd="+enterCd
						+"&dbLink="+dbLink;

			sheet1.DoSearch( "${ctx}/PsnalLicensePop.do?cmd=getPsnalLicensePopList", param ); 
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
			<li class="txt"><tit:txt mid='license' mdef='자격'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
