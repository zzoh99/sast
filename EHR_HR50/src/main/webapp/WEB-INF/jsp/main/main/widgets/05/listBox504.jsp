<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	var widget504 = {
		size: null
	};

	var overRankStandard = '';

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox504(size) {
		widget504.size = size;
		
		if (size == "normal"){
			createWidgetMini504();
			setDataWidgetMini504();
		} else if (size == ("wide")){
			createWidgetWide504();
			setDataWidgetWide504();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini504(overRankStand){
		if (typeof overRankStand == "undefined" || overRankStand == null || overRankStand == ""){
			overRankStand = "org";
		}
		
		if (overRankStand == "user"){
			var html =
						'<div class="widget_header">' +
						'  <div class="widget_title">교육이수시간 순위</div>' +
						'</div>' +
						'<div class="widget_body widget-common best-top">' +
						'  <div class="bookmarks_title">' +
						'    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
						'    <span>개인별 상위 Top 3</span>' +
						'    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
						'  </div>' +
						'  <div class="avatar-list" id="overTimeUserList">' +
						'  </div>' +
						'  <!-- hover 시 말풍선 -->' +
						'  <div class="speech-bubble">' +
						'    <span class="name">박주호<span class="team divider">Dev 개발/연구팀</span><span class="time divider">124시간 25분</span></span>' +
						'  </div>' +
						'</div>';

			document.querySelector('#widget504Element').innerHTML = html;

		} else if (overRankStand == "org"){
			var html =
						'<div class="widget_header">' +
						'  <div class="widget_title">교육이수시간 순위</div>' +
						'</div>' +
						'<div class="widget_body widget-common best-top">' +
						'  <div class="bookmarks_title">' +
						'    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
						'    <span>부서별 상위 Top 3</span>' +
						'    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
						'  </div>' +
						'  <div class="bookmark_list" id="overTimeOrgList">' +
						'  </div>' +
						'</div>';
	
			document.querySelector('#widget504Element').innerHTML = html;
		}
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini504(overRankStand){
		if (!overRankStand){
			overRankStand = "org";
			overRankStandard = "org";
		}
		
		const overTimeRank = ajaxCall('getListBox504List.do', '', false).data;

		var html = '';
		
		if (overRankStand == "user"){
            if (overTimeRank.userRank != null) {
                for (var i = 0; i < overTimeRank.userRank.length; i++){
                    html +=
                          '<div>' +
                          '  <span class="avatar-wrap">' +
                          '    <span class="tag_icon blue round">' + (i+1) + '</span>' +
                          '    <span class="avatar"><img src="../assets/images/attendance_char_0.png" id="overTimeImg' + (i+1) + '"></span>' +
                          '  </span>' +
                          '  <span class="name" id="overTimeName' + (i+1) + '">박주호</span>' +
                          '  <span class="team ellipsis" id="overTimeOrg' + (i+1) + '">Dev 개발/연구팀</span>' +
                          '</div>';
                }
            }

			document.querySelector('#overTimeUserList').innerHTML = html;
			setOverTimeUserData(overTimeRank.userRank);
			
		} else if (overRankStand == "org"){
            if (overTimeRank.orgRank != null) {
                for (var i = 0; i < overTimeRank.orgRank.length; i++){
                    html +=
                            '<div>' +
                            '  <span class="tag_icon green round">' + (i+1) + '</span>' +
                            '  <span class="title" id="overTimeOrgNm' + (i+1) + '">신기술 R&D센터..</span>' +
                            '  <span class="time" id="overTimeOrgTime' + (i+1) + '">0시간 0분</span>' +
                            '</div>';
                }
            }

			document.querySelector('#overTimeOrgList').innerHTML = html;
			setOverTimeOrgData(overTimeRank.orgRank);
		}
	}
	
	// 위젯 wide html 코드 생성
	function createWidgetWide504(){
		var html =
			  '<div class="widget_header">' +
			  '  <div class="widget_title">교육이수시간 순위</div>' +
			  '</div>' +
			  '<div class="widget_body attendance_contents annual-status overtime-work widget-common best-top">' +
			  '  <div class="container_box">' +
			  '    <div class="container_info">' +
			  '      <div class="list-title">부서별 상위 Top 3<span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span></div>' +
			  '      <div class="bookmark_list" id="overTimeOrgList">' +
			  '      </div>' +
			  '    </div>' +
			  '    <div class="container_info avatar-type">' +
			  '      <div class="list-title">개인별 상위 Top 3<span class="tag_icon blue round"><i class="mdi-ico">trending_up</i></span></div>' +
			  '      <div class="avatar-list" id="overTimeUserList">' +
			  '      </div>' +
			  '      <!-- hover 시 말풍선 -->' +
			  '      <div class="speech-bubble">' +
			  '        <span class="name">박주호<span class="team divider">본부장</span><span class="time divider">124시간 25분</span></span>' +
			  '      </div>' +
			  '    </div>' +
			  '  </div>' +
			  '</div>';

		document.querySelector('#widget504Element').innerHTML = html;
	}

	// 위젯 wide html 코드 생성
	function setDataWidgetWide504(){
		var overTimeRank = ajaxCall('getListBox504List.do', '', false).data;
		var leftHtml = '';
		var RightHtml = '';

        if (overTimeRank.orgRank != null ) {
            for (var i = 0; i < overTimeRank.orgRank.length; i++){
                leftHtml +=
                        '<div>' +
                        '  <span class="tag_icon green round">' + (i+1) + '</span>' +
                        '  <span class="title" id="overTimeOrgNm' + (i+1) + '">신기술 R&D센터..</span>' +
                        '  <span class="time" id="overTimeOrgTime' + (i+1) + '">0시간 0분</span>' +
                        '</div>';
            }
        }

        if (overTimeRank.userRank != null ) {
            for (var i = 0; i < overTimeRank.userRank.length; i++){
                RightHtml +=
                      '<div>' +
                      '  <span class="avatar-wrap">' +
                      '    <span class="tag_icon blue round">' + (i+1) + '</span>' +
                      '    <span class="avatar"><img src="../assets/images/attendance_char_0.png" id="overTimeImg' + (i+1) + '"></span>' +
                      '  </span>' +
                      '  <span class="name" id="overTimeName' + (i+1) + '">박주호</span>' +
                      '  <span class="team ellipsis" id="overTimeOrg' + (i+1) + '">Dev 개발/연구팀</span>' +
                      '</div>';
            }
        }

		document.querySelector('#overTimeOrgList').innerHTML = leftHtml;
		document.querySelector('#overTimeUserList').innerHTML = RightHtml;
		setOverTimeOrgData(overTimeRank.orgRank);
		setOverTimeUserData(overTimeRank.userRank)
	}

	function setOverRankFile($elem, sabun, enterCd){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}

	function setOverTimeUserData(userData){
        if (userData != null) {
            for (var i = 0; i < userData.length; i++){
                var $elem = $('#overTimeImg' + 1);
                $('#overTimeName'+(i+1)).text(userData[i].name);
                $('#overTimeOrg'+(i+1)).text(userData[i].orgNm);
                setOverRankFile($elem, userData[i].sabun, "${ssnEnterCd}")
            }
        }
	}

	function setOverTimeOrgData(orgData){
        if (orgData != null) {
            for (var i = 0; i < orgData.length; i++){
                $('#overTimeOrgNm'+(i+1)).text(orgData[i].orgNm);
                $('#overTimeOrgTime'+(i+1)).text(orgData[i].eduHour);
            }
        }
	}

	$('#widget504Element').on('click', '.arrowRight', function() {
		if (overRankStandard == "org") {
			overRankStandard = "user"
		} else if (overRankStandard == "user") {
			overRankStandard = "org"
		}
		
		createWidgetMini504(overRankStandard);
		setDataWidgetMini504(overRankStandard);
	});

	$('#widget504Element').on('click', '.arrowLeft', function() {
		if (overRankStandard == "org") {
			overRankStandard = "user"
		} else if (overRankStandard == "user") {
			overRankStandard = "org"
		}
		
		createWidgetMini504(overRankStandard);
		setDataWidgetMini504(overRankStandard);
	});
</script>
<div class="widget" id="widget504Element"></div>