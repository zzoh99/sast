var LANGUAGE = {
    $el: null,
    previewData: [
        {
            "fTestNm": "OPIC",
            "foreignNm": "영어",
            "testPoint": "A",
            "passScores": "IH",
            "officeNm": "",
            "applyYmd": "2021-01-02",
            "sdate": "",
            "edate": ""
        },
        {
            "fTestNm": "TOEIC",
            "foreignNm": "영어",
            "testPoint": "950",
            "passScores": "",
            "officeNm": "",
            "applyYmd": "2021-01-31",
            "sdate": "",
            "edate": ""
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
        this.addEvent();
        this.renderItems(data);
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserLanguage", "");
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
            const isExistsFile = this.isExistsFile(obj.fileSeq);
            const html = this.getItemHtml(isExistsFile);
            $list.append(html);
            const $last = $list.children().last();
            $last.data("language", obj);
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
        return `<div class="card rounded-16 pa-24 bg-white" id="languageCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon peace_hand size-16"></i>
                            <p class="txt_title_xs sb txt_left">어학</p>
                        </div>
                    </div>
                    <div class="d-flex flex-col gap-12" id="languageList">
                    </div>
                </div>`;
    },
    getItemHtml: function(isFileExists) {
        let fileBtnHtml = "";
        if (isFileExists) {
            fileBtnHtml = `<div>
                               <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                           </div>`;
        }
        return `<div class="card rounded-16 pa-16-20">
                    <div class="d-flex gap-16 align-center justify-between mb-8">
                        <div>
                            <p class="txt_title_xs sb">
                                <span class="lFTestNm"></span>
                                <span class="txt_body_sm txt_tertiary ml-8 lForeignNm"></span>
                            </p>
                        </div>
                        ${fileBtnHtml}
                    </div>
                    <div class="line gray mb-12"></div>
                    <div>
                        <div class="label_text_group mb-16">
                            <div class="txt_body_sm">
                                <span class="sb lTestPoint"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb lPassScores"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb lOfficeNm"></span>
                            </div>
                        </div>
                        <div class="label_text_group mb-8">
                            <div class="txt_body_sm">
                                <span class="txt_secondary">시험일자</span>
                                <span class="sb lApplyYmd"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="txt_secondary">수당지급시작/종료일</span>
                                <span class="sb lPeriod"></span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".lFTestNm").text(this.getValue(data.fTestNm));
        $el.find(".lForeignNm").text(this.getValue(data.foreignNm));

        this.setDataIfNull($el, "lTestPoint", data.testPoint);
        this.setDataIfNull($el, "lPassScores", data.passScores);
        this.setDataIfNull($el, "lOfficeNm", data.officeNm);

        $el.find(".lApplyYmd").text(this.getValue(data.applyYmd));
        $el.find(".lPeriod").text(this.getValue(data.sdate) + "~" + this.getValue(data.edate));
    },
    setDataIfNull: function($el, classNm, value) {
        if (value == null || value === "") {
            $el.find("." + classNm).parent().remove();
        } else {
            $el.find("." + classNm).text(this.getValue(value));
        }
    },
    addEvent: function() {
    },
    addItemEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("language")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#languageCard");
    },
    $getList: function() {
        return this.$getCard().find("#languageList");
    }
}