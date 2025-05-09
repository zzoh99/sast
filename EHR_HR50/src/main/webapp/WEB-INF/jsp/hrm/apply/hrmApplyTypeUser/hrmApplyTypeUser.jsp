<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>인사기본(발령내역수정)</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

	<script type="text/javascript">
		$(function() {
            init();
            $("#imageChangeCard").on("click", function(e) {

                if(!isPopup()) {return;}

                var args = new Array(5);
                var auth    = "A"
                    , applSeq = ""
                    , applInSabun = "${ssnSabun}"
                    , applYmd = "${curSysYyyyMMdd}"
                    , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
                    , applCd  = "22"
                    , initFunc = 'initLayer';

                args["applStatusCd"] = "11";

                const p = {
                    searchApplCd: applCd,
                    searchApplSeq: applSeq,
                    adminYn: 'N',
                    authPg: auth,
                    searchSabun: applInSabun,
                    searchApplSabun: applInSabun,
                    searchApplYmd: applYmd
                };
                var approvalMgrLayer = new window.top.document.LayerModal({
                    id: 'approvalMgrLayer',
                    url: url,
                    parameters: p,
                    width: 800,
                    height: 815,
                    title: '재직증명(한글)',
                    trigger: [
                        {
                            name: 'approvalMgrLayerTrigger',
                            callback: function(rv) {
                                getReturnValue(rv);
                            }
                        }
                    ]
                });
                approvalMgrLayer.show();
            })
		});

        async function init() {
            const data = await getCardList();
            if (data == null) return;

            renderHrmBasicCards(data.basicApply);
            renderHrmEtcCards(data.etcApply);
        }

        function renderHrmBasicCards(data) {
            const $cards = $("#basicAppCards");
            $cards.empty();

            for (const obj of data) {
                const html = getCardHtml();
                $cards.append(html);
                const $last = $cards.children().last();
                $last.find(".icon").addClass(obj.icon);
                $last.find(".sb").text(obj.applNm);
                $last.data("data", obj);
                addHrmBasicCardEvent($last);
            }
        }

        function getCardHtml() {
            return `<div class="card rounded-16 pa-24 d-flex flex-col align-center gap-10 hover_bg">
                        <i class="icon size-24"></i>
                        <p class="txt_title_sm sb"></p>
                    </div>`;
        }

        function addHrmBasicCardEvent($el) {
            $el.on("click", async function(e) {
                const applCd = $(this).data("data").applCd;
                const applNm = $(this).data("data").applNm;
                const transType = $(this).data("data").transType;

                if (applCd === "PICTURE") {
                    if (await isValidImageChangeApp())
                        showPsnalImageChangeLayer();
                } else if (applCd === "SIGN") {
                    showPsnalSignChangeLayer();
                } else {
                    // if (await isValidHrmApply(applCd)) {
                        showHrmBasicApplyLayer(applCd, applNm, transType);
                    // }
                }
            })
        }

        async function isValidImageChangeApp() {
            const data = await callFetch("${ctx}/HrmApplyUser.do?cmd=getEmpPictureChangeMgrDupChk", "");
            if (data == null || data.isError) {
                if (data != null && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return false;
            }

            const dataCnt = data.DATA.cnt;
            if ( dataCnt > 0 ) {
                alert("신청건이 있습니다.\r\n승인 또는 반려 후에 신청하시기 바랍니다.");
                return false;
            }

            return true;
        }

        function showPsnalImageChangeLayer() {

            if(!isPopup()) {return;}

            const param = {"empTable": '', "eTableNm": '개인이미지', "transType": 'picture', "sabun": "${ssnSabun}", "name": "${ssnName}" };

            let layerModal = new window.top.document.LayerModal({
                id : 'empPictureChangeReqLayer'
                , url : '/Popup.do?cmd=viewEmpPictureChangeReqLayer&authPg=A'
                , parameters : param
                , width : 500
                , height : 650
                , title : '개인 이미지 수정 신청'
                , trigger :[
                    {
                        name : 'empPictureChangeReqTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        }

        function showPsnalSignChangeLayer() {

            if(!isPopup()) {return;}

            var args = {};
            args["sabun"] = "${ssnSabun}";
            args["name"] = "${ssnName}";

            let layerModal = new window.top.document.LayerModal({
                id : 'signRegLayer'
                , url : '/Popup.do?cmd=viewSignRegLayer'
                , parameters : args
                , width : 500
                , height : 650
                , title : '서명등록'
                , trigger :[
                    {
                        name : 'signRegTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        }

        async function isValidHrmApply(applCd) {
            const data = await callFetch("${ctx}/HrmApplyUser.do?cmd=getEmpPictureChangeMgrDupChk", "&empTable=" + applCd);
            if (data == null || data.isError) {
                if (data != null && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return false;
            }

            const dataCnt = data.DATA.cnt;
            if ( dataCnt > 0 ) {
                alert("기존 신청건이 있습니다.\r\n승인 또는 반려된 후에 신청하시기 바랍니다.");
                return false;
            }

            return true;
        }

        function showPsnalBasicChangeLayer(eTable, eTableNm, transType) {

            if(!isPopup()) {return;}

            const param = {"empTable": eTable, "eTableNm": eTableNm, "transType": transType, "sabun":"${ssnSabun}", "name":$("#name").val()};

            let layerModal = new window.top.document.LayerModal({
                id : 'signRegLayer'
                , url : '/Popup.do?cmd=viewEmpPictureChangeReqLayer&authPg=A'
                , parameters : param
                , width : 500
                , height : 650
                , title : '개인 이미지 수정 신청'
                , trigger :[
                    {
                        name : 'empPictureChangeReqTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        }

        function showHrmBasicApplyLayer(eTable, eTableNm, transType) {
            if(!isPopup()) {return;}

            let param = {"empTable": eTable, "eTableNm": eTableNm, "transType": transType, "sabun": "${ssnSabun}", "name": $("#name").val()};
            // if(eTable === "THRM124") {
            //     param.selectedValue = selectedValue;
            // }

            if (isNeedCheckPassword(param)) {
                // 비밀번호 체크가 필요한 신청이면 비밀번호 레이어팝업이 우선 표시됨.
                new window.top.document.LayerModal({
                    id : 'pwConLayer'
                    , url : '/Popup.do?cmd=pwConLayer'
                    , parameters : ""
                    , width : 500
                    , height : 300
                    , title : '비밀번호 확인'
                    , trigger :[
                        {
                            name : 'pwConLayerTrigger'
                            , callback : function(result){
                                if (result.result === "Y") {
                                    let layerModal = new window.top.document.LayerModal({
                                        id : 'empCommonChangeReqLayer'
                                        , url : '/Popup.do?cmd=viewEmpCommonChangeReqLayer&authPg=A'
                                        , parameters : param
                                        , width : 840
                                        , height : 650
                                        , title : eTableNm + ' 수정 신청'
                                        , trigger :[
                                            {
                                                name : 'empCommonChangeReqTrigger'
                                                , callback : function(result){
                                                }
                                            }
                                        ]
                                    });
                                    layerModal.show();
                                }
                            }
                        }
                    ]
                }).show();
            }else{
                let layerModal = new window.top.document.LayerModal({
                    id : 'empCommonChangeReqLayer'
                    , url : '/Popup.do?cmd=viewEmpCommonChangeReqLayer&authPg=A'
                    , parameters : param
                    , width : 840
                    , height : 650
                    , title : eTableNm + ' 수정 신청'
                    , trigger :[
                        {
                            name : 'empCommonChangeReqTrigger'
                            , callback : function(result){
                            }
                        }
                    ]
                });
                layerModal.show();
            }
        }

        //신청 팝업
        function showApplLayer(auth,seq,applInSabun,applYmd, applCd) {
            if(!isPopup()) {return;}

            if(auth == "") {
                alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.'/>");
                return;
            }
            if(applCd == "") {
                alert("<msg:txt mid='110450' mdef='신청종류를 선택해 주세요.'/>"); return;
            }

            var data = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppMap","searchApplCd="+applCd,false);
            //재직상태
            var statusdata = ajaxCall("${ctx}/TimeOffApp.do?cmd=getStatusCd", "searchSabun=" + applInSabun , false).DATA;
            const statusCd = statusdata.statusCd;
            if(statusCd == 'RA'){//퇴직
                alert("<msg:txt mid='202005200000026' mdef='퇴직 직원은 신청할 수 없습니다.'/>");
                return;
            }else{
                if(data != null && data.DATA != null) {
                    if(data.DATA.ordTypeCd == 'N'){//복직
                        if(statusCd != 'CA'){
                            alert("<msg:txt mid='202005210000064' mdef='휴직 직원인 경우만 복직신청할 수 있습니다.'/>");
                            return;
                        }
                    }
                }
            }

            var p = {
                searchApplCd: applCd
                , searchApplSeq: seq
                , adminYn: 'N'
                , authPg: auth
                , searchSabun: applInSabun
                , searchApplSabun: applInSabun
                , searchApplYmd: applYmd
                , etc01: 'Y'
            };
            var url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
            var initFunc = 'initLayer';

            gPRow = "";
            pGubun = "viewApplButton";
            var approvalMgrLayer = new window.top.document.LayerModal({
                id: 'approvalMgrLayer',
                url: url,
                parameters: p,
                width: 800,
                height: 815,
                title: ' ',
                trigger: [
                    {
                        name: 'approvalMgrLayerTrigger',
                        callback: function(rv) {
                            init();
                        }
                    }
                ]
            });
            approvalMgrLayer.show();
            //window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
        }

        /**
         * 비밀번호 확인이 필요한 신청 건
         * @param param 파라미터
         * @returns {boolean}
         */
        const isNeedCheckPassword = (param) => {
            return (param.transType === "U" && param.empTable === "THRM100");
        }

        function renderHrmEtcCards(data) {
            const $cards = $("#etcAppCards");
            $cards.empty();

            for (const obj of data) {
                const html = getCardHtml();
                $cards.append(html);
                const $last = $cards.children().last();
                $last.find("i.icon").addClass(obj.icon);
                $last.find(".sb").text(obj.applNm);
                $last.data("data", obj);
                $last.on("click", function() {
                    const applCd = $(this).data("data").applCd;
                    showApplLayer('A','','${ssnSabun}','${curSysYyyyMMdd}', applCd);
                });
            }
        }

        async function getCardList() {
            const data = await callFetch("/HrmApplyUser.do?cmd=getHrmApplyTypeUserList", "surl=" + encodeURIComponent(parent.$("#surl").val()));
            if (data == null || data.isError) {
                if (data != null && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return;
            }

            if (data.msg != null && data.msg) {
                alert(data.msg);
                return null;
            }
            return data.map;
        }

	</script>
</head>
<body class="bodywrap">
	<div class="ux_wrapper">
        <div class="txt_title_lg sb mb-32">인사신청서</div>
        <div class="contents">
            <div class="mb-32" id="basicApp">
                <p class="txt_title_sm sb mb-12 txt_secondary">인사기본</p>
                <div class="d-grid grid-cols-4 gap-16" id="basicAppCards"></div>
            </div>

            <div id="etcApp">
                <p class="txt_title_sm sb mb-12 txt_secondary">휴복직/퇴직</p>
                <div class="d-grid grid-cols-4 gap-16" id="etcAppCards"></div>
            </div>
        </div>
    </div>
</body>
</html>