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
			
			{Header:"<sht:txt mid='appIndexGubunCd1' mdef='구분|구분'/>",  Type:"Combo",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"noticeTypeCd",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='workTypeNmV4' mdef='직군|직군'/>",  Type:"Combo",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"workType",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='applSabunV8' mdef='대상자|사번'/>",  Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"sabun",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applOrg' mdef='대상자|소속'/>",  Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"orgNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applJikchakNm' mdef='대상자|직책'/>",  Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikchakNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applNameV4' mdef='대상자|성명'/>",  Type:"Popup",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"name",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"대상자|호칭",  Type:"Text",   Hidden:Number("${aliasHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"alias",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applJikgubNm' mdef='대상자|직급'/>",  Type:"Text",   Hidden:Number("${jgHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikgubNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applJikweeNmV1' mdef='대상자|직위'/>",  Type:"Text",   Hidden:Number("${jwHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikweeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		initPage();

		$(window).smartresize(sheetResize); sheetInit();
// 		doAction1("Search");
	});

	// 기본 화면설정
	function initPage(){

		//구분
        var noticeType  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90200"), "<tit:txt mid='103895' mdef='전체'/>");
        //직군
		var workType  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");

		sheet1.SetColProperty("noticeTypeCd", {ComboText:"|"+noticeType[0], ComboCode:"|"+noticeType[1]} );
		sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]} );
		
		$("#searchNoticeTypeCd").html(noticeType[2]);
		
		$("#searchSabunNameAlias").bind("keyup", function(event){
			if(event.keyCode == '13') {
				doAction1('Search');
			}
		});
		
	}

	/* IB시트 함수 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/NoticeTargetMgr.do?cmd=getNoticeTargetMgrList", $("#srchFrm").serialize() ); 
			break;
		case "Save":
			//중복 체크 (변수 : "컬럼명|컬럼명")
        	if(!dupChk(sheet1,"", true, true)){break;}
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/NoticeTargetMgr.do?cmd=saveNoticeTargetMgr", $("#srchFrm").serialize());
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
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param); 
			break;
		case "DownTemplate":
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"#|#"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params); 
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

			//작업

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
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>알림구분 </th> 
			<td>
				<select id="searchNoticeTypeCd" name="searchNoticeTypeCd" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
			<td>
				<input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
					<li class="txt">알림대상자관리</li>
					<li class="btn">
						<a href="javascript:doAction1('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
						<a href="javascript:doAction1('Copy')" 	class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
						<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
						<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
