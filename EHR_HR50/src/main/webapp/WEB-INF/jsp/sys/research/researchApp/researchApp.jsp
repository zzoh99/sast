<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

    $(function() {

        var initdata = {};
        initdata.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",      Type:"${sNoTy}", Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo"},
            {Header:"<sht:txt mid='sDelete' mdef='삭제'/>",    Type:"${sDelTy}",  Hidden:1,                   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='statusCd' mdef='상태'/>",    Type:"${sSttTy}",  Hidden:1,                   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"<sht:txt mid='researchSeq' mdef='설문지순번'/>",    Type:"Text",        Hidden:1,   Width:0,        Align:"Center", ColMerge:0, SaveName:"researchSeq",     KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='noticeLvl' mdef='조사레벨'/>",      Type:"Text",        Hidden:1,   Width:70,       Align:"Center", ColMerge:0, SaveName:"noticeLvl",       KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='researchNm_V1' mdef='설문지'/>",        Type:"Text",        Hidden:0,   Width:200,      Align:"Left",   ColMerge:0, SaveName:"researchNm",      KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='detail1_V3285' mdef='설문작성'/>",      Type:"Image",       Hidden:0,   Width:30,       Align:"Center", ColMerge:0, SaveName:"detail1",         Sort:0, Cursor:"Pointer" },
            {Header:"<sht:txt mid='detail2_V681' mdef='결과확인'/>",      Type:"Image",       Hidden:0,   Width:30,       Align:"Center", ColMerge:0, SaveName:"detail2",         Sort:0, Cursor:"Pointer" },
            {Header:"<sht:txt mid='repYn' mdef='답변여부'/>",      Type:"Text",        Hidden:0,   Width:30,       Align:"Center", ColMerge:0, SaveName:"answerYn",        KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='memoV6' mdef='설명'/>",          Type:"Image",       Hidden:1,   Width:0,        Align:"Center", ColMerge:0, SaveName:"desc",            Sort:0, Cursor:"Pointer" },
            {Header:"<sht:txt mid='memoV4' mdef='메모'/>",          Type:"Text",        Hidden:1,   Width:0,        Align:"Center", ColMerge:0, SaveName:"memo",            KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='researchSymd' mdef='설문시작일'/>",    Type:"Date",        Hidden:0,   Width:60,       Align:"Center", ColMerge:0, SaveName:"researchSymd",    KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='researchEymd' mdef='설문종료일'/>",    Type:"Date",        Hidden:0,   Width:60,       Align:"Center", ColMerge:0, SaveName:"researchEymd",    KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='signYn_V1618' mdef='기명여부'/>",      Type:"Text",        Hidden:1,   Width:60,       Align:"Center", ColMerge:0, SaveName:"signYn",          KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='openYn' mdef='공개여부'/>",      Type:"Text",        Hidden:0,   Width:40,       Align:"Center", ColMerge:0, SaveName:"openYnNm",        KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='openYn_V874' mdef='공개여부코드'/>",  Type:"Text",        Hidden:1,   Width:40,       Align:"Center", ColMerge:0, SaveName:"openYn",          KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='stateCdNm' mdef='진행상태   '/>",   Type:"Text",        Hidden:0,   Width:40,       Align:"Center", ColMerge:0, SaveName:"stateCdNm",       KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='statusCdV4' mdef='진행상태코드'/>",  Type:"Text",        Hidden:1,   Width:60,       Align:"Center", ColMerge:0, SaveName:"stateCd",         KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='seqNo' mdef='파일순번'/>",      Type:"Text",        Hidden:1,   Width:30,       Align:"Center", ColMerge:0, SaveName:"fileSeq",         KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='noticeYn' mdef='공지여부'/>",      Type:"Text",        Hidden:1,   Width:30,       Align:"Center", ColMerge:0, SaveName:"noticeYn",        KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
        sheet1.SetImageList(1,"/common/images/icon/icon_popup.png");
//      sheet2.SetImageList(1,"/common/images/icon/icon_o.png");
//      sheet2.SetImageList(2,"/common/images/icon/icon_x.png");

        $(window).smartresize(sheetResize);
        sheetInit();
        doAction1("Search");
        $("#researchNm").bind("keyup",function(e){
            if(e.keyCode==13)doAction1("Search");
        });

        $( "#progressbar" ).progressbar({
            value: 37
        });

    });

    //Sheet Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":  sheet1.DoSearch( "${ctx}/ResearchApp.do?cmd=getResearchAppList", $("#sheetForm").serialize() ); break;
        //case "Save":
        //              IBS_SaveName(document.sheetForm,sheet1);
        //              sheet1.DoSave("${ctx}/ResearchApp.do?cmd=saveResearchApp" , $("#sheetForm").serialize());  break;
        case "Insert":  sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
        }
    }

    function doAction2(sAction) {
        switch (sAction) {
        case "Search":
            $("#rsSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
            sheet2.DoSearch( "${ctx}/ResearchApp.do?cmd=getResearchAppDetailList", $("#sheetForm").serialize());
            break;
        case "Save":
//          if(sheet2.FindStatusRow("I|U") != ""){
//              if(!dupChk(sheet2,"questionSeq", true, true)){break;}
//          }
            $("#rsSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
        //  IBS_SaveName(document.sheetForm,sheet2);
         //   sheet2.DoSave("${ctx}/ResearchApp.do?cmd=saveResearchAppDetail", $("#sheetForm").serialize() );
            break;
        case "Insert":
            var iRow = sheet2.DataInsert(sheet2.LastRow()+1);
            sheet2.SelectCell(iRow, 4);
            sheet2.SetCellImage(iRow,"detail",1);
            sheet2.SetCellValue(iRow, "researchSeq",sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
            break;
        case "Copy":
            var cRow = sheet2.DataCopy();
            sheet2.SetCellValue(cRow, "questionSeq","");
            break;

        }
    }

    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    function sheet1_OnClick(Row, Col, Value){
        try{
            if(Row < 1) return;
            if(sheet1.ColSaveName(Col) == "detail1"){
                if(sheet1.GetCellImage(Row,"detail1")!= "") {
                	researchAppDetail1Popup(Row);
                	/*
                    if(sheet1.GetCellValue(Row,"answerYn")!="Y") {
                    	researchAppDetail1Popup(Row);
                    } else {
                        alert("<msg:txt mid='109643' mdef='이미 설문에 응하셨습니다.'/>");
                    }*/
                }
            }else if(sheet1.ColSaveName(Col) == "detail2"){
                if(sheet1.GetCellImage(Row,"detail2")!= ""){
                    if(sheet1.GetCellValue(Row,"openYn")!="Y") {
                        alert("<msg:txt mid='109471' mdef='비공개 설문입니다.'/>");
                    } else {
                        researchAppDetail2Popup(Row);
                    }
                }
            }
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }
    function sheet2_OnChange(Row, Col, Value){
        try{
            if(Row < 1) return;
            if( sheet2.ColSaveName(Col) != "questionItemCd") return;
            if(Value == "30") sheet2.SetCellImage(Row,"detail",2);
            else sheet2.SetCellImage(Row,"detail",1);
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }
    function researchAppDetail1Popup(Row){
        if(!isPopup()) {return;}
        var w       = 1040;
        var h       = 700;
        var url     = "${ctx}/ResearchApp.do?cmd=researchAppWriteLayer&authPg=${authPg}";

        gPRow = Row;
        pGubun = "researchAppWritePopup";

        var p = {
            researchSeq : sheet1.GetCellValue(Row,"researchSeq"),
            researchNm : sheet1.GetCellValue(Row,"researchNm"),
            memo : sheet1.GetCellValue(Row,"memo"),
            fileSeq : sheet1.GetCellValue(Row,"fileSeq")
        }

        // openPopup(url,args,w,h);

        // 시트방식
        /*
        var researchAppWriteLayer = new window.top.document.LayerModal({
            id: 'researchAppWriteLayer',
            url: url,
            parameters: p,
            width: w,
            height: h,
            title: '설문작성',
            trigger: [
                {
                    name: 'researchAppWriteLayerTrigger',
                    callback: function(rv) {
                        getReturnValue(rv);
                    }
                }
            ]
        });

        researchAppWriteLayer.show();
        */

        // form방식
        let researchAppWriteFormLayer = new window.top.document.LayerModal({
            id: 'researchAppWriteFormLayer',
            url: '${ctx}/ResearchApp.do?cmd=researchAppWriteFormLayer&authPg=${authPg}',
            parameters: p,
            width: w,
            height: h,
            title: '설문작성',
            trigger: [
                {
                    name: 'researchAppWriteFormTrigger',
                    callback: function(rv) {
                        doAction1("Search");
                    }
                }
            ]
        });

        researchAppWriteFormLayer.show();

    }

    function researchAppDetail2Popup(Row){
        if(!isPopup()) {return;}
        var w       = 1040;
        var h       = 780;
        var url     = "${ctx}/ResearchApp.do?cmd=researchAppResultLayer&authPg=${authPg}";

        gPRow = Row;
        pGubun = "researchAppResultPopup";

        var p =  {
            researchSeq : sheet1.GetCellValue(Row,"researchSeq"),
            researchNm : sheet1.GetCellValue(Row,"researchNm")
        };

        // openPopup(url,args,w,h);
        var researchAppResultLayer = new window.top.document.LayerModal({
            id: 'researchAppResultLayer',
            url: url,
            parameters: p,
            width: w,
            height: h,
            title: '설문조사 결과확인',
            trigger: [
                {
                    name: 'researchAppResultLayerTrigger',
                    callback: function(rv) {
                        getReturnValue(rv);
                    }
                }
            ]
        });

        researchAppResultLayer.show();
    }
    var gPRow = "";
    var pGubun = "";

    //팝업 콜백 함수.
    function getReturnValue(returnValue) {
        if(pGubun == "researchAppWritePopup"){
            doAction1("Search");
        } else if(pGubun == "researchAppResultPopup") {
        }
    }

</script>
</head>
<body class="bodywrap">

<div class="wrapper">

    <form id="sheetForm" name="sheetForm">
        <input id="rsSeq" name="rsSeq" type="hidden" />
        <div class="sheet_search outer">
            <div>
            <table>
                <tr>
                    <th><tit:txt mid='104133' mdef='설문지명'/></th>
                    <td>
                        <input id="researchNm" name="researchNm" type="text" class="text w200" />
                    </td>
                    <td>
                        <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
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
                            <li class="txt"><tit:txt mid='104427' mdef='설문지 '/></li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
