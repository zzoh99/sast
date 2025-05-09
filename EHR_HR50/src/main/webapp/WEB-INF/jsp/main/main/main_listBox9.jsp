<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widgetContent;
var default_class9 = "";
var cntPage9 = 0;

function main_listBox9(title, info , classNm, seq ){

	$("#listBox9").attr("seq", seq);

	default_class9 = classNm;
	loadApp9(1 , 0, classNm);
}

// 이전
function btnUp9(){

	var box9_page = parseInt($("#box9_page").val(),10);
	box9_page = box9_page - 1;

	if(box9_page >= 1){
		$("#box9_page").val( box9_page);
		//loadApp9(box9_page, 1, "box_100");

		if(default_class9 == "box_100") {

			if(box9_page > 1){
				$("#survey_txt").slideDown("slow" , function(){
					$("#survey_txt").hide();
					loadApp9(box9_page, 1, default_class9);
				});
			}


		} else {
			$("#survey_txt").hide("slide", {direction: 'left'}, 400, function(){
				//$("#survey_txt").hide();
				loadApp9(box9_page, 1, default_class9);
			});
		}
	}
}

// 다음
function btnDw9(){

	var box9_page = parseInt($("#box9_page").val(),10);
	box9_page = box9_page + 1;

	$("#box9_page").val( box9_page);
	//loadApp9(box9_page, 2, "box_100");

	if(default_class9 == "box_100") {

		if(cntPage9 > box9_page){
			$("#survey_txt").slideDown("slow" , function(){
				$("#survey_txt").hide();
				loadApp9(box9_page, 2, default_class9);
			});
		}


	} else {
		$("#survey_txt").hide("slide", {direction: 'right'}, 400, function(){
			//$("#survey_txt").hide();
			loadApp9(box9_page, 2, default_class9);
		});
	}



}

function loadApp9(page , mode , classNm){

	var setUrl = "";

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if(classNm == "box_100"){
		setUrl = "${ctx}/getListBox9List.do?page="+page+"&countAnniv=2";
	}else{
		setUrl = "${ctx}/getListBox9List.do?page="+page+"&countAnniv=1";
	}

	$.ajax({
		url 		: setUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list9 = rv.DATA;


			var getBox9Cnt = "";
			if(classNm == "box_100"){
				getBox9Cnt = ajaxCall("${ctx}/getListBox9ListCnt.do",$("#mainForm").serialize(),false).list;
				cntPage9 = Math.ceil(getBox9Cnt.length/ 2);
			}

			$("#listBox9").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent = '<h3 class="main_title_250">설문조사</h3>'
						      + '<div class="main_img_group">'
						      + '	<span class="img_250 img_100_survey"></span>'
						      + '</div>'
						      + '<div id="survey_txt" class="survey_txt"></div>'
						      +	'<div class="survey_btn_prev"><a href="javascript:btnUp9();" class="btn_prev_b">이전</a></div>'
				      		  +	'<div class="survey_btn_next"><a href="javascript:btnDw9();" class="btn_next_b">다음</a></div>'
						      + '<div class="btn_alignC">'
							  + '	<a id="pollWidget" style="cursor: pointer;" class="btnW">참여하기</a>'
							  + '</div>';


			}else if(classNm == "box_400"){

				widgetContent = '<h3 class="main_title_400">설문조사</h3>'
				      		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_survey"></span>'
				      		  + '</div>'
				      		  + '<div id="survey_txt" class="survey_txt">'
				      		  + '</div>'
				      		  +	'<div class="survey_btn_prev"><a href="javascript:btnUp9()" class="btn_prev_b">이전</a></div>'
				      		  +	'<div class="survey_btn_next"><a href="javascript:btnDw9()" class="btn_next_b">다음</a></div>'
						      + '<div class="btn_alignC">'
							  + '	<a id="pollWidget" style="cursor: pointer;" class="btnW">참여하기</a>'
							  + '</div>';

			}else{

				widgetContent = '<h3 class="main_title_100 img_100_bookm">설문조사</h3>'
				      		  + '<div class="box100_btn_prev" id="box100_btn_prev9"><a href="javascript:btnUp9()" class="btn_up">이전</a></div>'
					  		  +	'<div class="box100_btn_next" id="box100_btn_next9"><a href="javascript:btnDw9()" class="btn_down">다음</a></div>'
				      		  + '<ul id="survey_txt" class="survey_txt"></ul>';

			}

			//$("#listBox4").empty(); //클리어
			$("#listBox9").addClass(classNm);
			$("#listBox9 > .anchor_of_widget").html(widgetContent);


			if(list9.length != 0 ) {

				var tmp = "";

				if( classNm != "box_100" ){
					tmp = "<p>#POLL#</p>"
				        + "<p>#DATE1# ~ #DATE2#</p>";
				}else{
					tmp = '<li><p>#POLL#</p>'
						+ '<p class="survey_date">#DATE1# ~ #DATE2#</p></li>';
				}

				var str = "";

				for(var i=0; i<list9.length; i++){
					str += tmp.replace(/#POLL#/g,list9[i].researchNm)
					          .replace(/#DATE1#/g,list9[i].researchSymd)
					          .replace(/#DATE2#/g,list9[i].researchEymd);
				}

				if(str==""){
					if( classNm != "box_100" ){
						str = "<p >진행중인 설문이</p><p><tit:txt mid='104215' mdef='없습니다. '/></p><p></p>";
					}else{
						str = "<li><p >진행중인 설문이</p><p><tit:txt mid='104215' mdef='없습니다. '/></p><p></p></li>";
					}
				}

				$("#survey_txt").html(str);
				$("#survey_txt").hide();

				if ( mode == 0 ){
					$("#survey_txt").show();
				} else if ( mode == 2 ){
					$("#survey_txt").show("slide", {direction: "down" }, "slow");
				} else if ( mode == 1 ){
					$("#survey_txt").show("slide", {direction: "up" }, "slow");
				}

			}else{

				if(page > 1){
					var tPage = page-1;
					$("#box9_page").val(tPage);
					loadApp9(tPage , 0 , classNm);
				}

		  		$("#box100_btn_prev9").hide();
		  		$("#box100_btn_next9").hide();

	      		$(".survey_btn_prev").hide();
			    $(".survey_btn_next").hide();
			    $("#pollWidget").hide();
			    $("#survey_txt").html("<p>등록된 자료가 없습니다.</p>");

			}

			//더보기 링크 클릭 이벤트
			$("#pollWidget").click(function() {
				var goPrgCd = "ResearchApp.do?cmd=viewResearchApp";
				goSubPage("02","","","",goPrgCd);
			});


			// classNm 1. box_250 , box_400 , box_100

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}
</script>
<input type="hidden" id="box9_page" name="box9_page" value="1" />

<div id="listBox9" lv="9" info="설문조사  참여하기" class="notice_box" >
	<div class="anchor_of_widget">
		<!-- <h3 class="main_title">설문조사</h3>
		<div class="main_img_group">
			<span class="img_survey_240"></span>
		</div>
		<div id="survey_txt" class="survey_txt">

		</div>
		<div class="btn_alignC">
			<a id="pollWidget"  class="btnW">참여하기</a>
		</div> -->
	</div>
</div>

