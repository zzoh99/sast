<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title><tit:txt mid='104038' mdef='인사기본(보증)'/></title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicUser/psnalBasicUserTemplates.jsp"%>

	<script type="text/javascript">

		$(function() {
			init();
		});

		async function init() {
			await setUsableTemplate();
			addBtnEvent();
			const text = await getTabInfoJson();
			$("#tabInfoJson").val(text);
			renderPreview(text);
		}

		async function setUsableTemplate() {
			const codes = await getCommonCodes();
			let html = "";
			for (const code of codes) {
				html += `<a class="btn outline_gray" data-code="${'${code.code}'}">${'${code.codeNm}'}</a>`;
			}
			$("#templateIds").html(html);
			$("#templateIds a").on('click', function() {
				const msg = $("#tabInfoJson").val();
				const spos = $("#tabInfoJson").prop("selectionStart");
				const epos = $("#tabInfoJson").prop("selectionEnd");
				const msg1 = msg.substring(0, spos);
				const msg2 = msg.substring(epos, msg.length);

				const code = $(this).attr("data-code");

				$("#tabInfoJson").val(msg1 + code + msg2);
			});
		}

		async function getCommonCodes() {
			const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonCodeLists", "grpCd=H50501");
			if (data == null || data.isError) {
				if (data != null && data.errMsg) alert(data.errMsg);
				else alert("알 수 없는 오류가 발생하였습니다.");
				return;
			}

			return data.codeList;
		}

		async function getTabInfoJson() {
			const data = await callFetch("${ctx}/PsnalBasicUserConfig.do?cmd=getPsnalBasicUserConfigJson", "");
			if (data == null || data.isError) {
				if (data != null && data.errMsg) alert(data.errMsg);
				else alert("알 수 없는 오류가 발생하였습니다.");
				return;
			}

			if (!data.map || !data.map.jsonText) {
				return defaultTemplate;
			} else {
				return data.map.jsonText;
			}
		}

		function renderPreview(text) {
			try {
				const tabJson = JSON.parse(text);
				renderPreviewByJson(tabJson);
			} catch(ex) {
				console.error(ex);
				alert("탭정보 데이터가 유효하지 않습니다.");
			}
		}

		function renderPreviewByJson(tabs) {
			const $tabSection = $("#tabSection");
			const $tabButtonList = $tabSection.find("#tabs ul");
			$tabButtonList.empty();

			$tabSection.find(".tab_content").remove();
			for (const idx in tabs) {
				renderTabBtn(tabs[idx]);
				renderTabContent(tabs[idx]);
				if (idx === "0") {
					activeTabBtn(tabs[idx].tabId);
					activeTabContent(tabs[idx].tabId);
				}
			}
		}

		/**
		 * 탭 버튼 리스트 영역 rendering
		 * @param tabInfo {object} 탭 정보
		 */
		function renderTabBtn(tabInfo) {
			const $tabButtonList = $("#tabSection #tabs ul");

			const html = getTabButtonHtml(tabInfo.tabId);
			$tabButtonList.append(html);
			const $last = $tabButtonList.children().last();
			$last.find(".tab").text(tabInfo.tabNm);
			$last.data("tabInfo", tabInfo);

			addTabBtnEvent($last);
		}

		function getTabButtonHtml(tabId) {
			return `<li><button class="tab" data-tabId="${'${tabId}'}"></button></li>`;
		}

		function addTabBtnEvent($el) {
			$el.on("click", function () {
				const $tabs = $(this).closest("#tabs");

				$tabs.find(".tab.active").removeClass("active");
				$(this).find(".tab").addClass("active");

				const tabInfo = $(this).data("tabInfo");
				$tabs.siblings(".tab_content.active").removeClass("active");
				$tabs.siblings(".tab_content#tab" + tabInfo.tabId).addClass("active");
			})
		}

		async function renderTabContent(tabInfo) {
			const $tabSection = $("#tabSection");
			const html = getTabContentHtml(tabInfo.tabId);
			$tabSection.append(html);
			await initTabContent(tabInfo);
		}

		function getTabContentHtml(tabId) {
			if (tabId === "1") {
				return `<div class="tab_content hr_tab_content scroll-y" id="tab${'${tabId}'}"></div>`;
			} else {
				return `<div class="tab_content" id="tab${'${tabId}'}"></div>`;
			}
		}

		/**
		 * Tab 컨텐츠 부분 생성
		 * @param tabInfo
		 * @returns {Promise<void>}
		 */
		async function initTabContent(tabInfo) {
			const $tabContent = $("#tab" + tabInfo.tabId);
			$tabContent.empty();
			// 각 탭의 행마다 열의 수를 기록
			let maxColInfo = {};

			for (const template of tabInfo.template) {
				if (template.showYn !== "Y") continue;

				if (!maxColInfo[template.rowSeq]) {
					maxColInfo[template.rowSeq] =
							Array.from(tabInfo.template)
									.filter(obj => obj.showYn === "Y" && obj.rowSeq === template.rowSeq)
									.length;
					const rowHtml = getRowHtml(tabInfo.tabId, maxColInfo[template.rowSeq]);
					$tabContent.append(rowHtml);
				}

				const $last = $tabContent.children().last();
				await renderSection(template.templateId, $last, true);
			}
		}

		function getRowHtml(tabId, maxColSeq) {
			if (tabId === "1") {
				return `<div class="d-grid grid-cols-${'${maxColSeq}'} gap-16 mb-16"></div>`;
			} else {
				return `<div class="d-grid grid-cols-${'${maxColSeq}'} gap-16 hr_tab_content inner_scroll"></div>`;
			}
		}

		function activeTabBtn(tabId) {
			const $tabButtonList = $("#tabSection #tabs ul");
			$tabButtonList.find(".tab.active").removeClass("active");
			$tabButtonList.find(".tab[data-tabId=" + tabId + "]").addClass("active");
		}

		function activeTabContent(tabId) {
			const $tabContents = $("#tabSection>.tab_content");
			$tabContents.filter(".active").removeClass("active");
			$tabContents.filter("#tab" + tabId).addClass("active");
		}

		function addBtnEvent() {
			$("#btnReRender").on("click", function() {
				renderPreview($("#tabInfoJson").val());
			});

			$("#btnSearch").on("click", async function() {
				const text = await getTabInfoJson();
				$("#tabInfoJson").val(text);
				renderPreview(text);
			});

			$("#btnSave").on("click", function() {
				if (isValidSave())
					saveTabInfoJson();
			});

			$("#btnGetDefault").on("click", function() {
				btnGetDefault();
			});
		}

		async function saveTabInfoJson() {
			const data = await callFetch("${ctx}/PsnalBasicUserConfig.do?cmd=savePsnalBasicUserConfig", $("#sheetForm").serialize());
			if (data == null || data.isError) {
				if (data != null && data.errMsg) alert(data.errMsg);
				else alert("데이터 저장 시 알 수 없는 오류가 발생하였습니다.");
				return;
			}

			if (data && data.msg) {
				alert(data.msg);
				return;
			}

			const text = await getTabInfoJson();
			$("#tabInfoJson").val(text);
			renderPreview(text);
		}

		function isValidSave() {
			let json = [];
			try {
				json = JSON.parse($("#tabInfoJson").val());
			} catch(ex) {
				alert("유효하지 않은 JSON 형태의 데이터입니다.");
				return false;
			}

			const isInValid1 = !Array.isArray(json);
			if (isInValid1) {
				alert("탭 정보는 배열이어야 합니다.");
				return false;
			}

			const isInvalid2 = Array.from(json).filter(obj => !("tabId" in obj) || !("tabNm" in obj) || !("seq" in obj) || !("template" in obj)).length > 0;
			if (isInvalid2) {
				alert("유효하지 않은 탭 정보가 존재합니다. 탭 정보에는 tabId, tabNm, seq, template 이 포함되어야 합니다.");
				return false;
			}

			const isInvalid3 = Array.from(json)
					.filter(obj => !Array.isArray(obj.template)).length > 0;
			if (isInvalid3) {
				alert("template은 배열이어야 합니다.");
				return false;
			}

			const isInvalid4 = Array.from(json)
					.filter(obj => Array.from(obj.template).filter(obj2 => !("rowSeq" in obj2) || !("colSeq" in obj2) || !("templateId" in obj2) || !("showYn" in obj2)).length > 0).length > 0;
			if (isInvalid4) {
				alert("유효하지 않은 template 정보가 존재합니다. template 에는 rowSeq, colSeq, templateId, showYn 이 포함되어야 합니다.");
				return false;
			}

			const templateIdList = Array.from($("#templateIds a")).map(obj => { return $(obj).attr("data-code"); });
			let invalidTemplateIds = [];
			Array.from(json)
					.forEach(obj => {
						Array.from(obj.template)
								.forEach(obj2 => {
									if (!templateIdList.includes(obj2.templateId))
										invalidTemplateIds.push(obj2.templateId);
								})
					});
			const isInvalid5 = invalidTemplateIds.length > 0;
			if (isInvalid5) {
				alert("유효하지 않은 템플릿이 추가되었습니다.\n유효하지 않은 템플릿ID: " + invalidTemplateIds.join(", "));
				return false;
			}

			return true;
		}

		function btnGetDefault() {
			$("#tabInfoJson").val(defaultTemplate);
		}
	</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<table class="sheet_main">
			<colgroup>
				<col width="35%">
				<col width="1%">
				<col width="64%">
			</colgroup>
			<tbody>
				<tr>
					<td>
						<div class="explain">
							<div class="title">※ 도움말</div>
							<div class="txt">
								<ul>
									<li>아래 템플릿 버튼을 클릭하면 탭 정보 JSON에 템플릿의 코드가 추가됩니다.<br/><span id="templateIds"></span></li>
								</ul>
							</div>
						</div>
						<div class="sheet_title">
							<ul>
								<li class="txt">탭정보</li>
								<li class="btn">
									<a id="btnGetDefault" class="btn outline_gray authR">예시템플릿가져오기</a>
									<a id="btnReRender" class="btn filled authR">화면재조회</a>
									<a id="btnSearch" class="btn dark authR">조회</a>
									<a id="btnSave" class="btn filled authA">저장</a>
								</li>
							</ul>
						</div>
						<div class="ux_wrapper">
							<form id="sheetForm" name="sheetForm" >
								<textarea id="tabInfoJson" name="tabInfoJson" style="height: 600px;"></textarea>
							</form>
						</div>
					</td>
					<td></td>
					<td>
						<div id="preview">
							<div class="ux_wrapper bg_surface_bright hr_background">
								<div class="hr_top_bg">
									<svg width="100%" height="100" viewBox="0 0 1658 100" fill="none" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMid slice">
										<g clip-path="url(#clip0_222_24719)">
											<rect width="1658" height="100" class="bg-fill"/>
											<rect x="-809" y="-862.543" width="1190" height="1611.61" rx="595" transform="rotate(-45 -809 -862.543)" class="shape-fill-1"/>
											<rect x="-12.7715" y="191.229" width="1385.93" height="2123.83" rx="692.965" transform="rotate(-45 -12.7715 191.229)" class="shape-fill-2"/>
											<path fill-rule="evenodd" clip-rule="evenodd" d="M927.962 -520.393C917.838 -383.108 860.287 -248.665 755.311 -143.689C628.525 -16.9023 458.755 40.7041 292.909 29.1302C319.492 -98.359 382.265 -219.808 481.228 -318.772C605.529 -443.072 765.302 -510.279 927.962 -520.393Z" class="shape-fill-3"/>
										</g>
										<defs>
											<clipPath id="clip0_222_24719">
												<rect width="1658" height="100" fill="white"/>
											</clipPath>
										</defs>
									</svg>
								</div>
								<div class="contents pa-0">
									<div class="card bg-white rounded-16 pa-24-40 d-flex justify-between align-center mb-16 mt-50" id="empHeader">
										<div class="profile_wrap pa-0">
											<div class="avatar size-48">
												<img src="/EmpPhotoOut.do?enterCd=&searchKeyword=&t=" class="size-48">
											</div>
											<div class="info">
												<div>
													<div class="d-flex align-center gap-8">
														<span class="txt_title_xs_sb">홍길동</span>
														<span class="chip sm">재직</span>
													</div>
												</div>
												<div class="txt_body_sm txt_tertiary">
													<span>인사팀</span>
													<span class="txt_14 txt_gray">|</span>
													<span>대리</span>
													<span class="txt_14 txt_gray">|</span>
													<span>010-0000-0000</span>
													<span class="txt_14 txt_gray">|</span>
													<span>gildong@text.com</span>
												</div>
											</div>
										</div>
										<div>
											<button class="btn outline">
												<i class="mdi-ico">settings</i>
												개인정보변경
											</button>
										</div>
									</div>
									<div id="tabSection">
										<div class="tab_container simple ma-auto mb-8" id="tabs">
											<ul>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>
