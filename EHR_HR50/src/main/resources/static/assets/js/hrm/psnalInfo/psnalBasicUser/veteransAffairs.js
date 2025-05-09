var VTRNAFFRS= {
    $el: null,
    previewData: {
        "bohunNm": "애국지사(건국훈장1-3등급)",
        "famNm": "조부",
        "bohunNo": "21-038889",
        "bohunPNm": "홍갑석",
        "empOrderNo": "123456",
        "note": "",
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserVeteransAffairs", "");
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
        return `<div class="card bg-white rounded-16 pa-24-20" id="veteransAffairsCard">
                    <div class="mb-16 d-flex gap-8">
                        <i class="icon photo_spark size-16"></i>
                        <p class="txt_title_xs sb txt_left">보훈사항</p>
                    </div>
                </div>`;
    },
    getItemHtml: function() {
        return `<div class="card rounded-16 pa-16-20">
                    <div class="label_list d-flex flex-col gap-8">
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">보훈구분</span>
                            <span class="txt_body_sm sb vaBohunNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">보훈관계</span>
                            <span class="txt_body_sm sb vaFamNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">보훈번호</span>
                            <span class="txt_body_sm sb vaBohunNo"></span>
                        </div>
                        <div class="line"></div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">유공자성명</span>
                            <span class="txt_body_sm sb vaBohunPNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">고용명령번호</span>
                            <span class="txt_body_sm sb vaEmpOrderNo"></span>
                        </div>
                        <div class="line"></div>
                        <div class="d-flex flex-col gap-4">
                            <span class="txt_body_sm txt_secondary">비고</span>
                            <span class="txt_body_sm sb vaNote"></span>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".vaBohunNm").text(this.getValue(data.bohunNm));
        $el.find(".vaFamNm").text(this.getValue(data.famNm));
        $el.find(".vaBohunNo").text(this.getValue(data.bohunNo));
        $el.find(".vaBohunPNm").text(this.getValue(data.bohunPNm));
        $el.find(".vaEmpOrderNo").text(this.getValue(data.empOrderNo));
        $el.find(".vaNote").text(this.getValue(data.note));
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#veteransAffairsCard");
    },
    isEmptyObject: function(obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object;
    }
}