//프로세스 맵 처음화면
let processMapList = [];

$(document).ready(async function() {

	let initTab = $(".tab_menu").first();
	$(initTab).addClass("active");
	// 프로세스맵 조회
	fetchProcessMapListForUser(initTab);
	
	onTabMenuClick();
	
	// 프로세스맵 적용화면
	// 하단 스와이퍼
	document.querySelectorAll(".btn_area button").forEach((button) => {
		button.addEventListener("mousedown", (e) => {
			e.preventDefault();
		});
	});

//	$(".icon_area").on("click", function() {
//		$(".bar_content").toggleClass("hidden");
//	});
//
//	$(".btn.left").on("click", function() {
//		$(".btn").removeClass("active");
//		var btnArea = $(this).closest(".btn_area");
//		btnArea.find(".btn").addClass("active");
//	});
});

//======프로세스 맵 처음화면==========

//프로세스 맵목록 조회 시 목록 그리기
function drawProcessMapListForUser(data) {
	processMapList = data.procMapList;
	$(".process_map_wrap").empty();
	
	if(processMapList.length<1){
		$(".process_map_wrap").addClass("no_content");
		$(".process_map_wrap").append('<img src="" alt=""><p>해당 내용이 없습니다.</p>');
		setRandomImage();
		return
	}else{
		$(".process_map_wrap").removeClass("no_content");		
	}
	
	let idx = 0;
	let noChildren=0;
	for (idx = 0; idx < processMapList.length; idx++) {
		if (processMapList[idx].children.length >= 1) {
		$(".process_map_wrap").append('<div class="toggle_wrap"></div>');
		let lastToggleWrap = $(".process_map_wrap .toggle_wrap").last()
		$(lastToggleWrap).append(
			'<div class="toggle_menu">' +
			'<div class="title">' +
			'<i class="mdi-ico"></i><spa>' + processMapList[idx].procMapNm + '</span>' +
			'</div>' +
			'<i class="mdi-ico">keyboard_arrow_down</i>' +
			'</div>');
		$(lastToggleWrap).append('<div class="toggle_content"></div>');
		let lastToggleContent = $(".process_map_wrap .toggle_wrap .toggle_content").last();

		// 프로세스 맵이 존재하는 경우
			// 카드 추가
			let childrenIdx = 0;
			$(lastToggleContent).append('<div class="map_box_wrap"></div>');
			for (childrenIdx = 0; childrenIdx < processMapList[idx].children.length; childrenIdx++) {
				let tempProcess = processMapList[idx].children[childrenIdx];
				$(lastToggleContent).children().first().append(
					'<div class="map_box" onclick="openProcMapIframe(\''+tempProcess.procSeq+'\')">'+
					'<div class="title_area">' +
					'<div>' +
					'<span class="number">' + tempProcess.seq + '</span>' +
					'<span class="title">' + tempProcess.procNm + '</span>' +
					'</div>' +
					'<i class="mdi-ico filled">library_books</i>' +
					'</div>' +
					'<div class="speech_bubble">' + tempProcess.memo + '</div>'+
					'<form id=' + tempProcess.procSeq + ' onsubmit="return false">' +
					'<input type="hidden" name="procMapSeq" value="' + tempProcess.procMapSeq + '" />' +
					'<input type="hidden" name="location" value="' + tempProcess.location + '" />' +
					'<input type="hidden" name="procNm" value="' + tempProcess.procNm + '" />' +
					'<input type="hidden" name="surl" value="' + tempProcess.surl + '" />' +
					'<input type="hidden" name="murl" value="' + tempProcess.murl + '" />' +
					'<input type="hidden" name="menuId" value="' + tempProcess.menuId + '" />' +
					'<input type="hidden" name="prgPath" value="' + tempProcess.prgPath + '" />' +
					'<input type="hidden" name="helpTxtTitle" />' +
					'<textarea style="display:none" name="helpTxtContent" form="' + tempProcess.procSeq + '"></textarea>' +
					'<input type="hidden" name="fileSeq" value="' + tempProcess.fileSeq + '" />' +
					'</from>'
				);
				// jQuery append 시 helpTxtContent 의 원문이 변형되는 케이스가 발견되어 append 이후 value 지정하는 것으로 변경.
				$("#"+tempProcess.procSeq).find("input[name=helpTxtTitle]").val(tempProcess.helpTxtTitle);
				$("#"+tempProcess.procSeq).find("textarea[name=helpTxtContent]").val(tempProcess.helpTxtContent);
				if (tempProcess.helpTxtTitle == "") {
					$(lastToggleContent).find(".mdi-ico").last().css("display", "none");
				}
				if (tempProcess.memo == "") {
					$(lastToggleContent).find(".speech_bubble").last().css("display", "none");
				}
			}
		}else{
			noChildren++
		} 
	}
	
	if(processMapList.length==noChildren){
		$(".process_map_wrap").addClass("no_content");
		$(".process_map_wrap").append('<img src="" alt=""><p>해당 내용이 없습니다.</p>');
		setRandomImage();
		return
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
	
	$(".map_box_wrap .mdi-ico").click(function(e) {
		e.stopPropagation();
		let procSeq=$(this).closest(".map_box").find("form").attr("id");
		let tempProc = $("#" + procSeq);
		let helpTxtTitle = $(tempProc).find("input[name=helpTxtTitle]").val();
		let helpTxtContent = $(tempProc).find("textarea[name=helpTxtContent]").val();
		let fileSeq = $(tempProc).find("input[name=fileSeq]").val();
		processMapLinkBarUtil.openHelpModal(procSeq,helpTxtTitle,helpTxtContent,fileSeq);
	});
}

//프로세스 맵 목록 조회
function fetchProcessMapListForUser(ele) {
	let params = {
		mainMenuCd: $(ele).attr("value")
	}
	
	loadingUtil.on();
	setTimeout(
		function () {
			ajaxCall3(
				"/ProcessMap.do?cmd=getProcessMapList",
				"get",
				params,
				false,
				null,
				function(data){
					drawProcessMapListForUser(data);
					loadingUtil.off();
				},
				loadingUtil.off,
	)},300)
}

function openProcMapIframe(procSeq) {
	let tempProc = $("form#"+procSeq);
	let procNm = $(tempProc).find("input[name=procNm]").val();
	let prgPath = $(tempProc).find("input[name=prgPath]").val();
	let location = $(tempProc).find("input[name=location]").val();
	let surl = $(tempProc).find("input[name=surl]").val();
	let murl = $(tempProc).find("input[name=murl]").val();
	let menuId = $(tempProc).find("input[name=menuId]").val();
	let procMapSeq = $(tempProc).find("input[name=procMapSeq]").val();
	let procMapLinkBarInfo={procMapSeq:procMapSeq,procSeq:procSeq};

	window.top.processMapLinkBarUtil.open(
		procNm,
		prgPath,
		location,
		surl,
		murl,
		menuId,
		procMapLinkBarInfo
	);
}