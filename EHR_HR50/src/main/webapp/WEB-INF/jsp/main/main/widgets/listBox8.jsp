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

    ajaxCall2("${ctx}/getListBox8List.do"
        , ""
        , true
        , null
        , function(result) {
            if (result && result.DATA) {

                const data = result.DATA;
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
                        if (widget8.size == 'wide') {
                            a += '<div class="swiper-slide">\n'
                                + '	<div class="container_box">\n'
                                + '		<div class="img_container">\n'
                                + '			<div class="person_img_wrap">\n'
                                + '				<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + c.sabun + '" class="person_img" />\n'
                                + '			</div>\n'
                                + '		</div>\n'
                                + '		<div class="person_info">\n'
                                + '			<span class="icon-position">' + c.orgNm + '</span>\n'
                                + '			<div class="person_name">' + c.name + '<span>' + c.jikweeNm + '</span></div>\n'
                                + '			<div class="phone_info"><span>입사년도</span>' + c.empYmd + '</div>\n'
                                + '		</div>\n'
                                + '	</div>\n'
                                + '</div>\n';
                        } else {
                            a += '<div class="swiper-slide">\n'
                                + '	<div class="content_area">\n'
                                + '		<div class="img_container">\n'
                                + '			<div class="person_img_wrap">\n'
                                + '				<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + c.sabun + '" class="person_img" />\n'
                                + '			</div>\n'
                                + '		</div>\n'
                                + '		<div class="person_info">\n'
                                + '			<div class="icon-position">' + c.orgNm + '</div><span>' + c.name +  ' </span>\n'
                                + '		</div>\n'
                                + '		<div class="phone_info">\n'
                                + '			<span>입사년도</span><span>' + c.empYmd + '</span>\n'
                                + '		</div>'
                                + '	</div>\n'
                                + '</div>\n';
                        }


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
        })
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
    },
    nested: true // 위젯 안에 슬라이드가 있을 시 사용 (중첩 슬라이드시 개별 슬라이드 가능하게 수정). 2023.10.26 snow3
  });
}

function onWidget8MoreIconClick() {
	$('#widget8MoreIcon').off().click(function() {
        if(typeof goSubPage == 'undefined') {
            // 서브페이지에서 서브페이지 호출
            if(typeof window.top.goOtherSubPage == 'function') {
                window.top.goOtherSubPage("", "", "", "", "NewEmpLst.do?cmd=viewNewEmpLst");
            }
        } else {
            goSubPage("", "", "", "", "NewEmpLst.do?cmd=viewNewEmpLst");
        }
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