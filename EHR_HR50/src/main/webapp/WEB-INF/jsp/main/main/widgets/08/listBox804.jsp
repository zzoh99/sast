<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 시간외 근무 사용현황 순위 
	 */

	var widget804 = {
		size: null
	};

	var overRankStandard = '';

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox804(size) {
		widget804.size = size;
		
		if (size == "normal"){
			createWidgetMini804();
			setDataWidgetMini804();
		} else if (size == ("wide")){
			createWidgetWide804();
			setDataWidgetWide804();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini804(overRankStand){
		if (typeof overRankStand == "undefined" || overRankStand == null || overRankStand == ""){
			overRankStand = "org";
		}
		
		if (overRankStand == "user"){
			var html =
						'<div class="widget_header">' +
						'  <div class="widget_title">시간외 근무 사용현황 순위</div>' +
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

			document.querySelector('#widget804Element').innerHTML = html;

		} else if (overRankStand == "org"){
			var html =
						'<div class="widget_header">' +
						'  <div class="widget_title">시간외 근무 사용현황 순위</div>' +
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
	
			document.querySelector('#widget804Element').innerHTML = html;
		}
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini804(overRankStand) {
		if (!overRankStand) {
			overRankStand = "org";
			overRankStandard = "org";
		}

        ajaxCall2("getListBox804List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data) {
		            const overTimeRank = data.data;

                    var html = '';

                    if (overRankStand == "user"){
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

                        document.querySelector('#overTimeUserList').innerHTML = html;
                        setOverTimeUserData(overTimeRank.userRank, overTimeRank.enterCd);

                    } else if (overRankStand == "org"){
                        for (var i = 0; i < overTimeRank.orgRank.length; i++){
                            html +=
                                    '<div>' +
                                    '  <span class="tag_icon green round">' + (i+1) + '</span>' +
                                    '  <span class="title" id="overTimeOrgNm' + (i+1) + '">신기술 R&D센터..</span>' +
                                    '  <span class="time" id="overTimeOrgTime' + (i+1) + '">124시간 25분</span>' +
                                    '</div>';
                        }

                        document.querySelector('#overTimeOrgList').innerHTML = html;
                        setOverTimeOrgData(overTimeRank.orgRank);
                    }
                }
            })
	}
	
	// 위젯 wide html 코드 생성
	function createWidgetWide804(){
		var html =
			  '<div class="widget_header">' +
			  '  <div class="widget_title">시간외 근무 사용현황 순위</div>' +
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

		document.querySelector('#widget804Element').innerHTML = html;
	}

	// 위젯 wide html 코드 생성
	function setDataWidgetWide804() {

        ajaxCall2("getListBox804List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data) {
                    const overTimeRank = data.data;
                    /*
                        overTimeRank = {
                            enterCd: 'HR',
                            userRank: [
                                {orgNm: 'R&D사업부', name: '권인혁', rank: 1, sabun: '101133'},
                                {orgNm: '인사관리부', name: '구인수', rank: 2, sabun: '101136'},
                                {orgNm: '영업부', name: '계상훈', rank: 3, sabun: '101153'}
                            ],
                            orgRank: [
                                {orgNm: 'R&D사업부', rank: 1, time: '16시간 00분'},
                                {orgNm: '인사관리부', rank: 2, time: '14시간 30분'},
                                {orgNm: '영업부', rank: 3, time: '12시간 30분'}
                            ]
                        };
                     */

                    var leftHtml = '';
                    var RightHtml = '';

                    for (var i = 0; i < overTimeRank.orgRank.length; i++) {
                        leftHtml +=
                            '<div>' +
                            '  <span class="tag_icon green round">' + (i + 1) + '</span>' +
                            '  <span class="title" id="overTimeOrgNm' + (i + 1) + '">신기술 R&D센터..</span>' +
                            '  <span class="time" id="overTimeOrgTime' + (i + 1) + '">124시간 25분</span>' +
                            '</div>';
                    }

                    for (var i = 0; i < overTimeRank.userRank.length; i++) {
                        RightHtml +=
                            '<div>' +
                            '  <span class="avatar-wrap">' +
                            '    <span class="tag_icon blue round">' + (i + 1) + '</span>' +
                            '    <span class="avatar"><img src="../assets/images/attendance_char_0.png" id="overTimeImg' + (i + 1) + '"></span>' +
                            '  </span>' +
                            '  <span class="name" id="overTimeName' + (i + 1) + '">박주호</span>' +
                            '  <span class="team ellipsis" id="overTimeOrg' + (i + 1) + '">Dev 개발/연구팀</span>' +
                            '</div>';
                    }

                    document.querySelector('#overTimeOrgList').innerHTML = leftHtml;
                    document.querySelector('#overTimeUserList').innerHTML = RightHtml;
                    setOverTimeOrgData(overTimeRank.orgRank);
                    setOverTimeUserData(overTimeRank.userRank, overTimeRank.enterCd)
                }
            })
	}

	function setOverRankFile($elem, sabun, enterCd){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}

	function setOverTimeUserData(userData,enterCd){
		for (var i = 0; i < userData.length; i++){
			if (userData[i].rank == 1){
				var $elem = $('#overTimeImg' + 1);

				$('#overTimeName1').text(userData[i].name);
				$('#overTimeOrg1').text(userData[i].orgNm);
				setOverRankFile($elem, userData[i].sabun, enterCd)
			} else if (userData[i].rank == 2){
				var $elem = $('#overTimeImg' + 2);
				
				$('#overTimeName2').text(userData[i].name);
				$('#overTimeOrg2').text(userData[i].orgNm);
				setOverRankFile($elem, userData[i].sabun, enterCd)
			} else if (userData[i].rank == 3){
				var $elem = $('#overTimeImg' + 3);
				
				$('#overTimeName3').text(userData[i].name);
				$('#overTimeOrg3').text(userData[i].orgNm);
				setOverRankFile($elem, userData[i].sabun, enterCd)
			}
		}
	}

	function setOverTimeOrgData(orgData){
		for (var i = 0; i < orgData.length; i++){
			if (orgData[i].rank == 1){
				$('#overTimeOrgNm1').text(orgData[i].orgNm);
				$('#overTimeOrgTime1').text(orgData[i].time);
			} else if (orgData[i].rank == 2){
				$('#overTimeOrgNm2').text(orgData[i].orgNm);
				$('#overTimeOrgTime2').text(orgData[i].time);
			} else if (orgData[i].rank == 3){
				$('#overTimeOrgNm3').text(orgData[i].orgNm);
				$('#overTimeOrgTime3').text(orgData[i].time);
			}
		}
	}

	$('#widget804Element').on('click', '.arrowRight', function() {
		if (overRankStandard == "org") {
			overRankStandard = "user"
		} else if (overRankStandard == "user") {
			overRankStandard = "org"
		}
		
		createWidgetMini804(overRankStandard);
		setDataWidgetMini804(overRankStandard);
	});

	$('#widget804Element').on('click', '.arrowLeft', function() {
		if (overRankStandard == "org") {
			overRankStandard = "user"
		} else if (overRankStandard == "user") {
			overRankStandard = "org"
		}
		
		createWidgetMini804(overRankStandard);
		setDataWidgetMini804(overRankStandard);
	});
</script>
<div class="widget" id="widget804Element"></div>