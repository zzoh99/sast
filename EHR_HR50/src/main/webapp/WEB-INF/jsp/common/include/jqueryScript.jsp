<!--   STYLE	 -->
<link rel="stylesheet" href="/common/css/${wfont}.css" />
<link rel="stylesheet" type="text/css" href="/common/${theme}/css/style.css">
 
<link rel="stylesheet" href="/common/css/after.css" />
<link rel="stylesheet" href="/common/css/color.css" />
<link rel="stylesheet" href="/common/css/util.css" />
<link rel="stylesheet" href="/common/css/override.css" />


<link rel="stylesheet" href="/common/plugin/select2/css/select2.css" />
<link rel="stylesheet" href="/common/plugin/select2/css/select2-custom.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/modal.css">
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
<link rel="stylesheet" type="text/css" href="/assets/css/evaluation.css">
<link rel="stylesheet" type="text/css" href="/assets/css/themes/colors.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/themes/theme.css" />

<!-- Vest -->
<script src="/common/js/VestSubmit.js"></script>
<script src="/common/js/VestUtils.js?v=20250409"></script>

<!--   JQUERY	 -->
<%--<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>--%>
<script src="${ctx}/common/js/jquery/3.6.2/jquery-3.6.2.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/crypto-js/4.2.0/crypto-js.min.js" type="text/javascript" charset="utf-8"></script>


<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.datepicker.js" type="text/javascript" charset="utf-8"></script>
<c:choose>
	<c:when test="${sessionScope.ssnLocaleCd =='' || sessionScope.ssnLocaleCd =='ko_KR' }">
		<script src="${ctx}/common/js/jquery/datepicker_lang_KR.js"	type="text/javascript" charset="utf-8"></script>
	</c:when>
	<c:otherwise>
		<script src="${ctx}/common/js/jquery/datepicker_lang_EN.js"	type="text/javascript" charset="utf-8"></script>
	</c:otherwise>
</c:choose>

<script src="${ctx}/common/js/jquery/select2.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.mask.js" type="text/javascript" charset="utf-8"></script>

<!--   VALIDATION	 -->
<script src="${ctx}/common/js/jquery/jquery.validate.js" type="text/javascript" charset="utf-8"></script>

<!-- WIDGET LAYOUT -->
<script src="${ctx}/assets/plugins/masonry-4.2.2/masonry.pkgd.min.js"></script>

<!--  COMMON SCRIT -->
<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>
<script src="${ctx}/common/js/util.js"			type="text/javascript" charset="UTF-8"></script>
<script src="${ctx}/common/js/commonIBSheet.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/autolink.js"		type="text/javascript" charset="UTF-8"></script>
<script src="${ctx}/common/js/lang.js"          type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/encSubmit.js"		type="text/javascript" charset="UTF-8"></script>

<!--  Ajax Error -->
<%--<script type="text/javascript" src="/common/js/ras/script.js"></script>--%>
<!-- 2023-12-14 레이어 모달로 jsp 바인딩할때 document.write 메소드가 페이지 전체의 소스를 지워버려서 수정함 -->
<script type="text/javascript" src="/common/js/ras/jsbn.js"></script>
<script type="text/javascript" src="/common/js/ras/rsa.js"></script>
<script type="text/javascript" src="/common/js/ras/prng4.js"></script>
<script type="text/javascript" src="/common/js/ras/rng.js"></script>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<script type="text/javascript">

if("${sessionScope.devMode}" == "A"){
	$(document).ready(function(){

		if(window.top == window.self){
			return;
		}

		$("body").children().first().before("<h1 id='devModeUrl'>++++++ programUrl : "+ document.URL.substring(document.URL.lastIndexOf("/") + 1)+"</h1>");

		// DevModeUrl 표기 컨트롤
		var chkDevModeUrl = getChkDevModeUrl();
		if (chkDevModeUrl !== null && chkDevModeUrl !== undefined) {
			if (chkDevModeUrl.is(":checked")) {
				$('#devModeUrl').show();
			} else {
				$('#devModeUrl').hide();
			}
		}
	});
}

var _theme = "${theme}";
var session_theme = "${theme}";
</script>

<%@ include file="/WEB-INF/jsp/common/include/isuDesignScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/processMapChecker.jsp"%>
