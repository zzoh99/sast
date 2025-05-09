function getPanalAlertList(sabun, flag){
    var isPop = true;
    // 오늘 하루 그만보기  체크
    if( getCookie("panalAlertClose") != null ){
        var today = new Date();
        var tMonth = today.getMonth() + 1
        tMonth     = tMonth< 10 ? "0"+tMonth : tMonth;
        var tDay   = today.getDate()
        tDay       = tDay < 10 ? "0" + tDay : tDay;

        var cookieValue = sabun +"|"+ today.getFullYear() + tMonth + tDay;
        if (getCookie("panalAlertClose") == cookieValue ){
            // 오늘 하루 그만 보기 이미 체크된 경우면 알림 화면 열지 않게 하기 위함
            isPop = false;
        }

        if(flag) isPop = flag;
    }

    $.ajax({
        url: "/getPanalAlertList.do",
        type: "post",
        dataType: "json",
        async: true,
        data:"",
        success : function(rv) {
            var lst = rv.result;
            var str = "";
            for ( var i = 0; i < lst.length; i++) {  //
                str += "<li><a class='mdi-ico'>check</a>"+lst[i].title+"&nbsp;<a class='li_link' url='"+lst[i].linkUrl+"'>[바로가기]</span></li>";
            }

            if( str != "") {
                $("#panalAlert").html(str);
                $("#panalAlertDiv").draggable();
                $("ul#panalAlert li").on('click', function(e) {
                    var liLink = $(this).find('a.li_link');
                    goSubPage('', '', '', '', liLink.attr("url"));
                });
                setTimeout(function(){$("#alertInfo").show();},50);

                if (isPop) {
                    setTimeout(function(){ loadToastMsg(); $(".panalAlert").show(); }, 50);
                } else {
                    $("#panalAlert").html($("<li/>", { "class" : "mat10 mab10"}).text("등록된 알림사항이 없습니다."));
                }
            }

            $("#panalAlertDiv .btn-close").click(function(){  $(".panalAlert").hide(); });
            $("#alertInfo").click(function() {
                if( $(".panalAlert").css("display") == "none" ) {
                    $(".panalAlert").show();
                    // 개인 알림 데이터 조회
                    loadToastMsg();
                } else {
                    $(".panalAlert").hide();
                }
            });
        }
    });
}

function getPanalAlertList2(sabun, flag){

    var isPop = true;
    // 오늘 하루 그만보기  체크
    if( getCookie("panalAlertClose") != null ){
        var today = new Date();
        var tMonth = today.getMonth() + 1
        tMonth     = tMonth< 10 ? "0"+tMonth : tMonth;
        var tDay   = today.getDate()
        tDay       = tDay < 10 ? "0" + tDay : tDay;

        var cookieValue = sabun +"|"+ today.getFullYear() + tMonth + tDay;
        if (getCookie("panalAlertClose") == cookieValue ){
            // 오늘 하루 그만 보기 이미 체크된 경우면 알림 화면 열지 않게 하기 위함
            isPop = false;
        }

        if(flag) isPop = flag;
    }

    if(!isPop) return;

    let args = {};
    let layerModal = new window.top.document.LayerModal({
        id : 'alertPanelLayer'
        , url : '/viewAlertPanelLayer.do'
        , parameters : args
        , width : 540
        , height : 620
        , title : "알림"
        , trigger :[
            {
                name : 'alertPanelTrigger'
                , callback : function(result){
                }
            }
        ]
    });
    layerModal.show();
}

function loadToastMsg() {
    var _li, _listEle = $(".toastMsgList", "#panalAlertDiv");
    if( _listEle.length > 0 ) {
        $.ajax({
            url     : "/getAlertInfoList.do",
            type    : "post",
            dataType: "json",
            async   : true,
            data    : "",
            success : function(data) {
                if(data){
                    _listEle.empty();
                    var list = data.DATA;

                    if(list.length == 0) {
                        _listEle.html($("<li/>", {}).text("새로운 알림이 없습니다."));
                        $(".toastMsgBox", "#panalAlertDiv").css({
                            "height" : "35px"
                        });

                    } else {
                        for(var i = 0 ; i < list.length;i++){
                            var ob = list[i];

                            _li = $("<li/>", {
                                "seq" : ob.seq
                            });
                            _li.append(
                                $("<div/>", {
                                    "class" : "nTitle",
                                    "seq"   : ob.seq
                                })
                                    .append($("<a/>", {
                                        "class" : "btn_show"
                                    }))
                                    .append($("<span/>", {
                                        "class" : "date"
                                    }).text("[" + ob.regDate + "]"))
                                    .append(ob.nTitle)
                            );
                            _li.append(
                                $("<div/>", {
                                    "class" : "nContent"
                                })
                                    .html(ob.nContent)
                                    .append(
                                        $("<p/>", {
                                            "class" : "manage"
                                        })
                                            .append(
                                                $("<a />", {
                                                    "class" : "link hide",
                                                    "href" : "javascript:goDirectRecentToastMsg('" + ob.nLink + "', '" + ob.seq + "');"
                                                }).text("[바로가기]")
                                            )
                                            .append(
                                                $("<a />", {
                                                    "class" : "remove",
                                                    "href" : "javascript:deleteToastMsg('" + ob.seq + "');"
                                                }).text("[지우기]")
                                            )
                                    )
                            );

                            _li.find(".nTitle").addClass((ob.readYn == "Y") ? "readY" : "readN");

                            if( ob.nLink && ob.nLink != null && ob.nLink != "" ) {
                                _li.find(".link").removeclass("hide");
                            }

                            _listEle.append(_li);
                        };

                        $(".nTitle", _listEle).on("click", function(e){
                            var _seq = $(this).attr("seq");

                            if( $("li[seq='" + _seq + "']", _listEle).hasClass("active") ) {
                                $("li[seq='" + _seq + "']", _listEle).removeClass("active");
                                $("li[seq='" + _seq + "'] .nContent", _listEle).slideUp();
                            } else {
                                $("li[seq='" + _seq + "']", _listEle).addClass("active");
                                $("li[seq='" + _seq + "'] .nContent", _listEle).slideDown();

                                // 읽지 않은 알림인 경우
                                if( $("li[seq='" + _seq + "'] .nTitle", _listEle).hasClass("readN") ) {
                                    updateAlertInfoReadYn(_seq);
                                }
                            }
                        });
                        $(".remove", _listEle).on("click", function(e){
                        });
                    }
                }
            },
            error:function(e){
                alert("[개인 알림 데이터 조회 오류] messge : " + e.responseText);
            }
        });
    }
}

function changeUser(){
    const p = { adminYn: 'N', authPg: 'A', searchSabun: '${ssnSabun}' };
    const url = '/ChangePw.do?cmd=viewChgPwLayer';
    var changePwLayer = new window.top.document.LayerModal({
        id: 'changePwLayer',
        url: url,
        parameters: p,
        width: 461,
        height: 250,
        title: '비밀번호 설정'
    });
    changePwLayer.show();
}

// 공지사항 건수 확인
function getMainEssChiefNotice() {
    const data = ajaxCall('/getListBox6List.do', 'searchRk=8', false).DATA;
    if(data != null && data != 'undefined') {
        let html = '';
        data.forEach(function(notice){
            html += '<li class="pointer" onclick="mainEssChiefOpenNoticeLayer(\''+ notice.bbsCd +'\', \'' + notice.bbsSeq+ '\')">' +
                    '  <span class="title">' + notice.title + '</span>' +
                    '  <span class="date">' + notice.regDate + '</span>' +
                    '</li>'
        });
        $("#noticeList").html(html);
    }
}

// 공지사항 레이어 팝업 호출
function mainEssChiefOpenNoticeLayer(bbsCd, bbsSeq){
    var url = "/Board.do?cmd=viewBoardReadPopup&";
    var $form = $('<form></form>');
    var param1 	= $('<input name="bbsCd" 	type="hidden" 	value="'+bbsCd+'" />');
    var param2 	= $('<input name="bbsSeq" 	type="hidden" 	value="'+bbsSeq+'" />');
    $form.append(param1).append(param2);
    $form.appendTo('body');
    url += $form.serialize() ;
    openPopup(url, new Array(), "940", "800");
}

// 확인하지 않은 알림 건수
function getMainEssChiefNotification() {
    const data = ajaxCall('/getAlertInfoList.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        $("#unchkNotification").html(data.length + '건');
    }
}

// 구성원현황 조회
function getMainEssChiefMemList(searchOrgCd) {
    let data = null;
    data = ajaxCall('/getMainEssCeoAllMemList.do', 'searchOrgCd='+searchOrgCd, false).DATA;

    if(data != null && data != 'undefined') {
        $('#memListCnt').html(data.length);

        let html = '';
        let org = '';
        for(let i=0; i < data.length; i++) {


            let name = data[i].name;
            let orgNm = data[i].orgNm;
            let orgCd = data[i].orgCd;
            let teamCnt = data[i].teamCnt;
            let jikweeNm = data[i].jikweeNm;
            let workNm = data[i].workNm;
            let photoSrc = data[i].photo;
            let color = 'green';

            if(workNm == '교육') color = 'blue';
            else if(workNm == '외근') color = 'red';

            if (i == data.length) {
                html += '</ul></li>';
            }
            if(org != orgCd) {
                if (i > 0) {
                    html += '</ul></li>';
                }
                org = orgCd;
                html += '<li>' +
                    '<div class="team-list-wrap pointer" onclick="toggleTeamMemList(\''+orgCd+'\')">' +
                    '<span class="team">' +orgNm+ '</span><span class="cnt">'+teamCnt+'</span><span class="unit">명</span>' +
                    '<span class="arrow pointer"><i class="mdi-ico filled" style="float: right;" id="orgIco'+orgCd+'">keyboard_arrow_up</i></span>' +
                    '</div>' +
                    '<ul class="card-list" id="teamMemList'+orgCd+'">'
            }

            html += '<li class="profile-card simple">' +
                    '  <div class="inner-wrap">' +
                    '    <div class="avatar-wrap">' +
                    '      <img src="' + photoSrc + '" alt="profile">' +
                    '    </div>' +
                    '    <div class="profile">' +
                    '      <div><span class="name">' + name + '</span><span class="position">' + jikweeNm + '</span></div>' +
                    '      <div class="year-wrap"><span class="team">' + orgNm + '</span></div>' +
                    '    </div>' +
                    '  </div>' +
                    '  <span class="status ' + color + '">' + workNm + '</span>'
                    '</li>';
        }

        $('#memList').html(html);
    }
}

function toggleTeamMemList(orgCd) {
    if($('#teamMemList'+orgCd).hasClass('hide')) {
        $('#teamMemList'+orgCd).removeClass('hide');
        $('#orgIco'+orgCd).html('keyboard_arrow_up');
    } else {
        $('#teamMemList'+orgCd).addClass('hide');
        $('#orgIco'+orgCd).html('keyboard_arrow_down');
    }
}

// 연차현황
function getMainEssChiefVacationList() {
    const data = ajaxCall('/getListBox5List.do', '', false).DATA[0];
    if(data != null && data != 'undefined') {
        $("#vacationCreCnt").html(data.creCnt);
        $("#vacationRestCnt").html(data.restCnt);
    }

    const data2 = ajaxCall('/getMainEssChiefVacationList.do', '', false).DATA;

    if(data2 != null && data2 != 'undefined') {
        // 4개씩 묶어서 출력하기 위한 연산 처리
        let len = Math.ceil(data2.length/4) * 4;
        let html = '';
        for(let i=0; i < len; i++) {
            let name = '';
            let orgNm = '';
            let jikweeNm = '';
            let restCnt = '';

            if(i%4 == 0) {
                html += '<div class="swiper-slide widget-wrapper member-swipe">'
            }

            if(i < data2.length) {
                name = data2[i].name;
                orgNm = data2[i].orgNm;
                jikweeNm = data2[i].jikweeNm;
                restCnt = data2[i].restCnt;

                html += '<div class="member-item">' +
                        '  <div>' +
                        '    <span class="name">' + name + '</span>' +
                        '    <span class="position">' + jikweeNm + '</span>' +
                        '  </div>' +
                        '  <div class="remainder">' +
                        '    <span class="label">잔여</span>' +
                        '    <span class="cnt">' + restCnt + '</span>' +
                        '    <span class="unit">개</span>' +
                        '  </div>' +
                        '</div>';

            } else {
                html += '<div class="member-item"></div>';
            }

            if(i%4 == 3) {
                html += '</div>'
            }
        }

        $('#vacationSwipeDiv').append(html);
        vacationSwipeAndLink();
    }
}

// 팀원현황 슬라이드를 위한 변수 선언 및 함수 정의
var vacationSwiper = {
    swiper: null
};

function vacationSwipeAndLink() {
    vacationSwiper.swiper = new Swiper("#vacation-slide", {
        spaceBetween: 30,
        pagination: {
            el: ".swiper-pagination",
            type: 'bullets',
            clickable: true,
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        }
    });
}

//테마별 차트 색상 배열 선언
const themes = {
  navy: {
	  teamLeave: ['#087ef7'],
	  overWork: ['#a185ff'],
	  TeamEdu: ['#73d3e5'],
  },
  blue: {
	  teamLeave: ['#087ef7'],
	  overWork: ['#a185ff'],
	  TeamEdu: ['#73d3e5'],
  },
  skyblue: {
	  teamLeave: ['#087ef7'],
	  overWork: ['#a185ff'],
	  TeamEdu: ['#73d3e5'],
  },
  greenOrange: {
	  teamLeave: ['#007eec'],
	  overWork: ['#ffb055'],
	  TeamEdu: ['#3455f9'],
  },
  green: {
	  teamLeave: ['#1dbc52'],
	  overWork: ['#66e497'],
	  TeamEdu: ['#7fe57b'],
  },
  chicken: {
	  teamLeave: ['#f14d3b'],
	  overWork: ['#fbb725'],
	  TeamEdu: ['#a3232c'],
  },
  orange: {
	  teamLeave: ['#f14d3b'],
	  overWork: ['#fbb725'],
	  TeamEdu: ['#a3232c'],
  },
  red: {
	  teamLeave: ['#f14d3b'],
	  overWork: ['#fbb725'],
	  TeamEdu: ['#a3232c'],
  },
  gold: {
	  teamLeave: ['#c7ac65'],
	  overWork: ['#c3751b'],
	  TeamEdu: ['#806947'],
  },
};

// 팀원 휴가 현황 차트
function drawMainEssChiefVacationChart() {
    const series = [];
    const categories = [];

    let s = null;

    const data_1 = [], data_2 = [], data_3 = [];
    const data = ajaxCall('/getMainEssChiefVacationChart.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        data.forEach(function(value){
            categories.push(value.category);
            data_1.push(value.usedPer);
        })
    }

    s = {name: '', data: data_1, color: themes[session_theme].teamLeave[0]};
    series.push(s);

    let options = {
        series: series,
        chart: {
            type: 'bar',
            height: 210,
            toolbar: {
                show: false
            }
        },
        plotOptions: {
            bar: {
                horizontal: false,
                dataLabels: {
                    position: 'top',
                },
                columnWidth: 15,
            }
        },
        legend: {
            position: 'bottom',
            horizontalAlign: 'right',
            fontSize:'10px',
            fontWeight:400,
        },
        dataLabels: {
            enabled: false,
            offsetX: -6,
            style: {
                fontSize: '12px',
                colors: ['#fff']
            }
        },
        stroke: {
            show: true,
            width: 1,
            colors: ['#fff']
        },
        tooltip: {
            shared: true,
            intersect: false
        },
        xaxis: {
            categories: categories
        },
        yaxis: {
            show: true,
            tickAmount: 4,
        },
    };

    $('#vacationStatusChart').html('');
    let vacationStatusChart = new ApexCharts(document.getElementById("vacationStatusChart"), options);
    vacationStatusChart.render();
}

// 초과근무 현황 차트
function drawMainEssChiefOtChart() {
    const series = [];
    const categories = [];


    let s = null;

    const data_1 = [], data_2 = [], data_3 = [];
    const data = ajaxCall('/getMainEssChiefOtChart.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        data.forEach(function(value){
            categories.push(value.category);
            data_1.push(value.otHour);
        })
    }

    s = {name: '', data: data_1, color: themes[session_theme].overWork[0]};
    series.push(s);

    let options = {
        series: series,
        chart: {
            type: 'bar',
            height: 210,
            toolbar: {
                show: false
            }
        },
        plotOptions: {
            bar: {
                horizontal: false,
                dataLabels: {
                    position: 'top',
                },
                columnWidth: 15,
            }
        },
        legend: {
            position: 'bottom',
            horizontalAlign: 'right',
            fontSize:'10px',
            fontWeight:400,
        },
        dataLabels: {
            enabled: false,
            offsetX: -6,
            style: {
                fontSize: '12px',
                colors: ['#fff']
            }
        },
        stroke: {
            show: true,
            width: 1,
            colors: ['#fff']
        },
        tooltip: {
            shared: true,
            intersect: false
        },
        xaxis: {
            categories: categories
        },
        yaxis: {
            show: true,
            tickAmount: 4,
        },
    };

    $('#otStatusChart').html('');
    let otStatusChart = new ApexCharts(document.getElementById("otStatusChart"), options);
    otStatusChart.render();
}

// 팀 교육현황 차트
function drawMainEssChiefEduChart() {
    const series = [];
    const categories = [];

    let s = null;

    const data_1 = [], data_2 = [], data_3 = [];
    const data = ajaxCall('/getMainEssChiefEduChart.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        data.forEach(function(value){
            categories.push(value.category);
            data_1.push(value.eduHour);
        })
    }

    s = {name: '', data: data_1, color: themes[session_theme].TeamEdu[0]};
    series.push(s);

    let options = {
        series: series,
        chart: {
            type: 'bar',
            height: 210,
            toolbar: {
                show: false
            }
        },
        plotOptions: {
            bar: {
                horizontal: false,
                dataLabels: {
                    position: 'top',
                },
                columnWidth: 15,
            }
        },
        legend: {
            position: 'bottom',
            horizontalAlign: 'right',
            fontSize:'10px',
            fontWeight:400,
        },
        dataLabels: {
            enabled: false,
            offsetX: -6,
            style: {
                fontSize: '12px',
                colors: ['#fff']
            }
        },
        stroke: {
            show: true,
            width: 1,
            colors: ['#fff']
        },
        tooltip: {
            shared: true,
            intersect: false
        },
        xaxis: {
            categories: categories
        },
        yaxis: {
            show: true,
            tickAmount: 4,
        },
    };

    $('#eduStatusChart').html('');
    let eduStatusChart = new ApexCharts(document.getElementById("eduStatusChart"), options);
    eduStatusChart.render();
}

// 결재현황
function getMainEssChiefApplList() {
    let data = null;
    data = ajaxCall('/getMainEssChiefApplList.do', '', false).DATA;

    if(data != null && data != 'undefined') {
        let applEndCnt = 0;
        let html = '';

        for(let i=0; i < data.length; i++) {
            let statusClass = '';
            if(data[i].agreeStatusCd != '10') {
                applEndCnt++;
                statusClass = 'end';
            }

            html += '<li class="pointer" onclick="openApplMenu()">' +
                    '  <span class="status "'+statusClass+'>' + data[i].status +  '</span>' +
                    '  <span class="title">' + data[i].applNm + '</span>' +
                    '  <span class="name ml-auto">' + data[i].name + '</span>' +
                    '  <span class="date">' + data[i].applDate + '</span>' +
                    '</li>'
        }

        $('#applTotCnt').html(data.length+'건 중');
        $('#applEndCnt').html(applEndCnt+'건');

        $('#applListUl').html(html);
    }
}

// 결재문서 열기
function openApplMenu(){
    goSubPage("10", "", "", "", "AppBeforeLst.do?cmd=viewAppBeforeLst");

}

// 팀원 근무 정보 조회
function getMainEssChiefWorkEmp() {
    const data = ajaxCall('/getMainEssChiefWorkEmp.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        $('#workEmpCnt').html(data.workEmpCnt);
        $('#vacationEmpCnt').html(data.vacationEmpCnt);
    }
}

/*

const aspectRatio = 16 / 9;

//Get the container and calculate initial height based on the aspect ratio
const chartContainer = document.querySelector('#psnlStatusChart');
let initialWidth = chartContainer.offsetWidth;
let initialHeight = initialWidth / aspectRatio;


window.addEventListener('resize', function() {
    let currentWidth = chartContainer.offsetWidth;
    let newHeight = currentWidth / aspectRatio;
    
    ApexCharts.exec(chart.id, 'updateOptions', {
        chart: {
            width: currentWidth,
            height: newHeight
        }
    }, false, false); // false parameters prevent the update from being animated and reset
});
*/
