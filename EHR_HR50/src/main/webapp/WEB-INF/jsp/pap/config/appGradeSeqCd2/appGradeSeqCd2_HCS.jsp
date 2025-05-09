<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>배분결과(2차)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

//=========================================================================================================================================

		var searchAppraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList",false).codeList, "");
		var searchGradeCd     = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00010"), "전체");//등급(P00010)
		var searchSChk        = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90005"), "전체");//Y/N(S90005)

		$("#searchAppraisalCd").html(searchAppraisalCd[2]);
		$("#searchOrgGradeCd").html(searchGradeCd[2]);
		$("#searchSChk").html(searchSChk[2]);

//=========================================================================================================================================


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가ID코드(TPAP101)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가대상그룹(TPAP133)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가대상그룹명|평가대상그룹명",		Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"appGroupNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수코드(P00003)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"순서",					Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가방법코드(P10006)_사용안함",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appMethodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"1차종료여부_사용안함",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"app1stYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"조직평가등급|조직평가등급",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgGradeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"계획|총원",				Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgInwon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계획|S",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd219S",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계획|A",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd219A",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계획|B",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd219B",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계획|C",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd219C",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계획|D",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd219D",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"동일\n여부|동일\n여부",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sChk",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차|총원",				Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd350Inwon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차|S",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd350S",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차|A",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd350A",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차|B",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd350B",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차|C",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd350C",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"2차|D",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cd350D",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("orgGradeCd", 		{ComboText:"|"+searchGradeCd[0], 		ComboCode:"|"+searchGradeCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		$("#searchAppGroupNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

						if(!checkList()) return ;
						sheet1.DoSearch( "${ctx}/AppGradeSeqCd2.do?cmd=getAppGradeSeqCd2List", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet1,"appraisalCd|appGroupCd", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/AppGradeSeqCd2.do?cmd=saveAppGradeSeqCd2", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"", ExcelFontSize:"9", ExcelRowHeight:"20"});
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span>평가명</span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span>평가대상그룹명</span>
				<input id="searchAppGroupNm" name="searchAppGroupNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<span>조직평가등급</span>
				<select id="searchOrgGradeCd" name="searchOrgGradeCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span>동일여부</span>
				<select id="searchSChk" name="searchSChk" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">배분결과(2차)</li>
			<li class="btn">
<!-- 				<a href="javascript:doAction1('DownTemplate')" 	class="basic authA">양식다운로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a> -->
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>
