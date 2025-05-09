<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css" />
<script type="text/javascript">
    $(function () {
        var searchAppSeqCd  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=Y","P00003"), "전체");//차수(P00003)

        var initdata1 = {};
        initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

        initdata1.Cols = [
            {Header:"No|No",				Type:"Seq",	        Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"평가ID코드(TPAP101)",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"평가단계(P00005)",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"차수|차수",					Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"피평가자|성명",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
            {Header:"피평가자|사번",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
            {Header:"피평가자|평가부서명",			Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
            {Header:"피평가자|직책",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"코칭|평가자사번",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
            {Header:"코칭|평가자성명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSabunName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
            {Header:"코칭|날짜",					Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"coaYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"코칭|장소",					Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"coaPlace",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
            {Header:"코칭|내용",					Type:"Text",	Hidden:0,	Width:450,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, Wrap:1, MultiLineText:1 },
            {Header:"조직코드(TORG101)",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"직위(H20030)",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"직위명",						Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"직무코드(TORG201)",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"직무명",						Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
            {Header:"직군코드(H10050)",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"직종명",						Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"직책(H20020)",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"직급(H20010)",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"직급명",						Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"평가Sheet유형((P20005)",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSheetType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"평가방법코드(P10006)",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appMethodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"평가포함여부",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"주부서여부(YN)",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mainOrgYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"평가제외사유(P00018)",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appExCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"비고",						Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"평가대상자확정여부",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appConfirmYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"평가그룹(TPAP133)(사용안함)",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"1차종료여부",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"app1stYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"이동평가반영비율",			Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appMRate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"임시대상자여부",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tmpYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"MBO마감여부",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboCloseYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"역량마감여부",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compCloseYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"MBO평가대상자여부",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTargetYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
            {Header:"업무개선도",					Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTargetYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
        sheet1.SetUnicodeByte(3);

        sheet1.SetColProperty("appSeqCd", 			{ComboText:"|"+searchAppSeqCd[0],		 	ComboCode:"|"+searchAppSeqCd[1]} );

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");

    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                var param = $("#referIntvHstForm").serialize();
                sheet1.DoSearch( "${ctx}/EvaMain.do?cmd=getAppCoachingMgrList", param );
                break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
</script>
<body class="bodywrap">
<form id="referIntvHstForm" name="referIntvHstForm">
    <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value="${param.searchAppStepCd}"/>
    <input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value="${param.searchAppSeqCd}"/>
    <input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value="${param.searchEvaSabun}"/>
    <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value="${param.searchAppraisalCd}"/>
    <input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value="${param.searchAppOrgCd}"/>
    <input type="hidden" id="searchAppStatusCd" name="searchAppStatusCd" value="${param.searchAppStatusCd}"/>
    <input type="hidden" id="searchPg" name="searchPg" value="referIntvHst"/>
</form>
<div class="wrapper">
    <div class="inner">
        <div class="sheet_title">
            <ul>
                <li class="txt">Coaching확인</li>
            </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "500px", "kr"); </script>
</div>
</body>
