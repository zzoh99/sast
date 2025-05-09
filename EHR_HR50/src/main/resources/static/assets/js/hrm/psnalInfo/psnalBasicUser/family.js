var FAMILY = {
    $el: null,
    previewData: [
        {
            "famTypeNm": "부",
            "famTypeClassNm": "green",
            "famNm": "홍길준",
            "famYmd": "1968-01-01",
            "genderNm": "남",
            "famResNo": "680101-*******",
            "liveWithYn": "Y",
            "hSupportYn": "Y",
            "acaNm": "대졸",
            "officeNm": "OO회계사",
            "famJikweeNm": "",
            "note": ""
        },
        {
            "famTypeNm": "모",
            "famTypeClassNm": "green",
            "famNm": "이길순",
            "famYmd": "1969-01-01",
            "genderNm": "여",
            "famResNo": "690101-*******",
            "liveWithYn": "Y",
            "hSupportYn": "Y",
            "acaNm": "대졸",
            "officeNm": "",
            "famJikweeNm": "",
            "note": ""
        },
        {
            "famTypeNm": "처",
            "famTypeClassNm": "green",
            "famNm": "최길영",
            "famYmd": "1992-01-01",
            "genderNm": "여",
            "famResNo": "920101-*******",
            "liveWithYn": "Y",
            "hSupportYn": "Y",
            "acaNm": "대졸",
            "officeNm": "강남병원",
            "famJikweeNm": "",
            "note": ""
        },
        {
            "famTypeNm": "자녀",
            "famTypeClassNm": "green",
            "famNm": "홍길후",
            "famYmd": "2024-01-01",
            "genderNm": "남",
            "famResNo": "240101-*******",
            "liveWithYn": "Y",
            "hSupportYn": "Y",
            "acaNm": "",
            "officeNm": "",
            "famJikweeNm": "",
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserFamily", "");
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
            $last.data("family", obj);
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
        return `<div class="card rounded-16 pa-24 bg-white" id="familyCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon hobby size-16"></i>
                            <p class="txt_title_xs sb txt_left">가족</p>
                        </div>
                    </div>
                    <div class="d-grid grid-cols-2 gap-16" id="familyList">
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
                    <div class="d-flex gap-16 align-center justify-between mb-16">
                        <div class="d-flex gap-10 align-center">
                            <span class="chip sm fFamTypeNm"></span>
                            <div class="txt_body_sm sb">
                                <span class="fFamNm"></span>
                                <span class="fFamYmd"></span>
                                <span class="fGenderNm"></span>
                            </div>
                        </div>
                        ${fileBtnHtml}
                    </div>
                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-80 mb-12">
                        <div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">주민등록번호</span>
                                <span class="txt_body_sm sb fFamResNo"></span>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">동거여부</span>
                                <span class="txt_body_sm sb fLiveWithYn"></span>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">건강보험피부양자등록여부</span>
                                <span class="txt_body_sm sb fHSupportYn"></span>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">학력</span>
                                <span class="txt_body_sm sb fAcaNm"></span>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">직장(학교)명</span>
                                <span class="txt_body_sm sb fOfficeNm"></span>
                            </div>
                        </div>
                        <div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">직위(학년)</span>
                                <span class="txt_body_sm sb fFamJikweeNm"></span>
                            </div>
                        </div>

                    </div>
                    <div class="line gray mb-12"></div>
                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-40">
                        <div class="d-flex gap-8">
                            <span class="txt_body_sm txt_secondary">비고</span>
                            <span class="txt_body_sm sb fNote"></span>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".fFamTypeNm").text(this.getValue(data.famTypeNm));
        $el.find(".fFamTypeNm").addClass(data.famTypeClassNm);
        $el.find(".fFamNm").text(this.getValue(data.famNm));
        $el.find(".fFamYmd").text(this.getValue(data.famYmd));
        $el.find(".fGenderNm").text(this.getValue(data.genderNm));
        $el.find(".fFamResNo").text(this.getValue(data.famResNo));
        $el.find(".fLiveWithYn").text(this.getValue(data.liveWithYn));
        $el.find(".fHSupportYn").text(this.getValue(data.hSupportYn));
        $el.find(".fAcaNm").text(this.getValue(data.acaNm));
        $el.find(".fOfficeNm").text(this.getValue(data.officeNm));
        $el.find(".fFamJikweeNm").text(this.getValue(data.famJikweeNm));
        $el.find(".fNote").text(this.getValue(data.note));
    },
    addEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("family")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#familyCard");
    },
    $getList: function() {
        return this.$getCard().find("#familyList");
    }
}