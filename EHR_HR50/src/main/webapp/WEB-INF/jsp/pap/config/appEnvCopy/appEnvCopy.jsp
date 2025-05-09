<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가환경복사</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var famList = null
	var mltsrcAppraisalCdList = null;

	$(function() {
		
		famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); // 평가명
		mltsrcAppraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=D,",false).codeList, "");
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
				{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
				{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
				{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

				{Header:"선택",		Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"copy",			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
				{Header:"복사항목",	Type:"Text",		Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"tarName",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"대상테이블",	Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"tableNm",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"원본",		Type:"Combo",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"orignParam",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"대상",		Type:"Combo",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"targetParam",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"생성여부",	Type:"Text",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"copyYn",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"table",	Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"tableNm",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"orderSeq",	Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"orderSeq",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("orignParam", {ComboText:famList[0], ComboCode:famList[1]} );
		sheet1.SetColProperty("targetParam", {ComboText:famList[0], ComboCode:famList[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		var sCode = "";
		if ( famList[1] != "") sCode = famList[1].split("|")[0];

		$("#orignParam1").val( sCode );
		$("#orignParam2").val( sCode );
		$("#orignParam3").val( sCode );
		$("#orignParam4").val( sCode );
		$("#orignParam5").val( sCode );
		$("#orignParam6").val( sCode );
		$("#orignParam7").val( mltsrcAppraisalCdList[1].split("|")[0] );
		$("#orignParam8").val( sCode );
		$("#orignParam9").val( sCode );

		$("#targetParam1").val( sCode );
		$("#targetParam2").val( sCode );
		$("#targetParam3").val( sCode );
		$("#targetParam4").val( sCode );
		$("#targetParam5").val( sCode );
		$("#targetParam6").val( sCode );
		$("#targetParam7").val( mltsrcAppraisalCdList[1].split("|")[0] );
		$("#targetParam8").val( sCode );
		$("#targetParam9").val( sCode );

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	sheet1.DoSearch( "${ctx}/AppEnvCopy.do?cmd=getAppEnvCopyList", $("#srchFrm").serialize() ); break;
		case "Save":
			var checked = false;
			var k = 0;
			var copyYnMsg = "";

			for(i=1; i<=sheet1.LastRow(); i++) {
				if (sheet1.GetCellValue(i, "copy") == "Y") {
					checked = true;
					if(sheet1.GetCellValue(i, "orignParam" ) == sheet1.GetCellValue(i, "targetParam" )){
						k++;
					}

					if ( sheet1.GetCellValue(i, "copyYn") == "Y" ) {
						copyYnMsg = copyYnMsg + sheet1.GetCellValue(i, "tarName") + ",";
					}
				}
			}

			if( !checked ){
				alert("복사항목을 선택하세요.");
				return;
			}

			if(k > 0) {
				alert("원본과 대상이 같은 평가명으로 되어 있는것이 존재합니다.");
				return;
			}

			if ( copyYnMsg != "" ) {
				copyYnMsg = copyYnMsg.substring(0, copyYnMsg.length-1);
				alert(copyYnMsg + "에 생성된 평가자료가 있습니다.\n삭제는 해당 화면으로 이동하여 삭제 하시기 바랍니다.");
				return;
			}

			if( !confirm("환경복사를 하시겠습니까?")){
				return;
			}
			
			//IBS_SaveName(document.srchFrm,sheet1);
			//sheet1.DoSave( "${ctx}/AppEnvCopy.do?cmd=prcAppEnvCopy", $("#srchFrm").serialize(), -1, false); break;
			
			for( var i = 1; i < sheet1.RowCount	()+1; i++ ) {
				if (sheet1.GetCellValue(i, "copy") == "Y") {
					$("#orignParam"+i).val( sheet1.GetCellValue(i, "orignParam" ) );
					$("#targetParam"+i).val( sheet1.GetCellValue(i, "targetParam" ) );
					
					var params = "tableNm=" + sheet1.GetCellValue(i, "tableNm") + 
						"&orignParam=" + sheet1.GetCellValue(i, "orignParam") + 
						"&targetParam=" + sheet1.GetCellValue(i, "targetParam");
					var data = ajaxCall("${ctx}/AppEnvCopy.do?cmd=prcAppEnvCopy", params, false);
					
					if (data != null && data.Result != null && data.Result.Code != null && data.Result.Message != null) {
						alert(data.Result.Message);
						doAction1("Search");
						return;
					}
				}
			}
			
			alert("환경복사를 완료하였습니다.");
			doAction1("Search");
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			/*
			sheet1.SetCellValue(1, "tarName", "역량평가항목정의",0);	sheet1.SetCellValue(1, "sStatus", "R",0);
			sheet1.SetCellValue(2, "tarName", "평가그룹관리",0);			sheet1.SetCellValue(2, "sStatus", "R",0);
			
			sheet1.SetCellValue(3, "tarName", "종합평가반영비율",0);		sheet1.SetCellValue(3, "sStatus", "R",0);
			sheet1.SetCellValue(4, "tarName", "평가등급배분항목",0);			sheet1.SetCellValue(4, "sStatus", "R",0);
			sheet1.SetCellValue(5, "tarName", "평가SHEET",0);		sheet1.SetCellValue(5, "sStatus", "R",0);
			
			sheet1.SetCellValue(6, "tarName", "차수별 평가등급관리",0);		sheet1.SetCellValue(6, "sStatus", "R",0);
			sheet1.SetCellValue(7, "tarName", "다면평가항목정의",0);	sheet1.SetCellValue(7, "sStatus", "R",0);
			*/
			
			if ( sheet1.RowCount() > 0 ){
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
					sheet1.SetCellValue(i, "sStatus", "R",0);
					
					/* 20190708 다면평가항목정의 추가 */
					if( sheet1.GetCellValue(i, "tableNm") == "TPAP407" ) {
						if( mltsrcAppraisalCdList != null && mltsrcAppraisalCdList[0] != undefined && mltsrcAppraisalCdList[0].length > 0 ) {
							sheet1.CellComboItem(i, "orignParam",  {"ComboText" : mltsrcAppraisalCdList[0], "ComboCode" : mltsrcAppraisalCdList[1]});
							sheet1.CellComboItem(i, "targetParam", {"ComboText" : mltsrcAppraisalCdList[0], "ComboCode" : mltsrcAppraisalCdList[1]});
						} else {
							sheet1.CellComboItem(i, "orignParam",  {"ComboText" : "|-", "ComboCode" : "|"});
							sheet1.CellComboItem(i, "targetParam", {"ComboText" : "|-", "ComboCode" : "|"});
						}
					}
				}
			}
			
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != -1 ) {
				// 조회 시 일부 행을 주석처리할 경우 정확한 행번호를 취득하기 위하여 orderSeq를 이용하여 행번호를 취득하도록 변경
				$("#orignParam1").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "1"), "orignParam" ) );
				$("#orignParam2").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "2"), "orignParam" ) );
				$("#orignParam3").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "3"), "orignParam" ) );
				$("#orignParam4").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "4"), "orignParam" ) );
				$("#orignParam5").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "5"), "orignParam" ) );
				$("#orignParam6").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "6"), "orignParam" ) );
				$("#orignParam7").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "7"), "orignParam" ) );
				$("#orignParam8").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "8"), "orignParam" ) );
				$("#orignParam9").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "9"), "orignParam" ) );

				$("#targetParam1").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "1"), "targetParam" ) );
				$("#targetParam2").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "2"), "targetParam" ) );
				$("#targetParam3").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "3"), "targetParam" ) );
				$("#targetParam4").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "4"), "targetParam" ) );
				$("#targetParam5").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "5"), "targetParam" ) );
				$("#targetParam6").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "6"), "targetParam" ) );
				$("#targetParam7").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "7"), "targetParam" ) );
				$("#targetParam8").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "8"), "targetParam" ) );
				$("#targetParam9").val( sheet1.GetCellValue(sheet1.FindText("orderSeq", "9"), "targetParam" ) );

				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 변경 시
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "targetParam" ) {
				$("#targetParam").val( sheet1.GetCellValue(Row, "targetParam" ) );
				$("#tableNm").val( sheet1.GetCellValue(Row, "tableNm" ) );

				var data = ajaxCall("${ctx}/AppEnvCopy.do?cmd=getAppEnvCopyMap", $("#srchFrm2").serialize(), false);

				if(data.DATA != null){
					var copyYn = data.DATA.copyYn;
					sheet1.SetCellValue(Row, "copyYn", copyYn);
				}
			}
		}catch(ex){
			alert("OnChange Event Error " + ex);
		}
	}
</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" name="orignParam1" id="orignParam1" value="">
	<input type="hidden" name="orignParam2" id="orignParam2" value="">
	<input type="hidden" name="orignParam3" id="orignParam3" value="">
	<input type="hidden" name="orignParam4" id="orignParam4" value="">
	<input type="hidden" name="orignParam5" id="orignParam5" value="">
	<input type="hidden" name="orignParam6" id="orignParam6" value="">
	<input type="hidden" name="orignParam7" id="orignParam7" value="">
	<input type="hidden" name="orignParam8" id="orignParam8" value="">
	<input type="hidden" name="orignParam9" id="orignParam9" value="">

	<input type="hidden" name="targetParam1" id="targetParam1" value="">
	<input type="hidden" name="targetParam2" id="targetParam2" value="">
	<input type="hidden" name="targetParam3" id="targetParam3" value="">
	<input type="hidden" name="targetParam4" id="targetParam4" value="">
	<input type="hidden" name="targetParam5" id="targetParam5" value="">
	<input type="hidden" name="targetParam6" id="targetParam6" value="">
	<input type="hidden" name="targetParam7" id="targetParam7" value="">
	<input type="hidden" name="targetParam8" id="targetParam8" value="">
	<input type="hidden" name="targetParam9" id="targetParam9" value="">

	</form>
	<form id="srchFrm2" name="srchFrm2">
	<input type="hidden" name="targetParam" id="targetParam" value="">
	<input type="hidden" name="tableNm" id="tableNm" value="">
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">평가환경복사</li>
							<li class="btn">
								<a href="javascript:doAction1('Save')" class="btn filled authA">평가환경복사</a>
							    <a href="javascript:doAction1('Search')" class="btn dark authR">조회</a>
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