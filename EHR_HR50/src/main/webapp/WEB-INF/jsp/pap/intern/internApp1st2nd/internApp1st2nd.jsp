<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>수습1차,2차평가</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No"		,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제|삭제"	,Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태|상태"	,Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			{Header:"평가|평가"			,Type:"Image",		Hidden:0,  Width:50,   Align:"Center",	ColMerge:0,   SaveName:"detail",			KeyField:0,   CalcLogic:"",	  Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"성명|성명"			,Type:"Popup",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번|사번"			,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"호칭|호칭"			,Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"alias",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"소속|소속"			,Type:"Text",		Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급|직급"			,Type:"Text",		Hidden:Number("${jgHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위|직위"			,Type:"Text",		Hidden:Number("${jwHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"입사일|입사일"		,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"gempYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"수습만료일|수습만료일"	,Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"traYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"완료여부|완료여부"		,Type:"Text",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"appraisal1stYn",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"진행상태|1차"			,Type:"Text",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"status1stYn",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"진행상태|2차"			,Type:"Text",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"status2ndYn",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },

			{Header:"소속코드|소속코드"		,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위코드|직위코드"		,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikgubCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"직책코드|직책코드"		,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"직책|직책"			,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"근무지코드|근무지코드"	,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"locationCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(1); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");
		sheet1.SetDataLinkMouse("detail",1);

		if ( $("#searchAppSeqCd").val() == "1" ) {
			sheet1.SetColHidden("appraisal1stYn", 0);
			sheet1.SetColHidden("status1stYn", 1);
			sheet1.SetColHidden("status2ndYn", 1);

			$("#spanTitle").html("수습1차평가");

		} else {
			sheet1.SetColHidden("appraisal1stYn", 1);
			sheet1.SetColHidden("status1stYn", 0);
			sheet1.SetColHidden("status2ndYn", 0);

			$("#spanTitle").html("수습2차평가 ");
		}

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchSabun").val("${sessionScope.ssnSabun}");
		$("#searchName").val("${sessionScope.ssnName}");
		$("#searchOrgNm").val("${sessionScope.ssnOrgNm}");
		$("#searchJikgubNm").val("${sessionScope.ssnJikgubNm}");
		$("#searchJikweeNm").val("${sessionScope.ssnJikweeNm}");

		if ( "${sessionScope.ssnPapAdminYn}" == "Y" ) {
			$("#btnSabunPop").show();
			$("#btnSabunClear").show();
		} else {
			$("#btnSabunPop").hide();
			$("#btnSabunClear").hide();
		}

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/InternApp1st2nd.do?cmd=getInternApp1st2ndList", $("#srchFrm").serialize() ); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row >= sheet1.HeaderRows()){
				if(sheet1.ColSaveName(Col) == "detail" && sheet1.GetCellValue(Row, "sStatus") != "" ){
					if(!isPopup()) {return;}

					if ( $("#searchAppSeqCd").val() == "2" ) {
						if ( sheet1.GetCellValue(Row, "status1stYn") == "N" ) {
							alert("1차평가가 완료되지 않았습니다.");
							return;
						}
					}

		     		var args = new Array();
					var authPg = "";
					if ( $("#searchAppSeqCd").val() == "1" && (sheet1.GetCellValue(Row, "status1stYn") == "Y" || sheet1.GetCellValue(Row, "status2ndYn") == "Y") ) {
						authPg = "R";
					} else if ( $("#searchAppSeqCd").val() == "2" && sheet1.GetCellValue(Row, "status2ndYn") == "Y" ) {
						authPg = "R";
					} else {
						authPg = "A";
					}

		     		args["appSeqCd"] = $("#searchAppSeqCd").val();
					args["sabun"] = sheet1.GetCellValue(Row, "sabun");
					args["traYmd"] = sheet1.GetCellValue(Row, "traYmd");

					gPRow = Row;
					pGubun = "internApp1st2ndPop";

					var layer = new window.top.document.LayerModal({
						id : 'internApp1st2ndPopLayer'
						, url : "${ctx}/InternApp1st2nd.do?cmd=viewInternApp1st2ndPop&authPg="+authPg
						, parameters: args
						, width : 1000
						, height : 700
						, title : "수습평가팝업"
						, trigger :[
							{
								name : 'internApp1st2ndPopTrigger'
								, callback : function(rv){
									getReturnValue(rv);
								}
							}
						]
					});
					layer.show();

		     	}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//사원 팝업
	function employeePopup(){
		try{
			var args = new Array();

			gPRow = "";
			pGubun = "searchEmployeePopup";

			var layer = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : "${ctx}/Popup.do?cmd=employeePopup"
				, parameters: args
				, width : 1000
				, height : 700
				, title : "사원조회"
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(rv){
							getReturnValue(rv);
						}
					}
				]
			});
			layer.show();

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {
        if(pGubun == "internApp1st2ndPop"){
        	if(rv["Code"] == "1") {
         		doAction1("Search");
        	}
        } else if(pGubun == "searchEmployeePopup") {
			$("#searchName").val(rv["name"]);
			$("#searchSabun").val(rv["sabun"]);
			$("#searchOrgNm").val(rv["orgNm"]);
			$("#searchJikgubNm").val(rv["jikgubNm"]);
			$("#searchJikweeNm").val(rv["jikweeNm"]);
			doAction1("Search");
        }
	}

</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value="${map.searchAppSeqCd}" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td><span>성명 </span>
							<input id="searchSabun" name ="searchSabun" type="hidden" />
							<input id="searchName" name ="searchName" type="text" class="text readonly " readonly />
							<a onclick="javascript:employeePopup('searchName');" class="button6" id="btnSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName,#searchOrgNm,#searchJikgubNm,#searchJikweeNm').val('');" class="button7" id="btnSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td><span>소속 </span>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly w150" readOnly />
						</td>

	<c:if test="${ssnJikweeUseYn == 'Y'}">
						<td><span>직위 </span>
							<input id="searchJikweeNm" name ="searchJikweeNm" type="text" class="text readonly" readOnly />
						</td>
	</c:if>
	<c:if test="${ssnJikgubUseYn == 'Y'}">
						<td><span>직급 </span>
							<input id="searchJikgubNm" name ="searchJikgubNm" type="text" class="text readonly" readOnly />
						</td>
	</c:if>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
							<li id="txt" class="txt"><span id="spanTitle"></span></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>