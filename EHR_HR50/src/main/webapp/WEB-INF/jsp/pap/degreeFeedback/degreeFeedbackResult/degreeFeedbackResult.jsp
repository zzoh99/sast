<!-- 부트스트랩 사용시 우선순위 순서 필요 -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>다면평가결과</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {
    });
	
</script>
</head>
<body>
	<div class="wrapper">
		<!-- include 기본정보 page TODO -->
		<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
		<div class="hr-container">
			<table class="table table-wrap table-fixed border-bottom-0 mb-0">
				<colgroup>        
					<col width="17%">    
				</colgroup>
				<tbody>
					<tr>
						<th><sup>*</sup>평가년도</th>
						<td>
							<div class="d-flex justify-content-between">	
								<select class="col-2" name="" id="" required>
									<option value="">분류</option>
									<option value="">분류</option>
									<option value="">분류</option>
								</select>
								<div class="btns navy-btns">
									<button class="btn" type="button">조회</button>
								</div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<section class="sect-sub">
				<div class="d-flex">
					<div class="bx bg-gray"><i class="mdi-ico icon-green">track_changes</i><h3 class="h3">목표</h3></div>
					<ul class="row">
						<li class="bx next">
							<a class="w-100" href="">
								<strong class="badge green mb-2">등록완료</strong>
								<p class="subject">2023년 조직 목표</p>
								<div class="date d-flex justify-content-between w-100">
									<span class="cate">목표등록</span>
									<span>2023.01.01 - 2023.06.30</span>
								</div>
								<div class="d-flex align-items-center justify-content-between w-100">
									<div class="progress">
										<div class="progress-bar" role="progressbar" style="width: 25%" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
									</div>
									<span class="current">1<span class="total">/2</span></span>
								</div>
							</a>
							<i class="mdi-ico ico-next">expand_circle_down</i>
						</li>
						<li class="bx next">
							<a class="w-100" href="">
								<strong class="badge blue mb-2">승인요청</strong>
								<p class="subject">2023년 조직 목표</p>
								<div class="date d-flex justify-content-between w-100">
									<span class="cate">목표등록</span>
									<span>2023.01.01 - 2023.06.30</span>
								</div>
								<div class="info">
									<p>조직명</p>
									<p>직무명</p>
								</div>
							</a>
							<i class="mdi-ico ico-next">expand_circle_down</i>
						</li>
						<li class="bx">
							<a class="w-100" href="">
								<strong class="badge pink mb-2">승인반려</strong>
								<p class="subject">2023년 조직 목표</p>
								<div class="date d-flex justify-content-between w-100">
									<span class="cate">목표등록</span>
									<span>2023.01.01 - 2023.06.30</span>
								</div>
								<div class="info">
									<p>조직명</p>
									<p>직무명</p>
								</div>
							</a>
							<i class="mdi-ico ico-next">expand_circle_down</i>
						</li>
						<!-- not:미등록, disabled:미평가 -->
						<li class="bx not">
							<a class="w-100" href="">
								<strong class="badge gray mb-2">미등록</strong>
								<p class="subject">2023년 조직 목표</p>
								<div class="date d-flex justify-content-between w-100">
									<span class="cate">목표등록</span>
									<span>2023.01.01 - 2023.06.30</span>
								</div>
								<div class="info">
									<p>조직명</p>
									<p>직무명</p>
								</div>
							</a>
							<i class="mdi-ico ico-next">expand_circle_down</i>
						</li>
					</ul>
				</div>
				<div class="d-flex">
					<div class="bx bg-gray"><i class="mdi-ico filled icon-green">assignment</i><h3 class="h3">평가</h3></div>
					<ul class="row">
						<li class="bx disabled">
							<a class="w-100" href="">
								<strong class="badge gray mb-2">미평가</strong>
								<p class="subject">2023년 조직 목표</p>
								<div class="date d-flex justify-content-between w-100">
									<span class="cate">목표등록</span>
									<span>2023.01.01 - 2023.06.30</span>
								</div>
								<div class="info">
									<p>조직명</p>
									<p>직무명</p>
								</div>
							</a>
							<i class="mdi-ico ico-next">expand_circle_down</i>
						</li>
					</ul>
				</div>
				<div class="d-flex">
					<div class="bx bg-gray"><i class="mdi-ico filled icon-green">speaker_notes</i><h3 class="h3">면담</h3></div>
					<ul class="row">
						<li class="bx">
							<a class="w-100" href="">
								<strong class="badge green mb-2">등록완료</strong>
								<p class="subject">2023년 조직 목표</p>
								<div class="date d-flex justify-content-between w-100">
									<span class="cate">목표등록</span>
									<span>2023.01.01 - 2023.06.30</span>
								</div>
								<div class="info">
									<p>조직명</p>
									<p>직무명</p>
								</div>
							</a>
							<i class="mdi-ico ico-next">expand_circle_down</i>
						</li>
					</ul>
				</div>
			</section>
		</div>
	</div>
</body>
</html>