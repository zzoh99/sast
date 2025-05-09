<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>교육신청승인</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	
	$(function() {
	
		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getCommonCodeList});
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getCommonCodeList});
		$("#searchPayYmd, #searchYmd").datepicker2();

		$("#searchEduSYmd").datepicker2({startdate:"searchEduEYmd"});
		$("#searchEduEYmd").datepicker2({enddate:"searchEduSYmd"});
		
		
		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm, #searchEduCourseNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
	
		$("#searchApplStatusCd, #searchEduBranchCd, #searchEduMBranchCd").on("change", function(e) {
			doAction1("Search");
		})
		
		
		init_sheet();
		
		
		doAction1("Search");
	});

	

	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",			Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//기본항목
			{Header:"세부\n내역|세부\n내역", Type:"Image",  	Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail",     	Edit:0 },
			{Header:"신청일|신청일",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0},
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
			{Header:"신청내용|과정코드",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSeq",			KeyField:0,	Format:"",		Edit:0},
			{Header:"신청내용|과정명",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	Format:"",		Edit:0},
			{Header:"신청내용|교육구분",		Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:0,	Format:"",		Edit:0},
			{Header:"신청내용|교육분류",		Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:0,	Format:"",		Edit:0},
			{Header:"신청내용|교육시작일",	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduSYmd",			KeyField:0,	Format:"Ymd",	Edit:0},	
			{Header:"신청내용|교육종료일",	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduEYmd",			KeyField:0,	Format:"Ymd",	Edit:0},	

			{Header:"취소\n여부|취소\n여부",		Type:"Combo",	Hidden:0, 	Width:55,  	Align:"Center", ColMerge:1, SaveName:"updateYn",		KeyField:0,	Format:"",	Edit:0, FontColor:"#ff0000" },
			{Header:"만족도\n조사|만족도\n조사", 	Type:"Image",  	Hidden:0,  	Width:45, 	Align:"Center", ColMerge:1, SaveName:"suvImg",       	KeyField:0, Format:"", 	Edit:0},
			{Header:"수료\n여부|수료\n여부",		Type:"Combo",	Hidden:0, 	Width:55,  	Align:"Center", ColMerge:1, SaveName:"eduConfirmType",	KeyField:0,	Format:"",	Edit:0, FontColor:"#0000ff" },
			
			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"}
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_o.png");
		sheet1.SetDataLinkMouse("detail", 1);
		
		// 처리상태
        var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		$("#searchApplStatusCd").html(applStatusCdList[2]);

		getCommonCodeList();
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}

	function getCommonCodeList() {
		//==============================================================================================================================
		//공통코드 한번에 조회
		let grpCds = "L10010,L10015";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchFrom").val() + "&baseEYmd=" + $("#searchTo").val();
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");

		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );
		sheet1.SetColProperty("updateYn", 		{ComboText:'||취소', ComboCode:"|N|Y"} );
		sheet1.SetColProperty("eduConfirmType", {ComboText:'|미수료|수료', ComboCode:"|0|1"} );
		//==============================================================================================================================
		$("#searchEduBranchCd").html(codeLists["L10010"][2]);
		$("#searchEduMBranchCd").html(codeLists["L10015"][2]);
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

		if ($("#searchEduSYmd").val() == "" && $("#searchEduEYmd").val() != "") {
			alert('교육시작일을 입력하세요.');
			return false;
		}

		if ($("#searchEduSYmd").val() != "" && $("#searchEduEYmd").val() == "") {
			alert('교육종료일을 입력하세요.');
			return false;
		}

		if ($("#searchEduSYmd").val() != "" && $("#searchEduEYmd").val() != "") {
			if (!checkFromToDate($("#searchEduSYmd"),$("#searchEduEYmd"),"교육일자","교육일자","YYYYMMDD")) {
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
			var sXml = sheet1.GetSearchData("${ctx}/EduApr.do?cmd=getEduAprList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
        case "Save":   
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/EduApr.do?cmd=saveEduApr", $("#sheet1Form").serialize()); 
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
				searchApplCd: '130'
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
			title: '신청서',
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
			<th>교육시작일</th>
			<td>
				<input id="searchEduSYmd" name="searchEduSYmd" type="text" size="10" class="date2" value=""/>
				~ <input id="searchEduEYmd" name="searchEduEYmd" type="text" size="10" class="date2" value=""/>
			</td>
			<th>교육구분</th>
			<td>
				<select id="searchEduBranchCd" name="searchEduBranchCd"></select>
			</td>
			<th>교육분류</th>
			<td>
				<select id="searchEduMBranchCd" name="searchEduMBranchCd"></select>
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
			<th>과정명</th>
			<td>
				<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w150" style="ime-mode:active;"/>
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
				<li id="txt" class="txt">교육승인</li> 
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
