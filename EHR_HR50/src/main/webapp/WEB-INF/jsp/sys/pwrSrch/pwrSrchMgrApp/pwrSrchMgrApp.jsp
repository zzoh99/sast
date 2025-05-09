<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113699' mdef='조건검색관리(일반)'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var srchBizCd = null;
	var srchTypeCd = null;

	/*Sheet 기본 설정 */
	$(function() {
		//srchBizCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체'/>",-1);
		srchBizCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "<tit:txt mid='103895' mdef='전체'/>");

		srchTypeCd = new Array("업무별 조건검색|Suitable Matching","2|1","");
		srchTypeCd[2] = "<option value=''>전체</option><option value=''>전체</option><option value=''>전체</option>";
		//Condtion Combo setting
		$("#srchBizCd").html(srchBizCd[2]) ;

		/*대 메뉴가 '시스템'이 아닌경우 업무구분은 변경불가하며 검색구분은 히든처리
										Ordered - CBS / Coding - JSG*/
		if("${result.mainMenuCd}" != 11) {
			$("#srchBizCd").attr("disabled", "disabled");
			$(".srchTypeViewYn").addClass("hide") ;
		}

		"${result.mainMenuCd}" == 11 ? "" : $("#srchBizCd").val("${result.mainMenuCd}") ;	//업무 구분

		$("#srchType").html(srchTypeCd[2]);	//검색 구분

		sheet1.SetDataLinkMouse("sStatus", 1);
	    sheet1.SetDataLinkMouse("dbItemDesc", 1);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
	        {Header:"<sht:txt mid='sNo' mdef='No'/>",  				Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",    			Type:"${sDelTy}", 	Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",    			Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	        {Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",      	Type:"Image",   	Hidden:0,  			Width:40,   		Align:"Center",  ColMerge:0,   SaveName:"dbItemDesc",		KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
	        {Header:"<sht:txt mid='searchSeq_V646' mdef='검색\n순번'/>",      	Type:"Text",    	Hidden:0,  			Width:45,   		Align:"Center",  ColMerge:0,   SaveName:"searchSeq",       	KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='searchType' mdef='검색구분'/>",        	Type:"Combo",   	Hidden:0,  			Width:65,			Align:"Center",  ColMerge:0,   SaveName:"searchType",      	KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='searchDesc' mdef='검색설명'/>",        	Type:"Text",    	Hidden:0,  			Width:100,			Align:"Left",    ColMerge:0,   SaveName:"searchDesc",      	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
	        {Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",        	Type:"Combo",   	Hidden:0, 	 		Width:40,			Align:"Left",    ColMerge:0,   SaveName:"bizCd",           	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='viewCd' mdef='조회업무코드'/>",    	Type:"Text",    	Hidden:0,  			Width:60,  			Align:"Left",    ColMerge:0,   SaveName:"viewCd",          	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='viewDesc' mdef='조회업무'/>",        	Type:"Popup",   	Hidden:0,  			Width:100,			Align:"Left",    ColMerge:0,   SaveName:"viewDesc",        	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='commonUseYn' mdef='공통사용\n여부'/>",  	Type:"Combo",   	Hidden:0,  			Width:60,   		Align:"Center",  ColMerge:0,   SaveName:"commonUseYn",    	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",            	Type:"Text",    	Hidden:1,  			Width:0,    		Align:"Left",    ColMerge:0,   SaveName:"sabun",            KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"<sht:txt mid='chkId' mdef='등록자'/>",          	Type:"Text",    	Hidden:0,  			Width:80,   		Align:"Center",  ColMerge:0,   SaveName:"owner",            KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
	        {Header:"<sht:txt mid='chkdateV1' mdef='최종수정일'/>",      	Type:"Date",    	Hidden:0,  			Width:80,  			Align:"Center",  ColMerge:0,   SaveName:"chkdate",          KeyField:0,   CalcLogic:"",   Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
	        {Header:"<sht:txt mid='viewNm' mdef='VIEW_NM'/>",         	Type:"Text",    	Hidden:1,  			Width:0,    		Align:"Center",  ColMerge:0,   SaveName:"viewNm",          	KeyField:0,   CalcLogic:"",   Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
	        {Header:"<sht:txt mid='copySearchSeq' mdef='복사_SEARCH_SEQ'/>",	Type:"Text",    	Hidden:1,  			Width:60,   		Align:"Center",  ColMerge:0,   SaveName:"copySearchSeq",  	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		];
		//초기화
		IBS_InitSheet(sheet1, initdata);
	 	sheet1.SetEditable("${editable}");
     	sheet1.SetColProperty("bizCd", 		{ComboText:srchBizCd[0], 	ComboCode:srchBizCd[1]} );
        sheet1.SetColProperty("searchType", 	{ComboText:srchTypeCd[0], 	ComboCode:srchTypeCd[1]} );
        sheet1.SetColProperty("commonUseYn", 	{ComboText:"YES|NO", 		ComboCode:"Y|N"} );
        //sheet1.SetImageList(0,"/HTML/images/icon/ico_detail.gif");
        sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
        sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		$("#srchDesc").bind("keyup",function(event){
			if( event.keycode == 13){
				doAction("Search");
			}
			$(this).focus();
		});
       	doAction("Search");

	    $(window).smartresize(sheetResize);

	    sheetInit();
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/PwrSrchMgrApp.do?cmd=getPwrSrchMgrAppList", $("#sheet1Form").serialize() );
			break;
		//case "Save":		//저장
			//update, insert는 MERGE 사용 이외는 Delete
		//	IBS_SaveName(document.sheet1Form,sheet1);
		//	sheet1.DoSave( "${ctx}/PwrSrchMgrApp.do?cmd=savePwrSrchMgrApp", $("#sheet1Form").serialize() );
         //   break;
        case "Insert":		//입력
        	var Row = sheet1.DataInsert(0);
            sheet1.SelectCell(Row, "searchSeq");
            break;
        case "Copy":		//행 복사
        	var copySearchSeq = sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq");
            var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "copySearchSeq",copySearchSeq);
            sheet1.SelectCell(Row, "searchSeq");
            break;
        case "Clear":		//Clear
            sheet1.RemoveAll();
            break;
        case "Down2Excel":	//엑셀내려받기
            sheet1.Down2Excel();
            break;
        case "LoadExcel":   //엑셀업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
            break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 	저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
		    selectSheet = sheet1;
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

  	function sheet1_OnClick(Row, Col, Value){
  		var status = sheet1.GetCellValue(Row,"sStatus") ;
  		var srchType = sheet1.GetCellText(Row, "searchType").toUpperCase() ;
		try{
			if(Row > 0 && sheet1.ColSaveName(Col) == "dbItemDesc"){
		        if(status != "I" ){
		            if(status != "U"){
		                if(srchType.indexOf("업무") != -1 ){
		                    if(sheet1.GetCellValue(Row, "viewCd") != ""){
								bizPopup(Row,"${ctx}/PwrSrchBizPopup.do?cmd=pwrSrchBizPopup&authPg=${authPg}","1000","800");
		                    }else{ alert("<msg:txt mid='110401' mdef='조회업무를 먼저 선택하세요.'/>"); }
		                }
		            }else{ alert("<msg:txt mid='alertBeSaveReflectCheckV1' mdef='저장을 먼저하세요.'/>"); }
		        }else{ alert("<msg:txt mid='alertBeSaveReflectCheckV1' mdef='저장을 먼저하세요.'/>"); }
	    	}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

  	function bizPopup(Row,url,w,h){
		var args 	= new Array();
		args["openSheet"]	= "sheet1";
		var rv = openPopup(url, args, w,h);
	}

</script>

</head>
<body class="bodywrap">

	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<input id="userId" name="userId" type="hidden" /> <input id="enterCd"
				name="enterCd" type="hidden" />
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='114394' mdef='업무구분'/></th>
					<td>
						<select id="srchBizCd" name="srchBizCd" onChange=""></select>
					</td>
					<th class="srchTypeViewYn"><tit:txt mid='112961' mdef='검색구분'/></th>
					<td class="srchTypeViewYn">
						<select id="srchType" name="srchType" onChange=""></select>
					</td>
					<th><tit:txt mid='112606' mdef='검색설명'/></th>
					<td>
						<input id="srchDesc" name="srchDesc" type="text" class="text" />
					</td>
					<td>
						<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
					</td>
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
						<li id="txt" class="txt"><tit:txt mid='113699' mdef='조건검색관리(일반)'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
							<btn:a href="javascript:doAction('Copy')" css="basic authA" mid='110696' mdef="복사"/>
							<btn:a href="javascript:doAction('Save')" css="basic authA" mid='110708' mdef="저장"/>
							<a href="javascript:doAction('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		</table>
	</div>
</body>
</html>
