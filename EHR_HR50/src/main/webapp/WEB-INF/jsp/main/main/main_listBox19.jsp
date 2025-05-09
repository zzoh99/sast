<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%//---------------------------------- 결재할 내역 --------------------------------%>

<script type="text/javascript">
var widgetContent19;
var listBox19_classNm;

function main_listBox19(title, info, classNm, seq ){

	listBox19_classNm = classNm;
	$("#listBox19").attr("seq", seq);

	var lCnt = ajaxCall("${ctx}/getListBox2CntR.do", "", false);
	$("#box19_listCnt").val(lCnt.DATA[0].cnt);

	loadApp19(1 , 0, classNm);
}
//팝업에서 결재 후 리턴
function mainBox19loadApp(){
	loadApp19(1 , 0, listBox19_classNm);
}
function loadApp19(page , mode , classNm){

	var setUrl = "";

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}

	if(classNm == "box_100"){
		setUrl = "${ctx}/getListBox19List.do?page="+page+"&countAnniv=4";
	}else{
		setUrl = "${ctx}/getListBox19List.do";
	}

	$.ajax({
		url 		: setUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list19 = rv.Map;

			$("#listBox19").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent19 = '<h3 class="main_title_250">결재할 내역</h3>'
						      + '<a  class="btn_main_more" title="더보기" id="appWidget2" >더보기</a>'
						      + '<a  class="lst_number" id="lb19Num" ></a>'
						      + '<ul id="lb19Lst" class="main_lst"></ul>';


			}else if(classNm == "box_400"){

				widgetContent19 = '<h3 class="main_title_400">결재할 내역</h3>'
				      		  + '<a  class="btn_main_more" title="더보기" id="appWidget2" >더보기</a>'
				     		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_approval"></span>'
				      		  + '</div>'
				      		  + '<a  class="lst_number" id="lb19Num" ></a>'
				      		  + '<ul id="lb19Lst" class="main_lst"></ul>';

			}else{

				widgetContent19 = '<h3 class="main_title_100 img_100_approval">결재할 내역('
							  + '<a  class="lst_number" id="lb19Num" ></a>)</h3>'
				      		  + '<div class="box100_btn_prev"><a href="javascript:btnUp19()" class="btn_up">이전</a></div>'
					  		  +	'<div class="box100_btn_next"><a href="javascript:btnDw19()" class="btn_down">다음</a></div>'
				      		  + '<ul id="lb19Lst" class="main_lst"></ul>';

			}

			//$("#listBox19").empty(); //클리어
			$("#listBox19").addClass(classNm);
			$("#listBox19 > .anchor_of_widget").html(widgetContent19);

			$("#lb19Num").html("<a href='#' id='directPage'>" + list19.cnt + "<span>건</span></a>");

			if(list19.list.length == 0 ) {
				$("#appWidget2").hide();

				if(page > 1){
					var tPage = page-1;
					$("#box19_page").val(tPage);
					loadApp19(tPage, 0, classNm);
				}

			}else{

				var tmp = "<li #URL#><a href='#'><span class='lst_date'>#APPLYMD#</span><span class='lst_type'>#TITLE#</span><span class='lst_name'>#NAME#</span></a></li>";
				//$('#lb19Lst').empty(); //클리어
				var str="";

				for(var i=0; i< list19.list.length; i++){
					tabInfo  = "applType='"+list19.list[i].applType+"' ";
					tabInfo += "applSeq='"+list19.list[i].applSeq+"' ";
					tabInfo += "applSabun='"+list19.list[i].applSabun+"' ";
					tabInfo += "applInSabun='"+list19.list[i].applInSabun+"' ";
					tabInfo += "applCd='"+list19.list[i].applCd+"' ";
					tabInfo += "applYmd='"+list19.list[i].applYmd+"' ";
					tabInfo += "conditionEnterCd='"+list19.list[i].enterCd+"' ";

					str += tmp.replace(/#TITLE#/g,list19.list[i].applNm)
							  .replace(/#APPLYMD#/g,list19.list[i].applYmdA)
							  .replace(/#URL#/g,tabInfo)
							  .replace(/#NAME#/g,list19.list[i].applSabunName);


					/*
							  .replace(/#TDCLASS#/g,list.listR[i].tdclass)
							  .replace(/#STATUSNM#/g,list.listR[i].applStatusCdNm)
							  .replace(/#ENTERCD#/g,list.listR[i].enterCd); */
				}
				$("#lb19Lst").html(str);
				$("#lb19Lst > li").hide();


				if ( mode == 0 ){
					$("#lb19Lst > li").show();
				} else if ( mode == 2 ){
					$("#lb19Lst > li").show("slide", {direction: "down" }, "slow");
				} else if ( mode == 1 ){
					$("#lb19Lst > li").show("slide", {direction: "up" }, "slow");
				}

				$("#lb19Lst li").click(function(event) {

					if( $(this).attr("applSeq") != undefined ) {
						mainOpenApp19( $(this).attr("applType")
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
			$("#appWidget2").click(function() {
				var goPrgCd = "AppBeforeLst.do?cmd=viewAppBeforeLst";
				goSubPage("10","","","",goPrgCd);
			});

			$("#directPage").click(function() {
				var goPrgCd = "AppBeforeLst.do?cmd=viewAppBeforeLst";
				goSubPage("10","","","",goPrgCd);
			});

		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}

function btnUp19(){
	var box19_page= parseInt($("#box19_page").val(),10);

	box19_page = box19_page - 1;

	if(box19_page >= 1){
		$("#box19_page").val( box19_page);
		loadApp19(box19_page, 1, "box_100");
	}

}

function btnDw19(){

	var cnt = $("#box19_listCnt").val();

	var box19_page= parseInt($("#box19_page").val(),10);
	box19_page = box19_page + 1;

	var tPage = "";
	if(cnt%4 != 0){
		tpage = (cnt/4) + 1;
	}else{
		tpage = cnt/4;
	}

	if( box19_page <= tpage ){
		$("#box19_page").val( box19_page);
		loadApp19(box19_page, 2, "box_100");
	}


}

function createFormObject(name, value) {
	var outObj = $('<input type="text"/>').attr({ id : "" , value : "" });
}

function mainOpenApp19(appType, applSeq, applSabun, applInSabun, applCd, applYmd, conditionEnterCd ){
	if(!isPopup()) {return;}
    var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
    var initFunc = 'initResultLayer';
    var p = {
			searchApplCd: applCd
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
<input type="hidden" id="box19_page" name="box19_page" value="1" />
<input type="hidden" id="box19_listCnt" name="box19_listCnt" />
<div id="listBox19" lv="19" info="결재할 내역보기" class="notice_box">
	 <div class="anchor_of_widget">
		<!-- <h3 id="lb19Title" class="main_title">결제할 내역</h3>
		<a id="lb19Num" class="lst_number pointer">
		</a>
		<ul id="lb19Lst" class="main_lst">
		</ul>
		<div id="lb19More" class="btn_alignC">
			<a id="appWidget2" class="btnW pointer">더보기</a>
		</div> -->
	</div>
</div>
