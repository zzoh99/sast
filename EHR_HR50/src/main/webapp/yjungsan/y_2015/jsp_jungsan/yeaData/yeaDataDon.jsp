<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>기부금</title>
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

		//연말정산 기부금 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",						Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",						Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",						Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도|년도",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"순서|순서",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"seq",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"성명|성명",						Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"fam_nm",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"년월|년월",						Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"ymd",				KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"기부금영수증\n일련번호|기부금영수증\n일련번호",Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"contribution_no",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"사업자등록번호등\n(주민번호)|사업자등록번호등\n(주민번호)",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"enter_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:15 },
			{Header:"상호(법인명)|상호(법인명)",			Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"firm_nm",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"기부금종류|기부금종류",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"contribution_cd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"건수|건수",						Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_cnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"금액자료|직원용",					Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:inputEdit,	InsertEdit:inputEdit,	EditLen:35 },
			{Header:"금액자료|담당자용",					Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:applEdit,	InsertEdit:applEdit,	EditLen:35 },
			{Header:"자료입력유형|자료입력유형",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"주민등록번호|주민등록번호",						Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"famres",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//대상자 전부 조회
		$("#searchDpndntYn").val("");
		var famAllList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
		//공제대상자만 조회
		$("#searchDpndntYn").val("Y");
		famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
		
		var contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y","C00307"), "");
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		var workTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00313"), "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");
		
		sheet1.SetColProperty("fam_nm",				{ComboText:"|"+famAllList[0], ComboCode:"|"+famAllList[1]} );
		sheet1.SetColProperty("adj_input_type",		{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet1.SetColProperty("work_type",			{ComboText:"|"+workTypeList[0], ComboCode:"|"+workTypeList[1]} );
		sheet1.SetColProperty("contribution_cd",	{ComboText:"|"+contributionCdList[0], ComboCode:"|"+contributionCdList[1]} );
		sheet1.SetColProperty("feedback_type",	{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		
		$(window).smartresize(sheetResize);
		sheetInit();

		parent.doSearchCommonSheet();
		doAction1("Search");
	});

	//연말정산 기부금
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataDonRst.jsp?cmd=selectYeaDataDonList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!parent.checkClose())return;

			for( var i = 2; i < sheet1.LastRow()+2; i++) {
				if(sheet1.GetCellValue(i, "adj_input_type") == "07" || sheet1.GetCellValue(i, "appl_mon") == "0") continue; 
				
				if( sheet1.GetCellValue(i, "sStatus") == "U" ||
					sheet1.GetCellValue(i, "sStatus") == "I" ||
					sheet1.GetCellValue(i, "sStatus") == "S" ) {

					if( sheet1.GetCellValue(i, "contribution_cd") == "20" || sheet1.GetCellValue(i, "contribution_cd") == "42" ) {
						if( sheet1.GetCellValue(i, "fam_nm") != $("#searchRegNo", parent.document).val() ) {
							alert("정치자금이나 우리사주조합 기부금은 본인만 해당됩니다.") ;
							return ;
						}
					}

					//정치자금을 제외한 나머지는 사업자 등록번호화 상호가 필수사항이다.
					if( sheet1.GetCellValue(i, "contribution_cd") != "20" ) {

						if( sheet1.GetCellValue(i, "enter_no") == "" ) {
							alert("사업자등록번호등은 필수 입력 사항입니다.") ;
							return ;
						}

						var biz_no = sheet1.GetCellValue(i, "enter_no") ;

						if( biz_no < 10) {
							//alert("사업자등록번호등이 잘못 입력되었습니다.") ;
							//return ;
						}
						var fResNo ; var rResNo ;
						if( biz_no.length >= 13 ) {
							var fResNo = biz_no.substring(0,6) ;
							var rResNo = biz_no.substring(6,13) ;
						} else {
							fResNo = "" ;
							rResNo = "" ;
						}
						if( checkBizID(biz_no) == false && checkRegNo(fResNo, rResNo) == false ) {
							//alert("상호는 필수 입력 사항입니다.") ;
							//return ;
						}
					}
				}
			}

			tab_setAdjInputType(orgAuthPg, sheet1);

			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataDonRst.jsp?cmd=saveYeaDataDon");
			break;
		case "Insert":
			if(!parent.checkClose())return;

			var newRow = sheet1.DataInsert(0) ;
			sheet1.CellComboItem(newRow, "fam_nm", {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]});
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
		case "DonationFrdPop":   //기부금이월자료 팝업 오픈
	 		var w 		= 900;
			var h 		= 580;
			var url 	= "<%=jspPath%>/yeaData/yeaDataDonPopup.jsp?authPg=R";
			var args 	= new Array();
			args["searchWorkYy"]		= $("#searchWorkYy").val() ;
			args["searchAdjustType"]	= $("#searchAdjustType").val() ;
			args["searchSabun"]		= $("#searchSabun").val() ;
			
			if(!isPopup()) {return;}
			var rv = openPopup(url,args,w,h);
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
							sheet1.SetCellEditable(i, "enter_no", 0) ;
							sheet1.SetCellEditable(i, "firm_nm", 0) ;
							sheet1.SetCellEditable(i, "contribution_cd", 0) ;
							sheet1.SetCellEditable(i, "appl_cnt", 0) ;
						} else {
							sheet1.SetCellEditable(i, "enter_no", 0) ;
							sheet1.SetCellEditable(i, "firm_nm", 0) ;
							sheet1.SetCellEditable(i, "contribution_cd", 0) ;
							sheet1.SetCellEditable(i, "appl_cnt", 0) ;
						}
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
			//상호 특수문자 입력 방지
			if ( sheet1.ColSaveName(Col) == "firm_nm" ) {
				if ( !checkMetaChar2(sheet1.GetCellValue(Row,"firm_nm")) ) {
					alert("특수문자는 입력 할 수 없습니다.");
					sheet1.SetCellValue(Row,Col,"");
				}
			}

			if(sheet1.ColSaveName(Col) == "contribution_cd" && (sheet1.GetCellValue(Row,"contribution_cd")=="30"
				||sheet1.GetCellValue(Row,"contribution_cd")=="31")){
				alert('특례기부금 및 공익법인기부신탁기부금은 2012.06.30 까지 지출한 분만 해당됩니다.');
			}
			
			/*
			if ( sheet1.ColSaveName(Col) == "enter_no" ) {
				if ( sheet1.GetCellValue(Row, Col) != "" ) {
					var fResNo = sheet1.GetCellValue(Row, Col) ;
					if( !checkBizID(fResNo) ) {
						if ( !confirm("사업자등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet1.SetCellValue(Row, Col, "") ;
					}
				}
			}
			*/
			
			if( sheet1.ColSaveName(Col) == "enter_no" && sheet1.GetCellValue(Row,"enter_no")!= "" ){
				//if ( !checkIdNo(shtObj.GetCellValue(Row,"res_no_imdaein")) ) shtObj.SetCellValue(Row,"res_no_imdaein", "");
				Value = Value.replace(/-/gi, '');
				if(Value.length == 10) {
					if ( !checkBizID(sheet1.GetCellValue(Row,"enter_no")) ) {
						if(!confirm("사업자등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) sheet1.SetCellValue(Row,"enter_no", "");
						else {
							//sheet1.SetCellValue(Row, Col, Value.substr(0,3)+Value.substr(3,2)+Value.substr(5));
							sheet1.SetCellText(Row, Col, Value.substr(0,3)+"-"+Value.substr(3,2)+"-"+Value.substr(5));
						}
					} 
				} else if (Value.length == 13) {
					if ( !checkIdNo(sheet1.GetCellValue(Row,"enter_no")) ) sheet1.SetCellValue(Row,"enter_no", "");
					else { 
						//sheet1.SetCellValue(Row, Col, Value.substr(0,6)+Value.substr(6));
						sheet1.SetCellText(Row, Col, Value.substr(0,6)+"-"+Value.substr(6));
					}
					
				} else {
					alert("입력값의 길이가 주민번호, 사업자등록번호 길이에 부적합합니다.");
					sheet1.SetCellValue(Row, Col, "");
				}			
			}
			
			inputChangeAppl(sheet1,Col,Row);
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	//특수문자 입력 체크(스페이스 제외)
	function checkMetaChar2(pVal){
		// 특수 문자 모음 
		var num = "{}[]()<>?|`~'!@#$%^&*-+=,.;:\"'\\/";
		var bFlag = true;
		
		for (var i = 0;i < pVal.length;i++){
			if(num.indexOf(pVal.charAt(i)) != -1) bFlag = false;
		}
		
		return bFlag;
	}
	
	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A080",false);
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
			$("#A080_03").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A080_03"),"input_mon"));
			$("#A080_05").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A080_05"),"input_mon"));
			//$("#A080_07").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A080_07"),"input_mon"));
			$("#A080_09").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A080_09"),"input_mon"));
			$("#A080_10").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A080_10"),"input_mon"));
			$("#A080_11").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A080_11"),"input_mon"));
		} else {
			$("#A080_03").val("0");
			$("#A080_05").val("0");
			//$("#A080_07").val("0");
			$("#A080_09").val("0");
			$("#A080_10").val("0");
			$("#A080_11").val("0");
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
	
	function checkIdNo(pIdNo) {
		if(pIdNo!= ""){
			//주민번호 유효성체크
			var rResNo = pIdNo;
			//외국인 주민번호 체크
			if(rResNo.substring(6,7) == "5"
					|| rResNo.substring(6,7) == "6"
					|| rResNo.substring(6,7) == "7"
					|| rResNo.substring(6,7) == "8"){

				if(fgn_no_chksum(rResNo) == true){
				} else{
					return confirm("등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?");
				}
			} else {
				if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) == true){
				} else{
					return confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?");
				}
			}
		}
		return true;
	}
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">

	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchDpndntYn" name="searchDpndntYn" value="Y" />
	<input type="hidden" id="searchFamCd_s" name="searchFamCd_s" value="" />
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">기부금
				<a href="javascript:yeaDataExpPopup('기부금', helpText, 425);" class="cute_gray authR">기부금 안내</a>
				<a href="javascript:doAction1('DonationFrdPop');" class="basic authR">이월자료</a>
			</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<!--col width="17%" /-->
		<col width="20%" />
		<col width="20%" />
		<col width="20%" />
	</colgroup>
	<tr>
		<th class="center">정치자금기부금</th>
		<th class="center">법정기부금</th>
		<!--th class="center">50%한도 적용기부금</th-->
		<th class="center">우리사주조합기부금</th>
		<th class="center">종교단체 외 지정기부금</th>
		<th class="center">종교단체 지정기부금</th>
	</tr>
	<tr>
		<td class="right">
			<input id="A080_05" name="A080_05" type="text" class="text w50p right transparent" readonly /> 원
		</td>
		<td class="right">
			<input id="A080_03" name="A080_03" type="text" class="text w50p right transparent" readOnly />원
		</td>
		<!-- td class="right">
			<input id="A080_07" name="A080_07" type="text" class="text w50p right transparent" readOnly />원
		</td -->
		<td class="right">
			<input id="A080_09" name="A080_09" type="text" class="text w50p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A080_10" name="A080_10" type="text" class="text w50p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A080_11" name="A080_11" type="text" class="text w50p right transparent" readOnly />원
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
	<div style="height:400px">
	<script type="text/javascript">createIBSheet("sheet1", "100%", "400px"); </script>
	</div>
</div>
</body>
</html>