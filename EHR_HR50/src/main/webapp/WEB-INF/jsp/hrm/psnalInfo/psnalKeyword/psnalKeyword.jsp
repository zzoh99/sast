<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사기본(직무)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		 Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		 Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"상태",		 Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"사번",		 Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"구분",		 Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"keywordType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"keywordSeq",Type:"Text",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"keywordSeq",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"Keyword",	 Type:"Text",	Hidden:0,	Width:250,	Align:"Center",	ColMerge:0,	SaveName:"keyword",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",		 Type:"Text",	Hidden:0,	Width:300,	Align:"Center",	ColMerge:0,	SaveName:"note",	    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetVisible(true);sheet1.SetCountPosition(0);

        var keywordArr = [];
        keywordArr.push({code: "C", codeNm: "조건"});
        keywordArr.push({code: "I", codeNm: "입력"});
        keywordCd =convCode(keywordArr);

        sheet1.SetColProperty("keywordType", 		{ComboText:keywordCd[0], ComboCode:keywordCd[1]} );

		//관리자가 아닌 경우 table 수정불가로
		if("${authPg}" == 'R') sheet1.SetEditable(false);

		$(window).smartresize(sheetResize); sheetInit();
	
		setEmpPage() ;
	});
	
	function setEmpPage() { 
		$("#hdnSabun").val($("#searchUserId",parent.document).val());
	
		doAction1("Search");
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val();
			sheet1.DoSearch( "${ctx}/PsnalKeyword.do?cmd=getPsnalKeywordList", param );
			break;
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PsnalKeyword.do?cmd=savePsnalKeyword", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "keywordType", "I");
			sheet1.SetCellValue(row, "sabun", $("#hdnSabun").val());
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
			var rowCnt = sheet1.RowCount();
			for (var i=1; i<=rowCnt; i++) {
				if( sheet1.GetCellValue( i, "keywordType") == 'C' ) {
					sheet1.InitCellProperty(i, "keyword", {Type: "Text", Align: "Center", Edit:0});
					sheet1.InitCellProperty(i, "note", {Type: "Text", Align: "Center", Edit:0});
				}
			}

			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

    function sheet1_OnBeforeCheck(Row, Col) {
		if(sheet1.ColSaveName(Col)	== "sDelete") {
		    	if(sheet1.GetCellValue(Row,"sDelete") == "0" && sheet1.GetCellValue( Row, "keywordType") == 'C') {
	     			alert("구분 값이 입력인 경우에만 삭제가 가능합니다.");
	     			sheet1.SetAllowCheck(false);
		    	}
    		}

	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">KeyWord</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Search');" css="basic authR" mid='search' mdef="조회"/>
				<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
