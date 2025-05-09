var CONTACTS = {
    $el: null,
    previewData: [
        {
            "contTypeNm": "사무실전화",
            "contAddress": "02-1234-5678"
        },
        {
            "contTypeNm": "휴대전화",
            "contAddress": "010-0000-0000"
        },
        {
            "contTypeNm": "사내이메일",
            "contAddress": "gildong@text.com"
        },
        {
            "contTypeNm": "사외이메일",
            "contAddress": "gildonge@tmail.com"
        },
        {
            "contTypeNm": "비상연락망1",
            "contAddress": "031-1111-1111"
        },
        {
            "contTypeNm": "비상연락망2",
            "contAddress": "010-1111-1111"
        }
    ],
    /**
     * 항목 초기화
     * @param $el 부모 element
     * @param isPreview 예시 여부. true 일 경우 예시 데이터를 사용한다.
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserContacts", "");
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
            const html = this.getItemHtml();
            $list.append(html);
            const $last = $list.children().last();
            this.setData($last, obj);
        }
    },
    getNoDataHtml: function() {
        return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
                    <i class="icon no_data"></i>
                    <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                </div>`;
    },
    getDefaultHtml: function() {
        return `<div class="card rounded-16 pa-24 bg-white" id="contactsCard">
                    <div class="title_label_list">
                        <div class="title d-flex gap-8">
                            <i class="icon chat size-16"></i>
                            <p class="txt_title_xs sb txt_left">연락처</p>
                        </div>
                        <div class="label_list gap-12 d-grid grid-cols-2  gap-x-40" id="contactsList">
                        </div>
                    </div>
                </div>`;
    },
    getItemHtml: function() {
        return `<div class="d-flex gap-8">
                    <span class="txt_body_sm txt_secondary contTypeNm"></span>
                    <span class="txt_body_sm sb contAddress"></span>
                </div>`;
    },
    setData: function($el, data) {
        $el.find(".contTypeNm").text(this.getValue(data.contTypeNm));
        $el.find(".contAddress").text(this.getValue(data.contAddress));
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#contactsCard");
    },
    $getList: function() {
        return this.$getCard().find("#contactsList");
    }
}