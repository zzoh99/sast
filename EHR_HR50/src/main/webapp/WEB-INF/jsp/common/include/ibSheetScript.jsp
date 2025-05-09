<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
if(typeof top.HR_PAKEGE_NAME_$_ == "undefined" || top.HR_PAKEGE_NAME_$_ != "HR") {
	try{ top.D_$_ = null; } catch(e) {};
}
top.HR_PAKEGE_NAME_$_ = "HR";
</script>
<!--   IBSHEET	 -->
<%-- <link rel="stylesheet" type="text/css" href="/common/${theme}/Main/ibsheet.css"> --%>
<script src="${ctx}/common/plugin/IBLeaders/Sheet/js/ibleaders.js" type="text/javascript"></script>
<script src="${ctx}/common/plugin/IBLeaders/Sheet/js/ibsheetinfo.js?ver=202503131710" type="text/javascript"></script>
<script src="${ctx}/common/plugin/IBLeaders/Sheet/js/ibsheet.js" type="text/javascript"></script>
<!--script src="${ctx}/common/plugin/IBLeaders/Sheet/js/ibmaskedit.js" type="text/javascript"></script>  -->
<script src="${ctx}/common/plugin/IBLeaders/Sheet/js/ibsheetcalendar.js" type="text/javascript"></script>


<script type="text/javascript">
	var thisUrl = "${tUrl}";
	var isUseDownloadReasonReg = ("${ssnFileDownRegReason}" == "Y") ? true : false;

    /* 모바일 다운로드 허용 확인 로직 추가(24.09.26) */
    var isMobile = {
        Android: function() {
            // 안드로이드 모바일 기기만 감지
            return /Android.*Mobile/.test(navigator.userAgent);

            // 모든 안드로이드 감지시 아래 코드 사용
            //return /Android/i.test(navigator.userAgent);
        },
        iOS: function() {
            // iOS 모바일 기기만 감지 (iPhone, iPad, iPod)
            return /iPhone|iPad|iPod/i.test(navigator.userAgent) ||
                (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 0);
        },
        any: function() {
            return (isMobile.Android() || isMobile.iOS());
        }
    };
    var isFileDownMobile = ("${ssnFileDownMobileYn}" == "Y") ? true : false;
    var isDown = true;
    if(!isFileDownMobile && isMobile.any()) {
        isDown = false;
    }
</script>