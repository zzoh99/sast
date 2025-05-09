<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
var widgetContent16;

function main_listBox16(title, info, classNm, seq ){

	$("#listBox16").attr("seq", seq);

	var lCnt = ajaxCall("${ctx}/getListBox16Cnt.do", "", false);
	$("#box16_listCnt").val(lCnt.DATA[0].cnt);

	loadApp16(1 , 0, classNm);
}


function btnUp16(){

	var box16_page = parseInt($("#box16_page").val(),10);
	box16_page = box16_page - 1;

	if(box16_page >= 1){
		$("#box16_page").val( box16_page);
		loadApp16(box16_page, 1, "box_100");
	}


}

function btnDw16(){
	var cnt = $("#box16_listCnt").val();

	var box16_page = parseInt($("#box16_page").val(),10);
	box16_page = box16_page + 1;

	var tPage = "";
	if(cnt%2 != 0){
		tpage = (cnt/2) + 1;
	}else{
		tpage = cnt/2;
	}

	if( box16_page <= tpage ){
		$("#box16_page").val( box16_page);
		loadApp16(box16_page, 2, "box_100");
	}
}


function loadApp16( page , mode16 , classNm){
	var setUrl = "";

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if(classNm == "box_100"){
		setUrl = "${ctx}/getListBox16List.do?page="+page+"&countAnniv=2";
	}else{
		setUrl = "${ctx}/getListBox16List.do";
	}

	var list = null;

	$.ajax({
		url 		: setUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list16 = rv.DATA;

			$("#listBox16").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent16 = '<h3 class="main_title_250">이달의 기념일</h3>'
						      + '<a  class="btn_main_more" title="더보기" id="anniversaryWidget" >더보기</a>'
						      + '<div class="main_img_group">'
						      + '	<span class="img_250 img_100_anniv"></span>'
						      + '</div>'
						      + '<div class="anniv_group">'
						      + '<ul id="anniv_txt" class="anniv_txt" ></ul>'
						      + '</div>';


			}else if(classNm == "box_400"){

				widgetContent16 = '<h3 class="main_title_400">이달의 기념일</h3>'
				     		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_anniv"></span>'
				      		  + '</div>'
				      		  + '<div class="anniv_group">'
				      		  + '<ul id="anniv_txt" class="anniv_txt"></ul>'
				      		  + '</div>';

			}else{

				widgetContent16 = '<h3 class="main_title_100 img_100_anniv">이달의 기념일</h3>'
				      		  + '<div class="box100_btn_prev"><a href="javascript:btnUp16()" class="btn_up">이전</a></div>'
					  		  +	'<div class="box100_btn_next"><a href="javascript:btnDw16()" class="btn_down">다음</a></div>'
				      		  + '<div class="anniv_group">'
				      		  + '<ul id="anniv_txt" class="anniv_txt"></ul>'
				      		  + '</div>';

			}

			$("#listBox16").addClass(classNm);
			$("#listBox16 > .anchor_of_widget").html(widgetContent16);

			if(list16.length != 0){

			    var tmp1 = '<li><span class="anniv_icon anniv_icon_w">#DIV#</span>'
			    			+'<span class="anniv_date">#SUNDATE#</span>'
			    			+'<span class="anniv_type">#DIV#</span>'
			    			+'<span class="anniv_con">#NAME# (#ORGNM#)</span></li>';
			    var tmp2 = '<li><span class="anniv_icon anniv_icon_b">#DIV#</span>'
	    					+'<span class="anniv_date">#SUNDATE#</span>'
	    					+'<span class="anniv_type">#DIV#</span>'
	    					+'<span class="anniv_con">#NAME# (#ORGNM#)</span></li>';

				var str = "";
				for(var i=0; i<list16.length; i++){

					if ( list16[i].div == "결혼"){

						str += tmp1.replace(/#NAME#/g,list16[i].name)
				          .replace(/#ORGNM#/g,list16[i].orgNm)
				          .replace(/#DIV#/g,list16[i].div)
				          .replace(/#SUNDATE#/g,list16[i].sunDate)
				          .replace(/#LUNDAY#/g,list16[i].lunDay);
					}else{
						str += tmp2.replace(/#NAME#/g,list16[i].name)
				          .replace(/#ORGNM#/g,list16[i].orgNm)
				          .replace(/#DIV#/g,list16[i].div)
				          .replace(/#SUNDATE#/g,list16[i].sunDate)
				          .replace(/#LUNDAY#/g,list16[i].lunDay);

					}
				}

				$("#anniv_txt").html(str);
				$("#anniv_txt").hide();

 				if ( mode16 == 0 ){
					$("#anniv_txt").show();
				} else if ( mode16 == 2 ){
					$("#anniv_txt").show("slide", {direction: "down" }, "slow");
				} else if ( mode16 == 1 ){
					$("#anniv_txt").show("slide", {direction: "up" }, "slow");
				}

			}else{

			}

			//더보기 링크 클릭 이벤트
			$("#anniversaryWidget").click(function() {
				var goPrgCd = "Anniversary.do?cmd=viewAnniversary";
				goSubPage("02","","","",goPrgCd);
			});


		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});

}
</script>
<input type="hidden" id="box16_page" name="box16_page" value="1" />
<input type="hidden" id="box16_listCnt" name="box16_listCnt" />
<div  id="listBox16" lv="16" info="기념일" class="notice_box">
	<div class="anchor_of_widget">
		<!-- <div class="anniv_group">
			<div class="anniv_btn_prev"><a href="javascript:btnUp()" class="btn_up">이전</a></div>
			<div class="anniv_btn_next"><a href="javascript:btnDw()" class="btn_down">다음</a></div>
			<h3 class="anniv_title">이달의 기념일</h3>
			<ul class="anniv_txt" id="widget16">
			</ul>
		</div> -->
	</div>
</div>


