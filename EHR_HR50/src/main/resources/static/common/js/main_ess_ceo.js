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
                //console.log('data', data);

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
function getMainEssCeoNotice() {
    const data = ajaxCall('/getListBox6List.do', 'searchRk=8', false).DATA;
    if(data != null && data != 'undefined') {
        let html = '';
        data.forEach(function(notice){
            html += '<li class="pointer" onclick="mainEssCeoOpenNoticeLayer(\''+ notice.bbsCd +'\', \'' + notice.bbsSeq+ '\')">' +
                    '  <span class="title">' + notice.title + '</span>' +
                    '  <span class="date">' + notice.regDate + '</span>' +
                    '</li>'
        });
        $("#noticeList").html(html);
    }
}

// 공지사항 레이어 팝업 호출
function mainEssCeoOpenNoticeLayer(bbsCd, bbsSeq){
    var url = "/Board.do?cmd=viewBoardReadPopup&";
    var $form = $('<form></form>');
    var param1 	= $('<input name="bbsCd" 	type="hidden" 	value="'+bbsCd+'" />');
    var param2 	= $('<input name="bbsSeq" 	type="hidden" 	value="'+bbsSeq+'" />');
    $form.append(param1).append(param2);
    $form.appendTo('body');
    url += $form.serialize() ;
    openPopup(url, new Array(), "940", "800");
}


// 결재정보 확인
function getMainEssCeoAppl() {
    const data = ajaxCall('/getMainEssAppl.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        $('#applAgreeCnt').html(data.applAgreeCnt);
    }
}

// 확인하지 않은 알림 건수
function getMainEssCeoNotification() {
    const data = ajaxCall('/getAlertInfoList.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        $("#unchkNotification").html(data.length + '건');
    }
}

// 인원현황 조회
function getMainEssCeoEmpCnt() {
    const data = ajaxCall('/getMainEssCeoEmpCnt.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        let allCnt = 0;
        for(let i=0; i < data.length; i++) {
            allCnt += data[i].empCnt;
            if(data[i].statusCd == 'AA') {
                // 재직
                $("#empWorkCnt").html(data[i].empCnt);
            } else if (data[i].statusCd == 'CA') {
                // 휴직
                $("#empLeaveCnt").html(data[i].empCnt);
            }
        }
        $("#empAllCnt").html(allCnt);
    }
}

// 퇴사현황 조회
function getMainEssCeoRetireInfo() {
    const data = ajaxCall('/getMainEssCeoRetireInfo.do', '', false).DATA;

    if(data != null && data != 'undefined') {
        $("#empRetCnt").html(data.retCnt);
        if(data.retRateGap == 0) {
            $("#retRateGap").html("퇴사율이 전년도와 동일합니다.");
        } else if (data.retRateGap < 0) {
            let gap = data.retRateGap*-1;
            $("#retRateGap").html('퇴사율이 전년도 보다 <span class="cnt">' + gap + '%</span> 낮습니다.');
        } else {
            $("#retRateGap").html('퇴사율이 전년도 보다 <span class="cnt">' + data.retRateGap + '%</span> 높습니다.');
        }
    }
}

// 주목할인재
function getMainEssCeoTalentEmployee(type) {
    let data = null;
    if(type == 'New'){
        data = ajaxCall('/getMainEssCeoNewEmployee.do', '', false).DATA;
    } else if(type == 'Core') {
        data = ajaxCall('/getMainEssCeoCoreEmployee.do', '', false).DATA;
    }

    if(data != null && data != 'undefined') {
        // 6개씩 묶어서 출력하기 위한 연산 처리
        let len = Math.ceil(data.length/6) * 6;
        let html = '';
        for(let i=0; i < len; i++) {
            let photoSrc = '';
            let name = '';
            let orgNm = '';
            let jikweeNm = '';

            if(i%6 == 0) {
                html += '<div class="swiper-slide widget-wrapper">' +
                        '  <div class="widget member-box">' +
                        '    <ul class="member-list">'
            }

            if(i < data.length) {
                name = data[i].name;
                orgNm = data[i].orgNm;
                jikweeNm = data[i].jikweeNm;
                photoSrc = data[i].photo;

                html += '<li>' +
                        '  <div class="avatar-wrap">' +
                        '    <img src="'+photoSrc+'" alt="profile">' +
                        '  </div>' +
                        '  <div class="profile">' +
                        '    <div><span class="team">' + orgNm + '</span></div>' +
                        '    <div class="name-wrap"><span class="name">'+name+'</span><span class="position">'+jikweeNm+'</span></div>' +
                        '  </div>' +
                        '</li>' ;
            } else {
                html += '<li><div class="avatar-wrap"></div><div class="profile"></div></li>';
            }

            if(i%6 == 5) {
                html += '</ul></div></div>'
            }
        }

        $('#talentEmployeeDiv').html(html);
        talentEmployeeSwipeAndLink();
    }
}


// 주목할 인재 슬라이드를 위한 변수 선언 및 함수 정의
var talentEmployee = {
    swiper: null
};

function talentEmployeeSwipeAndLink() {
    talentEmployee.swiper = new Swiper("#talent-employee-slide", {
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
	cnt: ['#243078', '#4a5a9c', '#16224f'],  // 기준색과 그보다 밝거나 어두운 톤
	cntPay: ['#5667ad', '#6f7bc0', '#8e96d4', '#aeb1e8', '#1b234d'],  // 다양한 밝기와 채도 변화
	perform: ['#727cba', '#c4c9f0', '#ffc304'],  // 부드러운 배색과 포인트 컬러
  },
  blue: {
    cnt: ['#087ef7', '#7fbeff', '#3b9cff'],
    cntPay: ['#73d3e5', '#8ae6f7', '#abf2ff', '#caf7ff', '#465166'],
    perform: ['#a185ff', '#e2d9ff', '#ffc304'],
  },
  skyblue: {
    cnt: ['#087ef7', '#7fbeff', '#3b9cff'],
    cntPay: ['#73d3e5', '#8ae6f7', '#abf2ff', '#caf7ff', '#465166'],
    perform: ['#a185ff', '#e2d9ff', '#ffc304'],
  },
  greenOrange: {
    cnt: ['#007eec', '#cde7ff', '#70bcff'],
    cntPay: ['#ffb055', '#ffd19c', '#ffe0bb', '#ffecd6', '#515151'],
    perform: ['#1649c0', '#bdd1ff', '#ffb055'],
  },
  green: {
	cnt: ['#1dbc52', '#53e07a', '#35c469'],
	cntPay: ['#66e497', '#7ff5af', '#a0ffc9', '#c2ffd7', '#2b7c39'],
	perform: ['#7fe57b', '#d9f8d4', '#ffc304'],
  },
  chicken: {
    cnt: ['#f14d3b', '#ffc3bb', '#ff9492'],
    cntPay: ['#fbb725', '#ffd16f', '#ffe4a9', '#fff0d0', '#473737'],
    perform: ['#a3232c', '#f9c6ca', '#fbb725'],
  },
  orange: {
    cnt: ['#f14d3b', '#ffc3bb', '#ff9492'],
    cntPay: ['#fbb725', '#ffd16f', '#ffe4a9', '#fff0d0', '#473737'],
    perform: ['#a3232c', '#f9c6ca', '#fbb725'],
  },
  red: {
    cnt: ['#d12b1b', '#ffd3cf', '#ffb3ac'],
    cntPay: ['#fbb725', '#ffd16f', '#ffe4a9', '#fff0d0', '#473737'],
    perform: ['#a7463c', '#e5c6c2', '#fbb725'],
  },
  gold: {
    cnt: ['#c7ac65', '#d9d3c2', '#c0b28d'],
    cntPay: ['#c3751b', '#f1a54c', '#fdca8f', '#ffead2', '#4c442f'],
    perform: ['#806947', '#e0cfb5', '#ffd24d'],
  },
};

// 인원현황 차트
function drawPersonnelStatus(num) {
    const series = [];
    const categories = [];


    let s = null;

    const data_1 = [], data_2 = [], data_3 = [];
    const data = ajaxCall('/getMainEssCeoPsnlStatus'+num+'.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        data.forEach(function(value){
            if(value.chartName == '임원') {
                categories.push(value.category);
                data_1.push(value.cnt);
            } else if (value.chartName == '일반') {
                data_2.push(value.cnt);
            } else if (value.chartName == '기타') {
                data_3.push(value.cnt);
            }
        })
    }
    

    // 임원
    s = {name: '임원', data: data_1, color: themes[session_theme].cnt[0]};
    series.push(s);

    // 일반직
    s = {name: '일반직', data: data_2, color: themes[session_theme].cnt[1]};
    series.push(s);

    // 기타
    s = {name: '기타', data: data_3, color: themes[session_theme].cnt[2]};
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

    $('#psnlStatusChart').html('');
    let psnlStatusChart = new ApexCharts(document.getElementById("psnlStatusChart"), options);
    psnlStatusChart.render();
}


// 본부별 실적 차트
function drawAchieveStatusChart() {
    const series = [];
    const categories = [];

    let s = null;

    const data_1 = [], data_2 = [], data_3 = [];

    // TODO 목데이터 -> 실데이터로 적용 필요
    categories.push('HR');
    categories.push('전략사업');
    categories.push('경영전략');
    categories.push('디지털융합');

    data_1.push(92);
    data_1.push(63);
    data_1.push(57);
    data_1.push(35);

    data_2.push(85);
    data_2.push(70);
    data_2.push(55);
    data_2.push(40);

    data_3.push(82);
    data_3.push(60);
    data_3.push(61);
    data_3.push(22);

    // 달성
    s = {name: '달성', data: data_1, color: themes[session_theme].perform[0], type: 'bar'};
    series.push(s);

    // 목표
    s = {name: '목표', data: data_2, color: themes[session_theme].perform[1], type: 'bar'};
    series.push(s);

    // 전년 실적
    s = {name: '전년 실적', data: data_3, color: themes[session_theme].perform[2], type: 'line'};
    series.push(s);

    let options = {
        series: series,
        chart: {
            type: 'bar',
            height: 238,
            toolbar: {
                show: false
            }
        },
        plotOptions: {
            bar: {
                horizontal: false,
                dataLabels: {
                    position: 'bottom',
                    horizontalAlign: 'right',
                },
                columnWidth: 25,
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
            fontSize:'10px',      
            fontWeight: 400, 	
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

    $('#achieveStatusChart').html('');
    let achieveStatusChart = new ApexCharts(document.getElementById("achieveStatusChart"), options);
    achieveStatusChart.render();
}

// 인건비 현황 차트
function drawCostStatusChart() {
    const series = [];
    const categories = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

    let s = null;

    const data_1 = [], data_2 = [], data_3 = [], data_4 = [], data_5 = [];

    // TODO 목데이터 -> 실데이터로 적용 필요
    data_1.push(120);
    data_1.push(230);
    data_1.push(370);
    data_1.push(450);
    data_1.push(250);
    data_1.push(450);
    data_1.push(130);
    data_1.push(220);
    data_1.push(150);
    data_1.push(350);
    data_1.push(350);
    data_1.push(350);

    data_2.push(920);
    data_2.push(630);
    data_2.push(570);
    data_2.push(350);
    data_2.push(350);
    data_2.push(350);
    data_2.push(1350);
    data_2.push(350);
    data_2.push(3510);
    data_2.push(350);
    data_2.push(1350);
    data_2.push(1350);

    data_3.push(930);
    data_3.push(630);
    data_3.push(570);
    data_3.push(350);
    data_3.push(1350);
    data_3.push(350);
    data_3.push(350);
    data_3.push(1350);
    data_3.push(1350);
    data_3.push(1350);
    data_3.push(350);
    data_3.push(1350);
    
    data_4.push(940);
    data_4.push(640);
    data_4.push(1570);
    data_4.push(450);
    data_4.push(450);
    data_4.push(1450);
    data_4.push(450);
    data_4.push(1450);
    data_4.push(450);
    data_4.push(1450);
    data_4.push(450);
    data_4.push(1450);

    data_5.push(2200);
    data_5.push(3200);
    data_5.push(2200);
    data_5.push(2800);
    data_5.push(2500);
    data_5.push(4800);
    data_5.push(2600);
    data_5.push(3400);
    data_5.push(3500);
    data_5.push(2400);
    data_5.push(2300);
    data_5.push(5000);

    s = {name: '기본연봉', data: data_1, color: themes[session_theme].cntPay[0], type: 'bar'};
    series.push(s);

    s = {name: '성과급', data: data_2, color: themes[session_theme].cntPay[1], type: 'bar'};
    series.push(s);

    s = {name: 'OT', data: data_3, color: themes[session_theme].cntPay[2], type: 'bar'};
    series.push(s);

    s = {name: '휴가수당', data: data_4, color: themes[session_theme].cntPay[3], type: 'bar'};
    series.push(s);

    s = {name: '전년인건비', data: data_5, color: themes[session_theme].cntPay[4], type: 'line'};
    series.push(s);

    let options = {
        series: series,
        chart: {
            type: 'bar',
            stacked: true,
            height: 210,
            toolbar: {
                show: false
            }
        },
        plotOptions: {
            bar: {
                horizontal: false,
                dataLabels: {
                    position: 'bottom',
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
            enabled: true,
            enabledOnSeries: [4],
            formatter: function(val) {
                return val/100;
            },
            style: {
                fontSize: '8px',
                fontFamily: 'Helvetica, Arial, sans-serif',
                colors: undefined
            },
            background: {
                enabled: true,
                foreColor: '#fff',
                padding: 4,
                borderRadius: 10,
                borderWidth: 1,
                borderColor: '#fff',
                opacity: 0.9,
                dropShadow: {
                    enabled: false,
                    top: 1,
                    left: 1,
                    blur: 1,
                    color: '#000',
                    opacity: 0.45
                }
            },
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
            max: 6000
        },
    };

    $('#costStatusChart').html('');
    let costStatusChart = new ApexCharts(document.getElementById("costStatusChart"), options);
    costStatusChart.render();
}

function getMainEssCeoMemList(type) {
    let data = null;
    if(type == 'Exec'){
        $('#memListTitle').html('임원현황');
        data = ajaxCall('/getMainEssCeoExecMemList.do', '', false).DATA;

        if(data != null && data != 'undefined') {
            $('#memListCnt').html(data.length);

            let html = '';
            for(let i=0; i < data.length; i++) {
                let name = data[i].name;
                let orgNm = data[i].orgNm;
                let jikweeNm = data[i].jikweeNm;
                let careerCnt = data[i].careerCnt;
                let workNm = data[i].workNm;
                let photoSrc = data[i].photo;
                let color = 'green';

                if(workNm == '교육') color = 'blue';
                else if(workNm == '외근') color = 'red';

                html += '<li class="profile-card">' +
                    '  <div class="inner-wrap">' +
                    '    <div class="avatar-wrap">' +
                    '      <img src="' + photoSrc + '" alt="profile">' +
                    '    </div>' +
                    '    <div class="profile">' +
                    '      <div><span class="name">' + name + '</span><span class="label">근속</span><span class="year">' + careerCnt + '</span></div>' +
                    '      <div class="year-wrap"><span class="position">' + jikweeNm + '</span><span class="team">' + orgNm + '</span></div>' +
                    '    </div>' +
                    '  </div>' +
                    '  <span class="status ' + color + '">' + workNm + '</span>'
                '</li>';
            }

            $('#memList').html(html);
        }
    } else if(type == 'All') {
        $('#memListTitle').html('전직원');
        data = ajaxCall('/getMainEssCeoAllMemList.do', '', false).DATA;

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
                        '<span class="arrow pointer"><i class="mdi-ico filled" style="float: right;" id="orgIco'+orgCd+'">keyboard_arrow_down</i></span>' +
                        '</div>' +
                        '<ul class="card-list hide" id="teamMemList'+orgCd+'">'
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
    } else if(type == 'All') {
        $('#memListTitle').html('전직원');
        data = ajaxCall('/getMainEssCeoAllMemList.do', '', false).DATA;

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
                        '<span class="arrow pointer"><i class="mdi-ico filled" style="float: right;" id="orgIco'+orgCd+'">keyboard_arrow_down</i></span>' +
                        '</div>' +
                        '<ul class="card-list hide" id="teamMemList'+orgCd+'">'
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
    } else if (type == 'Leader') {
        $('#memListTitle').html('팀장현황');
        data = ajaxCall('/getMainEssCeoLeaderMemList.do', '', false).DATA;

        if(data != null && data != 'undefined') {
            $('#memListCnt').html(data.length);

            let html = '';
            for(let i=0; i < data.length; i++) {
                let name = data[i].name;
                let orgNm = data[i].orgNm;
                let jikweeNm = data[i].jikweeNm;
                let careerCnt = data[i].careerCnt;
                let workNm = data[i].workNm;
                let photoSrc = data[i].photo;
                let color = 'green';

                if(workNm == '교육') color = 'blue';
                else if(workNm == '외근') color = 'red';

                html += '<li class="profile-card">' +
                    '  <div class="inner-wrap">' +
                    '    <div class="avatar-wrap">' +
                    '      <img src="' + photoSrc + '" alt="profile">' +
                    '    </div>' +
                    '    <div class="profile">' +
                    '      <div><span class="name">' + name + '</span><span class="label">근속</span><span class="year">' + careerCnt + '</span></div>' +
                    '      <div class="year-wrap"><span class="position">' + jikweeNm + '</span><span class="team">' + orgNm + '</span></div>' +
                    '    </div>' +
                    '  </div>' +
                    '  <span class="status ' + color + '">' + workNm + '</span>'
                '</li>';
            }

            $('#memList').html(html);
        }
    } else if(type == 'Late') {
        $('#memListTitle').html('지각');
        $(".toggle-tab-wrap .toggle-tab li[rel=today]").click();

        data = ajaxCall('/getMainEssCeoLateMemList.do', '', false).DATA;

        if(data != null && data != 'undefined') {
            $('#memListCnt').html(data.length);

            let html = '';
            for(let i=0; i < data.length; i++) {
                let name = data[i].name;
                let orgNm = data[i].orgNm;
                let jikweeNm = data[i].jikweeNm;
                let photoSrc = data[i].photo;
                let lateCnt = data[i].lateCnt;

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
                        '  <span class="status hide"><span class="cnt">' + lateCnt + '</span>회 지각</span>'
                        '</li>';
            }
            $('#memList').html(html);
        }
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

//대표이사 총 인원 탭 
$(document).ready(function() {
    $('#numberPeople li:first').addClass('on');
    
    $('#numberPeople li a').click(function(e) {
        e.preventDefault();
        
        var tabId = $(this).attr('href');

        $('.widget.info').removeClass('active').hide();
        $(tabId).addClass('active').fadeIn();
        $('#numberPeople li').removeClass('on');
        $(this).parent().addClass('on');
    });
    
    $('#numberPeople li:first-child a').click();
    
//    console.log("session_theme : " + session_theme);
//    const themes = {
//	  greenOrange: {
//	    cnt: ['#007eec', '#cde7ff', '#70bcff'],
//	    cntPay: ['#ffb055', '#ffd19c', '#ffe0bb', '#515151'],
//	    perform: ['#1649c0', '#bdd1ff', '#ffb055'],
//	  }
//	};
//    console.log(themes[session_theme].cnt[0]);
});


function headerSearchCeo() {
    var searchWord = $('#mainHeaderSearchWord').val();

    var mainSearchModal = new window.top.document.LayerModal({
        id: 'keywordLayer',
        url: '/Popup.do?cmd=keywordLayer',
        parameters: { topKeyword: searchWord },
        width: 1300,
        height: 900,
        title: '사원조회'
    });
    mainSearchModal.show();
}



