var CAREER = {
    $el: null,
    previewData: {
        "info": {
            "outerCareerCnt": "10년 10개월"
        },
        "outer": [
            {
                "cmpNm": "한국중견기업",
                "sdate": "2017-01-01",
                "edate": "2018-12-31",
                "agreeRate": "100",
                "careerYyCnt": "2",
                "careerMmCnt": "0",
                "deptNm": "경영지원팀",
                "jikweeNm": "사원",
                "jobNm": "채용/교육",
                "manageNm": "정규직",
                "retReason": "개인사유",
                "note": "동일 직무로 인해 100% 인정합니다.",
            },
            {
                "cmpNm": "이수헬스케어",
                "sdate": "2019-01-01",
                "edate": "2022-07-31",
                "agreeRate": "100",
                "careerYyCnt": "3",
                "careerMmCnt": "6",
                "deptNm": "인사팀",
                "jikweeNm": "대리",
                "jobNm": "근태",
                "manageNm": "정규직",
                "retReason": "휴식으로 인해 퇴사",
                "note": "특이사항 없음",
            },
            {
                "cmpNm": "한국오라클",
                "sdate": "2023-01-01",
                "edate": "2024-12-31",
                "agreeRate": "80",
                "careerYyCnt": "1",
                "careerMmCnt": "9",
                "deptNm": "인사팀",
                "jikweeNm": "대리",
                "jobNm": "총무",
                "manageNm": "정규직",
                "retReason": "개인사유",
                "note": "",
            }
        ],
        "inner": [
            {
                "tfOrgNm": "인사팀",
                "jikweeNm": "대리",
                "jobNm": "급여지원",
                "evalTxt": "C",
                "note": "적응을 힘들어 하여 팀 이동 신청",
            },
            {
                "tfOrgNm": "총무팀",
                "jikweeNm": "대리",
                "jobNm": "창고관리",
                "evalTxt": "-",
                "note": "",
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

        this.clearHtml($el);
        const defHtml = this.getDefaultHtml();
        $el.append(defHtml);

        this.$getCard().find("#ocTotCareer").text(data.info.outerCareerCnt);
        this.renderOuterCareer(data.outer);
        this.renderInnerCareer(data.inner);
        this.addEvent();
        this.activeTab();
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserCareer", "");
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
    renderOuterCareer: function(data) {
        const $list = this.$getOuterCareerList();
        if (data == null || data.length === 0) {
            const noDataHtml = this.getNoDataHtml();
            $list.append(noDataHtml);
            return;
        }

        $list.empty();

        for (const obj of data) {
            const isExistsFile = this.isExistsFile(obj.fileSeq);
            const html = this.getOuterCareerItemHtml(isExistsFile);
            $list.append(html);
            const $last = $list.children().last();
            $last.data("outer", obj);
            this.setOuterCareerData($last, obj);
            this.addOuterCareerEvent($last);
        }
    },
    renderInnerCareer: function(data) {
        const $list = this.$getInnerCareerList();
        if (data == null || data.length === 0) {
            const noDataHtml = this.getNoDataHtml();
            $list.append(noDataHtml);
            return;
        }

        $list.empty();

        for (const obj of data) {
            const html = this.getInnerCareerItemHtml();
            $list.append(html);
            const $last = $list.children().last();
            $last.data("inner", obj);
            this.setInnerCareerData($last, obj);
        }
    },
    getNoDataHtml: function() {
        return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
                    <i class="icon no_data"></i>
                    <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                </div>`;
    },
    getDefaultHtml: function() {
        return `<div class="card rounded-16 pa-24 bg-white" id="careerCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon send size-16"></i>
                            <p class="txt_title_xs sb txt_left">경력</p>
                        </div>
                    </div>
                    <div class="tab_container w-164 ma-auto mb-8">
                        <ul>
                            <li>
                                <button class="tab active" data-tab="outerCareer">
                                    사외경력
                                </button>
                            </li>
                            <li>
                                <button class="tab" data-tab="innerCareer">
                                    사내경력
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div class="tab_content active" id="outerCareerTabContent">
                        <div class="txt_body_m txt_secondary mb-8 d-flex gap-4">
                            <i class="mdi-ico txt_18">settings</i>
                            총 인정경력
                            <span class="sb txt_primary ocTotCareer">10년 10개월</span>
                        </div>
                        <div class="d-flex flex-col gap-12" id="outerCareerList">
                        </div>
                    </div>
                    <div class="tab_content" id="innerCareerTabContent">
                        <div class="d-flex flex-col gap-12" id="innerCareerList">
                        </div>
                    </div>
                </div>`;
    },
    getOuterCareerItemHtml: function(isFileExists) {
        let fileBtnHtml = "";
        if (isFileExists) {
            fileBtnHtml = `<i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18 btnFileDown">file_download</i>`;
        }
        return `<div class="card rounded-16 pa-16-20">
                    <div class="d-flex gap-16 align-center justify-between mb-8">
                        <div>
                            <p class="txt_title_xs sb">
                                <span class="ocCmpNm"></span>
                                <span class="txt_body_sm txt_tertiary ml-8 ocPeriod"></span>
                            </p>
                        </div>
                        <div class="d-flex gap-16 align-center">
                            <div class="d-flex gap-4 txt_body_sm">
                                <span class=" txt_secondary">인정비율(%)</span>
                                <span class="sb ocAgreeRate"></span>
                            </div>
                            <div class="d-flex gap-4 txt_body_sm">
                                <span class=" txt_secondary">인정경력</span>
                                <span class="sb ocAgreeCareer"></span>
                            </div>
                            ${fileBtnHtml}
                        </div>
                    </div>
                    <div class="line gray mb-12"></div>
                    <div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">부서</span>
                                <span class="sb ocDeptNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">직위</span>
                                <span class="sb ocJikweeNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">담당업무</span>
                                <span class="sb ocJobNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">고용형태</span>
                                <span class="sb ocManageNm"></span>
                            </div>
                        </div>
                        <div class="txt_body_sm mb-8">
                            <span class="txt_secondary">퇴직사유</span>
                            <span class="sb ml-4 ocRetReason"></span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">비고</span>
                            <span class="sb ml-4 ocNote"></span>
                        </div>
                    </div>
                </div>`;
    },
    setOuterCareerData: function($el, data) {
        $el.find(".ocCmpNm").text(this.getValue(data.cmpNm));
        $el.find(".ocPeriod").text(this.getValue(data.sdate) + "~" + this.getValue(data.edate));
        $el.find(".ocAgreeRate").text(this.getValue(data.agreeRate));
        $el.find(".ocAgreeCareer").text(this.getValue(data.careerYyCnt) + "년 " + this.getValue(data.careerMmCnt) + "개월");
        $el.find(".ocDeptNm").text(this.getValue(data.deptNm));
        $el.find(".ocJikweeNm").text(this.getValue(data.jikweeNm));
        $el.find(".ocJobNm").text(this.getValue(data.jobNm));
        $el.find(".ocManageNm").text(this.getValue(data.manageNm));
        $el.find(".ocRetReason").text(this.getValue(data.retReason));
        $el.find(".ocNote").text(this.getValue(data.note));
    },
    getInnerCareerItemHtml: function() {
        return `<div class="card rounded-16 pa-16-20">
                    <div class="d-flex gap-16 align-center justify-between mb-8">
                        <div>
                            <p class="txt_title_xs sb">
                                <span class="icTfOrgNm"></span>
                                <span class="txt_body_sm txt_tertiary ml-8 icPeriod"></span>
                            </p>
                        </div>
                    </div>
                    <div class="line gray mb-12"></div>
                    <div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">직위</span>
                                <span class="sb icJikweeNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">담당업무</span>
                                <span class="sb icJobNm"></span>
                            </div>
                        </div>
                        <div class="txt_body_sm mb-8">
                            <span class="txt_secondary">평가</span>
                            <span class="sb ml-4 icEvalTxt"></span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">비고</span>
                            <span class="sb ml-4 icNote"></span>
                        </div>
                    </div>
                </div>`;
    },
    setInnerCareerData: function($el, data) {
        $el.find(".icTfOrgNm").text(this.getValue(data.tfOrgNm));
        $el.find(".icJikweeNm").text(this.getValue(data.jikweeNm));
        $el.find(".icJobNm").text(this.getValue(data.jobNm));
        $el.find(".icEvalTxt").text(this.getValue(data.evalTxt));
        $el.find(".icNote").text(this.getValue(data.note));
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    addOuterCareerEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("outer")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    activeTab: function(tabType = "outerCareer") {
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
            CAREER.activeTab(tabType);
        })
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#careerCard");
    },
    $getOuterCareerList: function() {
        return this.$getCard().find("#outerCareerList");
    },
    $getInnerCareerList: function() {
        return this.$getCard().find("#innerCareerList");
    }
}