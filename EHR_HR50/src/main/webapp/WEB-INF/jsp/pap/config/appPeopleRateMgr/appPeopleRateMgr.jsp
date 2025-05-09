<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"성명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"평가ID",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"평가단계",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd"},
			{Header:"평가년도",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYy"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetUnicodeByte(3);

		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가소속",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"반영비율",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appMRate",	KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:0,	EditLen:20 },

			{Header:"평가ID",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가단계",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetUnicodeByte(3);
		sheet2.SetSumValue("sNo", "합계") ;

		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"시작일자",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate", Format:"Ymd"},
   			{Header:"종료일자",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate", Format:"Ymd"},
   			{Header:"부서명",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"orgNm"}
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable(0);sheet3.SetVisible(true);sheet3.SetUnicodeByte(3);



		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");	//평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function(){

		$("#searchAppraisalCd").bind("change",function(event){
			doAction1("Search");
		});
	});

</script>

<!-- sheet1 script -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			doAction2("Clear");
			sheet1.DoSearch( "${ctx}/AppPeopleRateMgr.do?cmd=getAppPeopleRateMgrList1", $("#sheet1Frm").serialize() );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 셀이 선택 되었을때 발생한다
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;

			$("#searchAppraisalCd").val( sheet1.GetCellValue(NewRow, "appraisalCd") );
			$("#searchSabun").val( sheet1.GetCellValue(NewRow, "sabun") );
			$("#searchAppOrgCd").val( sheet1.GetCellValue(NewRow, "appOrgCd") );
			$("#searchAppraisalYy").val( sheet1.GetCellValue(NewRow, "appraisalYy") );

			doAction2("Search");
			doAction3("Search");
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

</script>

<!-- sheet2 script -->
<script type="text/javascript">
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/AppPeopleRateMgr.do?cmd=getAppPeopleRateMgrList2", $("#sheet1Frm").serialize() ); break;
		case "Save":
			if(sheet2.GetSumValue("appMRate") != "100") {
				alert("반영비율의 합이 100이 되어야 합니다.");
				return;
			}
			IBS_SaveName(document.sheet1Frm,sheet2);
			sheet2.DoSave( "${ctx}/AppPeopleRateMgr.do?cmd=saveAppPeopleRateMgr2", $("#sheet1Frm").serialize()); break;

		case "Clear":
			sheet2.RemoveAll();
			sheet2.SetSumValue("sNo", "합계") ;
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var d = new Date();
			var fName = "평가반영비율_" + d.getTime() + ".xlsx";
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel($.extend(param, { FileName:fName}));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			if ( Code != -1 ) {
				doAction2("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>

<!-- sheet3 script -->
<script type="text/javascript">
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			//조회 데이터 읽어오기
			var searchData = sheet3.GetSearchData("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrChgOrgList", $("#sheet1Frm").serialize() );
			var rtnData = eval("("+searchData+")");
			var searchList = rtnData.DATA;
			var rtnList = new Array();
			var orgCd = "Default";
			for( var i=0; i< searchList.length; i++){
				if( orgCd != searchList[i].orgCd ) rtnList.push(searchList[i]);
				orgCd = searchList[i].orgCd;
			}
			rtnData.DATA = rtnList;
			//조회 결과 내용을 표현하기
			sheet3.LoadSearchData(rtnData);

			break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var d = new Date();
			var fName = "조직이동상세_" + d.getTime() + ".xlsx";
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet3.Down2Excel($.extend(param, { FileName:fName}));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Frm" name="sheet1Frm" >
	<input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value="5" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value="" />
	<input type="hidden" id="searchAppraisalYy" name="searchAppraisalYy" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span>평가명 </span>
				<select id="searchAppraisalCd" name="searchAppraisalCd"> </select>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">부서이동대상자</li>
					<li class="btn">
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%"); </script>
		</td>
		<td class="sheet_right" style="padding-right:1px;">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">조직이동상세</li>
					<li class="btn">
						<a href="javascript:doAction3('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet3", "50%", "50%"); </script>
				<div class="sheet_title">
				<ul>
					<li class="txt">평가반영비율</li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
						<a href="javascript:doAction2('Save')" 	class="btn filled authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "50%"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>