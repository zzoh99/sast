<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>조직이동상세</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {

		var arg = p.popDialogArgumentAll();

		 if( arg != undefined ) {
			$("#searchAppraisalYy").val(arg["searchAppraisalYy"]);
			$("#searchSabun").val(arg["searchSabun"]);
			$("#span_appraisalYy").html(arg["searchAppraisalYy"]);
			$("#span_sabun").html(arg["searchSabun"]);
			$("#span_name").html(arg["searchName"]);
		}

		$(".close, #close").click(function() {
			p.self.close();
		});


		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"시작일자",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate", Format:"Ymd"},
   			{Header:"종료일자",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate", Format:"Ymd"},
   			{Header:"부서명",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"orgNm"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetUnicodeByte(3);


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});


	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//조회 데이터 읽어오기
			var searchData = sheet1.GetSearchData("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrChgOrgList", $("#srchFrm").serialize() );
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
			sheet1.LoadSearchData(rtnData);

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
<form id="srchFrm" name="srchFrm" >
<input type="hidden" name="searchAppraisalYy" id="searchAppraisalYy" />
<input type="hidden" name="searchSabun" id="searchSabun" />
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>조직이동상세</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">


		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<table class="table">
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
					<div class="sheet_title">
					<ul>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
		</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</form>
</body>
</html>