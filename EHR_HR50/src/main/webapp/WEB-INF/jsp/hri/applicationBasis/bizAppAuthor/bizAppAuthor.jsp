<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:6, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",		Type:"Combo",		Hidden:0,  Width:150,  		Align:"Center",		ColMerge:0,	  	SaveName:"locationCd",	KeyField:0,	EditLen:10 },
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",	Type:"Text",		Hidden:0,  Width:120,   	Align:"Center",  	ColMerge:0,   	SaveName:"applCd",    		KeyField:0, EditLen:100 },
			{Header:"<sht:txt mid='applNm' mdef='신청서명'/>",		Type:"Text",		Hidden:0,  Width:150,  		Align:"Center",  	ColMerge:0,   	SaveName:"applNm",    		KeyField:0, EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(false);sheet1.SetCountPosition(4);sheet1.SetVisible(true);


		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:3, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}", 	Hidden:0,  Width:30, 	Align:"Center",  	ColMerge:0, SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,  Width:30, 	Align:"Center",  	ColMerge:0, SaveName:"sStatus" },
			{Header:"<sht:txt mid='locationCdV1' mdef='근무지코드'/>",	Type:"Text",      	Hidden:1,  Width:100,	Align:"Left",		ColMerge:0, SaveName:"locationCd",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",	Type:"Text",      	Hidden:1,  Width:100,	Align:"Left",		ColMerge:0, SaveName:"applCd",     		KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applNm' mdef='신청서명'/>",		Type:"Text",      	Hidden:0,  Width:100,	Align:"Center",		ColMerge:0, SaveName:"applNm",     		KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applTypeCd' mdef='결재구분'/>",		Type:"Combo",    	Hidden:0,  Width:80,	Align:"Center",		ColMerge:0, SaveName:"applTypeCd",   	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Text",      	Hidden:0,  Width:50, 	Align:"Center",		ColMerge:0,	SaveName:"agreeSeq",      	KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",  		Type:"Combo",     	Hidden:1,  Width:80,   	Align:"Left", 		ColMerge:0,	SaveName:"agreeEnterCd",    KeyField:1,   CalcLogic:"",   Format:"",   	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",      	Hidden:0,  Width:100,	Align:"Center",		ColMerge:0, SaveName:"agreeSabun",      KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"PopupEdit",	Hidden:0,  Width:80,	Align:"Center",		ColMerge:0, SaveName:"name",       		KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",      	Hidden:0,  Width:100,	Align:"Center", 	ColMerge:0, SaveName:"jikweeNm",      	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",      	Hidden:0,  Width:100,	Align:"Center", 	ColMerge:0, SaveName:"jikchakNm",     	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata); sheet2.SetEditable(true);sheet2.SetCountPosition(4);sheet2.SetVisible(true);




		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCd",false).codeList, "");
		$("#locationCd").html(locationCd[2]);
		sheet1.SetColProperty("locationCd", 		{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );
		sheet2.SetColProperty("applTypeCd", 	{ComboText:"담당|합의|결재", ComboCode:"40|20|10"} );

		$("#appCd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#appCdNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#locationCd").bind("change",function(event){
			doAction1("Search");
		});

		/*var getEnterCdAuthList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&ssnGrpCd=${ssnGrpCd}","queryId=getEnterCdAuthList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		sheet2.SetColProperty("agreeEnterCd", 			{ComboText:"|" + getEnterCdAuthList[0], ComboCode:"|" + getEnterCdAuthList[1]} );
		*/
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});


	function doAction1(sAction) {
		switch (sAction) {
		case "Search":  sheet1.DoSearch( "${ctx}/BizAppAuthor.do?cmd=getBizAppAuthorList", $("#sheet1Form").serialize()); break;
		}
    }

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param="locationCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"locationCd")+"&applCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applCd");
			sheet2.DoSearch( "${ctx}/BizAppAuthor.do?cmd=getBizAppAuthorList2", param); break;
		case "Save":
			if(!dupChk(sheet2,"locationCd|applCd|agreeEnterCd|agreeSabun", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/BizAppAuthor.do?cmd=saveBizAppAuthor2", $("#sheet1Form").serialize() );
			break;
        case "Insert":
        	var Row1 = sheet1.GetSelectRow();
        	var Row2 = sheet2.DataInsert(0);

        	sheet2.SetCellValue(Row2,"applCd",sheet1.GetCellValue(Row1,"applCd"));
        	sheet2.SetCellValue(Row2,"applNm",sheet1.GetCellValue(Row1,"applNm"));
        	sheet2.SetCellValue(Row2,"locationCd",sheet1.GetCellValue(Row1,"locationCd"));
        	sheet2.SetCellValue(Row2,"agreeEnterCd","${ssnEnterCd}");

       	break;
        case "Copy":  		var Row = sheet2.DataCopy(); sheet2.SelectCell(Row, 2); break;
        case "Down2Excel":	sheet2.Down2Excel(); break;
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(sheet1.GetSelectRow() > 0 && OldRow != NewRow) {
				/* if(sheet2.FindStatusRow("I|U|D") != ""){
					alert("신청서별수신결재자를 먼저 저장하세요");
					return;
				}else{ */
					doAction2('Search');
				//}
			}
		} catch(ex){
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function  sheet2_OnPopupClick(Row, Col){
		try{
		    if(sheet2.ColSaveName(Col)=="name"){
		    	employeePopup(Row);
			}
		}catch(ex){alert("sheet2_OnPopupClick Event Error: " + ex);}
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

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
			sheet2.SetCellValue(gPRow, "agreeSabun", 	rv["sabun"] );
			sheet2.SetCellValue(gPRow, "name", 			rv["name"] );
			sheet2.SetCellValue(gPRow, "jikweeNm", 		rv["jikweeNm"] );
			sheet2.SetCellValue(gPRow, "jikchakNm", 	rv["jikchakNm"] );
	    }
	}

</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='114399' mdef='사업장'/></th>
							<td>
								<select id="locationCd" name="locationCd"></select>
							</td>
							<th><tit:txt mid='114633' mdef='신청서코드'/></th>
							<td>
								<input id="appCd" name ="appCd" type="text" class="text"/>
							</td>
							<th><tit:txt mid='114237' mdef='신청서코드명'/></th>
							<td>
								<input id="appCdNm" name ="appCdNm" type="text" class="text"/>
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid="110697" mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='112136' mdef='신청서코드관리'/></li>
				</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>

		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="txt">신청서별 수신결재자</li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Insert');" 		css="basic" mid="110700" mdef="입력"/>
						<btn:a href="javascript:doAction2('Copy');" 		css="basic" mid="110696" mdef="복사"/>
						<btn:a href="javascript:doAction2('Save');" 		css="basic" mid="110708" mdef="저장"/>
					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%","${ssnLocaleCd}"); </script>
</div>
</body>
</html>
