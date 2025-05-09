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
		});

        async function init() {
            const data = await getCardList();
            if (data == null) return;

            renderHrmBasicCards(data);
        }

        function renderHrmBasicCards(data) {
            const $cards = $("#basicAppCards");
            $cards.empty();

            console.log(data)

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
            console.log($el)
            $el.on("click", async function(e) {
                const applCd = $(this).data("data").applCd;
                const applNm = $(this).data("data").applNm;
                showApplLayer('A','','${ssnSabun}','${curSysYyyyMMdd}', applCd);
            })
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
            console.log(param)
            return (param.transType === "U" && param.empTable === "THRM100");
        }

        async function getCardList() {
            const data = ajaxCall("${ctx}/BenApplyUser.do?cmd=getBenAppCodeList", "", false).DATA;
            if (data == null || data.isError) {
                if (data != null && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return;
            }

            if (data.msg != null && data.msg) {
                alert(data.msg);
                return null;
            }
            return data;
        }

	</script>
</head>
<body class="bodywrap">
	<div class="ux_wrapper">
        <div class="txt_title_lg sb mb-32">복리후생신청서</div>
        <div class="contents">
            <div class="mb-32" id="basicApp">
                <p class="txt_title_sm sb mb-12 txt_secondary">복리후생</p>
                <div class="d-grid grid-cols-4 gap-16" id="basicAppCards"></div>
            </div>
        </div>
    </div>
</body>
</html>