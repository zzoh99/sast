<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
    <base target="_self">
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <title>Quick Menu</title>
    <script type="text/javascript">
        /*Sheet 기본 설정 */
        $(function() {
            createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");
            createIBSheet3(document.getElementById('sheet2-wrap'), "sheet2", "100%", "100%", "${ssnLocaleCd}");

            var initdata = {};
            initdata.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22,ChildPage:5};
            initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
                {Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
                {Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd", 	UpdateEdit:0 },
                {Header:"<sht:txt mid='priorMenuCd' mdef='상위메뉴'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",	UpdateEdit:0 },
                {Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",		UpdateEdit:0 },
                {Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuSeq",		UpdateEdit:0 },
                {Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",				Type:"Combo",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"type",		UpdateEdit:0 },
                {Header:"<sht:txt mid='koKrV5' mdef='메뉴/프로그램명'/>",		Type:"Text",	Hidden:0,	Width:280,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",		UpdateEdit:0, TreeCol:1  },
                {Header:"<sht:txt mid='grpCd_V1193' mdef='권한코드'/>",			Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"grpCd",		UpdateEdit:0 },
                {Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>",			Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",		UpdateEdit:0 },
                {Header:"<sht:txt mid='searchSeqV2' mdef='조건검색코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	UpdateEdit:0 },
                {Header:"<sht:txt mid='searchDescV1' mdef='조건검색'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	UpdateEdit:0 },
                {Header:"<sht:txt mid='dataPrgType' mdef='적용권한'/>",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dataPrgType",	UpdateEdit:0 },
                {Header:"<sht:txt mid='dataPrgTypeV2' mdef='프로그램\n권한'/>",		Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	UpdateEdit:0 },
                {Header:"<sht:txt mid='cnt' mdef='ONEPAGE\nROWS'/>",	Type:"Int",		Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"cnt",			UpdateEdit:0 },
                {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",		Hidden:1,	Width:30,	Align:"Right",	ColMerge:0,	SaveName:"seq",			UpdateEdit:0 }
            ]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

            sheet1.SetColProperty("type", 			{ComboText:"메뉴|프로그램|조건검색|탭", 	ComboCode:"M|P|S|T"} );

            var initdata = {};
            initdata.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
                {Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
                {Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd", 	UpdateEdit:0 },
                {Header:"<sht:txt mid='priorMenuCd' mdef='상위메뉴'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",	UpdateEdit:0 },
                {Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",				Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",		UpdateEdit:0 },
                {Header:"<sht:txt mid='menuSeq_V2267' mdef='메뉴순번'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuSeq",		UpdateEdit:0 },
                {Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",			Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"grpCd",		UpdateEdit:0 },
                {Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>",			Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",		UpdateEdit:0 },
                {Header:"<sht:txt mid='prgNmV1' mdef='프로그램명'/>",			Type:"Text",		Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",		UpdateEdit:0 },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"delImg",		UpdateEdit:0, Cursor:"Pointer" },
                {Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",				Type:"Text",		Hidden:1,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"mySeq",		UpdateEdit:0 },
                {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",		Hidden:1,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"sabun",		UpdateEdit:0}

            ]; IBS_InitSheet(sheet2, initdata); sheet2.SetCountPosition(4);sheet2.SetEditableColorDiff (0);
            sheet2.SetImageList(0,"/common/images/icon/icon_x.png");

            //var menuList = convCodeIdx( ajaxCall("${ctx}/QuickMenu.do?cmd=getQuickMuComboList","",false).DATA,"",1);
            var menuList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getQuickMuComboList",false).codeList, "");
            $("#mainMenuCd").html(menuList[2]);

            $("#mainMenuCd").change(function(){
                changeIcon($("#mainMenuCd  option:selected").val());
                $("#mainMenuNm").val($("#mainMenuCd  option:selected").text());
                doAction1("Search");
            });

            $("#mainMenuNm").val( $("#mainMenuCd option:selected").text() );
            sheetInit();

            $("#btnPlus").click(function() {
                sheet1.ShowTreeLevel(-1);
            });

            $("#btnStep1").click(function()	{
                sheet1.ShowTreeLevel(0, 1);
            });

            $("#btnStep2").click(function()	{
                sheet1.ShowTreeLevel(1,2);
            });

            $("#btnStep3").click(function()	{
                sheet1.ShowTreeLevel(-1);
            });

            // sheet 높이 계산
            let sheetHeight = $(".modal_body").height() - $("#sheet1Form").height() - $(".sheet_title").height() - 2;
            sheet1.SetSheetHeight(sheetHeight);
            sheet2.SetSheetHeight(sheetHeight);

            changeIcon($("#mainMenuCd  option:selected").val());
            doAction1("Search");
            doAction2("Search");
        });


        //Sheet Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search": 	 	sheet1.DoSearch( "${ctx}/QuickMenu.do?cmd=getQuickMuPrgList", $("#sheet1Form").serialize() ); break;

            }
        }


        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try{if (Msg != ""){alert(Msg);}}catch(ex){alert("OnSearchEnd Event Error : " + ex);}

        }


        function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
            if(Row > 0 && sheet2.ColSaveName(Col) == "delImg"){

                if(confirm("퀵메뉴를 삭제하시겠습니까?")){
                    sheet2.SetCellValue(Row,"sDelete","1");
                    doAction2("Save");
                }
                else {
                    sheet2.SetCellValue(Row,"sDelete","0");
                }

            }
        }


        //Sheet Action
        function doAction2(sAction) {
            switch (sAction) {
                case "Search": 	 	sheet2.DoSearch( "${ctx}/QuickMenu.do?cmd=tsys333SelectMyQuickMenuList", $("#sheet1Form").serialize() ); break;

                case "Save":
                    IBS_SaveName(document.sheet1Form,sheet2);
                    sheet2.DoSave( "${ctx}/QuickMenu.do?cmd=saveQuickMenu", $("#sheet1Form").serialize() );
                    // setTimeout(async () => {
                    //     closeQuickMenuLayer();
                    // }, 1000);
                    break;


                case "Insert":      //입력

                    var Row = sheet2.DataInsert(0);

                    sheet2.SetCellValue(Row,"sabun",		"${ssnSabun}");
                    sheet2.SetCellValue(Row,"mainMenuCd",	sheet1.GetCellValue(sheet1.GetSelectRow(),"mainMenuCd"));
                    sheet2.SetCellValue(Row,"priorMenuCd",	sheet1.GetCellValue(sheet1.GetSelectRow(),"priorMenuCd"));
                    sheet2.SetCellValue(Row,"menuCd",		sheet1.GetCellValue(sheet1.GetSelectRow(),"menuCd"));
                    sheet2.SetCellValue(Row,"menuSeq",		sheet1.GetCellValue(sheet1.GetSelectRow(),"menuSeq"));
                    sheet2.SetCellValue(Row,"grpCd",		sheet1.GetCellValue(sheet1.GetSelectRow(),"grpCd"));
                    sheet2.SetCellValue(Row,"prgCd",		sheet1.GetCellValue(sheet1.GetSelectRow(),"prgCd"));
                    sheet2.SetCellValue(Row,"menuNm",		sheet1.GetCellValue(sheet1.GetSelectRow(),"menuNm"));
                    sheet2.SetCellValue(Row,"seq",			"0");

                    doAction2("Save");

                    break;


            }
        }


        //조회 후 에러 메시지
        function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try{if (Msg != ""){alert(Msg);}}catch(ex){alert("OnSearchEnd Event Error : " + ex);}

        }

        //조회 후 에러 메시지
        function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try{if (Msg != ""){alert(Msg);}doAction2("Search");}catch(ex){alert("OnSaveEnd Event Error : " + ex);}

        }

        function changeIcon(value) {
            $("#menu_logo div").attr("class","");
            $("#menu_logo div").addClass("pos"+value);
        }



        function goSave(){

            if(sheet1.GetCellValue(sheet1.GetSelectRow(),"type") == "P" || sheet1.GetCellValue(sheet1.GetSelectRow(),"type") == "S"){
                menuSeq = sheet1.GetCellValue(sheet1.GetSelectRow(),"menuSeq");
                var chk = "Y";
                if(sheet2.RowCount() > 0){

                    for(var i=1; i <= sheet2.LastRow(); i++){
                        if(menuSeq == sheet2.GetCellValue(i,"menuSeq")){
                            alert("<msg:txt mid='110100' mdef='이미 등록된 프로그램입니다. 삭제후 등록해 주십시요.'/>");
                            chk = "N";
                            break;
                        }
                    }
                }
                if(chk != "Y"){
                    return;
                }
                else {
                    doAction2("Insert");
                }
            }
            else {
                alert("프로그램만 등록 가능합니다.");
                return;
            }
        }





        function goUpDown(gubun){

            if(sheet2.RowCount() > 0){
                var mySeq 		= sheet2.GetCellValue(sheet2.GetSelectRow(),"mySeq");
                var menuNm 		= sheet2.GetCellValue(sheet2.GetSelectRow(),"menuNm");
                var mainMenuCd 	= sheet2.GetCellValue(sheet2.GetSelectRow(),"mainMenuCd");
                var priorMenuCd = sheet2.GetCellValue(sheet2.GetSelectRow(),"priorMenuCd");
                var menuCd 		= sheet2.GetCellValue(sheet2.GetSelectRow(),"menuCd");
                var menuSeq 	= sheet2.GetCellValue(sheet2.GetSelectRow(),"menuSeq");
                var grpCd 		= sheet2.GetCellValue(sheet2.GetSelectRow(),"grpCd");

                var cnt = 0;
                if(gubun == "up"){
                    for(var i=sheet2.RowCount(); i >= 1; i--){
                        if(Number(mySeq) > Number(sheet2.GetCellValue(i,"mySeq"))){
                            cnt = i;
                            break;
                        }
                    }
                }
                else if(gubun == "down"){
                    for(var i=1; i <= sheet2.RowCount(); i++){
                        if(Number(mySeq) < Number(sheet2.GetCellValue(i,"mySeq"))){
                            cnt = i;
                            break;
                        }
                    }
                }



                if(cnt != 0){
                    sheet2.SetCellValue(sheet2.GetSelectRow(),"mySeq",	 	mySeq );
                    sheet2.SetCellValue(sheet2.GetSelectRow(),"menuNm", 	sheet2.GetCellValue(cnt,"menuNm") );
                    sheet2.SetCellValue(sheet2.GetSelectRow(),"mainMenuCd",	sheet2.GetCellValue(cnt,"mainMenuCd") );
                    sheet2.SetCellValue(sheet2.GetSelectRow(),"priorMenuCd",sheet2.GetCellValue(cnt,"priorMenuCd") );
                    sheet2.SetCellValue(sheet2.GetSelectRow(),"menuCd",		sheet2.GetCellValue(cnt,"menuCd") );
                    sheet2.SetCellValue(sheet2.GetSelectRow(),"menuSeq",	sheet2.GetCellValue(cnt,"menuSeq") );
                    sheet2.SetCellValue(sheet2.GetSelectRow(),"grpCd",		sheet2.GetCellValue(cnt,"grpCd") );


                    sheet2.SetCellValue(cnt,"mySeq", 		sheet2.GetCellValue(cnt,"mySeq"));
                    sheet2.SetCellValue(cnt,"menuNm",		menuNm);
                    sheet2.SetCellValue(cnt,"mainMenuCd", 	mainMenuCd);
                    sheet2.SetCellValue(cnt,"priorMenuCd", 	priorMenuCd);
                    sheet2.SetCellValue(cnt,"menuCd", 		menuCd);
                    sheet2.SetCellValue(cnt,"menuSeq", 		menuSeq);
                    sheet2.SetCellValue(cnt,"grpCd", 		grpCd);

                    sheet2.SelectCell(cnt,"menuNm");
                }

            }
        }

        function closeQuickMenuLayer() {
            const modal = window.top.document.LayerModalUtility.getModal('quickMenuLayer');
            modal.fire('quickMenuLayerTrigger', {}).hide();
        }

    </script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <div class="sheet_search outer">
            <div>
                <form id="sheet1Form" name="sheet1Form" >
                    <input type="hidden" id="mainMenuNm" name="mainMenuNm"/>
                    <table>
                        <tr>
                            <th><tit:txt mid='113332' mdef='메인메뉴'/></th>
                            <td>
                                <select id="mainMenuCd" name="mainMenuCd"></select>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>

        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
            <colgroup>
                <col width="60%" />
                <col width="43px" />
                <col width="40%" />
            </colgroup>
            <tr>
                <td class="sheet_left">
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li class="txt"><strong><tit:txt mid='104233' mdef='메뉴명'/></strong></li>
                                <li class="btn">
                                    <div class="util sheet_util">
                                        <ul>
                                            <li id="btnStep1"></li>
                                            <li id="btnStep2"></li>
                                            <li id="btnStep3"></li>
                                        </ul>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div id="sheet1-wrap"></div>
                </td>
                <td class="sheet_arrow">
                    <div id="menu_logo hide">
                        <div></div>
                    </div>
                    <a href="javascript:goSave();" class="btn filled">이동</a>
                </td>

                <td class="sheet_right">
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li class="txt"><strong>Quick Menu</strong></li>
                                <li class="btn">
                                    <a href="javascript:goUpDown('up');"  class="btn outline-gray">▲</a>
                                    <a href="javascript:goUpDown('down');"  class="btn outline-gray">▼</a>
                                    <btn:a href="javascript:doAction2('Save')"  css="btn filled" mid='110708' mdef="저장"/>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div id="sheet2-wrap"></div>
                </td>
            </tr>
        </table>
    </div>
    <div class="modal_footer ">
        <btn:a href="javascript:closeQuickMenuLayer()" css="btn outline_gray" mid='110881' mdef="닫기"/>
    </div>
</div>
</body>
</html>
