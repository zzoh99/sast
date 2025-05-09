<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Int",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='surveyItemCd' mdef='설문항목코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"surveyItemCd",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='surveyItemType' mdef='분류'/>",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"surveyItemType",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='surveyItemNm' mdef='설문항목명'/>",		Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"surveyItemNm",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"기본항목여부",		Type:"CheckBox",	Hidden:0,				Width:60,	Align:"Center",	ColMerge:0,	SaveName:"defYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"startYmd",		KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , EndDateCol: "endYmd"},
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"endYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol: "startYmd"},
			{Header:"<sht:txt mid='description' mdef='설명'/>",			Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"surveyItemDesc",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var list1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10230"), "");

		sheet1.SetColProperty("surveyItemType", 			{ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );
		
		$("#searchSurveyItemNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchSurveyItemType").bind("change",function(event){
			doAction1("Search");
		});

		var strOptionAll = "<option value=''>전체</option>";
		$("#searchSurveyItemType").html(strOptionAll+list1[2]);

		sheet1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "endYmd") != null && sheet1.GetCellValue(i, "endYmd") != "") {
					var sdate = sheet1.GetCellValue(i, "startYmd");
					var edate = sheet1.GetCellValue(i, "endYmd");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "endYmd");
						return false;
					}
				}
			}
		}
		return true;
	}

	/**
	 * Sheet 각종 처리
	 */
	 function doAction1(sAction){
		switch(sAction){
			case "Search":      //조회
			
				sheet1.DoSearch( "${ctx}/EduServeryItemMgr.do?cmd=getEduServeryItemMgrList", $("#srchFrm").serialize() );
				break;
			
			case "Save":        //저장
				// 필수값/유효성 체크
				if (!chkInVal()) {
					break;
				}
			
				// 중복체크
				if (!dupChk(sheet1, "surveyItemType|surveyItemNm", false, true)) {break;}
				
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/EduServeryItemMgr.do?cmd=saveEduServeryItemMgr", $("#srchFrm").serialize() );
				break;
			
			case "Insert":      //입력
			
				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "startYmd","<%=DateUtil.getCurrentTime("yyyyMMdd")%>");
				sheet1.SetCellValue(Row, "endYmd", "99991231");
			break;
			
		case "Copy": //행복사
		
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "surveyItemCd", "");
			sheet1.SetCellValue(Row, "languageCd", "");
			sheet1.SetCellValue(Row, "languageNm", "");
			break;
			
		case "Clear": //Clear
		
			sheet1.RemoveAll();
			break;
		
		case "Down2Excel": //엑셀내려받기
		
			sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
			break;
		
		case "LoadExcel": //엑셀업로드
		
			var params = { Mode : "HeaderMatch", WorkSheetNo : 1 };
			sheet1.LoadExcel(params);
			break;
		
		}
	}

	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
			}
			//setSheetSize(this);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}
	
</script>

</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>분류</th>
						<td>
							<select id="searchSurveyItemType" name="searchSurveyItemType"></select>
						</td>
						<th>항목명  </th>
						<td>  <input id="searchSurveyItemNm" name ="searchSurveyItemNm" type="text" class="text w100" /> </td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduServeryEventMgr' mdef='교육만족도항목관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
