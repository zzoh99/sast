<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태마스터</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

	
<!-- 공통으로 들어오면 widget.css 삭제해야됨TODO -->
<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
<script defer src="../assets/plugins/apexcharts-3.42.0/apexcharts.js"></script>
	
<script type="text/javascript">

	var TotMonValue;
	var bfTotMon1Value;
	var bfTotMon2Value;
	var bfTotMon3Value;

    var currentYear;
    var lastYear1;
    var lastYear2;
    var lastYear3;
	
	
	$(document).ready(function () {
		const {  vacationLeaveCost, overTimeUse, attendanceCnt, attendanceInfo, attendanceAllInfo } = ajaxCall('/base08Data.do', '', false).data;
		setVacationLeaveCost(vacationLeaveCost);
		setOverTimeUse(overTimeUse);
		setAttendanceCnt(attendanceCnt)
		setAttendanceInfo(attendanceInfo)
		setAttendanceAllInfo(attendanceAllInfo)
	});
	/* 연차 보상 비용 현황 */
	function setVacationLeaveCost(vacationLeaveCost){
		$('#minMon').text(vacationLeaveCost.data[0].minMon);
		$('#minMonMini').text(vacationLeaveCost.data[0].minMon);
		$('#maxMon').text(vacationLeaveCost.data[0].maxMon);
		$('#maxMonMini').text(vacationLeaveCost.data[0].maxMon);
		$('#totMon').text(vacationLeaveCost.data[0].totMon);
		$('#totMonMini').text(vacationLeaveCost.data[0].totMon);
		$('#cnt').text(vacationLeaveCost.data[0].cnt);
		$('#cntMini').text(vacationLeaveCost.data[0].cnt);
		$('#bfTotMon1').text(vacationLeaveCost.data[0].bfTotMon1);
		$('#bfTotMon2').text(vacationLeaveCost.data[0].bfTotMon2);
		$('#bfTotMon3').text(vacationLeaveCost.data[0].bfTotMon3);

		TotMonValue = vacationLeaveCost.data[0].totMon;
		bfTotMon1Value = vacationLeaveCost.data[0].bfTotMon1;
		bfTotMon2Value = vacationLeaveCost.data[0].bfTotMon2;
		bfTotMon3Value = vacationLeaveCost.data[0].bfTotMon3;

		currentYear = vacationLeaveCost.data[0].bfPayDay;
	    lastYear1 = vacationLeaveCost.data[0].bfPayDay1;
	    lastYear2 = vacationLeaveCost.data[0].bfPayDay2;
	    lastYear3 = vacationLeaveCost.data[0].bfPayDay3;

		if (vacationLeaveCost.data[0].totMon === 0 || vacationLeaveCost.data[0].bfTotMon1 === 0){
			$('#divideTotMon').text(0);
			$('#divideTotMonMini').text(0);
		}else{
			$('#divideTotMon').text(vacationLeaveCost.data[0].totMon/vacationLeaveCost.data[0].bfTotMon1);
			$('#divideTotMonMini').text(vacationLeaveCost.data[0].totMon/vacationLeaveCost.data[0].bfTotMon1);

			if (vacationLeaveCost.data[0].totMon > vacationLeaveCost.data[0].bfTotMon1) {
			    $('#standard').text('증가');
			    $('#standardMini').text('증가');
			} else if (vacationLeaveCost.data[0].totMon < vacationLeaveCost.data[0].bfTotMon1) {
			    $('#standard').text('감소');
			    $('#standardMini').text('감소');
			}else{
				$('#standard').text('');
			    $('#standardMini').text('');
			} 
		}
	}

	function setOverTimeUse(overTimeUse){
		$('#ym').text(overTimeUse.data[0].ym);
		$('#rate').text(overTimeUse.data[0].rate);

		var list = overTimeUse.data;
			
		for (var step = 0; step < list.length; step++) {

			console.log('qwe',list[step].type);

			$('#holAvgHour').text(('-'));
			$('#holOverCnt').text(('-'));
			$('#holRateTxt').text(('-'));

			if ( list[step].type === 1){
				
				if ( overTimeUse.data[step].rateTxt.substr(-2) === '증가' ){

					var overHtmlMini = '<strong class="title_green" id="rateTxtMini"></strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>'; 

					document.querySelector('#overTimeTrendMini').insertAdjacentHTML('beforeend', overHtmlMini);
					
				}else if ( overTimeUse.data[step].rateTxt.substr(-2) === '감소' ){
					var overHtmlMini = '<strong class="title_red" id="rateTxtMini"></strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>'; 

					document.querySelector('#overTimeTrendMini').insertAdjacentHTML('beforeend', overHtmlMini);

				}else{
					/*데이터 비었을 때 , 0일 때 퍼블리싱 준다고 함 */
				}

				if ( overTimeUse.data[step].rateTxt.substr(-2) === '증가' ){

					var overHtmlMini = '<strong class="title_green" id="rateTxt"></strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>'; 

					document.querySelector('#overTimeTrend').insertAdjacentHTML('beforeend', overHtmlMini);
					
				}else if ( overTimeUse.data[step].rateTxt.substr(-2) === '감소' ){
					var overHtmlMini = '<strong class="title_red" id="rateTxt"></strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>'; 

					document.querySelector('#overTimeTrend').insertAdjacentHTML('beforeend', overHtmlMini);

				}else{
					/*데이터 비었을 때 , 0일 때 퍼블리싱 준다고 함 */
				}

				$('#avgHourMini').text(overTimeUse.data[step].avgHour);
				$('#overCntMini').text(overTimeUse.data[step].cnt);
				$('#rateTxtMini').text(overTimeUse.data[step].rateTxt.substr(0,3));
				
				$('#avgHour').text(overTimeUse.data[step].avgHour);
				$('#overCnt').text(overTimeUse.data[step].cnt);
				$('#rateTxt').text(overTimeUse.data[step].rateTxt.substr(0,3));

			}else if ( list[step].type === 2){

				if ( overTimeUse.data[step].rateTxt.substr(-2) === '증가' ){

					var overHtmlMini = '<strong class="title_green" id="nightRateTxt"></strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>'; 

					document.querySelector('#nightTimeTrend').insertAdjacentHTML('beforeend', overHtmlMini);
					
				}else if ( overTimeUse.data[step].rateTxt.substr(-2) === '감소' ){
					var overHtmlMini = '<strong class="title_red" id="nightRateTxt"></strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>'; 

					document.querySelector('#nightTimeTrend').insertAdjacentHTML('beforeend', overHtmlMini);

				}else{
					/*데이터 비었을 때 , 0일 때 퍼블리싱 준다고 함 */
				}
				
				$('#nightAvgHour').text(overTimeUse.data[step].avgHour);
				$('#nightCnt').text(overTimeUse.data[step].cnt);
				$('#nightRateTxt').text(overTimeUse.data[step].rateTxt.substr(0,3));

			}else if ( list[step].type === 3){

				if ( overTimeUse.data[step].rateTxt.substr(-2) === '증가' ){

					var overHtmlMini = '<strong class="title_green" id="nightRateTxt"></strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>'; 

					document.querySelector('#holRateTxt').insertAdjacentHTML('beforeend', overHtmlMini);
					
				}else if ( overTimeUse.data[step].rateTxt.substr(-2) === '감소' ){
					var overHtmlMini = '<strong class="title_red" id="nightRateTxt"></strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>'; 

					document.querySelector('#holRateTxt').insertAdjacentHTML('beforeend', overHtmlMini);

				}else{
					/*데이터 비었을 때 , 0일 때 퍼블리싱 준다고 함 */
				}
				
				$('#holAvgHour').text(overTimeUse.data[step].avgHour);
				$('#holOverCnt').text(overTimeUse.data[step].cnt);
				$('#holRateTxt').text(overTimeUse.data[step].rateTxt.substr(0,3));
			}
		}
	}

	function length(size){
		
	} 

	function setAttendanceCnt(attendanceCnt){
		$('#attedanceBfCnt').text(attendanceCnt.data[0].bfCnt);
		$('#attedanceRate').text(attendanceCnt.data[0].rate);
		$('#attedanceCnt').text(attendanceCnt.data[0].cnt);

// 		if (attendanceCnt.data[0].cnt > attendanceCnt.data[0].bfCnt) {
// 		    // 증가일 때
// 		    var rateElement = document.createElement('strong');
// 		    rateElement.className = 'title_green';
// 		    rateElement.textContent = '증가';

// 		    var iconElement = document.createElement('div');
// 		    iconElement.className = 'tag_icon green round';
// 		    var icon = document.createElement('i');
// 		    icon.className = 'mdi-ico';
// 		    icon.textContent = 'trending_up';

// 		    iconElement.appendChild(icon);

// 		    rateElement.appendChild(iconElement);

// 		    var parentElement = document.getElementById('attedanceCnt');
// 		    parentElement.appendChild(rateElement);
// 		} else if (attendanceCnt.data[0].bfCnt > attendanceCnt.data[0].cnt) {
// 		    // 감소일 때
// 		    var rateElement = document.createElement('strong');
// 		    rateElement.className = 'title_red';
// 		    rateElement.textContent = '감소';

// 		    var iconElement = document.createElement('div');
// 		    iconElement.className = 'tag_icon red round';
// 		    var icon = document.createElement('i');
// 		    icon.className = 'mdi-ico';
// 		    icon.textContent = 'trending_down';

// 		    iconElement.appendChild(icon);

// 		    rateElement.appendChild(iconElement);

// 		    var parentElement = document.getElementById('attedanceCnt');
// 		    parentElement.appendChild(rateElement);
// 		} else {
// 			 // 감소일 때
// 		    var rateElement = document.getElementById('attedanceRate');
// 		    rateElement.textContent = '감소';
// 		    rateElement.classList.add('title_red');

// 		    var iconElement = document.createElement('div');
// 		    iconElement.className = 'tag_icon red round';
// 		    var icon = document.createElement('i');
// 		    icon.className = 'mdi-ico';
// 		    icon.textContent = 'trending_down';

// 		    iconElement.appendChild(icon);

// 		    rateElement.appendChild(iconElement);
// 		}
	}

	function setAttendanceInfo(attendanceInfo) {
		if (Array.isArray(attendanceInfo.data)) {
			attendanceInfo.data.forEach(function (employee) {

		    var html = '<div><div class="avatar"><img src="../assets/images/attendance_char_0.png"></div>' 
			    	 + '<span class="name">' + employee.name + '</span>' 
			    	 + '<span class="position">사원</span>' 
			    	 + '<span class="team short">영업마케팅</span></div>';

			document.querySelector('#late_list').insertAdjacentHTML('beforeend', html);
			
// 		    div.innerHTML = `<div class="avatar"><img src="../assets/images/attendance_char_0.png"></div>
// 		      <span class="name">${employee.name}</span>
// 		      <span class="position">사원</span>
// 		      <span class="team">영업마케팅</span>
// 		    `;
// 		    document.querySelector('#late_list').append(div);
// 			var html = '';


		    });
		} 
	}


	function setAttendanceAllInfo(attendanceAllInfo) {
	    var allAttendanceList = attendanceAllInfo.data;
	    var lateAttendanceList = [];
	    var lateAttendanceList1 = [];
	    var lateAttendanceList2 = [];
	    var overseaAttendanceList = [];
	    var overseaAttendanceList1 = [];
	    var overseaAttendanceList2 = [];
	    var absentAttendanceList = [];
	    var absentAttendanceList1 = [];
	    var absentAttendanceList2 = [];

	    console.log('all', attendanceAllInfo);

	    for (var i = 0; i < allAttendanceList.length; i++) {
	        if (allAttendanceList[i].classify === 40) {
	            lateAttendanceList.push(allAttendanceList[i]);
	        } else if (allAttendanceList[i].classify === 111) {
	            overseaAttendanceList.push(allAttendanceList[i]);
	        } else if (allAttendanceList[i].classify === 999) {
	            absentAttendanceList.push(allAttendanceList[i]);
	        }
	    }

	    console.log('overseaAttendanceList.length', overseaAttendanceList.length);

	    if (overseaAttendanceList.length > 1) {
	        for (var k = 0; k < overseaAttendanceList.length; k++) {
	            if (k % 2 === 0) {
	                overseaAttendanceList1.push(overseaAttendanceList[k]);
	            } else if (k % 2 === 1) {
	                overseaAttendanceList2.push(overseaAttendanceList[k]);
	            }
	        }

	        overseaAttendanceList1.forEach(function (lateEmployee1) {
	            console.log('late', lateEmployee1);
	            var html = '<div><div class="avatar"><img src="../assets/images/attendance_char_0.png"></div>' +
	                '<span class="name">' + lateEmployee1.name + '</span>' +
	                '<span class="position">사원</span>' +
	                '<span class="team short">영업마케팅</span></div>';
	            document.querySelector('#allList1').insertAdjacentHTML('beforeend', html);
	        });
	        overseaAttendanceList2.forEach(function (lateEmployee2) {
	            console.log('late', lateEmployee2);
	            var html = '<div><div class="avatar"><img src="../assets/images/attendance_char_0.png"></div>' +
	                '<span class="name">' + lateEmployee2.name + '</span>' +
	                '<span class="position">사원</span>' +
	                '<span class="team short">영업마케팅</span></div>';
	            document.querySelector('#allList2').insertAdjacentHTML('beforeend', html);
	        });
	    } else {
	        overseaAttendanceList1.push(overseaAttendanceList[0]);
	        overseaAttendanceList1.forEach(function (lateEmployee) {
	            console.log('late', lateEmployee);
	            var html = '<div><div class="avatar"><img src="../assets/images/attendance_char_0.png"></div>' +
	                '<span class="name">' + lateEmployee.name + '</span>' +
	                '<span class="position">사원</span>' +
	                '<span class="team short">영업마케팅</span></div>';
	            document.querySelector('#allList1').insertAdjacentHTML('beforeend', html);
	        });
	    }
	}

	
</script>
	
</head>
<body class="iframe_content">
    <!-- main_tab_content -->
    <div class="main_tab_content">
      <!-- sub_menu_container -->
      <div class="sub_menu_container attendance_container">
        <div class="header">
          <div class="title_wrap">
            <i class="mdi-ico filled">business_center_black</i>
            <span>근태마스터</span>
          </div>
          
          <div class="button_wrap">
            <button class="btn filled icon_text">
              <i class="mdi-ico filled">event</i>근무스케쥴 신청
            </button>
            <button class="btn filled icon_text">
              <i class="mdi-ico filled">assignment_turned_in</i>근태신청
            </button>
          </div>
        </div>
        <div class="widget_container">
          <div class="widget_wrap row_1 col_1"></div>
          <div class="widget_wrap row_1 col_1">
            <!-- 시간외 근무 사용현황 -->
            <div class="widget">
              <div class="widget_header">
                <div class="widget_title">시간외 근무 사용현황</div>
              </div>
              <div class="widget_body widget-common overtime-work">
                <div class="bookmarks_title">
                  <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
                  <span>연장근무</span>
                  <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
                </div>
                <div class="container_info">
                  <span class="info_title_num" id="overCntMini"><span class="info_title unit">건</span></span>
                  <span class="info_title desc" id="overTimeTrendMini">전년대비<strong class="title_green" id="rateTxtMini"></strong></span>
                  <div class="info_box">
                    <span class="title_kor">평균</span><span class="box_bnum" id="avgHourMini"></span><span class="title_kor">시간</span>
                  </div>
                </div>
              </div>
            </div>
            <!--// 시간외 근무 사용현황 -->
          </div>

          <div class="widget_wrap row_1 col_2">
            <!-- 시간외 근무 사용현황 wide -->
            <div class="widget wide">
              <div class="widget_header">
                <div class="widget_title">시간외 근무 사용현황</div>
              </div>
              <div class="widget_body attendance_contents annual-status">
                <div class="container_box overtime-work widget-common">
                  <div class="container_info">
                    <span class="info_title"><i class="mdi-ico">alarm_on</i>연장근무</span>
                    <span class="info_title_num" id="overCnt"><span class="info_title unit">건</span></span>
                    <span class="info_title desc" id="overTimeTrend">전년대비<strong class="title_green" id="rateTxt"></strong></span>
                    <div class="info_box">
                      <span class="title_kor">평균</span><span class="box_bnum" id="avgHour"></span><span class="title_kor">시간</span>
                    </div>
                  </div>
                  <div class="container_info">
                    <span class="info_title"><i class="mdi-ico">dark_mode</i>야간근무</span>
                    <span class="info_title_num" id="nightCnt"><span class="info_title unit">건</span></span>
                    <span class="info_title desc" id="nightTimeTrend">전년대비</span>
                    <div class="info_box">
                      <span class="title_kor">평균</span><span class="box_bnum" id="nightAvgHour"></span><span class="title_kor">시간</span>
                    </div>
                  </div>
                  <div class="container_info">
                    <span class="info_title"><i class="mdi-ico">interests</i>휴일근무</span>
                    <span class="info_title_num" id="holOverCnt"><span class="info_title unit">건</span></span>
                    <span class="info_title desc" id="holTimeTrend">전년대비<strong class="title_green" id="holRateTxt"></strong></span>
                    <div class="info_box">
                      <span class="title_kor">평균</span><span class="box_bnum" id="holAvgHour"></span><span class="title_kor">시간</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="widget_wrap row_1 col_1"></div>
          <div class="widget_wrap row_1 col_1">
            <!-- 연차 보상 비용 현황 -->
            <div class="widget">
              <div class="widget_header">
                <div class="widget_title">연차 보상 비용 현황</div>
              </div>
              <div class="widget_body attendance_contents annual-status">
                <div class="container_box">
                  <div class="container_left">
                    <div class="container_info">
                      <span class="info_title">보상 지급 인원<strong class="cnt" id="cntMini"></strong>명</span>
                      <span class="info_title_num" id="totMonMini"><span class="info_title unit"></span></span>
                      <span class="info_title desc">전년대비<strong class="title_green" id="divideTotMon"></strong><span class="info_title desc" id="standard"></span><div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
                    </div>
                    <div class="info_box">
                      <span class="title_kor">1인당 최대 보상</span><span class="box_bnum" id="maxMonMini"></span><span class="title_kor"></span>
                    </div>
                    <div class="info_box">
                      <span class="title_kor">1인당 최소 보상</span><span class="box_bnum" id="minMonMini"></span><span class="title_kor"></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!--// 연차 보상 비용 현황 -->
          </div>

          <div class="widget_wrap row_1 col_2">
            <!-- 연차 보상 비용 현황 wide -->
            <div class="widget wide">
              <div class="widget_header">
                <div class="widget_title">연차 보상 비용 현황</div>
              </div>
              <div class="widget_body attendance_contents annual-status">
                <div class="container_box">
                  <div class="container_left">
                    <div class="container_info">
                      <span class="info_title">보상 지급 인원<strong class="cnt" id="cnt"></strong>명</span>
                      <span class="info_title_num" id="totMon"><span class="info_title unit"></span></span>
                      <span class="info_title desc">전년대비<strong class="title_green" id="divideTotMonMini"></strong><span class="info_title desc" id="standardMini"></span><div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
                    </div>
                    <div class="info_box">
                      <span class="title_kor">1인당 최대 보상</span><span class="box_bnum" id="maxMon"></span><span class="title_kor"></span>
                    </div>
                    <div class="info_box">
                      <span class="title_kor">1인당 최소 보상</span><span class="box_bnum" id="minMon"></span><span class="title_kor"></span>
                    </div>
                  </div>
                  <div class="container_right">
                    <div class="chart-wrap">
                      <div id="annualChart"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!--// 연차 보상 비용 현황 wide -->
          </div>
       	  <!-- 전사 근태 현황 비율-->
          <div class="widget_wrap row_1 col_1">
            <div class="widget">
              <div class="widget_header">
                <div class="widget_title">전사 근태 현황</div>
              </div>
              <div class="widget_body attend-status widget-common">
                <div class="bookmarks_title">
                  <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
                  <span>지각</span>
                  <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
                </div>
                <div class="container_info">
                  <span class="info_title_num" id="attedanceCnt"><span class="info_title unit">명</span></span>
                  <span class="info_title desc">전년대비<strong class="title_green" id="attedanceRate"></strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
                  <div class="btn-wrap">
                    <button class="btn outline_gray btn-more">더보기</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- //전사 근태 현황 비율-->
          <!-- 전사 근태 현황 지각 목록-->
          <div class="widget_wrap row_1 col_1">
            <div class="widget">
              <div class="widget_header">
                <div class="widget_title">지각</div>
                <a href="#" class="widget-close"><i class="mdi-ico">close</i></a>
              </div>
              <div class="widget_body widget-common avatar-widget">
                <div class="widget_body_title total-title"><span class="label">전체</span><span class="cnt">-</span><span class="unit">명</span></div>
                <div class="bookmarks_wrap">
                  <div class="bookmark_list" id="late_list"></div>
                </div>
              </div>
            </div>
          </div>
          <!-- //전사 근태 현황 지각 목록-->
          <!-- 전사 근태 현황 wide -->
          <div class="widget_wrap row_1 col_2">
            <div class="widget wide">
              <div class="widget_header">
                <div class="widget_title">전사 근태 현황</div>
                <i class="mdi-ico">more_horiz</i>
              </div>
              <div class="widget_body avatar-widget">
                <div class="bookmarks_title">
                  <div class="tab_wrap">
                    <div class="tab_menu active">지각</div>
                    <div class="tab_menu">해외법인 파견자</div>
                    <div class="tab_menu">결근</div>
                  </div>
                </div>
                <div class="bookmarks_wrap pt-30">
                  <div class="bookmark_list" id="allList1">
                    <span class="total">
                      <span class="list-label">전체</span><span class="cnt">-</span><span class="unit">명</span>
                    </span>
                  </div>
                  <div class="bookmark_list" id="allList2">
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!--// 전사 근태 현황 wide -->
        </div>
      </div>
      <!--// attendance_master -->
    </div>
    <!-- // main_tab_content -->
    
    <div class="select_options fix_width align_center custom" id="people_status">
      <div class="option on">
        <span class="no">1</span>
        <span class="status">승인완료</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option on">
        <span class="no">2</span>
        <span class="status">승인완료</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option wait">
        <span class="no">3</span>
        <span class="status">결재진행중</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">4</span>
        <span class="status">결재진행중</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">5</span>
        <span class="status">결재대기</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">6</span>
        <span class="status">결재대기</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">7</span>
        <span class="status">결재대기</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
    </div>
  </body>
  <script>
    $(document).ready(function () {
      /* 말풍선 */
      $('.avatar-list .name').mouseover(function(event){
        const xpos = $(this).position().left;
        const ypos = -$(this).parent().position().top;
        console.log("xpos:"+xpos+"/ ypos:"+ypos);
        // $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
        $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
      });
      $('.avatar-list .name').mouseout(function(event){
        $(this).parent().parent().next().hide();
      });

      /* 말풍선 */
      $('.overtime-work .avatar-list .name').mouseover(function(event){
        const xpos = ($(this).position().left + $(this).width() - 5 );
        const ypos = -($(this).parent().position().top + 33);
        console.log("xpos:"+xpos+"/ ypos:"+ypos);
        // $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
        $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
      });
      $('.overtime-work .avatar-list .name').mouseout(function(event){
        $(this).parent().parent().next().hide();
      });


      /* EIS 근무 위젯 */
      var annualChart = {
        series: [
          {
            data: [bfTotMon3Value, bfTotMon2Value, bfTotMon1Value, TotMonValue],
          },
        ],
        chart: {
          height: 143,
          type: "bar",
          events: {
            click: function (chart, w, e) {
              // console.log(chart, w, e)
            },
          },
        },
        stroke: {
          width: 1,
        },
        yaxis: {
          show: false,
          tickAmount: 7,
        },
        colors: ["#2570f9"],
        plotOptions: {
          bar: {
            columnWidth: "4px",
            distributed: true,
          },
        },
        dataLabels: {
          enabled: false,
        },
        legend: {
          show: false,
        },
        xaxis: {
          categories: [lastYear3.substr(0,4), lastYear2.substr(0,4), lastYear1.substr(0,4), currentYear.substr(0,4)],
          labels: {
            style: {
              /* colors: ["#2570f9"], */
              fontSize: "12px",
            },
          },
        },
      };
      if (document.querySelector("#annualChart")) {
        new ApexCharts(
          document.querySelector("#annualChart"),
          annualChart
        ).render();
      }
    });
  </script>
</html>
