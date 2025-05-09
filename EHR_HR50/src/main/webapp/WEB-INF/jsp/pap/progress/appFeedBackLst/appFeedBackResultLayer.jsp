<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- HR UX 개선 신규 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">

<div class="hr-container target-modal p-0 size middle">
	<div class="modal-content border-0">
		<div class="modal_body p-0" id="">
			<ul class="process-wrap row box p-0 flex-nowrap">
				<li class="box box-border flex-column active">
					<div class="cate">
						<p class="badge green">자기평가</p>
						<!-- marginal:m등급 / non:n등급 -->
						<span class="ranked visible outstanding"></span>
					</div>
					<div class="d-inline-block">
						<span class="name">김이수</span>
						<span class="caption-sm text-boulder">대리</span>
					</div>
					<p class="caption-sm text-boulder pt-1">인사총무실</p>
					<p class="caption-sm text-boulder">프로젝트관리(EB)</p>
					<p class="evaluation visible done date"><i class="mdi-ico mr-1"></i>2023.12.02</p>
				</li>
				<li class="box box-border flex-column">
					<div class="cate">
						<p class="badge blue">평가</p>
						<span class="ranked visible non"></span>
					</div>
					<div class="d-inline-block">
						<span class="name">김팀장</span>
						<span class="caption-sm text-boulder">팀장</span>
					</div>
					<p class="caption-sm text-boulder pt-1">인사총무실</p>
					<p class="caption-sm text-boulder">프로젝트관리(EB)</p>
					<p class="evaluation visible done date"><i class="mdi-ico mr-1"></i>2023.12.02</p>
				</li>
				<li class="box box-border flex-column">
					<div class="cate">
						<p class="badge blue">검토</p>
						<span class="ranked visible marginal"></span>
					</div>
					<div class="d-inline-block">
						<span class="name">박이사</span>
						<span class="caption-sm text-boulder">이사</span>
					</div>
					<p class="caption-sm text-boulder pt-1">인사총무실</p>
					<p class="caption-sm text-boulder">프로젝트관리(EB)</p>
					<p class="evaluation visible done date"><i class="mdi-ico mr-1"></i>2023.12.02</p>
				</li>
				<li class="box box-border flex-column">
					<div class="cate">
						<p class="badge blue">재검토</p>
						<span class="ranked visible non"></span>
					</div>
					<div class="d-inline-block">
						<span class="name">김팅장</span>
						<span class="caption-sm text-boulder">부장</span>
					</div>
					<p class="caption-sm text-boulder pt-1">인사총무실</p>
					<p class="caption-sm text-boulder">프로젝트관리(EB)</p>
					<p class="evaluation visible done date"><i class="mdi-ico mr-1"></i>2023.12.02</p>
				</li>
				<!-- 최종등급 -->
				<li class="box box-border flex-column final">
					<div class="cate">
						<p class="badge">최종등급</p>
					</div>
					<div class="d-flex align-items-center h-100">
						<p>O</p>
						<a href=""><i class="mdi-ico help filled">help</i></a>
					</div>
				</li>
			</ul>
			<ul class="nav nav-tabs type1" id="tabs">
				<li class="nav-item">
					<a class="nav-link active" data-toggle="tab" href="#tab1">개인목표</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#tab2">직무공통목표</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" data-toggle="tab" href="#tab3">자기개발계획</a>
				</li>
			</ul>
			<div class="tab-content">
				<div class="tab-pane fade show active" id="tab1">
					<h4 class="h4 mb-2">개인목표</h4>
					<div class="box box-border row">
						<div class="d-flex align-items-center w-100">
							<strong class="badge green rounded-pill font-weight-bold mr-2">50%</strong>
							<p class="h4">경영계획(또는 품의비용) 대비 투자비용 절감률</p>
							<div class="info ml-auto">
								<p><span class="badge green mr-2">자기평가</span><span class="h3 text-color-basic">M</span></p>
								<p class="pl-3 ml-3"><span class="badge blue mr-2">1차평가</span><span class="h3 text-color-basic">O</span></p>
							</div>
						</div>
						<div class="box-list w-100">
							<div class="collapsed">
								<p class="md-dot pb-2">자기평가</p>
								<p class="caption">자기평가 내용입니다</p>
							</div>
						</div>
						<div class="box-list w-100">
							<div class="collapsed" data-toggle="collapse">
								<p class="md-dot pb-2">평가자 의견 (강점)</p>
								<p class="caption">강점에 대한 평가자의 의견입니다.</p>
							</div>
						</div>
						<div class="box-list w-100">
							<div class="collapsed" data-toggle="collapse">
								<p class="md-dot pb-2">평가자 의견 (개선점)</p>
								<p class="caption">개선점에 대한 평가자의 의견입니다.</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
</div>
<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>