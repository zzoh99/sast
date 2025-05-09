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
function getMainEssNotice() {
    const data = ajaxCall('/getListBox6List.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        $("#noticeCnt").html(data.length);
    }
}

// 남은 연차 건수 확인
function getMainEssVacation() {
    const data = ajaxCall('/getListBox5List.do', '', false).DATA[0];
    if(data != null && data != 'undefined') {
        $("#vacationRestCnt").html(data.restCnt);
    }
}

// 결재정보 확인
function getMainEssAppl() {
    const data = ajaxCall('/getMainEssAppl.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        $('#applAgreeCnt').html(data.applAgreeCnt + "건");
        $('#applProgCnt').html(data.applProgCnt + "건");
        $('#applFinCnt').html(data.applFinCnt + "건");
    }
}

// 확인하지 않은 알림 건수
function getMainEssNotification() {
    const data = ajaxCall('/getAlertInfoList.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        $("#unchkNotification").html(data.length + '건');
    }
}

// 근태정보 확인
function getMainEssWorkTime() {
    const data = ajaxCall('/getMainEssWorkTime.do', '', false).DATA;
    if(data != null && data != 'undefined') {

        if(data.ehrInHm != '') {
            $(".work-btn").removeClass('on');
            $('#st').html(data.ehrInHm);
        }
        if(data.ehrOutHm != '') {
            $(".work-btn").attr("disabled", true);
            $('#et').html(data.ehrOutHm);
        }

        $('#totWorkHour').html(data.totHour + "시간");
    }
}

function prcMainEssWorkTime(type) {
    const param = "&gubun="+type;
    const data = ajaxCall('/prcMainEssWorkTime.do', param, false).DATA;
    if(data != null && data != 'undefined') {
        if (data.Message != '' && typeof(data.Message) != 'undefined') {
            alert(data.Message);
        }
    }
    getMainEssWorkTime();
}

// 동료일정 확인
function getMainEssPsnlTime() {
    const data = ajaxCall('/getMainEssPsnlTime.do', '', false).DATA;

    if(data != null && data != 'undefined') {
        // 4개씩 묶어서 출력하기 위한 연산 처리
        let len = Math.ceil(data.length/4) * 4;
        let html = '';
        for(let i=0; i < len; i++) {
            let photoSrc = '';
            let gunNmClass = '';
            let name = '';
            let gntNm = '';

            if(i%4 == 0) {
                html += '<div class="swiper-slide widget-wrapper">'
            }

            if(i < data.length) {
                name = data[i].name;
                gntNm = data[i].gntNm;
                photoSrc = '/EmpPhotoOut.do?enterCd='+data[i].enterCd+'&searchKeyword='+data[i].sabun+'&t='+new Date().getTime();

                if(data[i].gntGubunCd == '19' || data[i].gntGubunCd == '35') {
                    // 외근
                    gunNmClass = 'outside';
                } else if (data[i].gntGubunCd == '1'
                    || data[i].gntGubunCd == '3'
                    || data[i].gntGubunCd == '7'
                    || data[i].gntGubunCd == '9'
                    || data[i].gntGubunCd == '11'
                    || data[i].gntGubunCd == '13'
                    || data[i].gntGubunCd == '15'
                    || data[i].gntGubunCd == '16'
                    || data[i].gntGubunCd == '17'
                    || data[i].gntGubunCd == '18') {
                    // 휴가
                    gunNmClass = 'leave';
                } else if (data[i].gntGubunCd == '21') {
                    // 교육
                    gunNmClass = 'edu';
                } else if (data[i].gntGubunCd == '23') {
                    // 병가
                    gunNmClass = 'sick';
                } else {
                    gunNmClass = '';
                }

                html += '<div class="inner-wrap">' +
                        '  <div class="widget">' +
                        '    <div class="profile">' +
                        '      <div class="avatar-wrap">' +
                        '        <img src="'+photoSrc+'" alt="profile">\n' +
                        '      </div>' +
                        '      <span class="name">' + name + '</span>' +
                        '    </div>' +
                        '    <span class="ml-auto status '+gunNmClass+'">' + gntNm + '</span>' +
                        '  </div>' +
                        '</div>';
            } else {
                html += '<div class="inner-wrap"><div class="widget widget-blank"><div class="profile"><div class="avatar-wrap"></div></div></div></div>';
            }

            if(i%4 == 3) {
                html += '</div>'
            }
        }

        $('#psnlTimeDiv').append(html);
        psnlTimeSwipeAndLink();
    }
}

// 동료일정 슬라이드를 위한 변수 선언 및 함수 정의
var psnlTime = {
    swiper: null
};

function psnlTimeSwipeAndLink() {
    psnlTime.swiper = new Swiper("#psnl-time-slide", {
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

// 연간일정
function getMainEssAnnualPlan() {
    const data = ajaxCall('/getMainEssAnnualPlan.do', '', false).DATA;
    if(data != null && data != 'undefined') {
        for(let i=0; i < data.length; i++) {
            let html = '<li class="list pointer" onclick="goMainMenu(\''+data[i].mainMenuCd+'\')"><P>'+data[i].title+'</P><div><i class="mdi-ico">event</i><span class="date">'+data[i].period+'</span></div></li>';
            $("#annualPlanList").append(html);
        }
    }
}

// 메인 메뉴로 이동
function goMainMenu(mainMenuCd) {
    $(".menu_item[mainmenucd="+mainMenuCd+"]").click();
}

function callMenuListLayer(){
    var menuListLayer = new window.top.document.LayerModal({
        id: 'menuListLayer',
        url: "/MenuListLayer.do",
        parameters: {},
        width: 1600,
        height: 800,
        title: '메뉴목록'
    });
    menuListLayer.show();
}

// 즐겨찾기 저장
function saveBookmark(mainMenuCd, priorMenuCd, menuCd, menuSeq, prgCd, bookMarkYn){
    const param = "&mainMenuCd="+mainMenuCd +
        "&priorMenuCd="+priorMenuCd +
        "&menuCd="+menuCd +
        "&menuSeq="+menuSeq +
        "&prgCd="+prgCd +
        "&bookMarkYn="+bookMarkYn ;
    const data = ajaxCall('/saveMainEssBookmark.do', param, false).DATA;
}

// 즐겨찾기 중분류 메뉴 전체 저장
function saveBookmarkAll(obj) {
    // 부모 div의 ul 내의 모든 li 찾기
    const bookMarkYn = $(obj).hasClass('on') ? 'N' : 'Y';
    if(bookMarkYn === 'Y') {
        $(obj).closest('.col').find('.bookmark-btn').not($(obj)).addClass('on');
    } else {
        $(obj).closest('.col').find('.bookmark-btn').not($(obj)).removeClass('on');
    }

    $(obj).closest('.col').find('ul li').each(function() {
        saveBookmark($(this).data('mainmenucd'), $(this).data('priormenucd'), $(this).data('menucd'), $(this).data('menuseq'), $(this).data('prgcd'), bookMarkYn)
    });
}