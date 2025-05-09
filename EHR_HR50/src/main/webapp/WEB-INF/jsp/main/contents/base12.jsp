<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <title></title>
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">
        $(document).ready(function() {
            var result = Math.floor(secureRandom() * 10);
            $(".btn li:eq("+result+")").addClass("on");
            $("#subMain").addClass("bg"+result);
            $(".btn li").click(function() {
                $(".btn li").each(function() {
                    $(this).removeClass("on");
                });
                $(this).addClass("on");
                $("#subMain").attr("class", "");
                $("#subMain").addClass("bg"+$(this).index());
            });
        });
    </script>

</head>
<body>
<div id="subMain">
    <c:choose>
        <c:when test="${map.mgrHelp == null}">
            <div class="txt" style="background: rgba(0,0,0,0)">
                    <%--
                    기업 내외부의 정보를 통합 분석해 경영진에게 적시에 제공함으로써<br/>
                    경영 전반의 의사결정 속도와 정확성을 높이고 상하 조직원 간의 정보전달을 용이하게 하여<br/>
                    위기 대응 능력을 향상시키기 위한 정보를 제공합니다.
                     --%>
                <msg:txt mid='textBase12' mdef='기업 내외부의 정보를 통합 분석해 경영진에게 적시에 제공함으로써<br/>경영 전반의 의사결정 속도와 정확성을 높이고 상하 조직원 간의 정보전달을 용이하게 하여<br/>위기 대응 능력을 향상시키기 위한 정보를 제공합니다.'/>
            </div>
        </c:when>
        <c:otherwise>
            <div class="txt"  style="background: rgba(0,0,0,0)">
                    ${map.mgrHelp}
            </div>
        </c:otherwise>
    </c:choose>

    <div class="btn">
        <ul>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
            <li></li>
        </ul>
    </div>
</div>
</body>
</html>
