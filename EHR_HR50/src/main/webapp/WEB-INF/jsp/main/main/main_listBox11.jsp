<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function main_listBox11(title, info){
	if($.browser.msie==true) {
		//alert('버전은 '+$.browser.version+'입니다.');
		$("#downEtc").hide("slow",function(){
			$("#downIe").show();
		});
	} else {
		//alert('마이크로 소프트의 브라우저가 아닙니다.');
		$("#downIe").hide("slow",function(){
			$("#downEtc").show();
		});
	}
}
</script>
<div id="listBox11" lv="11" title="다운로드" info="파일 다운로드" class="notice_box">
	<div class="bg"><div class="ico_download"></div></div>
	<div class="main">
		<ul class="header">
			<li class="title">다운로드</li>
<!-- <li><btn:a  mid='110782' mdef="더 보기"/> <img src="/common//images/main/ico_notice_new.gif" /></li> -->
</ul>

<!--  로딩 s -->
<div class="main_loading">
	<img src="/common/images/common/top_change.gif"/>
</div>
<!--  로딩 e -->
<div class="download_scroll">
	<table class="notice_table download_table">
	<tr id="downIe">
		<th	><div class="limit2"><a href="${baseUrl}/common/plugin/DataServer/plugin/CX60u_OCX_setup.zip" target="_blan">Report Tool [ Microsoft Internet Explorer ] </a></div></th>
</tr>
<tr id="downEtc">
	<th	><div class="limit2"><a href="${baseUrl}/common/plugin/DataServer/plugin/CX60_Plugin_u_setup.exe" target="_blan">Report PlugIN [ Chrome / Safari / Firefox ]</a></div></th>
</tr>
<tr>
	<th><div class="limit2"><a href="http://www.microsoft.com/silverlight/" target="_blan">Silverlight</a></div></th>
</tr>
<tr>
	<th><div class="limit2"><btn:a href="https://www.google.com/intl/ko/chrome/browser/" target="_blan" mid='111075' mdef="Chrome 다운로드"/></div></th>
</tr>
<!--
<tr>
	<th><div class="limit2"><btn:a href="http://windows.microsoft.com/ko-KR/internet-explorer/downloads/ie-8" target="_blan" mid='111217' mdef="IE 8 다운로드"/></div></th>
</tr>
 -->
			</table>
		</div>

	</div>
</div>
