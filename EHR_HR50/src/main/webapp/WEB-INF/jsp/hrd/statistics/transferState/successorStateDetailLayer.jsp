<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">

	var searchSabun         = ""
	var searchActiveYyyy    = "";
	var searchHalfGubunType = "";

	var EnterKeyEvent = function(control, searchFunc, searchParam){
		$(control).bind("keyup", function(event) {
			if (event.keyCode == 13) {
				searchFunc(searchParam);
				$(control).focus();
			}
		});
	};

	var SelectChangeEvent = function(control, searchFunc, searchParam){
		$(control).on("change", function() {
			searchFunc(searchParam);
			$(control).focus();
		});
	};

	$(function() {
		createIBSheet3(document.getElementById('successorStateDetailLayerSheet-wrap'), "successorStateDetailLayerSheet", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('successorStateDetailLayer');

		console.log(modal.parameters);

		searchSabun         = modal.parameters.searchSabun || '';
		searchActiveYyyy 	= modal.parameters.searchActiveYyyy || '';
		searchHalfGubunType = modal.parameters.searchHalfGubunType || '';

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'     	mdef='No'   />"     ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' 	mdef='삭제' 	/>"     ,Type:"${sDelTy}" ,Hidden:Number("${sDelHdn}") ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' 	mdef='상태' 	/>"     ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='sabun'       mdef='사번'  />" 		,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"sabun"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='name'        mdef='성명'  />" 		,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"name"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='priorOrgNm'       mdef='상위부서'  />" 		,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"priorOrgNm"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='orgNm'       mdef='소속'  />" 		,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"orgNm"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='jobNm'       mdef='직무'  />" 		,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"jobNm"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='rank'        mdef='순위'  />" 		,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"rank"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
		];
		IBS_InitSheet(successorStateDetailLayerSheet, initdata);
		successorStateDetailLayerSheet.SetVisible(true);
		successorStateDetailLayerSheet.SetCountPosition(4);

		var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		successorStateDetailLayerSheet.SetSheetHeight(sheetHeight);

		loadUI();
		loadEvent();

		doAction1("Search");
	});

	function loadUI(){

	}

	function loadEvent(){
		$("input:text").each(function(index){
			EnterKeyEvent(this, doAction1, "Search")
		});

		$("select").each(function(index){
			SelectChangeEvent(this, doAction1, "Search");
		})


	}

	function loadLookupCombo(sheet, fieldName, codeList){
		sheet.SetColProperty(fieldName, {ComboText:"|"+codeList[0], ComboCode:"|"+codeList[1]} );

	}


	function successorStateDetailLayerSheet_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			// sheetResize();
		} catch(ex) {
			    alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function successorStateDetailLayerSheet_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			doAction1("Search");

		} catch(ex) {
			    alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function successorStateDetailLayerSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if ( successorStateDetailLayerSheet.ColSaveName(col) == "colName") {
				//TODO something
				return;
			}

			//doAction1("Search");

		} catch(ex) {
			    alert("OnClick Event Error : " + ex);
		}
	}

	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var params = "searchActiveYyyy="      + searchActiveYyyy
	  				      	+ "&searchHalfGubunType=" + searchHalfGubunType
						    + "&searchSabun="         + searchSabun
							+ "&searchName="          + $("#searchName").val();

				successorStateDetailLayerSheet.DoSearch( "${ctx}/TransferState.do?cmd=getsuccessorStateDetailPopupList", params);
				break;
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper modal_layer">
	<div class="modal_body padb5">
		<form id="srchFrm" name="srchFrm" >
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='' mdef='성명' /></th>
							<td>
								<input id="searchName" name="searchName" type="Text" class="text" />
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='search' mdef='조회' />
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<form id="successorStateDetailLayerSheetForm" name="successorStateDetailLayerSheetForm"></form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt1" class="txt"><tit:txt mid='' mdef='업무대체자조회'/></li>
					<li class="btn">

					</li>
				</ul>
			</div>
		</div>
<%--		<script type="text/javascript">createIBSheet("successorStateDetailLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="successorStateDetailLayerSheet-wrap"></div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('successorStateDetailLayer');" css="gray large" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>
</html>
