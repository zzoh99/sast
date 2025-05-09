<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<script>

	var layoutLayer = {
		id: 'layoutLayer'
	}

	var layoutLayerFn = {
		iframeLoad: false,
		isProgress: false,
		$getModal: function() {
			return $('#modal-' + layoutLayer.id);
		},
		$getModalBody: function() {
			return this.$getModal().find(".modal_body");
		},
		$getAuthorFrame: function() {
			return this.$getModal().find("#authorFrame");
		},
		init: async function() {
			this.setModalTitle();
			this.initViews();

			await this.initLevelCode();
			await this.initApproverLine();

			this.callIframeBody();
			this.addEvents();
		},
		setModalTitle: function() {
			if ('${uiInfo.titleYn}' === 'Y') {
				const obj = this.$getModal().find('.layer-modal-header').children('#inputTitle');
				this.$getModal().find('div.layer-modal-header span.layer-modal-title').hide();
				obj.show();
				obj.val('${uiInfo.applTitle}');
			} else {
				this.$getModal().find('div.layer-modal-header span.layer-modal-title').text('${uiInfo.applTitle}');
			}
		},
		callIframeBody: function() {
			iframeOnLoad("0px");
		},
		addEvents: function() {
			this.$getAuthorFrame().on("load", function() {
				// 신청상세 화면 높이 재측정
				layoutLayerFn.setIframeHeight(layoutLayer.id);
			});
		},
		setIframeHeight: function(id) {
			const ifrm = document.getElementById(id);
			if (ifrm) {
				ifrm.style.visibility = 'hidden';
				ifrm.style.height = ifrm.contentDocument.body.scrollHeight + "px";
				ifrm.style.visibility = 'visible';
			}
		}
	};

	$(function() {
		layoutLayerFn.init();
	});

	function closeApprovalMgrLayer() {
		const modal = window.top.document.LayerModalUtility.getModal(layoutLayer.id);
		modal.fire('approvalMgrLayerTrigger', {}).hide();
	}

	/**
	 * 상세화면 iframe 내 높이 재조정.
	 * @param ih
	 * @modify 2024.04.23 Det.jsp 내에서 부모의 iframeOnLoad를 호출할 때 아직 화면이 그려지기 전에 iframe의 높이를 지정하는 경우가 있어 0.3초 후 다시 높이를 조정. by kwook
	 */
	function iframeOnLoad(ih) {
		try {
			setTimeout(function() {
				const ih2 = parseInt((""+ih).split("px").join(""));
				let wrpH = 0;
				layoutLayerFn.$getAuthorFrame().contents().find(".wrapper").children().each((idx, ele) => wrpH += $(ele).outerHeight(true));
				if (wrpH > ih2)
					layoutLayerFn.$getAuthorFrame().height(wrpH);
				else
					layoutLayerFn.$getAuthorFrame().height(ih2);
			}, 300);

			layoutLayerFn.iframeLoad = true;
		} catch(e) {
			layoutLayerFn.$getAuthorFrame().height(ih);
			layoutLayerFn.iframeLoad = true;
		}
	}
</script>
<div class="wide wrapper modal_layer ux_wrapper bg-gray">
	<div class="modal_body approval">

		<div class="d-flex gap-16">
			<div class="card bg-white pa-24 rounded-16 flex-1">
				<!-- <p class="txt_title_xs sb txt_left mb-12">신청내용</p> -->
				<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:100px; min-height:317px;"></iframe>

				<div class="footer">
					<button class="btn lg outline w-full" id="btnClose">확인</button>
				</div>
			</div>
		</div>
		<form id="authorForm" name="form">
			<input id="widgetParams" 	name="widgetParams" 	type="hidden" value="${params}"/>
		</form>
	</div>
</div>