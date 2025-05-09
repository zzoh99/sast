<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>직무 검색</title>
	<script type="text/javascript">

		$(function() {
			var modal = window.top.document.LayerModalUtility.getModal('aiEmpRcmdLayer');
			// const params = modal.parameters;

			<%--createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");--%>
			<%--var initdata1 = {};--%>
			<%--initdata1.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22};--%>
			<%--initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};--%>
			<%--initdata1.Cols = [--%>
			<%--	{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},--%>
			<%--	{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0},--%>
			<%--	{Header:"<sht:txt mid='useYn' mdef='선택'/>",				Type:"Radio",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"useYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	},--%>
			<%--	{Header:"<sht:txt mid='rGubun' mdef='인재추천구분'/>",		Type:"Text",		Hidden:0,					Width:350,			Align:"Center",	ColMerge:0,	SaveName:"rGubun",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10,},--%>
			<%--];IBS_InitSheet(sheet1, initdata1);sheet1.SetCountPosition(0);--%>
			<%--sheet1.SetSheetHeight(200);--%>

			createIBSheet3(document.getElementById('sheet2-wrap'), "sheet2", "100%", "100%", "${ssnLocaleCd}");
			var sTitle = "직무조회";
			var sHeader = "직무";
			var sShtTitle = "직무 선택";
			var sGrpCd = "H10060";

			$("#searchGrpCd").val(sGrpCd) ;

			var initdata2 = {};
			initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
			initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
			initdata2.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
				{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"Radio",	Hidden:0,	Width:40,				Align:"Center",	ColMerge:0,	SaveName:"radioCheck" },
				{Header:sHeader,									Type:"Text",		Hidden:0,	Width:120,			Align:"Left",	ColMerge:0,	SaveName:"codeNm", UpdateEdit:0 ,	TreeCol:1,  LevelSaveName:"sLevel" },
				{Header:"code",										Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"code", UpdateEdit:0 }
			];
			IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(4);sheet2.SetEditableColorDiff (0);

			var sheetHeight = $(".modal_body").height() - $(".sheet_title").height()
			sheet2.SetSheetHeight(sheetHeight);

			// 트리레벨 정의
			$("#btnPlus").click(function() {
				sheet2.ShowTreeLevel(-1);
			});
			$("#btnStep1").click(function()	{
				sheet2.ShowTreeLevel(0, 1);
			});
			$("#btnStep2").click(function()	{
				sheet2.ShowTreeLevel(1,2);
			});
			$("#btnStep3").click(function()	{
				sheet2.ShowTreeLevel(2, 3);
			});

			// doAction1("Search");
			doAction2("Search");
		})

		function doAction1(sAction) {
			switch (sAction) {
				case "Search":
					sheet1.DoSearch( "${ctx}/AiEmpRcmdMgr.do?cmd=getAiEmpRcmdMgrType");
					break;
			}
		}

		/*Sheet Action*/
		function doAction2(sAction) {
			switch (sAction) {
				case "Search": //조회
					sheet2.DoSearch( "${ctx}/SpecificEmpSrch.do?cmd=getSpecificEmpListPop", $('#sheet2Form').serialize());
					break;
			}
		}

		// 	조회 후 에러 메시지
		function Sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
			try{
			}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
		}

		function Sheet1_OnResize(lWidth, lHeight) {
			try {
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try{
				sheet1.SetCellValue(NewRow, "useYn", 1);
				$('#rGubun').val(sheet1.GetCellValue(NewRow, "rGubun"));
			}catch(ex){alert("OnSelectCell Event Error : " + ex);}
		}

		function Sheet1_OnDblClick(Row, Col) {
			try {
			} catch (ex) {
				alert("OnDblClick Event Error : " + ex);
			}
		}

			// 	조회 후 에러 메시지
		function Sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
			try{
			}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
		}

		function Sheet2_OnResize(lWidth, lHeight) {
			try {
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}
		function Sheet2_OnDblClick(Row, Col){
			try{
			}catch(ex){alert("OnDblClick Event Error : " + ex);}
		}

		function selectJob(){
			const modal = window.top.document.LayerModalUtility.getModal('aiEmpRcmdLayer');
			var sRow = sheet2.FindCheckedRow("radioCheck");
			modal.fire('aiEmpRcmdLayerTrigger', {
				jobCd : sheet2.GetCellValue(sRow, "code")
				, jobNm : sheet2.GetCellValue(sRow, "codeNm")
			}).hide();
		}
	</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form">
			<input type="hidden" id="jobCd" name="jobCd" />
			<input type="hidden" id="jobNm" name="jobNm" />
		</form>
		<form id="sheet2Form" name="sheet2Form">
			<input type="hidden" id="searchGrpCd" name="searchGrpCd" />
		</form>

		<table class="sheet_main">
<%--			<tr>--%>
<%--				<td>--%>
<%--					<div class="sheet_title inner">--%>
<%--						인재추천구분--%>
<%--					</div>--%>
<%--					<div id="sheet1-wrap"></div>--%>
<%--				</td>--%>
<%--			</tr>--%>
			<tr>
				<td>
					<div class="sheet_title inner">
						<ul>
							<li id="txt" class="txt"><span id="sheetTitle"></span>
								<div class="util">
									<ul>
										<li	id="btnPlus"></li>
										<li	id="btnStep1"></li>
										<li	id="btnStep2"></li>
										<li	id="btnStep3"></li>
									</ul>
								</div>
							</li>
						</ul>
					</div>
					<div id="sheet2-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:selectJob();" class="btn outline_gray">선택</a>
		<a href="javascript:closeCommonLayer('aiEmpRcmdLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>