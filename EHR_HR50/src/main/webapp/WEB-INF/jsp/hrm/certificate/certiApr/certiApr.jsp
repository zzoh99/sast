<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>제증명승인관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		$("#searchApplYmdFrom").datepicker2({startdate:"searchApplYmdTo"});
		$("#searchApplYmdTo").datepicker2({enddate:"searchApplYmdFrom"});
	
	    $("#searchName, #searchApplYmdFrom, #searchApplYmdTo").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchApplCd, #searchApplStatusCd").bind("change", function(e) {
			doAction1("Search");
		});

		init_sheet();
		
		
		doAction1("Search");
		
	});

	function chkInVal() {

		if ($("#searchApplYmdFrom").val() == "" && $("#searchApplYmdTo").val() != "") {
			alert("<msg:txt mid='110391' mdef='신청 시작일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchApplYmdFrom").val() != "" && $("#searchApplYmdTo").val() == "") {
			alert("<msg:txt mid='110256' mdef='신청 종료일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchApplYmdFrom").val() != "" && $("#searchApplYmdTo").val() != "") {
			if (!checkFromToDate($("#searchApplYmdFrom"),$("#searchApplYmdTo"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	function init_sheet(){ 
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22, FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"일괄승인\n선택",		Type:"DummyCheck",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:0 },
			//기본항목
			{Header:"세부\n내역",			Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"신청일",				Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"결재상태",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			//신청자정보
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},
			{Header:"부서",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},
			{Header:"직급",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"직위",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			//신청내용
			{Header:"신청서종류",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applCd",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"관리번호",			Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"regNo",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},
			{Header:"용도",				Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"purpose",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"출력(다운)\n여부",	Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"prtYn",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"출력(다운)\n가능횟수",Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"prtCnt",		KeyField:0,	Format:"Number",UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"기타",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"etc",			KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:0,	EditLen:2000 },

			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSabun"},
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//sheet1.SetImageList(0,"/common/images/icon/icon_info.png");
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", true);
		
		var applCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getAddlCodeList",""), "<tit:txt mid='103895' mdef='전체'/>");
		var applStatusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "<tit:txt mid='103895' mdef='전체'/>");
 
		sheet1.SetColProperty("applCd",			{ComboText:applCd[0], ComboCode:applCd[1]} );
		sheet1.SetColProperty("applStatusCd",	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		sheet1.SetColProperty("prtYn",			{ComboText:'Yes|No', ComboCode:'Y|N'} );

		$("#searchApplCd").html(applCd[2]);
		$("#searchApplStatusCd").html(applStatusCd[2]);
		
		//$("#applStatusCd").val("21");

		$(window).smartresize(sheetResize); sheetInit();

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			if($("#searchApplYmdFrom").val() == "") {
				alert("신청일을 입력하여 주십시오.");
				$("#searchApplYmdFrom").focus();
				return;
			}
			if($("#searchApplYmdTo").val() == "") {
				alert("신청일을 입력하여 주십시오.");
				$("#searchApplYmdTo").focus();
				return;
			}
			sheet1.DoSearch( "${ctx}/CertiApr.do?cmd=getCertiAprList", $("#sheetForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/CertiApr.do?cmd=saveCertiApr", $("#sheetForm").serialize());
			break;
		case "AllAppr":
			if(sheet1.RowCount("U") > 0 || sheet1.RowCount("D") > 0) {
				alert("수정된 데이터가 있습니다. 저장 후 선택하여 주십시오.");
				return;
			}
			
			if(sheet1.CheckedRows("ibsCheck") < 1) {
				alert("일괄승인할 데이터를 선택하여 주십시오.");
				return;
			}
			
			var sRow = sheet1.FindCheckedRow("ibsCheck");
			var arrRow = sRow.split("|");
			
			for(var i = 0; i < arrRow.length; i++){
				if(arrRow[i] != "") {
					sheet1.SetCellValue(arrRow[i],"sStatus","U");
				}
			}
			
			if(!confirm("일괄승인 하시겠습니까?")) {
				for(var i = 0; i < arrRow.length; i++){
					if(arrRow[i] != "") {
						sheet1.SetCellValue(arrRow[i],"sStatus","R");
					}
				}
				return;
			}
			
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/CertiApr.do?cmd=saveCertiAprStatus", $("#sheetForm").serialize(),-1, 0 );
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

	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
            sheet1.SetAllowCheck(true);
		    if(sheet1.ColSaveName(Col) == "ibsCheck") {
		        if((sheet1.GetCellValue(Row, "applStatusCd") != "21" && sheet1.GetCellValue(Row, "applStatusCd") != "31")) {
		            //alert("결재중인 데이터만 선택하여 주십시오.");
		            sheet1.SetAllowCheck(false);
		            return;
		        }
		    }
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}
	
	//세부내역 팝업
	function showApplPopup(Row) {
		
		var args = new Array(5);
		
		args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		var url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer';
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: sheet1.GetCellValue(Row,"applCd")
			  , searchApplSeq: sheet1.GetCellValue(Row,"applSeq")
			  , adminYn: 'Y'
			  , authPg: 'R'
			  , searchSabun: sheet1.GetCellValue(Row,"applInSabun")
			  , searchApplSabun: sheet1.GetCellValue(Row, "sabun")
			  , searchApplYmd: sheet1.GetCellValue(Row,"applYmd") 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
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
	
	
	function getReturnValue(returnValue) {
		doAction1("Search");
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>신청서종류</th>
				<td>
					<select id="searchApplCd" name="searchApplCd"></select>
				</td>
				<th>신청일자</th>
				<td colspan="2">
					<input id="searchApplYmdFrom" name="searchApplYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
					<input id="searchApplYmdTo" name="searchApplYmdTo" type="text" size="10" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
				</td>
			</tr>
			<tr>
				<th>신청상태</th>
				<td>
					<select id="searchApplStatusCd" name="searchApplStatusCd"></select>
				</td>
				<th>성명/사번</th>
				<td>
					<input id="searchName" name="searchName" type="text" class="text"/>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
				</td>				
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">제증명승인관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Save')" css="btn soft authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('AllAppr');" css="btn filled authA" mid='allApplV1' mdef="일괄승인"/>
			</li>
		</ul>
		</div>
	</div>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
