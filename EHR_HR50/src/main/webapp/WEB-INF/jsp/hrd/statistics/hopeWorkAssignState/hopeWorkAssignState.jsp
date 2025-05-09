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
			{Header:"<sht:txt mid='sNo'     mdef='No'   />"        ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제' />"        ,Type:"${sDelTy}" ,Hidden:1                    ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태' />"        ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='gWorkAssignNm'       	mdef='대분류'      />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"gWorkAssignNm"                  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='mWorkAssignNm'        	mdef='중분류'      />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"mWorkAssignNm"                  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='sWorkAssignNm'        	mdef='단위업무'    />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"sWorkAssignNm"                  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='appCnt'        			mdef='희망인원'    />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"appCnt"                         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='enterCd'        			mdef='회사코드'            />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"enterCd"                        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='activeYyyy'        		mdef='대상년도'            />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"activeYyyy"                     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='halfGubunType'        	mdef='반기구분'            />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"halfGubunType"                  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='gWorkAssignCd'        	mdef='gWorkAssignCd'            />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"gWorkAssignCd"                  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='mWorkAssignCd'        	mdef='mWorkAssignCd'            />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"mWorkAssignCd"                  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='sWorkAssignCd'        	mdef='sWorkAssignCd'            />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"sWorkAssignCd"                  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" }

		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'     mdef='No'   />"        ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제' />"        ,Type:"${sDelTy}" ,Hidden:1                    ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태' />"        ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='name'        mdef='이름'        />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"name"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='orgNm'        mdef='조직'        />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"orgNm"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='jikchakNm'        mdef='직책'        />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikchakNm"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='jikweeNm_V7'        mdef='직위'        />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikweeNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='jikgubNm'        mdef='직급'        />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"jikgubNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='moveHopeTime'        mdef='희망시기'    />" ,Type:"Combo"     ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"moveHopeTime" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='rating'        mdef='희망순위'    />" ,Type:"Text"      ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"rating"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='BLANK'        mdef='세부내역'        />" ,Type:"Image"     ,Hidden:0                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"detail"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" },
			{Header:"<sht:txt mid='sabun'        mdef='사번'            />" ,Type:"Text"      ,Hidden:1                    ,Width:50               ,Align:"Center" ,ColMerge:0 ,SaveName:"sabun"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:"" }
		];
		IBS_InitSheet(sheet2, initdata);
		sheet2.SetVisible(true);
		sheet2.SetCountPosition(4);
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetDataLinkMouse("detail", 1);

		loadUI();
		loadEvent();

		sheetInit();

		doAction1("Search");
	});

	function loadUI(){
		$(window).smartresize(sheetResize);

		SetSheetColumnLookup(sheet2, "moveHopeTime", convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D10010"), "") );

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
				var params = "searchActiveYyyy=" + $("#searchActiveYyyy"   ).val() +
						"&searchHalfGubunType="  + $("#searchHalfGubunType").val() +
						"&searchWorkAssignNm="   + $("#searchWorkAssignNm" ).val() ;

				sheet1.DoSearch( "${ctx}/HopeWorkAssignState.do?cmd=getHopeWorkAssignStateList", params);
				break;

			case "SearchDetail":
				var selectedRow = sheet1.GetSelectRow();

				var params = "searchActiveYyyy="      + sheet1.GetCellValue(selectedRow, "activeYyyy"  ) +
					      	 "&searchHalfGubunType="  + sheet1.GetCellValue(selectedRow, "halfGubunType") +
						     "&searchWorkAssignCd="   + sheet1.GetCellValue(selectedRow, "sWorkAssignCd");

				sheet2.DoSearch( "${ctx}/HopeWorkAssignState.do?cmd=getHopeWorkAssignStateDetailList", params);
				break;
		}
	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			sheet1.SetSelectRow(sheet1.HeaderRows());

			doAction1("SearchDetail");

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

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

	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		if (sheet2.CellSaveName(NewRow, NewCol) == "detail"){
// 			var selectedRow1 = sheet1.GetSelectRow();
// 			var selectedRow2 = sheet2.GetSelectRow();

// 			var searchActiveYyyy    = sheet1.GetCellValue(selectedRow1, "activeYyyy"   );
// 			var searchHalfGubunType = sheet1.GetCellValue(selectedRow1, "halfGubunType");
// 			var searchSabun         = sheet2.GetCellValue(selectedRow2, "sabun"        );

// 			SelfReportRegistPopup(searchActiveYyyy, searchHalfGubunType, searchSabun, 2);

		}

	}
	function sheet2_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if ( sheet2.ColSaveName(col) == "detail") {
				var selectedRow1 = sheet1.GetSelectRow();
				var selectedRow2 = sheet2.GetSelectRow();

				var searchActiveYyyy    = sheet1.GetCellValue(selectedRow1, "activeYyyy"   );
				var searchHalfGubunType = sheet1.GetCellValue(selectedRow1, "halfGubunType");
				var searchSabun         = sheet2.GetCellValue(selectedRow2, "sabun"        );

				SelfReportRegistPopup(searchActiveYyyy, searchHalfGubunType, searchSabun, 2);
			}

			//doAction2("Search");

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	var SelfReportRegistPopup = function(searchActiveYyyy, searchHalfGubunType, searchSabun, searchTabIndex){
		try {
			if(!isPopup()) {return;}

			gPRow = "";
			<%--openPopup("${ctx}/SelfReportRegist.do?cmd=viewSelfReportRegistPopup", args, "1250","700");--%>

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
						<th><tit:txt mid='2020021500006' mdef='단위업무명' /></th>
						<td>
							<input id="searchWorkAssignNm" name ="searchWorkAssignNm" type="text" class="text" />
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
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='2020021500007' mdef='단위업무별이동희망자현황'/></li>
				<li class="btn"></li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	<form id="sheet2Form" name="sheet2Form"></form>
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='2020021500008' mdef='이동희망자'/></li>
				<li class="btn"></li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
