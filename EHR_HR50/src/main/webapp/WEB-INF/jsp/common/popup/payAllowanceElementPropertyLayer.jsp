<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <title><tit:txt mid='104282' mdef='수당항목속성'/></title>
<%--    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>


    <script type="text/javascript">
        // 	var srchBizCd = null;
        // 	var srchTypeCd = null;
        var p = eval("${popUpStatus}");
        $(function() {

            const modal = window.top.document.LayerModalUtility.getModal('allowModal');
            const parameters = modal.parameters;

            var argsElementType = modal.parameters.elementType;
            var argsElementCd 	= modal.parameters.elementCd;
            var argsElementNm 	= modal.parameters.elementNm;
            var argsSdate 		= modal.parameters.sdate;

            $("#searchElemCd").val(argsElementCd);
            $("#searchElemNm").val(argsElementNm);
            $("#searchSdate").val(argsSdate);

            createIBSheet3(document.getElementById('mySheet0-wrap'), "mySheet0", "100%", "100%", "${ssnLocaleCd}");
            createIBSheet3(document.getElementById('mySheet1-wrap'), "mySheet1", "100%", "100%", "${ssnLocaleCd}");
            createIBSheet3(document.getElementById('mySheet2-wrap'), "mySheet2", "100%", "100%", "${ssnLocaleCd}");

            // Grid 0
            var initdata0 = {};
            //SetConfig
            initdata0.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
            //HeaderMode
            initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            //InitColumns + Header Title
            initdata0.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
//             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
                {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",      Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
                {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",        Type:"Text",      Hidden:0,  Width:125,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
                {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",          Type:"Text",      Hidden:0,  Width:40,   Align:"Left",    ColMerge:0,   SaveName:"include",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 }
            ];
            IBS_InitSheet(mySheet0, initdata0); mySheet0.SetEditable("${editable}");
            mySheet0.SetColProperty("include",          {ComboText:"YES|NO", ComboCode:"Y|N"} );
            mySheet0.SetCountPosition(4);


            // Grid 1
            var initdata1 = {};
            //SetConfig
            initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
            //HeaderMode
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            //InitColumns + Header Title
            initdata1.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
//             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
                {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",   Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
                {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",     Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
                {Header:"<sht:txt mid='attribute' mdef='적용여부코드'/>",   Type:"Text",      Hidden:0,  Width:125,  Align:"Center",  ColMerge:0,   SaveName:"attribute",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",       Type:"Text",       Hidden:1,  Width:135,  Align:"Center",  ColMerge:0,   SaveName:"attributeNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 } ,
            ];
            IBS_InitSheet(mySheet1, initdata1); mySheet1.SetEditable("${editable}");
            mySheet1.SetCountPosition(4);

            // Grid 2
            var initdata2 = {};
            //SetConfig
            initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
            //HeaderMode
            initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            //InitColumns + Header Title
            initdata2.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
//             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
                {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",      Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
                {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",        Type:"Text",      Hidden:0,  Width:125,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
                {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",          Type:"Text",      Hidden:0,  Width:40,   Align:"Left",    ColMerge:0,   SaveName:"include",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 }

            ];
            IBS_InitSheet(mySheet2, initdata2); mySheet2.SetEditable("${editable}");
            mySheet2.SetColProperty("include",          {ComboText:"YES|NO", ComboCode:"Y|N"} );
            mySheet2.SetCountPosition(4);
			
            var sheetHeight = $('.wrapper').height() - $('#mySheetForm').height() - $('.sheet_title').outerHeight(true);
    		$(window).smartresize(sheetResize); sheetInit();
    		mySheet0.SetSheetHeight(sheetHeight);
    		mySheet1.SetSheetHeight(sheetHeight);
    		mySheet2.SetSheetHeight(sheetHeight);

            doAction("Search");

            // $(".close").click(function() {
            //     p.self.close();
            // });
        });

        /*Sheet Action*/
        function doAction(sAction) {
            switch (sAction) {
                case "Search": 		//조회
                    mySheet0.DoSearch( "${ctx}/PayAllowanceElementPropertyPopup.do?cmd=getPayAllowanceElementPropertyPopupListFirst", $("#mySheetForm").serialize() );
                    mySheet1.DoSearch( "${ctx}/PayAllowanceElementPropertyPopup.do?cmd=getPayAllowanceElementPropertyPopupListSecond", $("#mySheetForm").serialize() );
                    mySheet2.DoSearch( "${ctx}/PayAllowanceElementPropertyPopup.do?cmd=getPayAllowanceElementPropertyPopupListThird", $("#mySheetForm").serialize() );
                    break;
            }
        }

        // 	조회 후 에러 메시지
        function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if(Msg != "") alert(Msg);
                sheetResize();
            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        //  조회 후 에러 메시지
        function mySheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if(Msg != "") alert(Msg);
                sheetResize();

                // 수습적용율
                var att2CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00009",false).codeList, "");
                mySheet1.InitCellProperty(1,"attribute", {Type:"Combo", ComboCode:att2CmbList[1], ComboText:att2CmbList[0]});

                // 과세여부
                var att3CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00011",false).codeList, "");
                mySheet1.InitCellProperty(2,"attribute", {Type:"Combo", ComboCode:att3CmbList[1], ComboText:att3CmbList[0]});

                // 신입/복직일할계산
                var att5CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00013",false).codeList, "");
                mySheet1.InitCellProperty(3,"attribute", {Type:"Combo", ComboCode:att5CmbList[1], ComboText:att5CmbList[0]});

                // 퇴직당월일할계산
                mySheet1.InitCellProperty(4,"attribute", {Type:"Combo", ComboCode:att5CmbList[1], ComboText:att5CmbList[0]});

                // 발령관련일할계산
                mySheet1.InitCellProperty(5,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

                // 징계관련일할계산
                mySheet1.InitCellProperty(6,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

                // 근태관련일할계산
                mySheet1.InitCellProperty(7,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

                // 산재관련일할계산
                mySheet1.InitCellProperty(8,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

                // 연말정산필드
                mySheet1.InitCellProperty(9,"attribute", {Type:"Popup"});
                mySheet1.SetCellValue(9, "attribute", mySheet1.GetCellValue(9, 'attributeNm'));

                // 상여관련
                //var att6CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList&searchRunType=00002,00003",false).codeList, "");
                var att6CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00001",false).codeList, "");
                mySheet1.InitCellProperty(10,"attribute", {Type:"Combo", ComboCode:att6CmbList[1], ComboText:att6CmbList[0]});

            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }
    </script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
    <div class="modal_body">
        <form id="mySheetForm" name="mySheetForm">
            <input type="hidden" name="searchElemCd" id="searchElemCd" />
            <input type="hidden" name="searchSdate" id="searchSdate" />
            <div class="sheet_search outer">
                <div>
                    <table>
                        <tr>
                            <th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
                            <td>  <input id="searchElemNm" name ="searchElemNm" type="text" readonly class="text readonly" /> </td>
                            <!-- 						<td> -->
                            <!-- 							<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> -->
                            <!-- 						</td> -->
                        </tr>
                    </table>
                </div>
            </div>
        </form>
        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
            <colgroup>
                <col width="30%" />
                <col width="30%" />
                <col width="30%" />
            </colgroup>
            <tr>
                <td class="sheet_left">
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li class="txt"><tit:txt mid='103979' mdef='항목그룹1'/></li>
                            </ul>
                        </div>
                    </div>
                    <div id="mySheet0-wrap"></div>
                </td>
                <td class="sheet_left">
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li class="txt"><tit:txt mid='104370' mdef='항목그룹2'/></li>
                            </ul>
                        </div>
                    </div>
                    <div id="mySheet1-wrap"></div>
                </td>
                <td class="sheet_right">
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li class="txt"><tit:txt mid='104182' mdef='항목그룹3'/></li>
                            </ul>
                        </div>
                    </div>
                    <div id="mySheet2-wrap"></div>
                </td>
            </tr>
        </table>
    </div>
    <div class="modal_footer">
    	<btn:a href="javascript:closeCommonLayer('allowModal');" css="btn outline_gray" mid='110881' mdef="닫기"/>
    </div>
</div>
</body>
</html>



