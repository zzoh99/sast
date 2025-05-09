<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">
        var searchApplSeq    = "${searchApplSeq}";
        var adminYn          = "${adminYn}";
        var authPg           = "${authPg}";
        var searchSabun      = "${searchSabun}";
        var searchApplSabun  = "${searchApplSabun}";
        var searchApplInSabun= "${searchApplInSabun}";
        var searchApplYmd    = "${searchApplYmd}";
        var applStatusCd	 = "";
        var pGubun         = "";
        var gPRow = "";
        var codeLists;

        var perlAccChgAppDet = {
            accountTypeCodeHtml: "",
            bankCodeHtml: "",
            defaultHeight: 0, /* tab_content 를 제외한 기본 신청서 높이 */
            iframeHeight: 434, /* 신청상세 iframe 높이 */
            tab1IframeHeight: 160,
            tab2IframeHeight: 132,
            itemSeq: 1,
        }

        $(function() {
            init();
        });

        function init() {
            parent.iframeOnLoad(perlAccChgAppDet.iframeHeight);

            applStatusCd = parent.$("#applStatusCd").val();

            if (applStatusCd == "") {
                applStatusCd = "11";
            }

            addCommonEvents();
            initTab1();
            initTab2();
        }

        function $getActiveTab() {
            return $(".tab_content.active");
        }

        function getActiveTabId() {
            return $getActiveTab().attr("id");
        }

        function $getTab(tabId) {
            return $(".tab_content#" + tabId);
        }

        function initTab1() {
            perlAccChgAppDet.accountTypeCodeHtml = getAccountTypeCodeListHtml();
            perlAccChgAppDet.bankCodeHtml = getBankCodeListHtml();

            clearTab1AccountList();
            addTab1AccountItem();
            addTab1Events();
        }

        function getAccountTypeCodeListHtml() {
            const accountTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00180"), "선택");
            return accountTypeList[2];
        }

        function getBankCodeListHtml() {
            const bankCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H30001"), "선택");
            return bankCdList[2];
        }

        function clearTab1AccountList() {
            $getTab("tab1").find("#tab1AccountList").empty();
        }

        function addTab1AccountItem() {
            perlAccChgAppDet.tab1IframeHeight = perlAccChgAppDet.tab1IframeHeight + 264 + 20;
            perlAccChgAppDet.iframeHeight = perlAccChgAppDet.tab1IframeHeight;
            parent.iframeOnLoad(perlAccChgAppDet.tab1IframeHeight);
            const $list = $getTab("tab1").find("#tab1AccountList");
            const html = getTab1AccountItemHtml(perlAccChgAppDet.itemSeq);
            perlAccChgAppDet.itemSeq++;
            $list.append(html);
            const $last = $list.children().last();
            addTab1AccountItemEvent($last);
        }

        function getTab1AccountItemHtml(idx) {
            return `<div class="accountItem">
                        <div class="d-flex justify-end mb-4"><button class="btn outline" name="btnDelete">삭제</button></div>
                        <div class="input_form">
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">계좌구분</p>
                                </div>
                                <div class="label_content">
                                    <select class="custom_select" name="searchAccountType" id="searchAccountType" required>
                                        ${'${perlAccChgAppDet.accountTypeCodeHtml}'}
                                    </select>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">요청일자</p>
                                </div>
                                <div class="label_content">
                                    <div>
                                        <input type="text" id="searchReqDate${'${idx}'}" name="searchReqDate" class="date2" maxlength="7" autocomplete="off" placeholder="시작일자" required />
                                    </div>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">은행명</p>
                                </div>
                                <div class="label_content">
                                    <select class="custom_select" name="searchBankCd" required>
                                        ${'${perlAccChgAppDet.bankCodeHtml}'}
                                    </select>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">계좌번호</p>
                                </div>
                                <div class="label_content">
                                    <input type="text" name="searchAccountNo" class="input_text txt_right" placeholder="계좌번호를 입력해주세요" required />
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">예금주</p>
                                </div>
                                <div class="label_content">
                                    <input type="text" name="searchAccName" class="input_text txt_right" placeholder="예금주 성함을 작성해주세요" />
                                </div>
                            </div>
                        </div>
                    </div>`;
        }

        function addTab1AccountItemEvent($el) {
            $el.find("input[name=searchReqDate]").datepicker2();

            $el.find("button[name=btnDelete]").on("click", function(e) {
                e.stopPropagation();
                $(this).closest(".accountItem").remove();
                perlAccChgAppDet.tab1IframeHeight = perlAccChgAppDet.tab1IframeHeight - 264 - 20;
                perlAccChgAppDet.iframeHeight = perlAccChgAppDet.tab1IframeHeight;
                parent.iframeOnLoad(perlAccChgAppDet.tab1IframeHeight);
            })
        }

        function addTab1Events() {
            $getTab("tab1").find("button[name=btnAdd]").on("click", function(e) {
                e.stopPropagation();
                addTab1AccountItem();
            })
        }

        async function initTab2() {
            const data = await getTab2AccountInfo();
            renderTab2AccountList(data);
        }

        function clearTab2() {
            const $tab = $getTab("tab2");
            $tab.empty();
        }

        async function getTab2AccountInfo() {
            const param = "searchSabun=" + searchApplSabun;
            const data = await callFetch("${ctx}/PerlAccChgApp.do?cmd=getPerlAccChgAppDetCurrAccountList", param);
            if (data == null || data.isError) {
                if (data != null && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return null;
            }

            if (data.msg != null && data.msg !== "") {
                alert(data.msg);
                return null;
            } else
                return data.list;
        }

        function renderTab2AccountList(list) {

            clearTab2();

            const $tab = $getTab("tab2");
            if (list == null || list.length === 0) {
                const noItemHtml = getTab2NoAccountItemHtml();
                $tab.append(noItemHtml);
                perlAccChgAppDet.tab2IframeHeight = perlAccChgAppDet.defaultHeight + 132;
                return;
            } else {
                const listHtml = getTab2AccountListHtml();
                $tab.append(listHtml);
                perlAccChgAppDet.tab2IframeHeight = perlAccChgAppDet.defaultHeight + 18 + 12;
            }

            const $list = $tab.find("#tab2AccountList");
            for (const idx in list) {
                const html = getTab2AccountItemHtml(idx);
                $list.append(html);
                const $last = $list.children().last();
                setTab2AccountItem($last, list[idx]);

                perlAccChgAppDet.tab2IframeHeight = perlAccChgAppDet.tab2IframeHeight + 124 + 12;
            }
        }

        function getTab2AccountItemHtml(idx) {
            return `<div class="card rounded-12 pa-24 checkbox_card">
                        <div class="checkbox_wrap mb-16">
                            <input type="checkbox" class="form-checkbox" id="checkbox${'${idx}'}" name="isDelete" />
                            <label for="checkbox${'${idx}'}" class="txt_title_xs sb accAccountTypeNm"></label>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">시작/종료 일자</span>
                                <span class="sb accPeriod"></span>
                            </div>
                        </div>
                        <div class="label_text_group">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">은행명</span>
                                <span class="sb accBankNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">계좌번호</span>
                                <span class="sb accAccountNo"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">예금주</span>
                                <span class="sb accName">김이수</span>
                            </div>
                        </div>
                    </div>`;
        }

        function getTab2AccountListHtml() {
            return `<div class="d-flex flex-col gap-12 py-12" id="tab2AccountList">
                        <p class="txt_body_m txt_tertiary" id="tab2Title">• 삭제할 계좌를 선택 후 결재신청 해주세요</p>
                    </div>`;
        }

        function getTab2NoAccountItemHtml() {
            return `<div class="d-flex flex-col gap-12 justify-center align-center py-12">
                        <i class="icon no_list"></i>
                        <p class="txt_body_m txt_tertiary txt_center">
                            삭제할 계좌가 없습니다.
                            <br />
                            계좌를 추가해주세요.
                        </p>
                    </div>`;
        }

        function setTab2AccountItem($el, data) {
            $el.data("account", data);
            $el.find(".accAccountTypeNm").text(getValue(data.accountTypeNm));
            $el.find(".accPeriod").text(getValue(data.sdate) + "~" + getValue(data.edate));
            $el.find(".accBankNm").text(getValue(data.bankNm));
            $el.find(".accAccountNo").text(getValue(data.accountNo));
            $el.find(".accName").text(getValue(data.accName));
        }

        function getValue(val) {
            return (val == null || val === "") ? "-" : val;
        }

        function addCommonEvents() {

            // 기본 헤더 높이 구하기
            perlAccChgAppDet.defaultHeight =
                Array.from($(".bank_account_form").children(":not(.tab_content)"))
                    .reduce((acc, cur) => acc += Number($(cur).outerHeight(true)), 0);

            perlAccChgAppDet.tab1IframeHeight =
                perlAccChgAppDet.defaultHeight + $getTab("tab1").find("button[name=btnAdd]").parent().outerHeight(true);

            // 계좌 폼 내부 탭
            $(".bank_account_form .tab_container .tab").click(function () {
                const $container = $(this).closest(".tab_container");
                const $bankForm = $(this).closest(".bank_account_form");

                $container.find(".tab").removeClass("active");
                $(this).addClass("active");

                const tabId = $(this).data("tab");
                $bankForm.find(".tab_content").removeClass("active");
                $bankForm.find("#" + tabId).addClass("active");

                if (tabId === "tab1") {
                    parent.iframeOnLoad(perlAccChgAppDet.tab1IframeHeight);
                } else if (tabId === "tab2") {
                    parent.iframeOnLoad(perlAccChgAppDet.tab2IframeHeight);
                } else {
                    parent.iframeOnLoad(perlAccChgAppDet.iframeHeight);
                }
            })

            // 삭제 계좌 checkbox
            $(".form-checkbox").change(function () {
                $(this).closest(".checkbox_card").toggleClass("checked");
            })
        }

        /**
         * 임시저장 및 신청 시 호출
         * @param status 결재상태
         */
        async function setValue(status) {
            let returnValue = false;

            try {

                if (authPg === "R") {
                    return true;
                }

                // 항목 체크 리스트
                if ( !isValid() ) {
                    return false;
                }

                const param = getSaveParams();
                console.log("param", param);
                //저장
                // const data = ajaxTypeJson("${ctx}/PerlAccChgApp.do?cmd=savePerlAccChgAppDet", param, false);
                const data = await callFetch("${ctx}/PerlAccChgApp.do?cmd=savePerlAccChgAppDet", param, false);
                console.log("data", data);
                if (data.Result.Code < 1) {
                    alert(data.Result.Message);
                    returnValue = false;
                } else {
                    returnValue = true;
                }
            } catch(ex) {
                console.error(ex);
                alert("저장 시 오류가 발생하였습니다. 관리자에게 문의바랍니다.");
                return false;
            }

            return returnValue;
        }

        function isValid() {
            try {
                $getTab("tab1").find("#tab1AccountList")
                    .children()
                    .find("input, select")
                    .filter(function(idx, obj) {
                        return $(obj).is(":required");
                    })
                    .each(function(idx, obj) {
                        if ($(obj).val() == null || $(obj).val() === "") {
                            alert($(obj).closest(".input_form_item").find(".label p").text() + "(은)는 필수 입력해주시기 바랍니다.");
                            $(obj).focus();
                            throw new Error("");
                        }
                    })
            } catch(ex) {
                return false;
            }

            const tab1ListCnt = $getTab("tab1").find("#tab1AccountList").children().length;
            const tab2ListCnt = $getTab("tab2")
                .find("#tab2AccountList")
                .children()
                .filter(function(idx, obj) {
                    return $(obj).find("input[name=isDelete]").is(":checked");
                })
                .length;
            if (tab1ListCnt + tab2ListCnt === 0) {
                alert("계좌 추가 또는 삭제 중 한 건이라도 입력해주시기 바랍니다.");
                return false;
            }

            return true;
        }

        function getSaveParams() {
            let param = {
                "new": [],
                "cancel": [],
            };
            let seq = 1;

            $getTab("tab1").find("#tab1AccountList").children().each(function(idx, obj) {
                let newObj = {};
                newObj.applSeq = searchApplSeq;
                newObj.sabun = searchApplSabun;
                newObj.seq = seq;
                newObj.reqDate = $(obj).find("input[name=searchReqDate]").val().replace(/-/gi, "");
                newObj.accountType = $(obj).find("select[name=searchAccountType]").val();
                newObj.bankCd = $(obj).find("select[name=searchBankCd]").val();
                newObj.accountNo = $(obj).find("input[name=searchAccountNo]").val();
                newObj.accName = $(obj).find("input[name=searchAccName]").val();
                param.new.push(newObj);
                seq++;
            })

            $getTab("tab2")
                .find("#tab2AccountList")
                .children(".card")
                .filter(function(idx, obj) {
                    return $(obj).find("input[name=isDelete]").is(":checked");
                })
                .each(function(idx, obj) {
                    let cancelObj = {};
                    cancelObj.applSeq = searchApplSeq;
                    cancelObj.sabun = searchApplSabun;
                    cancelObj.seq = seq;
                    const data = $(obj).data("account");
                    cancelObj.reqDate = data.sdate.replace(/-/gi, "");
                    cancelObj.accountType = data.accountType;
                    cancelObj.bankCd = data.bankCd;
                    cancelObj.accountNo = data.accountNo;
                    cancelObj.accName = data.accName;
                    param.cancel.push(cancelObj);
                    seq++;
                })

            return param;
        }
    </script>
</head>
<body class="hidden">
    <div class="ux_wrapper">
        <div class="bank_account_form">
            <p class="txt_title_xs sb txt_left mb-12">신청내용</p>
            <div class="input_form mb-12">
                <div class="input_form_item">
                    <div class="label">
                        <p class="txt_body_sm txt_secondary">신청서 종류</p>
                    </div>
                    <div class="label_content">
                        <div class="tab_container w-full ma-auto">
                            <ul>
                                <li>
                                    <button class="tab active" data-tab="tab1">추가</button>
                                </li>
                                <li>
                                    <button class="tab" data-tab="tab2">삭제</button>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab_content active" id="tab1">
                <div class="d-flex flex-col gap-20" id="tab1AccountList">
                    <div class="accountItem">
                        <div class="d-flex justify-end mb-4"><button class="btn outline" name="btnDelete">삭제</button></div>
                        <div class="input_form">
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">계좌구분</p>
                                </div>
                                <div class="label_content">
                                    <select class="custom_select" name="searchAccountType" id="searchAccountType">
                                    </select>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">시작/종료일자</p>
                                </div>
                                <div class="label_content">
                                    <!-- 아래 img 태그는 지우시고 기존 개발에서 사용하시는대로 input.bbit-dp-input 에 .thin 클래스 추가하시면 됩니다. -->
                                    <div>
                                        <input type="text" id="searchSdate" name="searchSdate" class="date2" maxlength="7" autocomplete="off" placeholder="시작일자" />
                                    </div>
                                    <div>
                                        <input type="text" id="searchEdate" name="searchEdate" class="date2" maxlength="7" autocomplete="off" placeholder="종료일자" />
                                    </div>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">은행명</p>
                                </div>
                                <div class="label_content">
                                    <select class="custom_select" name="searchBankCd" id="searchBankCd">
                                        <option value="">선택</option>
                                    </select>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">계좌번호</p>
                                </div>
                                <div class="label_content">
                                    <input type="text" class="input_text txt_right" placeholder="계좌번호를 입력해주세요" />
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">예금주</p>
                                </div>
                                <div class="label_content">
                                    <input type="text" class="input_text txt_right" placeholder="예금주 성함을 작성해주세요" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--<div>
                        <div class="d-flex justify-end mb-4"><button class="btn outline">삭제</button></div>
                        <div class="input_form">
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">계좌구분</p>
                                </div>
                                <div class="label_content">
                                    <select class="custom_select" name="" id="">
                                        <option value="">선택</option>
                                        <option value="">선택</option>
                                        <option value="">선택</option>
                                        <option value="">선택</option>
                                    </select>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">시작/종료일자</p>
                                </div>
                                <div class="label_content">
                                    <div>
                                        <input type="text" id="searchYm1" name="tmpPayYmFrom" class="date2 bbit-dp-input" maxlength="7" autocomplete="off" placeholder="시작일자" /><img class="ui-datepicker-trigger" src="../assets/images/calendar.png" alt="" isshow="0" />
                                    </div>
                                    <div>
                                        <input type="text" id="searchYm2" name="tmpPayYmFrom" class="date2 bbit-dp-input" maxlength="7" autocomplete="off" placeholder="종료일자" /><img class="ui-datepicker-trigger" src="/common/orange/images/calendar.gif" alt="" isshow="0" />
                                    </div>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">은행명</p>
                                </div>
                                <div class="label_content">
                                    <select class="custom_select" name="" id="">
                                        <option value="">선택</option>
                                    </select>
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">계좌번호</p>
                                </div>
                                <div class="label_content">
                                    <input type="text" class="input_text txt_right" placeholder="계좌번호를 입력해주세요" />
                                </div>
                            </div>
                            <div class="input_form_item">
                                <div class="label">
                                    <p class="txt_body_sm txt_secondary">예금주</p>
                                </div>
                                <div class="label_content">
                                    <input type="text" class="input_text txt_right" placeholder="예금주 성함을 작성해주세요" />
                                </div>
                            </div>
                        </div>
                    </div>-->
                </div>

                <div class="d-flex justify-center mt-32">
                    <button class="btn m outline" name="btnAdd">
                        <i class="mdi-ico mr-2">add</i>
                        추가
                    </button>
                </div>
            </div>
            <div class="tab_content" id="tab2">
                <div class="d-flex flex-col gap-12 justify-center align-center py-12" style="display: none;" id="tab2NoAccountApp">
                    <i class="icon no_list"></i>
                    <p class="txt_body_m txt_tertiary txt_center">
                        삭제할 계좌가 없습니다.
                        <br />
                        계좌를 추가해주세요.
                    </p>
                </div>
                <!-- <div class="d-flex flex-col gap-12 py-12" style="display: none;" id="tab2AccountList">
                    <p class="txt_body_m txt_tertiary" id="tab2Title">• 삭제할 계좌를 선택 후 결재신청 해주세요</p>
                    <div class="card rounded-12 pa-24 checkbox_card">
                        <div class="checkbox_wrap mb-16">
                            <input type="checkbox" class="form-checkbox" id="checkbox1" name="" />
                            <label for="checkbox1" class="txt_title_xs sb">급여계좌</label>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">시작/종료 일자</span>
                                <span class="sb">2020-01-01~2024-12-31</span>
                            </div>
                        </div>
                        <div class="label_text_group">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">은행명</span>
                                <span class="sb">신한은행</span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">계좌번호</span>
                                <span class="sb">123-45645-789918</span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">예금주</span>
                                <span class="sb">김이수</span>
                            </div>
                        </div>
                    </div>

                    <div class="card rounded-12 pa-24 checkbox_card">
                        <div class="checkbox_wrap mb-16">
                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                            <label for="checkbox1" class="txt_title_xs sb">급여계좌</label>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">시작/종료 일자</span>
                                <span class="sb">2020-01-01~2024-12-31</span>
                            </div>
                        </div>
                        <div class="label_text_group">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">은행명</span>
                                <span class="sb">신한은행</span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">계좌번호</span>
                                <span class="sb">123-45645-789918</span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">예금주</span>
                                <span class="sb">김이수</span>
                            </div>
                        </div>
                    </div>
                </div> -->
            </div>
        </div>
    </div>
</body>
</html>
