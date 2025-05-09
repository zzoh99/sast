<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

    $(function() {

        $("#searchDate").datepicker2();

        var initdata = {};
        initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",               	Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",              Type:"${sDelTy}",   Hidden:1,Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",              Type:"${sSttTy}",   Hidden:1,Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",             	Type:"Text",        Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sabun",       	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",             	Type:"Popup",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"name",        	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"호칭|호칭",             	Type:"Text",       Hidden:Number("${aliasHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"alias",        	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='jikgubCdV1' mdef='직급|직급'/>",             	Type:"Text",        Hidden:Number("${jgHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",    	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",             	Type:"Text",        Hidden:Number("${jwHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",    	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='orgNm_V2812' mdef='부서|부서'/>",				Type:"Text",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:0,	  SaveName:"orgNm",			KeyField:0,	  Format:"",						PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"<sht:txt mid='baseSeq' mdef='시스템|직제\n순서'/>",   		Type:"Int",      	Hidden:0,  Width:30,  Align:"Center",  ColMerge:0,   SaveName:"baseSeq",    	KeyField:0,   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='baseJikjeSort' mdef='시스템|직제SEQ'/>",       	Type:"Text",     	Hidden:0,  Width:200,  Align:"Center",  ColMerge:0,   SaveName:"baseJikjeSort", KeyField:0,   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='exJikjeSort_V1' mdef='예외직제SEQ|예외직제SEQ'/>",  Type:"Text",     	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"exJikjeSort",   KeyField:0,   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='realSeq' mdef='최종|직제\n순서'/>",   		Type:"Int",      	Hidden:0,  Width:30,  Align:"Center",  ColMerge:0,   SaveName:"realSeq",    	KeyField:0,   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='realJikjeSort' mdef='최종|직제SEQ'/>",       	Type:"Text",     	Hidden:0,  Width:200,  Align:"Center",  ColMerge:0,   SaveName:"realJikjeSort", KeyField:0,   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='sDate' mdef='시작일자|시작일자'/>",		Type:"Date",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:0,	  SaveName:"sdate",			KeyField:0,	  Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"<sht:txt mid='edateV7' mdef='종료일자|종료일자'/>",		Type:"Date",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:0,	  SaveName:"edate",			KeyField:0,	  Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",             		Type:"Text",        Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"bigo",        	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        $("#searchSabun, #searchOrg").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	if($("#searchDate").val() == ""){
        		alert("<msg:txt mid='109901' mdef='기준일자를 입력하세요.'/>");
        		return;
        	}
        	sheet1.DoSearch( "${ctx}/JikjeExceptionMgr.do?cmd=getJikjeExceptionMgrList", $("#srchFrm").serialize() ); break;
        case "Save":
                            if (!dupChk(sheet1, "sabun|sdate", false, true)) {break;}
                            IBS_SaveName(document.srchFrm,sheet1);
                            sheet1.DoSave( "${ctx}/JikjeExceptionMgr.do?cmd=saveJikjeExceptionMgr", $("#srchFrm").serialize()); break;
        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), "name"); break;
        case "Copy":        sheet1.DataCopy(); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
            sheet1.Down2Excel(param);
             break;
        break;

        case "LoadExcel":

            var params = {Mode:"HeaderMatch", WorkSheetNo:1};
            sheet1.LoadExcel(params);
            break;

        case "DownTemplate":

        	var templeteTitle1 = "업로드시 이 행은 삭제 합니다";
            templeteTitle1 += "\n날짜형식은 하이픈('-')을 입력하여 주시기 바랍니다.(ex: 2015-12)";

            sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"sabun|exJikjeSort|sdate|edate|bigo"
            ,TitleText:templeteTitle1,UserMerge :"0,0,1,7"
            });

            break;
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

    // 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY
            if (Shift == 1 && KeyCode == 45) {
                doAction1("Insert");
            }
            //Delete KEY
            if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
                sheet1.SetCellValue(Row, "sStatus", "D");
            }
        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }




//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);

          if(colName == "name") {

              if(!isPopup()) {return;}

              sheet1.SelectCell(Row,"name");

              gPRow = Row;
              pGubun = "employeePopup";

              openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "840","520");

          }
        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

  //팝업 콜백 함수.
    function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup") {
            sheet1.SetCellValue(gPRow, "sabun",rv["sabun"]);
            sheet1.SetCellValue(gPRow, "name",rv["name"]);
            sheet1.SetCellValue(gPRow, "alias",rv["alias"]);
            sheet1.SetCellValue(gPRow, "orgNm",rv["orgNm"]);
            sheet1.SetCellValue(gPRow, "jikgubNm",rv["jikgubNm"]);
            sheet1.SetCellValue(gPRow, "jikweeNm",rv["jikweeNm"]);
        }

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
                    	<th><tit:txt mid='113520' mdef='기준일 '/></th>
                        <td>    <input id="searchDate" name="searchDate" type="text" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"></td>
                        <th><tit:txt mid='104330' mdef='사번/성명'/></th>
                        <td>  <input id="searchSabun" name ="searchSabun" type="text" class="text" /> </td>
                        <th><tit:txt mid='113316' mdef='부서명'/></th>
                        <td>     <input type="text" id="searchOrg" name="searchOrg" class="text"/></td>
                        <td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
                            <li id="txt" class="txt">직제순서확인</li>
                            <li class="btn">
                            	<%--
                                <btn:a href="javascript:doAction1('DownTemplate')" css="basic authA" mid='110702' mdef="양식다운로드"/>
                                <btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction1('Copy')"  css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction1('Save')"  css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction1('LoadExcel')"     css="basic authA" mid='110703' mdef="업로드"/>
                                --%>
                                <a href="javascript:doAction1('Down2Excel')"    class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
