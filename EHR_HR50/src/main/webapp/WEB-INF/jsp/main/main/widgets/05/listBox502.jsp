<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	var widget502 = {
		size: null
	};

	var wokrTypeStand502 = '';
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox502(size) {
		widget502.size = size;
		
		if (size == "normal"){
			createWidgetMini502();
			setDataWidgetMini502();
		} else if (size == ("wide")){
			createWidgetWide502();
			setDataWidgetWide502();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini502(){
		var code =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">교육이수시간</div>' +
		    '</div>' +
		    '<div class="widget_body widget-common overtime-work">' +
		    '  <div class="bookmarks_title">' +
		    '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
		    '    <span id="w502_workName">전체</span>' +
		    '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
		    '  </div>' +
		    '  <div class="container_info">' +
		    '    <span class="info_title_num" id="w502m_hour">56<span class="info_title unit">시간</span></span>' +
		    '    <div class="info_box">' +
		    '      <span class="title_kor">평균</span><span class="box_bnum" id="w502m_avg">30</span><span class="title_kor">시간</span>' +
		    '    </div>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget502Element').innerHTML = code;
	}
	
	// 위젯 데이터 넣기 
	function setDataWidgetMini502(wokrType){
	    var info = ajaxCall('getListBox502List.do', '', false).data;
        console.log(info);
	    if (!wokrType){
	    	wokrType = 'all';
		}
	    wokrTypeStand502 = wokrType;

	    if (info != null){
		    if (wokrType == 'all'){
		        $('#w502_workName').text('전체');
                $("#w502m_hour").html(info.totalHour+'<span class="info_title unit">시간</span>');
                $("#w502m_avg").text(info.totalAvgHour);
		    } else if (wokrType == 'jikwee'){
		        $('#w502_workName').text('현직급('+info.jikweeNm+')');
                $("#w502m_hour").html(info.jikgubHour+'<span class="info_title unit">시간</span>');
                $("#w502m_avg").text(info.jikgubAvgHour);
		    } else if (wokrType == 'nowYear'){
		        $('#w502_workName').text('당해년도');
                $("#w502m_hour").html(info.nowYearHour + '<span class="info_title unit">시간</span>');
                $("#w502m_avg").text(info.nowYearAvgHour);
		    }
		}
	}

	// 위젯 wided html 코드 생성 및 데이터 넣기 
	function createWidgetWide502(){
		var code =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">교육이수시간</div>' +
		    '</div>' +
		    '<div class="widget_body attendance_contents annual-status">' +
		    '  <div class="container_box overtime-work widget-common">' +
		    '    <div class="container_info">' +
		    '      <span class="info_title" id="w502_name1">전체</span>' +
		    '      <span class="info_title_num" id="w502_hour1">0<span class="info_title unit">시간</span></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="w502_avg1">0</span><span class="title_kor">시간</span>' +
		    '      </div>' +
		    '    </div>' +
		    '    <div class="container_info">' +
		    '      <span class="info_title" id="w502_name2">현직급(과장)</span>' +
		    '      <span class="info_title_num" id="w502_hour2">0<span class="info_title unit">시간</span></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="w502_avg2">0</span><span class="title_kor">시간</span>' +
		    '      </div>' +
		    '    </div>' +
		    '    <div class="container_info">' +
		    '      <span class="info_title" id="w502_name3">당해년도</span>' +
		    '      <span class="info_title_num" id="w502_hour3">0<span class="info_title unit">시간</span></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="w502_avg3">0</span><span class="title_kor">시간</span>' +
		    '      </div>' +
		    '    </div>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget502Element').innerHTML = code;
	}

	function setDataWidgetWide502(){
		var info = ajaxCall('getListBox502List.do', '', false).data;

        if (info != null) {
            $("#w502_name2").text("현직급("+info.jikweeNm+")");

            // 시간
            $("#w502_hour1, #w502_hour2, #w502_hour3").each((idx,ele) => {
                let str = '<span class="info_title unit">시간</span>';
                if (ele.id.lastIndexOf(1) > -1) {
                     str = info.totalHour + str;
                }else if (ele.id.lastIndexOf(2) > -1) {
                    str = info.jikgubHour + str;
                }else {
                    str = info.nowYearHour + str;
                }
                ele.innerHTML = str;
            });

            // 평균시간
            $("#w502_avg1").text(info.totalAvgHour);
            $("#w502_avg2").text(info.jikgubAvgHour);
            $("#w502_avg3").text(info.nowYearAvgHour);
        }
	}

	$(document).ready(function() {
		$('#widget502Element').on('click', '.arrowRight', function() {
			if (wokrTypeStand502 == 'all'){
				setDataWidgetMini502('jikwee');
			} else if (wokrTypeStand502 == 'jikwee'){
				setDataWidgetMini502('nowYear');
			} else if (wokrTypeStand502 == 'nowYear'){
				setDataWidgetMini502('all');
			}
		});
		
		$('#widget502Element').on('click', '.arrowLeft', function() {
			if (wokrTypeStand502 == 'all'){
				setDataWidgetMini502('nowYear');
			} else if (wokrTypeStand502 == 'jikwee'){
				setDataWidgetMini502('all');
			} else if (wokrTypeStand502 == 'nowYear'){
				setDataWidgetMini502('jikwee');
			}
		});
	});
</script>
<div class="widget" id="widget502Element"></div>