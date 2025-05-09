<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 시간외 근무 사용현황
	 */

	var widget801 = {
		size: null
	};

	var wokrTypeStand = '';
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox801(size) {
		widget801.size = size;
		
		if (size == "normal"){
			createWidgetMini801();
			setDataWidgetMini801();
		} else if (size == ("wide")){
			createWidgetWide801();
			setDataWidgetWide801();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini801(){
		var code =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">시간외 근무 사용현황</div>' +
		    '</div>' +
		    '<div class="widget_body widget-common overtime-work">' +
		    '  <div class="bookmarks_title">' +
		    '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
		    '    <span id="workTypeName"></span>' +
		    '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
		    '  </div>' +
		    '  <div class="container_info">' +
		    '    <span class="info_title_num" id="overCntMini"><span class="info_title unit">시간</span></span>' +
		    '    <span class="info_title desc" id="overTimeTrendMini"></span>' +
		    '    <div class="info_box">' +
		    '      <span class="title_kor">평균</span><span class="box_bnum" id="avgHourMini">0</span><span class="title_kor">시간</span>' +
		    '    </div>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget801Element').innerHTML = code;
	}
	
	// 위젯 데이터 넣기 
	function setDataWidgetMini801(wokrType) {
        ajaxCall2("getListBox801List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.overTimeUse) {
                    const overTimeUse = data.data.overTimeUse;

                    if (!wokrType) {
                        wokrType = 'over';
                    }
                    wokrTypeStand = wokrType;
                    var data1 = [];
                    var data2 = [];
                    var data3 = [];

                    if (overTimeUse.data.length > 0){
                        for (var i = 0; i < overTimeUse.data.length; i++) {
                            var currentItem = overTimeUse.data[i];

                            if (currentItem.type == 1) {
                                data1.push(currentItem);
                            } else if (currentItem.type == 2) {
                                data2.push(currentItem);
                            } else if (currentItem.type == 3) {
                                data3.push(currentItem);
                            }
                        }

                        if (wokrType == 'over'){
                            $('#workTypeName').text('연장근무');
                            if (data1.length != 0){
                                setOverTimeCnt(data1[0].sumHour, '#overCntMini');
                                compareOverTimeYear(data1[0].rateTxt, '#overTimeTrendMini');
                                $('#avgHourMini').text(data1[0].avgHour);
                            }
                        } else if (wokrType == 'night'){
                            $('#workTypeName').text('야간근무');
                            if (data2.length != 0){
                                setOverTimeCnt(data2[0].sumHour, '#overCntMini');
                                compareOverTimeYear(data2[0].rateTxt, '#overTimeTrendMini');
                                $('#avgHourMini').text(data2[0].avgHour);
                            }
                        } else if (wokrType == 'holiday'){
                            $('#workTypeName').text('휴일근무');
                            if (data3.length != 0){
                                setOverTimeCnt(data3[0].sumHour, '#overCntMini');
                                compareOverTimeYear(data3[0].rateTxt, '#overTimeTrendMini');
                                $('#avgHourMini').text(data3[0].avgHour);
                            }
                        }
                    }
                }
            })
	}

	// 위젯 wided html 코드 생성 및 데이터 넣기 
	function createWidgetWide801(){
		var code =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">시간외 근무 사용현황</div>' +
		    '</div>' +
		    '<div class="widget_body attendance_contents annual-status">' +
		    '  <div class="container_box overtime-work widget-common">' +
		    '    <div class="container_info">' +
		    '      <span class="info_title"><i class="mdi-ico">alarm_on</i>연장근무</span>' +
		    '      <span class="info_title_num" id="overCnt">0<span class="info_title unit">시간</span></span>' +
		    '      <span class="info_title desc" id="overTimeTrend">전년대비<strong class="title_green" id="rateTxt"></strong></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="avgHour"></span><span class="title_kor">시간</span>' +
		    '      </div>' +
		    '    </div>' +
		    '    <div class="container_info">' +
		    '      <span class="info_title"><i class="mdi-ico">dark_mode</i>야간근무</span>' +
		    '      <span class="info_title_num" id="nightCnt">0<span class="info_title unit">시간</span></span>' +
		    '      <span class="info_title desc" id="nightTimeTrend">전년대비</span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="nightAvgHour"></span><span class="title_kor">시간</span>' +
		    '      </div>' +
		    '    </div>' +
		    '    <div class="container_info">' +
		    '      <span class="info_title"><i class="mdi-ico">interests</i>휴일근무</span>' +
		    '      <span class="info_title_num" id="holOverCnt">0<span class="info_title unit">시간</span></span>' +
		    '      <span class="info_title desc" id="holTimeTrend">전년대비<strong class="title_green" id="holRateTxt"></strong></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="holAvgHour">0</span><span class="title_kor">시간</span>' +
		    '      </div>' +
		    '    </div>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget801Element').innerHTML = code;
	}

	function setDataWidgetWide801() {
        ajaxCall2("getListBox801List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.overTimeUse) {
                    const overTimeUse = data.data.overTimeUse;

// 		overTimeUse = {
// 				data: [
// 					{type: 1, cnt: 10, rateTxt: '전년대비 10% 증가', avgHour: 11.5},
// 					{type: 2, cnt: 10, rateTxt: '전년대비 10% 감소', avgHour: 11.5},
// 					{type: 3, cnt: 10, rateTxt: '전년대비 10% 증가', avgHour: 11.5}
// 				]
// 			};
                    var data1 = [];
                    var data2 = [];
                    var data3 = [];

                    if (overTimeUse.data.length > 0){
                        for (var i = 0; i < overTimeUse.data.length; i++) {
                            var currentItem = overTimeUse.data[i];

                            if (currentItem.type == 1) {
                                data1.push(currentItem);
                            } else if (currentItem.type == 2) {
                                data2.push(currentItem);
                            } else if (currentItem.type == 3) {
                                data3.push(currentItem);
                            }
                        }

                        if (data1.length != 0){
                            setOverTimeCnt(data1[0].sumHour, '#overCnt');
                            compareOverTimeYear(data1[0].rateTxt, '#overTimeTrend');
                            $('#avgHour').text(data1[0].avgHour);
                        }

                        if (data2.length != 0){
                            setOverTimeCnt(data2[0].sumHour, '#nightCnt');
                            compareOverTimeYear(data2[0].rateTxt, '#nightTimeTrend');
                            $('#nightAvgHour').text(data2[0].avgHour);
                        }

                        if (data3.length != 0){
                            setOverTimeCnt(data3[0].sumHour, '#holOverCnt');
                            compareOverTimeYear(data3[0].rateTxt, '#holTimeTrend');
                            $('#holAvgHour').text(data3[0].avgHour);
                        }
                    }
                }
            })
	}

	function setOverTimeCnt(cnt, targetElement){
		var html = cnt + '<span class="info_title unit">시간</span>';
		document.querySelector(targetElement).innerHTML = html;
	}

	function compareOverTimeYear(gapRate, targetElement) {
	    var gapRateBefore = '';
	    var gapRateNum ='';

	    if (gapRate.substr(-2, gapRate.length) == '증가') {
	    	gapRateBefore = 
   				'전년대비<strong class="title_green">' + getNumbers(gapRate) + '%' +
	            '</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
	    } else if (gapRate.substr(-2, gapRate.length) == '감소') {
	    	gapRateBefore = 
		    	'전년대비<strong class="title_red">' + getNumbers(gapRate) + '%' +
	            '</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
	    } else {
	    	gapRateBefore = '<strong class="title_green">' + getNumbers(gapRate) + '%';
	    }
		
		document.querySelector(targetElement).innerHTML = gapRateBefore;
	}

	function getNumbers(gapRate) {
		  const match = gapRate.match(/[-+]?[0-9]*\.?[0-9]+/);

		  if (match) {
		    return parseFloat(match[0]);
		  }
		  return NaN;
	}

	$(document).ready(function() {
		$('#widget801Element').on('click', '.arrowRight', function() {

			if (wokrTypeStand == 'over'){
				setDataWidgetMini801('night');
			} else if (wokrTypeStand == 'night'){
				setDataWidgetMini801('holiday');
			} else if (wokrTypeStand == 'holiday'){
				setDataWidgetMini801('over');
			}
		});
		
		$('#widget801Element').on('click', '.arrowLeft', function() {

			if (wokrTypeStand == 'over'){
				setDataWidgetMini801('holiday');
			} else if (wokrTypeStand == 'night'){
				setDataWidgetMini801('over');
			} else if (wokrTypeStand == 'holiday'){
				setDataWidgetMini801('night');
			}
		});
	});
</script>
<div class="widget" id="widget801Element"></div>