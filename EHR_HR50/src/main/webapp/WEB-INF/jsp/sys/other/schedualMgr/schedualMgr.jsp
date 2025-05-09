<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchFromYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchToYmd"});		
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",    Hidden:0,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"detail", 		Sort:0 ,	  Cursor:"Pointer" },
            {Header:"<sht:txt mid='seqV5' mdef='SEQ'/>",			Type:"Int",     Hidden:1,  Width:100, 	Align:"Center", ColMerge:0,   SaveName:"seq",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='schGubunCd' mdef='일정구분'/>",	Type:"Combo",    Hidden:0,  Width:80,	Align:"Center", ColMerge:0,   SaveName:"schGubunCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='yy' mdef='년도'/>",				Type:"Text",     Hidden:0,  Width:60,  Align:"Center", ColMerge:0,   SaveName:"yy", 			KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
            {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Date",     Hidden:0,  Width:100,  Align:"Center", ColMerge:0,   SaveName:"sdate", 		KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 , EndDateCol:"edate"},
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",     Hidden:0,  Width:100, 	Align:"Center", ColMerge:0,   SaveName:"edate",  		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , StartDateCol:"sdate"},
            {Header:"<sht:txt mid='titleV1' mdef='일정'/>",			Type:"Text",     Hidden:0,  Width:200,  Align:"Left", 	ColMerge:0,   SaveName:"title",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='mailcont' mdef='내용'/>",			Type:"Text",     Hidden:0,  Width:200,  Align:"Left", 	ColMerge:0,   SaveName:"memo",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000, MultiLineText:1 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		var schGubunCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90008"), "<tit:txt mid='103895' mdef='전체'/>");	//일정구분
		
		sheet1.SetColProperty("schGubunCd", 			{ComboText:schGubunCd[0], ComboCode:schGubunCd[1]} )
		
		$("#searchSchGubunCd").html(schGubunCd[2]);

		$("#searchTitle, #searchFromYmd, #searchToYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#searchSchGubunCd").change(function(){
			doAction1("Search");
		});	
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function chkInVal(sAction) {
		if(sAction == "Search") {
			if ($("#searchFromYmd").val() != "" && $("#searchToYmd").val() != "") {
				if (!checkFromToDate($("#searchFromYmd"),$("#searchToYmd"),"시작일","시작일","YYYYMMDD")) {
					return false;
				}
			}
		} else if (sAction == "Save") {
			// 시작일자와 종료일자 체크
			for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
				if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
					if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
						var sdate = sheet1.GetCellValue(i, "sdate");
						var edate = sheet1.GetCellValue(i, "edate");
						if (parseInt(sdate) > parseInt(edate)) {
							alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
							sheet1.SelectCell(i, "edate");
							return false;
						}
					}
				}
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal(sAction)){break;}
			sheet1.DoSearch( "${ctx}/SchedualMgr.do?cmd=getSchedualMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 	
			// if(sheet1.FindStatusRow("I|U") != ""){
			// 	if(!dupChk(sheet1,"sdate", false, true)){break;}
			// 	if(!dupChk(sheet1,"eddate", false, true)){break;}
			// }
			if(!chkInVal(sAction)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/SchedualMgr.do?cmd=saveSchedualMgr", $("#srchFrm").serialize()); break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"yy","<%= DateUtil.getCurrentTime("yyyy")%>");
			sheet1.SetCellValue(row,"sdate","<%= DateUtil.getCurrentTime("yyyy-MM-dd")%>");
			sheet1.SelectCell(row, "schGubunCd");

			<%--"<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+365)%>"--%>
		break;
		case "Copy":		
			var Row = sheet1.DataCopy();
		    sheet1.SetCellValue(Row,"seq","");	  
		    break;
		
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"5|6|7|8|9",ExcelFontSize:"9",ExcelRowHeight:"20"});
			break;		
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

				var args 	= new Array();
				args["seq"] 	= sheet1.GetCellValue(Row, "seq");
				args["schGubunCd"] 		= sheet1.GetCellValue(Row, "schGubunCd");
				args["yy"] 		= sheet1.GetCellValue(Row, "yy");
				args["sdate"] 	= sheet1.GetCellValue(Row, "sdate");
				args["edate"] 	= sheet1.GetCellValue(Row, "edate");
				args["title"] 	= sheet1.GetCellValue(Row, "title");
				args["memo"] = sheet1.GetCellValue(Row, "memo");

				url = '/SchedualMgr.do?cmd=viewSchedualMgrLayer';
				schedualMgrLayer(url, args);

		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}		
	}

function schedualMgrLayer(pUrl, param) {

	let layerModal = new window.top.document.LayerModal({
		id : 'schedualMgrLayer'
		, url : pUrl
		, parameters : param
		, width : 640
		, height : 630
		, title : '일정관리 상세내역'
		, trigger :[
			{
				name : 'schedualMgrLayer'
				, callback : function(result){
					var gPRow = sheet1.GetSelectRow();
					sheet1.SetCellValue(gPRow, "seq", 		result["seq"] );
					sheet1.SetCellValue(gPRow, "schGubunCd",result["schGubunCd"] );
					sheet1.SetCellValue(gPRow, "sdate", 	result["sdate"] );
					sheet1.SetCellValue(gPRow, "edate", 	result["edate"] );
					sheet1.SetCellValue(gPRow, "title", 	result["title"] );
					sheet1.SetCellValue(gPRow, "memo", 		result["memo"] );
				}
			}
		]
	});
	layerModal.show();
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
						<th><tit:txt mid='104497' mdef='시작일'/></th>
						<td>
							<input id="searchFromYmd" name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>"/> ~
							<input id="searchToYmd" name="searchToYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+365)%>"/>
						</td>	
						<th><tit:txt mid='112958' mdef='일정구분 '/></th>					
						<td>  <select id="searchSchGubunCd" name="searchSchGubunCd"> </select> </td>	
						<th><tit:txt mid='112275' mdef='일정 '/></th>					
						<td>  <input id="searchTitle" name ="searchTitle" type="text" class="text" /> </td>
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
							<li id="txt" class="txt"><tit:txt mid='schedualMgr' mdef='일정관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline-gray authR" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline-gray authR" mid='110703' mdef="업로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
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
