<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사마스터</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script defer src="../assets/plugins/apexcharts-3.42.0/apexcharts.js"></script>


<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>

<script type="text/javascript">

	var now = new Date();
	var month = [];
	var monthIn = [];
	var monthOut = [];
	var indexData = [];
	var yearLeave = [];
	var year = [];

	$(document).ready(function() {
		const { companyYearlyTrendsIndex, yearlyEnterExitTrend, candidate, leave } = ajaxCall('/base02Data.do', '', false).data;
		console.log('yearlyEnterExitTrend',yearlyEnterExitTrend);
		setCompanyYearlyTrendsIndex(companyYearlyTrendsIndex);
		setYearlyEnterExitTrend(yearlyEnterExitTrend);
		setCandidate(candidate);
		setLeave(leave);
	});
	
	// 입/퇴사 추이
	function setYearlyEnterExitTrend(yearlyEnterExitTrend){

		insertCnt(yearlyEnterExitTrend.data[0].in, '#rateEnterExitIn');

		compareYear(yearlyEnterExitTrend.data[0].gapRateIn, '#gapRateEnterExitIn');

		insertCnt(yearlyEnterExitTrend.data[0].in, '#rateEnterExitWideIn');
		insertCnt(yearlyEnterExitTrend.data[0].out, '#rateEnterExitWideOut');

		compareYear(yearlyEnterExitTrend.data[0].gapRateIn, '#gapRateEnterExitInWideIn');
		compareYear(yearlyEnterExitTrend.data[0].gapRateOut, '#gapRateEnterExitInWideOut');

		for (var i = 0; i < 5; i++) {
			
			month.push(now.getMonth() - i + 1);

		}

	for (var i = 0; i < 4; i++) {
			
		year.push(now.getFullYear() - i);

	}
	
		console.log(month);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].oneIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].twoIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].threeIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].fourIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].fiveIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].sixIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].sevenIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].eightIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].tenIn);
		monthIn.push(yearlyEnterExitTrend.monthlyData[0].elevenIn);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].oneOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].twoOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].threeOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].fourOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].fiveOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].sixOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].sevenOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].eightOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].tenOut);
		monthOut.push(yearlyEnterExitTrend.monthlyData[0].elevenOut);

		console.log('monthIn',monthIn);
		console.log('monthOut',monthOut);
	}

	function setCompanyYearlyTrendsIndex(companyYearlyTrendsIndex){

		indexData = companyYearlyTrendsIndex.data.slice();
		console.log('asdf',indexData);
		console.log('zxcv',companyYearlyTrendsIndex.data);
		
		for (var i =0 ; i< companyYearlyTrendsIndex.data.length ; i++ ){
			if ( companyYearlyTrendsIndex.data[i].year === '2023' ){

				$('#newHireDeparture').text(companyYearlyTrendsIndex.data[i].cnt);
				$('#newHireDepartureRate').text(companyYearlyTrendsIndex.data[i].gapRate);
				//3개년 채용지수
				$('#rateIndex').text(companyYearlyTrendsIndex.data[i].rate+ '%');
				$('#rateIndexWide').text(companyYearlyTrendsIndex.data[i].rate+ '%');
				$('#newHire').text('잔류자/입사자 ' + companyYearlyTrendsIndex.data[i].cnt + '/' + companyYearlyTrendsIndex.data[i].remainCnt);
				compareYear(companyYearlyTrendsIndex.data[i].gapRate, '#gapRateIndex');
				$('#rateIndexWide').text(companyYearlyTrendsIndex.data[i].rate+ '%');
				$('#newHireWide').text('잔류자/입사자 ' + companyYearlyTrendsIndex.data[i].cnt + '/' + companyYearlyTrendsIndex.data[i].remainCnt);
				compareYear(companyYearlyTrendsIndex.data[i].gapRate, '#gapRateIndexWide');


				//3개년 채용인원 				
				insertCnt(companyYearlyTrendsIndex.data[i].cnt, '#newHireThisYearWide');
				compareYear(companyYearlyTrendsIndex.data[i].gapRate, '#gapRateThisYearWide');

				insertCnt(companyYearlyTrendsIndex.data[i].cnt, '#newHireThisYear');
				compareYear(companyYearlyTrendsIndex.data[i].gapRate, '#gapRateThisYear');
				
			}else if ( companyYearlyTrendsIndex.data[i].year === '2022' ){

				insertCnt(companyYearlyTrendsIndex.data[i].cnt, '#newHireLastYearWide');
				
				compareYear(companyYearlyTrendsIndex.data[i].gapRate, '#gapRateLastYearWide');

			}else if ( companyYearlyTrendsIndex.data[i].year === '2021' ){

				insertCnt(companyYearlyTrendsIndex.data[i].cnt, '#newHireTheYearBeforeWide');
				
				compareYear(companyYearlyTrendsIndex.data[i].gapRate, '#gapRateTheYearBeforeWide');

				
			}else if ( companyYearlyTrendsIndex.data[i].year === '2020' ){
			}
		}
	}

	function insertCnt(cnt, targetElement){
		var Html = cnt + '<span class="info_title unit">명</span>';
		document.querySelector(targetElement).insertAdjacentHTML('beforeend',Html);
	}

	function compareYear(gapRate, targetElement) {
	    var gapRateBefore = '';

	    if (gapRate > 0) {
	    	gapRateBefore = '<strong class="title_green">' +
	            gapRate + '%' +
	            '</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
	    } else if (gapRate < 0) {
	    	gapRateBefore = '<strong class="title_red">' +
	            gapRate + '%' +
	            '</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
	    } else {
	    	gapRateBefore = '<strong class="title_green">' +
	            gapRate + '%';
	    }
		
	    document.querySelector(targetElement).insertAdjacentHTML('beforeend', gapRateBefore);
	}

	function setCandidate(candidate){

		const sawonList = [];
		const dariList = [];
		const gwajangList = [];
		const chajangList = [];
		
		console.log('candidatasde',candidate.data);
		$('#candidateCnt').text(candidate.data.length);
		$('#candidateCntWide').text(candidate.data.length);
		for ( var i = 0 ; i < candidate.data.length ; i++ ){
// 			승진후보자 
			var html = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="candidateImage' + (i+1) +'"></span></div>'
            		 + '<div class="profile-info"><span class="name" id="candidateName' + (i+1) + '">'
            		 + '<span class="position" id="candidateJikwee' + (i+1) + '"></span></span>'
            		 + '<span class="team short ellipsis" id="candidateBuseo' + (i+1) + '"></span></div></div>';

	   		 document.querySelector('#candidateList').insertAdjacentHTML('beforeend',html);

	   		$('#candidateImage'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + candidate.data[i].sabun + "&t=" + (new Date()).getTime());
	   		$('#candidateName' + (i+1)).text(candidate.data[i].name);
	   		$('#candidateBuseo' + (i+1)).text(candidate.data[i].buseo);
	   		$('#candidateJikwee' + (i+1)).text(candidate.data[i].jikweeNm);

	   		if ( candidate.data[i].jikweeNm == ("사원")){
	   			sawonList.push(candidate.data[i]);
	   		}else if ( candidate.data[i].jikweeNm === ("대리")){
	   			dariList.push(candidate.data[i]);
	   		}else if ( candidate.data[i].jikweeNm === ("과장")){
	   			gwajangList.push(candidate.data[i]);
	   		}else if ( candidate.data[i].jikweeNm === ("차장")){
	   			chajangList.push(candidate.data[i]);
	   		}
		}
		
		console.log('sawonList',sawonList);
		console.log('dariList',dariList);
		console.log('gwajangList',gwajangList);
		console.log('chajangList',chajangList);
		
		if ( sawonList.length > 0){

			var html = '<div class="bookmark_inner-wrap">'
       				 + '<div class="bookmark_list mt-30" id="sawonLeft">'
       		 		 + '<span class="total">'
         		 	 + '<strong class="list-label">대리 승진후보자</strong></span></div>'
         		 	 + '<div class="bookmark_list mt-30" id="sawonRight"></div></div>'
         		
			document.querySelector('#candidateWideList').insertAdjacentHTML('beforeend',html);

			for ( var i = 0 ; i < sawonList.length ; i++ ){

				if( (i+1) % 2 === 1 ){
					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="sawonImageLeft' + (i+1) +'"></span></div>'
				       		 + '<div class="profile-info"><span class="name" id="sawonNameLeft' + (i+1) + '">'
				       		 + '<span class="position" id="sawonJikweeLeft' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="sawonBuseoLeft' + (i+1) + '"></span></div></div>';

	  		 		document.querySelector('#sawonLeft').insertAdjacentHTML('beforeend',innerHtml);

			  		$('#sawonImageLeft'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + sawonList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#sawonNameLeft' + (i+1)).text(sawonList[i].name);
			  		$('#sawonBuseoLeft' + (i+1)).text(sawonList[i].buseo);
			  		$('#sawonJikweeLeft' + (i+1)).text(sawonList[i].jikweeNm);
					
				}else if( (i+1) % 2 === 0 ){
					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="candidateImageRight' + (i+1) +'"></span></div>'
	       					 + '<div class="profile-info"><span class="name" id="candidateNameRight' + (i+1) + '">'
				       		 + '<span class="position" id="candidateJikweeRight' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="candidateBuseoRight' + (i+1) + '"></span></div></div>';

			  		document.querySelector('#sawonRight').insertAdjacentHTML('beforeend',innerHtml);
			
			  		$('#candidateImageRight'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + sawonList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#candidateNameRight' + (i+1)).text(sawonList[i].name);
			  		$('#candidateBuseoRight' + (i+1)).text(sawonList[i].buseo);
			  		$('#candidateJikweeRight' + (i+1)).text(sawonList[i].jikweeNm);

				}
			}
		}
		if ( dariList.length > 0 ){

			var html = '<div class="bookmark_inner-wrap">'
          		 	 + '<div class="bookmark_list mt-30" id="dariLeft">'
          		 	 + '<span class="total">'
        		 	 + '<strong class="list-label">과장 승진후보자</strong></span></div>'
        		 	 + '<div class="bookmark_list mt-30" id="dariRight"></div></div>'
    		
			document.querySelector('#candidateWideList').insertAdjacentHTML('beforeend',html);

			for ( var i = 0 ; i < dariList.length ; i++ ){

				if( (i+1) % 2 === 1 ){
					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="dariImageLeft' + (i+1) +'"></span></div>'
				       		 + '<div class="profile-info"><span class="name" id="dariNameLeft' + (i+1) + '">'
				       		 + '<span class="position" id="dariJikweeLeft' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="dariBuseoLeft' + (i+1) + '"></span></div></div>';

	  		 		document.querySelector('#dariLeft').insertAdjacentHTML('beforeend',innerHtml);

			  		$('#dariImageLeft'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + dariList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#dariNameLeft' + (i+1)).text(dariList[i].name);
			  		$('#dariBuseoLeft' + (i+1)).text(dariList[i].buseo);
			  		$('#dariJikweeLeft' + (i+1)).text(dariList[i].jikweeNm);
					
				}else if( (i+1) % 2 === 0 ){
					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="dariImageRight' + (i+1) +'"></span></div>'
	       					 + '<div class="profile-info"><span class="name" id="dariNameRight' + (i+1) + '">'
				       		 + '<span class="position" id="dariJikweeRight' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="dariBuseoRight' + (i+1) + '"></span></div></div>';

			  		document.querySelector('#dariRight').insertAdjacentHTML('beforeend',innerHtml);
			
			  		$('#dariImageRight'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + dariList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#dariNameRight' + (i+1)).text(dariList[i].name);
			  		$('#dariBuseoRight' + (i+1)).text(dariList[i].buseo);
			  		$('#dariJikweeRight' + (i+1)).text(dariList[i].jikweeNm);

				}
			}
		}

		if ( gwajangList.length > 0 ){

			var html = '<div class="bookmark_inner-wrap">'
          		 	 + '<div class="bookmark_list mt-30" id="gwajangLeft">'
          		 	 + '<span class="total">'
       		 	 	 + '<strong class="list-label">차장 승진후보자</strong></span></div>'
       		 		 + '<div class="bookmark_list mt-30" id="gwajangRight"></div></div>'
   		
			document.querySelector('#candidateWideList').insertAdjacentHTML('beforeend',html);

			for ( var i = 0 ; i < gwajangList.length ; i++ ){
				
				if( (i+1) % 2 === 1 ){
					
					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="gwajangImageLeft' + (i+1) +'"></span></div>'
				       		 + '<div class="profile-info"><span class="name" id="gwajangNameLeft' + (i+1) + '">'
				       		 + '<span class="position" id="gwajangJikweeLeft' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="gwajangBuseoLeft' + (i+1) + '"></span></div></div>';

	  		 		document.querySelector('#gwajangLeft').insertAdjacentHTML('beforeend',innerHtml);

			  		$('#gwajangImageLeft'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + gwajangList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#gwajangNameLeft' + (i+1)).text(gwajangList[i].name);
			  		$('#gwajangBuseoLeft' + (i+1)).text(gwajangList[i].buseo);
			  		$('#gwajangJikweeLeft' + (i+1)).text(gwajangList[i].jikweeNm);
					
				}else if( (i+1) % 2 === 0 ){

					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="gwajangImageRight' + (i+1) +'"></span></div>'
	       					 + '<div class="profile-info"><span class="name" id="gwajangNameRight' + (i+1) + '">'
				       		 + '<span class="position" id="gwajangJikweeRight' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="gwajangBuseoRight' + (i+1) + '"></span></div></div>';

			  		document.querySelector('#gwajangRight').insertAdjacentHTML('beforeend',innerHtml);
			
			  		$('#gwaImageRight'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + gwajangList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#gwajangNameRight' + (i+1)).text(gwajangList[i].name);
			  		$('#gwajangBuseoRight' + (i+1)).text(gwajangList[i].buseo);
			  		$('#gwajangJikweeRight' + (i+1)).text(gwajangList[i].jikweeNm);

				}
			}
		}
		if ( chajangList.length > 0 ){

			var html = '<div class="bookmark_inner-wrap">'
          			 + '<div class="bookmark_list mt-30" id="chajangLeft">'
          			 + '<span class="total">'
       				 + '<strong class="list-label">부장 승진후보자</strong></span></div>'
       				 + '<div class="bookmark_list mt-30" id="chajangRight"></div></div>'
   		
			document.querySelector('#candidateWideList').insertAdjacentHTML('beforeend',html);

			for ( var i = 0 ; i < chajangList.length ; i++ ){

				if( (i+1) % 2 === 1 ){
					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="chajangImageLeft' + (i+1) +'"></span></div>'
				       		 + '<div class="profile-info"><span class="name" id=chajangNameLeft' + (i+1) + '">'
				       		 + '<span class="position" id="chajangJikweeLeft' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="chajangBuseoLeft' + (i+1) + '"></span></div></div>';

	  		 		document.querySelector('#chajangLeft').insertAdjacentHTML('beforeend',innerHtml);

			  		$('#chajangImageLeft'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + chajangList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#chajangNameLeft' + (i+1)).text(chajangList[i].name);
			  		$('#chajangBuseoLeft' + (i+1)).text(chajangList[i].buseo);
			  		$('#chajangJikweeLeft' + (i+1)).text(chajangList[i].jikweeNm);
					
				}else if( (i+1) % 2 === 0 ){
					var innerHtml = '<div><div class="avatar-wrap"><span class="avatar"><img src="../assets/images/attendance_char_0.png" id="chajangImageRight' + (i+1) +'"></span></div>'
	       					 + '<div class="profile-info"><span class="name" id="chajangNameRight' + (i+1) + '">'
				       		 + '<span class="position" id="chajangJikweeRight' + (i+1) + '"></span></span>'
				       		 + '<span class="team short ellipsis" id="chajangBuseoRight' + (i+1) + '"></span></div></div>';

			  		document.querySelector('#gwajangRight').insertAdjacentHTML('beforeend',innerHtml);
			
			  		$('#chaImageRight'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + chajangList[i].sabun + "&t=" + (new Date()).getTime());
			  		$('#chajangNameRight' + (i+1)).text(chajangList[i].name);
			  		$('#chajangBuseoRight' + (i+1)).text(chajangList[i].buseo);
			  		$('#chajangJikweeRight' + (i+1)).text(chajangList[i].jikweeNm);

				}
			}
		}
	}

	function setLeave(leave){
		console.log('leave',leave.data[0]);
		
		insertIndex(leave.data[0].out,'#leaveIndex');
		insertIndex(leave.data[0].out,'#leaveIndexWide');
		compareYear(leave.data[0].gapRateOut,'#leaveGap');
		compareYear(leave.data[0].gapRateOut,'#leaveGapWide');
		insertCnt(leave.data[0].outCnt,'#leaveCnt');
		insertCnt(leave.data[0].outCnt,'#leaveCntWide');
		yearLeave = leave.data[0];
		
	}

	function insertIndex(index, targetElement){
		var Html = index + '<span class="info_title_num unit">%</span>';
		document.querySelector(targetElement).insertAdjacentHTML('beforeend',Html);
	}

	function insertCnt(cnt, targetElement){
		var Html = cnt + '</span><span class="title_kor">명';
		document.querySelector(targetElement).insertAdjacentHTML('beforeend',Html);
	}

// 	$('.option check').click(function(){
// 		var standValue = $(this).attr('value');

// 		const () 
	
// 	});

// 	$('#candidateWideStand').click(function(){
//  		var standValue = $(this).attr('value');
// 		console.log('standValue',standValue);
		
//  	}); 

</script>

</head>
<body class="iframe_content">
	<div class="main_tab_content">
		<div class="sub_menu_container attendance_container">
			<div class="header">
	          <div class="title_wrap">
	          	<i class="mdi-ico filled">business_center_black</i>
	            <span>인사마스터</span>
	          </div>
	    </div>
	    
	    <div class="swiper widgetSwiper">
	    	 <div id="widgetBody" class="swiper-wrapper">
	    	 </div>
	    	 <div class="swiper-pagination"></div>
	    </div>
	    
	    <div class="widget_container">
	    	<div class="widget_wrap row_1 col_1">
	    		<div class="widget">
	    			<div class="widget_header">
		              <div class="widget_title">전사 인원 추이</div>
		            </div>
		            <div class="widget_body attendance_contents annual-status salary-average">
		              <div class="container_box">
		                <div class="container_left">
		                  <div class="container_info barChart-wrap">
		                    <span class="info_label mt-0">현재 정원 (목표)</span>
		                    <span class="info_title_num">2,350<span class="info_title data">/2,456</span><span class="info_title data-unit">명</span></span>
		                    <div class="progress_container">
		                      <div class="progress_bar bar_green" style="width:60%">
		                      </div>
		                    </div>
		                  </div>
		                  <div class="container_info barChart-wrap">
		                    <span class="info_label mt-0">정원율</span>
		                    <span class="info_title_num">66%</span>
		                    <div class="progress_container">
		                      <div class="progress_bar bar_blue" style="width:60%">
		                      </div>
		                    </div>
		                  </div>
		                </div>
		              </div>
		            </div>
	    		</div>
	    	</div>
	    	<!-- 입/퇴사 추이 -->
	    	<div class="widget_wrap row_1 col_1">
	    		<div class="widget">
	    			<div class="widget_header">
		              <div class="widget_title">입/퇴사 추이</div>
		            </div>
		            <div class="widget_body widget-common attend-status widget-more">
		              <div class="bookmarks_title">
		                <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
		                <span>입사자</span>
		                <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
		              </div>
		              <div class="container_info">
		                <span class="info_label">2023년도 기준</span>
		                <span class="info_title_num" id="rateEnterExitIn"></span>
		                <span class="info_title desc" id="gapRateEnterExitIn">전년대비</span>
		              </div>
		            </div>	
	    		</div>
	    	</div>
	    	<!--// 입/퇴사 추이 -->
	    	<!-- 입/퇴사 추이 wide -->
	    	<div class="widget_wrap row_1 col_2">
	    	  <div class="widget wide">
	            <div class="widget_header">
	              <div class="widget_title">입/퇴사 추이</div>
	            </div>
	            <div class="widget_body attendance_contents annual-status salary-average">
	              <div class="container_box">
	                <div class="container_left">
	                  <div class="container_info inOut-wrap">
	                    <div class="info_title">2023년도 기준</div>
	                    <div class="inner-wrap">
	                      <div class="in">
	                        <span class="info_label">입사자</span>
	                        <span class="info_title_num" id="rateEnterExitWideIn"></span>
	                        <div class="info_title desc">전월대비</div>
	                        <div class="info_title desc" id="gapRateEnterExitInWideIn"></div>
	                      </div>
	                      <div class="out">
	                        <span class="info_label">퇴사자</span>
	                        <span class="info_title_num" id="rateEnterExitWideOut"></span>
	                        <div class="info_title desc">전월대비</div>
	                        <div class="info_title desc" id="gapRateEnterExitInWideOut"></div>
	                      </div>
	                    </div>
	                  </div>
	                </div>
	                <div class="container_right">
	                  <div class="bookmarks_title select-outer">
	                    <div class="custom_select no_style">
	                      <button class="select_toggle">
	                        <span>연도별</span><i class="mdi-ico">arrow_drop_down</i>
	                      </button>
	                      <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->
	                      <div class="select_options numbers" style="visibility: hidden;">
	                        <div class="option">연도별</div>
	                        <div class="option">분기별</div>
	                        <div class="option">월별</div>
	                        <div class="option">연별</div>
	                      </div>
	                    </div>
	                  </div>
	                  <div class="chart-wrap">
	                    <div id="entryExitChart"></div>
	                  </div>
	                </div>
	              </div>
	            </div>
	          </div>
	    	</div>
	    	<div class="widget_wrap row_1 col_1"></div>
			<div class="widget_wrap row_1 col_1">
	    	  <div class="widget">
	            <div class="widget_header">
	              <div class="widget_title">3개년 채용 인원</div>
	            </div>
	            <div class="widget_body attendance_contents annual-status recruit-year">
	              <div class="bookmarks_title">
	                <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
	                <span>2023</span>
	                <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
	              </div>
	              <div class="container_left">
	                <div class="container_info">
	                  <span class="info_title_num" id="newHireThisYear"></span>
	                  <span class="info_title desc" id="gapRateThisYear">전년대비</span>
	                  <div class="info_box">
	                    <span class="title_kor">최대 채용 팀</span>
	                  </div>
	                  <div class="info_box team">
	                    <span class="title_kor">스마트사업팀</span>
	                  </div>
	                </div>
	              </div>
				</div>
			  </div>
			</div>
	    	<!--// 입/퇴사 추이 wide -->
	    	<div class="widget_wrap row_1 col_2">
	    		<div class="widget wide">
		            <div class="widget_header">
		              <div class="widget_title">3개년 채용 인원</div>
		            </div>
		            <div class="widget_body attendance_contents annual-status overtime-work widget-common recruit-year">
		              <div class="container_box">
		                <div class="container_info">
		                  <span class="info_title">2021</span>
		                  <span class="info_title_num" id="newHireTheYearBeforeWide"></span>
		                  <span class="info_title desc" id="gapRateTheYearBeforeWide">전년대비</span>
		                  <div class="info_box">
		                    <span class="title_kor">최대 채용 팀</span>
		                  </div>
		                  <div class="info_box team">
		                    <span class="title_kor">스마트사업팀</span>
		                  </div>
		                </div>
		                <div class="container_info">
		                  <span class="info_title">2022</span>
		                  <span class="info_title_num" id="newHireLastYearWide"></span>
		                  <span class="info_title desc" id="gapRateLastYearWide">전년대비</span>
		                  <div class="info_box">
		                    <span class="title_kor">최대 채용 팀</span>
		                  </div>
		                  <div class="info_box team">
		                    <span class="title_kor">스마트사업팀</span>
		                  </div>
		                </div>
		                <div class="container_info">
		                  <span class="info_title">2023</span>
		                  <span class="info_title_num" id="newHireThisYearWide"></span>
		                  <span class="info_title desc" id="gapRateThisYearWide">전년대비</span>
		                  <div class="info_box">
		                    <span class="title_kor">최대 채용 팀</span>
		                  </div>
		                  <div class="info_box team">
		                    <span class="title_kor">스마트사업팀</span>
		                  </div>
		                </div>
		              </div>
		            </div>
		          </div>
	    	</div>
	    	<div class="widget_wrap row_1 col_1"></div>
	    	<div class="widget_wrap row_1 col_1">
	    		<div class="widget">
            <div class="widget_header">
              <div class="widget_title">3개년 채용 지수</div>
            </div>
            <div class="widget_body attendance_contents annual-status recruit-year">
              <div class="bookmarks_title">
                <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
                <span>채용 성공률</span>
                <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
              </div>
              <div class="container_left">
                <div class="container_info">
                  <div class="select-outer">
                    <div class="custom_select no_style">
                      <button class="select_toggle">
                        <span>2023년</span><i class="mdi-ico">arrow_drop_up</i>
                      </button>
                      <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->
                      <div class="select_options numbers" style="visibility: visible;">
                        <div class="option">2023년</div>
                        <div class="option">2022년</div>
                        <div class="option">2021년</div>
                        <div class="option">2021년</div>
                        <div class="option">2021년</div>
                        <div class="option">2021년</div>
                        <div class="option">2021년</div>
                        <div class="option">2021년</div>
                        <div class="option">2021년</div>
                      </div>
                    </div>
                  </div>  
                  <span class="info_title_num" id="rateIndex"><span class="info_title_num unit"></span></span>
                  <span class="info_title num-desc" id="newHire"></span>
                  <span class="info_title desc">작년 채용 대비</span>
                  <span class="info_title desc" id="gapRateIndex"></span>
                </div>
              </div>
            </div>
          </div>
	    	</div>
	    	 <!-- 3개년 채용 지수 wide -->
	    	<div class="widget_wrap row_1 col_2">
	          <div class="widget wide">
            <div class="widget_header">
              <div class="widget_title">3개년 채용 지수</div>
            </div>
            <div class="widget_body widget-common timeList-widget attendance_contents annual-status index-3year">
              <div class="bookmarks_title">
                <div class="tab_wrap">
                  <div class="tab_menu active">채용 성공률</div>
                  <div class="tab_menu">선발율</div>
                  <div class="tab_menu">수용률</div>
                  <div class="tab_menu">안정도</div>
                  <div class="tab_menu">기초율</div>
                </div>
              </div>
              <div class="container_box">
                <div class="container_left">
                  <div class="container_info">
                    <span class="info_title label">올해 기준 안정도</span>
                    <span class="info_title_num" id="rateIndexWide"><span class="info_title_num unit"></span></span>
                    <span class="info_title num-desc" id="newHireWide"></span>
                  <span class="info_title desc">작년 채용 대비</span>
                  <span class="info_title desc" id="gapRateIndexWide"></span>
                  </div>
                </div>
                <div class="container_right">
                  <div class="chart-wrap">
                    <div id="indexChart"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
	    	</div>
          <!--// 3개년 채용 지수 wide -->
	    	<div class="widget_wrap row_1 col_1"></div>
	    	<div class="widget_wrap row_1 col_1">
	    		<div class="widget">
		            <div class="widget_header">
		              <div class="widget_title">채용 현황</div>
		            </div>
		            <div class="widget_body attend-status widget-common widget-more">
		              <div class="sub-title">2023.01.01 ~ 2023.09.30</div>
		              <div class="bookmarks_title">
		                <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
		                <span>지원자</span>
		                <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
		              </div>
		              <div class="container_info">
		                <span class="info_title_num">13<span class="info_title unit">명</span></span>
		                <span class="info_title desc"><span>전년대비</span><strong class="title_green">10%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
		              </div>
		            </div>
		          </div>
	    	</div>
	    	<div class="widget_wrap row_1 col_2">
	    		<div class="widget wide">
		            <div class="widget_header">
		              <div class="widget_title">채용 현황</div>
		            </div>
		            <div class="widget_body attendance_contents annual-status overtime-work widget-common">
		              <div class="container_box">
		                <div class="container_info">
		                  <span class="info_title">지원자</span>
		                  <span class="info_title_num">746<span class="info_title unit">명</span></span>
		                  <span class="info_title desc"><span>전년대비</span><strong class="title_green">10%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
		                </div>
		                <div class="container_info">
		                  <span class="info_title">합격자</span>
		                  <span class="info_title_num">50<span class="info_title unit">명</span></span>
		                  <span class="info_title desc"><span>전년대비</span><strong class="title_red">10%</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div></span>
		                </div>
		                <div class="container_info">
		                  <span class="info_title">입사자</span>
		                  <span class="info_title_num">50<span class="info_title unit">명</span></span>
		                  <span class="info_title desc"><span>전년대비</span><strong class="title_green">10%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
		                </div>
		              </div>
		            </div>
		          </div>
	    	</div>
	    	<div class="widget_wrap row_1 col_1"></div>
	    	<div class="widget_wrap row_1 col_1">
		      <div class="widget">
	            <div class="widget_header">
	              <div class="widget_title">퇴사율</div>
	            </div>
	            <div class="widget_body attendance_contents annual-status salary-average">
	              <div class="container_box">
	                <div class="container_left">
	                  <div class="container_info">
	                    <span class="info_title label">올해 퇴사율</span>
	                    <span class="info_title_num" id="leaveIndex"></span>
	                    <span class="info_title desc" id="leaveGap"></span>
	                  </div>
	                  <div class="info_box">
	                    <span class="title_kor">퇴사자 수</span><span class="box_bnum" id="leaveCnt"></span>
	                  </div>
	                </div>
	              </div>
	            </div>
	          </div>
	    	</div>
	    	<div class="widget_wrap row_1 col_2">
            <!-- 토글이 있을 땐 'toggle-wrap'으로 감싸준다. -->
			  <div class="widget wide">
                <div class="widget_header">
                  <div class="widget_title">퇴사율</div>
            	</div>
            	<div class="widget_body attendance_contents annual-status salary-average">
              	  <div class="container_box">
                	<div class="container_left">
                  	  <div class="container_info">
	                    <span class="info_title label">올해 퇴사율</span>
	                    <span class="info_title_num" id="leaveIndexWide"></span>
	                    <span class="info_title desc" id="leaveGapWide"></span>
                  	  </div>
                  	  <div class="info_box">
                    	<span class="title_kor">퇴사자 수</span><span class="box_bnum" id="leaveCntWide"></span>
	                  </div>
                	</div>
                	<div class="container_right">
                  	  <div class="bookmarks_title select-outer">
                    	<div class="custom_select no_style">
                      	  <button class="select_toggle">
                        	<span>분기별</span><i class="mdi-ico">arrow_drop_down</i>
                      	  </button>
                      <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->
                      	  <div class="select_options numbers" style="visibility: hidden;">
                        	<div class="option">분기별</div>
                        	<div class="option">월별</div>
                        	<div class="option">연별</div>
                      	  </div>
                    	</div>
                    	<div class="sub-title">2023년 8월 11일 기준</div>
                  	  </div>
	                  <div class="chart-wrap">
	                    <div id="leaveChart"></div>
	                  </div>
                	</div>
              	  </div>
            	</div>
			  </div>
          <!--// 퇴사율 wide -->
	    	</div>
	    	<div class="widget_wrap row_1 col_1"></div>
	    	<!-- 승진후보자 현황 -->
	    	<div class="widget_wrap row_1 col_1">
	          <div class="widget">
	            <div class="widget_header">
	              <div class="widget_title">승진후보자 현황</div>
	              <i class="mdi-ico">more_horiz</i>
	            </div>
	            <div class="widget_body widget-common avatar-widget big">
	              <div class="bookmarks_title select-outer total-title">
	                <div class="custom_select no_style">
	                  <button class="select_toggle">
	                    <span>전체</span><i class="mdi-ico">arrow_drop_down</i>
	                  </button>
	                  <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->
	                  <div class="select_options numbers" style="visibility: none;">
	                    <div class="option check" value="">전체</div>
	                    <div class="option check" value="team">팀별</div>
	                    <div class="option check" vlaue="head">본부별</div>
	                  </div>
	                </div>
	                <span class="num" id="candidateCnt"></span>
	                <span class="unit">명</span>
	              </div>
	              <div class="bookmarks_wrap">
	                <div class="bookmark_list" id="candidateList"></div>
	              </div>
	            </div>
	          </div>
	    	</div>
			<!-- //승진후보자 현황 -->
	    	<div class="widget_wrap row_1 col_2">
	    	<!-- 승진후보자 현황 wide -->
          <div class="widget wide">
            <div class="widget_header">
              <div class="widget_title">승진후보자 현황</div>
              <i class="mdi-ico">more_horiz</i>
            </div>
            <div class="widget_body widget-common avatar-widget big">
              <div class="bookmarks_title select-outer total-title">
                <div class="custom_select no_style">
                  <button class="select_toggle">
                    <span>전체</span><i class="mdi-ico">arrow_drop_down</i>
                  </button>
                  <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->
                  <div class="select_options numbers" style="visibility: hidden;">
                    <div class="option">전체</div>
                    <div class="option">팀별</div>
                    <div class="option">본부별</div>
                  </div>
                </div>
                <span class="num" id="candidateCntWide"></span>
                <span class="unit">명</span>
              </div>
              <div class="bookmarks_wrap multi-list" id="candidateWideList"></div>
            </div>
          </div>
          <!--// 핵심인재 현황 wide -->
	    	</div>
		</div>
	</div>
</body>
<script>
$(document).ready(function () {
// 	const ctx = $('#annualChart2');

// 	const year2021 = {
// 	    label: '2021',
// 	    data: [10, 8, 6, 5, 12, 7],
// 	    backgroundColor: 'rgba(203, 206, 145, .5)',
// 	    borderColor: '#CBCE91',
// 	    borderWidth: 1
// 	}

// 	const year2020 = {
// 	    label: '2020',
// 	    data: [5, 10, 5, 3, 4, 2],
// 	    backgroundColor: 'rgba(203, 206, 145, .5)',
// 	    borderColor: '#CBCE91',
// 	    borderWidth: 1
// 	}

// 	const data = {
// 	    labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
// 	    datasets: [
// 	        year2021,
// 	        year2020
// 	    ]
// 	}

// 	const options = {
// 	    maintainAspectRatio: false, // 그래프의 비율 유지
// 	    scales: {
// 	        x: { stacked: true }, // x 축 값 누적
// 	        y: { stacked: true }  // y 축 값 누적
// 	    },
// 	    // 그 외 다른 옵션들을 여기에 추가할 수 있습니다.
// 	};

// 	// 그래프 생성
// 	const chart = new Chart(ctx, {
// 	    type: 'bar', // 바 차트 유형
// 	    data: data,   // 데이터
// 	    options: options // 옵션
// 	});

	var options = {
			  series: [{
				name: '입사자',
			    data: [monthIn[0], monthIn[1], monthIn[2], monthIn[3], monthIn[4], monthIn[5], monthIn[6], monthIn[7], monthIn[8], monthIn[9], monthIn[10], monthIn[11], monthIn[12]],
// 			    data: [20, 30, 50, monthIn[3], monthIn[4]],
			    color: '#2570f9'
			  }, {
				name: '퇴사자',
			    data: [monthOut[0], monthOut[1], monthOut[2], monthOut[3], monthOut[4], monthOut[5], monthOut[6], monthOut[7], monthOut[8], monthOut[9], monthOut[10], monthOut[11], monthOut[12]],
// 				data: [20, 30, 50, monthIn[3], monthIn[4]],
				color: '#777777'
			  }],
			  chart: {
			    type: 'bar', 
			    height: 143,
			    width: 238,
			    toolbar: {
		            show: false
		        }
			  },
			  plotOptions: {
			    bar: {
			      horizontal: false, 
			      dataLabels: {
			        position: 'top',
			      },
			      columnWidth: 5, 
			    }
			  },
			  legend: {
  		        position: 'top',
  		        horizontalAlign: 'right'
  		      },
			  dataLabels: {
			    enabled: false,
			    offsetX: -6,
			    style: {
			      fontSize: '12px',
			      colors: ['#fff']
			    }
			  },
			  stroke: {
			    show: true,
			    width: 1,
			    colors: ['#fff']
			  },
			  tooltip: {
			    shared: true,
			    intersect: false
			  },
			  xaxis: {
			    categories: ['1','2','3','4','5',month[4]+'월', month[3]+'월', month[2]+'월', month[1]+'월', month[0]+'월', '11월','12월' ],
			  },
			  yaxis: {
				  show: false,
				    tickAmount: 4,
			  },
			};
			
			var chart = new ApexCharts(document.querySelector("#entryExitChart"), options);
    		chart.render();

    		var indexs = {
    				  series: [{
    						name: '잔류자',
    					    data: [indexData[3].remainCnt, indexData[2].remainCnt, indexData[1].remainCnt, indexData[0].remainCnt],
    					    color: '#2570f9'
    					  }, {
    						name: '입사자',
    						data: [indexData[3].cnt, indexData[2].cnt, indexData[1].cnt, indexData[0].cnt],
//    		 				data: [20, 30, 50, monthIn[3], monthIn[4]],
    						color: '#777777'
    					  }],
    					  chart: {
    					    type: 'bar', 
    					    height: 143,
    					    width: 238,
    					    toolbar: {
    				            show: false
    				        }
    					  },
    					  plotOptions: {
    					    bar: {
    					      horizontal: false, 
    					      dataLabels: {
    					        position: 'top',
    					      },
    					      columnWidth: 5, 
    					    }
    					  },
    					  legend: {
    		  		        position: 'top',
    		  		        horizontalAlign: 'right'
    		  		      },
    					  dataLabels: {
    					    enabled: false,
    					    offsetX: -6,
    					    style: {
    					      fontSize: '12px',
    					      colors: ['#fff']
    					    }
    					  },
    					  stroke: {
    					    show: true,
    					    width: 1,
    					    colors: ['#fff']
    					  },
    					  tooltip: {
    					    shared: true,
    					    intersect: false
    					  },
    					  xaxis: {
    						  categories: [year[3]+'년' , year[2]+'년' , year[1]+'년' , year[0]+'년' ],
    					  },
    					  yaxis: {
    						  show: false,
    						    tickAmount: 4,
    					  },
    					};
    				
    				var chart = new ApexCharts(document.querySelector("#indexChart"), indexs);
    	    		chart.render();

    	    		var leave = {
    	    				  series: [{
    	    						name: '퇴사자',
    	    					    data: [yearLeave.outCnt, yearLeave.lastOutCnt, yearLeave.yearBeforeCnt, yearLeave.yearBeforeLastCnt],
    	    					    color: '#2570f9'
    	    					  }],
    	    					  chart: {
    	    					    type: 'bar', 
    	    					    height: 143,
    	    					    width: 238,
    	    					    toolbar: {
    	    				            show: false
    	    				        }
    	    					  },
    	    					  plotOptions: {
    	    					    bar: {
    	    					      horizontal: false, 
    	    					      dataLabels: {
    	    					        position: 'top',
    	    					      },
    	    					      columnWidth: 5, 
    	    					    }
    	    					  },
    	    					  legend: {
    	    		  		        position: 'top',
    	    		  		        horizontalAlign: 'right'
    	    		  		      },
    	    					  dataLabels: {
    	    					    enabled: false,
    	    					    offsetX: -6,
    	    					    style: {
    	    					      fontSize: '12px',
    	    					      colors: ['#fff']
    	    					    }
    	    					  },
    	    					  stroke: {
    	    					    show: true,
    	    					    width: 1,
    	    					    colors: ['#fff']
    	    					  },
    	    					  tooltip: {
    	    					    shared: true,
    	    					    intersect: false
    	    					  },
    	    					  xaxis: {
    	    					    categories: [year[3]+'년' , year[2]+'년' , year[1]+'년' , year[0]+'년' ],
    	    					  },
    	    					  yaxis: {
    	    						  show: false,
    	    						    tickAmount: 4,
    	    					  },
    	    					};
    	    				
    	    				var chart = new ApexCharts(document.querySelector("#leaveChart"), leave);
    	    	    		chart.render();

});

</script>
</html>
