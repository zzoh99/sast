<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		EMP_INFO_CHANGE_TABLE_SHEET["thrm100"] = sheet1;
		//event
		$("#searchEmpTable, #searchPrgCd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            			
			{Header:"<sht:txt mid='empTable' mdef='테이블'/>", 	Type:"Text",    	Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"empTable",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='authScopeCdV3' mdef='테이블명'/>", Type:"Text",    	Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"empTableNm",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='prgCd_V6500' mdef='프로그램ID'/>", Type:"Text",    	Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"prgCd",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='proGubun' mdef='처리구분'/>", Type:"Combo",    	Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"transType",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='multirowYn' mdef='다건입력여부'/>", Type:"CheckBox",    Hidden:0,   Width:30,  	Align:"Center", ColMerge:0, SaveName:"multirowYn",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='useYnV1' mdef='변경신청\n사용여부'/>", Type:"CheckBox",    Hidden:0,   Width:30,  	Align:"Center", ColMerge:0, SaveName:"useYn",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"조회기능\n사용여부", Type:"CheckBox",    Hidden:0,   Width:30,  	Align:"Center", ColMerge:0, SaveName:"displayYn",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='infoSeq' mdef='순번'/>", 	Type:"Text",    	Hidden:0,   Width:30,  	Align:"Center", ColMerge:0, SaveName:"seq",       KeyField:1, Format:"Number",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:0 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>", 	Type:"Text",    	Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"note",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		
		
		sheet1.SetColProperty("transType", 		{ComboText:"|입력|수정|삭제|입력,삭제|입력,수정|수정,삭제|입력,수정,삭제", ComboCode:"|I|U|D|ID|IU|UD|IUD"} );

		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeTableMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							if(!dupChk(sheet1,"empTable", true, true)){break;}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpInfoChangeTableMgr", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "mailType"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } /* doAction1("Search"); */ } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
			
				gPRow = Row;
				pGubun = "employeePopup";

				var win = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
		
		if(pGubun == "employeePopup") {
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"sabun",rv.sabun);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"name",rv.name);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"orgNm",rv.orgNm);
	    	sheet1.SetCellValue(sheet1.GetSelectRow(),"jikgubNm",rv.jikgubNm);
	    }
	
	}

</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>	
						<th><tit:txt mid='112835' mdef='테이블명/테이블ID '/></th>		
						<td>  <input type="text" class="text" id="searchEmpTable" name="searchEmpTable"></td>
						<th><tit:txt mid='113210' mdef='프로그램ID '/></th>
						<td>  <input id="searchPrgCd" name ="searchPrgCd" type="text" class="text"  /> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='113559' mdef='사원정보변경기준관리'/></li>
							<li class="btn _thrm100">
								<btn:a href="javascript:doAction1('Insert')" css="btn outline_gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline_gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline_gray authR" mid='down2excel' mdef="다운로드"/>
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
