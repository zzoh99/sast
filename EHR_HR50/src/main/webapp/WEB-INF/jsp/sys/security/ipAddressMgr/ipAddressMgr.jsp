<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>공인IP관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("#searchDate").datepicker2();
		$("#searchDate").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		init_sheet();


		doAction1("Search");
	});


	function init_sheet(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"IP대역|~부터",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ipAddress",	KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1, AcceptKeys:"N|[.]"},
			{Header:"IP대역|~까지",	Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ipAddressEnd",KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1, AcceptKeys:"N|[.]", MinimumValue:0, MaximumValue:255, EditLen:3},
			{Header:"IP갯수|IP갯수",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ipCnt",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1},
			{Header:"시작일|시작일",	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1, EndDateCol:"edate"},
			{Header:"종료일|종료일",	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1, StartDateCol:"sdate"},
			{Header:"비고|비고",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1},

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);



		$(window).smartresize(sheetResize); sheetInit();
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

				if($("#searchDate").val() == ""){
					alert("기준일은 필수조회 조건 입니다.");
					$("searchDate").foccs();
					return false;
				}

				sheet1.DoSearch( "${ctx}/IpAddressMgr.do?cmd=getIpAddressMgrList", $("#sheet1Form").serialize() );

				break;
		case "Save":
			if(!chkInVal()){break;}
			if(!dupChk(sheet1,"ipAddress|sdate", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/IpAddressMgr.do?cmd=saveIpAddressMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
		case "DownTemplate":
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"3|4|5|6|7|8"});
			break;
			break;
		}
	}


	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>기준일</th>
					<td>
						<input type="text" id="searchDate" name="searchDate" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
					</td>
					<td> <btn:a href="javascript:doAction1('Search');" css="btn dark authR" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">IP관리</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('DownTemplate')" 	class="btn outline-gray authA" >양식다운로드</a>
					<a href="javascript:doAction1('LoadExcel')" 	class="btn outline-gray authA" >업로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>