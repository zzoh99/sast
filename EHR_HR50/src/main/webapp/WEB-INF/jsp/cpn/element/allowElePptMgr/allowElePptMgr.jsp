<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='104282' mdef='수당항목속성'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p 	   = eval("${popUpStatus}");
	var pGubun = "";

	var selectTargetSdate = "";

	// 연말정산 코드 값
	var attribute8 = "";

	$(function() {

    	// Grid 0
        var initdata0 = {};
        //SetConfig
        initdata0.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        //HeaderMode
        initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata0.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",      Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",        Type:"Text",      Hidden:0,  Width:80,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",          Type:"Text",      Hidden:0,  Width:80,   Align:"Center",    ColMerge:0,   SaveName:"include",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 }
            ];
        IBS_InitSheet(sheet2, initdata0); sheet2.SetEditable("${editable}");
        sheet2.SetColProperty("include",          {ComboText:"YES|NO", ComboCode:"Y|N"} );
        sheet2.SetCountPosition(4);


        // Grid 1
        var initdata1 = {};
        //SetConfig
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        //HeaderMode
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata1.Cols = [
            {Header:"<sht:txt mid='sNo' 		 mdef='No'/>",         	Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sStatus' 	 mdef='상태'/>",         Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
            {Header:"<sht:txt mid='elementCdV3'  mdef='항목그룹코드'/>",	Type:"Text",      	Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,	SaveName:"elementCd",     	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,	UpdateEdit:1,	InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",    	Type:"Text",     	Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,	SaveName:"elementSetNm",	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:10 },
            {Header:"<sht:txt mid='attribute' 	 mdef='적용여부코드'/>",   Type:"Text",      	Hidden:0,  Width:125,  Align:"Center",  ColMerge:0, SaveName:"attribute",     	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='attributeNm'  mdef='적용여부'/>",      Type:"Text",       	Hidden:1,  Width:135,  Align:"Center",  ColMerge:0, SaveName:"attributeNm",   	KeyField:0,	CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
        	{Header:"<sht:txt mid='sdateV17' 	 mdef='업데이트날짜'/>",	Type:"Text",       	Hidden:1,  Width:135,  Align:"Center",	ColMerge:0, SaveName:"sdate",    		KeyField:0, CalcLogic:"",	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
        ];
        IBS_InitSheet(sheet3, initdata1); sheet3.SetEditable("${editable}");
        sheet3.SetCountPosition(4);

        // Grid 2
        var initdata2 = {};
        //SetConfig
        initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        //HeaderMode
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata2.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",      Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",        Type:"Text",      Hidden:0,  Width:125,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",          Type:"Text",      Hidden:0,  Width:40,   Align:"Center",    ColMerge:0,   SaveName:"include",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 }
        ];
        IBS_InitSheet(sheet4, initdata2); sheet4.SetEditable("${editable}");
        sheet4.SetColProperty("include",          {ComboText:"YES|NO", ComboCode:"Y|N"} );
        sheet4.SetCountPosition(4);

        // Grid
        var initdata = {};
        //SetConfig
        initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        //HeaderMode
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='elementType' mdef='항목유형'/>",       Type:"Combo",     Hidden:1,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"elementType",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",       Type:"Text",      Hidden:0,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",         Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
            {Header:"<sht:txt mid='reportNmV1' mdef='Report명'/>",       Type:"Text",      Hidden:1,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"reportNm",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='priority' mdef='계산\n순위'/>",     Type:"Text",      Hidden:1,  Width:40,   Align:"Right",   ColMerge:0,   SaveName:"priority",          KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='updownType' mdef='절상/사\n구분'/>",  Type:"Combo",     Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"updownType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='danwi' mdef='단위'/>",           Type:"Combo",     Hidden:1,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"updownUnit",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='currency' mdef='통화'/>",           Type:"Combo",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"currency",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='elementLinkType' mdef='항목Link\n유형'/>", Type:"Combo",     Hidden:1,  Width:70,   Align:"Left",    ColMerge:0,   SaveName:"elementLinkType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",       Type:"Text",      Hidden:1,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",       Type:"Text",      Hidden:1,  Width:75,   Align:"Center",  ColMerge:0,   SaveName:"edate",             KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",           Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sdelete" }
        ];

        IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");
        sheet1.SetCountPosition(4);

        $(window).smartresize(sheetResize); sheetInit();

        doAction("Search");

        $(".close").click(function() {
           p.self.close();
        });
    });

    //  조회 후 에러 메시지
    function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Msg != "") alert(Msg);
            sheetResize();

            // 수습적용율
            var att2CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00009",false).codeList, "");
            sheet3.InitCellProperty(1,"attribute", {Type:"Combo", ComboCode:"|"+att2CmbList[1], ComboText:"|"+att2CmbList[0]});

            // 과세여부
            var att3CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00011",false).codeList, "");
            sheet3.InitCellProperty(2,"attribute", {Type:"Combo", ComboCode:"|"+att3CmbList[1], ComboText:"|"+att3CmbList[0]});

            // 신입/복직일할계산
            var att5CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00013",false).codeList, "");
            sheet3.InitCellProperty(3,"attribute", {Type:"Combo", ComboCode:"|"+att5CmbList[1], ComboText:"|"+att5CmbList[0]});

            // 퇴직당월일할계산
            sheet3.InitCellProperty(4,"attribute", {Type:"Combo", ComboCode:"|"+att5CmbList[1], ComboText:"|"+att5CmbList[0]});

            // 발령관련일할계산
            sheet3.InitCellProperty(5,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"|YES|NO"});

            // 징계관련일할계산
            sheet3.InitCellProperty(6,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"|YES|NO"});

            // 근태관련일할계산
            sheet3.InitCellProperty(7,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"|YES|NO"});

            // 산재관련일할계산
            //sheet3.InitCellProperty(8,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"|YES|NO"});

            // 연말정산필드
            /*
            sheet3.InitCellProperty(9,"attribute", {Type:"Popup"});

            attribute9 = sheet3.GetCellValue(9, "attribute");

            sheet3.SetCellValue(9, "attribute", sheet3.GetCellValue(9, 'attributeNm'));
			*/
            sheet3.InitCellProperty(8,"attribute", {Type:"Popup"});

            attribute8 = sheet3.GetCellValue(8, "attribute");

            sheet3.SetCellValue(8, "attribute", sheet3.GetCellValue(8, 'attributeNm'));

            // 상여관련
            //var att6CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList&searchRunType=00002,00003",false).codeList, "");
            var att6CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00001",false).codeList, "");
            //sheet3.InitCellProperty(10,"attribute", {Type:"Combo", ComboCode:"|"+att6CmbList[1], ComboText:"|"+att6CmbList[0]});
            sheet3.InitCellProperty(9,"attribute", {Type:"Combo", ComboCode:"|"+att6CmbList[1], ComboText:"|"+att6CmbList[0]});

        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    //Sheet Action
    function doAction(sAction) {
        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/AllowElePptMgr.do?cmd=getAllowElePptMgrList", $("#sheetForm").serialize() );
                            break;
        case "Down2Excel":  sheet1.Down2Excel(); break;
        }
    }

    //Sheet Action
    function doActionOther(sAction) {
        switch (sAction) {
        case "Search":      sheet2.DoSearch( "${ctx}/AllowElePptMgr.do?cmd=getAllowElePptMgrListFirst", $("#sheetForm").serialize() );
                            sheet3.DoSearch( "${ctx}/AllowElePptMgr.do?cmd=getAllowElePptMgrListSecond", $("#sheetForm").serialize() );
                            sheet4.DoSearch( "${ctx}/AllowElePptMgr.do?cmd=getAllowElePptMgrListThird", $("#sheetForm").serialize() );
                            break;
        case "Save":        // 모두 업데이트
                            for(var i = 1; i <= 10; i++){
                                sheet3.SetCellValue(i, "sdate",   selectTargetSdate);
                                sheet3.SetCellValue(i, "sStatus",   "U" );
                            }
                            // 연말정산
                            sheet3.SetCellValue(8, "attributeNm", attribute8);
                            IBS_SaveName(document.sheetForm,sheet3);
                            sheet3.DoSave( "${ctx}/AllowElePptMgr.do?cmd=updateAllowElePptMgrListSecond", $("#sheetForm").serialize());
                            break;
        case "Insert":      sheet.SelectCell(sheet.DataInsert(0), 4); break;
        case "Copy":        sheet.DataCopy(); break;
        case "Clear":       sheet.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet.Down2Excel(param);

							break;
        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet.LoadExcel(params); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    /*
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }
    */

    // 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY
            if (Shift == 1 && KeyCode == 45) {
                doAction("Insert");
            }
            //Delete KEY
            if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
                sheet1.SetCellValue(Row, "sStatus", "D");
            }
        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }

    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try{
            if(OldRow != NewRow){

            	$("#searchElemCd").val(sheet1.GetCellValue(NewRow,"elementCd"));
                $("#searchElemNm").val(sheet1.GetCellValue(NewRow,"elementNm"));
                $("#searchSdate").val(sheet1.GetCellValue(NewRow,"sdate"));

                selectTargetSdate = sheet1.GetCellValue(NewRow,"sdate");

                doActionOther("Search");
            }
        }catch(ex){alert("OnSelectCell Event Error : " + ex);}
     }

    //  연말정산
//    function sheet3_OnPopupClick(Row, Col){
//         try{

//         	var args    = new Array();

//           args["adjElementCd"]  = sheet3.GetCellValue(9, "attribute");
//           args["adjElementNm"]  = sheet3.GetCellValue(9, "attributeNm");

//           var rv = null;

//           if(Row == 9) {

//               var rv = openPopup("/DedEleMgr.do?cmd=viewDedEleMgrPopup&authPg=${authPg}", args, "740","520");
//               if(rv!=null){
//             	  attribute8 = rv["adjElementCd"];
//                   sheet3.SetCellValue(9, "attribute",   rv["adjElementNm"] );


//               }
//           }
//         }catch(ex){alert("OnPopupClick Event Error : " + ex);}
//     }

    function sheet3_OnPopupClick(Row, Col) {
		if(Row !== 8) return;

		let layerModal = new window.top.document.LayerModal({
			id : 'viewDedEleLayer'
			, url : '/DedEleMgr.do?cmd=viewDedEleMgrLayer&authPg=${authPg}'
			, parameters : {
				adjElementCd : sheet1.GetCellValue(8, "attribute")
				, adjElementNm : sheet1.GetCellValue(8, "attributeNm")
			}
			, width : 860
			, height : 520
			, title : '<tit:txt mid='dedEleMgrPop' mdef='연말정산 코드항목 조회'/>'
			, trigger :[
				{
					name : 'dedTrigger'
					, callback : function(result){
						sheet3.SetCellValue(8, "attribute", result.adjElementNm);
					}
				}
			]
		});
		layerModal.show();

<%--        try {--%>
<%--        	var args = new Array();--%>

<%--          	args["adjElementCd"] = sheet3.GetCellValue(8, "attribute");--%>
<%--          	args["adjElementNm"] = sheet3.GetCellValue(8, "attributeNm");--%>

<%--          	var rv = null;--%>

<%--          	if(Row == 8) {--%>
<%--/*--%>
<%--				var rv = openPopup("/DedEleMgr.do?cmd=viewDedEleMgrPopup&authPg=${authPg}", args, "740","520");--%>

<%--              	if(rv != null) {--%>
<%--              		attribute8 = rv["adjElementCd"];--%>
<%--                	sheet3.SetCellValue(8, "attribute", rv["adjElementNm"] );--%>
<%--              	}--%>
<%--*/--%>
<%--				pGubun = "dedEleMgrPopup";--%>
<%--          		openPopup("/DedEleMgr.do?cmd=viewDedEleMgrPopup&authPg=${authPg}", args, "740","520");--%>
<%--          }--%>
<%--        } catch(ex){alert("OnPopupClick Event Error : " + ex);}--%>
    }

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "dedEleMgrPopup"){
          	attribute8 = rv["adjElementCd"];
            sheet3.SetCellValue(8, "attribute", rv["adjElementNm"] );
        }
	}

    // 저장 후 메시지
    function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
	    <input type="hidden" id="searchElemCd" name="searchElemCd" value="" />
	    <input type="hidden" id="searchSdate" name="searchSdate" value="" />
	    <input type="hidden" id="searchElemNm" name="searchElemNm" value="" />
    </form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			    <colgroup>
			        <col width="25%" />
			        <col width="20%" />
			        <col width="35%" />
                    <col width="20%" />
			    </colgroup>
			    <tr>
			        <td class="sheet_right">
                        <div class="inner">
                            <div class="sheet_title">
                            <ul>
                                <li class="txt"><tit:txt mid='allowElePptMgr1' mdef='수당항목'/></li>
                            </ul>
                            </div>
                        </div>
                        <script type="text/javascript"> createIBSheet("sheet1", "25%", "100%", "${ssnLocaleCd}"); </script>
                    </td>
                    <td class="sheet_right">
                        <div class="inner">
                            <div class="sheet_title">
                            <ul>
                                <li class="txt"><tit:txt mid='103979' mdef='항목그룹1'/></li>
                            </ul>
                            </div>
                        </div>
                        <script type="text/javascript"> createIBSheet("sheet2", "20%", "100%", "${ssnLocaleCd}"); </script>
                    </td>
			        <td class="sheet_right">
			            <div class="inner">
			                <div class="sheet_title">
			                <ul>
			                    <li class="txt"><tit:txt mid='104370' mdef='항목그룹2'/></li>
			                    <li class="btn">
	                                <a href="javascript:doActionOther('Save')"   class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
                                </li>
			                </ul>
			                </div>
			            </div>
			            <script type="text/javascript"> createIBSheet("sheet3", "35%", "100%", "${ssnLocaleCd}"); </script>
			        </td>
			        <td class="sheet_right">
			            <div class="inner">
			                <div class="sheet_title">
			                <ul>
			                    <li class="txt"><tit:txt mid='104182' mdef='항목그룹3'/></li>
			                </ul>
			                </div>
			            </div>
			            <script type="text/javascript"> createIBSheet("sheet4", "20%", "100%", "${ssnLocaleCd}"); </script>
			        </td>
			    </tr>
			    </table>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
