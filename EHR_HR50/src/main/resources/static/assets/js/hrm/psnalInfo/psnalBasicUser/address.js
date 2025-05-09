var ADDRESS = {
    $el: null,
    previewData: [
        {
            "addrTypeNm": "본적",
            "addr": "서울특별시 서초구 사평대로60 4~7층 12345",
            "note": "특이사항 없음"
        },
        {
            "addrTypeNm": "주민등록지",
            "addr": "서울특별시 서초구 사평대로60 4~7층 12345",
            "note": "특이사항 없음"
        },
        {
            "addrTypeNm": "현거주지",
            "addr": "서울특별시 서초구 사평대로60 4~7층 12345",
            "note": "특이사항 없음"
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

        const defHtml = this.getDefaultHtml();
        $el.append(defHtml);
        this.renderItems(data);
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserAddress", "");
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
        $list.empty();

        if (data == null || data.length === 0) {
            const noDataHtml = this.getNoDataHtml();
            $list.append(noDataHtml);
            return;
        }

        for (const obj of data) {
            const isFileExists = this.isExistsFile(obj.fileSeq);
            const html = this.getItemHtml(isFileExists);
            $list.append(html);
            const $last = $list.children().last();
            $last.data("address", obj);
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
        return `<div class="card rounded-16 pa-24 bg-white" id="addressCard">
                    <div class="mb-16 d-flex gap-8">
                        <i class="icon photo_spark size-16"></i>
                        <p class="txt_title_xs sb txt_left">주소</p>
                    </div>
                    <div class="d-flex flex-col gap-12" id="addressList">
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
        return `<div class="card rounded-12 pa-16-24 d-flex justify-between align-center">
                    <div class="d-flex gap-16 align-center">
                        <div class="w-75">
                            <span class="chip sm addrTypeNm"></span>
                        </div>
                        <div>
                            <p class="txt_body_sm sb addrNm"></p>
                            <p class="txt_body_sm mt-4 addrNote"></p>
                        </div>
                    </div>
                    ${fileBtnHtml}
                </div>`;
    },
    isExistsFile: function(fileSeq) {
        return fileSeq != null && fileSeq !== "";
    },
    setData: function($el, data) {
        $el.find(".addrTypeNm").text(this.getValue(data.addrTypeNm));
        $el.find(".addrNm").text(this.getValue(data.addr));
        $el.find(".addrNote").text("비고 " + this.getValue(data.note));
    },
    addEvent: function($el) {
        $el.find(".btnFileDown").on("click", function(e) {
            const fileSeq = ($(this).closest(".card").data("address")).fileSeq;
            openFileDownloadLayer($(this), fileSeq);
        });
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#addressCard");
    },
    $getList: function() {
        return this.$getCard().find("#addressList");
    }
}