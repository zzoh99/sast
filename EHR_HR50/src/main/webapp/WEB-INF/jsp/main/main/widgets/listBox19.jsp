<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget19 = { size: null };

function init_listBox19(size) {
	widget19.size = size;
	loadWidget19();
}

function loadWidget19() {
    ajaxCall2("${ctx}/getListBox19Info.do"
        , ""
        , true
        , null
        , function(result) {
            if (result && result.DATA) {
                const data = result.DATA;

                // 완료, 대기, 진행률
                var comp = data.filter(d => d.agreeStatusCd != '10').length;
                var wait = data.filter(d => d.agreeStatusCd == '10').length;
                var per = Math.round(comp/data.length * 100);
                var html = '';
                const today = "<%=DateUtil.getCurrentTime("MM/dd")%>";
                const compTitle = `오늘(\${today}) 결재 처리한(반려 포함) 결재건수입니다.`;
                const waitTitle = `내가 결재해야하는 잔여결재건수입니다.`;

                if (widget19.size == 'wide') {
                    html = `<div class="container_box">
                    <div class="container_info">
                        <div class="info_area">
                            <div class="area_title title_comp">완료</div>
                            <div class="area_num num_count" title="\${compTitle}">\${comp}</div>
                            <div class="area_title title_wait">대기</div>
                            <div class="area_num" title="\${waitTitle}">\${wait}</div>
                        </div>
                        <div class="info_area">
                            <span class="area_title">결과 진행률</span>
                            <span class="area_num num_per">\${per}<span class="per_title">%</span></span>
                        </div>
                    </div>
                    <div class="progress_container">
                        <div class="progress_bar bar_blue" style="width:\${per}%"></div>
                    </div>`;
                    if (data && data.length > 0) {
                        html += `<div id="widget19OnArea" class="superior_info"></div>
                    <ul id="widget19List" class="approval_list">`;

                        html += data.reduce((a, c) => {
                            a += `<li applSeq="\${c.applSeq}"
                            applSabun="\${c.applSabun}"
                            applInSabun="\${c.applInSabun}"
                            applCd="\${c.applCd}"
                            applYmd="\${c.applYmd}">
                        <div>\${c.title}</div>`;

                            if (c.line && c.line.length > 0) {
                                a +=  '		<div class="approval_progress">\n';
                                var totalLine = c.line.length;
                                var compLine  = c.line.filter(cc => ['20', '30', '40', '50'].includes(cc.agreeStatusCd)).length;
                                var lineTitle = totalLine == compLine ?
                                    ['20', '40'].includes(c.line[c.line.length - 1].agreeStatusCd) ? '완료':'취소'
                                    :'진행중';
                                var cclass = lineTitle == '진행중' ? ''
                                    :lineTitle == '완료' ? 'on':'off';

                                a += c.line.reduce((aa, cc, idx) => {
                                    if (idx != 0) aa += '<span class="progress_line"></span>\n';
                                    //결재코드 = 10:결재요청, 20:결재완료, 30:결재반려, 40:합의완료, 50:합의반려
                                    var lclass = '';
                                    lclass = ['20', '40'].includes(cc.agreeStatusCd) ? 'on'
                                        : ['30', '50'].includes(cc.agreeStatusCd) ? 'off'
                                            : '';
                                    if (c.line.length - 1 == idx) lclass += ' progress_count_in';
                                    aa += '<span jikwee="' + cc.agreeJikweeNm + '" aname="' + cc.agreeName + '" asabun="' + cc.agreeSabun + '" enterCd="' + cc.enterCd + '" class="progress_circle ' + lclass + '"></span>\n'
                                    return aa;
                                }, '');
                                a += '			<span class="progress_title ' + cclass + '">' + compLine + '/' + totalLine +  '</span>\n';
                                a += '			<span class="progress_title ' + cclass + '">' + lineTitle +  '</span>\n';
                                a += '		</div>\n';
                            }

                            a += '		</li>\n';
                            return a;
                        }, '')

                        html += '	</ul>\n';
                    } else {
                        html += `<div class="approval_no_data_wide">
                        <i class="mdi-ico">task</i><div class="no_data_info">결재 내역이 없습니다.</div>
                    </div>`;
                    }

                    html += '</div>\n';
                } else {
                    html = `<div class="content_area">
			        <div class="content_current">
                        <div class="info_title info_curr">잔여 결재건수</div>
                        <div class="info_area">
                            <span class="info_num area_curr" title="\${waitTitle}">\${wait}<span class="per_title">건</span></span>
<!--                            <span class="area_curr_total">\${data.length}</span>-->
                        </div>
                    </div>
                    <div class="content_per">
                        <div class="info_title info_per">오늘 결재건수</div>
                        <div class="info_area">
                            <span class="info_num area_per" title="\${compTitle}">\${comp}<span class="per_title">건</span></span>
                        </div>
                    </div>`;
                    // <div class="progress_container">
                    //     <div class="progress_bar bar_blue" style="width:\${per}%"></div>
                    // </div>`;
                    if (data && data.length > 0) {
                        html += '<ul id="widget19List" class="approval_list">\n';
                        html += data.reduce((a, c) => {
                            a += `<li applSeq="\${c.applSeq}"
						            applSabun="\${c.applSabun}"
                                    applInSabun="\${c.applInSabun}"
                                    applCd="\${c.applCd}"
                                    applYmd="\${c.applYmd}">
				  			      <div>\${c.title}</div>
                              </li>`;
                            return a;
                        }, '');
                        html += '</ul>\n';
                    } else {
                        html += `<div class="approval_no_data">
				         <i class="mdi-ico">task</i>
				         <div class="no_data_info">결재 내역이 없습니다.</div>
				     </div>`;
                    }

                    html += `</div>`;
                }

                $('#widget19Body').html(html);

                if (widget19.size == 'wide') {
                    widget19CursorActionOn();
                }

                widget19ClickOn();
            }
        })
}

function widget19ClickOn() {
	$('#widget19List li').on('click', function() {
		var applSeq = $(this).attr('applSeq');
		var applSabun = $(this).attr('applSabun');
		var applInSabun = $(this).attr('applInSabun');
		var applCd = $(this).attr('applCd');
		var applYmd = $(this).attr('applYmd');
		widget19OpenPopup(applSeq, applSabun, applInSabun, applCd, applYmd)
	});
}

function widget19CursorActionOn() {
	$('#widget19Body div.container_box ul li div span.progress_circle').on('mouseover', function(e) {
		var jik = $(this).attr('jikwee');
		var name = $(this).attr('aname');
		var sabun = $(this).attr('asabun');
		var datetime = new Date().getTime();
        var enterCd = $(this).attr('enterCd');
		var imageUrl = '/EmpPhotoOut.do?enterCd=' + enterCd + '&searchKeyword=' + sabun + '&t=' + datetime;

		
		
		var html = '<span class="superior_photo"><img src="' + imageUrl + '"></img></span>\n'
				 + '<span class="superior_title">' + name + '<span class="title_normal">' + jik + '</span></span>';

		$('#widget19OnArea').html(html);

		const xpos = $(this).position().left + 16;
	    const ypos = $(this).position().top + $(this).parent().parent().position().top - 50;
	    
	    $('#widget19OnArea').css({
	    	display: "flex",
	        "margin-left": xpos + "px",
	        "margin-top": ypos + "px"
		});
	});

	$('#widget19Body div.container_box ul li div span.progress_circle').on('mouseout', function(e) {
		$('#widget19OnArea').empty();
	    $('#widget19OnArea').hide();
	});
}

function widget19OpenPopup(applSeq, applSabun, applInSabun, applCd, applYmd) {
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
		};

    pGubun = "viewApprovalMgrResult";
    var approvalMgrLayer = new window.top.document.LayerModal({
		id: 'approvalMgrLayer',
		url: url,
		parameters: p,
		width: 800,
		height: 815,
		title: '근태신청',
        trigger: [
            {
                name: 'approvalMgrLayerTrigger',
                callback: function(rv) {
                    getReturnValueListBox19(rv);
                }
            }
        ]
	});
	approvalMgrLayer.show();
}

function goWidget19SubPage() {
	goSubPage("10", "", "", "", "AppBeforeLst.do?cmd=viewAppBeforeLst");
}

function getReturnValueListBox19(rv) {
    loadWidget19();
}


</script>
<div class="widget_header">
    <div class="widget_title">
        <i class="mdi-ico">task</i>내결재
    </div>
    <i class="mdi-ico" onclick="goWidget19SubPage()">more_horiz</i>
</div>
<div id="widget19Body" class="widget_body widget_approval">
</div>