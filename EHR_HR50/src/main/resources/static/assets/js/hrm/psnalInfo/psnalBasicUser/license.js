var LICENSE = {
    $el: null,
    previewData: [
        {
            "licenseNm": "CCNA",
            "licenseGrade": "Expert",
            "licSYmd": "2021-01-11",
            "licenseNo": "123456",
            "officeNm": "기관1",
            "licUYmd": "2024-01-11",
            "licEYmd": "2025-01-11",
            "allowSymd": "2025-01-01",
            "allowEymd": "2025-01-11",
            "licenseBigo": ""
        },
        {
            "licenseNm": "1종투자상담사",
            "licenseGrade": "Expert",
            "licSYmd": "2022-01-01",
            "licenseNo": "12345879",
            "officeNm": "기관2",
            "licUYmd": "",
            "licEYmd": "",
            "allowSymd": "2025-01-01",
            "allowEymd": "",
            "licenseBigo": ""
        },
        {
            "licenseNm": "OCP",
            "licenseGrade": "Expert",
            "licSYmd": "2023-11-11",
            "licenseNo": "123456",
            "officeNm": "기관3",
            "licUYmd": "",
            "licEYmd": "",
            "allowSymd": "2025-01-01",
            "allowEymd": "",
            "licenseBigo": ""
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserLicense", "");
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
            $last.data("license", obj);
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
        return `<div class="card rounded-16 pa-24 bg-white" id="licenseCard">
                    <div class="d-flex justify-between align-center mb-12">
                        <div class="d-flex gap-8">
                            <i class="icon cyborg size-16"></i>
                            <p class="txt_title_xs sb txt_left">자격</p>
                        </div>
                    </div>
                    <div class="d-flex flex-col gap-12" id="licenseList">
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
        return `<div class="card rounded-16 pa-16-20">
                    <div class="d-flex gap-16 align-center justify-between mb-8">
                        <div>
                            <p class="txt_title_xs sb">
                                <span class="lLicenseNm"></span>
                                <span class="chip sm blue ml-8 lLicenseGrade"></span>
                            </p>
                        </div>
                        <div class="d-flex gap-16 align-center">
                            <div class="d-flex gap-4 txt_body_sm">
                                <span class="txt_tertiary">취득일</span>
                                <span class="lLicSYmd"></span>
                            </div>
                            ${fileBtnHtml}
                        </div>
                    </div>
                    <div class="line gray mb-12"></div>
                    <div class="label_list gap-12 d-grid grid-cols-2  gap-x-40 mb-16">
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">자격증번호</span>
                            <span class="txt_body_sm sb lLicenseNo"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">발급기관</span>
                            <span class="txt_body_sm sb lOfficeNm"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">갱신일(교부일)</span>
                            <span class="txt_body_sm sb lLicUYmd"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">만료일</span>
                            <span class="txt_body_sm sb lLicEYmd"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">수당지급시작일</span>
                            <span class="txt_body_sm sb lAllowSymd"></span>
                        </div>
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">수당지급종료일</span>
                            <span class="txt_body_sm sb lAllowEymd"></span>
                        </div>
                    </div>
                    <div class="line mb-16"></div>
                    <div class="label_list">
                        <div class="d-flex justify-between">
                            <span class="txt_body_sm txt_secondary">관련근거</span>
                            <span class="txt_body_sm sb lLicenseBigo"></span>
                        </div>
                    </div>
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".lLicenseNm").text(this.getValue(data.licenseNm));
        $el.find(".lLicenseGrade").text(this.getValue(data.licenseGrade));
        $el.find(".lLicSYmd").text(this.getValue(data.licSYmd));
        $el.find(".lLicenseNo").text(this.getValue(data.licenseNo));
        $el.find(".lOfficeNm").text(this.getValue(data.officeNm));
        $el.find(".lLicUYmd").text(this.getValue(data.licUYmd));
        $el.find(".lLicEYmd").text(this.getValue(data.licEYmd));
        $el.find(".lAllowSymd").text(this.getValue(data.allowSymd));
        $el.find(".lAllowEymd").text(this.getValue(data.allowEymd));
        $el.find(".lLicenseBigo").text(this.getValue(data.licenseBigo));
    },
    addEvent: function() {
    },
    addItemEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("license")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#licenseCard");
    },
    $getList: function() {
        return this.$getCard().find("#licenseList");
    }
}