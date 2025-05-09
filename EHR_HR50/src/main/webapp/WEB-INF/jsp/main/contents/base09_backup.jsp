<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style>
    /* Style for the modal */
    #myModal {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        width: 800px;
        height: 612px;
        transform: translate(-50%, -50%);
        background-color: #fff;
        border: 1px solid #ccc;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        z-index: 1;
    }
    #myModal .modal-header{display:flex; align-items: center; padding:10px 18px; background-color:#2570f9; color:#ffffff; font-size: 14px;font-weight: bold;}
    #myModal .modal-header .btn-close{margin-left:auto;  color:#ffffff; background-color: transparent;}
    #myModal .modal-body{position:relative; padding: 118px 84px 150px 152px;}
    #myModal .modal-body .img-wrap{position:absolute; top: 110px; left: 44px;}
    #myModal .modal-body .img-wrap img{width:88px; height: auto;}
    #myModal .modal-body .modal-title{font-size: 28px; font-weight: 800; line-height: 1.43; text-align: left; color: #000;}
    #myModal .modal-body .modal-list{margin-top: 56px;}
    #myModal .modal-body .modal-list li{margin-top: 24px;}
    #myModal .modal-body .modal-list li:first-childe{margin-top: 0px;}
    #myModal .modal-body .modal-list li .label{display:inline-block; width:52px; margin-right:12px; font-size: 14px;font-weight: bold;line-height: 1.71;color: #000;}
    #myModal .modal-body .modal-list li .desc{position:relative; padding-left:24px; font-size: 14px; font-weight: 400; line-height: 1.71;color: #666;}
    #myModal .modal-body .modal-list li .desc::before{content:''; position: absolute; top:2px; left:0px; display:inline-block; width:1px; height:16px; background-color: #c7c7c7;}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		var result = Math.floor(secureRandom() * 10);
		$(".btn li:eq("+result+")").addClass("on");
		$("#subMain").addClass("bg"+result);
		$(".btn li").click(function() {
			$(".btn li").each(function() {
				$(this).removeClass("on");
			});
			$(this).addClass("on");
			$("#subMain").attr("class", "");
			$("#subMain").addClass("bg"+$(this).index());
		});
	});
</script>

</head>
<body style="background-color: #f8f8f8;">
<%-- <div id="subMain">
<c:choose>
	<c:when test="${map.mgrHelp == null}">
		<div class="txt" style="background: rgba(0,0,0,0)">
			
			국가에서 운영하는 4대보험외 사내에서 제공하는 다양한<br/>
			복리후생 제도들을 운영할 수 있도록 지원하고 정보를 제공합니다.
			
			<msg:txt mid='textBase09' mdef='국가에서 운영하는 4대보험외 사내에서 제공하는 다양한<br/>복리후생 제도들을 운영할 수 있도록 지원하고 정보를 제공합니다.'/>
		</div>
	</c:when>
	<c:otherwise>
		<div class="txt"  style="background: rgba(0,0,0,0)">
			${map.mgrHelp}
		</div>
	</c:otherwise>
</c:choose>

	<div class="btn">
	<ul>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
		<li></li>
	</ul>
	</div>
</div> --%>
<div class="welfare-content">
    <div class="page-title"><i class="mdi-ico round">volunteer_activism</i>직원복지</div>
    <div class="widget-wrap">
        <div class="widget-gutters">
            <div class="widget">
                <div class="widget-title">경조금/경조용품</div>
                <div class="widget-desc">임직원의 다양한 경조사를 지원합니다. <br>상세 내용은 매뉴얼을 확인합니다.</div>
                <div class="btn-wrap">
                    <button class="btn-common" id="openModalBtn">규정</button>
                </div>
                <div class="img-wrap">
                    <img src="/common/images/widget/widget_condolence_2x.png" alt="">
                </div>
            </div>
        </div>
        <div class="widget-gutters">
            <div class="widget">
                <div class="widget-title">사택/이사</div>
                <div class="widget-desc">사원 이상의 영업부 직원 중 서울 이외의 지역으로 인사발령을 받아 이동하는 경우 사택과 이사비를 지원합니다.<br>상세 내용은 규정을 확인합니다.</div>
                <div class="btn-wrap">
                    <button class="btn-common">규정</button>
                </div>
                <div class="img-wrap">
                    <img src="/common/images/widget/widget_company_housing_2x.png" alt="">
                </div>
            </div>
        </div>
        <div class="widget-gutters">
            <div class="widget">
                <div class="widget-title">생일&출산 포인트</div>
                <div class="widget-desc">생일자, 출산(예정)자를 대상으로 해당 월에 복지몰 포인트를 지급합니다.<br>상세 내용은 매뉴얼을 확인합니다.</div>
                <div class="btn-wrap">
                    <button class="btn-common">매뉴얼</button>
                    <!-- <button class="btn-common btn-mall">복지몰</button> -->
                </div>
                <div class="img-wrap">
                    <img src="/common/images/widget/widget_birthday_point_2x.png" alt="">
                </div>
            </div>
        </div>
        <div class="widget-gutters">
            <div class="widget">
                 <div class="widget-title">단체상해보험</div>
                <div class="widget-desc">임직원 여러분의 상해, 질병과 관련한 복지 증진을 위하여 단체상해보험을 가입하여 운용하고 있습니다.<br>보험청구 필요한 사항이 발생하였을 경우 가이드를 참고하여 접수 및 청구하여 활용해 주시기 바랍니다.</div>
                <div class="btn-wrap">
                    <button class="btn-common">가이드</button>
                </div>
                <div class="img-wrap">
                    <img src="/common/images/widget/widget_insurance_2x.png" alt="">
                </div>
            </div>
        </div>
        <div class="widget-gutters">
            <div class="widget">
                <div class="widget-title">종합건강검진</div>
                <div class="widget-desc">직원의 근무 만족도 및 삶의 질 향상을 위한 종합건강검진을 지원합니다. <br>상세 내용은 가이드를 확인합니다.</div>
                <div class="btn-wrap">
                    <button class="btn-common">가이드</button>
                </div>
                <div class="img-wrap">
                    <img src="/common/images/widget/widget_health_check_2x.png" alt="">
                </div>
            </div>

        </div>
        <div class="widget-gutters">
            <div class="widget">
                <div class="widget-title">장기근속포상경조금</div>
                <div class="widget-desc">임직원의 노고에 감사드리며 근속연수에 따라 포상금 및 기념패를 지급합니다. <br>근속연수는 매년 12월 말의 기준이며 상세 내용은 규정을 확인합니다.</div>
                <div class="btn-wrap">
                    <button class="btn-common">규정</button>
                </div>
                <div class="img-wrap">
                    <img src="/common/images/widget/widget_reward_2x.png" alt="">
                </div>
            </div>
        </div>
    </div>
</div>
<div id="myModal">
	<div class="modal-header">
	규정
	<button onclick="closeModal()" class="btn-close"><i class="mdi-ico close">close</i></button>
	</div>
	<div class="modal-body">
		<div class="modal-title">직원들의 리프레쉬를위해<br>회사에서 은혜적으로 부여하는 휴가입니다</div>
		<div class="img-wrap">
			<img src="/common/images/widget/widget_condolence_2x.png" alt="">
		</div>
		<ul class="modal-list">
			<li><span class="label">대상</span><span class="desc">매년 9월 기준 근속연수 1년 이상 근로자</span></li>
			<li><span class="label">기간</span><span class="desc">4일 (유급, 단PT의 경우 근무시간에 비례해서 지급)</span></li>
			<li><span class="label">신청방법</span><span class="desc">WFS(하기 링크) 접속 🡪 ‘휴무’🡪 ‘내 휴무‘ 🡪 ‘새 요청생성‘ 🡪 “리프레쉬</span></li>
			<li><span class="label">필요서류</span><span class="desc">불필요</span></li>
		</ul>
	</div>	
</div>
<script>
    // Get references to the modal and the button
    var modal = document.getElementById('myModal');
    var openModalBtn = document.getElementById('openModalBtn');

    // Function to open the modal
    function openModal() {
        modal.style.display = 'block';
    }

    // Function to close the modal
    function closeModal() {
        modal.style.display = 'none';
    }

    // Attach the openModal function to the button click event
    openModalBtn.addEventListener('click', openModal);
</script>
</body>
</html>
