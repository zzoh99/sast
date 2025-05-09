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
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,						Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가자|사번",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"appSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가자|성명",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"appName",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가자|호칭",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"alias",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가자|소속",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가자|직급",		Type:"Text",		Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가자|직위",		Type:"Text",		Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가자|직책",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"차수|차수",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"appSeqNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹|평가그룹",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"평가ID|평가ID",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가단계|평가단계",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appStepCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수|평가차수",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appSeqCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가그룹|평가그룹",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속|평가소속",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata.Cols = [
   			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
   			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },

   			{Header:"피평가자|사번",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"피평가자|성명",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"피평가자|호칭",			Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"alias",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"피평가자|소속",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"피평가자|직급",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"피평가자|직위",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"피평가자|직책",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"완료\n여부|완료\n여부",	Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"appraisalYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },

			{Header:"평가ID|평가ID",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가단계|평가단계",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appStepCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수|평가차수",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appSeqCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속|평가소속",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가자사번|평가자사번",Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {

		$("#searchAppraisalCd").change(function(){

			if($("#searchAppraisalCd").val() != ""){
				var data   = ajaxCall("${ctx}/AppAdjStausMng.do?cmd=getBaseYmd","&searchAppraisalCd="+$("#searchAppraisalCd").val(),false);

				if(data.map != null && data.map != ""){
					$("#baseYmd").val(data.map.baseYmd);
					doAction1("Search");
				}
			}

		});

		$("#searchAppSeqCd, #searchAppraisalYn").change(function(){

			doAction1("Search");
		});

		$("#searchNameSabun").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);

		var data   = ajaxCall("${ctx}/AppAdjStausMng.do?cmd=getBaseYmd","&searchAppraisalCd="+$("#searchAppraisalCd").val(),false);

		if(data.map != null && data.map != ""){
			$("#baseYmd").val(data.map.baseYmd);
		}

		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote3=Y",false).codeList, "");
		$("#searchAppSeqCd").html(appSeqCdList[2]);

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AppAdjStausMng.do?cmd=getAppAdjStausMngList1", $("#srchFrm").serialize() );
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			doAction2("Clear");

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

	// 셀이 선택 되었을때 발생한다
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;

			doAction2("Search");
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var Row = sheet1.GetSelectRow();
			$("#searchAppraisalCd2").val( sheet1.GetCellValue(Row, "appraisalCd"));
			$("#searchAppGroupCd2").val( sheet1.GetCellValue(Row, "appGroupCd"));
			$("#searchAppSeqCd2").val( sheet1.GetCellValue(Row, "appSeqCd"));
			$("#searchAppSabun2").val( sheet1.GetCellValue(Row, "appSabun"));

			sheet2.DoSearch( "${ctx}/AppAdjStausMng.do?cmd=getAppAdjStausMngList2", $("#srchFrm2").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.srchFrm2,sheet2);
			sheet2.DoSave( "${ctx}/AppAdjStausMng.do?cmd=saveAppAdjStausMng2", $("#srchFrm2").serialize());
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
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
	<input type="hidden" name="baseYmd" id="baseYmd">
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
							<select name="searchAppSeqCd" id="searchAppSeqCd">
							</select>
						</td>
						<td>
							<span>평가자 성명 /사번</span>
							<input id="searchNameSabun" name ="searchNameSabun" value="" type="text" class="text" />
						</td>
						<td>
							<span>평가완료여부</span>
							<select name="searchAppraisalYn" id="searchAppraisalYn">
								<option value="">전체</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
						<li id="txt" class="txt">평가자</li>
						<li class="btn">
							<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
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
						<li id="txt" class="txt">피평가자</li>
						<li class="btn">
							<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
							<a href="javascript:doAction2('Save');" 	class="btn filled authA">저장</a>
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