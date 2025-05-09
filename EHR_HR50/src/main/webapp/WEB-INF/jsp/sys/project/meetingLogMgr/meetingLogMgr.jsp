<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
    var gPRow = "";
    var pGubun = "";
    var cModuleCd;
    $(function() {
        cModuleCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrModuleCdList",false).codeList, "");
        $("#cModuleCd").html("<option value='ALL'>전체</option>"+cModuleCd[2]);

        $("input[name='chk_all']").click(function () {
            var chk_listArr = $("input[name='chk_list']");
            for (var i=0; i < chk_listArr.length; i++) {
                chk_listArr[i].checked = this.checked;
            }
        });

        $("input[name='chk_list']").click(function () { //리스트 항목이 모두 선택되면 전체 선택 체크
            if ($("input[name='chk_list']:checked").length == 3) {
                $("input[name='chk_all']")[0].checked = true;
            } else  {                                                //리스트 항목 선택 시 전체 선택 체크를 해제함
                $("input[name='chk_all']")[0].checked = false;
            }
        });

        $("#searchWord").bind("keyup",function(event){

            if( event.keyCode == 13 ){
                checkSelectedValue();
                doAction1("Search");
                $(this).focus();
            }
        });

        initSheet();
    });

    function initSheet() {
        var contactYn = 1;
        if("${map.contactYn}" == "Y" ){contactYn =0;}

        //공지사항유무에 따라  공지시작일, 종료일을 보여주거나 감춘다.
        var notiYn = 1;
        if("${map.notifyYn}" == "Y" ){notiYn=0;}

        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"Text",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"rn" , UpdateEdit:0},
            {Header:"<sht:txt mid='bbsNmV1' mdef='게시판명'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"bbsNm", UpdateEdit:0 },
            {Header:"<sht:txt mid='title' mdef='제목'/>",		Type:"Html",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"title", UpdateEdit:0 },
            {Header:"<sht:txt mid='chargeNameV2' mdef='담당자'/>",		Type:"Text",	Hidden:contactYn,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"contact", UpdateEdit:0 },
            {Header:"<sht:txt mid='fileCnt' mdef='파일'/>",		Type:"Image",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"fileCnt", UpdateEdit:0 },
            {Header:"<sht:txt mid='regDate' mdef='작성일시'/>",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"regDate", UpdateEdit:0 },
            {Header:"<sht:txt mid='writer' mdef='작성자'/>",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"writer", UpdateEdit:0 },
            {Header:"B",		Type:"Text",	Hidden:1,	Width:45,	Align:"Left",	ColMerge:0,	SaveName:"burl", UpdateEdit:0 },
            {Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"bbsCd", UpdateEdit:0 },
            {Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"bbsSeq", UpdateEdit:0 },
            {Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"priorBbsSeq", UpdateEdit:0 },
            {Header:"",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"masterBbsSeq", UpdateEdit:0 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"등록",	Type:"CheckBox",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y",	FalseValue:"N" },
            {Header:"모듈",		Type:"Combo",		Hidden:0,						Width:50,	Align:"Center",	ColMerge:0,	SaveName:"moduleCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"상위메뉴명",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorMenuNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"상위메뉴코드",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorMenuCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"메뉴명",		Type:"Text",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"menuNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"메뉴코드",		Type:"Text",		Hidden:1,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"menuCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
        ]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
        sheet2.SetColProperty("moduleCd", 		{ComboText:"|"+cModuleCd[0], 		ComboCode:"|"+cModuleCd[1]} );

        $("#searchName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        $(window).smartresize(sheetResize); sheetInit();
        sheet2.SetFocusAfterProcess(0);
        doAction1("Search");

        //Autocomplete
        $(sheet2).sheetAutocomplete({
            Columns: [
                {
                    ColSaveName  : "name",
                    CallbackFunc : function(returnValue){
                        var rv = $.parseJSON('{' + returnValue+ '}');
                        sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"]);
                        sheet2.SetCellValue(gPRow, "name",		rv["name"]);
                        sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
                        sheet2.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
                        sheet2.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
                        sheet2.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
                        sheet2.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
                        sheet2.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
                        sheet2.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
                        sheet2.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
                    }
                }
            ]
        });
    }

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                sheet1.DoSearch( "${ctx}/Board.do?cmd=getBoardList", $("#srchFrm").serialize() );
                break;
            case "Insert":
                $("#saveType").val("insert");
                submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardWrite");
                break;
            case "Read":
                $("#saveType").val("select");
                submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardRead");
                break;
        }
    }
    //Example Sheet2 Action
    function doAction2(sAction) {
        switch (sAction) {
            case "Search":
                $('#searchModuleCd').val($('#cModuleCd option:selected').val());
                if($('#searchCheckYn').is(":checked")) {
                    $('#searchUseYn').val("Y");
                }else {
                    $('#searchUseYn').val("N");
                }

                sheet2.DoSearch( "${ctx}/MeetingLogMgr.do?cmd=getModuleList", $("#srchFrm").serialize());
                break;
            case "Save":
                IBS_SaveName(document.sheetForm,sheet2);
                sheet2.DoSave( "${ctx}/AuthGrpUserMgr.do?cmd=saveAuthGrpUserMgr", $("#sheetForm").serialize()); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 셀에 마우스 클릭했을때 발생하는 이벤트
    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try{
            $("#searchBbsSeq").val(sheet1.GetCellValue(NewRow, "bbsSeq"));
            doAction2("Search");
        }catch(ex){alert("OnSelectCell Event Error : " + ex);}
    }

    // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    function sheet1_OnDblClick(Row, Col) {
        try{

            $("#bbsSeq").val(sheet1.GetCellValue(Row, "bbsSeq"));
            $("#burl").val(sheet1.GetCellValue(Row, "burl"));
            doAction1("Read");

        }catch(ex) {alert("OnDblClick Event Error : " + ex);}
    }

    function checkSelectedValue(){
        var valueArr = new Array();
        var list = $("input[name='chk_list']");
        for(var i = 0; i < list.length; i++){
            if(list[i].checked){ //선택되어 있으면 배열에 값을 저장함
                valueArr.push(list[i].value);
            }
        }

        //선택된 체크박스의 값을 모아서 넘김
        var str = '';
        for(var i in valueArr){
            str += valueArr[i]+',';
        }
        $("#chkField").val(str);
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
        <input type=hidden id=saveType  name="saveType"/>
        <input type=hidden id=chkField 	name=chkField>
        <input type=hidden id=bbsCd 	name=bbsCd		value="11000">
        <input type=hidden id=bbsSeq	name=bbsSeq>
        <input type=hidden id=burl	  	name=burl>
        <input type=hidden id=searchBbsSeq	  	name=searchBbsSeq>
        <input type=hidden id=searchModuleCd	  	name=searchModuleCd>
        <input type=hidden id=searchUseYn	  	name=searchUseYn value="N">
        <div class="sheet_search outer">
            <div class="sheet_search outer">
                <div>
                    <table>
                        <tr>
                            <td <c:if test="${map.headYn!='Y'}">style="display:none""</c:if>> <span>업무구분  </span> <select id="boardHead" name="boardHead"> </select> </td>
                            <td><input type="checkbox" id="chk_all"  name="chk_all" value="ALL" />&nbsp; ALL</td>
                            <td><input type="checkbox" id="chk_list" name="chk_list" value="TITLE" />&nbsp; 제목</td>
                            <td><input type="checkbox" id="chk_list" name="chk_list" value="CONTENTS" />&nbsp; 내용</td>
                            <td><input type="checkbox" id="chk_list" name="chk_list" value="NAME" />&nbsp; 작성자</td>
                            <td><input type="text"     id="searchWord" name="searchWord" value="" class="text center" style="width: 100%" /></td>
                            <td><btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <colgroup>
            <col width="65%" />
            <col width="35%" />
        </colgroup>
        <tr>
            <td class="sheet_left">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li class="txt">회의록</li>
                            <li class="btn">
                                <btn:a href="javascript:doAction1('Insert')" css="basic" mid='110700' mdef="입력"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
            </td>
            <td class="sheet_right">
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li class="txt">관련메뉴</li>
                            <li class="btn">
                                모듈 : <select id="cModuleCd" name="cModuleCd" class="box" onchange="doAction2('Search')"></select>
                                &nbsp;&nbsp;
                                <input type="checkbox" class="checkbox" style="vertical-align:middle;" id="searchCheckYn" name="searchCheckYn" value="N" onclick="doAction2('Search')"/>등록메뉴만보기
                                <btn:a href="javascript:doAction2('Save')" 	css="basic" mid='110698' mdef="저장"/>
                            </li>
                            <li class="btn">
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>