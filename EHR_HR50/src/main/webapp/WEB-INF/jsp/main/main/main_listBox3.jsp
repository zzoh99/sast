<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function main_listBox3(title, info, classNm, seq ){

	$("#listBox3").attr("seq", seq);

	$.ajax({
		url 		: "${ctx}/getListBox3List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;
			var tmp = "<tr><td>#HRIYM#</td><td class=left><span>#STIME#</span> ~ <span>#ETIME#</span></td></tr>";
			var str = "";
			for(var i=0; i<list.length; i++){
				str += tmp.replace(/#HRIYM#/g,list[i].sYmd)
				          .replace(/#STIME#/g,list[i].sTime)
				          .replace(/#ETIME#/g,list[i].eTime);
			}
			$("#commute_table").append(str);
			// 더보기 링크 클릭 이벤트
			$("#hriWidget").click(function() {
				var goPrgCd = "/PsnlCalendar.do?cmd=viewPsnlCalendar";
				goSubPage("08","","","",goPrgCd);
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}
</script>
						<div id="listBox3" lv="3" title="출근 / 퇴근시간" info="최근3일간 출근시간 및 교통비 신청 바로가기" class="notice_box">
							<div class="bg"><div class="ico_clock"></div></div>
							<div class="main">
								<ul class="header">
									<li class="title">출근 / 퇴근시간</li>
									<li id="hriWidget"><btn:a  mid='110782' mdef="더 보기"/> <img src="/common/images/main/ico_notice_link.gif" /></li>
									<!--<li><btn:a  css="box" mid='111224' mdef="교통비신청"/> <img src="/common//images/main/ico_notice_link.gif" /></li>-->
								</ul>

								<!--  로딩 s -->
								<div class="main_loading">
									<img src="/common/images/common/top_change.gif"/>
								</div>
								<!--  로딩 e -->

								<table class="commute_table">
								<colgroup>
									<col width="60" />
									<col width="" />
								</colgroup>
								<tr class="title">
									<td>일자</td>
									<td class="left2">출근&nbsp;&nbsp;&nbsp;&nbsp;퇴근</td>
								</tr>
								<!--
								<tr><td>02.21</td><td class="left"><span>09:00 ~ 23:00</td></tr><tr>

									<td>02.21</td>
									<td class="left">09:00 ~ 23:00</td>
								</tr>
								<tr>
									<td>02.21</td>
									<td class="left">09:00 ~ 23:00</td>
								</tr>
								-->
								</table>
								<div class="commute_table_scroll">
									<table id="commute_table" class="commute_table">
									<colgroup>
										<col width="60" />
										<col width="" />
									</colgroup>
									</table>
								</div>
							</div>
						</div>
