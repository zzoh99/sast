<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>알림</title>
<style>
	.layer-modal-header {border-bottom: 0 !important;}
	.layer-modal-header + div {overflow-y:auto !important;}
	.alert {background: none; position: relative;}
	.alert .alarm-alert {transform: none; right: 0; margin-left: 0; max-width: none;}
	.alert .alarm-alert .alert-content {max-height: none;}
	.alert .alarm-alert .alert-content .alert-body {max-height: none; padding: 0;}
	.alert .alarm-alert .alert-content .alert-body .alert-box .alarm-list .common {width: 100%;}
	.alert .alarm-alert .alert-content .alert-body .alert-box .alarm-list .common .tit {background-color: transparent; padding: 0; margin-right:8px;}
	.modal_layer .modal_footer {justify-content: space-between !important;}
	.modal_layer .modal_footer .custom-label {justify-content: flex-end;}
	.modal_layer .modal_body {padding: 0 !important;}
	.icon-btn .mdi-ico {font-size: 18px; opacity:.5;}
</style>
<script type="text/javascript">

	$(function() {

		const modal = window.top.document.LayerModalUtility.getModal('alertPanelLayer');

		doAction("INIT");


		if (getCookie("panalAlertClose") != null) {
			var today = new Date();

			var tMonth = today.getMonth() + 1
			tMonth = tMonth < 10 ? "0" + tMonth : tMonth;
			var tDay = today.getDate()
			tDay = tDay < 10 ? "0" + tDay : tDay;

			var cookieValue = _connect_I_ + "|" + today.getFullYear() + tMonth + tDay;

			if (getCookie("panalAlertClose") == cookieValue) {
				// 오늘 하루 그만 보기 이미 체크된 경우면 알림 화면 열지 않게 하기 위함
				$('#doNotShowTodayDiv').hide();
			}
		}
		bindClearButtons();
	})

	async function doAction(type) {
		if (type === "INIT") {
			setCommonAlert();
			setPersonalAlert();
			addBtnEvent();
		} else if (type === "INIT_TOAST") {
			setPersonalAlert();
		}
	}

	function renderCommonAlert(data) {
		const _alarmList = $(".alert-default ul.alarm-list");
		if (_alarmList.length > 0) {
			// 화면 초기화
			_alarmList.empty();

			if (data) {
				if(data.length === 0) {
					_alarmList.html($("<li/>", { "class" : "mat10 mab10"}).text("등록된 알림사항이 없습니다."));
				} else {
					data.forEach((obj, idx) => {
						let _li = `<li>
									   <div class="tit-div common" data-url="\${obj.linkUrl}">
										   <div class="info">
											   <span class="date">\${obj.regDate}</span>
											   <div class="btns blue-btns sm-btns">
												   <button class="btn">바로가기</button>
											   </div>
										   </div>
										   <span class="caption">\${obj.title}</span>
									   </div>
								   </li>`;

						_alarmList.append($(_li));
					});

					_alarmList.find("div.tit-div").off("click").on('click', function(e) {
						const link = $(this).attr('data-url');
						if (link)
							goSubPage('', '', '', '', link);
					});
				}
			}
		}
	}

	function renderPersonalAlert(data) {
		const _alarmList = $(".alert-personal ul.alarm-list");
		if (_alarmList.length > 0) {
			// 화면 초기화
			_alarmList.empty();

			if (data) {
				if(data.length == 0) {
					_alarmList.html($("<li class='noPsnlAlert'/>", {}).text("새로운 개인 알림이 없습니다."));
				} else {
					data.forEach((obj, idx) => {
						let _li = '';
						//2024-08-27 링크가 있는 경우 임시 스타일 수정 - 강상구
						//data-surl="\${obj.surl}"
						if(obj.nLink != '') {
							_li = `<li>
								       <div class="info">
										   <span class="date">\${obj.regDate}</span>
										   <button type="button" class="btns no-style icon-btn pointer toast-delete" onclick="javascript:deleteToastAlert('\${obj.seq}')">
											   <i class="mdi-ico">close</i>
										   </button>
									   </div>
									   <div class="toast_div common" data-path="\${obj.path}"
										data-url="\${obj.nLink}" data-surl="\${obj.surl}"
									   		style="width: 100%;display: flex;justify-content: space-between;">
										   <div>
										   		<span class="tit">\${obj.nTitle}</span>
										   		<span class="caption">\${obj.nContent}</span>
										   </div>
										   <div class="btns blue-btns sm-btns">
												<button class="btn">바로가기</button>
										   </div>
									   </div>
								   </li>`;

							$(_li).find("div.toast_div").addClass("pointer");
						}else{
							_li = `<li>
								       <div class="info">
										   <span class="date">\${obj.regDate}</span>
										   <button type="button" class="btns no-style icon-btn pointer toast-delete" onclick="javascript:deleteToastAlert('\${obj.seq}')">
											   <i class="mdi-ico">close</i>
										   </button>
									   </div>
									   <div class="toast_div common" style="width: 100%;">
										   <span class="tit">\${obj.nTitle}</span>
										   <span class="caption">\${obj.nContent}</span>
									   </div>
								   </li>`;
						}

						_alarmList.append($(_li));
					});

					_alarmList.find("div.toast_div").off("click").on('click', function(e) {
						const link = $(this).attr('data-url');
						const path = $(this).attr('data-path');

						var inPrgCd = $('<input type="hidden" name="prgCd" value="'+ path+'" />')

						var form = $('<form></form>');
						form.append(inPrgCd);
						$('body').append(form);

						var result = ajaxCall("/geSubDirectMap.do", form.serialize(), false).map;

						var code = result.mainMenuCd;
						var prgCd = result.prgCd;

						//cookie set
						const qryString = link.split('&')
						for(var i = 0; i < qryString.length; i++){
							if(i > 0){
								const data = qryString[i].split('=');
								setCookie(data[0], data[1] ,1000);
							}
						}

						if($("#subForm").length > 0 ){
							//추가 탭 생성
							window.top.goOtherSubPage("", "", "", "", prgCd);
						}else{
							openSubPage(code, '', '', '', prgCd);
						}
						closeCommonLayer('alertPanelLayer');
					});
/*
					$(".nTitle", _listEle).on("click", function(e){
						var _seq = $(this).attr("seq");

						if( $("li[seq='" + _seq + "']", _listEle).hasClass("active") ) {
							$("li[seq='" + _seq + "']", _listEle).removeClass("active");
							$("li[seq='" + _seq + "'] .nContent", _listEle).slideUp();
						} else {
							$("li[seq='" + _seq + "']", _listEle).addClass("active");
							$("li[seq='" + _seq + "'] .nContent", _listEle).slideDown();

							// 읽지 않은 알림인 경우
							if( $("li[seq='" + _seq + "'] .nTitle", _listEle).hasClass("readN") ) {
								updateAlertInfoReadYn(_seq);
							}
						}
					});
 */
				}
			}
		}
	}

	function deleteToastAlert(seq) {
		$.ajax({
			url :"/deleteAllAlert.do",
			dateType : "json",
			type:"post",
			data: {seq:seq},
			success: function( data ) {
				if (data.Message !== "") {
					alert(data.Message);
				}else{
					doAction("INIT_TOAST");
				}
			},
			error:function(e){
				alert(e.responseText);
			}
		});
	}

	async function deleteAllPersonalAlert() {

		const isExistsPersonalAlert = $(".alert-personal ul.alarm-list").children(":not(.noPsnlAlert)").length > 0;
		if (!isExistsPersonalAlert) {
			alert("삭제할 개인 알림이 없습니다.");
			return;
		}

		if (!confirm("모든 개인 알림을 삭제하시겠습니까?")) return;

		const data = await callFetch("${ctx}/deleteAllAlert.do", "");
		if (data.isError) {
			alert(data.errMsg);
			return;
		}

		if (data.Code > 0) {
			doAction("INIT_TOAST");
		} else {
			alert(data.Message);
		}
	}

	function addBtnEvent() {
		$("#btnDelAllPersonalAlert").on("click", function(e) {
			deleteAllPersonalAlert();
		})

		$("#doNotShowTodayDiv, #doNotShowToday").on("click", function(e) {
			closePanalAlert(_connect_I_);
			closeCommonLayer('alertPanelLayer');
		})
	}

	function setCommonAlert() {
		ajaxCall2("${ctx}/getPanalAlertList.do"
				, ""
				, true
				, null
				, function(data) {
					if (data && data.result) {
						const alertData = data.result;
						renderCommonAlert(alertData);
					}
				});
	}

	function setPersonalAlert() {
		ajaxCall2("${ctx}/getAlertInfoList.do"
				, ""
				, true
				, null
				, function(data) {
					if (data && data.DATA) {
						const toastAlertData = data.DATA;
						renderPersonalAlert(toastAlertData);
					}
				});
	}

	function clearAlarmList($alertBox) {
		$alertBox.find('ul.alarm-list').empty();
	}
	function bindClearButtons() {
		$(document).on('click', '.alert-box .tit a', function(e) {
			e.preventDefault();
			// 클릭된 버튼의 가장 가까운 .alert-box 를 찾아서 리스트 삭제
			const $box = $(this).closest('.alarm-box');
			clearAlarmList($box);
		});
	}
</script>

</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<div class="alert">
				<div class="alarm-alert">
					<div class="alert-content">
	<%--						<div class="alert-header">
								<h5 class="alert-title">알림</h5>
								<p class="alert-close">
									<button type="button" class="no-style btn-close">
										<i class="mdi-ico">close</i>
									</button>
								</p>
							</div>--%>
						<div class="alert-body">
							<div class="alert-box alert-default">
								<h6 class="tit">공통 알림</h6>
								<ul class="alarm-list">
<%--									<li>--%>
<%--										<div class="common">--%>
<%--											<div class="info">--%>
<%--												<span class="date">2023.01.01 09:01</span>--%>
<%--												<div class="btns blue-btns sm-btns">--%>
<%--													<button class="btn">바로가기</button>--%>
<%--												</div>--%>
<%--											</div>--%>
<%--											<!-- <span class="tit"><span class="new">N</span>일반</span> -->--%>
<%--											<span class="caption">댕댕님의 평가 [2023년 상반기 업적평가] [검토]가 완료되었습니다.</span>--%>
<%--										</div>--%>
<%--									</li>--%>
								</ul>
							</div>
							<div class="alert-box alert-personal">
								<h6 class="tit">개인 알림
									<a id="btnDelAllPersonalAlert" href="#" class="ml-auto delete-all">일괄삭제</a>
								</h6>
								<ul class="alarm-list">
<%--									<li>--%>
<%--										<div class="common">--%>
<%--											<div class="info">--%>
<%--												<span class="date">2023.01.01 09:01</span>--%>
<%--												<button class="btns no-style icon-btn pointer">--%>
<%--													<i class="mdi-ico">close</i>--%>
<%--												</button>--%>
<%--											</div>--%>
<%--											<span class="tit">일반</span>--%>
<%--											<span class="caption">댕댕님의 평가 [2023년 상반기 업적평가] [검토]가 완료되었습니다.</span>--%>
<%--										</div>--%>
<%--									</li>--%>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="modal_footer">
			<div id="doNotShowTodayDiv" class="custom-label">
				<input type="checkbox" id="doNotShowToday" name="doNotShowToday" class="">
				<label for="doNotShowToday">오늘 하루 그만보기</label>
			</div>&nbsp;&nbsp;&nbsp;
			<a href="javascript:closeCommonLayer('alertPanelLayer');" class="btn outline_gray">닫기</a>
		</div>
	</div>
</body>
</html>