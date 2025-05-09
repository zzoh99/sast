<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 조직장 근태 현황
	 */

	var widget813 = {
		size: null
	};

	var workTypeCount = 0;
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox813(size) {
		widget813.size = size;
		
		if (size == "wide"){
			createWidgetWide813();
			satDataWidgetWide813();
		} else if (size == ("normal")){
			createWidgetMini813();
			setDataWidgetMini813();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini813(){
		var code =
					'<div class="widget_header">' +
					'  <div class="widget_title">조직장 근태 현황</div>' +
					'</div>' +
					'<div class="widget_body attend-status widget-common">' +
					'  <div class="bookmarks_title">' +
					'    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
					'    <span id="gntCdName">지각</span>' +
					'    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
					'  </div>' +
					'  <div class="container_info">' +
					'    <span class="info_title_num" id="attedanceCnt"><span class="info_title unit">명</span></span>' +
					'    <span class="info_title desc">전년대비<strong class="title_green" id="attedanceGapRate"></strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>' +
					'    <div class="btn-wrap">' +
					'      <button class="btn outline_gray btn-more attendanceDetail">더보기</button>' +
					'    </div>' +
					'  </div>' +
					'</div>';
			
		document.querySelector('#widget813Element').innerHTML = code;
	}

	// 위젯 데이터 넣기 
	function setDataWidgetMini813(stand) {
        ajaxCall2("getListBox813List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.attendanceStatus) {
	                const attendanceStatus = data.data.attendanceStatus;

	                if (!stand) {
                        stand = 0;
                    }

                    if (attendanceStatus.dataCnt.length > 0 ){

                        if (stand == attendanceStatus.dataCnt.length){
                            stand = 0;
                            workTypeCount = 0;
                        } else if (workTypeCount < 0) {
                            stand = attendanceStatus.dataCnt.length - 1;
                            workTypeCount = attendanceStatus.dataAllCnt.length - 1;
                        }

                        for (var i = 0; i < attendanceStatus.data.length; i++){
                            if (attendanceStatus.dataAllCnt[stand].gntCd == attendanceStatus.data[i].gntCd){
                                var html = attendanceStatus.data[i].rate;
                                document.querySelector('#attedanceGapRate').innerHTML = html;
                            }
                        }

                        var gntCountHtml = attendanceStatus.dataAllCnt[stand].gntCount + '<span class="info_title unit">명</span>'
                        document.querySelector('#attedanceCnt').innerHTML = gntCountHtml;
                        $('#gntCdName').text(attendanceStatus.dataAllCnt[stand].gntNm);

                    }
                }
            })
	}
	
	// 위젯 wided html 코드 생성 및 데이터 넣기 
	function createWidgetWide813(){
		var code =
					'<div class="widget_header">' +
					'  <div class="widget_title">조직장 근태 현황</div>' +
					'  <i class="mdi-ico">more_horiz</i>' +
					'</div>' +
					'<div class="widget_body avatar-widget">' +
					'  <div class="bookmarks_title">' +
					'    <div class="tab_wrap" id="workTypeNameTabList">' +
					'    </div>' +
					'  </div>' +
					'  <div class="bookmarks_wrap pt-30">' +
					'    <div class="bookmark_list" id="attendanceList1">' +
					'    </div>' +
					'    <div class="bookmark_list" id="attendanceList2">' +
					'    </div>' +
					'  </div>' +
					'</div>';

		document.querySelector('#widget813Element').innerHTML = code;
	}
	
	// 위젯 wide 데이터 넣기 
	function satDataWidgetWide813(workType) {
        ajaxCall2("getListBox813List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.attendanceStatus) {
                    const attendanceStatus = data.data.attendanceStatus;

                    var enterCd = attendanceStatus.enterCd;
                    var html = '';

                    // 탭 html 생성
                    if (attendanceStatus.dataCnt.length > 0){

                        for (var i = 0; i < attendanceStatus.dataCnt.length; i++){
                            if (i == 0){
                                html += '<div class="tab_menu active" value="' + attendanceStatus.dataCnt[i].gntCd + '">' + attendanceStatus.dataCnt[i].gntNm + '</div>'
                            } else {
                                html += '<div class="tab_menu" value="' + attendanceStatus.dataCnt[i].gntCd + '">' + attendanceStatus.dataCnt[i].gntNm + '</div>'
                            }
                        }

                        document.querySelector('#workTypeNameTabList').innerHTML = html;

                        if (!workType) {
                            workType = attendanceStatus.dataCnt[0].gntCd;
                        }

                        var filteredData = [];

                        for (var i = 0; i < attendanceStatus.dataList.length; i++) {
                            if (attendanceStatus.dataList[i].classify == workType) {
                                filteredData.push(attendanceStatus.dataList[i]);
                            }
                        }

                        if (filteredData.length > 0){

                            var code1 = '';
                            var code2 = '';

                            code1 =
                                '      <span class="total">' +
                                '        <span class="list-label">전체</span><span class="cnt" id="attendanceAllCnt"></span><span class="unit">명</span>' +
                                '      </span>';

                            // 좌측 html 코드
                            for (var i = 1; i < filteredData.length+1; i+=2){

                                code1 +=
                                    '      <div>' +
                                    '        <div class="avatar">' +
                                    '          <img src="../assets/images/attendance_char_0.png" id="attendanceImage' + i + '">' +
                                    '        </div>' +
                                    '        <span class="name" id="attendanceName' + i + '"></span>' +
                                    '        <span class="position"></span>' +
                                    '        <span class="team"></span>' +
                                    '      </div>';
                            }

                            // 우측 html 코드
                            for (var i = 2; i < filteredData.length+1; i+=2){
                                code2 +=
                                    '      <div>' +
                                    '        <div class="avatar">' +
                                    '          <img src="../assets/images/attendance_char_0.png" id="attendanceImage' + i + '">' +
                                    '        </div>' +
                                    '        <span class="name" id="attendanceName' + i + '"></span>' +
                                    '        <span class="position"></span>' +
                                    '        <span class="team"></span>' +
                                    '      </div>';
                            }

                            document.querySelector('#attendanceList1').innerHTML = code1;
                            document.querySelector('#attendanceList2').innerHTML = code2;
                            $('#attendanceAllCnt').text(filteredData.length);

                            // 리스트 데이터
                            for (var i = 0; i < filteredData.length; i++){
                                var $elemImage = $('#attendanceImage' + (i+1));
                                var $elemName = $('#attendanceName' + (i+1));

                                $elemImage.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + filteredData[i].sabun +"&t=" + (new Date()).getTime());
                                $elemName.text(filteredData[i].name);
                            }
                        }
                    }
                }
            })
	}

	$(document).ready(function() {
		$('#widget813Element').on('click', '.arrowRight', function() {
			workTypeCount++;
			setDataWidgetMini813(workTypeCount);
		});

		$('#widget813Element').on('click', '.arrowLeft', function() {
			workTypeCount--;
			setDataWidgetMini813(workTypeCount);
		});

		$('#widget813Element').on('click', '.tab_menu', function() {
		    var tabValue = $(this).attr('value');
		    satDataWidgetWide813(tabValue); 

		    $('#widget813Element .tab_menu.active').removeClass('active');
		    $('#widget813Element .tab_menu[value="' + tabValue + '"]').addClass('active');
		});

		/*
		 * TODO 차장님께서 11월 3일 금요일날 설명해주신다고 하셨음 
		 */
// 		$('#widget813Element').on('click', '.attendanceDetail', function() {
// 		});
	});
</script>
<div class="widget" id="widget813Element"></div>
	
