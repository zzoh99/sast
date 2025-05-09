<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">

        $(function() {
            const modal = window.top.document.LayerModalUtility.getModal('retAllowanceStaLayer');
            if(modal.parameters && modal.parameters.searchMapTypeCd)
                $("#searchMapTypeCd").val(modal.parameters.searchMapTypeCd);
            if(modal.parameters && modal.parameters.searchMapTypeNm)
                $(".searchMapTypeNm").text(modal.parameters.searchMapTypeNm);

            createIBSheet3(document.getElementById('retAllowanceStaLayerSheet-wrap'), "retAllowanceStaLayerSheet", "100%", "100%","${ssnLocaleCd}");

            let initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata1.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
                {Header:"<sht:txt mid='codeNm' mdef='코드명'/>",		Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
            ];
            IBS_InitSheet(retAllowanceStaLayerSheet, initdata1);
            retAllowanceStaLayerSheet.SetEditable(false);
            retAllowanceStaLayerSheet.SetVisible(true);
            retAllowanceStaLayerSheet.SetCountPosition(4);

            retAllowanceStaLayerSheet.FocusAfterProcess = false;

            $(window).smartresize(sheetResize); sheetInit();

            const sheetHeight = $('.modal_body').height() - $('#sheet1Form').height() - $('.sheet_title').height();
            retAllowanceStaLayerSheet.SetSheetHeight(sheetHeight);
            doAction1("Search");
        });

        $(function() {
            $("#codeNm").bind("keyup",function(event){
                if( event.keyCode == 13){
                    doAction1("Search");
                }
            });

            $(".close").click(function() {
                p.self.close();
            });
        });

        /*Sheet Action*/
        function doAction1(sAction) {
            switch (sAction) {
                case "Search": //조회
                    retAllowanceStaLayerSheet.DoSearch( "${ctx}/RetAllowanceSta.do?cmd=getRetAllowanceStaPopList", $("#sheet1Form").serialize());
                    break;
                case "Clear":        //Clear
                    retAllowanceStaLayerSheet.RemoveAll();
                    break;
                case "Down2Excel":  //엑셀내려받기
                    retAllowanceStaLayerSheet.Down2Excel();
                    break;
            }
        }

        // 조회 후 에러 메시지
        function retAllowanceStaLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try{
                if(Msg != "") alert(Msg);
                sheetResize();
            }catch(ex){
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 더블클릭시 발생
        function retAllowanceStaLayerSheet_OnDblClick(Row, Col){
            try{

                if( Row < retAllowanceStaLayerSheet.HeaderRows() ) return;
                returnFindUser(Row,Col);
            }catch(ex){
                alert("OnDblClick Event Error : " + ex);
            }
        }

        function returnFindUser(Row,Col) {
            const modal = window.top.document.LayerModalUtility.getModal('retAllowanceStaLayer');
            modal.fire('retAllowanceStaTrigger', [{
                code : retAllowanceStaLayerSheet.GetCellValue(Row, "code"),
                codeNm : retAllowanceStaLayerSheet.GetCellValue(Row, "codeNm")
            }]).hide();
        }
    </script>

<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
            <input id="searchMapTypeCd" name="searchMapTypeCd" type="hidden" value="">
            <div class="sheet_search outer">
                <div>
                    <table>
                        <tr>
                            <td>
                                <span class="searchMapTypeNm">회계Location</span>
                                <input id="codeNm" name ="codeNm" type="text" class="text" />
                            </td>
                            <td>
                                <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </form>

        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
            <tr>
                <td>
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li id="txt" class="txt searchMapTypeNm">회계Location</li>
                            </ul>
                        </div>
                    </div>
                    <div id="retAllowanceStaLayerSheet-wrap"></div>
<%--                    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>--%>
                </td>
            </tr>
        </table>
    </div>
    <div class="modal_footer">
         <a href="javascript:closeCommonLayer('retAllowanceStaLayer');" class="btn outline_gray">닫기</a>
    </div>
</div>
</body>