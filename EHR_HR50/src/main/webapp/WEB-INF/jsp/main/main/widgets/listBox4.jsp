<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget4 = {
	size: null,
	seq: null
};

function init_listBox4(size) {
	widget4.size = size;
	loadWidget4();
}

function loadWidget4() {

    ajaxCall2("${ctx}/getListBox4List.do"
        , ""
        , true
        , null
        , function(result) {
            if (result && result.DATA) {

                const data = result.DATA;
                var html = '';
                if (data && data.length > 0) {
                    html = '<div class="bookmarks_title"></div>\n';
                    html += widget4.size == 'wide' ? '<div class="bookmarks_wrap">\n':'<div class="bookmark_list">\n';
                    var body = data.reduce((a, c, idx) => {
                        if (widget4.size == 'wide') {
                            if (a.left == '') a.left = '<div class="bookmark_list">\n';
                            if (a.right == '') a.right = '<div class="bookmark_list">\n';
                            if (idx%2 == 0) {
                                a.left += '<div><span class="widget4_link" mmcd="' + c.mainMenuCd + '" prgcd="' + c.prgCd + '" >' + c.menuNm + '</span></div>\n';
                            } else {
                                a.right += '<div><span class="widget4_link" mmcd="' + c.mainMenuCd + '" prgcd="' + c.prgCd + '" >' + c.menuNm + '</span></div>\n';
                            }
                            if (idx == data.length - 1){
                                a.left += '</div>\n';
                                a.right += '</div>\n';
                            }
                        } else {
                            a.left += '<div><span class="widget4_link" mmcd="' + c.mainMenuCd + '" prgcd="' + c.prgCd + '">' + c.menuNm + '</span></div>\n';
                        }
                        return a;
                    }, {left: '', right: ''});

                    html += body.left + body.right;
                    html += '</div>\n';
                } else {
                    html = '<div class="no_list">\n'
                        + '	<i class="mdi-ico">boormakr</i>\n'
                        + '	<p>자주 사용하는 메뉴가 없습니다. <br />\n'
                        + '	자주 사용하는 메뉴를 등록해주세요.\n'
                        + '	</p>\n'
                        + '</div>\n';
                }

                $('#widget4Body').html(html);
                $('#widget4Body span.widget4_link').on('click', function() {
                    var mmcd = $(this).attr('mmcd');
                    var prgcd = $(this).attr('prgcd');
                    openSubPage(mmcd, '', '', '', prgcd);
                });
            }
        })

  $('#widget4MoreIco').off().click(function() {
    var url = '/QuickMenu.do?cmd=viewQuickMenuLayer';
    var quickMenuLayer = new window.top.document.LayerModal({
      id: 'quickMenuLayer',
      url: url,
      width: 790,
      height: 750,
      title: '자주 사용하는 메뉴',
      trigger: [
        {
          name: 'quickMenuLayerTrigger',
          callback: function(rv) {
            getReturnValueListBox4(rv);
          }
        }
      ]
    });
    quickMenuLayer.show();
  });
}

function getReturnValueListBox4(rv) {
  loadWidget4();
}

</script>
<div class="widget_header">
  <div class="widget_title">
    <i class="mdi-ico">bookmark</i>자주 사용하는 메뉴
  </div>
  <i id="widget4MoreIco" class="mdi-ico">more_horiz</i>
</div>
<div id="widget4Body" class="widget_body">
  <div class="bookmarks_title">
  	<!-- 
    <i class="mdi-ico">keyboard_arrow_left</i><span>인사</span><i class="mdi-ico">keyboard_arrow_right</i>
     -->
  </div>
  <div class="bookmark_list">
    <div><span>대량발령</span></div>
    <div><span>인사기본</span></div>
    <div><span>발령처리</span><span class="tag_icon green round">C</span></div>
    <div><span>급여명세서</span><span class="tag_icon blue round">N</span></div>
    <div><span>급여명세서</span><span class="tag_icon blue round">N</span></div>
    <div><span>급여명세서</span><span class="tag_icon blue round">N</span></div>
  </div>
</div>