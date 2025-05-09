//프로세스 맵 처음화면
let selectedAuthGrp = { grpNm: "전체", grpCd: "" };
let processMapList = [];
let authGrpList = [];

$(document).ready(async function() {

	// 토글 권한 선택 클릭이벤트
	selectAuthGrpOption();
	selectedAuthGrp = {
			grpNm: $("#authGrp_select").find('option[value="' + $("#authGrp_select").val() + '"]').attr("name"),
			grpCd: $("#authGrp_select").val()
	};
	// 프로세스맵 조회
	fetchProcessMapList();


});

//======프로세스 맵 처음화면==========

//프로세스 맵목록 조회 시 목록 그리기
function drawProcessMapList(data) {
	processMapList = data.processMapList;
	authGrpList = data.authGrpList;
	$(".process_map_wrap").empty();
	let idx = 0;
	for (idx = 0; idx < processMapList.length; idx++) {
		$(".process_map_wrap").append('<div class="toggle_wrap"></div>')
		let lastToggleWrap = $(".process_map_wrap .toggle_wrap").last()
		$(lastToggleWrap).append(
			'<div class="toggle_menu">' +
			'<div class="title">' +
			'<i class="mdi-ico filled">' + processMapList[idx].icon + '</i>' +
			'<span class="title">' + processMapList[idx].mainMenuNm + '</span>' +
			'</div>' +
			'<i class="mdi-ico">keyboard_arrow_down</i>' +
			'</div>');
		$(lastToggleWrap).append('<div class="toggle_content"></div>');
		let lastToggleContent = $(".process_map_wrap .toggle_wrap .toggle_content").last();

		// 프로세스 맵이 존재하는 경우
		if (processMapList[idx].children.length >= 1) {
			//메뉴 열린 상태로 만들기
			$(lastToggleContent).css('display', 'block');
			$(lastToggleWrap).children(".toggle_menu").children("i").text("keyboard_arrow_up");

			// 카드 추가
			let childrenIdx = 0;
			$(lastToggleContent).append('<div class="map_box_wrap"></div>');
			for (childrenIdx = 0; childrenIdx < processMapList[idx].children.length; childrenIdx++) {
				let tempProcessMapp = processMapList[idx].children[childrenIdx];
				$(lastToggleContent).children().first().append('<div class="map_box" onclick="goViewerPage(' + tempProcessMapp.procMapSeq + ')">' +
					'<div class="title_area">' +
					'<span>' + tempProcessMapp.procMapNm + '</span>' +
					'</div>' +
					'<div class="tip_area"></div>' +
					'</div>')
				if (tempProcessMapp.favoriteYn == "Y") {
					$(".process_map_wrap .toggle_content .title_area").last().append('<i class="icon-star"></i>');
				}
				if (tempProcessMapp.status == "T") {
					$(".process_map_wrap .toggle_content .tip_area").last().append('<span class="tip color_1">임시저장</span>');
				}
				$(".process_map_wrap .toggle_content .tip_area").last().append('<span class="tip color_' + tempProcessMapp.grpCd + '">' + tempProcessMapp.grpNm + '</span>');
			}
		} else {
			$(lastToggleContent).append(
				'<div class="no_data">' +
				'<i class="mdi-ico">add_box</i><span>프로세스맵이 없습니다.<br/>생성하기 버튼을 눌러 프로세스맵을 만들어주세요.</span>' +
				'</div>')

		}

	}
	$(".process_map_wrap .toggle_menu").click(function() {
		var content = $(this).next(".toggle_content");
		var icon = $(this).children("i");

		$(".process_map_wrap .toggle_menu").not(this).removeClass("active");

		if (content.is(":visible")) {
			$(this).removeClass("active");
			content.slideUp(100);
			icon.text("keyboard_arrow_down");
		} else {
			$(this).addClass("active");
			content.slideDown(100);
			icon.text("keyboard_arrow_up");
		}
	});
}

//콤보 박스 권한 선택
function selectAuthGrpOption() {	
	$("#authGrp_select").change(function() {
		selectedAuthGrp = {
			grpNm: $(this).find('option[value="' + $(this).val() + '"]').attr("name"),
			grpCd: $(this).val()
		};
		fetchProcessMapList();
	});
}

//프로세스 맵 목록 조회
function fetchProcessMapList() {
	let params = {
		grpCd: selectedAuthGrp.grpCd != "" ? selectedAuthGrp.grpCd : null
	}
	
	loadingUtil.on();
	setTimeout(
		function () {
			ajaxCall3(
				"/ProcessMapMgr.do?cmd=getProcessMapList",
				"get",
				params,
				false,
				null,
				function(data){
					drawProcessMapList(data);
					loadingUtil.off();
				},
				loadingUtil.off,
	)},300);
}

// 페이지 이동
function goEditPage() {
	window.top.loadingUtil.on();
	window.location.href = "/ProcessMapMgr.do?cmd=viewEditProcessMap"
}

function goViewerPage(procMapSeq) {
	window.location.href = "/ProcessMapMgr.do?cmd=viewViewerProcessMap&procMapSeq=" + procMapSeq;
}

// 모달
// 즐겨찾기
function openBookmarkModal() {
	let option = {
		scriptVariableNm: "modalScript",
		type: "url",
		url: "/ProcessMapMgr.do?cmd=viewFavoriteList",
		title: "즐겨찾기",
		useDimAutoClose: false,
		callback: fetchProcessMapList
	};
	window.top.modalUtil.open(option)
}