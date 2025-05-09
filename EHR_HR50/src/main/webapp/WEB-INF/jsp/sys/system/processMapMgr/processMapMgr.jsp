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
<script src="${ ctx }/common/js/jquery/3.6.2/jquery-3.6.2.min.js"></script>
<script src="${ ctx }/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.js"></script>
<%-- <script src="${ ctx }/assets/js/common.js"></script> --%>
<script src="${ ctx }/assets/js/util.js"></script>

<!-- 개별 화면 script -->  
<script src="${ ctx }/assets/js/process_map.js"></script>

</head>

  <body class="iframe_content">
    <!-- main_tab_content -->
    <div class="main_tab_content">

      <!-- process_map_container -->
      <div class="sub_menu_container process_map">

        <div class="header">
          <div class="title_wrap">
            <i class="mdi-ico filled">explore</i>
            <span>프로세스맵</span>
            <select id="authGrp_select" class="custom_select" style="color: #323232;">
            	<option name="전체" value="">전체</option>
                <c:forEach	var="item" items="${authGrpList}" varStatus="status">
                	<option name="${item.grpNm}" value="${item.grpCd}">${item.grpNm}</option>			
				</c:forEach>
            </select>
            <div class="btn_wrap expand">
              <span class="btn" onclick="makeVisibleToggleContent('OPEN')"><i class="mdi-ico">add</i></span>
              <span class="btn" onclick="makeVisibleToggleContent('CLOSE')"><i class="mdi-ico">remove</i></span>
            </div>
          </div>
          
          <div class="button_wrap">
            <button class="btn outline-gray icon_text" id="bookmark_btn" onclick="openBookmarkModal()">
              <i class="mdi-ico">star</i>즐겨찾기
            </button>
            <button class="btn filled icon_text" onclick="goEditPage()">
              <i class="mdi-ico">add</i>생성하기
            </button>
          </div>
        </div>

        <div class="process_map_wrap">
          
        </div>
        <button class="btn top" onclick="moveScrollTop()"><i class="mdi-ico round">arrow_upward</i></button>
      </div>
      <!-- // process_map_container -->

    </div>
    <!-- // main_tab_content -->
    
    </body>
</html>

