<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
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

	var SetSheetColumnLookup = function(sheet, columnName, lookupList){
		sheet.SetColProperty(columnName, 	{ComboText:"|"+ lookupList[0], ComboCode:"|"+lookupList[1]} );
	}

	var SetSelectLookup = function(selectObject, lookupList){
		selectObject.html(lookupList[2]);
	}

	$(function() {
		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo V1'        	mdef='No|No'     />"  ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V1'      mdef='삭제|삭제' />"  ,Type:"${sDelTy}" ,Hidden:1                    ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus V1' 		mdef='상태|상태'      />"  ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0 },
			{Header:"<sht:txt mid='BLANK'      		mdef='직급|직급' />"  ,Type:"Text"      ,Hidden:0                    ,Width:80               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikgubNm"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'      		mdef='평균|평균' />"  ,Type:"Int"       ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"avgPoint"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" }
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);


		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'     	mdef='No'       />"  ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'     mdef='삭제'     />"  ,Type:"${sDelTy}" ,Hidden:1                    ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' 	mdef='상태'     />"  ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0 },
			{Header:"<sht:txt mid='BLANK'       mdef='설문내용' />"  ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"surveyItemNm"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'       mdef='점수'     />"  ,Type:"Int"       ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"point"          ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" }
		];
		IBS_InitSheet(sheet2, initdata);
		sheet2.SetVisible(true);
		sheet2.SetCountPosition(4);

		loadUI();
		loadEvent();

		sheetInit();

	});

	function loadGridHeaderAndData(){
		var params = "searchActiveYyyy="      + $("#searchActiveYyyy").val() +
					"&searchHalfGubunType="  + $("#searchHalfGubunType").val() +
					"&searchOrgCd="          + $("#searchOrgCd").val();

		var dataList = ajaxCall("${ctx}/WorkSatisfactionPositionStatistics.do?cmd=getWorkSatisfactionPositionStatisticsSurveyItemList", params, false);

		var index = 0;
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly, FrozenCol:7};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

		initdata1.Cols = [];
		initdata1.Cols[index++] = {Header:"<sht:txt mid='sNo V1'      	mdef='No|No'     	/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[index++] = {Header:"<sht:txt mid='BLANK'        	mdef='직급|직급'		/>" ,Type:"Text"      ,Hidden:0                    ,Width:80               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikgubNm"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" };
		initdata1.Cols[index++] = {Header:"<sht:txt mid='BLANK'        	mdef='평균|평균' 		/>" ,Type:"Int"       ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"avgPoint"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" };
		initdata1.Cols[index++] = {Header:"<sht:txt mid='BLANK'        	mdef='회사코드'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"enterCd"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" };
		initdata1.Cols[index++] = {Header:"<sht:txt mid='BLANK'        	mdef='대상년도'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"activeYyyy"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" };
		initdata1.Cols[index++] = {Header:"<sht:txt mid='BLANK'        	mdef='반기구분'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"halfGubunType"  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" };
		initdata1.Cols[index++] = {Header:"<sht:txt mid='BLANK'        	mdef='직급코드'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikgubCd"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" };

		for(var i=0; i < dataList.DATA.length; i++) {
			initdata1.Cols[index++]  = { Header:'항목별점수|' + dataList.DATA[i].surveyItemNm,	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:dataList.DATA[i].surveyItemCd,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0, Wrap : 1, MultiLineText : 1};
		}

		sheet1.Reset();
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

		sheet1.DoSearch( "${ctx}/WorkSatisfactionPositionStatistics.do?cmd=getWorkSatisfactionPositionStatisticsList", params);

	}

	function loadUI(){
		$(window).smartresize(sheetResize);

		SetSelectLookup($("#searchActiveYyyy"),
				stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getActiveYyyyList",false).codeList, "" ) ); //년도

		SetSelectLookup($("#searchHalfGubunType"),
				convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "") ); //반기구분

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

	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				loadGridHeaderAndData();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;
			case "SearchDetail":
				var selectedRow = sheet1.GetSelectRow();

				var params = "searchActiveYyyy="      + sheet1.GetCellValue(selectedRow, "activeYyyy"  ) +
					   	     "&searchHalfGubunType="  + sheet1.GetCellValue(selectedRow, "halfGubunType") +
						     "&searchJikgubCd="       + sheet1.GetCellValue(selectedRow, "jikgubCd");

				sheet2.DoSearch( "${ctx}/WorkSatisfactionPositionStatistics.do?cmd=getWorkSatisfactionPositionStatisticsItem", params);
		}

	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			sheetResize();

			if 	(sheet1.RowCount() != 0 ){
				sheet1.SetSelectRow(sheet1.HeaderRows());
				doAction1("SearchDetail");
			}

		} catch(ex) {
			    alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			doAction1("Search");

		} catch(ex) {
			    alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if ( sheet1.ColSaveName(col) == "colName") {
				//TODO something
				return;
			}

			doAction1("SearchDetail");

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function orgSearchPopup(){
		try {
			if(!isPopup()) {return;}

			var args    = new Array();

			gPRow = "";
			pGubun = "searchOrgBasicPopup";

			openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
		}
		catch(ex)
		{
			alert("Open Popup Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "searchOrgBasicPopup"){
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
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
						<th><tit:txt mid='104305' mdef='년도' /></th>
						<td>
							<select id="searchActiveYyyy" name="searchActiveYyyy"></select>
						</td>
						<th><tit:txt mid='113890' mdef='반기구분' /></th>
						<td>
							<select id="searchHalfGubunType" name="searchHalfGubunType"></select>
						</td>
						<td>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104279' mdef='소속' /></th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:120px"/>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
							<a onclick="javascript:orgSearchPopup();"            class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<td>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='search' mdef='조회' />
						</td>
					</tr>

				</table>
			</div>
		</div>
	</form>
	<form id="sheet1Form" name="sheet1Form"></form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt1" class="txt"><tit:txt mid='2020022100002123' mdef='직급별업무만족도'/></li>
				<li class="btn">

				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	<form id="sheet2Form" name="sheet2Form"></form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt2" class="txt"><tit:txt mid='2020022100003' mdef='업무만족도상세'/></li>
				<li class="btn">

				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
