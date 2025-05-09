<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchFromYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchToYmd"});		
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",    Hidden:1,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"detail", 		Sort:0 ,	  Cursor:"Pointer" },
            {Header:"<sht:txt mid='bbsCd_V659' mdef='게시판ID'/>",	Type:"Combo",    Hidden:0,  Width:100, 	Align:"Center", ColMerge:0,   SaveName:"bbsCd",   		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",		Type:"Combo",    Hidden:0,  Width:100,	Align:"Center", ColMerge:0,   SaveName:"gbCd",    		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },            
            {Header:"<sht:txt mid='key' mdef='KEY'/>",		Type:"Text",     Hidden:0,  Width:80,  Align:"Center", ColMerge:0,   SaveName:"key", 			KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2000 },
            {Header:"VALLUE",	Type:"Text",     Hidden:0,  Width:80, 	Align:"Center", ColMerge:0,   SaveName:"value",  		KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2000 },
            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Date",     Hidden:0,  Width:70,  Align:"Center", 	ColMerge:0,   SaveName:"sdate",			KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",		Type:"Date",     Hidden:0,  Width:70,  Align:"Center", 	ColMerge:0,   SaveName:"edate",       	KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		var bbsCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTSYS700bbsCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		var gbCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S92100"), "<tit:txt mid='103895' mdef='전체'/>");	//구분

		
		sheet1.SetColProperty("bbsCd", 			{ComboText:bbsCdList[0], ComboCode:bbsCdList[1]} ) ;
		sheet1.SetColProperty("gbCd", 			{ComboText:gbCdList[0], ComboCode:gbCdList[1]} ) ;
		
		$("#searchBbsCd").html(bbsCdList[2]);
		$("#searchSchGubunCd").html(gbCdList[2]);

		$("#searchTitle").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#searchSchGubunCd").change(function(){
			doAction1("Search");
		});	
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/SysBoradStdMgr.do?cmd=getSysBoradStdMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/SysBoradStdMgr.do?cmd=saveSysBoradStdMgr", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "schGubunCd"); break;
		case "Copy":		
			var Row = sheet1.DataCopy();
		    sheet1.SetCellValue(Row,"seq","");	  
		    break;
		
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
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	sysBoradStdMgrPopup(Row);    
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}		
	}
	
	/**
	 * 상세내역 window open event
	 */
	function sysBoradStdMgrPopup(Row){
  		var w 		= 640;
		var h 		= 450;
		var url 	= "${ctx}/SysBoradStdMgrPopup.do?cmd=viewSysBoradStdMgrPopup&authPg=${authPg}";
		var args 	= new Array();
		args["seq"] 	= sheet1.GetCellValue(Row, "seq");
		args["schGubunCd"] 		= sheet1.GetCellValue(Row, "schGubunCd");
		args["sdate"] 	= sheet1.GetCellValue(Row, "sdate");
		args["edate"] 	= sheet1.GetCellValue(Row, "edate");
		args["title"] 	= sheet1.GetCellValue(Row, "title");
		args["memo"] = sheet1.GetCellValue(Row, "memo");

		var rv = openPopup(url,args,w,h);
		if(rv!=null){
			sheet1.SetCellValue(Row, "seq", 	rv["seq"] );
			sheet1.SetCellValue(Row, "schGubunCd", 		rv["schGubunCd"] );
			sheet1.SetCellValue(Row, "sdate", 	rv["sdate"] );
			sheet1.SetCellValue(Row, "edate", 	rv["edate"] );
			sheet1.SetCellValue(Row, "title", 	rv["title"] );
			sheet1.SetCellValue(Row, "memo", rv["memo"] );
			
			
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
						<th><tit:txt mid='113335' mdef='게시판 ID '/></th>
						<td>  <select id="searchBbsCd" name="searchBbsCd"> </select> </td>				
						<th><tit:txt mid='113694' mdef='구분 '/></th>		
						<td>  <select id="searchSchGubunCd" name="searchSchGubunCd"> </select> </td>		
						<th><tit:txt mid='104497' mdef='시작일'/></th>				
						<td>
							<input id="searchFromYmd" name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>"/> ~
							<input id="searchToYmd" name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
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
							<li id="txt" class="txt"><tit:txt mid='112276' mdef='기준관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
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
