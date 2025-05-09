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
	var gPRow = "";
	var pGubun = "";

	$(function() {
		
		$("input:text", "#srchFrm").on("keyup", function(event) {
			if (event.keyCode == 13) {
				doAction1("Search");
				$(this).focus();
			}
		});
		$("select", "#srchFrm").on("change", function(e){
			doAction1("Search");
			$(this).focus();
		});
		
		var activeYyyyCdLists = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getActiveYyyyList",false).codeList, ("${ssnLocaleCd}" == "ko_KR" ? "" : "") );
		var registCdLists = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getRegistRadioList",false).codeList, ("${ssnLocaleCd}" == "ko_KR" ? "전체" : "ALL") );
		
		$("#searchActiveYyyy").html(activeYyyyCdLists[2]);
		$("#searchRegist").html(registCdLists[2]);

		$("#searchActiveYyyy").change(function () {
			getCommonCodeList();
		});

		getCommonCodeList();

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:1, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'            mdef='No'		/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'        mdef='삭제'		/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'        mdef='상태'		/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='sabun'          mdef='사번'		/>", Type:"Text"     , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0 ,SaveName:"sabun"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='name'           mdef='이름'		/>", Type:"Text"     , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0 ,SaveName:"name"           , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='orgNm'          mdef='소속'		/>", Type:"Text"     , Hidden:0                  , Width:150         , Align:"Center", ColMerge:0 ,SaveName:"orgNm"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='jikchakNm'      mdef='직책'		/>", Type:"Text"     , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0 ,SaveName:"jikchakNm"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='jikweeNm_V7'    mdef='직위'		/>", Type:"Text"     , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0 ,SaveName:"jikweeNm"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='jikgubNm'       mdef='직급'		/>", Type:"Text"     , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0 ,SaveName:"jikgubNm"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='approvalReqYmd' mdef='승인등록일'	/>", Type:"Date"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0 ,SaveName:"approvalReqYmd" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:"Ymd" },
			{Header:"<sht:txt mid='registed'       mdef='등록여부'		/>", Type:"Text"     , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0 ,SaveName:"registed"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='regYmd'         mdef='등록일'		/>", Type:"Text"     , Hidden:0                  , Width:90          , Align:"Center", ColMerge:0 ,SaveName:"regYmd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:"Ymd" },
			{Header:"<sht:txt mid='orgCd'          mdef='조직코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0 ,SaveName:"orgCd"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='jikgubCd'       mdef='직급코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0 ,SaveName:"jikgubCd"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='jikweeCdV2'     mdef='직위코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0 ,SaveName:"jikweeCd"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='jikchakCd'      mdef='직책코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0 ,SaveName:"jikchakCd"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    },
			{Header:"<sht:txt mid='statusCd'       mdef='재직코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0 ,SaveName:"statusCd"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, PointCount:0, CalcLogic:"", Format:""    }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetVisible(true); sheet1.SetCountPosition(4);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});

	function getCommonCodeList() {
		let searchYear = $("#searchActiveYyyy").val();
		let baseSYmd = searchYear + "-01-01";
		let baseEYmd = searchYear + "-12-31";

		const halfGubunTypeCdLists = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005", baseSYmd, baseEYmd), "");
		$("#searchHalfGubunType").html(halfGubunTypeCdLists[2]);
	}

	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/SelfReportRegStatistics.do?cmd=getSelfReportRegStatisticsList", $("#srchFrm").serialize());
				break;
		}
	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);
			doAction1("Search");
		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
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

			let layerModal = new window.top.document.LayerModal({
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

	function getReturnValue(result) {
		if(pGubun == "searchOrgBasicPopup"){
			$("#searchOrgCd").val(result[0].orgCd);
			$("#searchOrgNm").val(result[0].orgNm);
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
						<th>등록구분</th>
						<td>
							<select id="searchRegist" name="searchRegist"></select>
						</td>
						<th><tit:txt mid='104279' mdef='소속' /></th>
						<td>
							<input  type="text" id="searchOrgNm" name ="searchOrgNm" class="text w120 readonly" readOnly />
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
							<a onclick="javascript:orgSearchPopup();"            class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='' mdef='사번/성명' /></th>
						<td>
							<input type="text" id="searchSabunName" name ="searchSabunName" class="w150" />
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
				<li id="txt1" class="txt"><tit:txt mid='2020021300009' mdef='자기신고서 등록현황'/></li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
