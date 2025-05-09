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
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'               mdef='No'			/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'           mdef='삭제'			/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0, HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'           mdef='상태'			/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"<sht:txt mid='sabun'             mdef='사번'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='name'              mdef='성명'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"name"             , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='orgNm'             mdef='소속'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"orgNm"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikchakNm'         mdef='직책'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikchakNm"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikweeNm_V7'       mdef='직위'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikweeNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikgubNm'          mdef='직급'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikgubNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalStatus'    mdef='진행상태'		/>", Type:"Combo"    , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalStatus"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='2020021400002'     mdef='요청일'		/>", Type:"Date"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalReqYmd"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalEmpNo'     mdef='승인자'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalEmpNo"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalEmpName'   mdef='승인자'		/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalEmpName"  , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalYmd'       mdef='승인일'		/>", Type:"Date"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalYmd"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='registed'          mdef='지식-스킬'		/>", Type:"Image"    , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"registed"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='statusCd'          mdef='재직상태'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"statusCd"         , keyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='sabun'             mdef='사번'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='activeStartYmd'    mdef='시작일자'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeStartYmd"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='orgCd'             mdef='조직코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"orgCd"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikgubCd'          mdef='직급코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikgubCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikweeCd'          mdef='직위코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikweeCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikchakCd'         mdef='직책코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikchakCd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='enterCd'           mdef='회사코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='activeYyyy'        mdef='대상년도'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='halfGubunType'     mdef='반기구분'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"halfGubunType"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalMainOrgCd' mdef='승인메인조직코드'	/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgCd", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalOrgCd'     mdef='승인조직코드'	/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalOrgCd"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("registed", 1);

		loadUI();
		loadEvent();

		sheetInit();
	});

	function loadUI(){
		$(window).smartresize(sheetResize);
		
		// 그룹코드 조회
		SetSelectLookup($("#searchActiveYyyy"),
				stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getActiveYyyyList",false).codeList, ("${ssnLocaleCd}" == "ko_KR" ? "" : "") ) ); //년도

		SetSelectLookup($("#searchApprovalStatus"),
				stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getApprovalStatusListForSearching",false).codeList, ("${ssnLocaleCd}" == "ko_KR" ? "전체" : "ALL") ) ); //년도

		getCommonCodeList();

	}

	function getCommonCodeList() {
		let searchYear = $("#searchActiveYyyy").val();
		let baseSYmd = searchYear + "-01-01";
		let baseEYmd = searchYear + "-12-31";

		// 그룹코드 조회
		let grpCds = "D00005,D00007";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "");
		SetSelectLookup($("#searchHalfGubunType"), codeLists["D00005"] ); //반기구분
		SetSheetColumnLookup(sheet1, "approvalStatus", codeLists["D00007"] );
	}

	function loadEvent(){
		$("input:text").each(function(index){
			EnterKeyEvent(this, doAction1, "Search")
		});

		$("select").each(function(index){
			SelectChangeEvent(this, doAction1, "Search");
		});

		$("#searchActiveYyyy").change(function () {
			getCommonCodeList();
		})
	}

	function loadLookupCombo(sheet, fieldName, codeList){
		sheet.SetColProperty(fieldName, {ComboText:"|"+codeList[0], ComboCode:"|"+codeList[1]} );
	}

	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				var params = "searchActiveYyyy="      + $("#searchActiveYyyy").val() +
						     "&searchHalfGubunType="  + $("#searchHalfGubunType").val() +
						     "&searchOrgCd="          + $("#searchOrgCd").val() +
				             "&searchApprovalStatus=" + $("#searchApprovalStatus").val() +
				             "&searchSabunName="      + $("#searchSabunName").val();

				sheet1.DoSearch( "${ctx}/SelfRatingStatisticsRegist.do?cmd=getSelfRatingStatisticsRegistList", params);
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
						<th><tit:txt mid='112589' mdef='진행상태' /></th>
						<td>
							<select id="searchApprovalStatus" name="searchApprovalStatus"></select>
						</td>
						<th><tit:txt mid='104279' mdef='소속' /></th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:120px"/>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
							<a onclick="javascript:orgSearchPopup();"            class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th>사번/성명</th>
						<td>
							<input type="text" id="searchSabunName" name="searchSabunName" style="width:150px;" />
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
				<li id="txt1" class="txt"><tit:txt mid='2020021500003' mdef='스킬/지식등록현황'/></li>
				<li class="btn">
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
