<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='pwrSrchVmMgr' mdef='조건검색View관리'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	/*Sheet 기본 설정 */
	$(function() {
			//배열 선언
			var initdata = {};
			

			//SetConfig
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
			//HeaderMode
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			//InitColumns + Header Title
			initdata.Cols = [
			  	{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete", Sort:0 },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus", Sort:0 },
	        	{Header:"<sht:txt mid='viewCdV2' mdef='View코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"viewCd",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='viewNmV1' mdef='View명'/>",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"viewNm",	KeyField:1,	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
				{Header:"<sht:txt mid='viewDescV1' mdef='View설명'/>",	Type:"Text",	Hidden:0,	Width:220,	Align:"Left",	ColMerge:0,	SaveName:"viewDesc",KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
			];
			//초기화

			IBS_InitSheet(mySheet, initdata);
			mySheet.SetCountPosition(4);
			
			
			$("#viewNm").bind("keyup",function(event){
				if( event.keyCode == 13){
					doAction("Search"); $(this).focus();
				}
			});
			
			$(window).smartresize(sheetResize); sheetInit();
			//mySheet.SetVisible(1);
		    doAction("Search");
		    
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/PwrSrchVwMgr.do?cmd=getPwrSrchVwMgrList", $("#mySheetForm").serialize() );
			break;
		case "Save":		//저장
			IBS_SaveName(document.mySheetForm,mySheet);
			mySheet.DoSave( "${ctx}/PwrSrchVwMgr.do?cmd=savePwrSrchVwMgr", $("#mySheetForm").serialize());
        	break;
        case "Insert":		//입력
            var Row = mySheet.DataInsert(0);
            mySheet.SelectCell(Row, "viewNm");
            break;
        case "Copy":		//행복사
            var Row = mySheet.DataCopy();
            mySheet.SetCellValue(Row, "viewCd", "");
            mySheet.SelectCell(Row, "viewNm");
            break;
        case "Clear":		//Clear
            mySheet.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            mySheet.Down2Excel();
            break;
        case "LoadExcel":   //엑셀업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			mySheet.LoadExcel(params);
            break;
		}
    }

	// 조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function mySheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}

			//Delete KEY
			if (Shift == 1 && KeyCode == 46
					&& mySheet.GetCellValue(Row, "sStatus") == "I") {
				mySheet.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113698' mdef='View 명'/></th>
						<td>
							<input id="viewNm" name ="viewNm" type="text" class="text" />
						</td>
						<td>
							<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
				<li id="txt" class="txt">
					조건검색View관리
					<span><tit:txt mid='112602' mdef='- 설명문구 공간입니다.'/></span>
				</li>
				<li class="btn">
					<btn:a href="javascript:doAction('Copy')" css="btn outline-gray authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction('Save')" css="btn filled authA" mid='110708' mdef="저장"/>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>



