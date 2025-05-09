<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<!--   IBSHEET	 -->
<script type="text/javascript">
<%
	if("2".equals(StringUtil.getPropertiesValue("SYS.VERSION"))) {
%>
try {
	// 20211115 김병철 : cloudhr 오류로 인해 try catch 추가
	//ibsheet.js 캐쉬를 사용하지 않기위해서 설정(매번 패킹을 푸는 형식으로 속도가 좀 느려진다고 한다.) 캐쉬를 사용하면 한 서비스에 서로 다른 버전이 있으면 충돌남.
	if(typeof top.HR_PAKEGE_NAME_$_ == "undefined" || top.HR_PAKEGE_NAME_$_ != "YEAR") {
		try{ top.D_$_ = null; } catch(e) {};
	}
	top.HR_PAKEGE_NAME_$_ = "YEAR";
} catch(e) {
    alert("error : " + e);
}
<%
	}
%>
</script>
<script src="../../../common_jungsan/plugin/IBLeaders/Sheet/js/ibleaders.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/plugin/IBLeaders/Sheet/js/ibsheetinfo.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/plugin/IBLeaders/Sheet/js/ibsheet.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/plugin/IBLeaders/Sheet/js/ibsheetcalendar.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<link rel="stylesheet" type="text/css" href="../../../common_jungsan/plugin/IBLeaders/Sheet/css/style.css">
<link rel="stylesheet" type="text/css" href="../../../common_jungsan/plugin/IBLeaders/Sheet/css/nwe_common.css">
