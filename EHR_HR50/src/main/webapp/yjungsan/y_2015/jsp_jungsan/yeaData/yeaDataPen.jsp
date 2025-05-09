<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>연금보험료</title>
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
	var helpText3;
	//기준년도
	var systemYY;

	//기본정보
	$(function() {

		$("#searchWorkYy").val($("#searchWorkYy", parent.document).val());
		$("#searchAdjustType").val($("#searchAdjustType", parent.document).val());
		$("#searchSabun").val($("#searchSabun", parent.document).val());
		systemYY = $("#searchWorkYy", parent.document).val();

		//기본정보 조회(도움말 등등).
		initDefaultData();
	});

	//쉬트 초기화
	$(function() {

		//실제 메뉴에서 넘어온 권한을 보고 에디트
		var inputEdit = 0 ;
 		var applEdit = 0 ;
 		if( orgAuthPg == "A") {
 			inputEdit = 0 ;
 			applEdit = 1 ;
 		} else {
 			inputEdit = 1 ;
 			applEdit = 0 ;
 		}

 		//연말정산 연금보험료 쉬트.
 		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",							Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",							Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",							Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도|년도",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"구분|구분",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"saving_deduct_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직연금\n구분|퇴직연금\n구분",	Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"ret_pen_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },			
			{Header:"금융기관코드|금융기관코드",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"finance_org_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"납입횟수코드|납입횟수코드",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"paying_num_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"계좌번호\n(또는증권번호)|계좌번호\n(또는증권번호)",Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"account_no",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"금액자료|직원용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:inputEdit,	InsertEdit:inputEdit,	EditLen:35 },
			{Header:"금액자료|담당자용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:applEdit,	InsertEdit:applEdit,	EditLen:35 },
			{Header:"공제금액|공제금액",						Type:"Int",			Hidden:1,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"ded_mon",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"자료입력유형|자료입력유형",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		var financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00319"), "");
		//dynamic query 보안 이슈 때문에 queryId=getSavingDeductList2 분기 처리
		var savingDeductTypeList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getSavingDeductList2","searchGubun=2,3",false).codeList, "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");
		var retPenTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00318"), "");
		
		sheet1.SetColProperty("adj_input_type",		{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet1.SetColProperty("finance_org_cd",		{ComboText:"|"+financeOrgCdList[0], ComboCode:"|"+financeOrgCdList[1]} );
		sheet1.SetColProperty("saving_deduct_type",	{ComboText:savingDeductTypeList[0], ComboCode:savingDeductTypeList[1]} );
		sheet1.SetColProperty("feedback_type",		{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		sheet1.SetColProperty("ret_pen_type",		{ComboText:"|"+retPenTypeList[0], ComboCode:"|"+retPenTypeList[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();

		parent.doSearchCommonSheet();
		doAction1("Search");
	});

	//연말정산 연금보험료
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=selectYeaDataPenList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!parent.checkClose())return;

			tab_setAdjInputType(orgAuthPg, sheet1);

			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
				tab_setAuthEdtitable(orgAuthPg, sheet1, i);
				/*
				if( (sheet1.GetCellValue(i, "saving_deduct_type") == "11" || sheet1.GetCellValue(i, "saving_deduct_type") == "12")  
						&& sheet1.GetCellValue(i, "ret_pen_type") == "") {
					alert("퇴직연금일때 퇴직연금 구분을 반드시 선택해 주시기 바랍니다.");
					sheet1.SelectCell(i, "ret_pen_type");
					return;
				} 
				*/
			}
			
			sheet1.DoSave("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=saveYeaDataPen");
			break;
		case "Insert":
			//if( confirm("퇴직연금납입금액으로 회사부담금이 아닌, 반드시 본인이 추가적으로 불입한 금액입니다.") ) {
				if(!parent.checkClose())return;

				var newRow = sheet1.DataInsert(0) ;
				sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
				sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
				sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;

				tab_clickInsert(orgAuthPg, sheet1, newRow);
			//}
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
			
			if(Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
					tab_setAuthEdtitable(orgAuthPg, sheet1, i);
					/*
					if(sheet1.GetCellValue(i, "saving_deduct_type") == "11") {
						sheet1.SetCellEditable(i, "ret_pen_type", true);
					} else {
						sheet1.SetCellEditable(i, "ret_pen_type", false);
					}
					*/
				}
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			parent.getYearDefaultInfoObj();
			if(Code == 1) {
				parent.doSearchCommonSheet();
				doAction1("Search") ;
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//값이 바뀔대 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "input_mon") {
				sheet1.SetCellValue(Row,"appl_mon", sheet1.GetCellValue(Row,Col)) ;
			}
			
			if(sheet1.GetCellValue(Row, "saving_deduct_type") == "11" || sheet1.GetCellValue(Row, "saving_deduct_type") == "12") {
				sheet1.SetCellEditable(Row, "ret_pen_type", true);
			} else {
				sheet1.SetCellValue(Row, "ret_pen_type", "");
				sheet1.SetCellEditable(Row, "ret_pen_type", false);
			}
		}catch(ex){
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

	//기본정보 조회(도움말 등등).
	function initDefaultData() {
		var params = "searchWorkYy="+$("#searchWorkYy").val();
		params += "&adjProcessCd=A030";
		params += "&queryId=getYeaDataHelpText";

		var result = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params,false);

		helpText3 = result.Data.help_text1 + result.Data.help_text2 + result.Data.help_text3;
	}

	//기본자료 설정.
	function sheetSet(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){
			$("#A030_01").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_01"),"input_mon") ) ;
			$("#A030_02").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_02"),"input_mon") ) ;
			$("#A030_03").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_03"),"input_mon") ) ;
			$("#A030_04").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_04"),"input_mon") ) ;
			$("#A100_05").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_05"),"input_mon") ) ;
			$("#A100_03").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_03"),"input_mon") ) ;
		}else{
			$("#A030_01").val("0");
			$("#A030_02").val("0");
			$("#A030_03").val("0");
			$("#A030_04").val("0");
			$("#A100_05").val("0");
			$("#A100_03").val("0");
		}
	}

	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url 	= "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
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
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">연금
				<a href="javascript:yeaDataExpPopup('연금', helpText3, 400);" class="cute_gray authR">연금 안내</a>
			</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="16%" />
		<col width="17%" />
		<col width="16%" />
		<col width="17%" />
		<col width="16%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="center" colspan=2 >연금보험료공제</th>
		<th class="center"  >그밖의 소득공제</th>
		<th class="center" colspan=3>연금계좌 세액공제</th>
	</tr>
	<tr>
		<th class="center" >국민연금보험료</th>
		<th class="center" >기타 연금보험</th>
		<th class="center" >개인연금저축<br>(2000.12.31 이전 가입)</th>
		<th class="center">과학기술인공제</th>
		<th class="center">퇴직연금납입금액</th>
		<th class="center">연금저축</th>
	</tr>
	<tr>
		<td class="right">
			<input id="A030_01" name="A030_01" type="text" class="text w70p right transparent" readonly /> 원
		</td>
		<td class="right">
			<input id="A030_02" name="A030_02" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A100_03" name="A100_03" type="text" class="text w70p right transparent" readonly /> 원
		</td>		
		<td class="right">
			<input id="A030_04" name="A030_04" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A030_03" name="A030_03" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A100_05" name="A100_05" type="text" class="text w70p right transparent" readOnly />원
		</td>
	</tr>
	</table>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"></li>
			<li class="btn">
		 	<span id="btnDisplayYn02">
			<a href="javascript:doAction1('Search');"		class="basic authR">조회</a>
			<a href="javascript:doAction1('Insert');"		class="basic authA">입력</a>
			<a href="javascript:doAction1('Save');"			class="basic authA">저장</a>
			<a href="javascript:doAction1('Down2Excel');"	class="basic authR">다운로드</a>
		 	</span>
		</li>
		</ul>
	</div>
	</div>
	<div style="height:250px">
	<script type="text/javascript">createIBSheet("sheet1", "100%", "250px"); </script>
	</div>
	<span class="hide">
		<script type="text/javascript">createIBSheet("yeaSheet1", "100%", "100%"); </script>
		<script type="text/javascript">createIBSheet("yeaSheet7", "100%", "100%"); </script>
	</span>
</div>
</body>
</html>