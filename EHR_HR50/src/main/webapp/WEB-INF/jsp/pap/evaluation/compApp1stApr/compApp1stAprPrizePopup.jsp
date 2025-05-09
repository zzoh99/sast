<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var baseYear;
	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});

		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
	    	$("#searchAppSabun").val(arg["searchSabun"]);
	    	$("#searchYear").val(arg["searchYear"]);
	    	
	    }
       var sdate = baseYear +"01-01"
		
		
	     $(".close").click(function() {
		    	p.self.close();
	     });

		var initdata = {};
		initdata.Cfg = {/* FrozenCol:6 ,*/SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"일자",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ymd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"구분",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"상세구분",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubunNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"내용",		Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"상벌점",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"승진포인트",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sgPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


		var gubun 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20040"), "전체");
		sheet1.SetColProperty("gubun", 			{ComboText:gubun[0], ComboCode:gubun[1]} );

		$("#searchGubun").html(gubun[2]);

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/CompApp1stApr.do?cmd=getCompApp1stAprPrizePopupList", $("#srchFrm").serialize() );
				break;
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

	<div class="popup_title">
		<ul>
			<li>상벌점 확인</li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
			<div class="sheet_search outer">
				<form id="srchFrm" name="srchFrm" >
				<div>
					<input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
					<input type="hidden" id="searchYear" name="searchYear" value=""/>
					<table>
						<tr><!--
							<td><span>신청일자</span>
								  <input id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">
								      <input id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">

							</td>
							-->
							<td> <span>구분</span>
								<select id="searchGubun" name="searchGubun" class="box" onchange="javascript:doAction1('Search');">

								</select>
							</td>
							<td>
								<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
							</td>
						</tr>
					</table>
				</div>
				</form>
			</div>

        	<div id="tabs">
				<ul class="outer tab_bottom">
				</ul>

					<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
						<tr>
							<td>
								<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
							</td>
						</tr>
					</table>
			</div>

			<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
			</div>
		</div>

</div>
</body>
</html>