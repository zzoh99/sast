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
		initdata.Cfg = {SearchMode:smLazyLoad,Page:500,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1,AutoSumCalcMode:1};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='appIndexGubunCd1' mdef='구분|구분'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"건재|부문",			Type:"AutoSum",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"material",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"건재|공통",			Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"materialCommon",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"건설|부문",			Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"const",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"건설|공통",			Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"constCommon",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"플랜트|부문",		Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"plant",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"플랜트|공통",		Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"plantCommon",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"전체|부문",			Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"total",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, CalcLogic:"|material|+|const|+|plant|" },
			{Header:"전체|공통",		Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"totalCommon",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 , CalcLogic:"|materialCommon|+|constCommon|+|plantCommon|" }
		];

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetDataRowMerge(0);
	    sheet1.SetSumValue("jikweeNm", "합계") ;

		$("#schDate").datepicker2();
		$("#schDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OrgEmpStat.do?cmd=getOrgEmpStatList", $("#srchFrm").serialize() );
			break;
		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
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
							<input id="schDate" name="schDate" type="text" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='2017040700014' mdef='부문별인원현황'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
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
