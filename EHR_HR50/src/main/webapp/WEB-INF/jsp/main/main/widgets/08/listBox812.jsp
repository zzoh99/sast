<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
    /*
     * 근태 > 부서원 근무 현황
     */

    var widget812 = {
        size: null
    };

    var workTypeCount = 0;

    /**
     * 파라미터에 따른 메서드 선택
     * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
     */
    function init_listBox812(size) {
        widget812.size = size;

        if (size === "normal") {
            createWidgetMini812();
        } else if (size === "wide") {
            createWidgetWide812();
        }
        //조직리스트 조회
        setWidget812ButtonList();
        
    }

    // 위젯 html 코드 생성
    function createWidgetMini812(){
        var html =
            '<div class="widget_header">' +
            '  <div class="widget_title">부서원 근무 현황</div>' +
            '</div>' +
            '<div class="widget_body widget-common achieve-rate avatar-widget">' +
            '  <div class="bookmarks_title total-title select-outer">' +
            '    <div class="custom_select no_style">' +
            '      <button class="select_toggle select_toggle812">' +
            '        <span id="widget812CurrentOrgNm"></span><i class="mdi-ico">arrow_drop_down</i>' +
            '      </button>' +
            '      <div class="select_options numbers select_options812" id="widget812Button" style="visibility: hidden;">' +
            '      </div>' +
            '    </div>' +
            '    <span class="label ml-auto">전체</span><span class="cnt" id="widget812WorkerCnt"></span><span class="unit">명</span>' +
            '  </div>' +
            '  <div class="bookmarks_wrap">' +
            '    <div class="bookmark_list" id="widget812List">' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.querySelector('#widget812Element').innerHTML = html;
    }

    // 위젯 데이터 넣기 
    function setDataWidgetMini812(){

        const param = {orgCd :   $('#widget812CurrentOrgCd').text() }
        ajaxCall2("getListBox812List.do"
            , param
            , true
            , null
            , function(data) {
                if (data && data.data) {

                    const teamWorkData = data.data;

                    if (teamWorkData.teamWorkStatus) {
                        let teamCount = teamWorkData.teamWorkStatus.length;
                        let teamHtml = '';
                        for (let i = 0; i < teamCount; i++) {
                            teamHtml +=
                                '      <div class="narrow-gap">' +
                                '        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="teamWorkImg' + i + '"></div>' +
                                '        <span class="name" id="widget812Name' + i + '"></span>' +
                                '        <span class="position" id="widget812Jikwee' + i + '"></span>' +
                                '        <span class="progress-wrap-center">' +
                                '          <span class="progress_container bar_orange" id="widget812ProgressBar' + i + '"></span>' +
                                '        </span>' +
                                '        <span><i class="mdi-ico" id="widget812Warning' + i + '"></i></span>' +
                                '        <span class="hour" id="widget812Hour' + i + '"></span>' +
                                '      </div>';
                        }

                        document.querySelector('#widget812List').innerHTML = teamHtml;
                        setDataWidget812(teamWorkData.teamWorkStatus, teamWorkData.enterCd);
                    }
                }
            })
    }

    // 위젯 wided html 코드 생성 및 데이터 넣기 
    function createWidgetWide812(){
        let html =
            '<div class="widget_header">' +
            '  <div class="widget_title">부서원 근무 현황</div>' +
            '</div>' +
            '<div class="widget_body widget-common achieve-rate avatar-widget">' +
            '  <div class="bookmarks_title total-title select-outer">' +
            '    <div class="custom_select no_style">' +
            '      <button class="select_toggle select_toggle812">' +
            '        <span id="widget812CurrentOrgNm"></span><span id="widget812CurrentOrgCd" style="display: none;"></span><i class="mdi-ico">arrow_drop_down</i>' +
            '      </button>' +
            '      <div class="select_options numbers select_options812" id="widget812Button" style="visibility: hidden;">' +
            '      </div>' +
            '    </div>' +
            '    <span class="label ml-4">전체</span><span class="cnt" id="widget812WorkerCnt"></span><span class="unit">명</span>' +
            '  </div>' +
            '  <div class="bookmarks_wrap">' +
            '    <div class="bookmark_list" id="widget812List">' +
            '    </div>' +
            '  </div>' +
            '</div>';

        document.querySelector('#widget812Element').innerHTML = html;
    }

    // 위젯 wide 데이터 넣기 
    function setDataWidgetWide812() {

    	const param = {orgCd :   $('#widget812CurrentOrgCd').text() };
        ajaxCall2("getListBox812List.do"
            , param
            , true
            , null
            , function(data) {
                if (data && data.data) {
                    const teamWorkData = data.data;

                    if (teamWorkData.teamWorkStatus) {
                        let teamCount = teamWorkData.teamWorkStatus.length;
                        let teamHtml = '';
                        for (let i = 0; i < teamCount; i++) {
                            teamHtml +=
                                '      <div class="narrow-gap">' +
                                '        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="teamWorkImg' + i + '"></div>' +
                                '        <span class="name" id="widget812Name' + i + '"></span>' +
                                '        <span class="position" id="widget812Jikwee' + i + '"></span>' +
                                '        <span class="progress-wrap-center">' +
                                '          <span class="progress_container bar_orange" id="widget812ProgressBar' + i + '"></span>' +
                                '        </span>' +
                                '        <span><i class="mdi-ico" id="widget812Warning' + i + '"></i></span>' +
                                '        <span class="hour" id="widget812Hour' + i + '"></span>' +
                                '      </div>';
                        }

                        document.querySelector('#widget812List').innerHTML = teamHtml;
                        setDataWidget812(teamWorkData.teamWorkStatus, teamWorkData.enterCd);
                    }
                }
            })
    }

    function setTeamWorkImgFile($elem, sabun, enterCd){
        $elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
    }
    
    function setWidget812ButtonList() {

        addWidget812ButtonEvent();

        ajaxCall2("getListBox812OrgList.do"
            , ""
            , true
            , null
            , function(result) {
                if (result && result.data) {
                    const data = result.data;

                    let teamHtml = '';

                    for (let i = 0; i < data.length; i++) {
                        teamHtml +=
                            '        <div class="option widget812OrgButton" value="' + data[i].code + '">' + data[i].codeNm + '</div>'
                    }

                    document.querySelector('#widget812Button').innerHTML = teamHtml;
                    $('#widget812CurrentOrgCd').text(data[0].code);
                    $('#widget812CurrentOrgNm').text(data[0].codeNm);

                    addWidget812ButtonClickEvent();

                    if (widget812.size === "normal") {
                        setDataWidgetMini812();
                    } else if (widget812.size === "wide") {
                        setDataWidgetWide812();
                    }
                }
            })
    }

    function addWidget812ButtonEvent() {
        $('#widget812Element').on('click', '.select_toggle812', function() {
            const selectOptions = document.querySelector('.select_options812');
            if (selectOptions.style.visibility == 'hidden') {
                selectOptions.style.visibility = 'visible';
            } else {
                selectOptions.style.visibility = 'hidden';
            }
        });
    }

    function addWidget812ButtonClickEvent() {
        $('#widget812Element .widget812OrgButton').off('click');
        $('#widget812Element').on('click', '.widget812OrgButton', function() {
            let orgNm = $(this).text();
            let orgCd = $(this).attr("value");
            if (widget812.size == "normal"){
                setDataWidgetMini812();
            } else if (widget812.size == "wide"){
                setDataWidgetWide812();
            }
            $('#widget812CurrentOrgNm').text(orgNm);
            $('#widget812CurrentOrgCd').text(orgCd);
            const selectOptions = document.querySelector('.select_options812');
            selectOptions.style.visibility = 'hidden';
        });
    }
    
    function setDataWidget812(teamWorkData, enterCd){

        for (let i = 0; i < teamWorkData.length; i++){
            let $elem = $('#teamWorkImg' + i);

            $('#widget812Name' + i).text(teamWorkData[i].name);
            $('#widget812Jikwee' + i).text(teamWorkData[i].jikweeNm);

            let barHtml = '<span class="progress_bar" style="width:'+ teamWorkData[i].progRate +'%"></span>'
            $('#widget812ProgressBar' + i).html(barHtml);

            // 진행률이 경과율보다 큰 경우 경고표시. 임시아이콘 사용으로 아이콘 변경 필요
            if(teamWorkData[i].elpsRate < teamWorkData[i].progRate)
                $('#widget812Warning' + i).text('notifications');

            $('#widget812Hour' + i).text(teamWorkData[i].weekAvg+"h / 52h");

            setTeamWorkImgFile($elem, teamWorkData[i].sabun, enterCd);
        }

        $('#widget812WorkerCnt').text(teamWorkData.length);
    }
/*
    $(document).ready(function() {
    	//조직리스트 조회
        setWidget812ButtonList();
        let selectOptions = document.querySelector('.select_options812');

        $('#widget812Element').on('click', '.select_toggle812', function() {
            selectOptions = document.querySelector('.select_options812');
            if (selectOptions.style.visibility == 'hidden') {
                selectOptions.style.visibility = 'visible';
            } else {
                selectOptions.style.visibility = 'hidden';
            }
        });
        
        $('#widget812Element').on('click', '.widget812OrgButton', function() {
            let orgNm = $(this).text();
            let orgCd = $(this).attr("value");
            if (widget812.size == "normal"){
                setDataWidgetMini812();
            } else if (widget812.size == "wide"){
                setDataWidgetWide812();
            }
            $('#widget812CurrentOrgNm').text(orgNm);
            $('#widget812CurrentOrgCd').text(orgCd);
            selectOptions.style.visibility = 'hidden';
        });

    });

 */
</script>
<div class="widget" id="widget812Element"></div>
	
