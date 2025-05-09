var PSNLINFO = {
    $el: null,
    previewData: {
        "nameUs": "Hong Gildong",
        "nameCn": "洪吉同",
        "resNo": "900101-1111111",
        "birYmd": "90년 01월 01일",
        "age": "35세",
        "statusNm": "재직",
    },
    /**
     * 항목 초기화
     * @param $el 부모 element
     * @param isPreview 예시 여부. true 일 경우 예시 데이터를 사용한다. 기본값 false.
     */
    init: async function($el, isPreview = false) {
        this.$el = $el;

        this.clearHtml();

        let data;
        if (isPreview) {
            data = this.previewData;
        } else {
            data = await this.getData();
        }
        if (data == null) return;

        const html = this.getHtml();
        $el.append(html);
        this.setData(data);
    },
    getData: async function()  {
        try {
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserPsnlInfo", "");
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
    getHtml: function() {
        return `<div class="card rounded-16 pa-24 bg-white" id="psnlInfoCard">
                    <div class="title_label_list">
                        <div class="title d-flex gap-8">
                            <i class="icon profile_person size-16"></i>
                            <p class="txt_title_xs sb txt_left">개인정보</p>
                        </div>
                        <div class="label_list gap-12">
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">영문성명</span>
                                <span class="txt_body_sm sb" id="piNameUs">Kim isu</span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">한자성명</span>
                                <span class="txt_body_sm sb" id="piNameCn">-</span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">주민등록번호</span>
                                <span class="txt_body_sm sb" id="piResNo">903456-1987654</span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">생년월일</span>
                                <span class="txt_body_sm sb" id="piBirYmd">90년 3월 24일 / 36세</span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">재직상태</span>
                                <span class="txt_body_sm sb" id="piStatusNm">재직</span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    setData: function(data) {
        const $card = this.$getCard();
        $card.find("#piNameUs").text(this.getValue(data.nameUs));
        $card.find("#piNameCn").text(this.getValue(data.nameCn));
        $card.find("#piResNo").text(this.getValue(data.resNo));
        $card.find("#piBirYmd").text(this.getValue(data.birYmd) + ' / ' + this.getValue(data.age));
        $card.find("#piStatusNm").text(this.getValue(data.statusNm));
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#psnlInfoCard");
    }
}