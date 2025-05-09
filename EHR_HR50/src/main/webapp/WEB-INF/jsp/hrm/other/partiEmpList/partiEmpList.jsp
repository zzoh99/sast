<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:100,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete"},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus"},
			{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Left",	ColMerge:0,	SaveName:"orgNm"},
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"name"},
			{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"resNo", Format:"IdNo"},
			{Header:"<sht:txt mid='sexTypeV1' mdef='성별'/>",	    	Type:"Text"    ,	Hidden:0,	Width:60,	        Align:"Center",	ColMerge:0,	SaveName:"sex"},
			{Header:"<sht:txt mid='jikgubNmV1' mdef='직급명'/>",			Type:"Text"    ,	Hidden:Number("${jgHdn}"),	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"jikgubNm"},
			{Header:"<sht:txt mid='jikweeNmV1' mdef='직위명'/>",			Type:"Text"    ,	Hidden:Number("${jwHdn}"),	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"jikweeNm"},
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"empYmd", Format:"Ymd"},
			{Header:"<sht:txt mid='workYmCntV1' mdef='근속기간'/>",		Type:"Text",		Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"empTerm"},
			{Header:"<sht:txt mid='totCarrMth' mdef='총경력기간'/>",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"empCarrTerm"},
			{Header:"급여사업장명",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"bpNm"},
			{Header:"LOCATION명",	Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"locationNm"},
			{Header:"<sht:txt mid='statusNmV2' mdef='재직상태명'/>",		Type:"Text"    ,	Hidden:0,	Width:80,	        Align:"Center",	ColMerge:0,	SaveName:"statusNm"},
			{Header:"<sht:txt mid='manageNmV1' mdef='사원구분명'/>",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"manageNm"},
			{Header:"<sht:txt mid='jikchakNmV1' mdef='직책명'/>",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"jikchakNm"},
			{Header:"<sht:txt mid='workTypeNmV6' mdef='직군명'/>",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"workTypeNm"},
			{Header:"<sht:txt mid='stfTypeNm' mdef='채용구분명'/>",		Type:"Text"    ,	Hidden:0,	Width:80,	        Align:"Center",	ColMerge:0,	SaveName:"stfTypeNm"},
			{Header:"집전화번호",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"homeTel"},
			{Header:"<sht:txt mid='handPhone_V6736' mdef='핸드폰번호'/>",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"handPhone"},
			{Header:"<sht:txt mid='mailId' mdef='메일주소'/>",		Type:"Text"    ,	Hidden:0,	Width:150,	        Align:"Left",	ColMerge:0,	SaveName:"mailId"},
			{Header:"<sht:txt mid='acaSchNm' mdef='학교명'/>",			Type:"Text"    ,	Hidden:0,	Width:130,	        Align:"Left",	ColMerge:0,	SaveName:"acaSchNm"},
			{Header:"<sht:txt mid='acamajNm' mdef='전공'/>",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"acamajNm"},
			{Header:"<sht:txt mid='acaYn' mdef='졸업구분'/>",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"acaYnNm"},
			{Header:"<sht:txt mid='addr' mdef='주소'/>",			Type:"Text"    ,	Hidden:0,	Width:250,	        Align:"Left",	ColMerge:0,	SaveName:"address"},
			{Header:"회계구분코드",		Type:"Text"    ,	Hidden:0,	Width:80,	        Align:"Center",	ColMerge:0,	SaveName:"branchCd"},
			{Header:"회계구분",			Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"branchNm"},
			{Header:"<sht:txt mid='workType' mdef='직종'/>",			Type:"Text"    ,	Hidden:0,	Width:80,	        Align:"Center",	ColMerge:0,	SaveName:"jikjongNm"},
			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",			Type:"Text"    ,	Hidden:0,	Width:130,	        Align:"Center",	ColMerge:0,	SaveName:"jobNm"},
			{Header:"공통사무",		Type:"Text"    ,	Hidden:1,	Width:130,	        Align:"Left",	ColMerge:0,	SaveName:"taskNm"},
			{Header:"최종직장명",		Type:"Text"    ,	Hidden:0,	Width:150,	        Align:"Left",	ColMerge:0,	SaveName:"cmpNm"},
			{Header:"<sht:txt mid='empType' mdef='입사구분'/>",		Type:"Text"    ,	Hidden:0,	Width:100,	        Align:"Center",	ColMerge:0,	SaveName:"empTypeNm"}
		];


		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetDataRowMerge(1);

		$("#schType").html("<option value='1'>직급별</option><option value='2'>직군별</option><option value='3'>사원구분별</option>");
		$("#searchDate").datepicker2();
		$("#searchDate,#searchSabunNameAlias").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchDate").val() == ""){
				alert("<msg:txt mid='109901' mdef='기준일자를 입력하세요.'/>");
				return;
			}
			sheet1.DoSearch( "${ctx}/PartiEmpList.do?cmd=getPartiEmpListList", $("#srchFrm").serialize() );
			break;
		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td>
							<input id="searchDate" name="searchDate" type="text" class="text required date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
						<td>
							 <input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
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
							<li id="txt" class="txt">인원명부</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
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
