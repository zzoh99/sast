var GRNTINS= {
    $el: null,
    previewData: [
        {
            "wrrntTypeNm": "SGI서울보증",
            "warrantySYmd": "2021-05-20",
            "warrantyEYmd": "2026-02-20",
            "warrantyNo": "2021-01-123",
            "currencyNm": "KRW",
            "warrantyMon": "10,000,000",
            "note": ""
        },
        {
            "wrrntTypeNm": "대한보증보험",
            "warrantySYmd": "2018-02-02",
            "warrantyEYmd": "2023-02-01",
            "warrantyNo": "2018-02-123",
            "currencyNm": "KRW",
            "warrantyMon": "5,000,000",
            "note": ""
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

        this.renderItems(data);
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserGuaranteeInsurance", "");
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
        const $list = this.$getList();
        if (data == null || data.length === 0) {
            const noDataHtml = this.getNoDataHtml();
            $list.append(noDataHtml);
            return;
        }

        $list.empty();

        for (const obj of data) {
            const isFileExists = this.isExistsFile(obj.fileSeq);
            const html = this.getItemHtml(isFileExists);
            $list.append(html);
            const $last = $list.children().last();
            $last.data("grntIns", obj);
            this.setData($last, obj);
            this.addEvent($last);
        }
    },
    getNoDataHtml: function() {
        return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
                    <i class="icon no_data"></i>
                    <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                </div>`;
    },
    getDefaultHtml: function() {
        return `<div class="card rounded-16 pa-24 bg-white" id="grntInsCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon cyborg size-16"></i>
                            <p class="txt_title_xs sb txt_left">보증보험</p>
                        </div>
                    </div>
                    <div class="d-flex flex-col gap-12" id="grntInsList">
                    </div>
                </div>`;
    },
    getItemHtml: function(isFileExists) {
        let fileBtnHtml = "";
        if (isFileExists) {
            fileBtnHtml = `<div class="btnFileDown">
                               <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                           </div>`;
        }
        return `<div class="card rounded-12 pa-16-20">
                    <div class="d-flex gap-16 align-center justify-between mb-8">
                        <div>
                            <p class="txt_title_xs sb">
                                <span class="giWrrntTypeNm"></span>
                                <span class="txt_body_sm txt_tertiary ml-8 giWrrntPeriod"></span>
                            </p>
                        </div>
                        ${fileBtnHtml}
                    </div>
                    <div class="line gray mb-12"></div>
                    <div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">증권번호</span>
                                <span class="sb giWarrantyNo"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">통화단위</span>
                                <span class="sb giCurrencyNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">보증금액</span>
                                <span class="sb giWarrantyMon"></span>
                            </div>
                        </div>
                        <div class="label_list">
                            <div class="d-flex gap-8">
                                <span class="txt_body_sm txt_secondary">비고</span>
                                <span class="txt_body_sm sb giNote"></span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".giWrrntTypeNm").text(this.getValue(data.wrrntTypeNm));
        $el.find(".giWrrntPeriod").text(this.getValue(data.warrantySYmd) + "~" + this.getValue(data.warrantyEYmd));
        $el.find(".giWarrantyNo").text(this.getValue(data.warrantyNo));
        $el.find(".giCurrencyNm").text(this.getValue(data.currencyNm));
        $el.find(".giWarrantyMon").text(this.getValue(data.warrantyMon));
        $el.find(".giNote").text(this.getValue(data.note));
    },
    addEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("grntIns")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#grntInsCard");
    },
    $getList: function() {
        return this.$getCard().find("#grntInsList");
    }
}