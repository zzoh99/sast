var EDUCATION = {
    $el: null,
    previewData: {
        "totPage": 1,
        "list": [
            {
                "eduCourseNm": "2024 귀속 연말정산 교육",
                "eduSYmd": "2025-01-16",
                "eduEYmd": "2025-01-17",
                "eduBranchNm": "필수교육",
                "eduBranchClassNm": "green",
                "inOutTypeNm": "사내",
                "eduMBranchNm": "",
                "eduMethodNm": "오프라인",
                "realExpenseMon": "",
                "laborReturnYn": "NO",
                "eduConfirmType": "인정",
                "eduOrgNm": "이수시스템",
            },
            {
                "eduCourseNm": "2025년 법정필수교육(직장내 괴롭힘)",
                "eduSYmd": "2025-02-14",
                "eduEYmd": "2025-02-18",
                "eduBranchNm": "필수교육",
                "eduBranchClassNm": "green",
                "inOutTypeNm": "사내",
                "eduMBranchNm": "",
                "eduMethodNm": "오프라인",
                "realExpenseMon": "",
                "laborReturnYn": "NO",
                "eduConfirmType": "인정",
                "eduOrgNm": "이수시스템",
            },
            {
                "eduCourseNm": "인사/노무 총괄",
                "eduSYmd": "2025-03-15",
                "eduEYmd": "2025-03-17",
                "eduBranchNm": "특별교육",
                "eduBranchClassNm": "",
                "inOutTypeNm": "사외",
                "eduMBranchNm": "",
                "eduMethodNm": "오프라인",
                "realExpenseMon": "",
                "laborReturnYn": "NO",
                "eduConfirmType": "인정",
                "eduOrgNm": "고용노동부",
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
        const defHtml = this.getDefaultHtml();
        $el.append(defHtml);

        let data;
        if (isPreview) {
            data = this.previewData;
        } else {
            data = await this.getData();
        }
        if (data == null) return;

        this.initPagination(data.totPage);
        this.addEvent();
        this.renderItems(data.list);
    },
    getData: async function(page = "1")  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserEducation", "page=" + page);
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
    initPagination: function(totPage) {
        const html = this.getPaginationHtml();
        this.$getCard().find(".edu_list").append(html);

        this.renderPagination(totPage);
    },
    renderPagination: function(totPage, activeNum = "1") {
        const $pagination = this.$getCard().find(".edu_list .pagination");
        $pagination.find("button.first").on("click", function() {
            $(this).parent().find("button").filter(function() {
                return $(this).text() === "1";
            }).click();
        })
        $pagination.find("button.prev").on("click", function() {
            const $active = $(this).parent().find("button.active");
            if ($active.text() === "1") return;
            $(this).parent().find("button.active").prev().click();
        })
        $pagination.find("button.next").on("click", function() {
            const $active = $(this).parent().find("button.active");
            if ($active.next().is(".next")) return;
            $(this).parent().find("button.active").next().click();
        })
        $pagination.find("button.last").on("click", function() {
            $(this).parent().find("button.next").prev().click();
        })

        const $next = $pagination.find(".next");
        for (let i = 1 ; i <= totPage ; i++) {
            $next.before(`<button>${i}</button>`);
            const $last = $next.prev();
            $last.on("click", async function() {
                $(this).parent().find("button.active").removeClass("active");
                $(this).addClass("active");

                const data = await EDUCATION.getData(EDUCATION.getPage());
                EDUCATION.renderItems(data.list);
            })
        }

        $pagination.find("button.active").removeClass("active");
        $pagination.find("button").filter(function() {
            return $(this).text() === activeNum;
        }).addClass("active");
    },
    renderItems: function(data) {
        const $list = this.$getList();
        $list.empty();

        if (data == null || data.length === 0) {
            const noDataHtml = this.getNoDataHtml();
            $list.append(noDataHtml);
            return;
        }

        for (const obj of data) {
            const html = this.getItemHtml();
            $list.append(html);
            const $last = $list.children().last();
            this.setData($last, obj);
            this.addItemEvent($last);
        }
    },
    getNoDataHtml: function() {
        return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
                    <i class="icon no_data"></i>
                    <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                </div>`;
    },
    getDefaultHtml: function() {
        return `<div class="card rounded-16 pa-24 bg-white" id="eduCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon rocket size-16"></i>
                            <p class="txt_title_xs sb txt_left">교육</p>
                        </div>
                        <div>
                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18 all_accordion_handle">unfold_less</i>
                        </div>
                    </div>
                    <div class="edu_list">
                        <div>
                            <div class="d-flex flex-col gap-12" id="eduList">
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    getPaginationHtml: function() {
        return `<div class="pagination">
                    <button class="first"></button>
                    <button class="prev"></button>
                    <button class="next"></button>
                    <button class="last"></button>
                </div>`;
    },
    getItemHtml: function() {
        return `<div class="accordion card rounded-16 pa-16-20 open">
                    <div class="accordion_header d-flex gap-16 align-center justify-between">
                        <div>
                            <p class="txt_body_sm sb eEduCourseNm">
                            </p>
                        </div>
                        <div class="d-flex gap-8 align-center">
                            <span class="txt_body_sm txt_tertiary txt_nowrap eEduPeriod"></span>
                            <span class="chip sm eEduBranchNm">특별교육</span>
                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6">expand_more</i>
                        </div>
                    </div>
                    <div class="accordion_item">
                        <div class="line gray mb-12"></div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">사내/외</span>
                                <span class="sb eInOutTypeNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">교육분류</span>
                                <span class="sb eEduMBranchNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">시행방법</span>
                                <span class="sb eEduMethodNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">교육비</span>
                                <span class="sb eRealExpenseMon"></span>
                            </div>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">고용보험적용여부</span>
                                <span class="sb eLaborReturnYn"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">교육수료구분</span>
                                <span class="sb eEduConfirmType"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">교육기관</span>
                                <span class="sb eEduOrgNm"></span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".eEduCourseNm").text(this.getValue(data.eduCourseNm));
        $el.find(".eEduPeriod").text(this.getValue(data.eduSYmd) + "~" + this.getValue(data.eduEYmd));
        $el.find(".eEduBranchNm").text(this.getValue(data.eduBranchNm));
        // 교육구분 item 색상은 공통코드 'L10010' 의 비고2 의 값
        $el.find(".eEduBranchNm").addClass(data.eduBranchClassNm);
        $el.find(".eInOutTypeNm").text(this.getValue(data.inOutTypeNm));
        $el.find(".eEduMBranchNm").text(this.getValue(data.eduMBranchNm));
        $el.find(".eEduMethodNm").text(this.getValue(data.eduMethodNm));
        $el.find(".eRealExpenseMon").text(this.getValue(data.realExpenseMon));
        $el.find(".eLaborReturnYn").text(this.getValue(data.laborReturnYn));
        $el.find(".eEduConfirmType").text(this.getValue(data.eduConfirmType));
        $el.find(".eEduOrgNm").text(this.getValue(data.eduOrgNm));
    },
    addEvent: function() {
        // 모두 접기/펴기
        this.$getCard().find(".all_accordion_handle").on("click", function() {
            const $allAccordions = EDUCATION.$getList().find(".accordion");
            const hasOpenAccordion = EDUCATION.hasOpenAccordion();

            if (hasOpenAccordion) {
                $allAccordions.removeClass("open");
                $(this).text("unfold_more");
            } else {
                $allAccordions.addClass("open");
                $(this).text("unfold_less");
            }
        })
    },
    hasOpenAccordion: function() {
        const $allAccordions = this.$getList().find(".accordion");
        return $allAccordions.hasClass("open");
    },
    addItemEvent: function($el) {
        $el.find(".accordion_header").on("click", function () {
            $(this).closest(".accordion").toggleClass("open");

            const $allAccordionHandle = EDUCATION.$getCard().find(".all_accordion_handle");
            const hasOpenAccordion = EDUCATION.hasOpenAccordion();
            if (hasOpenAccordion) {
                $allAccordionHandle.text("unfold_less");
            } else {
                $allAccordionHandle.text("unfold_more");
            }
        })
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#eduCard");
    },
    $getList: function() {
        return this.$getCard().find("#eduList");
    },
    getPage: function() {
        const $pagination = this.$getCard().find(".edu_list .pagination");
        return $pagination.find("button.active").text();
    }
}