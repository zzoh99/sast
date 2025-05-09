<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 복직 예정자 현황
	 */

	var widget209 = {
		size: null
	};

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox209(size) {
		widget209.size = size;
		
		if (size == "normal"){
			createWidgetMini209();
			setDataWidgetMini209();
		} else if (size == ("wide")){
			createWidgetWide209();
			setDataWidgetWide209();
		}
	}

	// 위젯 html 코드
	function createWidgetMini209(){
		var html = 
					'<div class="widget_header">' +
					'  <div class="widget_title">복직 예정자 현황</div>' +
					'  <i class="mdi-ico">more_horiz</i>' +
					'</div>' +
					'<div class="widget_body widget-common avatar-widget big">' +
					'  <div class="bookmarks_title select-outer total-title">' +
					'    <div class="custom_select no_style">' +
					'      <button class="select_toggle select_toggle209">' +
			        '        <span id="overseaRange">전체</span><i class="mdi-ico">arrow_drop_down</i>' +
			        '      </button>' +
			        '      <div class="select_options numbers select_options209" style="visibility: hidden;">' +
			        '        <div class="option checkRange" value="all">전체</div>' +
				    '        <div class="option checkRange" value="3">3개월</div>' +
				    '        <div class="option checkRange" value="6">6개월</div>' +
			        '      </div>' +
			        '    </div>' +
					'    <span class="num" id="overseaCnt"></span>' +
					'    <span class="unit">명</span>' +
					'  </div>' +
					'  <div class="bookmarks_wrap">' +
					'    <div class="bookmark_list" id="overseaList">' +
					'    </div>' +
					'  </div>' +
					'</div>';

		document.querySelector('#widget209Element').innerHTML = html;
	}
	
	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini209(overseaOption){
		if (typeof overseaOption == "undefined" || overseaOption == null || overseaOption == ""){
			overseaOption = "all";
		}

		const overseaDeployment = ajaxCall('getListBox209List.do', {option: overseaOption}, false).data;

		var html = '';

		if (overseaDeployment.overseaDeployment){
			var overseaCount = overseaDeployment.overseaDeployment.length;
	
			for (var i = 0; i < overseaCount; i++){
				html += 
						'      <div>' +
						'        <div class="avatar-wrap">' +
						'          <span class="avatar">' +
						'            <img src="../assets/images/attendance_char_0.png" id="overseaImage' + (i+1) + '">' +
						'          </span>' +
						'        </div>' +
						'        <div class="profile-info">' +
						'          <span class="name" id="overseaName' + (i+1) + '">김이수<span class="position" id="overseaJikweeNm' + (i+1) + '">사원</span></span>' +
						'          <span class="team short ellipsis" id="overseaOrgNm' + (i+1) + '">영업마케팅</span>' +
						'        </div>' +
						'      </div>';
			}
	
			document.querySelector('#overseaList').innerHTML = html;
	
			$('#overseaCnt').text(overseaCount);
			
			for (var i = 0; i < overseaCount; i++){
				var nameHtml = overseaDeployment.overseaDeployment.data[i].name + '<span class="position" id="overseaJikweeNm' + (i+1) + '">사원</span>';
	
				document.querySelector('#overseaName' + (i+1)).innerHTML = nameHtml;
				$('#overseaJikweeNm' + (i+1)).text(overseaDeployment.overseaDeployment.data[i].jikweeNm);
				$('#overseaOrgNm' + (i+1)).text(overseaDeployment.overseaDeployment.data[i].orgNm);
	
				var $elem = $('#overseaImage' + (i+1));
	
				setOverseaImgFile($elem, overseaDeployment.overseaDeployment.data[i].sabun, overseaDeployment.overseaDeployment.data[i].enterCd);
			}
		}
	}
	
	// 위젯 wide html 코드 
	function createWidgetWide209(){
		var html = 
					'<div class="widget_header">' +
					'  <div class="widget_title">복직 예정자 현황</div>' +
					'  <i class="mdi-ico">more_horiz</i>' +
					'</div>' +
					'<div class="widget_body widget-common avatar-widget big">' +
					'  <div class="bookmarks_title select-outer total-title">' +
					'    <div class="custom_select no_style">' +
					'      <button class="select_toggle select_toggle209">' +
			        '        <span id="overseaRange">전체</span><i class="mdi-ico">arrow_drop_down</i>' +
			        '      </button>' +
			        '      <div class="select_options numbers select_options209" style="visibility: hidden;">' +
			        '        <div class="option checkRange" value="all">전체</div>' +
				    '        <div class="option checkRange" value="3">3개월</div>' +
				    '        <div class="option checkRange" value="6">6개월</div>' +
			        '      </div>' +
			        '    </div>' +
					'    <span class="num" id="overseaCnt"></span>' +
					'    <span class="unit">명</span>' +
					'  </div>' +
					'  <div class="bookmarks_wrap pt-30">' +
					'    <div class="bookmark_list" id="overseaListLeft">' +
					'    </div>' +
					'    <div class="bookmark_list" id="overseaListRight">' +
					'    </div>' +
					'  </div>' +
					'</div>';

		document.querySelector('#widget209Element').innerHTML = html;
	}

	// 위젯 wide 데이터 넣기  
	function setDataWidgetWide209(overseaOption){

		if (typeof overseaOption == "undefined" || overseaOption == null || overseaOption == ""){
			overseaOption = "all";
		}

		const overseaDeployment = ajaxCall('getListBox209List.do', {option: overseaOption}, false).data;

		var headHtml = '';
		var leftHtml = '';
		var rightHtml = '';

		if (overseaDeployment){
			var overseaCount = overseaDeployment.overseaDeployment.data.length;
			
			for (var i = 1; i <= overseaCount; i+=2){
				leftHtml +=
						'      <div>' +
						'        <div class="avatar-wrap">' +
						'          <span class="avatar">' +
						'            <img src="../assets/images/attendance_char_0.png" id="overseaImage' + i + '">' +
						'          </span>' +
						'        </div>' +
						'        <div class="profile-info">' +
						'          <span class="name" id="overseaName' + i + '"><span class="position" id="overseaJikweeNm' + i + '">사원</span></span>' +
						'          <span class="team short ellipsis" id="overseaOrgNm' + i + '"></span>' +
						'        </div>' +
						'        <span class="tag_icon green period" id="overseaPeriod' + i + '"></span>' + 
						'      </div>';
			}
	
			for (var j = 2; j < overseaCount+1 ; j+=2){
				rightHtml += 
						'      <div>' +
						'        <div class="avatar-wrap">' +
						'          <span class="avatar">' +
						'            <img src="../assets/images/attendance_char_0.png" id="overseaImage' + j + '">' +
						'          </span>' +
						'        </div>' +
						'        <div class="profile-info">' +
						'          <span class="name" id="overseaName' + j + '"><span class="position" id="overseaJikweeNm' + j + '">사원</span></span>' +
						'          <span class="team short ellipsis" id="overseaOrgNm' + j + '"></span>' +
						'        </div>' +
						'        <span class="tag_icon green period" id="overseaPeriod' + j + '"></span>' +
						'      </div>';
			}
			
			document.querySelector('#overseaListLeft').innerHTML = headHtml + leftHtml;
			document.querySelector('#overseaListRight').innerHTML = rightHtml;
	
			$('#overseaCnt').text(overseaCount);
			
			for (var i = 0; i < overseaCount; i++){
                var nameHtml = overseaDeployment.overseaDeployment.data[i].name + '<span class="position" id="overseaJikweeNm' + (i+1) + '">사원</span>';
	
				document.querySelector('#overseaName' + (i+1)).innerHTML = nameHtml;
				$('#overseaJikweeNm' + (i+1)).text(overseaDeployment.overseaDeployment.data[i].jikweeNm);
				$('#overseaOrgNm' + (i+1)).text(overseaDeployment.overseaDeployment.data[i].orgNm);
				$('#overseaPeriod' + (i+1)).text('D'+overseaDeployment.overseaDeployment.data[i].period);
	
				var $elem = $('#overseaImage' + (i+1));

				setOverseaImgFile($elem, overseaDeployment.overseaDeployment.data[i].sabun, overseaDeployment.overseaDeployment.data[i].enterCd);
			}
		}
	}
	
	function setOverseaImgFile($elem, sabun, enterCD){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCD + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}
	
	$(document).ready(function() {
		var selectToggle = document.querySelector('.select_toggle209');
	    var selectOptions = document.querySelector('.select_options209');

		$('#widget209Element').on('click', '.select_toggle209', function() {
			var selectOptions = document.querySelector('.select_options209');
			if (selectOptions.style.visibility == 'hidden') {
	            selectOptions.style.visibility = 'visible';
			} else {
	            selectOptions.style.visibility = 'hidden';
			}
		});

		$('#widget209Element').on('click', '.checkRange', function() {
		    var rangeValue = $(this).attr('value');
		    
			switch (rangeValue){
			case 'all':
				$('#overseaRange').text("전체");
				break;
			case 'team':
				$('#overseaRange').text("3개월");
				break;
			case 'head':
				$('#overseaRange').text("6개월");
				break;
			}
			
			if (widget209.size == 'normal'){
				setDataWidgetMini209(rangeValue);
			} else if (widget209.size == 'wide'){
				setDataWidgetWide209(rangeValue);
			} 

			selectOptions.style.visibility = 'hidden';
		});
	}); 
</script>
<div class="widget" id="widget209Element"></div>