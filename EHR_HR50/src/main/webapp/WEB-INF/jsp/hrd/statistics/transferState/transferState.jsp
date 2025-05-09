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
			{Header:"<sht:txt mid='sNo'        mdef='No|No'   />"           ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제' />"              ,Type:"${sDelTy}" ,Hidden:1                    ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태' />"              ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='BLANK'        mdef='이름|이름'         />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"name"          ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='조직|조직'         />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"orgNm"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='직책|직책'         />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikchakNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='직위|직위'         />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikweeNm"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='직급|직급'         />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikgubNm"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='백업대상|백업대상' />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"transferNm01"  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='대체가능자|1순위'  />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"successorNm01" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='대체가능자|2순위'  />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"successorNm02" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='대체가능자|3순위'  />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"successorNm03" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='대체가능자|상세'   />" ,Type:"Image"     ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"detail"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='他\n승계|他\n승계' />" ,Type:"Image"     ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"detail2"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='대상년도|대상년도'                  />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"activeYyyy"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='반기구분|반기구분'                  />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"halfGubunType" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='사번|사번'                  />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"sabun"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" }
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_quest.png");
		sheet1.SetDataLinkMouse("detail2", 1);


		loadUI();
		loadEvent();

		sheetInit();

		doAction1("Search");
	});

	function loadUI(){
		$(window).smartresize(sheetResize);

		SetSelectLookup($("#searchActiveYyyy"), stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getActiveYyyyList",false).codeList, "" ) ); //년도

		SetSelectLookup($("#searchHalfGubunType"), convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "") ); //반기구분
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
				var params = "searchActiveYyyy="      + $("#searchActiveYyyy"   ).val() +
							 "&searchHalfGubunType="  + $("#searchHalfGubunType").val() +
						     "&searchOrgCd="          + $("#searchOrgCd"        ).val()+
							 "&searchName="           + $("#searchName"         ).val();

				sheet1.DoSearch( "${ctx}/TransferState.do?cmd=getTransferStateList", params);
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
			if ( sheet1.ColSaveName(col) == "detail") {
				var selectedRow = sheet1.GetSelectRow();

				var searchActiveYyyy    = sheet1.GetCellValue(selectedRow, "activeYyyy"   );
				var searchHalfGubunType = sheet1.GetCellValue(selectedRow, "halfGubunType");
				var searchSabun         = sheet1.GetCellValue(selectedRow, "sabun"        );

				SelfReportRegistPopup(searchActiveYyyy, searchHalfGubunType, searchSabun, 3);
			} else if (sheet1.ColSaveName(col) == "detail2") {
				var selectedRow = sheet1.GetSelectRow();

				var searchActiveYyyy    = sheet1.GetCellValue(selectedRow, "activeYyyy"   );
				var searchHalfGubunType = sheet1.GetCellValue(selectedRow, "halfGubunType");
				var searchSabun         = sheet1.GetCellValue(selectedRow, "sabun"        );

				SuccesorStateDetailPopup(searchActiveYyyy, searchHalfGubunType, searchSabun, 2);
			}

			//doAction1("Search");

		} catch(ex) {
			    alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
// 		if (sheet1.CellSaveName(NewRow, NewCol) == "detail"){
// 			var selectedRow = sheet1.GetSelectRow();

// 			var searchActiveYyyy    = sheet1.GetCellValue(selectedRow, "activeYyyy"   );
// 			var searchHalfGubunType = sheet1.GetCellValue(selectedRow, "halfGubunType");
// 			var searchSabun         = sheet1.GetCellValue(selectedRow, "sabun"        );

// 			SelfReportRegistPopup(searchActiveYyyy, searchHalfGubunType, searchSabun, 3);

// 		}
// 		else if (sheet1.CellSaveName(NewRow, NewCol) == "detail2"){
// 			var selectedRow = sheet1.GetSelectRow();

// 			var searchActiveYyyy    = sheet1.GetCellValue(selectedRow, "activeYyyy"   );
// 			var searchHalfGubunType = sheet1.GetCellValue(selectedRow, "halfGubunType");
// 			var searchSabun         = sheet1.GetCellValue(selectedRow, "sabun"        );

// 			SuccesorStateDetailPopup(searchActiveYyyy, searchHalfGubunType, searchSabun, 2);

// 		}
	}

	var SelfReportRegistPopup = function(searchActiveYyyy, searchHalfGubunType, searchSabun, searchTabIndex){
		try {
			if(!isPopup()) {return;}

			gPRow = "";

			<%--openPopup("${ctx}/SelfReportRegist.do?cmd=viewSelfReportRegistPopup", args, "1250","750");--%>

			let w = 1250;
			let h = 750;
			let url = "/SelfReportRegist.do?cmd=viewSelfReportRegistLayer";
			let p = {
				searchActiveYyyy : searchActiveYyyy,
				searchHalfGubunType : searchHalfGubunType,
				searchSabun : searchSabun,
				searchTabIndex : searchTabIndex
			};

			let selfReportRegistLayer = new window.top.document.LayerModal({
				id : 'selfReportRegistLayer'
				, url : url
				, parameters : p
				, width : w
				, height : h
				, title : '자기신고서조회'
				, trigger :[
					{
						name : 'selfReportRegistLayerTrigger'
						, callback : function(result){

						}
					}
				]
			});
			selfReportRegistLayer.show();

		}
		catch(ex)
		{
			alert("Open Popup Event Error : " + ex);
		}
	}

	var SuccesorStateDetailPopup = function(searchActiveYyyy, searchHalfGubunType, searchSabun){
		try {
			if(!isPopup()) {return;}
			gPRow = "";

			// openPopup("${ctx}/TransferState.do?cmd=viewsuccessorStateDetailPopup", args, "900","700");

			let w = 740;
			let h = 520;
			let url = "/TransferState.do?cmd=viewSuccessorStateDetailLayer";
			let p = {
				searchActiveYyyy : searchActiveYyyy,
				searchHalfGubunType : searchHalfGubunType,
				searchSabun : searchSabun
			};

			const successorStateDetailLayer = new window.top.document.LayerModal({
				id : 'successorStateDetailLayer'
				, url : url
				, parameters : p
				, width : w
				, height : h
				, title : '<tit:txt mid='orgSchList' mdef='업무대체자조회'/>'
				, trigger :[
					{
						name : 'successorStateDetailLayerTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			successorStateDetailLayer.show();

		}
		catch(ex)
		{
			alert("Open Popup Event Error : " + ex);
		}
	};

	function orgSearchPopup(){
		try {
			if(!isPopup()) {return;}

			gPRow = "";
			pGubun = "searchOrgBasicPopup";

			// openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
			let w = 740;
			let h = 520;
			let url = "/Popup.do?cmd=viewOrgBasicLayer";

			const orgLayer = new window.top.document.LayerModal({
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
							console.log(result)
							$("#searchOrgCd").val(result[0].orgCd);
							$("#searchOrgNm").val(result[0].orgNm);
						}
					}
				]
			});
			orgLayer.show();
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
						<th><tit:txt mid='104279' mdef='소속' /></th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:120px"/>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
							<a onclick="javascript:orgSearchPopup();"            class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='103880' mdef='성명' /></th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="w150" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='search' mdef='조회' />
						</td>
					</tr>

				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt1" class="txt"><tit:txt mid='' mdef='업무대체가능자현황'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel')"	css="basic" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
