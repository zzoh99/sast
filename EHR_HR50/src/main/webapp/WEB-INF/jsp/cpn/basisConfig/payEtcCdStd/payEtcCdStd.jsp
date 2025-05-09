<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='113825' mdef='급여테이블관리(파견)'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
                {Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",     Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                {Header:"<sht:txt mid='resultV2' mdef='결과'/>",     Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
                {Header:"<sht:txt mid='sStatus' mdef='상태'/>",     Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
				{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",     Type:"Text",     Hidden:0,  Width:130,   Align:"Left",    ColMerge:0,   SaveName:"globalValueCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
				{Header:"<sht:txt mid='codeNm' mdef='코드명'/>",   Type:"Text",     Hidden:0,  Width:150,   Align:"Left",    ColMerge:0,   SaveName:"globalValueNm",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
				{Header:"<sht:txt mid='description' mdef='설명'/>",     Type:"Text",     Hidden:0,  Width:300,   Align:"Left",    ColMerge:0,   SaveName:"description",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='dataTypeV3' mdef='Type'/>",     Type:"Combo",    Hidden:0,  Width:70,    Align:"Center",  ColMerge:0,   SaveName:"dataType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='globalValue' mdef='코드값'/>",   Type:"Text",     Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"globalValue",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>", Type:"Date",     Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sdate",            KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>", Type:"Date",     Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"edate",            KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		];
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);


		sheet1.SetColProperty("dataType", 			{ComboText:"|Number|Character", ComboCode:"|N|C"} );

		$("#searchGlobalValueNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");

		$(".sheet_search>div>table>tr input[type=text],select").each(function(){

		});
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PayEtcCdStd.do?cmd=getPayEtcCdStdList", $("#sheet1Form").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"globalValueCd|sdate", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PayEtcCdStd.do?cmd=savePayEtcCdStd", $("#sheet1Form").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), ""); break;
		case "Copy":
				sheet1.SelectCell(sheet1.DataCopy(), 7);
				break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
        		var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 값 변경 시 이벤트
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		const isDisableNumberType = (_Row) => {
			// Type 이 숫자인데 코드값이 숫자가 아닌 경우를 체크
			return sheet1.GetCellValue(_Row, "dataType") === "N"
					&& sheet1.GetCellValue(_Row, "globalValue")
					&& /[^0-9.\-]/.test(sheet1.GetCellValue(_Row, "globalValue"));
		}

		try {
			if (sheet1.ColSaveName(Col) === "globalValue" || sheet1.ColSaveName(Col) === "dataType") {
				if (isDisableNumberType(Row)) {
					alert("Type이 숫자일 경우 숫자만 입력 가능합니다.");
					sheet1.SetCellValue(Row, Col, OldValue);
				}
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113120' mdef='코드명 '/> </th>
						<td>  <input id="searchGlobalValueNm" name ="searchGlobalValueNm" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='payEtcCdStd' mdef='급여기타기준관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')"       css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	      css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" 	      css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction('Down2Excel')"   css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
