<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 교대근무조 현황
	 */

	var widget808 = {
		size: null
	};

	var shiftWorkStandard = [];
	var shiftWorkDataIndex = 0;
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox808(size) {
		widget808.size = size;
		
		if (size == "wide"){
			createWidgetWide808();
			setDataWidgetWide808();
		} else if (size == ("normal")){
			createWidgetMini808();
			setDataWidgetMini808();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini808(){
		var html =
				'<div class="widget_header">' +
				'  <div class="widget_title">교대근무조 현황</div>' +
				'</div>' +
				'<div class="widget_body widget-common timeList-widget work-shift">' +
				'  <div class="bookmarks_title">' +
				'    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
				'    <span id="shiftWorkType"></span>' +
				'    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
				'  </div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="shiftWorkList">' +
				'    </div>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget808Element').innerHTML = html;
	}
	
	// 위젯 데이터 넣기 
	function setDataWidgetMini808(shiftWorkStand){

        ajaxCall2("getListBox808List.do"
            , {stand: shiftWorkStand}
            , true
            , null
            , function(data) {
                if (data && data.data) {
                    const shiftWorkData = data.data;

                    shiftWorkStandard.length = 0;

                    if (shiftWorkData.teamData) {
                        for (var i = 0; i < shiftWorkData.teamData.length; i++) {
                            shiftWorkStandard.push(shiftWorkData.teamData[i].orgCd);
                        }

                        $('#shiftWorkType').text(shiftWorkData.teamData[shiftWorkDataIndex].orgNm);
                    }

                    if (shiftWorkData.shiftWorkData) {
                        var html = '';

                        for (var i = 0; i < shiftWorkData.shiftWorkData.length; i++) {
                            html +=
                                '      <div>' +
                                '        <span class="tag_icon green" id="shift' + (i + 1) + '"></span>' +
                                '        <span class="time" id="shiftTime' + (i + 1) + '"></span>' +
                                '        <span class="cnt" id="shiftCnt' + (i + 1) + '">6</span>' +
                                '        <span class="unit">명</span>' +
                                '      </div>';
                        }

                        document.querySelector('#shiftWorkList').innerHTML = html;
                        setDataWidget808(shiftWorkData.shiftWorkData);
                    }
                }
            })
	}
	
	// 위젯 wided html 코드 생성 및 데이터 넣기 
	function createWidgetWide808(){
		var html =
				'<div class="widget_header">' +
				'  <div class="widget_title">교대근무조 현황</div>' +
				'</div>' +
				'<div class="widget_body widget-common timeList-widget work-shift">' +
				'  <div class="bookmarks_title">' +
				'    <div class="tab_wrap" id="shiftWorkTab">' +
				'    </div>' +
				'  </div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="shiftWorkListLeft">' +
				'    </div>' +
				'    <div class="bookmark_list" id="shiftWorkListRight">' +
				'    </div>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget808Element').innerHTML = html;
	}

	// 위젯 wide 데이터 넣기 
	function setDataWidgetWide808(shiftWorkStand) {

        ajaxCall2("getListBox808List.do"
            , {stand: shiftWorkStand}
            , true
            , null
            , function(data) {
                if (data && data.data) {
                    const shiftWorkData = data.data;
                    /*
                    shiftWorkData = {
                        teamData: [{orgNm: '영업관리팀', orgCd: 'B01'}, {orgNm: '영업지원팀', orgCd: 'B02'}],
                        shiftWorkData: [
                            {sTime: '08:00', eTime: '21:00', shift: 2, shiftCnt: 23},
                            {sTime: '08:00', eTime: '18:00', shift: 3, shiftCnt: 16},
                            {sTime: '09:00', eTime: '16:00', shift: 4, shiftCnt: 16}
                        ]
                    }
                     */

                    var tabHtml = '';
                    var leftHtml = '';
                    var rightHtml = '';

                    if (shiftWorkData.teamData) {
                        for (var i = 0; i < shiftWorkData.teamData.length; i++) {
                            if (i == 0) {
                                tabHtml +=
                                    '      <div class="tab_menu active" value="' + shiftWorkData.teamData[i].orgCd + '">' + shiftWorkData.teamData[i].orgNm + '</div>';
                            } else {
                                tabHtml +=
                                    '      <div class="tab_menu" value="' + shiftWorkData.teamData[i].orgCd + '">' + shiftWorkData.teamData[i].orgNm + '</div>';
                            }
                        }

                        document.querySelector('#shiftWorkTab').innerHTML = tabHtml;
                    }

                    if (shiftWorkData.shiftWorkData) {
                        for (var i = 1; i < shiftWorkData.shiftWorkData.length + 1; i += 2) {
                            leftHtml +=
                                '      <div>' +
                                '        <span class="tag_icon green" id="shift' + i + '"></span>' +
                                '        <span class="time" id="shiftTime' + i + '"></span>' +
                                '        <span class="cnt" id="shiftCnt' + i + '"></span>' +
                                '        <span class="unit">명</span>' +
                                '      </div>';
                        }

                        for (var i = 2; i < shiftWorkData.shiftWorkData.length + 1; i += 2) {
                            rightHtml +=
                                '      <div>' +
                                '        <span class="tag_icon green" id="shift' + i + '"></span>' +
                                '        <span class="time" id="shiftTime' + i + '"></span>' +
                                '        <span class="cnt" id="shiftCnt' + i + '"></span>' +
                                '        <span class="unit">명</span>' +
                                '      </div>';
                        }

                        document.querySelector('#shiftWorkListLeft').innerHTML = leftHtml;
                        document.querySelector('#shiftWorkListRight').innerHTML = rightHtml;
                        setDataWidget808(shiftWorkData.shiftWorkData);
                    }
                }
            })
	}

	function setDataWidget808(shiftData){
		for (var i = 0; i < shiftData.length; i++){
			$('#shift' + (i+1)).text(shiftData[i].shift + "교대");
			$('#shiftCnt' + (i+1)).text(shiftData[i].shiftCnt);
			$('#shiftTime' + (i+1)).text(shiftData[i].sTime + "-" + shiftData[i].eTime);
		}
	}

	$(document).ready(function() {
		$('#widget808Element').on('click', '.arrowLeft', function() {
			shiftWorkDataIndex--;
			if (0 > shiftWorkDataIndex) {
	            shiftWorkDataIndex = shiftWorkStandard.length-1; 
	        }
	        
			setDataWidgetMini808(shiftWorkStandard[shiftWorkDataIndex]);
		});

		$('#widget808Element').on('click', '.arrowRight', function() {
			shiftWorkDataIndex++;
			
			if (shiftWorkDataIndex > shiftWorkStandard.length-1) {
	            shiftWorkDataIndex = 0; 
	        }
	        
			setDataWidgetMini808(shiftWorkStandard[shiftWorkDataIndex]);
		});

		$('#widget808Element').on('click', '.tab_menu', function() {
		    var tabValue = $(this).attr('value');
		    setDataWidgetWide808(tabValue); 
		    
		    $('#widget808Element .tab_menu.active').removeClass('active');
		    $('#widget808Element .tab_menu[value="' + tabValue + '"]').addClass('active');
		}); 
	});
</script>
<div class="widget" id="widget808Element"></div>
	