<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		var searchSabun = "";
		var searchYm = "";
		var sdate = "";
		var edate = "";

		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			searchSabun = arg["searchSabun"];
			searchYm 	= arg["searchYm"];
			sdate		= arg["sdate"];
			edate		= arg["edate"];
		}else{
	    	if(p.popDialogArgument("searchSabun")!=null)		searchSabun  	= p.popDialogArgument("searchSabun");
	    	if(p.popDialogArgument("searchYm")!=null)			searchYm  		= p.popDialogArgument("searchYm");
	    	if(p.popDialogArgument("sdate")!=null)				sdate  			= p.popDialogArgument("sdate");
	    	if(p.popDialogArgument("edate")!=null)				edate  			= p.popDialogArgument("edate");
	    }

		$("#searchSabun").val(searchSabun);
		$("#searchYm").val(searchYm);
		$("#sdate").val(sdate);
		$("#edate").val(edate);

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='gntNmV1' mdef='근태종류|근태종류'/>",		Type:"Text",      	Hidden:0,  	Width:100,  Align:"Center",	ColMerge:0,   	SaveName:"gntNm",			KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='applYmdV10' mdef='신청일|신청일'/>",			Type:"Date",      	Hidden:0,  	Width:90,   Align:"Center",	ColMerge:0,   	SaveName:"applYmd",			KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='sdateV15' mdef='신청기간|시작일'/>",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,		SaveName:"sYmd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"<sht:txt mid='edateV10' mdef='신청기간|종료일'/>",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,		SaveName:"eYmd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='holDayV2' mdef='적용\n일수|적용\n일수'/>",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,		SaveName:"holDay",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='applStatusNmV1' mdef='신청상태|신청상태'/>",		Type:"Text",      	Hidden:0,  	Width:100,	Align:"Center",	ColMerge:0,   	SaveName:"applStatusNm",	KeyField:0, Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		// 헤더 머지
		sheet1.SetMergeSheet( msHeaderOnly);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function() {

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getPsnlAnnualStaPopList", $("#sheet1Form").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


</script>
</head>

<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun"  />
		<input type="hidden" id="searchYm" name="searchYm" />
		<input type="hidden" id="sdate" name="sdate" />
		<input type="hidden" id="edate" name="edate" />
	</form>
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='psnlTimeStaPop' mdef='근태상세내역'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">

		<div class="sheet_title outer">
		<ul>
			<li id="txt" class="txt"><tit:txt mid='psnlTimeStaPop' mdef='근태상세내역'/></li>
		</ul>
		</div>

		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:p.self.close();" css="gray large" mid="close" mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>