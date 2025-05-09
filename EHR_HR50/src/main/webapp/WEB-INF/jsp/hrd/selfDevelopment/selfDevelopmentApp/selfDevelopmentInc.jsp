<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
	$(function() {
		var cellEditable = 1;
		var cellHidden   = 0;
		
		/* Tab */
		$("#tabs").tabs();
		$("#tabsIndex").val('0');

		if ($("#prgType").val() == "App") {
			$("#btnCancle").hide();
			$("#btnAccept").hide();
			$("#btnReject").hide();
		}else{
			$("#btnCancle").show();
			$("#btnAccept").show();
			$("#btnReject").show();
			cellEditable = 0;
			cellHidden   = 1;
		}

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata3.Cols = [
			{Header:"<sht:txt mid='sNo'        mdef='No'			/>|<sht:txt mid='sNo'        mdef='No'			/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus'    mdef='상태'			/>|<sht:txt mid='sStatus'    mdef='상태'			/>", Type:"${sSttTy}", Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" , Sort:0 },
			{Header:"<sht:txt mid='sStatus'    mdef='상태'			/>|<sht:txt mid='sStatus'    mdef='상태'			/>", Type:"${sSttTy}", Hidden:1,                    Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus2", Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'			/>|<sht:txt mid='sDelete V5' mdef='삭제'			/>", Type:"CheckBox" , Hidden:cellHidden,           Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" , Sort:0, UpdateEdit:1, InsertEdit:1},

			{Header:"<sht:txt mid='BLANK'      mdef='구분코드'			/>|<sht:txt mid='BLANK'      mdef='구분코드'		/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"gubunCode"    , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='구분'			/>|<sht:txt mid='BLANK'      mdef='구분'			/>", Type:"Text"    , Hidden:0, Width:80 , Align:"Center", ColMerge:0, SaveName:"gubun"        , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:100  },
			{Header:"<sht:txt mid='BLANK'      mdef='코드'			/>|<sht:txt mid='BLANK'      mdef='코드'			/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"code"         , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:1           , EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='지식/스킬'			/>|<sht:txt mid='BLANK'      mdef='지식/스킬'		/>", Type:"Text"    , Hidden:0, Width:100, Align:"Left"  , ColMerge:0, SaveName:"codeNm"       , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:100  },
			{Header:"<sht:txt mid='BLANK'      mdef='지식/스킬 요구수준비교'	/>|<sht:txt mid='BLANK'      mdef='본인수준'		/>", Type:"Combo"   , Hidden:0, Width:50 , Align:"Center", ColMerge:0, SaveName:"selfGrade"    , KeyField:0, CalcLogic:"", Format:"NullInteger", PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='지식/스킬 요구수준비교'	/>|<sht:txt mid='BLANK'      mdef='現업무'		/>", Type:"Combo"   , Hidden:0, Width:40 , Align:"Center", ColMerge:0, SaveName:"workGrade"    , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:1    },
			{Header:"<sht:txt mid='BLANK'      mdef='지식/스킬 요구수준비교'	/>|<sht:txt mid='BLANK'      mdef='희망업무1'		/>", Type:"Combo"   , Hidden:0, Width:60 , Align:"Center", ColMerge:0, SaveName:"hope1Grade"   , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:1    },
			{Header:"<sht:txt mid='BLANK'      mdef='지식/스킬 요구수준비교'	/>|<sht:txt mid='BLANK'      mdef='희망업무2'		/>", Type:"Combo"   , Hidden:0, Width:60 , Align:"Center", ColMerge:0, SaveName:"hope2Grade"   , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:1    },
			{Header:"<sht:txt mid='BLANK'      mdef='지식/스킬 요구수준비교'	/>|<sht:txt mid='BLANK'      mdef='희망업무3'		/>", Type:"Combo"   , Hidden:0, Width:60 , Align:"Center", ColMerge:0, SaveName:"hope3Grade"   , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'      mdef='실행년도'			/>|<sht:txt mid='BLANK'      mdef='실행년도'		/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"activeYyyy"   , KeyField:1, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:1           , EditLen:4    },
			{Header:"<sht:txt mid='BLANK'      mdef='반기구분'			/>|<sht:txt mid='BLANK'      mdef='반기구분'		/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"halfGubunType", KeyField:1, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:1           , EditLen:1    },
			{Header:"<sht:txt mid='BLANK'      mdef='사번'			/>|<sht:txt mid='BLANK'      mdef='사번'			/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"sabun"        , KeyField:1, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:1           , EditLen:13   },
			{Header:"<sht:txt mid='BLANK'      mdef='TRM코드'			/>|<sht:txt mid='BLANK'      mdef='TRM코드'		/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"trmCd"        , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='교육코드'			/>|<sht:txt mid='BLANK'      mdef='교육코드'		/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"education"    , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:100  },
			{Header:"<sht:txt mid='BLANK'      mdef='희망교육계획'		/>|<sht:txt mid='BLANK'      mdef='희망교육계획'		/>", Type:"Text"    , Hidden:0, Width:200, Align:"Left"  , ColMerge:0, SaveName:"eduDevPlan"   , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:cellEditable, InsertEdit:cellEditable, EditLen:1000 },
			{Header:"<sht:txt mid='BLANK'      mdef='자기계발계획'		/>|<sht:txt mid='BLANK'      mdef='교육시간'		/>", Type:"Text"    , Hidden:1, Width:50 , Align:"Center", ColMerge:0, SaveName:"time"         , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='자기계발계획'		/>|<sht:txt mid='BLANK'      mdef='희망월'			/>", Type:"Combo"   , Hidden:1, Width:40 , Align:"Center", ColMerge:0, SaveName:"eduPreYmd"    , KeyField:0, CalcLogic:"", Format:"Ymd"        , PointCount:0, UpdateEdit:cellEditable, InsertEdit:cellEditable, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='점수'			/>|<sht:txt mid='BLANK'      mdef='점수'			/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"point"        , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:1           , InsertEdit:1           , EditLen:100  },
			{Header:"<sht:txt mid='BLANK'      mdef='번호'			/>|<sht:txt mid='BLANK'      mdef='번호'			/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"num"          , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:1           , EditLen:20   },
			{Header:"<sht:txt mid='BLANK'      mdef='구분'			/>|<sht:txt mid='BLANK'      mdef='구분'			/>", Type:"Text"    , Hidden:1, Width:0  , Align:"Center", ColMerge:0, SaveName:"itemGubun"    , KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:1           , EditLen:4    },
			{Header:"<sht:txt mid='BLANK'      mdef='팀장\n확인'		/>|<sht:txt mid='BLANK'      mdef='팀장\n확인'		/>", Type:"CheckBox", Hidden:1, Width:50 , Align:"Center", ColMerge:0, SaveName:"confirmStatus", KeyField:0, CalcLogic:"", Format:""           , PointCount:0, UpdateEdit:0           , InsertEdit:0           , EditLen:4    },
		];
		IBS_InitSheet(sheet3, initdata3);
		sheet3.SetCountPosition(0);
		sheet3.SetEditable(true);
		sheet3.SetVisible(true);

		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata4.Cols = [
			{Header:"<sht:txt mid='sNo'        mdef='No'		/>", Type:"${sNoTy}", Hidden:0, Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus'    mdef='상태'		/>", Type:"${sSttTy}",Hidden:1, Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" , Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'		/>", Type:"${sDelTy}",Hidden:1, Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"직무",			Type:"Combo",		Hidden:0,  Width:30,	Align:"Center",	 ColMerge:0,   SaveName:"jobCd",		KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"교육기관명",	    Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"eduOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"교육명",		    Type:"Text",      	Hidden:0,  Width:100,   Align:"Left",	 ColMerge:0,   SaveName:"eduCourseNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"교육구분",		Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"eduBranchNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"이수여부",		Type:"CheckBox",   	Hidden:0,  Width:20,   Align:"Center",  ColMerge:0,   SaveName:"compYn",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, TrueValue:"Y", FalseValue:"N" },
	 		{Header:"신청",			Type:"Html",		Hidden:0,  Width:20,  Align:"Center", ColMerge:0,	SaveName:"btnApp",  		Sort:0},
	 		{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"cnt"}
		];
		IBS_InitSheet(sheet4, initdata4);
		sheet4.SetCountPosition(0);
		sheet4.SetEditable(true);
		sheet4.SetVisible(true);
		// 콥보 리스트
		/* ########################################################################################################################################## */
		var grpCds = "H99010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		sheet4.SetColProperty("jobCd", 			{ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );			//직무코드
		/* ########################################################################################################################################## */

		sheet4.SetImageList(0,"/common/images/icon/icon_info.png");
		sheet4.SetDataLinkMouse("workNote", 1);

		// ----------------

		var initdata5 = {};
		initdata5.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata5.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata5.Cols = [
			{Header:"<sht:txt mid='sNo'     mdef='No'					/>", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}") , Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'					/>", Type:"${sSttTy}", Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK'   mdef='활동년도'					/>", Type:"Text"   , Hidden:0, Width:40 , Align:"Center", ColMerge:0, SaveName:"activeYyyy"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4    },
			{Header:"<sht:txt mid='BLANK'   mdef='반기구분'					/>", Type:"Combo"  , Hidden:0, Width:50 , Align:"Center", ColMerge:0, SaveName:"halfGubunType"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1    },
			{Header:"<sht:txt mid='BLANK'   mdef='사원번호'					/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"sabun"                , KeyField:1, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'   mdef='경력목표코드'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"careerTargetCd"       , KeyField:1, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:22   },
			{Header:"<sht:txt mid='BLANK'   mdef='이동희망업무[1순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignCd1"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='이동희망업무[2순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignCd2"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='이동희망업무[3순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignCd3"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='이동희망시기'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"moveHopeTime"         , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='이동희망사유'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"moveHopeCd"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:22   },
			{Header:"<sht:txt mid='BLANK'   mdef='이동희망세부사유'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"moveHopeDesc"         , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'   mdef='비상대체자'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgCd1"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='선정사유'					/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgCd2"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='후임자[1순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgCd3"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='선정사유[1순위]]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgNm1"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50   },
			{Header:"<sht:txt mid='BLANK'   mdef='후임자[2순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgNm2"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50   },
			{Header:"<sht:txt mid='BLANK'   mdef='선정사유[2순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgNm3"           , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50   },
			{Header:"<sht:txt mid='BLANK'   mdef='후임자[3순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgCdMoveHopeTime", KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='선정사유[3순위]'			/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgCdMoveHopeCd"  , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:22   },
			{Header:"<sht:txt mid='BLANK'   mdef='발령요청일'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgCdMoveHopeDesc", KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'   mdef='발령상태'					/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"transferEmpNo"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'   mdef='승인부서코드'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"transferDesc"         , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'   mdef='승인부서'					/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"successorEmpNo1"      , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'   mdef='승인팀코드'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"successorDesc1"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'   mdef='승인팀'					/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"successorEmpNo2"      , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'   mdef='승인자사번'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"successorDesc2"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'   mdef='승인자성명'				/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"successorEmpNo3"      , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'   mdef='successorDesc3'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"successorDesc3"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalReqYmd'		/>", Type:"Text"   , Hidden:0, Width:80 , Align:"Center", ColMerge:0, SaveName:"approvalReqYmd"       , KeyField:0, CalcLogic:"", Format:"Ymd", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10    },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalStatus'		/>", Type:"Combo"  , Hidden:0, Width:80 , Align:"Center", ColMerge:0, SaveName:"approvalStatus"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1    },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalMainOrgCd'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"approvalMainOrgCd"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalMainOrgNm'	/>", Type:"Text"   , Hidden:0, Width:80 , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgNm"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50   },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalOrgCd'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"approvalOrgCd"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalOrgNm'		/>", Type:"Text"   , Hidden:0, Width:80 , Align:"Center", ColMerge:0, SaveName:"approvalOrgNm"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalEmpNo'		/>", Type:"Text"   , Hidden:0, Width:70 , Align:"Center", ColMerge:0, SaveName:"approvalEmpNo"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalEmpName'		/>", Type:"Text"   , Hidden:0, Width:70 , Align:"Center", ColMerge:0, SaveName:"approvalEmpName"      , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:20   },
			{Header:"<sht:txt mid='BLANK'   mdef='approvalYmd'			/>", Type:"Text"   , Hidden:0, Width:80 , Align:"Center", ColMerge:0, SaveName:"approvalYmd"          , KeyField:0, CalcLogic:"", Format:"Ymd", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10    },
			{Header:"<sht:txt mid='BLANK'   mdef='careerTargetNm'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"careerTargetNm"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='careerTargetType'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"careerTargetType"     , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1    },
			{Header:"<sht:txt mid='BLANK'   mdef='careerTargetDesc'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"careerTargetDesc"     , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNmLarge1'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNmLarge1"   , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNmMiddle1'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNmMiddle1"  , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNm1'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNm1"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNmLarge2'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNmLarge2"   , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNmMiddle2'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNmMiddle2"  , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNm2'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNm2"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNmLarge3'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNmLarge3"   , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNmMiddle3'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNmMiddle3"  , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignNm3'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignNm3"        , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignAppCnt1'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignAppCnt1"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignCurCnt1'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignCurCnt1"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignWrkExp1'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignWrkExp1"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignAppCnt2'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignAppCnt2"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignCurCnt2'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignCurCnt2"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignWrkExp2'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignWrkExp2"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignAppCnt3'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignAppCnt3"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignCurCnt3'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignCurCnt3"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='workAssignWrkExp3'	/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"workAssignWrkExp3"    , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='mainOrgAppCnt1'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgAppCnt1"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='mainOrgAppCnt2'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgAppCnt2"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='mainOrgAppCnt3'		/>", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"mainOrgAppCnt3"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100  },
			{Header:"<sht:txt mid='BLANK'   mdef='careerMap'		    />", Type:"Text"   , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"careerMap"       , KeyField:0, CalcLogic:"", Format:""   , PointCount:0, UpdateEdit:1, InsertEdit:1},
		];
		IBS_InitSheet(sheet5, initdata5);
		sheet5.SetCountPosition(0);
		sheet5.SetEditable(true);
		sheet5.SetVisible(true);

		fnSetCodeInc();

		$(window).smartresize(sheetResize); sheetInit();

	});

	function fnSetCodeInc() {
		//상하반기
		var gradeCd	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00012"), "");
		sheet3.SetColProperty("selfGrade" , {ComboText:gradeCd[0], ComboCode:gradeCd[1]} );
		sheet3.SetColProperty("workGrade" , {ComboText:gradeCd[0], ComboCode:gradeCd[1]} );
		sheet3.SetColProperty("hope1Grade", {ComboText:gradeCd[0], ComboCode:gradeCd[1]} );
		sheet3.SetColProperty("hope2Grade", {ComboText:gradeCd[0], ComboCode:gradeCd[1]} );
		sheet3.SetColProperty("hope3Grade", {ComboText:gradeCd[0], ComboCode:gradeCd[1]} );

		var eduPreYmdCd	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00014"), "");
		sheet3.SetColProperty("eduPreYmd" , {ComboText:eduPreYmdCd[0], ComboCode:eduPreYmdCd[1]} );
	}

	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				var nSelectRow = sheet1.GetSelectRow();
				var param = "searchYyyy="+sheet1.GetCellValue(nSelectRow,"activeYyyy")+"&searchHalfGubunType="+sheet1.GetCellValue(nSelectRow,"halfGubunType")+"&searchSabun="+sheet1.GetCellValue(nSelectRow,"sabun");
				sheet3.DoSearch( "${ctx}/SelfDevelopmentApp.do?cmd=getSelfSkillAndDevPlanList",param );
				break;
			case "Save":
				if(sheet3.FindStatusRow("I|S|D|U") != ""){
					IBS_SaveName(document.srchFrm,sheet3);
					sheet3.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveSelfSkillAndDevPlan", $("#srchFrm").serialize(),-1,0);
				}
				break;
			case "Copy":		//행복사
				var year  = sheet1.GetCellValue(sheet1.GetSelectRow(),"activeYyyy");
				var half  = sheet1.GetCellValue(sheet1.GetSelectRow(),"halfGubunType");
				var sabun = sheet1.GetCellValue(sheet1.GetSelectRow(),"sabun");
				var trmCd = $("#searchTrmCd").val();

				if(sheet3.GetCellValue(sheet3.GetSelectRow(),"education") == ""){
					sheet3.SetCellValue(sheet3.GetSelectRow(), "activeYyyy"   , year );
					sheet3.SetCellValue(sheet3.GetSelectRow(), "halfGubunType", half );
					sheet3.SetCellValue(sheet3.GetSelectRow(), "sabun"		, sabun);
					sheet3.SetCellValue(sheet3.GetSelectRow(), "trmCd"		, trmCd);
				}else {
					var iRow = sheet3.DataCopy();
					sheet3.SetCellValue(iRow, "activeYyyy"   , year );
					sheet3.SetCellValue(iRow, "halfGubunType", half );
					sheet3.SetCellValue(iRow, "sabun"		, sabun);
					sheet3.SetCellValue(iRow, "trmCd"		, trmCd);

					sheet3.SetSelectRow(iRow);
				}

				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet3.Down2Excel(param);
				break;
		}
	}

	function doAction4(sAction) {
		switch (sAction) {
			case "Search":
				var nSelectRow = sheet1.GetSelectRow();
				var param = "&workAssignList="+sheet5.GetCellValue(1,"workAssignCd1") + ","+sheet5.GetCellValue(1,"workAssignCd2") + ","+sheet5.GetCellValue(1,"workAssignCd3");
				param += "&searchSabun="+sheet5.GetCellValue(1,"sabun");
				
				sheet4.DoSearch( "${ctx}/SelfDevelopmentApp.do?cmd=getWorkJobList",param );
				break;
// 사용안함 (혼동방지를 위해 주석처리)
//			 case "Save":
//				 IBS_SaveName(document.srchFrm,sheet4);
//				 sheet4.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveVacationAppEx", $("#srchFrm").serialize()); break;
//			 case "Down2Excel":
//				 var downcol = makeHiddenSkipCol(sheet4);
//				 var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
//				 sheet4.Down2Excel(param);
//				 break;
		}
	}

	function doAction5(sAction) {
		switch (sAction) {
			case "Search":
				var nSelectRow = sheet1.GetSelectRow();
				var param = "searchYyyy="+sheet1.GetCellValue(nSelectRow,"activeYyyy")+"&searchHalfGubunType="+sheet1.GetCellValue(nSelectRow,"halfGubunType")+"&searchSabun="+sheet1.GetCellValue(nSelectRow,"sabun");
				sheet5.DoSearch( "${ctx}/SelfDevelopmentApp.do?cmd=getSelfReportMoveHopeList",param );
				break;
// 사용안함 (혼동방지를 위해 주석처리)
//			 case "Save":
//				 IBS_SaveName(document.srchFrm,sheet5);
//				 sheet5.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveVacationAppEx", $("#srchFrm").serialize()); break;
//			 case "Down2Excel":
//				 var downcol = makeHiddenSkipCol(sheet5);
//				 var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
//				 sheet5.Down2Excel(param);
//				 break;
		}
	}

	//Tab 선택 시
	function moveTab(tabIdx){
		var a=1
		// 0: KPI, 1:역량, 2:평가의견
		  switch(tabIdx){
			case 0: //KPI
				$("#spanGrade1").show();  //KPI점수
				$("#spanGrade2").hide();
				$("#spanGrade3").hide();
				$("#btnCompDic").hide(); //역량사전
				break;
			case 1://역량
				$("#spanGrade1").hide();
				$("#spanGrade2").show(); //역량점수
				$("#spanGrade3").hide();
				$("#btnCompDic").show(); //역량사전

				setTimeout(function(){setSheetSize(sheet3);}, 50);
				break;
			case 2://평가의견
				$("#spanGrade1").hide();
				$("#spanGrade2").hide();
				$("#spanGrade3").show(); //KPI점수 + 역량점수
				$("#btnCompDic").hide(); //역량사전
				break;
		}
	}

	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
//			 if (Msg != "") {
//				 alert(Msg);
//			 }
			doAction3("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			// 팀장승인 상태이면 삭제 불가
			if ($("#prgType").val() == "Apr" && sheet1.GetCellValue(sheet1.GetSelectRow(),"approvalStatus") == "1") {
				for(var i = sheet3.HeaderRows(); i<=sheet3.LastRow(); i++){
					if(sheet3.GetCellValue(i, "education") == ""){
						sheet3.SetCellEditable(i, "confirmStatus",false);
					}
					else if(sheet3.GetCellValue(i, "education") != ""){
						sheet3.SetCellEditable(i, "confirmStatus",true);
					}
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//팝업
		if(sheet3.ColSaveName(Col) == "sDelete"){

			if(sheet3.GetCellValue(Row, "education") == ""){
				sheet3.SetCellValue(Row, "sDelete","0", {event:false});
				alert("삭제할 희망교육과정이 없습니다.");
				return;
			}

			if(sheet3.GetCellValue(sheet3.GetSelectRow(), "sStatus") == "I"){
				sheet3.RowDelete(Row, false);
			}else{
				var cnt = 0;
				var delChkCnt = 0;

				for(var i=0; i < sheet3.RowCount(); i++){
					if(sheet3.GetCellValue(sheet3.GetSelectRow(), "code") == sheet3.GetCellValue(i, "code")){
						cnt = cnt + 1;
						if (sheet3.GetCellValue(sheet3.GetSelectRow(), "sDelete") == "1") {
							delChkCnt = delChkCnt + 1;
						}
					}
				}

				//sStatus2
				if(cnt <= 1){
					sheet3.SetCellValue(sheet3.GetSelectRow(), "education"   ,"")
					sheet3.SetCellValue(sheet3.GetSelectRow(), "educationnm" ,"")
					sheet3.SetCellValue(sheet3.GetSelectRow(), "eduPreYmd"   ,"")
					sheet3.SetCellValue(sheet3.GetSelectRow(), "time"		,"")
					sheet3.SetCellValue(sheet3.GetSelectRow(), "num"		 ,"")
					sheet3.SetCellValue(sheet3.GetSelectRow(), "itemGubun"   ,"")
					//sheet3.SetCellValue(sheet3.GetSelectRow(), "sStatus"	 ,"R");
				}else{
					//sheet3.RowDelete(Row,0);
					sheet3.SetCellValue(sheet3.GetSelectRow(), "sStatus"	 ,"D");
					if (nCnt == delChkCnt) {
						sheet3.SetCellValue(Row, "education"   ,"" , {event:false})
						sheet3.SetCellValue(Row, "educationnm" ,"" , {event:false})
						sheet3.SetCellValue(Row, "eduPreYmd"   ,"" , {event:false})
						sheet3.SetCellValue(Row, "time"		,"" , {event:false})
						sheet3.SetCellValue(Row, "num"		 ,"" , {event:false})
						sheet3.SetCellValue(Row, "itemGubun"   ,"" , {event:false})
						sheet3.SetCellValue(Row, "sDelete"	 ,"0", {event:false});
						sheet3.SetCellValue(Row, "sStatus"	 ,"U");
					}
				}
			}

		}

		if(sheet3.ColSaveName(Col) == "educationnm") {
			//내부교육
			if(sheet3.GetCellValue(Row, "itemGubun") == "1") {
				var num = sheet3.GetCellValue(Row, "num");
				var education = sheet3.GetCellValue(Row, "education");
				var openWindow = CenterWin("../../tra/course/EducationDetail.jsp?dataAuthority=<//%=dataAuthority%//>&_editFlag=FALSE&num="+num+"&education="+education, "EducationDetail", "scrollbars=yes, status=no, width=860, height=700, top=0, left=0");
				openWindow.focus();
			}
			//외부교육
			else if(sheet3.GetCellValue(Row, "itemGubun") == "2") {
				var num = sheet3.GetCellValue(Row, "num");
				var education = sheet3.GetCellValue(Row, "education");
				var openWindow = CenterWin("../../tra/outcourse/OutEducationDetail.jsp?dataAuthority=<//%=dataAuthority%//>&_editFlag=FALSE&seq="+education, "OutEducationDetail", "scrollbars=yes, status=no, width=860, height=700, top=0, left=0");
				openWindow.focus();
			}
			else if(sheet3.GetCellValue(Row, "itemGubun") == "") {
				return;
			}else {
				alert("연수원교육입니다.");
				return;
			}
		}
	}


	function sheet3_OnPopupClick(Row, Col){
		try{
			if(Row > 0 && sheet3.ColSaveName(Col) == "educationnm"){

				$("#searchTrmCd"  ).val(sheet3.GetCellValue(Row, "code"	 ));
				$("#searchTrmType").val(sheet3.GetCellValue(Row, "gubunCode"));
				$("#searchTrmNm"  ).val(sheet3.GetCellValue(Row, "codeNm"   ));
				
				var approvalStatus = $("#approvalStatus").val(); 

				if (approvalStatus == "3" ) {
					//내부교육
					if (sheet3.GetCellValue(Row, "itemGubun") == "1") {
						var num = sheet3.GetCellValue(Row, "num");
						var education = sheet3.GetCellValue(Row, "education");
						//var openWindow = CenterWin("../../tra/course/EducationDetail.jsp?dataAuthority=</%=dataAuthority%>&_editFlag=FALSE&num="+num+"&education="+education, "EducationDetail", "scrollbars=yes, status=no, width=860, height=700, top=0, left=0");
						openWindow.focus();
					}
					//외부교육
					else if (sheet3.GetCellValue(Row, "itemGubun") == "2") {
						var num = sheet3.GetCellValue(Row, "num");
						var education = sheet3.GetCellValue(Row, "education");
						//var openWindow = CenterWin("../../tra/outcourse/OutEducationDetail.jsp?dataAuthority=</%=dataAuthority%>&_editFlag=FALSE&seq="+education, "OutEducationDetail", "scrollbars=yes, status=no, width=860, height=700, top=0, left=0");
					} else if (sheet3.GetCellValue(Row, "itemGubun") == "") {
						return;
					} else {
						alert("연수원교육입니다.");
						return;
					}
				}else{
					selfDevelopmentTRMPopup(Row);
				}
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function sheet4_OnClick(Row, Col, Value) {
		try{
			if(sheet4.ColSaveName(Col) == "workNote" ) {
				rdWorkAssignNotePopup(Row);
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	function sheet4_OnSearchEnd() {
		var rowCnt = sheet4.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			
			if(sheet4.GetCellValue(i, "compYn") == "N" && sheet4.GetCellValue(i, "cnt") > 0){
				sheet4.SetCellValue(i, "btnApp", "<a class='button sbutton' style='height:17px;padding:0px 10px 2px 10px'>신청</a>");
			}
			
		}

	}
	// 경력개발계획 클릭 이벤트
	function sheet4_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		
		if( NewRow < sheet4.HeaderRows() ) return;
		
			if( sheet4.ColSaveName(NewCol) == "btnApp" && sheet4.GetCellValue(NewRow, "compYn") == "N" && sheet4.GetCellValue(NewRow, "cnt") > 0) {
		        if(typeof goSubPage == 'undefined') {
		            // 서브페이지에서 서브페이지 호출
		            if(typeof window.top.goOtherSubPage == 'function') {
		                window.top.goOtherSubPage("", "", "", "", "EduApp.do?cmd=viewEduApp");
		            }
		        } else {
		            goSubPage("", "", "", "", "EduApp.do?cmd=viewEduApp");
		        }
			}
	}
	

	function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if( sheet5.RowCount() != 0 ) {
				const voContent = sheet5.GetCellValue(sheet5.GetSelectRow(), "careerMap");
				$("#span_careerTargetNm").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "careerTargetNm"));

				const voAtag = document.createElement('a')
				voAtag.innerHTML = '[상세보기]'
				voAtag.addEventListener("click", () =>{careerMapDetailPopup(voContent)})
				$("#span_careerTargetNm").append(voAtag);

				$("#workAssignNm1Large" ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmLarge1"));
				$("#workAssignNm1Middle").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmMiddle1"));
				$("#workAssignNm1"	  ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNm1"));

				$("#workAssignNm2Large" ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmLarge2"));
				$("#workAssignNm2Middle").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmMiddle2"));
				$("#workAssignNm2"	  ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNm2"));

				$("#workAssignNm3Large" ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmLarge3"));
				$("#workAssignNm3Middle").html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNmMiddle3"));
				$("#workAssignNm3"	  ).html(sheet5.GetCellValue(sheet5.GetSelectRow(), "workAssignNm3"));
				
				doAction4('Search');
			}else{
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function fnClearSheetInc() {
		sheet3.RemoveAll();
		sheet4.RemoveAll();
		sheet5.RemoveAll();
		fnClearInputInc();
	}

	function fnDoActionInc(){
		fnClearInputInc();
		doAction3('Search');
		doAction5('Search');
	}

	function fnClearInputInc() {
		$("#span_careerTargetNm").html("");
		$("#workAssignNm1Large" ).html("");
		$("#workAssignNm2Large" ).html("");
		$("#workAssignNm3Large" ).html("");
		$("#workAssignNm1Middle").html("");
		$("#workAssignNm2Middle").html("");
		$("#workAssignNm3Middle").html("");
		$("#workAssignNm1"      ).html("");
		$("#workAssignNm2"      ).html("");
		$("#workAssignNm3"      ).html("");

		//본인 및 팀장의견 Clear
		$("#approvalReqMemo"   ).val("");
		$("#approvalReturnMemo").val("");
	}


	/**
	 * 상세내역 window open event
	 */
	function selfDevelopmentTRMPopup(Row) {
		if (!isPopup()) {
			return;
		}

		var w = 1000;
		var h = 700;
		var url = "${ctx}/SelfDevelopmentTRM.do?cmd=viewSelfDevelopmentTRMPopup&authPg=${authPg}";
		var args = new Array();
		var arrCodes = new Array();

		var nSelectRow = sheet1.GetSelectRow();
		var searchSabun = sheet1.GetCellValue(nSelectRow,"sabun");

		for (var i=0, nICnt=sheet3.RowCount(); i<nICnt; i++) {

			if (sheet3.GetCellValue(Row, "code") == sheet3.GetCellValue(i, "code") && sheet3.GetCellValue(Row, "gubunCode") == sheet3.GetCellValue(i, "gubunCode") ) {

				if (sheet3.GetCellValue(i, "gubunCode") != ""){
					arrCodes.push(sheet3.GetCellValue(i, "education"));
				}
			}
		}

		args["trmCd"	  ] = sheet3.GetCellValue(Row, "code");
		args["trmType"	] = sheet3.GetCellValue(Row, "gubunCode");
		args["trmNm"	  ] = sheet3.GetCellValue(Row, "codeNm");
		args["searchSabun"] = searchSabun
		args["eduList"	] = arrCodes.toString();

		gPRow = Row;
		pGubun = "selfDevelopmentTRMPopup";

		openPopup(url, args, w, h);
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "selfDevelopmentTRMPopup"){
			var eduList = rv["eduList"];
			var strArray = eduList.split(",");
			if (strArray.length>=5) {
				for ( var i=0,nICnt=strArray.length;i<nICnt; i += 5) {
					doAction3('Copy');
					var nRow = sheet3.GetSelectRow();
					sheet3.SetCellValue(nRow,"education"  , strArray[i  ]);
					sheet3.SetCellValue(nRow,"educationnm", strArray[i+1]);
					sheet3.SetCellValue(nRow,"time"       , strArray[i+2]);
					sheet3.SetCellValue(nRow,"num"        , strArray[i+3]);
					sheet3.SetCellValue(nRow,"itemGubun"  , strArray[i+4]);
				}
			}
		}
	}


	function doSave(sStatus) {
		var msg = "";
		if(sStatus == "1"){ msg = "승인요청"; }
		else if(sStatus == "2"){ msg = "요청취소"; }
		else if(sStatus == "9"){ msg = "저장"; }
		else if(sStatus == "3"){ msg = "완료"; }

		if(confirm(msg+"하시겠습니까?")){
			//if(sStatus != "9") {
			if(sheet3.RowCount() != 0){
				var chkEdu = "Y";
//				 for(var i=0; i<= sheet3.RowCount(); i++ ) {
//					 if(sheet3.GetCellValue(i, "educationnm") != ""){
//						 if(sheet3.GetCellValue(i, "eduPreYmd") == ""){
//							 alert("예상교육일정은 필수 입력사항입니다.");
//							 actionFlag = true;
//							 sheet3.SelectCell(i, "eduPreYmd");
//							 return;
//						 }
//						 else {
//							 chkEdu = "Y";
//						 }
//					 }
//				 }
			}
			else {
				alert("교육과정이 없습니다. 입력해 주십시요.");
				actionFlag = true;
				return;
			}
			
			sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalStatus"  , sStatus);
			sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalReqMemo" , $("#approvalReqMemo").val());

			//요청일때 요청일 셋팅
			if(sStatus == "1"){
				sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalReqYmd", '${curSysYyyyMMdd}');
			} else {
				sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalReqYmd", "");
			}
			
			if(sStatus == "3"){ // && authorityGroup == "19"){
				var nSelectRow = sheet1.GetSelectRow();
				var searchSabun = sheet1.GetCellValue(nSelectRow,"sabun");
				
				sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalEmpNo"	, searchSabun);
				sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalEmpName"  , "");
				sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalYmd"	  , '${curSysYyyyMMdd}' );
				
				if(sheet3.RowCount() != 0){
					for(var i=2; i<= sheet3.LastRow(); i++ ) {
						if(sheet3.GetCellValue(i, "eduDevPlan") != ""){
							sheet3.SetCellValue(i, "confirmStatus","1");
						}
					}
				}
			}

			doAction1("Save");
			doAction3("Save");

			alert("자기계발계획서가 "+msg+"되었습니다.");
		}
	}


	// 승인화면에서의 기능버튼 처리
	function doSaveApr(sStatus){
		if (sStatus == "0") {
			if(sheet1.RowCount != 0){
				if(confirm("승인취소 하시겠습니까?")){
					if (sheet1.GetSelectRow() > 0 ) {
						sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalStatus", "1");
						if(sheet1.FindStatusRow("I|S|D|U") != ""){
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/SelfDevelopmentApr.do?cmd=saveSelfDevelopmentAprCancel", $("#srchFrm").serialize(),-1,0);
						}
					}else {
						alert("승인취소할 항목이 없습니다.");
					}
				}
			}else{
				alert("승인취소할 항목이 없습니다.");
			}

		} else if (sStatus == "3" || sStatus == "4") { // 3: 승인 4:반려

			var msg = "";

			if(sStatus == "3") {
				msg = "승인";
			} else if(sStatus == "4") {
				msg = "반려";
			}

			if(sheet1.RowCount != 0){
				if(confirm(msg+"하시겠습니까?")){
					sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalStatus"	 , sStatus);
					sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalEmpNo"	  , "${ssnSabun}");
					sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalYmd"		, "${curSysYyyyMMdd}");
					sheet1.SetCellValue(sheet1.GetSelectRow(), "approvalReturnMemo" , $("#approvalReturnMemo").val() );

					doAction3("Save");   // 3번Sheet 저장

					if(sheet1.FindStatusRow("I|S|D|U") != ""){
						IBS_SaveName(document.srchFrm,sheet1);
						sheet1.DoSave( "${ctx}/SelfDevelopmentApr.do?cmd=saveSelfDevelopmentAprConfirmOrReject", $("#srchFrm").serialize(),-1,0);
					}
				}
			} else {
				alert(msg + "할 항목이 없습니다.");
				return;
			}
		}
	}

	function setAuth(nRow){
		try {

			var approvalStatus = $("#approvalStatus").val();
			var prgType        = $("#prgType").val();
			
			$("#funcBtnList").find("a").hide();
			
			if (approvalStatus == "3" && prgType=="Apr") {   // 팀장승인
				$("#btnCancle").show();
			
			} else if (approvalStatus == "1" && prgType=="Apr") {   // 승인요청
				$("#btnAccept").show();
				$("#btnReject").show();

				$("#approvalReqMemo").attr("readonly",true).addClass("readonly");
				$("#approvalReqMemo").removeClass("required");

				$("#approvalReturnMemo").attr("readonly",false).removeClass("readonly");
				$("#approvalReturnMemo").removeAttr("disabled");
				
			} else if ((approvalStatus != "1" && approvalStatus != "3") && prgType=="App") {   // 저장
				$("#btnReq").show();
				$("#btnSave").show();

				$("#approvalReqMemo").removeAttr("disabled");
//				 $("#approvalReqMemo").removeClass("readonly");
				$("#approvalReqMemo").attr("readonly",false).removeClass("readonly");

				$("#approvalReturnMemo").attr("readonly", true).addClass("readonly");
				$("#approvalReturnMemo").removeClass("required");
				
			} else if ((approvalStatus =="1" || approvalStatus =="3") && prgType == "App" ) {
				$("#approvalReqMemo").attr("readonly",true).addClass("readonly");
				$("#approvalReqMemo").removeClass("required");

				$("#approvalReturnMemo").attr("readonly", true).addClass("readonly");
				$("#approvalReturnMemo").removeClass("required");
			}

			// 팀장승인 상태이면 삭제 불가
			if (approvalStatus == "3" ) {
				$("#approvalReqMemo").attr("readonly",true).addClass("readonly");
				$("#approvalReqMemo").removeClass("required");
				$("#approvalReturnMemo").attr("readonly",true).addClass("readonly");
				$("#approvalReturnMemo").removeClass("required");
			}

		}catch (ex) {
			console.log("setAuth Exception : ", ex);
		}
	}


	function rdWorkAssignNotePopup(Row){
		var w	= 900;
		var h	= 700;
		var url  = "${ctx}/RdPopup.do";
		var args = new Array();

		var rdMrd		   = "";
		var rdTitle		 = "";
		var rdParam		 = "";

		var nSelectRow = sheet1.GetSelectRow();
		var searchSabun = sheet1.GetCellValue(nSelectRow,"sabun");
		
		///rp [HR][5070037][2008][1][하반기]

		//rdMrd   = "hrm/empcard/PersonInfoCard_${ssnEnterCd}.mrd";
		rdMrd   = "cdp/WorkAssignNote.mrd";
		rdTitle = "기술서";

		rdParam += "[${ssnEnterCd}]";
		rdParam += "["+sheet4.GetCellValue(Row,"workAssignCd")+"]";
		rdParam += "["+searchSabun+"]";


		var imgPath = " " ;
		args["rdTitle"]	  = rdTitle ; // rd Popup제목
		args["rdMrd"]		= rdMrd;	// ( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"]	  = rdParam;  // rd파라매터
		args["rdParamGubun"] = "rp";	 // 파라매터구분(rp/rv)
		args["rdToolBarYn"]  = "Y" ;	 // 툴바여부
		args["rdZoomRatio"]  = "100";	// 확대축소비율

		args["rdSaveYn"]  = "Y" ;  // 기능컨트롤_저장
		args["rdPrintYn"] = "Y" ;  // 기능컨트롤_인쇄
		args["rdExcelYn"] = "Y" ;  // 기능컨트롤_엑셀
		args["rdWordYn"]  = "Y" ;  // 기능컨트롤_워드
		args["rdPptYn"]   = "Y" ;  // 기능컨트롤_파워포인트
		args["rdHwpYn"]   = "Y" ;  // 기능컨트롤_한글
		args["rdPdfYn"]   = "Y" ;  // 기능컨트롤_PDF

		var rv = openPopup(url, args, w, h);  // 알디출력을 위한 팝업창
		if(rv!=null && rv["printResultYn"] == "Y"){
		}
	}


	function careerMapDetailPopup(poCareerMapContent) {

		if (!isPopup()) {
			return;
		}

		let w = 900;
		let h = 700;
		let url = "${ctx}/CareerTarget.do?cmd=viewCareerMapDetailLayer&authPg=${authPg}";

		pGubun = "careerMapDetailLayer";

		const p = {
			//careerTargetCd : sheet1.GetCellValue(Row, "careerTargetCd"),
			careerMap : poCareerMapContent,
			readYn : 'Y'
		};

		const careerMapDetailLayer = new window.top.document.LayerModal({
			id : 'careerMapDetailLayer' //식별자ID
			, url : url
			, parameters : p
			, width : w
			, height : h
			, title : '경력목표 세부내역'
			, trigger :[
				{
					name : 'careerMapDetailLayerTrigger'
					, callback : function(result){
						doAction1("Search");
					}
				}
			]
		});
		careerMapDetailLayer.show();

	}

</script>
<input type="hidden" id="searchTrmType" name="searchTrmType"  >
<input type="hidden" id="searchTrmCd"   name="searchTrmCd"  >
<input type="hidden" id="searchTrmNm"   name="searchTrmNm"  >
<div class="innertab inner" style="height:100%;">
	<div id="tabs" class="tab">
		<ul class="outer tab_bottom">
			<li><a href="#tabs-1" onClick="$('#tabsIndex').val('0');moveTab(0);"><tit:txt mid='BLANK' mdef='자기신고'/></a></li>
			<li><a href="#tabs-2" onClick="$('#tabsIndex').val('1');moveTab(1);"><tit:txt mid='BLANK' mdef='자기계발계획'/></a></li>
			<li><a href="#tabs-3" onClick="$('#tabsIndex').val('2');moveTab(2);"><tit:txt mid='BLANK' mdef='본인 및 팀장의견'/></a></li>
			<li id="funcBtnList" class="h30" style="border:0px; line-height: 30px; float:right;">
				<a style="display:none;"></a>
				<a href="javascript:doSaveApr('0');" class="basic" id="btnCancle"><tit:txt mid='BLANK' mdef='승인취소'/></a>
				<a href="javascript:doSaveApr('3');" class="basic" id="btnAccept"><tit:txt mid='BLANK' mdef='승인'/></a>
				<a href="javascript:doSaveApr('4');" class="basic" id="btnReject"><tit:txt mid='BLANK' mdef='반려'/></a>
				<a href="javascript:doSave('1');"    class="basic" id="btnReq"><tit:txt mid='BLANK' mdef='승인요청'/></a>
				<a href="javascript:doSave('9');"    class="basic" id="btnSave"><tit:txt mid='104476' mdef='저장'/></a>
			</li>
		</ul>
		<div id="tabs-1" style="height:100%">
			<div class='disp_flex justify_between alignItem_start'>
				<div class="w40p">
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='BLANK' mdef='경력목표 및 이동희망업무'/></li>
							</ul>
						</div>
					</div>
					<table cellpadding="0" cellspacing="0" class="table">
						<colgroup>
							<col width="11%" />
							<col width="11%" />
							<col width="26%" />
							<col width="26%" />
							<col width="26%" />
						</colgroup>
						<tr>
							<th colspan="2">경력목표</th>
							<td colspan="3"><span id="span_careerTargetNm"></span></td>
						</tr>
						<tr>
							<th rowspan="4">이동희망<br>단위업무</th>
							<th >&nbsp;</th>
							<th class="pad-x-15 alignC">1순위</th>
							<th class="pad-x-15 alignC">2순위</th>
							<th class="pad-x-15 alignC">3순위</th>
						</tr>
						<tr>
							<th>대분류</th>
							<td class="pad-x-15 alignC"><span id="workAssignNm1Large"></span></td>
							<td class="pad-x-15 alignC"><span id="workAssignNm2Large"></span></td>
							<td class="pad-x-15 alignC"><span id="workAssignNm3Large"></span></td>
						</tr>
						<tr>
							<th>중분류</th>
							<td class="pad-x-15 alignC"><span id="workAssignNm1Middle"></span></td>
							<td class="pad-x-15 alignC"><span id="workAssignNm2Middle"></span></td>
							<td class="pad-x-15 alignC"><span id="workAssignNm3Middle"></span></td>
						</tr>
						<tr>
							<th>단위업무</th>
							<td class="pad-x-15 alignC"><span id="workAssignNm1"></span></td>
							<td class="pad-x-15 alignC"><span id="workAssignNm2"></span></td>
							<td class="pad-x-15 alignC"><span id="workAssignNm3"></span></td>
						</tr>
					</table>
					<div class="hide">
						<script type="text/javascript">createIBSheet("sheet5", "100%", "100%", "${ssnLocaleCd}"); </script>
					</div>
				</div>
				<div class="w60p mal20">
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='BLANK' mdef='직무관련교육'/></li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet4", "100%", "83%", "${ssnLocaleCd}"); </script>
				</div>
			</div>
		</div>
		<div id="tabs-2">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='BLANK' mdef='자기계발계획 '/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "83%", "${ssnLocaleCd}"); </script>
		</div>
		<div id="tabs-3">
			<table border="0" cellspacing="0" cellpadding="0" class="table mat15 outer">
				<tbody>
				<colgroup>
					<col width="50%"/>
					<col width="50%"/>
				</colgroup>
				<tr>
					<th class="center"><tit:txt mid='BLANK' mdef='자기계발계획 의견'/></th>
					<th class="center"><tit:txt mid='BLANK' mdef='팀장 승인/반려 의견'/></th>
				</tr>
				<tr>
					<td class="kpiCt">
						<textarea id="approvalReqMemo"	name="approvalReqMemo"	class="readonly" disabled style="width:100%; height:100px;" ></textarea>
					</td>
					<td>
						<textarea id="approvalReturnMemo" name="approvalReturnMemo" class="readonly" disabled style="width:100%; height:100px;" ></textarea>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>