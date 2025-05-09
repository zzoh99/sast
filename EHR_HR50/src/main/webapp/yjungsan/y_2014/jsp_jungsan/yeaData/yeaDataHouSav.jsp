<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>주택마련저축</title>
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
	//총급여
	var paytotMonStr;
	//세대주 여부
 	var houseOwnerYn;
	//주택구입일자
 	var houseGetYmd;
	//주택면적
 	var houseArea;
	//주택공시시가
 	var officialPrice;
 	//주택수
 	var houseCnt;
 	//총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
	var yeaMonShowYn;

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
        }else if(yeaMonShowYn == "A"){
            if(orgAuthPg == "A") {
                $("#paytotMonViewYn").show() ;
            }else{
                $("#paytotMonViewYn").hide() ;
            } 
            
        }else{
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

		//연말정산 주택마련저축 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",							Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",							Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",							Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도|년도",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"저축구분|저축구분",						Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"saving_deduct_type",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"금융기관|금융기관",						Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"finance_org_cd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"납입횟수|납입횟수",						Type:"Int",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"paying_num_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"계좌번호\n(또는증권번호)|계좌번호\n(또는증권번호)",Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"account_no",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"금액자료|직원용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:inputEdit,	InsertEdit:inputEdit,	EditLen:35 },
			{Header:"금액자료|담당자용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:applEdit,	InsertEdit:applEdit,	EditLen:35 },
			{Header:"공제금액|공제금액",						Type:"AutoSum",			Hidden:1,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"ded_mon",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"자료입력유형|자료입력유형",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		var financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&orderBy=code_nm","C00319"), "");
		var savingDeductTypeList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getSavingDeductList","searchGubun=4",false).codeList, "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");
		
		sheet1.SetColProperty("adj_input_type",		{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet1.SetColProperty("finance_org_cd",		{ComboText:"|"+financeOrgCdList[0], ComboCode:"|"+financeOrgCdList[1]} );
		sheet1.SetColProperty("saving_deduct_type",	{ComboText:"|"+savingDeductTypeList[0], ComboCode:"|"+savingDeductTypeList[1]} );
		sheet1.SetColProperty("feedback_type",	{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		
		$(window).smartresize(sheetResize);
		sheetInit();

		parent.doSearchCommonSheet();
		doAction1("Search");
	});

	//연말정산 주택마련저축
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataHouSavRst.jsp?cmd=selectYeaDataHouSavList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!parent.checkClose())return;

			if(!dupChk(sheet1, "saving_deduct_type|finance_org_cd|account_no", true, true)) {break;}

			/* 장기주택마련저축 삭제
			for( var i = 2; i < sheet1.LastRow()+2; i++) {
				if( sheet1.GetCellValue(i, "sStatus") == "U"
						|| sheet1.GetCellValue(i, "sStatus") == "I" ) {
					if( sheet1.GetCellValue(i, "saving_deduct_type") == "33"
							&& (paytotMonStr.replace(/,/gi, "") * 1) > 88000000  ) {
						alert( "장기주택마련저축은 총급여 88백만원 이하 근로자에 한해서 등록 가능합니다. \n - 총 급여액 : " + paytotMonStr ) ;
						return;
					}
				}
			}
			*/
			
			tab_setAdjInputType(orgAuthPg, sheet1);

			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataHouSavRst.jsp?cmd=saveYeaDataHouSav");
			break;
		case "Insert":
			if(!parent.checkClose())return;

			/*
			if(houseOwnerYn != 'Y') {
				alert("본인이 세대주일 경우에만 등록 가능합니다.");
				return;
			}
            */
			var newRow = sheet1.DataInsert(0) ;
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
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//클릭시 발생
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sDelete" ) tab_clickDelete(sheet1, Row);
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{			
			//저축구분
			if(sheet1.ColSaveName(Col) == "saving_deduct_type"){
				
				if ( nvl(sheet1.GetCellValue(Row,"saving_deduct_type"), "") == "" ) {
					return;
					
				} else if ( sheet1.GetCellValue(Row,"saving_deduct_type")=='50' ) {  
					// 장기집합투자증권저축일 경우
					
					if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 80000000 ) {
						//8천만원 초과여부
						alert("총급여 8천만원 이하인 자에 한해 장기집합투자증권저축 선택이 가능합니다.");
						sheet1.SetCellValue(sheet1.GetSelectRow(),"saving_deduct_type", "") ;
						return;
					} 
				
				} else {
					
					if(houseOwnerYn != 'Y') {
						//세대주여부
						alert("본인이 세대주일 경우에만 등록 가능합니다.");
						sheet1.SetCellValue(sheet1.GetSelectRow(),"saving_deduct_type", "") ;
						return;
						
					} else {
						if(sheet1.GetCellValue(Row,"saving_deduct_type")=='33'){  // 장기주택 마련저축일 경우
							alert('총급여액 8,800만원 이하이며, 2009년 12월31일 이전 가입자만 등록 가능하며,\n 2006년1월1일 이후 가입자인 경우 가입당시 기준시가 3억원 이하여야 합니다.');
							return;
						}
						if(sheet1.GetCellValue(Row,"saving_deduct_type")=='34'){  // 근로자주택 마련저축일 경우
							alert('근로자주택마련저축은 연중 국민주택규모의 1주택이하 주택 소유자가, 2009년 12월31일 이전 가입했을 경우에만 등록 가능합니다.');
							return;
						}
					}
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

	 	//개인별 총급여
		var param2 = "searchWorkYy="+$("#searchWorkYy").val();
		param2 += "&searchAdjustType="+$("#searchAdjustType").val();
		param2 += "&searchSabun="+$("#searchSabun").val();
		param2 += "&queryId=getYeaDataPayTotMon";

		var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
	 	paytotMonStr = nvl(result2.Data.paytot_mon,"");

		//세대주 정보
		var param3 = "searchWorkYy="+$("#searchWorkYy").val();
		param3 += "&searchAdjustType="+$("#searchAdjustType").val();
		param3 += "&searchSabun="+$("#searchSabun").val();
		param3 += "&queryId=getYeaHouseOwner";

		var result3 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param3,false);
		houseOwnerYn 	= nvl(result3.Data.house_owner_yn,"");
		houseGetYmd 	= nvl(result3.Data.house_get_ymd,"");
		houseArea 		= nvl(result3.Data.house_area,"");
		officialPrice 	= nvl(result3.Data.official_price,"");
		houseCnt 		= nvl(result3.Data.house_cnt,"");
		
		//총급여 확인 버튼 유무
		var result4 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
		yeaMonShowYn = nvl(result4[0].code_nm,"");
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
			$("#A100_31").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_31"),"input_mon"));
			$("#A100_33").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_33"),"input_mon"));
			$("#A100_34").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_34"),"input_mon"));
			$("#A100_40").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_40"),"input_mon"));
		} else {
			$("#A100_31").val("");
			$("#A100_33").val("");
			$("#A100_34").val("");
			$("#A100_40").val("");
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
	
	//[총급여] 보이기
	function paytotMonView(){
		if(paytotMonStr != ""){
			if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 80000000 ) {
				$("#span_paytotMonView").html("<B>YES</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
			} else {
				$("#span_paytotMonView").html("<B>NO</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
			}
		} else {
			alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
		}
	}
	
	//[총급여] 닫기
	function paytotMonViewClose(){
		$("#span_paytotMonView").html("");
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
			<li class="txt">저축 
				<span id="paytotMonViewYn">
					<a href="javascript:paytotMonView();" class="basic authA"><b><font color="red">[총급여 8천만원 초과여부]</font></b></a>
				</span>
				<span id="span_paytotMonView" ></span>
			</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="25%" />
		<col width="25%" />
		<col width="25%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="center">청약저축</th>
		<th class="center">주택청약종합저축</th>
		<th class="center">근로자주택마련저축</th>
		<th class="center">장기집합투자증권저축</th>
	</tr>
	<tr>
		<td class="right">
			<input id="A100_34" name="A100_34" type="text" class="text w50p right transparent"  readonly /> 원
		</td>
		<td class="right">
			<input id="A100_31" name="A100_31" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
		<td class="right">
			<input id="A100_33" name="A100_33" type="text" class="text w50p right transparent" readOnly /> 원
		</td>
		<td class="right">
			<input id="A100_40" name="A100_33" type="text" class="text w50p right transparent" readOnly /> 원
		</td>		
	</tr>
	</table>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"> </li>
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
	<div style="height:250px">
	<script type="text/javascript">createIBSheet("sheet1", "100%", "250px"); </script>
	</div>
</div>
</body>
</html>