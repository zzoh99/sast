<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- bootstrap -->
<link rel="stylesheet" type="text/css" href="/common/plugin/bootstrap/css/bootstrap.min.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!--common-->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- 근태 css -->
<link rel="stylesheet" type="text/css" href="/assets/css/attendanceNew.css"/>
<script src="/common/plugin/bootstrap/js/bootstrap.min.js"></script>

<!-- 개별 화면 script -->
<script>
    $(function() {
        initPage();
    });

    async function initPage() {
        progressBar(true);

        initTab();

        const initCodes = await getInitCodes();
        initElementByCode(initCodes);

        await initSearchSeqList();

        initFinDateMonth();
        // initFinDateDay();

        const getUpbaseCodes = await getCodeList("WT0001");
        initUpbaseU1y(getUpbaseCodes);
        initUpbase(getUpbaseCodes);

        const getUnitCodes = await getCodeList("WT0002");
        initUnitU1y(getUnitCodes);
        initUnit(getUnitCodes);

        $("#searchEmpYmd").datepicker2();
        $("#searchEmpYmd").val("${curSysYyyyMMddHyphen}");

        addEvents();

        await searchAllTabs();
        setRequired();

        progressBar(false);
    }

    /**
     * Tab 초기화
     */
    function initTab() {
        const tabMenus = document.querySelectorAll("li.tab_menu");
        tabMenus.forEach((menu, idx) => {
            menu.addEventListener("click", (e) => {
                e.preventDefault(); // 태그의 기본 동작 방지

                const tabContents = document.querySelectorAll("div.tab-content");
                tabContents.forEach((content) => {
                    content.classList.remove("active");
                    content.classList.add("hide");
                })

                document.querySelectorAll("li.tab_menu").forEach((content) => {
                    content.classList.remove("active");
                })

                menu.classList.add("active");
                tabContents[idx].classList.add("active");
                tabContents[idx].classList.remove("hide");
            });
        });
    }

    /**
     * 연차코드 조회
     */
    function initElementByCode(initCodes) {
        const renderRadio = (code, arr) => {
            let html = ``;
            for (const obj of arr) {
                html += `<input type="radio" name="\${code}" id="\${code}\${obj.code}" class="form-radio" value="\${obj.code}" checked />
                        <label for="\${code}\${obj.code}">\${obj.title}</label>`;
            }
            return html;
        }

        const renderOption = (arr) => {
            let html = ``;
            for (const obj of arr) {
                html += `<option value="\${obj.code}">\${obj.title}</option>`;
            }
            return html;
        }

        if (initCodes) {
            for (const code in initCodes) {

                if (code === "gntCd") {
                    if(Object.keys(initCodes[code]).length > 0) {
                        document.querySelector("input#gntCd").value = initCodes[code][0].code;
                    }
                } else {

                    const pEl = document.querySelector("#"+code+", #"+code+"Div");
                    if (pEl) pEl.innerHTML = ""; // 초기화

                    if (pEl instanceof HTMLDivElement && pEl.classList.contains("radio-group")) {
                        // 라디오 버튼 렌더링
                        pEl.innerHTML = renderRadio(code, initCodes[code]);
                    } else if (pEl instanceof HTMLSelectElement) {
                        // option 으로 설정
                        pEl.innerHTML = renderOption(initCodes[code]);
                    }
                }
            }
        }
    }

    function openTab(tabNum) {
        const tabButton = document.querySelector("li#tabButton" + tabNum);
        tabButton.click();
    }

    async function initSearchSeqList() {
        const data = await callFetch("${ctx}/WtmLeaveCreStd.do?cmd=getWtmLeaveCreStdSearchSeqList", "gntCd=" + $("#gntCd").val());
        if (data.isError) {
            alert(data.errMsg);
            $("#searchSeq").html("");
            return;
        }

        const codeList = convCode(data.DATA, "");
        $("#searchSeq").html(codeList[2]);
    }

    async function deleteSearchSeqCode() {
        if ($("#searchSeq").val() === "") {
            alert("삭제하고자 하는 발생대상자 조건을 선택해주세요.");
            $("#searchSeq").focus();
            return;
        }

        if (!confirm("선택한 " + $("#searchSeq option:selected").text() + " 대상자의 생성기준을 삭제하시겠습니까? 삭제후에는 복구할 수 없습니다.")) return;

        const data = await callFetch("${ctx}/WtmLeaveCreStd.do?cmd=deleteWtmLeaveCreStdSearchSeq", "gntCd=" + $("#gntCd").val() + "&searchSeq=" + $("#searchSeq").val());
        if (data.isError) {
            alert(data.errMsg);
            return;
        }

        alert(data.Message);
    }

    /**
     * 회계일_월 초기화
     * @param value 초기값
     */
    function initFinDateMonth(value = "0") {
        const finDateMonth = document.querySelector("select#finDateMonth");
        finDateMonth.innerHTML = "";

        for (let i = 0 ; i <= 12 ; i++) {
            const option = document.createElement("option");
            if (i === 0) {
                option.value = "";
                option.innerText = "선택";
            } else {
                option.value = (i + "");
                option.innerText = i + "월";
            }

            if (value && value === i+"")
                option.selected = true;

            finDateMonth.append(option);
        }

        finDateMonth.addEventListener("change", (event) => { initFinDateDay(event.target.value); });
    }

    /**
     * 회계일_일자 초기화
     * @param month 선택된 월
     * @param value 초기값
     */
    function initFinDateDay(month, value = "0") {

        const finDateDay = document.querySelector("select#finDateDay");
        finDateDay.innerHTML = "";

        const fOption = document.createElement("option");
        fOption.value = "";
        fOption.innerText = "선택";
        finDateDay.append(fOption);

        if (month) {
            const date = new Date();
            date.setMonth(month);
            date.setDate(0);
            const lastDayOfMonth = date.getDate(); // 회계월의 마지막 날짜

            for (let i = 1 ; i <= lastDayOfMonth ; i++) {
                const option = document.createElement("option");
                option.value = (i + "");
                option.innerText = i + "일";

                if (value && value === i+"")
                    option.selected = true;

                finDateDay.append(option);
            }
        }
    }

    /**
     * 2년차 연차 올림기준 초기화
     * @param codes 코드리스트
     * @param value 초기값
     */
    function initUpbaseU1y(codes, value = "R") {

        const upbaseU1yDiv = document.querySelector("div#upbaseU1yDiv");
        upbaseU1yDiv.innerHTML = "";

        for (const obj of codes) {
            const input = document.createElement("input");
            input.type = "radio";
            input.name = "upbaseU1y";
            input.id = "upbaseU1y" + obj.code;
            input.className = "form-radio";
            input.value = obj.code;

            if (value === obj.code) {
                input.checked = true;
            }

            const label = document.createElement("label");
            label.for = "upbaseU1y" + obj.code;
            label.innerText = obj.codeNm;

            upbaseU1yDiv.append(input);
            upbaseU1yDiv.append(label);
        }
    }

    /**
     * 근속년수 올림기준
     * @param codes 코드리스트
     * @param value 초기값
     */
    function initUpbase(codes, value = "R") {

        const upbaseDiv = document.querySelector("div#upbaseDiv");
        upbaseDiv.innerHTML = "";

        for (const obj of codes) {
            const input = document.createElement("input");
            input.type = "radio";
            input.name = "upbase";
            input.id = "upbase" + obj.code;
            input.className = "form-radio";
            input.value = obj.code;

            if (value === obj.code) {
                input.checked = true;
            }

            const label = document.createElement("label");
            label.for = "upbase" + obj.code;
            label.innerText = obj.codeNm;

            upbaseDiv.append(input);
            upbaseDiv.append(label);
        }
    }

    /**
     * 2년차 연차 단위자리수 초기화
     * @param codes 코드리스트
     * @param value 초기값
     */
    function initUnitU1y(codes, value = "10") {

        const unitU1yDiv = document.querySelector("div#unitU1yDiv");
        unitU1yDiv.innerHTML = "";

        for (const obj of codes) {
            const input = document.createElement("input");
            input.type = "radio";
            input.name = "unitU1y";
            input.id = "unitU1y" + obj.code;
            input.className = "form-radio";
            input.value = obj.code;

            if (value === obj.code) {
                input.checked = true;
            }

            const label = document.createElement("label");
            label.for = "unitU1y" + obj.code;
            label.innerText = obj.codeNm;

            unitU1yDiv.append(input);
            unitU1yDiv.append(label);
        }
    }

    /**
     * 근속년수 단위자리수 초기화
     * @param codes 코드리스트
     * @param value 초기값
     */
    function initUnit(codes, value = "10") {

        const unitDiv = document.querySelector("div#unitDiv");
        unitDiv.innerHTML = "";

        for (const obj of codes) {
            const input = document.createElement("input");
            input.type = "radio";
            input.name = "unit";
            input.id = "unit" + obj.code;
            input.className = "form-radio";
            input.value = obj.code;

            if (value === obj.code) {
                input.checked = true;
            }

            const label = document.createElement("label");
            label.for = "unit" + obj.code;
            label.innerText = obj.codeNm;

            unitDiv.append(input);
            unitDiv.append(label);
        }
    }

    /**
     * 이벤트 초기화
     */
    function addEvents() {
        $("#searchSeq").on("change", function() {
            searchAllTabs();
        })

        $("#btnAddSearchSeq").on("click", function() {
            openSearchSeqLayer("add");
        });

        $("#btnModifySearchSeq").on("click", function() {
            openSearchSeqLayer("modify");
        });

        $("#btnDeleteSearchSeq").on("click", function() {
            deleteSearchSeqCode();
        });

        // Tab 조회 이벤트
        document.querySelectorAll("button#tab1Search, button#tab2Search, button#tab3Search").forEach((el) => {
            el.addEventListener("click", async (event) => {
                progressBar(true);
                const stdInfo = await getWtmLeaveCreStd();
                if (isEmptyObject(stdInfo)) {
                    alert("저장된 휴가생성기준 데이터가 없습니다. 저장 후 조회바랍니다.");
                    return;
                }
                const tabNum = getTabNumber(event.target);
                searchTab(stdInfo, tabNum);
                progressBar(false);
            });
        });

        // Tab 저장 이벤트
        document.querySelectorAll("button#tab1Save, button#tab2Save, button#tab3Save").forEach((el) => {
            el.addEventListener("click", (event) => {
                if(!isValidRequired()) return;
                progressBar(true);
                saveTab(event);
                progressBar(false);
            });
        });

        // 연차부여 예상조회 이벤트
        document.querySelector("button#btnSimulation").addEventListener("click", async () => {
            if(!isValidRequired()) return;

            progressBar(true);
            const data = await getLeaveSimulationData();
            if (data) {
                renderCardGutter(data);
            }
            progressBar(false);
        });

        // input, select 항목마다 변경 이벤트 추가
        $("input, select:not(#searchSeq)").on("change", function(el) {
            fnChangeEvent(el);
        });

        // 월차 생성기준에 따른 이벤트
        const monthlyCreTypeU1y = document.querySelector("select#monthlyCreTypeU1y");
        monthlyCreTypeU1y.addEventListener("change", (event) => {
            document.querySelector("div#divStartAtEmpYmdU1y").style.display = event.target.value === "A" ? "" : "none";
        })
        monthlyCreTypeU1y.dispatchEvent(new Event("change"));
    }

    /**
     * 조건검색 팝업 오픈
     */
    function openSearchSeqLayer(prcType) {
        if(!isPopup()) {return;}

        const url = '/Popup.do?cmd=viewPwrSrchMgrLayer';
        const p = { searchDesc: $("#searchSeq option:selected").text() };
        new window.top.document.LayerModal({
            id : 'pwrSrchMgrLayer',
            url: url,
            parameters: p,
            width: 850,
            height: 620,
            title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>',
            trigger :[
                {
                    name : 'pwrTrigger',
                    callback : function(result) {
                        if (!result.searchSeq) return;
                        if (prcType === "add")
                            saveWtmLeaveCreStdAddSearchSeq(result.searchSeq);
                        else if (prcType === "modify")
                            saveWtmLeaveCreStdModifySearchSeq(result.searchSeq);
                    }
                }
            ]
        }).show();
    }

    async function saveWtmLeaveCreStdAddSearchSeq(searchSeq) {

        if ($("#searchSeq").find("option[value=" + searchSeq + "]").length > 0) {
            if (!confirm("이미 동일한 대상자로 연차생성기준이 등록되어 있습니다. 연차발생 기준 저장 후 이동하시겠습니까?")) return;

            $("#tab1Save").click();
            $("#searchSeq").val(searchSeq).change();
            return;
        }

        const data = await callFetch("${ctx}/WtmLeaveCreStd.do?cmd=saveWtmLeaveCreStdAddSearchSeq", "gntCd=" + $("#gntCd").val() + "&searchSeq=" + searchSeq);
        if (data.isError) {
            alert(data.errMsg);
            return;
        }

        if (data.Result && data.Result.Code <= 0) {
            alert("연차생성대상자 추가에 실패하였습니다. 담당자에게 문의 바랍니다.");
        } else {
            await initSearchSeqList();
            $("#searchSeq").val(searchSeq);
        }
    }

    async function saveWtmLeaveCreStdModifySearchSeq(searchSeq) {
        const data = await callFetch("${ctx}/WtmLeaveCreStd.do?cmd=saveWtmLeaveCreStdModifySearchSeq", "gntCd=" + $("#gntCd").val() + "&searchSeq=" + $("#searchSeq").val() + "&searchNewSeq=" + searchSeq);
        if (data.isError) {
            alert(data.errMsg);
            return;
        }

        if (data.Result && data.Result.Code <= 0) {
            alert("연차생성대상자 수정에 실패하였습니다. 담당자에게 문의 바랍니다.");
        } else {
            alert(data.Result.Message);
            await initSearchSeqList();
            $("#searchSeq").val(searchSeq);
        }
    }

    /**
     * 조건검색 값 clear
     */
    function clearSearchSeqValue() {
        document.querySelector("#searchSeq").value = "";
    }

    /**
     * Tab 별 조회 이벤트
     * @param stdInfo 기준정보
     * @param tabNum Tab 번호
     */
    function searchTab(stdInfo, tabNum) {

        // 변경되었다는 알림 제거
        document.querySelector("div#tabs-"+tabNum).querySelector('.status-banner').style.display = 'none';

        if (!isEmptyObject(stdInfo)) {

            document.querySelectorAll("div#tabs-" + tabNum + " input").forEach((input) => {
                const name = input.name;
                const value = stdInfo[name];
                if (input.type === "text") {
                    input.value = value;
                    input.setAttribute("data-origin", value);
                } else if (input.type === "radio") {
                    if (input.value === value) {
                        input.checked = true;
                        input.setAttribute("data-origin", "checked");
                    }
                }
            })

            document.querySelectorAll("div#tabs-" + tabNum + " select").forEach((select) => {
                const name = select.name;
                const value = stdInfo[name];
                select.setAttribute("data-origin", value);
                select.querySelectorAll("option").forEach((option) => {
                    option.selected = (option.value === value);
                });

                // 회계월인 경우에는 회계일을 세팅함.
                if (name === "finDateMonth") {
                    initFinDateDay(value);
                }
            })
        }
    }

    /**
     * 전체 탭 데이터 조회
     * @returns {Promise<void>}
     */
    async function searchAllTabs() {
        const stdInfo = await getWtmLeaveCreStd();
        searchTab(stdInfo, 1);
        searchTab(stdInfo, 2);
        searchTab(stdInfo, 3);
    }

    /**
     * tab 마다 저장 이벤트
     * @param event
     * @returns {Promise<void>}
     */
    async function saveTab(event) {
        const code = await saveWtmLeaveCreStd();
        if (code > 0) {
            const stdInfo = await getWtmLeaveCreStd();
            searchTab(stdInfo, getTabNumber(event.target));
        }
    }

    /**
     * api 호출을 위한 파라미터 string 생성
     * @returns {string}
     */
    function getParameterString() {
        const isChecked = (el) => {
            return (!(el instanceof HTMLInputElement && el.type === "radio") && el.name) || el.checked;
        };

        let result = "";
        document.querySelectorAll("input, select").forEach((el) => {
            if (isChecked(el))
                result += "&" + el.name + "=" + el.value;
        });
        return result;
    }

    /**
     * 빈 객체인지 여부 판단
     * @param obj
     * @returns {boolean}
     */
    function isEmptyObject(obj) {
        return Object.keys(obj).length === 0 && obj.constructor === Object;
    }

    /**
     * 연차 부여 미리보기 render
     * @param data 미리보기 데이터
     */
    function renderCardGutter(data = {}) {

        // 사전 function 정의 Start
        const createCardGutter = (obj) => {
            const cardGutter = document.createElement('div');
            cardGutter.className = 'col-xl-4 col-lg-6 col-md-6 col-sm-12 card-gutter';

            // TODO: popover 의 period 부분에 텍스트가 길게 들어가면 짤림 현상 발생.
            const popover = `<div class="popover"><span class='popover-title'>\${obj.reasonText}</span><div class='period'>\${obj.reasonPeriod}</div></div>`;

            // TODO: 부여시기의 텍스트가 길어질 경우 글자가 줄분리되어 아래로 떨어짐.
            cardGutter.innerHTML =
                `
                    <div class="leave-card">
                        <div class="inner-wrap">
                            <span class="icon-wrap"><i class="mdi-ico">today</i></span>
                            <span class="card-date">\${obj.formattedYmd}</span>
                        </div>
                        <div class="row card-desc">
                            <div class="col-common col-5"><span class="label">부여시기</span><span class="desc">\${obj.term}</span></div>
                            <div class="col-common col-4"><span class="label">1년미만</span><span class="desc">\${obj.monthlyLeave}</span>\${((obj.monthlyLeave !== "-") ? popover : "")}</div>
                            <div class="col-common col-3"><span class="label">연차</span><span class="desc">\${obj.annualLeave}</span>\${((obj.annualLeave !== "-") ? popover : "")}</div>
                        </div>
                    </div>
                `;
            return cardGutter;
        };

        const createPreviewForm = (key, arr) => {
            const header = document.createElement("div");
            header.className = "preview-header";
            header.innerText = (key === "others")? "이후 미리보기" : key + "년 미리보기";

            const body = document.createElement("div");
            body.className = "preview-body";
            const cardWrapper = document.createElement("div");
            cardWrapper.className = "row card-wrapper";

            for (const info of arr) {
                const cardGutter = createCardGutter(info);
                cardWrapper.append(cardGutter);
            }

            body.append(cardWrapper);

            previewWrap.append(header);
            previewWrap.append(body);
        };
        // 사전 function 정의 End


        const previewWrap = document.querySelector("div.preview-wrap");
        previewWrap.innerHTML = "";

        if (isEmptyObject(data)) return;

        for (const year in data) {
            createPreviewForm(year, data[year]);
        }
    }

    /**
     * 항목별 변경에 따른 이벤트
     * @param event 이벤트객체
     */
    function fnChangeEvent(event) {
        setChanged(getTabNumber(event.target)); // 탭 별 변경여부 처리
        setRequired(); // 필수값 처리
    }

    /**
     * 항목별 변경에 따른 상태 처리
     * @param tabNum 탭 번호
     */
    function setChanged(tabNum) {
        const isChangedTarget = (target) => {
            return (target instanceof HTMLInputElement && target.type === "text" && target.getAttribute("data-origin") !== target.value)
                || (target instanceof HTMLInputElement && target.type === "radio" && document.querySelector("input[name=" + target.name + "][data-origin=checked]").value !== target.value)
                || (target instanceof HTMLSelectElement && target.getAttribute("data-origin") !== target.value);
        }

        const tabContent = document.querySelector("div#tabs-" + tabNum);
        let isChanged = false;
        try {
            tabContent.querySelectorAll("input[type=radio]:checked, select").forEach((el) => {
                if (isChangedTarget(el))
                    throw new Error("");
            });
        } catch(error) {
            isChanged = true;
        }

        if (isChanged) {
            tabContent.querySelector('.status-banner').style.display = 'block';
        } else {
            tabContent.querySelector('.status-banner').style.display = 'none';
        }
    }

    /**
     * 설정값에 따른 필수값 화면 설정
     */
    function setRequired() {

        // 사전 function 정의 Start
        const isRequiredFinDate = () => {
            return (document.querySelector("input[name=annualCreType]:checked").value === "B")
                || (document.querySelector("select[name=monthlyCreTypeU1y]").value === "C")
                || (["A", "B", "C"].includes(document.querySelector("select[name=annualCreTypeU1y]").value));
        };

        const isRequiredTotDaysType = () => {
            return (document.querySelector("input[name=annualCreType]:checked").value === "B")
                || (["A", "C"].includes(document.querySelector("select[name=annualCreTypeU1y]").value));
        };

        const isRequiredUpbaseU1y = () => {
            return (["A", "C"].includes(document.querySelector("select[name=annualCreTypeU1y]").value));
        };

        const isRequiredUpbase = () => {
            return (document.querySelector("input[name=annualCreType]:checked").value === "B");
        };

        const addReq = (el) => {
            const th = el.closest("tr").querySelector("th");
            if (!th.querySelector("span.req")) {
                const req = document.createElement("span");
                req.className = "req";
                th.prepend(req);
            }
        }

        const removeReq = (el) => {
            const req = el.closest("tr").querySelector("th span.req");
            if (req) req.remove();
        }
        // 사전 function 정의 End



        if (isRequiredFinDate()) {
            // 회계일 필수 여부 확인
            addReq(document.querySelector("select#finDateMonth"));
        } else {
            removeReq(document.querySelector("select#finDateMonth"));
        }

        if (isRequiredTotDaysType()) {
            // 기준년도 일수 필수값 확인
            addReq(document.querySelector("input[name=totDaysType]"));
        } else {
            removeReq(document.querySelector("input[name=totDaysType]"));
        }

        if (isRequiredUpbaseU1y()) {
            // 2년차 연차 올림/단위자리 필수값 확인
            addReq(document.querySelector("input[name=upbaseU1y]"));
            addReq(document.querySelector("input[name=unitU1y]"));
        } else {
            removeReq(document.querySelector("input[name=upbaseU1y]"));
            removeReq(document.querySelector("input[name=unitU1y]"));
        }

        if (isRequiredUpbase()) {
            // 근속년수 올림/단위자리 필수값 확인
            addReq(document.querySelector("input[name=upbase]"));
            addReq(document.querySelector("input[name=unit]"));
        } else {
            removeReq(document.querySelector("input[name=upbase]"));
            removeReq(document.querySelector("input[name=unit]"));
        }
    }

    /**
     * 저장 / 조회 시 필수값 체크
     * @returns {boolean}
     */
    function isValidRequired() {
        const existsNotSelectedElements = (td) => {
            return (!td.querySelector("input[type=radio]:checked")
                && Array.from(td.querySelectorAll("select")).filter((el2) => el2.value).length === 0);
        }

        if($('#searchSeq').val() == '') {
            alert("지급대상 조건검색을 입력해주시기 바랍니다.")
            return false;
        }

        let isValid = true;
        try {
            document.querySelectorAll("span.req").forEach((el) => {

                const td = el.closest("tr").querySelector("td");
                if (existsNotSelectedElements(td)) {

                    const th = el.closest("tr").querySelector("th");
                    alert(th.innerText + "을(를) 입력해주시기 바랍니다.");

                    const tabNum = getTabNumber(el);
                    openTab(tabNum);

                    throw new Error("");
                }
            });
        } catch (error) {
            isValid = false;
        }
        return isValid;
    }

    /**
     * 특정 엘리멘트가 속한 탭 번호를 조회
     * @param el HTMLElement
     * @returns {*}
     */
    function getTabNumber(el) {
        console.log(el);
        return el.closest("div.tab-content").id.replace("tabs-", "");
    }



    // api 호출
    /**
     * 연차코드 조회
     * @returns {Promise<[{codeNm: number, cnt: number, perCnt: number}]|[{codeNm: number, cnt: number, perCnt: number}]|[{wkpAvgM: number, wkpAvgY: number}]|[[]]|*|{}>}
     */
    async function getInitCodes() {
        const data = await callFetch("${ctx}/WtmLeaveCreStd.do?cmd=getWtmLeaveCreStdLeaveCdMap", "");
        if (data.isError) {
            alert(data.errMsg);
            return;
        }

        return data.DATA;
    }

    /**
     * 휴가생성기준 데이터 조회
     * @returns {Promise<[{codeNm: number, cnt: number, perCnt: number}]|[{codeNm: number, cnt: number, perCnt: number}]|[{wkpAvgM: number, wkpAvgY: number}]|[[]]|*|{}|{}>}
     */
    async function getWtmLeaveCreStd() {
        const gntCd = document.querySelector("input#gntCd").value;
        if (!gntCd) {
            alert(`연차휴가 코드가 정상적으로 설정되지 않았습니다. 근태코드관리에서 근태종류가 "연차휴가"인 근태코드 중 기본근태코드를 설정해주세요.`);
            return {};
        }

        const searchSeq = document.querySelector("#searchSeq").value;

        const response = await fetch("${ctx}/WtmLeaveCreStd.do?cmd=getWtmLeaveCreStdMap&gntCd="+gntCd+"&searchSeq="+searchSeq, {
            method: "POST"
        });
        const result = await response.json();
        if (result.Message) alert(result.Message);
        // if (!result.DATA) alert("저장된 기준 데이터가 없습니다.");

        // 조회 결과가 없고 지급대상자 설정이 되어있지 않은 경우, 지급대상자 조건검색팝업 호출
        if(!result.DATA && $("#searchSeq").val() === '') {
            openSearchSeqLayer("add");
        } else {
            $("#searchSeq").val(result.DATA.searchSeq);
        }

        return (result.DATA) ? result.DATA : {};
    }

    /**
     * 공통코드 리스트 조회
     * @param grpCd 공통코드 grcode
     * @returns {Promise<*>}
     */
    async function getCodeList(grpCd) {
        const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonCodeLists", "grpCd=" + grpCd);
        if (data.isError) {
            alert(data.errMsg);
            return;
        }

        return data.codeList;
    }

    /**
     * 연차 부여 미리보기 조회
     * @returns {Promise<[{codeNm: number, cnt: number, perCnt: number}]|[{codeNm: number, cnt: number, perCnt: number}]|[{wkpAvgM: number, wkpAvgY: number}]|[[]]|*>}
     */
    async function getLeaveSimulationData() {
        const data = await callFetch("${ctx}/WtmLeaveCreStd.do?cmd=getWtmLeaveCreStdSimulationList", getParameterString());
        if (data.isError) {
            alert(data.errMsg);
            return;
        }

        return data.DATA;
    }

    /**
     * 휴가생성기준 저장
     * @returns {Promise<*>}
     */
    async function saveWtmLeaveCreStd() {
        const data = await callFetch("${ctx}/WtmLeaveCreStd.do?cmd=saveWtmLeaveCreStd", getParameterString());
        if (data.isError) {
            alert(data.errMsg);
            return;
        }

        return data.Result.Code;
    }
</script>
</head>
<body class="iframe_content white attendanceNew">
<div class="row flex-grow-1">
    <div class="col-4">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="icon-wrap"><i class="mdi-ico">today</i></span>
                <span class="page-title">연차발생</span>
            </div>
        </h2>
        <div class="title-wrap">
            <input type="hidden" id="gntCd" name="gntCd"/>
            <label for="searchSeq">발생대상자</label>
            <select class="custom_select" id="searchSeq" name="searchSeq">
                <option value="">선택</option>
            </select>
            <button id="btnAddSearchSeq" class="btn outline_gray">신규</button>
            <button id="btnModifySearchSeq" class="btn outline_gray">대상자수정</button>
            <button id="btnDeleteSearchSeq" class="btn outline_gray">삭제</button>
        </div>
        <!-- tab -->
        <div id="tabs" class="tab">
            <ul class="tab_bottom">
                <li id="tabButton1" class="tab_menu active" href="#tabs-1" >연차생성기준</li>
                <li id="tabButton2" class="tab_menu" href="#tabs-2">1년미만 대상자</li>
                <li id="tabButton3" class="tab_menu" href="#tabs-3">소수점 처리 방법</li>
            </ul>
            <div id="tabs-1" class="tab-content active">
                <h2 class="title-wrap pt-4 pb-3">
                    <span class="page-title">연차생성기준</span>
                    <div class="btn-wrap">
                        <button class="btn dark search" id="tab1Search">조회</button>
                        <button class="btn filled save" id="tab1Save">저장</button>
                    </div>
                </h2>
                <div class="status-banner">
                    변경된 내용이 있습니다. 저장해 주세요.
                </div>
                <div class="table-wrap">
                    <table class="defualt basic type5 th-trans line-grey">
                        <colgroup>
                            <col width="100px">
                            <col width="*%">
                        </colgroup>
                        <tr>
                            <th><span class="req"></span>생성기준</th>
                            <td>
                                <p class="desc">연차생성을 위한 기준일자를 선택해주세요.</p>
                                <div id="annualCreTypeDiv" class="input-wrap mt-4 radio-group"></div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="req"></span>입사일기준</th>
                            <td>
                                <p class="desc">근속년수 계산을 위한 입사일 기준을 선택해 주세요.</p>
                                <div id="annualCreJoinTypeDiv" class="input-wrap mt-4 radio-group">
                                    <input type="radio" name="annualCreJoinType" id="annualCreJoinTypeG" class="form-radio" value="G" checked />
                                    <label for="annualCreJoinTypeG">그룹입사일</label>
                                    <input type="radio" name="annualCreJoinType" id="annualCreJoinTypeE" class="form-radio" value="E" />
                                    <label for="annualCreJoinTypeE">입사일</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>회계일</th>
                            <td>
                                <p class="desc">회계일을 입력해주세요.</p>
                                <div class="input-wrap mt-4">
                                    <div class="input-wrap wid-100px">
                                        <label for="finDateMonth" style="display: none;">회계월</label>
                                        <select class="custom_select" id="finDateMonth" name="finDateMonth">
                                            <option value="">선택</option>
                                            <!-- 옵션 반복 -->
                                        </select>
                                    </div>
                                    <div class="input-wrap wid-100px ml-3">
                                        <label for="finDateDay" style="display: none;">회계일</label>
                                        <select class="custom_select" id="finDateDay" name="finDateDay">
                                            <option value="">선택</option>
                                            <!-- 옵션 반복 -->
                                        </select>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>기준년도 일수</th>
                            <td>
                                <p class="desc">회계일 기준 근속년수 계산 시 기준년도 계산방법을 선택해주세요.</p>
                                <div id="totDaysTypeDiv" class="input-wrap mt-4 radio-group">
                                    <input type="radio" name="totDaysType" id="totDaysTypeA" class="form-radio" value="A" />
                                    <label for="totDaysTypeA">365일</label>
                                    <input type="radio" name="totDaysType" id="totDaysTypeB" class="form-radio" value="B" checked />
                                    <label for="totDaysTypeB">당해총일수</label>
                                </div>
                            </td>
                        </tr>
                        <tr class="hide">
                            <th>근무율 80% 판단여부</th>
                            <td>
                                <p class="desc">연차생성 시 근무율 80% 이상일 경우에만 연차를 정상으로 생성할지 선택해주세요.</p>
                                <div class="input-wrap mt-4">
                                    <select class="custom_select" id="noCheckWorkRateYn" name="noCheckWorkRateYn">
                                        <option value="N">80% 미만 시 월 만근에 따라 월차 부여</option>
                                        <option value="Y" checked>80% 미만 상관없이 연차 부여</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>잔여연차</th>
                            <td>
                                <p class="desc">잔여연차 처리 방법을 선택해주세요.</p>
                                <div id="rewardTypeDiv" class="input-wrap mt-4 radio-group">
                                    <input type="radio" name="rewardType" id="rewardTypeA" class="form-radio" value="A" checked />
                                    <label for="rewardTypeA">이월</label>
                                    <input type="radio" name="rewardType" id="rewardTypeB" class="form-radio" value="B" />
                                    <label for="rewardTypeB">보상</label>
                                    <input type="radio" name="rewardType" id="rewardTypeC" class="form-radio" value="C" />
                                    <label for="rewardTypeC">소멸</label>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="tabs-2" class="tab-content hide">
                <h2 class="title-wrap pt-4 pb-3">
                    <span class="page-title">계속근로기간이 1년 미만인 대상자</span>
                    <div class="btn-wrap">
                        <button class="btn dark" id="tab2Search">조회</button>
                        <button class="btn filled" id="tab2Save">저장</button>
                    </div>
                </h2>
                <div class="status-banner">
                    변경된 내용이 있습니다. 저장해 주세요.
                </div>
                <div class="table-wrap">
                    <table class="defualt basic type5 th-trans line-grey">
                        <colgroup>
                            <col width="100px">
                            <col width="*%">
                        </colgroup>
                        <tr>
                            <th><span class="req"></span>자동생성여부</th>
                            <td>
                                <p class="desc">입사 후 1년 미만 대상자의 연/월차를 자동생성할지 여부를 선택해주세요. 자동생성을 하지 않아도 연차생성메뉴에서 생성가능합니다.</p>
                                <div class="input-wrap mt-4 radio-group">
                                    <input type="radio" name="autoCreU1yYn" id="autoCreU1yYnY" class="form-radio" value="Y" checked />
                                    <label for="autoCreU1yYnY">자동생성</label>
                                    <input type="radio" name="autoCreU1yYn" id="autoCreU1yYnN" class="form-radio" value="N" />
                                    <label for="autoCreU1yYnN">자동생성 안 함</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="req"></span>월차 생성기준</th>
                            <td>
                                <p class="desc">입사 후 1년 미만 대상자의 월차 생성기준을 선택해주세요.</p>
                                <div class="input-wrap mt-4">
                                    <div class="input-wrap">
                                        <select class="custom_select" id="monthlyCreTypeU1y" name="monthlyCreTypeU1y">
<%--                                        <option value="A" selected>매월 개근 시 1일 부여</option>--%>
<%--                                        <option value="B">입사 시 11일 선부여</option>--%>
<%--                                        <option value="C">회계일 기준 분할 지급</option>--%>
                                        </select>
                                    </div>
                                </div>
                                <div id="divStartAtEmpYmdU1y" class="mt-4" style="display: none;">
                                    <p class="desc">매월 생성되는 월차를 하나로 통합할지 여부를 선택해주세요.</p>
                                    <p class="desc text-danger">* 통합할 경우 사용시작일은 처음 생성된 월차의 사용시작일이 됩니다.</p>
                                    <div class="input-wrap wid-100px mt-4">
                                        <select class="custom_select" id="startAtEmpYmdU1y" name="startAtEmpYmdU1y">
                                            <option value="N">통합안함</option>
                                            <option value="Y">통합</option>
                                        </select>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th><span class="req"></span>1년 개근 연차</th>
                            <td>
                                <p class="desc">입사 후 1년 미만 대상자의 1년 개근 시 발생하는 연차 생성기준을 선택해주세요.</p>
                                <p class="desc text-danger">* 연차생성기준을 회계일로 설정했을 때만 적용 됩니다.</p>
                                <div class="input-wrap mt-4">
                                    <select class="custom_select" id="annualCreTypeU1y" name="annualCreTypeU1y">
<%--                                        <option value="A" selected>첫 회계일에 근무시간 대비 연차 부여</option>--%>
<%--                                        <option value="B">첫 회계일에 15일 부여</option>--%>
<%--                                        <option value="C">입사일에 첫 회계일까지 근무기간 대비 연차 선부여</option>--%>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>1년미만 잔여연차</th>
                            <td>
                                <p class="desc">잔여연차 처리 방법을 선택해주세요.</p>
                                <div class="input-wrap mt-4 radio-group">
                                    <input type="radio" name="rewardTypeU1y" id="rewardTypeU1yA" class="form-radio" value="A" checked />
                                    <label for="rewardTypeU1yA">이월</label>
                                    <input type="radio" name="rewardTypeU1y" id="rewardTypeU1yB" class="form-radio" value="B" />
                                    <label for="rewardTypeU1yB">익월에 보상</label>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div id="tabs-3" class="tab-content hide">
                <h2 class="title-wrap pt-4 pb-3">
                    <span class="page-title">근속년수 계산 시 소수점 처리 방법</span>
                    <div class="btn-wrap">
                        <button class="btn dark" id="tab3Search">조회</button>
                        <button class="btn filled" id="tab3Save">저장</button>
                    </div>
                </h2>
                <div class="status-banner">
                    변경된 내용이 있습니다. 저장해 주세요.
                </div>
                <div class="table-wrap">
                    <table class="defualt basic type5 th-trans line-grey">
                        <colgroup>
                            <col width="100px">
                            <col width="*%">
                        </colgroup>
                        <tr>
                            <th>2년차 연차 올림기준</th>
                            <td>
                                <p class="desc">입사 후 1년미만 대상자의 2년차 연차 계산 시 올림기준을 선택해주세요.</p>
                                <div class="input-wrap mt-4 radio-group" id="upbaseU1yDiv">
                                    <input type="radio" name="upbaseU1y" id="upbaseU1yN" class="form-radio" value="N" />
                                    <label for="upbaseU1yN">사용안함</label>
                                    <input type="radio" name="upbaseU1y" id="upbaseU1yC" class="form-radio" value="C" />
                                    <label for="upbaseU1yC">절상</label>
                                    <input type="radio" name="upbaseU1y" id="upbaseU1yR" class="form-radio" value="R" checked />
                                    <label for="upbaseU1yR">반올림</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>2년차 연차 단위자리수</th>
                            <td>
                                <p class="desc">입사 후 1년미만 대상자의 2년차 연차 계산 시 단위자리수를 선택해주세요.</p>
                                <div class="input-wrap mt-4 radio-group" id="unitU1yDiv">
                                    <input type="radio" name="unitU1y" id="unitU1y1" class="form-radio" value="1" />
                                    <label for="unitU1y1">정수로</label>
                                    <input type="radio" name="unitU1y" id="unitU1y10" class="form-radio" value="10" checked />
                                    <label for="unitU1y10">소수점 첫째자리까지</label>
                                    <input type="radio" name="unitU1y" id="unitU1y100" class="form-radio" value="100" checked />
                                    <label for="unitU1y100">소수점 둘째자리까지</label>
                                    <input type="radio" name="unitU1y" id="unitU1y1000" class="form-radio" value="1000" checked />
                                    <label for="unitU1y1000">소수점 셋째자리까지</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>근속년수 올림기준</th>
                            <td>
                                <p class="desc">근속년수에 따른 연차 계산 시 올림기준을 선택해주세요.</p>
                                <div class="input-wrap mt-4 radio-group" id="upbaseDiv">
                                    <input type="radio" name="upbase" id="upbaseN" class="form-radio" value="N" />
                                    <label for="upbaseN">사용안함</label>
                                    <input type="radio" name="upbase" id="upbaseC" class="form-radio" value="C" />
                                    <label for="upbaseC">절상</label>
                                    <input type="radio" name="upbase" id="upbaseR" class="form-radio" value="R" checked />
                                    <label for="upbaseR">반올림</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>근속년수 단위자리수</th>
                            <td>
                                <p class="desc">근속년수에 따른 연차 계산 시 단위자리수를 선택해주세요.</p>
                                <div class="input-wrap mt-4 radio-group" id="unitDiv">
                                    <input type="radio" name="unitU1y" id="unit1" class="form-radio" value="1" />
                                    <label for="unit1">정수로</label>
                                    <input type="radio" name="unitU1y" id="unit10" class="form-radio" value="10" checked />
                                    <label for="unit10">소수점 첫째자리까지</label>
                                    <input type="radio" name="unitU1y" id="unit100" class="form-radio" value="100" checked />
                                    <label for="unit100">소수점 둘째자리까지</label>
                                    <input type="radio" name="unitU1y" id="unit1000" class="form-radio" value="1000" checked />
                                    <label for="unit1000">소수점 셋째자리까지</label>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="col-8 border-left preview-content bg-grey">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">연차 부여 미리보기</span>
            </div>
            <div class="btn-wrap">
                <!-- TODO: 입사일자 css 적용 필요 -->
                <label for="searchEmpYmd">입사일자</label>
                <input id="searchEmpYmd" name="searchEmpYmd" type="text" maxlength="10" class="text center date"/>
                <button class="btn outline" id="btnSimulation">연차부여 예상조회</button>
            </div>
        </h2>
        <div class="preview-wrap">
        </div>
    </div>
</div>
</body>
</html>
