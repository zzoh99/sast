<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote1=Y",false).codeList, "");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
    		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"S등급비율"	,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appSRate",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"A등급비율"	,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appARate",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"B등급비율"	,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appBRate",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"C등급비율"	,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appCRate",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"D등급비율"	,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appDRate",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"합계"		,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"totCnt",		KeyField:0,   CalcLogic:"|appSRate|+|appARate|+|appBRate|+|appCRate|+|appDRate|",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"비고"		,Type:"Text",     	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },

            {Header:"평가ID"		,Type:"Text",     	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetUnicodeByte(3);

		initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가차수"		,Type:"Text",     	Hidden:0,  Width:70, 	Align:"Center",	ColMerge:0,   SaveName:"appSeqNm",		KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"평가그룹"		,Type:"Text",     	Hidden:0,  Width:70, 	Align:"Center",	ColMerge:0,   SaveName:"appGroupNm",	KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"전체\n기준인원"	,Type:"Text",     	Hidden:0,  Width:60,  	Align:"Center",	ColMerge:0,   SaveName:"totCnt",		KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
   			{Header:"S등급"			,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appGroupSCnt",	KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"A등급"			,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appGroupACnt",	KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"B등급"			,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appGroupBCnt",	KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"C등급"			,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appGroupCCnt",	KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"D등급"			,Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appGroupDCnt",	KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"등급별\n계획인원",Type:"Int",     	Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"totCalc",		KeyField:0,   CalcLogic:"|appGroupSCnt|+|appGroupACnt|+|appGroupBCnt|+|appGroupCCnt|+|appGroupDCnt|",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"비고"			,Type:"Text",     	Hidden:0,  Width:100,	Align:"Left",	ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },

            {Header:"평가ID"			,Type:"Text",     	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"appSeqCd"		,Type:"Text",     	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appSeqCd",		KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"평가대상그룹"		,Type:"Text",     	Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"appGroupCd",	KeyField:1,   CalcLogic:"",   Format:"",      PointCount:0, UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);

		sheet2.SetDataLinkMouse("totCnt",1);

		$(window).smartresize(sheetResize); sheetInit();

		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]); //평가명
		$("#searchAppSeqCd").html("<option value=''>전체</option>"+appSeqCdList[2]);

        $("#searchAppraisalCd, #searchAppSeqCd").bind("change",function(event){
			doAction1("Search");
		});

		doAction1("Search");
	});
</script>
<!-- sheet1 script -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppGradeOrgRateMgr.do?cmd=getAppGradeOrgRateMgrList1", $("#srchFrm").serialize() ); break;
		case "Save":
							if(sheet1.FindStatusRow("I") != ""){
								if(!dupChk(sheet1,"appraisalCd", false, true)){break;}
							}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppGradeOrgRateMgr.do?cmd=saveAppGradeOrgRateMgr1", $("#srchFrm").serialize());
							break;
		case "Insert":
							if ( sheet1.RowCount() > 0 ) {
								alert("기준배분비율은 한건만 입력 가능합니다.");
								return;
							}

							var row = sheet1.DataInsert(0);
							sheet1.SetCellValue(row,"appraisalCd",$("#searchAppraisalCd").val());
							sheet1.SelectCell(row, "appSRate");
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param = {DownCols:downcol, SheetDesign:1, Merge:1};
							sheet1.Down2Excel(param);
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			if ( Code != -1 ) doAction2("Search");
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != -1 ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
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

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		if(sheet1.GetCellValue(Row, "totCnt") > 100){
			alert('등급의 합은 100을 초과 할수 없습니다.');
			sheet1.ReturnCellData(Row, Col);
		}
	}
</script>

<!-- sheet2 script -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/AppGradeOrgRateMgr.do?cmd=getAppGradeOrgRateMgrList2", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet2);
							sheet2.DoSave( "${ctx}/AppGradeOrgRateMgr.do?cmd=saveAppGradeOrgRateMgr2", $("#srchFrm").serialize());
							break;
		case "Insert":		var row = sheet2.DataInsert(0);
							break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet2);
							var param = {DownCols:downcol, SheetDesign:1, Merge:1};
							sheet2.Down2Excel(param);
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		case "Proc":
							if(!confirm("평가그룹별 인원배분계획 생성작업을 하시겠습니까?")) return;

							var data = ajaxCall("${ctx}/AppGradeOrgRateMgr.do?cmd=prcAppGradeOrgRateMgr",$("#srchFrm").serialize(),false);
		    				if(data.Result.Code == null) {
					    		alert("인원배분계획 생성작업이 완료되었습니다.");
					    		doAction1("Search");
		    		    	} else {
		    			    	alert(data.Result.Message);
		    		    	}

							break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != -1 ) doAction2("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	//
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet2.ColSaveName(Col) == "totCnt"){
				if(!isPopup()) {return;}

        		var args = new Array();
       			args["searchAppraisalCd"] = sheet2.GetCellValue(Row, "appraisalCd");
       			args["searchAppSeqCd"] = sheet2.GetCellValue(Row, "appSeqCd");
       			args["searchAppGroupCd"] = sheet2.GetCellValue(Row, "appGroupCd");

        		openPopup("${ctx}/AppGradeOrgRateMgr.do?cmd=viewAppGradeOrgRateMgrPop",args,1000,500);
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >

		<div class="sheet_search outer">
			<div>

				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td>
							<span>평가차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd" class="box"></select>
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
			<li class="txt">기준배분비율</li>
			<li class="btn">
				<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
				<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
			</li>

		</ul>
		</div>
	</div>
	<div class="outer">
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "56px"); </script>
	</div>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">인원배분기준표</li>
			<li class="btn">
				<a href="javascript:doAction2('Proc')" 			class="button authA">인원배분기준표생성</a>
				<a href="javascript:doAction2('Search')" 		id="btnSearch" class="button">조회</a>
				<a href="javascript:doAction2('Save')" 			class="basic authA">저장</a>
				<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>

</div>
</body>
</html>