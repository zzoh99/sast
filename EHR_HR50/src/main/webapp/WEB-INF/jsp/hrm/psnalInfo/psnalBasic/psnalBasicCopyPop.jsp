<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	$(function() {

		var arg = p.popDialogArgumentAll();

	    if( arg != undefined ) {

			    $("#searchResNo").val(arg["searchResNo"]);
			    $("#searchSabun").val(arg["searchSabun"]);
	    }




		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});

		$("#findOrg").bind("keyup",function(event){
			if( event.keyCode == 13){ findOrg(); $(this).focus(); }
		});

		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

		var initdata = {};
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sabun",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",	Type:"Date",		Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"empYmd",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='retYmd' mdef='퇴직일'/>",	Type:"Date", 		Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"retYmd",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10, }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

	});

	//Example Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PsnalBasic.do?cmd=getPsnalBasicCopyPopList", $("#srchFrm").serialize() ); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try{
			$("#searchNewSabun").val(sheet1.GetCellValue(NewRow, "sabun"));

		}catch (ex) {

		}

	}

	function makeDic(){

		if ( !confirm("해당 사번 (" + $("#searchNewSabun").val() + ") 정보를 복사 하시겠습니까?") ) return;

		var data = ajaxCall("${ctx}/PsnalBasic.do?cmd=prcPsnalBasicCopy",$("#srchFrm").serialize(),false);
		if(data.Result.Code == null) {
    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
    		doAction1("Search");
    	} else {
	    	alert(data.Result.Message);
    	}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='112202' mdef='인사정보 복사'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id=srchFrm name=srchFrm>
	        <input id="searchResNo" 		name="searchResNo" 		type="hidden" />
			<input id="searchSabun" 		name="searchSabun" 		type="hidden" />
			<input id="searchNewSabun" 		name="searchNewSabun" 		type="hidden" />
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"></li>
						<li class="btn">
							<a href="javascript:doAction1('Save')" class="basic"><tit:txt mid='114678' mdef='인사정보복사'/></a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		</table>

		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>

</body>
</html>
