<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	//var vtitle = "";
	//var vinfo = "";
var widgetContent;

function main_listBox4(title, info, classNm, seq ){

	$("#listBox4").attr("seq", seq);

	var lCnt = ajaxCall("${ctx}/getListBox4Cnt.do", "", false);
	$("#box4_listCnt").val(lCnt.DATA[0].cnt);

	loadApp4(1 , 0, classNm);

}

function btnUp4(){
	var box4_page= parseInt($("#box4_page").val(),10);

	box4_page = box4_page - 1;

	if(box4_page >= 1){
		$("#box4_page").val( box4_page);
		loadApp4(box4_page, 1, "box_100");
	}


}

function btnDw4(){
	var cnt = $("#box4_listCnt").val();
	var box4_page= parseInt($("#box4_page").val(),10);
	box4_page = box4_page + 1;

	var tPage = "";
	if(cnt%6 != 0){
		tpage = (cnt/6) + 1;
	}else{
		tpage = cnt/6;
	}

	if( box4_page <= tpage ){
		$("#box4_page").val( box4_page);
		loadApp4(box4_page, 2, "box_100");
	}

}


function loadApp4(page , mode , classNm){
	var setUrl = "";

	if(classNm == null || classNm == ""){
		classNm = "box_250";
	}

	if(classNm == "box_100"){
		setUrl = "${ctx}/getListBox4List.do?page="+page+"&countAnniv=6";
	}else{
		setUrl = "${ctx}/getListBox4List.do";
	}

	$.ajax({
		url 		: setUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list4 = rv.DATA;

			$("#listBox4").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent = '<h3 class="main_title_250">자주 사용하는 메뉴</h3>'
						      + '<a  class="btn_main_sett clickable" title="설정하기" id="btnW_04">설정하기</a>'
						      + '<div class="main_img_group">'
						      + '	<span class="img_250 img_100_bookm"></span>'
						      + '</div>'
						      + '<ul id="ulUseMenu" class="bookm_txt"></ul>';


			}else if(classNm == "box_400"){

				widgetContent = '<h3 class="main_title_400">자주 사용하는 메뉴</h3>'
				      		  + '<a  class="btn_main_sett clickable" title="설정하기" id="btnW_04">설정하기</a>'
				      		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_bookm"></span>'
				      		  + '</div>'
				      		  + '<ul id="ulUseMenu" class="bookm_txt"></ul>';

			}else{

				widgetContent = '<h3 class="main_title_100 img_100_bookm">자주 사용하는 메뉴</h3>'
				      		  + '<div class="box100_btn_prev"><a href="javascript:btnUp4()" class="btn_up">이전</a></div>'
					  		  +	'<div class="box100_btn_next"><a href="javascript:btnDw4()" class="btn_down">다음</a></div>'
				      		  + '<ul id="ulUseMenu" class="bookm_txt"></ul>';

			}

			//$("#listBox4").empty(); //클리어
			$("#listBox4").addClass(classNm);
			$("#listBox4 > .anchor_of_widget").html(widgetContent);

			if(list4.length != 0){

				var tmp = "<div class=#DATA1# mainMenuCd=#DATA2# prgCd=#DATA3#><span>#DATA4#</span></div>";
				//$('.favorite_talbe').empty(); //클리어

				var str = "";
				$("#ulUseMenu").html("");
				for(var i=0; i<list4.length; i++){
					str = tmp.replace(/#DATA1#/g,list4[i].mainMenuCss)  //A.MAIN_MENU_CD
					          .replace(/#DATA2#/g,list4[i].mainMenuCd)
					          .replace(/#DATA3#/g,list4[i].prgCd)
					          .replace(/#DATA4#/g,list4[i].menuNm);

					$("#ulUseMenu").append("<li style='cursor:pointer;'>"+str+"</li>");

				}

				$("#ulUseMenu").hide();

				if ( mode == 0 ){
					$("#ulUseMenu").show();
				} else if ( mode == 2 ){
					$("#ulUseMenu").show("slide", {direction: "down" }, "slow");
				} else if ( mode == 1 ){
					$("#ulUseMenu").show("slide", {direction: "up" }, "slow");
				}

			}else{
				$("#ulUseMenu").html("<li>등록된 자료가 없습니다.</li>");
				$("#ulUseMenu").show();

			}

// 			$("#ulUseMenu").jScrollPane();

			// 자주 사용하는 메뉴 클릭시 서브로 이동
			$("#ulUseMenu li div").click(function() {
				goSubPage(
						$(this).attr("mainMenuCd"),
						"","","",
						$(this).attr("prgCd")
					);
			});

			$("#btnW_04").click(function() {

				pGubun = "viewQuickMenu";
				openPopup("/QuickMenu.do?cmd=viewQuickMenu", "", 770, 650, function(event){
					goMain();
				});
			});

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});


}
</script>
<input type="hidden" id="box4_page" name="box4_page" value="1" />
<input type="hidden" id="box4_listCnt" name="box4_listCnt" />
<!-- 자주 사용하는 메뉴 -->
<div id="listBox4" lv="4"  info="자주사용하시는 메뉴 등록" class="notice_box">
	<div class="anchor_of_widget">
		<!-- <h3 class="main_title">자주 사용하는 메뉴</h3>
		<div class="main_img_group">
			<span class="img_bookm_240"></span>
		</div>
		<ul id="ulUseMenu" class="bookm_txt">
		</ul>
		<div class="btn_alignC">
			<a  class="btnW" id="btnW_04">설정</a>
		</div> -->
	</div>
</div>
<!-- //자주 사용하는 메뉴 end -->