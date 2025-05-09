<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>테스트 연말정산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",      	Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),		Width:"<%=sNoWdt%>",		Align:"Center",	ColMerge:0,		SaveName:"sNo"},
			{Header:"삭제",    	Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",		Align:"Center",	ColMerge:0,		SaveName:"sDelete",		Sort:0},
			{Header:"상태",    	Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>",		Align:"Center",	ColMerge:0,		SaveName:"sStatus",	Sort:0},
			{Header:"그룹\n코드",	Type:"Text",		Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"grcode_cd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"코드명",		Type:"Text",		Hidden:0,	Width:100,		Align:"Left",	ColMerge:0,	SaveName:"grcode_nm",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Header:"코드설명",		Type:"Text",		Hidden:0,	Width:200,		Align:"Left",	ColMerge:0,	SaveName:"grcode_full_nm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"코드영문명",	Type:"Text",		Hidden:1,	Width:0,		Align:"Left",	ColMerge:0,	SaveName:"grcode_eng_nm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"구분",		Type:"Combo",		Hidden:0,	Width:80,		Align:"Center", ColMerge:0,	SaveName:"type",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"세부\n코드수",	Type:"Text",		Hidden:0,	Width:40,		Align:"Center", ColMerge:0,	SaveName:"sub_cnt",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);

		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetColProperty("type", {ComboText:"세부코드|세부고정코드", ComboCode:"C|N"} );

 		$(window).smartresize(sheetResize);
		sheetInit();

		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "cmd=search&srchGrpCd="+$("#srchGrpCd").val();
			sheet1.DoSearch("<%=jspPath%>/test/testSelectRst.jsp", param );
			break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
			    if(!dupChk(sheet1,"grcode_cd", true, true)){break;}
			}

			var param = "cmd=save";
			sheet1.DoSave("<%=jspPath%>/test/testSelectRst.jsp", param);
		    break;
		case "Insert":
			//var param = [];
			//param["test"] = "1111";
			//openPopup("../test/testSelect.jsp",param,500);
			sheet1.SelectCell(sheet1.DataInsert(0), 2);
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
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1('Search');
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function setEmpPage() {
		alert($("#searchUserId").val());
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>

	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td>
					<span>그룹코드</span>
					<input id="srchGrpCd" name="srchGrpCd" type="text" class="text" />
				</td>
				<td>
					<a href="#" id="srchBtn" onclick="javascript:doAction1('Search')" class="button">조회</a>
				</td>
			</tr>
		</table>
		</div>
	</div>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">코드그룹관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="basic authA">복사</a>
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