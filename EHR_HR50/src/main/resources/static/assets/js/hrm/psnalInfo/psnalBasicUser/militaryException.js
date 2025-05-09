var MLTRYEXPT= {
    $el: null,
    previewData: {
        "targetYn": "Y",
        "armyEduYn": "Y",
        "sdate": "2010-01-01",
        "edate": "2010-04-30",
        "armyEduSYmd": "2010-01-01",
        "armyEduEYmd": "2010-04-30",
        "armyEduNm": "5군단",
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserMilitaryException", "");
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
        return `<div class="card bg-white rounded-16 pa-24-20" id="militaryExceptionCard">
                    <div class="mb-16 d-flex gap-8">
                        <i class="icon send size-16"></i>
                        <p class="txt_title_xs sb txt_left">병역특례</p>
                    </div>
                </div>`;
    },
    getItemHtml: function() {
        return `<div class="card rounded-16 pa-16-20">
                    <div class="label_list d-flex flex-col gap-8">
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">병특대상여부</span>
                            <span class="txt_body_sm sb meTargetYn"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">군사교육수료여부</span>
                            <span class="txt_body_sm sb meArmyEduYn"></span>
                        </div>
                        <div class="line"></div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">특례편입일</span>
                            <span class="txt_body_sm sb meSdate"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">특례만료일</span>
                            <span class="txt_body_sm sb meEdate"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">군사교육기간</span>
                            <span class="txt_body_sm sb meArmyEduPeriod"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">훈련부대명</span>
                            <span class="txt_body_sm sb meArmyEduNm"></span>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".meTargetYn").text(this.getValue(data.targetYn));
        $el.find(".meArmyEduYn").text(this.getValue(data.armyEduYn));
        $el.find(".meSdate").text(this.getValue(data.sdate));
        $el.find(".meEdate").text(this.getValue(data.edate));
        $el.find(".meArmyEduPeriod").text(this.getValue(data.armyEduSYmd) + "~" + this.getValue(data.armyEduEYmd));
        $el.find(".meArmyEduNm").text(this.getValue(data.armyEduNm));
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#militaryExceptionCard");
    },
    isEmptyObject: function(obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object;
    }
}