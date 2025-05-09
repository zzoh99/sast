<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
	<head>
		<title>우리회사 복리후생</title>
		<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
		<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
		<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

		<script type="text/javascript">
			$(function() {
                init();
			});

            async function init() {
                removeAllCards();
                const companyBenefits = await getOurCompanyBenefits();
                const categories = getCategories(companyBenefits.categories);
                renderBenefitsCards(companyBenefits.benefits, categories);
                initCardEvent();
            }

            /**
             * 그려져 있던 모든 복리후생 카드리스트 삭제
             */
            function removeAllCards() {
                $(".apply_req_wrap .contents").html("");
            }

            async function getOurCompanyBenefits() {
                const result = await fetch("${ctx}/OurBenefitsSta.do?cmd=getOurCompanyBenefits", {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: ""
                });
                const json = await result.json();
                if (json.message != null && json.message) {
                    alert(json.message);
                }
                return json;
            }

            /**
             * 카테고리 별 색상
             * @param categories
             * @returns {object}
             */
            function getCategories(categories) {
                const colorList = ["green", "blue", "", "tan", "indigo", "red", "pink", "scarlet", "yellow"];
                let categoryInfo = {};

                let category;
                for (category of categories) {
					const num = (category.categoryNo - 1) % 9;
                    categoryInfo[category.categoryNm] = {
                        color: colorList[num]
                    };
                }

                return categoryInfo;
            }

            function renderBenefitsCards(benefits, categories) {
                let benefit;
                for (benefit of benefits) {
                    if (benefit.categoryNm != null && benefit.categoryNm !== "") {
                        benefit.categoryColor = categories[benefit.categoryNm].color;
                    }
                    const html = getBenefitCardHtml(benefit);
                    $(".apply_req_wrap .contents").append(html);
					setCardText(benefit);
                }
            }

            function getBenefitCardHtml(benefit) {
                let categoryHtml = ``;
                if (benefit.categoryNm != null && benefit.categoryNm !== "") {
                    categoryHtml = `<div class="chip_wrap">
                                        <span class="chip ${'${benefit.categoryColor}'}"></span>
                                    </div>`;
                }
                return `<div class="card" data-id="${'${benefit.bnftCd}'}" data-url="${'${benefit.redirectUrl}'}">
                            <div class="card_inner">
                                ${'${categoryHtml}'}
                                <div class="title"></div>
                                <div class="desc">
                                </div>
                            </div>
                            <div class="icon_area">
                                <span class="icon ${'${benefit.icon}'}"></span>
                            </div>
                        </div>`;
            }

			function setCardText(benefit) {
				const $card = $(`.apply_req_wrap .contents .card[data-id="${'${benefit.bnftCd}'}"]`);
				$card.find(".chip").text(benefit.categoryNm);
				$card.find(".title").text(benefit.bnftNm);
				$card.find(".desc").text(benefit.note);
			}

            function openContent(url) {
                window.location.href = url;
            }

            function initCardEvent() {
                $(".apply_req_wrap .contents .card").on("click", function() {
                    const url = $(this).data("url");
                    openContent(url);
                })
            }
		</script>
	</head>
	<body class="bodywrap">
		 <div class="apply_req_wrap">
            <div class="page_title">우리회사 복리후생</div>
            <div class="contents">
<!--
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip green">카테고리분류</span>
                        </div>
                        <div class="title">경조금</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_01"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip blue">카테고리분류</span>
                        </div>
                        <div class="title">사내대출</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_02"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip">카테고리분류</span>
                        </div>
                        <div class="title">의료비</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_03"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip tan">카테고리분류</span>
                        </div>
                        <div class="title">리조트</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_04"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip indigo">카테고리분류</span>
                        </div>
                        <div class="title">학자금대출</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_05"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip red">카테고리분류</span>
                        </div>
                        <div class="title">동호회</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인
                            가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_06"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip pink">카테고리분류</span>
                        </div>
                        <div class="title">선물신청</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_07"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip scarlet">카테고리분류</span>
                        </div>
                        <div class="title">자원예약</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_08"></span>
                    </div>
                </div>
                <div class="card">
                    <div class="card_inner">
                        <div class="chip_wrap">
                            <span class="chip yellow">카테고리분류</span>
                        </div>
                        <div class="title">명함신청</div>
                        <div class="desc">
                            e-HR에 접속 후 비밀번호를<br />입력하여 확인 가능합니다.
                        </div>
                    </div>
                    <div class="icon_area">
                        <span class="icon welfase_09"></span>
                    </div>
                </div>
-->
            </div>
        </div>
	</body>
</html>
