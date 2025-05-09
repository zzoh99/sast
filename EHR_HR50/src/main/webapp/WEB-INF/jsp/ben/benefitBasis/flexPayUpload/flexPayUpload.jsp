<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>변동급여업로드</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script type="text/javascript">
		var gPRow = "";

		$(function() {
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
			initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
			initdata1.Cols = [
				{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",		Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",		Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"항목코드",	Type:"Text",	Hidden:1,  Width:0,  Align:"Center",  ColMerge:0,   SaveName:"benefitBizCd",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 },
				{Header:"항목명",	Type:"Text",	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"benefitBizNm",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 },
				{Header:"급여일자",	Type:"Text",	Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payActionNm",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 },
				{Header:"급여사업장코드",	Type:"Text",	Hidden:1,  Width:0,  Align:"Center",  ColMerge:0,   SaveName:"businessPlaceCd",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 },
				{Header:"급여사업장",	Type:"Text",	Hidden:0,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"businessPlaceNm",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 },
				{Header:"마감여부",	Type:"Text",	Hidden:0,  Width:70,  Align:"Center",  ColMerge:0,   SaveName:"magamYn",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 },
				{Header:"closeYn",	Type:"Text",	Hidden:1,  Width:0,  Align:"Center",  ColMerge:0,   SaveName:"closeYn",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0 }
			]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			var initdata2 = {};
			initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
			initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
			initdata2.Cols = [
				{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"payActionCd", Type:"Text",   Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"payActionCd",   KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:12 },

				{Header:"항목명",	Type:"Combo",	Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"benefitBizCd",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"성명",     Type:"Text",	Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"name",			KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"사번",     Type:"Text",	Hidden:1,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"금액",     Type:"Int",		Hidden:0,  Width:100,	Align:"Right",   ColMerge:0,   SaveName:"paymentMon",	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
				{Header:"비고",     Type:"Text",	Hidden:0,  Width:150,	Align:"Center",  ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"수정시간",	Type:"Date",	Hidden:0,  Width:150,	Align:"Center",  ColMerge:0,   SaveName:"chkdate",		KeyField:0,   CalcLogic:"",   Format:"YmdHm",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"수정 ID",	Type:"Text",	Hidden:0,  Width:150,	Align:"Center",  ColMerge:0,   SaveName:"chkid",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

			$(window).smartresize(sheetResize); sheetInit();
			var benefitBizCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B10230"), "");
			sheet2.SetColProperty("benefitBizCd", {ComboText:"|"+benefitBizCd[0], ComboCode:"|"+benefitBizCd[1]} );

			$("#searchSabunName").bind("keyup", function(event) {
				if (event.keyCode === 13) {
					doAction("Search");
					$(this).focus();
				}
			});

			// 성명 입력시 자동완성 처리
			$(sheet2).sheetAutocomplete({
				Columns: [
					{
						ColSaveName  : "name",
						CallbackFunc : function(returnValue){
							var rv = $.parseJSON('{' + returnValue+ '}');
							sheet2.SetCellValue(gPRow, "name", rv["name"]);
							sheet2.SetCellValue(gPRow, "sabun", rv["sabun"]);
						}
					}
				]
			});

			getCpnLatestPaymentInfo();
		});

		// 최근급여일자 조회
		function getCpnLatestPaymentInfo() {
			var procNm = "최근급여일자";
			// 급여구분(C00001-00001.급여)
			var paymentInfo = ajaxCall("${ctx}/FlexPayUpload.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001,00002,00003,R0001,R0002,R0003,J0001,ETC,RETRO", false);

			if (paymentInfo.DATA && paymentInfo.DATA[0]) {
				$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
				$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);
				$("#closeYn").val(paymentInfo.DATA[0].closeYn);

				if (paymentInfo.DATA[0].payActionCd) {
					doAction1("Search");
				}
			} else if (paymentInfo.Message) {
				alert(paymentInfo.Message);
			}
		}

		/**
		 * 마감 상태에 따른 버튼 세팅
		 * @param cpnCloseYn 급여마감상태(Y/N)
		 * @param closeYn 마감상태(Y/N)
		 */
		function setButtonByCloseStatus(cpnCloseYn, closeYn) {
			if (cpnCloseYn === "Y") {
				$("#cpnCloseMsg").show();

				$("#DetailDownTemplate").hide();
				$("#DetailInsert").hide();
				$("#DetailCopy").hide();
				$("#DetailSave").hide();
				$("#DetailLoadexcel").hide();

				$("#btnClose").hide();
				$("#btnCancel").hide();
				$(".authA").hide();
				sheet2.SetEditable(false);
			} else {
				$("#cpnCloseMsg").hide();

				if (!closeYn) {
					$("#DetailDownTemplate").hide();
					$("#DetailInsert").hide();
					$("#DetailCopy").hide();
					$("#DetailSave").hide();
					$("#DetailLoadexcel").hide();

					$("#btnClose").hide();
					$("#btnCancel").hide();
					$(".authA").hide();
					sheet2.SetEditable(false);
				} else if(closeYn === 'Y') {
					$("#DetailDownTemplate").hide();
					$("#DetailInsert").hide();
					$("#DetailCopy").hide();
					$("#DetailSave").hide();
					$("#DetailLoadexcel").hide();

					$("#btnClose").hide();
					$("#btnCancel").show();
					$(".authA").hide();
					sheet2.SetEditable(false);
				} else {
					$("#DetailDownTemplate").show();
					$("#DetailInsert").show();
					$("#DetailCopy").show();
					$("#DetailSave").show();
					$("#DetailLoadexcel").show();

					$("#btnClose").show();
					$("#btnCancel").hide();
					$(".authA").show();
					sheet2.SetEditable(true);
				}
			}
		}

		// Sheet1 Action
		function doAction1(sAction) {
			switch (sAction) {
			case "Search":
				if (!($("#searchPayActionCd").val())) {
					alert("급여일자를 입력해주세요.");
					return;
				}

				sheet1.DoSearch( "${ctx}/FlexPayUpload.do?cmd=getFlexPayUploadFirstList", $("#sheetForm").serialize() );
				sheet2.RemoveAll();
				break;
			}
		}

		// Sheet2 Action
		function doAction2(sAction) {
			switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/FlexPayUpload.do?cmd=getFlexPayUploadSecondList", $("#sheetForm").serialize());
				break;
			case "Save":
				if(!dupChk(sheet2,"benefitBizCd|sabun", false, true)) break;
				IBS_SaveName(document.sheetForm, sheet2);
				sheet2.DoSave( "${ctx}/FlexPayUpload.do?cmd=saveFlexPayUpload", $("#sheetForm").serialize());
				break;
			case "Insert":
				if (sheet1.GetSelectRow() < 0) {
					alert("Master 데이터를 선택해주시기 바랍니다.");
					return;
				} else {
					var newRow = sheet2.DataInsert(0);
					sheet2.SetCellValue(newRow, "benefitBizCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "benefitBizCd"));
				}
				break;
			case "Copy":
				sheet2.DataCopy(); break;
			case "Clear":
				sheet2.RemoveAll(); break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet2.Down2Excel(param);
				break;
			case "LoadExcel":
				// 업로드
				if (sheet1.GetSelectRow() < 0) {
					alert("Master 데이터를 선택해주시기 바랍니다.");
					return;
				}
				var params = {};
				sheet2.LoadExcel(params);
				break;
			case "DownTemplate":
				// 양식다운로드
				sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|name|paymentMon|note"});
				break;
			case "Close" :
				callProcPerRow("Close");
				break;
			case "Cancel" :
				callProcPerRow("Cancel");
				break;
			}
		}

		function sheet2_OnLoadExcel(){
			if (sheet1.GetSelectRow() < 0) {
				alert("Master 데이터를 선택해주시기 바랍니다.");
				sheet2.RemoveAll();
			} else {
				for(var i = 1; i <= sheet2.RowCount(); i++) {
					sheet2.SetCellValue(i, "benefitBizCd", sheet1.GetCellValue( sheet1.GetSelectRow(), "benefitBizCd"));
				}
			}
		}

		// 조회 후 에러 메시지
		function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg !== "")
					alert(Msg);

				sheetResize();

				if (sheet1.RowCount() > 0) {
					$("#searchBenefitBizCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "benefitBizCd"));
					ajaxCall2("${ctx}/FlexPayUpload.do?cmd=getCpnQueryList"
							, "queryId=getCpnCloseYnMap&payActionCd="+$("#searchPayActionCd").val()
							, true
							, null
							, function(data) {
								if (data && data.DATA && data.DATA[0]) {
									$("#closeYn").val(data.DATA[0].closeYn);
									setButtonByCloseStatus(data.DATA[0].closeYn, sheet1.GetCellValue(sheet1.GetSelectRow(), "closeYn"));
									doAction2('Search');
								}
							}, function() {
								setButtonByCloseStatus($("#closeYn").val(), sheet1.GetCellValue(Row, "closeYn"));
								doAction2('Search');
							});
				}
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// Detail 항목 검색
		function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
			$("#searchBenefitBizCd").val(sheet1.GetCellValue(Row, "benefitBizCd"));
			ajaxCall2("${ctx}/FlexPayUpload.do?cmd=getCpnQueryList"
					, "queryId=getCpnCloseYnMap&payActionCd="+$("#searchPayActionCd").val()
					, true
					, null
					, function(data) {
						if (data && data.DATA && data.DATA[0]) {
							$("#closeYn").val(data.DATA[0].closeYn);
							setButtonByCloseStatus(data.DATA[0].closeYn, sheet1.GetCellValue(Row, "closeYn"));
							doAction2('Search');
						}
					}, function() {
						setButtonByCloseStatus($("#closeYn").val(), sheet1.GetCellValue(Row, "closeYn"));
						doAction2('Search');
					});
		}

		// 조회 후 에러 메시지
		function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg)
					alert(Msg);

				sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}


		// 저장 후 메시지
		function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg)
					alert(Msg);

				doAction2('Search');
			} catch (ex) {
				alert("OnSaveEnd Event Error " + ex);
			}
		}

		//  급여일자 조회 팝업
		function openPayDayPopup(){
			const getCloseYn = (closeYn) => {
				return (closeYn === "1" || closeYn === "Y") ? "Y" : "N";
			}

			let layerModal = new window.top.document.LayerModal({
				id : 'payDayLayer'
				, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
				, parameters : {
					runType : '00001,00002,00003,R0001,R0002,R0003,J0001,ETC,RETRO'
				}
				, width : 840
				, height : 520
				, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
				, trigger :[
					{
						name : 'payDayTrigger'
						, callback : function(result){
							$("#searchPayActionCd").val(result.payActionCd);
							$("#searchPayActionNm").val(result.payActionNm);
							$("#searchSabunName").val("");
							$("#closeYn").val(getCloseYn(result.closeYn));

							doAction1("Search");
						}
					}
				]
			});
			layerModal.show();
		}

		function callProcPerRow(procName) {

			if(!($("#searchPayActionCd").val())) {
				alert("급여일자를 선택하여 주십시오.");
				return;
			}

			const row = sheet1.GetSelectRow();

			const cpnClose = ajaxCall("${ctx}/FlexPayUpload.do?cmd=getCpnQueryList", "queryId=getCpnCloseYnMap&payActionCd="+$("#searchPayActionCd").val(), false);
			let cpnCloseYn = "N";
			if (cpnClose.DATA && cpnClose.DATA[0]) {
				cpnCloseYn = cpnClose.DATA[0].closeYn;
			} else if (cpnClose.Message) {
				alert(cpnClose.Message);
				return;
			}

			if(cpnCloseYn === "Y") {
				setButtonByCloseStatus(cpnCloseYn, sheet1.GetCellValue(row, "closeYn"));
				alert("해당 급여작업이 마감되었습니다. 급여담당자가 급여 마감을 풀어야 변동급여에 관한 작업을 진행할 수 있습니다.");
			} else {
				if( sheet2.RowCount("I") > 1 ) {
					alert("입력중인 행이 존재합니다. 저장후 처리하시기 바랍니다.");
					return;
				}

				const procNm = (procName === "Close") ? "마감" : "마감취소";
				const msg = "급여일자 " + sheet1.GetCellValue(row, "payActionNm") + " 에 대한 " + sheet1.GetCellValue(row, "businessPlaceNm") + " 급여사업장의 " + sheet1.GetCellValue(row, "benefitBizNm") + " 항목을 " + procNm + "하시겠습니까?";
				if (!confirm(msg)) return;

				callProc(procName);
			}
		}

		function callProc(procName) {
			const isValidProcName = (procName) => {
				return (procName === "Close" || procName === "Cancel");
			}

			if (!isValidProcName(procName)) {
				alert("유효하지 않은 마감 상태입니다. 새로고침 후 다시 시도해주시기 바랍니다.");
				return;
			}

			const procNm = (procName === "Close") ? "마감" : "마감취소";
			progressBar(true, procNm + " 중입니다.");

			const row = sheet1.GetSelectRow();

			const params = "searchPayActionCd=" + $("#searchPayActionCd").val()
					+ "&searchBusinessPlaceCd=" + sheet1.GetCellValue(row, "businessPlaceCd")
					+ "&searchBenefitBizCd=" + sheet1.GetCellValue(row, "benefitBizCd");

			ajaxCall2("/FlexPayUpload.do?cmd=call" + ((procName === "Close") ? "P_BEN_PAY_DATA_CLOSE" : "P_BEN_PAY_DATA_CLOSE_CANCEL")
					, params
					, true
					, null
					, function (data) {
						console.log(data);
						progressBar(false);
						if (!data || !data.Result) {
							alert(procNm + "처리를 사용할 수 없습니다. 관리자에게 문의바랍니다.");
							return;
						}

						if (!data.Result.Code || data.Result.Code === "OK") {
							alert("정상적으로 " + procNm + " 처리되었습니다.");
						} else {
							alert(row + "행 데이터 처리도중 : " + data.Result.Message);
						}
						doAction1("Search");
					}, function (xhr) {
						progressBar(false);
						alert("처리 중 오류가 발생하였습니다. 관리자에게 문의바랍니다.");
					});
		}
	</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchBenefitBizCd" name="searchBenefitBizCd"/>
		<input type="hidden" id="closeYn" name="closeYn"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span><label for="searchPayActionNm">급여일자</label></span>
							<input id="searchPayActionNm" name="searchPayActionNm" type="text" class="text" style="width:160px;" readOnly />
							<input type="hidden" id="searchPayActionCd" name="searchPayActionCd"/>
							<a onclick="javascript:openPayDayPopup()" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<td>
							<span><label for="searchSabunName">성명/사번</label></span>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" style="width:100px;"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
						<td>
							<span id="cpnCloseMsg" style="display: none; color: red;">이미 마감된 급여입니다. 급여담당자에게 문의바랍니다.</span>
							<a href="javascript:doAction2('Close')" id="btnClose" class="button" style="display: none;">마감</a>
							<a href="javascript:doAction2('Cancel')" id="btnCancel" class="button" style="display: none;">마감취소</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="40%" />
			<col width="60%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">Master</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%"); </script>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">Detail</li>
						<li class="btn">
								<a href="javascript:doAction2('DownTemplate')" class="basic authA" id="DetailDownTemplate" >양식다운로드</a>
								<a href="javascript:doAction2('Insert')" class="basic authA" id ="DetailInsert">입력</a>
								<a href="javascript:doAction2('Copy')" 	class="basic authA" id ="DetailCopy">복사</a>
								<a href="javascript:doAction2('Save')" 	class="basic authA" id ="DetailSave">저장</a>
								<a href="javascript:doAction2('LoadExcel')" class="basic authA" id ="DetailLoadexcel">업로드</a>
								<a href="javascript:doAction2('Down2Excel')" class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "70%", "100%"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>