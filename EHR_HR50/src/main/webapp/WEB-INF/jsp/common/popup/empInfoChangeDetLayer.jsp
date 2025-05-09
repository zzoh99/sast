<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('empInfoChangeDetLayer');
        arg = modal.parameters;

        createIBSheet3(document.getElementById('detSheet-wrap'), "detSheet", "100%", "100%","${ssnLocaleCd}");
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll,FrozenCol:0};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"항목", 	Type:"Text",    Hidden:0,   Width:200,  	Align:"Center", ColMerge:0, SaveName:"columnNm",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"신청전", 	Type:"Html",   Hidden:0,   Width:200,  	Align:"Center", ColMerge:0, SaveName:"preValue",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2000, MultiLineText:1, Wrap:1 },
            {Header:"신청후", 	Type:"Html",    Hidden:0,   Width:200,  	Align:"Center", ColMerge:0, SaveName:"aftValue",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2000, MultiLineText:1, Wrap:1 },
            {Header:"", 	Type:"Text",    Hidden:1,   Width:70,  	Align:"Left", ColMerge:0, SaveName:"cType",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"", 	Type:"Text",    Hidden:1,   Width:70,  	Align:"Left", ColMerge:0, SaveName:"popupType",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },

        ]; IBS_InitSheet(detSheet, initdata);detSheet.SetEditable("${editable}");detSheet.SetVisible(true);detSheet.SetCountPosition(4);detSheet.SetEditEnterBehavior("newline");

        $(window).smartresize(sheetResize); sheetInit();
        // detSheet.SetSheetHeight(sheetHeight);
        var param = "applSeq="+arg.applSeq+"&empTable="+arg.empTable;
        // param += "&applType="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applType");
        // param += "&applStatusCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applStatusCd");

        detSheet.DoSearch("${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeMgrList2", param);
    });

    function detSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();
            for(var i=1 ; i<detSheet.RowCount()+1; i++){
                if( detSheet.GetCellValue(i,"preValue") != detSheet.GetCellValue(i,"aftValue")){
                    detSheet.SetCellFontColor(i,"preValue", "blue");
                    detSheet.SetCellFontColor(i,"aftValue", "blue");

                }

                //첨부파일인 경우 button
                if(detSheet.GetCellValue(i,"cType") == "F"){
                    var t = detSheet.GetCellValue(i,"popupType");

                    if(detSheet.GetCellValue(i,"preValue")!=""){
                        detSheet.SetCellValue(i, "preValue", '<a class="basic" onclick="javascript:viewAttachFile(\''+detSheet.GetCellValue(i,"preValue")+'\', \''+detSheet.GetCellValue(i,"popupType")+'\');">첨부</a>');
                    }
                    if(detSheet.GetCellValue(i,"aftValue")!=""){
                        detSheet.SetCellValue(i, "aftValue", '<a class="basic" onclick="javascript:viewAttachFile(\''+detSheet.GetCellValue(i,"aftValue")+'\', \''+detSheet.GetCellValue(i,"popupType")+'\');">첨부</a>');
                    }
                }
            }
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <div class="layerTitle-wrap">
            	<div class="txt _popTitle"></div>
            	<div class="ml-auto">
            		<div class="btn"></div>
            	</div>
            </div>
<%--            <div>--%>
<%--                <form id="empForm" name="empForm">--%>
<%--                <table border="0" cellpadding="0" cellspacing="0" class="default" id="empTable">--%>
<%--                </table>--%>
<%--                </form>--%>
<%--            </div>--%>
            <div id="detSheet-wrap"></div>
        </div>
        <div class="modal_footer">
<%--            <a href="javascript:doempInfoChangeDetLayerAction1('Save');" class="btn filled" id="regBtn" ><tit:txt mid='appComLayout' mdef='신청'/></a>--%>
            <a href="javascript:closeCommonLayer('empInfoChangeDetLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	    </div>
    </div>
</body>
</html>


