var OVRSSTUDY = {
    $el: null,
    previewData: [
        {
            "nationNm": "이집트",
            "sdate": "2018-01-01",
            "edate": "2018-07-31",
            "cityNm": "카이로",
            "purpose": "이집트 문명 탐구",
            "note": ""
        },
        {
            "nationNm": "미국",
            "sdate": "2019-01-01",
            "edate": "2019-02-20",
            "cityNm": "로스앤젤레스",
            "purpose": "미국 고객사 방문",
            "note": ""
        },
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

        const defHtml = this.getDefaultHtml();
        $el.append(defHtml);
        this.addEvent();
        this.renderItems(data);
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserOverseasStudy", "");
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
            $last.data("ovrsstudy", obj);
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
        return `<div class="card rounded-16 pa-24 bg-white" id="overseasStudyCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon cyborg size-16"></i>
                            <p class="txt_title_xs sb txt_left">해외연수</p>
                        </div>
                    </div>
                    <div class="d-flex flex-col gap-12" id="overseasStudyList">
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
                                <span class="osNationNm"></span>
                                <span class="txt_body_sm txt_tertiary ml-8 osPeriod"></span>
                            </p>
                        </div>
                        ${fileBtnHtml}
                    </div>
                    <div class="line gray mb-12"></div>
                    <div class="label_text_group mb-8">
                        <div class="txt_body_sm">
                            <span class="txt_secondary">도시</span>
                            <span class="sb osCityNm"></span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">연수목적</span>
                            <span class="sb osPurpose"></span>
                        </div>
                    </div>
                    <div class="label_list">
                        <div class="d-flex flex-col gap-4">
                            <span class="txt_body_sm txt_secondary">연수내용</span>
                            <span class="txt_body_sm sb osNote"></span>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".osNationNm").text(this.getValue(data.nationNm));
        $el.find(".osPeriod").text(this.getValue(data.sdate) + "~" + this.getValue(data.edate));
        $el.find(".osCityNm").text(this.getValue(data.cityNm));
        $el.find(".osPurpose").text(this.getValue(data.purpose));
        $el.find(".osNote").text(this.getValue(data.note));
    },
    addEvent: function() {
    },
    addItemEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("ovrsstudy")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#overseasStudyCard");
    },
    $getList: function() {
        return this.$getCard().find("#overseasStudyList");
    }
}