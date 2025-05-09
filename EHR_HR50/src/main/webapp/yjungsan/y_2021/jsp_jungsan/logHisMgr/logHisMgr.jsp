<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>로그내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var bFlag = false;
    $(function() {
    	//엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
    	$("#searchYear").val("<%=yeaYear%>") ;

        $("#searchFromYmd").val(<%=curSysYyyyMMdd%>);
        $("#searchToYmd").val(<%=curSysYyyyMMdd%>);
        $("#searchFromYmd").mask("1111-11-11") ;   $("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
        $("#searchToYmd").mask("1111-11-11") ;   $("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",        Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"SEQ",       Type:"Text",    Hidden:1, Width:20,   Align:"Center",   ColMerge:1,   SaveName:"seq",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"회사",       Type:"Text",   Hidden:1, Width:20,    Align:"Center", ColMerge:1,   SaveName:"enter_cd",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"사번",       Type:"Text",   Hidden:0, Width:20,    Align:"Center", ColMerge:1,   SaveName:"sabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"성명",       Type:"Text",   Hidden:0, Width:20,    Align:"Center", ColMerge:1,  SaveName:"name",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"실행구분",    Type:"Text",   Hidden:0, Width:30,    Align:"Center", ColMerge:1,  SaveName:"log_type",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"메뉴명",     Type:"Text",    Hidden:0, Width:50,   Align:"Center", ColMerge:1,   SaveName:"menu_nm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"서비스명",    Type:"Text",   Hidden:0, Width:60,    Align:"Center", ColMerge:1,   SaveName:"cmd",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"사유",       Type:"Text",    Hidden:0, Width:200,  Align:"Left",   ColMerge:1,   SaveName:"log_reason", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"작업내용",    Type:"Text",   Hidden:0, Width:200,   Align:"Left", ColMerge:1,     SaveName:"log_memo",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"작업자\n사번",    Type:"Text",   Hidden:0, Width:20,    Align:"Center", ColMerge:1,   SaveName:"chkid",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"작업자\n성명",    Type:"Text",   Hidden:0, Width:20,    Align:"Center", ColMerge:1,   SaveName:"chkname",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0},
            {Header:"작업일자",    Type:"Text",   Hidden:0, Width:40,    Align:"Center", ColMerge:1,   SaveName:"chkdate",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0}

        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var logYn     = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_LOG_YN", "queryId=getSystemStdData",false).codeList;
        var fileLogYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_FILE_LOG_YN", "queryId=getSystemStdData",false).codeList;
        var rdLogYn   = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_RD_LOG_YN", "queryId=getSystemStdData",false).codeList;

        $("#searchLogTypeCd").append("<option value=''>전체</option>");

        $("#searchLogTypeCd").append("<option value='J'>작업</option>");

        if(logYn[0].code_nm == "Y"){
            $("#searchLogTypeCd").append("<option value='R'>조회</option>");
            $("#searchLogTypeCd").append("<option value='I'>입력</option>");
            $("#searchLogTypeCd").append("<option value='U'>수정</option>");
            $("#searchLogTypeCd").append("<option value='D'>삭제</option>");
        }
        if(fileLogYn[0].code_nm == "Y"){
	        $("#searchLogTypeCd").append("<option value='E'>엑셀다운로드</option>");
	        $("#searchLogTypeCd").append("<option value='F'>파일다운로드</option>");
        }
        if(rdLogYn[0].code_nm == "Y"){
            $("#searchLogTypeCd").append("<option value='P'>출력물인쇄</option>");
        }
        $(window).smartresize(sheetResize);sheetInit();
    });

    $(function() {
        $("#searchMenuNm,#searchServiceNm,#searchYear,#searchLogMemo,#searchSbNm,#searchChkNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
                $(this).focus();
            }
        });
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	if(!searchValChk()){
	            sheet1.DoSearch( "<%=jspPath%>/logHisMgr/logHisMgrRst.jsp?cmd=selectSavLogList", $("#sheetForm").serialize() );
	            break;
        	}else{
        		alert("전체일 경우에는 검색 조건을 하나라도 입력해주세요.");
        		break;
        	}
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param   = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
            sheet1.Down2Excel(param);
            break;
        }
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize();
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    function searchValChk(){
    	var valChk = false;
    	if($("#searchLogTypeCd").val() == "" && $("#searchMenuNm").val()  == ""
    	&& $("#searchServiceNm").val() == "" && $("#searchLogMemo").val() == "" && $("#searchSbNm").val() == "" && $("#searchChkNm").val() == ""){
    		valChk = true;
    	}
        return valChk;
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
            <tr>
                <td>
                    <span>년도</span>
                    <input id="searchYear" name ="searchYear" type="text" class="text center" maxlength="4" style="width:35px"/>
                </td>
                <td>
	                <span>작업일자</span>
                    <input id="searchFromYmd" name="searchFromYmd" type="text" class="date2" onFocus="this.select()" value="" maxlength="20" />
                    ~
                    <input id="searchToYmd" name="searchToYmd" type="text" class="date2" onFocus="this.select()" value="" maxlength="20" />
	            </td>
                <td>
                    <span>실행구분</span>
                    <select id="searchLogTypeCd" name ="searchLogTypeCd" class="box" onchange="javascript:doAction1('Search');"></select>
                </td>
            </tr>
            <tr>
                <td>
                    <span>메뉴명</span>
                    <input id="searchMenuNm" name ="searchMenuNm" type="text" class="text" maxlength="30" style="width:150px"/>
                </td>
                <td>
                    <span>서비스명</span>
                    <input id="searchServiceNm" name ="searchServiceNm" type="text" class="text" maxlength="30" style="width:150px"/>
                </td>
                <td>
                    <span>작업내용</span>
                    <input id="searchLogMemo" name ="searchLogMemo" type="text" class="text" maxlength="30" style="width:200px"/>
                </td>
            </tr>
            <tr>
                <td>
                    <span>사번/성명</span>
                    <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="30" style="width:100px"/>
                </td>
                <td>
                    <span>작업자 사번/성명</span>
                    <input id="searchChkNm" name ="searchChkNm" type="text" class="text" maxlength="30" style="width:100px"/>
                </td>
                <td>
                    <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                </td>
            </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">로그내역관리</li>
            <li class="btn">
            	<font class='blue'>[기부금이월자료업로드는 대상년도-1로 검색]&nbsp;&nbsp;&nbsp;[데이터가 많을경우 검색조건을 하나라도 입력 후 조회해주시기 바랍니다.]</font>
                <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>