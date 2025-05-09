<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<style>
	.ui-state-disabled {
		opacity: .65;
	}
</style>
<script>
	var approvalChangeOption = {
		id: 'changeApprovalLineLayer'
		, orgCd: null
		, pathSeq: null
		, searchApplSabun: null
		, appls: null
		, deputys: null
		, inusers: null
		, refers: null
	};

	var appPathRegLayerFn = {
		approverAppTypeCodeHtml: null,
		inChargerAppTypeCodeHtml: null,
		$getModal: function() {
			return $('#modal-' + approvalChangeOption.id);
		},
		$getModalBody: function() {
			return $(this.$getModal().find(".modal_body")[0]);
		},
		$getTabContent: function(tabId) {
			return this.$getModalBody().find("#" + tabId);
		},
		$getActiveTab: function() {
			return this.$getModalBody().find(".tab_content.active");
		},
		/**
		 * 특정 탭의 대상자 리스트 Selector 조회
		 * @returns {*}
		 */
		$getEmpListByTabId: function(tabId) {
			return this.$getTabContent(tabId).find(".approval_list_table tbody");
		},
		init: async function() {
			await this.initCommons();
			this.initTab1();
			this.initTab2();
		},
		initCommons: async function() {

			// 결재자 initialize
			this.clearApprover();
			const codeList1 = await this.getApproverTypeList();
			this.approverAppTypeCodeHtml = convCodeIdx(codeList1, '', -1)[2];
			const convAppls = approvalChangeOption.appls.map(a => ({
				agreeSeq: a.agreeSeq,
				name: a.name,
				sabun: a.agreeSabun,
				empAlias: a.empAlias,
				applTypeCd: a.applTypeCd,
				orgCd: a.orgCd,
				orgNm: a.org,
				jikchakCd: a.jikchakCd,
				jikchakNm: a.jikchak,
				jikweeCd: a.jikweeCd,
				jikweeNm: a.jikwee,
			}));
			this.addApprovers(convAppls, false);

			// 담당자 initialize
			this.clearInCharger();
			const codeList2 = await this.getInChargerTypeList();
			this.inChargerAppTypeCodeHtml = convCodeIdx(codeList2, '', -1)[2];
			const convInChargers = approvalChangeOption.inusers.map(a => ({
				agreeSeq: a.agreeSeq,
				sabun: a.agreeSabun,
				name: a.agreeName,
				empAlias: a.empAlias,
				applTypeCd: a.applTypeCd,
				orgCd: a.orgCd,
				orgNm: a.org,
				jikchakCd: a.jikchakCd,
				jikchakNm: a.jikchak,
				jikweeCd: a.jikweeCd,
				jikweeNm: a.jikwee,
				orgAppYn: a.orgAppYn,
			}));
			this.addInChargers(convInChargers, false);

			// 참조자 initialize
			this.clearReferer();
			const convRefers = approvalChangeOption.refers.map(a => ({
				name: a.referName,
				sabun: a.referSabun,
				empAlias: a.referEmpAlias,
				orgCd: a.referOrgCd,
				orgNm: a.referOrg,
				jikchakCd: a.referJikchakCd,
				jikchakNm: a.referJikchak,
				jikweeCd: a.referJikweeCd,
				jikweeNm: a.referJikwee,
			}));
			this.addReferers(convRefers, false);

			this.addCommonEvents();
		},
		/**
		 * 조직도 탭의 모든 체크된 대상자의 체크 해제
		 */
		clearActiveTabAllCheckedEmps: function() {
			const activeTabId = this.$getActiveTab().attr("id");
			this.$getEmpListByTabId(activeTabId)
					.find("tr input[type=checkbox]:checked")
					.prop("checked", false);
		},
		/**
		 * 조직도 탭 초기화
		 * @returns {Promise<void>}
		 */
		initTab1: async function() {
			// 조직도 tab
			this.clearTab1EmpList();
			await this.initTab1OrgList();
			this.addTab1Events();
		},
		/**
		 * 조직도 초기화
		 * @returns {Promise<void>}
		 */
		initTab1OrgList: async function() {
			this.clearTab1OrgList();
			const orgs = await this.getTab1OrgList();
			this.renderTab1OrgList(orgs);
		},
		/**
		 * 조직도 리스트 Selector 조회
		 * @returns {*}
		 */
		$getTab1OrgList: function() {
			return this.$getModalBody().find("#appPathRegOrgList");
		},
		/**
		 * 조직도 Clear
		 */
		clearTab1OrgList: function() {
			this.$getTab1OrgList().empty();
		},
		/**
		 * 조직도 데이터 조회
		 * @returns {Promise<[{codeNm: number, perCnt: number, cnt: number}]|[{codeNm: number, perCnt: number, cnt: number}]|[{wkpAvgY: number, wkpAvgM: number}]|[[]]|*|null>}
		 */
		getTab1OrgList: async function() {
			const param = "pathSeq=" + approvalChangeOption.pathSeq + "&sabun=" + approvalChangeOption.searchApplSabun;
			const data = await callFetch("/AppPathReg.do?cmd=getAppPathOrgList", param);
			if (data == null || data.isError) {
				if (data && data.Message) alert(data.Message);
				return null;
			}

			return data.DATA;
		},
		/**
		 * 조직도 리스트 그리기
		 * @param orgs
		 */
		renderTab1OrgList: function(orgs) {
			this.clearTab1OrgList();

			if (orgs == null) return;

			for (const org of orgs) {

				let $ul;
				if (org.Level === 1) {
					this.$getTab1OrgList().append(`<ul class="tree"></ul>`);
					$ul = this.$getTab1OrgList().find("ul.tree");
					$ul.data("level", 1);
				} else {
					// 상위조직 조회
					const $priorOrg = this.$getTab1OrgList().find("div.tree_item")
							.filter(function() { return $(this).data("org").orgCd == org.priorOrgCd });
					// 상위조직의 tree 구조를 위한 ul 태그가 있는지 확인
					const hasUl = ($priorOrg.length > 0 && $priorOrg.parent().children("ul").length > 0);
					if (!hasUl) {
						// ul 태그가 없다면 추가
						$priorOrg.parent().append(`<ul></ul>`);
						$ul = $priorOrg.parent().children("ul");
						$ul.data("level", org.Level);
					} else {
						// ul 태그가 있다면 기존 ul 태그 사용
						$ul = $priorOrg.parent().children("ul");
					}
				}

				const html = this.getOrgItemHtml();
				$ul.last().append(html);
				const $el = $ul.last().children("li").last();
				$el.find(".tree_item").data("org", org);
				$el.find(".tree_item>span").text(org.orgNm);
				this.addTab1OrgItemEvent($el.find(".tree_item"));
			}

			this.doSearchFirstOrgItem();
		},
		getOrgItemHtml: function() {
			return `<li>
					<div class="tree_item">
						<i class="mdi-ico tree_toggle"></i>
						<span></span>
					</div>
				</li>`;
		},
		setTab1OrgItem: function($el, org, idx) {
			$el.data("org", org);
			$el.find("td").eq(1).text(idx);
			$el.find("td").eq(3).text(org.name);
			$el.find("td").eq(4).text(org.orgNm);
			$el.find("td").eq(5).text(org.jikchakNm);
			$el.find("td").eq(6).text(org.jikweeNm);
		},
		addTab1OrgItemEvent: function($el) {
			$el.on("click", function(e) {
				e.stopPropagation();
				appPathRegLayerFn.$getModalBody().find('.tree_container .tree_item').removeClass('active');
				$(this).addClass('active');
				approvalChangeOption.orgCd = $(this).data("org").orgCd;
				appPathRegLayerFn.initTab1EmpList();
			});

			const getHelperHtml = (orgNm) => {
				return `<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
							<div class="d-flex align-center gap-4">
								<i class="mdi-ico txt_18 txt_tertiary cursor-pointer deleteItem">delete_forever</i>
								<div class="desc_divider_wrap dot">
									<span class="txt_body_sm sb txt_primary aliEmpName">${'${orgNm}'}</span>
								</div>
							</div>
							<div class="d-flex align-center gap-8 appLineItemOption">
								<i class="mdi-ico txt_18 txt_tertiary cursor-pointer dragHandle">drag_handle</i>
							</div>
						</div>`;
			};

			// 담당부서 등록
			$el.draggable({
				connectToSortable: "#" + this.$getInChargerList().attr("id"),
				helper: function(e) {
					const orgNm = $(e.target).text();
					return getHelperHtml(orgNm);
				},
				start: function(e, ui) {
					const width = appPathRegLayerFn.$getInChargerList().eq(0).css("width");
					$(ui.helper[0]).css("width", width).css("height", "auto");
					$(ui.helper[0]).data("org", $(e.target).data("org"));
				},
			})
		},
		doSearchFirstOrgItem: function() {
			this.$getTab1OrgList()
					.find(".tree_item")
					.filter(function() { return $(this).data("org").Level === 1 }).eq(0)
					.click();
		},
		/**
		 * 조직도 탭의 대상자 리스트 Selector 조회
		 * @returns {*}
		 */
		$getTab1EmpList: function() {
			return this.$getModalBody().find(".tab_content#tab1 #appPathRegEmpList tbody");
		},
		initTab1EmpList: async function() {
			this.clearTab1EmpList();
			const emps = await this.getTab1EmpList();
			this.renderTab1EmpList(emps);
		},
		clearTab1EmpList: function() {
			this.$getTab1EmpList().empty();
		},
		getTab1EmpList: async function() {
			const param = "pathSeq=" + approvalChangeOption.pathSeq +
					"&orgCd=" + approvalChangeOption.orgCd;
			const data = await callFetch("/AppPathReg.do?cmd=getAppPathRegOrgUserList", param);
			if (data == null || data.isError) {
				if (data && data.Message) alert(data.Message);
				return null;
			}

			return data.DATA;
		},
		renderTab1EmpList: function(emps) {
			this.clearTab1EmpList();

			if (emps == null || emps.length === 0) {
				const html = this.getNoEmpItemHtml();
				this.$getTab1EmpList().append(html);
				return;
			}

			let idx = 1;
			for (const emp of emps) {
				const html = this.getTab1EmpItemHtml();
				this.$getTab1EmpList().append(html);
				const $last = this.$getTab1EmpList().children().last();
				this.setTab1EmpItem($last, emp, idx);
				idx++;
			}
		},
		getNoEmpItemHtml: function() {
			return `<div class="d-flex flex-col gap-8 align-center">
					<i class="icon no_user size-100"></i>
					<p class="txt_body_sm txt_tertiary">검색결과가 없습니다.</p>
				</div>`;
		},
		getTab1EmpItemHtml: function() {
			return `<tr>
					<td></td>
					<td>
						<input type="checkbox" class="form-checkbox" id="checkbox1" />
					</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>`;
		},
		setTab1EmpItem: function($el, emp, idx) {
			$el.data("emp", emp);
			$el.find("td").eq(0).text(idx);
			$el.find("td").eq(2).text(emp.name);
			$el.find("td").eq(3).text(emp.orgNm);
			$el.find("td").eq(4).text(emp.jikchakNm);
			$el.find("td").eq(5).text(emp.jikweeNm);
		},
		/**
		 * 조직도 탭의 선택된 대상자 리스트 조회
		 * @returns {*[]|null}
		 */
		getTab1CheckedEmps: function() {
			let emps = [];

			this.$getTab1EmpList()
					.find("tr")
					.filter(function() { return $(this).find("input[type=checkbox]").is(":checked") })
					.each(function(idx, obj) { emps.push($(obj).data("emp")) });

			if (emps.length === 0) {
				alert("대상자를 선택해주시기 바랍니다.");
				return null;
			}

			return emps;
		},
		/**
		 * 조직도 탭의 이벤트 추가
		 */
		addTab1Events: function() {

			// 트리 컨트롤
			this.$getModalBody().find('.tree_container .tree_toggle').click(function(e) {
				e.stopPropagation();
				$(this).closest('li').toggleClass('collapsed');
			});

			this.$getModalBody().find('.tree_top .mdi-ico').click(function() {
				const iconIndex = $(this).index();
				const $tree = $(this).closest('.card').find('.tree');

				switch(iconIndex) {
					case 0:
						$tree.find('li').removeClass('collapsed');
						break;
					case 1:
						$tree.find('li').addClass('collapsed');
						break;
					case 2:
						$tree.find('li').addClass('collapsed');
						$tree.find('> li').removeClass('collapsed');
						$tree.find('> li > ul > li').removeClass('collapsed');
						break;
					case 3:
						$tree.find('li').addClass('collapsed');
						$tree.find('> li').removeClass('collapsed');
						break;
				}
			});

			this.$getModalBody().find("#btnAppPathRegTab1AddApprovers").on("click", function() {
				const emps = appPathRegLayerFn.getTab1CheckedEmps();
				if (emps == null) return;
				appPathRegLayerFn.addApprovers(emps, true);
			});

			this.$getModalBody().find("#btnAppPathRegTab1AddInChargers").on("click", function() {
				const emps = appPathRegLayerFn.getTab1CheckedEmps();
				if (emps == null) return;
				appPathRegLayerFn.addInChargers(emps, true);
			});

			this.$getModalBody().find("#btnAppPathRegTab1AddReferers").on("click", function() {
				const emps = appPathRegLayerFn.getTab1CheckedEmps();
				if (emps == null) return;
				appPathRegLayerFn.addReferers(emps, true);
			});
		},
		/**
		 * 검색 탭 초기화
		 * @returns {Promise<void>}
		 */
		initTab2: async function() {
			// 검색 tab
			await this.initTab2EmpList();
			this.addTab2Events();
		},
		$getTab2EmpList: function() {
			return this.$getTabContent("tab2").find("#appPathRegTab2EmpList tbody");
		},
		initTab2EmpList: async function() {
			this.clearTab2EmpList();
		},
		clearTab2EmpList: function() {
			this.$getTab2EmpList().empty();
		},
		getTab2EmpList: async function() {
			const searchKeyword = this.$getTabContent("tab2").find("input#searchKeyword").val();

			const param = "pathSeq=" + approvalChangeOption.pathSeq +
					"&searchKeyword=" + searchKeyword;
			const data = await callFetch("/AppPathReg.do?cmd=getAppPathRegOrgUserList", param);
			if (data == null || data.isError) {
				if (data && data.Message) alert(data.Message);
				return null;
			}

			return data.DATA;
		},
		renderTab2EmpList: function(emps) {
			this.clearTab2EmpList();

			const $tab2 = this.$getTabContent("tab2");

			if (emps == null || emps.length === 0) {
				$tab2.find("#appPathRegTab2EmpTitle").hide();
				$tab2.find("#appPathRegTab2EmpList").hide();
				$tab2.find("#appPathRegTab2EmpBtnArea").attr("style", function(i, s) { return (s || '') + 'display: none !important;'});
				$tab2.find("#appPathRegTab2NoEmpList").show();
				return;
			} else {
				$tab2.find("#appPathRegTab2NoEmpList").attr("style", function(i, s) { return (s || '') + 'display: none !important;'});
				$tab2.find("#appPathRegTab2EmpTitle").show();
				$tab2.find("#appPathRegTab2EmpList").show();
				$tab2.find("#appPathRegTab2EmpBtnArea").show();
			}

			let idx = 1;
			for (const emp of emps) {
				const html = this.getTab2EmpItemHtml();
				this.$getTab2EmpList().append(html);
				const $last = this.$getTab2EmpList().children().last();
				this.setTab2EmpItem($last, emp, idx);
				idx++;
			}
		},
		getTab2EmpItemHtml: function() {
			return `<tr>
					<td></td>
					<td>
						<input type="checkbox" class="form-checkbox" id="checkbox1" />
					</td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>`;
		},
		addTab2Events: function() {
			const $tab2 = this.$getTabContent("tab2");

			$tab2.find("#btnAppPathRegTab2AddApprover").on("click", function() {
				const emps = appPathRegLayerFn.getTab2CheckedEmps();
				if (emps == null) return;
				appPathRegLayerFn.addApprovers(emps, true);
			})

			$tab2.find("#btnAppPathRegTab2AddInCharger").on("click", function() {
				const emps = appPathRegLayerFn.getTab2CheckedEmps();
				if (emps == null) return;
				appPathRegLayerFn.addInChargers(emps, true);
			})

			$tab2.find("#btnAppPathRegTab2AddReferer").on("click", function() {
				const emps = appPathRegLayerFn.getTab2CheckedEmps();
				if (emps == null) return;
				appPathRegLayerFn.addReferers(emps, true);
			})

			$tab2.find("#btnAppPathRegTab2Search").on("click", async function() {
				const $searchKeyword = appPathRegLayerFn.$getTabContent("tab2").find("input#searchKeyword");
				if (!$searchKeyword.val()) {
					alert("검색어를 입력해주세요.");
					$searchKeyword.focus();
					return;
				}

				const emps = await appPathRegLayerFn.getTab2EmpList();
				appPathRegLayerFn.renderTab2EmpList(emps);
			})

			$tab2.find("input#searchKeyword").on("keyup", function(e) {
				if (e.keyCode == 13) {
					$tab2.find("#btnAppPathRegTab2Search").click();
				}
			})

			$tab2.find("#btnAppPathRegTab2SearchCancel").on("click", function() {
				appPathRegLayerFn.renderTab2EmpList(null);
			})
		},
		/**
		 * 조직도 탭의 선택된 대상자 리스트 조회
		 * @returns {*[]|null}
		 */
		getTab2CheckedEmps: function() {
			let emps = [];

			this.$getTab2EmpList()
					.find("tr")
					.filter(function() { return $(this).find("input[type=checkbox]").is(":checked") })
					.each(function(idx, obj) { emps.push($(obj).data("emp")) });

			if (emps.length === 0) {
				alert("대상자를 선택해주시기 바랍니다.");
				return null;
			}

			return emps;
		},
		setTab2EmpItem: function($el, emp, idx) {
			$el.data("emp", emp);
			$el.find("td").eq(0).text(idx);
			$el.find("td").eq(2).text(emp.name);
			$el.find("td").eq(3).text(emp.orgNm);
			$el.find("td").eq(4).text(emp.jikchakNm);
			$el.find("td").eq(5).text(emp.jikweeNm);
		},
		/**
		 * 결재자 리스트 Selector 조회
		 * @returns {*}
		 */
		$getApproverList: function() {
			return this.$getModalBody().find("#appPathRegApproverList");
		},
		/**
		 * 결재자 리스트 Clear
		 */
		clearApprover: function() {
			this.$getApproverList().empty();
		},
		addApprovers: function(emps, isCheckValid = false) {
			const $approverList = this.$getApproverList();

			if (emps == null || emps.length === 0) {
				const html = this.getNoAppLineItemHtml("결재자를 선택해주제요.");
				$approverList.append(html);
				return;
			} else {
				if ($approverList.find(".appPathRegNoAppLineItem").length > 0)
					this.clearApprover();
			}

			if (isCheckValid && !this.isValidAddApprovers(emps)) {
				return;
			}

			for (const emp of emps) {
				emp.addType = "approver";
				const html = this.getAppLineItemHtml(emp);
				$approverList.append(html);
				const $last = $approverList.children().last();
				this.setAppLineItem($last, emp);
				this.addAppLineItemEvent($last);
			}

			this.clearActiveTabAllCheckedEmps();
		},
		isValidAddApprovers: function(emps) {
			const $approverList = this.$getApproverList();
			let dupList = [];
			emps.forEach(obj => {
				const isDup = $approverList.find(".card").filter(function() { return $(this).data("item").sabun === obj.sabun; }).length > 0;
				if (isDup) dupList.push(obj);
			})
			if (dupList.length > 0) {
				const dupNames = dupList.map(obj => obj.name).join(", ");
				if (!confirm(dupNames + " 대상자는 이미 추가되어있습니다. 추가하시겠습니까?")) return false;
			}
			return true;
		},
		/**
		 * 담당자 리스트 Selector 조회
		 * @returns {*}
		 */
		$getInChargerList: function() {
			return this.$getModalBody().find("#appPathRegInChargerList");
		},
		/**
		 * 담당자 리스트 Clear
		 */
		clearInCharger: function() {
			this.$getInChargerList().empty();
		},
		addInChargers: function(emps, isCheckValid = false) {
			const $inChargerList = this.$getInChargerList();

			if (emps == null || emps.length === 0) {
				const html = this.getNoAppLineItemHtml("담당자를 선택해주제요.");
				$inChargerList.append(html);
				return;
			} else {
				if ($inChargerList.find(".appPathRegNoAppLineItem").length > 0)
					this.clearInCharger();
			}

			if (isCheckValid && !this.isValidAddInChargers(emps)) {
				return;
			}

			for (const emp of emps) {
				emp.addType = "incharger";
				const html = this.getAppLineItemHtml(emp);
				$inChargerList.append(html);
				const $last = $inChargerList.children().last();
				this.setAppLineItem($last, emp);
				this.addAppLineItemEvent($last);
			}

			this.clearActiveTabAllCheckedEmps();
		},
		isValidAddInChargers: function(emps) {
			const $inChargerList = this.$getInChargerList();
			let dupList = [];
			emps.forEach(obj => {
				const isDup = $inChargerList.find(".card").filter(function() { return $(this).data("item").sabun === obj.sabun; }).length > 0;
				if (isDup) dupList.push(obj);
			})
			if (dupList.length > 0) {
				const dupNames = dupList.map(obj => obj.name).join(", ");
				if (!confirm(dupNames + " 대상자는 이미 추가되어있습니다. 추가하시겠습니까?")) return false;
			}
			return true;
		},
		/**
		 * 참조자 리스트 Selector 조회
		 * @returns {*}
		 */
		$getRefererList: function() {
			return this.$getModalBody().find("#appPathRegRefererList");
		},
		/**
		 * 참조자 리스트 Clear
		 */
		clearReferer: function() {
			this.$getRefererList().empty();
		},
		addReferers: function(emps, isCheckValid = false) {
			const $refererList = this.$getRefererList();
			if (emps == null || emps.length === 0) {
				const html = this.getNoAppLineItemHtml("참조자를 선택해주제요.");
				$refererList.append(html);
				return;
			} else {
				if ($refererList.find(".appPathRegNoAppLineItem").length > 0)
					this.clearReferer();
			}

			if (isCheckValid && !this.isValidAddReferers(emps)) {
				return;
			}

			for (const emp of emps) {
				emp.addType = "referer";
				const html = this.getAppLineItemHtml(emp);
				$refererList.append(html);
				const $last = $refererList.children().last();
				this.setAppLineItem($last, emp);
				this.addAppLineItemEvent($last);
			}

			this.clearActiveTabAllCheckedEmps();
		},
		isValidAddReferers: function(emps) {
			const $refererList = this.$getRefererList();
			let dupList = [];
			emps.forEach(obj => {
				const isDup = $refererList.find(".card").filter(function() { return $(this).data("item").sabun === obj.sabun; }).length > 0;
				if (isDup) dupList.push(obj);
			})
			if (dupList.length > 0) {
				const dupNames = dupList.map(obj => obj.name).join(", ");
				if (!confirm(dupNames + " 대상자는 이미 추가되어있습니다. 추가하시겠습니까?")) return false;
			}
			return true;
		},
		getApproverTypeList: async function() {
			const param = "grpCd=R10052&queryId=R10052&notCode=40";
			const data = await callFetch("/CommonCode.do?cmd=getCommonCodeList", param);
			if (data == null || data.isError) {
				if (data && data.errMsg) alert(data.errMsg);
				return null;
			}

			return data.codeList;
		},
		getInChargerTypeList: async function() {
			const param = "grpCd=R10052&queryId=R10052&notCode=30";
			const data = await callFetch("/CommonCode.do?cmd=getCommonCodeList", param);
			if (data == null || data.isError) {
				if (data && data.errMsg) alert(data.errMsg);
				return null;
			}

			return data.codeList;
		},
		getNoAppLineItemHtml: function(msg) {
			return `<div class="h-84 d-flex flex-col justify-between align-center appPathRegNoAppLineItem">
						<i class="icon no_user"></i>
						<p class="txt_body_sm txt_tertiary">${'${msg}'}</p>
					</div>`;
		},
		getAppLineItemHtml: function(emp) {

			let codeHtml = ``;
			if (emp.addType === "approver") { // 결재자
				codeHtml = appPathRegLayerFn.approverAppTypeCodeHtml;
			} else if (emp.addType === "incharger") { // 담당자
				codeHtml = appPathRegLayerFn.inChargerAppTypeCodeHtml;
			}

			let deleteHtml = `<i class="mdi-ico txt_18 txt_tertiary cursor-pointer deleteItem">delete_forever</i>`;
			let dragHtml = `<i class="mdi-ico txt_18 txt_tertiary cursor-pointer dragHandle">drag_handle</i>`;
			let disableClass = ``;

			// 결재자 중 기안자의 경우 삭제, drag 이벤트 발생 불가
			const disableModify = (emp.addType === "approver" && emp.applTypeCd === "30");
			if (disableModify) {
				deleteHtml = ``;
				dragHtml = ``;
				disableClass = `ui-state-disabled`;
			}

			let appTypeCdHtml = '';
			if (emp.addType === "approver" || emp.addType === "incharger") {
				appTypeCdHtml = `<div class="d-flex align-center gap-8">
									<select class="custom_select w-82" name="applTypeCd">
										${'${codeHtml}'}
									</select>
									${'${dragHtml}'}
								</div>`;
			} else {
				appTypeCdHtml = `<div class="d-flex align-center gap-8">
									${'${dragHtml}'}
								</div>`;
			}
			return `<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between ${'${disableClass}'}">
						<div class="d-flex align-center gap-4">
							${'${deleteHtml}'}
							<div class="desc_divider_wrap dot">
								<span class="txt_body_sm sb txt_primary aliEmpName"></span>
								<span class="aliJikchakNm"></span>
								<span class="aliOrgNm"></span>
							</div>
						</div>
						${'${appTypeCdHtml}'}
					</div>`;
		},
		setAppLineItem: function($el, emp) {
			if (emp == null) return;

			$el.data("item", emp);

			const jikchakNm = emp.jikchakNm ? emp.jikchakNm : '-';
			const orgNm = emp.orgNm ? emp.orgNm : '-';
			if (emp.orgAppYn != null && emp.orgAppYn === "Y") {
				$el.find(".aliEmpName").text(orgNm);
				$el.find(".aliJikchakNm").remove();
				$el.find(".aliOrgNm").remove();
			} else {
				$el.find(".aliEmpName").text(emp.name);
				$el.find(".aliJikchakNm").text(jikchakNm);
				$el.find(".aliOrgNm").text(orgNm);
			}

			if (emp.applTypeCd) {
				$el.find("select[name=applTypeCd]").val(emp.applTypeCd);
			}
		},
		addAppLineItemEvent: function($el) {
			$el.find("i.deleteItem").on("click", function(e) {
				e.stopPropagation();

				const $list = $(this).closest(".appPathRegList");
				const listId = $list.attr("id");

				$(this).closest(".card").remove();

				const isNoData = $list.children().length === 0;
				if (isNoData) {
					if (listId === appPathRegLayerFn.$getApproverList().attr("id")) {
						$list.append(appPathRegLayerFn.getNoAppLineItemHtml("결재자를 선택해주세요."));
					} else if (listId === appPathRegLayerFn.$getInChargerList().attr("id")) {
						$list.append(appPathRegLayerFn.getNoAppLineItemHtml("담당자를 선택해주세요."));
					} else if (listId === appPathRegLayerFn.$getRefererList().attr("id")) {
						$list.append(appPathRegLayerFn.getNoAppLineItemHtml("참조자를 선택해주세요."));
					}
				}
			})
		},
		addCommonEvents: function() {
			// 결재자변경 내부 탭
			this.$getModalBody().find(".tab_container .tab").on("click", function () {
				const $container = $(this).closest(".tab_container");
				const $bankForm = $(this).closest(".approval_select");
				$container.find(".tab").removeClass("active");
				$(this).addClass("active");
				const tabId = $(this).data("tab");
				$bankForm.find(".tab_content").removeClass("active");
				$bankForm.find("#" + tabId).addClass("active");
			})

			// 결재자 sorting 이벤트
			this.$getApproverList().sortable({
				handle: ".dragHandle",
				items: ".card:not(.ui-state-disabled)"
			});

			// 담당자 sorting 이벤트
			this.$getInChargerList().sortable({
				handle: ".dragHandle",
				start: function(e, ui) {
					const width = $(e.target).css("width");
					$(ui.helper).css("width", width);
				},
				receive: function(e, ui) {
					// 조직도에서 조직을 드래그 후 이벤트
					if (appPathRegLayerFn.$getInChargerList().find(".appPathRegNoAppLineItem").length > 0)
						appPathRegLayerFn.$getInChargerList().find(".appPathRegNoAppLineItem").remove();

					const $el = $(ui.helper[0]);
					$(ui.helper[0]).css("width", "auto").css("height", "auto");

					const data = $el.data("org");
					const obj = {
						orgAppYn: "Y", orgCd: data.orgCd, orgNm: data.orgNm,
						agreeSabun: data.orgCd, agreeName: data.orgNm, empAlias: "-",
						name: data.orgNm, jikchakNm: "", jikchakCd: "", jikweeNm: "", jikweeCd: ""
					};

					const getCodeHtml = () => {
						let codeHtml = appPathRegLayerFn.inChargerAppTypeCodeHtml;
						return `<select class="custom_select w-82" name="applTypeCd">
							${'${codeHtml}'}
						</select>`;
					}

					$el.find(".appLineItemOption").prepend(getCodeHtml());
					appPathRegLayerFn.setAppLineItem($el, obj);
					appPathRegLayerFn.addAppLineItemEvent($el);
				}
			});

			// 참조자 sorting 이벤트
			this.$getRefererList().sortable({
				handle: ".dragHandle",
			});

			this.$getModalBody().find("#btnAppPathRegConfirm").on("click", function() {
				const param = appPathRegLayerFn.getReturnParam();
				const modal = window.top.document.LayerModalUtility.getModal(approvalChangeOption.id);
				modal.fire('changeApprovalLineTrigger', param).hide();
			})

			this.$getModalBody().find("#btnAppPathRegCancel").on("click", function() {
				const modal = window.top.document.LayerModalUtility.getModal(approvalChangeOption.id);
				modal.hide();
			})
		},
		/**
		 * 상위 신청화면에 결재선을 전달하기 위한 데이터 생성
		 * @returns {{appls: *[], inappls: *[], referer: *[]}}
		 */
		getReturnParam() {
			let appls = [];
			this.$getApproverList()
					.find(".card")
					.each(function(idx, obj) {
						const data = $(obj).data("item");
						const newObj = $.extend({}, data);
						newObj.agreeSeq = idx+1;
						newObj.agreeSabun = data.agreeSabun ? data.agreeSabun : data.sabun ? data.sabun : '';
						newObj.orgNm = data.orgNm ? data.orgNm : data.org ? data.org : '';
						newObj.applTypeCd = $(obj).find("select[name=applTypeCd]").val();
						newObj.applTypeCdNm = $(obj).find("select[name=applTypeCd] option:selected").text();
						newObj.jikweeNm = data.jikweeNm ? data.jikweeNm : data.jikwee ? data.jikwee : '';
						newObj.jikchakNm = data.jikchakNm ? data.jikchakNm : data.jikchak ? data.jikchak : '';
						appls.push(newObj);
					});

			let inappls = [];
			this.$getInChargerList()
					.find(".card")
					.each(function(idx, obj) {
						const data = $(obj).data("item");
						const newObj = $.extend({}, data);
						newObj.agreeSabun = data.agreeSabun ? data.agreeSabun : data.sabun ? data.sabun : '';
						newObj.agreeName = data.agreeName ? data.agreeName : data.name ? data.name : '';
						newObj.applTypeCd = $(obj).find("select[name=applTypeCd]").val();
						newObj.applTypeCdNm = $(obj).find("select[name=applTypeCd] option:selected").text();
						newObj.orgNm = data.orgNm ? data.orgNm : data.org ? data.org : '';
						newObj.jikchakNm = data.jikchakNm ? data.jikchakNm : data.jikchak ? data.jikchak : '';
						newObj.jikweeNm = data.jikweeNm ? data.jikweeNm : data.jikwee ? data.jikwee : '';
						inappls.push(newObj);
					});

			let referer = [];
			this.$getRefererList()
					.find(".card")
					.each(function(idx, obj) {
						const data = $(obj).data("item");
						const newObj = $.extend({}, data);
						newObj.ccSabun = data.ccSabun ? data.ccSabun : data.agreeSabun ? data.agreeSabun : data.sabun ? data.sabun : '';
						newObj.orgNm = data.orgNm ? data.orgNm : data.org ? data.org : '';
						newObj.jikchakNm = data.jikchakNm ? data.jikchakNm : data.jikchak ? data.jikchak : '';
						newObj.jikweeNm = data.jikweeNm ? data.jikweeNm : data.jikwee ? data.jikwee : '';
						newObj.pathSeq = approvalChangeOption.pathSeq;
						referer.push(newObj);
					});

			return { appls, inappls, referer };
		}
	}

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal(approvalChangeOption.id);
		const parameters =  modal.parameters;

		approvalChangeOption = {
			id: 'changeApprovalLineLayer'
			, orgCd: '${orgCd}'
			, pathSeq: '${pathSeq}'
			, searchApplSabun: '${searchApplSabun}'
			, ...parameters.lines
		};

		appPathRegLayerFn.init();
	});
</script>
<div class="wrapper modal_layer ux_wrapper">
	<div class="modal_body approval_select">
		<div class="tab_container ma-auto mb-16 w-164">
			<ul>
				<li>
					<button class="tab active" data-tab="tab1">조직도</button>
				</li>
				<li>
					<button class="tab" data-tab="tab2">검색</button>
				</li>
			</ul>
		</div>

		<!-- 컨텐츠 -->
		<div class="d-flex gap-16">
			<div class="tab_content active" id="tab1">
				<div class="d-flex gap-16 approval_tab_1">
					<div class="card rounded-12 pa-8">
						<div class="tree_top">
							<i class="mdi-ico">add_circle</i>
							<i class="mdi-ico">remove_circle</i>
							<i class="mdi-ico">drag_handle</i>
							<i class="mdi-ico">remove</i>
						</div>
						<div class="tree_container" id="appPathRegOrgList">
							<!--
							<ul class="tree">
								<li>
									<div class="tree_item">
										<i class="mdi-ico tree_toggle"></i>
										<span>이수시스템</span>
									</div>
									<ul>
										<li>
											<div class="tree_item">
												<i class="mdi-ico tree_toggle"></i>
												<span>대표이사</span>
											</div>
											<ul>
												<li>
													<div class="tree_item">
														<i class="mdi-ico tree_toggle"></i>
														<span>디지털사업본부</span>
													</div>
													<ul>
														<li>
															<div class="tree_item">
																<i class="mdi-ico tree_toggle"></i>
																<span>김유진</span>
															</div>
														</li>
														<li>
															<div class="tree_item">
																<i class="mdi-ico tree_toggle"></i>
																<span>김유진</span>
															</div>
														</li>
													</ul>
												</li>
												<li>
													<div class="tree_item">
														<i class="mdi-ico tree_toggle"></i>
														<span>디지털사업본부</span>
													</div>
												</li>
											</ul>
										</li>
										<li>
											<div class="tree_item">
												<i class="mdi-ico tree_toggle"></i>
												<span>대표이사</span>
											</div>
											<ul>
												<li>
													<div class="tree_item">
														<i class="mdi-ico tree_toggle"></i>
														<span>디지털사업본부</span>
													</div>
												</li>
											</ul>
										</li>
									</ul>
								</li>
							</ul>
                            -->
						</div>
					</div>
					<div class="card rounded-0 bg-white pa-0">
						<p class="txt_body_sm txt_secondary mb-8">*선택 후 하단에서 추가버튼을 눌러주세요</p>
						<div class="scroll_table_wrap fixed_h approval_list_table">
							<table class="custom_table" id="appPathRegEmpList">
								<thead>
								<tr>
									<th>No</th>
									<th>선택</th>
									<th>성명</th>
									<th>부서</th>
									<th>직책</th>
									<th>직위</th>
								</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="d-flex gap-8 all-flex-1 py-24-16 bd-t-c-1">
							<button class="btn outline" id="btnAppPathRegTab1AddApprovers">결재자 추가</button>
							<button class="btn outline" id="btnAppPathRegTab1AddInChargers">담당자 추가</button>
							<button class="btn outline" id="btnAppPathRegTab1AddReferers">참조자 추가</button>
						</div>
					</div>
				</div>
			</div>

			<div class="tab_content flex-1" id="tab2">
				<div class="approval_tab_2">
					<div class="input_search_wrap mb-20">
						<input id="searchKeyword" name="searchKeyword" type="text" class="input_text w-320" placeholder="성명 또는 소속으로 검색해주세요" />
						<span class="material-icons-outlined cancel_btn" id="btnAppPathRegTab2SearchCancel">cancel</span>
						<span class="material-icons-outlined txt_tertiary" id="btnAppPathRegTab2Search">search</span>
					</div>

					<div class="card rounded-0 bg-white pa-0">
						<div class="d-flex flex-col gap-8 align-center" id="appPathRegTab2NoEmpList">
							<i class="icon no_user size-100"></i>
							<p class="txt_body_sm txt_tertiary">검색결과가 없습니다.</p>
						</div>
						<p class="txt_body_sm txt_secondary mb-8" id="appPathRegTab2EmpTitle" style="display: none;">*선택 후 하단에서 추가버튼을 눌러주세요</p>
						<div class="scroll_table_wrap fixed_h approval_list_table" id="appPathRegTab2EmpList" style="display: none;">
							<table class="custom_table">
								<thead>
								<tr>
									<th>No</th>
									<th>선택</th>
									<th>성명</th>
									<th>부서</th>
									<th>직책</th>
									<th>직위</th>
								</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
						<div class="d-flex gap-8 all-flex-1 py-24-16 bd-t-c-1" id="appPathRegTab2EmpBtnArea" style="display: none !important;">
							<button class="btn outline" id="btnAppPathRegTab2AddApprover">결재자 추가</button>
							<button class="btn outline" id="btnAppPathRegTab2AddInCharger">담당자 추가</button>
							<button class="btn outline" id="btnAppPathRegTab2AddReferer">참조자 추가</button>
						</div>
					</div>
				</div>
			</div>

			<!-- 하단 버튼 영역 (.footer)가 안보여야 하는 경우에는 .footer_fixed 클래스 제거 + div.footer 제거 -->
			<div class="card pa-0 rounded-12 d-flex flex-col justify-between pt-20 w-386 min-w-386">
				<div class="px-12">
					<p class="txt_body_sm txt_secondary d-flex align-center gap-4 mb-10">
						<i class="mdi-ico txt_18">drag_handle</i>
						드래그 버튼을 클릭하여 순서를 변경할 수 있습니다.
					</p>

					<div>
						<div class="mb-24" id="appPathRegApproverArea">
							<div class="card bg-dark-gray rounded-8 pa-8 mb-8">
								<p class="txt_body_sm sb">결재자</p>
							</div>
							<div class="d-flex flex-col gap-8 appPathRegList" id="appPathRegApproverList">
								<!-- <div class="h-84 d-flex flex-col justify-between align-center">
                                    <i class="icon no_user"></i>
                                    <p class="txt_body_sm txt_tertiary">결재자를 선택해주세요</p>
                                </div> -->
								<!-- <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<select class="custom_select w-82" name="" id="">
											<option value="">결재</option>
										</select>
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div>
								<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<select class="custom_select w-82" name="" id="">
											<option value="">결재</option>
										</select>
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div>
								<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<select class="custom_select w-82" name="" id="">
											<option value="">결재</option>
										</select>
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div> -->
							</div>
						</div>
						<div class="mb-24" id="appPathRegInChargerArea">
							<div class="card bg-dark-gray rounded-8 pa-8 mb-8">
								<p class="txt_body_sm sb">담당자</p>
							</div>
							<div class="d-flex flex-col gap-8 appPathRegList" id="appPathRegInChargerList">
								<!-- <div class="h-84 d-flex flex-col justify-between align-center">
                                    <i class="icon no_user"></i>
                                    <p class="txt_body_sm txt_tertiary">담당을 선택해주세요</p>
                                </div> -->
								<!-- <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<select class="custom_select w-82" name="" id="">
											<option value="">결재</option>
										</select>
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div>
								<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<select class="custom_select w-82" name="" id="">
											<option value="">결재</option>
										</select>
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div>
								<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<select class="custom_select w-82" name="" id="">
											<option value="">결재</option>
										</select>
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div> -->
							</div>
						</div>

						<div class="mb-24" id="appPathRegRefererArea">
							<div class="card bg-dark-gray rounded-8 pa-8 mb-8">
								<p class="txt_body_sm sb">참조자</p>
							</div>
							<div class="d-flex flex-col gap-8 appPathRegList" id="appPathRegRefererList">
								<!-- <div class="h-84 d-flex flex-col justify-between align-center">
                                    <i class="icon no_user"></i>
                                    <p class="txt_body_sm txt_tertiary">참조를 선택해주세요</p>
                                </div> -->
								<!-- <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div>
								<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div>
								<div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
									<div class="d-flex align-center gap-4">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
										<div class="desc_divider_wrap dot">
											<span class="txt_body_sm sb txt_primary">김이수</span>
											<span>팀장</span>
											<span>영업관리팀</span>
										</div>
									</div>
									<div class="d-flex align-center gap-8">
										<i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
									</div>
								</div> -->
							</div>
						</div>
					</div>
				</div>
				<div class="d-flex gap-8 all-flex-1 pa-16-24 bd-t-c-1">
					<button class="btn m outline dark_gray" id="btnAppPathRegCancel">취소</button>
					<button class="btn m primary w-full" id="btnAppPathRegConfirm">
						<i class="mdi-ico mr-4">check</i>
						적용
					</button>
				</div>
			</div>
		</div>
	</div>
</div>
