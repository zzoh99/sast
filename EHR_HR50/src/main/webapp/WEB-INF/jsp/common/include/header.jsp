<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 알림 토스트 --%>
<%@ include file="/WEB-INF/jsp/common/include/notification.jsp"%>

<!-- Vest -->
<%--<script src="/common/js/VestSubmit.js"></script>
<script src="/common/js/VestUtils.js"></script>--%>

<div id="header" class="header">
	<div class="logo">
	    <img src="/OrgPhotoOut.do?logoCd=7&orgCd=0&t=<%= new Date().getTime() %>" alt="logo" style="cursor: pointer;" onClick="goMain();">
	</div>
	<div>
	    <c:if test="${ssnErrorAccYn =='Y'}">
	        <div id="errorAcc" style="margin-right: 20px;">
	            <a href="#" style='color:red; font-size:14px;'>[오류접수]</a>
	        </div>
	    </c:if>
	    <c:if test="${devMode =='L' || devMode=='L2'}">
	        <div>
	            <a id="goLngcode" class="btn_gnb_home gray" style="background-color: lightgrey; margin-right: 50px;">
	                <span style="color:#000;letter-spacing:0;">어휘관리</span>
	            </a>
	        </div>
	    </c:if>
	</div>
	<div class="inner-wrap">
	    <span class="avatar">
	      <img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=${ssnSabun}&t=<%= new Date().getTime() %>" alt="">
	    </span>

	    <div class="custom_select no_style">
	      <button class="select_toggle">
	        <span class="name">${ssnName}</span><i class="mdi-ico">arrow_drop_down</i>
	      </button>
	      <div class="select_options fix_width align_center">
	        <div class="option" onClick="changeUser();"><i class="mdi-ico">lock</i>비밀번호 변경</div>
	        <div class="option" onClick="logout();"><i class="mdi-ico">logout</i>로그아웃</div>
	      </div>
	    </div>
    
	    <div class="search">
	      <input type="text" id="mainHeaderSearchWord" class="" placeholder="인사정보, 업무 검색이 가능합니다.                  ">
	      <button type="button" class="btn filled btn-search" onclick="headerSearch()">검색</button>
	    </div>
    
	    <c:if test="${ hostIp eq '127.0.0.1' || hostIp eq '0:0:0:0:0:0:0:1' && (ssnAdmin eq 'Y' && ssnGuideModeYn eq 'Y') }">
			<div style="position: absolute;top:-3px; left:250px;">
				<input type="text" id="devTabUrl" style="width:400px; padding:1px; border:0px; background-color:#FFF5C8; color:blue; font-size:9px;" /><!-- 개발자 모드 : 탭 URL 표시  -->
			</div>
		</c:if>
	</div>
    
    <div class="control">

    <c:if test="${ssnAdmin == 'Y' && ssnDevModeYn == 'Y'}">
        <a href="#" class="devMode">
            <select id="devMode" name="devMode" class="custom_select">
                <option value="">일반모드</option>
                <option value="L">언어모드</option>
                <option value="L2">언어모드2</option>
            </select>
        </a>
    </c:if>

    	<!-- 도움말 임시 Test -->
		<a href="#" class="helpModal" style="display: none">
			<i class="mdi-ico filled">contact_support</i>
		</a>

    <c:if test="${ssnCompanyMgrYn == 'Y'}">
        <a href="#" class="chgCompany">
            <i class="mdi-ico filled">domain</i>
            ${ssnEnterNm} 법인전환
        </a>
    </c:if>
    
   		<a href="#" class="session" title="시간연장">
       	 <i class="mdi-ico">av_timer</i>
         <span id="headerSTime" class="countdown">--:--:--</span>
         <span class="txt-bold" onClick="headerSTimeInit();">연장</span>
       </a>

       <a href="#" class="account_info">
         <i class="mdi-ico filled account_circle">person</i>
         <div class="custom_select no_style">
           <button class="select_toggle">
             <span>${ssnGrpNm}</span>
           </button>
           <div id="possibleAuthList" class="select_options fix_width align_center"></div>
         </div>
       </a>
<c:if test="${ssnLocaleCd != '' && ssnLangUseYn == 1}">
        <a href="#" class="language">
            <i class="mdi-ico filled">flag</i>
            <div class="custom_select no_style">
                <button class="select_toggle">
                    <span>${ssnLocaleLanguage}</span><i class="mdi-ico">arrow_drop_down</i>
                </button>
              <div id="langeList" class="select_options fix_width align_center"></div>
            </div>
        </a>
</c:if>

<%--       <span class="divider"></span>--%>
<%--       <span id="headerCTime" class="datetime"></span>--%>
      <!--  <span class="divider"></span> -->

       

    <c:if test="${ssnAdmin=='Y' && ssnAdminFncYn == 'Y'}">
        <a href="#" class="change-user" title="사용자 변경 로그인">
            <i class="mdi-ico filled">person</i>
        </a>
    </c:if>
    <c:if test="${ssnChatbotYn =='Y'}">
        <a href="#" id="chatbot_btn">
            <i class="v-icon chat-icon-chatbot"></i>
        </a>
    </c:if>

        <a href="#" class="setting" title="테마 설정">
       	<div class="custom_select no_style icon">
           <button class="select_toggle">
             <i class="mdi-ico filled">settings</i>
           </button>
           <div id="themeList" class="select_options fix_width align_center">
             <div class="header">테마 설정</div>
             <div class="option" theme="blue"><span class="circle blue"></span>Blue</div>
             <div class="option" theme="orange"><span class="circle orange"></span>Orange</div>
             <div class="option" theme="red"><span class="circle red"></span>Red</div>
             <div class="option" theme="chicken"><span class="circle orange-red"></span>Orange Red</div>
             <div class="option" theme="greenOrange"><span class="circle green-orange"></span>Green Orange</div>
             <div class="option" theme="gold"><span class="circle gold"></span>Gold</div>
             <div class="option" theme="green"><span class="circle green"></span>Green</div>
             <div class="option" theme="skyblue"><span class="circle skyblue"></span>SkyBlue</div>
             <div class="option" theme="navy"><span class="circle navy"></span>Navy</div>
             <div class="option" theme="white"><span class="circle white"></span>White</div>
           </div>
         </div>
       </a>
        <a href="#" class="user-alert">
            <i class="mdi-ico filled" title="알림">notifications</i>
        </a>

       <a href="#" class="lock" title="화면잠금">
       	<i class="mdi-ico filled" onClick="disableTop();">lock</i>
       </a>
     </div>

    <!-- 메인페이지 알림 -->
    <div id="panalAlertDiv" class="panalAlert" style="display:none;">
        <div class="panalAlert_title">
            <a class="title_icon"></a>
            <span style="font-size:18px">알 림</span>
            <a class="mdi-ico btn-close">close</a>
        </div>
        <ul id="panalAlert"></ul>
        <div class="toastMsgDiv">
            <div class="title alignL">
                <span>개인 알림</span>
                <a href="" class="btn_deleteAllToastMsg">[알림 모두 지우기]</a>
            </div>
            <div class="toastMsgBox">
                <ul class="toastMsgList"></ul>
            </div>
        </div>
        <div class="panalAlert_todayClose mal25">
            <span><label for="panalAlertTodayClose">오늘 하루 그만보기</label></span>
            <input type="checkbox" id="panalAlertTodayClose" name="panalAlertTodayClose" />
        </div>
    </div>
</div>
<c:if test="${ssnChatbotYn =='Y'}">
<div id="chabot-div">
    <script src="/isusys-chatbot-wrapper/chatSetting.js"></script>
    <script>
        const ssnEnterCd = '${ssnEnterCd}';
        const ssnLocaleCd = "${ssnLocaleCd}";
        const theme = "${theme}";
        const wfont = "${wfont}";
        const ssnManageCd = "${ssnManageCd}";
        const ssnGrpCd = "${ssnGrpCd}";
        const ssnSabun = "${ssnSabun}";
        const ssnName = "${ssnName}";

        IsusysChatbot.load({
            parentsElementId : "chabot-div",
            scriptSrc:"",
            chatbotInfo : {
                url : "https://aichat.isu.co.kr/isu-hr-chatbot",
                tenantKey : "DEMO",
                ssnSabun : ssnSabun,
                ssnName : ssnName,
                gubunCd : ssnGrpCd,
                serviceName : "hr_chatbot",
                theme : theme,
                wfont : wfont
            }
        })
    </script>
</div>
</c:if>
<script>

    $(function () {
        $('#devMode').val('${devMode}');
        $('#workup-launcher .workup-launcher-open-icon').addClass("${theme}");
    });

    $('#chatbot_btn').click((e) => {
        document.getElementById("chatbotTopBtn").click();
    });

    // 사용자변경 클릭 이벤트
    $('.change-user').on('click', function(){
        if(!isPopup()) {return;}

        if (!confirm(getMsgLanguage({"msgid": "msg.201707120000007", "defaultMsg":"관리자 권한으로 접근 하였습니다.\n관리자가 아닌 경우 접근경로를 확인가능하며,\n인사상 불이익이 있을 수 있습니다.\n\n본인의 아이디와 비밀번호를 사용 바랍니다."}))){
            return;
        }

        gPRow = "";
        pGubun = "chgUserLayer";
        const url = '/chgUserLayer.do?cmd=viewChgUserLayer';
        let chgUserLayer = new window.top.document.LayerModal({
            id: 'chgUserLayer',
            url: url,
            width: 900,
            height: 750,
            title: '사용자 변경 로그인'
        });
        chgUserLayer.show();
    });

    $('.user-alert').on('click', function(){
        getPsnalAlertListLayer();
    });

    $('.helpModal').on('click', function(){
        openHelpLayer();
    });

    $('.chgCompany').on('click', function(){
		const url = '/chgCompanyLayer.do?cmd=viewChgCompanyLayer';
		var changeCompanyLayer = new window.top.document.LayerModal({
    		id: 'changeCompanyLayer',
    		url: url,
    		width: 450,
    		height: 370,
    		title: '<tit:txt mid='113568' mdef='회사변경'/>'
    	});
		changeCompanyLayer.show();
    });

    $('#devMode').on('change', function(){
        ajaxCall("/DevMode.do","devModeVal=" + $(this).val(), false);
        redirect("/",	"_top");
    });

    $("#goLngcode").on('click', function(){
        var url = "/DictMgr.do?cmd=viewDict";
        var args = {};
        openPopup(url,args,"1450","590");
    });

    $("#errorAcc").on('click', function(){
        let url = "/ReqDefinitionPop.do?cmd=viewReqDefinitionLayer";

        const layer = new window.top.document.LayerModal({
            id: 'reqDefinitionLayer',
            url: url,
            width: 1000,
            height: 590,
            title: pageLocation + ' 오류접수'
        });
        layer.show();
    });

    function getPanalAlertList2(sabun, flag) {

        var isPop = true;
        // 오늘 하루 그만보기  체크
        if (getCookie("panalAlertClose") != null) {
            var today = new Date();
            var tMonth = today.getMonth() + 1
            tMonth = tMonth < 10 ? "0" + tMonth : tMonth;
            var tDay = today.getDate()
            tDay = tDay < 10 ? "0" + tDay : tDay;

            var cookieValue = sabun + "|" + today.getFullYear() + tMonth + tDay;
            if (getCookie("panalAlertClose") == cookieValue) {
                // 오늘 하루 그만 보기 이미 체크된 경우면 알림 화면 열지 않게 하기 위함
                isPop = false;
            }

            if (flag) isPop = flag;
        }

        if (!isPop) return;

        getPsnalAlertListLayer();
    }


    function getPsnalAlertListLayer(){
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

    function openHelpLayer(){
        let args = {};
        let layerModal = new window.top.document.LayerModal({
            id : 'helpLayer'
            , url : '/viewHelpLayer.do'
            , parameters : args
            , width : 1170
            , height : 850
            , title : "도움말"
            , trigger :[
                {
                    name : 'helpLayerTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layerModal.show();
    }

    function changeUser(){
    	const p = { adminYn: 'N', authPg: 'A', searchSabun: '${ssnSabun}' };
    	const url = '/ChangePw.do?cmd=viewChgPwLayer';
    	var changePwLayer = new window.top.document.LayerModal({
    		id: 'changePwLayer',
    		url: url,
    		parameters: p,
    		width: 461,
    		height: 450,
    		title: '<tit:txt mid='113796' mdef='비밀번호 설정'/>'
    	});
    	changePwLayer.show();
    }

    function getPanalAlertList(sabun){
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

    // 검색창에서 enter key 입력시 event
    $("#mainHeaderSearchWord").on("keyup", function(key) {
        if(key.keyCode === 13) {
            headerSearch();
        }
    });
</script>