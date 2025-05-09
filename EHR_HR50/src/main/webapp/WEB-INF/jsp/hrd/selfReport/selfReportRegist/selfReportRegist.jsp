<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html><head><title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<style type="text/css">
	table.default td, table.table td {
		border-right: 1px solid #e7edf0 !important;
	}
	table.default td:last-child, table.table td:last-child {
		border-right: none !important;
	}
</style>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	
	$(function() {
		$( "#tabs" ).tabs();

		// 그룹코드 조회
		var grpCds = "D00005,D10010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, (("${ssnLocaleCd}" == "ko_KR" || "${ssnLocaleCd}" == "") ? "전체" : "All"));
		var moveHopeCdLists = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getMoveHopeCdList", false).codeList, ("${ssnLocaleCd}" == "ko_KR" ? "없음" : "None"));
		
		$("#moveHopeTime").html(codeLists["D10010"][2]);
		$("#moveHopeCd").html(moveHopeCdLists[2]);
		
		var initdata = {};
		/* SHEET1 */
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No'						/>", Type:"${sNoTy}"  , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete'       mdef='삭제'						/>", Type:"${sDelTy}" , Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0, HeaderCheck:0 },
			{Header:"<sht:txt mid='sStatus'       mdef='상태'						/>", Type:"${sSttTy}" , Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='activeYyyy'    mdef='년도'						/>", Type:"Text"      , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='halfGubunType' mdef='반기구분'					/>", Type:"Combo"     , Hidden:0                  , Width:80          , Align:"Center", ColMerge:0, SaveName:"halfGubunType"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='sabun'         mdef='사번'						/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"                 , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='registed'      mdef='등록여부'					/>", Type:"Text"      , Hidden:0                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"regYn"                 , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='careerTargetCd'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetCd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignCd1'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignCd1"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignCd2'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignCd2"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignCd3'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignCd3"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='moveHopeTime'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"moveHopeTime"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='moveHopeCd'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"moveHopeCd"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='moveHopeDesc'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"moveHopeDesc"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgCd1'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgCd1"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgCd2'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgCd2"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgCd3'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgCd3"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgNm1'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgNm1"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgNm2'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgNm2"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgNm3'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgNm3"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgCdMoveHopeTime'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgCdMoveHopeTime" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgCdMoveHopeCd'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgCdMoveHopeCd"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgCdMoveHopeDesc'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgCdMoveHopeDesc" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='transferEmpNo'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"transferEmpNo"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='transferDesc'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"transferDesc"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorEmpNo1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorEmpNo1"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorDesc1'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorDesc1"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorEmpNo2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorEmpNo2"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorDesc2'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorDesc2"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorEmpNo3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorEmpNo3"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorDesc3'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorDesc3"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalReqYmd'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalReqYmd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalStatus'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalStatus"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalMainOrgCd'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgCd"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalMainOrgNm'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgNm"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalOrgCd'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalOrgCd"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalOrgNm'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalOrgNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalEmpNo'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalEmpNo"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalEmpName'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalEmpName"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='approvalYmd'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"approvalYmd"           , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='careerTargetNm'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetNm"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='careerTargetTypeNm'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetTypeNm"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='careerTargetType'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetType"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='careerTargetDesc'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetDesc"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNmLarge1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNmLarge1"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNmMiddle1'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNmMiddle1"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNm1'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNm1"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNmLarge2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNmLarge2"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNmMiddle2'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNmMiddle2"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNm2'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNm2"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNmLarge3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNmLarge3"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNmMiddle3'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNmMiddle3"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignNm3'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignNm3"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignAppCnt1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignAppCnt1"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignCurCnt1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignCurCnt1"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignWrkExp1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignWrkExp1"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignAppCnt2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignAppCnt2"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignCurCnt2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignCurCnt2"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignWrkExp2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignWrkExp2"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignAppCnt3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignAppCnt3"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignCurCnt3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignCurCnt3"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='workAssignWrkExp3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"workAssignWrkExp3"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgAppCnt1'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgAppCnt1"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgAppCnt2'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgAppCnt2"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='mainOrgAppCnt2'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"mainOrgAppCnt2"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='transferEmpNm'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"transferEmpNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='transferOrgNm'			/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"transferOrgNm"         , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='transferJikgubNm'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"transferJikgubNm"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='transferJikweeNm'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"transferJikweeNm"      , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorEmpNm1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorEmpNm1"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorOrgNm1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorOrgNm1"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorJikgubNm1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorJikgubNm1"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorJikweeNm1'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorJikweeNm1"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorEmpNm2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorEmpNm2"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorOrgNm2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorOrgNm2"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorJikgubNm2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorJikgubNm2"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorJikweeNm2'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorJikweeNm2"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorEmpNm3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorEmpNm3"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorOrgNm3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorOrgNm3"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorJikgubNm3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorJikgubNm3"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='successorJikweeNm3'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"successorJikweeNm3"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='activeStartYmd'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeStartYmd"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='activeEndYmd'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeEndYmd"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='enterCd'       mdef='회사코드'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetVisible(true); sheet1.SetCountPosition(4);
		sheet1.SetColProperty("halfGubunType", 	{ComboText:"|"+ codeLists["D00005"][0], ComboCode:"|"+codeLists["D00005"][1]} );
		/* [END] SHEET1 */
		
		
		/* SHEET2 */
		initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No'				/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'       mdef='삭제'				/>", Type:"${sDelTy}", Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'       mdef='상태'				/>", Type:"${sSttTy}", Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='BLANK'         mdef='설문항목'			/>", Type:"Text"     , Hidden:0                  , Width:70          , Align:"Center", ColMerge:0, SaveName:"surveyItemNm"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='설명'				/>", Type:"Text"     , Hidden:0                  , Width:210         , Align:"Left"  , ColMerge:0, SaveName:"surveyItemDesc" , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='본인\n점수'			/>", Type:"Text"     , Hidden:0                  , Width:40          , Align:"Center", ColMerge:0, SaveName:"point"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='평균\n점수'			/>", Type:"Text"     , Hidden:0                  , Width:40          , Align:"Center", ColMerge:0, SaveName:"avgPoint"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='차이'				/>", Type:"Text"     , Hidden:0                  , Width:40          , Align:"Center", ColMerge:0, SaveName:"gapPoint"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='BLANK'         mdef='매우 그렇지않다(1)'	/>", Type:"CheckBox" , Hidden:0                  , Width:70          , Align:"Center", ColMerge:0, SaveName:"point1"         , KeyField:0, UpdateEdit:1, InsertEdit:1, EditLen:1, Format:"", TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='BLANK'         mdef='그렇지 않다(2)'		/>", Type:"CheckBox" , Hidden:0                  , Width:70          , Align:"Center", ColMerge:0, SaveName:"point2"         , KeyField:0, UpdateEdit:1, InsertEdit:1, EditLen:1, Format:"", TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='BLANK'         mdef='보통(3)'			/>", Type:"CheckBox" , Hidden:0                  , Width:70          , Align:"Center", ColMerge:0, SaveName:"point3"         , KeyField:0, UpdateEdit:1, InsertEdit:1, EditLen:1, Format:"", TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='BLANK'         mdef='그렇다(4)'			/>", Type:"CheckBox" , Hidden:0                  , Width:70          , Align:"Center", ColMerge:0, SaveName:"point4"         , KeyField:0, UpdateEdit:1, InsertEdit:1, EditLen:1, Format:"", TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='BLANK'         mdef='매우 그렇다(5)'		/>", Type:"CheckBox" , Hidden:0                  , Width:70          , Align:"Center", ColMerge:0, SaveName:"point5"         , KeyField:0, UpdateEdit:1, InsertEdit:1, EditLen:1, Format:"", TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='enterCd'       mdef='회사코드'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='surveyItemCd'  mdef='설문항목'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"surveyItemCd"   , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='activeYyyy'    mdef='대상년도'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='halfGubunType' mdef='반기구분'			/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"halfGubunType"  , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" },
			{Header:"<sht:txt mid='sabun'         mdef='사번'				/>", Type:"Text"     , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"sabun"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, Format:"" }
		]; IBS_InitSheet(sheet2, initdata); sheet2.SetVisible(true); sheet2.SetCountPosition(4);
		/* [END] SHEET2 */
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});
	
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var params = "searchSabun=" + $("#searchUserId").val();
				sheet1.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getSelfReportRegistList", params);
				break;
			case "Save":
				var selectedRow = sheet1.GetSelectRow();
				
				if ( sheet1.GetCellValue(selectedRow, "approvalReqYmd") != "") {
					return;
				}
				if (sheet1.GetCellValue(selectedRow, "careerTargetCd"  ) == ""){
					alert("경력목표를 선택해주세요");
					careerPopup();
					return;
				}
				
				var params = {
					  "activeYyyy"      : sheet1.GetCellValue(selectedRow, "activeYyyy")
					, "halfGubunType"   : sheet1.GetCellValue(selectedRow, "halfGubunType")
					, "sabun"           : $("#searchUserId").val()
					, "careerTargetCd"  : sheet1.GetCellValue(selectedRow, "careerTargetCd")
					, "workAssignCd1"   : sheet1.GetCellValue(selectedRow, "workAssignCd1")
					, "workAssignCd2"   : sheet1.GetCellValue(selectedRow, "workAssignCd2")
					, "workAssignCd3"   : sheet1.GetCellValue(selectedRow, "workAssignCd3")
					, "moveHopeTime"    : $("#moveHopeTime").val()
					, "moveHopeCd"      : $("#moveHopeCd"  ).val()
					, "moveHopeDesc"    : $("#moveHopeDesc").val()
					, "transferEmpNo"   : sheet1.GetCellValue(selectedRow, "transferEmpNo")
					, "transferDesc"    : $("#transferDesc").val()
					, "successorEmpNo1" : sheet1.GetCellValue(selectedRow, "successorEmpNo1")
					, "successorEmpNo2" : sheet1.GetCellValue(selectedRow, "successorEmpNo2")
					, "successorEmpNo3" : sheet1.GetCellValue(selectedRow, "successorEmpNo3")
					, "successorDesc1"  : $("#successorDesc1").val()
					, "successorDesc2"  : $("#successorDesc2").val()
					, "successorDesc3"  : $("#successorDesc3").val()
					, "approvalReqYmd"  : sheet1.GetCellValue(selectedRow, "approvalReqYmd")
					, "approvalStatus"  : sheet1.GetCellValue(selectedRow, "approvalStatus")
					, "approvalEmpNo"   : sheet1.GetCellValue(selectedRow, "approvalEmpNo")
					, "approvalYmd"     : sheet1.GetCellValue(selectedRow, "approvalYmd")
				};
				
				$.ajax({
					  url      : "${ctx}SelfReportRegist.do?cmd=saveSelfReportRegist"
					, type     : "post"
					, dataType : "json"
					, async    : false
					, data     : params
					, success  : function(rv) {
						if( rv && rv != null && rv.Result && rv.Result != null ) {
							alert(rv.Result.Message);
							if( rv.Result.Code && rv.Result.Code != null && rv.Result.Code > 0 ) {
								doAction1("Search");
							}
						} else {
							alert("처리 중 오류가 발생했습니다. 관리자에 문의 하시기 바랍니다.");
						}
					}
					, error : function(jqXHR, ajaxSettings, thrownError) {
						ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
					}
				});
				break;
		}
	}

	function doAction2(sAction){
		switch (sAction) {
			case "Search":
				/*if( sheet1.GetSelectRow() == sheet1.HeaderRows() ) {
					if (sheet1.GetCellValue(sheet1.GetSelectRow(), "careerTargetCd") == ""){
						alert("경력목표를 저장 후 설문저장을 하세요");
						return;
					}
				}*/
				
				var selectedRow = sheet1.GetSelectRow();
				var params = "searchEnterCd="        + sheet1.GetCellValue(selectedRow, "enterCd") +
							 "&searchActiveYyyy="    + sheet1.GetCellValue(selectedRow, "activeYyyy") +
							 "&searchHalfGubunType=" + sheet1.GetCellValue(selectedRow, "halfGubunType") +
							 "&searchSabun="         + $("#searchUserId").val();
				
				sheet2.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getSurveyPointList", params);
				break;
			case "Save":
				if (sheet1.GetCellValue(sheet1.GetSelectRow(), "careerTargetCd") == ""){
					alert("경력목표를 저장 후 설문저장을 하세요");
					return;
				}
				IBS_SaveName(document.sheet2Form, sheet2);
				sheet2.DoSave("${ctx}/SelfReportRegist.do?cmd=saveSurveyPoint", $("#sheet2Form").serialize());
				break;
		}
	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);
			sheetResize();
			sheet1.SetSelectRow(sheet1.HeaderRows());
			loadData(sheet1.GetSelectRow());
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") alert(msg);
			doAction2("Search");
		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			loadData(row);
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
			doAction2("Search");
		} catch(ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}
	
	// 체크박스 체크시 이벤트
	function sheet2_OnBeforeCheck(Row, Col) {
		try {
			var colName = sheet2.CellSaveName(Row, Col);
			if( sheet2.GetCellValue(Row, Col) == "N" ) {
				if( colName == "point1" ) {
					sheet2.SetCellValue(Row, "point2", "N");
					sheet2.SetCellValue(Row, "point3", "N");
					sheet2.SetCellValue(Row, "point4", "N");
					sheet2.SetCellValue(Row, "point5", "N");
					sheet2.SetCellValue(Row, "point" ,  1 );
				}
				if( colName == "point2" ) {
					sheet2.SetCellValue(Row, "point1", "N");
					sheet2.SetCellValue(Row, "point3", "N");
					sheet2.SetCellValue(Row, "point4", "N");
					sheet2.SetCellValue(Row, "point5", "N");
					sheet2.SetCellValue(Row, "point" ,  2 );
				}
				if( colName == "point3" ) {
					sheet2.SetCellValue(Row, "point1", "N");
					sheet2.SetCellValue(Row, "point2", "N");
					sheet2.SetCellValue(Row, "point4", "N");
					sheet2.SetCellValue(Row, "point5", "N");
					sheet2.SetCellValue(Row, "point" ,  3 );
				}
				if( colName == "point4" ) {
					sheet2.SetCellValue(Row, "point1", "N");
					sheet2.SetCellValue(Row, "point2", "N");
					sheet2.SetCellValue(Row, "point3", "N");
					sheet2.SetCellValue(Row, "point5", "N");
					sheet2.SetCellValue(Row, "point" ,  4 );
				}
				if( colName == "point5" ) {
					sheet2.SetCellValue(Row, "point1", "N");
					sheet2.SetCellValue(Row, "point2", "N");
					sheet2.SetCellValue(Row, "point3", "N");
					sheet2.SetCellValue(Row, "point4", "N");
					sheet2.SetCellValue(Row, "point" ,  5 );
				}
			}
		} catch (ex) {
			alert("sheet2 OnBeforeCheck Event Error : " + ex);
		}
	}

	var clearCareer = function(){
		$('#careerTargetNm, #careerTargetType, #careerTargetDesc').html("");
		sheet1.SetCellValue(sheet1.GetSelectRow(), "careerTargetCd"  , "");
		sheet1.SetCellValue(sheet1.GetSelectRow(), "careerTargetNm"  , "");
		sheet1.SetCellValue(sheet1.GetSelectRow(), "careerTargetType", "");
		sheet1.SetCellValue(sheet1.GetSelectRow(), "careerTargetDesc", "");
	}

	var clearWorkAssign = function(assign){
		if (assign == 'workAssign1'){
			$('#workAssignNmLarge1, #workAssignNmMiddle1, #workAssignNm1, #workAssignAppCnt1, #workAssignWrkExp1').html("");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignCd1"      , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNmLarge1" , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNmMiddle1", "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNm1"      , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignAppCnt1"  , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignWrkExp1"  , "");
		} else if (assign == 'workAssign2'){
			$('#workAssignNmLarge2, #workAssignNmMiddle2, #workAssignNm2, #workAssignAppCnt2, #workAssignWrkExp2').html("");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignCd2"      , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNmLarge2" , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNmMiddle2", "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNm2"      , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignAppCnt2"  , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignWrkExp2"  , "");
		} else if (assign == 'workAssign3'){
			$('#workAssignNmLarge3, #workAssignNmMiddle3, #workAssignNm3, #workAssignAppCnt3, #workAssignWrkExp3').html("");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignCd3"      , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNmLarge3" , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNmMiddle3", "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignNm3"      , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignAppCnt3"  , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "workAssignWrkExp3"  , "");
		}
	}

	var clearEmployee = function(employeeType){
		if (employeeType == 'successor1'){
			$('#successorEmpNm1, #successorOrgNm1, #successorJikgubNm1, #successorJikweeNm1').html("");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorEmpCd1"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorEmpNm1"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorOrgNm1"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorJikgubNm1", "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorJikweeNm1", "");
		} else if (employeeType == 'successor2'){
			$('#successorEmpNm2, #successorOrgNm2, #successorJikgubNm2, #successorJikweeNm2').html("");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorEmpCd2"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorEmpNm2"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorOrgNm2"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorJikgubNm2", "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorJikweeNm2", "");
		} else if (employeeType == 'successor3'){
			$('#successorEmpNm3, #successorOrgNm3, #successorJikgubNm3, #successorJikweeNm3').html("");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorEmpCd3"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorEmpNm3"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorOrgNm3"   , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorJikgubNm3", "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "successorJikweeNm3", "");
		} else if (employeeType == 'transfer'){
			$('#transferEmpNm, #transferOrgNm, #transferJikgubNm, #transferJikweeNm').html("");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "transferEmpCd"    , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "transferEmpNm"    , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "transferOrgNm"    , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "transferJikgubNm" , "");
			sheet1.SetCellValue(sheet1.GetSelectRow(), "transferJikweeNm" , "");
		}
	}

	var doButtonShowing = function(showing){
		if (showing){
			$("#btnSave").show();
			$("#btnSave2").show();
			$("#careerTargetSelectButton").show();
			$("#careerTargetClearButton" ).show();
			$("#assignSelectButton1"     ).show();
			$("#assignClearButton1"      ).show();
			$("#assignSelectButton2"     ).show();
			$("#assignClearButton2"      ).show();
			$("#assignSelectButton3"     ).show();
			$("#assignClearButton3"      ).show();
			$("#successorSelectButton1"  ).show();
			$("#successorClearButton1"   ).show();
			$("#successorSelectButton2"  ).show();
			$("#successorClearButton2"   ).show();
			$("#successorSelectButton3"  ).show();
			$("#successorClearButton3"   ).show();
			$("#transferSelectButton"    ).show();
			$("#transferClearButton"     ).show();
			$("#moveHopeTime"            ).prop('disabled', false);
			$("#moveHopeCd"              ).prop('disabled', false);
			$("#moveHopeDesc"            ).prop('disabled', false);
			$("#successorDesc1"          ).prop('disabled', false);
			$("#successorDesc2"          ).prop('disabled', false);
			$("#successorDesc3"          ).prop('disabled', false);
			$("#transferDesc"            ).prop('disabled', false);
		} else {
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
			$("#moveHopeTime"            ).prop('disabled', 'disabled');
			$("#moveHopeCd"              ).prop('disabled', 'disabled');
			$("#moveHopeDesc"            ).prop('disabled', "disabled");
			$("#successorDesc1"          ).prop('disabled', "disabled");
			$("#successorDesc2"          ).prop('disabled', "disabled");
			$("#successorDesc3"          ).prop('disabled', "disabled");
			$("#transferDesc"            ).prop('disabled', "disabled");
		}
	}

	var loadData = function(selectedRow){
		// var selectRow = sheet1.GetSelectRow();

		$("#careerTargetNm"     ).html( sheet1.GetCellValue(selectedRow, "careerTargetNm") );
		$("#careerTargetType"   ).html( sheet1.GetCellValue(selectedRow, "careerTargetTypeNm") );
		$("#careerTargetDesc"   ).html( sheet1.GetCellValue(selectedRow, "careerTargetDesc") );

		$("#workAssignNmLarge1" ).html( sheet1.GetCellValue(selectedRow, "workAssignNmLarge1") );
		$("#workAssignNmMiddle1").html( sheet1.GetCellValue(selectedRow, "workAssignNmMiddle1") );
		$("#workAssignNm1"      ).html( sheet1.GetCellValue(selectedRow, "workAssignNm1") );
		$("#workAssignAppCnt1"  ).html( sheet1.GetCellValue(selectedRow, "workAssignAppCnt1") + "/" + sheet1.GetCellText(selectedRow, "workAssignCurCnt1"));
		$("#workAssignWrkExp1"  ).html( sheet1.GetCellValue(selectedRow, "workAssignWrkExp1") );
		$("#workAssignNmLarge2" ).html( sheet1.GetCellValue(selectedRow, "workAssignNmLarge2") );
		$("#workAssignNmMiddle2").html( sheet1.GetCellValue(selectedRow, "workAssignNmMiddle2") );
		$("#workAssignNm2"      ).html( sheet1.GetCellValue(selectedRow, "workAssignNm2") );
		$("#workAssignAppCnt2"  ).html( sheet1.GetCellValue(selectedRow, "workAssignAppCnt2") + "/" + sheet1.GetCellText(selectedRow, "workAssignCurCnt2") );
		$("#workAssignWrkExp2"  ).html( sheet1.GetCellValue(selectedRow, "workAssignWrkExp2") );
		$("#workAssignNmLarge3" ).html( sheet1.GetCellValue(selectedRow, "workAssignNmLarge3") );
		$("#workAssignNmMiddle3").html( sheet1.GetCellValue(selectedRow, "workAssignNmMiddle3") );
		$("#workAssignNm3"      ).html( sheet1.GetCellValue(selectedRow, "workAssignNm3" ) );
		$("#workAssignAppCnt3"  ).html( sheet1.GetCellValue(selectedRow, "workAssignAppCnt3") + "/" + sheet1.GetCellText(selectedRow, "workAssignCurCnt3") );
		$("#workAssignWrkExp3"  ).html( sheet1.GetCellValue(selectedRow, "workAssignWrkExp3") );
		$("#moveHopeTime"       ).val(  sheet1.GetCellValue(selectedRow, "moveHopeTime") );
		$("#moveHopeCd"         ).val(  sheet1.GetCellValue(selectedRow, "moveHopeCd") );
		$("#moveHopeDesc"       ).val(  sheet1.GetCellValue(selectedRow, "moveHopeDesc") );

		$("#transferEmpNm"      ).html( sheet1.GetCellValue(selectedRow, "transferEmpNm") );
		$("#transferOrgNm"      ).html( sheet1.GetCellValue(selectedRow, "transferOrgNm") );
		$("#transferJikgubNm"   ).html( sheet1.GetCellValue(selectedRow, "transferJikgubNm") );
		$("#transferJikWeeNm"   ).html( sheet1.GetCellValue(selectedRow, "transferJikweeNm") );
		$("#transferDesc"       ).val(  sheet1.GetCellValue(selectedRow, "transferDesc") );

		$("#successorEmpNm1"    ).html( sheet1.GetCellValue(selectedRow, "successorEmpNm1") );
		$("#successorOrgNm1"    ).html( sheet1.GetCellValue(selectedRow, "successorOrgNm1") );
		$("#successorJikgubNm1" ).html( sheet1.GetCellValue(selectedRow, "successorJikgubNm1") );
		$("#successorJikweeNm1" ).html( sheet1.GetCellValue(selectedRow, "successorJikweeNm1") );
		$("#successorDesc1"     ).val(  sheet1.GetCellValue(selectedRow, "successorDesc1") );

		$("#successorEmpNm2"    ).html( sheet1.GetCellText(selectedRow, "successorEmpNm2") );
		$("#successorOrgNm2"    ).html( sheet1.GetCellText(selectedRow, "successorOrgNm2") );
		$("#successorJikgubNm2" ).html( sheet1.GetCellText(selectedRow, "successorJikgubNm2") );
		$("#successorJikweeNm2" ).html( sheet1.GetCellText(selectedRow, "successorJikweeNm2") );
		$("#successorDesc2"     ).val(  sheet1.GetCellText(selectedRow, "successorDesc2") );

		$("#successorEmpNm3"    ).html( sheet1.GetCellText(selectedRow, "successorEmpNm3") );
		$("#successorOrgNm3"    ).html( sheet1.GetCellText(selectedRow, "successorOrgNm3") );
		$("#successorJikgubNm3" ).html( sheet1.GetCellText(selectedRow, "successorJikgubNm3") );
		$("#successorJikweeNm3" ).html( sheet1.GetCellText(selectedRow, "successorJikweeNm3") );
		$("#successorDesc3"     ).val(  sheet1.GetCellText(selectedRow, "successorDesc3") );

		$("#moveHopeTime"       ).val(  sheet1.GetCellText(selectedRow, "moveHopeTime") );
		$("#moveHopeCd"         ).val(  sheet1.GetCellText(selectedRow, "moveHopeCd") );

		// 버튼감춤 처리(첫번째 라인(최종자기신고서)이 아니면 수정 불가능한 자료임
		var canEdit = isDateInRange(selectedRow);
		doButtonShowing(canEdit);
		
		sheet2.SetEditable(false);
		if( canEdit && sheet1.GetCellValue(selectedRow, "careerTargetCd") != "" ) sheet2.SetEditable(true);

		doAction2("Search");
	}

	function isDateInRange(selectedRow) {
		const formatYmd = (ymd) => {
			return ymd.slice(0, 4) + '-' + ymd.slice(4, 6) + '-' + ymd.slice(6);
		};

		const today = new Date();
		const startYmd = sheet1.GetCellText(selectedRow, "activeStartYmd");
		const endYmd = sheet1.GetCellText(selectedRow, "activeEndYmd");

		const startDate = new Date(formatYmd(startYmd));
		const endDate = new Date(formatYmd(endYmd));

		return today.getTime() >= startDate.getTime() && today.getTime() <= endDate.getTime();
	}

	function setEmpPage() {
		doAction1("Search");
	}

	function employeePopup(searchGubun) {
		try {
			if(!isPopup()) {return;}

			gPRow = "";
			pGubun = searchGubun;

			<%--openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");--%>

			const employeeLayer = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : '/Popup.do?cmd=viewEmployeeLayer'
				, parameters : {}
				, width : 740
				, height : 520
				, title : '사원조회'
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			employeeLayer.show();

		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}

	function careerPopup() {
		try {
			if(!isPopup()) {return;}

			gPRow = "";
			pGubun = "searchCareerTarget";

			// openPopup("${ctx}/SelfReportRegist.do?cmd=viewCareerPathPopup", args, "1300","800");

			let w = 1300;
			let h = 800;
			let url = "/SelfReportRegist.do?cmd=viewCareerPathLayer";

			const layerModal = new window.top.document.LayerModal({
				id : 'careerPathLayer'
				, url : url
				, parameters : {}
				, width : w
				, height : h
				, title : '<tit:txt mid='payDayPop' mdef='경력목표조회'/>'
				, trigger :[
					{
						name : 'careerPathLayerTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			layerModal.show();

		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}

	function workAssignPopup(searchGubun) {
		try {
			if(!isPopup()) {return;}
			
			var selectedRow = sheet1.GetSelectRow();
			var chooseCds = "";
			
			chooseCds += "|" + sheet1.GetCellValue(selectedRow, "workAssignCd1");
			chooseCds += "|" + sheet1.GetCellValue(selectedRow, "workAssignCd2");
			chooseCds += "|" + sheet1.GetCellValue(selectedRow, "workAssignCd3");

			gPRow = "";
			pGubun = searchGubun;

			// openPopup("${ctx}/SelfReportRegist.do?cmd=viewWorkAssignPopup", args, "840","500");

			let w = 840;
			let h = 500;
			let url = "/SelfReportRegist.do?cmd=viewWorkAssignLayer";
			let p = {
				chooseCds : chooseCds + "|"
			};

			const workAssignLayer = new window.top.document.LayerModal({
				id : 'workAssignLayer'
				, url : url
				, parameters : p
				, width : w
				, height : h
				, title : '<tit:txt mid='payDayPop' mdef='단위업무체계조회'/>'
				, trigger :[
					{
						name : 'workAssignLayerTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			workAssignLayer.show();

		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}

	function getReturnValue(returnValue) {
		var selectedRow = sheet1.GetSelectRow();

		if (pGubun == "searchCareerTarget") {
			sheet1.SetCellValue(selectedRow, "careerTargetCd"     , returnValue.careerTargetCd);
			sheet1.SetCellValue(selectedRow, "careerTargetNm"     , returnValue.careerTargetNm);
			sheet1.SetCellValue(selectedRow, "careerTargetType"   , returnValue.careerTargetType);
			sheet1.SetCellValue(selectedRow, "careerTargetTypeNm" , returnValue.careerTargetTypeNm);
			sheet1.SetCellValue(selectedRow, "careerTargetDesc"   , returnValue.careerTargetDesc);
		} else if(pGubun == "workAssign1"){
			sheet1.SetCellValue(selectedRow, "workAssignCd1"      , returnValue.workAssignCd);
			sheet1.SetCellValue(selectedRow, "workAssignNm1"      , returnValue.workAssignNm);
			sheet1.SetCellValue(selectedRow, "workAssignNmLarge1" , returnValue.gWorkAssignNm);
			sheet1.SetCellValue(selectedRow, "workAssignNmMiddle1", returnValue.mWorkAssignNm);
		} else if(pGubun == "workAssign2"){
			sheet1.SetCellValue(selectedRow, "workAssignCd2"      , returnValue.workAssignCd);
			sheet1.SetCellValue(selectedRow, "workAssignNm2"      , returnValue.workAssignNm);
			sheet1.SetCellValue(selectedRow, "workAssignNmLarge2" , returnValue.gWorkAssignNm);
			sheet1.SetCellValue(selectedRow, "workAssignNmMiddle2", returnValue.mWorkAssignNm);
		} else if(pGubun == "workAssign3"){
			sheet1.SetCellValue(selectedRow, "workAssignCd3"      , returnValue.workAssignCd);
			sheet1.SetCellValue(selectedRow, "workAssignNm3"      , returnValue.workAssignNm);
			sheet1.SetCellValue(selectedRow, "workAssignNmLarge3" , returnValue.gWorkAssignNm);
			sheet1.SetCellValue(selectedRow, "workAssignNmMiddle3", returnValue.mWorkAssignNm);
		} else if(pGubun == "successor1"){
			sheet1.SetCellValue(selectedRow, "successorEmpNo1"    , returnValue.sabun);
			sheet1.SetCellValue(selectedRow, "successorEmpNm1"    , returnValue.name);
			sheet1.SetCellValue(selectedRow, "successorOrgNm1"    , returnValue.orgNm);
			sheet1.SetCellValue(selectedRow, "successorJikgubNm1" , returnValue.jikgubNm);
			sheet1.SetCellValue(selectedRow, "successorJikweeNm1" , returnValue.jikweeNm);
		} else if(pGubun == "successor2"){
			sheet1.SetCellValue(selectedRow, "successorEmpNo2"    , returnValue.sabun);
			sheet1.SetCellValue(selectedRow, "successorEmpNm2"    , returnValue.name);
			sheet1.SetCellValue(selectedRow, "successorOrgNm2"    , returnValue.orgNm);
			sheet1.SetCellValue(selectedRow, "successorJikgubNm2" , returnValue.jikgubNm);
			sheet1.SetCellValue(selectedRow, "successorJikweeNm2" , returnValue.jikweeNm);
		} else if(pGubun == "successor3"){
			sheet1.SetCellValue(selectedRow, "successorEmpNo3"    , returnValue.sabun);
			sheet1.SetCellValue(selectedRow, "successorEmpNm3"    , returnValue.name);
			sheet1.SetCellValue(selectedRow, "successorOrgNm3"    , returnValue.orgNm);
			sheet1.SetCellValue(selectedRow, "successorJikgubNm3" , returnValue.jikgubNm);
			sheet1.SetCellValue(selectedRow, "successorJikweeNm3" , returnValue.jikweeNm);
		} else if(pGubun == "transfer"){
			sheet1.SetCellValue(selectedRow, "transferEmpNo"      , returnValue.sabun);
			sheet1.SetCellValue(selectedRow, "transferEmpNm"      , returnValue.name);
			sheet1.SetCellValue(selectedRow, "transferOrgNm"      , returnValue.orgNm);
			sheet1.SetCellValue(selectedRow, "transferJikgubNm"   , returnValue.jikgubNm);
			sheet1.SetCellValue(selectedRow, "transferJikweeNm"   , returnValue.jikweeNm);
		}
		loadData(selectedRow);
	}
 </script>
</head>
<body class="hidden">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
<%--	<form id="srchFrm" name="srchFrm" >--%>
<%--		<div class="sheet_search outer">--%>
<%--			<div>--%>
<%--				<table>--%>
<%--					<tr>--%>
<%--						<td>--%>
<%--							<span><tit:txt mid='' mdef='' /></span><input id="" name="" type="Text" class="text" />--%>
<%--						</td>--%>
<%--						<td>--%>
<%--							<btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='search' mdef='조회' />--%>
<%--						</td>--%>
<%--					</tr>--%>
<%--				</table>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--	</form>--%>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="25%" />
			<col width="75%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<form id="sheet1Form" name="sheet1Form"></form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">경력개발 차수</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='2020020800003' mdef='자기신고서 작성'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Save');" id='btnSave' mid='110708' css='btn filled' mdef="저장"/>
						</li>
					</ul>
				</div>
				
				<div id="tabs" class="w100p">
					<ul class="inner tab_bottom">
						<li onclick=""><btn:a href="#tabs-1" mid='2020020700014' mdef="경력목표"/></li>
						<li onclick=""><btn:a href="#tabs-2" mid='2020020700015' mdef="이동희망 업무"/></li>
						<li onclick=""><btn:a href="#tabs-3" mid='2020020700016' mdef="업무대체가능자"/></li>
						<li onclick="javascript:doAction2('Search');"><btn:a href="#tabs-4" mid='2020020700017' mdef="업무만족도"/></li>
					</ul>
					
					<div id="tabs-1" class="pad-y-5" style="height:calc(100vh - 270px); overflow-y:auto;">
						<table border="0" cellpadding="0" cellspacing="0" class="explain_main">
							<colgroup>
								<col width="12%" />
								<col width="*"/>
							</colgroup>
							<tr>
								<td class="top">
									<table border="0" cellpadding="0" cellspacing="0" class="default">
										<colgroup>
											<col width="150px" />
											<col width="*" />
										</colgroup>
										<tr class="h40">
											<th><tit:txt mid='2020020700012' mdef='경력목표'/></th>
											<td>
												<div class="disp_flex justify_between alignItem_center">
													<div><span id="careerTargetNm"></span></div>
													<div class="mal15">
														<a onclick="javascript:careerPopup();" class="button6" id="careerTargetSelectButton"><img src="/common/${theme}/images/btn_search2.gif"/></a>
														<a onclick="javascript:clearCareer();" class="button7" id="careerTargetClearButton"><img src="/common/${theme}/images/icon_undo.gif"/></a>
													</div>
												</div>
											</td>
										</tr>
										<tr class="h40">
											<th><tit:txt mid='2020020700011' mdef='인재유형'/></th>
											<td>
												<span id="careerTargetType"></span>
											</td>
										</tr>
										<tr>
											<th><tit:txt mid='2020020700013' mdef='경력목표개요'/></th>
											<td>
												<div id="careerTargetDesc" style="min-height: 90px;"></div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
					<div id="tabs-2" class="pad-y-5" style="height:calc(100vh - 270px); overflow-y:auto;">
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
								<td>
									<div class="disp_flex justify_between alignItem_center">
										<div>
											<span id="workAssignNm1"></span>
										</div>
										<div class="mal15">
											<a onclick="javascript:workAssignPopup('workAssign1');"  class="button6" id="assignSelectButton1"><img src="/common/${theme}/images/btn_search2.gif"/></a>
											<a onclick="javascript:clearWorkAssign('workAssign1');"  class="button7" id="assignClearButton1"><img src="/common/${theme}/images/icon_undo.gif"/></a>
										</div>
									</div>
								</td>
								<td>
									<div class="disp_flex justify_between alignItem_center">
										<div>
											<span id="workAssignNm2"></span>
										</div>
										<div class="mal15">
											<a onclick="javascript:workAssignPopup('workAssign2');"  class="button6" id="assignSelectButton2"><img src="/common/${theme}/images/btn_search2.gif"/></a>
											<a onclick="javascript:clearWorkAssign('workAssign2');"  class="button7" id="assignClearButton2"><img src="/common/${theme}/images/icon_undo.gif"/></a>
										</div>
									</div>
								</td>
								<td>
									<div class="disp_flex justify_between alignItem_center">
										<div>
											<span id="workAssignNm3"></span>
										</div>
										<div class="mal15">
											<a onclick="javascript:workAssignPopup('workAssign3');"  class="button6" id="assignSelectButton3"><img src="/common/${theme}/images/btn_search2.gif"/></a>
											<a onclick="javascript:clearWorkAssign('workAssign3');"  class="button7" id="assignClearButton3"><img src="/common/${theme}/images/icon_undo.gif"/></a>
										</div>
									</div>
								</td>
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
							<tr>
								<th><tit:txt mid='2020020700027' mdef='이동시기'/></th>
								<td colspan="3">
									<select id="moveHopeTime" name="moveHopeTime"></select>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='2020020700028' mdef=' 이동희망사유'/></th>
								<td colspan="3">
									<select id="moveHopeCd" name="moveHopeCd"></select>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='2020020700029' mdef='세부 이동희망사유'/></th>
								<td colspan="3">
									<textarea id="moveHopeDesc" style="width: 100%;" rows="6"></textarea>
								</td>
							</tr>
						</table>
					</div>
					<div id="tabs-3" class="pad-y-5" style="height:calc(100vh - 270px); overflow-y:auto;">
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
								<td>
									<div class="disp_flex justify_between alignItem_center">
										<div>
											<span id="successorEmpNm1"></span>
										</div>
										<div class="mal15">
											<a onclick="javascript:employeePopup('successor1');"  class="button6" id="successorSelectButton1"><img src="/common/${theme}/images/btn_search2.gif"/></a>
											<a onclick="javascript:clearEmployee('successor1');"  class="button7" id="successorClearButton1"><img src="/common/${theme}/images/icon_undo.gif"/></a>
										</div>
									</div>
								</td>
								<td>
									<div class="disp_flex justify_between alignItem_center">
										<div>
											<span id="successorEmpNm2"></span>
										</div>
										<div class="mal15">
											<a onclick="javascript:employeePopup('successor2');"  class="button6" id="successorSelectButton2"><img src="/common/${theme}/images/btn_search2.gif"/></a>
											<a onclick="javascript:clearEmployee('successor2');"  class="button7" id="successorClearButton2"><img src="/common/${theme}/images/icon_undo.gif"/></a>
										</div>
									</div>
								</td>
								<td>
									<div class="disp_flex justify_between alignItem_center">
										<div>
											<span id="successorEmpNm3"></span>
										</div>
										<div class="mal15">
											<a onclick="javascript:employeePopup('successor3');"  class="button6" id="successorSelectButton3"><img src="/common/${theme}/images/btn_search2.gif"/></a>
											<a onclick="javascript:clearEmployee('successor3');"  class="button7" id="successorClearButton3"><img src="/common/${theme}/images/icon_undo.gif"/></a>
										</div>
									</div>
								</td>
								<td>
									<div class="disp_flex justify_between alignItem_center">
										<div>
											<span id="transferEmpNm"></span>
										</div>
										<div class="mal15">
											<a onclick="javascript:employeePopup('transfer');"  class="button6" id="transferSelectButton"><img src="/common/${theme}/images/btn_search2.gif"/></a>
											<a onclick="javascript:clearEmployee('transfer');"  class="button7" id="transferClearButton"><img src="/common/${theme}/images/icon_undo.gif"/></a>
										</div>
									</div>
								</td>
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
					<div id="tabs-4">
						<form id="sheet2Form" name="sheet2Form"></form>
						<div class="sheet_title inner">
							<ul>
								<li id="txt2" class="txt"><tit:txt mid='2020021000013' mdef='설문조사'/></li>
								<li class="btn">
									<btn:a href="javascript:doAction2('Search');" id='btnSearch2' mid='110697' css='btn outline_gray' mdef="조회"/>
									<btn:a href="javascript:doAction2('Save');" id='btnSave2' mid='110708' css='btn filled' mdef="저장"/>
								</li>
							</ul>
						</div>
						<script type="text/javascript">createIBSheet("sheet2", "100%", "78%", "${ssnLocaleCd}"); </script>
<%--						<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">--%>
<%--							<colgroup>--%>
<%--								<col width="100%" />--%>
<%--								<col width="30%" />--%>
<%--							</colgroup>--%>
<%--							<tr>--%>
<%--								<td>--%>
<%--								</td>--%>
<%--								<td>--%>
<%--									1번--%>
<%--								</td>--%>
<%--							</tr>--%>
<%--						</table>--%>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
