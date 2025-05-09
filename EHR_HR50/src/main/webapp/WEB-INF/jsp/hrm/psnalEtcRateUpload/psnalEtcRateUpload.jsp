<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기타사항업로드(지급율)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Popup",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"divCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='payRate' mdef='지급율'/>",	Type:"Float",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"rate",		KeyField:0,	Format:"",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:330, MultiLineText:1, ToolTip:1},
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90199"), "<tit:txt mid='103895' mdef='전체'/>");
		var userCd1 = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getPsnalEtcRateUploadCodeList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("divCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		$("#searchDivCd").html(userCd1[2]);
		$("#fromSdate").datepicker2({startdate:"toSdate"});
		$("#toSdate").datepicker2({enddate:"fromSdate"});
// 		$("#fromSdate").val("${curSysYyyyMMHyphen}-01") ;
// 		$("#toSdate").val("${curSysYyyyMMHyphen}-31") ;
		$("#fromSdate, #toSdate, #searchSaNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search") ;

	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PsnalEtcRateUpload.do?cmd=getPsnalEtcRateUploadList",$("#sheet1Form").serialize() );
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Save":
// 			if(!dupChk(sheet1,"sabun|gntCd|applYmd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalEtcRateUpload.do?cmd=savePsnalEtcRateUpload" ,$("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "chkdate", "");
			sheet1.SetCellValue(row, "chkNm",	"");
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({
					TitleText:"*기타사항자료업로드"
						+ "\n*필수입력항목 : '사번', '구분', '시작일자'"
						+ "\n*파일로드시에는 이 행을 삭제해야 합니다."
					, SheetDesign:1,Merge:1,DownRows:0,DownCols:"sabun|divCd|sdate|edate|rate|memo",ExcelRowHeight:"40"});
			break;
		case "LoadExcel":
			/* if($("#searchDivCd").val() == ""){
				alert("<msg:txt mid='109722' mdef='구분을 선택해주세요.'/>");
				break;
			}
			sheet1.RemoveAll(); */
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
		break;
		}
	}

	function sheet1_OnLoadExcel() {

		for(var i = sheet1.HeaderRows(); i<sheet1.LastRow()+sheet1.HeaderRows(); i++) {
			if(sheet1.GetCellValue(i,"divCd") == "") {
				sheet1.SetCellValue(i, "divCd", $("#searchDivCd option:selected").val()) ;
			}
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				sheet1.SetCellEditable(i,"sabun",false);
				sheet1.SetCellEditable(i,"name",false);
				sheet1.SetCellEditable(i,"divCd",false);
				sheet1.SetCellEditable(i,"sdate",false);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	var gPRow = "";
    var pGubun = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name" || sheet1.ColSaveName(Col) == "adviser") {
				if(!isPopup()) {return;}

				if(sheet1.ColSaveName(Col) == "adviser"){
					pGubun = "adviser";
				}else{
					pGubun = "name";
				}
				gPRow = Row;

				let layerModal = new window.top.document.LayerModal({
					id : 'employeeLayer'
					, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
					, parameters : {}
					, width : 740
					, height : 520
					, title : '사원조회'
					, trigger :[
						{
							name : 'employeeTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				layerModal.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(rv) {

		if( pGubun == "adviser" ){
	        sheet1.SetCellValue(gPRow, "adviser",   rv["name"] );
	        sheet1.SetCellValue(gPRow, "adviserSabun",   rv["sabun"] );
		}else if( pGubun == "name" ){
            sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
            sheet1.SetCellValue(gPRow, "name",		rv["name"] );
            sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
            sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
        }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103997' mdef='구분'/></th>
			<td>
				<select id="searchDivCd" name="searchDivCd" onChange="doAction1('Search')"></select>
			</td>
			<th><tit:txt mid='113464' mdef='시작일자'/></th>
			<td colspan="2">  <input type="text" id="fromSdate" name="fromSdate" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>" /> ~
			<input type="text" id="toSdate" name="toSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchSaNm" name="searchSaNm" type="text" class="text" style="ime-mode:active;"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<table class="sheet_main">
	<tr>
		<td class="bottom outer">
			<div class="explain">
				<div class="title">※ 도움말</div>
				<div class="txt">
					<table>
						<tr>
							<td id="etcComment">
								<li>- 업로드 참고 : 기존자료 종료일은 신규자료 시작일 - 1일자로 업데이트 후 신규자료 업로드하시기 바랍니다.</li>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</td>
	</tr>
	</table>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">기타사항업로드(지급율)</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="basic authR" mid='110702' mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="basic authR" mid='110703' mdef="업로드"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="basic authA" mid='110700' mdef="입력"/>
<!-- 				<btn:a href="javascript:doAction1('Copy');" 		css="basic authA" mid='110696' mdef="복사"/> -->
				<btn:a href="javascript:doAction1('Save');" 		css="basic authA" mid='110708' mdef="저장"/>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
