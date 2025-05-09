<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가코드"		,Type:"Text",     	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"평가명"			,Type:"Text",     	Hidden:0,  Width:300,  Align:"Center",	ColMerge:0,   SaveName:"appraisalNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"평가단계"		,Type:"Combo",     	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appStepCd",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"작업상태"		,Type:"Text",     	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"checkY",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		var comboList5 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00005"),"전체"); // 평가단계
		sheet1.SetColProperty("appStepCd", 			{ComboText:comboList5[0], ComboCode:comboList5[1]} );


		initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가ID"			,Type:"Text",     	Hidden:1,  Width:60,  Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",				KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"성명"			,Type:"Popup",     	Hidden:0,  Width:70,  Align:"Center",	ColMerge:0,   SaveName:"name",				KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"사번"			,Type:"Text",     	Hidden:0,  Width:60,  Align:"Center",	ColMerge:0,   SaveName:"sabun",				KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"소속"			,Type:"Text",     	Hidden:0,  Width:150, Align:"Center",	ColMerge:0,   SaveName:"orgNm",				KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직위"			,Type:"Text",     	Hidden:0,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"jikweeNm",			KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직책"			,Type:"Text",     	Hidden:0,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"jikchakNm",			KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직종"			,Type:"Text",     	Hidden:0,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"workTypeNm",		KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직무"			,Type:"Text",     	Hidden:0,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"jobNm",				KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"직무코드"		,Type:"Text",     	Hidden:1,  Width:80,  Align:"Center",	ColMerge:0,   SaveName:"jobCd",				KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"항목코드"		,Type:"Text",		Hidden:1,  Width:70,  Align:"Center",	ColMerge:0,   SaveName:"seq",				KeyField:0,   CalcLogic:"",   Format:"",      PitCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"대분류"	    	,Type:"Combo",		Hidden:0,  Width:80, Align:"Center",	ColMerge:0,   SaveName:"internItemType",	KeyField:0,   CalcLogic:"",   Format:"",      PitCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가역량"		,Type:"Popup",		Hidden:0,  Width:100, Align:"Center",	ColMerge:0,   SaveName:"internItemNm",		KeyField:1,   CalcLogic:"",   Format:"",      PitCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"평가내용"		,Type:"Text",		Hidden:0,  Width:250, Align:"Left",		ColMerge:0,   SaveName:"internItemMemo",	KeyField:0,   CalcLogic:"",   Format:"",      PitCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:330, MultiLineText:1, ToolTip:1 },
            {Header:"가중치(%)"		,Type:"Float",      Hidden:0,  Width:60,  Align:"Center",	ColMerge:0,   SaveName:"appBasisPoint",		KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"순서"			,Type:"Int",      	Hidden:0,  Width:40, Align:"Center",	ColMerge:0,   SaveName:"sunbun",			KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);


		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchAppTypeCd=D,",false).codeList, ""); // 평가명
		var famList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getJobCdList",false).codeList, "전체"); // 직무명

		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"),"전체"); // 직위
		var comboList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"),"전체"); // 직책
		var comboList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009"),"전체"); // 항목구분
		var comboList4 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"),"전체"); // 지표구분


		$("#searchAppraisalCd").html(famList[2]); //평가명
		$("#searchJikweeCd").html(comboList1[2]);  //직위
		$("#searchJikchakCd").html(comboList2[2]); // 직책
		$("#searchJobCd").html(famList1[2]); // 직무명


		//대분류
		var combocdList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10010"), "");
		sheet2.SetColProperty("internItemType", 			{ComboText:combocdList1[0], ComboCode:combocdList1[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppInternItemCreateMgr.do?cmd=getAppInternItemCreateMgrList", $("#sheetForm").serialize() ); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/AppInternItemCreateMgr.do?cmd=getAppInternItemCreateMgrList1", $("#sheetForm").serialize(),1 ); break;
		case "Save":
			if (!dupChk(sheet2, "appraisalCd|appraisalCd|sabun|seq", false, true)) {break;}
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/AppInternItemCreateMgr.do?cmd=saveAppInternItemCreateMgr", $("#sheetForm").serialize()); break;
		case "Insert":		var Row = sheet2.DataInsert(0);
							sheet2.SetCellValue(Row, "appraisalCd",$("#searchAppraisalCd").val());
							sheet2.SelectCell(Row, "name");
							break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
			doAction2("Search");
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
				if (Msg != "") {
					alert(Msg);
			  	}
				doAction2("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	function sheet2_OnPopupClick(Row, Col){
		try{

			var colName = sheet2.ColSaveName(Col);
			var args    = new Array();
			args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
			var rv = null;

			if(colName == "internItemNm") {
				var rv = openPopup("/AppInternItemCreateMgr.do?cmd=viewAppInternItemCreateMgrPop", args, "1000","700");
				if(rv!=null){
				sheet2.SetCellValue(Row, "seq",   			rv["seq"] );
				sheet2.SetCellValue(Row, "internItemType",  rv["internItemType"] );
				sheet2.SetCellValue(Row, "internItemNm",   	rv["internItemNm"] );
				sheet2.SetCellValue(Row, "internItemMemo",  rv["internItemMemo"] );
				sheet2.SetCellValue(Row, "appBasisPoint",   rv["appBasisPoint"] );
				sheet2.SetCellValue(Row, "sunbun",   		rv["sunbun"] );
				}
			}else if(colName == "name"){
				 var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
	              if(rv!=null){
	                  sheet2.SetCellValue(Row, "name",   rv["name"] );
	                  sheet2.SetCellValue(Row, "sabun",  rv["sabun"] );
	                  sheet2.SetCellValue(Row, "orgNm",  rv["orgNm"] );
	                  sheet2.SetCellValue(Row, "jikweeNm",  rv["jikweeNm"] );
	                  sheet2.SetCellValue(Row, "jikchakNm",  rv["jikchakNm"] );
	                  sheet2.SetCellValue(Row, "workTypeNm",  rv["workTypeNm"] );
	                  sheet2.SetCellValue(Row, "jobNm",  rv["jobNm"] );
	              }
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	//사원 팝입
	function employeePopup(){
	    try{

	     var args    = new Array();
	     var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
	        if(rv!=null){


	         $("#searchName").val(rv["name"]);
	         $("#searchSabun").val(rv["sabun"]);
	         doAction2("Search");
	        }
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}


	function searchAll(){
		doAction1("Search");
		doAction2("Search");
	}


	function createPopup(){

		if(sheet1.RowCount() == 0){
			alert("평가일정을 등록하셔야 합니다.");
		}else{
			if(sheet1.GetCellValue(1,"checkY") == ""){
				if(confirm("해당 평가대상자들의  촉탁직평가표를 생성합니다\n계속하시겠습니까?")){

			        var data = ajaxCall("/AppInternItemCreateMgr.do?cmd=prcAppInternItemCreateMgr",$("#sheetForm").serialize(),false);
					if(data.Result.Code == null) {
			    		alert("처리되었습니다.");
			    		doAction1("Search");
			    	} else {
				    	alert(data.Result.Message);
			    	}
				}
			}else{
				if(confirm("촉탁직평가표를 재생성합니다\n계속하시겠습니까?")){

			        var data = ajaxCall("/AppInternItemCreateMgr.do?cmd=prcAppInternItemCreateMgr",$("#sheetForm").serialize(),false);
					if(data.Result.Code == null) {
			    		alert("처리되었습니다.");
			    		doAction1("Search");
			    	} else {
				    	alert(data.Result.Message);
			    	}
				}
			}
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>

				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<span>직위</span>
							<select name="searchJikweeCd" id="searchJikweeCd" onChange="javascript:doAction2('Search');">
							</select>
						</td>
						<td>
							<span>직책</span>
							<select name="searchJikchakCd" id="searchJikchakCd" onChange="javascript:doAction2('Search');">
							</select>
						</td>
						<td>
						</td>
					</tr>
					<tr>
							<td>
								<span>직무명</span>
								<select name="searchJobCd" id="searchJobCd" onChange="javascript:doAction2('Search');">
								</select>
							</td>
							<td colspan="2"><span>성명 </span>
								<input id="searchName" name ="searchName" type="text" class="text" readOnly />
								<input id="searchSabun" name ="searchSabun" type="hidden" class="text"  />
								<a onclick="javascript:employeePopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
								<a onclick="$('#searchSabun,#searchName').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
							</td>
							<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>

			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">촉탁직평가표생성결과</li>
			<li class="btn">
				<a href="javascript:createPopup()" class="button authA">촉탁직평가표생성</a>
			</li>
		</ul>
		</div>
	</div>
	<div class="outer">
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "58px"); </script>
	</div>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">촉탁직평가표생성관리</li>
			<li class="btn">
				<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
				<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>
				<a href="javascript:doAction2('Copy')" 	class="basic authA">복사</a>
				<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>

</div>
</body>
</html>