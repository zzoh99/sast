<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>직책 리스트 조회</title>

<script type="text/javascript">
	var multiSelect = "N";
	var chooseJikchakCds = "";

	$(function() {

		createIBSheet3(document.getElementById('mySheet-wrap'), "mySheet", "100%", "100%","kr");

		$("#chkVisualYn").html("<option value=''>전체</option> <option value='Y'>사용</option> <option value='N'>사용안함</option>"); // 보여주기여부
		const modal = window.top.document.LayerModalUtility.getModal('jikchakLayer');
		(modal.parameters && modal.parameters.enterCd)
				? $("#searchEnterCd").val(modal.parameters.enterCd)
				: $("#searchEnterCd").val('');
		(modal.parameters && modal.parameters.chkVisualYn)
				? $("#chkVisualYn").val(modal.parameters.chkVisualYn)
				: $("#chkVisualYn").val('');
		multiSelect = modal.parameters.multiSelect || 'N';
		chooseJikchakCds = modal.parameters.chooseJikchakCds || '';
		(modal.parameters && modal.parameters.baseDate)
				? $("#searchBaseDate").val(modal.parameters.baseDate)
				: $("#searchBaseDate").val('');

		
		var chooseCheckHidden = (multiSelect == "Y") ? 0 : 1;
		if(multiSelect == "Y") {
			$("#btn_complete").show();
		} else {
			$("#btn_complete").hide();
		}
		
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, /*FrozenCol:5,*/ DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"삭제",			Type:"${sDelTy}",   Hidden:1,				   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
				{Header:"상태",			Type:"${sSttTy}",   Hidden:1,				   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
				
				{Header:"선택",			Type:"DummyCheck",	Hidden:chooseCheckHidden,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"chooseYn",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
				{Header:"현재\n사용여부",	Type:"CheckBox",	Hidden:0,					Width:0,	Align:"Center",	ColMerge:0,	SaveName:"schemeUseYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,	TrueValue:"1",	FalseValue:"0" },
				{Header:"직책코드",		Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직책명",			Type:"Text",		Hidden:0,					Width:200,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
				{Header:"직책명(전체)",	Type:"Text",		Hidden:1,					Width:200,	Align:"Left",	ColMerge:0,	SaveName:"jikchakFullNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
				{Header:"직책명(영문)",	Type:"Text",		Hidden:1,					Width:200,	Align:"Left",	ColMerge:0,	SaveName:"jikchakEngNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
				{Header:"시작일자",		Type:"Text",		Hidden:1,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",				KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				{Header:"종료일자",		Type:"Text",		Hidden:1,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",				KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		];
		IBS_InitSheet(mySheet, initdata);

		mySheet.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		$("#searchBaseDate").datepicker2();

		doAction("Search");

		$("#searchBaseDate,#serachJikchakNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		$("#chkVisualYn").change(function(){
			doAction("Search");
		});

	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/Popup.do?cmd=getJikchakBasicPopupList", $("#mySheetForm").serialize() );
			break;
		}
	}

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			
			if(multiSelect == "Y" && chooseJikchakCds != null && chooseJikchakCds != "" && chooseJikchakCds != undefined ) {
				var checkJikchakCds = "|" + chooseJikchakCds.replace(/,/g, "|") + "|";
				for(var Row = 1; Row <= mySheet.RowCount(); Row++) {
					if( checkJikchakCds.indexOf( "|" + mySheet.GetCellValue(Row, "jikchakCd") + "|") > -1 && mySheet.GetCellValue(Row, "schemeUseYn") == "1" ) {
						mySheet.SetCellValue(Row, "chooseYn", "Y");
					} else {
						mySheet.SetCellValue(Row, "chooseYn", "N");
					}
				}
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function mySheet_OnDblClick(Row, Col){
		if(multiSelect == "N") {

			const modal = window.top.document.LayerModalUtility.getModal('jikchakLayer');
			modal.fire('jikchakTrigger', [{
				jikchakCd : mySheet.GetCellValue(Row, "jikchakCd")
				, jikchakNm : mySheet.GetCellValue(Row, "jikchakNm")
			}]).hide();
		}
	}
	
	function setValue() {
		if(multiSelect == "Y") {
			let result = [];
			for(var Row = 1; Row <= mySheet.RowCount(); Row++) {
				if( mySheet.GetCellValue(Row, "chooseYn") == "Y" ) {
					result.push({
						jikchakCd : mySheet.GetCellValue(Row, "jikchakCd")
						, jikchakNm : mySheet.GetCellValue(Row, "jikchakNm")
					});
				}
			}
			const modal = window.top.document.LayerModalUtility.getModal('jikchakLayer');
			modal.fire('jikchakTrigger', result).hide();
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="mySheetForm" name="mySheetForm" tabindex="1">
				<input type="hidden" id="searchEnterCd" name="searchEnterCd" />
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<th>기준일자</th>
								<td>
									<input type="text" id="searchBaseDate" name="searchBaseDate" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
								</td>
								<th>직책명</th>
								<td>
									<input id="serachJikchakNm" name ="serachJikchakNm" type="text" class="text" />
								</td>
								<th>현재<br/>사용여부</th>
								<td>
									<input type="checkbox" id="searchUseYn" name="searchUseYn" value="Y" checked>
								</td>
								<td>
									<a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
								</td>
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
							<li id="txt" class="txt">직책 리스트 조회</li>
						</ul>
						</div>
					</div>
						<div id="mySheet-wrap"></div>
	<%--				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","kr"); </script>--%>
					</td>
				</tr>
			</table>
		</div>

		<div class="modal_footer">
			<ul>
				<li>
					<a href="javascript:setValue();" id="btn_complete" class="button large">선택완료</a>
					<a href="javascript:closeCommonLayer('jikchakLayer');" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>



