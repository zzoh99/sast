var loadObj = {
	config : {
		
	},
	/**
	 * 조회중 표시를 위한 Block 영역 생성
	 */
	showBlockUI : function() {
		var str = "조회중입니다. 잠시만 기다려주세요.";
		
		$.blockUI({
			message: '<div><img src="/common/plugin/IBLeaders/Org/IBOrgSharp5/img/busy.gif" /> ' + str + '</div>',
			css: {
				border: 'none', 
				padding: '15px', 
				backgroundColor: '#FFF', 
				'-webkit-border-radius': '8px', 
				'-moz-border-radius': '8px', 
				'border-radius': '8px', 
				color: '#333' 
			}
		});
	},
	/**
	 * Block 영역 삭제
	 */
	hideBlockUI : function() {
		$.unblockUI();
	}
};

$(function() {
	// 트리, 탭을 표시하기  표현을 위한 설정

	// 초기엔 전체 탭 영역 숨김
	$(".tab_content").hide();

	// 첫번째 탭 영역을 보이게 함.
	$(".tab_content:first").show();
	
	// 탭 관련 클릭 이벤트
	$("ul.tabs li").click(function () {
	    $("ul.tabs li").removeClass("active");
	    $(this).addClass("active");
	    $(".tab_content").hide();
	    var activeTab = $(this).attr("rel");
	    $("#" + activeTab).fadeIn();
	});
	
	// 최초 조회시 첫번째 탭이 선택되도록 함.
	$("ul.tabs li:first").click();
});