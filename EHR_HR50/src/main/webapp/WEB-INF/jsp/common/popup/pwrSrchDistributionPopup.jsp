<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var srchSeq = null;
	var p = eval("${popUpStatus}");
	
	$(function() {
		//srchSeq = dialogArguments["srchSeq"];
		
		//var arg = p.window.dialogArguments;
		//if( arg != undefined ) {
		//	srchSeq 	= arg["srchSeq"];
		//}
		
		srchSeq = "20023";
		$("#srchSeq").val(srchSeq);
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:3, DataRowMerge:0};                                                                                                                                                                                              
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};                                                                                                                                                                          
		initdata.Cols = [                                                                                                                                                                                                                            
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:0, 	Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:0,  	Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",	Type:"Text",      	Hidden:1,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"searchSeq",  	KeyField:1,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
  			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>"    ,	Type:"Text",      	Hidden:0,  	Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sabun",       	KeyField:1,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
 			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>"    ,	Type:"PopupEdit", 	Hidden:0,  	Width:100,  Align:"Center",  ColMerge:0,   SaveName:"name",        	KeyField:1,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
      		{Header:"<sht:txt mid='distrYmd' mdef='배포일자'/>",	Type:"Date",      	Hidden:0,  	Width:80,   Align:"Left",    ColMerge:0,   SaveName:"distrYmd",   	KeyField:0,	Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
 			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>"  ,	Type:"Text",      	Hidden:0,  	Width:120,  Align:"Left",    ColMerge:0,   SaveName:"orgNmORG_NM",	KeyField:0,	Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jobNmV2' mdef='직무명'/>"  ,	Type:"Text",      	Hidden:0,  	Width:100,  Align:"Left",    ColMerge:0,   SaveName:"jobNmJOB_NM",	KeyField:0,	Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>"    ,	Type:"Text",      	Hidden:0,  	Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",   	KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>"    ,	Type:"Text",      	Hidden:0,  	Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",   	KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>"    ,	Type:"Text",      	Hidden:0,  	Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",  	KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>"    ,	Type:"DelCheck",  	Hidden:0,  	Width:50,   Align:"Center",  ColMerge:0,   SaveName:"sDelete" }
       	];
		IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	    $(window).smartresize(sheetResize); sheetInit();
	    doAction("Search");
	});
	function doAction(sAction) {
		switch (sAction) {
		case "Search":  sheet1.DoSearch( "${ctx}/PwrSrchDistributionPopup.do?cmd=getPwrSrchDistributionPopupList", $("#sheetForm").serialize() ); break;
		//case "Save":   	
		//	sheet1.DoSave("PwrSrchDistribution_save.jsp", true); 
		//	break;
		case "Insert":     
            var Row = mySheet.DataInsert(0);
            sheet1.SetCellValue(Row, "SEARCH_SEQ", document.all.searchSearchSeq.value);
            sheet1.SelectCell(Row, "NAME");
            break;
		}
    }
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet1_OnClick(Row, Col, Value){
		var returnValue = new Array(4);
		returnValue["viewCd"] 	= sheet1.GetCellValue(Row,"sabun");
		returnValue["viewNm"] 	= sheet1.GetCellValue(Row,"viewNm");
		returnValue["viewDesc"] = sheet1.GetCellValue(Row,"viewDesc");
		p.window.returnValue = returnValue;                   
		p.window.close(); 
	}
    function winClose(){
    	p.window.close();
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='112733' mdef='조건검색 배포'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
	<div class="popup_main">
				<form id="sheetForm" name="sheetForm" >
					<input id="srchSeq" name="srchSeq" type="hidden"/>
				</form>
		
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
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
