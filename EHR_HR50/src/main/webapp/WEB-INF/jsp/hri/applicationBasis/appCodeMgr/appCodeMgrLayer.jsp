<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
    var applCd = null;
    var openSheet = null;
    var recevType = null;
    var gPRow = "";
    var pGubun = "";
    $(function() {
        
        const modal = window.top.document.LayerModalUtility.getModal('appCodeMgrLayer');

        createIBSheet3(document.getElementById('appCodeMgrLayerSheet-wrap'), "appCodeMgrLayerSheet", "100%", "100%","${ssnLocaleCd}");

        applCd         = modal.parameters.applCd || '';
        recevType      = modal.parameters.recevType || '';
        $("#appCodeMgrLayerSheetForm #applCd").val(applCd);

        var bHidden   = (recevType == "B")?0:1;
        var bType     = (recevType == "B")?"Combo":"Text";

        var grCobmboList     = convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "",-1);
        var grCobmboList2    = convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W82020"), "",-1);
        appCodeMgrLayerSheet.SetDataLinkMouse("temp1", 1);
        appCodeMgrLayerSheet.SetDataLinkMouse("temp2", 1);
        
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",                Type:"${sNoTy}",   Hidden:Number("${sNoHdn}"),  Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",  Hidden:0,                    Width:30,           Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",          Type:"${sSttTy}",  Hidden:0,                    Width:30,           Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
            {Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",     Type:"Text",       Hidden:1,                    Width:50,           Align:"Left",    ColMerge:0,   SaveName:"applCd",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>" ,        Type:"Text",       Hidden:0,                    Width:50,           Align:"Center",  ColMerge:0,   SaveName:"agreeSeq",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
            {Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>" ,  Type:"Combo",      Hidden:0,                    Width:100,          Align:"Center",  ColMerge:0,   SaveName:"applTypeCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"조직결재여부" ,                                 Type:"CheckBox",   Hidden:0,                    Width:80,           Align:"Center",  ColMerge:0,   SaveName:"orgAppYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , TrueValue:"Y" , FalseValue:"N" },
            {Header:"성명/조직명" ,                                  Type:"PopupEdit",  Hidden:0,                    width:80,          Align:"Center",  ColMerge:0,   SaveName:"name",             KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"사번/조직코드" ,                                Type:"Text",       Hidden:0,                    Width:120,          Align:"Center",  ColMerge:0,   SaveName:"sabun",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:130 },
            {Header:"<sht:txt mid='hochingNm' mdef='호칭'/>" ,       Type:"Text",       Hidden:1,                    Width:80,           Align:"Center",  ColMerge:0,   SaveName:"alias",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"직책" ,                                         Type:"Text",       Hidden:0,                    Width:100,          Align:"Left",    ColMerge:0,   SaveName:"jikchakNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"사업장",                                        Type:bType,        Hidden:bHidden,              Width:100,          Align:"Left",    ColMerge:0,   SaveName:"businessPlaceCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
        ]; IBS_InitSheet(appCodeMgrLayerSheet, initdata); appCodeMgrLayerSheet.SetEditable(true);appCodeMgrLayerSheet.SetCountPosition(4);appCodeMgrLayerSheet.SetVisible(true);
        appCodeMgrLayerSheet.SetColProperty("applTypeCd",         {ComboText:"담당|결재", ComboCode:"40|10"} );

        if (bType == "Combo"){
            //var businessPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "");
            //사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
            var url     = "queryId=getBusinessPlaceCdList";
            var allFlag = true;
            if ("${ssnSearchType}" != "A"){
                url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
                allFlag = false;
            }
            var businessPlaceCd = "";
            if(allFlag) {
                businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));    //사업장
            } else {
                businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");    //사업장
            }

            appCodeMgrLayerSheet.SetColProperty("businessPlaceCd",    {ComboText:businessPlaceCd[0], ComboCode:businessPlaceCd[1]} );
        }

        $(window).smartresize(sheetResize); sheetInit();
        
        var sheetHeight = $('.modal_body').height() - $('#appCodeMgrLayerSheetForm').height() - $('.sheet_title').height();
        appCodeMgrLayerSheet.SetSheetHeight(sheetHeight);


        doAction("Search");
        
    });
    function doAction(sAction) {
		switch (sAction) {
		case "Search":  appCodeMgrLayerSheet.DoSearch( "${ctx}/AppCodeMgr.do?cmd=getAppCodeMgrPopupList", $("#appCodeMgrLayerSheetForm").serialize()); break;
		case "Save":
			if(!dupChk(appCodeMgrLayerSheet,"agreeSeq", true, true)){;break;}
			IBS_SaveName(document.appCodeMgrLayerSheetForm,appCodeMgrLayerSheet);
			appCodeMgrLayerSheet.DoSave("${ctx}/AppCodeMgr.do?cmd=saveAppCodeMgrPopup", $("#appCodeMgrLayerSheetForm").serialize() );
			break;
        case "Insert":
        	var Row = appCodeMgrLayerSheet.DataInsert(0);
        	var rowSeq = 0;
        	appCodeMgrLayerSheet.SelectCell(Row, 2);
        	appCodeMgrLayerSheet.SetCellValue(Row,"applCd",applCd);
            for ( var iRow=1; iRow < appCodeMgrLayerSheet.RowCount()+1; iRow++) {
                if(parseInt(rowSeq) < parseInt(appCodeMgrLayerSheet.GetCellValue(iRow,"agreeSeq"))){
                    rowSeq = appCodeMgrLayerSheet.GetCellValue(iRow,"agreeSeq");
                }
            }
            appCodeMgrLayerSheet.SetCellValue(Row,"agreeSeq",parseInt(rowSeq) + 1);
        	break;
        case "Copy":  		var Row = appCodeMgrLayerSheet.DataCopy(); appCodeMgrLayerSheet.SelectCell(Row, 2); break;
        case "Down2Excel":	appCodeMgrLayerSheet.Down2Excel(); break;
		}
    }
	function appCodeMgrLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function appCodeMgrLayerSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); //doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}
	function appCodeMgrLayerSheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && appCodeMgrLayerSheet.GetCellValue(Row, "sStatus") == "I") {
				appCodeMgrLayerSheet.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function appCodeMgrLayerSheet_OnPopupClick(Row, Col){
		try{
			if(appCodeMgrLayerSheet.ColSaveName(Col)=="name"){
				var orgAppYn = appCodeMgrLayerSheet.GetCellValue( Row , "orgAppYn" );

				if( orgAppYn == "N" ){
					employeePopup(Row);
				} else {
					orgPopup(Row);
				}
			}
		}catch(ex){alert("appCodeMgrLayerSheet_OnPopupClick Event Error: " + ex);}
	}

	function employeePopup(Row){
		<%--if(!isPopup()) {return;}--%>
		<%--gPRow = Row;--%>
		<%--pGubun = "employeePopup";--%>

		<%--var url = "${ctx}/Popup.do?cmd=employeePopup";--%>
		<%--var rv = openPopup(url,"",840,520);--%>
		/*
		if(rv!=null){
			appCodeMgrLayerSheet.SetCellValue(Row, "sabun", 		rv["sabun"] );
			appCodeMgrLayerSheet.SetCellValue(Row, "name", 		rv["name"] );
			appCodeMgrLayerSheet.SetCellValue(Row, "jikchakNm", 	rv["jikchakNm"] );
		}
		*/

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
                        appCodeMgrLayerSheet.SetCellValue(Row, "sabun",   result.sabun);
                        appCodeMgrLayerSheet.SetCellValue(Row, "name",   result.name);
                        appCodeMgrLayerSheet.SetCellValue(Row, "jikchakNm", result.jikchakNm);
                    }
                }
            ]
        });
        layerModal.show();
	}

	function orgPopup(Row){
		if(!isPopup()){
			return;
		}

		gPRow = Row;
		pGubun = "orgTreePopup1";

        var layerModal = new window.top.document.LayerModal({
            id : 'orgTreeLayer',
            url : "/Popup.do?cmd=viewOrgTreeLayer",
            parameters: {searchEnterCd : ''},
            width : 740,
            height : 520,
            title : "<tit:txt mid='orgTreePop' mdef='조직도 조회'/>",
            trigger: [
                {
                    name: 'orgTreeLayerTrigger',
                    callback: function(rv) {
                        appCodeMgrLayerSheet.SetCellValue(gPRow, "sabun",		rv["orgCd"] );
                        appCodeMgrLayerSheet.SetCellValue(gPRow, "name",		rv["orgNm"] );
                        appCodeMgrLayerSheet.SetCellValue(gPRow, "alias",		"-" );
                        appCodeMgrLayerSheet.SetCellValue(gPRow, "jikchakNm",	"-" );
                    }
                }
            ]
        });
        layerModal.show();
	}
</script>
</head>
<body class="bodywrap">
<form id="appCodeMgrLayerSheetForm" name="appCodeMgrLayerSheetForm">
    <input id="applCd" name="applCd" type="hidden" />
 </form>
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
                <tr>
                    <td>
                        <div class="inner">
                            <div class="sheet_title">
                            <ul>
                                <li id="txt" class="txt"><tit:txt mid='appCodeMgrV1' mdef='수신결재자'/></li>
                                <li class="btn">
                                    <btn:a href="javascript:doAction('Copy')" css="btn outline-gray" mid="110696" mdef="복사"/>
                                    <btn:a href="javascript:doAction('Insert')" css="btn outline-gray" mid="110700" mdef="입력"/>
                                    <btn:a href="javascript:doAction('Save')" css="btn filled" mid="110708" mdef="저장"/>
                                </li>
                            </ul>
                            </div>
                        </div>
                        <div id="appCodeMgrLayerSheet-wrap"></div>
                        <!--<script type="text/javascript"> createIBSheet("Sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>-->
                    </td>
                </tr>
            </table>
    
        </div>
        <div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('appCodeMgrLayer');" css="btn outline_gray" mid="close" mdef="닫기"/>
        </div>
    </div>

</body>
</html>
