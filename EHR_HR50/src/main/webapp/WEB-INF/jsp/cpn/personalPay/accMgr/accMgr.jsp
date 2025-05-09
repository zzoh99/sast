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

        var initdata = {};
        initdata.Cfg = {FrozenCol:22,SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		 Type:"${sDelTy}",	 Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },

            {Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",     Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",         Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",         Type:"Text",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",         Type:"Text",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sabun",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",         Type:"Text", Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"name",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",     Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"statusCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='accountType' mdef='계좌구분'/>",        Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"accountType",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",        Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",      KeyField:1,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",        Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",      KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='bankCdV2' mdef='금융사'/>",          Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"bankCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>",        Type:"Text",      Hidden:0,  Width:150,  Align:"Left",  ColMerge:0,   SaveName:"accountNo",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 },
			{Header:"<sht:txt mid='accName' mdef='예금주'/>",          Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"accName",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='chkdateV6' mdef='수정일시'/>",        Type:"Text",      Hidden:0,  Width:130,   Align:"Center", ColMerge:0,   SaveName:"chkdate",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='chkidV1' mdef='수정자'/>",        Type:"Text",      Hidden:0,  Width:120,   Align:"Center", ColMerge:0,   SaveName:"chkid",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 }
            ];
        IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


        // 직위
        //var jikweeCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
        //sheet1.SetColProperty("jikweeCd",           {ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );

        // 재직상태
        var statusCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
        sheet1.SetColProperty("statusCd",           {ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );

        // 계좌구분
        var accountTypeList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00180"), "<tit:txt mid='103895' mdef='전체'/>");
        sheet1.SetColProperty("accountType",            {ComboText:accountTypeList[0], ComboCode:accountTypeList[1]} );

        // 금웅사
        var bankCdList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "<tit:txt mid='103895' mdef='전체'/>");
        sheet1.SetColProperty("bankCd",             {ComboText:bankCdList[0], ComboCode:bankCdList[1]} );

        sheet1.SetColProperty("defaultYn", 			{ComboText:"|Y|N", ComboCode:"|Y|N"} );
        // 조회조건

        // 재직상태
        //alert(statusCdList[2]);
        $("#searchStatusCd").html(statusCdList[2]);
		$("#searchStatusCd").select2({
			placeholder: "<tit:txt mid='111914' mdef='선택'/>"
		});

		$("#searchDefaultYn").select2({
			placeholder: "<tit:txt mid='111914' mdef='선택'/>"
		});

        $("#searchAccountType").html(accountTypeList[2]);

        $("#searchSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
        
      //Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
                        sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
                        sheet1.SetCellValue(gPRow,"statusCd", rv["statusCd"]);

					}
				}
			]
		});
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":

            //$("#searchAccountTypeHidden").val(getMultiSelectValue($("#searchAccountType").val()));
            //$("#searchBankCdHidden").val(getMultiSelectValue($("#searchBankCd").val()));
            //$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
			$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
			$("#searchDefaultYnHidden").val(getMultiSelectValue($("#searchDefaultYn").val()));
            sheet1.DoSearch( "${ctx}/AccMgr.do?cmd=getAccMgrList", $("#sheetForm").serialize() ); break;
        case "Save":
        	if(!dupChk(sheet1,"sabun|accountType|sdate", false, true)){break;}
            // 미처리 상태의 건에 대한 update
            IBS_SaveName(document.sheetForm,sheet1);
            sheet1.DoSave( "${ctx}/AccMgr.do?cmd=saveAccMgr", $("#sheetForm").serialize()); break;
		case "Insert":      sheet1.DataInsert(0); break;
        case "Copy":        sheet1.DataCopy(); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;

		case "DownTemplate":
		// 양식다운로드
		sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"6|9|10|11|12|13"});
		break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();

        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }


    function sheet1_OnClick(Row, Col, Value) {
        try{

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


	function sheet1_OnPopupClick(Row, Col) {
		try{

			var colName = sheet1.ColSaveName(Col);
			if (Row >= sheet1.HeaderRows()) {
				if (colName == "name") {
					// 사원검색 팝입
					empSearchPopup(Row, Col);
				}
			}
		} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}


	// 사원검색 팝입
	function empSearchPopup(Row, Col) {
        let layerModal = new window.top.document.LayerModal({
            id : 'employeeLayer'
            , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
            , parameters : {}
            , width : 840
            , height : 520
            , title : '사원조회'
            , trigger :[
                {
                    name : 'employeeTrigger'
                    , callback : function(result){
                        sheet1.SetCellValue(Row, "sabun", result.sabun);
                        sheet1.SetCellValue(Row, "name", result.name);
                        sheet1.SetCellValue(Row, "orgNm", result.orgNm);
                        sheet1.SetCellValue(Row, "jikweeNm", result.jikweeNm);
                        sheet1.SetCellValue(Row, "statusCd", result.statusCd);
                    }
                }
            ]
        });
        layerModal.show();

		// if(!isPopup()) {return;}
        //
		// var w		= 840;
		// var h		= 520;
		// var url		= "/Popup.do?cmd=employeePopup";
		// var args	= new Array();
        //
		// gPRow = Row;
		// pGubun = "employeePopup";
        //
		// openPopup(url+"&authPg=R", args, w, h);
	}

// 	//팝업 콜백 함수.
// 	function getReturnValue(returnValue) {
// 		var rv = $.parseJSON('{' + returnValue+ '}');

//         if(pGubun == "employeePopup"){
// 			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
// 			sheet1.SetCellValue(gPRow, "name", rv["name"]);
// 			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
// 			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
// 			sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
//         }
// 	}


</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <!-- 조회조건 -->
    <%--
    <input type="hidden" id="searchElemCd" name="searchElemCd" value =""/>
    <input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>

    <input type="hidden" id="searchAccountTypeHidden" name="searchAccountTypeHidden" value="" />


    --%>
    <input type="hidden" id="searchDefaultYnHidden" name="searchDefaultYnHidden" value="" />
    <input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />
    <!-- 조회조건 -->
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th><tit:txt mid='112434' mdef='계좌구분 '/></th>
                        <td>
                        	<select id="searchAccountType" name ="searchAccountType" class="box" onChange="javascript:doAction1('Search')"></select>
                       	</td>
                       	<th><tit:txt mid='114198' mdef='재직상태 '/></th>
                        <td>
                        	<select id="searchStatusCd" name ="searchStatusCd" class="box"  multiple=""></select>
                       	</td>
                       	<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
	                    <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
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
                            <li id="txt" class="txt"><tit:txt mid='113149' mdef='은행계좌관리(관리자)'/></li>
                            <li class="btn">
<!--                             	<a href="javascript:doAction1('DownTemplate')" 	class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a> -->
                            	<a href="javascript:doAction1('Insert')"   class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
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
