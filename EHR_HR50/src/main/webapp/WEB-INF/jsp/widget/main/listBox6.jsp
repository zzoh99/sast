<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget6 = {
	size: null
};

function init_listBox6(size) {
	widget6.size = size;
	loadWidget6();
}

function loadWidget6() {
	$('#widget6MoreIco').off().click(function() {
		goSubPage('20', '', '', '', '/Board.do?cmd=viewBoardMgr||bbsCd=10000');
	});

	const data = ajaxCall('/getListBox6List.do', '', false).DATA;
	
	const today = new Date();
	const todaystring = today.getFullYear().toString() 
					 + lpad((today.getMonth() + 1).toString(), 2, '0')
					 + lpad(today.getDate().toString(), 2, '0'); 
	var isnew = false;

	var html = '';
	if (data.length > 0) {
		html += widget6.size == 'wide' ? '<ul class="notice_list_long">\n':'<ul class="notice_list">\n';
		html += data.reduce((a, c) => {
			a += '<li style="cursor:pointer;" '
			   + '	bbsCd="' + c.bbsCd + '"'
			   + '	bbsSeq="' + c.bbsSeq + '" >';
			if (widget6.size == 'wide') {
				a += '<div>\n'
				   + '	<p>' + c.title + '</p>\n';
			    if (todaystring == c.regDateNew) {
					a += '<div class="tag_icon red round">N</div>\n';
					isnew = true;
				}
				a += '</div>\n';
				a += '<span class="notice_date">' + c.regDate + '</span>\n';
			} else {
				a += '<span>' + c.title + '</span>\n';
				if (todaystring == c.regDateNew) {
					a += '<div class="tag_icon red round">N</div>\n';
					isnew = true;
				}
			}
			a += '</li>\n';
			return a;
		}, '');

		html += '</ul>\n';
	} else {
		html += '<div class="no_list">\n';
			  + '	<i class="mdi-ico filled">sms</i>\n'
			  + '	<p>공지사항이 없습니다.</p>\n'
			  + '</div>\n';
	}

	if (isnew) {
		$('#widget6NewIco').show();
	}

	$("#widget6Body").append(html);
	widget6BbsLinkOn();
}

function widget6BbsLinkOn() {
	$('#widget6Body li').off().click(function() {
		const cd = $(this).attr('bbsCd');
		const seq = $(this).attr('bbsSeq');
		mainOpenNoticePop(cd, seq);
	});
} 

function mainOpenNoticePop(bbsCd, bbsSeq){
	var url = "/Board.do?cmd=viewBoardReadPopup&";
    var $form = $('<form></form>');
    var param1 	= $('<input name="bbsCd" 	type="hidden" 	value="'+bbsCd+'" />');
    var param2 	= $('<input name="bbsSeq" 	type="hidden" 	value="'+bbsSeq+'" />');
    $form.append(param1).append(param2);
    $form.appendTo('body');
    url += $form.serialize() ;
	openPopup(url, new Array(), "940", "800", function(event){ goMain(); });
}

</script>
<div class="widget_header">
  <div class="widget_title">
    <i class="mdi-ico filled">sms</i>공지사항&ensp;
    <span id="widget6NewIco" class="tag_icon red title" style="display:none;">NEW</span>
  </div>
  <i id="widget6MoreIco" class="mdi-ico" style="cursor:pointer;">more_horiz</i>
</div>
<div id="widget6Body" class="widget_body">
  <div class="widget_body_title">공지사항 확인하기</div>
</div>








