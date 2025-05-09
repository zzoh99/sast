<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 핵심인재 현황
	 */

	var widget208 = {
		size: null
	};

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox208(size) {
		widget208.size = size;
		
		if (size == "normal"){
			createWidgetMini208();
			setDataWidgetMini208();
		} else if (size == ("wide")){
			createWidgetWide208();
			setDataWidgetWide208();
		}
	}

	// 위젯 html 코드 생성
	function createWidgetMini208(){
		var html = 
				'<div class="widget_header">' +
		        '  <div class="widget_title">핵심인재 현황</div>' +
		        '  <i class="mdi-ico">more_horiz</i>' +
		        '</div>' +
		        '<div class="widget_body widget-common avatar-widget big">' +
		        '  <div class="bookmarks_title select-outer total-title">' +
		        '    <div class="custom_select no_style">' +
		        '      <button class="select_toggle select_toggle208">' +
		        '        <span id="coreRange">전체</span><i class="mdi-ico">arrow_drop_down</i>' +
		        '      </button>' +
		        '      <div class="select_options numbers select_options208" style="visibility: hidden;">' +
		        '        <div class="option checkRange208" value="all">전체</div>' +
			    '        <div class="option checkRange208" value="team">팀별</div>' +
			    '        <div class="option checkRange208" value="head">본부별</div>' +
		        '      </div>' +
		        '    </div>' +
		        '    <span class="num" id="coreCnt"></span>' +
		        '    <span class="unit">명</span>' +
		        '  </div>' +
		        '  <div class="bookmarks_wrap">' +
		        '    <div class="bookmark_list" id="coreList">' +
		        '    </div>' +
		        '  </div>' +
		        '</div>';

		document.querySelector('#widget208Element').innerHTML = html;
	}
	
	// 위젯 mini 테이터 넣기
	function setDataWidgetMini208(coreOption){
		if (typeof coreOption == "undefined" || coreOption == null || coreOption == ""){
			coreOption = "all";
		}
		
		const coreStatus = ajaxCall('getListBox208List.do', {option: coreOption}, false).data;

		var html = '';

		if(coreStatus.coreStatus){
			for (var i = 0; i < coreStatus.coreStatus.length; i++){
				html += 
					'<div>' +
					'  <div class="avatar-wrap">' +
					'    <span class="avatar">' +
					'      <img src="../assets/images/attendance_char_0.png" id="coreImage' + (i+1) + '">' +
					'    </span>' +
					'  </div>' +
					'  <div class="profile-info">' +
					'    <span class="name" id="coreName' + (i+1) + '">김이수<span class="position" id="coreJikweeNm' + (i+1) + '">사원</span></span>' +
					'    <span class="team short ellipsis" id="coreOrgNm' + (i+1) + '">영업마케팅</span>' +
					'  </div>' +
					'</div>';
			}
	
			document.querySelector('#coreList').innerHTML = html;
	
			$('#coreCnt').text(coreStatus.coreStatus.length);
			
			for (var i = 0; i < coreStatus.coreStatus.length; i++){
				var nameHtml = coreStatus.coreStatus[i].name + '<span class="position" id="coreJikweeNm' + (i+1) + '">사원</span>';
	
				document.querySelector('#coreName' + (i+1)).innerHTML = nameHtml;
				$('#coreJikweeNm' + (i+1)).text(coreStatus.coreStatus[i].jikweeNm);
				$('#coreOrgNm' + (i+1)).text(coreStatus.coreStatus[i].orgNm);
	
				var $elem = $('#coreImage' + (i+1));
	
				setCoreImgFile($elem, coreStatus.coreStatus[i].sabun, i+1, coreStatus.enterCd);
			}
		}
	}
	
	// 위젯 wide html 코드 생성 
	function createWidgetWide208(){
		var html =
				'<div class="widget_header">' +
				'  <div class="widget_title">핵심인재 현황</div>' +
				'  <i class="mdi-ico">more_horiz</i>' +
				'</div>' +
				'<div class="widget_body widget-common avatar-widget big">' +
				'  <div class="bookmarks_title select-outer total-title">' +
				'    <div class="custom_select no_style">' +
				'      <button class="select_toggle select_toggle208">' +
		        '        <span id="coreRange">전체</span><i class="mdi-ico">arrow_drop_down</i>' +
		        '      </button>' +
		        '      <div class="select_options numbers select_options208" style="visibility: hidden;">' +
		        '        <div class="option checkRange208" value="all">전체</div>' +
			    '        <div class="option checkRange208" value="team">팀별</div>' +
			    '        <div class="option checkRange208" value="head">본부별</div>' +
		        '      </div>' +
		        '    </div>' +
		        '    <span class="num" id="coreCnt"></span>' +
		        '    <span class="unit">명</span>' +
				'  </div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="coreListLeft">' +
				'    </div>' +
				'    <div class="bookmark_list" id="coreListRight">' +
				'    </div>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget208Element').innerHTML = html;
	}
	
	// 위젯 wide 데이터 넣기  
	function setDataWidgetWide208(coreOption){
		if (typeof coreOption == "undefined" || coreOption == null || coreOption == ""){
			coreOption = "all";
		}
		
		const coreStatus = ajaxCall('getListBox208List.do', {option: coreOption}, false).data;

		var leftHtml = '';
		var rightHtml = '';

		if (coreStatus.coreStatus){
			for (var i = 1; i < coreStatus.coreStatus.length; i+=2){
				leftHtml += 
					'<div>' +
					'  <div class="avatar-wrap">' +
					'    <span class="avatar">' +
					'      <img src="../assets/images/attendance_char_0.png" id="coreImage' + i + '">' +
					'    </span>' +
					'  </div>' +
					'  <div class="profile-info">' +
					'    <span class="name" id="coreName' + i + '"><span class="position" id="coreJikweeNm' + i + '">사원</span></span>' +
					'    <span class="team short ellipsis" id="coreOrgNm' + i + '"></span>' +
					'  </div>' +
					'</div>';
			}
	
			for (var j = 2; j < coreStatus.coreStatus.length+1 ; j+=2){
				rightHtml += 
					'<div>' +
					'  <div class="avatar-wrap">' +
					'    <span class="avatar">' +
					'      <img src="../assets/images/attendance_char_0.png" id="coreImage' + j + '">' +
					'    </span>' +
					'  </div>' +
					'  <div class="profile-info">' +
					'    <span class="name" id="coreName' + j + '"><span class="position" id="coreJikweeNm' + j + '">사원</span></span>' +
					'    <span class="team short ellipsis" id="coreOrgNm' + j + '"></span>' +
					'  </div>' +
					'</div>';
			}
			
			document.querySelector('#coreListLeft').innerHTML = leftHtml;
			document.querySelector('#coreListRight').innerHTML = rightHtml;
	
			$('#coreCnt').text(coreStatus.coreStatus.length);
			
			for (var i = 0; i < coreStatus.coreStatus.length; i++){
				var nameHtml = coreStatus.coreStatus[i].name + '<span class="position" id="coreJikweeNm' + (i+1) + '">사원</span>';
	
				document.querySelector('#coreName' + (i+1)).innerHTML = nameHtml;
				$('#coreJikweeNm' + (i+1)).text(coreStatus.coreStatus[i].jikweeNm);
				$('#coreOrgNm' + (i+1)).text(coreStatus.coreStatus[i].orgNm);
	
				var $elem = $('#coreImage' + (i+1));
	
				setCoreImgFile($elem, coreStatus.coreStatus[i].sabun, i+1, coreStatus.enterCd);
			}
		}
	}

	function setCoreImgFile($elem, sabun, enterCD){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCD + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}

	$(document).ready(function() {
		var selectToggle = document.querySelector('.select_toggle208');
	    var selectOptions = document.querySelector('.select_options208');

		$('#widget208Element').on('click', '.select_toggle208', function() {
			var selectOptions = document.querySelector('.select_options208');
			if (selectOptions.style.visibility == 'hidden') {
	            selectOptions.style.visibility = 'visible';
			} else {
	            selectOptions.style.visibility = 'hidden';
			}
		});

		$('#widget208Element').on('click', '.checkRange208', function() {
		    var rangeValue = $(this).attr('value');

			switch (rangeValue){
			case 'all':
				$('#coreRange').text("전체");
				break;
			case 'team':
				$('#coreRange').text("팀별");
				break;
			case 'head':
				$('#coreRange').text("본부별");
				break;
			}
			
			if (widget208.size == 'normal'){
				setDataWidgetMini208(rangeValue);
			} else if (widget208.size == 'wide'){
				setDataWidgetWide208(rangeValue);
			} 

			selectOptions.style.visibility = 'hidden';
		});
	}); 
</script>
<div class="widget" id="widget208Element"></div>