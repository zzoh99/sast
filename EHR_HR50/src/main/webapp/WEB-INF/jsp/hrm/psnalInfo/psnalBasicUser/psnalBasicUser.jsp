<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>인사기본(임직원공통)</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <%-- ibSheet file 업로드용 --%>
    <%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
    <%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicUser/psnalBasicUserTemplates.jsp"%>

	<script type="text/javascript">
		$(function() {
			init();
		});

		function init() {
            initHeaders();
            initTabs();
		}

        async function initHeaders() {
            const userInfo = await getUserInfo();
            if (userInfo == null) return;

            setHeaderData(userInfo);
            initHeaderEvent();
        }

        function setHeaderData(info) {
            const $empHeader = $("#empHeader");
            $empHeader.find("#userFace").attr("src","/EmpPhotoOut.do?enterCd=" + info.enterCd + "&searchKeyword=" + info.sabun+"&t=" + (new Date()).getTime());

            $empHeader.find('#ehEmpName').text(getValue(info.empName));
            $empHeader.find('#ehStatusNm').text(getValue(info.statusNm));
            $empHeader.find('#ehStatusNm').addClass(getStatusClassName(info.statusCd));
            $empHeader.find('#ehOrgNm').text(getValue(info.orgNm));
            $empHeader.find('#ehJikweeNm').text(getValue(info.jikweeNm));
            $empHeader.find('#ehCellPhone').text(getValue(info.cellPhone));
            $empHeader.find('#ehEmail').text(getValue(info.email));
        }

        function getStatusClassName(statusCd) {
            if (statusCd === "CA") {
                return "yellow";
            } else if (statusCd === "RA") {
                return "red";
            } else if (statusCd === "AA") {
                return "green";
            } else
                return "";
        }

        function initHeaderEvent() {
            $("#btnModifyPersonalInfo").on("click", function(e) {
                window.location.href = "/HrmApplyUser.do?cmd=viewHrmApplyTypeUser";
            });
        }


        /**
         * 탭 initialize
         * @returns {Promise<void>}
         */
        async function initTabs() {
            let tabs = await getTabs();
            try {
                if (tabs != null && tabs.jsonText != null && tabs.jsonText !== "") {
                    tabs = JSON.parse(tabs.jsonText);
                } else {
                    tabs = JSON.parse(defaultTemplate);
                }
            } catch(ex) {
                console.error(ex);
                alert("탭 정보 생성 시 오류가 발생하였습니다.");
                return;
            }

            renderTabs(tabs);
        }

        function clearAll() {
            $("#tabs ul").empty();
            $(".tab_content").empty();
        }

        /**
         * 탭 rendering
         * @param tabs
         * @param activeTabId
         */
        function renderTabs(tabs) {
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
            return `<li><button class="tab" data-tabid="${'${tabId}'}"></button></li>`;
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

        function activeTabBtn(tabId) {
            const $tabButtonList = $("#tabSection #tabs ul");
            $tabButtonList.find(".tab.active").removeClass("active");
            $tabButtonList.find(".tab[data-tabid=" + tabId + "]").addClass("active");
        }

        function activeTabContent(tabId) {
            const $tabContents = $("#tabSection>.tab_content");
            $tabContents.filter(".active").removeClass("active");
            $tabContents.filter("#tab" + tabId).addClass("active");
        }

        /**
         * Tab 컨텐츠 부분 생성
         * @param tabInfo
         * @returns {Promise<void>}
         */
        async function initTabContent(tabInfo) {
            const $tabContent = $("#tab" + tabInfo.tabId);
            $tabContent.empty();
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
                await renderSection(template.templateId, $last);
            }
        }

        function getRowHtml(tabId, maxColSeq) {
            if (tabId === "1") {
                return `<div class="d-grid grid-cols-${'${maxColSeq}'} gap-16 mb-16"></div>`;
            } else {
                return `<div class="d-grid grid-cols-${'${maxColSeq}'} gap-16 hr_tab_content inner_scroll"></div>`;
            }
        }

        /**
         * 파일첨부/다운로드 팝업. 각 오브젝트에서 사용.
         * @param $this
         * @param fileSeq
         */
        function openFileDownloadLayer($this, fileSeq) {
            if ($this.find("form").length === 0) {
                const $form = $("<form/>");
                $this.append($form);
            }

            const $form2 = $this.find("form");
            initIbFileUpload($form2);

            let layerModal = new window.top.document.LayerModal({
                id : 'fileMgrLayer'
                , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=contact&authPg=R' // url 변경
                , parameters : {
                    fileSeq : fileSeq,
                    fileInfo: getFileList(fileSeq) // 파일 목록 동기화 처리를 위함
                }
                , width : 740
                , height : 420
                , title : '파일 다운로드'
                , trigger :[
                    {
                        name : 'fileMgrTrigger'
                        , callback : function(result){
                        }
                    }
                ]
            });
            layerModal.show();
        }

        function getValue(val) {
            return (val == null || val === "") ? "-" : val;
        }

        async function getUserInfo() {
            const response = await fetch("/PsnalBasicUser.do?cmd=getPsnalBasicUserEmployeeHeader", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                },
                body: ""
            });
            const json = await response.json();
            if(json.Message != null && json.Message) {
                alert(json.Message);
                return null;
            }
            return json.map;
        }

        async function getTabs() {
            const data = await callFetch("${ctx}/PsnalBasicUser.do?cmd=getPsnalBasicUserTabs", "");
            if (data == null || data.isError) {
                if (data && data.errMsg) alert(data.errMsg);
                else alert("알 수 없는 오류가 발생하였습니다.");
                return null;
            }

            if (data && data.msg) {
                alert(data.msg);
                return null;
            }
            return data.map;
        }
	</script>
</head>
<body>
	<div class="wrapper">
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
                            <img src="" class="size-48" id="userFace">
                        </div>
                        <div class="info">
                            <div>
                                <div class="d-flex align-center gap-8">
                                    <span class="txt_title_xs_sb" id="ehEmpName">-</span>
                                    <span class="chip sm" id="ehStatusNm">-</span>
                                </div>
                            </div>
                            <div class="txt_body_sm txt_tertiary">
                                <span id="ehOrgNm">-</span>
                                <span class="txt_14 txt_gray">|</span>
                                <span id="ehJikweeNm">-</span>
                                <span class="txt_14 txt_gray">|</span>
                                <span id="ehCellPhone">-</span>
                                <span class="txt_14 txt_gray">|</span>
                                <span id="ehEmail">-</span>
                            </div>
                        </div>
                    </div>
                    <div>
                        <button class="btn outline" id="btnModifyPersonalInfo">
                            <i class="mdi-ico">settings</i>
                            개인정보변경
                        </button>
                    </div>
                </div>
                <div id="tabSection">
                    <div class="tab_container simple ma-auto mb-8" id="tabs">
                        <ul>
                            <!-- <li>
                                <button class="tab active" data-tab="tab1">
                                    기본
                                </button>
                            </li>
                            <li>
                                <button class="tab" data-tab="tab2">
                                    발령/상벌
                                </button>
                            </li>
                            <li>
                                <button class="tab" data-tab="tab3">
                                    교육/자격
                                </button>
                            </li>
                            <li>
                                <button class="tab" data-tab="tab4">
                                    경력/학력
                                </button>
                            </li>
                            <li>
                                <button class="tab" data-tab="tab5">
                                    어학/해외연수
                                </button>
                            </li>
                            <li>
                                <button class="tab" data-tab="tab6">
                                    병역/보훈/장애
                                </button>
                            </li> -->
                        </ul>
                    </div>
                    <!-- <div class="tab_content active hr_tab_content scroll-y" id="tab1">
                        <div class="d-grid grid-cols-2 gap-16 mb-16">
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="title_label_list">
                                    <div class="title d-flex gap-8">
                                        <i class="icon profile_person size-16"></i>
                                        <p class="txt_title_xs sb txt_left">개인정보</p>
                                    </div>
                                    <div class="label_list gap-12">
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">영문성명</span>
                                            <span class="txt_body_sm sb">Kim isu</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">한자성명</span>
                                            <span class="txt_body_sm sb">-</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">주민등록번호</span>
                                            <span class="txt_body_sm sb">903456-1987654</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">생년월일</span>
                                            <span class="txt_body_sm sb">90년 3월 24일 / 36세</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">재직상태</span>
                                            <span class="txt_body_sm sb">재직</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="title_label_list">
                                    <div class="title d-flex gap-8">
                                        <i class="icon chat size-16"></i>
                                        <p class="txt_title_xs sb txt_left">연락처</p>
                                    </div>
                                    <div class="label_list gap-12 d-grid grid-cols-2  gap-x-40">
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">사무실 전화</span>
                                            <span class="txt_body_sm sb">02-123-4567</span>
                                        </div>
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">휴대전화</span>
                                            <span class="txt_body_sm sb">010-1234-5678</span>
                                        </div>
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">사내 이메일</span>
                                            <span class="txt_body_sm sb">kimisu@isu.co.kr</span>
                                        </div>
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">팩스번호</span>
                                            <span class="txt_body_sm sb">02-123-4567</span>
                                        </div>
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">비상연락망</span>
                                            <span class="txt_body_sm sb">010-2345-6789</span>
                                        </div>
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">사외 이메일</span>
                                            <span class="txt_body_sm sb">isususu@isu.co.kr</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="title_label_list">
                                    <div class="title d-flex gap-8">
                                        <i class="icon script size-16"></i>
                                        <p class="txt_title_xs sb txt_left">근무정보</p>
                                    </div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-80">
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">본부</span>
                                            <span class="txt_body_sm sb">솔루션사업본부</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">근속기간</span>
                                            <span class="txt_body_sm sb">5년 2개월</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">부서</span>
                                            <span class="txt_body_sm sb">마켓팅 기획팀</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">그룹입사일</span>
                                            <span class="txt_body_sm sb">2015-03-02</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">직위</span>
                                            <span class="txt_body_sm sb">대리</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">소속입사일</span>
                                            <span class="txt_body_sm sb">2015-03-02</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">직책</span>
                                            <span class="txt_body_sm sb">팀원</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">고용구분</span>
                                            <span class="txt_body_sm sb">공채</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">사원구분</span>
                                            <span class="txt_body_sm sb">사무직</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">퇴직일</span>
                                            <span class="txt_body_sm sb">-</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">직군</span>
                                            <span class="txt_body_sm sb">기술직</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">부서배치일</span>
                                            <span class="txt_body_sm sb">2015-03-02</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">직무코드</span>
                                            <span class="txt_body_sm sb">S1022126</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">직책승격일</span>
                                            <span class="txt_body_sm sb">2015-03-02</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="mb-16 d-flex gap-8">
                                    <i class="icon photo_spark size-16"></i>
                                    <p class="txt_title_xs sb txt_left">주소</p>
                                </div>
                                <div class="d-flex flex-col gap-12">
                                    <div class="card rounded-12 pa-16-24 d-flex justify-between align-center">
                                        <div class="d-flex gap-16 align-center">
                                            <div class="w-75">
                                                <span class="chip sm">주민등록지</span>
                                            </div>
                                            <div>
                                                <p class="txt_body_sm sb">서울특별시 서초구 사평대로60 4~7층 12345</p>
                                                <p class="txt_body_sm mt-4">비고 -</p>
                                            </div>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="card rounded-12 pa-16-24 d-flex justify-between align-center">
                                        <div class="d-flex gap-16 align-center">
                                            <div class="w-75">
                                                <span class="chip sm">본적</span>
                                            </div>
                                            <div>
                                                <p class="txt_body_sm sb">서울특별시 서초구 사평대로60 4~7층 12345</p>
                                                <p class="txt_body_sm mt-4">비고 -</p>
                                            </div>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="card rounded-12 pa-16-24 d-flex justify-between align-center">
                                        <div class="d-flex gap-16 align-center">
                                            <div class="w-75">
                                                <span class="chip sm">현주소지</span>
                                            </div>
                                            <div>
                                                <p class="txt_body_sm sb">서울특별시 서초구 사평대로60 4~7층 12345</p>
                                                <p class="txt_body_sm mt-4">비고 -</p>
                                            </div>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card rounded-16 pa-24 bg-white mb-16">
                            <div class="d-flex justify-between align-center mb-12">
                                <div class="d-flex gap-8">
                                    <i class="icon hobby size-16"></i>
                                    <p class="txt_title_xs sb txt_left">가족</p>
                                </div>
                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                            </div>
                            <div class="d-grid grid-cols-2 gap-16">
                                <div class="card rounded-12 pa-16-20">
                                    <div class="d-flex gap-16 align-center justify-between mb-16">
                                        <div class="d-flex gap-10 align-center">
                                            <span class="chip sm green">처</span>
                                            <div class="txt_body_sm sb">
                                                <span>김혜희</span>
                                                <span>1993-03-12</span>
                                                <span>여</span>
                                            </div>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-80 mb-12">
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">주민등록번호</span>
                                                <span class="txt_body_sm sb">880101-123456</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">동거여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">건강보험피부양자등록여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">학력</span>
                                                <span class="txt_body_sm sb">대학교 졸업</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직장(학교)명</span>
                                                <span class="txt_body_sm sb">이수시스템</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직위(학년)</span>
                                                <span class="txt_body_sm sb">차장</span>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="line gray mb-12"></div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-40">
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">-</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="card rounded-12 pa-16-20">
                                    <div class="d-flex gap-16 align-center justify-between mb-16">
                                        <div class="d-flex gap-10 align-center">
                                            <span class="chip sm green">처</span>
                                            <div class="txt_body_sm sb">
                                                <span>김혜희</span>
                                                <span>1993-03-12</span>
                                                <span>여</span>
                                            </div>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-80 mb-12">
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">주민등록번호</span>
                                                <span class="txt_body_sm sb">880101-123456</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">동거여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">건강보험피부양자등록여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">학력</span>
                                                <span class="txt_body_sm sb">대학교 졸업</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직장(학교)명</span>
                                                <span class="txt_body_sm sb">이수시스템</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직위(학년)</span>
                                                <span class="txt_body_sm sb">차장</span>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="line gray mb-12"></div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-40">
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">-</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="card rounded-12 pa-16-20">
                                    <div class="d-flex gap-16 align-center justify-between mb-16">
                                        <div class="d-flex gap-10 align-center">
                                            <span class="chip sm green">처</span>
                                            <div class="txt_body_sm sb">
                                                <span>김혜희</span>
                                                <span>1993-03-12</span>
                                                <span>여</span>
                                            </div>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-80 mb-12">
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">주민등록번호</span>
                                                <span class="txt_body_sm sb">880101-123456</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">동거여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">건강보험피부양자등록여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">학력</span>
                                                <span class="txt_body_sm sb">대학교 졸업</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직장(학교)명</span>
                                                <span class="txt_body_sm sb">이수시스템</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직위(학년)</span>
                                                <span class="txt_body_sm sb">차장</span>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="line gray mb-12"></div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-40">
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">-</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="card rounded-12 pa-16-20">
                                    <div class="d-flex gap-16 align-center justify-between mb-16">
                                        <div class="d-flex gap-10 align-center">
                                            <span class="chip sm green">처</span>
                                            <div class="txt_body_sm sb">
                                                <span>김혜희</span>
                                                <span>1993-03-12</span>
                                                <span>여</span>
                                            </div>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-80 mb-12">
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">주민등록번호</span>
                                                <span class="txt_body_sm sb">880101-123456</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">동거여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">건강보험피부양자등록여부</span>
                                                <span class="txt_body_sm sb">Y</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">학력</span>
                                                <span class="txt_body_sm sb">대학교 졸업</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직장(학교)명</span>
                                                <span class="txt_body_sm sb">이수시스템</span>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">직위(학년)</span>
                                                <span class="txt_body_sm sb">차장</span>
                                            </div>
                                        </div>

                                    </div>
                                    <div class="line gray mb-12"></div>
                                    <div class="label_list gap-12 d-grid grid-cols-2 gap-x-40">
                                        <div class="d-flex gap-8">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">-</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card rounded-16 pa-24 bg-white mb-40">
                            <div class="d-flex justify-between align-center mb-12">
                                <div class="d-flex gap-8">
                                    <i class="icon cyborg size-16"></i>
                                    <p class="txt_title_xs sb txt_left">보증보험</p>
                                </div>
                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                            </div>
                            <div class="d-flex flex-col gap-12">
                                <div class="card rounded-12 pa-16-20">
                                    <div class="d-flex gap-16 align-center justify-between mb-8">
                                        <div>
                                            <p class="txt_title_xs sb">
                                                한국보증보험
                                                <span class="txt_body_sm txt_tertiary ml-8">2022-12-01~2023-07-31</span>
                                            </p>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="line gray mb-12"></div>
                                    <div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">증권번호</span>
                                                <span class="sb">2020456</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">통화단위</span>
                                                <span class="sb">KRW</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">보증금액</span>
                                                <span class="sb">10,000,000</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">공제년월</span>
                                                <span class="sb">2024-01</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex gap-8">
                                                <span class="txt_body_sm txt_secondary">비고</span>
                                                <span class="txt_body_sm sb">보증 비고작성란</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card rounded-12 pa-16-20">
                                    <div class="d-flex gap-16 align-center justify-between mb-8">
                                        <div>
                                            <p class="txt_title_xs sb">
                                                한국보증보험
                                                <span class="txt_body_sm txt_tertiary ml-8">2022-12-01~2023-07-31</span>
                                            </p>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="line gray mb-12"></div>
                                    <div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">증권번호</span>
                                                <span class="sb">2020456</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">통화단위</span>
                                                <span class="sb">KRW</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">보증금액</span>
                                                <span class="sb">10,000,000</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">공제년월</span>
                                                <span class="sb">2024-01</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex gap-8">
                                                <span class="txt_body_sm txt_secondary">비고</span>
                                                <span class="txt_body_sm sb">보증 비고작성란</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card rounded-12 pa-16-20">
                                    <div class="d-flex gap-16 align-center justify-between mb-8">
                                        <div>
                                            <p class="txt_title_xs sb">
                                                한국보증보험
                                                <span class="txt_body_sm txt_tertiary ml-8">2022-12-01~2023-07-31</span>
                                            </p>
                                        </div>
                                        <div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="line gray mb-12"></div>
                                    <div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">증권번호</span>
                                                <span class="sb">2020456</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">통화단위</span>
                                                <span class="sb">KRW</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">보증금액</span>
                                                <span class="sb">10,000,000</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">공제년월</span>
                                                <span class="sb">2024-01</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex gap-8">
                                                <span class="txt_body_sm txt_secondary">비고</span>
                                                <span class="txt_body_sm sb">보증 비고작성란</span>
                                            </div>
                                        </div>
                                    </div>
                                </div> -->
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                    <i class="icon no_data"></i>
                                     <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                </div> -->
                            <!-- </div>
                        </div>
                    </div>
                    <div class="tab_content" id="tab2">
                        <div class="d-grid grid-cols-2 gap-16 hr_tab_content inner_scroll">
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon cyborg size-16"></i>
                                        <p class="txt_title_xs sb txt_left">발령</p>
                                    </div>
                                    <div>
                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18 dropdown_list_btn">
                                            filter_list
                                            <div class="dropdown_list sm w-70">
                                                <div class="dropdown_list_item">
                                                    <p>전체</p>
                                                </div>
                                                <div class="dropdown_list_item">
                                                    <p>주요발령</p>
                                                </div>
                                            </div>
                                        </i>
                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                    </div>
                                </div>
                                <div class="timeline">
                                    <div class="timeline-item">
                                        <div class="timeline-content d-flex gap-4 align-center mb-12">
                                            <span class="txt_body_sm txt_tertiary mr-8">2025-03-24</span>
                                            <span class="txt_title_xs sb">직무변경</span>
                                            <span class="chip sm blue">직무변경</span>
                                        </div>
                                        <div class="card rounded-12 pa-16-20">
                                            <div class="label_list gap-8 d-grid grid-cols-2  gap-x-40">
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">재직상태</span>
                                                    <span class="txt_body_sm sb">재직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">소속</span>
                                                    <span class="txt_body_sm sb">영업관리팀</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직책</span>
                                                    <span class="txt_body_sm sb">팀장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직위</span>
                                                    <span class="txt_body_sm sb">부장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직급</span>
                                                    <span class="txt_body_sm sb">수석연구원</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직무</span>
                                                    <span class="txt_body_sm sb">영업기획</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직군</span>
                                                    <span class="txt_body_sm sb">영업직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">사원구분</span>
                                                    <span class="txt_body_sm sb">사무직</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-content d-flex gap-4 align-center mb-12">
                                            <span class="txt_body_sm txt_tertiary mr-8">2025-03-24</span>
                                            <span class="txt_title_xs sb">직무변경</span>
                                            <span class="chip sm green">직무변경</span>
                                        </div>
                                        <div class="card rounded-12 pa-16-20">
                                            <div class="label_list gap-8 d-grid grid-cols-2  gap-x-40">
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">재직상태</span>
                                                    <span class="txt_body_sm sb">재직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">소속</span>
                                                    <span class="txt_body_sm sb">영업관리팀</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직책</span>
                                                    <span class="txt_body_sm sb">팀장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직위</span>
                                                    <span class="txt_body_sm sb">부장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직급</span>
                                                    <span class="txt_body_sm sb">수석연구원</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직무</span>
                                                    <span class="txt_body_sm sb">영업기획</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직군</span>
                                                    <span class="txt_body_sm sb">영업직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">사원구분</span>
                                                    <span class="txt_body_sm sb">사무직</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-content d-flex gap-4 align-center mb-12">
                                            <span class="txt_body_sm txt_tertiary mr-8">2025-03-24</span>
                                            <span class="txt_title_xs sb">직무변경</span>
                                            <span class="chip sm red">직무변경</span>
                                        </div>
                                        <div class="card rounded-12 pa-16-20">
                                            <div class="label_list gap-8 d-grid grid-cols-2  gap-x-40">
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">재직상태</span>
                                                    <span class="txt_body_sm sb">재직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">소속</span>
                                                    <span class="txt_body_sm sb">영업관리팀</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직책</span>
                                                    <span class="txt_body_sm sb">팀장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직위</span>
                                                    <span class="txt_body_sm sb">부장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직급</span>
                                                    <span class="txt_body_sm sb">수석연구원</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직무</span>
                                                    <span class="txt_body_sm sb">영업기획</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직군</span>
                                                    <span class="txt_body_sm sb">영업직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">사원구분</span>
                                                    <span class="txt_body_sm sb">사무직</span>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="timeline-item">
                                        <div class="timeline-content d-flex gap-4 align-center mb-12">
                                            <span class="txt_body_sm txt_tertiary mr-8">2025-03-24</span>
                                            <span class="txt_title_xs sb">직무변경</span>
                                            <span class="chip sm scarlet">직무변경</span>
                                        </div>
                                        <div class="card rounded-12 pa-16-20">
                                            <div class="label_list gap-8 d-grid grid-cols-2  gap-x-40">
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">재직상태</span>
                                                    <span class="txt_body_sm sb">재직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">소속</span>
                                                    <span class="txt_body_sm sb">영업관리팀</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직책</span>
                                                    <span class="txt_body_sm sb">팀장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직위</span>
                                                    <span class="txt_body_sm sb">부장</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직급</span>
                                                    <span class="txt_body_sm sb">수석연구원</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직무</span>
                                                    <span class="txt_body_sm sb">영업기획</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">직군</span>
                                                    <span class="txt_body_sm sb">영업직</span>
                                                </div>
                                                <div class="d-flex gap-8">
                                                    <span class="txt_body_sm txt_secondary">사원구분</span>
                                                    <span class="txt_body_sm sb">사무직</span>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon photo_spark size-16"></i>
                                        <p class="txt_title_xs sb txt_left">상벌</p>
                                    </div>
                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                </div>
                                <div class="tab_container w-164 ma-auto mb-8">
                                    <ul>
                                        <li>
                                            <button class="tab active" data-tab="tab1">
                                                포상사항
                                            </button>
                                        </li>
                                        <li>
                                            <button class="tab" data-tab="tab2">
                                                징계사항
                                            </button>
                                        </li>
                                    </ul>
                                </div>
                                <div class="tab_content active" id="tab1">
                                    <div class="d-flex flex-col gap-12"> -->
                                        <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                            <i class="icon no_data"></i>
                                             <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                        </div> -->
                                        <!-- <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        10년 근속포상
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        10년 근속포상
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        10년 근속포상
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        10년 근속포상
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab_content" id="tab2">
                                    <div class="d-flex flex-col gap-12"> -->
                                        <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                            <i class="icon no_data"></i>
                                             <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                        </div> -->
                                        <!-- <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        징계사항
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        10년 근속포상
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        10년 근속포상
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        10년 근속포상
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31</span>
                                                    </p>
                                                </div>
                                                <div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="sb">대내</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">수석연구원</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">팀장</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="sb">사무직</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상기관</span>
                                                        <span class="sb">이수시스템</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상번호</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상사유</span>
                                                        <span class="sb">장기근속</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab_content" id="tab3">
                        <div class="d-grid grid-cols-2 gap-16 hr_tab_content inner_scroll">
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon rocket size-16"></i>
                                        <p class="txt_title_xs sb txt_left">교육</p>
                                    </div>
                                    <div>
                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18 all_accordion_handle">unfold_more</i>
                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                    </div>
                                </div>
                                <div class="edu_list">
                                    <div>
                                        <div class="d-flex flex-col gap-12">
                                            <div class="accordion card rounded-16 pa-16-20 open">
                                                <div class="accordion_header d-flex gap-16 align-center justify-between">
                                                    <div>
                                                        <p class="txt_body_sm sb">
                                                            smart TPM 기법, 자주보전 1등 기업의 노하우를 찾아라
                                                        </p>
                                                    </div>
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="txt_body_sm txt_tertiary txt_nowrap">2025-01-01~2025-01-01</span>
                                                        <span class="chip sm blue">특별교육</span>
                                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6">expand_more</i>
                                                    </div>
                                                </div>
                                                <div class="accordion_item">
                                                    <div class="line gray mb-12"></div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">사내/외</span>
                                                            <span class="sb">사외</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육분류</span>
                                                            <span class="sb">직무 관련 교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">시행방법</span>
                                                            <span class="sb">필수교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육비</span>
                                                            <span class="sb">-</span>
                                                        </div>
                                                    </div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">고용보험적용여부</span>
                                                            <span class="sb">NO</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육수료구분</span>
                                                            <span class="sb">영업직</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육기관</span>
                                                            <span class="sb">휴넷</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="accordion card rounded-16 pa-16-20">
                                                <div class="accordion_header d-flex gap-16 align-center justify-between">
                                                    <div>
                                                        <p class="txt_body_sm sb">
                                                            smart TPM 기법, 자주보전 1등 기업의 노하우를 찾아라
                                                        </p>
                                                    </div>
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="txt_body_sm txt_tertiary txt_nowrap">2025-01-01~2025-01-01</span>
                                                        <span class="chip sm pink">특별교육</span>
                                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6">expand_more</i>
                                                    </div>
                                                </div>
                                                <div class="accordion_item">
                                                    <div class="line gray mb-12"></div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">사내/외</span>
                                                            <span class="sb">사외</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육분류</span>
                                                            <span class="sb">직무 관련 교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">시행방법</span>
                                                            <span class="sb">필수교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육비</span>
                                                            <span class="sb">-</span>
                                                        </div>
                                                    </div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">고용보험적용여부</span>
                                                            <span class="sb">NO</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육수료구분</span>
                                                            <span class="sb">영업직</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육기관</span>
                                                            <span class="sb">휴넷</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="accordion card rounded-16 pa-16-20">
                                                <div class="accordion_header d-flex gap-16 align-center justify-between">
                                                    <div>
                                                        <p class="txt_body_sm sb">
                                                            smart TPM 기법, 자주보전 1등 기업의 노하우를 찾아라
                                                        </p>
                                                    </div>
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="txt_body_sm txt_tertiary txt_nowrap">2025-01-01~2025-01-01</span>
                                                        <span class="chip sm green">특별교육</span>
                                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6">expand_more</i>
                                                    </div>
                                                </div>
                                                <div class="accordion_item">
                                                    <div class="line gray mb-12"></div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">사내/외</span>
                                                            <span class="sb">사외</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육분류</span>
                                                            <span class="sb">직무 관련 교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">시행방법</span>
                                                            <span class="sb">필수교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육비</span>
                                                            <span class="sb">-</span>
                                                        </div>
                                                    </div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">고용보험적용여부</span>
                                                            <span class="sb">NO</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육수료구분</span>
                                                            <span class="sb">영업직</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육기관</span>
                                                            <span class="sb">휴넷</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="accordion card rounded-16 pa-16-20">
                                                <div class="accordion_header d-flex gap-16 align-center justify-between">
                                                    <div>
                                                        <p class="txt_body_sm sb">
                                                            smart TPM 기법, 자주보전 1등 기업의 노하우를 찾아라
                                                        </p>
                                                    </div>
                                                    <div class="d-flex gap-8 align-center">
                                                        <span class="txt_body_sm txt_tertiary txt_nowrap">2025-01-01~2025-01-01</span>
                                                        <span class="chip sm blue">특별교육</span>
                                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6">expand_more</i>
                                                    </div>
                                                </div>
                                                <div class="accordion_item">
                                                    <div class="line gray mb-12"></div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">사내/외</span>
                                                            <span class="sb">사외</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육분류</span>
                                                            <span class="sb">직무 관련 교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">시행방법</span>
                                                            <span class="sb">필수교육</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육비</span>
                                                            <span class="sb">-</span>
                                                        </div>
                                                    </div>
                                                    <div class="label_text_group mb-8">
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">고용보험적용여부</span>
                                                            <span class="sb">NO</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육수료구분</span>
                                                            <span class="sb">영업직</span>
                                                        </div>
                                                        <div class="txt_body_sm">
                                                            <span class="txt_secondary">교육기관</span>
                                                            <span class="sb">휴넷</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="pagination">
                                        <button class="first"></button>
                                        <button class="prev"></button>
                                        <button class="active">1</button>
                                        <button>2</button>
                                        <button>3</button>
                                        <button>4</button>
                                        <button>5</button>
                                        <button class="next"></button>
                                        <button class="last"></button>
                                    </div>
                                </div>
                            </div>
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon cyborg size-16"></i>
                                        <p class="txt_title_xs sb txt_left">자격</p>
                                    </div>
                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                </div>
                                <div class="d-flex flex-col gap-12"> -->
                                    <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                        <i class="icon no_data"></i>
                                         <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                    </div> -->
                                    <!-- <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    1종투자상담사
                                                    <span class="chip sm blue ml-8">Expert</span>
                                                </p>
                                            </div>
                                            <div class="d-flex gap-16 align-center">
                                                <div class="d-flex gap-4 txt_body_sm">
                                                    <span class="txt_tertiary">취득일</span>
                                                    <span>2024-12-20</span>
                                                </div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_list gap-12 d-grid grid-cols-2  gap-x-40 mb-16">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">자격증번호</span>
                                                <span class="txt_body_sm sb">12345678</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">발급기관</span>
                                                <span class="txt_body_sm sb">한국Oracle</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">갱신일(교부일)</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">만료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급시작일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급종료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                        </div>
                                        <div class="line mb-16"></div>
                                        <div class="label_list">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">관련근거</span>
                                                <span class="txt_body_sm sb">자격증 보유여부 근거작성란</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    1종투자상담사
                                                    <span class="chip sm blue ml-8">Expert</span>
                                                </p>
                                            </div>
                                            <div class="d-flex gap-16 align-center">
                                                <div class="d-flex gap-4 txt_body_sm">
                                                    <span class="txt_tertiary">취득일</span>
                                                    <span>2024-12-20</span>
                                                </div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_list gap-12 d-grid grid-cols-2  gap-x-40 mb-16">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">자격증번호</span>
                                                <span class="txt_body_sm sb">12345678</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">발급기관</span>
                                                <span class="txt_body_sm sb">한국Oracle</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">갱신일(교부일)</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">만료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급시작일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급종료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                        </div>
                                        <div class="line mb-16"></div>
                                        <div class="label_list">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">관련근거</span>
                                                <span class="txt_body_sm sb">자격증 보유여부 근거작성란</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    1종투자상담사
                                                    <span class="chip sm blue ml-8">Expert</span>
                                                </p>
                                            </div>
                                            <div class="d-flex gap-16 align-center">
                                                <div class="d-flex gap-4 txt_body_sm">
                                                    <span class="txt_tertiary">취득일</span>
                                                    <span>2024-12-20</span>
                                                </div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_list gap-12 d-grid grid-cols-2  gap-x-40 mb-16">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">자격증번호</span>
                                                <span class="txt_body_sm sb">12345678</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">발급기관</span>
                                                <span class="txt_body_sm sb">한국Oracle</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">갱신일(교부일)</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">만료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급시작일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급종료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                        </div>
                                        <div class="line mb-16"></div>
                                        <div class="label_list">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">관련근거</span>
                                                <span class="txt_body_sm sb">자격증 보유여부 근거작성란</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    1종투자상담사
                                                    <span class="chip sm blue ml-8">Expert</span>
                                                </p>
                                            </div>
                                            <div class="d-flex gap-16 align-center">
                                                <div class="d-flex gap-4 txt_body_sm">
                                                    <span class="txt_tertiary">취득일</span>
                                                    <span>2024-12-20</span>
                                                </div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_list gap-12 d-grid grid-cols-2  gap-x-40 mb-16">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">자격증번호</span>
                                                <span class="txt_body_sm sb">12345678</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">발급기관</span>
                                                <span class="txt_body_sm sb">한국Oracle</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">갱신일(교부일)</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">만료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급시작일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">수당지급종료일</span>
                                                <span class="txt_body_sm sb">2024-12-20</span>
                                            </div>
                                        </div>
                                        <div class="line mb-16"></div>
                                        <div class="label_list">
                                            <div class="d-flex justify-between">
                                                <span class="txt_body_sm txt_secondary">관련근거</span>
                                                <span class="txt_body_sm sb">자격증 보유여부 근거작성란</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab_content" id="tab4">
                        <div class="d-grid grid-cols-2 gap-16 hr_tab_content inner_scroll">
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon cyborg size-16"></i>
                                        <p class="txt_title_xs sb txt_left">학력</p>
                                    </div>
                                    <div>
                                        <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                    </div>
                                </div>
                                <div>
                                    <div class="pa-16-20-8 bd-b">
                                        <div class="mb-8">
                                            <span class="chip sm scarlet">A-초등학교(국내)</span> -->
                                            <!-- <span class="chip sm tan">B-중학교(국내)</span>
                                            <span class="chip sm yellow">C-고등학교(국내)</span>
                                            <span class="chip sm purple">전문대학</span>
                                            <span class="chip sm green">E-대학교(국내)</span>
                                            <span class="chip sm blue">F-대학원(국내)</span>
                                            <span class="chip sm orange">F-대학원(박사)</span>
                                            <span class="chip sm red">편입</span>
                                            <span class="chip sm river">검정고시</span> -->
                                        <!-- </div>
                                        <div>
                                            <span class="txt_body_sm sb">서울대학교</span>
                                            <span class="txt_body_sm txt_tertiary">2023-07~2024-06</span>
                                        </div>
                                        <div class="label_text_group mt-4">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">전공</span>
                                                <span class="sb">국문과</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">복수전공</span>
                                                <span class="sb">사학과</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">편입</span>
                                                <span class="sb">N</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">최종학력여부</span>
                                                <span class="sb">Y</span>
                                            </div>
                                        </div>
                                        <div class="d-flex gap-8 align-center mt-8">
                                            <div class="label_text_group">
                                                <div class="txt_body_sm">
                                                    <span class="sb">졸업</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">서울</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">본교</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">주간</span>
                                                </div>
                                            </div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="pa-16-20-8 bd-b">
                                        <div class="mb-8">
                                            <span class="chip sm green">F-대학원(국내)</span>
                                        </div>
                                        <div>
                                            <span class="txt_body_sm sb">서울대학교</span>
                                            <span class="txt_body_sm txt_tertiary">2023-07~2024-06</span>
                                        </div>
                                        <div class="label_text_group mt-4">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">전공</span>
                                                <span class="sb">국문과</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">복수전공</span>
                                                <span class="sb">사학과</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">편입</span>
                                                <span class="sb">N</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">최종학력여부</span>
                                                <span class="sb">Y</span>
                                            </div>
                                        </div>
                                        <div class="d-flex gap-8 align-center mt-8">
                                            <div class="label_text_group">
                                                <div class="txt_body_sm">
                                                    <span class="sb">졸업</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">서울</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">본교</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">주간</span>
                                                </div>
                                            </div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="pa-16-20-8 bd-b">
                                        <div class="mb-8">
                                            <span class="chip sm yellow">F-대학원(국내)</span>
                                        </div>
                                        <div>
                                            <span class="txt_body_sm sb">백마고등학교</span>
                                            <span class="txt_body_sm txt_tertiary">2023-07~2024-06</span>
                                        </div>
                                        <div class="d-flex gap-8 align-center mt-8">
                                            <div class="label_text_group">
                                                <div class="txt_body_sm">
                                                    <span class="sb">졸업</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">서울</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">본교</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">주간</span>
                                                </div>
                                            </div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="pa-16-20-8 bd-b">
                                        <div class="mb-8">
                                            <span class="chip sm tan">F-대학원(국내)</span>
                                        </div>
                                        <div>
                                            <span class="txt_body_sm sb">일산중학교</span>
                                            <span class="txt_body_sm txt_tertiary">2023-07~2024-06</span>
                                        </div>
                                        <div class="d-flex gap-8 align-center mt-8">
                                            <div class="label_text_group">
                                                <div class="txt_body_sm">
                                                    <span class="sb">졸업</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">서울</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">본교</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">주간</span>
                                                </div>
                                            </div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>
                                    <div class="pa-16-20-8 bd-b">
                                        <div class="mb-8">
                                            <span class="chip sm scarlet">F-대학원(국내)</span>
                                        </div>
                                        <div>
                                            <span class="txt_body_sm sb">이수초등학교</span>
                                            <span class="txt_body_sm txt_tertiary">2023-07~2024-06</span>
                                        </div>
                                        <div class="d-flex gap-8 align-center mt-8">
                                            <div class="label_text_group">
                                                <div class="txt_body_sm">
                                                    <span class="sb">졸업</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">서울</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">본교</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">주간</span>
                                                </div>
                                            </div>
                                            <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                        </div>
                                    </div>

                                </div>
                            </div>
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon send size-16"></i>
                                        <p class="txt_title_xs sb txt_left">경력</p>
                                    </div>
                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                </div>
                                <div class="tab_container w-164 ma-auto mb-8">
                                    <ul>
                                        <li>
                                            <button class="tab active" data-tab="tab1">
                                                사외경력
                                            </button>
                                        </li>
                                        <li>
                                            <button class="tab" data-tab="tab2">
                                                사내경력
                                            </button>
                                        </li>
                                    </ul>
                                </div>
                                <div class="tab_content active" id="tab1">
                                    <div class="txt_body_m txt_secondary mb-8 d-flex gap-4">
                                        <i class="mdi-ico txt_18">settings</i>
                                        총 인정경력
                                        <span class="sb txt_primary">10년 10개월</span>
                                    </div>
                                    <div class="d-flex flex-col gap-12">
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card round ed-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab_content" id="tab2">

                                    <div class="txt_body_m txt_secondary mb-8 d-flex gap-4">
                                        <i class="mdi-ico txt_18">settings</i>
                                        총 인정경력
                                        <sdivan class="sb txt_primary">10년 10개월</span>
                                    </div>
                                    <div class="d-flex flex-col gap-12">
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card round ed-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="card rounded-16 pa-16-20">
                                            <div class="d-flex gap-16 align-center justify-between mb-8">
                                                <div>
                                                    <p class="txt_title_xs sb">
                                                        한국중견기업
                                                        <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                    </p>
                                                </div>
                                                <div class="d-flex gap-16 align-center">
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정비율(%)</span>
                                                        <span class="sb">100</span>
                                                    </div>
                                                    <div class="d-flex gap-4 txt_body_sm">
                                                        <span class=" txt_secondary">인정경력</span>
                                                        <span class="sb">6월 10개월</span>
                                                    </div>
                                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                                </div>
                                            </div>
                                            <div class="line gray mb-12"></div>
                                            <div>
                                                <div class="label_text_group mb-8">
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">부서</span>
                                                        <span class="sb">품질개선팀</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">직위</span>
                                                        <span class="sb">A1234DF</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">포상금액</span>
                                                        <span class="sb">10,000,000</span>
                                                    </div>
                                                    <div class="txt_body_sm">
                                                        <span class="txt_secondary">지급년일</span>
                                                        <span class="sb">2024-01</span>
                                                    </div>
                                                </div>
                                                <div class="txt_body_sm mb-8">
                                                    <span class="txt_secondary">퇴직사유</span>
                                                    <span class="sb ml-4">업무개편</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">비고</span>
                                                    <span class="sb ml-4">-</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab_content" id="tab5">
                        <div class="d-grid grid-cols-2 gap-16 hr_tab_content inner_scroll">

                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon peace_hand size-16"></i>
                                        <p class="txt_title_xs sb txt_left">어학</p>
                                    </div>
                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                </div>
                                <div class="d-flex flex-col gap-12"> -->
                                    <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                        <i class="icon no_data"></i>
                                         <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                    </div> -->
                                    <!-- <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    TOEIC
                                                    <span class="txt_body_sm txt_tertiary ml-8">영어</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div>
                                            <div class="label_text_group mb-16">
                                                <div class="txt_body_sm">
                                                    <span class="sb">A</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">레벨6</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">YBM</span>
                                                </div>
                                            </div>
                                            <div class="label_text_group mb-8">
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">시험일자</span>
                                                    <span class="sb">2024-01-01</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">수당지급시작/종료일</span>
                                                    <span class="sb">2024-01-01~2024-01-01</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    TOEIC
                                                    <span class="txt_body_sm txt_tertiary ml-8">영어</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div>
                                            <div class="label_text_group mb-16">
                                                <div class="txt_body_sm">
                                                    <span class="sb">A</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">레벨6</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">YBM</span>
                                                </div>
                                            </div>
                                            <div class="label_text_group mb-8">
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">시험일자</span>
                                                    <span class="sb">2024-01-01</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">수당지급시작/종료일</span>
                                                    <span class="sb">2024-01-01~2024-01-01</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    TOEIC
                                                    <span class="txt_body_sm txt_tertiary ml-8">영어</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div>
                                            <div class="label_text_group mb-16">
                                                <div class="txt_body_sm">
                                                    <span class="sb">A</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">레벨6</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="sb">YBM</span>
                                                </div>
                                            </div>
                                            <div class="label_text_group mb-8">
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">시험일자</span>
                                                    <span class="sb">2024-01-01</span>
                                                </div>
                                                <div class="txt_body_sm">
                                                    <span class="txt_secondary">수당지급시작/종료일</span>
                                                    <span class="sb">2024-01-01~2024-01-01</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card rounded-16 pa-24 bg-white">
                                <div class="d-flex justify-between align-center mb-12">
                                    <div class="d-flex gap-8">
                                        <i class="icon cyborg size-16"></i>
                                        <p class="txt_title_xs sb txt_left">해외연수</p>
                                    </div>
                                    <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                </div>
                                <div class="d-flex flex-col gap-12"> -->
                                    <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                        <i class="icon no_data"></i>
                                         <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                    </div> -->
                                    <!-- <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    이집트
                                                    <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">도시</span>
                                                <span class="sb">카이로</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">연수목적</span>
                                                <span class="sb">현지 품질 관리</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex flex-col gap-4">
                                                <span class="txt_body_sm txt_secondary">연수내용</span>
                                                <span class="txt_body_sm sb">공장 견학 및 내부 문서 관리</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    이집트
                                                    <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">도시</span>
                                                <span class="sb">카이로</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">연수목적</span>
                                                <span class="sb">현지 품질 관리</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex flex-col gap-4">
                                                <span class="txt_body_sm txt_secondary">연수내용</span>
                                                <span class="txt_body_sm sb">공장 견학 및 내부 문서 관리</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    이집트
                                                    <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">도시</span>
                                                <span class="sb">카이로</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">연수목적</span>
                                                <span class="sb">현지 품질 관리</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex flex-col gap-4">
                                                <span class="txt_body_sm txt_secondary">연수내용</span>
                                                <span class="txt_body_sm sb">공장 견학 및 내부 문서 관리</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    이집트
                                                    <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">도시</span>
                                                <span class="sb">카이로</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">연수목적</span>
                                                <span class="sb">현지 품질 관리</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex flex-col gap-4">
                                                <span class="txt_body_sm txt_secondary">연수내용</span>
                                                <span class="txt_body_sm sb">공장 견학 및 내부 문서 관리</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    이집트
                                                    <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">도시</span>
                                                <span class="sb">카이로</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">연수목적</span>
                                                <span class="sb">현지 품질 관리</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex flex-col gap-4">
                                                <span class="txt_body_sm txt_secondary">연수내용</span>
                                                <span class="txt_body_sm sb">공장 견학 및 내부 문서 관리</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card rounded-16 pa-16-20">
                                        <div class="d-flex gap-16 align-center justify-between mb-8">
                                            <div>
                                                <p class="txt_title_xs sb">
                                                    이집트
                                                    <span class="txt_body_sm txt_tertiary ml-8">2023-07-31~2023-08-01</span>
                                                </p>
                                            </div>
                                            <div>
                                                <i class="mdi-ico txt_tertiary cursor-pointer pa-6 txt_18">file_download</i>
                                            </div>
                                        </div>
                                        <div class="line gray mb-12"></div>
                                        <div class="label_text_group mb-8">
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">도시</span>
                                                <span class="sb">카이로</span>
                                            </div>
                                            <div class="txt_body_sm">
                                                <span class="txt_secondary">연수목적</span>
                                                <span class="sb">현지 품질 관리</span>
                                            </div>
                                        </div>
                                        <div class="label_list">
                                            <div class="d-flex flex-col gap-4">
                                                <span class="txt_body_sm txt_secondary">연수내용</span>
                                                <span class="txt_body_sm sb">공장 견학 및 내부 문서 관리</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab_content" id="tab6">
                        <div class="d-grid grid-cols-4 gap-16 hr_tab_content inner_scroll">
                            <div class="card bg-white rounded-16 pa-24-20">
                                <div class="mb-16 d-flex gap-8">
                                    <i class="icon rocket size-16"></i>
                                    <p class="txt_title_xs sb txt_left">병역사항</p>
                                </div> -->
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                    <i class="icon no_data"></i>
                                     <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                </div> -->
                                <!-- <div class="card rounded-16 pa-16-20">
                                    <div class="label_list d-flex flex-col gap-8">
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">병역구분</span>
                                            <span class="txt_body_sm sb">예비역
                                            </span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">군별</span>
                                            <span class="txt_body_sm sb">육군</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">계급</span>
                                            <span class="txt_body_sm sb">병장</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">군번</span>
                                            <span class="txt_body_sm sb">1234567</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">병과</span>
                                            <span class="txt_body_sm sb">법무</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">전역사유</span>
                                            <span class="txt_body_sm sb">만기제대</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">복무기간</span>
                                            <span class="txt_body_sm sb">2020-01-01~2021-08-31</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex flex-col gap-4">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-24-20">
                                <div class="mb-16 d-flex gap-8">
                                    <i class="icon send size-16"></i>
                                    <p class="txt_title_xs sb txt_left">병역특례</p>
                                </div> -->
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                    <i class="icon no_data"></i>
                                     <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                </div> -->
                                <!-- <div class="card rounded-16 pa-16-20">
                                    <div class="label_list d-flex flex-col gap-8">
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">병특대상여부</span>
                                            <span class="txt_body_sm sb">대상
                                            </span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">군사교육수료여부</span>
                                            <span class="txt_body_sm sb">수료</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">특례편입일</span>
                                            <span class="txt_body_sm sb">2020-01-01</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">특례만료일</span>
                                            <span class="txt_body_sm sb">2020-01-01</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">군사교육기간</span>
                                            <span class="txt_body_sm sb">2020-01-01~2021-08-31</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">훈련부대명</span>
                                            <span class="txt_body_sm sb">훈련부대</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex flex-col gap-4">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-24-20">
                                <div class="mb-16 d-flex gap-8">
                                    <i class="icon photo_spark size-16"></i>
                                    <p class="txt_title_xs sb txt_left">보훈사항</p>
                                </div> -->
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                    <i class="icon no_data"></i>
                                     <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                </div> -->
                                <!--<div class="card rounded-16 pa-16-20">
                                    <div class="label_list d-flex flex-col gap-8">
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">보훈구분</span>
                                            <span class="txt_body_sm sb">애국지사(건국훈장1-3등급)
                                            </span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">보훈관계</span>
                                            <span class="txt_body_sm sb">부</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">보훈번호</span>
                                            <span class="txt_body_sm sb">123456</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">유공자성명</span>
                                            <span class="txt_body_sm sb">김진수</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">고용명령번호</span>
                                            <span class="txt_body_sm sb">987654</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex flex-col gap-4">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-24-20">
                                <div class="mb-16 d-flex gap-8">
                                    <i class="icon user_multiple size-16"></i>
                                    <p class="txt_title_xs sb txt_left">장애사항</p>
                                </div> -->
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center my-12">
                                    <i class="icon no_data"></i>
                                     <p class="txt_body_sm txt_tertiary">해당사항 없음</p>
                                </div> -->
                                <!-- <div class="card rounded-16 pa-16-20">
                                    <div class="label_list d-flex flex-col gap-8">
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">장애유형</span>
                                            <span class="txt_body_sm sb">청각장애
                                            </span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">장애등급</span>
                                            <span class="txt_body_sm sb">01등급</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">장애구분</span>
                                            <span class="txt_body_sm sb">등록장애인</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">장애인정일</span>
                                            <span class="txt_body_sm sb">2020-01-01</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">장애번호</span>
                                            <span class="txt_body_sm sb">987654</span>
                                        </div>
                                        <div class="d-flex justify-between">
                                            <span class="txt_body_sm txt_secondary">장애인정기관</span>
                                            <span class="txt_body_sm sb">장애인정기관</span>
                                        </div>
                                        <div class="line"></div>
                                        <div class="d-flex flex-col gap-4">
                                            <span class="txt_body_sm txt_secondary">비고</span>
                                            <span class="txt_body_sm sb">비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란비고내용 작성란</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> -->

                </div>

            </div>

        </div>
    </div>
</body>
</html>
