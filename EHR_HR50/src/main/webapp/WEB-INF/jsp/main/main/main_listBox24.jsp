<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%/*-----------------------------------------------------------------------------
                                                         근무시간
---------------------------------------------------------------------------------*/%>
<script type="text/javascript">
var widgetContent24;
var widget24classNm;

function main_listBox24(title, info, classNm, seq ){
	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	widget24classNm = classNm;

	$("#listBox24").attr("seq", seq);

	loadApp24(1 , 0, classNm);
}

function loadApp24( page , mode24 , classNm){

	var list = null;
	var title = "주근무현황";
	
	$.ajax({
		url 		: "${ctx}/getListBox24List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			$("#listBox24").removeClass();
			
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){ // ( 250 * 250 ) 
				widgetContent24 = '<h3 class="main_title_250">'+title+'</h3>'
				                + '<a  class="btn_main_more pointer" title="더보기" id="btnMore24" >더보기</a>'
				                + '<div class="workTerm_group">'
				                + '    <div class="workTermDate">'
				                + '        <ul><li>[ 근무기간 ]</li><li id="workTermDate"></li></ul>'
				                + '    </div>'
				                + '    <table id="workTermTime">'
				                + '        <tr><th>&nbsp;</th><th>기본</th><th>연장</th><th>계</th></tr>'
				                + '        <tr><th>계획</th><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>'
				                + '        <tr><th>실적</th><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>'
				                + '    </table>'
				                + '</div>';

			}else if(classNm == "box_400"){  // ( 100 * 400 )
				widgetContent24 = '<h3 class="main_title_400">'+title+'</h3>'
				                + '<a  class="btn_main_more pointer" title="더보기" id="btnMore24" >더보기</a>'
				                + '<div class="workTerm_group padt10">'
				                + '    <div class="workTermDate padt_none">'
				                + '        <ul><li>[ 근무기간 ]</li><li id="workTermDate"></li></ul>'
				                + '    </div>'
				                + '    <table id="workTermTime">'
				                + '        <tr><th>&nbsp;</th><th>기본</th><th>연장</th><th>계</th></tr>'
				                + '        <tr><th>계획</th><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>'
				                + '        <tr><th>실적</th><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>'
				                + '    </table>'
				                + '    <div class="workTermDate padt10">'
				                + '        <ul><li>[ 근무기간 ]</li><li id="workTermDate2"></li></ul>'
				                + '    </div>'
				                + '    <table id="workTermTime2">'
				                + '        <tr><th>&nbsp;</th><th>기본</th><th>연장</th><th>계</th></tr>'
				                + '        <tr><th>계획</th><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>'
				                + '        <tr><th>실적</th><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>'
				                + '    </table>'
				                + '</div>';

			}else{ //box_100 ( 400 * 100 )
				widgetContent24 = '<h3 class="main_title_100 main_title_100_noimage">'+title+'</h3>'
				                + '<a  class="btn_main_more pointer" title="더보기" id="btnMore24" >더보기</a>'
				                + '<div class="workTerm_group">'
				                + '    <div class="workTermDate">'
				                + '        <ul><li>[ 근무기간 ]</li><li id="workTermDate"></li></ul>'
				                + '    </div>'
				                + '    <div class="workTableNote">(실적/계획, 단위:시간)</div>'
				                + '    <table id="workTermTime">'
				                + '        <tr><th>기본</th><th>연장</th><th>계</th></tr>'
				                + '        <tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>'
				                + '    </table>'
				                + '</div>';
			}

			$("#listBox24").addClass(classNm);
			$("#listBox24 > .anchor_of_widget").html(widgetContent24);

			//더보기 링크 클릭 이벤트
			$("#btnMore24").click(function() {
				var goPrgCd = "WorkTime.do?cmd=viewWorkTime";
				goSubPage("08","","","",goPrgCd);
			});

			
			if(rv.DATA == undefined || rv.DATA[0] == undefined ) return;
			
			var list24 = rv.DATA[0];
			

			$("#workTermDate").html(list24.workYmd);
			
			var tableHtml = "", tableHtml2 = "";
			if(classNm == "box_250" || classNm == "box_400" ){ // ( 250 * 250 )
				tableHtml = '<tr><th>&nbsp;</th><th>기본</th><th>연장</th><th>계</th></tr>'
				          + '<tr><th>계획</th><td>'+list24.planWtHour+'</td><td>'+list24.planOtHour+'</td><td>'+list24.planTtHour+'</td></tr>'
				          + '<tr><th>실적</th><td>'+list24.wtHour+'</td><td>'+list24.otHour+'</td><td>'+list24.ttHour+'</td></tr>';
			}
			
			if(classNm == "box_400" && rv.DATA.length == 2){  // ( 100 * 400 )
				$("#workTermDate2").html(rv.DATA[1].workYmd);
				tableHtml2 = '<tr><th>&nbsp;</th><th>기본</th><th>연장</th><th>계</th></tr>'
				          + '<tr><th>계획</th><td>'+rv.DATA[1].planWtHour+'</td><td>'+rv.DATA[1].planOtHour+'</td><td>'+rv.DATA[1].planTtHour+'</td></tr>'
				          + '<tr><th>실적</th><td>'+rv.DATA[1].wtHour+'</td><td>'+rv.DATA[1].otHour+'</td><td>'+rv.DATA[1].ttHour+'</td></tr>';

				$("#workTermTime2").html(tableHtml2);
			}
			
			if(classNm == "box_100" ){//box_100 ( 400 * 100 )
				tableHtml = '<tr><th>기본</th><th>연장</th><th>계</th></tr>'
				          + '<tr><td>'+list24.wtHour+' / '+list24.planWtHour+'</td><td>'+list24.otHour+' / '+list24.planOtHour+'</td><td>'+list24.ttHour+' / '+list24.planTtHour+'</td></tr>';
			}

			$("#workTermTime").html(tableHtml);

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}
</script>
<div id="listBox24" lv="24" info="근무시간" class="notice_box">
	<div class="anchor_of_widget">
<%/*
 		<h3 class="main_title_100 main_title_100_noimage">근무시간</h3>
        <a  class="btn_main_more pointer" title="더보기" id="btnMore24" >더보기</a>

   		<div class="workTerm_group">
   			<div class="workTermDate">
   				<ul><li>[ 근무기간 ]</li><li id="workTermDate">2020.01.01 ~ 2020.01.07</li></ul>
   			 </div>
   			<div class="workTableNote">(실적/계획, 단위:시간)</div>
	   		<table id="workTermTime">
	   		    <tr><th>기본</th><th>연장</th><th>계</th></tr>
	   		    <tr><td>40 / 40</td><td>12 / 12</td><td>52 / 52</td></tr>
	   		</table>
		</div>        
       
        <h3 class="main_title_400">근무시간</h3>
        <a  class="btn_main_more pointer" title="더보기" id="btnMore24" >더보기</a>
 	
   		<div class="workTerm_group">
   			<div class="workTermDate">
   				<ul><li>[ 근무기간 ]</li><li id="workTermDate">2020.01.01 ~ 2020.01.07</li></ul>
   			 </div>
	   		<table id="workTermTime">
	   		    <tr><th>&nbsp;</th><th>기본</th><th>연장</th><th>계</th></tr>
	   		    <tr><th>계획</th><td>40</td><td>12</td><td>52</td></tr>
	   		    <tr><th>실적</th><td>40</td><td>12</td><td>52</td></tr>
	   		</table>
	   		
   			<div class="workTermDate">
   				<ul><li>[ 근무기간 ]</li><li id="workTermDate2">2020.01.01 ~ 2020.01.07</li></ul>
   			 </div>
	   		<table id="workTermTime2">
	   		    <tr><th>&nbsp;</th><th>기본</th><th>연장</th><th>계</th></tr>
	   		    <tr><th>계획</th><td>40</td><td>12</td><td>52</td></tr>
	   		    <tr><th>실적</th><td>40</td><td>12</td><td>52</td></tr>
	   		</table>
		</div>
*/ %>
	</div>
</div>