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
});
//-->
</script>
<script src="../../../common_jungsan/js/common.js"		type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>
<script src="../../../common_jungsan/js/commonIBSheet.js"	type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>