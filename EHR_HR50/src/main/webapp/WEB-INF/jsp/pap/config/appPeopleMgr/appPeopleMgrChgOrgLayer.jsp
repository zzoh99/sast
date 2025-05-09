<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>조직이동상세</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>



<script type="text/javascript">
	<%--var p = eval("${popUpStatus}");--%>
	$(function() {
		createIBSheet3(document.getElementById('mysheet-wrap'), "apmcolSheet", "100%", "100%", "${ssnLocaleCd}");
		//var arg = p.popDialogArgumentAll();
		var modal = window.top.document.LayerModalUtility.getModal('appPeopleMgrChgOrgLayer');
		//if( arg != undefined ) {
			$("#searchAppraisalYy").val(modal.parameters.searchAppraisalYy);
			$("#searchSabun").val(modal.parameters.searchSabun);
			$("#span_appraisalYy").html(modal.parameters.searchAppraisalYy);
			$("#span_sabun").html(modal.parameters.searchSabun);
			$("#span_name").html(modal.parameters.searchName);
		//}

		// $(".close, #close").click(function() {
		// 	p.self.close();
		// });


		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"시작일자",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate", Format:"Ymd"},
   			{Header:"종료일자",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate", Format:"Ymd"},
   			{Header:"부서명",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"orgNm"}
		]; IBS_InitSheet(apmcolSheet, initdata);apmcolSheet.SetEditable(0);apmcolSheet.SetVisible(true);apmcolSheet.SetUnicodeByte(3);


		$(window).smartresize(sheetResize); sheetInit();
		var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - $(".sheet_title").height() - 2;
		apmcolSheet.SetSheetHeight(sheetHeight);

		doAction1("Search");
	});


	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//조회 데이터 읽어오기
			var searchData = apmcolSheet.GetSearchData("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrChgOrgList", $("#mySheetForm").serialize() );
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
			apmcolSheet.LoadSearchData(rtnData);

			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<input type="hidden" name="searchAppraisalYy" id="searchAppraisalYy" />
			<input type="hidden" name="searchSabun" id="searchSabun" />
			<div class="sheet_search outer">
				<table>
					<tr>
						<th>년도</th>
						<td>
							<span id="span_appraisalYy"></span>
						</td>
						<th>이름</th>
						<td>
							<span id="span_name"></span>
						</td>
						<th>사번</th>
						<td>
							<span id="span_sabun"></span>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li></li>
							</ul>
						</div>
					</div>
					<div id="mysheet-wrap"></div>
<%--				<script type="text/javascript"> createIBSheet("apmcolSheet", "100%", "100%"); </script>--%>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('appPeopleMgrChgOrgLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>