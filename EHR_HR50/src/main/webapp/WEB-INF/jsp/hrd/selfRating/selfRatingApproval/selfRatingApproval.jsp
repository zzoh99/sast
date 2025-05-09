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
	
	var tabObj;

	$(function() {
		tabObj = $( "#tabs" ).tabs();

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'               mdef='No'			/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'           mdef='삭제'			/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0, HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'           mdef='상태'			/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"<sht:txt mid='activeYyyy'        mdef='년도'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='halfGubunType'     mdef='반기구분'		/>", Type:"Combo"    , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"halfGubunType"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalMainOrgNm' mdef='조직'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgNm", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='2020021400002'     mdef='승인요청일'		/>", Type:"Date"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalReqYmd"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalStatus'    mdef='승인상태'		/>", Type:"Combo"    , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalStatus"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalYmd'       mdef='승인일'		/>", Type:"Date"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalYmd"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='2020021400007'     mdef='승인요청자'		/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"name"             , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikchakNm'         mdef='직책'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikchakNm"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikweeNm_V7'       mdef='직위'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikweeNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jikgubNm'          mdef='직급'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"jikgubNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalMainOrgCd' mdef='승인메인조직코드'	/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgCd", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalEmpNo'     mdef='승인자성명'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalEmpNo"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='activeStartYmd'    mdef='시작일자'		/>", Type:"Date"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeStartYmd"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='enterCd'           mdef='회사코드'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='sabun'             mdef='사번'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalOrgCd'     mdef='승인조직코드'	/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalOrgCd"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='approvalEmpName'   mdef='승인자성명'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalEmpName"  , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'            mdef='No'			/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sStatus'        mdef='상태'			/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"<sht:txt mid='sDelete'        mdef='삭제'			/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0, HeaderCheck:0},
			{Header:"<sht:txt mid='priorSkillNm'   mdef='카테고리'			/>", Type:"Text"     , Hidden:0                  , Width:140         , Align:"Left"  , ColMerge:0, SaveName:"priorSkillNm" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='skillNm'        mdef='기술명'			/>", Type:"Text"     , Hidden:0                  , Width:190         , Align:"Left"  , ColMerge:0, SaveName:"skillNm"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='useMonth'       mdef='사용개월수'		/>", Type:"Int"      , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0, SaveName:"useMonth"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='ratingGrade'    mdef='평가등급'			/>", Type:"Combo"    , Hidden:0                  , Width:100         , Align:"Center", ColMerge:0, SaveName:"ratingGrade"  , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='modifyGrade'    mdef='수정등급'			/>", Type:"Combo"    , Hidden:0                  , Width:100         , Align:"Center", ColMerge:0, SaveName:"modifyGrade"  , KeyField:0, UpdateEdit:1, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='modifyDesc'     mdef='수정사유'			/>", Type:"Text"     , Hidden:0                  , Width:230         , Align:"Left"  , ColMerge:0, SaveName:"modifyDesc"   , KeyField:0, UpdateEdit:1, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='enterCd'        mdef='회사코드'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='priorSkillCd'   mdef='priorSkillCd'	/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"priorSkillCd" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='skillCd'        mdef='skillCd'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"skillCd"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='activeYyyy'     mdef='대상년도'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='halfGubunType'  mdef='반기구분'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"halfGubunType", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='sabun'          mdef='사번'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='finalGrade'     mdef='finalGrade'	/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"finalGrade"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet2, initdata);
		sheet2.SetVisible(true);
		sheet2.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'              mdef='No'				/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sStatus'          mdef='상태'				/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"<sht:txt mid='sDelete'          mdef='삭제'				/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0, HeaderCheck:0},
			{Header:"<sht:txt mid='priorKnowledgeNm' mdef='카테고리'			/>", Type:"Text"     , Hidden:0                  , Width:140         , Align:"Left"  , ColMerge:0, SaveName:"priorKnowledgeNm", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='knowledgeNm'      mdef='지식명'				/>", Type:"Text"     , Hidden:0                  , Width:190         , Align:"Left"  , ColMerge:0, SaveName:"knowledgeNm"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='ratingGrade'      mdef='평가등급'			/>", Type:"Combo"    , Hidden:0                  , Width:100         , Align:"Center", ColMerge:0, SaveName:"ratingGrade"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='modifyGrade'      mdef='수정등급'			/>", Type:"Combo"    , Hidden:0                  , Width:100         , Align:"Center", ColMerge:0, SaveName:"modifyGrade"     , KeyField:0, UpdateEdit:1, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='modifyDesc'       mdef='수정사유'			/>", Type:"Text"     , Hidden:0                  , Width:230         , Align:"Left"  , ColMerge:0, SaveName:"modifyDesc"      , KeyField:0, UpdateEdit:1, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='enterCd'          mdef='회사코드'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='priorKnowledgeCd' mdef='priorKnowledgeCd'/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"priorKnowledgeCd", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='knowledgeCd'      mdef='knowledgeCd'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"knowledgeCd"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='activeYyyy'       mdef='대상년도'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='halfGubunType'    mdef='반기구분'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"halfGubunType"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='sabun'            mdef='사번'				/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"           , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='useMonth'         mdef='useMonth'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"useMonth"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='finalGrade'       mdef='finalGrade'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"finalGrade"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet3, initdata);
		sheet3.SetVisible(true);
		sheet3.SetCountPosition(4);

		$("#searchActiveYyyy").change(function () {
			// 그룹코드 조회
			let grpCds = "D00005";
			let searchYear = $("#searchActiveYyyy").val();
			let baseSYmd = searchYear + "-01-01";
			let baseEYmd = searchYear + "-12-31";

			let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
			const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "");
			SetSelectLookup($("#searchHalfGubunType"), codeLists["D00005"] ); //반기구분
		});

		initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'              mdef='No'				/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sStatus'          mdef='상태'				/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"<sht:txt mid='sDelete'          mdef='삭제'				/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0, HeaderCheck:0},
			{Header:"<sht:txt mid='priorKnowledgeNm' mdef='카테고리'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"priorKnowledgeNm", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='knowledgeNm'      mdef='지식명'				/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"knowledgeNm"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='ratingGrade'      mdef='평가등급'			/>", Type:"Combo"    , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"ratingGrade"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='modifyGrade'      mdef='수정등급'			/>", Type:"Combo"    , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"modifyGrade"     , KeyField:0, UpdateEdit:1, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='modifyDesc'       mdef='수정사유'			/>", Type:"Text"     , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"modifyDesc"      , KeyField:0, UpdateEdit:1, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='enterCd'          mdef='회사코드'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='priorKnowledgeCd' mdef='priorKnowledgeCd'/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"priorKnowledgeCd", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='knowledgeCd'      mdef='knowledgeCd'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"knowledgeCd"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='activeYyyy'       mdef='대상년도'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='halfGubunType'    mdef='반기구분'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"halfGubunType"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='sabun'            mdef='사번'				/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"           , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='useMonth'         mdef='useMonth'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"useMonth"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='finalGrade'       mdef='finalGrade'		/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"finalGrade"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet4, initdata);
		sheet4.SetVisible(true);
		sheet4.SetCountPosition(4);

		loadUI();
		loadEvent();

		sheetInit();

		doAction1("Search");

	});

	function loadUI(){
		$(window).smartresize(sheetResize);
		
		// 그룹코드 조회
		var grpCds = "D00005,D00007,D00008";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");

		SetSheetColumnLookup(sheet1, "halfGubunType" , codeLists["D00005"] );
		SetSheetColumnLookup(sheet1, "approvalStatus", codeLists["D00007"] );
		SetSheetColumnLookup(sheet2, "ratingGrade"   , codeLists["D00008"] );
		SetSheetColumnLookup(sheet2, "modifyGrade"   , codeLists["D00008"] );
		SetSheetColumnLookup(sheet3, "ratingGrade"   , codeLists["D00008"] );
		SetSheetColumnLookup(sheet3, "modifyGrade"   , codeLists["D00008"] );
		SetSheetColumnLookup(sheet4, "ratingGrade"   , codeLists["D00008"] );
		SetSheetColumnLookup(sheet4, "modifyGrade"   , codeLists["D00008"] );
		SetSelectLookup($("#searchHalfGubunType"), codeLists["D00005"] ); //반기구분

		$("#btnApproval"      ).hide();
		$("#btnCancelApproval").hide();
		$("#btnSaveDetail1"   ).hide();
		$("#btnSaveDetail2"   ).hide();
		$("#btnSaveDetail3"   ).hide();

		SetSelectLookup($("#searchActiveYyyy"), stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getActiveYyyyList",false).codeList, "") ); //년도

		//TRM코드 탭셋팅
		var html_trmCd = "";
		var trmCdList = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTrmCdList",false).codeList;
		for (i = 0; i < trmCdList.length; i++) {
			tabObj.find("#tabUl").append("<li onclick='javascript:sheetResize();'><a href='#tabs-"+(i+1)+"' id='tab-"+(i+1)+"'>"+trmCdList[i].codeNm+"</a></li>");
		}
		tabObj.tabs( "refresh" );
		tabObj.tabs( "option", "active", 0 );
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
				var params = "searchActiveYyyy="     + $("#searchActiveYyyy").val() +
	 						 "&searchHalfGubunType=" + $("#searchHalfGubunType").val();
				sheet1.DoSearch( "${ctx}/SelfRatingApproval.do?cmd=getSelfRatingApprovalList", params);
				break;
			case "Save" :
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/SelfRatingApproval.do?cmd=saveSelfRatingApproval", $("#sheet1Form").serialize());
				break;
			case "SaveDetail1":
				IBS_SaveName(document.sheet2Form,sheet2);
				sheet2.DoSave( "${ctx}/SelfRatingApproval.do?cmd=saveSelfRatingApprovalDetail1", $("#sheet2Form").serialize());
				break;
			case "SaveDetail2":
				IBS_SaveName(document.sheet3Form,sheet3);
				sheet3.DoSave( "${ctx}/SelfRatingApproval.do?cmd=saveSelfRatingApprovalDetail2", $("#sheet3Form").serialize());
				break;
			case "SaveDetail3":
				IBS_SaveName(document.sheet4Form,sheet4);
				sheet4.DoSave( "${ctx}/SelfRatingApproval.do?cmd=saveSelfRatingApprovalDetail3", $("#sheet4Form").serialize());
				break;
			case "SearchDetail1":
				sheet2.DoSearch( "${ctx}/SelfRatingApproval.do?cmd=getSelfRatingApprovalDetailList1", GetSearchParams());
				break;
			case "SearchDetail2":
				sheet3.DoSearch( "${ctx}/SelfRatingApproval.do?cmd=getSelfRatingApprovalDetailList2", GetSearchParams());
				break;
			case "SearchDetail3":
				sheet4.DoSearch( "${ctx}/SelfRatingApproval.do?cmd=getSelfRatingApprovalDetailList3", GetSearchParams());
				break;
		}
	}

	var GetSearchParams = function(){
		var selectedRow = sheet1.GetSelectRow();
		var params = "searchActiveYyyy="     + sheet1.GetCellValue(selectedRow, "activeYyyy"    ) +
		             "&searchHalfGubunType=" + sheet1.GetCellValue(selectedRow, "halfGubunType" ) +
		             "&searchSabun="         + sheet1.GetCellValue(selectedRow, "sabun"         ) +
		             "&searchBaseYmd="       + sheet1.GetCellValue(selectedRow, "activeStartYmd");
		return params;
	}

	var TryApproval = function(){
		sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalStatus" ,"3"                );
		sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalYmd"    ,"${curSysYyyyMMdd}");
		doAction1("Save");
	}

	var TryCancelApproval = function(){
		sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalYmd"    ,"");
		sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalStatus" ,"1");
		doAction1("Save");
	}

	var loadData = function(selectedRow){
		// var selectedRow    = sheet1.GetSelectRow();
		var approvalStatus = sheet1.GetCellValue(selectedRow, "approvalStatus");

		//승인요청
		if (approvalStatus == "1"){
			$("#btnApproval"      ).show();
			$("#btnCancelApproval").hide();
			$("#btnSaveDetail1"   ).show();
			$("#btnSaveDetail2"   ).show();
			$("#btnSaveDetail3"   ).show();
			//팀장승인
		} else if (approvalStatus == "3"){
			$("#btnApproval"      ).hide();
			$("#btnCancelApproval").show();
			$("#btnSaveDetail1"   ).hide();
			$("#btnSaveDetail2"   ).hide();
			$("#btnSaveDetail3"   ).hide();
		}

		doAction1("SearchDetail1");
		doAction1("SearchDetail2");
		doAction1("SearchDetail3");

	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			sheet1.SetSelectRow(sheet1.HeaderRows());

			loadData(sheet1.GetSelectRow());

			sheetResize();
		} catch(ex) {
			    alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			loadData(sheet1.GetSelectRow());
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

			loadData(sheet1.GetSelectRow());
		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try{
			// if ( sheet1.ColSaveName(col) == "colName") {
			// 	//TODO something
			// 	return;
			// }

			//doAction1("Search");
		} catch(ex) {
			    alert("OnClick Event Error : " + ex);
		}
	}

	function sheet2_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			doAction1("SearchDetail1");
		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function sheet3_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet3_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			doAction1("SearchDetail2");
		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function sheet4_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet4_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);

			doAction1("SearchDetail3");
		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
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
							<btn:a href="javascript:doAction1('Search');"  id='btnSearch'         mid='110697'           css='button'  mdef="조회"     />
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
				<li id="txt1" class="txt"><tit:txt mid='2020021400005' mdef='스킬/지식 자기평가'/></li>
				<li class="btn">
					<btn:a href="javascript:TryApproval();"        id='btnApproval'       mid='113326' css='button' mdef="승인"     />
					<btn:a href="javascript:TryCancelApproval();"  id='btnCancelApproval' mid='114018' css='button' mdef="승인취소" />
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	<div id="tabs" class="mat15" style="width: 100%;">
		<ul id="tabUl" class="inner tab_bottom">
<%-- 			<li onclick="javascript:sheetResize();"><btn:a href="#tabs-1" mid='2020020700014' mdef="IT Skill"     /></li> --%>
<%-- 			<li onclick="javascript:sheetResize();"><btn:a href="#tabs-2" mid='2020020700015' mdef="IT Knowledge" /></li> --%>
<%-- 			<li onclick="javascript:sheetResize();"><btn:a href="#tabs-3" mid='2020020700016' mdef="Biz Knowledge"/></li> --%>
		</ul>
		<div id="tabs-1">
			<div>
				<form id="sheet2Form" name="sheet2Form"></form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="btn">
								<btn:a href="javascript:doAction1('SearchDetail1');" id='btnSearchDetail1' mid='110697' css='basic' mdef="조회"/>
								<btn:a href="javascript:doAction1('SaveDetail1');"   id='btnSaveDetail1'   mid='110708' css='basic' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
			</div>
		</div>
		<div id="tabs-2">
			<div>
				<form id="sheet3Form" name="sheet3Form"></form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="btn">
								<btn:a href="javascript:doAction1('SearchDetail2');" id='btnSearchDetail2' mid='110697' css='basic' mdef="조회"/>
								<btn:a href="javascript:doAction1('SaveDetail2');"   id='btnSaveDetail2'   mid='110708' css='basic' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>
			</div>
		</div>
		<div id="tabs-3" class="hide">
			<div>
				<form id="sheet4Form" name="sheet4Form"></form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="btn">
								<btn:a href="javascript:doAction1('SearchDetail3');" id='btnSearchDetail3' mid='110697' css='basic' mdef="조회"/>
								<btn:a href="javascript:doAction1('SaveDetail3');"   id='btnSaveDetail3'   mid='110708' css='basic' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet4", "100%", "50%", "${ssnLocaleCd}"); </script>
			</div>
		</div>

	</div>
</div>
</body>
</html>
