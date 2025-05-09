var POST = {
    $el: null,
    previewData: [
        {
            "ordYmd": "2025-01-01",
            "ordTypeNm": "입사",
            "ordDetailNm": "입사",
            "statusNm": "재직",
            "orgNm": "인사팀",
            "jikchakNm": "팀원",
            "jikweeNm": "대리",
            "jikgubNm": "3급",
            "jobNm": "급여담당",
            "workTypeNm": "사무직",
            "manageNm": "정규직"
        },
        {
            "ordYmd": "2025-04-01",
            "ordTypeNm": "수습",
            "ordDetailNm": "면수습",
            "statusNm": "재직",
            "orgNm": "인사팀",
            "jikchakNm": "팀원",
            "jikweeNm": "대리",
            "jikgubNm": "3급",
            "jobNm": "급여담당",
            "workTypeNm": "사무직",
            "manageNm": "정규직"
        },
        {
            "ordYmd": "2025-04-08",
            "ordTypeNm": "인사이동",
            "ordDetailNm": "조직개편",
            "statusNm": "재직",
            "orgNm": "총무팀",
            "jikchakNm": "팀원",
            "jikweeNm": "대리",
            "jikgubNm": "3급",
            "jobNm": "창고관리",
            "workTypeNm": "사무직",
            "manageNm": "정규직"
        }
    ],
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
        this.addEvent(isPreview);
        this.renderItems(data);
    },
    getData: async function(mainYn = "")  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserPost", "");
            if (data == null || data.isError) {
                if (data != null && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return null;
            }

            if (data && data.msg) {
                alert(data.msg);
                return null;
            }
            return data.list;
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
    renderItems: function(data) {
        this.clearList();

        const $list = this.$getList();
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
        }
    },
    clearList: function() {
        const $list = this.$getList();
        $list.empty();
    },
    getNoDataHtml: function() {
        return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
                    <i class="icon no_data"></i>
                    <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                </div>`;
    },
    getDefaultHtml: function() {
        return `<div class="card rounded-16 pa-24 bg-white" id="postCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon cyborg size-16"></i>
                            <p class="txt_title_xs sb txt_left">발령</p>
                        </div>
                        <div>
                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18 dropdown_list_btn">
                                filter_list
                                <div class="dropdown_list sm w-70">
                                    <div class="dropdown_list_item" id="searchPostAll">
                                        <p>전체</p>
                                    </div>
                                    <div class="dropdown_list_item" id="searchPostMainYn">
                                        <p>주요발령</p>
                                    </div>
                                </div>
                            </i>
                        </div>
                    </div>
                    <div class="timeline" id="postList">
                    </div>
                </div>`;
    },
    getItemHtml: function() {
        return `<div class="timeline-item">
                    <div class="timeline-content d-flex gap-4 align-center mb-12">
                        <span class="txt_body_sm txt_tertiary mr-8 pOrdYmd"></span>
                        <span class="txt_title_xs sb pOrdTypeNm"></span>
                        <span class="chip sm blue pOrdDetailNm"></span>
                    </div>
                    <div class="card rounded-12 pa-16-20">
                        <div class="label_list gap-8 d-grid grid-cols-2  gap-x-40">
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">재직상태</span>
                                <span class="txt_body_sm sb pStatusNm"></span>
                            </div>
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">소속</span>
                                <span class="txt_body_sm sb pOrgNm"></span>
                            </div>
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">직책</span>
                                <span class="txt_body_sm sb pJikchakNm"></span>
                            </div>
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">직위</span>
                                <span class="txt_body_sm sb pJikweeNm"></span>
                            </div>
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">직급</span>
                                <span class="txt_body_sm sb pJikgubNm"></span>
                            </div>
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">직무</span>
                                <span class="txt_body_sm sb pJobNm"></span>
                            </div>
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">직군</span>
                                <span class="txt_body_sm sb pWorkTypeNm"></span>
                            </div>
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">사원구분</span>
                                <span class="txt_body_sm sb pManageNm"></span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".pOrdYmd").text(this.getValue(data.ordYmd));
        $el.find(".pOrdTypeNm").text(this.getValue(data.ordTypeNm));
        $el.find(".pOrdDetailNm").text(this.getValue(data.ordDetailNm));
        $el.find(".pStatusNm").text(this.getValue(data.statusNm));
        $el.find(".pOrgNm").text(this.getValue(data.orgNm));
        $el.find(".pJikchakNm").text(this.getValue(data.jikchakNm));
        $el.find(".pJikweeNm").text(this.getValue(data.jikweeNm));
        $el.find(".pJikgubNm").text(this.getValue(data.jikgubNm));
        $el.find(".pJobNm").text(this.getValue(data.jobNm));
        $el.find(".pWorkTypeNm").text(this.getValue(data.workTypeNm));
        $el.find(".pManageNm").text(this.getValue(data.manageNm));
    },
    addEvent: function(isPreview) {
        // 드롭다운 OPEN/CLOSE 이벤트
        this.$getCard().find(".dropdown_list_btn").on("click", function () {
            $(this).closest('.dropdown').find(".dropdown_list").toggleClass("show");
            $(this).parent().find(".dropdown_list").toggleClass("show");
            $(".dropdown_list.show").not($(this).parent().find(".dropdown_list")).removeClass("show");
        });

        // 드롭다운 리스트 닫기
        $(document).on('mouseup', function(e) {
            var dropdown = POST.$getCard().find('.dropdown_list.show');
            if (!dropdown.is(e.target) &&
                dropdown.has(e.target).length === 0 &&
                !$(e.target).hasClass('dropdown_list_btn')) {
                dropdown.removeClass('show');
            }
        });

        if (!isPreview) {
            // 드롭다운 선택 이벤트
            this.$getCard().find(".dropdown_list_item").on("click", async function () {
                const id = $(this).attr("id");
                if (id === "searchPostMainYn") {
                    POST.clearList();
                    const data = await POST.getData("Y");
                    POST.renderItems(data);
                } else {
                    POST.clearList();
                    const data = await POST.getData();
                    POST.renderItems(data);
                }
            });
        }
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#postCard");
    },
    $getList: function() {
        return this.$getCard().find("#postList");
    }
}