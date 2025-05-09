$(function() {
	initEmployeeHeader();
});

async function initEmployeeHeader() {
	await getUser();
	initEmployeeSearch();
	initEvent();
}

/**
 * User 정보 initialize
 * @returns {Promise<void>}
 */
async function getUser() {
	const isSearchable = ($getHeader().find('#searchKeyword').length !== 0 && $getHeader().find('#searchKeyword').val() != null && $getHeader().find('#searchKeyword').val() !== "")
		|| ($getHeader().find("#searchUserId").length !== 0 && $getHeader().find("#searchUserId").val() != null && $getHeader().find("#searchUserId").val() !== "");
	if (!isSearchable) return;

	const userInfo = await getUserInfo();
	if (userInfo == null) return;
	setUserInfo(userInfo);
}

async function getUserInfo() {
	const response = await fetch("/Employee.do?cmd=getEmployeeHeaderDataMap", {
		method: "POST",
		headers: {
			"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
		},
		body: $("#empForm").serialize()
	});
	const json = await response.json();
	if(json.Message != null && json.Message) {
		alert(json.Message);
		return null;
	}
	return json.DATA;
}

/**
 * 사용자 정보 세팅
 * @param userInfo
 */
function setUserInfo(userInfo) {

	$getHeader().find("#userFace").attr("src","/EmpPhotoOut.do?enterCd=" + userInfo.enterCd + "&searchKeyword=" + userInfo.sabun+"&t=" + (new Date()).getTime());

	$getHeader().find('.emp_name').text(userInfo.empName);
	$getHeader().find('.emp_position').text(userInfo.jikweeNm);
	$getHeader().find('.emp_org').text(userInfo.orgNm);
	$getHeader().find('.emp_status').text(userInfo.statusNm);
	$getHeader().find('.emp_status').addClass(getStatusClassName(userInfo.statusCd));

	// top 기본정보. 변동없음
	$getHeader().find('.emp_job').text(userInfo.jobNm);
	$getHeader().find('.emp_location').text(userInfo.locationNm);
	$getHeader().find('.emp_join_date').text(userInfo.empJoinYmd);
	$getHeader().find('.emp_work_period').text(userInfo.workPeriod);

	renderExpandedWrap(userInfo);

	$("#searchEmpPayType"   ).val(userInfo.payType);
	$("#searchCurrJikgubYmd").val(userInfo.currJikgubYmd);
	$("#searchWorkYyCnt"    ).val(userInfo.workYyCnt);
	$("#searchWorkMmCnt"    ).val(userInfo.workMmCnt);
	$("#searchSabunRef"     ).val(userInfo.sabun);
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

function $getHeader() {
	return $('.header_wrap .header').length === 0 ? $('body') : $('.header_wrap .header');
}

async function renderExpandedWrap(userInfo) {
	const $expandWrap = $getHeader().find('.expand_wrap .label_text_group');
	$expandWrap.empty();

	const headerColInfo = await getEmployeeHeaderInfoList();
	if (headerColInfo == null || headerColInfo.length === 0) return;

	let col;
	for (col of headerColInfo) {
		const bodyHtml = getTxtBodyHtml();
		$expandWrap.append(bodyHtml);
		const $lastBody = $expandWrap.children().last();
		setExpandedWrapColData($lastBody, col, userInfo);
	}
}

async function getEmployeeHeaderInfoList() {
	const response = await fetch("/Employee.do?cmd=employeeHeaderColInfo", {
		method: "POST",
		headers: {
			"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
		},
		body: $("#empForm").serialize()
	});
	const json = await response.json();
	return json.DATA;
}

function getTxtBodyHtml() {
	return `<div class="txt_body_sm">
		       <span class="txt_secondary txt-500"></span>
		       <span class="sb"></span>
		   </div>`;
}

/**
 * 임직원 공통 Header를 펼쳤을 때 데이터를 세팅한다.
 * @param $body
 * @param col
 * @param userInfo
 */
function setExpandedWrapColData($body, col, userInfo) {

	const getValue = (value) => {
		return (value == null || value === "") ? "-" : value;
	}

	let _addText = getAddText(col.addText, userInfo);
	// XSS 공격 대비 html 만 append 후 데이터를 Text 형태로 변환하여 넣는다.
	$body.find(".txt_secondary").text(col.eleNm);
	$body.find(".sb").text(getValue(userInfo[convCamel(col.eleId)[0] + col.eleCd] + _addText));
}

/**
 * 추가 텍스트의 값을 조회하여 실제 화면에 표시될 형태로 출력한다.
 * (@@A06@@) -> (남) 형태로 수정
 * @param addText
 * @param userInfo
 * @returns {*|string}
 */
function getAddText(addText, userInfo) {
	if (addText == null || addText === "") return "";

	let _addText;
	if (addText != null && addText !== "") {
		_addText = addText;
		const arr = addText.match(/@@(.*?)@@/g);
		if (arr != null && arr.length > 0) {
			for (let obj of arr) {
				const baseTxt = obj;
				const eleId = convCamel(baseTxt.replace(/@@/gi, ""))[0];

				const key = Object.keys(userInfo).filter(value => value.startsWith(eleId))[0];
				const value = userInfo[key];
				_addText = _addText.replace(baseTxt, value);
			}
		}
	}

	return _addText;
}

function initEmployeeSearch() {
	const $searchInput = $getHeader().find('#searchKeyword');
	if (!$searchInput.parent().is(".input_search_wrap")) {
		$searchInput.parent().addClass("input_search_wrap");
	}
	if ($searchInput.parent().closest(".ux_wrapper").length === 0) {
		$searchInput.parent().parent().addClass("ux_wrapper");
	}

	if ($searchInput.length > 0) {
		$searchInput.autocomplete(employeeOption()).data("uiAutocomplete")._renderItem = $getEmployeeSearchItem;
	}
}

function employeeOption() {
	return {
		source: function( request, response ) {
			$.ajax({
				url : "/Employee.do?cmd=employeeList",
				dateType : "json",
				type: "post",
				data: $getHeader().find("#empForm").serialize(),
				async: false,
				success: function( data ) {
					response( $.map( data.DATA, function( item ) {
						return {
							label: item.empSabun + ", " + item.enterCd  + ", " + item.enterNm
							,searchNm : $getHeader().find('#searchKeyword').val()
							,enterNm :	item.enterNm	// 회사명
							,enterCd :	item.enterCd	// 회사코드
							,empName :	item.empName	// 사원명
							,empAlias:	item.empAlias	// 호칭
							,empSabun :	item.empSabun	// 사번
							,orgNm :	item.orgNm		// 조직명
							,jikweeNm :	item.jikweeNm	// 직위
							,statusNm :	item.statusNm	// 재직상태명
							,statusCd :	item.statusCd	// 재직상태코드
							,value :	item.empName
							,viewSearchDate :	item.viewSearchDate
						};
					}));
				}
			});
		},
		delay: 50,
		autoFocus: true,
		minLength: 1,
		select: employeeReturn,
		classes: {
			"ui-autocomplete": "result_wrap search_box"
		},
		appendTo: ".input_search_wrap",
		focus: function(event) {
			event.preventDefault();
			return false;
		},
		open: function() {
			$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			
			// 키보드 네비게이션 스타일 적용을 위한 클래스 추가
            $(".ui-autocomplete .ui-menu-item").removeClass("keyboard-active");
            
            // 첫 번째 항목에 호버 스타일 적용 (autoFocus가 true이므로)
            if ($(".ui-autocomplete .ui-menu-item").length > 0) {
                $(".ui-autocomplete .ui-menu-item:first").addClass("keyboard-active");
            }
		},
		close: function() {
			$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
		},
		response: function( event, ui ) {
			if (ui.content.length === 0) {
				ui.content.push({ value: "", label: "" });
			}
		}
	};
}

// 리턴 값
async function employeeReturn( event, ui ) {
	if (ui.item.value === "") {
		$getHeader().find('#searchKeyword').val("");
		$getHeader().find(".input_search_wrap .cancel_btn").toggle(false);
		return;
	}

	$getHeader().find('#searchKeyword').blur();
	$getHeader().find("#searchUserId").val(ui.item.empSabun);
	$getHeader().find("#searchUserEnterCd").val(ui.item.enterCd);
	$getHeader().find("#searchUserStatusCd").val(ui.item.statusCd);
	$getHeader().find("#viewSearchDate").val(ui.item.viewSearchDate);
	await getUser();
	$getHeader().find('#searchKeyword').val("");
	$getHeader().find(".input_search_wrap .cancel_btn").toggle(false);

	//각 페이지 함수 호출
	setEmpPage();
}

//인사기본 상단 이름 검색 시 드롭다운 자동완성
function $getEmployeeSearchItem(ul, item) {
	if (item.value === "") {
		return $("<div/>")
			.addClass("empty")
			.append(`<i class="icon no_result"></i>
			         <span>검색결과가 없습니다.</span>`).appendTo(ul);
	}

	const status = getStatusClassName(item.statusCd);
	return $("<div/>")
		.addClass("profile_wrap")
		.data("item.autocomplete", item)
		.append(`<div class="avatar">
				     <img src="EmpPhotoOut.do?enterCd=${item.enterCd}&searchKeyword=${item.empSabun}&t=${(new Date()).getTime()}"/>
				 </div>
				 <div class="info">
				     <div>
				         <div class="d-flex align-center gap-8">
				             <span class="txt_title_xs_sb">${String(item.empName).split(item.searchNm).join(`<b class="f_blue f_bold">${item.searchNm}</b>`)}</span>
				         	 <span>${item.empSabun}</span>
				         </div>
				         <div>
				         	 <span class="chip ${status}">${item.statusNm}</span>
				         </div>
				     </div>
				     <div class="txt_body_sm txt_tertiary">
						 <span class="txt_body_sm txt_tertiary">${item.jikweeNm}</span>
						 <span class="txt_14 txt_gray">|</span>
				         <span>${item.enterNm}</span>
				         <span class="txt_14 txt_gray">|</span>
				         <span>${item.orgNm}</span>
				     </div>
				 </div>`).appendTo(ul);
}

function initEvent() {
	$getHeader().find(".expand_btn").click(function () {
		const $header = $(this).closest(".header");

		// open 클래스 토글
		$header.toggleClass("open");

		// 아이콘 텍스트 변경
		$(this).text($header.hasClass("open") ? "expand_less" : "expand_more");

		sheetResize();
	})


	const $searchInput = $getHeader().find("input#searchKeyword");
	const $cancelBtn = $getHeader().find(".input_search_wrap .cancel_btn");
	const $resultWrap = $getHeader().find(".input_search_wrap .result_wrap");

	// 입력 시 cancel 버튼 표시/숨김
	$searchInput.on("input", function () {
		const hasValue = $(this).val().length > 0;
		$cancelBtn.toggle(hasValue);
		$resultWrap.toggle(hasValue);
	})

	// cancel 버튼 클릭 시
	$cancelBtn.click(function () {
		$searchInput.val("");
		$(this).hide();
		$resultWrap.hide();
	})

	// 검색창 외부 클릭 시 결과창 닫기
	$(document).click(function (e) {
		if (!$(e.target).closest(".input_search_wrap, .result_wrap").length) {
			$resultWrap.hide()
		}
	})
	
	// 키보드 처리
	$getHeader().find("input#searchKeyword").on("keydown", function(e) {
	    const $items = $(".ui-autocomplete .ui-menu-item");
	    if ($items.length === 0) return;
	    
	    // 현재 선택된 항목 인덱스
	    let currentIndex = $items.index($(".ui-autocomplete .ui-menu-item.keyboard-active"));
	    if (currentIndex === -1) {
	        currentIndex = 0;
	    }
	    let $newActive;
	    
	    // 키보드 이동 처리
	    if (e.keyCode === 40) { // 아래 화살표
	        currentIndex = (currentIndex + 1) % $items.length;
	        e.preventDefault();
	    } else if (e.keyCode === 38) { // 위 화살표
	        currentIndex = currentIndex <= 0 ? $items.length - 1 : currentIndex - 1;
	        e.preventDefault();
	    } else if (e.keyCode === 13 && currentIndex >= 0) { // 엔터
	        e.preventDefault();
	        return;
	    } else {
	        return; // 다른 키는 처리하지 않음
	    }
	    
	    $items.removeClass("keyboard-active");
	    $newActive = $items.eq(currentIndex).addClass("keyboard-active");
	    ensureVisibility($newActive);
	});

	// 선택한 항목이 보이도록 스크롤 조정
	function ensureVisibility($item) {
	    const $container = $(".ui-autocomplete");
	    const containerTop = $container.scrollTop();
	    const containerHeight = $container.height();
	    const itemTop = $item.position().top;
	    const itemHeight = $item.outerHeight();
	    
	    if (itemTop < 0) {
	        $container.scrollTop(containerTop + itemTop);
	    } else if (itemTop + itemHeight > containerHeight) {
	        $container.scrollTop(containerTop + itemTop + itemHeight - containerHeight);
	    }
	}

	// 호버와 키보드 선택을 동기화
	$(document).on("mouseenter", ".ui-autocomplete .ui-menu-item", function() {
	    $(".ui-autocomplete .ui-menu-item").removeClass("keyboard-active");
	    $(this).addClass("keyboard-active");
	});
}

/**
 * 사용자 정보 Clear
 */
function clearUserInfo() {

	$getHeader().find("#userFace").attr("src","");

	$getHeader().find('.emp_name').text("-");
	$getHeader().find('.emp_position').text("-");
	$getHeader().find('.emp_org').text("-");
	$getHeader().find('.emp_status').text("-");

	// top 기본정보. 변동없음
	$getHeader().find('.emp_job').text("-");
	$getHeader().find('.emp_location').text("-");
	$getHeader().find('.emp_join_date').text("-");
	$getHeader().find('.emp_work_period').text("-");

	clearExpandedWrap();

	$("#searchEmpPayType"   ).val("");
	$("#searchCurrJikgubYmd").val("");
	$("#searchWorkYyCnt"    ).val("");
	$("#searchWorkMmCnt"    ).val("");
	$("#searchSabunRef"     ).val("");
}

function clearExpandedWrap() {
	const $expandWrap = $getHeader().find('.expand_wrap .label_text_group');
	$expandWrap.empty();
}