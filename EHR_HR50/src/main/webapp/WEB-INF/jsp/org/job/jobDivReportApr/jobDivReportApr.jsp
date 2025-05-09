<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>직무분장보고승인</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	$(function() {
	
		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});
		
		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		$("#searchApplStatusCd").on("change", function(e) {
			doAction1("Search");
		});
		
		init_sheet();
		
		doAction1("Search");
	});

	function init_sheet(){ 
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
  		initdata1.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//기본항목
			{Header:"세부\n내역|세부\n내역",	Type:"Image",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청일|신청일",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재상태|결재상태",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			//신청자정보
			{Header:"신청자|사번",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청자|성명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청자|부서",				Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청자|직책",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청자|직위",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청자|직급",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			//신청내용
			{Header:"적용일자|적용일자",				Type:"Date",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"applyYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
			
			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"}

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);

		// 콥보 리스트
		/* ########################################################################################################################################## */
		
		var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		$("#searchApplStatusCd").html(applStatusCdList[2]);
		
		/* ########################################################################################################################################## */
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/JobDivReportApr.do?cmd=getJobDivReportAprList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml);
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/JobDivReportApr.do?cmd=saveJobDivReportApr" ,$("#sheet1Form").serialize());
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	showApplPopup(Row);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//세부내역 팝업
	function showApplPopup(Row) {
		
		var args = new Array(5);
		
		args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: '182'
			  , searchApplSeq: sheet1.GetCellValue(Row,"applSeq")
			  , adminYn: 'Y'
			  , authPg: 'R'
			  , searchSabun: sheet1.GetCellValue(Row,"applInSabun")
			  , searchApplSabun: sheet1.GetCellValue(Row, "sabun")
			  , searchApplYmd: sheet1.GetCellValue(Row,"applYmd")
			  , etc02: '3'
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '직무분장보고',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
	
	//신청 후 리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

	</script>
	</head>
	<body class="hidden">
	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form" >
		<!-- 조회조건 -->
		<div class="sheet_search outer">
			<table>
			<tr>
				<th>신청기간</th>
				<td>
					<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">&nbsp;~&nbsp;
					<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
				</td>
				<th>결재상태</th>
				<td>
					<select id="searchApplStatusCd" name="searchApplStatusCd"></select>
				</td>
			</tr>
			<tr>
				<th>소속</th>
				<td>
					<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
				</td>
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
		</form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">직무분장보고승인</li> 
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel');" 	class="btn outline_gray authR">다운로드</a>
						<a href="javascript:doAction1('Save');" 	class="btn filled authA">저장</a>
					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</div>
	</body>
	</html>
