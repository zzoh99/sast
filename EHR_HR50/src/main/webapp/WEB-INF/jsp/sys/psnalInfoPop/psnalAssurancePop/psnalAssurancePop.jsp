<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104038' mdef='인사기본(보증)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var sabun = "${param.sabun}";
	var enterCd = "${param.enterCd}";
	var dbLink = "${param.dbLink}";

	$(function() {
		var config1 = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		var info1 = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		var headers1 = [
			{Text:"No|삭제|상태|사번|보증타입|보험회사|증권번호|보증기간\n시작일|보증기간\n종료일|보증금액",Align:"Center"}
		];

		var cols1 = [
   			{Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"type",			KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyCd",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyNo",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"warrantySYmd",	KeyField:1,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"warrantyEYmd",	KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Int",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"warrantyMon",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		];

		sheet1.SetConfig(config1);
		sheet1.InitHeaders(headers1, info1);
		sheet1.InitColumns(cols1);
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		var config2 = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		var info2 = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		var headers2 = [
			{Text:"No|삭제|상태|사번|보증타입|성명|관계|주민번호|연락처|보증기간|보증기간|주소|주소|주소|납세내역",Align:"Center"},
			{Text:"No|삭제|상태|사번|보증타입|성명|관계|주민번호|연락처|시작일|종료일|우편번호|기본주소|상세주소|납세내역",Align:"Center"}
		];

		var cols2 = [
   			{Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"type",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"warrantyNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"relNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resNo",			KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"PhoneNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantySYmd",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyEYmd",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Type:"Popup",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"zip",				KeyField:0,	Format:"PostNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"addr1",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"addr2",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"warrantyMon",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		];

		sheet2.SetConfig(config2);
		sheet2.InitHeaders(headers2, info2);
		sheet2.InitColumns(cols2);
		sheet2.SetEditable("${editable}");
		sheet2.SetVisible(true);
		sheet2.SetCountPosition(4);

		var userCd1 = convCode( codeList("${ctx}/PsnalInfoPop.do?cmd=getPsnalInfoPopCommonCodeList&enterCd="+enterCd+"&dbLink="+dbLink,"H20380"), "");

		sheet1.SetColProperty("warrantyCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		$("#hdnSabun").val($("#searchUserId",parent.document).val());

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		doAction2("Search");
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "enterCd="+enterCd
						+"&sabun="+sabun
						+"&type=1"
						+"&dbLink="+dbLink;
			
			sheet1.DoSearch( "${ctx}/PsnalAssurancePop.do?cmd=getPsnalAssurancePopWarrantyList", param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet0 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "enterCd="+enterCd
						+"&sabun="+sabun
						+"&type=3"
						+"&dbLink="+dbLink;
			
			sheet2.DoSearch( "${ctx}/PsnalAssurancePop.do?cmd=getPsnalAssurancePopWarrantyUserList", param );
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

	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		try {
			if(sheet2.ColSaveName(Col) == "zip") {
	            var rst = openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
	            if(rst != null){
	            	sheet2.SetCellValue(Row, "zip", rst["zip"]);
	            	sheet2.SetCellValue(Row, "addr1", rst["sido"]+ " "+ rst["gugun"] +" " + rst["dong"]);
	            	sheet2.SetCellValue(Row, "addr2", rst["bunji"]);
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='104329' mdef='보증보험'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='103937' mdef='보증인'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction2('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
