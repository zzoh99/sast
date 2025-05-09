<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='104282' mdef='수당항목속성'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");
	$(function() {

		var argsElementType = "";
        var argsElementCd 	= "";
        var argsElementNm 	= "";
        var argsSdate 		= "";

		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			argsElementType = arg["elementType"];
	        argsElementCd	= arg["elementCd"];
	        argsElementNm 	= arg["elementNm"];
	        argsSdate 		= arg["sdate"];

		}else{
    	    if(p.popDialogArgument("elementType")!=null)		argsElementType  	= p.popDialogArgument("elementType");
    	    if(p.popDialogArgument("elementCd")!=null)			argsElementCd  		= p.popDialogArgument("elementCd");
    	    if(p.popDialogArgument("elementNm")!=null)			argsElementNm  		= p.popDialogArgument("elementNm");
    	    if(p.popDialogArgument("sdate")!=null)				argsSdate  			= p.popDialogArgument("sdate");
        }

		// 전달 받은 값
		//var argsElementType = window.dialogArguments["elementType"];
        //var argsElementCd = window.dialogArguments["elementCd"];
        //var argsElementNm = window.dialogArguments["elementNm"];
        //var argsSdate = window.dialogArguments["sdate"];

        $("#searchElemCd").val(argsElementCd);
        $("#searchElemNm").val(argsElementNm);
        $("#searchSdate").val(argsSdate);

		// Grid 0
		var initdata0 = {};
		//SetConfig
		initdata0.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		//HeaderMode
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata0.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
//             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
            {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",      Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",        Type:"Text",      Hidden:0,  Width:125,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",          Type:"Text",      Hidden:0,  Width:40,   Align:"Left",    ColMerge:0,   SaveName:"include",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 }
            ];
		IBS_InitSheet(mySheet0, initdata0); mySheet0.SetEditable("${editable}");
        mySheet0.SetColProperty("include",          {ComboText:"YES|NO", ComboCode:"Y|N"} );
		mySheet0.SetCountPosition(4);


        // Grid 1
        var initdata1 = {};
        //SetConfig
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        //HeaderMode
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata1.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
//             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
	           {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",   Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
	           {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",     Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	           {Header:"<sht:txt mid='attribute' mdef='적용여부코드'/>",   Type:"Text",      Hidden:0,  Width:125,  Align:"Center",  ColMerge:0,   SaveName:"attribute",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	           {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",       Type:"Text",       Hidden:1,  Width:135,  Align:"Center",  ColMerge:0,   SaveName:"attributeNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 } ,
        ];
        IBS_InitSheet(mySheet1, initdata1); mySheet1.SetEditable("${editable}");
        mySheet1.SetCountPosition(4);

        // Grid 2
        var initdata2 = {};
        //SetConfig
        initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        //HeaderMode
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        //InitColumns + Header Title
        initdata2.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
//             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
//             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
            {Header:"<sht:txt mid='elementCdV3' mdef='항목그룹코드'/>",      Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementSetCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='elementSetNm' mdef='항목그룹명'/>",        Type:"Text",      Hidden:0,  Width:125,  Align:"Left",    ColMerge:0,   SaveName:"elementSetNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"<sht:txt mid='attributeNm' mdef='적용여부'/>",          Type:"Text",      Hidden:0,  Width:40,   Align:"Left",    ColMerge:0,   SaveName:"include",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 }

        ];
        IBS_InitSheet(mySheet2, initdata2); mySheet2.SetEditable("${editable}");
        mySheet2.SetColProperty("include",          {ComboText:"YES|NO", ComboCode:"Y|N"} );
        mySheet2.SetCountPosition(4);



	    $(window).smartresize(sheetResize); sheetInit();

	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet0.DoSearch( "${ctx}/PayAllowanceElementPropertyPopup.do?cmd=getPayAllowanceElementPropertyPopupListFirst", $("#mySheetForm").serialize() );
            mySheet1.DoSearch( "${ctx}/PayAllowanceElementPropertyPopup.do?cmd=getPayAllowanceElementPropertyPopupListSecond", $("#mySheetForm").serialize() );
            mySheet2.DoSearch( "${ctx}/PayAllowanceElementPropertyPopup.do?cmd=getPayAllowanceElementPropertyPopupListThird", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	   //  조회 후 에러 메시지
    function mySheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Msg != "") alert(Msg);
            sheetResize();

            // 수습적용율
            var att2CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00009",false).codeList, "");
            mySheet1.InitCellProperty(1,"attribute", {Type:"Combo", ComboCode:att2CmbList[1], ComboText:att2CmbList[0]});

            // 과세여부
            var att3CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00011",false).codeList, "");
            mySheet1.InitCellProperty(2,"attribute", {Type:"Combo", ComboCode:att3CmbList[1], ComboText:att3CmbList[0]});

            // 신입/복직일할계산
            var att5CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00013",false).codeList, "");
            mySheet1.InitCellProperty(3,"attribute", {Type:"Combo", ComboCode:att5CmbList[1], ComboText:att5CmbList[0]});

            // 퇴직당월일할계산
            mySheet1.InitCellProperty(4,"attribute", {Type:"Combo", ComboCode:att5CmbList[1], ComboText:att5CmbList[0]});

            // 발령관련일할계산
            mySheet1.InitCellProperty(5,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

            // 징계관련일할계산
            mySheet1.InitCellProperty(6,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

            // 근태관련일할계산
            mySheet1.InitCellProperty(7,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

            // 산재관련일할계산
            mySheet1.InitCellProperty(8,"attribute", {Type:"Combo", ComboCode:"|Y|N", ComboText:"-|YES|NO"});

            // 연말정산필드
            mySheet1.InitCellProperty(9,"attribute", {Type:"Popup"});
            mySheet1.SetCellValue(9, "attribute", mySheet1.GetCellValue(9, 'attributeNm'));

            // 상여관련
            //var att6CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList&searchRunType=00002,00003",false).codeList, "");
            var att6CmbList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=C00001",false).codeList, "");
            mySheet1.InitCellProperty(10,"attribute", {Type:"Combo", ComboCode:att6CmbList[1], ComboText:att6CmbList[0]});

        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }


  	<%--  function mySheet_OnClick(Row, Col, Value){
		try{
			if(Row > 0 && mySheet.ColSaveName(Col) == "dbItemDesc"){
                if(mySheet.GetCellText(Row, "searchType").toUpperCase().indexOf("업무") != -1 ){
                    if(mySheet.GetCellValue(Row, "viewCd") != ""){
		                            var win=CenterWin("./PwrSrchBiz_list.jsp?dataAuthority=<%=dataAuthority%>", "PwrSrchBiz_list", "scrollbars=no, status=no, width=940, height=685, top=0, left=0");
						detailPopup("<c:url value='PwrSrchMgr.do?cmd=pwrSrchMgrBizPopup' />","",900,700);
                    }else{
                        alert("<msg:txt mid='110401' mdef='조회업무를 먼저 선택하세요.'/>");
                    }
                }else if(mySheet.GetCellText(Row, "searchType").toUpperCase().indexOf("ADMIN") != -1 ){
		                    var win=CenterWin("./PwrSrchAdmin_list.jsp?dataAuthority=<%=dataAuthority%>&editFlag=true", "PwrSrchAdmin_list", "scrollbars=no, status=no, width=940, height=695, top=0, left=0");
                }else if(mySheet.GetCellText(Row, "searchType").toUpperCase().indexOf("SUITABLE") != -1 ){

		                	var win=CenterWin("/JSP/hri/suitblMatch/SuitableMatch_list.jsp?dataAuthority=<%=dataAuthority%>&editFlag=true", "SuitableMatch_list", "scrollbars=yes, status=no, width=955, height=695, top=0, left=0");
                }
	    	}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}  --%>
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='payAllowanceElementPropertyPop1' mdef='수당, 공제 항목 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>

    <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm">
		<input type="hidden" name="searchElemCd" id="searchElemCd" />
        <input type="hidden" name="searchSdate" id="searchSdate" />
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
                        <td>  <input id="searchElemNm" name ="searchElemNm" type="text" readonly class="text readonly" /> </td>
<!-- 						<td> -->
<!-- 							<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> -->
<!-- 						</td> -->
					</tr>
					</table>
					</div>
				</div>
		</form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
    <colgroup>
        <col width="30%" />
        <col width="30%" />
        <col width="30%" />
    </colgroup>
    <tr>
        <td class="sheet_left">
            <div class="inner">
                <div class="sheet_title">
                <ul>
                    <li class="txt"><tit:txt mid='103979' mdef='항목그룹1'/></li>
                </ul>
                </div>
            </div>
            <script type="text/javascript"> createIBSheet("mySheet0", "30%", "100%", "${ssnLocaleCd}"); </script>
        </td>
        <td>
            <div class="inner">
                <div class="sheet_title">
                <ul>
                    <li class="txt"><tit:txt mid='104370' mdef='항목그룹2'/></li>
                </ul>
                </div>
            </div>
            <script type="text/javascript"> createIBSheet("mySheet1", "30%", "100%", "${ssnLocaleCd}"); </script>
        </td>
        <td class="sheet_right">
            <div class="inner">
                <div class="sheet_title">
                <ul>
                    <li class="txt"><tit:txt mid='104182' mdef='항목그룹3'/></li>
                </ul>
                </div>
            </div>
            <script type="text/javascript"> createIBSheet("mySheet2", "30%", "100%", "${ssnLocaleCd}"); </script>
        </td>
    </tr>
    </table>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
    </div>
</body>
</html>



