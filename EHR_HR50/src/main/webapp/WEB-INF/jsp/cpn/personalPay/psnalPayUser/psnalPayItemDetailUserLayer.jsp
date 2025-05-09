<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>항목세부내역 레이어</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

	<script type="text/javascript">
		$(function() {
			const modal = window.top.document.LayerModalUtility.getModal('psnalPayItemDetailUserLayer');
            const arg = modal.parameters;
            $("#searchPayActionCd").val(arg.payActionCd);

            init();
		});

        async function init() {
            const itemDetail = await getItemDetail();
            if (itemDetail == null) return;

            if (itemDetail.isOpenYn === "N") {
                alert("아직 임직원에게 오픈되지 않은 급여입니다. 담당자에게 문의 바랍니다.");

                closeItemDetailLayer();
                return;
            }

            renderItemDetail(itemDetail.list);
        }

        function renderItemDetail(list) {

            const $tbody = $(".salary_detail_list table tbody");
            $tbody.empty();

            if (list.length === 0) {
                const html = getNoDataHtml();
                $tbody.append(`<tr><td colspan="5">${'${html}'}</td></tr>`);
                return;
            }

            for (const item of list) {
                const html = getItemDetailHtml();
                $tbody.append(html);
                const $last = $tbody.children().last();
                setItemDetail($last, item);
            }
        }

        /**
         * 행 HTML 텍스트 조회
         * @returns {string}
         */
        function getItemDetailHtml() {
            return `<tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>`;
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
        function setItemDetail($el, item) {
            const getValue = (value) => {
                return (value == null || value === "") ? "-" : value;
            }

            const getSubtract = (mon1, mon2) => {
                const tMon1 = ((mon1 == null || mon1 === "") ? 0 : Number(mon1.replace(/,/gi, "")));
                const tMon2 = ((mon2 == null || mon2 === "") ? 0 : Number(mon2.replace(/,/gi, "")));
                return (tMon1 - tMon2).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }

            $el.find("td").eq(0).text(getValue(item.elementNm));
            $el.find("td").eq(1).text(getValue(item.basicMon));
            $el.find("td").eq(2).text(getValue(item.resultMon));
            $el.find("td").eq(3).text(getSubtract(item.basicMon, item.resultMon));
            $el.find("td").eq(4).text(getValue(item.note));
        }

        function closeItemDetailLayer() {
            const modal = window.top.document.LayerModalUtility.getModal('psnalPayItemDetailUserLayer');
            modal.fire('psnalPayItemDetailUserLayerTrigger', {}).hide();
        }

        async function getItemDetail() {
            const response = await fetch("${ctx}/PsnalPayUser.do?cmd=getPsnalPayItemDetailUser", {
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
<body class="hidden">
	<div class="wrapper modal_layer ux_wrapper salary_detail_list">
        <div class="modal_body">
            <input type="hidden" id="searchPayActionCd" name="searchPayActionCd"/>
            
            <table class="custom_table">
                <thead>
                    <tr>
                        <th>항목명</th>
                        <th>기준금액</th>
                        <th>계산금액</th>
                        <th>차이금액</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>

        </div>
		<div class="modal_footer ">
			<btn:a href="javascript:closeCommonLayer('psnalPayItemDetailUserLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
    </div>
</body>
</html>
