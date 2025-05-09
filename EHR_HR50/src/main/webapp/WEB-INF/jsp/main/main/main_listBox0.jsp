<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">

var cntPage = 0;
var page = 1;
var mode0 = "";

function main_listBox0(title, info, classNm, seq){

	$("#lb0Title").html(title);
	$("#listBox0").attr("seq", seq);

	var queryType0 = "";
	if(classNm == "box_100"){
		queryType0 = "${ctx}/getListBox0List2.do?page="+page+"&countAnniv=4";
	} else {
		queryType0 = "${ctx}/getListBox0List.do";
	}

	$.ajax({
		url 		: queryType0,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {

			var getBox0Cnt = ajaxCall("${ctx}/getListBox0ListCnt.do",$("#mainForm").serialize(),false).list;
			cntPage = Math.ceil(getBox0Cnt.length/ 4);

			var classTypeHtml00;
			var tmp = "";

			if ( classNm == undefined || classNm== null || classNm == "undefined" || classNm == "null" || classNm == "" ){
				classNm = "box_250";
			}

			if(classNm == "box_100"){

				var btn_str = "";

				if(cntPage > 1){

					btn_str = '<div class="box100_btn_prev"><a href="javascript:btnUp0()" class="btn_up">이전</a></div><div class="box100_btn_next"><a href="javascript:btnDw0()" class="btn_down">다음</a></div>';
				}

				classTypeHtml00 = '<h3 id="lb0Title" class="main_title_100 img_100_pay">급여지급현황</h3>'+btn_str+''
					+ '<ul class="pay_txt" id="lb0PayT">'
					+ '</ul>';

//				tmp = "<li><span class='pay_date' style='width:50px;'>#CPNYM# #CNAME#</span><span #URL# style='width: 55px;text-align: center;display: inline-block;background-color: #96999b;border-radius: 15px;line-height: 11px;color: #FFF;font-size: 11px;font-weight: bold;padding: 3px;margin: 2px 10px 5px; cursor: pointer;'>명세표보기</span><span class='pay_complete'>지급완료</span></li>";
				tmp = "<li><span class='pay_date' style='width:50px;'>#CPNYM# </span><span #URL# style='width: 55px;text-align: center;display: inline-block;background-color: #96999b;border-radius: 15px;line-height: 11px;color: #FFF;font-size: 11px;font-weight: bold;padding: 3px;margin: 2px 10px 5px; cursor: pointer;'>명세표보기</span><span class='pay_complete'>지급완료</span></li>";



			} else if(classNm == "box_250"){

				classTypeHtml00 = '<h3 id="lb0Title" class="main_title_250">급여지급현황</h3>'
					+ '<a id="payWidget" class="btn_main_more" title="더보기" style="cursor:pointer">더보기</a>'
					+ '<div class="main_img_group">'
					+ '<span class="img_250 img_100_pay"></span>'
					+ '</div>'
					+ '<ul class="pay_txt" id="lb0PayT">'
					+ '</ul>';

//				tmp = "<li>#CPNYM# #CNAME# <span #URL# style='width: 55px;text-align: center;display: inline-block;background-color: #96999b;border-radius: 15px;line-height: 11px;color: #FFF;font-size: 11px;font-weight: bold;padding: 3px;margin-top: 2px;margin-left: 5px;cursor: pointer;'>명세표보기</span></li><li class='pay_complete'>지급완료</li>";
				tmp = "<li class='disp_flex alignItem_center justify_between'>#CPNYM# <span #URL# style='width: 55px;text-align: center;display: inline-block;background-color: #96999b;border-radius: 15px;line-height: 11px;color: #FFF;font-size: 11px;font-weight: bold;padding: 3px;margin-top: 2px;margin-left: 5px;cursor: pointer;'>명세표보기</span></li><li class='pay_complete'>지급완료</li>";

			} else if(classNm == "box_400"){

				classTypeHtml00 = '<h3 id="lb0Title" class="main_title_400">급여지급현황</h3>'
					+ '<a id="payWidget" class="btn_main_more" title="더보기" style="cursor:pointer">더보기</a>'
					+ '<div class="main_img_group">'
					+ '<span class="img_400 img_400_pay"></span>'
					+ '</div>'
					+ '<ul class="pay_txt" id="lb0PayT">'
					+ '</ul>';

//				tmp = "<li>#CPNYM# #CNAME# <span #URL# style='width: 55px;text-align: center;display: inline-block;background-color: #96999b;border-radius: 15px;line-height: 11px;color: #FFF;font-size: 11px;font-weight: bold;padding: 3px;margin-top: 2px;margin-left: 5px;cursor: pointer;'>명세표보기</span></li><li class='pay_complete'>지급완료</li>";
				tmp = "<li class='disp_flex alignItem_center justify_between'>#CPNYM# <span #URL# style='width: 55px;text-align: center;display: inline-block;background-color: #96999b;border-radius: 15px;line-height: 11px;color: #FFF;font-size: 11px;font-weight: bold;padding: 3px;margin-top: 2px;margin-left: 5px;cursor: pointer;'>명세표보기</span></li><li class='pay_complete'>지급완료</li>";
			}

			$("#listBox0 > .anchor_of_widget").html(classTypeHtml00);
			$("#listBox0").removeClass();
			$("#listBox0").addClass(classNm);


			var list = rv.DATA;
		 	var str = "";

		 	for(var i=0; i<list.length; i++){
		 		tabInfo  = "payActionCd='"+list[i].payActionCd+"' ";
		 		str += tmp.replace(/#CPNYM#/g,list[i].cpnym)
		 				  .replace(/#URL#/g,tabInfo)
		 		          //.replace(/#CNAME#/g,list[i].cname)
		 		          ;
		 	}

		 	$("#lb0PayT").html(str);

		 	if(list.length == 0){
		 		$("#lb0PayT").html("등록된 자료가 없습니다.");
		 	}


			$("#lb0PayT").html(str);
			$("#lb0PayT > li").hide();


			if(mode0 == ""){
				$("#lb0PayT > li").show();
			} else if ( mode0 == "up"){
				$("#lb0PayT > li").show("slide", {direction: "down" }, "slow");
			} else if ( mode0 == "dw"){
				$("#lb0PayT > li").show("slide", {direction: "up" }, "slow");
			}



		 	$("#lb0PayT li span").click(function(event) {
		 		if( $(this).attr("payActionCd") != undefined ) {
		 			if(!isPopup()) {return;}
		 			var url = "/PerPayPartiTermASta.do?cmd=viewPerPayPartiTermAStaPopup";
		 			var args= new Array();
		 			args["sabun"]		= "${ssnSabun}";
		 			args["payActionCd"]	= $(this).attr("payActionCd");
		 		    openPopup(url, args, "950","550");
		 		}
		 	});


		 	if(list.length == 0) {
		 		//$("#payWidget").hide();
		 		//$("#lb0NoData").show();
		 	} else {
		 		// 더보기 클릭
			 	$("#payWidget").click(function() {
					goSubPage("","","","","PerPayPartiUserSta.do?cmd=viewPerPayPartiUserSta");
				});
		 	}

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});

}


function btnUp0(){

	var box0_page = parseInt($("#box0_page").val(),10);

	if(box0_page > 1){
		box0_page = box0_page - 1;
		page = box0_page;

		mode0 = "up";

		$("#box0_page").val(box0_page);
		main_listBox0("급여지급현황", "급여지급리스트 및 상세내역보기.", "box_100");
	}

}

function btnDw0(){

	var box0_page = parseInt($("#box0_page").val(),10);

	if(cntPage > box0_page){
		box0_page = box0_page + 1;
		$("#box0_page").val(box0_page);
		page = box0_page;

		mode0 = "dw";

		main_listBox0("급여지급현황", "급여지급리스트 및 상세내역보기.", "box_100");
	}


}

</script>
<input type="hidden" id="box0_page" name="box0_page" value="1" />
<div id="listBox0" lv="0" class="notice_box">
	<div class="anchor_of_widget">
	</div>
</div>
<!--
<div id="listBox0" lv="0" info="급여지급리스트 및 상세내역보기." class="box_240 clear">
	<div class="anchor_of_widget">
		<h3 id="lb0Title" class="main_title">급여지급현황</h3>
		<div class="main_img_group">
			<span class="img_pay_240"></span>
		</div>
		<ul id="lb0PayT" class="pay_txt">
		</ul>
		<div class="btn_alignC">
			<a id="payWidget"  class="btnW">더보기</a>
		</div>
		<div id="lb0NoData" class="btn_alignC" style="display:none;">
			<span>데이터가 존재하지 않습니다.</span>
		</div>
	</div>
</div>
 -->


