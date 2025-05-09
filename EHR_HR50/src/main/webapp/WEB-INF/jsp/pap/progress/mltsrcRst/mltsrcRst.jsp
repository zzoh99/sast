<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>다면평가 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

    var appSeqCdList =""; 
    $(function() {
        var initdata = {}; 
        initdata.Cfg = {FrozenCol:10,SearchMode:smLazyLoad,Page:22,MergeSheet:msPrevColumnMerge + msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"삭제|삭제",        Type:"${sDelTy}",   Hidden:1,                   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",        Type:"${sSttTy}",   Hidden:1,                   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"No|No",     Type:"${sNoTy}",       Hidden:0, Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"대상자|사번",       Type:"Text",        Hidden:0,                   Width:60,          Align:"Center", ColMerge:1, SaveName:"sabun",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"대상자|성명",       Type:"Text",        Hidden:0,                   Width:60,          Align:"Center", ColMerge:1, SaveName:"name",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가자|사번",       Type:"Text",        Hidden:0,                   Width:60,          Align:"Center", ColMerge:1, SaveName:"appSabun",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가자|성명",       Type:"Text",        Hidden:0,                   Width:60,          Align:"Center", ColMerge:1, SaveName:"appName",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"차수|차수",        Type:"Text",        Hidden:0,                   Width:40,          Align:"Center", ColMerge:1, SaveName:"appSeqNm",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"조직명|조직명",       Type:"Text",        Hidden:0,                   Width:100,          Align:"Center", ColMerge:1, SaveName:"orgNm",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"역량명|역량명",       Type:"Text",        Hidden:0,         Width:100,          Align:"Center", ColMerge:1, SaveName:"ldsCompetencyNm",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"문항|문항",        Type:"Text",        Hidden:0,          Width:800,          Align:"Left", ColMerge:1, SaveName:"ldsCompBenm",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"척도|척도",        Type:"Text",        Hidden:0,                   Width:70,          Align:"Center", ColMerge:1, SaveName:"ldsResult",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"강점|강점",        Type:"Text",        Hidden:0,          Width:200,          Align:"Center", ColMerge:1, SaveName:"aComment",     Wrap:1, MultiLineText:1,     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"개선점|개선점",       Type:"Text",        Hidden:0,          Width:200,          Align:"Center", ColMerge:1, SaveName:"cComment",     Wrap:1, MultiLineText:1,     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"완료\n여부|완료\n여부",      Type:"Text",        Hidden:0,                   Width:30,          Align:"Center", ColMerge:0, SaveName:"ldsAppStatusCd",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	 
        sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
        sheet1.SetDataLinkMouse("detail",1); 

        appSeqCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00004"), "전체");
        sheet1.SetColProperty("appSeqCd",           {ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} ); 

        $(window).smartresize(sheetResize); sheetInit();

    });


    $(function() {

    	// 조회조건 이벤트 등록
        $("#searchAppraisalCd, #searchAppSeqCd").bind("change",function(event){
            doAction1("Search");
        });
 
    	
        $("#searchNameSabun, #searchAppOrgNm, #searchAppSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });

        //평가코드
        var appraisalCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&sysdateYn=Y","queryId=getCompAppraisalCdList",false).codeList, "");
        $("#searchAppraisalCd").html(appraisalCd[2]); 

        $("#searchAppSeqCd").html(appSeqCdList[2]);
        
        $("#searchAppraisalCd").change();

    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/MltsrcRst.do?cmd=getMltsrcRstList", $("#srchFrm").serialize() ); break;
        case "Save":
                            IBS_SaveName(document.srchFrm,sheet1);
                            sheet1.DoSave( "${ctx}/Template.do?cmd=saveTemplate", $("#srchFrm").serialize()); break;
        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
        case "Copy":        sheet1.DataCopy(); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param = {DownCols:downcol, SheetDesign:1, Merge:1};
            sheet1.Down2Excel(param);
        break;
        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if (Msg != ""){
                alert(Msg);
            }
            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try{
            if(Msg != ""){
                alert(Msg);
            }
            doAction1("Search");
        }catch(ex){
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    function sheet1_OnClick(Row, Col, Value) {
        try{
           
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td> <span class="w90">평가ID</span>     <select id="searchAppraisalCd" name="searchAppraisalCd"> </select> </td>
                        <td> <span class="w90">평가차수</span>   <select id="searchAppSeqCd"    name="searchAppSeqCd"> </select> </td>
                        <td> <span>피평가자 성명/사번</span>  <input  id="searchNameSabun"   name="searchNameSabun" type="text" class="text" /> </td>
                    </tr>
                    <tr>
                        <td> <span class="w90">평가소속</span>   <input  id="searchAppOrgNm"    name="searchAppOrgNm" type="text" class="text" /> </td>
                        <td> <span>평가자 성명/사번</span>  <input  id="searchAppSabunName"   name="searchAppSabunName" type="text" class="text" /> </td>
                        <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
                            <li id="txt" class="txt">다면평가 세부내역</li>
                            <li class="btn">
                                <%-- <a href="javascript:rdPopup();"    class="button authR">출력</a> --%>
                                <a href="javascript:doAction1('Down2Excel');"    class="basic authR">다운로드</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>