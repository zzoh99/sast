<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- 레거시 css -->
<link href="${ ctx }/common/css/nanum.css" rel="stylesheet" />
<link href="${ ctx }/common/css/common.css" rel="stylesheet" />
<link href="${ ctx }/common/css/util.css" rel="stylesheet" />
<link href="${ ctx }/common/css/override.css" rel="stylesheet" />

<!-- HR UX 개선 신규 css -->
<link href="${ ctx }/assets/css/_reset.css" rel="stylesheet" />
<link href="${ ctx }/assets/fonts/font.css" rel="stylesheet" />
<link href="${ ctx }/assets/css/common.css" rel="stylesheet" />

<!-- 개별 화면 css  -->
<link href="${ ctx }/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.css" rel="stylesheet" />
<%-- <link href="${ ctx }/assets/css/process_map.css" rel="stylesheet" > --%>

<!-- script -->
<script src="${ ctx }/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.js"></script>
<%-- <script src="${ ctx }/assets/js/common.js"></script> --%>
<script src="${ ctx }/assets/js/util.js"></script>

<!-- 개별 화면 script -->  
<script src="${ ctx }/assets/js/process_map_editor.js"></script>
<!-- favicon -->
<link rel="shortcut icon" type="image/x-icon" href="${ ctx }/common/images/icon/favicon_.ico" />

<script type="text/javascript">
let procMap={};

$(function() {
	procMap.procMapSeq = "${procMapSeq}";	
	procMap.grpCd = "${viewerGrpCd}";
	procMap.grpNm = "${grpNm}";
	procMap.mainMenuCd = "${mainMenuCd}";
	procMap.mainMenuNm = "${mainMenuNm}";
	procMap.procMapNm = "${procMapNm}";
	fetchProcList();
	
});

//페이지 이동
function goEditPageFromViwer() {
	let encodedPocNapNm=encodeURIComponent(procMap.procMapNm)//.replaceAll(/\//g, "%2F");
// 	let encodedURI=encodeURI("ProcessMapMgr.do?cmd=viewEditProcessMap&procMapSeq="+procMap.procMapSeq+"&grpCd="+procMap.grpCd+"&mainMenuCd="+procMap.mainMenuCd+"&procMapNm="+procMap.procMapNm).replaceAll(/\//g, "%2F");
	let encodedURI=
		"ProcessMapMgr.do?cmd=viewEditProcessMap&procMapSeq="
		+procMap.procMapSeq+"&grpCd="+procMap.grpCd+"&mainMenuCd="+procMap.mainMenuCd+"&procMapNm="+encodedPocNapNm;
			

	window.top.loadingUtil.on();
	window.location.href = encodedURI;
}

</script>

</head>

  <body class="iframe_content">

    <!-- main_tab_content -->
    <div class="main_tab_content process_map_edit">

      <div class="process_map_edit_header">
        <div class="left_area">
          <span class="title">프로세스맵 상세보기</span>
          <div class="select">
            <span>프로세스맵 명</span>
            <!-- 개발 시 참고: 뷰어에서는 input에 disabled 클래스 추가-->
            <input type="text" class="text_input round disabled" value="${procMapNm}" disabled>
          </div>
		  <div class="select">
            <span>권한선택</span>
            <!-- 개발 시 참고: 뷰어에서는 custom_select에 disabled 클래스 추가-->
            <div class="custom_select round disabled">
              <button class="select_toggle" >
                <span>${grpNm}</span>
              </button>
            </div>
          </div>
          <div class="select">
            <span>분류</span>
            <div class="custom_select round disabled">
              <button class="select_toggle" >
                <span>${mainMenuNm}</span>
              </button>
            </div>
          </div>
        </div>
        <div class="right_area">
          <a class="guide_btn" style="display:none">
            <i class="mdi-ico">help</i><span>프로세스맵 설정 가이드</span>
          </a>
          <button class="btn outline-gray" onclick="goStartPage()">목록보기</button>
          <button class="btn outline-gray" onclick="deleteProcMap()">삭제</button>
          <button class="btn outline-gray" onclick="goEditPageFromViwer()">수정</button>
        </div>
      </div>

      <!-- process_map_edit_container -->
      <div class="process_map_edit_container">

        <!-- edit_wrap -->
        <div class="edit_wrap">
          <div class="no_content" style="display:none">
           	<img src="" alt="">
           	<p>프로세스를 생성해주세요.</p>
          </div>
          <!-- #Sortable -->
          <!-- 개발 시 참고: 뷰어 페이지에서는 sortable 기능 막기 viewer 클래스 -->
          <div id="sortable" class="viewer" >
            
          </div>
          <!-- // #Sortable -->
        </div>
        <!-- //edit_wrap -->

      </div>
      <!-- // process_map_edit_container -->

    </div>
    <!-- // main_tab_content -->

  </body>
    

</html>

