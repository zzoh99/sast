<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>

<%@ taglib prefix="com" tagdir="/WEB-INF/tags/common" %>
<%@ taglib prefix="btn" tagdir="/WEB-INF/tags/button" %>
<%@ taglib prefix="msg" tagdir="/WEB-INF/tags/message" %>
<%@ taglib prefix="sht" tagdir="/WEB-INF/tags/sheet" %>
<%@ taglib prefix="tbl" tagdir="/WEB-INF/tags/table" %>
<%@ taglib prefix="tit" tagdir="/WEB-INF/tags/title" %>
<%@ taglib prefix="sch" tagdir="/WEB-INF/tags/search" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><tit:txt mid='pwdConfirmPop' mdef='비밀번호 확인'/></title>
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>

    <script type="text/javascript">
        $(function() {

            //로그인 아이디 패스워드 엔터 체크
            $("#confirmPwd").on("keyup", async function(event) {
                if ( event.keyCode == 13 ) {
                    const result = await checkPassword();
                    setInvalid(result.pwConfirmYn, result.message);
                }
            });

            //입력할때 레이어 숨김
            $("#confirmPwd").keypress(function(e) {
                $("#confirmPwd").removeClass("invalid");
            });
        });

        function setInvalid(code, msg = "") {
            if (code === "ERR" || code === "N") {
                $("#confirmPwd").addClass("invalid");
                $(".input_error_msg span").text(msg);
                $("#confirmPwd").focus();
            } else {
                $("#confirmPwd").removeClass("invalid");
                goConfirm();
            }
        }

        async function checkPassword() {
            const response = await fetch("${ctx}/CheckValidPassword.do", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: $("#srchFrm").serialize()
            });

            return await response.json();
        }

        function goConfirm() {
            submitCall($("#srchFrm"),"_self","post","${ctx}/PwConCheck.do", false);
        }
    </script>
</head>
<body>
    <div style="overflow:hidden;">
        <div class="ux_wrapper">
            <div class="page_title mb-12"><tit:txt mid='pwdConfirmPop' mdef='비밀번호 확인'/></div>
            <div class="contents pt-20">
                <div class="w-350 d-flex flex-col align-center ma-auto">
                    <i class="icon password mb-16"></i>
                    <p class="txt_body_small txt_center txt_secondary">
                        HR비밀번호를 입력해주세요
                    </p>
                    <p class="txt_title_xs_sb txt-primary mb-32">
                        비밀번호 입력
                    </p>
                    <div class="w-full">
                        <form id="srchFrm" name="srchFrm" >
                            <input type="hidden" id="surl" name="surl" value="${param.surl}" />
                            <!-- input에 .invalid 클래스 추가 시 오류 메시지 표시 -->
                            <input id="confirmPwd" name="confirmPwd"
                                type="password"
                                class="input_text lg"
                                placeholder="비밀번호를 입력해주세요."
                            />
                            <div class="input_error_msg txt_body_small">
                                <i class="mdi-ico">error</i>
                                <span></span>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
