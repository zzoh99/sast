<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">

	var _base_index_08 = 0;

	list88 = null;
	var myTimer8;
	var page8 = 1;
	var cntPage8 = 0;
	var default_class8 = "";
	var mode = "";

function main_listBox8(title, info, classNm8, seq ){

	$("#listBox8").attr("seq", seq);

	default_class8 = classNm8;

	$("#lb8Title").text(title);
	var queryType8 = "";

	if(classNm8 == "box_100"){
		queryType8 = "${ctx}/getListBox8List2.do?page="+page8+"&countAnniv=2";
	} else {
		queryType8 = "${ctx}/getListBox8List.do";
	}

	$.ajax({
		url 		: queryType8,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			list88 = rv.DATA;

			var getBox8Cnt = ajaxCall("${ctx}/getListBox8ListCnt.do",$("#mainForm").serialize(),false).list;
			cntPage8 = Math.ceil(getBox8Cnt.length/ 2);

			/*
			if(list88.length == 0) {
				$("#lb8More").hide();
				$("#lb8NoData").show();
				return false;
			}
			*/

			var classTypeHtml08;

			if ( classNm8 == undefined || classNm8== null || classNm8 == "undefined" || classNm8 == "null" || classNm8 == "" ){
				classNm8 = "box_250";
			}

			if(classNm8 == "box_100"){

				var btn_str8 = "";
				if(cntPage8 > 1){
					btn_str8 = '<div id="prev_btn_8" class="box100_btn_prev"><a style="cursor:pointer" class="btn_up">이전</a></div><div id="next_btn_8" class="box100_btn_next"><a style="cursor:pointer" class="btn_down">다음</a></div>';
				}

				classTypeHtml08 = '<h3 id="lb8Title" class="main_title_100 img_100_newcomer">신규입사자</h3>'
					+ '<a id="moreInfo" class="btn_main_more" title="더보기" style="cursor:pointer; top:10px !important;">더보기</a>'
					+btn_str8+''
					+ '<div class="newcomer_group">'
					+ '<div class="newcomer_img">'
					+ '<img id="newFace_img0" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</div>'
					+ '<div class="newcomer_txt" id="ncTxt0">'
					+ '</div>'

					+ '<div class="newcomer_img">'
					+ '<img id="newFace_img1" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</div>'
					+ '<div class="newcomer_txt" id="ncTxt1">'
					+ '</div>'

					+ '</div>';
			} else if(classNm8 == "box_250"){

				classTypeHtml08 = '<h3 id="lb8Title" class="main_title_250">신규입사자</h3>'
					+ '<a id="moreInfo" class="btn_main_more" title="더보기" style="cursor:pointer">더보기</a>'
					+ '<div class="hrdir_group">'
					+ '<div id="prev_btn_8" class="hrdir_btn_prve"><a style="cursor:pointer" class="btn_prev_s">이전</a></div>'
					+ '<div id="next_btn_8" class="hrdir_btn_next"><a style="cursor:pointer" class="btn_next_s">다음</a></div>'
					+ '</div>'
					+ '<ul class="header_group" id="hrdir_group8_250">'
					+ '<li class="header_img">'
					+ '<img id="newFace_img" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</li>'
					+ '<li class="header_txt" id="ncTxt">'
					+ '</li>'
					+ '</ul>'
					+ '<div class="header_btn_group" id="header_btn_group_8">'
					+ '<span class="on" id="onOff0">0</span>'
					+ '<span class="off" id="onOff1">1</span>'
					+ '<span class="off" id="onOff2">2</span>'
					+ '<span class="off" id="onOff3">3</span>'
					+ '</div>';


			} else if(classNm8 == "box_400"){

				classTypeHtml08 = '<h3 id="lb8Title" class="main_title_400">신규입사자</h3>'
					+ '<a id="moreInfo" class="btn_main_more" title="더보기" style="cursor:pointer">더보기</a>'
					+ '<div class="newcomer_group">'
					+ '<div class="newcomer_img">'
					+ '<img id="newFace_img" src="/common/images/common/img_photo.gif" alt="대표사진">'
					+ '</div>'
					+ '<div id="prev_btn_8" class="newcomer_btn_prve"><a style="cursor:pointer" class="btn_prev_b">이전</a></div>'
					+ '<div id="next_btn_8" class="newcomer_btn_next"><a style="cursor:pointer" class="btn_next_b">다음</a></div>'
					+ '<div class="newcomer_txt" id="ncTxt">'
					+ '</div>'
					+ '</div>'

			}

			$("#listBox8 > .anchor_of_widget").html(classTypeHtml08);
			$("#listBox8").removeClass();
			$("#listBox8").addClass(classNm8);

			$("#prev_btn_8").off();
			$("#prev_btn_8").on("click" , function(e){
				if(classNm8 != "box_100"){
					clearTimeout(myTimer8);
					_base_index_08 = _base_index_08 - 1;
					$("#ncTxt").hide("slide", {direction: "left" }, "fast");
					makeNewEmpHtml(classNm8);
					$("#ncTxt").show("slide", {direction: "right" }, "fast");
					timeoutSet_8(classNm8);
				}
			});


			$("#next_btn_8").off();
			$("#next_btn_8").on("click" , function(e){
				if(classNm8 != "box_100"){
					clearTimeout(myTimer8);
					_base_index_08 = _base_index_08 + 1;
					$("#ncTxt").hide("slide", {direction: "right" }, "fast");
					makeNewEmpHtml(classNm8);
					$("#ncTxt").show("slide", {direction: "left" }, "fast");
					timeoutSet_8(classNm8);
				}
			});

			$("#header_btn_group_8 > span").off();
			$("#header_btn_group_8 > span").on("click",function(){
				if(classNm8 != "box_100"){
					var bubble = $(this).text();
					if(bubble > _base_index_08){
						clearTimeout(myTimer8);
						_base_index_08 = parseInt(bubble, 10);
						$("#ncTxt").hide("slide", {direction: "right" }, "fast");
						makeNewEmpHtml(classNm8);
						$("#ncTxt").show("slide", {direction: "left" }, "fast");
						timeoutSet_8(classNm8);
					} else if(bubble < _base_index_08) {
						clearTimeout(myTimer8);
						_base_index_08 = parseInt(bubble, 10);
						$("#ncTxt").hide("slide", {direction: "left" }, "fast");
						makeNewEmpHtml(classNm8);
						$("#ncTxt").show("slide", {direction: "right" }, "fast");
						timeoutSet_8(classNm8);
					} else {
						return;
					}
				}
			}).css("cursor" , "pointer");

			makeNewEmpHtml(classNm8);
			timeoutSet_8(classNm8);

			// 더보기 링크 클릭 이벤트
			$("#moreInfo").click(function() {
				var goPrgCd = "NewEmpLst.do?cmd=viewNewEmpLst";
				goSubPage("","","","",goPrgCd);
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}



function timeoutSet_8(classNm8){

	if(default_class8 == classNm8 && default_class8 != "box_100"){

		if ( list88.length > 1 ){

			myTimer8 = setTimeout(function(){

				_base_index_08 = ( _base_index_08 + 1 ) % list88.length;

				if ( _base_index_08 == 0 ){

					$("#ncTxt").hide("slide", {direction: "left" }, "fast");
					makeNewEmpHtml(classNm8);
					$("#ncTxt").show("slide", {direction: "right" }, "fast");
				}else{
					$("#ncTxt").hide("slide", {direction: "right" }, "fast");
					makeNewEmpHtml(classNm8);
					$("#ncTxt").show("slide", {direction: "left" }, "fast");
				}

				timeoutSet_8(classNm8);
			}, 7000 );
		}

	}

}

function makeNewEmpHtml(classNm8){

	if(default_class8 == "box_100"){

		$('#prev_btn_8').click(function(){ btnUp8(); });


		$('#next_btn_8').click(function(){ btnDw8(); });

	} else {

		if ( _base_index_08 == 0 ){
			$("#prev_btn_8").hide();
			$("#next_btn_8").css("margin-left",  "183px");
		}else{
			$("#prev_btn_8").show();
			$("#next_btn_8").css("margin-left",  "14px");
		}

		if ( _base_index_08 == (list88.length -1)){

			$("#next_btn_8").hide();
		}else{

			$("#next_btn_8").show();
		}
	}



	$('#ncTxt').html(""); //클리어

	var str = "";
	var tmp = "";



	if(classNm8 == "box_250"){
		tmp = "<span class='header_type'>#DATA1# #DATA2#</span><span class='header_name'>#DATA3#</span><span class='header_tel'>#DATA4# 입사</span>";
	} else {
		tmp = "<span>#DATA1#</span><span>#DATA2#</span><span class='newcomer_name'>#DATA3#</span><span class='newcomer_date'>#DATA4# 입사</span>";
	}


	var sabun = "";


	if(list88.length > 0){

		if(classNm8 == "box_100"){

		 	for(var i=0; i<list88.length; i++){

				sabun = list88[i].sabun;
				str = tmp.replace(/#DATA1#/g,list88[i].orgNm)
				         .replace(/#DATA2#/g,list88[i].jikweeNm)
				         .replace(/#DATA3#/g,list88[i].name)
				         .replace(/#DATA4#/g,list88[i].empYmd);

			 	$("#ncTxt"+ i).html(str);
			 	$("#newFace_img" + i).attr("src","${ctx}/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword="+sabun);

			 	$("#ncTxt"+ i).hide();
			 	$("#newFace_img"+i).hide();
			 	$("#newFace_img1").hide();

			 	if(mode == ""){
				 	$("#ncTxt"+ i).show();
				 	$("#newFace_img" + i).show();
			 	}else if(mode == "up"){
			 		$("#ncTxt"+ i).show("slide", {direction: "up" }, "slow");
			 		$("#newFace_img" + i).show("slide", {direction: "up" }, "slow");
			 	} else if (mode == "dw"){
			 		$("#ncTxt"+ i).show("slide", {direction: "down" }, "slow");
			 		$("#newFace_img" + i).show("slide", {direction: "down" }, "slow");
			 	}

		 	}

		} else {

			sabun = list88[_base_index_08].sabun;
			str = tmp.replace(/#DATA1#/g,list88[_base_index_08].orgNm)
			         .replace(/#DATA2#/g,list88[_base_index_08].jikweeNm)
			         .replace(/#DATA3#/g,list88[_base_index_08].name)
			         .replace(/#DATA4#/g,list88[_base_index_08].empYmd);

			$("#newFace_img").attr("src","${ctx}/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword="+sabun);
			$("#ncTxt").html(str);
		}

	} else {
		$("#prev_btn_8").hide();
		$("#next_btn_8").hide();
		$("#newFace_img").hide();
		$("#newFace_img0").hide();
		$("#newFace_img1").hide();

		if(default_class8 == "box_250"){
			$("#hrdir_group8_250").html("");
			str = "등록된 자료가 없습니다.";
			$("#hrdir_group8_250").html(str);
			$("#header_btn_group_8").hide();

		} else if(default_class8 == "box_400"){
			$("#ncTxt").html("");
			str = "등록된 자료가 없습니다.";
			$("#ncTxt").html(str);

		} else if(default_class8 == "box_100"){
			$("#ncTxt0").html("등록된 자료가 없습니다.");
		}


		//str = "<span class='newcomer_date'>신규 입사자가 없습니다.</span>";
		//$("#ncTxt").html(str);
	}

	//4건 이상일 경우 버븦  hide
	if(classNm8 == "box_250"){

		$("#onOff0").hide();
		$("#onOff1").hide();
		$("#onOff2").hide();
		$("#onOff3").hide();

		if(list88.length > 4){
			$(".header_btn_group").hide();
		} else {
			for(var i=0; i<list88.length; i++){
				$("#onOff" + i).show();
			}

			$("#onOff0").removeClass();
			$("#onOff0").addClass("off");

			$("#onOff1").removeClass();
			$("#onOff1").addClass("off");

			$("#onOff2").removeClass();
			$("#onOff2").addClass("off");

			$("#onOff3").removeClass();
			$("#onOff3").addClass("off");

			$("#onOff" + _base_index_08).addClass("on");

		}
	}

}


function btnUp8(){

	var box8_page = parseInt($("#box8_page").val(),10);

	if(box8_page > 1){
		box8_page = box8_page - 1;
		page8 = box8_page;

		$("#box8_page").val(box8_page);
		mode = "up";
		main_listBox8("신규입사자", "최근입사자 보기", "box_100");
	}

}


function btnDw8(){

	var box8_page = parseInt($("#box8_page").val(),10);

	if(cntPage8 > box8_page){
		box8_page = box8_page + 1;
		$("#box8_page").val(box8_page);
		page8 = box8_page;

		mode = "dw";
		main_listBox8("신규입사자", "최근입사자 보기", "box_100");
	}


}

</script>
<input type="hidden" id="box8_page" name="box8_page" value="1" />
<div id="listBox8" lv="8"  class="notice_box">
	<div class="anchor_of_widget">
	</div>
</div>
<!--
<div class="box_390" id="listBox8" lv="8" title="신규입사자" info="최근입사자 보기" >
	<div class="anchor_of_widget">
		<h3 id="lb8Title" class="main_title_390">신규입사자</h3>
		<div id="ncGroup" class="newcomer_group">
			<div class="newcomer_img">
				<img id="newFace_img" src="/common/images/common/img_left_photo.gif" alt="대표사진">
			</div>
			<div id="ncTxt" class="newcomer_txt">
			</div>
		</div>
		<div id="lb8More" class="btn_alignC">
			<a id="moreInfo" class="btnW pointer">더보기</a>
		</div>
		<div id="lb8NoData" class="btn_alignC" style="display:none;">
			<span>데이터가 없습니다.</span>
		</div>
	</div>
</div>
 -->