<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>학자금승인</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	$(function() {
	
		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getComboList});
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getComboList});
		
		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
	
		$("#searchApplStatusCd, #searchDivCd").on("change", function(e) {
			doAction1("Search");
		})
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		
		// 급여년월
		$("#searchPayYm").datepicker2({ymonly:true});
		
		init_sheet();
		getComboList();
		doAction1("Search");
	});

	function getComboList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();
		//신청분기 콤보
		const divCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B60060", baseSYmd, baseEYmd), "선택");//학자금구분(B60050)
		$("#searchDivCd").html(divCdList[2]);
	}

	// 시트 생성
	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4, FrozenColRight:6};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",				Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//기본항목
			{Header:"세부\n내역|세부\n내역",	Type:"Image",  	Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail",     	Edit:0 },
			{Header:"신청일|신청일",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0},
			{Header:"결재상태|결재상태",		Type:"Combo",  	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd",	Edit:0 },
			//신청자정보
			{Header:"신청자|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"신청자|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"신청자|부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"신청자|직책",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"신청자|직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"신청자|직급",			Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"신청자|직군",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"worktypeNm", 		Edit:0},
			
			//신청내용
			{Header:"신청내용|학자금구분",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"schTypeCd",	Edit:0 },
			{Header:"신청내용|지원구분",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"schSupTypeCd",Edit:0 },
			{Header:"신청내용|가족구분",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"famCd",		Edit:0 },
			{Header:"신청내용|대상자명",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"famNm",		Edit:0 },
			{Header:"신청내용|생년월일",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famYmd",		Format:"Ymd",	Edit:0 },
			{Header:"신청내용|성별",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		Edit:0 },
			{Header:"신청내용|학교명",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"schName",		Edit:0 },
			{Header:"신청내용|신청년도",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appYear",		Edit:0 },
			{Header:"신청내용|신청분기",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"divCd",		Edit:0 },
			{Header:"신청내용|신청금액",		Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"applMon",		Edit:0 },
			{Header:"년간지원금액\n(지급금액 함계)|년간지원금액\n(지급금액 함계)",
										Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"yearApplMon",		Edit:0 },
			
			//지급정보
			{Header:"지급정보|지급금액",		Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"payMon",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"지급정보|급여년월",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payYm",		Format:"Ym",			UpdateEdit:1,	InsertEdit:1 },
			{Header:"지급정보|마감\n여부",		Type:"CheckBox",Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",		UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y",	FalseValue:"N" },
			{Header:"지급정보|비고",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"payNote",		UpdateEdit:1,			InsertEdit:1 },

			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"}
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		
		//지급정보 헤더 배경색
		var bcc = "#fdf0f5";
		sheet1.SetCellBackColor(0, "payMon", bcc);  sheet1.SetCellBackColor(1, "payMon", bcc);  
		sheet1.SetCellBackColor(0, "payYm", bcc);  sheet1.SetCellBackColor(1, "payYm", bcc);  
		sheet1.SetCellBackColor(0, "closeYn", bcc);  sheet1.SetCellBackColor(1, "closeYn", bcc);  
		sheet1.SetCellBackColor(0, "payNote", bcc);  sheet1.SetCellBackColor(1, "payNote", bcc);  

		// 처리상태
        var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		$("#searchApplStatusCd").html(applStatusCdList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		//==============================================================================================================================
		//공통코드 한번에 조회
		let grpCds = "B60050,B60051,B60030,B60060";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");
		sheet1.SetColProperty("schTypeCd",     {ComboText:"|"+codeLists["B60050"][0], ComboCode:"|"+codeLists["B60050"][1]} ); //학자금
		sheet1.SetColProperty("schSupTypeCd",  {ComboText:"|"+codeLists["B60051"][0], ComboCode:"|"+codeLists["B60051"][1]} ); //학자금지원구분
		sheet1.SetColProperty("famCd",         {ComboText:"|"+codeLists["B60030"][0], ComboCode:"|"+codeLists["B60030"][1]} ); //대상자(경조-가족구분)
		sheet1.SetColProperty("divCd",         {ComboText:"|"+codeLists["B60060"][0], ComboCode:"|"+codeLists["B60060"][1]} ); //신청분기

		//==============================================================================================================================
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
			getCommonCodeList();
			if(!chkInVal()){break;}
			var sXml = sheet1.GetSearchData("${ctx}/SchApr.do?cmd=getSchAprList", $("#sheet1Form").serialize() );
			//sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
        case "Save":   
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/SchApr.do?cmd=saveSchApr", $("#sheet1Form").serialize()); 
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
		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: '103'
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
			title: '학자금신청',
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
			<th>신청년도</th>
			<td>
				<input type="text" id="searchYear" name="searchYear" class="date2 w60 center" maxlength="4" value="${curSysYear}"/>
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
			<th>급여년월</th>
			<td>
				<input type="text" id="searchPayYm" name="searchPayYm" class="date2" maxlength="7 "/>
			</td>
			<th>신청분기</th>
			<td>
				<select id="searchDivCd" name="searchDivCd"></select>
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
				<li id="txt" class="txt">학자금승인</li> 
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
