<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"평가차수코드",		Type:"Combo",	Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",	KeyField:1, CalcLogic:"", Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"순번",			Type:"Int",		Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1, CalcLogic:"", Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
			{Header:"평가항목",		Type:"Text",	Hidden:0,  Width:480,	Align:"Left",	ColMerge:0,	SaveName:"appItem",		KeyField:1, CalcLogic:"", Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000, MultiLineText:1 },
			{Header:"비고",			Type:"Text",	Hidden:0,  Width:280,	Align:"Left",	ColMerge:0,	SaveName:"remark",		KeyField:0, CalcLogic:"", Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000, MultiLineText:1 },
			
			{Header:"평가ID코드",		Type:"Text",	Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0, CalcLogic:"", Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		sheet1.SetEditEnterBehavior("newline");
		
		var appraisalCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=D,",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		//$("#searchAppraisalCd").change();

		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalIdMgrTab2CdList&useYn=Y&searchAppraisalCd=" + $("#searchAppraisalCd").val(),false).codeList, "전체");
		sheet1.SetColProperty("appSeqCd", {ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );
		$("#searchAppSeqCd").html(appSeqCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/MltsrcAppItemMgnr.do?cmd=getMltsrcAppItemMgnrList", $("#srchFrm").serialize() );
			break;
			
		case "Save":
			if(!dupChk(sheet1,"appraisalCd|appSeqCd|seq", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/MltsrcAppItemMgnr.do?cmd=saveMltsrcAppItemMgnr", $("#srchFrm").serialize());
			break;
			
		case "Insert":
			var Row = sheet1.DataInsert(0);
			var appSeqCd = $("#searchAppSeqCd").val();
			if(appSeqCd != "") {
				sheet1.SetCellValue( Row, "seq", getMaxSeq(Row, appSeqCd) );
			}
			sheet1.SetCellValue( Row, "appraisalCd", $("#searchAppraisalCd").val() );
			sheet1.SetCellValue( Row, "appSeqCd",    $("#searchAppSeqCd").val() );
			break;
			
		case "Copy":
			var Row = sheet1.DataCopy();
			var appSeqCd = sheet1.GetCellValue( Row, "appSeqCd" );
			if(appSeqCd != "") {
				sheet1.SetCellValue( Row, "seq", getMaxSeq(Row, appSeqCd) );
			}
			break;
			
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	function sheet1_OnClick(Row, Col, Value) {
		try{

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function sheet1_OnChange(Row, Col, Value) {
		try{
			var saveName = sheet1.ColSaveName(Col);
			
			if( saveName == "appSeqCd" ) {
				if( Value != "" ) {
					sheet1.SetCellValue(Row, "seq", getMaxSeq(Row, Value));
				} else {
					sheet1.SetCellValue(Row, "seq", "");
				}
			}
			
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	
	// 지정 평가차수에 해당하는 데이터들의 seq 값 최대값 반환
	function getMaxSeq(Row, sAppSeqCd) {
		var maxNo = 0;
		for(var i = 1; i < sheet1.RowCount()+1; i++) {
			if( i != Row ) {
				var seq = sheet1.GetCellValue( i, "seq" );
				var appSeqCd = sheet1.GetCellValue( i, "appSeqCd" );
				if(sAppSeqCd == appSeqCd) {
					if( seq != "" ) {
						seq = Number(seq);
					}
					if(seq > maxNo) {
						maxNo = seq;
					}
				}
			}
		}
		maxNo++;
		return maxNo;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td><span>평가명</span>
							<select id="searchAppraisalCd" name="searchAppraisalCd" onChange="javaScript:doAction1('Search');"></select>
						</td>
						<td><span>차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd" onChange="javaScript:doAction1('Search');"></select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
							<li id="txt" class="txt">다면평가항목정의</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>