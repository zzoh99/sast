var WORKINFO = {
    $el: null,
    previewData: {
        "hqNm": "인사관리본부",
        "workPeriod": "0년 4개월",
        "orgNm": "총무팀",
        "gempYmd": "2025-01-01",
        "jikweeNm": "대리",
        "empYmd": "2025-01-01",
        "jikchakNm": "팀원",
        "stfTypeNm": "특별채용",
        "manageNm": "정규직",
        "retYmd": "-",
        "workTypeNm": "총무",
        "orgJoinYmd": "2025-04-01",
        "jobNm": "창고관리",
        "currJikchakYmd": "2025-01-01"
    },
    /**
     * 항목 초기화
     * @param $el 부모 element
     * @param isPreview 예시 여부. true 일 경우 예시 데이터를 사용한다.
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
            const data = await callFetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserWorkInfo", "");
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
        return `<div class="card rounded-16 pa-24 bg-white" id="workInfoCard">
                    <div class="title_label_list">
                        <div class="title d-flex gap-8">
                            <i class="icon script size-16"></i>
                            <p class="txt_title_xs sb txt_left">근무정보</p>
                        </div>
                        <div class="label_list gap-12 d-grid grid-cols-2 gap-x-80">
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">본부</span>
                                <span class="txt_body_sm sb wiHqNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">근속기간</span>
                                <span class="txt_body_sm sb wiWorkPeriod"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">부서</span>
                                <span class="txt_body_sm sb wiOrgNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">그룹입사일</span>
                                <span class="txt_body_sm sb wiGempYmd"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">직위</span>
                                <span class="txt_body_sm sb wiJikweeNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">소속입사일</span>
                                <span class="txt_body_sm sb wiEmpYmd"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">직책</span>
                                <span class="txt_body_sm sb wiJikchakNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">고용구분</span>
                                <span class="txt_body_sm sb wiStfTypeNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">사원구분</span>
                                <span class="txt_body_sm sb wiManageNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">퇴직일</span>
                                <span class="txt_body_sm sb wiRetYmd"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">직군</span>
                                <span class="txt_body_sm sb wiWorkTypeNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">부서배치일</span>
                                <span class="txt_body_sm sb wiOrgJoinYmd"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">직무명</span>
                                <span class="txt_body_sm sb wiJobNm"></span>
                            </div>
                            <div class="d-flex justify-between">
                                <span class="txt_body_sm txt_secondary">직책승격일</span>
                                <span class="txt_body_sm sb wiCurrJikchakYmd"></span>
                            </div>
                        </div>
                    </div>
                </div>`;
    },
    setData: function(data) {
        const $card = this.$getCard();
        $card.find(".wiHqNm").text(this.getValue(data.hqNm));
        $card.find(".wiWorkPeriod").text(this.getValue(data.workPeriod));
        $card.find(".wiOrgNm").text(this.getValue(data.orgNm));
        $card.find(".wiGempYmd").text(this.getValue(data.gempYmd));
        $card.find(".wiJikweeNm").text(this.getValue(data.jikweeNm));
        $card.find(".wiEmpYmd").text(this.getValue(data.empYmd));
        $card.find(".wiJikchakNm").text(this.getValue(data.jikchakNm));
        $card.find(".wiStfTypeNm").text(this.getValue(data.stfTypeNm));
        $card.find(".wiManageNm").text(this.getValue(data.manageNm));
        $card.find(".wiRetYmd").text(this.getValue(data.retYmd));
        $card.find(".wiWorkTypeNm").text(this.getValue(data.workTypeNm));
        $card.find(".wiOrgJoinYmd").text(this.getValue(data.orgJoinYmd));
        $card.find(".wiJobNm").text(this.getValue(data.jobNm));
        $card.find(".wiCurrJikchakYmd").text(this.getValue(data.currJikchakYmd));
    },
    getValue: function(val) {
        return (val == null || val === "") ? "-" : val;
    },
    $getCard: function() {
        return this.$el.find("#workInfoCard");
    }
}