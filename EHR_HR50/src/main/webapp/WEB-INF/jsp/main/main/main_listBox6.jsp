<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var cntPage6 = 0;
var page6 = 1;
var mode6 = "";


function main_listBox6(title, info, classNm, seq ){

	$("#listBox6").attr("seq", seq);

	$("#lb6Title").html(title);
	var queryType = "";
	if(classNm == "box_100"){
		queryType = "${ctx}/getListBox6List2.do?page="+page6+"&countAnniv=4";
	} else {
		queryType = "${ctx}/getListBox6List.do";
	}

	$.ajax({
		url 		: queryType,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;

			var getBox6Cnt = ajaxCall("${ctx}/getListBox6ListCnt.do",$("#mainForm").serialize(),false).list;
			cntPage6 = Math.ceil(getBox6Cnt.length/ 4);

			var classTypeHtml06;
			$("#listBox6").removeClass();

			if ( classNm == undefined || classNm== null || classNm == "undefined" || classNm == "null" || classNm == "" ){

				classNm = "box_250";
			}

			if(classNm == "box_100"){

				classTypeHtml06 = '<h3 id="lb6Title" class="main_title_100 img_100_notice">공지사항</h3>'
					+ '<div class="box100_btn_prev"><a href="javascript:btnUp6()" class="btn_up">이전</a></div>'
					+ '<div class="box100_btn_next"><a href="javascript:btnDw6()" class="btn_down">다음</a></div>'
					+ '<ul class="notice_group" id="lb6NGroup">'
					+ '</ul>';

			} else if(classNm == "box_250"){

				classTypeHtml06 = '<h3 id="lb6Title" class="main_title_250">공지사항</h3>'
					+'<a id="noticeWidget" class="btn_main_more" title="더보기" style="cursor:pointer">더보기</a>'
					+'<div class="main_img_group">'
					+'<span class="img_250 img_100_notice"></span>'
					+'</div>'
					+'<ul class="notice_group" id="lb6NGroup">'
					+'</ul>';

			} else if(classNm == "box_400"){

				classTypeHtml06 = '<h3 id="lb6Title" class="main_title_400">공지사항</h3>'
					+ '<a id="noticeWidget" class="btn_main_more" title="더보기" style="cursor:pointer">더보기</a>'
					+ '<div class="main_img_group">'
					+ '<span class="img_400 img_400_notice"></span>'
					+ '</div>'
					+ '<ul class="notice_group" id="lb6NGroup">'
					+ '</ul>';
			}

			$("#listBox6").addClass(classNm);
			$("#listBox6 > .anchor_of_widget").html(classTypeHtml06);

			//<span class="lst_new"></span>
			var tmp = "<li #URL#><a href='#' alt='#BTITLE#' title='#BTITLE#'>#BTITLE#</a>";
			tmp += "</li>";
			var str = "";
			var newImg = "";
			var toDate06 = "${ssnBaseDate}";


			for(var i=0; i<list.length; i++){
				tabInfo  = "bbsSeq='"+list[i].bbsSeq+"' ";
				tabInfo += "bbsCd='"+list[i].bbsCd+"' ";
				tabInfo += "pop='"+list[i].pop+"' ";
				tabInfo += "cookie='"+getCookie("Notice_"+list[i].bbsSeq)+"' ";


				if(Number(toDate06) == Number(list[i].regDateNew)){
					newImg = "class='lst_new'";
				} else {
					newImg = "";
				}

				str += tmp.replace(/#URL#/g,tabInfo)
				          .replace(/#BTITLE#/g,list[i].title)
						  .replace(/#CLASS#/g,newImg);
  
				// 팝업공지 선택 && 오늘하루열지않음에 선택되지 않은 공지사항만 팝업공지가 뜸
				// 팝업 차단시 리스트 미표기로 주석
				//if(list[i].pop == "Y" && getCookie("Notice_"+list[i].bbsSeq) != "done") {
					//mainOpenNoticePop( list[i].bbsCd,list[i].bbsSeq,'noticePopup');  		
				//}
			}

			$("#lb6NGroup").html(str);
			$("#lb6NGroup > li").hide();

			if(mode6 == ""){
				$("#lb6NGroup > li").show();
			} else if ( mode6 == "up"){
				$("#lb6NGroup > li").show("slide", {direction: "down" }, "slow");
			} else if ( mode6 == "dw"){
				$("#lb6NGroup > li").show("slide", {direction: "up" }, "slow");
			}

		 	if(list.length == 0){
		 		if(classNm == "box_100"){
		 			$("#lb6NGroup").html("등록된 자료가 없습니다.");
		 		} else {
		 			$("#lb6NGroup").html("<li>등록된 자료가 없습니다.<li>");
		 		}

		 	}



			//$("#lb6NGroup").jScrollPane();
			$("#lb6NGroup li").click(function(event,param) {
				if( $(this).attr("bbsSeq") != undefined ) {
					if(param == "noticePopup"){
						mainOpenNoticePop( $(this).attr("bbsCd") ,$(this).attr("bbsSeq"), 'noticePopup');
					}else{
						mainOpenNoticePop( $(this).attr("bbsCd") ,$(this).attr("bbsSeq"), 'linkPopup');
					}
				}
			});

			// 더보기 링크 클릭 이벤트
			$("#noticeWidget").click(function() {
				var goPrgCd = "/Board.do?cmd=viewBoardMgr||bbsCd=10000";
				goSubPage("20","","","",goPrgCd);
			});
			
			//팝업공지 선택 && 오늘하루열지않음에 선택되지 않은 공지사항만 팝업공지 
			$("#lb6NGroup > li[pop=Y][cookie=null]").trigger("click",['noticePopup']);
			
			
			
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}

	});
}
function mainOpenNoticePop(bbsCd,bbsSeq ,type){

	//if(!isPopup()) {return;}

	var url="";
	if (type =="noticePopup"){ url = "/Board.do?cmd=viewBoardReadPopupEx&";}
	else if(type=="linkPopup"){ url = "/Board.do?cmd=viewBoardReadPopup&";}
	
    var $form = $('<form></form>');
    $form.appendTo('body');
    var param1 	= $('<input name="bbsCd" 	type="hidden" 	value="'+bbsCd+'">');
    var param2 	= $('<input name="bbsSeq" 	type="hidden" 	value="'+bbsSeq+'">');
    $form.append(param1).append(param2);
    url +=$form.serialize() ;

	openPopup(url, self, "940","800");  


    //var url 	= "/Board.do?cmd=viewBoardReadPopup&";
	//var args 	= new Array();
	//args["bbsCd"]  = bbsCd;
	//args["bbsSeq"] = bbsSeq;
	//args["bbsNm"]  = "공지사항";
	//openPopup(url,args, "940","780");
}


function btnUp6(){

	var box6_page = parseInt($("#box6_page").val(),10);

	if(box6_page > 1){
		box6_page = box6_page - 1;
		page6 = box6_page;

		$("#box6_page").val(box6_page);
		mode6 = "up";
		main_listBox6("공지사항", "HR 관련 공지사항", "box_100");
	}

}

function btnDw6(){

	var box6_page = parseInt($("#box6_page").val(),10);

	if(cntPage6 > box6_page){
		box6_page = box6_page + 1;
		$("#box6_page").val(box6_page);
		page6 = box6_page;

		mode6 = "dw";
		main_listBox6("공지사항", "HR 관련 공지사항", "box_100");
	}


}

</script>
<input type="hidden" id="box6_page" name="box6_page" value="1" />
<div id="listBox6" lv="6"  class="notice_box">
	<div class="anchor_of_widget">
	</div>
</div>








