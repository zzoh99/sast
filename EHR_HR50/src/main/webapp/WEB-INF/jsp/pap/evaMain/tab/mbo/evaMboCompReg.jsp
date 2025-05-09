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

    var sRow;
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
        // 가중치 항목 숫자만 입력 가능하도록 함.
        $("#appRate").on("keyup", function(event) {
            makeNumber(this, 'A');
        });

        // evaMboCompRegSht1 init
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"mainAppTypeNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"<sht:txt mid='competencyNm' mdef='역량명'/>",		Type:"Popup",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",	Hidden:0,	Width:550,	Align:"Left",	ColMerge:1,	SaveName:"memo",			KeyField:0,	UpdateEdit:0,	InsertEdit:0, MultiLineText:1, Wrap:1  },
            {Header:"평가척도",		Type:"Text",	Hidden:1,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"gmeasureMemo",	KeyField:0,	UpdateEdit:0,	InsertEdit:0, MultiLineText:1, Wrap:1  },
            {Header:"<sht:txt mid='appRate' mdef='반영\n비율'/>",	Type:"Int",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appRate",			KeyField:0,	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"<sht:txt mid='compDevPlan' mdef='역량개발계획'/>",	Type:"Text",	Hidden:1,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"compDevPlan",		KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000, MultiLineText:1, Wrap:1 },
            {Header:"지원요청사항",	Type:"Text",	Hidden:1,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"reqSupportMemo",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000, MultiLineText:1, Wrap:1 },
            {Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"filePop",	Sort:0, Cursor:"Pointer" },
            {Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq"},

            {Header:"<sht:txt mid='appraisalCd' mdef='평가ID'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
            {Header:"<sht:txt mid='appSabunV6' mdef='사원번호'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
            {Header:"<sht:txt mid='appOrgCd' mdef='평가소속'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
            {Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"competencyCd"},
            {Header:"<sht:txt mid='mkGubunCd' mdef='생성구분코드'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd"}
        ]; IBS_InitSheet(evaMboCompRegSht1, initdata);evaMboCompRegSht1.SetEditable("${editable}");evaMboCompRegSht1.SetVisible(true);evaMboCompRegSht1.SetCountPosition(4);evaMboCompRegSht1.SetUnicodeByte(3);

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    <!-- evaMboCompRegSht1 Script -->
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                evaMboCompRegSht1.DoSearch( "${ctx}/EvaMain.do?cmd=getMboTargetRegList2", $("#evaMboCompRegForm").serialize() );
                break;
            case "Save":
                setFormToSheet();
                if(!dupChk(evaMboCompRegSht1,"appraisalCd|sabun|appOrgCd|competencyCd", true, true)){break;}
                IBS_SaveName(document.evaMboCompRegForm,evaMboCompRegSht1);
                evaMboCompRegSht1.DoSave( "${ctx}/EvaMain.do?cmd=saveMboTargetReg2", $("#evaMboCompRegForm").serialize());
                break;
            case "Insert":
                var Row = evaMboCompRegSht1.DataInsert(0);
                evaMboCompRegSht1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
                evaMboCompRegSht1.SetCellValue(Row, "appOrgCd", $("#searchAppOrgCd").val());
                evaMboCompRegSht1.SetCellValue(Row, "sabun", $("#searchEvaSabun").val());
                evaMboCompRegSht1.SetCellValue(Row, "mkGubunCd", "U");
                evaMboCompRegSht1.SetSelectRow(Row);
                clearForm();
                makeCard();
                showMboCompetency(Row);
                break;
            case "Delete" :
                evaMboCompRegSht1.SetCellValue(sRow, "sDelete", "1");

                if(evaMboCompRegSht1.FindStatusRow("D") === '') {
                    // 최초 입력한 데이터를 삭제하는 경우, card만 새로 생성해준다
                    makeCard();
                    if(evaMboCompRegSht1.GetDataFirstRow() > 0)
                        sheetToForm(evaMboCompRegSht1.GetDataFirstRow());
                } else {
                    doAction1('Save');
                }
                break;
        }
        return true;
    }

    // 조회 후 에러 메시지
    function evaMboCompRegSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            makeCard();

            if(evaMboCompRegSht1.GetDataFirstRow() > 0) {
                sheetToForm(evaMboCompRegSht1.GetDataFirstRow());
            } else {
                // 편집 불가 케이스
                if( ($("#searchAppStatusCd").val() === '11' || $("#searchAppStatusCd").val() === '23' || $("#searchAppStatusCd").val() === '33' || $("#searchAppStatusCd").val() === '43' )
                    && editYn != 'N') {
                    $("#btnWrap1").show();
                    $("#appRate", "#evaMboCompRegForm").attr('readonly', false);
                }
            }
            // 자동생성 ROW 인 경우 삭제 불가
            for( var i=evaMboCompRegSht1.HeaderRows(); i<=evaMboCompRegSht1.LastRow(); i++) {
                if ( evaMboCompRegSht1.GetCellValue(i, "mkGubunCd") == "S" ) {
                    evaMboCompRegSht1.SetCellEditable(i, "sDelete", 0);
                    evaMboCompRegSht1.SetCellEditable(i, "appRate", 0);
                }
            }

            sheetResize();
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function evaMboCompRegSht1_OnSaveEnd(Code, Msg) {
        try{
            if(Msg != "") {
                alert(Msg);
            }
            if ( Code != "-1" ) {
                doAction1('Search');
            }
        } catch(ex){
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    function evaMboCompRegSht1_OnPopupClick(Row, Col){
        try{
            if( evaMboCompRegSht1.ColSaveName(Col) == "competencyNm" ) {
                showMboCompetency(Row);
            }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

    function makeCard() {
        let html = '';
        let weightSum = 0;
        for(let i=evaMboCompRegSht1.HeaderRows(); i<=evaMboCompRegSht1.LastRow(); i++) {
            let isActive = i === evaMboCompRegSht1.HeaderRows() ? 'active' : ''

            weightSum += Number(evaMboCompRegSht1.GetCellValue(i, "appRate"));

            html +=
                `<div class="swiper-slide">
                        <a class="tab-link" href="javascript:sheetToForm(${'${i}'}); activeCard('goalCard${'${i}'}');">
                            <div id="goalCard${'${i}'}" name="goalCard" class="box box-border p-0 flex-column ${'${isActive}'}">
                                <div class="cate">
                                    <span class="badge green">`+ evaMboCompRegSht1.GetCellValue(i, "mainAppTypeNm") +`</span>
                                    <span class="percent">`+ evaMboCompRegSht1.GetCellValue(i, "appRate") +`%</span>
                                </div>
                                <p>`+ evaMboCompRegSht1.GetCellValue(i, "competencyNm") +`</p>
                            </div>
                        </a>
                    </div>`
        }
        $("#mboCardList").html(html);
        $("#weightSum").text(weightSum+"%");
    }
    
    // 선택한 카드의 CSS 변경
    function activeCard(cardId) {
        $('div[name="goalCard"]').removeClass('active');
        $("#"+cardId).addClass('active');
    }

    // 시트 정보를 폼에 셋팅
    function sheetToForm(Row){
        try {
            sRow = Row;
            evaMboCompRegSht1.SetSelectRow(Row);

            // 상세내용
            $("#mainAppTypeNm", "#evaMboCompRegForm").val(evaMboCompRegSht1.GetCellValue(Row, 'mainAppTypeNm'));
            $("#appRate", "#evaMboCompRegForm").val(evaMboCompRegSht1.GetCellValue(Row, 'appRate'));
            $("#competencyNm", "#evaMboCompRegForm").val(evaMboCompRegSht1.GetCellValue(Row, 'competencyNm'));
            $("#memo", "#evaMboCompRegForm").val(evaMboCompRegSht1.GetCellValue(Row, 'memo'));

            // 편집 불가 케이스
            if( ($("#searchAppStatusCd").val() !== '11' && $("#searchAppStatusCd").val() !== '23' && $("#searchAppStatusCd").val() !== '33' && $("#searchAppStatusCd").val() !== '43' )
                || editYn == 'N') {
                $("#btnWrap1").hide();
                $("#appRate", "#evaMboCompRegForm").attr('readonly', true);
            } else {
                $("#btnWrap1").show();
                // 자동생성 ROW 인 경우 수정, 삭제 불가
                if(evaMboCompRegSht1.GetCellValue(Row, "mkGubunCd") == "S" ) {
                    $("#btnDel").hide()
                    $("#btnSave").hide()
                    $("#appRate", "#evaMboCompRegForm").attr('readonly', true);
                } else {
                    $("#btnDel").show()
                    $("#btnSave").show()
                    $("#appRate", "#evaMboCompRegForm").attr('readonly', false)
                }
            }
        } catch (ex) {
            alert("sheetToForm() Script Error : " + ex);
        }
    }

    // 폼 정보를 시트에 세팅
    function setFormToSheet() {
        let row = evaMboCompRegSht1.GetSelectRow();
        if (row === -1) {
            doAction1("Insert");
            row = evaMboCompRegSht1.GetSelectRow();
        }
        evaMboCompRegSht1.SetCellValue(row,"appRate", $("#appRate").val());
        evaMboCompRegSht1.SetCellValue(row,"competencyNm",$("#competencyNm").val());

    }

    function clearForm() {
        // 폼 안의 모든 입력 필드, 체크박스, 라디오 버튼, 선택된 옵션 초기화
        $('#evaMboCompRegForm').find('input[type="text"], input[type="password"], input[type="email"], input[type="number"], input[type="date"], textarea').val('');
        $('#evaMboCompRegForm').find('input[type="checkbox"], input[type="radio"]').prop('checked', false);
        $('#evaMboCompRegForm').find('select').prop('selectedIndex', 0); // 첫 번째 옵션 선택
    }
    
    function showMboCompetency(Row) {
        var args	= {};

        sRow = Row;

        var layer1 = new window.top.document.LayerModal({
            id : 'mboTargetRegPopCompetencyLayer'
            , url : "${ctx}/EvaMain.do?cmd=viewMboTargetRegPopCompetency"
            , parameters: args
            , width : 740
            , height : 520
            , top : '50vh'
            , left : '50vw'
            , title : "역량항목"
            , trigger :[
                {
                    name : 'mboTargetRegPopCompetencyTrigger'
                    , callback : function(rv){
                        var paramName = ["orderSeq"
                            ,"competencyNm"
                            ,"competencyCd"
                            ,"mainAppTypeNm"
                            ,"gmeasureMemo"
                            ,"memo"
                        ];

                        for (var i=0; i<paramName.length; i++) {
                            evaMboCompRegSht1.SetCellValue(sRow, paramName[i], rv[paramName[i]]);
                        }
                        sheetToForm(sRow);
                    }
                }
            ]
        });
        layer1.show();
    }
</script>

<div class="hr-container target-modal p-0">
    <form id="evaMboCompRegForm" name="evaMboCompRegForm">
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
                        <a href="javascript:doAction1('Insert')"		class="btn soft"><tit:txt mid='104267' mdef='신규입력'/></a>
                        <a href="javascript:doAction1('Delete')"		id="btnDel" class="btn soft"><tit:txt mid='104476' mdef='삭제'/></a>
                        <a href="javascript:doAction1('Save')"			id="btnSave" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
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
                    <th><sup>*</sup>가중치</th>
                    <td class="text-left"><input type="text" id="appRate" name="appRate" class="inputbox sm" maxlength="3"></td>
                </tr>
                <tr>
                    <th><sup>*</sup>구분</th>
                    <td class="text-left" colspan="3">
                        <input type="text" id="mainAppTypeNm" name="mainAppTypeNm" class="inputbox mw-100" value="" readonly>
                    </td>
                </tr>
                <tr>
                    <th><sup>*</sup>역량명</th>
                    <td class="text-left" colspan="3">
                        <input type="text" id="competencyNm" name="competencyNm" class="inputbox mw-100" value="" readonly>
                    </td>
                </tr>
                <tr>
                    <th><sup>*</sup>개요</th>
                    <td class="text-left" colspan="3"><textarea name="memo" id="memo" class="w-100" rows="4" disabled></textarea></td>
                </tr>
                </tbody>
            </table>
        </div>
    </form>
    <!-- evaMboCompRegSht1 -->
    <div class="hide">
        <script type="text/javascript">createIBSheet("evaMboCompRegSht1", "100%", "100%","kr"); </script>
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