<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<% request.setAttribute("uploadType", "appl"); %>
<script>

	var approvalLayer = {
		id: 'approvalMgrLayer',
		fileSeq: '',
		prgExists: false,
		approvalLine: [],
		referersLine: [],
		inapplLine: [],
	}

	var approvalLayerFn = {
		iframeLoad: false,
		isProgress: false,
		$getModal: function() {
			return $('#modal-' + approvalLayer.id);
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
		initViews: function() {

			if ('${uiInfo.orgLevelYn}' === 'Y')
				this.$getModalBody().find('#approvalLayerLvlCode').show();

<c:if test="${uiInfo.fileYn == 'Y'}">
				this.$getModalBody().find('#uploadDiv').show();
</c:if>

			//신청서에서 height-full 선택시 ui 수정
			if (this.$getModal().find('div.modal-size').attr('class').includes('height-full')) {
				this.$getModal().find('div.modal-size').css('max-height', '100vh');
				this.$getModalBody().css('max-height', 'calc(100vh - 150px)');
				this.$getModalBody().css('height', '100%');
			}

			//결재선 변경이 없는 경우 처리
			if ('${uiInfo.appPathYn}' === 'Y' && '${uiInfo.orgLevelYn}' !== 'Y') {
				this.$getModalBody().find("#approvalLayerLvlCode").hide();
			}

			//결재처리여부, 수신처리여부가 N이면 결재라인을 숨김
			if ('${uiInfo.agreeYn}' === 'N' && '${uiInfo.recevYn}' === 'N') {
				this.$getModalBody().find('#approvalLayerAppLineTable').hide();
				this.$getModalBody().find("#approvalLayerLvlCode").hide();
			}

			//신청시 유의사항 정보가 있을 경우
			if ('${uiInfo.etcNoteYn}' === 'Y') {
				this.$getModalBody().find('#approvalLayerCommentArea').show();
				//유의사항 정보에 첨부파일이 존재한다면
				if (Number('${uiInfo.etcNoteFileCnt}') > 0) {
					this.$getModalBody().find('#btnApprovalLayerEtcFileDownload').show();
					this.$getModalBody().find('#btnApprovalLayerEtcFileDownload').on("click", function(e) {
						e.preventDefault();
						approvalLayerFn.showNoticeFileLayer('${uiInfo.etcNoteFileSeq}');
					});
				}
			}
		},
		initLevelCode: async function() {
			const data = await callFetch("/ApprovalMgr.do?cmd=getApprovalMgrLevelCodeList", "searchApplSabun=${searchApplSabun}");
			if (data == null || data.isError) return;

			const lvls = convCodeIdx(data.DATA, '', -1);
			this.$getModalBody().find('#approvalLayerLvlCode').html(lvls[2]);
			this.$getModalBody().find('#approvalLayerLvlCode').val('${orgLvl.orgLvl}');
		},
		initApproverLine: async function() {
			const isNotExistApplSeq = ('${applSeqExist}' === 'N');
			if (isNotExistApplSeq) {
				// 신청 정보가 없을 경우
				await this.initNewApproverLine();
			} else {
				// 신청 정보가 있을 경우

				const param = "searchApplSeq=${searchApplSeq}";
				const data1 = await callFetch('/ApprovalMgr.do?cmd=getApprovalMgrTHRI103', param);
				if (data1 == null || data1.isError) return;
				const applmi = data1.DATA;
				$('.layer-modal-header').children('#inputTitle').val(applmi.title);
				this.$getModalBody().find('#applStatusCd').val(applmi.applStatusCd);
				approvalLayer.fileSeq = applmi.fileSeq;

				const data2 = await callFetch('/ApprovalMgr.do?cmd=getApprovalMgrTHRI107', param);
				if (data2 == null || data2.isError) return;
				const appls = data2.DATA;
				this.renderApproversItem(appls);
				approvalLayer.approvalLine = appls.filter(a => a.gubun != '3');
				approvalLayer.inapplLine = appls.filter(a => a.gubun == '3').map(ia => ({
					...ia
					, empAlias: ia.agreeEmpAlias
					, org: ia.agreeOrgNm
					, jikchak: ia.agreeJikchakNm
					, jikwee: ia.agreeJikweeNm
					, orgAppYn: ia.orgAppYn
				}));

				this.$getModalBody().find('#approvalLayerLvlCode').val(appls[0].pathSeq);
				const data3 = await callFetch('/ApprovalMgr.do?cmd=getApprovalMgrTHRI125', param);
				const referers = data3.DATA;
				this.renderReferersItem(referers);

				if ('${uiInfo.agreeYn}' == 'N') {
					this.$getModalBody().find('#approvalLayerLvlCode').val('0');
					this.$getModalBody().find('#approvalLayerAppLineTable').hide();
					this.$getModalBody().find('#approvalLayerLineArea').hide();
				}
			}

			if (approvalLayer.approvalLine == null || !approvalLayer.approvalLine.length) {
				var user = {
					agreeName: '${userInfo.name}',
					agreeSabun: '${userInfo.sabun}',
					agreeOrgCd: '${userInfo.orgCd}',
					agreeOrgNm: '${userInfo.orgNm}',
					agreeJikweeCd: '${userInfo.jikweeCd}',
					agreeJikweeNm: '${userInfo.jikweeNm}',
					agreeJikchakCd: '${userInfo.jikchakCd}',
					agreeJikchakNm: '${userInfo.jikchakNm}',
					agreeSeq: 1,
					applTypeCdNm: '기안',
					applTypeCd:'30'
				};
				approvalLayer.approvalLine = [ user ];
				this.renderApproversItem(approvalLayer.approvalLine);
			}
		},
		initNewApproverLine: async function() {
			const param = "searchApplCd=${searchApplCd}&searchApplSabun=${searchApplSabun}&lvlCode=" + this.$getModalBody().find('#approvalLayerLvlCode').val();
			// 결재자
			const data1 = await callFetch("/ApprovalMgr.do?cmd=getApprovalMgrApplChgList", param);
			if (data1 == null || data1.isError) return null;
			const appls = data1.DATA;
			approvalLayer.approvalLine = appls;

			// 담당자
			const data2 = await callFetch("/ApprovalMgr.do?cmd=getApprovalMgrInList", param);
			if (data2 == null || data2.isError) return null;
			const inappls = data2.DATA;
			approvalLayer.inapplLine = inappls.map(ia => ({
				...ia
				, empAlias: ia.name
				, agreeName: ia.name
				, agreeSabun: ia.sabun
				, gubun: '3'
				, org: ia.orgNm
				, orgCd: ia.orgCd
				, jikchak: ia.jikchakNm
				, jikchakCd: ia.jikchakCd
				, jikwee: ia.jikweeNm
				, jikweeCd: ia.jikweeCd
				, orgAppYn: ia.orgAppYn
			}));

			const aps = [ ...appls, ...inappls ];
			this.renderApproversItem(aps);

			if ('${uiInfo.agreeYn}' === 'N') {
				/* 결재처리여부가 N이면 0단계(본인)결재선만 박고 화면에 안보이게 처리하고 멈춤  by JSG 2013.10.08 In JejuAir */
				this.$getModalBody().find('#approvalLayerLvlCode').val('0');
				this.$getModalBody().find('#approvalLayerAppLineTable').hide();
				this.$getModalBody().find('#approvalLayerLineArea').hide();
			}

			const data3 = await callFetch("/ApprovalMgr.do?cmd=getApprovalMgrReferUserChgList", param);
			if (data3 == null || data3.isError) return null;
			const refererData = data3.DATA;
			const referers = refererData.map(r => ({
				ccOrgNm: r.orgNm
				, ccOrgCd: r.orgCd
				, ccJikchakCd: r.jikchakCd
				, ccJikchakNm: r.jikchakNm
				, ccJikweeCd: r.jikweeCd
				, ccJikweeNm: r.jilweeNm
				, ccEmpName: r.ccName
				, ...r
			}));
			this.renderReferersItem(referers);

			$('#applStatusCd').val('');
		},
		renderApproversItem: function(appls) {
			const $applTBody = this.$getModalBody().find('#approvalLayerAppLineTable');
			$applTBody.empty();

			let idx = 1;
			for (const appl of appls) {

				const isDeputy = (appl.deputySabun != null && appl.deputySabun !== "");
				appl.isDeputy = isDeputy;
				let html = this.getApproverCardHtml(isDeputy);
				$applTBody.append(html);
				const $last = $applTBody.children().last();
				this.setApproverCard($last, appl, idx);
				idx++;
			}
		},
		getApproverCardHtml: function(isDeputy) {
			if (isDeputy) {
				return `<div class="timeline-item pb-8">
                            <div class="proxy_approver">
                                <div class="card rounded-12 pa-12-16">
                                    <p class="txt_body_sm sb mb-2 amEmpName"></p>
                                    <div class="desc_divider_wrap">
                                        <span class="amOrgNm"></span>
                                        <span class="amJikweeNm"></span>
                                    </div>
                                </div>
                                <div class="card rounded-12 pa-16 d-flex gap-12">
                                    <span class="step_num">
                                        <span class="amNo"></span>
                                    </span>
                                    <div class="flex-1">
                                        <div class="d-flex gap-8 align-center justify-between">
                                            <div class="d-flex gap-4 align-center mb-2">
                                                <p class="txt_title_xs sb txt-leading-100 amDptEmpName"></p>
                                                <span class="chip sm scarlet">대결자</span>
                                            </div>
                                            <span class="chip sm status amStatus">기안</span>
                                        </div>
                                        <div class="desc_divider_wrap mb-8">
                                            <span class="amDptOrgNm"></span>
                                            <span class="amDptJikweeNm"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>`;
			} else {
				return `<div class="timeline-item pb-8">
							<div class="card rounded-12 pa-16 d-flex gap-12">
								<span class="step_num">
									 <span class="amNo"></span>
								</span>
								<div class="flex-1">
									<div class="d-flex gap-8 align-center justify-between">
										<p class="txt_title_xs sb mb-2 amEmpName"></p>
										<span class="chip sm status amStatus"></span>
									</div>
									<div class="desc_divider_wrap mb-8">
										<span class="amOrgNm"></span>
										<span class="amJikweeNm"></span>
									</div>
								</div>
							</div>
						</div>`;
			}
		},
		setApproverCard: function($el, data, idx) {

			const status = data.agreeStatusCdNm ? data.agreeStatusCdNm : '';

			let name = data.agreeName ? data.agreeName : data.name ? data.name : '';
			const orgNm = data.agreeOrgNm ? data.agreeOrgNm : data.orgNm ? data.orgNm : '';
			const jwNm = data.agreeJikweeNm ? data.agreeJikweeNm : data.jikweeNm ? data.jikweeNm : '';

			$el.find(".amNo").text(idx);
			$el.find(".amStatus").text(data.applTypeCdNm);

			// 부서결재일 경우 성명에 부서명을 기입
			if (data.orgAppYn === "Y") {
				$el.find(".amEmpName").text(orgNm);
				$el.find(".amOrgNm").parent().hide();
			} else {
				$el.find(".amEmpName").text(name);
				$el.find(".amOrgNm").text(orgNm);
				$el.find(".amJikweeNm").text(jwNm);

				if (data.isDeputy) {
					$el.find(".amDptEmpName").text(data.deputyName);
					$el.find(".amDptOrgNm").text(data.deputyOrgNm);
					$el.find(".amDptJikweeNm").text(data.deputyJikweeNm);
				}
			}
		},
		renderReferersItem: function(referers) {
			approvalLayer.referersLine = referers;

			const $referer = this.$getModalBody().find('#approvalLayerReferUser');
			$referer.empty();

			if (referers != null && referers.length > 0) {
				this.$getModalBody().find("#approvalLayerReferArea").show();
			} else {
				this.$getModalBody().find("#approvalLayerReferArea").hide();
			}

			for (const referer of referers) {
				const html = this.getRefererCardHtml();
				$referer.append(html);
				const $last = $referer.children().last();
				this.setRefererCard($last, referer);
			}
		},
		getRefererCardHtml: function() {
			return `<div class="card rounded-12 pa-12-16">
                        <p class="txt_body_sm sb mb-2 ccEmpName"></p>
                        <div class="desc_divider_wrap">
                           <span class="ccOrgNm"></span>
                           <span class="ccJikweeNm"></span>
                        </div>
                    </div>`;
		},
		setRefererCard: function($el, data) {
			$el.find(".ccEmpName").text(data.ccEmpName);
			$el.find(".ccOrgNm").text(data.ccOrgNm);
			$el.find(".ccJikweeNm").text(data.ccJikweeNm);
		},
		callIframeBody: function() {
			const prgcd = "${uiInfo.detailPrgCd}"
			if (prgcd !== '') {
				const $form = this.$getModalBody().find("#authorForm");
				const lvlcode = this.$getModalBody().find('#approvalLayerLvlCode').val();
				$form.append('<input type="hidden" name="lvlCode" id="lvlCode" value="' + lvlcode + '" />');
				approvalLayer.prgExists = true;
				submitCall($form, "authorFrame", "post", prgcd);
			} else {
				iframeOnLoad("0px");
			}
		},
		addEvents: function() {

<c:if test="${uiInfo.fileYn == 'Y'}">
			// 파일업로드 초기화
			initFileUploadIframe("approvalMgrLayerUploadForm", approvalLayer.fileSeq, "appl", "${authPg}");
</c:if>
			//신청서 LEVELCODE EVNET
			this.$getModalBody().find('#approvalLayerLvlCode').change(function() {
				approvalLayerFn.initNewApproverLine();
			});

			this.$getAuthorFrame().on("load", function() {
				// 신청상세 화면 높이 재측정
				approvalLayerFn.setIframeHeight(approvalLayer.id);

				//신청일자 시작일, 종료일
				const startYmd = '${startYmd}' || '';
				const endYmd = '${endYmd}' || '';
				if ('${searchApplCd}' === '22' && startYmd !== '' && endYmd !== '') {
					$(this).get(0).contentDocument.getElementById('sYmd').value = '${startYmd}';
					$(this).get(0).contentDocument.getElementById('eYmd').value = '${endYmd}';
				}
			});

<c:if test="${uiInfo.showAppLineChangeBtn == 'Y'}">
			this.$getModalBody().find("#btnApprovalLineChange").on("click", function(e) {
				e.preventDefault();
				approvalLayerFn.showChangeApprovalLineLayer();
			});
</c:if>

			this.$getModalBody().find("#btnApplyApproval").on("click", function(e) {
				e.preventDefault();
				approvalLayerFn.doAction("21");
			});

			this.$getModalBody().find("#btnTempSave").on("click", function(e) {
				e.preventDefault();
				approvalLayerFn.doAction("11");
			})
		},
		setIframeHeight: function(id) {
			const ifrm = document.getElementById(id);
			if (ifrm) {
				ifrm.style.visibility = 'hidden';
				ifrm.style.height = ifrm.contentDocument.body.scrollHeight + "px";
				ifrm.style.visibility = 'visible';
			}
		},
		showNoticeFileLayer: function(fileSeq) {
			let layerModal = new window.top.document.LayerModal({
				id : 'fileMgrLayer'
				, url : 'fileuploadJFileUpload.do?cmd=viewFileMgrLayer'
				, parameters : {
					authPg : 'R',
					fileSeq : fileSeq,
					fileLayerId : 'noticeFileLayer'
				}
				, width : 740
				, height : 420
				, title : '파일다운로드'
				, trigger :[
					{
						name : 'fileMgrLayerTrigger'
						, callback : function(result){
						}
					}
				]
			});
			layerModal.show();
		},
		showChangeApprovalLineLayer: function() {
			if(!isPopup()) {return;}
			const args = {
				orgCd: '${userInfo.orgCd}'
				, pathSeq: this.$getModalBody().find('#approvalLayerLvlCode').val()
				, searchApplSabun: '${searchApplSabun}'
				, lines: this.getApprovalLineJson()
			};
			const changeApprovalLineLayer = new window.top.document.LayerModal({
				id: 'changeApprovalLineLayer',
				url: "/ApprovalMgr.do?cmd=viewApprovalMgrChgLineLayer",
				parameters: args,
				width: 1200,
				height: 750,
				title: "<tit:txt mid='appPathReg' mdef='결재 경로 변경'/>",
				trigger: [
					{
						name: 'changeApprovalLineTrigger',
						callback: function(rv) {
							approvalLayerFn.changeApprovalLineRtn(rv);
						}
					}
				]
			});
			changeApprovalLineLayer.show();
		},
		getApprovalLineJson: function() {
			let data = {
				appls: [],
				deputys: [],
				inusers: [],
				refers: [],
			};

			data.appls = approvalLayer.approvalLine.filter(a => (a.deputyYn !== 'Y' || (a.deputySabun && a.deputySabun == ''))).map((a, i) => ({
				agreeSeq: a.agreeSeq ? a.agreeSeq: '#agreeSeq#',
				name: a.agreeName,
				agreeSabun: a.agreeSabun,
				empAlias: a.agreeEmpAlias,
				applTypeCd: a.applTypeCd,
				gubun: a.applTypeCd === '30' ? '0' : '1',
				orgCd: a.agreeOrgCd,
				org: a.agreeOrgNm,
				jikwee: a.agreeJikweeNm,
				jikweeCd: a.agreeJikweeCd,
				jikchak: a.agreeJikchakNm,
				jikchakCd: a.agreeJikchakCd
			}));

			data.deputys = approvalLayer.approvalLine.filter(a => (a.deputyYn === 'Y' || (a.deputySabun && a.deputySabun != ''))).map((a, i) => ({
				sabun: a.deputySabun,
				org: a.deputyOrgNm,
				agreeSabun: a.agreeSabun,
				jikwee: a.deputyJikweeNm,
				jikchak: a.deputyJikchakNm
			}));

			data.inusers = approvalLayer.inapplLine;

			if (approvalLayer.referersLine && approvalLayer.referersLine.length > 0) {
				var author = approvalLayer.approvalLine.find(a => a.applTypeCd === '30');
				author = {inSabun: author.agreeSabun,
					name: author.agreeName,
					inOrg: author.agreeOrgNm,
					inOrgCd: author.agreeOrgCd,
					inJikchak: author.agreeJikchakNm,
					inJikchakCd: author.agreeJikchakCd,
					inJikwee: author.agreeJikweeNm,
					inJikweeCd: author.agreeJikweeCd,
					agreeSeq: author.agreeSeq};

				data.refers = approvalLayer.referersLine.map(a => ({
					...author
					, referName: a.ccEmpName
					, referSabun: a.ccSabun
					, referOrg: a.ccOrgNm
					, referOrgCd: a.ccOrgCd
					, referJikchak: a.ccJikchakNm
					, referJikchakCd: a.ccJikchakCd
					, referJikwee: a.ccJikweeNm
					, referJikweeCd: a.ccJikweeCd
					, referEmpAlias: a.ccEmpAlias
				}));
			}

			return data;
		},
		changeApprovalLineRtn: function(param) {
			if (param) {
				var { appls, inappls, referer } = param;
				approvalLayer.approvalLine = appls.map(a => ({
					agreeSeq: a.agreeSeq,
					agreeName: a.name,
					agreeEmpAlias: a.empAlias,
					agreeSabun: a.agreeSabun,
					applTypeCd: a.applTypeCd,
					applTypeCdNm: a.applTypeCdNm,
					agreeOrgCd: a.orgCd,
					agreeOrgNm: a.orgNm,
					agreeJikweeNm: a.jikweeNm,
					agreeJikweeCd: a.jikweeCd,
					agreeJikchakNm: a.jikchakNm,
					agreeJikchakCd: a.jikchakCd,
				}));
				approvalLayer.inapplLine = inappls.map(a => ({
					agreeSabun: a.agreeSabun,
					applTypeCd: a.applTypeCd,
					applTypeCdNm: a.applTypeCdNm,
					empAlias: a.empAlias,
					agreeName: a.name,
					gubun: '3',
					org: a.orgNm,
					orgCd: a.orgCd,
					jikchak: a.jikchakNm,
					jikchakCd: a.jikchakCd,
					jikwee: a.jikweeNm,
					jikweeCd: a.jikweeCd,
					orgAppYn: a.orgAppYn,
				}));
				this.renderApproversItem([...appls, ...inappls]);
				referer = referer.map(a => ({
					ccSabun: a.ccSabun,
					ccOrgNm: a.orgNm,
					ccOrgCd: a.orgCd,
					ccJikchakCd: a.jikchakCd,
					ccJikchakNm: a.jikchakNm,
					ccJikweeCd: a.jikweeCd,
					ccJikweeNm: a.jikweeNm,
					ccEmpName: a.name,
					ccEmpAlias: a.name,
					pathSeq: a.pathSeq
				}));
				this.renderReferersItem(referer);
			}
		},
		/**
		 * doAction 전 validation 체크
		 * @param action
		 * @returns {boolean}
		 */
		isValidAction: function(action) {
			if(!this.iframeLoad) {
				alert("<msg:txt mid='109888' mdef='업무 화면이 로딩 되지 않았습니다.n 로딩완료후 다시 시도 하십시오!'/>");
				return false;
			}

<c:if test="${uiInfo.fileYn == 'Y'}">
			//첨부파일 관련 로직은 후에 적용
			const attFileCnt = getFileUploadContentWindow("approvalMgrLayerUploadForm").getFileList();
			//첨부파일 필수여부 체크 (임시저장일 경우 제외)
			if("${uiInfo.fileEssentialYn}" === 'Y' && attFileCnt === 0 && action != "11" && $('#fileReqYn').val() != "N") {
				alert("파일 첨부가 필요한 신청입니다.");
				return false;
			}
</c:if>

			//결재선이 지정되지 않은 경우
			const line = [...approvalLayer.approvalLine, ...approvalLayer.inapplLine];
			if (!line || !line.length) {
				alert("결재선이 지정되어 있지 않습니다.\n결재선을 지정해 주시기 바랍니다.");
				return false;
			}

			//본인 결제가 허용되지 않았는데 결제자가 자기밖에 없는경우
			if( '${uiInfo.pathSelfCloseYn}' === 'N' && line.length === 1 ) {
				alert('결재선이 본인만 지정되었습니다. 결재자를 추가로 지정하여 신청해 주십시오.');
				return false;
			}

			return true;
		},
		doAction: async function(action) {
			if (approvalLayerFn.isProgress) {return;}

			if (action == '21' && $.trim('${uiInfo.confirmMsg}')) {
				if (!confirm('${uiInfo.confirmMsg}')) return;
			}

			if (!this.isValidAction(action)) return;

			this.$getModalBody().find('#applStatusCd').val(action);

			//하위 문서의 applseq를 새로운 applseq로 셋팅
			if (this.$getModalBody().find('#reApplSeq').val() != null && this.$getModalBody().find('#reApplSeq').val() !== '') {
				this.$getAuthorFrame().contents().find('#searchApplSeq').val(this.$getModalBody().find('#reApplSeq').val());
			}

			this.$getModalBody().find('#pathSeq').val($('#approvalLayerLvlCode').val());

<c:if test="${uiInfo.fileYn == 'Y'}">
			this.$getModalBody().find("#authorForm>#fileSeq").val(getFileUploadContentWindow("approvalMgrLayerUploadForm").getFileSeq());
</c:if>
			const param = {
				...formToJson(this.$getModalBody().find("#authorForm")),
				...this.getApprovalLineJson()
			};

			//제목수정여부 확인
			if ('${uiInfo.titleYn}' === 'Y') {
				param.applTitle = $('#inputTitle').val();
			}

			this.isProgress = true;
			progressBar(true, "Please Wait...");
			setTimeout(async () => {
				var validation = await approvalLayerFn.callIframeSaveLogic(action);
				if (validation) {
					approvalLayerFn.callSave(action, param);
					closeApprovalMgrLayer();
				}
				progressBar(false);
				approvalLayerFn.isProgress = false;
			}, 1000);
		},
		callIframeSaveLogic: async function(action) {
			this.isProgress = true;
			if (approvalLayer.prgExists) {
				return await this.$getAuthorFrame().get(0).contentWindow.setValue(action);
			} else {
				return true;
			}
		},
		callSave: function(action, param) {
			var r = ajaxTypeJson('/ApprovalMgr.do?cmd=saveApprovalMgr', param, false);
			if (r) {
				var msg = '';
				switch (r.Code) {
					case 1: msg = (action === '11') ? '저장 되었습니다.':'신청 되었습니다.'; break;
					case 0: msg = (action === '11') ? '저장된 내용이 없습니다.':'신청된 내용이 없습니다.'; break;
					case -1: msg = (action === '11') ? '저장에 실패했습니다.':'신청에 실패했습니다.'; break;
				}

				if (action === '21' && Number(r.cnt) > 0) {
					try {
						//var sendp = {applSeq: $('#searchApplSeq').val(), applStatusCd: action, firstDiv: 'Y'};
						//ajaxCall('/Send.do?cmd=callMailAppl', queryStringToJson(sendp), false);
					} catch (e) {
						alert('메일 발송 중 오류가 발생했습니다.')
					}
				}
				alert(msg);
			}
		}
	};

	$(function() {
		approvalLayerFn.init();
	});

	function closeApprovalMgrLayer() {
		const modal = window.top.document.LayerModalUtility.getModal(approvalLayer.id);
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
				approvalLayerFn.$getAuthorFrame().contents().find(".wrapper").children().each((idx, ele) => wrpH += $(ele).outerHeight(true));
				if (wrpH > ih2)
					approvalLayerFn.$getAuthorFrame().height(wrpH);
				else
					approvalLayerFn.$getAuthorFrame().height(ih2);
			}, 300);

			approvalLayerFn.iframeLoad = true;
		} catch(e) {
			approvalLayerFn.$getAuthorFrame().height(ih);
			approvalLayerFn.iframeLoad = true;
		}
	}
</script>
<div class="wide wrapper modal_layer ux_wrapper bg-gray">
	<div class="modal_body approval">

		<div class="d-flex gap-16">
			<div class="card bg-white pa-24 rounded-16 flex-1">
				<!-- <p class="txt_title_xs sb txt_left mb-12">신청내용</p> -->
				<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:100px; min-height:317px;"></iframe>

				<!-- 신청서 하단 공통 -->
				<div class="mt-24">
<c:if test="${uiInfo.fileYn == 'Y'}">
					<div class="mb-24">
						<div id="uploadDiv">
							<iframe id="approvalMgrLayerUploadForm" name="approvalMgrLayerUploadForm" frameborder="0" class="author_iframe" style="width:100%; height:150px;"></iframe>
						</div>
						<!--
						<div class="d-flex justify-between align-center mb-8">
							<div class="d-flex align-center gap-8 flex-1">
								<p class="txt_title_xs sb txt_secondary">첨부파일</p>
							</div>
							<div class="d-flex align-center gap-8">
								<input type="file" id="fileInput" style="display: none" multiple />
								<button class="btn outline dark_gray" onclick="document.getElementById('fileInput').click()">파일첨부</button>
							</div>
						</div>
						<div class="attached_files d-flex gap-4 flex-1 flex-col">
							<div class="file_item d-flex align-center gap-4 justify-between">
								<div class="d-flex align-center gap-4">
									<i class="icon file"></i>
									<span class="txt_body_sm txt_tertiary">보기 화면에서의 첨부파일 예시.zip</span>
								</div>
								<button class="download_file">
									<i class="mdi-ico txt_tertiary">file_download</i>
								</button>
							</div>
						</div>
						-->
					</div>
</c:if>
					<div class="card rounded-16 pa-12-16-24" id="approvalLayerCommentArea" style="display: none;">
						<div class="d-flex justify-between align-center mb-8">
							<p class="txt_title_xs sb txt_tertiary d-flex align-center gap-4">
								<i class="mdi-ico txt_18">error</i>
								신청시 유의사항
							</p>
							<button class="btn outline dark_gray" id="btnApprovalLayerEtcFileDownload" style="display: none;">다운로드</button>
						</div>
						<p class="pl-20 txt_body_sm txt_tertiary">
							${uiInfo.etcNote}
						</p>
					</div>
				</div>

			</div>

			<!-- 결재영역 .footer_fixed 없애고 스타일 수정하여서 .card, .card > div, .footer 부분 컨텐츠 내용을 감싸는 div만 한 번 확인 부탁드려요 -->
			<div class="card bg-white pa-24 rounded-16 d-flex flex-col gap-16 flex-1 max-w-332">
				<div class="d-flex flex-col gap-24 flex-1 scroll-y">
					<div class="mb-24">
						<div class="d-flex justify-between align-center mb-12">
							<p class="txt_title_xs sb">결재</p>
<c:if test="${uiInfo.showAppLineChangeBtn == 'Y'}">
							<button class="btn outline dark_gray" id="btnApprovalLineChange">
								<i class="mdi-ico mr-2">restart_alt</i>
								결재선변경
							</button>
</c:if>
						</div>
						<!-- 결재 신청 시에 사용 -->
						<div class="d-flex justify-between align-center mb-12">
							<p class="txt_body_sm txt_secondary">결재방법</p>
							<select class="custom_select w-174" name="approvalLayerLvlCode" id="approvalLayerLvlCode">
								<option value="">담당결재</option>
							</select>
						</div>

						<!-- timeline-item 에 상태에 따라 completed, active, rejected 클래스 추가 -->
						<div class="timeline mb-24" id="approvalLayerAppLineTable">
						</div>
						<div id="approvalLayerReferArea" style="display: none;">
							<p class="txt_title_xs sb txt_left mb-12 txt_secondary">참조</p>

							<div class="d-flex flex-col gap-8" id="approvalLayerReferUser">
							</div>
						</div>
					</div>
				</div>
				<div class="footer">
					<button class="btn lg outline w-full" id="btnTempSave">임시저장</button>
					<button class="btn lg primary w-full" id="btnApplyApproval">
						<i class="mdi-ico mr-4">check</i>
						결재신청
					</button>
				</div>
			</div>
		</div>
		<form id="authorForm" name="form">
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
			<input id="reApplSeq" 		name="reApplSeq" 		type="hidden" value="${reApplSeq}"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
			<input id="searchApplName" 	name="searchApplName" 	type="hidden" value="${userInfo.name}"/>
			<input id="adminYn" 		name="adminYn" 			type="hidden" value="${adminYn}"/>
			<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>
			<input id="pathSeq" 		name="pathSeq" 			type="hidden" value=""/>
			<input id="applStatusCd" 	name="applStatusCd" 	type="hidden" value=""/>
			<input id="fileSeq"			name="fileSeq"			type="hidden" value=""/>
			<input id="gubun" name="gubun" type="hidden" value="${gubun}"/>
			<input id="procExecYn" name="procExecYn" type="hidden" value="${uiInfo.procExecYn}"/>
			<input id="afterProcStatusCd"	name="afterProcStatusCd"	type="hidden" value=""/>
			<input id="etc01"			name="etc01"			type="hidden" value="${etc01}"/>
			<input id="etc02"			name="etc02"			type="hidden" value="${etc02}"/>
			<input id="etc03"			name="etc03"			type="hidden" value="${etc03}"/>
			<input id="applTitle"       name="applTitle"        type="hidden" value="${uiInfo.applTitle}" />
		</form>
	</div>
</div>