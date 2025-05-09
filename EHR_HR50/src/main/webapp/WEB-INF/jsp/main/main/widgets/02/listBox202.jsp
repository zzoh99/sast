<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * TODO 팀 쿼리 필요
	 * 인사 > 3개년 채용 인원
	 */

	var widget202 = {
		size: null
	};

	var now = new Date();
	var currentYear;
	
	/*
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox202(size) {
		 widget202.size = size;
		 
		if (size == "normal"){
			createWidgetMini202();
			setDataWidgetMini202();
		} else if (size == ("wide")){
			createWidgetWide202();
			setDataWidgetWide202();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini202(){
		var html =
				'<div class="widget_header">' +
	            '  <div class="widget_title">3개년 채용 인원</div>' +
	            '</div>' +
	            '<div class="widget_body attendance_contents annual-status recruit-year">' +
	            '  <div class="bookmarks_title">' +
	            '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
	            '    <span id="threeYear"></span>' +
	            '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
	            '  </div>' +
	            '  <div class="container_left">' +
	            '    <div class="container_info">' +
	            '      <span class="info_title_num" id="threeYearCnt"></span>' +
	            '      <span class="info_title desc" id="threeYearGapRate">전년대비</span>' +
	            '      <div class="info_box">' +
	            '        <span class="title_kor">최대 채용 팀</span>' +
	            '      </div>' +
	            '      <div class="info_box team">' +
	            '        <span class="title_kor">스마트사업팀</span>' +
	            '      </div>' +
	            '    </div>' +
	            '  </div>' +
				'</div>';

		document.querySelector('#widget202Element').innerHTML = html;
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini202(selectDate) {

        ajaxCall2("${ctx}/getListBox202List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.companyYearlyTrendsValues) {
                    const companyYearlyTrendsValues = data.data.companyYearlyTrendsValues;
                    if (!selectDate) {
                        selectDate = now.getFullYear();
                    }
                    currentYear = selectDate;
                    if (companyYearlyTrendsValues.data){
                        for (var i = 0; i < 3; i++){
                            if (companyYearlyTrendsValues.data[i].year == selectDate){
                                $('#threeYear').text(selectDate);
                                setNumberOfHireCnt(companyYearlyTrendsValues.data[i].cnt, '#threeYearCnt');
                                compareHiringChange(companyYearlyTrendsValues.data[i].gapRate, '#threeYearGapRate');
                            }
                        }
                    }
                }
            })
	}

	// 위젯 wide html 코드 생성 
	function createWidgetWide202(){
		var html = 
				'<div class="widget_header">' +
				'  <div class="widget_title">3개년 채용 인원</div>' +
				'</div>' +
				'<div class="widget_body attendance_contents annual-status overtime-work widget-common recruit-year">' +
				'  <div class="container_box">';

		for (var i = 0; i < 3; i++){
			html += 
				'<div class="container_info">' +
	            '  <span class="info_title" id="threeYear' + (i+1) + '"></span>' +
	            '  <span class="info_title_num" id="threeYearCnt' + (i+1) + '"></span>' +
	            '  <span class="info_title desc" id="threeYearGapRate' + (i+1) + '">전년대비</span>' +
	            '  <div class="info_box">' +
	            '    <span class="title_kor">최대 채용 팀</span>' +
	            '  </div>' +
	            '  <div class="info_box team">' +
	            '    <span class="title_kor">스마트사업팀</span>' +
	            '  </div>' +
	            '</div>';
		} 

		document.querySelector('#widget202Element').innerHTML = html;
	}

	// 위젯 wide 데이터 넣기  
	function setDataWidgetWide202() {

        ajaxCall2("${ctx}/getListBox202List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.companyYearlyTrendsValues) {
                    const companyYearlyTrendsValues = data.data.companyYearlyTrendsValues;

                    if (companyYearlyTrendsValues) {
                        for (var i = 0; i < 3; i++) {
                            if (companyYearlyTrendsValues.data[i].year == now.getFullYear()) {
                                $('#threeYear3').text(now.getFullYear());
                                setNumberOfHireCnt(companyYearlyTrendsValues.data[i].cnt, '#threeYearCnt3');
                                compareHiringChange(companyYearlyTrendsValues.data[i].gapRate, '#threeYearGapRate3');
                            } else if (companyYearlyTrendsValues.data[i].year == now.getFullYear() - 1) {
                                $('#threeYear2').text(now.getFullYear() - 1);
                                setNumberOfHireCnt(companyYearlyTrendsValues.data[i].cnt, '#threeYearCnt2');
                                compareHiringChange(companyYearlyTrendsValues.data[i].gapRate, '#threeYearGapRate2');
                            } else if (companyYearlyTrendsValues.data[i].year == now.getFullYear() - 2) {
                                $('#threeYear1').text(now.getFullYear() - 2);
                                setNumberOfHireCnt(companyYearlyTrendsValues.data[i].cnt, '#threeYearCnt1');
                                compareHiringChange(companyYearlyTrendsValues.data[i].gapRate, '#threeYearGapRate1');
                            }
                        }
                    }
                }
            })
	}

	// 인원수 html 데이터 넣기
	function setNumberOfHireCnt(cnt, targetElement){
		var Html = cnt + '<span class="info_title unit">명</span>';
		document.querySelector(targetElement).innerHTML = Html;
	}

	// 전년대비 비율 데이터 넣기 
	function compareHiringChange(gapRate, targetElement) {
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
	
	$('#widget202Element').on('click', '.arrowRight', function() {
		if (currentYear < now.getFullYear()) {
			currentYear = currentYear + 1;
		} else {
			currentYear = currentYear - 2;
		}

		setDataWidgetMini202(currentYear);
	});

	$('#widget202Element').on('click', '.arrowLeft', function() {
		if (currentYear > now.getFullYear()-2) {
			currentYear = currentYear - 1;
		} else {
			currentYear = currentYear + 2;
		}

		setDataWidgetMini202(currentYear);
	});
	
</script>
<div class="widget" id="widget202Element"></div>
	