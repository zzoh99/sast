<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

$(function() {
	initSheet1();

	$("#searchKeyword1, #searchKeyword2").bind("keyup",function(event){
		if( event.keyCode == 13){
			doAction1("Search");
			$(this).focus();
		}
	});
});

/**
 * 출력 window open event
 * 레포트 공통에 맞춘 개발 코드 템플릿
 * by JSG
 */
function rdPopup(searchSabun){

	var rv = "enterCd=${ssnEnterCd}"
			+"&sabun="+searchSabun;
	var data = ajaxCall("/EmpKeywordSearch.do?cmd=getEmpCardPrtRk", rv, false);
	if ( data != null && data.DATA != null ){
		const rdData = {
			rk : data.DATA.rk
		};
		window.top.showRdLayer('/EmpKeywordSearch.do?cmd=getEmpCardEncryptRd', rdData, null, "인사카드");
	}
}	

</script>

<script type="text/javascript">
function initSheet1(){
	var initdata = {};
	initdata.Cfg = {FrozenCol:3,SearchMode:smLazyLoad,Page:22}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		//{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		//{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"인사카드",		Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"selectImg",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"소속",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"사번",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"성명",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"직위",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"직책",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"재직상태",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
		{Header:"비고",			Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 }
		
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
	
	sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	
	sheet1.SetDataLinkMouse("selectImg", 1);
	
	$(window).smartresize(sheetResize); sheetInit();
}

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search":		
		if ( $("#searchKeyword1").val().trim().length < 2 ) {
			alert("키워드를 2글자 이상 입력해 주세요");
			$("#searchKeyword1").focus();
			return;
		}
		
		if ( $("#searchKeyword2").val().trim().length == 1 ) {
			alert("키워드를 2글자 이상 입력해 주세요");
			$("#searchKeyword2").focus();
			return;
		}
		
		sheet1.DoSearch( "${ctx}/EmpKeywordSearch.do?cmd=getEmpKeywordSearchList", $("#srchFrm").serialize() ); break;
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
		if(Msg != "")		alert(Msg);
		sheetResize(); 
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex); 
	}
}

function sheet1_OnClick(Row, Col, Value){
	try{
		if( sheet1.ColSaveName(Col) == "selectImg" ) {
			rdPopup( sheet1.GetCellValue(Row, "sabun") );
		}
	}catch(ex){alert("OnClick Event Error : " + ex);}
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
						<th>키워드1</th>
						<td>
							<input id="searchKeyword1" name ="searchKeyword1" value="" type="text" class="text" />
						</td>
						<th>키워드2</th>
						<td>
							<input id="searchKeyword2" name ="searchKeyword2" value="" type="text" class="text" />
						</td>
						<td>
							<input id="searchStatusCd" name="searchStatusCd" type="radio" value="RA" checked>퇴직자 제외
							<input id="searchStatusCd" name="searchStatusCd"  type="radio" value="" >퇴직자 포함
						</td>
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
							<li id="txt" class="txt">키워드검색</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"	class="btn outline-gray authR">다운로드</a>
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