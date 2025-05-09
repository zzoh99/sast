<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript">

    var sSabun = "";
    var classCdList     = null;	// 선택평가의 평가등급 코드 목록(TPAP110)
    $(function () {
        const modal = window.top.document.LayerModalUtility.getModal('evaAprLayer');
        var args = modal.parameters;
        $("#searchAppSabun", "#evaAprLayerFrm").val(args.searchAppSabun);
        $("#searchAppraisalCd", "#evaAprLayerFrm").val(args.searchAppraisalCd);
        $("#searchAppSeqCd", "#evaAprLayerFrm").val(args.searchAppSeqCd);
        $("#searchAppStepCd", "#evaAprLayerFrm").val(args.searchAppStepCd);

        // 평가그룹 설정
        var appGroupCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&"
            ,"queryId=getAppGroupCdList&searchAppraisalCd="+$("#searchAppraisalCd").val()
            +"&searchAppSabun="+$("#searchAppSabun").val()
            +"&searchAppStepCd="+$("#searchAppStepCd").val()
            +"&searchAppSeqCd="+$("#searchAppSeqCd").val()
            ,false).codeList, "");
        $("#searchAppGroupCd").html(appGroupCdList[2]);
        $("#searchChartAppGroupCd").val($("#searchAppGroupCd").val())

        $("#searchAppGroupCd").bind("change",function(event){
            $("#searchChartAppGroupCd").val($("#searchAppGroupCd").val())
            drawChart();
        });

        // 1차 평가인 경우 차트 그리지 않음
        if($("#searchAppSeqCd", "#evaAprLayerFrm").val() == '1')
            $(".evaChart").hide()

        createIBSheet3(document.getElementById('aprLayerSht1-wrap'), "aprLayerSht1", "780px", "400px", "${ssnLocaleCd}");

        var hdnType = 0;
        if($("#searchAppSeqCd", "#evaAprLayerFrm").val() == "1") {
            hdnType = 1;
        }

        // 평가등급코드 조회 Start
        var classCdListsParam = "queryId=getAppClassMgrCdListBySeq&searchAppStepCd=5";
        classCdListsParam += "&searchAppraisalCd=" + $("#searchAppraisalCd", "#evaAprLayerFrm").val();

        classCdList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",classCdListsParam,false).codeList, " ");

        // 평가구분에 따른 업적,역량평가대상자여부 컬럼 출력 여부 설정
        var appTypeCd = $("#searchAppraisalCd", "#evaAprLayerFrm").val().substring(2,3);
        if( appTypeCd == "C" ){				// 종합평가
            mboHdn = 0;
            compHdn = 0;
        } else if( appTypeCd == "A" ) {		// 성과평가
            mboHdn = 0;
            compHdn = 1;
        } else if( appTypeCd == "B" ) {		// 역량평가
            mboHdn = 1;
            compHdn = 0;
        }

        var closeYn = getSelectAttr("searchAppraisalCd", "closeYn");					// 마감여부
        var appGradingMethod = getSelectAttr("searchAppraisalCd", "appGradingMethod");	// P20007(평가채점방식) : P(점수), C(등급)
        var note1 = parseInt(getSelectAttr("searchAppraisalCd", "note1"), 10);			// [비고1 : 점수 Hidden]
        var note2 = parseInt(getSelectAttr("searchAppraisalCd", "note2"), 10);			// [비고2 : 등급 Hidden]
        var note3 = parseInt(getSelectAttr("searchAppraisalCd", "note3"), 10);			// [비고3 : 점수 Edit]
        var note4 = parseInt(getSelectAttr("searchAppraisalCd", "note4"), 10);			// [비고4 : 등급 Edit]

        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,AutoFitColWidth:'init|search|resize|rowtransaction'};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"No|No",			Type:"Seq",	        Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"선택|선택",			Type:"DummyCheck",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
            {Header:"성명|성명",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"사번|사번",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"호칭|호칭",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"alias",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"평가소속|평가소속",	Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"평가그룹|평가그룹",	Type:"Text",		Hidden:0,   Width:150,  Align:"Center", ColMerge:0, SaveName:"appGroupNm",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가그룹|평가그룹",	Type:"Text",		Hidden:1,   Width:100,  Align:"Left",   ColMerge:0, SaveName:"appGroupCd",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직책|직책",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"직위|직위",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"직급|직급",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"직무|직무",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

            /* 진행상태 */
            {Header:"진행상태|진행상태",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"lastStatusNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

            {Header:"본인평가\n완료여부|본인평가\n완료여부",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboSelfAppraisalYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"본인평가|업적점수",						Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboTAppSelfPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"본인평가|업적등급",						Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboTAppSelfClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"본인평가|역량점수",						Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compTAppSelfPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"본인평가|역량등급",						Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compTAppSelfClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
        ];

        /* 컬럼 추가 START */

        // 1차평가 관련 컬럼 추가
        initdata.Cols.push({Header:"1차평가|총점",			Type:"Float",	Hidden:1,	Width:50,	Align:"Center", ColMerge:0, SaveName:"app1stPoint",			KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,	InsertEdit:0,   EditLen:20 });
        initdata.Cols.push({Header:"1차평가|완료\n여부",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mbo1stAppraisalYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가|업적점수",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp1stPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가|업적등급",			Type:"Combo",	Hidden:(mboHdn | note2),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp1stClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가|업적순위",		    Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp1stRank",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가|업적순위",		    Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp1stRankTxt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });

        initdata.Cols.push({Header:"1차평가|업적의견",			Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"mboApp1stMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500, MultiLineText:1, Wrap:1 });
        initdata.Cols.push({Header:"1차평가|의견\n상세",		Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboApp1stMemoPop",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 });
        initdata.Cols.push({Header:"1차평가|역량점수",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp1stPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가|역량등급",			Type:"Combo",	Hidden:(compHdn | note2),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp1stClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가|역량순위",			Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp1stRank",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가|역량의견",			Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"compApp1stMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500, MultiLineText:1, Wrap:1 });
        initdata.Cols.push({Header:"1차평가|의견\n상세",		Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"compApp1stMemoPop",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 });

        // 2차평가 컬럼 추가
        if ($("#searchAppSeqCd", "#evaAprLayerFrm").val() == "2" || $("#searchAppSeqCd", "#evaAprLayerFrm").val() == "6") {
            initdata.Cols.push({Header:"2차평가|완료\n여부",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mbo2ndAppraisalYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"2차평가|업적점수",		Type:"Text",	Hidden:(mboHdn | note1),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp2ndPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"2차평가|업적등급",		Type:"Combo",	Hidden:(mboHdn | note2),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp2ndClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"2차평가|업적순위",		Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp2ndRank",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"2차평가|업적의견",		Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"mboApp2ndMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500, MultiLineText:1, Wrap:1 });
            initdata.Cols.push({Header:"2차평가|의견\n상세",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboApp2ndMemoPop",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 });
            initdata.Cols.push({Header:"2차평가|역량점수",		Type:"Text",	Hidden:(compHdn | note1),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp2ndPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"2차평가|역량등급",		Type:"Combo",	Hidden:(compHdn | note2),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp2ndClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"2차평가|역량순위",		Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp2ndRank",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"2차평가|역량의견",		Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"compApp2ndMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500, MultiLineText:1, Wrap:1 });
            initdata.Cols.push({Header:"2차평가|의견\n상세",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"compApp2ndMemoPop",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 });
        }

        // 3차 평가 컬럼 추가
        if ($("#searchAppSeqCd", "#evaAprLayerFrm").val() == "6") {
            // 평가 컬럼 추가
            initdata.Cols.push({Header:"3차평가|완료\n여부",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mbo3rdAppraisalYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"3차평가|업적점수",		Type:"Text",	Hidden:(mboHdn | note1),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp3rdPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"3차평가|업적등급",		Type:"Combo",	Hidden:(mboHdn | note2),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp3rdClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"3차평가|업적순위",		Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp3rdRank",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"3차평가|업적의견",		Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"mboApp3rdMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500, MultiLineText:1, Wrap:1 });
            initdata.Cols.push({Header:"3차평가|의견\n상세",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboApp3rdMemoPop",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 });
            initdata.Cols.push({Header:"3차평가|역량점수",		Type:"Text",	Hidden:(compHdn | note1),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp3rdPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"3차평가|역량등급",		Type:"Combo",	Hidden:(compHdn | note2),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp3rdClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"3차평가|역량순위",		Type:"Int",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compTApp3rdRank",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
            initdata.Cols.push({Header:"3차평가|역량의견",		Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"compApp3rdMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500, MultiLineText:1, Wrap:1 });
            initdata.Cols.push({Header:"3차평가|의견\n상세",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"compApp3rdMemoPop",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 });
        }

        // 기타 컬럼 추가
        initdata.Cols.push({Header:"1차평가업적총원",	Type:"Int",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboTApp1stRankTotCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"1차평가등급",	Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"app1stClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"2차평가등급",	Type:"Combo",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"app2ndClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"3차평가등급",	Type:"Combo",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"app3rdClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 });
        initdata.Cols.push({Header:"업적평가여부",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboTargetYn"});
        initdata.Cols.push({Header:"역량평가여부",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"compTargetYn"});
        initdata.Cols.push({Header:"평가ID",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"});
        initdata.Cols.push({Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"});
        initdata.Cols.push({Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSabun"});
        initdata.Cols.push({Header:"평가차수",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd"});
        initdata.Cols.push({Header:"진행상태코드",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"lastStatusCd"});
        /* END  컬럼 추가 */

        IBS_InitSheet(aprLayerSht1, initdata);aprLayerSht1.SetEditable(false);aprLayerSht1.SetVisible(true);aprLayerSht1.SetCountPosition(4);

        aprLayerSht1.SetDataAlternateBackColor(aprLayerSht1.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색
        aprLayerSht1.SetSheetHeight(400);
        aprLayerSht1.SetSheetWidth(780);
        sheetInit();

        evaAprLayerSheetResize();
        drawChart();
        doAction1('Search');

        // open history
        $('[data-snb]').on('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            var dataSnb = $(this).data('snb'),
                dataTg = $(this).data('target');

            if (dataSnb == 'menu') {
                $('[data-target="' + dataTg + '"]').addClass('active').siblings().removeClass('active');
                $(dataTg).addClass('active').siblings().removeClass('active');
            }
            if(dataTg === '.history-1') {
                showTargetTabs2();
            } else if(dataTg === '.history-2') {
                showIframe2("3");
            } else if(dataTg === '.history-3') {
                showIframe2("4");
            }

        });

        $('.folding').on('click', function (e) {
            $('[data-snb="menu"]').removeClass('active');
            $('[class^="history-"]').removeClass('active');
        });
    });

    function evaAprLayerSheetResize() {
        aprLayerSht1.SetSheetHeight(400);
        aprLayerSht1.SetSheetWidth(780);

        // 1차 평가의 경우 차트가 없기때문에 그 만큼 높이가 더 커져야 함
        if($("#searchAppSeqCd", "#evaAprLayerFrm").val() == "1")
            aprLayerSht1.SetSheetHeight(700);

    }

    function showIframe1(iframeIdx1) {
        $("#target1-"+iframeIdx1).show();
        $("[id^='target1-']:not(#target1-" + iframeIdx1 + ")").hide();
        switch (iframeIdx1) {
            case "1":
                // rsa 길이 제한으로 필요한 파라미터만 넘김
                var param = $("#evaAprLayerFrm").find(":input").not("#searchChartAppGroupCd, #mboClassCd, #compClassCd").serialize()
                $("#tab1-1").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboApr&"+param);
                setTabHeight($("#tab1-1").get(0))
                break;
            case "2":
                var param = $("#evaAprLayerFrm").find(":input").not("#searchChartAppGroupCd, #mboClassCd, #compClassCd").serialize();
                $("#tab1-2").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboCompApr&"+param);
                setTabHeight($("#tab1-2").get(0))
                break;
        }
    }

    function showIframe2(iframeIdx2) {
        $("#target2-"+iframeIdx2).show();
        $("[id^='target2-']:not(#target2-" + iframeIdx2 + ")").hide();
        switch (iframeIdx2) {
            case "1":
                var param = $("#evaAprLayerFrm").find(":input").not("#searchChartAppGroupCd, #mboClassCd, #compClassCd").serialize();
                param += '&editableYn=N'
                $("#tab2-1").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboReg&"+param);
                setTabHeight($("#tab2-1").get(0))
                break;
            case "2":
                var param = $("#evaAprLayerFrm").find(":input").not("#searchChartAppGroupCd, #mboClassCd, #compClassCd").serialize();
                param += '&editableYn=N'
                $("#tab2-2").attr("src", "${ctx}/EvaMain.do?cmd=viewEvaMboCompReg&"+param);
                setTabHeight($("#tab2-2").get(0))
                break;
            case "3":
                var param = $("#evaAprLayerFrm").find(":input").not("#searchChartAppGroupCd, #mboClassCd, #compClassCd").serialize();
                $("#tab2-3").attr("src", "${ctx}/EvaMain.do?cmd=viewReferIntvHst&"+param);
                setTabHeight($("#tab2-3").get(0))
                break;
            case "4":
                var param = $("#evaAprLayerFrm").find(":input").not("#searchChartAppGroupCd, #mboClassCd, #compClassCd").serialize();
                $("#tab2-4").attr("src", "${ctx}/EvaMain.do?cmd=viewReferGoalSta&"+param);
                setTabHeight($("#tab2-4").get(0))
                break;
        }
    }
    
    function setTabHeight(tabIframe) {
        tabIframe.addEventListener('load', function() {
            setTimeout(function () {
                let height = tabIframe.contentWindow.document.body.scrollHeight + 'px';
                tabIframe.style.height = height;
            }, 1000);
        });
    }

    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                // sheet 조회
                aprLayerSht1.DoSearch( "${ctx}/EvaMain.do?cmd=getApp1st2ndList1", $("#evaAprLayerFrm").serialize() );
                break;
            case "Save":
                var appGradingMethod = getSelectAttr("searchAppraisalCd", "appGradingMethod");	// P20007(평가채점방식) : P(점수), C(등급)
                IBS_SaveName(document.evaAprLayerFrm,aprLayerSht1);
                aprLayerSht1.DoSave( "${ctx}/EvaMain.do?cmd=saveApp1st2ndClassCd350", $("#evaAprLayerFrm").serialize() + "&appGradingMethod=" + appGradingMethod);
                break;
            case "SaveGrade":
                if( !confirm("등급을 저장하시겠습니까?")) return;
                //저장
                var data = ajaxCall("${ctx}/EvaMain.do?cmd=saveEvaAprGradeCd",$("#evaAprLayerFrm").serialize(),false);
                if(data.Result.Message != '') {
                    alert(data.Result.Message);
                }
                break;
            case "Clear":
                aprLayerSht1.RemoveAll();
                break;
            case "Down2Excel":
                var downcol = makeHiddenSkipCol(aprLayerSht1);
                var param = {DownCols:downcol, SheetDesign:1, Merge:1};
                aprLayerSht1.Down2Excel(param);
                break;
            case "SortName":
                var sort = $("#btnSortName").attr("sort") === 'asc' ? 'desc' : 'asc' ;
                aprLayerSht1.ColumnSort("name", sort);
                $("#btnSortName").attr("sort", sort);
                setTimeout(function(){ makeCard() }, 300);
                break;
            case "SortGroup":
                var sort = $("#btnSortGroup").attr("sort") === 'asc' ? 'desc' : 'asc' ;
                aprLayerSht1.ColumnSort("appGroupNm", sort);
                $("#btnSortGroup").attr("sort", sort);
                setTimeout(function(){ makeCard() }, 300);
                break;
            case "SortStatus":
                var sort = $("#btnSortStatus").attr("sort") === 'asc' ? 'desc' : 'asc' ;
                aprLayerSht1.ColumnSort("mboSelfAppraisalYn|mbo1stAppraisalYn|mbo2ndAppraisalYn|mbo3rdAppraisalYn", sort);
                $("#btnSortStatus").attr("sort", sort);
                setTimeout(function(){ makeCard() }, 300);
                break;
            case "ChkApp": //평가완료
                if (!isPopup()) {return;}

                //공통 체크
                if( !commCheck() ) return;
                //sheet1 체크 - MBO
                if (mboTargetYn == "Y") {
                    if( !checkTab1() ) {
                        return;
                    }
                }
                //sheet2 체크 - 역량
                if (compTargetYn == "Y") {
                    if( !checkTab2() ) {
                        return;
                    }
                }

                var args = new Array();

                args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
                args["searchEvaSabun"] = $("#searchEvaSabun").val();
                args["searchAppOrgCd"] = $("#searchAppOrgCd").val();
                args["searchAppStepCd"] = $("#searchAppStepCd").val();
                args["searchAppSeqCd"] = $("#searchAppSeqCd").val();
                args["searchAppSabun"] = $("#searchAppSabun").val();
                args["searchAppYn"] = "Y";
                args["lastAppSeqCd"] = $("#lastAppSeqCd").val();

                var layer = new window.top.document.LayerModal({
                    id : 'appSelfReturnCommentLayer'
                    , url : "${ctx}/EvaMain.do?cmd=viewAppSelfReturnComment"
                    , parameters: args
                    , width : 500
                    , height : 320
                    , top: '50vh'
                    , left: '50vw'
                    , title : "의견등록"
                    , trigger :[
                        {
                            name : 'appSelfReturnCommentLayerTrigger'
                            , callback : function(rv){
                                if ( rv["Code"] != "-1" )	{
                                    $("#searchAppYn").val("Y");
                                    setTimeout(function(){
                                        var data = ajaxCall("${ctx}/EvaMain.do?cmd=prcAppSelf2",$("#evaAprLayerFrm").serialize(),false);

                                        if(data.Result.Code == null) {
                                            alert( "평가확정 처리되었습니다.");
                                            sSabun = $("#searchEvaSabun").val();
                                            doAction1('Search');
                                        } else {
                                            alert(data.Result.Message);
                                        }

                                    }, 300);
                                }
                            }
                        }
                    ]
                });
                layer.show();

                break;

            case "ChkReturn": //반려
                if(!isPopup()) {return;}

                if( !commCheck() ) return;

                var url = "${ctx}/EvaMain.do?cmd=viewAppSelfReturnComment";
                var args = new Array();

                args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
                args["searchEvaSabun"] = $("#searchEvaSabun").val();
                args["searchAppOrgCd"] = $("#searchAppOrgCd").val();
                args["searchAppStepCd"] = $("#searchAppStepCd").val();
                args["searchAppSeqCd"] = $("#searchAppSeqCd").val();
                args["searchAppSabun"] = $("#searchAppSabun").val();
                args["searchAppYn"] = "N";

                var layer = new window.top.document.LayerModal({
                    id : 'appSelfReturnCommentLayer'
                    , url : "${ctx}/EvaMain.do?cmd=viewAppSelfReturnComment"
                    , parameters: args
                    , width : 500
                    , height : 320
                    , top: '50vh'
                    , left: '50vw'
                    , title : "의견등록"
                    , trigger :[
                        {
                            name : 'appSelfReturnCommentLayerTrigger'
                            , callback : function(rv){
                                if ( rv["Code"] != "-1" )	{
                                    $("#searchAppYn").val("N");

                                    setTimeout(function(){
                                        var data = ajaxCall("${ctx}/EvaMain.do?cmd=saveAppSelfReturnStatus",$("#evaAprLayerFrm").serialize(),false);

                                        if(data.Result.Code == null) {
                                            alert( "반려 처리되었습니다.");
                                            sSabun = $("#searchEvaSabun").val();
                                            doAction1('Search');
                                        } else {
                                            alert(data.Result.Message);
                                        }

                                    }, 300);

                                }
                            }
                        }
                    ]
                });
                layer.show();
                
                break;
        }
    }

    //공통 체크
    function commCheck(){
        if($("#searchAppraisalCd", "#evaAprLayerFrm").val() == "") {
            alert("평가명이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppOrgCd", "#evaAprLayerFrm").val() == ""){
            alert("평가소속이 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppSabun", "#evaAprLayerFrm").val() == "") {
            alert("평가자가 존재하지 않습니다.");
            return false;
        }

        if($("#searchEvaSabun", "#evaAprLayerFrm").val() == "") {
            alert("평가 대상자가 존재하지 않습니다.");
            return false;
        }

        if($("#searchAppYn", "#evaAprLayerFrm").val() == "") {
            alert("이미 평가완료된 상태입니다.");
            return false;
        }

        return true;
    }

    //Tab1 Check
    function checkTab1(){
        let item = $('#tab1-1').get(0).contentWindow.checkRequiredCol();

        if(item !== null) {
            alert("[ 업적 ] 탭 평가 항목의 "+item+"을 모두 입력하여 주세요.");
            return false;
        }

        return true;
    }

    //Tab2 Check
    function checkTab2(){
        let item = $('#tab1-2').get(0).contentWindow.checkRequiredCol();

        if(item !== null) {
            alert("[ 역량 ] 탭 평가 항목의 "+item+"을 모두 입력하여 주세요.");
            return false;
        }

        return true;
    }

    // 조회 후 에러 메시지
    function aprLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }

            const data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getAppraisalCdListSeqMbo3&" + $("#evaAprLayerFrm").serialize(), false).codeList[0]
            var closeYn = data.closeYn;					    // 마감여부
            var appGradingMethod = data.appGradingMethod;	// P20007(평가채점방식) : P(점수), C(등급)
            var note1 = parseInt(data.note1, 10);			// [비고1 : 점수 Hidden]
            var note2 = parseInt(data.note2, 10);			// [비고2 : 등급 Hidden]
            var note3 = parseInt(data.note3, 10);			// [비고3 : 점수 Edit]
            var note4 = parseInt(data.note4, 10);			// [비고4 : 등급 Edit]

            // P10018(평가진행상태(목표))
            // 11	미제출
            // 21	승인요청
            // 23	1차반려
            // 25	1차승인
            // 31	2차승인요청
            // 33	2차반려
            // 35	2차승인
            // 41	3차승인요청
            // 43	3차반려
            // 99	최종승인

            var compEvalFlag = false;
            for(var i = aprLayerSht1.HeaderRows(); i < aprLayerSht1.RowCount()+aprLayerSht1.HeaderRows() ; i++) {
                var statusCd = aprLayerSht1.GetCellValue(i, "lastStatusCd");

                if( statusCd == "99" ){  //최종승인
                    aprLayerSht1.SetCellEditable(i, "chk", 1);
                }

                var mboSelfAppraisalYn = aprLayerSht1.GetCellValue(i, "mboSelfAppraisalYn");	// 본인평가완료여부
                var mbo1stAppraisalYn  = aprLayerSht1.GetCellValue(i, "mbo1stAppraisalYn");	// 1차평가완료여부
                var mbo2ndAppraisalYn  = aprLayerSht1.GetCellValue(i, "mbo2ndAppraisalYn");	// 2차평가완료여부
                var mbo3rdAppraisalYn  = aprLayerSht1.GetCellValue(i, "mbo3rdAppraisalYn");	// 3차평가완료여부

                var mboTargetYn  = aprLayerSht1.GetCellValue(i, "mboTargetYn");		// 업적평가여부
                var compTargetYn = aprLayerSht1.GetCellValue(i, "compTargetYn");		// 역량평가여부

                var mboEditFlag  = 0;
                var compEditFlag = 0;

                // 1차평가인 경우
                if ($("#searchAppSeqCd", "#evaAprLayerFrm").val() == "1") {
                    if (compTargetYn == "Y") {
                        compEvalFlag = true;
                    }

                    // 본인평가가 완료된 상태에서 1차평가가 완료되지 않은 상태인 경우 1차 평가등급 설정 항목 편집 허용
                    if (mboSelfAppraisalYn == "Y" && mbo1stAppraisalYn == "N" && statusCd != "99" && (statusCd == "21" || statusCd == "33")) {
                        // 업적평가여부가 허용된 경우
                        if (mboTargetYn == "Y") {
                            mboEditFlag = 1;
                        }
                        // 역량평가여부가 허용된 경우
                        if (compTargetYn == "Y") {
                            compEditFlag = 1;
                        }
                    }

                    aprLayerSht1.SetCellEditable(i, "mboTApp1stPoint", mboEditFlag & note3);
                    aprLayerSht1.SetCellEditable(i, "mboTApp1stClassCd", mboEditFlag & note4);
                    aprLayerSht1.SetCellEditable(i, "mboApp1stMemo", mboEditFlag);
                    aprLayerSht1.SetCellEditable(i, "compTApp1stPoint", compEditFlag & note3);
                    aprLayerSht1.SetCellEditable(i, "compTApp1stClassCd", compEditFlag & note4);
                    aprLayerSht1.SetCellEditable(i, "compApp1stMemo", compEditFlag);
                    // 1차 업적평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "mboTApp1stClassCd",  {"ComboText" : classCdList["1"][0] , "ComboCode" : classCdList["1"][1]});
                    // 1차 역량평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "compTApp1stClassCd", {"ComboText" : classCdList["1"][0] , "ComboCode" : classCdList["1"][1]});
                }

                // 2차평가인 경우
                if ($("#searchAppSeqCd", "#evaAprLayerFrm").val() == "2") {
                    // 최종승인 이전 단계에서 1차평가가 완료된 경우 2차평가등급 항목 편집 허가
                    if (mbo1stAppraisalYn == "Y" && mbo2ndAppraisalYn == "N" && statusCd != "99" && (statusCd == "25" || statusCd == "31" || statusCd == "43")) {
                        // 업적평가여부가 허용된 경우
                        if (mboTargetYn == "Y") {
                            mboEditFlag = 1;
                        }
                        // 역량평가여부가 허용된 경우
                        if (compTargetYn == "Y") {
                            compEditFlag = 1;
                        }
                    }

                    aprLayerSht1.SetCellEditable(i, "mboTApp2ndPoint", mboEditFlag & note3);
                    aprLayerSht1.SetCellEditable(i, "mboTApp2ndClassCd", mboEditFlag & note4);
                    aprLayerSht1.SetCellEditable(i, "mboApp2ndMemo", mboEditFlag);
                    aprLayerSht1.SetCellEditable(i, "compTApp2ndPoint", compEditFlag & note3);
                    aprLayerSht1.SetCellEditable(i, "compTApp2ndClassCd", compEditFlag & note4);
                    aprLayerSht1.SetCellEditable(i, "compApp2ndMemo", compEditFlag);


                    // 1차 업적평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "mboTApp1stClassCd",  {"ComboText" : classCdList["1"][0], "ComboCode" : classCdList["1"][1]});
                    // 2차 업적평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "mboTApp2ndClassCd",  {"ComboText" : classCdList["2"][0], "ComboCode" : classCdList["2"][1]});

                    // 1차 역량평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "compTApp1stClassCd", {"ComboText" : classCdList["1"][0], "ComboCode" : classCdList["1"][1]});
                    // 2차 역량평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "compTApp2ndClassCd", {"ComboText" : classCdList["2"][0], "ComboCode" : classCdList["2"][1]});
                }

                // 3차평가인 경우
                if ($("#searchAppSeqCd", "#evaAprLayerFrm").val() == "6") {
                    // 최종승인 이전 단계에서 1차평가가 완료된 경우 2차평가등급 항목 편집 허가
                    if (mbo2ndAppraisalYn == "Y" && mbo3rdAppraisalYn == "N" && statusCd != "99" && (statusCd == "35" || statusCd == "41")) {
                        // 업적평가여부가 허용된 경우
                        if (mboTargetYn == "Y") {
                            mboEditFlag = 1;
                        }
                        // 역량평가여부가 허용된 경우
                        if (compTargetYn == "Y") {
                            compEditFlag = 1;
                        }
                    }

                    aprLayerSht1.SetCellEditable(i, "mboTApp3rdPoint", mboEditFlag & note3);
                    aprLayerSht1.SetCellEditable(i, "mboTApp3rdClassCd", mboEditFlag & note4);
                    aprLayerSht1.SetCellEditable(i, "mboApp3rdMemo", mboEditFlag);
                    aprLayerSht1.SetCellEditable(i, "compTApp3rdPoint", compEditFlag & note3);
                    aprLayerSht1.SetCellEditable(i, "compTApp3rdClassCd", compEditFlag & note4);
                    aprLayerSht1.SetCellEditable(i, "compApp3rdMemo", compEditFlag);

                    // 1차 업적평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "mboTApp1stClassCd", {"ComboText" : classCdList["1"][0] , "ComboCode" : classCdList["1"][1]});
                    // 2차 업적평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "mboTApp2ndClassCd", {"ComboText" : classCdList["2"][0] , "ComboCode" : classCdList["2"][1]});
                    // 3차 업적평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "mboTApp3rdClassCd", {"ComboText" : classCdList["6"][0] , "ComboCode" : classCdList["6"][1]});

                    // 1차 역량평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "compTApp1stClassCd", {"ComboText" : classCdList["1"][0] , "ComboCode" : classCdList["1"][1]});
                    // 2차 역량평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "compTApp2ndClassCd", {"ComboText" : classCdList["2"][0] , "ComboCode" : classCdList["2"][1]});
                    // 3차 역량평가등급 콤보 설정
                    aprLayerSht1.CellComboItem(i, "compTApp3rdClassCd", {"ComboText" : classCdList["6"][0] , "ComboCode" : classCdList["6"][1]});
                }
            }

            makeCard() // 좌측 평가대상자 카드 생성

            evaAprLayerSheetResize();
        } catch (ex) {
            alert("AprLayerSht1 OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function aprLayerSht1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            doAction1("Search");
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
    
    // 선택한 카드의 CSS 변경
    function activeCard(obj) {
        if ($(obj).hasClass('active')) {
            // 카드 전체 미선택인 경우
            $('div[name="aprCard"]').removeClass('active');
            // 평가 전체 현황 활성화 및 평가 창 비활성화
            $('#evaAprProgress').show();
            $('#evaAprDet').hide();
            $('#evaAprHistory').hide();
            $('.folding').click();
        } else {
            // 다른 카드를 하나라도 선택한 경우
            $('div[name="aprCard"]').removeClass('active');
            $(obj).addClass('active')
            aprLayerSht1.SetSelectRow($(obj).attr('row'));
            // 평가 전체 현황 비활성화 및 평가 창 활성화
            $('#evaAprProgress').hide();
            $('#evaAprDet').show();
            $('#evaAprHistory').show();
        }
    }

    function makeCard() {
        /* 좌측 평가대상자 카드 생성 */
        var sSabunRow = '';
        var maxCnt = 0, curCnt = 0;
        var groupCd = '', html = '';
        for(var i = aprLayerSht1.HeaderRows(); i < aprLayerSht1.RowCount()+aprLayerSht1.HeaderRows() ; i++) {
            let appGroupCd = aprLayerSht1.GetCellValue(i, "appGroupCd");
            if(i === aprLayerSht1.RowCount()+aprLayerSht1.HeaderRows()-1) {
                html += '</div>';
                html = curCnt > 0 ? html.replace(`<span id="${'${groupCd}'}CurCnt" className="current">0</span>`, `<span id="${'${groupCd}'}CurCnt" className="current">${'${curCnt}'}</span>`) : html;
                html = maxCnt > 0 ? html.replace(`<span id="${'${groupCd}'}MaxCnt" class="total">/0</span>`, `<span id="${'${groupCd}'}MaxCnt" className="total">/${'${maxCnt}'}</span>`) : html;
            }

            if(groupCd !== appGroupCd) {
                if(i !== aprLayerSht1.HeaderRows()) {
                    html += '</div>';
                    html = curCnt > 0 ? html.replace(`<span id="${'${groupCd}'}CurCnt" class="current">0</span>`, `<span id="${'${groupCd}'}CurCnt" class="current">${'${curCnt}'}</span>`) : html;
                    html = maxCnt > 0 ? html.replace(`<span id="${'${groupCd}'}MaxCnt" class="total">/0</span>`, `<span id="${'${groupCd}'}MaxCnt" class="total">/${'${maxCnt}'}</span>`) : html;
                }

                let appGroupNm = aprLayerSht1.GetCellValue(i, "appGroupNm");
                html += `
                            <div class="d-flex">
                                <h4 class="h4 mr-1 d-inline-block">${'${appGroupNm}'}</h4>
                                <div class="caption-sm d-inline-block">
                                    <span id="${'${appGroupCd}'}CurCnt" class="current">0</span><span id="${'${appGroupCd}'}MaxCnt" class="total">/0</span>
                                </div>
                            </div>
                            <div class="box p-0 flex-column mt-2">
                            `;

                // 초기화
                groupCd = appGroupCd;
                maxCnt = 0;
                curCnt = 0;
            }

            var statusCd = aprLayerSht1.GetCellValue(i, "statusCd");
            let sabun = aprLayerSht1.GetCellValue(i, "sabun");
            // 선택한 사번으로 자동 조회하기 위한 sSabunRow 값 구하기
            sSabunRow = sSabun === sabun ? i : sSabunRow;

            let datetime = new Date().getTime();
            let imageUrl = '/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + aprLayerSht1.GetCellValue(i, "sabun") + '&t=' + datetime;
            let name = aprLayerSht1.GetCellValue(i, "name");
            let appOrgNm = aprLayerSht1.GetCellValue(i, "appOrgNm");
            let appOrgCd = aprLayerSht1.GetCellValue(i, "appOrgCd");
            let jikweeNm = aprLayerSht1.GetCellValue(i, "jikweeNm");
            let jobNm = aprLayerSht1.GetCellValue(i, "jobNm");

            let mboSelfAppraisalYn = aprLayerSht1.GetCellValue(i, "mboSelfAppraisalYn");
            let mbo1stAppraisalYn = aprLayerSht1.GetCellValue(i, "mbo1stAppraisalYn");
            let mbo2ndAppraisalYn = aprLayerSht1.GetCellValue(i, "mbo2ndAppraisalYn");
            let mbo3rdAppraisalYn = aprLayerSht1.GetCellValue(i, "mbo3rdAppraisalYn");
            let appYn = 'N';
            let preAppYn = 'N';

            if($("#searchAppSeqCd", "#evaAprLayerFrm").val() === '1') {
                // 1차 평가
                appYn = mbo1stAppraisalYn;
                if(mboSelfAppraisalYn === 'Y') preAppYn = 'Y'
                else preAppYn = 'N';
            } else if ($("#searchAppSeqCd", "#evaAprLayerFrm").val() === '2') {
                // 2차 평가
                appYn = mbo2ndAppraisalYn;
                if(mboSelfAppraisalYn === 'Y' && mbo1stAppraisalYn === 'Y') preAppYn = 'Y'
                else preAppYn = 'N';
            } else if ($("#searchAppSeqCd", "#evaAprLayerFrm").val() === '6') {
                // 6차 평가
                appYn = mbo3rdAppraisalYn;
                if(mboSelfAppraisalYn === 'Y' && mbo1stAppraisalYn === 'Y' && mbo2ndAppraisalYn === 'Y') preAppYn = 'Y'
                else preAppYn = 'N';
            }

            if(appYn === 'Y') curCnt++;

            let statusClass = '';
            if(preAppYn === 'N') {
                // 이전 평가 미평가
                statusClass = 'evaluation'
            } else if (appYn === 'Y') {
                // 해당 차수 평가 완료
                statusClass = 'evaluation done'
            } else {
                // 해당 차수 평가 미완료
                statusClass = 'evaluation pending'
            }

            html += `<div id="aprCard${'${sabun}'}" name="aprCard" row=${'${i}'} class="box box-border pointer" onclick="activeCard(this); setAppSabunList('${'${sabun}'}', '${'${appOrgCd}'}')">
                            <p class="thumb mr-0 align-self-start">
                                <img src="${'${imageUrl}'}">
                            </p>
                            <div class="d-flex flex-column">
                                <div class="d-inline-block">
                                    <span class="name">${'${name}'}</span>
                                    <span class="caption-sm text-boulder">${'${jikweeNm}'}</span>
                                </div>
                                <p class="caption-sm text-boulder pt-1 mb-0">${'${appOrgNm}'}</p>
                                <p class="caption-sm text-boulder pt-1 mb-0">${'${jobNm}'}</p>
                                <p class="${'${statusClass}'} visible pt-1 mb-0"><i class="mdi-ico mr-1"></i></p>
                            </div>
                        </div>`

        }
        $("#aprListWrap").html(html);
        /* 좌측 평가대상자 카드 생성 끝 */
        if(sSabunRow !== '') {
            activeCard($("#aprCard"+sSabun).get(0))
            setAppSabunList(sSabun, $("#searchAppOrgCd").val());
        }
    }
</script>

<%-- 평가디테일용 스크립트--%>
<script>
    var mboTargetYn = "";
    var compTargetYn = "";
    var appraisalYn = "";
    var preAppraisalYn = "";

    // 평가자 정보 세팅
    function setAppSabunList(sabun, appOrgCd) {
        $("#searchEvaSabun").val(sabun);
        $("#searchAppOrgCd").val(appOrgCd);
        const data = ajaxCall('/EvaMain.do?cmd=getAppSabunList', $("#evaAprLayerFrm").serialize(), false).DATA;
        let preAppYn = 'N';
        preAppraisalYn = 'N';

        let mboClassCd = '';
        let compClassCd = '';

        if(data != null && data !== 'undefined') {
            let html = '';
            data.forEach(function(item){
                mboTargetYn = item.mboTargetYn;
                compTargetYn = item.compTargetYn;
                appraisalYn = $("#searchAppSeqCd").val() === item.appSeqCd ? item.appraisalYn : appraisalYn;
                preAppraisalYn = $("#searchAppSeqCd").val() === item.appSeqCd ? preAppYn : preAppraisalYn;

                $("#aprTitle").text(item.title);
                $("#aprAppPeriod").text(item.appPeriod);
                $("#lastAppSeqCd").val(item.lastAppSeqCd);

                let isActive = $("#searchAppSeqCd").val() === item.appSeqCd ? 'active' : '';
                let statusNm = '';

                if (item.appraisalYn === 'Y') {
                    // 해당 차수 평가 완료
                    statusNm = 'evaluation done'
                } else if(preAppYn === 'N') {
                    // 이전 평가 미평가
                    statusNm = 'evaluation'
                } else {
                    // 해당 차수 평가 미완료
                    statusNm = 'evaluation pending'
                }

                preAppYn = item.appraisalYn;
                let mboGrade = '';
                let compGrade = '';
                let mboGradeHis = '';
                let compGradeHis = '';

                // 이전차수 평가 등급 보여주기
                let gradeHtml = ''
                if(item.appSeqCd == '1') {
                    mboGrade = aprLayerSht1.GetCellText(aprLayerSht1.GetSelectRow(), 'mboTApp1stClassCd');
                    compGrade = aprLayerSht1.GetCellText(aprLayerSht1.GetSelectRow(), 'compTApp1stClassCd');
                    if($("#searchAppSeqCd").val() == item.appSeqCd) {
                        mboClassCd = aprLayerSht1.GetCellValue(aprLayerSht1.GetSelectRow(), 'mboTApp1stClassCd');
                        compClassCd = aprLayerSht1.GetCellValue(aprLayerSht1.GetSelectRow(), 'compTApp1stClassCd');
                    }
                } else if (item.appSeqCd == '2') {
                    mboGrade = aprLayerSht1.GetCellText(aprLayerSht1.GetSelectRow(), 'mboTApp2ndClassCd');
                    compGrade = aprLayerSht1.GetCellText(aprLayerSht1.GetSelectRow(), 'compTApp2ndClassCd');

                    if($("#searchAppSeqCd").val() == item.appSeqCd) {
                        mboClassCd = aprLayerSht1.GetCellValue(aprLayerSht1.GetSelectRow(), 'mboTApp2ndClassCd');
                        compClassCd = aprLayerSht1.GetCellValue(aprLayerSht1.GetSelectRow(), 'compTApp2ndClassCd');
                    }
                } else if (item.appSeqCd == '6') {
                    mboGrade = aprLayerSht1.GetCellText(aprLayerSht1.GetSelectRow(), 'mboTApp3rdClassCd');
                    compGrade = aprLayerSht1.GetCellText(aprLayerSht1.GetSelectRow(), 'compTApp3rdClassCd');

                    if($("#searchAppSeqCd").val() == item.appSeqCd) {
                        mboClassCd = aprLayerSht1.GetCellValue(aprLayerSht1.GetSelectRow(), 'mboTApp3rdClassCd');
                        compClassCd = aprLayerSht1.GetCellValue(aprLayerSht1.GetSelectRow(), 'compTApp3rdClassCd');
                    }
                }

                if((Number($("#searchAppSeqCd").val()) >= Number(item.appSeqCd) && item.appraisalYn === 'Y')) {
                    if(mboGrade != '')
                        mboGradeHis = `<span class="mr-2">업적</span><span class="ranked">${'${mboGrade}'}</span>`

                    if(compGrade != '')
                        compGradeHis = `<span class="ml-4 mr-2">역량</span><span class="ranked">${'${compGrade}'}</span>`


                    gradeHtml = `<div class="grade-wrap">
                                    ${'${mboGradeHis}'}
                                    ${'${compGradeHis}'}
                                </div>`
                } else if ($("#searchAppSeqCd").val() == item.appSeqCd){
                    let mboGradeBox = ''
                    let compGradeBox = ''

                    if(mboTargetYn === 'Y') {
                        mboGradeBox = `<p class="mb-1">
                                            <span class="mr-2">업적</span>
                                            <select name="mboClassCdList" id="mboClassCdList" class="h4 opensans-bold text-blue border1"></select>
                                       </p>`
                    }

                    if(compTargetYn === 'Y') {
                        compGradeBox = `<p class="mb-1">
                                            <span class="mr-2">역량</span>
                                            <select name="compClassCdList" id="compClassCdList" class="h4 opensans-bold text-blue border1"></select>
                                       </p>`
                    }

                    // 등급선택 콤보박스 추가
                    gradeHtml = `<div class="grade-wrap d-flex flex-row" style="gap: 1rem">
                                    <div class="grade-wrap d-flex flex-column mt-0 mb-0">
                                        ${'${mboGradeBox}'}
                                        ${'${compGradeBox}'}
                                    </div>
                                    <div class="btns">
                                        <a href="javascript:doAction1('SaveGrade')" id="btnSaveGrade" class="btn filled">저장</a>
                                    </div>
                                </div>`
                }

                html += `
                        <li class="box box-border flex-column ${'${isActive}'}">
                            <div class="cate">
                                <p class="badge gray">${'${item.appSeqNm}'}</p>
                                <p class="${'${statusNm}'}"><i class="mdi-ico mr-1"></i></p>
                            </div>
                            <div class="d-inline-block">
                                <span class="name">${'${item.appSabunName}'}</span>
                                <span class="caption-sm text-boulder">${'${item.appSabunJikweeNm}'}</span>
                            </div>
                            <p class="caption-sm text-boulder pt-1">${'${item.appSabunOrgNm}'}</p>
                            ${'${gradeHtml}'}
                        </li>
                        `;
            });
            $("#aprAppSabunListWrap").html(html);
            $("#searchAppYn").val(appraisalYn);

            // 등급 콤보박스 항목 설정
            $("#mboClassCdList, #compClassCdList").html(classCdList[$("#searchAppSeqCd").val()][2]);
            $("#mboClassCdList").bind("change", function(){
                $("#mboClassCd").val($("#mboClassCdList").val())
            });
            $("#compClassCdList").bind("change", function(){
                $("#compClassCd").val($("#compClassCdList").val())
            });
            $("#mboClassCdList").val(mboClassCd);
            $("#compClassCdList").val(compClassCd);
        }

        // 권한 없는 항목들 hide 처리
        setHideItems();

        // 이전차수 평가가 모두 완료된 경우에만 상세 평가 화면 출력.
        if($('div[name="aprCard"]').hasClass('active')) {
            if(preAppraisalYn !== 'Y') {
                $("#searchEvaSabun").val('');
                alert('이전 차수 평가가 완료되지 않았습니다.');
                $("#tab1-1").hide()
                $("#tab1-2").hide()
                $("#tab2-1").hide()
                $("#tab2-2").hide()
                $("#tab2-3").hide()
                $("#btnPrint").hide();
                $(".grade-wrap").addClass('d-lg-none');
            } else {
                $("#tab1-1").show()
                $("#tab1-2").show()
                $("#tab2-1").show()
                $("#tab2-2").show()
                $("#tab2-3").show()
                $("#btnPrint").show();
                $(".grade-wrap").removeClass('d-lg-none');
            }
        }
    }

    function showTargetTabs1() {
        // 평가대상인 탭만 보이도록설정
        if(mboTargetYn === 'Y') {
            $("#mboTab").show();
            $("#target1-1").show();
            $("#mboTab").addClass("active");
            $("#target1-1").addClass("show active");
            showIframe1('1');
        } else {
            $("#mboTab").hide();
            $("#target1-1").hide();
            $("#mboTab").removeClass("active");
            $("#target1-1").removeClass("show active");
        }

        if(compTargetYn === 'Y') {
            showIframe1('2');
            $("#compTab").show();
            $("#target1-2").show();

            if( mboTargetYn === 'N') {
                $("#compTab").addClass("active");
                $("#target1-2").addClass("show active");
            } else {
                $("#compTab").removeClass("active");
                $("#target1-2").removeClass("show active");
            }
        } else {
            $("#compTab").hide();
            $("#target1-2").hide();
            $("#compTab").removeClass("active");
            $("#target1-2").removeClass("show active");
        }

        // 활성화 되어있는 탭만 보여주기
        $("[id^='target1-'].show.active").show();
        $("[id^='target1-']:not(.show):not(.active)").hide();
    }

    function showTargetTabs2() {

        if($(".history-1").hasClass("active")) {

            // 평가대상인 탭만 보이도록설정
            if(mboTargetYn === 'Y') {
                $("#goalMboTab").show();
                $("#target2-1").show();
                $("#goalMboTab").addClass("active");
                $("#target2-1").addClass("show active");
                showIframe2('1');
            } else {
                $("#goalMboTab").hide();
                $("#target2-1").hide();
                $("#goalMboTab").removeClass("active");
                $("#target2-1").removeClass("show active");
            }

            if(compTargetYn === 'Y') {
                showIframe2('2');
                $("#goalCompTab").show();
                $("#target2-2").show();

                if( mboTargetYn === 'N') {
                    $("#goalCompTab").addClass("active");
                    $("#target2-2").addClass("show active");
                } else {
                    $("#goalCompTab").removeClass("active");
                    $("#target2-2").removeClass("show active");
                }
            } else {
                $("#goalCompTab").hide();
                $("#target2-2").hide();
                $("#goalCompTab").removeClass("active");
                $("#target2-2").removeClass("show active");
            }
        } else if ($(".history-2").hasClass("active")) {
            showIframe2("3");
        } else if ($(".history-3").hasClass("active")) {
            showIframe2("4");
        }

        // 활성화 되어있는 탭만 보여주기
        $("[id^='target2-'].show.active").show();
        $("[id^='target2-']:not(.show):not(.active)").hide();
    }

    // 권한 없는 항목들 hide 처리
    function setHideItems() {
        showTargetTabs1();
        showTargetTabs2();
        // 평가완료 버튼
        if(appraisalYn === 'Y') {
            $("#appBtns").hide();
        } else {
            if(preAppraisalYn === 'Y') $("#appBtns").show();
            else $("#appBtns").hide();
        }
    }

    function drawChart() {
        $("#rangeChart").empty()
        $("#barchart").empty()

        // 평가그룹이 선택되지 않은 경우 차트 그리기X
        if($("#searchAppGroupCd").val() == '') return;

        var gradeData = ajaxCall("${ctx}/EvaMain.do?cmd=getAppGradeRateStdClassItemList",$("#evaAprLayerFrm").serialize(),false).DATA;
        if(gradeData != null && gradeData !== 'undefined') {
            var chartData1 = new Array(); // 차트1 데이터
            var chartData2 = new Array(); // 차트2 데이터
            var chartCategory = new Array(); // 차트2 카테고리
            var data = null;
            // 배분계획 및 결과 조회
            if($("#searchAppSeqCd").val() == '2') {
                // 2차
                data = ajaxCall("${ctx}/EvaMain.do?cmd=getAppGradeSeqCd2List", $("#evaAprLayerFrm").serialize(), false ).DATA;
            } else if($("#searchAppSeqCd").val() == '6') {
                // 3차
                data = ajaxCall("${ctx}/EvaMain.do?cmd=getAppGradeSeqCd6List", $("#evaAprLayerFrm").serialize(), false ).DATA;
            }

            if(data != null && data !== 'undefined') {
                data.forEach((item, idx) => {
                    const planMin = item.minCntArrPlan.split('@');
                    const planMax = item.maxCntArrPlan.split('@');
                    chartData2 = item.cntArrExec.split('@');

                    planMin.forEach((plan, idx) => {
                        chartCategory.push(gradeData[idx].appClassNm);
                        chartData1.push({x: gradeData[idx].appClassNm, y: [plan, planMax[idx]]})
                    })
                })
            }

            // 최대 구분자 6
            const maxVal1 = Math.min(Math.max(...chartData1.flatMap(item => item.y)), 6);
            var options1 = {
                series: [
                    {
                        data: chartData1
                    }
                ],
                chart: {
                    type: 'rangeBar',
                    zoom: {
                        enabled: false
                    }
                },
                plotOptions: {
                    bar: {
                        isDumbbell: true,
                        columnWidth: 3,
                        dumbbellColors: [['#008FFB', '#00E396']],
                    }
                },
                legend: {
                    show: true,
                    showForSingleSeries: true,
                    position: 'top',
                    horizontalAlign: 'left',
                    customLegendItems: ['최소', '최대']
                },
                fill: {
                    type: 'gradient',
                    gradient: {
                        type: 'vertical',
                        gradientToColors: ['#00E396'],
                        inverseColors: true,
                        stops: [0, 100]
                    }
                },
                grid: {
                    xaxis: {
                        lines: {
                            show: true
                        }
                    },
                    yaxis: {
                        lines: {
                            show: false
                        }
                    }
                },
                xaxis: {
                    tickPlacement: 'on'
                },
                yaxis: {
                    tickAmount: maxVal1, // y축 눈금 수 설정
                    labels: {
                        formatter: function(val) {
                            return val + "명";
                        }
                    }
                },
                tooltip: {
                    y: {
                        formatter: function(val) {
                            return val + "명";
                        }
                    }
                }
            };

            var chart1 = new ApexCharts(document.querySelector("#rangeChart"), options1);
            chart1.render();

            // chart2
            const maxVal2 = Math.min(Math.max(Math.max(...chartData2), 1), 6);
            var options2 = {
                series: [{
                    data: chartData2
                }],
                chart: {
                    type: 'bar',
                    width: 300,
                    height: 170,
                },
                plotOptions: {
                    bar: {
                        borderRadius: 4,
                        horizontal: true,
                    }
                },
                dataLabels: {
                    enabled: false
                },
                xaxis: {
                    categories: chartCategory,
                    labels: {
                        formatter: function (val) {
                            return val + '명';
                        }
                    },
                    tickAmount: maxVal2
                },
                colors: ['#7aca40'],
            };

            var chart2 = new ApexCharts(document.querySelector("#barchart"), options2);
            chart2.render();
        }
    }

    // 출력
    function showRd(){
        if ( $("#searchAppOrgCd").val() == ""  ) {
            alert("평가정보가 없습니다.");
            return;
        }

        var rdMrd   = "pap/progress/AppReport_HR.mrd";
        var rdTitle = "평가집계표출력";
        var rdParam = "";

        var searchAppraisalCdSAbunAppOrgCd_s = "('" + $("#searchAppraisalCd").val() + "', '"+ $("#searchEvaSabun").val() +"', '"+ $("#searchAppOrgCd").val() +"'),";
        searchAppraisalCdSAbunAppOrgCd_s = searchAppraisalCdSAbunAppOrgCd_s.substr(0, searchAppraisalCdSAbunAppOrgCd_s.length-1);

        rdParam  += "[${ssnEnterCd}] "; //회사코드
        rdParam  += "[5] "; //단계
        rdParam  += "["+ $("#searchAppSeqCd").val() +"] "; // 차수
        rdParam  += "["+ searchAppraisalCdSAbunAppOrgCd_s +"] "; //피평가자 사번, 평가소속
        rdParam  += "[N] "; //최종결과출력

        const data = {
            parameters : rdParam,
            rdMrd : rdMrd
        };

        window.top.showRdLayer('/EvaMain.do?cmd=getEncryptRd', data, null, rdTitle, null, null, '50vh', '50vw');
    }
</script>
<form name="evaAprLayerFrm" id="evaAprLayerFrm" method="post">
<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
<input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value=""/>
<input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value=""/>
<input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value=""/>
<input type="hidden" id="searchAppStatusCd" name="searchAppStatusCd" value=""/>
<input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value=""/>
<input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
<input type="hidden" id="lastAppSeqCd" name="lastAppSeqCd" value=""/>
<input type="hidden" id="searchAppYn" name="searchAppYn" value=""/>
<input type="hidden" id="searchChartAppGroupCd" name="searchChartAppGroupCd" value=""/>
<input type="hidden" id="mboClassCd" name="mboClassCd" value=""/>
<input type="hidden" id="compClassCd" name="compClassCd" value=""/>
</form>
<div class="hr-container target-modal p-0 large">
    <div class="modal-content border-0">
        <div class="modal-body p-0">
            <div class="d-flex gap-20">
                <div class="line position-relative">
                    <div class="scroll">
                        <div class="d-flex">
                            <h4 class="h4 mr-1 d-inline-block">평가 대상자</h4>
                        </div>
                        <div class="filters-group info">
                            <p><a id="btnSortName" href="javascript:doAction1('SortName')" class="ico-btn text-bright-gray d-flex align-items-center fw-bold" sort="desc">이름<i class="mdi-ico text-bright-gray ml-1">sync_alt</i></a></p>
                            <p class="pl-3 ml-3"><a id="btnSortGroup" href="javascript:doAction1('SortGroup')" class="ico-btn text-bright-gray d-flex align-items-center fw-bold" sort="desc">평가그룹<i class="mdi-ico text-bright-gray ml-1">sync_alt</i></a></p>
                            <p class="pl-3 ml-3"><a id="btnSortStatus" href="javascript:doAction1('SortStatus')" class="ico-btn text-bright-gray d-flex align-items-center fw-bold" sort="desc">평가상태<i class="mdi-ico text-bright-gray ml-1">sync_alt</i></a></p>
                        </div>
                        <div class="tab-content">
                            <div class="tab-pane fade active show" id="filter1">
                                <div id="aprListWrap" class="current-situation-list"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row flex-grow-1 sidebar-line" id="evaAprProgress" style="gap: 0">
                    <div class="outer evaChart">
                        <div class="sheet_title">
                            <ul>
                                <li id="txt" class="txt">평가전체현황</li>
                                <p class="text-center mb-0 ml-4 font-weight-bold" style="">평가그룹</p>
                                <select name="searchAppGroupCd" id="searchAppGroupCd" class="text-blue border1"></select>
                            </ul>
                        </div>
                    </div>
                    <div class="row evaChart">
                        <div class="col-6 pl-0 pr-2">
                            <h4 class="h4 pb-2">평가등급 배분기준 인원(명)</h4>
                            <div class="box p-0">
                                <div class="box-list">
                                    <div id="rangeChart" style="height:200px"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-6 pr-0 pl-2">
                            <h4 class="h4 pb-2">[ HR팀(팀장) 수석 ] 배분인원 현황</h4>
                            <div class="box p-0">
                                <div class="box-list">
                                    <div id="barchart" style="height:200px"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col scroll target-content">
                        <div class="outer">
                            <div class="sheet_title">
                                <ul>
                                    <li id="txt" class="txt">평가대상자 상세</li>
                                </ul>
                            </div>
                        </div>
                        <div id="aprLayerSht1-wrap"></div>
                    </div>
                </div>
                <div class="row flex-grow-1 sidebar-line" id="evaAprDet" style="display: none;">
                    <div class="col scroll">
                        <div class="sub-title-wrap">
                            <div class="d-flex align-items-center">
                                <h3 id="aprTitle" class="h2 mr-2"></h3>
                                <div class="btns ml-auto">
                                    <a href="javascript:showRd()" id="btnPrint" class="btn outline-gray">출력</a>
                                </div>
                                <div class="btns ml-2" id="appBtns">
                                    <a href="javascript:doAction1('ChkReturn')"	class="btn red-btn" id="btnReturn">반려</a>
                                    <a href="javascript:doAction1('ChkApp')"	class="btn filled" id="btnApp">평가완료</a>
                                </div>
                            </div>
                        </div>
                        <ul id="aprAppSabunListWrap" class="process-wrap row box p-0 flex-nowrap"></ul>
                        <ul class="nav nav-tabs type1" id="targetTabs1">
                            <li class="nav-item">
                                <a id="mboTab" class="nav-link active" data-toggle="tab" href="#target1-1" onclick="javascript:showIframe1('1');">업적</a>
                            </li>
                            <li class="nav-item">
                                <a id="compTab" class="nav-link" data-toggle="tab" href="#target1-2" onclick="javascript:showIframe1('2');">역량</a>
                            </li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane fade show active" id="target1-1">
                                <iframe id="tab1-1" name="tab1-1" frameborder='0' scrolling="no" style="width:100%"></iframe>
                            </div>
                             <div class="tab-pane fade" id="target1-2">
                                <iframe id="tab1-2" name="tab1-2"  frameborder='0' scrolling="no" style="width:100%"></iframe>
                            </div>
                        </div>
                    </div>
                    <div class="history-1 col scroll ">
                        <h4 class="h4 mb-2">목표작성내역</h4>
                        <ul class="nav nav-tabs type1">
                            <li class="nav-item">
                                <a id="goalMboTab" class="nav-link active" data-toggle="tab" href="#target2-1" onclick="javascript:showIframe2('1')">목표 업적</a>
                            </li>
                            <li class="nav-item">
                                <a id="goalCompTab" class="nav-link" data-toggle="tab" href="#target2-2" onclick="javascript:showIframe2('2')">목표 역량</a>
                            </li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane fade show active" id="target2-1">
                                <iframe id="tab2-1" name="tab2-1" src='${ctx}/EvaMain.do?cmd=viewEvaMboReg'
                                        frameborder='0' scrolling="no" style="width:100%"
                                        onload="setTabHeight(this)"></iframe>
                            </div>
                            <div class="tab-pane fade" id="target2-2">
                                <iframe id="tab2-2" name="tab2-2" src='${ctx}/EvaMain.do?cmd=viewEvaMboCompReg'
                                        frameborder='0' scrolling="no" style="width:100%"
                                        onload="setTabHeight(this)"></iframe>
                            </div>
                        </div>
                    </div>
                    <div class="history-2 col scroll">
                        <h4 class="h4 mb-2">면담내역</h4>
                        <iframe id="tab2-3" name="tab2-3" src='${ctx}/EvaMain.do?cmd=viewReferIntvHst'
                                frameborder='0' scrolling="no" style="width:100%"
                                onload="setTabHeight(this)"></iframe>
                    </div>
                    <div class="history-3 col scroll">
                        <h4 class="h4 mb-2">평가진행이력</h4>
                        <iframe id="tab2-4" name="tab2-4" src='${ctx}/EvaMain.do?cmd=viewReferGoalSta'
                                frameborder='0' scrolling="no" style="width:100%"
                                onload="setTabHeight(this)"></iframe>
                    </div>
                </div>
                <%-- 히스토리 --%>
                <div class="d-flex flex-column flex-shrink-0 line position-relative sidebar-wrap">
                    <ul class="list-unstyled ps-0 sidebar" id="evaAprHistory" style="display: none;">
                        <li data-snb="menu" data-target=".history-1">
                            <button type="button" class="text-boulder w-100"><i class="mdi-ico d-flex justify-content-center">track_changes</i>목표작성내역</button>
                        </li>
                        <li data-snb="menu" data-target=".history-2">
                            <button type="button" class="text-boulder w-100"><i class="mdi-ico filled d-flex justify-content-center">assignment_ind</i>면담내역</button>
                        </li>
                        <li data-snb="menu" data-target=".history-3">
                            <button type="button" class="text-boulder w-100"><i class="mdi-ico d-flex justify-content-center">history</i>평가진행이력</button>
                        </li>
                    </ul>
                </div>
                <button class="folding" type="button"><i class="mdi-ico filled">arrow_left</i></button>
            </div>
        </div>
    </div>
</div>


<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<script>
    function openModal() {
        $(".eva-modal")
            .find(".modal, .modal_background")
            .fadeIn(150);
    }

    function closeModal() {
        $(
            ".eva-modal .modal, .eva-modal .modal_background"
        ).fadeOut(150);
    }
</script>


