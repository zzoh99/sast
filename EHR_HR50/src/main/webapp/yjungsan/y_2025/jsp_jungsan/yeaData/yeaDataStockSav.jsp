<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>주택마련저축</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<% String orgAuthPg = removeXSS(request.getParameter("orgAuthPg"), "1"); %>

<script type="text/javascript">
	var orgAuthPg = "<%=orgAuthPg%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;

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

		//연말정산 주택마련저축 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",		        			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",		        			Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",							Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도|년도",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"연금저축구분|연금저축구분",					Type:"Combo",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"saving_deduct_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"금융기관|금융기관",						Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"finance_org_cd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"납입횟수|납입횟수",						Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"paying_num_cd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"계좌번호\n(또는증권번호)|계좌번호\n(또는증권번호)",Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"account_no",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"금액자료|직원용",						Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:inputEdit,	InsertEdit:inputEdit,	EditLen:35 },
			{Header:"금액자료|담당자용",						Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:applEdit,	InsertEdit:applEdit,	EditLen:35 },
			{Header:"공제금액|공제금액",						Type:"Int",			Hidden:1,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"ded_mon",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"자료입력유형|자료입력유형",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00325"), "");
		var financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00319"), "");
		var payingNumCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getPayingNumCdList&searchYear="+<%=yeaYear%>,"",false).codeList, "");

		sheet1.SetColProperty("adj_input_type",		{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet1.SetColProperty("finance_org_cd",		{ComboText:"|"+financeOrgCdList[0], ComboCode:"|"+financeOrgCdList[1]} );
		sheet1.SetColProperty("paying_num_cd",		{ComboText:"|"+payingNumCdList[0], ComboCode:"|"+payingNumCdList[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();

		parent.doSearchCommonSheet();
		doAction1("Search");
	});

 	//연말정산 주택마련저축
	function doAction1(sAction) {
		switch (sAction) {
        case "Search":
        	sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataStockSavRst.jsp?cmd=selectYeaDataStockSavList", $("#sheetForm").serialize() );
        	break;
        case "Save":
        	if(!parent.checkClose())return;

    		if(!dupChk(sheet1, "saving_deduct_type|paying_num_cd|account_no", true, true)) {break;}

        	if(orgAuthPg == "A") {
	            for(var i = 2; i < sheet1.RowCount()+2; i++){
	                if(sheet1.GetCellValue(i, "sStatus") == "U"){
	                	sheet1.SetCellValue(i, "adj_input_type", "02") ;
	                }
	            }
        	}

        	sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataStockSavRst.jsp?cmd=saveYeaDataStockSav");
        	break;
        case "Insert":
        	if(!parent.checkClose())return;

        	var newRow = sheet1.DataInsert(0) ;
        	sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
        	sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
        	sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

        	if( orgAuthPg == "A" ) {
        		sheet1.SetCellValue(newRow, "adj_input_type", "02");
        	} else {
        		sheet1.SetCellValue(newRow, "adj_input_type", "01");
        	}

        	sheet1.SelectCell(newRow, 2);
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
				for(var i = 2; i < sheet1.RowCount()+2; i++) {
					sheet1.SetRowEditable(i, 1);

					if( sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF입력
						sheet1.SetRowEditable(i, 0);
						if(orgAuthPg == "A") sheet1.SetCellEditable(i, "appl_mon", 1) ;
					} else if( sheet1.GetCellValue(i, "adj_input_type") == "03") {
						sheet1.SetCellEditable(i, "input_mon", 0) ;
						sheet1.SetCellEditable(i, "appl_mon", 0) ;
					} else if( sheet1.GetCellValue(i, "adj_input_type") == "02" ) {
						if(orgAuthPg == "A") {
							sheet1.SetCellEditable(i, "input_mon", 0) ;
							sheet1.SetCellEditable(i, "appl_mon", 1) ;
						} else {
							sheet1.SetCellEditable(i, "input_mon", 0) ;
							sheet1.SetCellEditable(i, "appl_mon", 0) ;
						}
					}

					if ( sheet1.GetCellValue(i, "adj_input_type") == "03" || sheet1.GetCellValue(i, "adj_input_type") == "04" ) {
						sheet1.SetCellEditable(i, "sDelete", 0) ;
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
			parent.getYearDefaultInfoObj();
			if(Code == 1) {
				parent.doSearchCommonSheet();
				//doAction1("Search");
				sheet1_OnSearchEnd(1, "", "", "");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "paying_num_cd") {
			    if(sheet1.GetCellValue(Row, "paying_num_cd") == "01" || sheet1.GetCellValue(Row, "paying_num_cd") == "02" ) {
			        alert("3년차 납입분만 입력 가능합니다.");
			        sheet1.SelectCell(Row, "paying_num_cd");
			        sheet1.SetCellValue(Row, "paying_num_cd", " ") ;
			        return ;
			    }
			}

			inputChangeAppl(sheet1,Col,Row);
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A100",false);
		helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");
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
			$("#A100_26").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_26"),"input_mon"));
			$("#A100_27").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_27"),"input_mon"));
			$("#A100_28").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_28"),"input_mon"));
		} else {
			$("#A100_26").val("");
			$("#A100_27").val("");
			$("#A100_28").val("");
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
            <li class="txt">장기주식형저축
            	<a href="javascript:yeaDataExpPopup('장기주식형저축', helpText, 500);" class="cute_gray authR">장기주식형저축 안내</a>
            </li>
        </ul>
        </div>
    </div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="33%" />
		<col width="33%" />
		<col width="%" />
	</colgroup>
	<tr>
		<th class="center" >납입1년차</th>
		<th class="center" >납입2년차</th>
		<th class="center" >납입3년차</th>
	</tr>
	<tr>
		<td class="right">
            <input id="A100_26" name="A100_26" type="text" class="text w50p right transparent" readonly /> 원
		</td>
		<td class="right">
			<input id="A100_27" name="A100_27" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
		<td class="right">
			<input id="A100_28" name="A100_28" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
	</tr>
	</table>
	<div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">
            </li>
            <li class="btn">
	        <a href="javascript:doAction1('Search');"		class="basic authR">조회</a>
	        <a href="javascript:doAction1('Insert');"		class="basic authA">입력</a>
	        <span id="copyBtn">
	        <a href="javascript:doAction1('Copy');"			class="basic authA">복사</a>
	        </span>
	        <a href="javascript:doAction1('Save');"			class="basic authA">저장</a>
	        <a href="javascript:doAction1('Down2Excel');"	class="basic authR">다운로드</a>
    	</li>
        </ul>
    </div>
    </div>
    <div style="height:250px">
	<script type="text/javascript">createIBSheet("sheet1", "100%", "250px"); </script>
	</div>
</div>
</body>
</html>