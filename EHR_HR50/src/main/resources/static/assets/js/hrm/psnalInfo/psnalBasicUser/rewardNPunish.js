var RWRDNPNSH = {
    $el: null,
    previewData: {
        "reward": [
            {
                "prizeNm": "1년 근속포상",
                "prizeYmd": "2025-02",
                "inOutNm": "대내",
                "orgNm": "인사팀",
                "jikgubNm": "3급",
                "jikchakNm": "팀원",
                "manageNm": "관리직",
                "prizeOfficeNm": "이수시스템",
                "prizeNo": "2025A02",
                "prizeMon": "100,000",
                "paymentYm": "2025-02",
                "prizeReason": "1년 근속"
            },
            {
                "prizeNm": "모범사원",
                "prizeYmd": "2025-04",
                "inOutNm": "대내",
                "orgNm": "총무팀",
                "jikgubNm": "3급",
                "jikchakNm": "팀원",
                "manageNm": "관리직",
                "prizeOfficeNm": "이수시스템",
                "prizeNo": "2025C04",
                "prizeMon": "500,000",
                "paymentYm": "2025-04",
                "prizeReason": "타의 모범이 됨"
            }
        ],
        "punish": [
            {
                "punishNm": "주의/경고",
                "punishYmd": "2025-02",
                "orgNm": "인사팀",
                "jikgubNm": "3급",
                "jikchakNm": "팀원",
                "manageNm": "관리직",
                "punishOfficeNm": "이수시스템",
                "auditOfficeNm": "이수시스템",
                "sdate": "2025-02-01",
                "edate": "2025-02-28",
                "punishNo": "2025P02",
                "punishReason": "고객과의 약속을 어김"
            }
        ]
    },
    /**
     * 항목 초기화
     * @param $el 부모 element
     * @param isPreview 예시 여부. true 일 경우 예시 데이터를 사용한다. 기본값 false.
     */
    init: async function($el, isPreview = false) {
        this.$el = $el;

        this.clearHtml($el);

        let data;
        if (isPreview) {
            data = this.previewData;
        } else {
            data = await this.getData();
        }
        if (data == null) return;

        const defHtml = this.getDefaultHtml();
        $el.append(defHtml);

        this.renderReward(data.reward);
        this.renderPunish(data.punish);
        this.addEvent();
        this.activeTab();
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserRewardAndPunish", "");
            if (data == null || data.isError) {
                if (data != null && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return null;
            }

            if (data && data.msg) {
                alert(data.msg);
                return null;
            }
            return data.map;
        } catch (ex) {
            console.error(ex);
            return null;
        }
    },
    clearHtml: function() {
        if (this.$getCard().length > 0) {
            this.$getCard().remove();
        }
    },
    getNoDataHtml: function() {
        return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
                    <i class="icon no_data"></i>
                    <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                </div>`;
    },
    getDefaultHtml: function() {
        return `<div class="card rounded-16 pa-24 bg-white" id="rewardNPunishCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon photo_spark size-16"></i>
                            <p class="txt_title_xs sb txt_left">상벌</p>
                        </div>
                    </div>
                    <div class="tab_container w-164 ma-auto mb-8">
                        <ul>
                            <li>
                                <button class="tab active" data-tab="reward">
                                    포상사항
                                </button>
                            </li>
                            <li>
                                <button class="tab" data-tab="punish">
                                    징계사항
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div class="tab_content active" id="rewardTabContent">
                        <div class="d-flex flex-col gap-12" id="rewardList">
                        </div>
                    </div>
                    <div class="tab_content" id="punishTabContent">
                        <div class="d-flex flex-col gap-12" id="punishList">
                        </div>
                    </div>
                </div>`;
    },
    getRewardItemHtml: function(isFileExists) {
        let fileBtnHtml = "";
        if (isFileExists) {
            fileBtnHtml = `<div class="btnFileDown">
                               <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                           </div>`;
        }
        return `<div class="card rounded-16 pa-16-20">
                    <div class="d-flex gap-16 align-center justify-between mb-8">
                        <div>
                            <p class="txt_title_xs sb">
                                <span class="rPrizeNm">
                                <span class="txt_body_sm txt_tertiary ml-8 rPrizeYmd"></span>
                            </p>
                        </div>
                        ${fileBtnHtml}
                    </div>
                    <div class="line gray mb-12"></div>
                    <div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="sb rInOutNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb rOrgNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb rJikgubNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb rJikchakNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb rManageNm"></span>
                            </div>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">포상기관</span>
                                <span class="sb rPrizeOfficeNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">포상번호</span>
                                <span class="sb rPrizeNo"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">포상금액</span>
                                <span class="sb rPrizeMon"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">지급년일</span>
                                <span class="sb rPaymentYm"></span>
                            </div>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">포상사유</span>
                                <span class="sb rPrizeReason"></span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },getPunishItemHtml: function(isFileExists) {
        let fileBtnHtml = "";
        if (isFileExists) {
            fileBtnHtml = `<div class="btnFileDown">
                               <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                           </div>`;
        }
        return `<div class="card rounded-16 pa-16-20">
                    <div class="d-flex gap-16 align-center justify-between mb-8">
                        <div>
                            <p class="txt_title_xs sb">
                                <span class="pPunishNm">
                                <span class="txt_body_sm txt_tertiary ml-8 pPunishYmd"></span>
                            </p>
                        </div>
                        ${fileBtnHtml}
                    </div>
                    <div class="line gray mb-12"></div>
                    <div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="sb pOrgNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb pJikgubNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb pJikchakNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb pManageNm"></span>
                            </div>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">징계기관</span>
                                <span class="sb pPunishOfficeNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">감사기관</span>
                                <span class="sb pAuditOfficeNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">징계시작일</span>
                                <span class="sb pSdate"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">징계종료일</span>
                                <span class="sb pEdate"></span>
                            </div>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">징계번호</span>
                                <span class="sb pPunishNo"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">징계사유</span>
                                <span class="sb pPunishReason"></span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setRewardData: function($el, data) {
        $el.find(".rPrizeNm").text(this.getValue(data.prizeNm));
        $el.find(".rPrizeYmd").text(this.getValue(data.prizeYmd));
        $el.find(".rInOutNm").text(this.getValue(data.inOutNm));
        $el.find(".rOrgNm").text(this.getValue(data.orgNm));
        $el.find(".rJikgubNm").text(this.getValue(data.jikgubNm));
        $el.find(".rJikchakNm").text(this.getValue(data.jikchakNm));
        $el.find(".rManageNm").text(this.getValue(data.manageNm));
        $el.find(".rPrizeOfficeNm").text(this.getValue(data.prizeOfficeNm));
        $el.find(".rPrizeNo").text(this.getValue(data.prizeNo));
        $el.find(".rPrizeMon").text(this.getValue(data.prizeMon));
        $el.find(".rPaymentYm").text(this.getValue(data.paymentYm));
        $el.find(".rPrizeReason").text(this.getValue(data.prizeReason));
    },
    setPunishData: function($el, data) {
        $el.find(".pPunishNm").text(this.getValue(data.punishNm));
        $el.find(".pPunishYmd").text(this.getValue(data.punishYmd));
        $el.find(".pOrgNm").text(this.getValue(data.orgNm));
        $el.find(".pJikgubNm").text(this.getValue(data.jikgubNm));
        $el.find(".pJikchakNm").text(this.getValue(data.jikchakNm));
        $el.find(".pManageNm").text(this.getValue(data.manageNm));
        $el.find(".pPunishOfficeNm").text(this.getValue(data.punishOfficeNm));
        $el.find(".pAuditOfficeNm").text(this.getValue(data.auditOfficeNm));
        $el.find(".pSdate").text(this.getValue(data.sdate));
        $el.find(".pEdate").text(this.getValue(data.edate));
        $el.find(".pPunishNo").text(this.getValue(data.punishNo));
        $el.find(".pPunishReason").text(this.getValue(data.punishReason));
    },
    addRewardEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("reward")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    addPunishEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("punish")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    renderReward: function(rewardData) {
        const $rewardList = this.$getRewardList();
        if (rewardData == null || rewardData.length === 0) {
            const noDataHtml = this.getNoDataHtml();
            $rewardList.append(noDataHtml);
            return;
        }

        $rewardList.empty();

        for (const obj of rewardData) {
            const isExistsFile = this.isExistsFile(obj.fileSeq);
            const html = this.getRewardItemHtml(isExistsFile);
            $rewardList.append(html);
            const $last = $rewardList.children().last();
            $last.data("reward", obj);
            this.setRewardData($last, obj);
            this.addRewardEvent($last);
        }
    },
    renderPunish: function(punishData) {
        const $punishList = this.$getPunishList();
        if (punishData == null || punishData.length === 0) {
            const noDataHtml = this.getNoDataHtml();
            $punishList.append(noDataHtml);
            return;
        }

        $punishList.empty();

        for (const obj of punishData) {
            const isExistsFile = this.isExistsFile(obj.fileSeq);
            const html = this.getPunishItemHtml(isExistsFile);
            $punishList.append(html);
            const $last = $punishList.children().last();
            $last.data("punish", obj);
            this.setPunishData($last, obj);
            this.addPunishEvent($last);
        }
    },
    activeTab: function(tabType = "reward") {
        const $tabList = this.$getCard().find(".tab_container");
        $tabList.find(".tab.active").removeClass("active");
        $tabList.find(".tab[data-tab=" + tabType + "]").addClass("active");

        $tabList.siblings(".tab_content.active").removeClass("active");
        $tabList.siblings(".tab_content#" + tabType + "TabContent").addClass("active");
    },
    addEvent: function() {
        this.$getCard().find(".tab_container .tab").on("click", function(e) {
            e.stopPropagation();
            const tabType = $(this).attr("data-tab");
            RWRDNPNSH.activeTab(tabType);
        })
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#rewardNPunishCard");
    },
    $getRewardList: function() {
        return this.$getCard().find("#rewardList");
    },
    $getPunishList: function() {
        return this.$getCard().find("#punishList");
    }
}