<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> 
<html class=""> 
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>인쇄미리보기</title>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<style type="text/css">
		#btnPrint__ td { padding:5px; }
		.popup_main { padding-right:5px;padding-left:5px; }
		.wrapper { height:auto; }
		#btnPrint__ label { position:relative; top:-3px; }
	</style>
	<style type="text/css" media="print">
		.noPrint {display:none;}
	</style>
	<script>
		var iv;
		var cnt = 1;
		$(function() {
			var prgCd = "<%=request.getParameter("prgCd")%>";
			$('#applTitle').html($('#approvalResultLayerTitle', opener.document).html());
			$('#author_info').html($('#approvalLayerAppLineTable', opener.document).html());
			$('#app_header').html($('#approvalMgrResultLayerUserInfo', opener.document).html());
			$('#etcCommentDiv').html($('#approvalLayerCommentArea', opener.document).html());
// 			$('#trComments').html($('#approvalLayerCommentContents', opener.document).html());
			$('#authorForm').html($('#authorFormAttr', opener.document).html());
			$('#memoTable').html($('#approvalMgrResultMemoTable', opener.document).html());
			$("#applBtnTop").hide();
			$("#commentWrite").hide();
			$('#etcCommentDiv').hide();
			$(".button7").css("visibility", "hidden");

			submitCall($("#authorForm"),"authorFrame", "post", prgCd); //업무화면
			iv = setInterval(iterval, 500); //화면로드가 될따까지 돌림

		    $("#chkCmt").change(function(){ //유의사항 숨기기
				if( $('#chkCmt').is(':checked')  ){
					$("#etcCommentDiv").show();
				}else{
					$("#etcCommentDiv").hide();
				}
		    });
		    $("#chkAppLine").change(function(){ //결재선 숨기기
				if( $('#chkAppLine').is(':checked')  ){
					$("#author_info").show();
				}else{
					$("#author_info").hide();
				}
		    });


		    $(".wrapper").bind("click", function(){ //화면클릭 시 버튼 숨김/표시
		    	if( $("#btnPrint").css("display") != "none" ){
		    		$("#btnPrint").hide();
		    	} else{
		    		$("#btnPrint").show();
		    	}

		    });
		});

		function iframeOnLoad(ih){
			$("#authorFrame").height(ih);
		}
		
		function iterval(){
			cnt++;
			var obj = $("#authorFrame").get(0).contentWindow;
			var objSheet1 = obj.sheet1;

			// 높이 자동조절
			if(!obj || !obj.setPrintHeight){
				var h = $("#authorFrame").contents().height();
				$("#authorFrame").height(h);
			}

			if( cnt > 10 || ( cnt > 3 && ( obj.sheet1 == "undefined" || obj.sheet1 == undefined) ) ) clearInterval(iv);

			if( obj.sheet1 != "undefined" && obj.sheet1 != undefined){
				if(obj.sheet1.RowCount() > 0){
					clearInterval(iv);
					try{
						if(obj.setPrintHeight)obj.setPrintHeight(); //각 업무페이지 개별 수정
						obj.sheet1.FitColWidth();
					}catch(e){
						log.error("setPrintHeight() 에러 ");
					}
				}

			}
		}

		//인쇄 버튼 클릭 시
		function goPrint(){
			//$("#btnPrint").hide();
			window.print();
		}
	</script>
</head>
<body style="width: 21cm;">
	<table id="btnPrint__" class="noPrint">
		<tr>
			<td><btn:a href="javascript:goPrint();" mid="print" mdef="인쇄" css="pink large"/></td>
			<td><btn:a href="javascript:window.self.close();" mid="close" mdef="닫기" css="gray large"/></td>
			<td><input type="checkbox" id="chkCmt" name="chkCmt" style="margin-bottom:-2px;"><label for="chkCmt"><span>&nbsp;<tit:txt mid="psnlWorkScheduleMgr2" mdef="유의사항" /></span></label></td>
			<td><input type="checkbox" id="chkAppLine" name="chkAppLine" checked style="margin-bottom:-2px;"><label for="chkAppLine"><span>&nbsp;<tit:txt mid="schAppLine" mdef="결재선 내역" /></span></label></td>
		</tr>
	</table>
	<form id="authorForm" name="form"></form>
	<div class="wrapper" style="overflow: visible" id="printArea">
		<div class="popup_title hide">
			<ul>
				<li style="width:100%;border-bottom:1px solid #b1b1b1;">
					<span id="applTitle"></span>
				</li>
			</ul>
		</div>
		<div class="popup_main">
			<div id="author_info"></div>
			<div class="clear"></div>
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='L1706090000001' mdef='신청자' /></li>
				</ul>
			</div>
			<div id="app_header" class="app_header"></div>
			<div class="h15 hide"></div>
			<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:1000px;overflow: visible;margin-left:2px;margin-right:2px;"></iframe>
			<table class="sheet_main" id="etcCommentDiv"></table>
			<table class="sheet_main" id="trComments"></table>
	     	<table id="memoTable" class="settle mat20"></table>
		 </div>
		 <div style="height:30px;">&nbsp;</div>
	</div>
</body>
</html>