<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="btn" tagdir="/WEB-INF/tags/button" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<title>급여명세서(계산방법 포함)</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

	<script type="text/javascript">
		$(function() {
			const modal = window.top.document.LayerModalUtility.getModal('psnalPayFormulaUserLayer');
            const arg = modal.parameters;
            $("#searchPayActionCd").val(arg.payActionCd);

            init();
		});

        async function init() {
            const formula = await getFormula();
            if (formula == null) return;

            if (formula.isOpenYn === "N") {
                alert("아직 임직원에게 오픈되지 않은 급여입니다. 담당자에게 문의 바랍니다.");

                closeFormulaLayer();
                return;
            }

            renderFormula("pay", formula.pay);
            renderFormula("deduct", formula.deduct);
        }

        function renderFormula(type = "pay", list) {

            let $labelList;
            if (type === "deduct") {
                $labelList = $("#deductFormulaArea .label_list");
            } else {
                $labelList = $("#payFormulaArea .label_list");
            }
            $labelList.empty();

            if (list.length === 0) {
                const html = getNoDataHtml();
                $labelList.append(html);
                return;
            }

            for (const item of list) {
                const html = getFormulaHtml();
                $labelList.append(html);
                const $last = $labelList.children().last();
                setFormula($last, item);
            }
        }

        /**
         * 행 HTML 텍스트 조회
         * @returns {string}
         */
        function getFormulaHtml() {
            return `<div>
                        <div class="d-flex justify-between mb-4">
                            <span class="txt_body_m txt_secondary"></span>
                            <span class="txt_title_xs sb"></span>
                        </div>
                        <p class="txt_body_sm txt_tertiary"></p>
                    </div>`;
        }

        function getNoDataHtml() {
            return `<div class="h-84 d-flex flex-col justify-between align-center my-12">
						<i class="icon no_list"></i>
						<p class="txt_body_sm txt_tertiary">조회된 데이터가 없습니다.</p>
					</div>`;
        }

        /**
         * 행 별 데이터 값 설정
         * @param $el
         * @param item
         */
        function setFormula($el, item) {
            const getValue = (value) => {
                return (value == null || value === "") ? "-" : value;
            }

            $el.find(".txt_body_m").text(getValue(item.elementNm)); // 항목명
            $el.find(".sb").text(getValue(item.resultMonFor)); // 금액
            $el.find(".txt_body_sm").text(getValue(item.formula)); // 계산방법
        }

        function closeFormulaLayer() {
            const modal = window.top.document.LayerModalUtility.getModal('psnalPayFormulaUserLayer');
            modal.fire('psnalPayFormulaUserLayerTrigger', {}).hide();
        }

        async function getFormula() {
            const response = await fetch("${ctx}/PsnalPayUser.do?cmd=getPsnalPayFormulaUser", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: "searchPayActionCd=" + $("#searchPayActionCd").val()
            });

            const json = await response.json();
            if (json.msg != null && json.msg !== "") {
                alert(json.msg);
                return null;
            }
            return json.map;
        }
	</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer ux_wrapper salary_detail_list">
         <div class="modal_body">
             
             <div class="card rounded-16 pa-24 mb-16 bg-white" id="payFormulaArea">
                 <div class="title_label_list">
                     <div class="title">
                         <p class="txt_title_xs sb txt_left">수당계산방법</p>
                     </div>
                     <div class="label_list gap-16">
                     </div>
                 </div>
             </div>
     
             <div class="card rounded-16 pa-24 bg-white" id="deductFormulaArea">
                 <div class="title_label_list">
                     <div class="title">
                         <p class="txt_title_xs sb txt_left">공제총액</p>
                     </div>
                     <div class="label_list gap-16">
                     </div>
                 </div>
             </div>


        </div>
        <div class="modal_footer ">
			<btn:a href="javascript:closeCommonLayer('psnalPayFormulaUserLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
     </div>
</body>
</html>
