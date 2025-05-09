<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">

setInterval(function(){
	  $(".compStyle").toggle();
	}, 500);


var widgetContent21;
var widget21cnt = 2; // box_100 한페이지에 들어갈 row수
function main_listBox21(title, info, classNm, seq ){
	$("#listBox21").attr("seq", seq );



	/////////////////
	//classNm = "box_100";





	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if (classNm == "box_100"){
		// box_100 모드만 보여주는 데이터가 다름. 별도처리
		//var lCnt = ajaxCall("${ctx}/GetDataList.do?cmd=getListBox21List_100Cnt", "", false);

		//$("#box21_tempCnt").val(lCnt.DATA[0].cnt); // 전체건수(계획건수)
		//$("#box21_notCompCnt").val(lCnt.DATA[0].notCompCnt); // 총 미이수건수
		//$("#box21_listCnt").val(lCnt.DATA[0].listCnt); // 리스트 미이수건수
	}

	loadEdu21(1 , 0, classNm);

}

function btnUp21(){
	var box2_page= parseInt($("#box2_page").val(),10);

	box2_page = box2_page - 1;

	if(box2_page >= 1){
		$("#box2_page").val( box2_page);
		loadEdu21(box2_page, 1, "box_100");
	}


}

function btnDw21(){
	var cnt = $("#box21_listCnt").val();

	var box2_page= parseInt($("#box2_page").val(),10);
	box2_page = box2_page + 1;

	var tPage = "";
	if(cnt%widget21cnt != 0){
		tpage = (cnt/widget21cnt) + 1;
	}else{
		tpage = cnt/widget21cnt;
	}

	if( box2_page <= tpage ){
		$("#box2_page").val( box2_page);
		loadEdu21(box2_page, 2, "box_100");
	}

}

function loadEdu21(page , mode , classNm){

	var setUrl = "";

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if(classNm == "box_100"){
		setUrl = "${ctx}/GetDataList.do?cmd=getListBox21List_100&page="+page+"&countAnniv="+widget21cnt;
	}else{
		setUrl = "${ctx}/GetDataList.do?cmd=getListBox21List_100";
	}

	//alert(classNm+setUrl);

	$.ajax({
		url 		: setUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {

			var list21 = rv.DATA;

			$("#listBox21").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent21 = '<h3 class="main_title_250">교육이수현황</h3>'
						      + '<div class="main_img_group">'
						      + '	<span class="img_250 img_100_edu"></span>'
						      + '</div>'
						      + '<div class="edu_group">'
						      + '<ul id="edu_txt" class="edu_txt" ></ul>'
						      + '</div>';


			}else if(classNm == "box_400"){

				widgetContent21 = '<h3 class="main_title_400">교육이수현황</h3>'
				     		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_edu"></span>'
				      		  + '</div>'
				      		  + '<div class="edu_group">'
				      		  + '<ul id="edu_txt" class="edu_txt"></ul>'
				      		  + '</div>';

			}else{

				var cnt    = $("#box21_tempCnt").val(); // 전체건수(계획건수)
				var notCnt = $("#box21_notCompCnt").val(); // 총미이수건수

				widgetContent21 = '<h3 class="main_title_100 img_100_edu">교육계획/실적('+cnt+'/'+notCnt+')</h3>'
				      		  + '<div class="box100_btn_prev"><a href="javascript:btnUp21()" class="btn_up">이전</a></div>'
					  		  +	'<div class="box100_btn_next"><a href="javascript:btnDw21()" class="btn_down">다음</a></div>'
				      		  + '<div class="edu_group">'
				      		  + '<ul id="edu_txt" class="edu_txt"></ul>'
				      		  + '</div>';

			}

			$("#listBox21").addClass(classNm);
			$("#listBox21 > .anchor_of_widget").html(widgetContent21);



			//$("#listBox21").empty(); //클리어
			$("#listBox21").addClass(classNm);
			$("#listBox21 > .anchor_of_widget").html(widgetContent21);

			if(list21.length == 0 ) {
				//더보기 숨기기
				$("#appWidgetAppl").hide();

				if(page > 1){
					var tPage = page-1;
					$("#box2_page").val(tPage);
					loadEdu21(tPage, 0, classNm);
				}

			}else{



				//$('#lb2Lst').empty(); //클리어
				var str = "";
				var tmp = "";
					tmp  = "<li><span class='edu_name'>＊#EDU_EVENT_NM#</span>"
				         + "<br>"
				         + "<span class='edu_date'>#APPL_S_YMD#</span>"
						 + "<span class='edu_date'>#APPL_E_YMD#</span>"
					     + "&nbsp;&nbsp;"
					     + "<span class='compStyle'>#COMPLETE_YN_NM#</span>"
						 + "</li>";

				for(var i=0; i< list21.length; i++){
					var  temp_cont = tmp.replace(/#EDU_EVENT_NM#/g,list21[i].eduEventNm)
					          .replace(/#APPL_S_YMD#/g,list21[i].applSYmd)
					          .replace(/#APPL_E_YMD#/g,list21[i].applEYmd)
					          ;

					if (list21[i].completeYn == "Y") {
						temp_cont = temp_cont.replace(/#COMPLETE_YN_NM#/g, list21[i].completeYnNm);
					} else {
						temp_cont = temp_cont.replace(/#COMPLETE_YN_NM#/g, "<B><font color='RED'>"+list21[i].completeYnNm+"</font></B>");
					}
					str += temp_cont;
				}

				$("#edu_txt").html(str);
				$("#edu_txt").hide();

 				if ( mode == 0 ){
					$("#edu_txt").show();
				} else if ( mode == 2 ){
					$("#edu_txt").show("slide", {direction: "down" }, "slow");
				} else if ( mode == 1 ){
					$("#edu_txt").show("slide", {direction: "up" }, "slow");
				}


			}
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}



function createFormObject(name, value) {
	var outObj = $('<input type="text"/>').attr({ id : "" , value : "" });
}



/* function getReturnValue(returnValue) {

	var rv = $.parseJSON('{'+ returnValue+'}');

	if(pGubun == "widjetPopup") {

	}

} */
</script>
<input type="hidden" id="box21_page" name="box21_page" value="1" />
<input type="hidden" id="box21_tempCnt" name="box21_tempCnt" />
<input type="hidden" id="box21_notCompCnt" name="box21_notCompCnt" />
<input type="hidden" id="box21_listCnt" name="box21_listCnt" />
<div id="listBox21" lv="21" class="notice_box">
	<div class="anchor_of_widget">
	</div>
</div>


