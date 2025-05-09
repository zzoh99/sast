<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 부서 근태 현황
	 */

	var widget807 = {
		size: null
	};

	var workTypeCount = 0;
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox807(size) {
		widget807.size = size;
		
		if (size === "normal") {
			createWidgetMini807();
		} else if (size === "wide") {
			createWidgetWide807();
		}
        setWidget807OrgList();
	}

	// 위젯 html 코드 생성
	function createWidgetMini807(){
		var html =
				'<div class="widget_header">' +
				'  <div class="widget_title">부서 근태 현황</div>' +
				'</div>' +
				'<div class="widget_body widget-common avatar-widget">' +
				'  <div class="bookmarks_title total-title select-outer">' +
				'    <div class="custom_select no_style">' +
				'      <button class="select_toggle select_toggle807">' +
				'        <span id="widget807CurrentOrgNm"></span><i class="mdi-ico">arrow_drop_down</i>' +
				'      </button>' +
				'      <div class="select_options numbers select_options807" id="widget807Button" style="visibility: hidden;">' +
				'      </div>' +
				'    </div>' +
				'    <span class="label ml-auto">전체</span><span class="cnt" id="teamWorkWorkerCnt"></span><span class="unit">명</span>' +
				'  </div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="teamWorkList">' +
				'    </div>' +
				'  </div>' +
				'</div>';
			
		document.querySelector('#widget807Element').innerHTML = html;
	}

	// 위젯 데이터 넣기 
	function setDataWidgetMini807(orgCd) {

        ajaxCall2("getListBox807List.do"
            , "searchOrgCd=" + orgCd
            , true
            , null
            , function(data) {
                if (data && data.data) {
                    const teamWorkData = data.data;

                    var html = '';

                    if (teamWorkData.teamWorkStatus) {
                        for (var i = 0; i < teamWorkData.teamWorkStatus.length; i++) {
                            html +=
                                '      <div>' +
                                '        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="teamWorkImg' + (i + 1) + '"></div>' +
                                '        <span class="name" id="teamWorkName' + (i + 1) + '"></span>' +
                                '        <span class="position" id="teamWorkJikwee' + (i + 1) + '"></span>' +
                                '        <span class="tag_icon a-status home" id="teamWorkType' + (i + 1) + '"></span>' +
                                '      </div>';
                        }

                        document.querySelector('#teamWorkList').innerHTML = html;
                        setDataWidget807(teamWorkData.teamWorkStatus, teamWorkData.enterCd);
                    }
                }
            })
	}
	
	// 위젯 wided html 코드 생성 및 데이터 넣기 
	function createWidgetWide807(){
		var html =
				'<div class="widget_header">' +
				'  <div class="widget_title">부서 근태 현황</div>' +
				'</div>' +
				'<div class="widget_body avatar-widget widget-common">' +
				'  <div class="bookmarks_title total-title select-outer">' +
				'    <div class="custom_select no_style">' +
				'      <button class="select_toggle select_toggle807">' +
				'        <span id="widget807CurrentOrgNm"></span><i class="mdi-ico">arrow_drop_down</i>' +
				'      </button>' +
				'      <div class="select_options numbers select_options807" id="widget807Button" style="visibility: hidden;">' +
				'      </div>' +
				'    </div>' +
				'    <span class="label ml-4">전체</span><span class="cnt" id="teamWorkWorkerCnt"></span><span class="unit">명</span>' +
				'  </div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="teamWorkListLeft">' +
				'    </div>' +
				'    <div class="bookmark_list" id="teamWorkListRight">' +
				'    </div>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget807Element').innerHTML = html;
	}
	
	// 위젯 wide 데이터 넣기 
	function satDataWidgetWide807(orgCd) {

        ajaxCall2("getListBox807List.do"
            , "searchOrgCd=" + orgCd
            , true
            , null
            , function(data) {
                if (data && data.data) {
                    const teamWorkData = data.data;

                    /*
                    teamWorkData = {
                        enterCd: 'HR',
                        teamWorkStatus: [
                            {orgNm: '영업관리팀', jikweeNm: '과장', name: '이낙표', type: '배우자출산', sabun: '101167'},
                            {orgNm: '영업관리팀', jikweeNm: '대리', name: '고길동', type: '재택근무', sabun: '101261'},
                            {orgNm: '영업관리팀', jikweeNm: '사원', name: '하근석', type: '연차', sabun: '101119'},
                            {orgNm: '영업지원팀', jikweeNm: '사원', name: '홍팀원', type: '연차', sabun: '101184'},
                            {orgNm: '영업지원팀', jikweeNm: '과장', name: '임엽숙', type: '재택근무', sabun: '101253'},
                            {orgNm: '영업지원팀', jikweeNm: '사원', name: '이이현', type: '연차', sabun: '101094'}
                        ]
                    };
                     */

                    if (teamWorkData.teamWorkStatus) {
                        var teamCount = teamWorkData.teamWorkStatus.length;
                        var leftHtml = '';
                        var rightHtml = '';

                        for (var i = 1; i < teamCount + 1; i += 2) {
                            leftHtml +=
                                '      <div>' +
                                '        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="teamWorkImg' + i + '"></div>' +
                                '        <span class="name" id="teamWorkName' + i + '"></span>' +
                                '        <span class="position" id="teamWorkJikwee' + i + '"></span>' +
                                '        <span class="tag_icon a-status home" id="teamWorkType' + i + '"></span>' +
                                '      </div>';
                        }

                        for (var i = 2; i < teamCount + 1; i += 2) {
                            rightHtml +=
                                '      <div>' +
                                '        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="teamWorkImg' + i + '"></div>' +
                                '        <span class="name" id="teamWorkName' + i + '"></span>' +
                                '        <span class="position" id="teamWorkJikwee' + i + '"></span>' +
                                '        <span class="tag_icon a-status home" id="teamWorkType' + i + '"></span>' +
                                '      </div>';
                        }

                        document.querySelector('#teamWorkListLeft').innerHTML = leftHtml;
                        document.querySelector('#teamWorkListRight').innerHTML = rightHtml;
                        setDataWidget807(teamWorkData.teamWorkStatus, teamWorkData.enterCd);
                    }
                }
            })
	}

	function setTeamWorkImgFile($elem, sabun, enterCd){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}

	function setDataWidget807(teamWorkData, enterCd) {
		for (var i = 0; i < teamWorkData.length; i++){
			var $elem = $('#teamWorkImg' + (i+1));
			
			$('#teamWorkName' + (i+1)).text(teamWorkData[i].name);
			$('#teamWorkJikwee' + (i+1)).text(teamWorkData[i].jikweeNm);
			$('#teamWorkType' + (i+1)).text(teamWorkData[i].type);
			setTeamWorkImgFile($elem, teamWorkData[i].sabun, enterCd);
		}
			
		$('#teamWorkWorkerCnt').text(teamWorkData.length);
	}

    function setWidget807OrgList() {

        addWidget807OrgComboEvent();

        ajaxCall2("getListBox807OrgList.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data) {
                    const orgList = data.data;

                    const teamHtml = Array.from(orgList).reduce((acc, cur) => acc += `<div class="option widget807OrgButton" value="\${cur.code}">\${cur.codeNm}</div>`, "");

                    document.querySelector('#widget807Button').innerHTML = teamHtml;
                    $('#widget807CurrentOrgNm').text(orgList[0].codeNm);

                    addWidget807ButtonClickEvent();

                    if (widget807.size === "normal") {
                        setDataWidgetMini807(orgList[0].code);
                    } else if (widget807.size === "wide") {
                        satDataWidgetWide807(orgList[0].code);
                    }
                }
            })
    }

    function addWidget807OrgComboEvent() {
        $('#widget807Element .select_toggle807').off("click").on('click', function() {
            const selectOptions = document.querySelector('.select_options807');
            if (selectOptions.style.visibility == 'hidden') {
                selectOptions.style.visibility = 'visible';
            } else {
                selectOptions.style.visibility = 'hidden';
            }
        });
    }

    function addWidget807ButtonClickEvent() {
        $('#widget807Element .widget807OrgButton').off('click').on('click', function() {

            let orgNm = $(this).text();
            let orgCd = $(this).attr("value");
            if (widget807.size === "normal") {
                setDataWidgetMini807(orgCd);
            } else if (widget807.size === "wide") {
                satDataWidgetWide807(orgCd);
            }
            $('#widget807CurrentOrgNm').text(orgNm);
            const selectOptions = document.querySelector('.select_options807');
            selectOptions.style.visibility = 'hidden';
        });
    }
</script>
<div class="widget" id="widget807Element"></div>
	
