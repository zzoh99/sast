<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 채용 현황
	 */

	var widget207 = {
		size: null
	};

	var recruitOption = '';

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox207(size) {
		widget207.size = size;
		
		if (size == "normal"){
			createWidgetMini207();
			setDataWidgetMini207();
		} else if (size == ("wide")){
			createWidgetWide207();
			setDataWidgetWide207();
		}
	}

	// 위젯 html 코드
	function createWidgetMini207(){
		var code =
				'<div class="widget_header">' +
				'  <div class="widget_title">채용 현황</div>' +
				'</div>' +
				'<div class="widget_body attend-status widget-common widget-more">' +
				'  <div class="sub-title" id="recruitPeriod"> </div>' +
				'  <div class="bookmarks_title">' +
				'    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
				'    <span id="recruitType"></span>' +
				'    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
				'  </div>' +
				'  <div class="container_info">' +
				'    <span class="info_title_num" id="recruitCnt"></span>' +
				'    <span class="info_title desc" id="recruitGapRate"></span>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget207Element').innerHTML = code;
	}

	// 위젯 mini 테이터
	function setDataWidgetMini207(recruitMiniOption){
		// 올해 1월 1일 ~현재 날짜 넣기 
		var nowDate = new Date();
		var year = nowDate.getFullYear();
		var startDate = new Date(year, 0, 1);

		var formattedStartDate = formatDate(startDate);
		var formattedEndDate = formatDate(nowDate);

		document.getElementById("recruitPeriod").textContent = formattedStartDate + ' ~ ' + formattedEndDate;

		const recruitmentStatus = ajaxCall('getListBox207List.do', '', false).data.recruitmentStatus;

		if (typeof recruitMiniOption == "undefined" || recruitMiniOption == null || recruitMiniOption == ""){
			recruitMiniOption = 1;
			recruitOption = 1;
		}
		
		var type = "";
	    var cntData = "";
	    var gapRateData = "";

	    if (recruitmentStatus){
		    if (recruitMiniOption == 1) {
		    	type = "지원자";
		    	cntData = recruitmentStatus.appsCnt;
		    	gapRateData = recruitmentStatus.appsGapRate;
		    } else if (recruitMiniOption == 2) {
		    	type = "합격자";
		    	cntData = recruitmentStatus.newHiresCnt;
		    	gapRateData = recruitmentStatus.newHiresGapRate;
		    } else if (recruitMiniOption == 3) {
		    	type = "입사자";
		    	cntData = recruitmentStatus.winnersCnt;
		    	gapRateData = recruitmentStatus.winnersGapRate;
		    }
	
		    $('#recruitType').text(type);
		    recruitCnt(cntData, '#recruitCnt');
		    recruitGapRate(gapRateData, '#recruitGapRate');
		}
	}

	// 위젯wide html 코드 
	function createWidgetWide207(){
		var code = 
				'<div class="widget_header">' +
				'  <div class="widget_title">채용 현황</div>' +
				'</div>' +
				'<div class="widget_body attendance_contents annual-status overtime-work widget-common">' +
				'  <div class="container_box">' +
				'    <div class="container_info">' +
				'      <span class="info_title">지원자</span>' +
				'      <span class="info_title_num" id="appsCnt"></span>' +
				'      <span class="info_title desc" id="appsGapRate"></span>' +
				'    </div>' +
				'    <div class="container_info">' +
				'      <span class="info_title">합격자</span>' +
				'      <span class="info_title_num" id="winnersCnt"></span>' +
				'      <span class="info_title desc" id="winnersGapRate"></span>' +
				'    </div>' +
				'    <div class="container_info">' +
				'      <span class="info_title">입사자</span>' +
				'      <span class="info_title_num" id="newHiresCnt"></span>' +
				'      <span class="info_title desc" id="newHiresGapRate"></span>' +
				'    </div>' +
				'  </div>' +
				'</div>';
	
		document.querySelector('#widget207Element').innerHTML = code;
	}
	
	// 위젯wide 테이터
	function setDataWidgetWide207(){
		const recruitmentStatus = ajaxCall('getListBox207List.do', '', false).data.recruitmentStatus;

		if (recruitmentStatus){
			recruitCnt(recruitmentStatus.appsCnt, '#appsCnt');
			recruitGapRate(recruitmentStatus.appsGapRate, '#appsGapRate');
			recruitCnt(recruitmentStatus.newHiresCnt, '#winnersCnt');
			recruitGapRate(recruitmentStatus.newHiresGapRate, '#winnersGapRate');
			recruitCnt(recruitmentStatus.winnersCnt, '#newHiresCnt');
			recruitGapRate(recruitmentStatus.winnersGapRate, '#newHiresGapRate');
		}
	}

	function recruitCnt(cnt, targetElement){
		var Html = cnt + '<span class="info_title unit">명</span>';
		document.querySelector(targetElement).innerHTML = Html;
	}

	// 전년대비 비율 데이터 넣기 
	function recruitGapRate(gapRate, targetElement) {
	    var gapRateBefore = '';

	    if (gapRate > 0) {
	    	gapRateBefore = 
   				'전년대비<strong class="title_green">' + gapRate + '%' +
	            '</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
	    } else if (gapRate < 0) {
	    	gapRateBefore = 
		    	'전년대비<strong class="title_red">' + gapRate + '%' +
	            '</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
	    } else {
	    	gapRateBefore = '<strong class="title_green">' + gapRate + '%';
	    }
		
		document.querySelector(targetElement).innerHTML = gapRateBefore;
	}

	// 날짜 함수
	function formatDate(date) {
	  var year = date.getFullYear();
	  var month = date.getMonth() + 1;
	  var day = date.getDate();

	  if (month < 10) {
	    month = '0' + month;
	  }
	  if (day < 10) {
	    day = '0' + day;
	  }

	  return year + '.' + month + '.' + day;
	}

	$('#widget207Element').on('click', '.arrowRight', function() {
		if (recruitOption == 3){
			recruitOption = 1;
		} else{
			recruitOption++;
		}

		setDataWidgetMini207(recruitOption);
	});

	$('#widget207Element').on('click', '.arrowLeft', function() {
		if (recruitOption == 1){
			recruitOption = 3;
		} else{
			recruitOption--;
		}

		setDataWidgetMini207(recruitOption);
	});
</script>
<div class="widget" id="widget207Element"></div>