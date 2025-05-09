<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114131' mdef='프로필 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%> 
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.popDialogArgumentAll();
	var searchSabun = "";

    if( arg != undefined ) {
    	//openSheet = arg["sheet2"];
    	searchSabun = arg["sabun"];
    }
	setEmpData(searchSabun) ;
	//setImgFile(searchSabun) ;
	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});

	p.resizeTo("610","460");
});

function setValue() {
	var rv = new Array(1);
	//rv["orderSeq"]		= $("#orderSeq").val();
	if(p.popReturnValue) p.popReturnValue(rv);
	//p.window.returnValue = rv;
	p.window.close();
}

//사진파일 적용 by
function setImgFile(sabun){
	$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
}

function setEmpData(sabun) {
	var result = ajaxCall("${ctx}/EmpProfilePopup.do?cmd=getEmpProfile&searchSabun="+sabun,queryId="getEmpProfile",false);
	$("#tdSabun").html(result["DATA"]["sabun"]) ;
	$("#tdName").html(result["DATA"]["name"]) ;
	$("#tdOrgNm").html(result["DATA"]["orgNm"]) ;
	$("#tdJikgubNm").html(result["DATA"]["jikgubNm"]) ;
	$("#tdJikchakNm").html(result["DATA"]["jikchakNm"]) ;
	$("#tdInNum").html(result["DATA"]["officeTel"]) ;
	$("#tdPhone").html(result["DATA"]["handPhone"]) ;
	$("#tdFaxNum").html(result["DATA"]["faxNo"]) ;
	$("#tdEmail").html(result["DATA"]["mailId"]) ;

	$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title outer">
		<ul>
			<li>Profile</li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main inner">
		<input type="hidden" id="locationCd" name="locationCd">
	<table>
		<colgroup>
			<col width="200px" />
			<col width="10px" />
			<col width="700px" />
		</colgroup>
		<tr>
		<td class="center">
			<img src="/common/images/common/img_photo.gif" id="photo" width="100" height="121" onerror="javascript:this.src='/common/images/common/img_photo.gif'">
		</td>
		<td>
		</td>
		<td>
		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="50%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='103880' mdef='성명'/></th>
				<td id="tdName">
				</td>
				<th><tit:txt mid='103975' mdef='사번'/></th>
				<td id="tdSabun">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td id="tdOrgNm" colspan="3">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104471' mdef='직급'/></th>
				<td id="tdJikgubNm">
				</td>
				<th><tit:txt mid='103785' mdef='직책'/></th>
				<td id="tdJikchakNm">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='114132' mdef='사내전화'/></th>
				<td id="tdInNum">
				</td>
				<th><tit:txt mid='103945' mdef='휴대폰'/></th>
				<td id="tdPhone">
				</td>
			</tr>
			<tr>
				<th>E-Mail</th>
				<td id="tdEmail" colspan="3">
				</td>
			</tr>
		</table>

		</td>
		</tr>

		</table>


		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large authR"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
