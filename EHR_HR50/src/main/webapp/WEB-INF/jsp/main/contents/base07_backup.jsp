<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>급여마스터</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script defer src="../assets/plugins/apexcharts-3.42.0/apexcharts.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		const {  salaryTop, salaryBottom, salaryIncrease,salaryOutlier } = ajaxCall('/base07Data.do', '', false).data;
		console.log('salaryTop',salaryTop);
		console.log('salaryBottom',salaryBottom);
		console.log('salaryIncrease',salaryIncrease);
		setSalaryTop(salaryTop);
		setSalaryBottom(salaryBottom);
		setSalaryIncrease(salaryIncrease);
		setSalaryOutlier(salaryOutlier);
	});

	function setSalaryTop(salaryTop){

		for ( var i =0; i < salaryTop.data.length ; i++  ){

			if ( salaryTop.data[i].rank === 1 ){
				$('#firstTopName').text(salaryTop.data[i].name);
				$('#firstTopOrgNm').text(salaryTop.data[i].orgNm);
				$('#firstTopNameMini').text(salaryTop.data[i].name);
				$('#firstTopOrgNmMini').text(salaryTop.data[i].orgNm);
			}else if ( salaryTop.data[i].rank === 2 ){
				$('#secondTopName').text(salaryTop.data[i].name);
				$('#secondTopOrgNm').text(salaryTop.data[i].orgNm);
				$('#secondTopNameMini').text(salaryTop.data[i].name);
				$('#secondTopOrgNmMini').text(salaryTop.data[i].orgNm);
			}else if ( salaryTop.data[i].rank === 3 ){
				$('#thirdTopName').text(salaryTop.data[i].name);
				$('#thirdTopOrgNm').text(salaryTop.data[i].orgNm);
				$('#thirdTopNameMini').text(salaryTop.data[i].name);
				$('#thirdTopOrgNmMini').text(salaryTop.data[i].orgNm);
			}
		}
	}

	function setSalaryData(rank, data) {
	    var roundedValue = Math.round(data.uprate);
	    var str = roundedValue + '%';
	    
	    $('#salaryIncreaseTop' + rank).text(data.name);
	    $('#salaryIncreaseTopOrgNm' + rank).text(data.orgNm);
	    $('#salaryIncreaseTopjikweeNm' + rank).text(data.jikweeNm);
	    $('#salaryIncreaseTopuprate' + rank).text(str);
	    
	    $('#salaryIncreaseTopWide' + rank).text(data.name);
	    $('#salaryIncreaseTopOrgNmWide' + rank).text(data.orgNm);
	    $('#salaryIncreaseTopjikweeNmWide' + rank).text(data.jikweeNm);
	    $('#salaryIncreaseTopuprateWide' + rank).text(str);
	}

	function setSalaryBottom(salaryBottom){
			
		for ( var k =0; k < salaryBottom.data.length ; k++  ){

			if ( salaryBottom.data[k].rank === 1 ){
				$('#firstBottomName').text(salaryBottom.data[k].name);
				$('#firstBottomOrgNm').text(salaryBottom.data[k].orgNm);
			}else if ( salaryBottom.data[k].rank === 2 ){
				$('#secondBottomName').text(salaryBottom.data[k].name);
				$('#secondBottomOrgNm').text(salaryBottom.data[k].orgNm);
			}else if ( salaryBottom.data[k].rank === 3 ){
				$('#thirdBottomName').text(salaryBottom.data[k].name);
				$('#thirdBottomOrgNm').text(salaryBottom.data[k].orgNm);
			}
		}
	}

	function setSalaryIncrease(salaryIncrease) {
	    for (var l = 0; l < salaryIncrease.data.length; l++) {
	        if (salaryIncrease.data[l].rank <= 10) {
	            setSalaryData(salaryIncrease.data[l].rank, salaryIncrease.data[l]);
	        }
	    }
	}

	function setSalaryOutlier(salaryOutlier){
		}
	
</script>

</head>
<body class="iframe_content">
    <!-- main_tab_content -->
    <div class="main_tab_content">
      <!-- sub_menu_container -->
      <div class="sub_menu_container eis_container">
        <div class="header">
          <div class="title_wrap">
            <i class="mdi-ico filled">business_center_black</i>
            <span>급여마스터</span>
          </div>
        </div>
        <div class="widget_container">
          <div class="widget_wrap row_1 col_1"></div>
          <div class="widget_wrap row_1 col_1">
            <!-- 직급대비 급여 상/하위 -->
            <div class="widget">
              <div class="widget_header">
                <div class="widget_title">직급대비 급여 상/하위</div>
              </div>
              <!-- 토글이 있을 땐 'toggle-wrap'으로 감싸준다. -->
              <div class="widget_body widget-common best-top">
                <div class="select-outer">
                  <div class="custom_select no_style">
                    <button class="select_toggle">
                      <span>과장</span><i class="mdi-ico">arrow_drop_down</i>
                    </button>
                    <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->
                    <div class="select_options numbers" style="visibility: hidden;">
                      <div class="option">부장</div>
                      <div class="option">차장</div>
                      <div class="option">과장</div>
                      <div class="option">대리</div>
                      <div class="option">사원</div>
                    </div>
                  </div>
                  <div class="toggle-wrap">
                  </div>
                </div>
                <div class="bookmarks_title">
                  <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
                  <span>상위 Top 3</span>
                  <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
                </div>
                <div class="avatar-list">
                  <div><span class="avatar-wrap"><span class="tag_icon blue round">1</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="firstTopNameMini"></span><span class="team ellipsis" id="firstTopOrgNmMini"></span></div>
                  <div><span class="avatar-wrap"><span class="tag_icon blue round">2</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="secondTopNameMini"></span><span class="team ellipsis" id="secondTopOrgNmMini"></span></div>
                  <div><span class="avatar-wrap"><span class="tag_icon blue round">3</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="thirdTopNameMini"></span><span class="team ellipsis" id="thirdTopOrgNmMini"></span></div>
                </div>
                <!-- hover 시 말풍선 -->
                <div class="speech-bubble">
                  <span class="name">박주호<span class="team divider">Dev 개발/연구팀</span><span class="time divider">124시간 25분</span></span>
                </div>
              </div>
            </div>
            <!--// 직급대비 급여 상/하위 -->
          </div>
          <div class="widget_wrap row_1 col_2">
            <!-- 직급대비 급여 상/하위 wide -->
            <div class="widget wide">
              <!-- 토글이 있을 땐 'toggle-wrap'으로 감싸준다. -->
              <div class="widget_header toggle-wrap">
                <div class="widget_title">직급대비 급여 상/하위</div>
              </div>
              <div class="widget_body attendance_contents annual-status overtime-work widget-common best-top">
                <div class="custom_select no_style">
                  <button class="select_toggle">
                    <span>과장</span><i class="mdi-ico">arrow_drop_down</i>
                  </button>
                  <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->
                  <div class="select_options numbers" style="visibility: hidden;">
                    <div class="option">부장</div>
                    <div class="option">차장</div>
                    <div class="option">과장</div>
                    <div class="option">대리</div>
                    <div class="option">사원</div>
                  </div>
                </div>
                <div class="container_box">
                  <div class="container_info avatar-type">
                    <div class="list-title">상위 Top 3<span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span></div>
                    <div class="avatar-list">
                      <div><span class="avatar-wrap"><span class="tag_icon green round">1</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="firstTopName"></span><span class="team ellipsis" id="firstTopOrgNm"></span></div>
                  <div><span class="avatar-wrap"><span class="tag_icon green round">2</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="secondTopName"></span><span class="team ellipsis" id="secondTopOrgNm"></span></div>
                  <div><span class="avatar-wrap"><span class="tag_icon green round">3</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="thirdTopName"></span><span class="team ellipsis" id="thirdTopOrgNm"></span></div>
                    </div>
                    <!-- hover 시 말풍선 -->
                    <div class="speech-bubble">
                      <span class="name">박주호<span class="team divider">본부장</span><span class="time divider">124시간 25분</span></span>
                    </div>
                  </div>
                  <div class="container_info avatar-type">
                    <div class="list-title">하위 Top 3<span class="tag_icon red round"><i class="mdi-ico">trending_down</i></span></div>
                    <div class="avatar-list">
                      <div><span class="avatar-wrap"><span class="tag_icon red round">1</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="firstBottomName"></span><span class="team ellipsis" id="firstBottomOrgNm"></span></div>
                      <div><span class="avatar-wrap"><span class="tag_icon red round">2</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="secondBottomName"></span><span class="team ellipsis" id="secondBottomOrgNm"></span></div>
                      <div><span class="avatar-wrap"><span class="tag_icon red round">3</span><span class="avatar"><img src="../assets/images/attendance_char_0.png"></span></span><span class="name" id="thirdBottomName"></span><span class="team ellipsis" id="thirdBottomOrgNm"></span></div>
                    </div>
                    <!-- hover 시 말풍선 -->
                    <div class="speech-bubble">
                      <span class="name">박주호<span class="team divider">본부장</span><span class="time divider">124시간 25분</span></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!--// 직급대비 급여 상/하위 -->
          </div>
          <div class="widget_wrap row_1 col_1">
          </div>
           <div class="widget_wrap row_1 col_1">
            <!-- 급여인상 Top10 -->
            <div class="widget">
              <!-- 토글이 있을 땐 'toggle-wrap'으로 감싸준다. -->
              <div class="widget_header toggle-wrap">
                <div class="widget_title">급여인상 Top10</div>
              </div>
              <div class="widget_body widget-common avatar-widget big">
                <div class="widget_body_title total-title"><span class="label">전체 평균 증가</span><span class="cnt">18</span><span class="text">%</span><span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span></div>
                <div class="bookmarks_wrap">
                  <div class="bookmark_list">
                    <!-- 이 div 자체로 for문 -->
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon blue round">1</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTop1"><span class="position" id="salaryIncreaseTopjikweeNm1"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm1"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate1"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon blue round">2</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop2"><span class="position" id="salaryIncreaseTopjikweeNm2"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm2"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate2"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon blue round">3</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop3"><span class="position" id="salaryIncreaseTopjikweeNm3"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm3"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate3"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">4</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop4"><span class="position" id="salaryIncreaseTopjikweeNm4"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm4"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate4"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">5</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop5"><span class="position" id="salaryIncreaseTopjikweeNm5"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm5"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate5"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">6</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop6"><span class="position" id="salaryIncreaseTopjikweeNm6"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm6"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate6"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">7</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop7"><span class="position" id="salaryIncreaseTopjikweeNm7"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm7"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate7"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">8</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop8"><span class="position" id="salaryIncreaseTopjikweeNm8"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm8"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate8"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">9</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop9"><span class="position" id="salaryIncreaseTopjikweeNm9"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm9"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate9"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">10</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name"id="salaryIncreaseTop10"><span class="position" id="salaryIncreaseTopjikweeNm10"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNm10"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprate10"><span class="unit">%</span></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!-- //급여인상 Top10 -->
          </div>
          <div class="widget_wrap row_1 col_2">
            <!-- 급여인상 Top10 wide -->
            <div class="widget wide">
              <div class="widget_header toggle-wrap">
                <div class="widget_title">급여 인상 Top 10</div>
                <input type="checkbox" id="toggle6" hidden="">
              </div>
              <div class="widget_body widget-common avatar-widget big">
                <div class="widget_body_title total-title"><span class="label">전체 평균 증가</span><span class="cnt">18</span><span class="text">%</span><span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span></div>
                <div class="bookmarks_wrap">
                  <div class="bookmark_list">
                    <!-- 이 div 자체로 for문 -->
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon blue round">1</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide1"><span class="position" id="salaryIncreaseTopjikweeNmWide1"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide1"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide1"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon blue round">3</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide3"><span class="position" id="salaryIncreaseTopjikweeNmWide3"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide3"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide3"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">5</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide5"><span class="position" id="salaryIncreaseTopjikweeNmWide5"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide5"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide5"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">7</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide7"><span class="position" id="salaryIncreaseTopjikweeNmWide7"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide7"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide7"><span class="unit">%</span></span>
                    </div>
                    <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">9</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide9"><span class="position" id="salaryIncreaseTopjikweeNmWide9"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide9"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide9"><span class="unit">%</span></span>
                    </div>
                   </div>
                  <div class="bookmark_list">
                    <!-- 이 div 자체로 for문 -->
                     <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon blue round">2</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide2"><span class="position" id="salaryIncreaseTopjikweeNmWide2"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide2"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide2"><span class="unit">%</span></span>
                    </div> <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">4</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide4"><span class="position" id="salaryIncreaseTopjikweeNmWide4"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide4"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide4"><span class="unit">%</span></span>
                    </div> <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">6</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide6"><span class="position" id="salaryIncreaseTopjikweeNmWide6"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide6"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide6"><span class="unit">%</span></span>
                    </div> <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">8</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide8"><span class="position" id="salaryIncreaseTopjikweeNmWide8"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide8"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide8"><span class="unit">%</span></span>
                    </div> <div>
                      <div class="avatar-wrap">
                        <span class="tag_icon black round">10</span>
                        <span class="avatar">
                          <img src="../assets/images/attendance_char_0.png">
                        </span>
                      </div>
                      <div class="profile-info">
                        <span class="name" id="salaryIncreaseTopWide10"><span class="position" id="salaryIncreaseTopjikweeNmWide10"></span></span>
                        <span class="team short ellipsis" id="salaryIncreaseTopOrgNmWide10"></span>
                      </div>
                      <span class="percent" id="salaryIncreaseTopuprateWide10"><span class="unit">%</span></span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!--// 급여인상 Top10 wide -->
          </div>
          <div class="widget_wrap row_1 col_1"></div>
          <div class="widget_wrap row_1 col_1">
            <!-- 급여 아웃라이어 -->
            <div class="widget">
              <div class="widget_header toggle-wrap">
                <div class="widget_title">급여 아웃라이어</div>
                </label>
              </div>
              <div class="widget_body attend-status widget-common widget-more">
                <div class="bookmarks_title">
                  <a href="#"><i class="mdi-ico">keyboard_arrow_left</i></a>
                  <span>사원</span>
                  <a href="#"><i class="mdi-ico">keyboard_arrow_right</i></a>
                </div>
                <div class="container_info">
                  <span class="info_title_num">13<span class="info_title unit">명</span></span>
                  <span class="info_title desc">전년대비<strong class="title_green">10%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
                  <div class="btn-wrap">
                    <button class="btn outline_gray btn-more">아웃라이어 더 보기</button>
                  </div>
                </div>
              </div>
            </div>
            <!-- //급여 아웃라이어 -->
          </div>
          <div class="widget_wrap row_1 col_2">
            <!-- 급여 아웃라이어 wide -->
            <div class="widget wide">
              <div class="widget_header toggle-wrap">
                <div class="widget_title">급여 아웃라이어</div>
                </label>
              </div>
              <div class="widget_body chart-full">
                <div class="btn-wrap">
                  <button class="btn outline_gray btn-more">아웃라이어 더 보기</button>
                </div>
                <div class="chart-wrap">
                  <div id="boxplotChart"></div>
                </div>
              </div>
            </div>
            <!--// 급여 아웃라이어 wide -->
          </div>
          <div class="widget_wrap row_1 col_1"></div>
        </div>
      </div>
    </div>
    <!-- // main_tab_content -->
    
    <div class="select_options fix_width align_center custom" id="people_status">
      <div class="option on">
        <span class="no">1</span>
        <span class="status">승인완료</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option on">
        <span class="no">2</span>
        <span class="status">승인완료</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option wait">
        <span class="no">3</span>
        <span class="status">결재진행중</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">4</span>
        <span class="status">결재진행중</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">5</span>
        <span class="status">결재대기</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">6</span>
        <span class="status">결재대기</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
      <div class="option">
        <span class="no">7</span>
        <span class="status">결재대기</span>
        <span class="name"><img src="../assets/images/attendance_char_0.png"></img>김이수 대리</span>
      </div>
    </div>
  </body>
  <script> 
    $(document).ready(function () {
      /* 말풍선 */
      $('.avatar-list .name').mouseover(function(event){
        const xpos = $(this).position().left;
        const ypos = -$(this).parent().position().top;
        console.log("xpos:"+xpos+"/ ypos:"+ypos);
        // $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
        $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
      });
      $('.avatar-list .name').mouseout(function(event){
        $(this).parent().parent().next().hide();
      });

      /* 말풍선 */
      $('.overtime-work .avatar-list .name').mouseover(function(event){
        const xpos = ($(this).position().left + $(this).width() - 5 );
        const ypos = -($(this).parent().position().top + 33);
        console.log("xpos:"+xpos+"/ ypos:"+ypos);
        // $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
        $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
      });
      $('.overtime-work .avatar-list .name').mouseout(function(event){
        $(this).parent().parent().next().hide();
      });

      var options = {
              series: [
              {
                name: '금액',
                type: 'boxPlot',
                data: [
                  {
                    x: '사원',
                    y: [2500, 3000, 3000, 4200, 5000]
                  },
                  {
                    x: '대리',
                    y: [3800, 4100, 4100, 5800, 6200]
                  },
                  {
                    x: '과장',
                    y: [5000, 5800, 5800, 6900, 7500]
                  },
                  {
                    x: '차장',
                    y: [5800, 6200, 6200, 7700, 8200]
                  },
                  {
                    x: '부장',
                    y: [6700,7200, 7200, 8500, 9000]
                  },
                  {
                    x: '임원',
                    y: [7600,8100, 8100, 9500, 10200]
                  }
                ]
              },
              {
                name: '최소',
                type: 'scatter',
                data: [
                  {
                    x: '사원',
                    y: 5900
                  },
                  {
                    x: '대리',
                    y: 7000
                  },
                  {
                    x: '과장',
                    y: 8000
                  },
                  {
                    x: '차장',
                    y: 9000
                  },
                  {
                    x: '부장',
                    y: 9900
                  },
                  {
                    x: '임원',
                    y: 11000
                  },
                ]
              }
            ],
              chart: {
              type: 'boxPlot',
              width: 504,
              height: 130.5
            },
            colors: ['#008FFB', '#FEB019'],
		    xaxis: {
		        type: 'category',
		        categories: ['사원', '대리', '과장', '차장', '부장', '임원'],
		        tooltip: {
		            formatter: function (val) {
		                return val;
		            }
		        }
		    },
		    yaxis: {
		        categories: [2000, 4000, 6000, 8000, 10000],
		        tickAmount: 4,
		        min:2000,
		        max:10000,
		        labels: {
		            style: {
		                fontSize: '11px'
		            }
		        }
		    }
		};

            var chart = new ApexCharts(document.querySelector("#boxplotChart"), options);
            chart.render();

    });
  </script>
</html>
