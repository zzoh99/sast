<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");
	$(function() {
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
     			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"Seq",       Hidden:0,  Width:40,  Align:"Center",  ColMerge:0,   SaveName:"sNo" },

    			{Header:"<sht:txt mid='mapTypeCd' mdef='조직맵핑구분'/>",		Type:"Combo",     Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"mapTypeCd",  keyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
    			{Header:"<sht:txt mid='mapCd' mdef='조직맵핑코드'/>",		Type:"Text",      Hidden:0,  Width:80, 	Align:"Center",  ColMerge:0,   SaveName:"mapCd",       keyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
    			{Header:"<sht:txt mid='mapCdV2' mdef='조직맵핑명'/>",		Type:"Text",      Hidden:0,  Width:150, Align:"Left",    ColMerge:0,   SaveName:"mapNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
    			{Header:"<sht:txt mid='erpEmpCd' mdef='ERP사원구분'/>",		Type:"Combo",     Hidden:1,  Width:0,  	Align:"Center",  ColMerge:0,   SaveName:"erpEmpCd",   keyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
    			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",      Hidden:1,  Width:200, Align:"Left",    ColMerge:0,   SaveName:"note",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		];
		IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);

		var W20020 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20020"), "<tit:txt mid='103895' mdef='전체'/>");
		var C14050 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C14050"), "");

		mySheet.SetColProperty("mapTypeCd", {ComboText:W20020[0], ComboCode:W20020[1]} );
		mySheet.SetColProperty("erpEmpCd", {ComboText:C14050[0], ComboCode:C14050[1]} );

	  	$("#searchMapTypeCd").html(W20020[2]);

	  	$("#searchYmd").datepicker2();
	  	
		$("#searchMapTypeCd").change(function(){
			doAction("Search");
		});

		$("#searchMapNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

	    //$(window).smartresize(sheetResize); 
	    sheetInit();

	    //doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });

	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			if(!checkList()) return ;
			mySheet.DoSearch( "${ctx}/Popup.do?cmd=getOrgMappingItemPopupList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function mySheet_OnDblClick(Row, Col){
		var rv = new Array(3);
		rv["mapTypeCd"] = mySheet.GetCellValue(Row, "mapTypeCd");
		rv["mapCd"] 	= mySheet.GetCellValue(Row, "mapCd");
		rv["mapNm"]		= mySheet.GetCellValue(Row, "mapNm");

		p.popReturnValue(rv);
		p.window.close();
	}
	
	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='112707' mdef='조직구분항목 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
						<td> <span>기준일</span> 
							<input type="text" id="searchYmd" name="searchYmd" class="date2 required" value="${curSysYyyyMMddHyphen}">
						</td>
						<th><tit:txt mid='114510' mdef='조직맵핑구분 '/></th>
						<td>  <select id="searchMapTypeCd" name="searchMapTypeCd"></select></td>
						<th><tit:txt mid='113436' mdef='조직맵핑명 '/></th>
						<td>  <input id="searchMapNm" name ="searchMapNm" type="text" class="text" /> </td>
						<td> <a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
						<li id="txt" class="txt"><tit:txt mid='112707' mdef='조직구분항목 조회'/></li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



