<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>전출입관리</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">

        var newIframe;
        var oldIframe;
        var iframeIdx;

        $(function() {

            $("input[type='text']").keydown(function(event){
                if(event.keyCode == 27){
                    return false;
                }
            });

            $("#searchYm").datepicker2({ymonly : true});

            newIframe = $('#tabs-1 iframe');
            iframeIdx = 0;

            $( "#tabs" ).tabs({
                beforeActivate: function(event, ui) {
                    iframeIdx = ui.newTab.index();
                    newIframe = $(ui.newPanel).find('iframe');
                    oldIframe = $(ui.oldPanel).find('iframe');
                    showIframe();
                }
            });

            initTabsLine(); //탭 하단 라인 추가
            showIframe();

            $("#searchYm").bind("keyup",function(event){
                if( event.keyCode == 13){
                    setEmpPage();
                }
            });

        });

        function showIframe() {

            if(typeof oldIframe != 'undefined') {
                oldIframe.attr("src","${ctx}/common/hidden.jsp");
            }

            if(iframeIdx == 0) {
                newIframe.attr("src","${ctx}/InOutOrgMgr.do?cmd=viewInOutOrgMgrTab1&authPg=${authPg}");
            } else if(iframeIdx == 1) {
                newIframe.attr("src","${ctx}/InOutOrgMgr.do?cmd=viewInOutOrgMgrTab2&authPg=${authPg}");
            }

        }

        // 입력시 조건 체크
        function checkList(){
            var ch = true;
            var exit = false;
            if(exit){return false;}
            // 화면의 개별 입력 부분 필수값 체크
            $(".required").each(function(index){
                if($(this).val() == null || $(this).val() == ""){
                    alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
                    $(this).focus();
                    ch =  false;
                    return false;
                }
            });
            return ch;
        }

        function setEmpPage() {
            if(!checkList()) return ;
            $('iframe')[iframeIdx].contentWindow.doAction1("Search");
        }
    </script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sendForm" name="sendForm">
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
                            <span>결산년월</span>
                            <input type="text" id="searchYm" name="searchSdate" class="date2 required" value="${curSysYyyyMMddHyphen}"/>
                        </td>
                        <td>
                            <btn:a href="javascript:setEmpPage();"	css="button authR" mid='110697' mdef="조회"/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>

    <div class="inner" style="height:100%;">
        <div id="tabs" class="tab">
            <div class='ui-tabs-nav-line'></div> <!-- 탭 하단 라인 -->
            <ul>
                <li><a href="#tabs-1">대상자조회</a></li>
                <li><a href="#tabs-2">전표조회</a></li>
            </ul>
            <div id="tabs-1">
                <div  class="layout_tabs">
                    <iframe src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe>
                </div>
            </div>
            <div id="tabs-2">
                <div  class='layout_tabs'>
                    <iframe src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
