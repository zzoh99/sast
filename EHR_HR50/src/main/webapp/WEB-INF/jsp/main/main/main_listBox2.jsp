<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widgetContent02;

function main_listBox2(title, info, classNm, seq ){

	$("#listBox2").attr("seq", seq );
	var lCnt = ajaxCall("${ctx}/getListBox2CntL.do", "", false);
	$("#box2_listCnt").val(lCnt.DATA[0].cnt);

	loadApp2(1 , 0, classNm);

}

function loadApp2(page , mode , classNm){

	var setUrl = "";

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if(classNm == "box_100"){
		setUrl = "${ctx}/getListBox2List.do?page="+page+"&countAnniv=4";
	}else{
		setUrl = "${ctx}/getListBox2List.do";
	}

	$.ajax({
		url 		: setUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list2 = rv.map;

			$("#listBox2").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent02 = '<h3 class="main_title_250">신청한 내역</h3>'
						      + '<a  class="btn_main_more" title="더보기" id="appWidgetAppl" >더보기</a>'
						      + '<a  class="lst_number" id="lb2Cnt" ></a>'
						      + '<ul id="lb2Lst" class="main_lst"></ul>';


			}else if(classNm == "box_400"){

				widgetContent02 = '<h3 class="main_title_400"><tit:txt mid="appHistory" mdef="신청한 내역" /></h3>'
				      		  + '<a  class="btn_main_more" title="더보기" id="appWidgetAppl" >더보기</a>'
				     		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_application"></span>'
				      		  + '</div>'
				      		  + '<a  class="lst_number" id="lb2Cnt" ></a>'
				      		  + '<ul id="lb2Lst" class="main_lst"></ul>';

			}else{

				widgetContent02 = '<h3 class="main_title_100 img_100_application"><tit:txt mid="appHistory" mdef="신청한 내역" />('
							  + '<a  class="lst_number" id="lb2Cnt" ></a>)</h3>'
				      		  + '<div class="box100_btn_prev"><a href="javascript:btnUp2()" class="btn_up">이전</a></div>'
					  		  +	'<div class="box100_btn_next"><a href="javascript:btnDw2()" class="btn_down">다음</a></div>'
				      		  + '<ul id="lb2Lst" class="main_lst"></ul>';

			}

			//$("#listBox2").empty(); //클리어
			$("#listBox2").addClass(classNm);
			$("#listBox2 > .anchor_of_widget").html(widgetContent02);

			$("#lb2Cnt").html(list2.cnt + "<span>건</span>");

			if(list2.list.length == 0 ) {
				//더보기 숨기기
				$("#appWidgetAppl").hide();

				if(page > 1){
					var tPage = page-1;
					$("#box2_page").val(tPage);
					loadApp2(tPage, 0, classNm);
				}

			}else{

				//$('#lb2Lst').empty(); //클리어
				var str="";

				var tmpG = "<li #URL#><a href='#'><span class='lst_date'>#APPLYMD#</span><span class='lst_type' title='#TITLE#'>#TITLE#</span>"
						 + "<span class='lst_bltG' style='width:55px'>#STATUSNM#</span></a></li>";

				var tmpW = "<li #URL#><a href='#'><span class='lst_date'>#APPLYMD#</span><span class='lst_type' title='#TITLE#'>#TITLE#</span>"
						 + "<span class='lst_bltW'>#STATUSNM#</span></a></li>";

				for(var i=0; i< list2.list.length; i++){

					tabInfo  = "applType='"+list2.list[i].applType+"' ";
					tabInfo += "applSeq='"+list2.list[i].applSeq+"' ";
					tabInfo += "applSabun='"+list2.list[i].applSabun+"' ";
					tabInfo += "applInSabun='"+list2.list[i].applInSabun+"' ";
					tabInfo += "applCd='"+list2.list[i].applCd+"' ";
					tabInfo += "applYmd='"+list2.list[i].applYmd+"' ";
					tabInfo += "conditionEnterCd='"+list2.list[i].enterCd+"' ";

					if(list2.list[i].applStatusCd == "99"){
						str += tmpW.replace(/#TITLE#/g,list2.list[i].applNm)
						           .replace(/#APPLYMD#/g,list2.list[i].applYmdA)
						           .replace(/#TDCLASS#/g,list2.list[i].tdclass)
						           .replace(/#STATUSNM#/g,list2.list[i].applStatusCdNm)
								   .replace(/#URL#/g,tabInfo)
						           .replace(/#NAME#/g,list2.list[i].applInSabunName)
								   .replace(/#ENTERCD#/g,list2.list[i].enterCd);
					}else{
						str += tmpG.replace(/#TITLE#/g,list2.list[i].applNm)
						           .replace(/#APPLYMD#/g,list2.list[i].applYmdA)
						           .replace(/#TDCLASS#/g,list2.list[i].tdclass)
						           .replace(/#STATUSNM#/g,list2.list[i].applStatusCdNm)
						           .replace(/#URL#/g,tabInfo)
						           .replace(/#NAME#/g,list2.list[i].applInSabunName)
						           .replace(/#ENTERCD#/g,list2.list[i].enterCd);
					}

				}

				$("#lb2Lst").html(str);
				$("#lb2Lst").hide();

				if ( mode == 0 ){
					$("#lb2Lst").show();
				} else if ( mode == 2 ){
					//$("#lb2Lst").show("slide", {direction: "down" }, "slow");
					$("#lb2Lst").show();
				} else if ( mode == 1 ){
					//$("#lb2Lst").show("slide", {direction: "up" }, "slow");
					$("#lb2Lst").show();
				}

				$("#lb2Lst li").click(function(event) {
					if( $(this).attr("applSeq") != undefined ) {
						mainOpenApp( $(this).attr("applType")
									,$(this).attr("applSeq")
									,$(this).attr("applSabun")
									,$(this).attr("applInSabun")
									,$(this).attr("applCd")
									,$(this).attr("applYmd")
									,$(this).attr("conditionEnterCd"))
									;
					}
				});

			}
			//더보기 링크 클릭 이벤트
			$("#appWidgetAppl").off();
			$("#appWidgetAppl").on( "click" , function(e) {
				var goPrgCd = "AppBoxLst.do?cmd=viewAppBoxLst";
				goSubPage("10","","","",goPrgCd);
			});

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}

function btnUp2(){
	var box2_page= parseInt($("#box2_page").val(),10);

	box2_page = box2_page - 1;

	if(box2_page >= 1){
		$("#box2_page").val( box2_page);
		loadApp2(box2_page, 1, "box_100");
	}


}

function btnDw2(){
	var cnt = $("#box2_listCnt").val();

	var box2_page= parseInt($("#box2_page").val(),10);
	box2_page = box2_page + 1;

	var tPage = "";
	if(cnt%4 != 0){
		tpage = (cnt/4) + 1;
	}else{
		tpage = cnt/4;
	}

	if( box2_page <= tpage ){
		$("#box2_page").val( box2_page);
		loadApp2(box2_page, 2, "box_100");
	}

}

function createFormObject(name, value) {
	var outObj = $('<input type="text"/>').attr({ id : "" , value : "" });
}

function mainOpenApp(appType, applSeq, applSabun, applInSabun, applCd, applYmd, conditionEnterCd ){
	if(!isPopup()) {return;}
    var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
    var initFunc = 'initResultLayer';
    var p = {
			searchApplCd: '22'
		  , searchApplSeq: applSeq
		  , adminYn: 'N'
		  , authPg: 'R'
		  , searchSabun: applInSabun
		  , searchApplSabun: applSabun
		  , searchApplYmd: applYmd
		  , conditionEnterCd: conditionEnterCd
		};

    pGubun = "viewApprovalMgrResult";
    openLayer(url, p, 800, 815, initFunc);
}
</script>
<input type="hidden" id="box2_page" name="box2_page" value="1" />
<input type="hidden" id="box2_listCnt" name="box2_listCnt" />
<div id="listBox2" lv="2" info="신청한 내역 내역보기" class="notice_box">
	<div class="anchor_of_widget"></div>
</div>
