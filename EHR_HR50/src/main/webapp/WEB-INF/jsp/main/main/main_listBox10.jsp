<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">

var _base_index10 = 0;
list10 = null;
var myTimer10;
var default_class10 = "";
var page10 = 1;
var cntPage10 = 0;
var mode10 = "";
var str = "";
var tmp = "";


function main_listBox10(title, info, classNm10, seq){

	$("#listBox10").attr("seq", seq);

	default_class10 = classNm10;
	var queryType10 = "";

	if(classNm10 == "box_100"){
		queryType10 = "${ctx}/getListBox10List.do?page="+page10+"&countAnniv=2";
	} else {
		queryType10 = "${ctx}/getListBox10List.do";
	}

	var list2 = ajaxCall("${ctx}/getListBox10List.do","",false).DATA;
	$.ajax({
		url 		: queryType10,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			list10 = rv.DATA;

			var getBox10Cnt = ajaxCall("${ctx}/getListBox10ListCnt.do",$("#mainForm").serialize(),false).list;
			cntPage10 = Math.ceil(getBox10Cnt.length/ 2);

			var classTypeHtml10;

			if ( classNm10 == undefined || classNm10== null || classNm10 == "undefined" || classNm10 == "null" || classNm10 == "" ){
				classNm10 = "box_250";
			}

			if(classNm10 == "box_100"){
				var btn_str10 = "";
				if(cntPage10 > 1){
					btn_str10 = '<div id="prev_btn_10" class="box100_btn_prev"><a href="javascript:btnUp10();" style="cursor:pointer" class="btn_up">이전</a></div><div id="next_btn_10" class="box100_btn_next"><a href="javascript:btnDw10();" style="cursor:pointer" class="btn_down">다음</a></div>';
				}

				classTypeHtml10 = '<h3 class="main_title_100 img_100_hrmanager">인사담당자</h3>'+btn_str10
					+ '<div class="newcomer_group">'
					+ '<div class="newcomer_img">'
					+ '<img id="newFace_img100_0" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</div>'
					+ '<div class="newcomer_txt" id="ncTxt100_0">'
					+ '</div>'
					+ '<div class="newcomer_img">'
					+ '<img id="newFace_img100_1" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</div>'
					+ '<div class="newcomer_txt" id="ncTxt100_1">'
					+ '</div>'
					+ '</div>';
			} else if(classNm10 == "box_250"){

				classTypeHtml10 = '<h3 class="main_title_250">인사담당자</h3>'
					+ '<div class="hrdir_group">'
					+ '<div id="prev_btn_10" class="hrdir_btn_prve"><a style="cursor:pointer" class="btn_prev_s">이전</a></div>'
					+ '<div id="next_btn_10" class="hrdir_btn_next"><a style="cursor:pointer" class="btn_next_s">다음</a></div>'
					+ '</div>'
					+ '<ul class="header_group" id="header_group_250">'
					+ '<li class="header_img">'
					+ '<img id="newFace_img_0" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</li>'
					+ '<li class="header_txt" id="ncTxt_0">'
					+ '</li>'
					+ '</ul>'
					+ '<div class="header_btn_group" id="header_btn_group_10">'
					+ '<span class="on" id="onOff_0" style="cursor:pointer">0</span>'
					+ '<span class="off" id="onOff_1" style="cursor:pointer">1</span>'
					+ '<span class="off" id="onOff_2" style="cursor:pointer">2</span>'
					+ '<span class="off" id="onOff_3" style="cursor:pointer">3</span>'
					+ '</div>';


			} else if(classNm10 == "box_400"){

				classTypeHtml10 = '<h3 class="main_title_400">인사담당자</h3>'
					+ '<div class="newcomer_group">'
					+ '<div class="newcomer_img">'
					+ '<img id="newFace_img_0" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</div>'
					+ '<div id="prev_btn_10" class="newcomer_btn_prve"><a style="cursor:pointer" class="btn_prev_b">이전</a></div>'
					+ '<div id="next_btn_10" class="newcomer_btn_next"><a style="cursor:pointer" class="btn_next_b">다음</a></div>'
					+ '<div class="newcomer_txt" id="ncTxt_0">'
					+ '</div>'
					+ '</div>'

			}

			$("#listBox10 > .anchor_of_widget").html(classTypeHtml10);
			$("#listBox10").removeClass();
			$("#listBox10").addClass(classNm10);

			if(classNm10 == "box_250"){
				tmp = "<span class='header_type' id='header_type#SEQ#'>#OPOSITION# </span>"
					+ "<span class='header_name' id='header_name#SEQ#'>#ONAME# </span>"
					+ "<span class='header_tel' id='header_tel#SEQ#'>내선번호 #OTEL# </span>"
					+ "<input type='hidden' id='header_sabun#SEQ#' value='#SABUN#' >";
			} else {
				tmp = "<span id='header_type#SEQ#'>#OPOSITION# </span>"
					+ "<span class='newcomer_name' id='header_name#SEQ#'>#ONAME# </span>"
					+ "<span class='newcomer_date' id='header_tel#SEQ#'>내선번호 #OTEL# </span>"
					+ "<input type='hidden' id='header_sabun#SEQ#' value='#SABUN#' >";
			}



			str = "";
			var r = 0;

			if(classNm10 == "box_100"){

				for(var i=0; i<list10.length; i++){
					r++;
					str = tmp.replace(/#OPOSITION#/g,list10[i].positionNm)
			          .replace(/#ONAME#/g,list10[i].name)
			          .replace(/#OTEL#/g,list10[i].officeTel)
			          .replace(/#SEQ#/g, r)
			          .replace(/#SABUN#/g, list10[i].sabun);

				 	$("#ncTxt100_"+ i).html(str);
				 	$("#newFace_img100_" + i).attr("src","${ctx}/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword="+list10[i].sabun +"&t=" + (new Date()).getTime());

				 	$("#ncTxt100_"+ i).hide();
				 	$("#newFace_img100_"+i).hide();
				 	$("#newFace_img100_1").hide();

				 	if(mode10 == ""){
					 	$("#ncTxt100_"+ i).show();
					 	$("#newFace_img100_" + i).show();
				 	}else if(mode10 == "up"){
				 		$("#ncTxt100_"+ i).show("slide", {direction: "up" }, "slow");
				 		$("#newFace_img100_" + i).show("slide", {direction: "up" }, "slow");
				 	} else if (mode10 == "dw"){
				 		$("#ncTxt100_"+ i).show("slide", {direction: "down" }, "slow");
				 		$("#newFace_img100_" + i).show("slide", {direction: "down" }, "slow");
				 	}
				}

			}
			$("#prev_btn_10").off();
			$("#prev_btn_10").on("click" , function(e){

				if(classNm10 != "box_100"){

					clearTimeout(myTimer10);

					_base_index10 = _base_index10 - 1;
					$("#ncTxt_0").hide("slide", {direction: "left" }, "fast");
					makeNewEmpHtml_10();
					$("#ncTxt_0").show("slide", {direction: "right" }, "fast");
					timeoutSet_10(classNm10);

				}
			});

			$("#next_btn_10").off();
			$("#next_btn_10").on("click" , function(e){

				if(classNm10 != "box_100"){

					clearTimeout(myTimer10);
					_base_index10 = _base_index10 + 1;
					$("#ncTxt_0").hide("slide", {direction: "right" }, "fast");
					makeNewEmpHtml_10();
					$("#ncTxt_0").show("slide", {direction: "left" }, "fast");
					timeoutSet_10(classNm10);
				}


			});


			$("#header_btn_group_10 > span").off();
			$("#header_btn_group_10 > span").on("click", function(){

				if(classNm10 != "box_100"){

					var bubble10 = $(this).text();

					if(bubble10 > _base_index10){

						clearTimeout(myTimer10);

						_base_index10 = parseInt(bubble10, 10);
						$("#ncTxt_0").hide("slide", {direction: "right" }, "fast");
						makeNewEmpHtml_10(classNm10);
						$("#ncTxt_0").show("slide", {direction: "left" }, "fast");
						timeoutSet_10(classNm10);


					} else if(bubble10 < _base_index10) {

						clearTimeout(myTimer10);

						_base_index10 = parseInt(bubble10, 10);
						$("#ncTxt_0").hide("slide", {direction: "left" }, "fast");
						makeNewEmpHtml_10(classNm10);
						$("#ncTxt_0").show("slide", {direction: "right" }, "fast");
						timeoutSet_10(classNm10);

					} else {
						return;
					}

				}

			});

			makeNewEmpHtml_10();
			timeoutSet_10(classNm10);

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}



function timeoutSet_10(classNm10){

	if(default_class10 == classNm10 && default_class10 != "box_100"){

		if ( list10.length > 1 ){

			myTimer10 = setTimeout(function(){

				_base_index10 = ( _base_index10 + 1 ) % list10.length;

				if ( _base_index10 == 0 ){

					$("#ncTxt_0").hide("slide", {direction: "left" }, "fast");
					makeNewEmpHtml_10();
					$("#ncTxt_0").show("slide", {direction: "right" }, "fast");
				}else{
					$("#ncTxt_0").hide("slide", {direction: "right" }, "fast");
					makeNewEmpHtml_10();
					$("#ncTxt_0").show("slide", {direction: "left" }, "fast");
				}

				timeoutSet_10(classNm10);
			}, 7000 );
		}

	}

}


function makeNewEmpHtml_10(){

	if(default_class10 == "box_100"){

		if(list10.length == 0){
			$("#newFace_img100_0").hide();
			$("#newFace_img100_1").hide();
			$("#ncTxt100_0").html("등록된 자료가 없습니다.");
		}

	} else {

		if ( _base_index10 == 0 ){
			$("#prev_btn_10").hide();
			$("#next_btn_10").css("margin-left",  "183px");
		}else{
			$("#prev_btn_10").show();
			$("#next_btn_10").css("margin-left",  "14px");
		}

		if ( _base_index10 == (list10.length -1)){

			$("#next_btn_10").hide();
		}else{

			$("#next_btn_10").show();
		}

		$('.bubbleSpan:eq(' + (_base_index10 ) + ')').trigger("click");



		if(list10.length > 0){
			str = tmp.replace(/#OPOSITION#/g,list10[_base_index10].positionNm)
	          .replace(/#ONAME#/g,list10[_base_index10].name)
	          .replace(/#OTEL#/g,list10[_base_index10].officeTel)
	          .replace(/#SEQ#/g, _base_index10)
	          .replace(/#SABUN#/g, list10[_base_index10].sabun);

			$("#newFace_img_0").attr("src","${ctx}/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword="+list10[_base_index10].sabun +"&t=" + (new Date()).getTime());
			$("#ncTxt_0").html(str);
		} else {

			$("#prev_btn_10").hide();
			$("#next_btn_10").hide();
			$("#newFace_img_0").hide();
			$("#ncTxt100_1").hide();

			if(default_class10 == "box_250"){
				$("#header_group_250").html("");
				str = "등록된 자료가 없습니다.";
				$("#header_group_250").html(str);
			} else if(default_class10 == "box_400"){
				$("#ncTxt_0").html("");
				str = "등록된 자료가 없습니다.";
				$("#ncTxt_0").html(str);

			}

		}


		//4건 이상일 경우 버븦  hide
		if(default_class10 == "box_250"){

			$("#onOff_0").hide();
			$("#onOff_1").hide();
			$("#onOff_2").hide();
			$("#onOff_3").hide();

			if(list10.length > 4){
				$("#header_btn_group_10").hide();
			} else {
				for(var i=0; i<list10.length; i++){
					$("#onOff_" + i).show();
				}

				$("#onOff_0").removeClass();
				$("#onOff_0").addClass("off");

				$("#onOff_1").removeClass();
				$("#onOff_1").addClass("off");

				$("#onOff_2").removeClass();
				$("#onOff_2").addClass("off");

				$("#onOff_3").removeClass();
				$("#onOff_3").addClass("off");

				$("#onOff_" + _base_index10).addClass("on");

			}
		}

	}


}

function btnUp10(){

	var box10_page = parseInt($("#box10_page").val(),10);

	if(box10_page > 1){
		box10_page = box10_page - 1;
		page10 = box10_page;

		$("#box10_page").val(box10_page);
		mode10 = "up";
		main_listBox10("인사담당자", "HR담당자 연락처 보기", "box_100");
	}
}

function btnDw10(){

	var box10_page = parseInt($("#box10_page").val(),10);

	if(cntPage10 > box10_page){
		box10_page = box10_page + 1;
		$("#box10_page").val(box10_page);
		page10 = box10_page;

		mode10 = "dw";
		main_listBox10("인사담당자", "HR담당자 연락처 보기", "box_100");
	}


}


</script>
<input type="hidden" id="box10_page" name="box10_page" value="1" />
<div id="listBox10" lv="10" class="notice_box">
	<div class="anchor_of_widget">
	</div>
</div>
<!-- 인사담당자 -->
<!--
<div lv="10" id="listBox10" class="box_240">
	<div class="anchor_of_widget">
		<h3 class="main_title">인사담당자</h3>

		<div id="ncGroup_10" class="hrdir_group">
			<ul class="header_group">
				<li class="header_img" id="header_img10">
					<img id="newFace_img_10" src="/common/images/common/img_left_photo.gif" alt="대표사진">
				</li>
				<li class="header_txt" id="header_txt10">
					<span class="header_type">인적자원관리</span><span class="header_name">최수영 팀장</span><span class="header_tel">내선번호 8453</span>
				</li>
			</ul>
		</div>


		<div class="header_btn_group" id="header_btn_group10">
	 		<span class="off">1</span>
			<span class="on">2</span>
			<span class="off">3</span>
			<span class="off">4</span>
		</div>
	</div>
</div>
-->
<!-- //인사담당자 end -->

