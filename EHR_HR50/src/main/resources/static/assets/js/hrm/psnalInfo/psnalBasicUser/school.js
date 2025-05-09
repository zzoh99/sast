var SCHOOL = {
    $el: null,
    previewData: [
        {
            "acaNm": "F-대학원(국내)",
            "acaClassNm": "blue",
            "acaSchNm": "서울대학교",
            "acaSYm": "2017-03",
            "acaEYm": "2019-02",
            "acamajNm": "경영학과",
            "doumajNm": "",
            "entryType": "N",
            "acaType": "Y",
            "acaYn": "졸업",
            "acaPlaceNm": "서울",
            "eTypeNm": "본교",
            "dTypeNm": "주간"
        },
        {
            "acaNm": "E-대학교(국내)",
            "acaClassNm": "green",
            "acaSchNm": "연세대학교",
            "acaSYm": "2011-03",
            "acaEYm": "2017-02",
            "acamajNm": "경영학과",
            "doumajNm": "",
            "entryType": "N",
            "acaType": "N",
            "acaYn": "졸업",
            "acaPlaceNm": "서울",
            "eTypeNm": "본교",
            "dTypeNm": "주간"
        },
        {
            "acaNm": "C-고등학교(국내)",
            "acaClassNm": "yellow",
            "acaSchNm": "서울고등학교",
            "acaSYm": "2009-03",
            "acaEYm": "2011-02",
            "acamajNm": "",
            "doumajNm": "",
            "entryType": "",
            "acaType": "N",
            "acaYn": "졸업",
            "acaPlaceNm": "서울",
            "eTypeNm": "",
            "dTypeNm": ""
        },
        {
            "acaNm": "B-중학교(국내)",
            "acaClassNm": "tan",
            "acaSchNm": "서울중학교",
            "acaSYm": "2007-03",
            "acaEYm": "2009-02",
            "acamajNm": "",
            "doumajNm": "",
            "entryType": "",
            "acaType": "N",
            "acaYn": "졸업",
            "acaPlaceNm": "서울",
            "eTypeNm": "",
            "dTypeNm": ""
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserSchool", "");
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
            $last.data("school", obj);
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
        return `<div class="card rounded-16 pa-24 bg-white" id="schoolCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon cyborg size-16"></i>
                            <p class="txt_title_xs sb txt_left">학력</p>
                        </div>
                    </div>
                    <div id="schoolList">
                    </div>
                </div>`;
    },
    getItemHtml: function(isFileExists) {
        let fileBtnHtml = "";
        if (isFileExists) {
            fileBtnHtml = `<i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18 btnFileDown">file_download</i>`;
        }
        return `<div class="pa-16-20-8 bd-b schoolItemCard">
                    <div class="mb-8">
                        <span class="chip sm sAcaNm"></span>
                    </div>
                    <div>
                        <span class="txt_body_sm sb sAcaSchNm"></span>
                        <span class="txt_body_sm txt_tertiary sAcaPeriod"></span>
                    </div>
                    <div class="label_text_group mt-4">
                        <div class="txt_body_sm">
                            <span class="txt_secondary">전공</span>
                            <span class="sb sAcamajNm"></span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">복수전공</span>
                            <span class="sb sDoumajNm"></span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">편입</span>
                            <span class="sb sEntryType"></span>
                        </div>
                        <div class="txt_body_sm">
                            <span class="txt_secondary">최종학력여부</span>
                            <span class="sb sAcaType"></span>
                        </div>
                    </div>
                    <div class="d-flex gap-8 align-center mt-8">
                        <div class="label_text_group">
                            <div class="txt_body_sm">
                                <span class="sb sAcaYn"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb sAcaPlaceNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb sETypeNm"></span>
                            </div>
                            <div class="txt_body_sm">
                                <span class="sb sDTypeNm"></span>
                            </div>
                        </div>
                        ${fileBtnHtml}
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".sAcaNm").text(this.getValue(data.acaNm));
        $el.find(".sAcaNm").addClass(data.acaClassNm);
        $el.find(".sAcaSchNm").text(this.getValue(data.acaSchNm));
        $el.find(".sAcaPeriod").text(this.getValue(data.acaSYm) + "~" + this.getValue(data.acaEYm));

        this.setDataIfNull($el, "sAcamajNm", data.acamajNm);
        this.setDataIfNull($el, "sDoumajNm", data.doumajNm);
        this.setDataIfNull($el, "sEntryType", data.entryType);
        this.setDataIfNull($el, "sAcaType", data.acaType);
        this.setDataIfNull($el, "sAcaYn", data.acaYn);
        this.setDataIfNull($el, "sAcaPlaceNm", data.acaPlaceNm);
        this.setDataIfNull($el, "sETypeNm", data.eTypeNm);
        this.setDataIfNull($el, "sDTypeNm", data.dTypeNm);
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
            console.log($(this).closest(".schoolItemCard").data("school"));
            const fileSeq = ($(this).closest(".schoolItemCard").data("school")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#schoolCard");
    },
    $getList: function() {
        return this.$getCard().find("#schoolList");
    },
    initPreview: function($el) {
        this.$el = $el;

        this.clearHtml($el);
        const defHtml = this.getDefaultHtml();
        $el.append(defHtml);
        this.addEvent();

        const data = [
            {
                "acaNm": "F-대학원(국내)",
                "acaClassNm": "blue",
                "acaSchNm": "서울대학교",
                "acaSYm": "2017-03",
                "acaEYm": "2019-02",
                "acamajNm": "경영학과",
                "doumajNm": "",
                "entryType": "N",
                "acaType": "Y",
                "acaYn": "졸업",
                "acaPlaceNm": "서울",
                "eTypeNm": "본교",
                "dTypeNm": "주간"
            },
            {
                "acaNm": "E-대학교(국내)",
                "acaClassNm": "green",
                "acaSchNm": "연세대학교",
                "acaSYm": "2011-03",
                "acaEYm": "2017-02",
                "acamajNm": "경영학과",
                "doumajNm": "",
                "entryType": "N",
                "acaType": "N",
                "acaYn": "졸업",
                "acaPlaceNm": "서울",
                "eTypeNm": "본교",
                "dTypeNm": "주간"
            },
            {
                "acaNm": "C-고등학교(국내)",
                "acaClassNm": "yellow",
                "acaSchNm": "서울고등학교",
                "acaSYm": "2009-03",
                "acaEYm": "2011-02",
                "acamajNm": "",
                "doumajNm": "",
                "entryType": "",
                "acaType": "N",
                "acaYn": "졸업",
                "acaPlaceNm": "서울",
                "eTypeNm": "",
                "dTypeNm": ""
            },
            {
                "acaNm": "B-중학교(국내)",
                "acaClassNm": "tan",
                "acaSchNm": "서울중학교",
                "acaSYm": "2007-03",
                "acaEYm": "2009-02",
                "acamajNm": "",
                "doumajNm": "",
                "entryType": "",
                "acaType": "N",
                "acaYn": "졸업",
                "acaPlaceNm": "서울",
                "eTypeNm": "",
                "dTypeNm": ""
            }
        ];
        this.renderItems(data);
    }
}