<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<%--[${result}]--%>
<%--<form id="redirectForm" name="redirectForm" action="http://localhost:3000/hrMain" method="post">--%>
<%--    <input type="hidden" name="token" value="${result.token}" />--%>
<%--</form>--%>
T
<script>
    // location.href = 'http://localhost:3000'
    const form = document.createElement('form')
    form.method = 'POST'
    form.action = '/MainVue.do'
    // param 생성
    const param = document.createElement('input')
    param.type = 'hidden'
    param.name = 'token'
    param.value = '${result.token}'
    form.appendChild(param)
    // form 제출
    document.body.appendChild(form)
    form.submit()
</script>
<%--<script>--%>
<%--    window.onload = function() {--%>
<%--        fetch("http://localhost:3000", {--%>
<%--            method: "POST",--%>
<%--            headers: { "Content-Type": "application/json" },--%>
<%--            body: JSON.stringify({--%>
<%--                token: "${result.token}"--%>
<%--            })--%>
<%--        }).then(response => {--%>
<%--            console.log(response)--%>
<%--            if (response.ok) {--%>
<%--                window.location.href = "http://localhost:3000";--%>
<%--            }--%>
<%--        });--%>
<%--    };--%>
<%--</script>--%>
</body>
</html>
