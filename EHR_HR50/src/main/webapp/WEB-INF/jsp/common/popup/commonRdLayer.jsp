<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>뷰어</title>
</head>
<script type="text/javascript">

    function research(viewer) {
        var modal = window.top.document.LayerModalUtility.getModal("rdLayer");


        viewer.openFile(modal.parameters.p, modal.parameters.d, modal.parameters.o);
    }

    var isDown = false;
    var downType = '';
    $(function() {
        var modal = window.top.document.LayerModalUtility.getModal("rdLayer");

        //적용
        var viewer = new m2soft.crownix.Viewer('${rdUrl}/ReportingServer/service', 'com-crownix-viewer');
        viewer.setParameterEncrypt(11);

        var opt = modal.parameters.o == null ? '' : modal.parameters.o;

        if(typeof opt.rdToolBarYn != 'undefined')
            showToolbar(viewer, opt.rdToolBarYn);

        if(opt != '')
            viewer.hideToolbarItem(hideToolbarItemArray(opt));

        viewer.openFile(modal.parameters.p, modal.parameters.d, modal.parameters.o);

        var eventHandler = function(event){
            if(isDown) {
                // 다운로드 버튼 클릭으로 인해 리포트가 다시 생성된 경우, 다운로드 처리
                if(downType === 'print') {
                    // PDF 로 변환하여 출력
                    viewer.print({
                        isServerSide: true,
                    })
                } else {
                    viewer.downloadFile(downType);
                }
                isDown = false;
                downType = '';
            }

            // RD 이벤트 리스너를 지우고 커스텀 이벤트를 처리하기위해 각 버튼에 mouseover 할 때마다 클릭 이벤트 리스너를 초기화 해준다.
            $(document).off('mouseover').on('mouseover', '#crownix-toolbar-print_pdf, #crownix-toolbar-save .dropdown li[id^="crownix-toolbar-"]', function() {
                $(this).off('click tab').on('click tab', function() {
                    var btnId = $(this).attr('id');
                    if(btnId === 'crownix-toolbar-print_pdf'){
                        downType = 'print'
                    } else {
                        downType = btnId.replace('crownix-toolbar-', ''); // 다운로드 유형 설정
                    }
                    const result = ajaxTypeJson(modal.parameters.u, modal.parameters.ud, false);
                    isDown = true;
                    viewer.openFile(result.DATA.path, result.DATA.encryptParameter, modal.parameters.o);
                })
            });
        };
        viewer.bind('report-finished', eventHandler);
    });

    function showToolbar(viewer, rdToolBarYn) {
        rdToolBarYn === "N" ? viewer.hideToolbar() : viewer.showToolbar();
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

</script>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <div style="height: calc(100% - 65px);">
            <div id="com-crownix-viewer" class="rd-viewer" style="position:absolute; top:0; left:0; width:100%; height:inherit;"></div>
        </div>
    </div>
    <div class="modal_footer">
        <a href="javascript:closeCommonLayer('rdLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
    </div>
</div>
</body>
</html>
