<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 탄력근로제 현황
	 */

	var widget809 = {
		size: null
	};

	var flexibleWorkOption = [];
	var currentTeamDataIndex = 0;
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox809(size) {
		widget809.size = size;
		
		if (size == "normal"){
			createWidgetMini809();
			setDataWidgetMini809();
		} else if (size == ("wide")){
			createWidgetWide809();
			setDataWidgetWide809();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini809(){
		var html =
			  '<div class="widget_header">' +
			  '  <div class="widget_title">탄력근로제 현황</div>' +
			  '</div>' +
			  '<div class="widget_body widget-common timeList-widget short">' +
			  '  <div class="sub-title" id="flexibleWorkToday"></div>' +
			  '  <div class="bookmarks_title">' +
			  '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
			  '    <span id="currentFlexibleWorkType">생산직 탄력근로제</span>' +
			  '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
			  '  </div>' +
			  '  <div class="bookmarks_wrap">' +
			  '    <div class="bookmark_list" id="flexibleWorkList">' +
			  '    </div>' +
			  '  </div>' +
			  '</div>';

		document.querySelector('#widget809Element').innerHTML = html;
	}
	
	// 위젯 데이터 넣기 
	function setDataWidgetMini809(option) {

        ajaxCall2("getListBox809List.do"
            , {option: option}
            , true
            , null
            , function(data) {
                if (data && data.data) {

                    const flexibleWorkData = data.data;

                    flexibleWorkOption = [];

                    if (flexibleWorkData.teamData) {
                        for (var i = 0; i < flexibleWorkData.teamData.length; i++) {
                            flexibleWorkOption.push(flexibleWorkData.teamData[i].orgCd);
                        }

                        $('#currentFlexibleWorkType').text(flexibleWorkData.teamData[currentTeamDataIndex].orgNm);
                    }

                    if (flexibleWorkData.flexibleWorkData) {
                        var html = '';

                        for (var i = 0; i < flexibleWorkData.flexibleWorkData.length; i++) {
                            html +=
                                '      <a href="#">' +
                                '        <div>' +
                                '          <span class="time" id="flexibleWorkTime' + (i + 1) + '"></span>' +
                                '          <span class="cnt" id="flexibleWorkCnt' + (i + 1) + '"></span>' +
                                '          <span class="unit">명</span>' +
                                '          <i class="mdi-ico">keyboard_arrow_right</i>' +
                                '        </div>' +
                                '      </a>';
                        }

                        document.querySelector('#flexibleWorkList').innerHTML = html;
                        setDataWidget809(flexibleWorkData.flexibleWorkData);
                    }
                }
            })
	}
	
	// 위젯 wided html 코드 생성 및 데이터 넣기 
	function createWidgetWide809(){
		var html = 
				'<div class="widget_header">' +
				'  <div class="widget_title">탄력근로제 현황<span class="sub-title" id="flexibleWorkToday"></span></div>' +
				'</div>' +
				'<div class="widget_body widget-common timeList-widget">' +
				'  <div class="bookmarks_title">' +
				'    <div class="tab_wrap" id="flexibleWorkTab">' +
				'    </div>' +
				'  </div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="flexibleWorkListLeft">' +
				'    </div>' +
				'    <div class="bookmark_list" id="flexibleWorkListRight">' +
				'    </div>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget809Element').innerHTML = html;
	}

	// 위젯 wide 데이터 넣기 
	function setDataWidgetWide809(option) {

        ajaxCall2("getListBox809List.do"
            , {option: option}
            , true
            , null
            , function(data) {
                if (data && data.data) {

                    const flexibleWorkData = data.data;
                    /*
                    flexibleWorkData = {
                        teamData: [{orgNm: '영업관리팀', orgCd: 'B01'}, {orgNm: '영업지원팀', orgCd: 'B02'}],
                        flexibleWorkData: [
                            {sTime: '08:00', eTime: '17:00', shift: 2, shiftCnt: 23},
                            {sTime: '08:00', eTime: '18:00', shift: 3, shiftCnt: 16},
                            {sTime: '09:00', eTime: '16:00', shift: 4, shiftCnt: 16}
                        ],
                    };
                     */
                    var tabHtml = '';
                    var leftHtml = '';
                    var rightHtml = '';

                    if (flexibleWorkData.teamData) {
                        for (var i = 0; i < flexibleWorkData.teamData.length; i++) {
                            if (i == 0) {
                                tabHtml +=
                                    '      <div class="tab_menu active" value="' + flexibleWorkData.teamData[i].orgCd + '">' + flexibleWorkData.teamData[i].orgNm + '</div>';
                            } else {
                                tabHtml +=
                                    '      <div class="tab_menu" value="' + flexibleWorkData.teamData[i].orgCd + '">' + flexibleWorkData.teamData[i].orgNm + '</div>';
                            }
                        }

                        document.querySelector('#flexibleWorkTab').innerHTML = tabHtml;
                    }

                    if (flexibleWorkData.flexibleWorkData) {
                        for (var i = 1; i < flexibleWorkData.flexibleWorkData.length + 1; i += 2) {
                            leftHtml +=
                                '      <a href="#">' +
                                '        <div>' +
                                '          <span class="time" id="flexibleWorkTime' + i + '"></span>' +
                                '          <span class="cnt" id="flexibleWorkCnt' + i + '"></span>' +
                                '          <span class="unit">명</span>' +
                                '          <i class="mdi-ico">keyboard_arrow_right</i>' +
                                '        </div>' +
                                '      </a>';
                        }

                        for (var i = 2; i < flexibleWorkData.flexibleWorkData.length + 1; i += 2) {
                            rightHtml +=
                                '      <a href="#">' +
                                '        <div>' +
                                '          <span class="time" id="flexibleWorkTime' + i + '"></span>' +
                                '          <span class="cnt" id="flexibleWorkCnt' + i + '"></span>' +
                                '          <span class="unit">명</span>' +
                                '          <i class="mdi-ico">keyboard_arrow_right</i>' +
                                '        </div>' +
                                '      </a>';
                        }

                        document.querySelector('#flexibleWorkListLeft').innerHTML = leftHtml;
                        document.querySelector('#flexibleWorkListRight').innerHTML = rightHtml;
                        setDataWidget809(flexibleWorkData.flexibleWorkData);
                    }
                }
            })
	}

	function setDataWidget809(flexibleWorkData){
		const now = new Date();
	    const year = now.getFullYear();
	    const month = (now.getMonth() + 1);
	    const day = now.getDate();
	    $('#flexibleWorkToday').text(year + '년 ' + month + '월 ' + day + '일')

		for (var i = 0; i < flexibleWorkData.length; i++){
			$('#flexibleWorkCnt' + (i+1)).text(flexibleWorkData[i].shiftCnt);
			$('#flexibleWorkTime' + (i+1)).text(flexibleWorkData[i].sTime + "-" + flexibleWorkData[i].eTime);
		}
	}

	$(document).ready(function() {
		$('#widget809Element').on('click', '.arrowLeft', function() {
			currentTeamDataIndex--;
			if (0 > currentTeamDataIndex) {
	            currentTeamDataIndex = flexibleWorkOption.length-1; 
	        }
	        
			setDataWidgetMini809(flexibleWorkOption[currentTeamDataIndex]);
		});

		$('#widget809Element').on('click', '.arrowRight', function() {
			currentTeamDataIndex++;
			
			if (currentTeamDataIndex > flexibleWorkOption.length-1) {
	            currentTeamDataIndex = 0; 
	        }
	        
			setDataWidgetMini809(flexibleWorkOption[currentTeamDataIndex]);
		});
		
		$('#widget809Element').on('click', '.tab_menu', function() {
		    var tabValue = $(this).attr('value');
		    setDataWidgetWide809(tabValue); 
		    
		    $('#widget809Element .tab_menu.active').removeClass('active');
		    $('#widget809Element .tab_menu[value="' + tabValue + '"]').addClass('active');
		}); 
	});
</script>
<div class="widget" id="widget809Element"></div>
	