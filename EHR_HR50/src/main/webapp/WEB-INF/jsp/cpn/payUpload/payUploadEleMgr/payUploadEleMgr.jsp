<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:0,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,						Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"코드",       Type:"Combo",     	Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"payCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"항목명",      Type:"Combo",    	Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"항목구분",     Type:"Text",     	Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"elementType",    KeyField:1,   CalcLogic:"", 	DefaultValue:"A" , 		Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"출력\n순서",   Type:"Float",     	Hidden:0,  Width:30,   Align:"Right",   ColMerge:0,   SaveName:"seq",        KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:0,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,						Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"코드",       Type:"Combo",     	Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"payCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"항목명",      Type:"Combo",    	Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"항목구분",     Type:"Text",     	Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"elementType",    KeyField:1,   CalcLogic:"", 	DefaultValue:"D" , 		Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"출력\n순서",   Type:"Float",     	Hidden:0,  Width:30,   Align:"Right",   ColMerge:0,   SaveName:"seq",        KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 }
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

   		
   	 	//급여구분
		var payCdList = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "");
		$("#searchPayCd").html(payCdList[2]);
		// 코드
		sheet1.SetColProperty("payCd", {ComboText:payCdList[0], ComboCode:payCdList[1]} );
		sheet2.SetColProperty("payCd", {ComboText:payCdList[0], ComboCode:payCdList[1]} );
		
		// 항목명(지급항목 element_type = 'A')
		var payElementListA = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&elementType=A","queryId=getCpnPayElementCdList",false).codeList, "");
		sheet1.SetColProperty("elementCd", {ComboText:payElementListA[0], ComboCode:payElementListA[1]} );
		// 항목명(공제항목 element_type = 'D')
		var payElementListD = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&elementType=D","queryId=getCpnPayElementCdList",false).codeList, "");
		sheet2.SetColProperty("elementCd", {ComboText:payElementListD[0], ComboCode:payElementListD[1]} );
		
		// 검색조건 : 급여구분
		$("#searchPayCd").change(function(){
			doActionSearch();
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		doAction2("Search");
	});
	
	// 지급항목(sheet1), 공제항목(sheet2) 조회
	function doActionSearch() {
		doAction1("Search");
		doAction2("Search");
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchElementType").val("A");
			sheet1.DoSearch( "${ctx}/PayUploadEleMgr.do?cmd=getPayUploadEleMgrList", $("#srchFrm").serialize() );
			break;
		case "Save": 
			// 중복체크 
			// if (!dupChk(sheet1, "payCd|elementCd", false, true)) {break;}
			var result = sheet1.ColValueDup("seq",{"IncludeDelRow" : 0});
	  		if(result>0 && sheet1.GetCellValue(result, "seq") !=""){
	  		    alert("중복된 출력순서입니다.");
	  		    //sheet1.SetSelectRow(result);
	  		  	break;
	  	 	}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave("${ctx}/PayUploadEleMgr.do?cmd=savePayUploadEleMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "payCd",$("#searchPayCd").val());
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "seq", "");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg);
			}
			if ( Code != "-1" ) {
				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchElementType").val("D");
			sheet2.DoSearch( "${ctx}/PayUploadEleMgr.do?cmd=getPayUploadEleMgrList", $("#srchFrm").serialize() );
			break;
		case "Save": 
			// 중복체크 
			//if (!dupChk(sheet2, "payCd|seq", false, true)) { break;}
			var result2 = sheet2.ColValueDup("seq",{"IncludeDelRow" : 0});
	  		if(result2>0 && sheet2.GetCellValue(result2, "seq") !=""){
	  		    alert("중복된 출력순서입니다.");
	  		    //sheet1.SetSelectRow(result);
	  		  	break;
	  	 	}
			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave("${ctx}/PayUploadEleMgr.do?cmd=savePayUploadEleMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row, "payCd",$("#searchPayCd").val());
			break;
		case "Copy":
			var row = sheet2.DataCopy();
			sheet2.SetCellValue(row, "seq", "");
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg);
			}
			if ( Code != "-1" ) {
				doAction2("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" name="searchElementType" id="searchElementType">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>급여구분</span>
							<select id="searchPayCd" name="searchPayCd" >
							</select>
						</td>
						<td> <a href="javascript:doActionSearch();" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="15px" />
		<col width="%" />
	</colgroup>
	<tr>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">지급항목</li>
						<li class="btn">
							<a href="javascript:doAction1('Insert')"	class="basic authA">입력</a>
							<a href="javascript:doAction1('Copy')"		class="basic authA">복사</a> 
							<a href="javascript:doAction1('Save')"		class="basic authA">저장</a> 
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
		</td>
		<td></td>
		<td class="">
			<form id="srchFrm2" name="srchFrm2" >
			<input type="hidden" id="searchAppraisalCd2" name="searchAppraisalCd" />
			<input type="hidden" id="searchAppGroupCd2" name="searchAppGroupCd" />
			<input type="hidden" id="searchAppSeqCd2" name="searchAppSeqCd" />
			<input type="hidden" id="searchAppSabun2" name="searchAppSabun" />
			</form>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">공제항목</li>
						<li class="btn">
							<a href="javascript:doAction2('Insert')"	class="basic authA">입력</a>
							<a href="javascript:doAction2('Copy')"		class="basic authA">복사</a>
							<a href="javascript:doAction2('Save');" 	class="basic authA">저장</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","kr"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>