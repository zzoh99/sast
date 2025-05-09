<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>경력목표 세부내역</title>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var headerStartCnt = 0;
	var locationCdList = "";
	var p = eval("${popUpStatus}");

	var arg = p.popDialogArgumentAll();

	var searchCareerTargetCd = arg['careerTargetCd'];
	var careerTargetNm       = arg['careerTargetNm'];

	var gPRow  = "";
	var popGubun = "";

	$(function() {


		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});


		$("#title").html(careerTargetNm + " 경력경로 미리보기");


		var titleList = ajaxCall("${ctx}/CareerPathPreView.do?cmd=getCareerPathPreViewTitleList", $("#sheetForm").serialize(), false);

		if (titleList != null && titleList.DATA != null) {

			var v=0;
			var initdata = {};
			initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

			initdata.Cols = [];
			initdata.Cols[v++] = {Header:"<sht:txt mid='BLANK' mdef='단계'/>" ,	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"level",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

			var i = 0 ;

			for(; i<titleList.DATA.length; i++) {
				initdata.Cols[v++] = {Header:titleList.DATA[i].codeNm,	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:titleList.DATA[i].saveNameDisp,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
				initdata.Cols[v++] = {Header:titleList.DATA[i].codeNm,	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:titleList.DATA[i].saveNameDispNm,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			}

			IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			$(window).smartresize(sheetResize); sheetInit();
		}

		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch("${ctx}/CareerPathPreView.do?cmd=getCareerPathPreViewList", $("#sheetForm").serialize()+"&searchCareerTargetCd="+searchCareerTargetCd);
				break;

		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{

			gPRow = Row;
			var colName = sheet1.ColSaveName(Col);
			var args    = new Array();
			var rv = null;

			console.log(colName, colName.substr(-2))

			if(colName.substr(-2) == "nm") {
				careerPathWorkAssnStatPopup(Row, Col);
			}

		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg, responseText) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	function careerPathWorkAssnStatPopup(Row,Col) {
		if (!isPopup()) {
			return;
		}

		var colName = sheet1.ColSaveName(Col-1);

		var w = 860;
		var h = 600;
		var url = "${ctx}/CareerPathWorkAssignStat.do?cmd=viewCareerPathWorkAssignStat&authPg=${authPg}";
		var args = new Array();

		args["careerTargetType" ] = sheet1.GetCellValue(Row, "searchCareerTargetCd");
		args["careerTargetNm"   ]   = careerTargetNm;
		args["jobCd"            ]   = sheet1.GetCellValue(Row, colName);;

		gPRow = Row;
		pGubun = "careerPathWorkAssnStatPopup";

		openPopup(url, args, w, h);
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if( popGubun == "O"){
			$("#searchOrgCd").val(rv["orgCd"]);
        	$("#searchOrgNm").val(rv["orgNm"]);
        	doAction1("Search");
        }else if( popGubun == "E"){
   			$('#name').val(rv["name"]);
   			$('#searchSabun').val(rv["sabun"]);
   	    	doAction1("Search");
        }else if ( popGubun == "insert"){
			sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",			rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "alias",			rv["alias"] );
			sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",		rv["jikchakNm"] );
			sheet1.SetCellValue(gPRow, "manageNm",		rv["manageNm"] );
	        sheet1.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
	        sheet1.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
        }
	}


</script>
</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm" method="post">
	<input type=hidden id="fileSeq"   	name="fileSeq">
</form>

<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li><span id="title"></span></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
<%--					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="btn">
									<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
								</li>
							</ul>
						</div>
					</div>--%>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<%--<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>--%>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>

	</div>

</div>
</body>
</html>
