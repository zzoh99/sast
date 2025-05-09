﻿<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 PDF 업로드</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script language="JavaScript">
<!--
	var p = eval("<%=popUpStatus%>");
	
	$(function(){
		
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			$("#paramYear").val(arg["searchWorkYy"]);
			$("#paramAdjustType").val(arg["searchAdjustType"]) ;
			$("#paramSabun").val(arg["searchSabun"]) ;
			
			$("#spanYear").html(arg["searchWorkYy"]) ;		
		}else{
			var searchWorkYy     = "";
			var searchAdjustType = "";
			var searchSabun      = "";
			
			searchWorkYy      = p.popDialogArgument("searchWorkYy");
			searchAdjustType  = p.popDialogArgument("searchAdjustType");
			searchSabun       = p.popDialogArgument("searchSabun");
			
			$("#paramYear").val(searchWorkYy);
			$("#paramAdjustType").val(searchAdjustType) ;
			$("#paramSabun").val(searchSabun) ;
			$("#spanYear").html(searchWorkYy) ;
		}
	});
	
	function goAction(){
		
		if($("#upload").val() == "") {
			alert("소득공제 업로드 파일을 선택해주세요.");
			return;
		}
		if( $("#upload").val() != "" ){
			var ext = $('#upload').val().split('.').pop().toLowerCase();
			if($.inArray(ext, ['pdf']) == -1) {
				alert('pdf 파일만 업로드 할수 있습니다.');
				return;
			}
		}
		
		$("#progressCover").show();

		$("#uploadForm").attr({"method":"POST","target":"ifrmPdfUpload","action":"pdfUploadRst.jsp"}).submit();
	}
	
	function procYn(err,message){
		$("#progressCover").hide();
		
		if(err=="Y"){
			alert(message);
			//p.window.returnValue = "Y";
			if(p.popReturnValue) p.popReturnValue("Y");
			p.window.close();
		} else {
			alert(message);
		}
	}
//-->
</script>
</head>
<body class="bodywrap">
	<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>PDF 업로드</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
		<form id="uploadForm" method="post"  enctype="multipart/form-data">
		<input type="hidden" id="paramYear" name="paramYear" value="2012"/>
		<input type="hidden" id="paramSabun" name="paramSabun" value="<%=removeXSS(session.getAttribute("ssnSabun"), '1')%>"/>
		<input type="hidden" id="paramAdjustType" name="paramAdjustType" value="1"/>
		<div class="outer">
			<table>
				<tr>
					<td style="padding:5px;"><b><span id="spanYear"></span> 연말정산</b></td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;<font color="red">* 국세청 연말정산간소화서비스 사이트에서 아래의 이미지에 해당하는 PDF를 다운로드 하셔서 등록하시기 바랍니다.</font></td>
				</tr>
				<tr>
					<td style="padding:5px;"><img src="../../../common_jungsan/images/common/pdf_popup_2017.jpg" border="0" style="vertical-align:middle;width:100%;height:100%"></td>
				</tr>
				<tr>
					<td style="padding:20px 5px 5px 5px;">
						<table style="width:100%;">
							<tr>
								<td>&nbsp;&nbsp;<font color="red">* PDF 자료를 국세청에서 다운받을 때 비밀번호를 설정하였을 경우, 해당 비밀번호를 입력하셔야 합니다.</font></td>
								<td align="right">비밀번호:<input type="text" id="paramPwd" name="paramPwd" value="" class="required"/></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td style="padding:5px;">&nbsp;&nbsp;* 찾아보기 버튼을 클릭하여 PDF파일을 선택하신 후, 업로드 버튼을 클릭하여 주시기 바랍니다.
					<br/>&nbsp;&nbsp;&nbsp;&nbsp; PDF파일은 각 인적공제 인원별로 최종 자료만 업로드 됩니다.(각 인원단위 삭제 후 덮어쓰기 개념)<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[본인+배우자 업로드 후 본인의 PDF자료만 재 업로드 시 본인의 데이터만 삭제후 업로드 됩니다.]<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[본인의 모든 자료(보험료/신용카드 등) 업로드 후 보험료 PDF만 다시 받아 재 업로드 시 본인 자료 삭제 후 보험료 데이터만 업로드 됩니다.]
					</td>
				</tr>
				<tr>
					<td style="padding:0px 5px 0px 5px;">
						<table style="width:100%;">
							<tr>
								<td><input type="file" id="upload" name="upload" class="text" style="width:100%;"></td>
								<td width="5px"></td>
								<td width="60px"><a href="javascript:goAction();" class="basic" title="전자문서 제출">업로드</a></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
			<!--
			<div class="sheet_title">
			<ul>
				<li class="txt"><span id="spanYear"></span> 연말정산</li>
			</ul>
			<ul>
				<li class="txt"><font color="red">PDF 자료를 국세청에서 다운받을 때 비밀번호를 설정하였을 경우, 해당 비밀번호를 입력하셔야 합니다.</font></li>
			</ul>
			<ul align="right">
				<li class="txt">비밀번호:<input type="text" id="paramPwd" name="paramPwd" value=""/></li>
			</ul>
			<ul>
				<li class="txt"><font color="red">찾아보기 버튼을 클릭하여 PDF파일을 선택하신 후, 업로드 버튼을 클릭하여 주시기 바랍니다.</font></li>
			</ul>
			<ul>
				<li class="txt">
					<input type="file" id="upload" name="upload" class="text" style="width:300px;">
					<a href="javascript:goAction();" class="basic" title="전자문서 제출">업로드</a>
				</li>
			</ul>
			</div>
			-->
		</div>
		</form>
		<iframe id="ifrmPdfUpload" name="ifrmPdfUpload" width="0" height="0" src="" border="0" frameborder="0" marginwidth="0" marginheight="0"></iframe>
        <div class="popup_button outer">
            <ul>
                <li>
                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
                </li>
            </ul>
        </div>
    </div>
</body>
</html>