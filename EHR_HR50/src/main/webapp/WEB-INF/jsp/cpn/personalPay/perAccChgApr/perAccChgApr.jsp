<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
    $(function() {

//      $("#searchDate").datepicker2();

        $("#searchFrom").datepicker2({startdate:"searchTo"});
        $("#searchTo").datepicker2({enddate:"searchFrom"});

        var initdata = {};
        initdata.Cfg = {/* FrozenCol:9,FrozenColRight:3, */SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",               Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",             Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",             Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"workType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",             Type:"Combo",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",             Type:"Text",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sabun",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",             Type:"PopupEdit", Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"name",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",         Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",             Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",             Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",         Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"manageCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",         Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"statusCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='empYmd' mdef='입사일'/>",           Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"empYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='apApplSeqV1' mdef='신청순번'/>",         Type:"Text",      Hidden:1,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"reqSeq",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"<sht:txt mid='applYmdV6' mdef='신청일자'/>",         Type:"Date",      Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"reqDate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='applStatusCd_V5692' mdef='처리상태'/>",         Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"status",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='accountType' mdef='계좌구분'/>",         Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"accountType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='bankCdV2' mdef='금융사'/>",           Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"bankCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>",         Type:"Text",      Hidden:0,  Width:150,  Align:"Left",  ColMerge:0,   SaveName:"accountNo",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='accName' mdef='예금주'/>",           Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"accName",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
            {Header:"<sht:txt mid='btnFileV1' mdef='파일첨부'/>",         Type:"Html",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"btnFile",       KeyField:0,                   Format:""       ,     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"<sht:txt mid='btnFileV1' mdef='파일첨부'/>",         Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"fileSeq",       KeyField:0,                   Format:"Number",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"<sht:txt mid='applyYn' mdef='반영\n여부'/>",       Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Left",    ColMerge:0,   SaveName:"dmyStatus",     KeyField:0,                   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50,     TrueValue:"Y", FalseValue:"N" },
            {Header:"<sht:txt mid='agreeDate' mdef='처리일자'/>",         Type:"Date",      Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"agreeDate",     KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='bigo_V5697' mdef='처리내용'/>",  		   Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"bigo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:666 }
            ];
        IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


        // 직군
        var workTypList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");
        sheet1.SetColProperty("workType",           {ComboText:workTypList[0], ComboCode:workTypList[1]} );

        // 직책
        var jikchakCdList   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");
        sheet1.SetColProperty("jikchakCd",          {ComboText:"|"+jikchakCdList[0], ComboCode:"|"+jikchakCdList[1]} );

        // 직위
        var jikweeCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
        sheet1.SetColProperty("jikweeCd",           {ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );

        //사원구분
        var manageCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");
        sheet1.SetColProperty("manageCd",           {ComboText:"|"+manageCdList[0], ComboCode:"|"+manageCdList[1]} );

        // 재직상태
        var statusCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
        sheet1.SetColProperty("statusCd",           {ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );

        // 계좌구분
        var accountTypeList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00180"), "");
        sheet1.SetColProperty("accountType",            {ComboText:accountTypeList[0], ComboCode:accountTypeList[1]} );

        // 금웅사
        var bankCdList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "");
        sheet1.SetColProperty("bankCd",             {ComboText:bankCdList[0], ComboCode:bankCdList[1]} );

        // 조회조건

        // 직군
        $("#searchWorkType").html(workTypList[2]);
        $("#searchWorkType").select2({
            placeholder: "<tit:txt mid='111914' mdef='선택'/>"
        });

        // 사원구분
        $("#searchManageCd").html(manageCdList[2]);
        $("#searchManageCd").select2({
            placeholder: "<tit:txt mid='111914' mdef='선택'/>"
        });

        // 재직상태
        $("#searchStatusCd").html(statusCdList[2]);
        $("#searchStatusCd").select2({
            placeholder: "<tit:txt mid='111914' mdef='선택'/>"
        });

        $("#searchElemNm,#searchOrgNm,#searchSabunName,#searchFrom,#searchTo").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":

            $("#searchWorkTypeHidden").val(getMultiSelectValue($("#searchWorkType").val()));
            $("#searchManageCdHidden").val(getMultiSelectValue($("#searchManageCd").val()));
            $("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));

            sheet1.DoSearch( "${ctx}/PerAccChgApr.do?cmd=getPerAccChgAprList", $("#sheetForm").serialize() ); break;
        case "Save":
            // 미처리 상태의 건에 대한 update
            IBS_SaveName(document.sheetForm,sheet1);
            sheet1.DoSave( "${ctx}/PerAccChgApr.do?cmd=updatePerAccChgApr", $("#sheetForm").serialize()); break;
        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
        case "Copy":        sheet1.DataCopy(); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
                var downcol = makeHiddenSkipCol(sheet1);
                var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
                sheet1.Down2Excel(param); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();
            for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
                if( sheet1.GetCellValue(r,"dmyStatus") == "Y"){

                        sheet1.SetCellEditable(r, "dmyStatus" ,0);
                }
            }

        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }


    function sheet1_OnClick(Row, Col, Value) {
        try{
        	 var sSaveName = sheet1.ColSaveName(Col);
        	if(sSaveName == "dmyStatus"){
	            if(sheet1.GetCellValue(Row,"status") == 'Y'){
	                    var msge = "기 반영된 자료는 반영을 해제할 수 없습니다.";
	                    msge    += "\n은행계좌관리에서 직접 삭제 또는 조정하여 주시기 바랍니다."
	                    alert(msge);
	            }
            }
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }


    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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


    function getMultiSelectValue( value ) {
    	if( value == null || value == "" ) return "";
    	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
        //return "'"+String(value).split(",").join("','")+"'";
		return value;
    }

    // 체크 박스 전체 선택
    function sheet1_OnCheckAllEnd(Col, Value) {

        try {

            for(var i=1; i <= sheet1.RowCount(); i++){
                if(sheet1.GetCellValue(i,"status") == 'Y'){
                    sheet1.SetCellValue(i, "dmyStatus", "Y");
                }
            }

        } catch (ex) {
            alert("OnCheckAllEnd Event Error : " + ex);
        }
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <!-- 조회조건 -->
    <input type="hidden" id="searchElemCd" name="searchElemCd" value =""/>
    <input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>

    <input type="hidden" id="searchWorkTypeHidden" name="searchWorkTypeHidden" value="" />
    <input type="hidden" id="searchManageCdHidden" name="searchManageCdHidden" value="" />
    <input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />

    <!-- 조회조건 -->
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
						<th><tit:txt mid='113497' mdef='신청기간 '/></th>
	                    <td>
	                        <input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>" /> ~
	                        <input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
	                    </td>
	                    <th><tit:txt mid='112277' mdef='사번/성명 '/></th>
	                    <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
	                    <th>반영여부 </th>
	                    <td>
	                        <select  id="searchProssStatus" name="searchProssStatus" class="box" onchange="javascript:doAction1('Search');">
	                            <option value="">전체</option>
	                            <option value="N">미반영</option>
	                            <option value="Y">반영</option>
	                        </select>
	                    </td>
                    </tr>
                    <tr>
                    	<th><tit:txt mid='104261' mdef='직군 '/></th>
                        <td>
                        	<select id="searchWorkType" name ="searchWorkType" multiple=""></select>
                        </td>
                        <th><tit:txt mid='112785' mdef='사원구분 '/></th>
                        <td>
                        	<select id="searchManageCd" name ="searchManageCd" multiple=""></select>
                       	</td>
                       	<th><tit:txt mid='114198' mdef='재직상태 '/></th>
                        <td>
                        	<select id="searchStatusCd" name ="searchStatusCd" multiple=""></select>
                       	</td>
                       	<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
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
                            <li id="txt" class="txt"><tit:txt mid='113157' mdef='은행계좌변경승인'/></li>
                            <li class="btn">
                                <a href="javascript:doAction1('Save')"  class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
                                <a href="javascript:doAction1('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
