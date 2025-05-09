<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> 
<html class="">
<script src="/common/js/pdf/jspdf.umd.min.js"></script>
<script src="/common/js/pdf/html2canvas.min.js"></script>

<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>인쇄미리보기</title>
	<style type="text/css">
		#btnPrint__ td { padding:5px; }
		.popup_main { padding-right:5px;padding-left:5px; }
		/**.wrapper { height:auto; }**/
		#btnPrint__ label { position:relative; }

		@media print {
			body * {
				visibility: hidden !important;
			}
			div#modal-approvalMgrResultPrintLayer>div.modal,
			div#modal-approvalMgrResultPrintLayer>div.modal * {
				visibility: visible !important;
			}
			.noPrint {
				display: none;
			}
			body {
				width: auto;
				height: auto;
				overflow: visible;
			}
			div#modal-approvalMgrResultPrintLayer>div.modal {
				padding: 0 10px;
				top: 0 !important;
				left: 0 !important;
				position: absolute !important;
				transform: none;
			}
			div#modal-approvalMgrResultPrintLayer>div.modal,
			div#modal-approvalMgrResultPrintLayer>div.modal>div.layer-content,
			div#modal-approvalMgrResultPrintLayer>div.modal>div.layer-content div.modal_layer,
			div#modal-approvalMgrResultPrintLayer>div.modal>div.layer-content div.modal_layer>div.modal_body {
				width: 100vw !important;
				max-width: 100vw !important;
				height: 100vh; !important;
				max-height: 100vh; !important;
				page-break-after: always !important;
				overflow: visible !important;
			}
		}
	</style>
	<script>
		var iv;
		var cnt = 1;
		var applTitle;
		$(function() {
			const modal = window.top.document.LayerModalUtility.getModal('approvalMgrResultPrintLayer');
			applTitle = modal.parameters.applTitle;
			let prgCd = modal.parameters.prgCd || '';

			$('#applTitle').html($('#approvalResultLayerTitle').html());
			$('#author_info').html($('#approvalLayerAppLineTable').html());
			$('#app_header').html($('#approvalMgrResultLayerUserInfo').html());
			$('#etcCommentDiv').html($('#approvalLayerCommentArea').html());
// 			$('#trComments').html($('#approvalLayerCommentContents', opener.document).html());
			$('#authorForm').html($('#authorFormAttr').html());
			$('#memoTable').html($('#approvalMgrResultMemoTable').html());
			$("#applBtnTop").hide();
			$("#commentWrite").hide();
			$('#etcCommentDiv').hide();
			$(".button7").css("visibility", "hidden");

			submitCall($("#authorForm"),"authorFrame", "post", prgCd); //업무화면
			iv = setInterval(iterval(this), 500); //화면로드가 될따까지 돌림

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

		/**
		 * 상세화면 iframe 내 높이 재조정.
		 * @param ih
		 * @modify 2024.04.23 Det.jsp 내에서 부모의 iframeOnLoad를 호출할 때 아직 화면이 그려지기 전에 iframe의 높이를 지정하는 경우가 있어 0.3초 후 다시 높이를 조정. by kwook
		 */
		function iframeOnLoad(ih){
			try {
				setTimeout(function() {
					var ih2 = parseInt((""+ih).split("px").join(""));
					var wrpH = 0;
					$("#authorFrame").contents().find(".wrapper").children().each((idx, ele) => wrpH += $(ele).outerHeight(true));
					if (wrpH > ih2)
						$("#authorFrame").height(wrpH);
					else
						$("#authorFrame").height(ih2);
				}, 300);
			} catch(e) {
				$("#authorFrame").height(ih);
			}
		}
		
		function iterval(pThis){
			if (!pThis) return;
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
		function goPrint() {
			window.onbeforeprint = (e) => {
				document.body.querySelector("div#modal-approvalMgrResultPrintLayer div.modal span.layer-modal-title").innerHTML = applTitle;
			};
			window.onafterprint = (e) => {
				document.body.querySelector("div#modal-approvalMgrResultPrintLayer div.modal span.layer-modal-title").innerHTML = "인쇄 미리보기";
			};
			window.print();
		}

		function savePdf() {
			const element = document.querySelector("#printArea"); // PDF로 변환하고자 하는 HTML 요소를 선택합니다. 예: document.getElementById('your-element-id')

			// PDF 출력을 위해 pdf Div 에 authorFrame 의 노드를 복사하고 authorFrame 은 숨김.
			let newNode = document.querySelector("div#modal-approvalMgrResultPrintLayer>div.modal>div.layer-modal-header").cloneNode(true);
			newNode.querySelector("span.layer-modal-title").innerHTML = applTitle;
			document.querySelector("div.modal div.modal_body>div#printArea").prepend(newNode);
			newNode = document.querySelector("#authorFrame").contentWindow.document.head.cloneNode(true);
			document.querySelector("div.modal div.modal_body div#pdfDiv").append(newNode);
			newNode = document.querySelector("#authorFrame").contentWindow.document.body.cloneNode(true);
			document.querySelector("div.modal div.modal_body div#pdfDiv").append(newNode);
			document.querySelector("#authorFrame").style.display = "none";
			document.querySelector("div.modal div.modal_body div#pdfDiv .sheet_title").style.backgroundColor = "white";

			html2canvas(element, {
				allowTaint: true,
				useCORS: true,
				// scale: 5,
			}).then((canvas) => {
				const imgData = canvas.toDataURL('image/png');
				const pdf = new jspdf.jsPDF({
					orientation: "p", // p: 가로(기본), l: 세로
					unit: "mm", // 단위 : "pt" (points), "mm", "in" or "px" 등)
					format: "a4", // 포맷 (페이지 크기).
				});

				const imgWidth = 210; // 이미지 가로 길이(mm) A4 기준
				const pageHeight = imgWidth * 1.414; // 출력 페이지 세로 길이 계산 A4 기준. 296.94
				const imgHeight = canvas.height * imgWidth / canvas.width; // 이미지 높이 길이(mm) A4 기준
				let heightLeft = imgHeight;
				let position = 0;

				// 첫 페이지 출력
				pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
				heightLeft -= pageHeight;

				// 한 페이지 이상일 경우 루프 돌면서 출력
				while (heightLeft >= 20) {
				 	position = heightLeft - imgHeight;
				 	pdf.addPage();
				 	pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
				 	heightLeft -= pageHeight;
				}

				pdf.save("download.pdf");

				// 변경된 내용 다시 원복
				document.querySelector("div.modal div.modal_body>div#printArea>div.layer-modal-header").remove();
				document.querySelector("div.modal div.modal_body div#pdfDiv").innerHTML = "";
				document.querySelector("#authorFrame").style.display = "block";
			});
		}
	</script>

<%--	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.3.1/jspdf.umd.min.js"></script>--%>
<%--	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.3.2/html2canvas.min.js"></script>--%>
</head>
<body class="bodywrap" style="width: 21cm;">
	<div class="wrapper modal_layer" style="overflow: visible">
		<div class="modal_body" style="padding: 0;">
			<div id="printArea" style="padding: 24px;">
				<table id="btnPrint__" class="noPrint sheet_title" data-html2canvas-ignore="true">
					<tr>
						<td><btn:a href="javascript:goPrint();" mid="print" mdef="인쇄" css="btn filled"/></td>
						<td><btn:a href="javascript:savePdf();" mid="print" mdef="PDF출력" css="btn filled"/></td>
						<td><input type="checkbox" class="checkbox" id="chkCmt" name="chkCmt"><label for="chkCmt"><span>&nbsp;<tit:txt mid="psnlWorkScheduleMgr2" mdef="유의사항" /></span></label></td>
						<td><input type="checkbox" class="checkbox" id="chkAppLine" name="chkAppLine" checked><label for="chkAppLine"><span>&nbsp;<tit:txt mid="schAppLine" mdef="결재선 내역" /></span></label></td>
					</tr>
				</table>
				<form id="authorForm" name="form"></form>
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
				<div id="pdfDiv"></div>
				<table class="sheet_main" id="etcCommentDiv" style="margin-top:32px"></table>
				<table class="sheet_main" id="trComments"></table>
				<table id="memoTable" class="settle mat20"></table>
			</div>
		</div>
		<div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('approvalMgrResultPrintLayer');" css="btn outline_gray" mid="close" mdef="닫기"/>
        </div>
<%--		 <div style="height:30px;">&nbsp;</div>--%>
	</div>
</body>
</html>