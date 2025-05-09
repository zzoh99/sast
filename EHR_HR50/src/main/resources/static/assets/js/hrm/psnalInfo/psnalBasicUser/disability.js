var DISABILITY = {
    $el: null,
    previewData: {
        "jangNm": "청각장애",
        "jangGradeNm": "04등급",
        "jangTypeNm": "등록장애인",
        "jangYmd": "2022-01-01",
        "jangNo": "22-123456",
        "jangOrgNm": "",
        "jangMemo": "",
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

        const defHtml = this.getDefaultHtml();
        $el.append(defHtml);
        this.renderItems(data);
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserDisability", "");
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
    renderItems: function(data) {
        const $card = this.$getCard();
        if (data == null || this.isEmptyObject(data)) {
            const noDataHtml = this.getNoDataHtml();
            $card.append(noDataHtml);
            return;
        }

        const html = this.getItemHtml();
        $card.append(html);
        const $last = $card.children().last();
        this.setData($last, data);
    },
    getNoDataHtml: function() {
        return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
                    <i class="icon no_data"></i>
                    <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                </div>`;
    },
    getDefaultHtml: function() {
        return `<div class="card bg-white rounded-16 pa-24-20" id="disabilityCard">
                    <div class="mb-16 d-flex gap-8">
                        <i class="icon user_multiple size-16"></i>
                        <p class="txt_title_xs sb txt_left">장애사항</p>
                    </div>
                </div>`;
    },
    getItemHtml: function() {
        return `<div class="card rounded-16 pa-16-20">
                    <div class="label_list d-flex flex-col gap-8">
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">장애유형</span>
                            <span class="txt_body_sm sb dJangNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">장애등급</span>
                            <span class="txt_body_sm sb dJangGradeNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">장애구분</span>
                            <span class="txt_body_sm sb dJangTypeNm"></span>
                        </div>
                        <div class="line"></div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">장애인정일</span>
                            <span class="txt_body_sm sb dJangYmd"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">장애번호</span>
                            <span class="txt_body_sm sb dJangNo"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">장애인정기관</span>
                            <span class="txt_body_sm sb dJangOrgNm"></span>
                        </div>
                        <div class="line"></div>
                        <div class="d-flex flex-col gap-4">
                            <span class="txt_body_sm txt_secondary">비고</span>
                            <span class="txt_body_sm sb dJangMemo"></span>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".dJangNm").text(this.getValue(data.jangNm));
        $el.find(".dJangGradeNm").text(this.getValue(data.jangGradeNm));
        $el.find(".dJangTypeNm").text(this.getValue(data.jangTypeNm));
        $el.find(".dJangYmd").text(this.getValue(data.jangYmd));
        $el.find(".dJangNo").text(this.getValue(data.jangNo));
        $el.find(".dJangOrgNm").text(this.getValue(data.jangOrgNm));
        $el.find(".dJangMemo").text(this.getValue(data.jangMemo));
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#disabilityCard");
    },
    isEmptyObject: function(obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object;
    }
}