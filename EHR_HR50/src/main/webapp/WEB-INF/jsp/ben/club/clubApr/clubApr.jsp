<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>동호회가입/탈퇴승인</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var grpCd           = "${grpCd}";
	
	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});
		
		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchApplStatusCd, #searchClubSeqCd").on("change", function(e) {
			doAction1("Search");
		});
		
		init_sheet();

		doAction1("Search");
	});
	
	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4,FrozenColRight:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata.Cols = [
			
				{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
				{Header:"삭제|삭제",			Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태|상태",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				//기본항목
				{Header:"세부\n내역|세부\n내역",Type:"Image",  	Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail",     	Edit:0 },
				{Header:"신청일|신청일",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0},
				{Header:"결재상태|결재상태",	Type:"Combo",  	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd",	Edit:0 },
				//신청자정보
				{Header:"신청자|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
				{Header:"신청자|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
				{Header:"신청자|부서",			Type:"Text",   	Hidden:0, Width:100, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
				{Header:"신청자|직책",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
				{Header:"신청자|직위",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
				{Header:"신청자|직급",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
				{Header:"신청자|직군",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"worktypeNm", 	Edit:0},
				
				//신청내용
				{Header:"신청내용|신청구분",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"joinType",	KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|동호회명",		Type:"Text",	Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"clubNm",		KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|회장",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"sabunAView",	KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|가입일자",		Type:"Date",	Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	Edit:0 },
				{Header:"신청내용|탈퇴일자",		Type:"Date",	Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	Edit:0 },
				{Header:"신청내용|급여공제동의일시",Type:"Date",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"agreeDate",	KeyField:0,	Format:"YmdHm",	Edit:0 },
				
				//Hidden
  				{Header:"Hidden",	Hidden:1, SaveName:"planSeq"},
	  			{Header:"Hidden",	Hidden:1, SaveName:"applInSabun"},
  				{Header:"Hidden",	Hidden:1, SaveName:"applSeq"}
	  			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetDataLinkMouse("detail", 1);
		
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(1); //편집불가 배경색 적용안함

		//==============================================================================================================================
		//공통코드 한번에 조회
 		sheet1.SetColProperty("joinType",  		{ComboText:"|"+"가입|탈퇴", ComboCode:"|"+"A|D"} ); //결제
		
        var clubCodeList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getClubAprClubCode",false).codeList, "전체");
		$("#searchClubSeqCd").html(clubCodeList[2]);
		
		var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		$("#searchApplStatusCd").html(applStatusCdList[2]);
		//==============================================================================================================================

		$(window).smartresize(sheetResize); sheetInit();
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		let grpCds = "R10010";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		let codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "");
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} ); //결제
	}

	function chkInVal() {

		if ($("#searchFrom").val() == "" && $("#searchTo").val() != "") {
			alert('신청기간 시작일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() == "") {
			alert('신청기간 종료일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() != "") {
			if (!checkFromToDate($("#searchFrom"),$("#searchTo"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			getCommonCodeList();
			var sXml = sheet1.GetSearchData("${ctx}/ClubApr.do?cmd=getClubAprList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
		var applCd = '710';
		var url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer';
		const p = {
				searchApplCd: applCd,
				searchApplSeq: sheet1.GetCellValue(Row,"applSeq"),
				adminYn: grpCd && grpCd == '99' ? 'N':'Y',
				authPg: 'R',
				searchSabun: sheet1.GetCellValue(Row,"applInSabun"),
				searchApplSabun: sheet1.GetCellValue(Row, "sabun"),
				searchApplYmd: sheet1.GetCellValue(Row,"applYmd")
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '동호회가입/탈퇴신청',
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
		//window.top.openLayer(url, p, 800, 815, 'initResultLayer', getReturnValue);
	}
	
	function getReturnValue(returnValue) {
		doAction1("Search");
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th><tit:txt mid="104102" mdef="신청기간" /></th>
			<td>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
			</td>
			<th><tit:txt mid="112999" mdef="결재상태" /></th>
			<td colspan="2">
				<select id="searchApplStatusCd" name="searchApplStatusCd"></select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid="104279" mdef="소속" /> </th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<th><tit:txt mid="104330" mdef="사번/성명" /></th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<th>동호회</th>
			<td>
				<select id="searchClubSeqCd" name="searchClubSeqCd"></select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">동호회가입/탈퇴승인</li> 
				<li class="btn"> 
					<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
