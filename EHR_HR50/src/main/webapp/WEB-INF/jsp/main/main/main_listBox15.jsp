<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<style>
	#ulRenewCont th 
	{
		background-color: #ebeef0 !important;
		border: 1px solid #dae1e6;
		padding: 4px 10px;
		text-align: center;
	}
	
	#ulRenewCont td 
	{
		background-color: #f6f9fa !important;
		border: 1px solid #dae1e6;
	}
	
	#month1Td {
		color: #f0519c;
		font-weight: bold; 
	}	
</style>
<script type="text/javascript">
var widgetContent15;
var cntPage15 = 0
var page = 1;
var mode15 = "";

function main_listBox15(title, info, classNm, seq){

	$("#listBox15").attr("seq", seq);

	if(classNm == null || classNm == ""){
		classNm = "box_250";
	}

	var queryType15 = "";
	if(classNm == "box_100"){
		queryType15 = "${ctx}/getListBox15List.do?page="+$("#box15_page").val()+"&countAnniv=1";
	} else {
		queryType15 = "${ctx}/getListBox15List.do";
	}

	$.ajax({
		url 		: queryType15,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;

			var getBox15Cnt = ajaxCall("${ctx}/getListBox15ListCnt.do",$("#mainForm").serialize(),false).list;
			cntPage15 = Math.ceil(getBox15Cnt.length/ 1);

			var tmpCNt2 = 0;
			var totCnt2 = 0;

			for(var j=0; j<getBox15Cnt.length; j++){
				tmpCNt2 =  parseInt( getBox15Cnt[j].cnt6 , 10 )
				        + parseInt( getBox15Cnt[j].cnt3 , 10 )
				        + parseInt( getBox15Cnt[j].cnt1 , 10 );

				totCnt2 = totCnt2 + tmpCNt2;
			}


			$("#listBox15").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent15 = '<h3 class="main_title_250">갱신사항 안내</h3>'
						      + '<a  class="btn_main_more clickable" title="더보기" id="renewalLst" >더보기</a>'
						      + '<a class="lst_number" id="aRenewTotCnt" ></a>'
						      + '<table id="ulRenewCont" class="table center" style="height:120px;width:96%;margin-left:2%; border: 1px solid #dae1e6 !important;border-spacing:5px;"></ul>';


			}else if(classNm == "box_400"){

				widgetContent15 = '<h3 class="main_title_400">갱신사항 안내</h3>'
				      		  + '<a  class="btn_main_more clickable" title="더보기" id="renewalLst" >더보기</a>'
				     		  + '<div class="main_img_group">'
				      		  + '	<span class="img_400 img_400_renew"></span>'
				      		  + '</div>'
				      		  //+ '<a class="lst_number" id="aRenewTotCnt" ></a>'
				      		  + '<table id="ulRenewCont" class="table center" style="height:150px;width:96%;margin-left:2%; border: 1px solid #dae1e6 !important;border-spacing:5px;"></ul>';

			}else{

				var btn_str15 = "";
				if(cntPage15 > 1){
					btn_str15 = '<div class="box100_btn_prev"><a href="javascript:btnUp15()" class="btn_up">이전</a></div><div class="box100_btn_next"><a href="javascript:btnDw15()" class="btn_down">다음</a></div>';
				}

				widgetContent15 = '<h3 class="main_title_100 img_100_renew">갱신사항 안내'
							  + '<a  class="lst_number" id="aRenewTotCnt" ></a></h3>'+btn_str15+''
				      		  //+ '<div class="box100_btn_prev"><a  class="btn_up">이전</a></div>'
					  		  //+	'<div class="box100_btn_next"><a  class="btn_down">다음</a></div>'
				      		  //+ '<ul id="ulRenewCont" class="lst_renew"></ul>';
							  + '<table id="ulRenewCont" class="table center white" style="width:50%;position:absolute;left:250px;top:28px; border: 1px solid #dae1e6 !important;border-spacing:5px;"></ul>';

			}

			$("#listBox15 > .anchor_of_widget").html(widgetContent15);
			$("#listBox15").removeClass();
			$("#listBox15").addClass(classNm);



// 			var tmp = '<li><a><span class="lst_date">#TITLE#</span><span class="lst_count">#DATA1#명</span></a></li>';			
// 			var str = "";
			var tmp1 = '<tr><th>구분</th><th>6개월</th><th>3개월</th><th>1개월</th></tr>';

// 			var totCnt =  0;
// 			var tmpCNt = 0;

			for(var i=0; i<list.length; i++){
				/*
				tmpCNt =  parseInt( list[i].cnt6 , 10 )
				        + parseInt( list[i].cnt3 , 10 )
				        + parseInt( list[i].cnt1 , 10 );


				totCnt = totCnt + tmpCNt;

				str += tmp.replace(/#TITLE#/g,  list[i].codeNm)
				          .replace(/#DATA1#/g,  tmpCNt);
				*/
			
				tmp1 += '<tr>';
				tmp1 += '<th>' + list[i].codeNm + '</th>';
				tmp1 += '<td>' + list[i].cnt6 + '</td>';
				tmp1 += '<td>' + list[i].cnt3 + '</td>';
				tmp1 += '<td id="month1Td">' + list[i].cnt1 + '</td>';
				tmp1 += '</tr>';
			}

			
			$("#ulRenewCont").html(tmp1);
			$("#ulRenewCont").hide();	
			

			if(mode15 == ""){
				$("#ulRenewCont").show();
			} else if ( mode15 == "up"){
				$("#ulRenewCont").show("slide", {direction: "down" }, "slow");
			} else if ( mode15 == "dw"){
				$("#ulRenewCont").show("slide", {direction: "up" }, "slow");
			}

			/*
			if(classNm == "box_100"){
				$("#aRenewTotCnt").html( totCnt2 + "<span>명</span>");
			} else {
				$("#aRenewTotCnt").html( totCnt + "<span>명</span>");
			}
			*/



			//$("#ulRenewCont").jScrollPane();

			// 더보기 링크 클릭 이벤트
			$("#renewalLst").click(function() {

				var goPrgCd = "RenewalLst.do?cmd=viewRenewalLst";
				goSubPage("02","","","",goPrgCd);
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}

function mainOpenNotice(bbsCd,bbsSeq ){
	if(!isPopup()) {return;}

    var url 	= "/Board.do?cmd=viewBoardReadPopup&";
	var args 	= new Array();

	args["bbsCd"]  = bbsCd;
	args["bbsSeq"] = bbsSeq;
	args["bbsNm"]  = "묻고답하기";

	var rv = openPopup(url,args, "940","780");
	if(rv!=null){}
}

var detailY = function (code,remainEndMonth,cnt){
	var codeLowerCase = code.toLowerCase();
	if( remainEndMonth == "6" && ( cnt != "0" || cnt != "undifined" ) ){
		$("#"+codeLowerCase+"6").text(cnt);
	}else{
		$("#"+codeLowerCase+"6").text("0");
	}
	if ( remainEndMonth == "3" && ( cnt != "0" || cnt != "undifined" ) ){
		$("#"+codeLowerCase+"3").text(cnt);
	}else {
		$("#"+codeLowerCase+"3").text("0");
	}
		if( remainEndMonth == "1" && ( cnt != "0" || cnt != "undifined" ) ) {
			$("#"+codeLowerCase+"1").text(cnt);
	}else{
		$("#"+codeLowerCase+"1").text("0");
	}
};


function btnUp15(){

	var box15_page = parseInt($("#box15_page").val(),10);

	if(box15_page > 1){
		box15_page = box15_page - 1;
		page = box15_page;

		mode15 = "up";

		$("#box15_page").val(box15_page);
		main_listBox15("갱신사항안내", "갱신사항 보기", "box_100");
	}

}

function btnDw15(){

	var box15_page = parseInt($("#box15_page").val(),10);

	if(cntPage15 > box15_page){
		box15_page = box15_page + 1;
		$("#box15_page").val(box15_page);
		page = box15_page;

		mode15 = "dw";

		main_listBox15("갱신사항안내", "갱신사항 보기", "box_100");
	}


}

</script>
<input type="hidden" id="box15_page" name="box15_page" value="1" />
<!--
<div id="listBox15" lv="15" info="갱신사항 안내" class="notice_box">
	<div class="bg"></div>
	<div class="main">
		<ul class="header">
			<li class="title"></li>
			<li id="renewalLst"><btn:a  mid="more" mdef="더보기"> <img src="/common/images/main/ico_notice_link.gif" /></btn:a></li>
		</ul>

		<div class="widget_con_Wrap">
		<table class="widget_table">
		<colgroup>
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
		</colgroup>
		<tr>
			<th class="center" rowspan="2"><tbl:txt mid="gubun" mdef="구분"/></th>
			<!-- <th class="center ls-1" colspan="3">갱신예정 기한안내</th> -->
			<!--
		</tr>
		<tr>
			<th class="center ls-1">6 <tbl:txt mid="months" mdef="개월"/></th>
			<th class="center ls-1">3 <tbl:txt mid="months" mdef="개월"/></th>
			<th class="center ls-1">1 <tbl:txt mid="months" mdef="개월"/></th>
		</tr>
		</table>

		<div class="scroll on">
		<table id="up_list" class="widget_table">
		<colgroup>
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
		</colgroup>
		</table>
		</div>
		</div>
	</div>
</div>

-->
<div id="listBox15" lv="15" info="갱신사항 안내" class="notice_box">
	<div class="anchor_of_widget">
		<!-- <h3 class="main_title">갱신사항 안내</h3>
		<a id="aRenewTotCnt"  class="lst_number">
			5<span>명</span>
		</a>
		<ul id="ulRenewCont" class="lst_renew scroll-pane">
		</ul>
		<div class="btn_alignC">
			<a id="renewalLst"  class="btnW">더보기</a>
		</div> -->
	</div>
</div>
