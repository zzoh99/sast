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
    /**
     * 새로운 항목인지 여부 Tag 처리
     * @param _regDateNew 등록일자(YYYYMMDD)
     * @param parentElement 부모 Element
     */
    const setIsNewTags = function(_regDateNew, parentElement) {
        if (!_regDateNew || (typeof _regDateNew) !== "string") return;
        if (!parentElement) return;

        const today = new Date();
        const todayString = today.getFullYear().toString()
            + lpad((today.getMonth() + 1).toString(), 2, '0')
            + lpad(today.getDate().toString(), 2, '0');

        if (todayString === _regDateNew.trim()) {
            const div = document.createElement("div");
            div.className = "tag_icon red round";
            div.innerText = "N";
            parentElement.append(div);
            $('#widget6NewIco').show();
        }
    }

	$('#widget6MoreIco').off().click(function() {
		goSubPage('20', '', '', '', '/Board.do?cmd=viewBoardMgr||bbsCd=10000');
	});

    ajaxCall2("${ctx}/getListBox6List.do"
        , ""
        , true
        , null
        , function(result) {
            if (result && result.DATA) {

                const data = result.DATA;

                const widget6Body = document.querySelector("div#widget6Body");
                if (data.length > 0) {
                    const ul = document.createElement("ul");
                    ul.className = (widget6.size === 'wide' ? "notice_list_long" : "notice_list");
                    data.reduce((a, c) => {
                        const li = document.createElement("li");
                        li.style.cursor = "pointer";
                        li.setAttribute("bbsCd", c.bbsCd);
                        li.setAttribute("bbsSeq", c.bbsSeq);

                        if (widget6.size === 'wide') {
                            const div = document.createElement("div");
                            const p = document.createElement("p");
                            p.innerText = c.title;
                            div.append(p);
                            setIsNewTags(c.regDateNew, div);
                            const span = document.createElement("span");
                            span.className = "notice_date";
                            span.innerText = c.regDate;
                            div.append(span);
                            li.append(div);
                        } else {
                            const span = document.createElement("span");
                            span.innerText = c.title;
                            li.append(span);
                            setIsNewTags(c.regDateNew, li);
                        }

                        a.append(li);

                        return a;
                    }, ul);

                    widget6Body.append(ul);
                } else {
                    const div = document.createElement("div");
                    div.className = "no_list";
                    const i = document.createElement("i");
                    i.className = "mdi-ico filled";
                    i.innerText = "sms";
                    div.append(i);
                    const p = document.createElement("p");
                    p.innerText = "공지사항이 없습니다.";
                    div.append(p);

                    widget6Body.append(div);
                }

                widget6BbsLinkOn();
            }
        })
}

function widget6BbsLinkOn() {
	$('#widget6Body li').off().click(function() {
		const cd = $(this).attr('bbsCd');
		const seq = $(this).attr('bbsSeq');
		mainOpenNoticePop(cd, seq);
	});
} 

function mainOpenNoticePop(bbsCd, bbsSeq){
    new window.top.document.LayerModal({
        id : 'boardReadLayer',
        url : '/Board.do?cmd=viewBoardReadLayer&authPg=R',
        parameters : {
            bbsCd: bbsCd,
            bbsSeq: bbsSeq
        },
        width : 940,
        height : 800,
        title : '공지사항',
        trigger :[
            {
                name : 'boardReadLayerTrigger'
                , callback : function(result) {
                    goMain();
                }
            }
        ]
    }).show();
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








