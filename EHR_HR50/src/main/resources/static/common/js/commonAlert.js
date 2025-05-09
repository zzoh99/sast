var isOpenAlertInfo = false;
var alertInfoHtml = "";
$(document).ready(function() {
	/* 2022.03.08 기존 알림 기능과 충돌남에 따라 기존 알림 기능 컨텐츠 출력 영역으로 통합처리함.
	var tmpFrm = $("form #tmpFrm");
	if (tmpFrm.length === 0) {
		tmpFrm = $("<form id=\"tmpFrm\" name=\"tmpFrm\"></form>");
		tmpFrm.appendTo("body");
	}
	
	var _noticeTitle = localeCd !== "en_US" ? "알림" : "Notifications";
	
	//알림 클릭시 DIALOG
	$("#dialogAlertInfo").dialog({
		height:380,
		width:500,
		modal:true,
		closeText:"",
		closeOnEscape: true,
		hideCloseButton: false,
		draggable: false,
		position: {
			my : 'center top',
			at : 'left bottom',
			of : '#alertInfo'
		},
		title: _noticeTitle,
		open : function(){
			$('.ui-dialog-titlebar-close',$(this).parent()).hide();
			$('.ui-widget-overlay').bind('click', function() { $('#dialogAlertInfo').dialog('close'); });
			var iframe = $("iframe#iframeAlertInfo");
			if(iframe[0].contentWindow.doActionAlertInfo){
				iframe[0].contentWindow.doActionAlertInfo();
			}else{
				iframe.load(function() {
					iframe[0].contentWindow.doActionAlertInfo();
				});
			}
			if(!isOpenAlertInfo){
				submitCall(tmpFrm,"iframeAlertInfo","post","/viewAlertInfo.do");
				isOpenAlertInfo = true;
			}
			setAlertInfoCnt();
			
			var title = localeCd == "ko_KR" ? "알람" : "Notification";
			$("#ui-id-4, .ui-dialog-title").html(title);
		},
		close:function(){
			setAlertInfoCnt();
		},
		autoOpen:false
	});
	var alertInfo = $("#alertInfo");
	alertInfo.on("click",function(){
		if (popupClose != null && typeof(popupClose) === "function") {
			popupClose("notification")
		}
		$("#dialogAlertInfo").dialog("open");
	});
	alertInfoHtml = alertInfo.html();
	*/
	
	var notiFloating = $('#noti-floating');
	if (notiFloating.length > 0) {
		notiFloating.hover(function () {
			$(this).css("border", "1px solid #FF6417");
			stayRecentAlert()
		}, function () {
			$(this).css("border", "1px solid #fff");
		});
	}
	
	setAlertInfoCnt();

});


// 최근 알림 조회 및 플로팅 세팅(5초 후 fadeOut)
var toRecentAlert;
var recentSeq;
var recentLink;

// 알림 마우스 오버시 fadeOut 취소
function stayRecentAlert() {
	clearTimeout(toRecentAlert);
}

// 알림 링크 바로가기
function goDirectRecentAlert(link, seq) {
	openPopup(link,"",900,600);
	
	if (seq !== undefined && seq !== null) {
		readRecentAlert(seq);
	}
}

// 최근 알림을 삭제
function deleteRecentAlert(seq) {
	$.ajax({
		url :"/deleteAllAlert.do",
		dateType : "json",
		type:"post",
		data: {seq:seq},
		success: function( data ) {
			if(data.Message !== ""){
				alert(data.Message);
			}else{
				setAlertInfoCnt();
				$('#noti-floating').fadeOut(500);
			}
		},
		error:function(e){
			alert(e.responseText);
			$('#noti-floating').fadeOut(500);
		}
	});
}

// 최근 알림을 업데이트(READ_YN = 'Y')
function readRecentAlert(seq) {
	$.ajax({
		url :"/updateAlertInfoReadYn.do",
		dateType : "json",
		type:"post",
		data: {seq:seq},
		success: function( data ) {
			if(data.Message !== ""){
				alert(data.Message);
			}else{
				setAlertInfoCnt();
				$('#noti-floating').fadeOut(500);
			}
		},
		error:function(e){
			alert(e.responseText);
			$('#noti-floating').fadeOut(500);
		}
	});
}

// 알림 리스트 카운트
function setAlertInfoCnt(){
	ajaxCall2("/getAlertInfoCnt.do", "", true, function(){}, function(result){
		var cnt = result.Result;
		var alertInfo = $("#alertInfo");
		alertInfo.html(alertInfoHtml);
		if(cnt>0) {
			alertInfo.append("<span class=\"badge\">"+cnt+"</span>");
		}
	});
}

//중복 로그인 체크
function setDupAlert(){

	alert("같은 ID로 다른장소(다른 브라우저, 다른 디바이스)에서  접속중입니다. 현재 접속중인  접속을 종료합니다. \n\n[경고창 발생원인]\n" +
			"1. 정상적인 로그아웃을 하지 않았을 경우 발생(30분 이내)\n" +
			"2. 타 사용자가 접속시도 중인 계정으로 로그인한 경우\n\n" +
			"※해킹 의심 시 패스워드 변경을 권고 드립니다.");
	
	location.href = "/Login.do";
	
}

