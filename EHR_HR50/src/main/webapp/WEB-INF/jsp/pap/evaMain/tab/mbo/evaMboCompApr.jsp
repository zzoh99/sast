<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css" />

<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    var allClassCdList = null;			// 전체평가등급(P00001)
    var classCdColId = '';

    $(function () {
        allClassCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), ""); // 전체평가등급(P00001)

        // 평가 차수에 맞는 컬럼ID 설정
        if($("#searchAppSeqCd").val() == '0') {
            // 본인평가
            classCdColId = 'compSelfClassCd';
        } else if ($("#searchAppSeqCd").val() == '1') {
            // 1차평가
            classCdColId = 'comp1stClassCd';
        } else if ($("#searchAppSeqCd").val() == '2') {
            // 2차평가
            classCdColId = 'comp2ndClassCd';
        } else if ($("#searchAppSeqCd").val() == '6') {
            // 3차평가
            classCdColId = 'comp3rdClassCd';
        }

        //시트 컬럼 설정 값
        hdnType = [0,0,0,0]; updType = [1,0,0,0];

        if($("#searchAppSeqCd").val() == "0") {  //본인
            hdnType[0] = 0; hdnType[1] = 1; hdnType[2] = 1; hdnType[3] = 1;
            updType[0] = 1; updType[1] = 0; updType[2] = 0; updType[3] = 0;
            $("#btnCompetency").hide();
        } else if($("#searchAppSeqCd").val() == "1") { //1차
            hdnType[0] = 0; hdnType[1] = 0; hdnType[2] = 1; hdnType[3] = 1;
            updType[0] = 0; updType[1] = 1; updType[2] = 0; updType[3] = 0;
        } else if($("#searchAppSeqCd").val() == "2") { //2차
            hdnType[0] = 0; hdnType[1] = 0; hdnType[2] = 0; hdnType[3] = 1;
            updType[0] = 0; updType[1] = 0; updType[2] = 1; updType[3] = 0;
        } else if($("#searchAppSeqCd").val() == "6") { //3차
            hdnType[0] = 0; hdnType[1] = 0; hdnType[2] = 0; hdnType[3] = 0;
            updType[0] = 0; updType[1] = 0; updType[2] = 0; updType[3] = 1;
        }

        var initdata = {};
        initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"세부\n내역|세부\n내역",		Type:"Image",	Hidden:0,			Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,				UpdateEdit:0,			InsertEdit:0,	EditLen:1,	Cursor:"Pointer" },
            {Header:"역량종류|역량종류",			Type:"Text",	Hidden:0,			Width:80,	Align:"Center",	ColMerge:1,	SaveName:"mainAppTypeNm",	KeyField:0,				UpdateEdit:0,			InsertEdit:1,	EditLen:100 },
            {Header:"역량항목|역량항목",			Type:"Text",	Hidden:0,			Width:120,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm",	KeyField:0,				UpdateEdit:0,			InsertEdit:1,	EditLen:100 },
            {Header:"평가척도|평가척도",			Type:"Text",	Hidden:1,			Width:200,	Align:"Left",	ColMerge:1,	SaveName:"gmeasureMemo",	KeyField:0,				UpdateEdit:0,			InsertEdit:0,	MultiLineText:1, Wrap:1 },
            {Header:"역량정의|역량정의",			Type:"Text",	Hidden:0,			Width:450,	Align:"Left",	ColMerge:1,	SaveName:"memo",			KeyField:0,				UpdateEdit:0,			InsertEdit:0,	MultiLineText:1, Wrap:1 },

            {Header:"반영\n비율|반영\n비율",		Type:"Int",	Hidden:0,			Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appRate",			KeyField:0,				UpdateEdit:0,			InsertEdit:1,	EditLen:10,	Format:"Integer",	PointCount:2 },
            {Header:"역량개발계획|역량개발계획",	Type:"Text",	Hidden:1,			Width:140,	Align:"Left",	ColMerge:0,	SaveName:"compDevPlan",		KeyField:0,				UpdateEdit:0,			InsertEdit:1,	EditLen:1000,	MultiLineText:1, Wrap:1 },
            {Header:"지원요청사항|지원요청사항",	Type:"Text",	Hidden:1,			Width:120,	Align:"Left",	ColMerge:0,	SaveName:"reqSupportMemo",	KeyField:0,				UpdateEdit:0,			InsertEdit:1,	EditLen:1000,	MultiLineText:1, Wrap:1 },

            // 주의! 이 곳에서의 설정은 Sheet가 처음 로딩될 때만 적용이 되기 때문에 searchAppraisalCd 변경 등으로 인해 바뀌는 설정값 들은 적용이 되지 않는다.
            // 따라서 아래 hdnType, updType값으로 설정하는 사항들은 setSheetColHidden_sheet1 함수에서 최종 설정하므로 아래 Sheet 초기화 시 적용된 사항들은 무시된다.
            // 변경이 필요할 시에는 이곳에서 변경하지 말고 setSheetColHidden_sheet1 함수에서 변경해야 한다!
            {Header:"본인평가|본인점수",			Type:"Int",		Hidden:1,			Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compAppSelfPoint",KeyField:updType[0],	UpdateEdit:updType[0],	InsertEdit:1,	EditLen:3 },
            {Header:"본인평가|본인등급",			Type:"Combo",	Hidden:hdnType[0],	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compSelfClassCd",	KeyField:updType[0],	UpdateEdit:updType[0],	InsertEdit:1,   ComboText : allClassCdList[0], ComboCode : allClassCdList[1]},
            {Header:"본인평가|본인의견",			Type:"Text",	Hidden:1,			Width:140,	Align:"Left",	ColMerge:0,	SaveName:"compSelfOpinion",	KeyField:0,				UpdateEdit:updType[0],	InsertEdit:1,	EditLen:1000,	MultiLineText:1, Wrap:1 },

            {Header:"1차평가|1차점수",			Type:"Int",		Hidden:1,			Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compApp1stPoint",	KeyField:updType[1],	UpdateEdit:updType[1],	InsertEdit:1,	EditLen:3 },
            {Header:"1차평가|1차등급",			Type:"Combo",	Hidden:hdnType[1],	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"comp1stClassCd",	KeyField:updType[1],	UpdateEdit:updType[1],	InsertEdit:1,   ComboText : allClassCdList[0], ComboCode : allClassCdList[1]},
            {Header:"1차평가|1차의견",			Type:"Text",	Hidden:1,	        Width:190,	Align:"Left",	ColMerge:0,	SaveName:"comp1stOpinion",	KeyField:updType[1],	UpdateEdit:updType[1],	InsertEdit:1,	EditLen:1000,	MultiLineText:1, Wrap:1 },

            {Header:"2차평가|2차점수",			Type:"Int",		Hidden:1,			Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compApp2ndPoint",	KeyField:updType[2],	UpdateEdit:updType[2],	InsertEdit:1,	EditLen:3 },
            {Header:"2차평가|2차등급",			Type:"Combo",	Hidden:hdnType[2],	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"comp2ndClassCd",	KeyField:updType[2],	UpdateEdit:updType[2],	InsertEdit:1,   ComboText : allClassCdList[0], ComboCode : allClassCdList[1]},
            {Header:"2차평가|2차의견",			Type:"Text",	Hidden:1,			Width:140,	Align:"Left",	ColMerge:0,	SaveName:"comp2ndOpinion",	KeyField:updType[2],	UpdateEdit:updType[2],	InsertEdit:1,	EditLen:1000,	MultiLineText:1, Wrap:1 },

            {Header:"3차평가|3차점수",			Type:"Int",		Hidden:1,			Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compApp3rdPoint",	KeyField:updType[3],	UpdateEdit:updType[3],	InsertEdit:1,	EditLen:3 },
            {Header:"3차평가|3차등급",			Type:"Combo",	Hidden:hdnType[3],	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"comp3rdClassCd",	KeyField:updType[3],	UpdateEdit:updType[3],	InsertEdit:1,   ComboText : allClassCdList[0], ComboCode : allClassCdList[1]},
            {Header:"3차평가|3차의견",			Type:"Text",	Hidden:1,			Width:140,	Align:"Left",	ColMerge:0,	SaveName:"comp3rdOpinion",	KeyField:updType[3],	UpdateEdit:updType[3],	InsertEdit:1,	EditLen:1000,	MultiLineText:1, Wrap:1 },

            {Header:"첨부파일|첨부파일",			Type:"Image",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"filePop",			Sort:0,	Cursor:"Pointer" },
            {Header:"첨부파일|첨부파일",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq"},

            {Header:"평가ID|평가ID",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
            {Header:"사번|사번",				Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
            {Header:"평가소속|평가소속",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
            {Header:"역량코드|역량코드",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"competencyCd"},
            {Header:"구분|구분",				Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mainAppType"},

            {Header:"역량|역량구분",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"competencyType"},
            {Header:"역량|시작일자",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sdate"},
            {Header:"역량|종료일자",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"edate"},
            {Header:"역량|척도코드",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"gmeasureCd"},
            {Header:"역량|척도명",				Type:"Text",	Hidden:1,			Width:50,	Align:"Center",	ColMerge:0,	SaveName:"gmeasureNm"}
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

        sheet1.SetEditEnterBehavior("newline");
        sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
        sheet1.SetImageList(1, "${ctx}/common/images/icon/icon_file.png");
        sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    function setStatusForm() {
        if($("#searchAppYn").val() === 'Y') {
            // 저장버튼 숨김
            $("#btnSave").hide();
            // 폼 안의 모든 입력 필드, 체크박스, 라디오 버튼, 선택된 옵션을 readonly로 설정
            $('#evaMboCompAprFrm').find('input[type="text"], input[type="password"], input[type="email"], input[type="number"], input[type="date"], textarea').attr('readonly', true);
            $('#evaMboCompAprFrm').find('input[type="checkbox"], input[type="radio"]').attr('disabled', true);
            $('#evaMboCompAprFrm').find('select').attr('disabled', true); // select 요소는 disabled 처리

        } else {
            $("#btnSave").show();

            // 본인평가외 1-3차 평가인 경우, 등급 선택만 남기고 모두 비활성화처리
            if($("#searchAppSeqCd").val() !== '0') {
                $('#evaMboCompAprFrm').find('input[type="text"], input[type="password"], input[type="email"], input[type="number"], input[type="date"], textarea').attr('readonly', true);
                $('#evaMboCompAprFrm').find('input[type="checkbox"], input[type="radio"]').attr('disabled', true);
                $('#evaMboCompAprFrm').find('select').attr('disabled', true); // select 요소는 disabled 처리
                $("input[type='radio'][name*='compClassCd']").attr('disabled', false);
                $("#compClassCd").attr('disabled', false);
                $("#btnSaveGrade").show();
            } else {
                $('#evaMboCompAprFrm').find('input[type="text"], input[type="password"], input[type="email"], input[type="number"], input[type="date"], textarea').attr('readonly', false);
                $('#evaMboCompAprFrm').find('input[type="checkbox"], input[type="radio"]').attr('disabled', false);
                $('#evaMboCompAprFrm').find('select').attr('disabled', false);
            }
        }
        
    }

    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                // sheet 조회
                sheet1.DoSearch( "${ctx}/EvaMain.do?cmd=getAppSelfList2", $("#evaMboCompAprFrm").serialize() );
                break;
            case "Save":
                if(parent.$("#btnSaveGrade").is(':visible')) {
                    if( !confirm("저장시 업적/역량등급이 초기화 됩니다. 저장하시겠습니까?")) return;
                }
                setFormToSheet();
                IBS_SaveName(document.evaMboCompAprFrm,sheet1);
                sheet1.DoSave( "${ctx}/EvaMain.do?cmd=saveMboCompApr", $("#evaMboCompAprFrm").serialize());
                break;
            case "SaveGrade":
                if( !confirm("역량등급을 저장하시겠습니까?")) return;
                //저장
                var data = ajaxCall("${ctx}/EvaMain.do?cmd=saveMboCompAprGradeCd",$("#evaMboCompAprFrm").serialize(),false);
                if(data.Result.Message != '') {
                    alert(data.Result.Message);
                }
                break;
            case "Clear":
                sheet1.RemoveAll();
                break;
            case "Down2Excel":
                var downcol = makeHiddenSkipCol(sheet1);
                var param = {DownCols:downcol, SheetDesign:1, Merge:1};
                sheet1.Down2Excel(param);
                break;
        }
        return true;
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            makeForm();
            // 저장버튼 및 form 활성화 여부 체크
            setStatusForm();
            sheetResize();
        } catch (ex) {
            alert("EvaMboCompApr sheet1 OnSearchEnd Event Error : " + ex);
        }
    }

    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try{
            if(Msg != "") alert(Msg);
            if ( Code != "-1" ) {
                // 프로시저 저장
                var data = ajaxCall("${ctx}/EvaMain.do?cmd=prcAppSelf1",$("#evaMboCompAprFrm").serialize(),false);
                if(data.Result.Code != null) {
                    alert(data.Result.Message);
                }
                doAction1("Search");
            }
        }catch(ex){
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    function makeForm() {

        // 역량 등급 설정
        var classCdListsParam = "queryId=getAppClassMgrCdListBySeq&searchAppStepCd=5";
        classCdListsParam += "&searchAppraisalCd=" + $("#searchAppraisalCd", "#evaMboCompAprFrm").val();

        var classCdList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",classCdListsParam,false).codeList, "선택");

        if($("#searchAppSeqCd", "#evaMboCompAprFrm").val() != '0') {
            //$("#compClassCdWrap").show();
            // 역량 등급 콤보박스 설정
            $("#compClassCd").html(classCdList[$("#searchAppSeqCd", "#evaMboCompAprFrm").val()][2]);

            const data = ajaxCall("${ctx}/EvaMain.do?cmd=getEvaAprGradeCdMap", $("#evaMboCompAprFrm").serialize(), false).DATA;
            if(data != null && data !== 'undefined') {
                $("#compClassCd").val(data.compClassCd);
                parent.$("#compClassCdList").val(data.compClassCd);
            }
        }

        let html = '';
        let classNmArr = allClassCdList[0].split('|');
        let classCdArr = allClassCdList[1].split('|');
        let classCdHtml = '';
        for(let i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
            classCdHtml = '';
            classCdArr.forEach(function(classCd, idx){
                let isChked = classCd === sheet1.GetCellValue(i, classCdColId) ? 'checked' : '' ;
                classCdHtml += `<input type="radio" class="btn-check" name="compClassCd${'${i}'}" id="compClassCd${'${i}'}-${'${classCd}'}" value="${'${classCd}'}" autocomplete="off" ${'${isChked}'}>
                                <label class="btn text-darkgray" for="compClassCd${'${i}'}-${'${classCd}'}">${'${classNmArr[idx]}'}</label>`
            });

            let selfCdClass = 'hide';
            let firstCdClass = 'hide';
            let secondCdClass = 'hide';

            if($("#searchAppSeqCd").val() == '1') {
                selfCdClass = 'show';
            } else if ($("#searchAppSeqCd").val() == '2') {
                selfCdClass = 'show';
                firstCdClass = 'show';
            } else if ($("#searchAppSeqCd").val() == '6') {
                selfCdClass = 'show';
                firstCdClass = 'show';
                secondCdClass = 'show';
            }

            html += `
                    <div class="box box-border row mb-2">
                        <div class="d-flex align-items-center mb-2">
                            <strong class="badge green rounded-pill font-weight-bold mr-2">`+sheet1.GetCellValue(i, 'appRate')+`%</strong>
                            <p class="h4 font-weight-normal">`+sheet1.GetCellValue(i, 'competencyNm')+`</p>
                        </div>
                        <div class="info ml-auto">
                            <p class="${'${selfCdClass}'}">
                                <span class="badge blue mr-2">자기평가</span>
                                <span class="h3 text-color-basic">`+sheet1.GetCellText(i, 'compSelfClassCd')+`</span>
                            </p>
                            <p class="pl-3 ml-3 ${'${firstCdClass}'}">
                                <span class="badge blue mr-2">1차평가</span>
                                <span class="h3 text-color-basic">`+sheet1.GetCellText(i, 'comp1stClassCd')+`</span>
                            </p>
                            <p class="pl-3 ml-3 ${'${secondCdClass}'}">
                                <span class="badge blue mr-2">2차평가</span>
                                <span class="h3 text-color-basic">`+sheet1.GetCellText(i, 'comp2ndClassCd')+`</span>
                            </p>
                        </div>
                        <h4 class="h4 mt-2 d-flex align-items-center font-weight-normal row"><i class="mdi-ico filled h3 mr-2">edit</i>개요</h4>
                        <textarea class="w-100 inputbox" rows="4" disabled>`+sheet1.GetCellValue(i, 'memo')+`</textarea>
                        <h4 class="h4 mt-2 d-flex align-items-center font-weight-normal row"><i class="mdi-ico filled h3 mr-2">edit</i>평가등급</h4>
                        <div class="btn-group" role="group" aria-label="radio toggle button group">
                        ${'${classCdHtml}'}
                        </div>
                    </div>
                    `
        }
        $("#evaMboCompAprFrmWrap").html(html);
    }

    // 폼 정보를 시트에 세팅
    function setFormToSheet() {
        for(let i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
            let radioNm = 'compClassCd'+i;
            let classCd = $('input[name="'+radioNm+'"]:checked').val();
            if (classCd === undefined) classCd = '';
            sheet1.SetCellValue(i, classCdColId, classCd);
        }
    }

    // 필수입력값 모두 입력했는지 확인
    function checkRequiredCol() {
        for(let i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
            for(let j=0; j<sheet1.LastCol(); j++) {
                // 필수입력이고, 히든이 아닌 컬럼 탐색
                if(sheet1.GetCellProperty(i, j, 'Hidden') == 0 && sheet1.GetCellProperty(i, j, 'KeyField') == 1 && sheet1.GetCellValue(i, j) == '') {
                    return sheet1.GetCellValue(0, j)
                }
            }
        }
        return null;
    }
</script>
<form id="evaMboCompAprFrm" name="evaMboCompAprFrm">
    <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value="${param.searchAppraisalCd}"/>
    <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value="${param.searchAppStepCd}"/>
    <input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value="${param.searchEvaSabun}"/>
    <input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value="${param.searchAppOrgCd}"/>
    <input type="hidden" id="searchAppStatusCd" name="searchAppStatusCd" value="${param.searchAppStatusCd}"/>
    <input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value="${param.searchAppSeqCd}"/>
    <input type="hidden" id="searchAppSabun" name="searchAppSabun" value="${param.searchAppSabun}"/>
    <input type="hidden" id="searchAppYn" name="searchAppYn" value="${param.searchAppYn}"/>

    <div class="hr-container target-modal p-0">
        <div class="d-flex justify-content-between align-items-center ">
            <ul class="process-wrap row box p-0 mb-2 mt-0 flex-nowrap">
                <li id="compClassCdWrap" class="box box-border flex-column final p-1 w-30" style="display: none;">
                    <div class="cate">
                        <p class="badge">역량등급</p>
                        <select name="compClassCd" id="compClassCd" class="h4 opensans-bold text-blue border1"></select>
                        <a href="javascript:doAction1('SaveGrade')" id="btnSaveGrade" class="btn filled" style="display: none;"><tit:txt mid='104476' mdef='저장'/></a>
                    </div>
                </li>
                <li class="flex-column p-2 ml-auto">
                    <div class="btns">
                        <a href="javascript:doAction1('Save')" id="btnSave" class="btn filled" style="display: none;"><tit:txt mid='104476' mdef='저장'/></a>
                    </div>
                </li>
            </ul>
        </div>
        <div class="hide"><script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script></div>
        <div id="evaMboCompAprFrmWrap"></div>
    </div>
</form>