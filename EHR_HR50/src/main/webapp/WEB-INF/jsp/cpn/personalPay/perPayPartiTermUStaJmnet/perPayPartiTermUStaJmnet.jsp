<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
        // 조회조건 급여구분(C00001-00001.급여 00002.상여 00003.연월차 RETRO.소급)
        var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList&searchRunType=00001,00002,00003,RETRO,ETC,J0001",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchPayCd").html(searchPayCdList[2]);

		$("#tmpPayYmFrom").datepicker2({ymonly:true});
		$("#tmpPayYmTo").datepicker2({ymonly:true});
		$("#tmpPayYmTo, #tmpPayYmFrom").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

  			{Header:"paymentYmd",   Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"paymentYmd",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
  			{Header:"<sht:txt mid='payActionCdV8' mdef='payActionCd'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
  			{Header:"<sht:txt mid='payActionCd' mdef='급여일자'/>",      Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payActionNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
  			{Header:"<sht:txt mid='element13' mdef='지급총액'/>",      Type:"AutoSum",       Hidden:0,  Width:100,   Align:"Right",   ColMerge:0,   SaveName:"totEarningMon",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='element15' mdef='공제총액'/>",      Type:"AutoSum",       Hidden:0,  Width:100,   Align:"Right",   ColMerge:0,   SaveName:"totDedMon",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='element16' mdef='실지급액'/>",      Type:"AutoSum",       Hidden:0,  Width:100,   Align:"Right",   ColMerge:0,   SaveName:"paymentMon",       KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

  			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sabun",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 }
  		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
  			{Header:"<sht:txt mid='reportNm_V5226' mdef='지급 내역'/>",   Type:"Text",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"reportNm",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
  			{Header:"<sht:txt mid='reportNm_V5226' mdef='지급 내역'/>",	Type:"AutoSum",      Hidden:0,  Width:0,    Align:"Right",  ColMerge:0,   SaveName:"resultMon",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
  		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(0);
  		sheet2.SetHeaderBackColor("#FFC31E");

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata3.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='reportNm_V914' mdef='공제 내역'/>",   Type:"Text",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"reportNm",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
  			{Header:"<sht:txt mid='reportNm_V914' mdef='공제 내역'/>",	Type:"AutoSum",      Hidden:0,  Width:0,    Align:"Right",  ColMerge:0,   SaveName:"resultMon",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
  		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(0);
  		sheet3.SetHeaderBackColor("#FF8C8C");

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 시작일 종료일 체크
			var sd = $("#tmpPayYmFrom").val().replace(/\-/g,'').replace(/\//g,'');
			var ed = $("#tmpPayYmTo").val().replace(/\-/g,'').replace(/\//g,'');

			if(sd > ed){
				alert("<msg:txt mid='110440' mdef='시작 일자를 확인해 주세요.'/>");
				$("#tmpPayYmFrom").focus();
				return;
			}

			sheet1.DoSearch( "${ctx}/PerPayPartiTermUStaJmnet.do?cmd=getPerPayPartiTermUStaJmnetList", $("#sheet1Form").serialize() ); break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		}
	}
	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":

			sheet2.DoSearch( "${ctx}/PerPayPartiTermUStaJmnet.do?cmd=getPerPayPartiTermUStaJmnetListFirst", $("#sheet1Form").serialize() ); break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param); break;
		}
	}

	//Sheet1 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":

			sheet3.DoSearch( "${ctx}/PerPayPartiTermUStaJmnet.do?cmd=getPerPayPartiTermUStaJmnetListSecond", $("#sheet1Form").serialize() ); break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet3.Down2Excel(param); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

	        var Row = sheet1.GetSelectRow();
	        $("#sabun").val( sheet1.GetCellValue(Row, "sabun") );
			$("#payActionCd").val( sheet1.GetCellValue(Row, "payActionCd") );

			doAction2("Search");

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction3("Search");

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
	    try {
	        if(OldRow == NewRow || OldRow == -1 || NewRow == -1) {
	        	return;
	        }

	        var Row = NewRow;
	        $("#sabun").val( sheet1.GetCellValue(Row, "sabun") );
			$("#payActionCd").val( sheet1.GetCellValue(Row, "payActionCd") );

			doAction2("Search");

	    } catch (ex) {
	        alert("OnSelectCell Event Error : " + ex);
	    }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='112099' mdef='조회기간 '/></th>
						<td>
							<input type="text" id="tmpPayYmFrom" name ="tmpPayYmFrom" class="date2" value="<%=DateUtil.getThisYear()%>-01" />
							~
							<input type="text" id="tmpPayYmTo" name ="tmpPayYmTo" class="date2" value="${curSysYyyyMMHyphen}" />
						</td>
						<th class="hide"><tit:txt mid='104470' mdef='사번 '/></th>
						<td class="hide"><input type="text" id="searchSabun" name="searchSabun" class="text w100 readonly" readonly value="${ssnSabun}" /></td>
						<th class="hide"><tit:txt mid='104450' mdef='성명 '/></th>
						<td><input type="text" id="searchName" name="searchName" class="text w100 readonly" readonly value="${ssnName}" /></td>
						<th class="hide"><tit:txt mid='114519' mdef='급여구분 '/></th>
						<td class="hide"><select id="searchPayCd" name="searchPayCd"> </select></td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
			</div>
		</div>
					<input type="hidden" id="sabun" name="sabun" value="" />
					<input type="hidden" id="payActionCd" name="payActionCd" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="25%" />
			<col width="25%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112103' mdef='기간별급여내역'/></li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a> -->
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='perPayMasterMgrException1' mdef='지급'/></li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a> -->
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "50%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='perPayMasterMgrException2' mdef='공제'/></li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a> -->
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "50%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
