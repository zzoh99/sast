
let selectedOtion = {
	authGrp: null,
	mainMenu: null
};

let searchedOption = {
	//실제 검색한 값, 프로세스 추가 시 작업 중인 프로세스 값들이랑 비교
	authGrp: null,
	mainMenu: null,
	//선택만 하고 실제로 검색을 안했을 경우 임시 저장
	tempAuthGrp: null,
	tempMainMenu: null,
}
let deletedProc = [];

$(document).ready(async function() {
	$("#procMap_authGrp_select").change(function() {
		searchedOption.tempAuthGrp = {
			grpNm: $(this).find('option[value="' + $(this).val() + '"]').attr("name"),
			grpCd: $(this).val()
		};
	});

	$("#procMap_menu_select").change(function() {
		searchedOption.tempMainMenu = {
			mainMenuNm: $(this).find('option[value="' + $(this).val() + '"]').attr("name"),
			mainMenuCd: $(this).val()
		};
	});

	// 프로세스맵 에디터
	$("textarea").on("input", function() {
		$(this).css("height", "auto");
		$(this).css("height", this.scrollHeight + "px");
	});

	if (!$("#sortable").hasClass("viewer")) {
		$("#sortable").sortable({
			start: function(event, ui) {
				let memo = ui.item.find(".map_memo");
				if (memo.is(":visible")) {
					memo.data("wasVisible", true).hide();
				}
				ui.item.find(".map_box_btn").hide();
			},
			stop: function(event, ui) {
				let memo = ui.item.find(".map_memo");
				if (memo.data("wasVisible")) {
					memo.show().removeData("wasVisible");
				}
				ui.item.find(".map_box_btn").show();
			},
			update: function(event, ui) {
				renewSeq();
			},
			containment: ".edit_wrap",
		});
	}
		
		
	

});

// 수정하기로 들어왔을 때 및 현재 작업 중인 [권헌,분류]와 다른 프로세스를 추가했을 경우
function selectedOtionSetting(authGrp, mainMenu) {
	selectedOtion.authGrp = {
		grpNm: authGrp.grpNm,
		grpCd: authGrp.grpCd
	};
	selectedOtion.mainMenu = {
		mainMenuNm: mainMenu.mainMenuNm,
		mainMenuCd: mainMenu.mainMenuCd
	};
	$("#selected-authGrpNm-val").text(selectedOtion.authGrp.grpNm);
	$("#selected-mainMenuNm-val").text(selectedOtion.mainMenu.mainMenuNm);
}

// 프로세스들의 좌측 상단 순서 번호 갱신
function renewSeq() {
	let numbers = $(".number");
	let numberIdx = 0;
	for (numberIdx = 0; numberIdx < numbers.length; numberIdx++) {
		$(numbers[numberIdx]).text(numberIdx + 1);
		$(numbers[numberIdx]).closest('.box_wrap').find("input[name=seq]").val(numberIdx + 1);
	}
}

//좌측 메뉼 리스트 조회
function fetchMenuList() {
	//temp 콤보복스에서 UI적으로 선택되어 있는 값
	if (searchedOption.tempAuthGrp && searchedOption.tempMainMenu) {
		searchedOption.authGrp = {
			grpNm: searchedOption.tempAuthGrp.grpNm,
			grpCd: searchedOption.tempAuthGrp.grpCd
		};
		searchedOption.mainMenu = {
			mainMenuNm: searchedOption.tempMainMenu.mainMenuNm,
			mainMenuCd: searchedOption.tempMainMenu.mainMenuCd
		};
		let params = {
			grpCd: searchedOption.authGrp.grpCd,
			mainMenuCd: searchedOption.mainMenu.mainMenuCd,
			procMapSeq: procMap.procMapSeq
		};
		ajaxCall3(
			"/ProcessMapMgr.do?cmd=getMenuList",
			"get",
			params,
			true,
			null,
			renewMenuList
		);
	} else {
		alert("검색 조건을 선택해주세요.");
	}
}

// 메뉴 리스트 그리기(추가버튼 추가)
function renewMenuList(rtnData) {
	let menuList = rtnData.menuList.map((menu) => {
		return { ...menu, "sButton": menu.type == "M" ? null : "추가" }
	});
	sheet0.LoadSearchData({ "data": menuList });
	sheet0.ShowTreeLevel(0, 1);
}

//메뉴 검색 input 내용 삭제
function clearMenuSearchInput() {
	$("#menu_search_iniput").val("");
}

function drawProcList(data) {
	let forms = $("form");
	// 좌측 메뉴에서 추가한 프로세스가 작업중인 프로세스와 권한 또는 분류가 다를 시
	// 기존에 있던 프로세스들을 전부 삭제 리스트에 추가
	if (data.procList.length < 1 && forms.length > 0) {
		let formIdx = 0;
		for (formIdx = 0; formIdx < forms.length; formIdx++) {
			deletedProc.push($(forms[formIdx]).attr("id"));
		}
	}
	procList = data.procList
	
	$("#sortable").empty();
	
	if(procList.length<1){
		setPorcAreaUI(false);
		return
	}

	let proIdx = 0
	
	for (proIdx = 0; proIdx < procList.length; proIdx++) {
		addProc(procList[proIdx], false);
	}

	$("textarea[name=memo]").on('input', function() {
		$(this).closest('.map_memo').find(".text_count").text(+$(this).val().length + " / 70");
	});

}

//프로세스 맵 목록 조회
function fetchProcList() {
	let params = {
		"procMapSeq": procMap.procMapSeq
	}
	ajaxCall3(
		"/ProcessMapMgr.do?cmd=getProcessList",
		"get",
		params,
		false,
		null,
		drawProcList
	);
}

//도움말 모달 열기
/*
	procSeq: 프로세스SEQ(ID)
	isHelpEditor: 열려고 하는 도움말 모달(에디터면 true, viwer면 fasle)
 	procViewMode: 현재 화면이 프로세스맵 (에디터,editor)인지, (뷰어,viewer)인지
*/
function openHelpModal(procSeq, isHelpEditor, procViewMode) {
	let tempProc = $("#" + procSeq);
	let option;
	let helpTxtTitle = $(tempProc).find("input[name=helpTxtTitle]").val();
	let helpTxtContent = $(tempProc).find("textarea[name=helpTxtContent]").val();
	let fileSeq = $(tempProc).find("input[name=fileSeq]").val();
	
	//작성된 도움말이 없으면 도움말 작성 모드
	if (helpTxtTitle == "" && helpTxtContent == "") {
		isHelpEditor = true;
	}

	if (isHelpEditor) {
		option = {
			scriptVariableNm: "modalScript",
			type: "url",
			url: "/ProcessMapMgr.do?cmd=viewProcessMapHelpEditorPop",
			title: "도움말 작성",
			useDimAutoClose: false,
			callback: helpEditorModalCallback,
			params: {
				procSeq: procSeq,
				fileSeq: fileSeq,
				authPg:'A',
				helpTxtTitle: helpTxtTitle,
				helpTxtContent: helpTxtContent
			}
		};
	} else {
		option = {
			scriptVariableNm: "modalScript",
			type: "url",
			url: "/ProcessMapMgr.do?cmd=viewProcessMapHelpPop",
			title: "도움말",
			callback: helpViwerModalCallback,
			params: {
				procViewMode: procViewMode,
				procSeq: procSeq,
				fileSeq: fileSeq,
				authPg:'R',
				helpTxtTitle: helpTxtTitle,
				helpTxtContent: helpTxtContent
			}
		};
	}
	window.top.modalUtil.open(option);
}


function helpViwerModalCallback(callbackData) {
	let action = callbackData.action;
	let procSeq = callbackData.procSeq;

	if (action == "D") {
		let tempProc = $("#" + procSeq);
		$(tempProc).find("input[name=helpTxtTitle]").val("");
		$(tempProc).find("textarea[name=helpTxtContent]").val("");
		$(tempProc).closest(".box_wrap").find(".head div i").first().remove();
		alert("도움말이 삭제 되었습니다. 프로세스맵을 저장 시 삭제완료됩니다.")
	} else {
		openHelpModal(procSeq, true);
	}
}

function helpEditorModalCallback(callbackData) {
	let procSeq = callbackData.procSeq;
	let helpTxtTitle = callbackData.helpTxtTitle;
	let helpTxtContent = callbackData.helpTxtContent;
	let fileSeq = callbackData.fileSeq
	let tempProc = $("#" + procSeq);
	
	let preHelpTxtTitleInput = $(tempProc).find("input[name=helpTxtTitle]")
	let preHelpTxtContentTxtarea = $(tempProc).find("textarea[name=helpTxtContent]")
	
	let iconDiv=$(tempProc).closest(".box_wrap").find(".head div").not("div.number");
	
	//수정/생성한 적이 없으면				
	if(!$(iconDiv).children("i").first().hasClass("updated")){
		if($(iconDiv).find("i").length<2){
			$(iconDiv).prepend(
				'<i class="mdi-ico filled" onclick="openHelpModal(' + procSeq + ',' + false + ',\'editor\')">library_books</i>');
		}
		$(iconDiv).children("i").first().addClass("updated");
	}
	
	$(tempProc).find("input[name=helpTxtTitle]").val(helpTxtTitle);
	$(tempProc).find("textarea[name=helpTxtContent]").val(helpTxtContent);
	$(tempProc).find("input[name=fileSeq]").val(fileSeq);
	
}

function setPorcAreaUI(isProcExist){
	if(isProcExist){
		$("#sortable").show();
		$(".no_content").hide();
	}else{
		$("#sortable").hide();
		$(".no_content").show();
		setRandomImage();		
	}	
}


// 프로세스맵 에디터
function addProc(proc, isNew) {
	const length = $(".box_wrap").length;

	if (length > 7) {
		alert("최대8개까지 추가할 수 있습니다.");		
		return false;
	}

	if (isNew) {
		proc.seq = length + 1;
		setPorcAreaUI(true);
	}

	let isEditor = $(".viewer").length < 1;

	$("#sortable").append(
		'<div class="box_wrap">' +
		'<div class="map_box_btn">' +
		'<button class="help" onclick="openHelpModal(' + proc.procSeq + ',' + false + ',\'editor\')"><i class="mdi-ico">drive_file_rename_outline</i><span>도움말</span></button>' +
		'<button class="memo" onclick="editMemo(this,' + proc.procSeq + ')"><i class="mdi-ico">description</i><span>메모</span></button>' +
		'</div>' +
		'</div>');
	let lastBoxrap = $("#sortable .box_wrap").last();
	$(lastBoxrap).append(
		'<div class="map_box">' +
		'<div class="head">' +
		'<div class="number">' + proc.seq + '</div>' +
		'</div>' +
		'<div class="title">' + proc.procNm + '</div>' +
		'</div>');
	$(lastBoxrap).find(".head").append('<div></div>')

	if (isEditor) {
		$(lastBoxrap).find(".head div").last().append(
			'<i class="mdi-ico" onclick="deleteProc(' + proc.procSeq + ')">close</i>');
	}

	if (proc.helpTxtTitle != "") {
		let procViewMode = isEditor ? "editor" : "viewer";
		$(lastBoxrap).find(".head div").last().prepend(
			'<i class="mdi-ico filled" onclick="openHelpModal(' + proc.procSeq + ',' + false + ',\'' + procViewMode + '\')">library_books</i>');
	}

	$(lastBoxrap).append(
		'<form id=' + proc.procSeq + ' onsubmit="return false">' +
		'<input type="hidden" name="procSeq" value="' + proc.procSeq + '" />' +
		'<input type="hidden" name="enterCd" value="' + proc.enterCd + '" />' +
		'<input type="hidden" name="memo" value="' + proc.memo + '" />' +
		'<input type="hidden" name="helpTxtTitle" />' +
		'<textarea style="display:none" name="helpTxtContent" form="' + proc.procSeq + '"></textarea>' +
		'<input type="hidden" name="fileSeq" value="' + proc.fileSeq + '" />' +
		'<input type="hidden" name="procNm" value="' + proc.procNm + '" />' +
		'<input type="hidden" name="seq" value="' + proc.seq + '" />' +
		//	'<input type="hidden" name="menuCd" value="'+proc.menuCd+'" />'+
		//	'<input type="hidden" name="menuSeq" value="'+proc.menuSeq+'" />'+
		//	'<input type="hidden" name="procMapSeq" value="'+proc.procMapSeq+'" />'+
		//	'<input type="hidden" name="priorMenuCd" value="'+proc.priorMenuCd+'" />'+
		//	'<input type="hidden" name="prgPath" value="'+proc.prgPath+'" />'+
		//	'<input type="hidden" name="mainMenuCd" value="'+proc.mainMenuCd+'" />'+
		'</from>' +
		'<div class="map_memo">' +
		'<span>' + proc.memo + '</span>' +
		'<textarea name="memo" form="' + proc.procSeq + '" maxlength="70">' + proc.memo + '</textarea>' +
		'<div class="footer">' +
		'<span class="text_count">' + proc.memo.length + ' / 70</span>' +
		'<button class="cancel_btn" onclick="cancelMemo(this)"><i class="icon-close-circle-dark"></i>취소</button>' +
		'<button class="save_btn" onclick="saveMemo(this,' + proc.procSeq + ')"><i class="icon-check-circle-dark"></i>저장하기</button>' +
		'</div>' +
		'</div>');
	// jQuery append 시 helpTxtContent 의 원문이 변형되는 케이스가 발견되어 append 이후 value 지정하는 것으로 변경.
	$(lastBoxrap).find("#" + proc.procSeq).find("input[name=helpTxtTitle]").val(proc.helpTxtTitle);
	$(lastBoxrap).find("#" + proc.procSeq).find("textarea[name=helpTxtContent]").val(proc.helpTxtContent);

	if (proc.memo == "") {
		$(lastBoxrap).find(".map_memo").css("visibility", "hidden")
	}

	if (isNew) {
		$("textarea[name=memo]").off('input');
		$("textarea[name=memo]").on('input', function() {
			$(this).closest('.map_memo').find(".text_count").text($(this).val().length + " / 70");
		});
	}
	
	return true;
}

function deleteProc(procSeq) {
	let delProcNm = $("#" + procSeq).find("input[name=procNm]").val();

	deletedProc.push(procSeq)
	$("#" + procSeq).closest('.box_wrap').remove();

	renewSeq();

	let isOtherExist = false;
	let formInputIdx = 0;
	let formInput = $("form").find("input[name=procNm]")

	for (formInputIdx = 0; formInputIdx < formInput.length; formInputIdx++) {
		if ($(formInput[formInputIdx]).val() == delProcNm) {
			isOtherExist = true;
			break;
		}
	}

	if (!isOtherExist) {
		let row = sheet0.FindText("menuNm", delProcNm);
		sheet0.SetCellFontColor(row, 0, "#555555");
	}
	
	if(formInput.length<1){
		setPorcAreaUI(false);
	}	
}

function editMemo(ele, procSeq) {
	let $processMemo = $(ele).closest(".box_wrap").find(".map_memo");
	$processMemo.css("visibility", "visible");
	$processMemo.addClass("update");
}

function cancelMemo(ele) {
	let $processMemo = $(ele).closest(".box_wrap").find(".map_memo");
	$processMemo.find("textarea").val($processMemo.find("span").first().text());
	if ($processMemo.find("textarea[name=memo]").val() == "") {
		$processMemo.css("visibility", "hidden");
	}
	$processMemo.find(".text_count").text($processMemo.find("textarea[name=memo]").val().length + " / 70");
	$processMemo.removeClass("update");
}

function saveMemo(ele, procSeq) {
	let $processMemo = $(ele).closest(".box_wrap").find(".map_memo");
	let memo = $processMemo.find("textarea").val();
	let tempProc = $("#" + procSeq);
	$processMemo.find("span").first().text(memo);
	$(tempProc).find("textarea[name=memo]").val(memo);
	if (memo == "") {
		$processMemo.css("visibility", "hidden");
	}
	$processMemo.removeClass("update");
}

function saveProcMap(status) {
	let procMapNm = $("#procMapNm_input").val();
	let forms = $("form")
	if (!selectedOtion.authGrp || !selectedOtion.mainMenu || procMapNm == "") {
		alert("프로세스 맵 정보를 입력해주세요.");
		return;
	}
	
	if (forms.length < 1) {
		if (!confirm("등록된 프로세스가 없습니다. 저장하시겠습니까?")) {
			return;
		}
	}

	let formIdx = 0;
	let procSeqList = [];
	for (formIdx = 0; formIdx < forms.length; formIdx++) {
		let tempProc = {};
		let serializeFormIdx = 0;
		let serializeForm = $(forms[formIdx]).serializeArray();
		for (serializeFormIdx = 0; serializeFormIdx < serializeForm.length; serializeFormIdx++) {
			tempProc = { ...tempProc, [serializeForm[serializeFormIdx].name]: serializeForm[serializeFormIdx].value }
		}
		
		procSeqList.push(tempProc);

	}

	let params = {
		procMapSeq: procMap.procMapSeq,
		mainMenuCd: selectedOtion.mainMenu.mainMenuCd,
		grpCd: selectedOtion.authGrp.grpCd,
		status: status,
		procMapNm: procMapNm,
		procSeqList: procSeqList,
		deleteProcSeqList: deletedProc,
	};

	ajaxCall3(
		"/ProcessMapMgr.do?cmd=saveProcessMap",
		"post",
		JSON.stringify(params),
		false,
		null,
		function(data) {
			if (status == "Y") {
				alert("저장되었습니다.");
			} else {
				alert("임시저장되었습니다.");
			}
			goStartPage();
		});
}

function deleteProcMap() {
	if (!confirm("프로세스맵을 삭제하시겠습니까?")) {
		return;
	}

	let params = { procMapSeq: procMap.procMapSeq };
	ajaxCall3(
		"/ProcessMapMgr.do?cmd=delProcessMap",
		"post",
		JSON.stringify(params),
		false,
		null,
		function(data) {
			alert("삭제되었습니다.");
			goStartPage();
		})
}

function cancelEditing(){	
	if (!confirm("프로세스 맵을 저장하지 않았다면 수정사항은 사라집니다. 작업을 그만두시겠습니까? ")) {
		return;
	}
	if(procMap.selectedGrpCd==""&&procMap.selectedMainMenuCd==""){
		goStartPage();
	}else{
		goViewerPage(procMap.procMapSeq);		
	}
}


// 페이지 이동
function goEditPage() {
	window.location.href = "/ProcessMapMgr.do?cmd=viewEditProcessMap";
}

function goViewerPage(procMapSeq) {
	window.location.href = "/ProcessMapMgr.do?cmd=viewViewerProcessMap&procMapSeq=" + procMapSeq;
}

function goStartPage() {
	window.location.href = "/ProcessMapMgr.do?cmd=viewProcessMapMgr";
}
