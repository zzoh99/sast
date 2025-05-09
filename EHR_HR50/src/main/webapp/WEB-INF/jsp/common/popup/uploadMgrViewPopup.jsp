<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="">
<head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <title>미리보기</title>
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <style>
        .wrapper {
            display: flex;
            justify-content: center; /* 수평 중앙 정렬 */
            align-items: center; /* 수직 중앙 정렬 */
            height: 100vh; /* 화면 전체 높이 */
            overflow: hidden; /* 스크롤바 숨기기 */
        }
        .popup_main {
            text-align: center; /* 콘텐츠 중앙 정렬 */
            width: 100%;
            height: 100%;
        }
        .popup_main img, .popup_main iframe {
            max-width: 100%; /* 콘텐츠의 너비를 컨테이너에 맞게 조정 */
            max-height: 100%; /* 콘텐츠의 높이를 컨테이너에 맞게 조정 */
        }
    </style>
    <script>
        function adjustPopupSize() {
            var img = document.getElementById('popupImage');
            var iframe = document.getElementById('pdfViewer');

            function resizePopup() {
                var width, height;
                if (img) {
                    width = img.naturalWidth;
                    height = img.naturalHeight;
                } else if (iframe) {
                    width = iframe.contentWindow.document.body.scrollWidth;
                    height = iframe.contentWindow.document.body.scrollHeight;
                }

                var popupWidth = width + 40; // 여백 추가
                var popupHeight = height + 60; // 여백 추가

                // 팝업 창 크기 조절
                window.resizeTo(popupWidth, popupHeight);
                //window.moveTo((window.screen.width - popupWidth) / 2, (window.screen.height - popupHeight) / 2);
            }

            if (img) {
                img.onload = resizePopup;
                if (img.complete) { // 이미지가 이미 로드된 상태일 경우
                    resizePopup();
                }
            } else if (iframe) {
                iframe.onload = resizePopup;
            }
        }

        window.onload = function() {
            adjustPopupSize();
        };
    </script>
</head>
<body>
<div class="wrapper" id="viewArea">
    <div class="popup_main">
        <%
            // 파일 확장자 추출
            String fileURL = request.getParameter("fileURL");
            String fileExt = request.getParameter("fileExt");
        %>

        <%
            if ("pdf".equals(fileExt)) {
        %>
        <iframe id="pdfViewer" src="${fileURL}" width="100%" height="100%" frameborder="0"></iframe>
        <%
        } else {
        %>
        <img id="popupImage" src="${fileURL}" alt="파일 이미지" />
        <%
            }
        %>
    </div>
</div>
</body>
</html>
