<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<!--   STYLE	 -->
<link rel="stylesheet" href="../../../common_jungsan/css/nanum.css" />
<link rel="stylesheet" href="../../../common_jungsan/theme1/css/style.css" />
<!--   JQUERY	 -->
<script src="../../../common_jungsan/js/jquery/1.8.3/jquery.min.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/jquery/jquery.mask.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/ui/1.10.0/jquery-ui.min.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/jquery/datepicker_lang_KR.js"	type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/jquery/jquery.datepicker.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/jquery/select2.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<!--  COMMON SCRIT -->
<script type="text/javascript">
<!--
var chkSysVersion = '<%=StringUtil.getPropertiesValue("SYS.VERSION")%>';
var comSearchType = ("<%=StringUtil.removeXSS((String)session.getAttribute("ssnSearchType"))%>"=="") ? "P" : "<%=StringUtil.removeXSS((String)session.getAttribute("ssnSearchType"))%>";
var comBtnAuthPg = ("<%=authPg%>"=="") ? "R" : "<%=authPg%>";
$(function() {
	(comBtnAuthPg =="A") ? $(".authA,.authR").removeClass("authA").removeClass("authR"):$(".authR").removeClass("authR");

	document.onkeydown=function() {
		if(event.srcElement.type != "text" && event.srcElement.type != "textarea") {
			if(event.keyCode==8) return false;
		}
	}
});

<%
//cloud hr 일경우 각 탭별 이동시 쿠키저장 및 팝업 닫기 수행.
if ("Y".equals(StringUtil.getPropertiesValue("CLOUD.HR.YN"))) {
%>
$(function() {
	var that = this;

	// 팝업창인지 확인.
	if (opener == null && parent.opener == null) {
		var yeaParam = getCloudHrCookie("yeaParam");

		$('body').on('visibility', function() {
			var $element = $( this );
			var boolSave = false;

			// 타이머 돌면서 화면이 보이는지 혹은 숨겼는지 확인하여 처리.
			var timer = setInterval( function() {
				if ($element.is(":visible") && boolSave == false) {
					try {
						if (parent && parent != that && parent.document) {
							//console.log("iframe");
						}
					} catch(e) {
						// tab 메인 화면일경우만 쿠키처리 필요함.
						//console.log("main");
						setCloudHrCookie("yeaParam", yeaParam, 1);
					}
					boolSave = true;
				} else if (!$element.is(":visible") && boolSave == true) {
					//console.log("hide");
					boolSave = false;
					closePopupAll();
				}
			}, 500 );

		}).trigger( 'visibility' );

		$(window).on("unload", function(e) {
			closePopupAll();
		});
	}
});

//현재 페이지의 모든 팝업창 종료.
function closePopupAll() {
	var closePopupObj = [];

	for (var i = 0; i < 5; i++) {
		if (i == 0) {
			if (globalWindowPopup && !globalWindowPopup.closed) {
				closePopupObj.push(globalWindowPopup);
			} else {
				return;
			}
		} else {
			if (typeof closePopupObj[i-1] != "undefined" && typeof closePopupObj[i-1].iPublicFrame != "undefined") {
				if (closePopupObj[i-1].iPublicFrame.globalWindowPopup && !closePopupObj[i-1].iPublicFrame.globalWindowPopup.closed) {
					closePopupObj.push(closePopupObj[i-1].iPublicFrame.globalWindowPopup);
				}
			}
		}
	}

	for (var i = closePopupObj.length-1; i >= 0; i--) {
		if (closePopupObj[i] && !closePopupObj[i].closed) {
			closePopupObj[i].close();
		}
	}
}

function getCloudHrCookie(c_name) {
	var value = document.cookie.match('(^|;) ?' + c_name + '=([^;]*)(;|$)');
	return value ? value[2] : null;
}

function setCloudHrCookie(c_name,  value , exdays) {
	var date = new Date();
	date.setTime(date.getTime() + exdays*24*60*60*1000);
	document.cookie = c_name + '=' + value + ';expires=' + date.toUTCString() + ';path=/yjungsan/';
}
<%
}
%>
//-->
</script>
<script src="../../../common_jungsan/js/common.js"		type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/commonIBSheet.js"	type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../common/include/yeaDataCommon.js"	type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>