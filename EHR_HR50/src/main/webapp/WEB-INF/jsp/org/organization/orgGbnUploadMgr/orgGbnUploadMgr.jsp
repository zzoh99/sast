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
		$("#searchSdate").datepicker2({ymdonly:true});
		$("#searchMapNm, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			  	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			  	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			  	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"<sht:txt mid='orgPath' mdef='조직경로'/>",      	  	Type:"Text",      Hidden:0,  Width:350,  	Align:"Left",  	ColMerge:0,   SaveName:"orgPath",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },

			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",      	  	Type:"Text",      Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",      	  	Type:"Text",      Hidden:0,  Width:100,  	Align:"Left",  	ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='mapTypeCd' mdef='조직맵핑구분'/>",		Type:"Combo",     Hidden:0,  Width:100,  	Align:"Center",  ColMerge:0,   SaveName:"mapTypeCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='mapCd' mdef='조직맵핑코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"mapCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mapCdV2' mdef='조직맵핑명'/>",	Type:"Popup",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"mapNm",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",      	  	Type:"Date",      Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"sdate",        KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 , EndDateCol:"edate"},
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",      	  	Type:"Date",      Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 , StartDateCol:"sdate"}
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var orgMappingGbn 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20020"), ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//조직맵핑구분
		//var searchMapCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTorg109List",false).codeList, "");	//사업장

		sheet1.SetColProperty("mapTypeCd", 			{ComboText:"|"+orgMappingGbn[0], ComboCode:"|"+orgMappingGbn[1]} );	//조직맵핑구분
		//sheet1.SetColProperty("mapCd", 			{ComboText:"|"+searchMapCd[0], ComboCode:"|"+searchMapCd[1]} );	//조직맵핑

		$("#searchMapTypeCd").html(orgMappingGbn[2]);

		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");//테스트결과로 초기조회 기능 제거 JSG
	});

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
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
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/OrgGbnUploadMgr.do?cmd=getOrgGbnUploadMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
			if (!chkInVal()) {break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/OrgGbnUploadMgr.do?cmd=saveOrgGbnUploadMgr", $("#srchFrm").serialize()); break;
		case "Insert":		var Row = sheet1.DataInsert(0) ;
							sheet1.SelectCell(Row, "mapNm");
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|5|6|7|8|9"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
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

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{

	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function orgGbnUploadMgrPopup(Row){
		if(!isPopup()) {return;}

  		var w 		= 640;
		var h 		= 430;
		var url 	= "${ctx}/OrgGbnUploadMgr.do?cmd=orgGbnUploadMgrPopup&authPg=${authPg}";
		var args 	= new Array();

		gPRow = Row;
		pGubun = "orgGbnUploadMgrPopup";

		openPopup(url,args,w,h);
	}

//  사원 조회
	function openEmployeePopup(Row){
	    try{
			if(!isPopup()) {return;}

			var args    = new Array();

			gPRow = Row;
			pGubun = "employeePopup";

			openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
	    } catch(ex){
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "orgGbnUploadMgrPopup"){
			sheet1.SetCellValue(gPRow, "mapTypeCd",	rv["mapTypeCd"]);
			sheet1.SetCellValue(gPRow, "mapCd",		rv["mapCd"]);
			sheet1.SetCellValue(gPRow, "mapNm",		rv["mapNm"]);
       } else if(pGubun == "employeePopup") {
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "orgNm", 	rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "statusNm", 	rv["statusNm"] );
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
						<th><tit:txt mid='113963' mdef='조직맵핑구분'/></th>
						<td><select id="searchMapTypeCd" name ="searchMapTypeCd" onChange="javascript:doAction1('Search')" class="box"></select></td>
						<th><tit:txt mid='104514' mdef='조직명'/></th>
						<td><input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /></td>
						<th><tit:txt mid='113436' mdef='조직맵핑명'/></th>
						<td>
							<input id="searchMapNm" name ="searchMapNm" type="text" class="text" />
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt"><tit:txt mid='orgGbnUploadMgr' mdef='조직구분업로드'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline-gray authR" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline-gray authR" mid='110703' mdef="업로드"/>
								<btn:a href="javascript:doAction1('Save')" 			css="btn filled authA" mid='110708' mdef="저장"/>
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
