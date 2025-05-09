<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html><head><title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<script src="/common/js/employeeHeaderLayer.js" type="text/javascript" charset="utf-8"></script>
<style type="text/css">
	/*table.default td, table.table td {*/
	/*	border-right: 1px solid #e7edf0 !important;*/
	/*}*/
	/*table.default td:last-child, table.table td:last-child {*/
	/*	border-right: none !important;*/
	/*}*/
</style>
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

	var searchActiveYyyy    = "";
	var searchHalfGubunType = "";
	var searchSabun         = "";
	var searchTabIndex      = -1;

	$(function() {
		createIBSheet3(document.getElementById('selfReportRegistLayerSheet2-wrap'), "selfReportRegistLayerSheet2", "100%", "100%","${ssnLocaleCd}");
		createIBSheet3(document.getElementById('selfReportRegistLayerSheet1-wrap'), "selfReportRegistLayerSheet1", "100%", "100%","${ssnLocaleCd}");

		let modalId = 'selfReportRegistLayer';
		let modal = window.top.document.LayerModalUtility.getModal(modalId);

		searchActiveYyyy 	= modal.parameters.searchActiveYyyy || '';
		searchHalfGubunType = modal.parameters.searchHalfGubunType || '';
		searchSabun         = modal.parameters.searchSabun || '';
		searchTabIndex      = modal.parameters.searchTabIndex || -1;
		$("#searchUserId").val(searchSabun);

		$( "#tabs" ).tabs();

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'                     mdef='No'   />"          ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"  ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'                 mdef='삭제' />"          ,Type:"${sDelTy}" ,Hidden:1                    ,Width:"${sDelWdt}" ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'                 mdef='상태' />"          ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}" ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='activeYyyy'              mdef='년도'          />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"activeYyyy"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='halfGubunType'           mdef='반기구분'      />" ,Type:"Combo"     ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"halfGubunType"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='sabun'                   mdef='sabun'                />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"sabun"                 ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='careerTargetCd'          mdef='careerTargetCd'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"careerTargetCd"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignCd1'           mdef='workAssignCd1'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCd1"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignCd2'           mdef='workAssignCd2'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCd2"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignCd3'           mdef='workAssignCd3'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCd3"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='moveHopeTime'            mdef='moveHopeTime'         />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"moveHopeTime"          ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='moveHopeCd'              mdef='moveHopeCd'           />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"moveHopeCd"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='moveHopeDesc'            mdef='moveHopeDesc'         />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"moveHopeDesc"          ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgCd1'              mdef='mainOrgCd1'           />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgCd1"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgCd2'              mdef='mainOrgCd2'           />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgCd2"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgCd3'              mdef='mainOrgCd3'           />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgCd3"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgNm1'              mdef='mainOrgNm1'           />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgNm1"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgNm2'              mdef='mainOrgNm2'           />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgNm2"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgNm3'              mdef='mainOrgNm3'           />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgNm3"            ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgCdMoveHopeTime'   mdef='mainOrgCdMoveHopeTime' />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgCdMoveHopeTime" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgCdMoveHopeCd'     mdef='mainOrgCdMoveHopeCd'  />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgCdMoveHopeCd"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgCdMoveHopeDesc'   mdef='mainOrgCdMoveHopeDesc' />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgCdMoveHopeDesc" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='transferEmpNo'           mdef='transferEmpNo'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"transferEmpNo"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='transferDesc'            mdef='transferDesc'         />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"transferDesc"          ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='successorEmpNo1'         mdef='successorEmpNo1'      />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorEmpNo1"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='successorDesc1'          mdef='successorDesc1'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorDesc1"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='successorEmpNo2'         mdef='successorEmpNo2'      />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorEmpNo2"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='successorDesc2'          mdef='successorDesc2'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorDesc2"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='successorEmpNo3'         mdef='successorEmpNo3'      />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorEmpNo3"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='successorDesc3'          mdef='successorDesc3'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorDesc3"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalReqYmd'          mdef='approvalReqYmd'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalReqYmd"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalStatus'          mdef='approvalStatus'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalStatus"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalMainOrgCd'       mdef='approvalMainOrgCd'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalMainOrgCd"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalMainOrgNm'       mdef='approvalMainOrgNm'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalMainOrgNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalOrgCd'           mdef='approvalOrgCd'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalOrgCd"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalOrgNm'           mdef='approvalOrgNm'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalOrgNm"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalEmpNo'           mdef='approvalEmpNo'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalEmpNo"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalEmpName'         mdef='approvalEmpName'      />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalEmpName"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='approvalYmd'             mdef='approvalYmd'          />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"approvalYmd"           ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='careerTargetNm'          mdef='careerTargetNm'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"careerTargetNm"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='careerTargetType'        mdef='careerTargetType'     />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"careerTargetType"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='careerTargetDesc'        mdef='careerTargetDesc'     />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"careerTargetDesc"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNmLarge1'      mdef='workAssignNmLarge1'   />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNmLarge1"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNmMiddle1'     mdef='workAssignNmMiddle1'  />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNmMiddle1"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNm1'           mdef='workAssignNm1'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNm1"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNmLarge2'      mdef='workAssignNmLarge2'   />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNmLarge2"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNmMiddle2'     mdef='workAssignNmMiddle2'  />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNmMiddle2"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNm2'           mdef='workAssignNm2'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNm2"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNmLarge3'      mdef='workAssignNmLarge3'   />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNmLarge3"    ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNmMiddle3'     mdef='workAssignNmMiddle3'  />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNmMiddle3"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignNm3'           mdef='workAssignNm3'        />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignNm3"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignAppCnt1'       mdef='workAssignAppCnt1'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignAppCnt1"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignCurCnt1'       mdef='workAssignCurCnt1'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCurCnt1"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignWrkExp1'       mdef='workAssignWrkExp1'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignWrkExp1"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignAppCnt2'       mdef='workAssignAppCnt2'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignAppCnt2"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignCurCnt2'       mdef='workAssignCurCnt2'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCurCnt2"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignWrkExp2'       mdef='workAssignWrkExp2'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignWrkExp2"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignAppCnt3'       mdef='workAssignAppCnt3'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignAppCnt3"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignCurCnt3'       mdef='workAssignCurCnt3'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignCurCnt3"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='workAssignWrkExp3'       mdef='workAssignWrkExp3'    />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"workAssignWrkExp3"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgAppCnt1'          mdef='mainOrgAppCnt1'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgAppCnt1"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgAppCnt2'          mdef='mainOrgAppCnt2'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgAppCnt2"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='mainOrgAppCnt3'          mdef='mainOrgAppCnt3'       />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"mainOrgAppCnt2"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='enterCd'        			mdef='회사코드'				/>" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"enterCd"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },

			{Header:"transferEmpNm"      ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"transferEmpNm"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"transferOrgNm"      ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"transferOrgNm"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"transferJikgubNm"   ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"transferJikgubNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"transferJikweeNm"   ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"transferJikweeNm"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorEmpNm1"    ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorEmpNm1"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorOrgNm1"    ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorOrgNm1"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorJikgubNm1" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorJikgubNm1"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorJikweeNm1" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorJikweeNm1"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorEmpNm2"    ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorEmpNm2"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorOrgNm2"    ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorOrgNm2"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorJikgubNm2" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorJikgubNm2"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorJikweeNm2" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorJikweeNm2"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorEmpNm3"    ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorEmpNm3"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorOrgNm3"    ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorOrgNm3"      ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorJikgubNm3" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorJikgubNm3"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"successorJikweeNm3" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"successorJikweeNm3"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },

		];
		IBS_InitSheet(selfReportRegistLayerSheet1, initdata);
		selfReportRegistLayerSheet1.SetVisible(true);
		selfReportRegistLayerSheet1.SetCountPosition(4);

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'     mdef='No'   />"                     ,Type:"${sNoTy}"  ,Hidden:Number("${sNoHdn}")  ,Width:"${sNoWdt}"      ,Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제' />"                     ,Type:"${sDelTy}" ,Hidden:1 ,Width:"${sDelWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태' />"                     ,Type:"${sSttTy}" ,Hidden:1                    ,Width:"${sSttWdt}"     ,Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='2020021000003'   mdef='설문항목'           />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"surveyItemNm"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='2020021000004'   mdef='설명'               />" ,Type:"Text"      ,Hidden:0                    ,Width:150          ,Align:"Center" ,ColMerge:0 ,SaveName:"surveyItemDesc" ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='2020021000005'   mdef='본인점수'           />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"point"          ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='2020021000006'   mdef='평균점수'           />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"avgPoint"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='2020021000007'   mdef='차이'               />" ,Type:"Text"      ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"gapPoint"       ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='2020021000008'   mdef='매우 그렇지않다(1)' />" ,Type:"CheckBox"  ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"point1"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , TrueValue:"Y", FalseValue:"N"  },
			{Header:"<sht:txt mid='2020021000009'   mdef='그렇지 않다(2)'     />" ,Type:"CheckBox"  ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"point2"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , TrueValue:"Y", FalseValue:"N"  },
			{Header:"<sht:txt mid='2020021000010'   mdef='보통(3)'            />" ,Type:"CheckBox"  ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"point3"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , TrueValue:"Y", FalseValue:"N"  },
			{Header:"<sht:txt mid='2020021000011'   mdef='그렇다(4)'          />" ,Type:"CheckBox"  ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"point4"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , TrueValue:"Y", FalseValue:"N"  },
			{Header:"<sht:txt mid='2020021000012'   mdef='매우 그렇다(5)'     />" ,Type:"CheckBox"  ,Hidden:0                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"point5"         ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , TrueValue:"Y", FalseValue:"N"  },

			{Header:"<sht:txt mid='enterCd'        mdef='회사코드'              />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"enterCd"        ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='surveyItemCd'   mdef='설문항목'              />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"surveyItemCd"   ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='activeYyyy'     mdef='대상년도'              />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"activeYyyy"     ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='halfGubunType'  mdef='반기구분'              />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"halfGubunType"  ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , },
			{Header:"<sht:txt mid='sabun'          mdef='사번'              />" ,Type:"Text"      ,Hidden:1                    ,Width:50           ,Align:"Center" ,ColMerge:0 ,SaveName:"sabun"          ,KeyField:0 ,UpdateEdit:0 ,InsertEdit:0 ,EditLen:0  ,MultiLineText:0         ,PointCount:0  ,CalcLogic:""         ,Format:""         , }
		];
		IBS_InitSheet(selfReportRegistLayerSheet2, initdata);
		selfReportRegistLayerSheet2.SetVisible(true);
		selfReportRegistLayerSheet2.SetCountPosition(4);

		let sheetHeight = 200;
		selfReportRegistLayerSheet2.SetSheetHeight(sheetHeight);
		selfReportRegistLayerSheet1.SetSheetHeight(sheetHeight);

		loadUI();
		loadEvent();

		doAction1("Search");

		//탭선택
		$("#tabs").tabs({
			active: searchTabIndex-1
		});
	});

	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var params = "searchActiveYyyy="       + searchActiveYyyy
						+ "&searchHalfGubunType=" + searchHalfGubunType
						+ "&searchSabun="         + $("#searchUserId").val();

				selfReportRegistLayerSheet1.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getSelfReportRegistPopupList", params);
				break;
		}
	}

	function doAction2(sAction){
		switch (sAction) {
			case "Search":
				var selectedRow = selfReportRegistLayerSheet1.GetSelectRow();
				var params = "searchEnterCd="        + selfReportRegistLayerSheet1.GetCellValue(selectedRow, "enterCd") +
						"&searchActiveYyyy="    + selfReportRegistLayerSheet1.GetCellValue(selectedRow, "activeYyyy") +
						"&searchHalfGubunType=" + selfReportRegistLayerSheet1.GetCellValue(selectedRow, "halfGubunType") +
						"&searchSabun="         + $("#searchUserId").val();

				selfReportRegistLayerSheet2.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getSurveyPointList", params);
				break;
		}
	}

	function loadUI(){
		SetSheetColumnLookup(selfReportRegistLayerSheet1, "halfGubunType", convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00005"), "") );

		SetSelectLookup($("#moveHopeTime"), convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D10010"), ("${ssnLocaleCd}" == "ko_KR" ? "없음" : "None")) ); //자기신고이동구분

		var moveHopeCdList = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getMoveHopeCdList",false).codeList, ("${ssnLocaleCd}" == "ko_KR" ? "없음" : "None") )
		SetSelectLookup($("#moveHopeCd"), moveHopeCdList); //이동희망사유


		$("#liTab1").addClass('hide');
		$("#liTab2").addClass('hide');
		$("#liTab3").addClass('hide');
		$("#liTab4").addClass('hide');
		$("#layerTabs-1").addClass('hide');
		$("#layerTabs-2").addClass('hide');
		$("#layerTabs-3").addClass('hide');
		$("#layerTabs-4").addClass('hide');
		if (searchTabIndex == 1) {
			$("#liTab1").removeClass('hide');
			$("#layerTabs-1").removeClass('hide');
		} else if (searchTabIndex == 2) {
			$("#liTab2").removeClass('hide');
			$("#layerTabs-2").removeClass('hide');
		} else if (searchTabIndex == 3) {
			$("#liTab3").removeClass('hide');
			$("#layerTabs-3").removeClass('hide');
		} else if (searchTabIndex == 4) {
			$("#liTab4").removeClass('hide');
			$("#layerTabs-4").removeClass('hide');
		}
	}

	function loadEvent(){
		// $("input:text").each(function(index){
		// 	EnterKeyEvent(this, doAction1, "Search")
		// });

		// $("select").each(function(index){
		// 	SelectChangeEvent(this, doAction1, "Search");
		// })

	}

	function loadLookupCombo(sheet, fieldName, codeList){
		sheet.SetColProperty(fieldName, {ComboText:"|"+codeList[0], ComboCode:"|"+codeList[1]} );
	}


	function selfReportRegistLayerSheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			if (selfReportRegistLayerSheet1.RowCount() <= 0){
				alert("조회결과가 없습니다");
				return;
			}

			selfReportRegistLayerSheet1.SetSelectRow(selfReportRegistLayerSheet1.HeaderRows());

			loadData(selfReportRegistLayerSheet1.GetSelectRow());

		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function selfReportRegistLayerSheet1_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			doAction2("Search");

		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function selfReportRegistLayerSheet2_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function selfReportRegistLayerSheet2_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="")
				alert(msg);

			doAction2("Search");
		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}

	}

	var doButtonShowing = function(showing){

		$("#btnSave").hide();
		$("#btnSave2").hide();
		$("#careerTargetSelectButton").hide();
		$("#careerTargetClearButton" ).hide();
		$("#assignSelectButton1"     ).hide();
		$("#assignClearButton1"      ).hide();
		$("#assignSelectButton2"     ).hide();
		$("#assignClearButton2"      ).hide();
		$("#assignSelectButton3"     ).hide();
		$("#assignClearButton3"      ).hide();
		$("#successorSelectButton1"  ).hide();
		$("#successorClearButton1"   ).hide();
		$("#successorSelectButton2"  ).hide();
		$("#successorClearButton2"   ).hide();
		$("#successorSelectButton3"  ).hide();
		$("#successorClearButton3"   ).hide();
		$("#transferSelectButton"    ).hide();
		$("#transferClearButton"     ).hide();
		$("#moveHopeTime"  ).prop('disabled', 'disabled');
		$("#moveHopeCd"    ).prop('disabled', 'disabled');
		$("#moveHopeDesc"  ).prop('disabled', "disabled");
		$("#successorDesc1").prop('disabled', "disabled");
		$("#successorDesc2").prop('disabled', "disabled");
		$("#successorDesc3").prop('disabled', "disabled");
		$("#transferDesc"  ).prop('disabled', "disabled");

	}

	var loadData = function(selectedRow){
		// var selectRow = selfReportRegistLayerSheet1.GetSelectRow();
		var careerTargetType = selfReportRegistLayerSheet1.GetCellText(selectedRow, "careerTargetType");
		if ( careerTargetType == "S" )
			careerTargetTypeNm = "IT Specialist";
		else if ( careerTargetType == "E" )
			careerTargetTypeNm = "IT Expert";
		else if ( careerTargetType == "B" )
			careerTargetTypeNm = "IT Biz. 전문가";
		else
			careerTargetTypeNm = "";

		$("#careerTargetNm"     ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "careerTargetNm"  ));
		$("#careerTargetType"   ).html(careerTargetTypeNm                               );
		$("#careerTargetDesc"   ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "careerTargetDesc"));

		$("#workAssignNmLarge1" ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNmLarge1" ));
		$("#workAssignNmMiddle1").html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNmMiddle1"));
		$("#workAssignNm1"      ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNm1"      ));
		$("#workAssignAppCnt1"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignAppCnt1") + "/" + selfReportRegistLayerSheet1.GetCellText(selectedRow, "workAssignCurCnt1"))
		$("#workAssignWrkExp1"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignWrkExp1"  ));
		$("#workAssignNmLarge2" ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNmLarge2" ));
		$("#workAssignNmMiddle2").html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNmMiddle2"));
		$("#workAssignNm2"      ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNm2"      ));
		$("#workAssignAppCnt2"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignAppCnt2") + "/" + selfReportRegistLayerSheet1.GetCellText(selectedRow, "workAssignCurCnt2"))
		$("#workAssignWrkExp2"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignWrkExp2"  ));
		$("#workAssignNmLarge3" ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNmLarge3" ));
		$("#workAssignNmMiddle3").html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNmMiddle3"));
		$("#workAssignNm3"      ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignNm3"      ));
		$("#workAssignAppCnt3"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignAppCnt3") + "/" + selfReportRegistLayerSheet1.GetCellText(selectedRow, "workAssignCurCnt3"))
		$("#workAssignWrkExp3"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "workAssignWrkExp3"  ));
		$("#moveHopeTime"       ).val(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "moveHopeTime"  ));
		$("#moveHopeCd"         ).val(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "moveHopeCd"    ));
		$("#moveHopeDesc"       ).val(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "moveHopeDesc"  ));

		$("#transferEmpNm"     ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "transferEmpNm"      ));
		$("#transferOrgNm"     ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "transferOrgNm"      ));
		$("#transferJikgubNm"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "transferJikgubNm"   ));
		$("#transferJikWeeNm"  ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "transferJikweeNm"   ));
		$("#transferDesc"      ).val(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "transferDesc"        ));

		$("#successorEmpNm1"   ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "successorEmpNm1"    ));
		$("#successorOrgNm1"   ).html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "successorOrgNm1"    ));
		$("#successorJikgubNm1").html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "successorJikgubNm1" ));
		$("#successorJikWeeNm1").html(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "successorJikweeNm1" ));
		$("#successorDesc1"    ).val(selfReportRegistLayerSheet1.GetCellValue(selectedRow, "successorDesc1"      ));

		$("#successorEmpNm2"   ).html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorEmpNm2"    ));
		$("#successorOrgNm2"   ).html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorOrgNm2"    ));
		$("#successorJikgubNm2").html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorJikgubNm2" ));
		$("#successorJikWeeNm2").html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorJikweeNm2" ));
		$("#successorDesc2"    ).val(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorDesc2"      ));

		$("#successorEmpNm3"   ).html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorEmpNm3"    ));
		$("#successorOrgNm3"   ).html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorOrgNm3"    ));
		$("#successorJikgubNm3").html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorJikgubNm3" ));
		$("#successorJikWeeNm3").html(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorJikweeNm3" ));
		$("#successorDesc3"    ).val(selfReportRegistLayerSheet1.GetCellText(selectedRow, "successorDesc3"      ));

		$("#moveHopeTime").val(selfReportRegistLayerSheet1.GetCellText(selectedRow, "moveHopeTime"    ));
		$("#moveHopeCd"  ).val(selfReportRegistLayerSheet1.GetCellText(selectedRow, "moveHopeCd"      ));

		//TODO 버튼감춤 처리(첫번째 라인(최종자기신고서)이 아니면 수정 불가능한 자료임
		var canEdit = selectedRow == selfReportRegistLayerSheet1.HeaderRows();

		doButtonShowing(canEdit);

		doAction2("Search");
	}

	function selfReportRegistLayerSheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			loadData(row);

			if ( selfReportRegistLayerSheet1.ColSaveName(col) == "colName") {
				//TODO something
				return;
			}

			//doAction1("Search");

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function setEmpPage() {

		doAction1("Search");
	}

</script>
</head>
<body class="hidden">
<div class="wrapper modal_layer">
	<div class="modal_body padb30">
		<%@ include file="/WEB-INF/jsp/common/include/employeeHeaderLayer.jsp"%>

		<div class="hide">
<%--			<script type="text/javascript">createIBSheet("selfReportRegistLayerSheet1", "0%", "0%", "kr"); </script>--%>
			<div id="selfReportRegistLayerSheet1-wrap"></div>
		</div>

		<!-- [START] Tabs -->
		<div id="tabs" class="w100p mat10" style="height: auto;">
			<ul class="inner tab_bottom">
				<li id="liTab1" onclick=""><btn:a href="#layerTabs-1" mid='2020020700014' mdef="경력목표"/></li>
				<li id="liTab2" onclick=""><btn:a href="#layerTabs-2" mid='2020020700015' mdef="이동희망 업무"/></li>
				<li id="liTab3" onclick=""><btn:a href="#layerTabs-3" mid='2020020700016' mdef="업무대체가능자"/></li>
				<li id="liTab4" onclick="javascript:doAction2('Search');"><btn:a href="#layerTabs-4" mid='2020020700017' mdef="업무만족도"/></li>
			</ul>

			<div id="layerTabs-1" class="pad-y-5">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="150px" />
						<col width="*" />
					</colgroup>
					<tr class="h40">
						<th><tit:txt mid='2020020700011' mdef='인재유형'/></th>
						<td>
							<span id="careerTargetNm"/>
						</td>
					</tr>
					<tr class="h40">
						<th><tit:txt mid='2020020700012' mdef='경력목표'/></th>
						<td>
							<span id="careerTargetType" />
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700013' mdef='경력목표개요'/></th>
						<td>
							<span id="careerTargetDesc" />
						</td>
					</tr>
				</table>
			</div>
			<div id="layerTabs-2" class="pad-y-5">
				<table border="0" cellpadding="0" cellspacing="0" class="explain_main default">
					<colgroup>
						<col width="12%" />
						<col width="29%" />
						<col width="29%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th><tit:txt mid='2020020700030' mdef='구분'/></th>
						<th class="pad-x-15 alignC"><tit:txt mid='2020020700024' mdef='1순위'/></th>
						<th class="pad-x-15 alignC"><tit:txt mid='2020020700025' mdef='2순위'/></th>
						<th class="pad-x-15 alignC"><tit:txt mid='2020020700026' mdef='3순위'/></th>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700021' mdef='이동희망단위업무'/></th>
						<td><span id="workAssignNm1"></span></td>
						<td><span id="workAssignNm2"></span></td>
						<td><span id="workAssignNm3"></span></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700019' mdef='대분류'/></th>
						<td><span id="workAssignNmLarge1"/></td>
						<td><span id="workAssignNmLarge2"/></td>
						<td><span id="workAssignNmLarge3"/></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700020' mdef='중분류'/></th>
						<td><span id="workAssignNmMiddle1"/></td>
						<td><span id="workAssignNmMiddle2"/></td>
						<td><span id="workAssignNmMiddle3"/></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700022' mdef='희망인원/현담당인원'/></th>
						<td><span id="workAssignAppCnt1" /></td>
						<td><span id="workAssignAppCnt2" /></td>
						<td><span id="workAssignAppCnt3" /></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700023' mdef='업무경험여부'/></th>
						<td><span id="workAssignWrkExp1" /></td>
						<td><span id="workAssignWrkExp2" /></td>
						<td><span id="workAssignWrkExp3" /></td>
					</tr>
				</table>
				<div class="sheet_title">
					<ul>
						<li class="txt">이동희망여부</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="explain_main default">
					<colgroup>
						<col width="150px" />
						<col width="*" />
					</colgroup>
					<tr>
						<th><tit:txt mid='2020020700027' mdef='이동시기'/></th>
						<td colspan="5">
							<select id="moveHopeTime" name="moveHopeTime"></select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700028' mdef=' 이동희망사유'/></th>
						<td colspan="5">
							<select id="moveHopeCd" name="moveHopeCd"></select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700029' mdef='세부</br>이동희망</br>사유'/></th>
						<td colspan="5">
								<textarea id="moveHopeDesc" style="width:100%" rows="10">
								</textarea>
						</td>
					</tr>
				</table>
			</div>
			<div id="layerTabs-3" class="pad-y-5">
				<table border="0" cellpadding="0" cellspacing="0" class="explain_main default">
					<colgroup>
						<col width="12%" />
						<col width="22%" />
						<col width="22%" />
						<col width="22%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th><tit:txt mid='2020020700030' mdef='구분'/></th>
						<th class="pad-x-15 alignC"><tit:txt mid='2020020700034' mdef='1순위</br>업무대체가능자'/></th>
						<th class="pad-x-15 alignC"><tit:txt mid='2020020700035' mdef='2순위</br>업무대체가능자'/></th>
						<th class="pad-x-15 alignC"><tit:txt mid='2020020700036' mdef='3순위</br>업무대체가능자'/></th>
						<th class="pad-x-15 alignC"><tit:txt mid='2020020700037' mdef='즉시대체가능자</br>(백업가능)'/></th>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700031' mdef='성명'/></th>
						<td><span id="successorEmpNm1"></span></td>
						<td><span id="successorEmpNm2"></span></td>
						<td><span id="successorEmpNm3"></span></td>
						<td><span id="transferEmpNm"></span></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020800011' mdef='조직'/></th>
						<td><span id="successorOrgNm1"/></td>
						<td><span id="successorOrgNm2"/></td>
						<td><span id="successorOrgNm3"/></td>
						<td><span id="transferOrgNm"/></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020800012' mdef='직급'/></th>
						<td><span id="successorJikgubNm1"/></td>
						<td><span id="successorJikgubNm2"/></td>
						<td><span id="successorJikgubNm3"/></td>
						<td><span id="transferJikgubNm"/></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020800013' mdef='직위'/></th>
						<td><span id="successorJikweeNm1"/></td>
						<td><span id="successorJikweeNm2"/></td>
						<td><span id="successorJikweeNm3"/></td>
						<td><span id="transferJikweeNm"/></td>
					</tr>
					<tr>
						<th><tit:txt mid='2020020700033' mdef='선정사유'/></th>
						<td>
							<textarea id="successorDesc1" class="w96p" rows="12" disabled></textarea>
						</td>
						<td>
							<textarea id="successorDesc2" class="w96p" rows="12" disabled></textarea>
						</td>
						<td>
							<textarea id="successorDesc3" class="w96p" rows="12" disabled></textarea>
						</td>
						<td>
							<textarea id="transferDesc"   class="w96p" rows="12" disabled></textarea>
						</td>
					</tr>
				</table>
			</div>
			<div id="layerTabs-4" >
				<div>
					<form id="selfReportRegistLayerSheet2Form" name="selfReportRegistLayerSheet2Form"></form>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt2" class="txt"><tit:txt mid='2020021000013' mdef='설문조사'/></li>
								<li class="btn">
									<btn:a href="javascript:doAction2('Search');" id='btnSearch2' mid='110697' css='basic' mdef="조회"/>
									<btn:a href="javascript:doAction2('Save');" id='btnSave2' mid='110708' css='basic' mdef="저장"/>
								</li>
							</ul>
						</div>
					</div>
<%--					<script type="text/javascript">createIBSheet("selfReportRegistLayerSheet2", "100%", "85%", "${ssnLocaleCd}"); </script>--%>
					<div id="selfReportRegistLayerSheet2-wrap"></div>
				</div>
			</div>
		</div>
		<!-- [END] Tabs -->
	</div>
</div>
</body>
</html>
