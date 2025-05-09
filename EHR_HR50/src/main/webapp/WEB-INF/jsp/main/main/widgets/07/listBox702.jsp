<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 급여 인상 Top 10 
	 */

	var widget702 = {
		size: null
	};

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox702(size){
		if (size == 'normal') {
			createWidgetMini702();
		} else if (size == 'wide') {
			createWidgetWide702();
		}
		
		const salaryIncrease = ajaxCall('getListBox702List.do', '', false).data.salaryIncrease;
		setDataWidget702(salaryIncrease);
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini702(){
		var html = '';

		for (var i = 0; i < 10; i++){
			var code = 
				'<div class="widget_header toggle-wrap">' +
				'  <div class="widget_title">급여 인상 Top10</div>' +
				'</div>' +
				'<div class="widget_body widget-common avatar-widget big ranking">' +
				'  <div class="widget_body_title total-title">' +
				'    <span class="label">전체 평균 증가</span>' +
				'    <span class="cnt" id="uprate"></span>' +
				'    <span class="text">%</span>' +
				'    <span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span>' +
				'  </div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list">';
				
			html += 
				'      <div>' +
				'        <div class="avatar-wrap">' +
				'          <span class="tag_icon blue round">' + (i+1) + '</span>' +
				'          <span class="avatar">' +
				'            <img src="/common/images/common/img_photo.gif" id="salaryImage' + (i+1) + '">' +
				'          </span>' +
				'        </div>' +
				'        <div class="profile-info">' +
				'          <span class="name" id="salaryIncreaseTop' + (i+1) + '">' +
				'            <span class="position" id="salaryIncreaseTopjikweeNm' + (i+1) + '"></span>' +
				'          </span>' +
				'          <span class="team short ellipsis" id="salaryIncreaseTopOrgNm' + (i+1) + '"></span>' +
				'        </div>' +
				'        <span class="percent" id="salaryIncreaseTopuprate' + (i+1) + '">' +
				'          <span class="unit">%</span>' +
				'        </span>' +
				'      </div>';
		}            

		document.querySelector('#widget702Element').innerHTML = code + html;
	}

	// 위젯 wide html 코드 생성 
	function createWidgetWide702(){
		var oddHtml = '';
		var evenHtml = '';

		for (var i = 1; i < 11; i+=2){ // 왼쪽 홀수 라인 html 생성
			var code = 
					'<div class="widget_header toggle-wrap">' +
					'  <div class="widget_title">급여 인상 Top 10</div>' +
					'</div>' +
					'<div class="widget_body widget-common avatar-widget big ranking">' +
					'  <div class="widget_body_title total-title">' +
					'    <span class="label">전체 평균 증가</span>' +
					'    <span class="cnt" id="uprate"></span>' +
					'    <span class="text">%</span>' +
					'    <span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span>' +
					'  </div>' +
					'  <div class="bookmarks_wrap">' +
					'    <div class="bookmark_list">';
					
			oddHtml += 
					'      <div>' +
					'        <div class="avatar-wrap">' +
					'          <span class="tag_icon blue round">' + i + '</span>' +
					'          <span class="avatar">' +
					'            <img src="/common/images/common/img_photo.gif" id="salaryImage' + i + '">' +
					'          </span>' +
					'        </div>' +
					'        <div class="profile-info">' +
					'          <span class="name" id="salaryIncreaseTop' + i + '">' +
					'            <span class="position" id="salaryIncreaseTopjikweeNm' + i + '"></span>' +
					'          </span>' +
					'          <span class="team short ellipsis" id="salaryIncreaseTopOrgNm' + i + '"></span>' +
					'        </div>' +
					'        <span class="percent" id="salaryIncreaseTopuprate' + i + '">' +
					'          <span class="unit">%</span>' +
					'        </span>' +
					'      </div>';
		}
		
		oddHtml +=  '    </div>' +
					'    <div class="bookmark_list">';
		
		for (var j = 2; j < 11; j+=2){ // 오른쪽 짝수 라인 html 생성
			evenHtml += 
					'      <div>' +
					'        <div class="avatar-wrap">' +
					'          <span class="tag_icon blue round">' + j + '</span>' +
					'          <span class="avatar">' +
					'            <img src="/common/images/common/img_photo.gif" id="salaryImage' + j + '">' +
					'          </span>' +
					'        </div>' +
					'        <div class="profile-info">' +
					'          <span class="name" id="salaryIncreaseTop' + j + '">' +
					'            <span class="position" id="salaryIncreaseTopjikweeNm' + j + '"></span>' +
					'          </span>' +
					'          <span class="team short ellipsis" id="salaryIncreaseTopOrgNm' + j + '"></span>' +
					'        </div>' +
					'        <span class="percent" id="salaryIncreaseTopuprate' + j + '">' +
					'          <span class="unit">%</span>' +
					'        </span>' +
					'      </div>';
		}

		document.querySelector('#widget702Element').innerHTML = code + oddHtml + evenHtml;
	}

	/*
	 * 위젯 데이터 넣기  
	 * salaryIncrease: 랭킹, 이름, 팀 전체 데이터
	 */ 
	function setDataWidget702(salaryIncrease) {
	    for (var i = 0; i < salaryIncrease.data.length; i++) {
	        if (salaryIncrease.data[i].rank <= 10) {
	        	var $elem = $('#salaryImage' + (1+i));
	        			        
	            setSalaryRankImgFile($elem, salaryIncrease.data[i].sabun, salaryIncrease.enterCd);
	            setSalaryData(salaryIncrease.data[i].rank, salaryIncrease.data[i]); // 순위에 따른 데이터 넣기 
	        }
	    }
	}

	/**
	 * TODO 파라미터 추가하기
	 * 회사코드, 사번, 현재시간으로 회원 사진 가져오기
	 * enterCD : 회사코드
	 * sabun : 사번
	 */	
	function setSalaryRankImgFile($elem, sabun, enterCD){
	    $elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCD + "&searchKeyword=" + sabun +"&t=" + (new Date()).getTime());
	}

	/**
	 * 급여 순위에 따른 이름, 직위, 부서, 증가율 데이터 넣기 
	 * rank : 순위
	 * data : 이름, 직위, 부서, 증가율 데이터
	 */	
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

</script>
<div class="widget" id="widget702Element"></div>