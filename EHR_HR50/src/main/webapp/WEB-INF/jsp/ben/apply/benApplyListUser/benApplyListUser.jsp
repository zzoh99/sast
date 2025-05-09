<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>복리후생관리_신청서</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

	<script>
		$(document).ready(function() {
			// 예시 데이터 (JSP에서 동적으로 받아오셔도 됩니다)
			var listData = [
				// {
				// 	title:  "연차휴가 신청서",
				// 	date:   "2025-04-10",
				// 	status: "진행중",
				// 	statusCode: "ongoing",
				// 	name: "김도희",
				// 	type:   "연차신청서"
				// },
			]

			var itemsPerPage = 10;                // 페이지당 항목 수
			var currentPage  = 1;                 // 현재 페이지
			var totalPages   = Math.ceil(listData.length / itemsPerPage);

			init();

			function init(){
				$('#searchFromApplYmd').datepicker2();
				$('#searchToApplYmd').datepicker2();

				const typeList = getTypeList()
				console.log(typeList)
				let typeHtml = '<option value="">신청서 종류</option>';
				typeList.forEach(item => {
					typeHtml += '<option value="' + item.applCd + '">' + item.applNm + '</option>';
				})
				$('#applCd').html(typeHtml);

				// 초기 렌더
				doAction();

			}

			// 리스트 렌더링
			function renderList(page) {
				$('#dataList').empty();
				var start = (page - 1) * itemsPerPage;
				var end   = start + itemsPerPage;

				var listHtml = '';
				listData.slice(start, end).forEach(function(item, i) {
					let statusCode = 'pending';
					if(item.statusCode == '1'){
						statusCode = 'done';
					}else if(item.statusCode == '2'){
						statusCode = 'ongoing';
					}else{
						if(item.statusCode == '21'){
							statusCode = 'done';
						}else if(item.statusCode == '99'){
							statusCode = 'ongoing';
						}
					}

					listHtml += '    <li class="empDet" data="' + item.applSeq + '">';
                    listHtml += '        <div class="inner-wrap">';
                    listHtml += '            <div class="form-title">' + item.title + '</div>';
                    listHtml += '            <span class="list-type">' + item.applNm + '</span>';
                    listHtml += '            <span class="form-date">' + item.date + '</span>';
                    listHtml += '        </div>';
                    listHtml += '        <div class="ml-auto">';
                    listHtml += '            <span class="status ' + statusCode + '">' + item.status + '</span>';
                    listHtml += '            <span class="name">' + item.name + '</span>';
                    listHtml += '        </div>';
                    listHtml += '    </li>';
				});
				$('#dataList').html(listHtml);

			}

			// 페이징 렌더링
			function renderPagination() {
				var $pg = $('.ux_wrapper .pagination');
				$pg.empty();

				// 맨 앞 / 이전
				if (currentPage > 1) {
					$pg.append('<button class="page-link first"></button>');
					$pg.append('<button class="page-link prev"></button>');
				} else {
					$pg.append('<button class="page-link first" disabled></button>');
					$pg.append('<button class="page-link prev" disabled></button>');
				}

				// 페이지 번호
				let sPage = Math.floor((currentPage-1) / 10)*10 + 1;
				let ePage =  Math.floor((currentPage-1) / 10)*10 +10;
				if(ePage > totalPages){
					ePage = totalPages;
				}

				for (var i = sPage; i <= ePage; i++) {
					var cls = (i === currentPage ? 'active' : '');
					$pg.append('<button class="page-link page '+ cls +'" data-page="'+ i +'">' + i + '</button>');
				}

				// 다음 / 맨 뒤
				if (currentPage < totalPages) {
					$pg.append('<button class="page-link next"></button>');
					$pg.append('<button class="page-link last"></button>');
				} else {
					$pg.append('<button class="page-link next" disabled></button>');
					$pg.append('<button class="page-link last" disabled></button>');
				}
			}

			// 버튼 클릭 이벤트
			$(document).on('click', '.ux_wrapper .pagination button', function(e) {
				if ($(this).is('[disabled]')) return;  // 비활성화 상태면 무시

				if ($(this).hasClass('first')) {
					currentPage = 1;
				} else if ($(this).hasClass('prev')) {
					currentPage = Math.max(1, currentPage - 1);
				} else if ($(this).hasClass('next')) {
					currentPage = Math.min(totalPages, currentPage + 1);
				} else if ($(this).hasClass('last')) {
					currentPage = totalPages;
				} else { // 번호 버튼
					currentPage = parseInt($(this).data('page'), 10);
				}

				renderList(currentPage);
				renderPagination();
			});

			$("#btnSeach").on("click", function(e) {
				doAction();
			});

			$("#btnModifyPersonalInfo").on("click", function(e) {
				window.location.href = "/BenApplyUser.do?cmd=viewBenApplyTypeUser";
			});

			$(document).on('click', '.empDet', function(e) {
				const param = listData.filter(e => e.applSeq == $(this).attr('data'))[0];
				console.log(param)
				var applSeq		= param.applSeq;
				var applCd		= param.applCd;
				var applSabun 	= param.applSabun;
				var applInSabun = param.applInSabun;
				var applYmd 	= param.applYmd;
				var p = {
					searchApplCd: applCd
					, searchApplSeq: applSeq
					, adminYn: 'Y'
					, authPg: 'R'
					, searchSabun: applInSabun
					, searchApplSabun: applSabun
					, searchApplYmd: applYmd
				};
				var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
				gPRow = "";
				var initFunc = 'initResultLayer';
				pGubun = "viewApprovalMgrResult";
				var approvalMgrLayer = new window.top.document.LayerModal({
					id: 'approvalMgrLayer',
					url: url,
					parameters: p,
					width: 800,
					height: 815,
					title: param.title,
					trigger: [
						{
							name: 'approvalMgrLayerTrigger',
							callback: function(rv) {
								doAction();
							}
						}
					]
				});
				approvalMgrLayer.show();
			})

			function doAction(){
				const data = ajaxCall('BenApplyUser.do?cmd=getBenApplList', $("#srchFrm").serialize(), false);
				console.log(data)
				let resultList = [];
				data.DATA.forEach(item => {
					resultList.push({
						title: item.title,
						applNm: item.applNm,
						date: item.applYmd,
						status: item.applStatusCdNm,
						statusCode: item.applStatusCd,
						name: item.name,
						sabun: item.sabun,
						applSeq: item.applSeq,
						applCd: item.applCd,
						applSabun: item.applSabun,
						applInSabun: item.applInSabun,
						applYmd: item.applYmd,
					})
				})
				listData = resultList;
				currentPage = 1;
				totalPages   = Math.ceil(listData.length / itemsPerPage);
				renderList(currentPage);
				renderPagination();
			}

			function getTypeList() {
				const data = ajaxCall("${ctx}/BenApplyUser.do?cmd=getBenAppCodeList", "searchBizCd=BEN",false).DATA;
				return data;
			}

		});

	</script>
</head>
<div class="wrapper">
	<div class="ux_wrapper">
		<h2 class="page_title">복리후생신청</h2>
		<!-- 조회조건 -->
		<form id="srchFrm" name="srchFrm" >
			<input type="hidden" id="searchSabunName" name="searchSabunName" value="${ssnSabun}" />
			<div class="card d-flex align-center gap-16">
				<div class="select_wrap icon note">
					<select class="custom_select thin" name="applCd" id="applCd">
						<option value="" disabled selected hidden>신청서 종류</option>
					</select>
				</div>
				<div class="date_picker_wrap">
					<!-- 아래 img 태그는 지우시고 기존 개발에서 사용하시는대로 input.bbit-dp-input 에 .thin 클래스 추가하시면 됩니다. -->
					<input type="text" id="searchFromApplYmd" name="searchFromApplYmd" class="date2 bbit-dp-input thin" maxlength="7" autocomplete="off" placeholder="시작일자" />
					<input type="text" id="searchToApplYmd" name="searchToApplYmd" class="date2 bbit-dp-input thin" maxlength="7" autocomplete="off" placeholder="종료일자" />
				</div>
				<button type="button" id="btnSeach" class="btn sm outline ml-8">조회</button>
				<button type="button" id="btnModifyPersonalInfo" class="btn ml-auto dark">복리후생신청</button>
			</div>
		</form>
		<!--// 조회조건 -->
		<!-- 리스트 -->
		<ul id="dataList" class="borderLine-list"></ul>
		<!--// 리스트 -->
		<!-- 페이징 -->
		<div id="pagination" class="pagination mt-16"></div>
		<!--// 페이징 -->
	</div>
</div>
</html>