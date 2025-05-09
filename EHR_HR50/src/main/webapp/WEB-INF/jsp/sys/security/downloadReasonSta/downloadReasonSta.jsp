<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}", Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}", Align:"Center", ColMerge:0, SaveName:"sNo" },
			
			{Header:"메뉴명",			Type:"Text",     Hidden:0,  Width:100,  Align:"Left",  	 ColMerge:0,   SaveName:"menuNm",   KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			{Header:"프로그램",		Type:"Text",     Hidden:0,  Width:180,  Align:"Left",  	 ColMerge:0,   SaveName:"prgCd",    KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			{Header:"사번",			Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sabun",    KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			{Header:"성명",			Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"name",     KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			
			{Header:"직급",			Type:"Text",     Hidden:Number("${jgHdn}"),  Width:65,  Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",   	KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			{Header:"직위",			Type:"Text",     Hidden:Number("${jwHdn}"),  Width:65,  Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",   	KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			{Header:"직책",			Type:"Text",     Hidden:Number("${jcHdn}"),  Width:65,  Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",   	KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			
			{Header:"파일명",			Type:"Text",     Hidden:0,  Width:160,  Align:"Left",    ColMerge:0,   SaveName:"fileNm",       KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			{Header:"사유",			Type:"Text",     Hidden:0,  Width:250,  Align:"Left",    ColMerge:0,   SaveName:"reason",       KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0,   MultiLineText:1 },
			{Header:"시트ID",		Type:"Text",     Hidden:0,  Width:65,   Align:"Center",  ColMerge:0,   SaveName:"sheetId",      KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 },
			{Header:"다운로드일시",	Type:"Text",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"downloadDate", KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   Edit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		$("#searchName,#searchPrgNm,#searchPrgCd,#searchFromYmd,#searchToYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});

	function chkInVal() {
		if ($("#searchFromYmd").val() != "" && $("#searchToYmd").val() != "") {
			if (!checkFromToDate($("#searchFromYmd"),$("#searchToYmd"),"일자","일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			sheet1.DoSearch( "${ctx}/DownloadReasonSta.do?cmd=getDownloadReasonStaList", $("#srchFrm").serialize() ); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
						<th>일자</th>
						<td>
							<input id="searchFromYmd" name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),0)%>"/> ~
							<input id="searchToYmd" name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th><tit:txt mid='104450' mdef='성명 '/></th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text" />
						</td>
						<th><tit:txt mid='114736' mdef='메뉴명 '/></th>
						<td>
							<input id="searchPrgNm" name ="searchPrgNm" type="text" class="text" />
						</td>
						<th><tit:txt mid='program' mdef='프로그램'/></th>
						<td>
							<input id="searchPrgCd" name ="searchPrgCd" type="text" class="text w200"/>
						</td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt">파일다운로드현황(개인정보 포함된 시트 데이터 다운로드 현황)</li>
							<li class="btn">
								※ 시스템사용기준관리 "<span class="f_bold f_point">SYS_FILE_DOWN_REG_REASON</span>" 설정값에 따라 기능 활성화.
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
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
