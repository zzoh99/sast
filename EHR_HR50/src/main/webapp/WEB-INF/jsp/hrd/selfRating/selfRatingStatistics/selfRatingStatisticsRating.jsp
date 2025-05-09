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
	};

	var SetSelectLookup = function(selectObject, lookupList){
		selectObject.html(lookupList[2]);
	};

	$(function() {
		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msAll, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1'            mdef='No|No'								/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'          mdef='삭제'									/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'          mdef='상태'									/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='priorKnowledgeNm' mdef='Category|Category'					/>", Type:"Text"     , Hidden:0                  , Width:200         , Align:"Left"  , ColMerge:0, SaveName:"priorKnowledgeNm", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='knowledgeNm'      mdef='IT Skill|IT Skill'					/>", Type:"Text"     , Hidden:0                  , Width:200         , Align:"Left"  , ColMerge:0, SaveName:"knowledgeNm"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='finalGrade01'     mdef='IT Skill Level 인원분포|고급'				/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"finalGrade01"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='finalGrade02'     mdef='IT Skill Level 인원분포|중급'				/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"finalGrade02"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='finalGrade03'     mdef='IT Skill Level 인원분포|초급'				/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"finalGrade03"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='countFinalGrade'  mdef='IT Skill Level 인원분포|합계'				/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"countFinalGrade" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='avgFinalGrade'    mdef='IT Skill Level 인원분포|환산점수\n(3점만점)'	/>", Type:"Float"    , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"avgFinalGrade"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("registed", 1);

		loadUI();
		loadEvent();
		
		$("#searchSkillTypeCd").change();

		sheetInit();
	});

	function loadUI(){
		$(window).smartresize(sheetResize);

		SetSelectLookup($("#searchActiveYyyy"),
				stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getActiveYyyyList",false).codeList, "" ) ); //년도

		SetSelectLookup($("#searchSkillTypeCd"),
				stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTrmCdList",false).codeList, "" ) );

		getCommonCodeList();

		$("#searchSkillTypeCd").on('change', function(){
			var selectedText = $("#searchSkillTypeCd option:selected").text();
			sheet1.SetCellValue(0, "knowledgeNm"       , selectedText                         );
			sheet1.SetCellValue(0, "finalGrade01"      , selectedText + " Level 인원분포"       );
// 			sheet1.SetCellValue(0, "finalGrade01"      , selectedText + "|고급"               );
// 			sheet1.SetCellValue(0, "finalGrade02"      , selectedText + "|중급"               );
// 			sheet1.SetCellValue(0, "finalGrade03"      , selectedText + "|초급"               );
// 			sheet1.SetCellValue(0, "countFinalGrade01" , selectedText + "|초급"               );
// 			sheet1.SetCellValue(0, "avgFinalGrade01"   , selectedText + "|환산점수\n(3점만점)");
			// SelectChangeEvent(this, doAction1, "Search");
		});
	}

	function getCommonCodeList() {
		let searchYear = $("#searchActiveYyyy").val();
		let baseSYmd = searchYear + "-01-01";
		let baseEYmd = searchYear + "-12-31";

		SetSelectLookup($("#searchHalfGubunType"),
				convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005", baseSYmd, baseEYmd), "") ); //반기구분
		SetSheetColumnLookup(sheet1, "approvalStatus", convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00007", baseSYmd, baseEYmd), "") );
	}

	function loadEvent(){
		$("input:text").each(function(index){
			EnterKeyEvent(this, doAction1, "Search")
		});

		$("select").each(function(index){
			SelectChangeEvent(this, doAction1, "Search");
		});

		$("#searchActiveYyyy").change(function (){
			getCommonCodeList();
		});
	}

	function loadLookupCombo(sheet, fieldName, codeList){
		sheet.SetColProperty(fieldName, {ComboText:"|"+codeList[0], ComboCode:"|"+codeList[1]} );
	}


	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				var params = "searchActiveYyyy="      + $("#searchActiveYyyy").val() +
						     "&searchHalfGubunType="  + $("#searchHalfGubunType").val() +
   						     "&searchSkillTypeCd="    + $("#searchSkillTypeCd").val() +
						     "&searchOrgCd="          + $("#searchOrgCd").val();

				sheet1.DoSearch( "${ctx}/SelfRatingStatisticsRating.do?cmd=getSelfRatingStatisticsRatingList", params);
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;
		}
	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			for(var row = sheet1.GetDataFirstRow(); row <= sheet1.GetDataLastRow(); row++){
				if(sheet1.GetCellValue(row, "finalGrade01") == 0) {
					sheet1.SetCellValue(row, "finalGrade01", "");
				}
				if(sheet1.GetCellValue(row, "finalGrade02") == 0) {
					sheet1.SetCellValue(row, "finalGrade02", "");
				}
				if(sheet1.GetCellValue(row, "finalGrade03") == 0) {
					sheet1.SetCellValue(row, "finalGrade03", "");
				}
				sheet1.SetCellValue(row, "sStatus", "R");
			}
			   
			sheetResize();
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

			//doAction1("Search");

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function orgSearchPopup(){
		try {
			if(!isPopup()) {return;}
			gPRow = "";
			pGubun = "searchOrgBasicPopup";

			// openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
			let w = 740;
			let h = 520;
			let url = "/Popup.do?cmd=viewOrgBasicLayer";

			const layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : url
				, parameters : {}
				, width : w
				, height : h
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			layerModal.show();
		}
		catch(ex)
		{
			alert("Open Popup Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
		if(pGubun == "searchOrgBasicPopup"){
			$("#searchOrgCd").val(returnValue[0].orgCd);
			$("#searchOrgNm").val(returnValue[0].orgNm);
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
						<th><tit:txt mid='103997' mdef='구분' /></th>
						<td>
							<select id="searchSkillTypeCd" name="searchSkillTypeCd"></select>
						</td>
						<th><tit:txt mid='104279' mdef='소속' /></th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:120px"/>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
							<a onclick="javascript:orgSearchPopup();"            class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
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
				<li id="txt1" class="txt"><tit:txt mid='2020021500002' mdef='스킬/지식수준별인원현황'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel')"	css="button" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
