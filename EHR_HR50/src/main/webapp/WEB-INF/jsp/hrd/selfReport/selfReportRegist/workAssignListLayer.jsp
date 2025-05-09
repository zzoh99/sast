<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">
	var searchJobCd = "";

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

	var SelectChangeEvent = function(control, searchFunc, searchParam){
		sheet.SetColuProperty(columnName, {ComboText:"|"+ lookupList[0], ComboCode:"|"+lookupList[1]});
	};

	$(function() {
		createIBSheet3(document.getElementById('workAssignListLayerSheet-wrap'), "workAssignListLayerSheet", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('workAssignListLayer');
		searchJobCd = modal.parameters.searchJobCd || '';

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msAll, Page:100, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'     mdef='No'               />" ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'             />" ,Type:"${sDelTy}" ,Hidden:Number("${sDelHdn}") ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'             />" ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='BLANK'        mdef='대분류'           />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"gWorkAssignNm"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='중분류'           />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mWorkAssignNm"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='단위업무명'       />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='단위업무\n기술서' />" ,Type:"Image"     ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"detail"           ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='workAssignNote'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNote"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='workAssignCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCd"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='mWorkAssignCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mWorkAssignCd"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='gWorkAssignCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"gWorkAssignCd"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='BLANK'        mdef='workAssignNoteCd'                 />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNoteCd" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
		];
		IBS_InitSheet(workAssignListLayerSheet, initdata);
		workAssignListLayerSheet.SetVisible(true);
		workAssignListLayerSheet.SetCountPosition(4);
		workAssignListLayerSheet.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		workAssignListLayerSheet.SetDataLinkMouse("detail", 1);

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		workAssignListLayerSheet.SetSheetHeight(sheetHeight);

		loadEvent();
		doAction1("Search");
	});

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


	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				var params = "searchJobCd=" + searchJobCd +
				             "&searchWorkAssignNm=" + $("#searchWorkAssignNm").val() ;

				workAssignListLayerSheet.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getWorkAssignListPopupList", params);

				break;
		}
	}

	function workAssignListLayerSheet_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			// sheetResize();
		} catch(ex) {
			    alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function workAssignListLayerSheet_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			doAction1("Search");

		} catch(ex) {
			    alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function workAssignListLayerSheet_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			
			/* RD 존재하지않음. 주석처리
			if( ( row > 0 ) && (workAssignListLayerSheet.ColSaveName(col) == "detail") ){
				alert("관련 출력물을 제공합니다.");
				return;
			}
			*/

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="srchFrm" name="srchFrm" >
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='' mdef='단위업무명' /></th>
							<td>
								<input id="searchWorkAssignNm" name="searchWorkAssignNm" type="Text" class="text" />
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='search' mdef='조회' />
							</td>
						</tr>

					</table>
				</div>
			</div>
		</form>
		<form id="workAssignListLayerSheetForm" name="workAssignListLayerSheetForm"></form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt1" class="txt"><tit:txt mid='' mdef='직무별단위업무'/></li>
					<li class="btn">

					</li>
				</ul>
			</div>
		</div>
<%--		<script type="text/javascript">createIBSheet("workAssignListLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="workAssignListLayerSheet-wrap"></div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('workAssignListLayer');" css="gray large" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>
</html>
