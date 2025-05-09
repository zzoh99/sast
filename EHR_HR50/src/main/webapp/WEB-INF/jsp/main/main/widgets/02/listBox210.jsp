<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 면수습 예정자 현황
	 */

	var widget210 = {
		size: null
	};

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox210(size) {
		widget210.size = size;
		
		if (size == "normal"){
			createWidgetMini210();
			setDataWidgetMini210();
		} else if (size == ("wide")){
			createWidgetWide210();
			setDataWidgetWide210();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini210(){
		var html = 
					'<div class="widget_header">' +
					'  <div class="widget_title">면수습 예정자 현황</div>' +
					'  <i class="mdi-ico">more_horiz</i>' +
					'</div>' +
					'<div class="widget_body widget-common avatar-widget big">' +
					'  <div class="bookmarks_title select-outer total-title">' +
					// '    <span class="label">예정(전체)</span>' +
					'    <span class="num" id="probationCnt"></span>' +
					// '    <span class="total" id="probationAllCnt"></span>' +
					'    <span class="unit">명</span>' +
					'  </div>' +
					'  <div class="bookmarks_wrap">' +
					'    <div class="bookmark_list" id="probationList">' +
					'    </div>' +
					'  </div>' +
					'</div>';

		document.querySelector('#widget210Element').innerHTML = html;
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini210(){
		const probationStatus = ajaxCall('getListBox210List.do', '', false).data;

		if (probationStatus.probationStatus){
			var html = '';
			var probationCount = probationStatus.probationStatus.length;
			var finishCount = 0;
					
			for (var i = 0; i < probationCount; i++){
				html += 
					
						'      <div>' +
						'        <div class="avatar-wrap">' +
						'          <span class="avatar">' +
						'            <img src="../assets/images/attendance_char_0.png" id="probationImage' + (i+1) + '">' +
						'          </span>' +
						'        </div>' +
						'        <div class="profile-info">' +
						'          <span class="name" id="probationName' + (i+1) + '"><span class="position" id="probationJikweeNm' + (i+1) + '"></span></span>' +
						'          <span class="team short ellipsis" id="probationOrgNm' + (i+1) + '"></span>' +
						'        </div>' +
						'      </div>';
			}
	
			document.querySelector('#probationList').innerHTML = html;
			
			for (var i = 0; i < probationCount; i++){
				var nameHtml = probationStatus.probationStatus[i].name + '<span class="position" id="probationJikweeNm' + (i+1) + '">사원</span>';
	
				document.querySelector('#probationName' + (i+1)).innerHTML = nameHtml;
				$('#probationJikweeNm' + (i+1)).text(probationStatus.probationStatus.data[i].jikweeNm);
				$('#probationOrgNm' + (i+1)).text(probationStatus.probationStatus.data[i].orgNm);
	
				var $elem = $('#probationImage' + (i+1));
				setProbationImgFile($elem, probationStatus.probationStatus.data[i].sabun, probationStatus.probationStatus.data[i].enterCd);
				
				if (probationStatus.probationStatus[i].period < 10){
					finishCount++;
				}
			}
	
			$('#probationAllCnt').text('(' + probationCount + ')');
			$('#probationCnt').text(finishCount);
		}
	}

	// 위젯 wide html 코드 생성 
	function createWidgetWide210(){
		var html =
					'<div class="widget_header">' +
					'  <div class="widget_title">면수습 예정자 현황</div>' +
					'  <i class="mdi-ico">more_horiz</i>' +
					'</div>' +
					'<div class="widget_body widget-common avatar-widget big">' +
					'  <div class="bookmarks_title select-outer total-title">' +
					// '    <span class="label">예정(전체)</span>' +
					'    <span class="num" id="probationCnt"></span>' +
					// '    <span class="total" id="probationAllCnt"></span>' +
					'    <span class="unit">명</span>' +
					'  </div>' +
					'  <div class="bookmarks_wrap">' +
					'    <div class="bookmark_list" id="probationListLeft">' +
					'    </div>' +
					'    <div class="bookmark_list" id="probationListRight">' +
					'    </div>' +
					'  </div>' +
					'</div>';

		document.querySelector('#widget210Element').innerHTML = html;
	}

	// 위젯 wide html 데이터 넣기
	function setDataWidgetWide210(){
		const probationStatus = ajaxCall('getListBox210List.do', '', false).data;

		if (probationStatus.probationStatus){
			var leftHtml = '';
			var rightHtml = '';
			var probationCount = probationStatus.probationStatus.data.length;
			var finishCount = 0;
			
			for (var i = 1; i <= probationCount; i+=2){
				leftHtml += 
						'      <div>' +
						'        <div class="avatar-wrap">' +
						'          <span class="avatar">' +
						'            <img src="../assets/images/attendance_char_0.png" id="probationImage' + i + '">' +
						'          </span>' +
						'        </div>' +
						'        <div class="profile-info">' +
						'          <span class="name" id="probationName' + i + '"><span class="position" id="probationJikweeNm' + i + '">사원</span></span>' +
						'          <span class="team short ellipsis" id="probationOrgNm' + i + '"></span>' +
						'        </div>' +
						'        <span class="tag_icon green d-day close" id="probationPeriod' + i + '"></span>' + 
						'      </div>';
			}
	
			for (var j = 2; j < probationCount+1 ; j+=2){
				rightHtml += 
						'      <div>' +
						'        <div class="avatar-wrap">' +
						'          <span class="avatar">' +
						'            <img src="../assets/images/attendance_char_0.png" id="probationImage' + j + '">' +
						'          </span>' +
						'        </div>' +
						'        <div class="profile-info">' +
						'          <span class="name" id="probationName' + j + '"><span class="position" id="probationJikweeNm' + j + '">사원</span></span>' +
						'          <span class="team short ellipsis" id="probationOrgNm' + j + '"></span>' +
						'        </div>' +
						'        <span class="tag_icon green d-day close" id="probationPeriod' + j + '"></span>' +
						'      </div>';
			}
			
			document.querySelector('#probationListLeft').innerHTML =  leftHtml;
			document.querySelector('#probationListRight').innerHTML = rightHtml;
	
	
			for (var i = 0; i < probationCount; i++){
				var nameHtml = probationStatus.probationStatus.data[i].name + '<span class="position" id="probationJikweeNm' + (i+1) + '">사원</span>';
	
				document.querySelector('#probationName' + (i+1)).innerHTML = nameHtml;
				$('#probationJikweeNm' + (i+1)).text(probationStatus.probationStatus.data[i].jikweeNm);
				$('#probationOrgNm' + (i+1)).text(probationStatus.probationStatus.data[i].orgNm);
	
				var $elem = $('#probationImage' + (i+1));
	
				setProbationImgFile($elem, probationStatus.probationStatus.data[i].sabun, probationStatus.probationStatus.data[i].enterCd);
				
				if (probationStatus.probationStatus.data[i].period < 10){
					finishCount++;
	
					$('#probationPeriod' + (i+1)).text('D-' + probationStatus.probationStatus.data[i].period);
				}
			}
	
			$('#probationAllCnt').text('(' + probationCount + ')');
			$('#probationCnt').text(finishCount);
		}
	}

	function setProbationImgFile($elem, sabun, enterCD){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCD + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}
</script>
<div class="widget" id="widget210Element"></div>