var MILITARY = {
    $el: null,
    previewData: {
        "transferNm": "예비역",
        "armyNm": "육군",
        "armyGradeNm": "병장",
        "armyNo": "09-1234567",
        "armyDNm": "통신",
        "dischargeNm": "만기제대",
        "armySYmd": "2009-01-01",
        "armyEYmd": "2010-11-30",
        "armyMemo": "비고"
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserMilitary", "");
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
        return `<div class="card bg-white rounded-16 pa-24-20" id="militaryCard">
                    <div class="mb-16 d-flex gap-8">
                        <i class="icon rocket size-16"></i>
                        <p class="txt_title_xs sb txt_left">병역사항</p>
                    </div>
                </div>`;
    },
    getItemHtml: function() {
        return `<div class="card rounded-16 pa-16-20">
                    <div class="label_list d-flex flex-col gap-8">
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">병역구분</span>
                            <span class="txt_body_sm sb mTransferNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">군별</span>
                            <span class="txt_body_sm sb mArmyNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">계급</span>
                            <span class="txt_body_sm sb mArmyGradeNm"></span>
                        </div>
                        <div class="line"></div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">군번</span>
                            <span class="txt_body_sm sb mArmyNo"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">병과</span>
                            <span class="txt_body_sm sb mArmyDNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">전역사유</span>
                            <span class="txt_body_sm sb mDischargeNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">복무기간</span>
                            <span class="txt_body_sm sb mArmyPeriod"></span>
                        </div>
                        <div class="line"></div>
                        <div class="d-flex flex-col gap-4">
                            <span class="txt_body_sm txt_secondary">비고</span>
                            <span class="txt_body_sm sb mArmyMemo"></span>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".mTransferNm").text(this.getValue(data.transferNm));
        $el.find(".mArmyNm").text(this.getValue(data.armyNm));
        $el.find(".mArmyGradeNm").text(this.getValue(data.armyGradeNm));
        $el.find(".mArmyNo").text(this.getValue(data.armyNo));
        $el.find(".mArmyDNm").text(this.getValue(data.armyDNm));
        $el.find(".mDischargeNm").text(this.getValue(data.dischargeNm));
        $el.find(".mArmyPeriod").text(this.getValue(data.armySYmd) + "~" + this.getValue(data.armyEYmd));
        $el.find(".mArmyMemo").text(this.getValue(data.armyMemo));
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#militaryCard");
    },
    isEmptyObject: function(obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object;
    }
}