<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='114014' mdef='외부사용자조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	
	$(function() {
		$(".close").click(function() {
			p.self.close();
		});
		
		initSheet1();
	});
	
	function returnValue(Row, Col) {
		if(sheet1.RowCount() <= 0) {
	      return;
	    }

    	var rv = [];
    	rv["sabun"] 	= sheet1.GetCellValue(Row,"sabun");
    	rv["name"] 		= sheet1.GetCellValue(Row,"name");
    	rv["comNm"] 	= sheet1.GetCellValue(Row,"comNm");
    	rv["orgNm"] 	= sheet1.GetCellValue(Row,"orgNm");
    	rv["jikchakNm"] = sheet1.GetCellValue(Row,"jikchakNm");
    	rv["jikgubNm"] 	= sheet1.GetCellValue(Row,"jikgubNm");
 		
		if(p.popReturnValue) p.popReturnValue(rv);
        p.self.close();
	}
</script>
<!-- sheet1 --> 
<script type="text/javascript">
	function initSheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"comNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		sheet1.DoSearch( "${ctx}/OutUserReg.do?cmd=getOutUserRegList", "searchUseYn=Y&"+ $("#srchFrm").serialize() ); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
            if (KeyCode == 13)	returnValue(Row,Col);
            
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){
		try{
			if(Row == 0)	return;
			
			returnValue(Row,Col);
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='114014' mdef='외부사용자조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<form id="srchFrm" name="srchFrm" >
				<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='112947' mdef='성명/사번'/></th>
							<td>  <input id="searchSabunName" name ="searchSabunName" type="text" class="text" style="ime-mode:active;"/> </td>
							<td>
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button"  mid='110697' mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
				</div>
			</form>
			
			<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='114014' mdef='외부사용자조회'/></li>
				</ul>
			</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

			<div class="popup_button outer">
				<ul>
					<li>
						<btn:a css="gray large close" mid='110881' mdef="닫기"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
