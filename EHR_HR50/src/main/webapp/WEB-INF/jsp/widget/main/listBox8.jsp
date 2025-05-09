<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget8 = {
	size: null,
	seq: null,
	swiper: null
};

function init_listBox8(size) {
	widget8.size = size;
	loadWidget8();
}

function loadWidget8() {
	const data = ajaxCall('/getListBox8List.do', '', false).DATA;
	var html = '';

	if (data.length > 0) {
		if (widget8.size == 'wide') {
			$('#widget8Body').addClass('widget_management_wide');
			html += '<div class="swiper management_wide">\n';
		} else {
			$('#widget8Body').removeClass('widget_management_wide');
			html += '<div class="swiper management_short">\n';
		}
		
		html += '	<div class="swiper-wrapper">\n';
		html += data.reduce((a, c) => {
			a += '<div class="swiper-slide">\n'
			   + '	<div class="container_box">\n'
			   + '		<div class="img_container">\n'
			   + '			<div class="person_img_wrap">\n'
			   + '				<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + c.sabun + '" class="person_img" />\n'
			   + '			</div>\n'
			   + '		</div>\n'
			   + '		<div class="person_info">\n'
			   + '			<span class="icon-position">' + c.jikweeNm + '</span>\n'
			   + '			<div class="person_name">' + c.name + '</div>\n'
			   + '			<div class="phone_info">' + c.orgNm + '</div>\n'
			   + '		</div>\n'
			   + '		<div class="phone_info">\n'
			   + '			<span>입사년도</span><span>' + c.empYmd + '</span>\n'
			   + '		</div>\n'
			   + '	</div>\n'
			   + "</div>\n"
			return a;
		}, '');
		html += '	</div>\n';
		html += '	<div class="swiper-pagination"></div>\n';
		html += '	<div class="swiper-button-next"><i class="mdi-ico">keyboard_arrow_right</i></div>\n';
		html += '	<div class="swiper-button-prev"><i class="mdi-ico">keyboard_arrow_left</i></div>\n';
		html += '</div>\n';
		$('#widget8MoreIcon').show();
		$('#widget8Body').html(html);
		onWidget8MoreIconClick();
		onWidget8SwipeAndLink();
	} else {
		html = '<div class="content_area_no">\n'
			 + '	<i class="mdi-ico filled">account_circle</i>\n'
			 + '	<div class="no_data_title">신규 입사자가 없습니다.</div>\n'
			 + '</div>';
		$('#widget8Body').html(html);
	}
}

function onWidget8SwipeAndLink() {
  /* 인사 담당자 sort */
  widget8.swiper = new Swiper('#widget8Body .swiper', {
    pagination: {
      el: '#widget8Body .swiper .swiper-pagination',
      type: 'bullets',
      clickable: true,
    },
    navigation: {
      nextEl: '#widget8Body .swiper .swiper-button-next',
      prevEl: '#widget8Body .swiper .swiper-button-prev',
    }
    nested: true // 위젯 안에 슬라이드가 있을 시 사용 (중첩 슬라이드시 개별 슬라이드 가능하게 수정). 2023.10.26 snow3
  });
}

function onWidget8MoreIconClick() {
	$('#widget8MoreIcon').off().click(function() {
		goSubPage("", "", "", "", "NewEmpLst.do?cmd=viewNewEmpLst");
	});
}
</script>
<div class="widget_header">
  <div class="widget_title">
	<i class="mdi-ico filled">account_circle</i>신규 입사자
  </div>
  <i id="widget8MoreIcon" class="mdi-ico" style="display:none;">more_horiz</i>
</div>
<div id="widget8Body" class="widget_body widget_management">
</div>