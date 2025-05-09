<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<!-- <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>-->
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='detail' mdef='세부\n내역|세부\n내역'/>",				Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
            {Header:"<sht:txt mid='locationCdV5' mdef='Location|코드'/>",					Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"locationCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='locationNmV2' mdef='Location|명칭'/>",					Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"locationNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:400 },
            {Header:"<sht:txt mid='nationalCdV2' mdef='소재국가|소재국가'/>",					Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"nationalCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='zipV1' mdef='우편번호|우편번호'/>",					Type:"PopupEdit", Hidden:0,  Width:75,   Align:"Center",  ColMerge:1,   SaveName:"zip",             KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"<sht:txt mid='addrV1' mdef='주소|주소'/>",							Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:1,   SaveName:"addr",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
            {Header:"<sht:txt mid='detailAddr' mdef='상세주소|상세주소'/>",					Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"detailAddr",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='engAddrV1' mdef='영문주소|영문주소'/>", 				Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:1,   SaveName:"engAddr",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
            {Header:"<sht:txt mid='2019071000002' mdef='영문상세주소|영문상세주소'/>", 		Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"detailEngAddr",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='taxBpCd' mdef='사업장|사업장'/>", 					Type:"Combo",     Hidden:0,  Width:120,   Align:"Center",  ColMerge:1,   SaveName:"taxBpCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
            {Header:"<sht:txt mid='taxLocationCd' mdef='지방소득세|LOCATION'/>", 				Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"taxLocationCd",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
            {Header:"<sht:txt mid='taxOfficeNm' mdef='지방소득세|관할구청'/>", 				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"taxOfficeNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
            {Header:"<sht:txt mid='recOfficeNm' mdef='지방소득세|취급청'/>", 				Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"recOfficeNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
            {Header:"<sht:txt mid='officeTaxYn' mdef='사업소세\n대상여부|사업소세\n대상여부'/>", Type:"CheckBox",  Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"officeTaxYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400,	TrueValue:"Y", FalseValue:"N" },
            {Header:"<sht:txt mid='orderSeq' mdef='순서|순서'/>", 						Type:"Int",  	  Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"orderSeq",     	KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var nationalCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "");	//소재국가
		//var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "");	//사업장
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//사업장
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION


		sheet1.SetColProperty("nationalCd", 			{ComboText:"|"+nationalCd[0], ComboCode:"|"+nationalCd[1]} );	//소재국가
		sheet1.SetColProperty("taxBpCd", 			{ComboText:"|"+businessPlaceCd[0], ComboCode:"|"+businessPlaceCd[1]} );	//사업장
		sheet1.SetColProperty("taxLocationCd", 			{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );	//LOCATION

		$("#searchLocationNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/LocationMgr.do?cmd=getLocationMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/LocationMgr.do?cmd=saveLocationMgr", $("#srchFrm").serialize() ); break;
		case "Insert":		alert("[조직구분항목]메뉴에서 입력하세요."); break;
		case "Copy":
			var Row = sheet1.DataCopy();
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	// 팝업 클릭시 발생 addr, detailAddr
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "zip") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "ZipCodePopup";
 				//openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
				var url = '/ZipCodePopup.do?cmd=viewZipCodeLayer&authPg=${authPg}';
				var layer = new window.top.document.LayerModal({
		           		  id : 'zipCodeLayer'
		                , url : url
		                , width : 740
		                , height : 620
		                , title : '우편번호 검색'
		                , trigger :[
		                    {
		                          name : 'zipCodeLayerTrigger'
		                        , callback : function(result){
		                        	getReturnValue(result);
		                        }
		                    }
		                ]
		            });
				layer.show();
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	locationMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function locationMgrPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 820;
		var h 		= 820;
		var url 	= "${ctx}/LocationMgr.do?cmd=viewLocationMgrLayer&authPg=${authPg}";
		var args 	= new Array();
		var p = {
				locationCd 		: sheet1.GetCellValue(Row, "locationCd"),
				locationNm 		: sheet1.GetCellValue(Row, "locationNm"),
				nationalCd 		: sheet1.GetCellValue(Row, "nationalCd"),
				zip 			: sheet1.GetCellValue(Row, "zip"),
				addr 			: sheet1.GetCellValue(Row, "addr"),
				detailAddr 		: sheet1.GetCellValue(Row, "detailAddr"),
				engAddr 		: sheet1.GetCellValue(Row, "engAddr"),
				detailEngAddr 	: sheet1.GetCellValue(Row, "detailEngAddr"),
				taxBpCd 		: sheet1.GetCellValue(Row, "taxBpCd"),
				taxLocationCd 	: sheet1.GetCellValue(Row, "taxLocationCd"),
				taxOfficeNm 	: sheet1.GetCellValue(Row, "taxOfficeNm"),
				recOfficeNm 	: sheet1.GetCellValue(Row, "recOfficeNm"),
				officeTaxYn 	: sheet1.GetCellValue(Row, "officeTaxYn"),
				orderSeq 		: sheet1.GetCellValue(Row, "orderSeq")
		};
		gPRow = Row;
		pGubun = "locationMgrPopup";
		var layer = new window.top.document.LayerModal({
     		  	 id : 'locationMgrLayer'
               , url : url
               , parameters: p
               , width : w
               , height : h
               , title : "<tit:txt mid='locationDetailMgr' mdef='Location관리 세부내역'/>"
               , trigger :[
                   {
                         name : 'locationMgrLayerTrigger'
                       , callback : function(result){
                       		getReturnValue(result);
                         }
                   }
               ]
           });
		layer.show();
		//openPopup(url,args,w,h);
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
        if(pGubun == "locationMgrPopup") {
			sheet1.SetCellValue(gPRow, "locationCd", 	returnValue["locationCd"] );
			sheet1.SetCellValue(gPRow, "locationNm", 	returnValue["locationNm"] );
			sheet1.SetCellValue(gPRow, "nationalCd", 	returnValue["nationalCd"] );
			sheet1.SetCellValue(gPRow, "zip", 			returnValue["zip"] );
			sheet1.SetCellValue(gPRow, "addr", 			returnValue["addr"] );
			sheet1.SetCellValue(gPRow, "detailAddr", 	returnValue["detailAddr"] );
			sheet1.SetCellValue(gPRow, "engAddr", 		returnValue["engAddr"] );
			sheet1.SetCellValue(gPRow, "detailEngAddr", returnValue["detailEngAddr"] );
			sheet1.SetCellValue(gPRow, "taxBpCd", 		returnValue["taxBpCd"] );
			sheet1.SetCellValue(gPRow, "taxLocationCd", returnValue["taxLocationCd"] );
			sheet1.SetCellValue(gPRow, "taxOfficeNm", 	returnValue["taxOfficeNm"] );
			sheet1.SetCellValue(gPRow, "recOfficeNm", 	returnValue["recOfficeNm"] );
			sheet1.SetCellValue(gPRow, "officeTaxYn", 	returnValue["officeTaxYn"] );
			sheet1.SetCellValue(gPRow, "orderSeq", 		returnValue["orderSeq"] );
        }else if ( pGubun == "ZipCodePopup" ){
			sheet1.SetCellValue(gPRow, "zip", returnValue["zip"]);
			sheet1.SetCellValue(gPRow, "addr", returnValue["doroAddr"]);
 			sheet1.SetCellValue(gPRow, "detailAddr", returnValue["detailAddr"]);
			sheet1.SetCellValue(gPRow, "engAddr", returnValue["resDoroFullAddrEng"]);
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
						<th>주소명칭  </th>
						<td>  <input id="searchLocationNm" name ="searchLocationNm" type="text" class="text w150" /> </td>
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
							<li id="txt" class="txt"><tit:txt mid='locationMgr' mdef='Location관리'/></li>
							<li class="btn">
								<%-- <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/> --%>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
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
