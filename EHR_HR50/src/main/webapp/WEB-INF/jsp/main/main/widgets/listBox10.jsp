<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget10 = {
	size: null,
	seq: null,
	swiper: null
};

function init_listBox10(size) {
	widget10.size = size;
	loadWidget10();
}

function loadWidget10() {

    ajaxCall2("${ctx}/getListBox10List.do"
        , ""
        , true
        , null
        , function(result) {
            if (result && result.DATA) {

                const data = result.DATA;
                var html = '';

                if (data.length > 0) {
                    if (widget10.size == 'wide') {
                        $('#widget10Body').addClass('widget_management_wide');
                        html += '<div class="swiper management_wide">\n';
                    } else {
                        $('#widget10Body').removeClass('widget_management_wide');
                        html += '<div class="swiper management_short">\n';
                    }

                    html += '	<div class="swiper-wrapper">\n';
                    html += data.reduce((a, c) => {
                        if (widget10.size == 'wide') {
                            a += '<div class="swiper-slide">\n'
                                + '	<div class="container_box">\n'
                                + '		<div class="img_container">\n'
                                + '			<div class="person_img_wrap">\n'
                                + '				<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + c.sabun + '" class="person_img" />\n'
                                + '			</div>\n'
                                + '		</div>\n'
                                + '		<div class="person_info">\n'
                                + '			<span class="icon-position">' + c.positionNm + '</span>\n'
                                + '			<div class="person_name">' + c.name + '</div>\n'
                                + '			<div class="phone_info"><span>내선번호</span>' + c.officeTel + '</div>\n'
                                + '		</div>\n'
                                + '	</div>\n'
                                + "</div>\n"
                        } else {
                            a += '<div class="swiper-slide">\n'
                                + '	<div class="content_area">\n'
                                + '		<div class="img_container">\n'
                                + '			<div class="person_img_wrap">\n'
                                + '				<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + c.sabun + '" class="person_img" />\n'
                                + '			</div>\n'
                                + '		</div>\n'
                                + '		<div class="person_info">\n'
                                + '			<div class="icon-position">' + c.positionNm + '</div><span>' + c.name +  ' </span>\n'
                                + '		</div>\n'
                                + '		<div class="phone_info">\n'
                                + '			<span>내선번호</span><span>' + c.officeTel + '</span>\n'
                                + '		</div>'
                                + '	</div>\n'
                                + "</div>\n"
                        }

                        return a;
                    }, '');
                    html += '	</div>\n';
                    html += '	<div class="swiper-pagination"></div>\n';
                    html += '	<div class="swiper-button-next"><i class="mdi-ico">keyboard_arrow_right</i></div>\n';
                    html += '	<div class="swiper-button-prev"><i class="mdi-ico">keyboard_arrow_left</i></div>\n';
                    html += '</div>\n';
                    $('#widget10Body').html(html);
                    onWidget10SwipeAndLink();
                } else {
                    html = '<div class="content_area_no">\n'
                        + '	<i class="mdi-ico filled">account_circle</i>\n'
                        + '	<div class="no_data_title">인사 담당자가 없습니다.</div>\n'
                        + '</div>';
                    $('#widget10Body').html(html);
                }
            }
        })
}

function onWidget10SwipeAndLink() {
  /* 인사 담당자 sort */
  widget10.swiper = new Swiper('#widget10Body .swiper', {
    pagination: {
      el: '#widget10Body .swiper .swiper-pagination',
      type: 'bullets',
      clickable: true,
    },
    navigation: {
      nextEl: '#widget10Body .swiper .swiper-button-next',
      prevEl: '#widget10Body .swiper .swiper-button-prev',
    },
    nested: true
  });
}

</script>
<div class="widget_header">
  <div class="widget_title">
	<i class="mdi-ico filled">account_circle</i>인사 담당자
  </div>
</div>
<div id="widget10Body" class="widget_body widget_management">
</div>