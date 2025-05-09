<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>뷰어</title>
</head>
<script type="text/javascript">
    $(function() {
        var modal = window.top.document.LayerModalUtility.getModal("rdSignLayer");

        //적용
        var signViewer = new m2soft.crownix.Viewer('${rdUrl}/ReportingServer/service', 'reportPage_ifrmsrc');
        signViewer.setParameterEncrypt(11);

        var opt = modal.parameters.o == null ? '' : modal.parameters.o;

        if(typeof opt.rdToolBarYn != 'undefined')
            showToolbar(signViewer, opt.rdToolBarYn);

        if(opt != '')
            signViewer.hideToolbarItem(hideToolbarItemArray(opt));

        signViewer.openFile(modal.parameters.p, modal.parameters.d, modal.parameters.o);
    });

    function showToolbar(signViewer, rdToolBarYn) {
        rdToolBarYn === "N" ? signViewer.hideToolbar() : signViewer.showToolbar();
    }

    function hideToolbarItemArray(opt) {
        var hideItem 	= new Array();

        var array=[
            {name:'rdSaveYn',		type:'save',		defaultShowYn:'Y'},	//기능컨트롤_저장
            {name:'rdPrintYn',	    type:'print',		defaultShowYn:'Y'},	//기능컨트롤_인쇄
            {name:'rdPrintPdfYn',	type:'print_pdf',	defaultShowYn:'Y'},	//기능컨트롤_PDF인쇄
            {name:'rdExcelYn',	    type:'xls',			defaultShowYn:'Y'},	//기능컨트롤_엑셀
            {name:'rdWordYn',		type:'doc',			defaultShowYn:'Y'},	//기능컨트롤_워드
            {name:'rdPptYn',		type:'ppt',			defaultShowYn:'Y'},	//기능컨트롤_파워포인트
            {name:'rdHwpYn',		type:'hwp',			defaultShowYn:'Y'},	//기능컨트롤_한글
            {name:'rdPdfYn',		type:'pdf',			defaultShowYn:'Y'}	//기능컨트롤_PDF
        ];

        array.forEach(item => {
            const key = item.name;
            const value = opt.hasOwnProperty(key) ? opt[key] : item.defaultShowYn;

            if(value === 'N') hideItem.push(item.type)
        })
        return hideItem;
    }

    //사인패드 서명 후 리턴
    function returnSignPad(rs){
        if(rs.FileSeq !== undefined && rs.FileSeq !== null && rs.FileSeq.length > 0) {
            if( !confirm("동의 하시겠습니까?\n(동의 후에는 본인이 취소할 수 없습니다.") ) return;
            var fileSeq = rs.FileSeq;
            var modal = window.top.document.LayerModalUtility.getModal("rdSignLayer");
            const p = { fileSeq };
            modal.fire('rdSignLayerTrigger', p).hide();
        } else {
            alert("처리 중 오류가 발생했습니다.");
        }
    }
</script>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <div style="height: calc(100% - 200px);">
            <div id="reportPage_ifrmsrc" class="rd-viewer" style="position:absolute; top:0; left:0; width:100%; height:inherit;"></div>
        </div>

        <div id="divSignPad" style="position:absolute;left:50%;right:0;bottom:0;height:200px;margin-left:-200px;">
            <iframe id="ifrmSignPad" name="ifrmSignPad" src="/Popup.do?cmd=signPadPopup" style="border:0px; width:400px; height:200px;"></iframe>
        </div>
    </div>
</div>
</body>
</html>
