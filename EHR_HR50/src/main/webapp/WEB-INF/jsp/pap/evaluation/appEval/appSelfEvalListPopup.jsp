<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>메뉴검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@page import="java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		$("#sabun").val(convertParam.sabun)
		$("#appTypeCd").val(convertParam.appTypeCd);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#txt").html(unescape(convertParam.title));
		var title = unescape(convertParam.title)+"|"+unescape(convertParam.title);
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택",		Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"평가자구분",	Type:"Text",		Hidden:0,		Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appTypeNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:1},
			{Header:"평가차수",	Type:"Text",		Hidden:0,		Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appSeq",			KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"사번",		Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",		Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSabunNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"조직명",		Type:"Text",		Hidden:0,		Width:90,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직책",		Type:"Text",		Hidden:0,		Width:60,	Align:"Left",	ColMerge:0,	SaveName:"appJikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
		]; 
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		
		sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.FitColWidth();

		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		
		$(window).smartresize(sheetResize); sheetInit();
		//var param = '${Param}';
		doAction1("Search");
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/AppEval.do?cmd=getSelfEvalListPopupList1", $("#empForm").serialize());
	            break;
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
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	function onView(){
		//console.log("searchMenuLayer.jsp onView()");
		
		sheetResize();
		//setTimeout(function(){ sheetResize(); $("#searchText").focus();},100);
	}
	
	function checkOpenMenu(s, m){
		//console.log( "Check Menu Open !!");
		var isOpen = false;
		$("#subMenuCont>li, #subMenuCont>li>dl>dt, #subMenuCont>li>dl>dt>dd", parent.document).each(function() {
			if( $(this).attr("menuId") == m ) {
				isOpen = true;
			}
		});
		if( isOpen ){
			//console.log( "Check Menu Open !! true");
			parent.openSubMenuCd(s, m);
			return true;
		} else{
			//console.log( "Check Menu Open !! false");
			return setTimeout(function(){ checkOpenMenu(s, m) }, 500 ); 
		}
				
	}
	
</script>

</head>
<body>
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="sabun" name="sabun"/>
		<input type="hidden" id="appSabun" name="appSabun"/>
		<input type="hidden" id="appTypeCd" name="appTypeCd"/>
		<input type="hidden" id="appraisalCd" name="appraisalCd"/>	
	</form>
	<!-- 
	<div class="outer">
		<table class="table">
		<colgroup>
			<col width="80" />
			<col width="" />
			<col width="50" />
		</colgroup>
		<tr>
			<th>메뉴명</th>
			<td>
				<input type="text" id="searchText" name="searchText" class="text w90p center" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
			</td>
		</tr>
		</table>
	</div>         
	<div class="h10 outer"></div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	 -->
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"></li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Search')" class="basic">조회</a> -->
								<a href="javascript:doAction1('Down2Excel')" 	class="basic">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>	
</div>
</body>
</html>



