<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%--<!-- css -->--%>
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
    var sSabun = "";
    $(function () {

        $("#coaYmd").datepicker2();

        const modal = window.top.document.LayerModalUtility.getModal('coachingLayer');
        var args = modal.parameters;
        $("#searchAppSabun", "#coachingLayerForm").val(args.searchAppSabun);
        $("#searchAppraisalCd", "#coachingLayerForm").val(args.searchAppraisalCd);
        $("#searchAppSeqCd", "#coachingLayerForm").val(args.searchAppSeqCd);
        $("#searchTitle", "#coachingLayerForm").val(args.searchTitle);

        createIBSheet3(document.getElementById('coachingLayerSht1-wrap'), "coachingLayerSht1", "0px", "0px", "${ssnLocaleCd}");
        createIBSheet3(document.getElementById('coachingLayerSht2-wrap'), "coachingLayerSht2", "100%", "100%", "${ssnLocaleCd}");

        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"차수",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCdNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"성명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"사번",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"소속",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

            {Header:"입사일",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"직위명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"직급명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"직책명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"직무명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"직급년차",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubYeuncha",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"평가ID",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"평가소속",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"평가차수",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
        ]; IBS_InitSheet(coachingLayerSht1, initdata);coachingLayerSht1.SetEditable(0);coachingLayerSht1.SetVisible(true);coachingLayerSht1.SetCountPosition(4);
        coachingLayerSht1.SetUnicodeByte(3);
        $("#coachingLayerSht1-wrap").hide();
        
        initdata.Cols = [
            {Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
            {Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"세부\n내역", Type:"Image",       Hidden:1,   Width:30,   Align:"Center", ColMerge:0, SaveName:"ibsImage",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"차수",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCdNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"Coach",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appName",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"날짜",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"coaYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10	},
            {Header:"장소",		Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"coaPlace",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
            {Header:"내용",		Type:"Text",		Hidden:0,	Width:400,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1333, Wrap:1, MultiLineText:1  },

            {Header:"수정가능여부",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"editable",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"평가ID",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"평가소속",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"평가차수",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"평가사번",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
        ]; IBS_InitSheet(coachingLayerSht2, initdata);coachingLayerSht2.SetEditable(true);coachingLayerSht2.SetVisible(true);coachingLayerSht2.SetCountPosition(4);
        coachingLayerSht2.SetUnicodeByte(3);
        coachingLayerSht2.SetImageList(0,"/common/images/icon/icon_popup.png");
        coachingLayerSht2.SetDataLinkMouse("ibsImage",true);
        coachingLayerSht2.SetEditEnterBehavior("newline");

        $(window).smartresize(sheetResize); sheetInit();
        
        initEvent();
        $(".target-link:first").click();

        doAction1('Search');
    });

    function initEvent() {
        $(".target-link").click(function(e){
            e.preventDefault();
            let target = $(this).attr("href");

            $(".target-content").hide();
            $(target).show();

            $('.target-link').find('.box').removeClass('active');
            $(this).find('.box').addClass('active');
        });

        $(".tab-link").click(function(e){
            e.preventDefault();
            let target = $(this).attr("href");

            $(".tabs-content").hide();
            $(target).show();
        });

        // open history
        $('[data-snb]').on('click',function(e){
            e.preventDefault() , e.stopPropagation() ;
            var dataSnb = $(this).data('snb'),
                dataTg = $(this).data('target');

            if (dataSnb == 'menu') {
                $('[data-target="'+dataTg+'"]').addClass('active').siblings().removeClass('active') ;
                $(dataTg).addClass('active').siblings().removeClass('active') ;
            }
        });

        //close history
        $('.folding').on('click',function(e){
            $('[data-snb="menu"]').removeClass('active');
            $('[class^="history-"]').removeClass('active');
        });
    }

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                coachingLayerSht1.DoSearch( "${ctx}/EvaMain.do?cmd=getAppCoachingAprList1", $("#coachingLayerForm").serialize() ); break;
        }
    }
    
    // 조회 후 에러 메시지
    function coachingLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if (Msg != "")	alert(Msg);

            var sSabunRow = '';
            var searchAppSeqCd = $("#searchAppSeqCd", "#coachingLayerForm").val();
            var orgCd = '', html = '';
            for(var i = coachingLayerSht1.HeaderRows(); i < coachingLayerSht1.RowCount()+coachingLayerSht1.HeaderRows() ; i++) {

                let appOrgCd = coachingLayerSht1.GetCellValue(i, "appOrgCd");
                if(i === coachingLayerSht1.RowCount()+coachingLayerSht1.HeaderRows()-1) {
                    html += '</div>';
                }

                if(orgCd !== appOrgCd) {
                    if(i !== coachingLayerSht1.HeaderRows()) {
                        html += '</div>';
                    }

                    let appOrgNm = coachingLayerSht1.GetCellValue(i, "appOrgNm");
                    html += `<h4 class="h4 mr-1 d-inline-block">${'${appOrgNm}'}</h4>
                            <div class="box p-0 flex-column mt-2">`;

                    // 초기화
                    orgCd = appOrgCd;
                }

                var statusCd = coachingLayerSht1.GetCellValue(i, "statusCd");
                let sabun = coachingLayerSht1.GetCellValue(i, "sabun");
                // 선택한 사번으로 자동 조회하기 위한 sSabunRow 값 구하기
                sSabunRow = sSabun === sabun ? i : sSabunRow;

                let datetime = new Date().getTime();
                let imageUrl = '/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + coachingLayerSht1.GetCellValue(i, "sabun") + '&t=' + datetime;
                let name = coachingLayerSht1.GetCellValue(i, "name");
                let jikweeNm = coachingLayerSht1.GetCellValue(i, "jikweeNm");
                let jobNm = coachingLayerSht1.GetCellValue(i, "jobNm");
                let statusNm = coachingLayerSht1.GetCellValue(i, "statusNm");
                let statusClass = 'green';
                if(statusCd === '11') {
                    statusClass = 'gray';
                } else if (Number(searchAppSeqCd)+1+'1' === statusCd) {
                    statusClass = 'blue';
                }
                html += `<div id="coachCard${'${sabun}'}" name="coachCard" class="box box-border pointer" onclick="searchCoaching(${'${i}'}); activeCard(this); ">
                            <p class="thumb mr-0"><img src="${'${imageUrl}'}"></p>
                            <div class="d-flex flex-column">
                                <div class="d-inline-block">
                                    <span class="name">${'${name}'}</span>
                                    <span class="caption-sm text-boulder">${'${jikweeNm}'}</span>
                                </div>
                            </div>
                        </div>`
            }
            $("#coachOrgSabunWrap").html(html);

            if(sSabunRow !== '') {
                searchCoaching(sSabunRow)
                activeCard($("#coachCard"+sSabun).get(0))
            } else if(coachingLayerSht1.RowCount() > 0) {
                searchCoaching(coachingLayerSht1.HeaderRows());
                activeCard($("#coachCard"+coachingLayerSht1.GetCellValue(coachingLayerSht1.HeaderRows(), 'sabun')).get(0))
            }

            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    function doAction2(sAction) {
        switch (sAction) {
            case "Search":
                var Row = coachingLayerSht1.GetSelectRow();
                coachingLayerSht2.DoSearch( "${ctx}/EvaMain.do?cmd=getAppCoachingAprList2", $("#coachingLayerForm").serialize() ); break;
            case "Save":
                if($("#searchEvaSabun", "#coachingLayerForm").val() === '') {
                    alert("평가 대상자를 선택해 주세요");
                    return;
                }
                if(coachingLayerSht2.FindStatusRow("I") != ""){
                    if(!dupChk(coachingLayerSht2,"appraisalCd|sabun|appOrgCd|appSeqCd|appSabun|coaYmd", true, true)){break;}
                }
                IBS_SaveName(document.coachingLayerForm,coachingLayerSht2);
                coachingLayerSht2.DoSave( "${ctx}/EvaMain.do?cmd=saveAppCoachingApr", $("#coachingLayerForm").serialize()); break;
            case "Insert":
                var Row = coachingLayerSht2.DataInsert(0);
                coachingLayerSht2.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
                coachingLayerSht2.SetCellValue(Row, "sabun", $("#searchEvaSabun").val());
                coachingLayerSht2.SetCellValue(Row, "appSabun", $("#searchAppSabun").val());
                coachingLayerSht2.SetCellValue(Row, "appOrgCd", $("#searchAppOrgCd").val());
                coachingLayerSht2.SetCellValue(Row, "appSeqCd", $("#searchAppSeqCd").val());
                coachingLayerSht2.SetSelectRow(Row);
                break;
        }
    }

    // 조회 후 에러 메시지
    function coachingLayerSht2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function coachingLayerSht2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try{
            if(Msg != ""){
                alert(Msg);
            }
            if ( Code != -1 ) doAction2("Search");
        }catch(ex){
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    // 평가대상자 정보 세팅
    function setAppSabunInfo() {
        const data = ajaxCall('/EvaMain.do?cmd=getAppSabunMap', $("#coachingLayerForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined') {
            $("#title").text(data.title);
            let datetime = new Date().getTime();
            let imageUrl = '/EmpPhotoOut.do?enterCd=' + data.enterCd + '&searchKeyword=' + data.sabun + '&t=' + datetime;
            $('#sabunImg').attr('src', imageUrl);
            $("#name").text(data.name);
            $("#jikweeNm").text(data.jikweeNm);
            $("#appOrgNm").text(data.appOrgNm);
            $("#jobNm").text(data.jobNm);
        }
    }

    function searchCoaching(Row) {
        try {
            sSabun = coachingLayerSht1.GetCellValue(Row, "sabun");

            $("#searchEvaSabun", "#coachingLayerForm").val(coachingLayerSht1.GetCellValue(Row, "sabun"))
            $("#searchAppOrgCd", "#coachingLayerForm").val(coachingLayerSht1.GetCellValue(Row, "appOrgCd"))

            setAppSabunInfo();
            doAction2("Search");

        } catch (ex) {
            alert("[sheet1] OnSelectCell Event Error : " + ex);
        }
    }

    // 선택한 카드의 CSS 변경
    function activeCard(obj) {
        $('div[name="coachCard"]').removeClass('active');
        $(obj).addClass('active');
    }

</script>
<form name="coachingLayerForm" id="coachingLayerForm" method="post">
    <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
    <input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value=""/>
    <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value=""/>
    <input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
    <input type="hidden" id="searchTitle" name="searchTitle" value=""/>
    <input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value=""/>
    <input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value=""/>
    <div class="hr-container target-modal p-0 large">
        <div class="modal-content border-0">
            <div class="modal-body p-0">
                <div class="d-flex gap-20">
                    <div class="line position-relative">
                        <div class="scroll">
                            <div id="coachOrgSabunWrap" class="current-situation-list"></div>
                        </div>
                    </div>
                    <div id="coachingLayerSht1-wrap" class="hide"></div>
                    <div class="row flex-grow-1 sidebar-line">
                        <div class="col scroll target-content" id="target-1">
                            <div class="sub-title-wrap">
                                <div class="d-flex align-items-center">
                                    <h3 id="title" class="h2 mr-2"></h3>
                                </div>
                            </div>
                            <dl class="d-flex">
                                <dt class="profile">
                                    <p class="thumb"><img id="sabunImg"></p>
                                </dt>
                                <dd>
                                    <p id="name" class="name"><span id="jikweeNm" class="ml-2"></span></p>
                                    <p>부서명</p>
                                </dd>
                                <dd>
                                    <span>평가조직</span>
                                    <p id="appOrgNm" class="font-weight-bold"></p>
                                </dd>
                                <dd>
                                    <span>직무</span>
                                    <p id="jobNm" class="font-weight-bold"></p>
                                </dd>
                            </dl>
                            <div class="outer">
                                <div class="sheet_title">
                                    <ul>
                                        <li id="txt" class="txt">Coaching 내역</li>
                                        <li class="btn">
                                            <a href="javascript:doAction2('Insert')"		class="btn outline-gray"><tit:txt mid='104267' mdef='입력'/></a>
                                            <a href="javascript:doAction2('Save')"			id="btnSave" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div id="coachingLayerSht2-wrap"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>


