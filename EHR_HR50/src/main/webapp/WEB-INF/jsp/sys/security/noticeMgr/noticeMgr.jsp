<%@page import="com.hr.common.util.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- <%@ page import="com.hr.common.util.DateUtil" %> -->
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//IBsheet1 init
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>", 	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>", 	Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},


			{Header:"<sht:txt mid='applSabunV8' mdef='대상자|사번'/>",  Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"sabun",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"대상자|순번",  Type:"Int",   Hidden:1,   Width:60,  Align:"Right",   ColMerge:0, SaveName:"seq",  KeyField:0, Format:"Integer",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='applOrg' mdef='대상자|소속'/>",  Type:"Text",   Hidden:1,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"orgNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikchakNm' mdef='대상자|직책'/>",  Type:"Text",   Hidden:1,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikchakNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applNameV4' mdef='대상자|성명'/>",  Type:"Popup",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"name",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"대상자|호칭",  Type:"Text",   Hidden:Number("${aliasHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"alias",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='applJikgubNm' mdef='대상자|직급'/>",  Type:"Text",   Hidden:Number("${jgHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikgubNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNmV1' mdef='대상자|직위'/>",  Type:"Text",   Hidden:Number("${jwHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikweeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"업무구분|업무구분",  Type:"Text",   Hidden:0,   Width:80,  Align:"Center",   ColMerge:0, SaveName:"nJobCd",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='title_V5006' mdef='제목|제목'/>",  Type:"Text",   Hidden:0,   Width:80,  Align:"Left",   ColMerge:0, SaveName:"nTitle",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='memo_V1778' mdef='내용|내용'/>",  Type:"Text",   Hidden:0,   Width:150,  Align:"Left",   ColMerge:0, SaveName:"nContent",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5000 , Wrap:1, MultiLineText:1 },
			{Header:"<sht:txt mid='sdate_V3644' mdef='시작일|시작일'/>",	Type:"Date",		Hidden:0,	Width:80,		Align:"Center", ColMerge:0,	SaveName:"sdate",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='edate_V5135' mdef='종료일|종료일'/>",	Type:"Date",		Hidden:0,	Width:80,		Align:"Center", ColMerge:0,	SaveName:"edate",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"읽음여부|읽음여부",	Type:"CheckBox",		Hidden:0,	Width:30,		Align:"Center", ColMerge:0,	SaveName:"readYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		$("#searchYmd,#searchSabunNameAlias").bind("keyup", function(event){
			if(event.keyCode == '13') {
				doAction1('Search');
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		$("#searchYmd").datepicker2();
	});



	/* IB시트 함수 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			sheet1.DoSearch( "${ctx}/NoticeMgr.do?cmd=getNoticeMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			//중복 체크 (변수 : "컬럼명|컬럼명")
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/NoticeMgr.do?cmd=saveNoticeMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), "컬럼명");
			break;
		case "Copy":
			sheet1.DataCopy();
        	//sheet1.SetCellValue( Row, "PK컬럼", "" );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		}
	}

	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	// 팝업 클릭시 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			//사원검색
			switch(sheet1.ColSaveName(Col)){
				case "name":
					if(!isPopup()) {return;}

					sheet1.SelectCell(Row,"name");

					gPRow = Row;
					pGubun = "employeePopup";

					openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "840","520");
					break;
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup") {
        	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
        	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
        	sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
        	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        	sheet1.SetCellValue(gPRow, "name", rv["name"]);
        	sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
        	sheet1.SetCellValue(gPRow, "workType", rv["workType"]);
        }
    }
// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#searchYmd").val() == "") {
		alert("<msg:txt mid='109871' mdef='기준일자를 선택하십시오.'/>");
		$("#searchYmd").focus();
		return false;
	}
	return true;
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='104352' mdef='기준일자'/></th>
			<td>
				<input id="searchYmd" name="searchYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
			</td>
			<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
			<td>
				<input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
			</td>
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
					<li class="txt">알림관리</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>
