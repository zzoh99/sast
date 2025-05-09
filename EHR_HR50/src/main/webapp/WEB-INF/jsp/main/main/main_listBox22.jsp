<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">

var widgetContent22;
var widget22cnt = 4; // box_100 한페이지에 들어갈 row수
function main_listBox22(title, info, classNm, seq ){
	$("#listBox22").attr("seq", seq );



	/////////////////
	///classNm = "box_250";





	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if (classNm == "box_100"){
		// box_100 모드만 보여주는 데이터가 다름. 별도처리
		var lCnt = ajaxCall("${ctx}/GetDataList.do?cmd=getListBox22List_100Cnt", "", false);

		$("#box22_listCnt").val(lCnt.DATA[0].cnt);
	}

	load22(1 , 0, classNm);

}

function btnUp22(){
	var box22_page= parseInt($("#box22_page").val(),10);

	box22_page = box22_page - 1;

	if(box22_page >= 1){
		$("#box22_page").val( box22_page);
		load22(box22_page, 1, "box_100");
	}


}

function btnDw22(){
	var cnt = $("#box22_listCnt").val();

	var box22_page= parseInt($("#box22_page").val(),10);
	box22_page = box22_page + 1;

	var tPage = "";
	if(cnt%widget22cnt != 0){
		tpage = (cnt/widget22cnt) + 1;
	}else{
		tpage = cnt/widget22cnt;
	}

	if( box22_page <= tpage ){
		$("#box22_page").val( box22_page);
		load22(box22_page, 2, "box_100");
	}

}

function load22(page , mode , classNm){

	var setUrl = "";

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if(classNm == "box_100"){
		setUrl = "${ctx}/GetDataList.do?cmd=getListBox22List&page="+page+"&countAnniv="+widget22cnt;
	}else{
		setUrl = "${ctx}/GetDataList.do?cmd=getListBox22List";
	}

	//alert(classNm+setUrl);

	$.ajax({
		url 		: setUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {

			var list22 = rv.DATA;

			$("#listBox22").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent22 = '<h3 class="main_title_250">오늘의 휴가자</h3>'
						      + '<div class="main_img_group">'
						      + '	<span class="img_250 img_100_holiday"></span>'
						      + '</div>'
						      + '<div class="today_holiday">'
						      + '<ul id="lb22Lst" class="cont_txt" ></ul>'
						      + '</div>';


			}else if(classNm == "box_400"){

				widgetContent22 = '<h3 class="main_title_400">오늘의 휴가자</h3>'
				     		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_holiday"></span>'
				      		  + '</div>'
				      		  + '<div class="today_holiday">'
				      		  + '<ul id="lb22Lst" class="cont_txt"></ul>'
				      		  + '</div>';

			}else{
				widgetContent22 = '<h3 class="main_title_100 img_100_holiday">오늘의 휴가자</h3>'
				      		  + '<div class="box100_btn_prev"><a href="javascript:btnUp22()" class="btn_up">이전</a></div>'
					  		  +	'<div class="box100_btn_next"><a href="javascript:btnDw22()" class="btn_down">다음</a></div>'
				      		  + '<div class="today_holiday">'
				      		  + '<ul id="lb22Lst" class="cont_txt" style="width:550px"></ul>'
				      		  + '</div>';
			}

			$("#listBox22").addClass(classNm);
			$("#listBox22 > .anchor_of_widget").html(widgetContent22);



			//$("#listBox22").empty(); //클리어
			$("#listBox22").addClass(classNm);
			$("#listBox22 > .anchor_of_widget").html(widgetContent22);

			if(list22.length == 0 ) {
				//더보기 숨기기
				$("#appWidgetAppl").hide();

				if(page > 1){
					var tPage = page-1;
					$("#box22_page").val(tPage);
					load22(tPage, 0, classNm);
				}

			}else{



				//$('#lb2Lst').empty(); //클리어
				var str = "";
				var tmp = "";
// 					tmp  = "<li><span class='name'>#NAME#</span>"
// 				         + "<span class='org_nm'>#ORG_NM#</span>"
// 						 + "<span class='gnt_nm'>#GNT_NM#</span>"
// 						 + "</li>";
				if(classNm == "box_250"){
					//아래쪽 위젯
					tmp  = "<li><span class='name'>#NAME#</span>"
				         + "<span class='org_nm' style='width:70px;'>#ORG_NM#</span>"
						 + "<span class='gnt_nm' style='display:inline-block; width:70px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;'>#GNT_NM#</span>"
						 + "</li>";

				}else if(classNm == "box_400"){
					tmp  = "<li><span class='name' style='width:45px;'>#NAME#</span>"
				         + "<span class='org_nm' style='width:65px;'>#ORG_NM#</span>"
						 + "<span class='gnt_nm' style='display:inline-block; width:50px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;'>#GNT_NM#</span>"
						 + "</li>";
				}else{
					tmp  = "<li><span class='name' style='display:inline-block; width:40px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;'>#NAME#</span>"
				         + "<span class='org_nm' style='display:inline-block; width:70px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;'>#ORG_NM#</span>"
						 + "<span class='gnt_nm' style='display:inline-block; width:85px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;'>#GNT_NM#</span>"
						 + "</li>";
				}

				for(var i=0; i< list22.length; i++){
					var  temp_cont = tmp.replace(/#NAME#/g,list22[i].name)
					          .replace(/#ORG_NM#/g,list22[i].orgNm)
					          .replace(/#GNT_NM#/g,list22[i].gntNm)
					          ;
					str += temp_cont;
				}

				$("#lb22Lst").html(str);
				$("#lb22Lst").hide();

 				if ( mode == 0 ){
					$("#lb22Lst").show();
				} else if ( mode == 2 ){
					$("#lb22Lst").show("slide", {direction: "down" }, "slow");
				} else if ( mode == 1 ){
					$("#lb22Lst").show("slide", {direction: "up" }, "slow");
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
<input type="hidden" id="box22_page" name="box22_page" value="1" />
<input type="hidden" id="box22_tempCnt" name="box22_tempCnt" />
<input type="hidden" id="box22_listCnt" name="box22_listCnt" />
<div id="listBox22" lv="22" class="notice_box">
	<div class="anchor_of_widget">
	</div>
</div>


