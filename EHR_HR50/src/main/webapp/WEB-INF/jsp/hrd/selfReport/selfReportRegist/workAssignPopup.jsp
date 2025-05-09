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
	var p = eval("${popUpStatus}");

	// var EnterKeyEvent = function(control, searchFunc, searchParam){
	// 	$(control).bind("keyup", function(event) {
	// 		if (event.keyCode == 13) {
	// 			searchFunc(searchParam);
	// 			$(control).focus();
	// 		}
	// 	});
	// };
	//
	// var SelectChangeEvent = function(control, searchFunc, searchParam){
	// 	$(control).on("change", function() {
	// 		searchFunc(searchParam);
	// 		$(control).focus();
	// 	});
	// };

	var SelectChangeEvent = function(control, searchFunc, searchParam){
		sheet.SetColuProperty(columnName, {ComboText:"|"+ lookupList[0], ComboCode:"|"+lookupList[1]});
	};

	var SetSelectLookup = function(selectObject, lookupList){
		selectObject.html(lookupList[2]);
	}

	$(function() {
		var arg = p.popDialogArgumentAll();
		console.log('arg', arg);
		if( arg != undefined ) {
			$("#chooseCds").val(arg["chooseCds"]);
		}

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'            mdef='No'				/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}"  , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'        mdef='삭제'				/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}" , Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'        mdef='상태'				/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}" , Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='gWorkAssignNm'  mdef='대분류'				/>", Type:"Text"     , Hidden:0                  , Width:150          , Align:"Center", ColMerge:0, SaveName:"gWorkAssignNm" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='mWorkAssignNm'  mdef='중분류'				/>", Type:"Text"     , Hidden:0                  , Width:150          , Align:"Center", ColMerge:0, SaveName:"mWorkAssignNm" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='sWorkAssignNm'  mdef='단위업무'				/>", Type:"Text"     , Hidden:0                  , Width:150          , Align:"Center", ColMerge:0, SaveName:"sWorkAssignNm" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='gWorkAssignCd'  mdef='gWorkAssignCd'		/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"gWorkAssignCd" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='mWorkAssignCd'  mdef='mWorkAssignCd'		/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"mWorkAssignCd" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='sWorkAssignCd'  mdef='sWorkAssignCd'		/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"sWorkAssignCd" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='appType'        mdef='appType'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"appType"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='systemType'     mdef='systemType'		/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"systemType"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='groupType'      mdef='groupType'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"groupType"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jobCd'          mdef='jobCd'				/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"jobCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='useYn'          mdef='useYn'				/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"useYn"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='startYmd'       mdef='startYmd'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"startYmd"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='endYmd'         mdef='endYmd'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"endYmd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='workAssignDesc' mdef='workAssignDesc'	/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"workAssignDesc", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='appCd'          mdef='appCd'				/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"appCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='initCd'         mdef='initCd'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"initCd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='subjectCd'      mdef='subjectCd'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"subjectCd"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='itsmCd'         mdef='itsmCd'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"itsmCd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='rtoCd'          mdef='rtoCd'				/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"rtoCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='rtoValue'       mdef='rtoValue'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"rtoValue"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='rtoYn'          mdef='rtoYn'				/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"rtoYn"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='orgCd'          mdef='orgCd'				/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"orgCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='orgNm'          mdef='orgNm'				/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"orgNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikryulCd'      mdef='jikryulCd'			/>", Type:"Text"     , Hidden:1                  , Width:50           , Align:"Center", ColMerge:0, SaveName:"jikryulCd"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		loadUI();
		loadEvent();

		sheetInit();

		doAction1("Search");
		
		$(".close").click(function() {
			p.self.close();
		});
	});

	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				var params = "gWorkAssignCd=" + $("#gWorkAssign").val() +
						     "&mWorkAssignCd=" + $("#mWorkAssign").val();
				sheet1.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getWorkAssignPopupList", params);
				break;
		}
	}

	function loadUI(){
		$(window).smartresize(sheetResize);

		SetSelectLookup($("#gWorkAssign"),  stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGWorkAssignList",false).codeList,
				("${ssnLocaleCd}" == "ko_KR" ? "선택" : "SELECT") ) ); //대분류

		SetSelectLookup($("#mWorkAssign"),  stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getMWorkAssignList",false).codeList,
				("${ssnLocaleCd}" == "ko_KR" ? "선택" : "SELECT") ) ); //중분류
	}

	function loadEvent(){
		// $("input:text").each(function(index){
		// 	EnterKeyEvent(this, doAction1, "Search")
		// });
		//
		// $("select").each(function(index){
		// 	SelectChangeEvent(this, doAction1, "Search");
		// })

		$("#gWorkAssign").on('change', function(){
			var gWorkAssignCd = $("#gWorkAssign").val();
//			var params = "gWorkAssignCd=" + gWorkAssignCd;
			SetSelectLookup($("#mWorkAssign"),  stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getMWorkAssignList&gWorkAssign=" + gWorkAssignCd,false).codeList,
					("${ssnLocaleCd}" == "ko_KR" ? "선택" : "SELECT") ) ); //중분류
		});
	}

	function loadLookupCombo(sheet, fieldName, codeList){
		sheet.SetColProperty(fieldName, {ComboText:"|"+codeList[0], ComboCode:"|"+codeList[1]} );
	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){
		try{
			returnWorkAssign(Row,Col);
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

	function returnWorkAssign(Row,Col){
		var returnValue = new Array(6);
		var isAlready = false;
		
		// 중복체크
		/*if( $("#chooseCds").val().indexOf("|" + sheet1.GetCellValue(Row, "sWorkAssignCd") + "|") > -1 ) {
			isAlready = true;
			alert("이미 선택되어 있는 업무입니다.");
		}*/
		
		if( !isAlready ) {
			returnValue["gWorkAssignCd"] = sheet1.GetCellValue(Row, "gWorkAssignCd");
			returnValue["gWorkAssignNm"] = sheet1.GetCellValue(Row, "gWorkAssignNm");
			returnValue["mWorkAssignCd"] = sheet1.GetCellValue(Row, "mWorkAssignCd");
			returnValue["mWorkAssignNm"] = sheet1.GetCellValue(Row, "mWorkAssignNm");
			returnValue["workAssignCd" ] = sheet1.GetCellValue(Row, "sWorkAssignCd");
			returnValue["workAssignNm" ] = sheet1.GetCellValue(Row, "sWorkAssignNm");
			
			if(p.popReturnValue) p.popReturnValue(returnValue);
			p.self.close();
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='2020021200005' mdef='단위업무체계조회'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="srchFrm" name="srchFrm" >
			<div class="sheet_search outer">
				<table>
					<tr>
						<th><tit:txt mid='2020021300001' mdef='대분류' /></th>
						<td>
							<select id="gWorkAssign" name="gWorkAssign"></select>
						</td>
						<th><tit:txt mid='2020021300002' mdef='중분류' /></th>
						<td>
							<select id="mWorkAssign" name="mWorkAssign"></select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='search' mdef='조회' />
						</td>
					</tr>
				</table>
			</div>
		</form>
		<form id="sheet1Form" name="sheet1Form">
			<input type="hidden" id="chooseCds" name="chooseCds" />
		</form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='2020021200004' mdef='단위업무체계'/></li>
					<li class="btn"></li>
				</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>
