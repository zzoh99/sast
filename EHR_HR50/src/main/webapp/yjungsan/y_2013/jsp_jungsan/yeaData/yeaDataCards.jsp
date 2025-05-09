<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>신용카드</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	//총급여 확인 버튼 유무
	var yeaMonShowYn ;
	//신용,직/선불카드 - 개인별 총급여
 	var paytotMonStr ;
	
 	var famList;

	$(function() {
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();

		//기본정보 조회(도움말 등등).
		initDefaultData() ;

		if(orgAuthPg == "A") {
			$("#copyBtn").show() ;
		} else {
			$("#copyBtn").hide() ;
		}
		
		//총급여 옵션이 Y이면 총급여 버튼 보여준다.
		if( yeaMonShowYn == "Y"){
			$("#paytotMonViewYn").show() ;
		} else{
			$("#paytotMonViewYn").hide() ;
		}
	});

	$(function() {

 		var inputEdit = 0 ;
 		var applEdit = 0 ;
 		if( orgAuthPg == "A") {
 			inputEdit = 0 ;
 			applEdit = 1 ;
 		} else {
 			inputEdit = 1 ;
 			applEdit = 0 ;
 		}

		//연말정산 신용카드 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",					Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도|년도",					Type:"Int",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"순서|순서",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"명의인|명의인",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"신용카드\n구분|신용카드\n구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"card_type",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"카드명|카드명",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"card_enter_nm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"금액자료|직원용",				Type:"AutoSum",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:1,	SaveName:"use_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:inputEdit,	InsertEdit:inputEdit,	EditLen:35 },
			{Header:"금액자료|담당자용",				Type:"AutoSum",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:applEdit,	InsertEdit:applEdit,	EditLen:35 },
			{Header:"자료입력유형|자료입력유형",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"의료기관\n사용액|의료기관\n사용액",	Type:"Text",		Hidden:1,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"med_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"회사지원금|회사지원금",			Type:"Text",		Hidden:1,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"co_deduct_mon",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"국세청\n자료여부|국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//대상자 전부 조회
		$("#searchFamCd_s").val("");
		var famAllList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
		//공제대상자만 조회
		$("#searchFamCd_s").val(",'6','7','8'");
		famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeCardList&queryId=getFamCodeCardList",$("#sheetForm").serialize(),false).codeList, "");
		
		var cardTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&visualYn=Y&useYn=Y","C00305"), "");
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");

		sheet1.SetColProperty("famres",			{ComboText:"|"+famAllList[0], ComboCode:"|"+famAllList[1]} );
		sheet1.SetColProperty("card_type",		{ComboText:"|"+cardTypeList[0], ComboCode:"|"+cardTypeList[1]} );
		sheet1.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet1.SetColProperty("feedback_type",	{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();

		parent.doSearchCommonSheet();
		doAction1("Search");
	});

	//연말정산 신용카드
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!parent.checkClose())return;

			tab_setAdjInputType(orgAuthPg, sheet1);

			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=saveYeaDataCards");
			break;
		case "Insert":
			if(!parent.checkClose())return;

			var newRow = sheet1.DataInsert(0) ;
			sheet1.CellComboItem(newRow, "famres", {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]});
			sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
			sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
			sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

			tab_clickInsert(orgAuthPg, sheet1, newRow);
			
			break;
		case "Copy":
			var newRow = sheet1.DataCopy();
			sheet1.SelectCell(newRow, 2);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if (Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
					if ( !tab_setAuthEdtitable(orgAuthPg, sheet1, i) ) continue;

					if( sheet1.GetCellValue(i, "adj_input_type") == "02" ) {
						if(orgAuthPg == "A") {
							sheet1.SetCellEditable(i, "use_mon", 0) ;
							sheet1.SetCellEditable(i, "card_type", 0) ;
							sheet1.SetCellEditable(i, "card_enter_nm", 0) ;
						} else {
							sheet1.SetCellEditable(i, "use_mon", 0) ;
							sheet1.SetCellEditable(i, "card_type", 0) ;
							sheet1.SetCellEditable(i, "card_enter_nm", 0) ;
						}
					}

					if( sheet1.GetCellValue(i, "card_type") == "7") { /* 현금영수증 선택시 국세청 자료여부 선택 불가 */
						sheet1.SetCellEditable(i, "nts_yn", 0) ;
					}

				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				parent.doSearchCommonSheet();
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "card_type" ) {
				if( sheet1.GetCellValue(Row, "card_type") == "7") { /* 현금영수증 선택시 국세청 자료여부 선택 불가(자료여부 : Y) */
					sheet1.SetCellValue(Row, "nts_yn", "Y") ;
					sheet1.SetCellEditable(Row, "nts_yn", 0) ;

				} else {
					sheet1.SetCellEditable(Row, "nts_yn", 1) ;
				}
			}

			inputChangeAppl(sheet1,Col,Row);
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sDelete" ) tab_clickDelete(sheet1, Row);
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A100",false);
		helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");

		//총급여 확인 버튼 유무
		var result2 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
		yeaMonShowYn = nvl(result2[0].code_nm,"");

		//신용,직/선불카드 - 개인별 총급여
		var param2 = "searchWorkYy="+$("#searchWorkYy").val();
		param2 += "&searchAdjustType="+$("#searchAdjustType").val();
		param2 += "&searchSabun="+$("#searchSabun").val();
		param2 += "&queryId=getYeaDataPayTotMon";

		var result3 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=0.25",false);
		paytotMonStr = nvl(result3.Data.paytot_mon,"");
	}

	//직원금액 입력시 담당자금액으로 셋팅 처리
	function inputChangeAppl(shtnm,colValue,rowValue){
		if(shtnm.ColSaveName(colValue) == "input_mon" || shtnm.ColSaveName(colValue) == "use_mon") {
			shtnm.SetCellValue(rowValue,"appl_mon", shtnm.GetCellValue(rowValue,colValue));
		}
	}

	//기본자료 설정.
	function sheetSet(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){
			$("#A100_13").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_13"),"input_mon"));
			$("#A100_14").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_14"),"input_mon"));
			$("#A100_15").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_15"),"input_mon"));
			$("#A100_16").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_16"),"input_mon"));
			$("#A100_17").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_17"),"input_mon"));
			$("#A100_22").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_22"),"input_mon"));
		} else {
			$("#A100_13").val("");
			$("#A100_14").val("");
			$("#A100_15").val("");
			$("#A100_16").val("");
			$("#A100_17").val("");
			$("#A100_22").val("");
		}
	}

	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url 	= "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
	}

	function paytotMonView(){
		if(paytotMonStr != ""){
			$("#span_paytotMonView").html("<B>"+paytotMonStr+"원</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
		} else {
			alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
			return;
		}
	}

	function paytotMonViewClose(){
		$("#span_paytotMonView").html("");
	}

	function sheetChangeCheck() {
		var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">

	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchDpndntYn" name="searchDpndntYn" value="" />
	<input type="hidden" id="searchFamCd_s" name="searchFamCd_s" value=",'6','7','8'" />
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">신용카드<span class="txt">※ 총급여 25% 미만의 연간 총액은 공제금액이 발생하지 않습니다.</span>
			<span id="paytotMonViewYn">
				<a href="javascript:paytotMonView();" class="basic authA"><b><font color="red">[총급여 25%확인]</font></b></a>
			</span>
			<span id="span_paytotMonView" ></span>
			<a href="javascript:yeaDataExpPopup('신용카드', helpText, 500)" class="cute_gray authA">신용카드 안내</a>
			</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="17%" />
		<col width="17%" />
		<col width="17%" />
		<col width="17%" />
		<col width="16%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="center">신용카드 등</th>
		<th class="center">현금 영수증</th>
		<th class="center">직불카드 등</th>
		<th class="center">전통시장사용분</th>
		<th class="center">대중교통이용분</th>
		<th class="center">사업관련비용</th>
	</tr>
	<tr>
		<td class="right">
			<input id="A100_15" name="A100_15" type="text" class="text w50p right transparent" readonly /> 원
		</td>
		<td class="right">
			<input id="A100_13" name="A100_13" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
		<td class="right">
			<input id="A100_22" name="A100_22" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
		<td class="right">
			<input id="A100_14" name="A100_14" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
		<td class="right">
			<input id="A100_16" name="A100_16" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
		<td class="right">
			<input id="A100_17" name="A100_17" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
	</tr>
	</table>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">
			</li>
			<li class="btn">
			<a href="javascript:doAction1('Search');" class="basic authR">조회</a>
			<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
			<span id="copyBtn">
			<a href="javascript:doAction1('Copy');"	class="basic authA">복사</a>
			</span>
			<a href="javascript:doAction1('Save');"	class="basic authA">저장</a>
			<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
		</li>
		</ul>
	</div>
	</div>
	<div style="height:410px">
	<script type="text/javascript">createIBSheet("sheet1", "100%", "410px"); </script>
	</div>
</div>
</body>
</html>