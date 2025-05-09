<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	var widget503 = {
		size: null
	};

	var wokrTypeStand503 = '';
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox503(size) {
		widget503.size = size;
		
		if (size == "normal"){
			createWidgetMini503();
			setDataWidgetMini503();
		} else if (size == ("wide")){
			createWidgetWide503();
			setDataWidgetWide503();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini503(){
		var code =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">교육이수건수</div>' +
		    '</div>' +
		    '<div class="widget_body widget-common overtime-work">' +
		    '  <div class="bookmarks_title">' +
		    '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
		    '    <span id="w503_workName">전체</span>' +
		    '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
		    '  </div>' +
		    '  <div class="container_info">' +
		    '    <span class="info_title_num" id="w503m_cnt">10<span class="info_title unit">건</span></span>' +
		    '    <div class="info_box">' +
		    '      <span class="title_kor">평균</span><span class="box_bnum" id="w503m_avg">12</span><span class="title_kor">건</span>' +
		    '    </div>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget503Element').innerHTML = code;
	}
	
	// 위젯 데이터 넣기 
	function setDataWidgetMini503(wokrType){
	    var info = ajaxCall('getListBox503List.do', '', false).data;

	    if (!wokrType){
	    	wokrType = 'all';
		}

	    wokrTypeStand503 = wokrType;

        if (info != null){
            if (wokrType == 'all'){
                $('#w503_workName').text('전체');
                $("#w503m_cnt").html(info.totalCnt+'<span class="info_title unit">건</span>');
                $("#w503m_avg").text(info.totalAvgCnt);
            } else if (wokrType == 'jikgub'){
                $('#w503_workName').text('현직급('+info.jikweeNm+')');
                $("#w503m_cnt").html(info.jikgubCnt+'<span class="info_title unit">건</span>');
                $("#w503m_avg").text(info.jikgubAvgCnt);
            } else if (wokrType == 'nowYear'){
                $('#w503_workName').text('당해년도');
                $("#w503m_cnt").html(info.nowYearCnt + '<span class="info_title unit">건</span>');
                $("#w503m_avg").text(info.nowYearAvgCnt);
            }
        }
	}

	// 위젯 wided html 코드 생성 및 데이터 넣기 
	function createWidgetWide503(){
		var code =
		    '<div class="widget_header">' +
		    '  <div class="widget_title">교육이수건수</div>' +
		    '</div>' +
		    '<div class="widget_body attendance_contents annual-status">' +
		    '  <div class="container_box overtime-work widget-common">' +
		    '    <div class="container_info">' +
		    '      <span class="info_title" id="w503_name1">전체</span>' +
		    '      <span class="info_title_num" id="w503_cnt1">10<span class="info_title unit">건</span></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="w503_avg1">12</span><span class="title_kor">건</span>' +
		    '      </div>' +
		    '    </div>' +
		    '    <div class="container_info">' +
		    '      <span class="info_title" id="w503_name2">현직급(과장)</span>' +
		    '      <span class="info_title_num" id="w503_cnt2">5<span class="info_title unit">건</span></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="w503_avg2">4</span><span class="title_kor">건</span>' +
		    '      </div>' +
		    '    </div>' +
		    '    <div class="container_info">' +
		    '      <span class="info_title" id="w503_name3">당해년도</span>' +
		    '      <span class="info_title_num" id="w503_cnt3">1<span class="info_title unit">건</span></span>' +
		    '      <div class="info_box">' +
		    '        <span class="title_kor">평균</span><span class="box_bnum" id="w503_avg3">1</span><span class="title_kor">건</span>' +
		    '      </div>' +
		    '    </div>' +
		    '  </div>' +
		    '</div>';

		document.querySelector('#widget503Element').innerHTML = code;
	}

	function setDataWidgetWide503(){
		var info = ajaxCall('getListBox503List.do', '', false).data;

        if (info != null) {
            $("#w503_name2").text("현직급("+info.jikgubNm+")");

            // 건수
            $("#w503_cnt1, #w503_cnt2, #w503_cnt3").each((idx,ele) => {
                let str = '<span class="info_title unit">건</span>';
                if (ele.id.lastIndexOf(1) > -1) {
                    str = info.totalCnt + str;
                }else if (ele.id.lastIndexOf(2) > -1) {
                    str = info.jikgubCnt + str;
                }else {
                    str = info.nowYearCnt + str;
                }
                ele.innerHTML = str;
            });

            // 평균시간
            $("#w503_avg1").text(info.totalAvgCnt);
            $("#w503_avg2").text(info.jikgubAvgCnt);
            $("#w503_avg3").text(info.nowYearAvgCnt);
        }
	}

	$(document).ready(function() {
		$('#widget503Element').on('click', '.arrowRight', function() {
			if (wokrTypeStand503 == 'all'){
				setDataWidgetMini503('jikgub');
			} else if (wokrTypeStand503 == 'jikgub'){
				setDataWidgetMini503('nowYear');
			} else if (wokrTypeStand503 == 'nowYear'){
				setDataWidgetMini503('all');
			}
		});
		
		$('#widget503Element').on('click', '.arrowLeft', function() {
			if (wokrTypeStand503 == 'all'){
				setDataWidgetMini503('nowYear');
			} else if (wokrTypeStand503 == 'jikgub'){
				setDataWidgetMini503('all');
			} else if (wokrTypeStand503 == 'nowYear'){
				setDataWidgetMini503('jikgub');
			}
		});
	});
</script>
<div class="widget" id="widget503Element"></div>