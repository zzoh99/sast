<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>

<!-- Bootstrap -->
<%--<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">--%>
<!-- Font Awesome -->
<link href="/common/css/cmpEmp/font-awesome.min.css" rel="stylesheet">
<!-- NProgress -->
<link href="/common/css/cmpEmp/nprogress.css" rel="stylesheet">
<!-- Custom Theme Style -->
<link href="/common/css/cmpEmp/custom.min.css" rel="stylesheet">
<link href="/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">

<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<title><tit:txt mid='114131' mdef='프로필 팝업'/></title>
<style type="text/css">

	.col-md-6 { max-width: 50%; width: 100%;}
	.top_tiles {display:flex; width:100%; }
	.top_tiles:first-child {padding-top: 12px;}

</style>
<script type="text/javascript">
var rs = null;
$(function(){
	const modal = window.top.document.LayerModalUtility.getModal('srchResultLayer');
	let frm = modal.parameters.frm || '';

	var result = ajaxCall("${ctx}/SpecificEmpSrch.do?cmd=getSpecificEmpList",frm,false);
	if(result["DATA"].length == 0 || result["DATA"] == null) {
		alert("<msg:txt mid='109379' mdef='해당 검색조건에 해당하는 사원은 존재하지 않습니다.'/>") ;
		modal.hide();
	}

	rs = result["DATA"] ;


	$(document).ready(function() {
		$('#photo').each(function() {
			if (!this.complete ) {// image was broken, replace with your new image
			this.src = "/common/images/common/img_photo.gif";
			}
		});
	});

	setEmpData() ;
});

function setValue() {
	const modal = window.top.document.LayerModalUtility.getModal('srchResultLayer');
	modal.hide();
}

//사진파일 적용 by
function setImgFile(sabun, i){
	$("#photo"+i).attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
}

function setEmpData() {
	var viewStr = "" ;
	/* mod 연산 을 통하여 번갈아가며 화면에 프로필을 뿌려준다 by JSG */
	$("#totalStr").html("<b>총원 : " + rs.length + "명</b>") ;
	
	viewStr = viewStr +"<div class=\'container body\'>";
	viewStr = viewStr +"<div class=\'main_container\'>";
	
	for(var i = 1; i <= rs.length; i++) {
		//alert("i : " + i + "\n(i % 2) : " + (i % 2)) ;
		if( (i % 2) == 1) {
			viewStr = viewStr + "<div class=\'right_col\' role=\'main\' style=\'margin-left:0px;\'>"   
			viewStr = viewStr + "<div class=\'top_tiles\'>"
		}
		
		viewStr = 	viewStr			+"<div class=\'animated flipInY col col-md-6\'>"
		viewStr = 	viewStr			+"<div class=\'tile-stats card-profile\'>"
		viewStr = 	viewStr			+"  <div class=\'profile_img \'>"
		viewStr = 	viewStr			+"    <img src=\'/common/images/common/img_photo.gif\'  id='photo"+i+"\' alt=\'Avatar\' title=\'Change the avatar\'>"
		viewStr = 	viewStr			+"  </div>"
		viewStr = 	viewStr			+"  <div class=\'profile_info\'>"
		viewStr = 	viewStr			+"    <p class=\'name\' id=\'tdName"+i+"\'>"
		viewStr = 	viewStr			+"      <span class=\'gender\'>(<i class=\'fa fa-male\'></i> 남성)</span>"
        viewStr = 	viewStr			+"    </p>"
        viewStr = 	viewStr			+"   <ul class=\'profile_desc\'>"
        viewStr = 	viewStr			+"      <li id=\'tdSabun"+i+"\'></li>"
        viewStr = 	viewStr			+"      <li id=\'tdOrgNm"+i+"\'></li>"
        viewStr = 	viewStr			+"      <li id=\'tdJikweeNm"+i+"\'></li>"
        viewStr = 	viewStr			+"      <li id=\'tdEmpYmd"+i+"\'></li>"
        viewStr = 	viewStr			+"      <li id=\'tdManageNm"+i+"\'></li>"
        viewStr = 	viewStr			+"      <li id=\'tdBirYmd"+i+"\'></li>"
        viewStr = 	viewStr			+"      <li id=\'tdJikchakNm"+i+"\'></li>"
        viewStr = 	viewStr			+"      <li id=\'tdInNum"+i+"\'></li>"
        viewStr = 	viewStr			+"    </ul>"
        viewStr = 	viewStr			+"  </div>"
        viewStr = 	viewStr			+"</div>"
        viewStr = 	viewStr			+"</div>"
		

		if( (i % 2) == 0) {
			viewStr = 	viewStr+"</div>";
			viewStr = 	viewStr+"</div>";
		}
	}
	
	viewStr = viewStr +"</div>";
	viewStr = viewStr +"</div>";
	
	/* 드로잉 */
	$("#draw").append(viewStr) ;
	/* 데이터 세팅 */
 	for(var i = 1; i <= rs.length; i++) {
		setImgFile(rs[i-1]["sabun"], i) ;
	 	$("#tdSabun"+i).html("사번 : "+rs[i-1]["sabun"]) ;
	 	$("#tdName"+i).html(rs[i-1]["name"]) ;
	 	$("#tdOrgNm"+i).html("소속 : "+rs[i-1]["orgNm"]) ;
	 	$("#tdJikweeNm"+i).html("직위 : "+rs[i-1]["jikweeNm"]) ;
	 	$("#tdJikgubNm"+i).html(rs[i-1]["jikgubNm"]) ;
	 	$("#tdJikjongNm"+i).html("직종 : "+rs[i-1]["jikjongNm"]) ;
	 	$("#tdJikchakNm"+i).html("직책 : "+rs[i-1]["jikchakNm"]) ;
	 	$("#tdInNum"+i).html("사내번호 : "+rs[i-1]["officeTel"]) ;
	 	$("#tdEmpYmd"+i).html("입사일 : "+rs[i-1]["empYmd"]) ;
	 	$("#tdWorkTypeNm"+i).html(rs[i-1]["workTypeNm"]) ;
	 	$("#tdManageNm"+i).html("사원구분 : "+rs[i-1]["manageNm"]) ;
	 	$("#tdBirYmd"+i).html("생년월일 : "+rs[i-1]["birYmd"]) ;
	 	//$("#tdLastSchNm"+i).html(rs[i-1]["lastSchNm"]) ;
	}

}
</script>
</head>
<body class="nav-md" style="overflow:scroll;">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<div>
			<ul>
				<li class="txt right"><span id="totalStr"></span></li>
			</ul>
		</div>

		<div id="draw"></div>
	</div>
	<!-- draw profile END -->
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('srchResultLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>
