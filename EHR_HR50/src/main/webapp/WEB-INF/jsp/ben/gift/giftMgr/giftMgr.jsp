<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>신물기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//선물신청구분
		var giftSeqList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getGiftMgrGiftSeqCombo", false).codeList
				        , "edate,searchSeq", "");
		$("#searchGiftSeq").html(giftSeqList[2]);
		
		
		$("#searchGiftSeq").bind("change", function(){
			
			$("#searchEdate").val($("#searchGiftSeq option:selected").attr("edate"));
			$("#searchSeq").val($("#searchGiftSeq option:selected").attr("searchSeq"));
			
			//선물신청구분
			var searchGiftCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getGiftMgrGiftCdCombo&"+$("#sheet1Form").serialize(), false).codeList, "전체");
			$("#searchGiftCd").html(searchGiftCdList[2]);
			doAction1("Search");
			doAction2("Search");
		}).change();
		
		$("#searchGiftCd,#searchAppYn").bind("change", function(){
			doAction2("Search");
		});

		$("#searchSabunName").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction2("Search");
			}
		});
		
		//Sheet 초기화
		init_sheet1(); init_sheet2();

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"선물코드",		Type:"Text",	Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"giftCd",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"선물명",			Type:"Text",	Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"giftNm",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"선물상세설명",		Type:"Text",	Hidden:0, Width:250, Align:"Left",		ColMerge:0,	SaveName:"giftDesc",	KeyField:0,	Format:"",		Edit:0 },
			{Header:"신청건수",		Type:"Int",		Hidden:0, Width:100, Align:"Center",	ColMerge:0,	SaveName:"cnt",			KeyField:0,	Format:"",		Edit:0 },
			
			{Header:"Hidden",	 Hidden:1, SaveName:"giftSeq"},
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);//sheet2.SetCountPosition(4);

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음

	}
	//Sheet 초기화
	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",			Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//신청자정보
			{Header:"신청자|사번",			Type:"Text",   	Hidden:0,   Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"신청자|성명",			Type:"Text",   	Hidden:0,   Width:80,	Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"신청자|부서",			Type:"Text",   	Hidden:0,   Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"신청자|직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"신청자|연락처",		Type:"Text",   	Hidden:0,   Width:120, 	Align:"Center",   ColMerge:0,  SaveName:"phoneNo", 			Edit:0},
			
			{Header:"신청내용|신청일자",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		Format:"Ymd", 		UpdateEdit:1,	InsertEdit:1},
			{Header:"신청내용|선물명",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"giftCd",		KeyField:1,     UpdateEdit:1,	InsertEdit:1},

			{Header:"신청내용|이름",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"recName",		UpdateEdit:1,	InsertEdit:1},
			{Header:"신청내용|연락처",		Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"recPhone",	UpdateEdit:1,	InsertEdit:1},
			{Header:"신청내용|우편번호",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"recZip",		UpdateEdit:1,	InsertEdit:1},
			{Header:"신청내용|배송주소",		Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"recAddr",		UpdateEdit:1,	InsertEdit:1},
			{Header:"신청내용|배송요청사항",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",		UpdateEdit:1,	InsertEdit:1},
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/GiftStd.do?cmd=getGiftStdDtlList", $("#sheet1Form").serialize() );
				break;
		}
	}

	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/GiftMgr.do?cmd=getGiftMgrList", $("#sheet1Form").serialize()+"&"+$("#sheet2Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/GiftMgr.do?cmd=saveGiftMgr", $("#sheet1Form").serialize());
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
			case "LoadExcel":
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
				sheet2.LoadExcel(params);
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

	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			//선물명
			var searchGiftCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getGiftMgrGiftCdCombo&"+$("#sheet1Form").serialize(), false).codeList, "전체");
			sheet2.SetColProperty("giftCd",  {ComboText:searchGiftCdList[0], ComboCode:searchGiftCdList[1]} );

			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/GiftMgr.do?cmd=getGiftMgrTotalList", $("#sheet1Form").serialize()+"&"+$("#sheet2Form").serialize(),false);

			if ( data != null && data.DATA != null ){ 
				$("#span_total").html("( 전체 : "+data.DATA.total+", 신청 : "+data.DATA.yCnt+", 미신청 : "+data.DATA.nCnt+ " )");
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="outer">
		<form name="sheet1Form" id="sheet1Form" method="post">
		<div class="sheet_search sheet_search_s">
			<table>
			<tr>
				<th>선물신청구분</th>
				<td>
					<select id="searchGiftSeq" name="searchGiftSeq"></select>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
		</form>
		<div class="sheet_title">
			<ul>
				<li class="txt">선물리스트</li>
				<li class="btn">
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "120px"); </script>

		<form name="sheet2Form" id="sheet2Form" method="post">
		<input type="hidden" id="searchEdate" name="searchEdate" />
		<input type="hidden" id="searchSeq" name="searchSeq" />
		<div class="sheet_search sheet_search_s">
			<table>
			<tr>
				<th>선물명</th>
				<td>
					<select id="searchGiftCd" name="searchGiftCd"></select>
				</td>
				<th>신청여부</th>
				<td>
					<select id="searchAppYn" name="searchAppYn">
						<option value="">전체</option>
						<option value="Y">신청</option>
						<option value="N">미신청</option>
					</select>
				</td>
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
				</td>
				<td>
					<a href="javascript:doAction2('Search')" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
		</form>
	
	</div>
	<div class="sheet_title inner">
		<ul>
			<li class="txt">선물 신청현황</li>
			<li class="btn">
				<span id="span_total" class="spacingN" style="color:blue;"></span>&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:doAction2('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction2('LoadExcel');" 	class="btn outline-gray authR">업로드</a>
				<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>

</div>
</body>
</html>
