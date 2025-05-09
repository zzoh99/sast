<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>수습종료발령</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var ordTypeCd = "";
	var userCd1 = "";
	$(function() {

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No",	    Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",	   	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택",		Type:"CheckBox",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"check1",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"발령",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령상세",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령일",	 	Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",			KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"소속",      Type:"Text",   		Hidden:0,   Width:150,  Align:"Center", ColMerge:0, SaveName:"orgNm",       	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"재직상태",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"수습종료일",	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",			KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		];

		IBS_InitSheet(sheet1, initdata);

		sheet1.SetEditable(true);
		sheet1.SetVisible(false);
		sheet1.SetCountPosition(4);

		$("#ordYmdFrom").datepicker2().bind("keyup", function(event){

			if (event.keyCode==13) doAction("Search");
		});
		$("#ordYmdTo").datepicker2().bind("keyup", function(event){

			if (event.keyCode==13) doAction("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#ordYmdFrom").val() == "") {
				alert("기준일을 입력하여 주십시오.");
				$("#ordYmdFrom").focus();
				return;
			}
			if($("#ordYmdTo").val() == "") {
				alert("기준일을 입력하여 주십시오.");
				$("#ordYmdTo").focus();
				return;
			}

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getEscapeApprenticeList",$("#sendForm").serialize() );
			break;
		case "Save":

			IBS_SaveName(document.sendForm,sheet1);
			sheet1.DoSave( "${ctx}/EscapeApprentice.do?cmd=saveEscapeApprentice",$("#sendForm").serialize());
			break;
		case "Down2Excel":

			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
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

			if(Code > 0) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sendForm" name="sendForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준일</th>
						<td>
							<input id="ordYmdFrom" name="ordYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
							<input id="ordYmdTo" name="ordYmdTo" type="text" size="10" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
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
				<li class="txt">수습종료발령</li>
				<li class="btn">
					<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
					<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>