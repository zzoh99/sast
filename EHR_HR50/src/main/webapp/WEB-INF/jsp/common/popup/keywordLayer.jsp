<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html style="overflow:scroll;">
<head>

<%--<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">--%>
<link href="/common/css/cmpEmp/font-awesome.min.css" rel="stylesheet">
<link href="/common/css/cmpEmp/nprogress.css" rel="stylesheet">
<link href="/common/css/cmpEmp/custom.min.css" rel="stylesheet">
<link href="/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">     

<style>
#keywordHeader { left:0; top:0; width:100%; min-width:900px; height:50px !important;
	background:url("../images/main/top_bg.png") left top repeat-x; font-size:12px; z-index:110; letter-spacing: 0px !important; }
#keywordHeader .header_wrap { position:relative; width:100%; text-align:center; }
#keywordHeader .header_wrap h1>a { display: block; position: absolute; top: 15px; left: 50%; cursor: pointer;}
#keywordHeader .header_wrap .member_search { float: left; position: relative; margin: 0px 0 12px 0px; width:100%; }
#keywordHeader .header_wrap .member_search input { box-sizing: border-box; border: 1px solid #e3e7ea; border-radius: 50px; width: 100%; padding: 8px 15px; color: #95999c; font-size: 12px; outline: none; }
#keywordHeader .header_wrap .member_search a { display: inline-block; position: absolute; right: 15px; top: 8px; }
#keywordHeader .pointer { cursor:pointer; }
</style>

<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>
<!-- 
include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
 -->
<script type="text/javascript">
	var srchBizCd = null;
	var rs = null;
	
	/*Sheet 기본 설정 */
	$(function() {
		
	    const modal = window.top.document.LayerModalUtility.getModal('keywordLayer');
	    var arg = modal.parameters;
        
        var sType = arg.sType || '';
        var topKeyword= arg.topKeyword || '';
        var searchEnterCd = arg.searchEnterCd || '';
        var isHideRet = "N";

		//top 에서 검색시 T를 넣어줌=> 전사원 검색이 가능
		//팝업에서 검색시 P를 기본적으로 가져감 => 권한에 따른 검색
		//INCLUDE 에서 검색시 I를 기본적으로 가져감  => 권한에 따른 검색
		$("#searchEmpType").val(sType);
		$("#searchKeyword").val(topKeyword);
		$("#searchEnterCd").val(searchEnterCd);
		if(isHideRet == "Y"){
			$("#searchStatusRadioDiv").hide();
		}
		

		$("#searchKeyword").focus();

		//검색어 있을경우 검색
		if($("#searchKeyword").val() != ""){
			doAction("Search");
		}

		//임직원공통인 경우 퇴직자검색조건 숨김
		if("${grpCd}" == "99") {
			$("#searchStatusRadioDiv").hide();
		}

        $("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).blur();
		 		doAction("Search");
		 		event.preventDefault();
			}
		});

        $(".close").click(function() {
	    	//p.self.close();
	    	closeLayerModal();
	    });
		sheetResize();
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
				if( ( $.trim( $("#searchKeyword").val( )) ) == "" ){
					alert("<msg:txt mid='123123123' mdef='키워드를 입력하세요.'/>");
					$("#searchKeyword").focus();
				}else{
					var result = ajaxCall("${ctx}/Popup.do?cmd=getKeywordEmpList", $("#mySheetForm").serialize(),false);
					//console.log(result);
					if(result["DATA"].length == 0 || result["DATA"] == null) {
					alert("<msg:txt mid='109379' mdef='해당 검색조건에 해당하는 사원은 존재하지 않습니다.'/>") ;
					//p.self.close();
					}
					
					rs = result["DATA"] ;
					setEmpData() ;
					
				    //sheet1.DoSearch( "${ctx}/Popup.do?cmd=getKeywordEmpList", $("#mySheetForm").serialize() );
				    //sheet1.DoSearch( "${ctx}/.do?cmd=employeeList", $("#mySheetForm").serialize(),1 );
				}
	            break;
		}
    }


	
	//사진파일 적용 by
	function setImgFile(sabun, i){
		$("#photo"+i).attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
	}

	function setEmpData() {
		var viewStr = "" ;
		$("#draw").html("")
		/* mod 연산 을 통하여 번갈아가며 화면에 프로필을 뿌려준다 by JSG */
		$("#totalStr").html("<b>총원 : " + rs.length + "명</b>") ;
		
		viewStr = viewStr +"<div class=\'body\'>";
		viewStr = viewStr +"<div class=\'main_container\'>";
		
		for(var i = 1; i <= rs.length; i++) {
			//alert("i : " + i + "\n(i % 2) : " + (i % 2)) ;
			if( (i % 2) == 1) {
				viewStr = viewStr + "<div class=\'right_col\' role=\'main\' style=\'margin-left:0px;\'>"   
				viewStr = viewStr + "<div class=\'row top_tiles\'>"
			}
			
			viewStr = 	viewStr			+"<div class=\'animated flipInY col-md-6 col-sm-6 col-xs-12\'>"
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

    function closeLayerModal(){
        const modal = window.top.document.LayerModalUtility.getModal('keywordLayer');
        modal.hide();
    }
</script>

</head>
<body class="nav-md" style="overflow:scroll;">
	<div class="wrapper modal_layer">
	    <div class="modal_body">
	        <form id="mySheetForm" name="mySheetForm">
	            <input type="hidden" id="searchEnterCd" name="searchEnterCd" value=""/>
	            <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/>
	            <input type="hidden" id="searchEmpType" name="searchEmpType" value="P"/> <!-- 팝업에서 사용 -->
	            <input type="hidden" id="searchUserId" name="searchUserId" />
	            <div id="keywordHeader">
		        	<div class="header_wrap">
			            <div class="member_search">
						    <input type="text" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하세요.">
						    <a class="pointer" href="javascript:doAction('Search');"><img id="searchUser" src="/common/images/main/btn_search.png" alt="검색하기" style='z-index:999;'></a>
				        </div>
		            </div>
	            </div>
	        </form>
		    <div id="draw">

            </div>
	    </div>
		<div class="modal_footer">
			<btn:a href="javascript:closeLayerModal();" css="gray large" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
