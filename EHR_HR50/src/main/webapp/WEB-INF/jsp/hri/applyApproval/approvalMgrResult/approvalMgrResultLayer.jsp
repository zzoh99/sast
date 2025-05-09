<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<% request.setAttribute("uploadType", "appl"); %>
<script>
	var approvalResultLayer = {
		id: 'approvalMgrLayer',
		searchApplCd: '${searchApplCd}',
		searchApplSeq: '${searchApplSeq}',
		fileSeq: '',
		pathSeq: '',
		agreeSeq: '',
		agreeSabun: '',
		agreeGubun: '',
		searchSabun: '',
		referAgreeSeq: '',
		agreeUserStatus: '',
		agreeUserMemo: '',
		signView: 'status',
		prgExists: false,
		deputy:null,
		approvalLine: [],
		referersLine: [],
		inapplLine: [],
	};

	var approvalResultLayerFn = {
		iframeLoad: false,
		$getModal: function() {
			return $('#modal-' + approvalResultLayer.id);
		},
		$getModalBody: function() {
			return $(this.$getModal().find(".modal_body")[0]);
		},
		$getAuthorResultFrame: function() {
			return this.$getModalBody().find("#authorResultFrame");
		},
		init: async function() {
			this.setModalTitle();
			await this.initViews();

			await this.initApproverLine();
			this.addEvents();
		},
		setModalTitle: function() {
			//title setting
			this.$getModal().find('div.layer-modal-header span.layer-modal-title').text('${applMasterInfo.title}');
		},
		initViews: async function() {
			//신청서 height-full 처리
			if (this.$getModal().find('div.modal-size').attr('class').includes('height-full')) {
				this.$getModal().find('div.modal-size').css('max-height', '100vh');
				this.$getModalBody().css('max-height', 'calc(100vh - 150px)');
				this.$getModalBody().css('height', '100%');
			}

			approvalResultLayer.prgExists = ("${uiInfo.detailPrgCd}" !== "");
			if (approvalResultLayer.prgExists) {
				submitCall(this.$getModalBody().find("#approvalMgrResultLayerForm"), "authorResultFrame", "post", "${uiInfo.detailPrgCd}");
			} else {
				iframeOnLoad("0px");
			}

<c:if test="${uiInfo.fileYn == 'Y'}">
			initFileUploadIframe("approvalMgrResultLayerUploadForm", "${applMasterInfo.fileSeq}", "appl", "${authPg}");
</c:if>

<c:if test="${adminYn == 'Y'}">
			//관리자라면 결재상태 OPTION정보 처리를 해준다
			const data1 = await callFetch('/CommonCode.do?cmd=getCommonCodeList', 'grpCd=R10010&useYn=Y');
			if (data1 == null || data1.isError) return;

			const codes = convCodeIdx(data1.codeList, '', -1);
			this.$getModalBody().find('#approvalMgrResultStatusCd').html(codes[2]);
			this.$getModalBody().find('#approvalMgrResultStatusCd').val('${applMasterInfo.applStatusCd}');
</c:if>
		},
		initApproverLine: async function() {

			//결재라인 생성
			const param = "searchApplSeq=${searchApplSeq}";
			const data1 = await callFetch('/ApprovalMgrResult.do?cmd=getApprovalMgrResultTHRI107', param);
			if (data1 == null || data1.isError) return;

			const appls = data1.DATA;
			this.renderApproversItem(appls);

			approvalResultLayer.approvalLine = appls.filter(a => a.gubun != '3');
			approvalResultLayer.inapplLine = appls.filter(a => a.gubun == '3').map(ia => ({
				...ia
				, empAlias: ia.agreeEmpAlias
				, org: ia.orgNm
				, jikchak: ia.agreeJikchakNm
				, jikwee: ia.agreeJikweeNm
				, orgAppYn: ia.orgAppYn
			}));

			const data2 = await callFetch('/ApprovalMgrResult.do?cmd=getApprovalMgrResultTHRI125', param);
			if (data2 == null || data2.isError) return;

			const referers = data2.DATA;
			approvalResultLayer.referersLine = referers;
			this.renderReferersItem(referers);
		},
		renderApproversItem: function(appls) {

			if (appls.length > 0)
				approvalResultLayer.pathSeq = appls[0].pathSeq;

			/*
			appls.map(a => {
				if (a.agreeStatusCd === '20')
					a = {...a, agreeSabun: '${ssnSabun}'};

				return a;
			})
			*/

			appls.filter(a => a.agreeStatusCd === '10')
					.forEach(a => {
						approvalResultLayer.agreeSabun = a.agreeSabun;
						approvalResultLayer.agreeSeq = a.agreeSeq;

						if (a.deputyYn === 'Y' || a.deputyName !== '') {
							const jknm = a.deputyJikchakNm == null || a.deputyJikchakNm === '' ? a.deputyJikweeNm : a.deputyJikchakNm;
							approvalResultLayer.deputy = {inSabun: a.deputySabun, inOrg: a.deputyOrgNm, inJikchak: jknm, inJikwee: a.deputyJikweeNm};
							approvalResultLayer.searchSabun = '${ssnSabun}';
						} else if (a.agreeSabun === '${ssnSabun}') {
							approvalResultLayer.referAgreeSeq = a.agreeSeq;
						}
					});

			const $appLineTable = this.$getModalBody().find("#approvalResultLayerAppLineTable");
			$appLineTable.empty();

			let idx = 1;
			for (const appl of appls) {
				const html = this.getApproverCardHtml(appl);
				$appLineTable.append(html);
				const $last = $appLineTable.children().last();
				this.setApproverCard($last, appl, idx);
				idx++;
			}
		},
		getApproverCardHtml: function(appl) {

			// 이미 결재 완료되었고 기안이 아니면서, 접속자가 결재자인 경우에는 표시
			const isShowOpinion =
					appl.agreeStatusCd !== ""
					&& appl.applTypeCd !== "30"
					&& ( appl.agreeStatusCd !== "10"
							|| ( appl.agreeStatusCd === "10"
									&& ( appl.agreeSabun === "${ssnSabun}"
											|| appl.agreeSabun === "${ssnOrgCd}"
											|| appl.deputySabun === "${ssnSabun}"
											|| appl.deputySabun === "${ssnOrgCd}" ) ) );
			let opinionHtml = '';
			if (isShowOpinion) {
				const applStatusCd = $("#approvalMgrResultLayerForm #applStatusCd").val();
				const isShowPlaceholder =
						applStatusCd !== "99"
						&& appl.agreeStatusCd === "10"
						&& ( appl.agreeSabun === "${ssnSabun}"
								|| appl.agreeSabun === "${ssnOrgCd}"
								|| appl.deputySabun === "${ssnSabun}"
								|| appl.deputySabun === "${ssnOrgCd}" );
				if (isShowPlaceholder) {
					opinionHtml = `<textarea name="amrMemo" class="mt-8 h-70" placeholder="의견을 작성해주세요"></textarea>`;
				} else {
					opinionHtml = `<textarea name="amrMemo" class="mt-8 h-70" disabled></textarea>`;
				}
			}

			const isDeputy = appl.deputyYn === 'Y';
			if (isDeputy) {
				return `<div class="timeline-item pb-8">
                            <div class="proxy_approver">
                                <div class="card rounded-12 pa-12-16">
                                    <p class="txt_body_sm sb mb-2 amrEmpName"></p>
                                    <div class="desc_divider_wrap">
                                        <span class="amrOrgNm"></span>
                                        <span class="amrJikweeNm"></span>
                                    </div>
                                </div>
                                <div class="card rounded-12 pa-16 d-flex gap-12">
                                    <span class="step_num">
                                        <span class="amrNo"></span>
                                    </span>
                                    <div class="flex-1">
                                        <div class="d-flex gap-8 align-center justify-between">
                                            <div class="d-flex gap-4 align-center mb-2">
                                                <p class="txt_title_xs sb txt-leading-100 amrDptEmpName"></p>
                                                <span class="chip sm scarlet">대결자</span>
                                            </div>
                                            <span class="chip sm status amrStatus"></span>
                                        </div>
                                        <div class="desc_divider_wrap mb-8">
                                            <span class="amrDptOrgNm"></span>
                                            <span class="amrDptJikweeNm"></span>
                                        </div>
                                        <p class="txt_body_sm txt_tertiary amTime"></p>
                                    </div>
                                </div>
                            </div>
							${'${opinionHtml}'}
                        </div>`;
			} else {
				return `<div class="timeline-item pb-8">
							<div class="card rounded-12 pa-16 d-flex gap-12">
								<span class="step_num">
									 <span class="amrNo"></span>
								</span>
								<div class="flex-1">
									<div class="d-flex gap-8 align-center justify-between">
										<p class="txt_title_xs sb mb-2 amrEmpName"></p>
										<span class="chip sm status amrStatus"></span>
									</div>
									<div class="desc_divider_wrap mb-8">
										<span class="amrOrgNm"></span>
										<span class="amrJikweeNm"></span>
									</div>
									<p class="txt_body_sm txt_tertiary amTime"></p>
								</div>
							</div>
							${'${opinionHtml}'}
						</div>`;
			}
		},
		setApproverCard: function($el, data, idx) {

			console.log("data", data);

			const time = data.agreeTime && data.agreeTime !== '' ?  cTimeFormat(new Date(data.agreeTime)) : '';
			const status = data.agreeStatusCdNm ? data.agreeStatusCdNm : data.applTypeCdNm ? data.applTypeCdNm : '';

			const name = data.agreeName ? data.agreeName : data.name ? data.name : '';
			const orgNm = data.agreeOrgNm ? data.agreeOrgNm : data.orgNm ? data.orgNm : '';
			const jwNm = data.agreeJikweeNm ? data.agreeJikweeNm : data.jikweeNm ? data.jikweeNm : '';

			const getAgreeClassNm = (statusCd) => {
				if (statusCd === "10") // 결재요청
					return "active";
				else if (statusCd === "20") // 결재완료
					return "completed";
				else if (statusCd === "30") // 반려
					return "rejected";
				else
					return "";
			}

			$el.addClass(getAgreeClassNm(data.agreeStatusCd));
			$el.find(".amrNo").text(idx);
			$el.find(".amTime").text(time);
			$el.find(".amrStatus").text(status);
			$el.find("textarea[name=amrMemo]").val(data.memo.replace(/\<br>/gi, "\n"));

			const isAppOrg = !data.agreeName && !data.name && data.agreeOrgNm;
			if (isAppOrg) {
				$el.find(".amrEmpName").text(data.agreeOrgNm);
				$el.find(".amrOrgNm").parent().hide();
			} else {
				$el.find(".amrEmpName").text(name);
				$el.find(".amrOrgNm").text(orgNm);
				$el.find(".amrJikweeNm").text(jwNm);

				const isDeputy = data.deputyYn === 'Y';
				if (isDeputy) {
					$el.find(".amrDptEmpName").text(data.deputyName);
					$el.find(".amrDptOrgNm").text(data.deputyOrgNm);
					$el.find(".amrDptJikweeNm").text(data.deputyJikweeNm);
				}
			}
		},
		renderReferersItem: function(referers) {

			const $referer = this.$getModalBody().find("#approvalResultLayerReferUser");
			$referer.empty();

			if (referers != null && referers.length > 0) {
				this.$getModalBody().find("#approvalResultLayerReferArea").show();
			} else {
				this.$getModalBody().find("#approvalResultLayerReferArea").hide();
				return;
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
			$el.find(".ccEmpName").text(data.name);
			$el.find(".ccOrgNm").text(data.ccOrgNm);
			$el.find(".ccJikweeNm").text(data.ccJikweeNm);
		},
		addEvents: function() {

			this.$getAuthorResultFrame().on("load", function() {
				approvalResultLayerFn.setIframeHeight(approvalResultLayer.id);
			});

<c:if test="${cancelButton.visibleApproveBtn == 'Y'}">
			this.$getModalBody().find("#btnApplConfirm").on("click", function(e) {
				// 결재
				e.preventDefault();
				approvalResultLayerFn.doApprove("1");
			})

			this.$getModalBody().find("#btnApplReject").on("click", function(e) {
				// 반려
				e.preventDefault();
				approvalResultLayerFn.doApprove("0");
			})
</c:if>

<c:if test="${cancelButton.cancel == 'YES'}">
			this.$getModalBody().find("#btnApplRecall").on("click", function(e) {
				// 취소
				e.preventDefault();
				approvalResultLayerFn.cancelApply();
			})
</c:if>

<c:if test="${cancelButton.visibleReuseBtn == 'Y'}">
			this.$getModalBody().find("#btnApplReuse").on("click", function(e) {
				// 재사용
				e.preventDefault();
				approvalResultLayerFn.showReuseApprovalLayer();
			})
</c:if>

<c:if test="${adminYn == 'Y'}">
			this.$getModalBody().find("#btnApplSave").on("click", function(e) {
				// 관리자 저장
				e.preventDefault();
				approvalResultLayerFn.saveAdmin();
			})
</c:if>

			this.$getModalBody().find("#btnApplCancel").on("click", function(e) {
				e.preventDefault();
				closeApprovalMgrResultLayer();
			})

<c:if test="${uiInfo.webPrintYn == 'Y'}">
			this.$getModalBody().find("#btnApprovalMgrWebPrint").on("click", function(e) {
				e.preventDefault();
				approvalResultLayerFn.showPrintPage();
			})
</c:if>
		},
		setIframeHeight: function(id) {
			const ifrm = document.getElementById(id);
			if (ifrm) {
				ifrm.style.visibility = 'hidden';
				ifrm.style.height = ifrm.contentDocument.body.scrollHeight + "px";
				ifrm.style.visibility = 'visible';
			}
		},
<c:if test="${cancelButton.visibleApproveBtn == 'Y'}">
		doApprove: async function(option) {

			showOverlay(500);

			if (!this.iframeLoad) {
				alert('<msg:txt mid="alertFrameLoad" mdef="업무 화면이 로딩 되지 않았습니다.\n 로딩완료후 다시 시도 하십시오." />');
				hideOverlay();
				return;
			}

			/* 근로시간단축 신청 */
			if ("${searchApplCd}" === "300") {
				let rtn;
				if (option === '1') {
					rtn = this.$getAuthorResultFrame().get(0).contentWindow.adminDoSave2('0');
				} else {
					rtn = this.$getAuthorResultFrame().get(0).contentWindow.adminDoSave2('2');
				}
				if (rtn == 0) {
					hideOverlay();
					return;
				}
			}

			approvalResultLayer.agreeUserStatus = option;
			approvalResultLayer.agreeUserMemo = replaceAll(this.$getModalBody().find("#approvalResultLayerAppLineTable .timeline-item.active textarea[name=amrMemo]").val(), "\n", "<br>");
			await this.saveApprovalMgrResult(approvalResultLayer.agreeUserStatus);
			hideOverlay();
		},
		saveApprovalMgrResult: async function(option) {

			//appl save가 필요한 상황이 안올듯? (결재라인 변경 기능이 없음)
			//참조자는 값만 있으면 save..
			const lines = this.getApprovalResultLineJson();
			const referSave = lines.refers && lines.refers.length ? 'Save':'';
			const param = {
				...lines,
				...approvalResultLayer,
				referSave: referSave,
				applSave: '',
				agreeGubun: option,
				procExecYn: this.$getModalBody().find('#procExecYn').val(),
				afterProcStatusCd: this.$getModalBody().find('#afterProcStatusCd').val()
			};

			setTimeout(async () => {
				const validation = await approvalResultLayerFn.callIframeResultSaveLogic(option);
				if (validation) {
					await approvalResultLayerFn.callResultSave(option, param);
					closeApprovalMgrResultLayer();
				}
				hideOverlay();
			}, 1000);
		},
		getApprovalResultLineJson: function() {
			let data = {
				appls: [],
				deputys: [],
				inusers: [],
				refers: [],
			};

			data.appls = approvalResultLayer.approvalLine
					.filter(a => (a.deputyYn !== 'Y' || (a.deputySabun && a.deputySabun == '')))
					.map((a, i) => ({
				agreeSeq: a.agreeSeq ? a.agreeSeq: '#agreeSeq#',
				name: a.agreeName,
				agreeSabun: a.agreeSabun,
				empAlias: a.agreeEmpAlias,
				applTypeCd: a.applTypeCd,
				gubun: a.applTypeCd === '30' ? '0':'1',
				orgCd: a.agreeOrgCd,
				org: a.agreeOrgNm,
				jikwee: a.agreeJikweeNm,
				jikweeCd: a.agreeJikweeCd,
				jikchak: a.agreeJikchakNm,
				jikchakCd: a.agreeJikchakCd
			}));

			data.deputys = approvalResultLayer.approvalLine.filter(a => (a.deputyYn === 'Y' || (a.deputySabun && a.deputySabun != ''))).map((a, i) => ({
				sabun: a.deputySabun,
				org: a.deputyOrgNm,
				agreeSabun: a.agreeSabun,
				jikwee: a.deputyJikweeNm,
				jikchak: a.deputyJikchakNm
			}));

			data.inusers = approvalResultLayer.inapplLine;

			/**
			 * 중복 참조자 발생하여 임시 주석 24.11.13 - 강상구
			 * 결과화면에서 참조자 추가 기능 생길 시 반영 필요
			 */
			// if (approvalResultLayer.referersLine && approvalResultLayer.referersLine.length > 0) {
			// 	var tmp = approvalResultLayer.approvalLine.find(a => approvalResultLayer.agreeSeq == a.agreeSeq);
			// 	if(tmp != null && tmp != undefined){
			// 		var author = approvalResultLayer.deputy ? approvalResultLayer.deputy
			// 				:{inSabun: tmp.agreeSabun,
			// 					inOrg: tmp.agreeOrgNm,
			// 					inOrgCd: tmp.agreeOrgCd,
			// 					inJikchak: tmp.agreeJikchakNm,
			// 					inJikwee: tmp.agreeJikweeNm,
			// 					agreeSeq: tmp.agreeSeq};
			//
			// 		data.refers = approvalResultLayer.referersLine.map(a => ({
			// 			...author
			// 			, referName: a.name
			// 			, referSabun: a.ccSabun
			// 			, referOrg: a.ccOrgNm
			// 			, referOrgCd: a.ccOrgCd
			// 			, referJikchak: a.ccJikchakNm
			// 			, referJikchakCd: a.ccJikchakCd
			// 			, referJikwee: a.ccJikweeNm
			// 			, referJikweeCd: a.ccJikweeCd
			// 			, referEmpAlias: a.ccEmpAlias
			// 		})).filter((item, index, self) =>
			// 			index === self.findIndex(i => i.referSabun === item.referSabun)
			// 		);
			// 	}
			// }

			return data;
		},
		callResultSave: async function(option, param) {
			const rv = ajaxTypeJson("${ctx}/ApprovalMgrResult.do?cmd=saveApprovalMgrResult", param, false);
			if (rv) {
				let message = '';
				if (Number(rv.cnt) > 0) {
					if (option === '1')
						message = "<msg:txt mid='alertOkAppl' mdef='결재 되었습니다.'/>";
					else
						message = "<msg:txt mid='alertRestoreOk' mdef='반려 되었습니다.'/>";
					try {
						//const p = {applSeq: approvalResultLayer.searchApplSeq, applStatusCd: option, firstDiv: 'N'};
						//ajaxCall("${ctx}/Send.do?cmd=callMailAppl", queryStringToJson(p), false);
					} catch (e) {
						alert('메일전송 중 오류가 발생했습니다.');
					}
				} else {
					if (option === '1')
						message = "<msg:txt mid='alertErrorAppl' mdef='결재 실패 하였습니다.'/>";
					else
						message = "<msg:txt mid='alertErrorCompanion' mdef='반려 실패 하였습니다.'/>";
				}
				alert(message);
			}
		},
</c:if>
<c:if test="${cancelButton.cancel == 'YES'}">
		cancelApply: async function() {
			showOverlay(500);
			const p = "searchApplSeq=${searchApplSeq}&statusCd=11";
			const data = await callFetch("/ApprovalMgrResult.do?cmd=updateCancelStatusCd", p);
			if (data == null || data.isError) {
				alert('신청서 회수 시 오류가 발생했습니다.');
				hideOverlay();
				return;
			}

			if (Number(data.cnt) > 0) {
				alert('신청서가 회수되었습니다.');
			} else {
				alert('신청서 회수 시 오류가 발생했습니다.');
				hideOverlay();
				return;
			}
			hideOverlay();
			closeApprovalMgrResultLayer();
		},
</c:if>
<c:if test="${cancelButton.visibleReuseBtn == 'Y'}">
		showReuseApprovalLayer: function() {
			const p = {
				searchApplCd: '${searchApplCd}'
				, searchApplSeq: approvalResultLayer.searchApplSeq
				, adminYn: 'N'
				, authPg: 'A'
				, searchSabun: '${searchSabun}'
				, searchApplSabun: this.$getModalBody().find('#searchApplSabun').val()
				, searchApplYmd: '${searchApplYmd}'
				, reUseYn: 'Y'
				, etc03: '${etc03}'
			};
			//upload div정보가 신청 layer와 겹치므로 삭제
			this.$getModalBody().find('#uploadDiv').remove();
			//get Trigger
			const modal = window.top.document.LayerModalUtility.getModal(approvalResultLayer.id);
			const trigger = modal.getTrigger('approvalMgrLayerTrigger');
			closeApprovalMgrResultLayer();
			new window.top.document.LayerModal({
				id: 'approvalMgrLayer',
				url: '/ApprovalMgr.do?cmd=viewApprovalMgrLayer',
				parameters: p,
				width: 800,
				height: 815,
				title: '신청서',
				trigger: [ trigger ]
			}).show();
		},
</c:if>
<c:if test="${adminYn == 'Y'}">
		saveAdmin: async function(option) {
			showOverlay(500);

			/* 근로시간단축 신청 */
			if ("${searchApplCd}" === "300") {

				/* 결재처리중(근무시간 조정) */
				if (this.$getModalBody().find("#applStatusCd").val() === '21'
						|| this.$getModalBody().find("#applStatusCd").val() === '31') {

					const rtn = this.$getAuthorResultFrame().get(0).contentWindow.adminDoSave2('1');
					if (rtn === 0) {
						hideOverlay();
						return;
					}
				}

				/* 결재반려 */
				if (this.$getModalBody().find("#applStatusCd").val() === '23'
						|| this.$getModalBody().find("#applStatusCd").val() === '33') {

					const rtn = this.$getAuthorResultFrame().get(0).contentWindow.adminDoSave2('2');
					if (rtn === 0) {
						hideOverlay();
						return;
					}
				}
			}

			const validation = await this.callIframeResultSaveLogic(option);
			const statusCd = this.$getModalBody().find('#approvalMgrResultStatusCd').val();
			const applStatusCd = this.$getModalBody().find('#applStatusCd').val();
			const procExecYn = this.$getModalBody().find('#procExecYn').val();
			const afterProcStatusCd = this.$getModalBody().find('#afterProcStatusCd').val();
			const searchApplSabun = this.$getModalBody().find('#searchApplSabun').val();

			if (validation) {
				const p = {...approvalResultLayer, statusCd, applStatusCd, procExecYn, afterProcStatusCd, searchApplSabun };
				const rv = ajaxCall('/ApprovalMgrResult.do?cmd=updateStatusCd', queryStringToJson(p), false);
				if (Number(rv.cnt) > 0) {
					alert(this.$getModalBody().find('#approvalMgrResultStatusCd option:selected').text() + ' 되었습니다.');
					hideOverlay();
					closeApprovalMgrResultLayer();
				}
			} else {
				hideOverlay();
			}
		},
</c:if>
		callIframeResultSaveLogic: async function(option) {
			if (approvalResultLayer.prgExists) {
				return await this.$getAuthorResultFrame().get(0).contentWindow.setValue(option);
			} else {
				return true;
			}
		},
		showPrintPage: function() {
			const p = {
				prgCd : '${ctx}${uiInfo.detailPrgCd}',
				applTitle: '${applMasterInfo.title}'
			};

			var printLayer = new window.top.document.LayerModal({
				id: 'approvalMgrResultPrintLayer',
				url: "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultPrintLayer",
				parameters: p,
				width: 815,
				height: 900,
				title: '인쇄 미리보기',
				trigger: [
					{
						name: 'approvalMgrResultPrintLayerTrigger',
						callback: function(rv) {
						}
					}
				]
			});
			printLayer.show();
		}
	}

	$(function() {
		approvalResultLayerFn.init();
	});

	function closeApprovalMgrResultLayer() {
		const modal = window.top.document.LayerModalUtility.getModal(approvalResultLayer.id);
		modal.fire('approvalMgrLayerTrigger').hide();
	}

	/**
	 * 상세화면 iframe 내 높이 재조정.
	 * @param ih
	 * @modify 2024.04.23 Det.jsp 내에서 부모의 iframeOnLoad를 호출할 때 아직 화면이 그려지기 전에 iframe의 높이를 지정하는 경우가 있어 0.4초 후 다시 높이를 조정. by kwook
	 */
	function iframeOnLoad(ih) {
		try {
			setTimeout(function() {
				const ih2 = parseInt((""+ih).split("px").join(""));
				let wrpH = 0;
				approvalResultLayerFn.$getAuthorResultFrame().contents().find(".wrapper").children().each((idx, ele) => wrpH += $(ele).outerHeight(true));
				if (wrpH > ih2)
					approvalResultLayerFn.$getAuthorResultFrame().height(wrpH);
				else
					approvalResultLayerFn.$getAuthorResultFrame().height(ih2);
			}, 400);
			approvalResultLayerFn.iframeLoad = true;
		} catch(e) {
			approvalResultLayerFn.$getAuthorResultFrame().height(ih);
			approvalResultLayerFn.iframeLoad = true;
		}
	}
</script>

<div class="wide wrapper modal_layer ux_wrapper bg-gray">
	<div class="modal_body approval">
		<div class="d-flex gap-16">
			<div class="card bg-white pa-24 rounded-16 d-flex flex-col gap-16 flex-1">
				<div class="d-flex flex-col gap-24 flex-1 scroll-y">
					<div class="bd-b">
                      	<div class="d-flex justify-between align-center mb-16">
                          	<div class="d-flex align-center gap-8 flex-1">
                              	<!-- <p class="txt_title_xs sb txt_primary">신청내용</p> -->
                          	</div>
<c:if test="${uiInfo.webPrintYn == 'Y'}">
                          	<div class="d-flex align-center gap-8">
                              	<button class="btn outline dark_gray windowPrint" id="btnApprovalMgrWebPrint">WEB 인쇄</button>
                          	</div>
</c:if>
                      	</div>
                  	</div>
					<iframe id="authorResultFrame" name="authorResultFrame" frameborder="0" class="author_iframe" style="width:100%; height:100px; min-height:317px;"></iframe>

					<!-- 신청서 하단 공통 -->
					<div class="mt-24">
<c:if test="${uiInfo.fileYn == 'Y'}">
						<div class="mb-24">
							<div id="uploadDiv">
								<iframe id="approvalMgrResultLayerUploadForm" name="approvalMgrResultLayerUploadForm" frameborder="0" class="author_iframe" style="width:100%; height:150px;"></iframe>
							</div>
						</div>
</c:if>
<c:if test="${uiInfo.etcNoteYn == 'Y'}">
						<div class="card rounded-16 pa-12-16-24" id="approvalResultLayerCommentArea">
							<div class="d-flex justify-between align-center mb-8">
								<p class="txt_title_xs sb txt_tertiary d-flex align-center gap-4">
									<i class="mdi-ico txt_18">error</i>
									신청시 유의사항
								</p>
							</div>
							<p class="pl-20 txt_body_sm txt_tertiary">
								${uiInfo.etcNote}
							</p>
						</div>
</c:if>
<c:if test="${adminYn == 'Y'}">
						<div class="mb-24">
							<div class="d-flex justify-between align-center mb-8">
								<div class="d-flex align-center gap-8 flex-1">
									<p class="txt_title_xs sb txt_secondary"><tit:txt mid='112999' mdef='결재상태'/></p>
								</div>
								<div class="d-flex align-center gap-8">
									<select id="approvalMgrResultStatusCd" style="appearance:auto" name="approvalMgrResultStatusCd" >
									</select>
								</div>
							</div>
						</div>
</c:if>
					</div>
				</div>

			</div>

			<!-- 결재영역 .footer_fixed 없애고 스타일 수정하여서 .card, .card > div, .footer 부분 컨텐츠 내용을 감싸는 div만 한 번 확인 부탁드려요 -->
			<div class="card bg-white pa-24 rounded-16 d-flex flex-col gap-16 flex-1 max-w-332">
				<div class="d-flex flex-col gap-24 flex-1 scroll-y">
					<div class="mb-24">
						<div class="d-flex justify-between align-center mb-12">
							<p class="txt_title_xs sb">결재</p>
						</div>
						<div class="card d-flex justify-between align-center txt_body_sm mb-12">
							<p class="txt_secondary">결재자 정보</p>
						</div>

						<!-- timeline-item 에 상태에 따라 completed, active, rejected 클래스 추가 -->
						<div class="timeline mb-24" id="approvalResultLayerAppLineTable">
						</div>
						<div id="approvalResultLayerReferArea" style="display: none;">
							<p class="txt_title_xs sb txt_left mb-12 txt_secondary">참조</p>

							<div class="d-flex flex-col gap-8" id="approvalResultLayerReferUser">
							</div>
						</div>
					</div>
				</div>

				<div class="footer">
<c:if test="${cancelButton.visibleApproveBtn == 'Y'}">
					<button class="btn lg primary w-full" id="btnApplConfirm">
                        <i class="mdi-ico mr-4">check</i>
                        결재
                    </button>
                    <button class="btn lg peach w-full" id="btnApplReject">
                        <i class="mdi-ico mr-4">backspace</i>
                        반려
                    </button>
</c:if>
<c:if test="${cancelButton.cancel == 'YES'}">
					<button class="btn lg dark w-full" id="btnApplRecall">회수</button>
</c:if>
<c:if test="${cancelButton.visibleReuseBtn == 'Y'}">
					<button class="btn lg dark w-full" id="btnApplReuse">재사용</button>
</c:if>
					<!-- <button class="btn lg outline w-full">취소신청</button> -->
					<!-- <button class="btn lg outline w-full">변경신청</button> -->
<c:if test="${adminYn == 'Y'}">
					<button class="btn lg primary w-full" id="btnApplSave">저장</button>
</c:if>
				</div>
			</div>
		</div>
		<form id="approvalMgrResultLayerForm" name="approvalMgrResultLayerForm">
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
			<input id="adminYn" 		name="adminYn" 			type="hidden" value="${param.adminYn}"/>
			<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>
			<input id="referUserStr" 	name="referUserStr" 	type="hidden" value=""/>
			<input id="applStatusCd" 	name="applStatusCd" 	type="hidden" value="${applMasterInfo.applStatusCd}"/>
			<input id="fileSeq"			name="fileSeq"			type="hidden" value=""/>
			<input id="agreeSeq"		name="agreeSeq"			type="hidden" value=""/>
			<input id="agreeGubun"		name="agreeGubun"		type="hidden" value=""/>
			<input id="referUserOriEtc"	name="referUserOriEtc"	type="hidden" value=""/>
			<input id="referUserNewEtc"	name="referUserNewEtc"	type="hidden" value=""/>
			<input id="applSave" 		name="applSave" 		type="hidden" value=""/>
			<input id="referSave" 		name="referSave" 		type="hidden" value=""/>
			<input id="pathSeq" 		name="pathSeq" 			type="hidden" value=""/>
			<input id="gubun" 			name="gubun" 			type="hidden" value="${gubun}"/>
			<input id="procExecYn"      name="procExecYn"       type="hidden" value="${uiInfo.procExecYn}"/>
			<input id="afterProcStatusCd"name="afterProcStatusCd"type="hidden" value="${applMasterInfo.applStatusCd}"/> <!-- 이전신청서 상태코드  2020.01.14 -->
			<input id="etc01"			name="etc01"			type="hidden" value="${etc01}"/>
			<input id="etc02"			name="etc02"			type="hidden" value="${etc02}"/>
			<input id="etc03"			name="etc03"			type="hidden" value="${etc03}"/>
			<input id="deputyInfo"		name="deputyInfo"		type="hidden" value=""/>
			<input id="agreeUserStatus"	name="agreeUserStatus"	type="hidden" value=""/> <!-- 결재/반려 여부 -->
			<input id="applYn"          name="applYn"           type="hidden" value="${applYn}"/> <!-- 현 결재자와 세션사번이 같은지 여부 -->
		</form>
		<form id="printForm" name="printForm"></form>
	</div>
</div>
