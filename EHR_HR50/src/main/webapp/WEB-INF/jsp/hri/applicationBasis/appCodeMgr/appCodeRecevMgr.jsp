<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head><title>수신결재자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
	    
		$("#appCd, #appCdNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
	
		$("#searchBizCd").bind("change",function(){
			doAction1("Search");
		});
		
		init_sheet1();init_sheet2();
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function init_sheet1(){
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		    //수정시 줄좀 맞춥시다..
			{Header:"<sht:txt mid='sNo'           mdef='No'/>",				Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd'      mdef='상태'/>",			Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center", SaveName:"sStatus" },
			{Header:"<sht:txt mid='bizCdV1'       mdef='업무구분코드'/>",		Type:"Combo",		Hidden:0,  Width:60,   Align:"Center", SaveName:"bizCd",   KeyField:0, Edit:0 },
			{Header:"<sht:txt mid='applCd_V3737'  mdef='신청서코드'/>",		Type:"Text",		Hidden:0,  Width:50,   Align:"Center", SaveName:"applCd",  KeyField:0, Edit:0 },
			{Header:"<sht:txt mid='applNm'        mdef='신청서명'/>",			Type:"Text",		Hidden:0,  Width:120,  Align:"Center", SaveName:"applNm",  KeyField:0, Edit:0 },
			
			{Header:"<sht:txt mid='recevYnV1'     mdef='수신처리\n필요여부'/>",	Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center", SaveName:"recevYn",    UpdateEdit:1,   InsertEdit:0, TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='L190923000002' mdef='수신\n결재자' />",		Type:"Image",		Hidden:0,  Width:50,   Align:"Center", SaveName:"recevBtn",   Cursor:"Pointer", ImgWidth:18, ImgHeight:18},
			{Header:"수신결재\n등록유형",			Type:"Combo",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"recevType",          Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },

		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
		
	    sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
	    sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");
	    sheet1.SetDataLinkMouse("temp1",1);

	    var grCobmboList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체' />",-1);
	    sheet1.SetColProperty("bizCd", 		{ComboText:grCobmboList[0], 	ComboCode:grCobmboList[1]} );
	    $("#searchBizCd").html(grCobmboList[2]);

		var recevTypeList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R30020"), "<tit:txt mid='103895' mdef='전체' />",-1);
		sheet1.SetColProperty("recevType",	{ComboText:recevTypeList[0], 	ComboCode:recevTypeList[1]} );
	}
	
	function init_sheet2(){
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'        mdef='No'/>",		Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete'    mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:0,  Width:45, Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='statusCd'   mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:0,  Width:45, Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			
			{Header:"<sht:txt mid='sort'       mdef='순서'/>" ,		Type:"Text",      Hidden:0,  Width:45, 	Align:"Center",	ColMerge:0, SaveName:"agreeSeq",   	KeyField:1,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='gubun'      mdef='결재구분'/>" ,	Type:"Combo",     Hidden:0,  Width:60,	Align:"Center",	ColMerge:0, SaveName:"applTypeCd",	KeyField:1,   UpdateEdit:1,   InsertEdit:1 },
			{Header:"조직결재여부" ,                                 Type:"CheckBox",   Hidden:0,                    Width:80,           Align:"Center",  ColMerge:0,   SaveName:"orgAppYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , TrueValue:"Y" , FalseValue:"N" },
			{Header:"<sht:txt mid='sabun'      mdef='사번/조직코드'/>" ,		Type:"Text",      Hidden:0,  Width:60,	Align:"Center",	ColMerge:0, SaveName:"sabun",       KeyField:1,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='name'       mdef='성명/조직명'/>" ,		Type:"PopupEdit", Hidden:0,  Width:60,	Align:"Center",	ColMerge:0, SaveName:"name",       	KeyField:0,   UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='orgNm'      mdef='소속'/>",		Type:"Text",   	  Hidden:0,  Width:80,  Align:"Center", ColMerge:0, SaveName:"orgNm",  		KeyField:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='jikgubNm'   mdef='직급'/>",		Type:"Text",   	  Hidden:Number("${jgHdn}"),  Width:60,  Align:"Center", ColMerge:0, SaveName:"jikgubNm",  	KeyField:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='businessPlaceCd'      mdef='사업장'/>",		Type:"Combo",   	  Hidden:1,  Width:80,  Align:"Center", ColMerge:0, SaveName:"businessPlaceCd",  		KeyField:0,   UpdateEdit:1,   InsertEdit:1 },

			{Header:"Hidden", Type:"Text", Hidden:1,  SaveName:"applCd"},
			
		]; IBS_InitSheet(sheet2, initdata); sheet2.SetEditable(true);sheet2.SetCountPosition(4);sheet2.SetVisible(true);
		sheet2.SetColProperty("applTypeCd", 		{ComboText:"<tit:txt mid='L190828000042' mdef='담당'/>|<tit:txt mid='113975' mdef='합의'/>|<tit:txt mid='113201' mdef='결재'/>", ComboCode:"40|20|10"} );
	}
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":  
			sheet1.DoSearch( "${ctx}/AppCodeMgr.do?cmd=getAppCodeMgrList", $("#sheet1Form").serialize()); 
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/AppCodeMgr.do?cmd=saveAppCodeMgrRecevYn", $("#sheet1Form").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
        	break;
		}
    }
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":  
			sheet2.DoSearch( "${ctx}/AppCodeMgr.do?cmd=getAppCodeMgrPopupList", $("#sheet1Form").serialize()); 
			break;
		case "Save":
			if(!dupChk(sheet2,"sabun", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave("${ctx}/AppCodeMgr.do?cmd=saveAppCodeMgrPopup", $("#sheet1Form").serialize() );
			break;
		case "Insert":
        	var Row = sheet2.DataInsert(-1);
        	sheet2.SelectCell(Row, 2);
        	sheet2.SetCellValue(Row,"applCd", $("#applCd").val() );
        	sheet2.SetCellValue(Row,"agreeSeq", maxAgreeSeq() );
        	
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param); 
        	break;
		}
    }
	
	function maxAgreeSeq(){

    	var maxSeq = 0;
    	
    	for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
    		
            if(parseInt(maxSeq) < parseInt(sheet2.GetCellValue(i, "agreeSeq"))){
            	maxSeq = parseInt(sheet2.GetCellValue(i,"agreeSeq"));
            }
        }
        return maxSeq+1;
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete){
		try {
			//log.debug($(".sheet_right > #contents").length);
			gPRow = NewRow;
			$("#applCd").val(sheet1.GetCellValue(NewRow,"applCd"));
			if( OldRow != NewRow ) {
				doAction2("Search");
			}
			setBpCol(NewRow);
		} catch (ex) { alert("OnSelectCell Event Error : " + ex); }
	}

function sheet1_OnChange(Row, Col, Value) {
	try{
		var sSaveName = sheet1.ColSaveName(Col);

		if(sSaveName == "recevType"){
			setBpCol(Row);
		}
	}catch(ex){alert("OnChange Event Error : " + ex);}
}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction2("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	function sheet2_OnPopupClick(Row, Col){
		try{
			if(sheet2.ColSaveName(Col)=="name"){
				var orgAppYn = sheet2.GetCellValue( Row , "orgAppYn" );

				if( orgAppYn == "N" ){
					employeePopup(Row);
				} else {
					orgPopup(Row);
				}
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function employeePopup(Row){
		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "employeePopup";

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
						sheet2.SetCellValue(Row, "sabun",   result.sabun);
						sheet2.SetCellValue(Row, "name",   result.name);
						sheet2.SetCellValue(Row, "jikchakNm", result.jikchakNm);
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
						sheet2.SetCellValue(gPRow, "sabun",		rv["orgCd"] );
						sheet2.SetCellValue(gPRow, "name",		rv["orgNm"] );
						sheet2.SetCellValue(gPRow, "alias",		"-" );
						sheet2.SetCellValue(gPRow, "jikchakNm",	"-" );
					}
				}
			]
		});
		layerModal.show();
	}

	function setBpCol(Row) {
		let recevType = sheet1.GetCellValue(Row, 'recevType')
		let bHidden   = (recevType == "B")?0:1;
		let bType     = (recevType == "B")?"Combo":"Text";

		sheet2.SetColHidden("businessPlaceCd", bHidden);
		if (bType == "Combo"){
			let url     = "queryId=getBusinessPlaceCdList";
			let allFlag = true;
			if ("${ssnSearchType}" != "A"){
				url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
				allFlag = false;
			}
			let businessPlaceCd = "";
			if(allFlag) {
				businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));    //사업장
			} else {
				businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");    //사업장
			}

			sheet2.SetColProperty("businessPlaceCd",    {ComboText:businessPlaceCd[0], ComboCode:businessPlaceCd[1]} );
		} else {
			sheet2.SetColProperty("businessPlaceCd",    {ComboText:"", ComboCode:""} );
		}
		sheetResize();
	}
</script>
<style type="text/css">
textarea { padding:5px; line-height:22px;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="srchUseYn" name="srchUseYn" value="Y"/>
	<input type="hidden" id="applCd" name="applCd"/>
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th><tit:txt mid='114394' mdef='업무구분' /></th>
			<td>
				<select id="searchBizCd" name="searchBizCd"></select>
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
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	
	<table class="sheet_main">
	<colgroup>
		<col width="" />
		<col width="30px" />
		<col width="55%" />
	</colgroup>
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='appCodeMgrV1' mdef='수신결재관리' /></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Save');" 	css="btn filled authA" mid='save'      mdef="저장"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow.png"/></div></td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='appCodeMgrV1' mdef='수신결재자'/></li> 
						<li class="btn">
							<btn:a href="javascript:doAction2('Insert')"    css="btn outline-gray" mid="insert" mdef="입력"/>
							<btn:a href="javascript:doAction2('Save');" 	css="btn filled" mid='save'   mdef="저장"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>	
		</td>
	</tr>
	</table>

</div>
</body>
</html>



