<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css" />

<script type="text/javascript">

    var sRow = '';
    const editYn = "${param.editableYn}";
    $(function () {
        $(".tab-link").click(function(e){
            e.preventDefault();
            let target = $(this).attr("href");

            $(".tab-content").hide();
            $(target).show();

            $(".tab-link.box").add();

            $('.tab-link').find('.box').removeClass('active');
            $(this).find('.box').addClass('active');
        });

        /* Form 항목 설정 */
        // 목표구분 Combo 설정
        var mboTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009"), "선택"); // 목표구분(P10009)
        $("#mboType").html(mboTypeList[2]);

        // 기한 Combo 설정
        var deadlineTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00019"), "선택");
        $("#deadlineType").html(deadlineTypeList[2]);

        // 순서, 가중치 항목 숫자만 입력 가능하도록 함.
        $("#orderSeq, #weight").on("keyup", function(event) {
            makeNumber(this, 'A');
        });

        // 조직KPI 버튼 설정
        let appStatusCd = $("#searchAppStatusCd").val()
        if (appStatusCd == "11" || appStatusCd == "23" || appStatusCd == "33" || appStatusCd == "43") {
            $("#btnOrgLeader").show(); //조직장KPI
        } else {
            $("#btnOrgLeader").hide(); //조직장KPI
        }

        // evaMboRegSht1 init
        var initdata = {};
        initdata.Cfg = {FrozenCol:9,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No|No",		Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:0,   Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태|상태",		Type:"${sSttTy}",	Hidden:0,   Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"순서|순서",									Type:"Int",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",				KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:2},
            {Header:"구분|구분",									Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appIndexGubunCd",			KeyField:0,	UpdateEdit:1,	InsertEdit:1,	},
            {Header:"구분|구분",									Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appIndexGubunNm",			KeyField:0,	UpdateEdit:1,	InsertEdit:1,	},

            {Header:"목표구분|목표구분",							Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"mboType",					KeyField:1,	UpdateEdit:1,	InsertEdit:1,	},
            {Header:"목표구분|목표구분",							Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"mboTypeNm",				KeyField:0,	UpdateEdit:1,	InsertEdit:1,	},
            {Header:"목표항목|목표항목",							Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",				KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1500},

            {Header:"비중(%)|비중(%)",							Type:"Text",    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"weight",					KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6, MaximumValue:100, MinimumValue:0},
            {Header:"목표달성을 위한 핵심 요인|목표달성을 위한 핵심 요인",Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"kpiNm",					KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1000},
            {Header:"달성목표(정량,최종)|달성목표(정량,최종)",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"formula",					KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1500},
            {Header:"중점추진 Activity|중점추진 Activity",			Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"remark",					KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1500},

            {Header:"추진일정",							    	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"deadlineType",			KeyField:1,	UpdateEdit:1,	InsertEdit:1 },
            {Header:"추진일정|To",								Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"deadlineTypeTo",			KeyField:0,	Format:"Ym",	UpdateEdit:1,	InsertEdit:1 },
            {Header:"측정기준|측정기준",							Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"baselineData",			KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1500},

            {Header:"목표수준|S(100)",							Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sGradeBase",				KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:300},
            {Header:"목표수준|A(90)", 							Type:"Text", 	Hidden:1,	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"aGradeBase",				KeyField:0, UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:300},
            {Header:"목표수준|B(80)", 							Type:"Text", 	Hidden:1,	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"bGradeBase",				KeyField:0, UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:300},
            {Header:"목표수준|C(70)", 							Type:"Text", 	Hidden:1,	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"cGradeBase",				KeyField:0, UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:300},
            {Header:"목표수준|D(60)",		 					Type:"Text",	Hidden:1,	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"dGradeBase",				KeyField:0, UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:300},

            {Header:"중간평가|중간평가",							Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboMidAppSelfClassCd",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	},
            {Header:"중간점검실적|중간점검실적",					Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboMidAppResult",			KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1000},
            {Header:"1차평가|1차평가",							Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboMidApp1stClassCd",		KeyField:0,	UpdateEdit:1,	InsertEdit:1,	},
            {Header:"승인자의견|승인자의견",						Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"mboMidApp1stMemo",		KeyField:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1500},
            {Header:"평가ID",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
            {Header:"평가소속",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
            {Header:"사원번호",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
            {Header:"순서",										Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
            {Header:"생성구분코드",								Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd"},
            {Header:"KPI지정 평가자사번",							Type:"Text",	Hidden:1,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"designateAppSabun"}

        ]; IBS_InitSheet(evaMboRegSht1, initdata);evaMboRegSht1.SetEditable("${editable}");evaMboRegSht1.SetVisible(true);evaMboRegSht1.SetCountPosition(4);evaMboRegSht1.SetUnicodeByte(3);


        // evaMboRegSht2 init
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제",		Type:"${sDelTy}",	Hidden:0,   Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태",		Type:"${sSttTy}",	Hidden:0,   Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"등급",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,	},
            {Header:"목표수준",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"goalLevel",	KeyField:1,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, Wrap:1,	EditLen:1500},
            {Header:"순서",		Type:"Int",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},

            // Hidden
            {Header:"평가ID",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
            {Header:"평가소속",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
            {Header:"사원번호",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
            {Header:"순서",										Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
            {Header:"생성구분코드",								Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd"},
        ]; IBS_InitSheet(evaMboRegSht2, initdata);evaMboRegSht2.SetVisible(true);evaMboRegSht2.SetCountPosition(4);evaMboRegSht2.SetUnicodeByte(3);
        // 등급
        var appClassCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "P00001"), "");	// 평가등급
        evaMboRegSht2.SetColProperty("appClassCd", 	{ComboText:appClassCd[0], ComboCode:appClassCd[1]} );

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    <!-- evaMboRegSht1 Script -->
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                evaMboRegSht1.DoSearch( "${ctx}/EvaMain.do?cmd=getMboTargetRegList1", $("#evaMboRegForm").serialize() );
                break;
            case "Save":
                setFormToSheet();

                // 삭제시, sheet2도 함께 삭제
                if(evaMboRegSht1.FindStatusRow("D") !== '' && evaMboRegSht2.FindStatusRow("D") !== '') {
                    doAction2('Save', 0);
                }

                IBS_SaveName(document.evaMboRegForm,evaMboRegSht1);
                evaMboRegSht1.DoSave( "${ctx}/EvaMain.do?cmd=saveMboTargetReg1", $("#evaMboRegForm").serialize());
                break;
            case "Insert":
                var Row = evaMboRegSht1.DataInsert(0);
                evaMboRegSht1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
                evaMboRegSht1.SetCellValue(Row, "appOrgCd", $("#searchAppOrgCd").val());
                evaMboRegSht1.SetCellValue(Row, "sabun", $("#searchEvaSabun").val());
                evaMboRegSht1.SetCellValue(Row, "mkGubunCd", "U");
                evaMboRegSht1.SetSelectRow(Row);
                clearForm();
                makeCard();
                disableForm(false);
                visibleBtn(true);
                sheetToForm(Row);
                break;
            case "OrgLeader" : //조직장KPI
                if(!isPopup()) {return;}
                orgLeaderPopup();
                break;
            case "Delete" :
                evaMboRegSht1.SetCellValue(sRow, "sDelete", "1");
                for(var i=evaMboRegSht2.HeaderRows(); i<=evaMboRegSht2.LastRow(); i++) {
                    evaMboRegSht2.SetCellValue(i, "sDelete", "1");
                }

                if(evaMboRegSht1.FindStatusRow("D") === '') {
                    // 최초 입력한 데이터를 삭제하는 경우, card만 새로 생성해준다
                    makeCard();
                    if(evaMboRegSht1.GetDataFirstRow() > 0)
                        sheetToForm(evaMboRegSht1.GetDataFirstRow());
                } else {
                    doAction1('Save');
                }

                break;

        }
        return true;
    }

    // 조회 후 에러 메시지
    function evaMboRegSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") { alert(Msg); }

            makeCard();

            if(evaMboRegSht1.GetDataFirstRow() > 0) {
                if(sRow != '')
                    sheetToForm(sRow);
                else
                    sheetToForm(evaMboRegSht1.GetDataFirstRow());
            } else {
                if( ($("#searchAppStatusCd").val() === '11' || $("#searchAppStatusCd").val() === '23' || $("#searchAppStatusCd").val() === '33' || $("#searchAppStatusCd").val() === '43' )
                    && editYn != 'N') {
                    disableForm(false);
                    visibleBtn(true);
                }
            }

            sheetResize();
        } catch (ex) { console.error(ex); /*alert("OnSearchEnd Event Error : " + ex);*/ }
    }

    // 저장 후 메시지
    function evaMboRegSht1_OnSaveEnd(Code, Msg) {
        try{
            if ( Code != "-1" ) {
                // 조직KPI 관리 프로시저 실행
                setTimeout(function(){
                    var params = "searchAppraisalCd=" + $("#searchAppraisalCd").val();
                    params += "&searchAppStepCd=" + $("#searchAppStepCd").val();
                    params += "&searchAppSabun=" + $("#searchEvaSabun").val();
                    params += "&searchSeq=&desigSabunsOrgs=";

                    var data = ajaxCall("${ctx}/EvaMain.do?cmd=prcMboTargetKpiMgr",params,false);
                    if(typeof data.Result.Message != 'undefined' && data.Result.Message !== null) {
                        alert(data.Result.Message);
                    } else {
                        if (Msg != "") {
                            alert(Msg);
                        }
                    }
                    clearForm()
                    doAction1('Search');
                }, 300);
            }
        }catch(ex){
            alert("OnSaveEnd Event Error " + ex);
        }
    }
    
    <!-- evaMboRegSht2 Script -->
    function doAction2(sAction, saveQuest) {
        switch (sAction) {
            case "Search":
                evaMboRegSht2.DoSearch( "${ctx}/EvaMain.do?cmd=getEvaMboRegList2", $("#evaMboRegForm").serialize() );
                break;
            case "Save":
                if(evaMboRegSht1.GetCellValue(evaMboRegSht1.GetSelectRow(), "seq") == '' || evaMboRegSht1.GetCellValue(evaMboRegSht1.GetSelectRow(), "mkGubunCd") == '') {
                    alert('목표상세내용을 먼저 저장하세요.')
                    break;
                }
                if(!dupChk(evaMboRegSht2,"appClassCd", true, true)){break;}
                IBS_SaveName(document.evaMboRegForm,evaMboRegSht2);
                evaMboRegSht2.DoSave( "${ctx}/EvaMain.do?cmd=saveEvaMboReg", {Param:$("#evaMboRegForm").serialize(),Quest:saveQuest});
                break;
            case "Copy":
                var row = evaMboRegSht2.DataCopy();
                break;
            case "Insert":
                var Row = evaMboRegSht2.DataInsert(0);
                evaMboRegSht2.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
                evaMboRegSht2.SetCellValue(Row, "appOrgCd", $("#searchAppOrgCd").val());
                evaMboRegSht2.SetCellValue(Row, "sabun", $("#searchEvaSabun").val());
                evaMboRegSht2.SetCellValue(Row, "seq", $("#searchSeq").val());
                evaMboRegSht2.SetCellValue(Row, "mkGubunCd", $("#searchMkGubunCd").val());
                break;
        }
        return true;
    }

    // 조회 후 에러 메시지
    function evaMboRegSht2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") { alert(Msg); }

            // 편집 불가 케이스
            if( ($("#searchAppStatusCd").val() !== '11' && $("#searchAppStatusCd").val() !== '23' && $("#searchAppStatusCd").val() !== '33' && $("#searchAppStatusCd").val() !== '43' )
                || editYn == 'N') {
                disableForm(true);
                visibleBtn(false);
            }

            sheetResize();
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function evaMboRegSht2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            if( Code > -1 ) doAction2("Search");
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    function makeCard() {
        let html = '';
        let weightSum = 0;
        for(let i=evaMboRegSht1.HeaderRows(); i<=evaMboRegSht1.LastRow(); i++) {
            let isActive = i === evaMboRegSht1.HeaderRows() ? 'active' : ''

            weightSum += Number(evaMboRegSht1.GetCellValue(i, "weight"));

            html +=
                `<div class="swiper-slide">
                        <a class="tab-link" href="javascript:sheetToForm(${'${i}'}); activeCard('goalCard${'${i}'}');">
                            <div id="goalCard${'${i}'}" name="goalCard" class="box box-border p-0 flex-column ${'${isActive}'}">
                                <div class="cate">
                                    <span class="badge green">`+ evaMboRegSht1.GetCellValue(i, "mboTypeNm") +`</span>
                                    <span class="percent">`+ evaMboRegSht1.GetCellValue(i, "weight") +`%</span>
                                </div>
                                <p>`+ evaMboRegSht1.GetCellValue(i, "mboTarget") +`</p>
                            </div>
                        </a>
                    </div>`
        }

        $("#mboCardList").html(html);
        $("#weightSum").text(weightSum+"%");

        if(html == '') {
            doAction1('Insert', true)
        }
    }

    // 선택한 카드의 CSS 변경
    function activeCard(cardId) {
        $('div[name="goalCard"]').removeClass('active');
        $("#"+cardId).addClass('active');
    }

    // 시트 정보를 폼에 셋팅
    function sheetToForm(Row){
        sRow = Row;
        evaMboRegSht1.SetSelectRow(Row);
        // 목표상세내용
        $("#mboType", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'mboType'));
        $("#orderSeq", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'orderSeq'));
        $("#mboTarget", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'mboTarget'));
        $("#baselineData", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'baselineData'));
        $("#weight", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'weight'));

        // 목표실행계획
        $("#formula", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'formula'));
        $("#deadlineType", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'deadlineType'));
        $("#remark", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'remark'));

        // 조회조건
        $("#searchSeq", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'seq'));
        $("#searchMkGubunCd", "#evaMboRegForm").val(evaMboRegSht1.GetCellValue(Row, 'mkGubunCd'));

        // 편집 불가 케이스
        if( ($("#searchAppStatusCd").val() !== '11' && $("#searchAppStatusCd").val() !== '23' && $("#searchAppStatusCd").val() !== '33' && $("#searchAppStatusCd").val() !== '43' )
            || editYn == 'N') {
            disableForm(true);
            visibleBtn(false);
        } else {
            visibleBtn(true);
            // 자동생성 ROW 인 경우 수정, 삭제 불가처리
            if ( evaMboRegSht1.GetCellValue(Row, "mkGubunCd") == "S" ) {
                //수정은 불가하지만 삭제는 가능하도록 수정
                $("#btnDel").show()
                $(".btnSave").hide()
                disableForm(true);
            } else if ( evaMboRegSht1.GetCellValue(Row, "mkGubunCd") == "C" ) {
                // 삭제 및 수정 불가처리
                $("#btnDel").hide()
                $(".btnSave").hide()
                disableForm(true);
            } else {
                $("#btnDel").show()
                $(".btnSave").show()
                disableForm(false);
            }
        }

        // 등급별 목표수준 조회
        doAction2('Search');
    }

    // 폼 정보를 시트에 세팅
    function setFormToSheet() {
        let row = evaMboRegSht1.GetSelectRow();
        if (row == -1) {
            var Row = evaMboRegSht1.DataInsert(0);
            evaMboRegSht1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
            evaMboRegSht1.SetCellValue(Row, "appOrgCd", $("#searchAppOrgCd").val());
            evaMboRegSht1.SetCellValue(Row, "sabun", $("#searchEvaSabun").val());
            evaMboRegSht1.SetCellValue(Row, "mkGubunCd", "U");
            evaMboRegSht1.SetSelectRow(Row);
            row = evaMboRegSht1.GetSelectRow();
        }
        evaMboRegSht1.SetCellValue(row,"mboType", $("#mboType").val());
        evaMboRegSht1.SetCellValue(row,"orderSeq",$("#orderSeq").val());
        evaMboRegSht1.SetCellValue(row,"mboTarget",$("#mboTarget").val());
        evaMboRegSht1.SetCellValue(row,"baselineData",$("#baselineData").val());
        evaMboRegSht1.SetCellValue(row,"weight",$("#weight").val());
        evaMboRegSht1.SetCellValue(row,"formula",$("#formula").val());
        evaMboRegSht1.SetCellValue(row,"deadlineType",$("#deadlineType").val());
        evaMboRegSht1.SetCellValue(row,"remark",$("#remark").val());
    }

    function clearForm() {
        // 폼 안의 모든 입력 필드, 체크박스, 라디오 버튼, 선택된 옵션 초기화
        $('#evaMboRegForm').find('input[type="text"], input[type="password"], input[type="email"], input[type="number"], input[type="date"], textarea').val('');
        $('#evaMboRegForm').find('input[type="checkbox"], input[type="radio"]').prop('checked', false);
        $('#evaMboRegForm').find('select').prop('selectedIndex', 0); // 첫 번째 옵션 선택
    }

    function disableForm(flag) {
        // 폼 안의 모든 입력 필드, 체크박스, 라디오 버튼, 선택된 옵션을 readonly로 설정
        $('#evaMboRegForm').find('input[type="text"], input[type="password"], input[type="email"], input[type="number"], input[type="date"], textarea').attr('readonly', flag);
        $('#evaMboRegForm').find('input[type="checkbox"], input[type="radio"]').attr('disabled', flag);
        $('#evaMboRegForm').find('select').attr('disabled', flag); // select 요소는 disabled 처리

        // 시트 편집여부
        if(evaMboRegSht2.GetDataFirstRow() > 0) {
            evaMboRegSht2.SetEditable(!flag)
            evaMboRegSht2.SetColHidden('sStatus', flag)
            evaMboRegSht2.SetColHidden('sDelete', flag)
            sheetResize();
        }
    }

    // 버튼 전체 visible 여부
    function visibleBtn(flag) {
        if (flag) {
            $("#btnWrap1").show();
            $("#btnWrap2").show();
        } else {
            $("#btnWrap1").hide();
            $("#btnWrap2").hide();
        }
    }

    function orgLeaderPopup() {

        var args = {};

        gPRow = "";
        pGubun = "mboTargetRegPopOrgLeader";

        args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
        args["searchAppOrgCd"] = $("#searchAppOrgCd").val();
        args["searchEvaSabun"] = $("#searchEvaSabun").val();
        args["searchAppStepCd"] = $("#searchAppStepCd").val();
        args["searchAppStatusCd"] = $("#searchAppStatusCd").val();
        args["authPg"] = "${authPg}";

        var layer = new window.top.document.LayerModal({
            id : 'mboTargetRegPopOrgLeaderLayer'
            , url : "${ctx}/EvaMain.do?cmd=viewMboTargetRegPopOrgLeader"
            , parameters: args
            , width : 1100
            , height : 650
            , top: '50vh'
            , left: '50vw'
            , title : "조직KPI"
            , trigger :[
                {
                    name : 'mboTargetRegPopOrgLeaderTrigger'
                    , callback : function(rv){
                        var paramName = ["orderSeq"
                            ,"appIndexGubunNm"
                            ,"appIndexGubunCd"
                            ,"mboTarget"
                            ,"kpiNm"
                            ,"formula"
                            ,"baselineData"
                            ,"sGradeBase"
                            ,"aGradeBase"
                            ,"bGradeBase"
                            ,"cGradeBase"
                            ,"dGradeBase"
                            ,"weight"
                            ,"remark"
                            ,"seq"
                            ,"mkGubunCd"
                            ,"mboType"
                            ,"mboTypeNm"
                            ,"deadlineType"
                            ,"deadlineTypeTo"
                            ,"appraisalCd"
                            ,"sabun"
                            ,"appOrgCd"
                            ,"detail"
                        ];

                        var iRow = evaMboRegSht1.DataInsert(0);
                        for (var i=0; i<paramName.length; i++) {
                            evaMboRegSht1.SetCellValue(iRow, paramName[i], rv[paramName[i]]);
                        }
                        makeCard();
                        sheetToForm(evaMboRegSht1.GetDataFirstRow());
                    }
                }
            ]
        });
        layer.show();
    }
</script>

<div class="hr-container target-modal p-0">
    <form id="evaMboRegForm" name="evaMboRegForm">
        <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value="${param.searchAppStepCd}"/>
        <input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value="${param.searchEvaSabun}"/>
        <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value="${param.searchAppraisalCd}"/>
        <input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value="${param.searchAppOrgCd}"/>
        <input type="hidden" id="searchAppStatusCd" name="searchAppStatusCd" value="${param.searchAppStatusCd}"/>
        <input type="hidden" id="searchSeq" name="searchSeq" value=""/>
        <input type="hidden" id="searchMkGubunCd" name="searchMkGubunCd" value=""/>
        <div class="warning-msg-wrap">
            <div class="d-flex align-items-center">
                <h4 class="h4 mr-3">가중치 합계</h4>
                <span class="d-flex align-items-center text-darkgray"><i class="mdi-ico help filled">help</i>가중치 합계가 100%가 되도록 목표를 등록하세요.</span>
                <span class="badge big green ml-auto rounded-pill">가중치 합계 <span id="weightSum" class="font-weight-bold"></span></span>
            </div>
        </div>
        <div class="registration-status-swiper">
            <div class="swiper-container">
                <div id="mboCardList" class="swiper-wrapper"></div>
            </div>
        </div>
        <div class="outer">
            <div class="sheet_title">
                <ul>
                    <li id="txt" class="txt">목표 상세내용</li>
                    <li id="btnWrap1" class="btn" style="display: none">
                        <a href="javascript:doAction1('OrgLeader')"		id="btnOrgLeader"	class="btn outline-gray">조직KPI</a>
                        <a href="javascript:doAction1('Insert', true)"		class="btn outline-gray"><tit:txt mid='104267' mdef='입력'/></a>
                        <a href="javascript:doAction1('Delete')"		id="btnDel" class="btn soft"><tit:txt mid='104476' mdef='삭제'/></a>
                        <a href="javascript:doAction1('Save')"			id="btnSave" class="btn filled btnSave"><tit:txt mid='104476' mdef='저장'/></a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="tab-content" id="tab-1">
            <table class="table table-fixed border-bottom-0 mb-0">
                <colgroup>
                    <col width="15%">
                    <col>
                </colgroup>
                <tbody>
                <tr>
                    <th><sup>*</sup>목표구분</th>
                    <td class="text-left">
                        <select name="mboType" id="mboType"></select>
                    </td>
                    <th><sup>*</sup>순서</th>
                    <td class="text-left"><input type="text" id="orderSeq" name="orderSeq" class="inputbox sm" maxlength="3"> </td>
                </tr>
                <tr>
                    <th><sup>*</sup>목표항목</th>
                    <td class="text-left" colspan="3"><input type="text" id="mboTarget" name="mboTarget" class="inputbox mw-100" value=""></td>
                </tr>
                <tr>
                    <th><sup>*</sup>평가기준</th>
                    <td class="text-left" colspan="3"><textarea name="baselineData" id="baselineData" class="w-100" rows="4"></textarea></td>
                </tr>
                <tr>
                    <th><sup>*</sup>가중치</th>
                    <td class="text-left" colspan="3"><input type="text" id="weight" name="weight" class="inputbox sm" maxlength="3"> </td>
                </tr>
                </tbody>
            </table>
            <div class="outer">
                <div class="sheet_title">
                    <ul>
                        <li id="txt" class="txt">등급별 목표수준</li>
                        <li id="btnWrap2" class="btn" style="display: none">
                            <a href="javascript:doAction2('Copy')"			class="btn outline-gray"><tit:txt mid='104335' mdef='복사'/></a>
                            <a href="javascript:doAction2('Insert')"		class="btn outline-gray"><tit:txt mid='104267' mdef='입력'/></a>
                            <a href="javascript:doAction2('Save')"			class="btn filled btnSave"><tit:txt mid='104476' mdef='저장'/></a>
                        </li>
                    </ul>
                </div>
            </div>
            <script type="text/javascript">createIBSheet("evaMboRegSht2", "100%", "250px","kr"); </script>
            <div class="outer">
                <div class="sheet_title">
                    <ul>
                        <li class="txt">목표 실행계획</li>
                    </ul>
                </div>
            </div>
            <table class="table table-fixed border-bottom-0 mb-0">
                <colgroup>
                    <col width="22%">
                    <col>
                </colgroup>
                <tbody>
                <tr>
                    <th>세부실행계획</th>
                    <td class="text-left"><textarea name="formula" id="formula" class="w-100" rows="4"></textarea></td>
                </tr>
                <tr>
                    <th>기한/일정</th>
                    <td class="text-left">
                        <select name="deadlineType" id="deadlineType"></select>
                    </td>
                </tr>
                <tr>
                    <th>예상이슈 및 지원사항</th>
                    <td class="text-left"><textarea name="remark" id="remark" class="w-100" rows="4"></textarea></td>
                </tr>
                </tbody>
            </table>
        </div>
    </form>
    <!-- evaMboRegSht1 -->
    <div class="hide">
        <script type="text/javascript">createIBSheet("evaMboRegSht1", "0", "0","kr"); </script>
    </div>
</div>

<!-- js -->
<%--<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>--%>
<script src="/assets/plugins/swiper-10.2.0/swiper-bundle.min.js"></script>

<script>
    // 등록여부 리스트 스와이퍼
	var registrationStatusSwiper = new Swiper(".registration-status-swiper .swiper-container", {
	    slidesPerView:'auto',
	    spaceBetween: 8,
        autoHeight : true,
        loop:false,
	    observer: true,
	    observeParents: true,
	    watchOverflow : true,
        navigation: {
		    nextEl: '.registration-status-swiper .swiper-button-next',
		    prevEl: '.registration-status-swiper .swiper-button-prev',
	    },
	    pagination: {
		    el: '.registration-status-swiper .swiper-pagination',
		    type: "bullets",
	    },
    }) ;
</script>