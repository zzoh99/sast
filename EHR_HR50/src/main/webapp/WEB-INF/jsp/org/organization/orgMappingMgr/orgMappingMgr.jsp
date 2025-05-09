<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		//조직도 select box
		var orgSchemeSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchOrgSchemeSdate").html(orgSchemeSdate[2]);

		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});

        $("#searchOrgSchemeSdate").bind("change",function(event){
        	doAction1("Search");
        });
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff(0);

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"<sht:txt mid='mapTypeCd' mdef='조직맵핑구분'/>",	Type:"Combo",     Hidden:0,  Width:95,   Align:"Center",  ColMerge:0,   SaveName:"mapTypeCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='mapCd' mdef='조직맵핑코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mapCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mapCdV2' mdef='조직맵핑명'/>",	Type:"Popup",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"mapNm",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",        KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13, EndDateCol: "edate" },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",		Type:"Date",  	  Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13, StartDateCol: "sdate" }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var mapTypeCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20020"), "");	//조직맵핑구분
		sheet2.SetColProperty("mapTypeCd", 			{ComboText:mapTypeCd[0], ComboCode:mapTypeCd[1]} );	//조직맵핑구분

		$(window).smartresize(sheetResize); sheetInit();
		sheet2.SetFocusAfterProcess(0);

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/OrgMappingMgr.do?cmd=getOrgMappingMgrSheet1List", $("#srchFrm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	//if(document.getElementById("searchOrgType").checked == false){
						//		sheet2.DoSearch( "${ctx}/OrgMappingMgr.do?cmd=getOrgMappingMgrSheet2List1", $("#srchFrm").serialize() );
						//	} else {
					//			sheet2.DoSearch( "${ctx}/OrgMappingMgr.do?cmd=getOrgMappingMgrSheet2List2", $("#srchFrm").serialize() );
					//		}
							sheet2.DoSearch( "${ctx}/OrgMappingMgr.do?cmd=getOrgMappingMgrSheet2List1", $("#srchFrm").serialize() );
		                    break;
		case "Save":
			if (!chkInVal()) {break;}
			if (!dupChk(sheet1,"orgCd|mapTypeCd|mapCd|sdate", false, true)){break;}
			//if (!dupDbChk()) {break;}

			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave( "${ctx}/OrgMappingMgr.do?cmd=saveOrgMappingMgr", $("#srchFrm").serialize() ); break;
		case "Insert":		var Row = sheet2.DataInsert(sheet2.LastRow()+1);
							sheet2.SelectCell(Row, "name");
					        sheet2.SetCellValue(Row, "orgCd",$("#searchOrgCd").val());
					        sheet2.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					        sheet2.SetCellValue(Row, "mapTypeCd", "");
							break;
		case "Copy":		
			var row = sheet2.DataCopy(); 
	        sheet2.SetCellValue(Row, "edate", "");
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	function dupDbChk(){
		for (var i=1; i<=sheet2.LastRow(); i++){
			if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U"){
				var param = "ssnEnterCd=${ssnEnterCd}"
						  + "&searchOrgCd="    +sheet2.GetCellValue(i, "orgCd")
						  + "&searchMapTypeCd="+sheet2.GetCellValue(i, "mapTypeCd")
						  + "&searchMapCd="    +sheet2.GetCellValue(i, "mapCd")
						  + "&searchSdate="    +sheet2.GetCellValue(i, "sdate")
						  + "&searchEdate="    +sheet2.GetCellValue(i, "edate");
				var dupCnt = ajaxCall("${ctx}/OrgMappingMgr.do?cmd=getOrgMappingMgrDupCheckMap", param, false);

				if (dupCnt != null && dupCnt.DATA.cnt != null && dupCnt.DATA.cnt > 0) {
					sheet2.SetSelectRow(i);
					alert("<msg:txt mid='alertOrgMappingDate' mdef='해당기간에 조직맵핑 자료가 존재합니다.'/>");
					return false;
				}

			}
		}
		return true;
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet2.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U") {
				if (sheet2.GetCellValue(i, "edate") != null && sheet2.GetCellValue(i, "edate") != "") {
					var sdate = sheet2.GetCellValue(i, "sdate");
					var edate = sheet2.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet2.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
	    	$("#searchOrgCd").val(sheet1.GetCellValue(NewRow, "orgCd"));

	    	/*disabled cell에 대한 선택된 색상 변경 로직 : 공통에서 작업키로 함
	    	var oldColor = sheet1.GetRowBackColor(NewRow) ;
	    	sheet1.SetRowBackColor(NewRow,"#5ADCF3");
	    	sheet1.SetRowBackColor(OldRow,"#F4F4F4");*/
	    	doAction2("Search");
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); 
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
			if( Code > -1 ) doAction2("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet2_OnChange(Row, Col, Value) {
		try{
			if( sheet2.ColSaveName(Col) == "sdate" &&
				sheet2.GetCellValue(Row, "edate") != "" &&
				Value > sheet2.GetCellValue(Row, "edate") ){

				alert("<msg:txt mid='109833' mdef='시작일이 종료일보다 큽니다.'/>") ;
			}
			if( sheet2.ColSaveName(Col) == "edate" &&
				sheet2.GetCellValue(Row, "sdate") != "" &&
				sheet2.GetCellValue(Row, "sdate") > Value ){

				alert("<msg:txt mid='109757' mdef='종료일이 시작일보다 작습니다.'/>") ;
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		try {
			if(sheet2.ColSaveName(Col) == "mapNm") {
				orgMappingItemPopup(Row) ;
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}


	//  조직구분항목 조회
	var gPRow = "";
	function orgMappingItemPopup(Row){
	    try{
	    	if(!isPopup()) {return;}
			gPRow = Row;
	     	var args    = new Array();
	     	var layer = new window.top.document.LayerModal({
	              		id : 'orgMappingItemLayer'
	                  , url : '/Popup.do?cmd=viewOrgMappingItemLayer&authPg=${authPg}'
	                  , width : 875
	                  , height : 520
	                  , title : "<tit:txt mid='112707' mdef='조직구분항목 조회'/>"
	                  , trigger :[
	                      {
	                            name : 'orgMappingItemLayerTrigger'
	                          , callback : function(result){
	                        	  sheet2.SetCellValue(gPRow, "mapTypeCd",	result["mapTypeCd"]);
		                          sheet2.SetCellValue(gPRow, "mapCd",		result["mapCd"]);
		                          sheet2.SetCellValue(gPRow, "mapNm",		result["mapNm"]);
	                          }
	                      }
	                  ]
	              });
	     	layer.show();
	    } catch(ex){alert("Open Popup Event Error : " + ex);}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='orgSchemeMgr' mdef='조직도'/>  </th>
						<td>  <select id="searchOrgSchemeSdate" name ="searchOrgSchemeSdate"></select> </td>
						<td>  <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="40%" />
		<col width="60%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='112713' mdef='조직도'/>
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>

					</li>
					<li class="btn">
						<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" />
						<span><tit:txt mid='113256' mdef='하위부서포함'/></span>&nbsp;&nbsp;
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='orgMapping' mdef='조직매핑'/>
					</li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
						<btn:a href="javascript:doAction2('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction2('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction2('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>

					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
	</form>
</div>
</body>
</html>
