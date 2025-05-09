<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112392' mdef='조건 검색 관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var srchBizCdList = null;
	var srchTypeCdList = null;
	var p = eval("${popUpStatus}");
	$(function() {
		//srchBizCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체'/>");
		srchBizCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");
		srchTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20010"), "<tit:txt mid='103895' mdef='전체'/>");

		$("#srchBizCd").html(srchBizCdList[2]);	//업무 구분
		$("#srchType").html(srchTypeCdList[2]);	//검색 구분

		sheet1.SetDataLinkMouse("sStatus", 1);
	    sheet1.SetDataLinkMouse("dbItemDesc", 1);
	    
		var srchBizCd = "";
		var srchType = "";
		var srchDesc = "";
		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			 srchBizCd 	  = arg["srchBizCd"];
			 srchType     = arg["srchType"];
			 srchDesc     = arg["srchDesc"];
		}else{
			if ( p.popDialogArgument("srchBizCd")  !=null ) { srchBizCd = p.popDialogArgument("srchBizCd"); }
			if ( p.popDialogArgument("srchType")   !=null ) { srchType  = p.popDialogArgument("srchType"); }
			if ( p.popDialogArgument("srchDesc")   !=null ) { srchDesc  = p.popDialogArgument("srchDesc"); }
		}
		$("#srchBizCd").val(srchBizCd);	//업무 구분
		$("#srchType").val(srchType);	//검색 구분
		$("#srchDesc").val(srchDesc);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
	        {Header:"<sht:txt mid='sNo' mdef='No'/>",  				Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo", UpdateEdit:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",      	Type:"Image",   Hidden:1,  	Width:40,	Align:"Center",  ColMerge:0,   SaveName:"dbItemDesc",	UpdateEdit:0},
			{Header:"<sht:txt mid='searchSeq_V646' mdef='검색\n순번'/>",      	Type:"Text",    Hidden:1,  	Width:30,	Align:"Center",  ColMerge:0,   SaveName:"searchSeq",    UpdateEdit:0 },
	        {Header:"<sht:txt mid='searchType' mdef='검색구분'/>",        	Type:"Combo",   Hidden:0,  	Width:130,	Align:"Center",  ColMerge:0,   SaveName:"searchType",   UpdateEdit:0 },
	        {Header:"<sht:txt mid='searchDesc' mdef='검색설명'/>",        	Type:"Text",    Hidden:0,  	Width:200,	Align:"Left",    ColMerge:0,   SaveName:"searchDesc",   UpdateEdit:0 },
	        {Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",        	Type:"Combo",   Hidden:0, 	Width:110,	Align:"Left",    ColMerge:0,   SaveName:"bizCd",        UpdateEdit:0 },
	        {Header:"<sht:txt mid='viewCd' mdef='조회업무코드'/>",    	Type:"Text",    Hidden:1,  	Width:0,  	Align:"Left",    ColMerge:0,   SaveName:"viewCd",       UpdateEdit:0 },
	        {Header:"<sht:txt mid='viewDesc' mdef='조회업무'/>",        	Type:"Text",   Hidden:0,  	Width:100,	Align:"Left",    ColMerge:0,   SaveName:"viewDesc",     UpdateEdit:0 },
	        {Header:"<sht:txt mid='commonUseYn' mdef='공통사용\n여부'/>",  	Type:"Combo",   Hidden:1,  	Width:0,   Align:"Center",  ColMerge:0,   SaveName:"commonUseYn",   UpdateEdit:0 },
	        {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",            	Type:"Text",    Hidden:1,  	Width:0,    Align:"Left",    ColMerge:0,   SaveName:"sabun",        UpdateEdit:0 },
	        {Header:"<sht:txt mid='chkId' mdef='등록자'/>",          	Type:"Text",    Hidden:1,  	Width:80,   Align:"Center",  ColMerge:0,   SaveName:"owner",        UpdateEdit:0 },
	        {Header:"<sht:txt mid='chkdateV1' mdef='최종수정일'/>",      	Type:"Date",    Hidden:1,  	Width:0,  	Align:"Center",  ColMerge:0,   SaveName:"chkdate",      UpdateEdit:0 },
	        {Header:"<sht:txt mid='viewNm' mdef='VIEW_NM'/>",         	Type:"Text",    Hidden:1,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"viewNm",       UpdateEdit:0 },
	        {Header:"<sht:txt mid='copySearchSeq' mdef='복사_SEARCH_SEQ'/>",	Type:"Text",    Hidden:1,  	Width:0,   Align:"Center",  ColMerge:0,   SaveName:"copySearchSeq", UpdateEdit:0 }
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetEditableColorDiff (0);
     	sheet1.SetColProperty("bizCd", 		{ComboText:srchBizCdList[0], 	ComboCode:srchBizCdList[1]} );
        sheet1.SetColProperty("searchType", 	{ComboText:srchTypeCdList[0], 	ComboCode:srchTypeCdList[1]} );
        sheet1.SetColProperty("commonUseYn", 	{ComboText:"YES|NO", 		ComboCode:"Y|N"} );
        sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();

		$("#srchDesc").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

	    doAction("Search");
	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/Popup.do?cmd=getPwrSrchMgrPopupList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var rv = new Array(5);
		rv["searchSeq"] 		= sheet1.GetCellValue(Row, "searchSeq");
		rv["searchDesc"]		= sheet1.GetCellValue(Row, "searchDesc");
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}

	function init_value() {
		var rv = new Array(5);
		rv["searchSeq"] 		= "";
		rv["searchDesc"]		= "";
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}
  	<%--  function mySheet_OnClick(Row, Col, Value){
		try{
			if(Row > 0 && sheet1.ColSaveName(Col) == "dbItemDesc"){
                if(sheet1.GetCellText(Row, "searchType").toUpperCase().indexOf("업무") != -1 ){
                    if(sheet1.GetCellValue(Row, "viewCd") != ""){
		                            var win=CenterWin("./PwrSrchBiz_list.jsp?dataAuthority=<%=dataAuthority%>", "PwrSrchBiz_list", "scrollbars=no, status=no, width=940, height=685, top=0, left=0");
						detailPopup("<c:url value='PwrSrchMgr.do?cmd=pwrSrchMgrBizPopup' />","",900,700);
                    }else{
                        alert("<msg:txt mid='110401' mdef='조회업무를 먼저 선택하세요.'/>");
                    }
                }else if(sheet1.GetCellText(Row, "searchType").toUpperCase().indexOf("ADMIN") != -1 ){
		                    var win=CenterWin("./PwrSrchAdmin_list.jsp?dataAuthority=<%=dataAuthority%>&editFlag=true", "PwrSrchAdmin_list", "scrollbars=no, status=no, width=940, height=695, top=0, left=0");
                }else if(sheet1.GetCellText(Row, "searchType").toUpperCase().indexOf("SUITABLE") != -1 ){

		                	var win=CenterWin("/JSP/hri/suitblMatch/SuitableMatch_list.jsp?dataAuthority=<%=dataAuthority%>&editFlag=true", "SuitableMatch_list", "scrollbars=yes, status=no, width=955, height=695, top=0, left=0");
                }
	    	}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}  --%>

</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='112392' mdef='조건 검색 관리'/></li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
			<form id="mySheetForm" name="mySheetForm">
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='114394' mdef='업무구분'/></th>
						<td>
							<select id="srchBizCd" name="srchBizCd" onChange=""></select>
						</td>
						<th><tit:txt mid='112961' mdef='검색구분'/></th>
						<td>
							<select id="srchType" name="srchType" onChange=""></select>
						</td>
						<th><tit:txt mid='112606' mdef='검색설명'/></th>
						<td>
							<input id="srchDesc" name="srchDesc" type="text" class="text" style="ime-mode:active;" />
						</td>
						<td>
							<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
							<li id="txt" class="txt"><tit:txt mid='112392' mdef='조건 검색 관리'/></li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
		</div>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:init_value();" css="blue large" mid='110754' mdef="초기화"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
			<br>
		</div>
	</div>
</body>
</html>



