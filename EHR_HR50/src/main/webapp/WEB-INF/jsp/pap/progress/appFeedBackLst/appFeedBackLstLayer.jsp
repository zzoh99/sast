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
			<dl class="d-flex pb-5 bt-line gray mb-4">
				<dt class="profile">
					<p class="thumb"><img src="https://picsum.photos/600/600?random=0" alt="김이수"></p>
				</dt>
				<dd>
					<p class="name">김이수<span class="ml-2">대리</span></p>
					<p>인사총무실</p>
				</dd>
				<dd>
					<span>평가조직</span>
					<p class="font-weight-bold">인사총무실</p>
				</dd>
				<dd>
					<span>평가상태</span>
					<p class="font-weight-bold">프로젝트관리(EB)</p>
				</dd>
			</dl>
			<div class="d-flex justify-content-between align-items-center mb-2">
				<h4 class="h4">2023년 상반기 성과평가</h4>
				<button type="button" class="bt-outline">이의제기 신청</button>
			</div>
			<div class="scrollset">
                <table class="table table-fixed table-ib-sheet text-center">
                    <colgroup>
                        <col width="25%">
                        <col>
                    </colgroup>
                    <thead>
						<tr>
							<th>업적</th>
							<th>연봉</th>
							<th>역량</th>
						</tr>
                    </thead>
                    <tbody>
						<tr>
							<td>M</td>
							<td>-</td>
							<td>-</td>
						</tr>
                    </tbody>
                </table>
            </div>
			<h4 class="h4 mt-5 mb-2 d-flex align-items-center row"><i class="mdi-ico filled h3 mr-2">edit</i>이의제기 신청사유</h4>
			<textarea name="" id="" class="w-100 inputbox" rows="4" placeholder="이의제기 신청사유를 입력해주세요"></textarea>
			<div class="d-flex justify-content-between align-items-center mb-2 mt-5">
				<h4 class="h4">이의제기 조정등급</h4>
				<div class="btns big-btns ml-auto">
					<button class="btn red-btn border-0">반려</button>
					<button class="btn green-btn border-0">확정</button>
				</div>
			</div>
			<div class="scrollset">
                <table class="table table-fixed table-ib-sheet text-center">
                    <colgroup>
                        <col width="25%">
                        <col>
                    </colgroup>
                    <thead>
						<tr>
							<th>업적</th>
							<th>연봉</th>
							<th>역량</th>
						</tr>
                    </thead>
                    <tbody>
						<tr>
							<td>
								<select name="" id="" class="border-0 w-auto">
									<option value="">O</option>
									<option value="">E</option>
									<option value="">M</option>
									<option value="">B</option>
									<option value="">N</option>
								</select>
							</td>
							<td>-</td>
							<td>-</td>
						</tr>
                    </tbody>
                </table>
            </div>
			<h4 class="h4 mt-5 mb-2 d-flex align-items-center row"><i class="mdi-ico filled h3 mr-2">edit</i>이의제기 심의결과</h4>
			<textarea name="" id="" class="w-100 inputbox" rows="4" placeholder="이의제기 심의결과를 입력해주세요"></textarea>
		</div>
	</div>
	
</div>
<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>