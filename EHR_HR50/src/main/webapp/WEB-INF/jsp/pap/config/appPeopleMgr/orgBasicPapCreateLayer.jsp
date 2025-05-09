<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></title>
	<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
	<script type="text/javascript">

		$(function() {

			createIBSheet3(document.getElementById('mysheet-wrap'), "mySheet", "100%", "100%", "${ssnLocaleCd}");

			var enterCd = "";

			const modal = window.top.document.LayerModalUtility.getModal('orgBasicPapCreateLayer');

			//var arg = p.popDialogArgumentAll();
			//if( arg != undefined ) {
			$("#appraisalCd").val(modal.parameters.searchAppraisalCd);
			$("#appStepCd").val(modal.parameters.searchAppStepCd);
			enterCd    = modal.parameters.enterCd;
			$("#searchEnterCd").val(enterCd);
			//}

			//$("#searchEnterCd").val(dialogArguments["enterCd"]) ;
			//배열 선언
			var initdata = {};
			//SetConfig
			initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
			//HeaderMode
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			//InitColumns + Header Title
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
				{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",      Type:"Text",      Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"orgCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",        Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			];
			IBS_InitSheet(mySheet, initdata);

			mySheet.SetCountPosition(4);

			$(window).smartresize(sheetResize); sheetInit();

			var sheetHeight = $(".modal_body").height() - $("#mySheetForm").height() - $(".sheet_title").height() - 2;
			//console.log("sheetHeight : " + sheetHeight);

			mySheet.SetSheetHeight(sheetHeight);

			doAction("Search");

			$("#searchOrgNm").bind("keyup",function(event){
				if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
			});

		});

		/*Sheet Action*/
		function doAction(sAction) {
			switch (sAction) {
				case "Search": 		//조회
					mySheet.DoSearch( "${ctx}/Popup.do?cmd=getOrgBasicPopupList2", $("#mySheetForm").serialize() );
					break;
			}
		}

		// 	조회 후 에러 메시지
		function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try {
				if(Msg != "") alert(Msg);
				sheetResize();
			} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
			}
		}

		function mySheet_OnDblClick(Row, Col){
			var rv = new Array(2);
			rv["orgCd"] 	= mySheet.GetCellValue(Row, "orgCd");
			rv["orgNm"]		= mySheet.GetCellValue(Row, "orgNm");

			const modal = window.top.document.LayerModalUtility.getModal('orgBasicPapCreateLayer');
			modal.fire('orgBasicPapCreateLayerTrigger', rv).hide();
		}
	</script>


</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
			<input type="hidden" name="appraisalCd" id="appraisalCd" />
			<input type="hidden" name="appStepCd" id="appStepCd" />
			<input type="hidden" id="searchEnterCd" name="searchEnterCd" />
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='104514' mdef='조직명'/></th>
							<td>  <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>
							<td>
								<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>

		<table class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></li>
							</ul>
						</div>
					</div>
					<div id="mysheet-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('orgBasicPapCreateLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>



