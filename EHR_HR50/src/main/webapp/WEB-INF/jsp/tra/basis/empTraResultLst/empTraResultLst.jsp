<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		//{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
		{Header:"조회년도|조회년도",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalYy",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"sabun",         KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		{Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"name",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		{Header:"기준년도|영문약자",             	Type:"Text", Hidden:Number("${aliasHdn}"), Width:80 , Align:"Center", ColMarge:1,  SaveName:"alias",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"<sht:txt mid='appOrgNmV6' mdef='소속|소속'/>",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"orgNm",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"<sht:txt mid='jikgubCdV1' mdef='직급|직급'/>",               	Type:"Text", Hidden:Number("${jgHdn}"), Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",               	Type:"Text", Hidden:Number("${jwHdn}"), Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"<sht:txt mid='jikchakCdV1' mdef='직책|직책'/>",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikchakNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"<sht:txt mid='empYmdV1' mdef='입사일|입사일'/>",              	Type:"Date", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"empYmd",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"<sht:txt mid='jikgubYeuncha_V5385' mdef='직급년차|직급년차'/>",              	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubYeuncha",    KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},


 		{Header:"이수결과 (교육과정수)|년도2",       	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"eduHour2",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"이수결과 (교육과정수)|년도1",       	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"eduHour1",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"이수결과 (교육과정수)|년도0",       	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"eduHour0",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetMergeSheet( msHeaderOnly);



		var sOption = "";
		var nowYY = parseInt("${curSysYear}", 10);
		for(var i = nowYY-5 ; i < nowYY+5; i++) {
			if ( i == nowYY ) sOption += "<option value='"+ i +"' selected>"+ i +"</option>";
			else sOption += "<option value='"+ i +"'>"+ i +"</option>";
		}
		$("#appraisalYy").html(sOption);

		$("#appraisalYy").bind("change",function(event){
			doAction1("Search");
		});

        $("#searchNmSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//doAction2("Clear");
			sheet1.SetCellText(1, "eduHour2", $("#appraisalYy").val() - 2 +"년도");
			sheet1.SetCellText(1, "eduHour1", $("#appraisalYy").val() - 1 +"년도");
			sheet1.SetCellText(1, "eduHour0", $("#appraisalYy").val() +"년도");
			sheet1.DoSearch( "${ctx}/EmpTraResultLst.do?cmd=getEmpTraResultLst", $("#srchFrm").serialize() );
			break;

		case "Down2Excel":
			sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY

		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114464' mdef='조회년도'/></th>
						<td>
							<SELECT id="appraisalYy" name="appraisalYy" class="box"></SELECT>
						</td>
						<th><tit:txt mid='112947' mdef='성명/사번'/></th>
						<td>
							<input id="searchNmSabun" name ="searchNmSabun" type="text" class="text" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='empTraResultLst' mdef='직원교육이수결과조회'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
