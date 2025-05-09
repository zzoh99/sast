<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var applCd = null;
	var openSheet = null;
	var gPRow = "";
	var pGubun = "";
	$(function() {
		
		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			applCd = arg["applCd"];
		} else {
			if(p.popDialogArgument("applCd")!=null){
				applCd = p.popDialogArgument("applCd");
			}
		}

		if (arg != undefined){
			openSheet = arg["sheet1"];
		} else {
// 			openSheet = p.window.opener.sheet1;
			openSheet = p.popDialogSheet("sheet1") ;
		}
		sRow = openSheet.GetSelectRow();

		$("#applCd").val(applCd);

		applCd		  = openSheet.GetCellValue(sRow,"applCd");
		var recevType = openSheet.GetCellValue(sRow,"recevType");
		var bHidden   = (recevType == "B")?0:1;
		var bType     = (recevType == "B")?"Combo":"Text";

	    var grCobmboList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "",-1);
	    var grCobmboList2	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W82020"), "",-1);
	    sheet1.SetDataLinkMouse("temp1", 1);
	    sheet1.SetDataLinkMouse("temp2", 1);
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:30, Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:0,  Width:30, Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>"	,	Type:"Text",      Hidden:1,  Width:50,	Align:"Left",	ColMerge:0,   SaveName:"applCd",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>" ,			Type:"Text",      Hidden:0,  Width:50, 	Align:"Center",	ColMerge:0,   SaveName:"agreeSeq",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>" ,		Type:"Combo",     Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,   SaveName:"applTypeCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"조직결재여부" ,	Type:"CheckBox",     Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,   SaveName:"orgAppYn",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , TrueValue:"Y" , FalseValue:"N" },
			{Header:"성명/조직명" ,	Type:"PopupEdit", Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번/조직코드" ,	Type:"Text",      Hidden:0,  Width:100,	Align:"Center",	ColMerge:0,   SaveName:"sabun",       	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:130 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>" ,			Type:"Text", Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"alias",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"직책" ,			Type:"Text",    	Hidden:0,  		Width:100,	Align:"Left", 	ColMerge:0,   SaveName:"jikchakNm", 	    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"사업장",			Type:bType,			Hidden:bHidden,	Width:100,	Align:"Left", 	ColMerge:0,   SaveName:"businessPlaceCd",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);

		sheet1.SetColProperty("applTypeCd", 		{ComboText:"담당|결재", ComboCode:"40|10"} );

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
				businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//사업장
			} else {
				businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
			}

			sheet1.SetColProperty("businessPlaceCd",	{ComboText:businessPlaceCd[0], ComboCode:businessPlaceCd[1]} );
		}

		$(window).smartresize(sheetResize); sheetInit();
		$(".close").click(function() {
	    	p.self.close();
	    });


		doAction("Search");
	});
	function doAction(sAction) {
		switch (sAction) {
		case "Search":  sheet1.DoSearch( "${ctx}/AppCodeMgr.do?cmd=getAppCodeMgrPopupList", $("#sheet1Form").serialize()); break;
		case "Save":
			if(!dupChk(sheet1,"agreeSeq", true, true)){;break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/AppCodeMgr.do?cmd=saveAppCodeMgrPopup", $("#sheet1Form").serialize() );
			break;
        case "Insert":
        	var Row = sheet1.DataInsert(0);
        	var rowSeq = 0;
        	sheet1.SelectCell(Row, 2);
        	sheet1.SetCellValue(Row,"applCd",applCd);
            for ( var iRow=1; iRow < sheet1.RowCount()+1; iRow++) {
                if(parseInt(rowSeq) < parseInt(sheet1.GetCellValue(iRow,"agreeSeq"))){
                    rowSeq = sheet1.GetCellValue(iRow,"agreeSeq");
                }
            }
            sheet1.SetCellValue(Row,"agreeSeq",parseInt(rowSeq) + 1);
        	break;
        case "Copy":  		var Row = sheet1.DataCopy(); sheet1.SelectCell(Row, 2); break;
        case "Down2Excel":	sheet1.Down2Excel(); break;
		}
    }
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); //doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}
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

	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col)=="name"){
				var orgAppYn = sheet1.GetCellValue( Row , "orgAppYn" );

				if( orgAppYn == "N" ){
					employeePopup(Row);
				} else {
					orgPopup(Row);
				}
			}
		}catch(ex){alert("sheet1_OnPopupClick Event Error: " + ex);}
	}

	function employeePopup(Row){
		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "employeePopup";

		var url = "${ctx}/Popup.do?cmd=employeePopup";
		var rv = openPopup(url,"",840,520);
		/*
		if(rv!=null){
			sheet1.SetCellValue(Row, "sabun", 		rv["sabun"] );
			sheet1.SetCellValue(Row, "name", 		rv["name"] );
			sheet1.SetCellValue(Row, "jikchakNm", 	rv["jikchakNm"] );
		}
		*/
	}

	function orgPopup(Row){
		var args = new Array();

		if(!isPopup()){
			return;
		}

		gPRow = Row;
		pGubun = "orgTreePopup1";

		openPopup("/Popup.do?cmd=orgTreePopup&authPg=${authPg}", args, "640","720");
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",		rv["name"] );
			sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );

		} else if(pGubun == "orgTreePopup1"){
			sheet1.SetCellValue(gPRow, "sabun",		rv["orgCd"] );
			sheet1.SetCellValue(gPRow, "name",		rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "alias",		"-" );
			sheet1.SetCellValue(gPRow, "jikchakNm",	"-" );
		}
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form">
	<input id="applCd" name="applCd" type="hidden" />
</form>
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='appCodeMgr' mdef='수신 결재자 등록'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='appCodeMgrV1' mdef='수신결재자'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')" css="basic" mid="110700" mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" css="basic" mid="110696" mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" css="basic" mid="110708" mdef="저장"/>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid="close" mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
