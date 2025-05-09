<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget2 = {
	size: null
};

function init_listBox2(size) {
	widget2.size = size;
	loadWidget2();
}

function loadWidget2() {

    ajaxCall2("${ctx}/getListBox2List.do"
        , ""
        , true
        , null
        , function(result) {
            if (result && result.map) {

                const data = result.map;
                $('#widget2Count').text(data.cnt + '건');
                var html = '';

                if (data.cnt > 0) {
                    $('#widget2MoreIcon').show();
                    $('#widget2MoreIcon').click(function() {
                        widget2GoLink();
                    });
                    html = '<div class="bookmark_list">\n';
                    html += data.list.reduce((a, c) => {
                        a += '<div style="cursor:pointer;" applSeq="' + c.applSeq
                            + '" applSabun="' + c.applSabun
                            + '" applInSabun="' + c.applInSabun
                            + '" applCd="' + c.applCd
                            + '" applYmd="' + c.applYmd
                            + '" conditionEnterCd="' + c.enterCd
                            + '">'
                            + c.applYmdA
                            + '<span class="title">'
                            + c.title
                            + '</span>';
                        if (widget2.size == 'wide') {
                            a += '<span class="tag_icon blue list">'
                                + c.applStatusCdNm
                                + '</span>';
                        }
                        a += '</div>\n';
                        return a;
                    }, '')
                    html += '</div>';
                    $('#widget2Body').append(html);
                    onWidget2LiClick();
                } else {
                    html = '<div class="no_list">\n'
                        + '	<i class="mdi-ico-filled">task</i>\n'
                        + '	<p>현재 신청 내역이 없습니다.</p>\n'
                        + '</div>';
                    $('#widget2Body').append(html);
                }
            }
        })
}

function onWidget2LiClick() {
	$('#widget2Body div.bookmark_list div').off().click(function() {
		if( $(this).attr("applSeq") != undefined ) {
			mainOpenApp( ''
						,$(this).attr("applSeq")
						,$(this).attr("applSabun")
						,$(this).attr("applInSabun")
						,$(this).attr("applCd")
						,$(this).attr("applYmd")
						,$(this).attr("conditionEnterCd"));
		}
	});
}

function mainOpenApp(appType, applSeq, applSabun, applInSabun, applCd, applYmd, conditionEnterCd ){
	if(!isPopup()) {return;}
    var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
    var initFunc = 'initResultLayer';
    var p = {
			searchApplCd: applCd
		  , searchApplSeq: applSeq
		  , adminYn: 'N'
		  , authPg: 'R'
		  , searchSabun: applInSabun
		  , searchApplSabun: applSabun
		  , searchApplYmd: applYmd 
		  , conditionEnterCd: conditionEnterCd
		};
    
    pGubun = "viewApprovalMgrResult";
    var approvalMgrLayer = new window.top.document.LayerModal({
		id: 'approvalMgrLayer',
		url: url,
		parameters: p,
		width: 800,
		height: 815,
		title: '근태신청'
	});
	approvalMgrLayer.show();
    //openLayer(url, p, 800, 815, initFunc);
 }

function widget2GoLink() {
	goSubPage("10", "", "", "", "AppBoxLst.do?cmd=viewAppBoxLst");
}
</script>
<div class="widget_header">
  <div class="widget_title">
    <i class="mdi-ico filled">task</i>신청한 내역
  </div>
  <i id="widget2MoreIcon" class="mdi-ico" style="cursor:pointer; display: none;">more_horiz</i>
</div>
<div id="widget2Body" class="widget_body">
  <div id="widget2Count" class="widget_body_title"></div>
</div>
