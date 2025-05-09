<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>교육비</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	
	var famList;
	
	// 교육 초중고/대학교 상세 구분 변수
	var contributionCdList1;
	var contributionCdList2;
	
	$(function() {
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();

		//기본정보 조회(도움말 등등).
		initDefaultData() ;
<%--
		if(orgAuthPg == "A") {
			$("#copyBtn").show() ;
		} else {
			$("#copyBtn").hide() ;
		}
--%>
	});
	
	$(function() {
<%--
 		var inputEdit = 0 ;
 		var applEdit = 0 ;
 		if( orgAuthPg == "A") {
 			inputEdit = 0 ;
 			applEdit = 1 ;
 		} else {
 			inputEdit = 1 ;
 			applEdit = 0 ;
 		}		
--%>
<%
String inputEdit = "0", applEdit = "0";
if( "Y".equals(adminYn) ) {
	inputEdit = "0";
	applEdit = "1";
} else{
	inputEdit = "1";
	applEdit = "0";
}
%>

		//연말정산 가족 쉬트.
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"관계",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"fam_cd",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"fam_nm",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"주민등록번호",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"famres",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"학력",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"aca_cd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"기본\n공제",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dpndnt_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"배우자\n공제",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"spouse_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"경로\n우대",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"senior_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"장애인\n공제",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"hndcp_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"장애\n구분",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"hndcp_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"부녀자\n공제",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"woman_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"자녀\n양육",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"child_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"출산\n입양",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"adopt_born_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"사업장",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"보험료",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"insurance_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"의료비",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"medical_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"교육비",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"education_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"신용\n카드등",		Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"credit_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		//연말정산 교육비 쉬트
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No|No",					Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"년도|년도",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"순서|순서",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"대상자|대상자",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"교육대상 구분|교육대상 구분",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_type",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"상세구분|상세구분",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"restrict_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"금액자료|직원용",				Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",		KeyField:0,	Format:"#,###",		PointCount:0,	UpdateEdit:<%=inputEdit%>,	InsertEdit:<%=inputEdit%>,	EditLen:35, MinimumValue: 0 },
			{Header:"금액자료|담당자용",				Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:1,	Format:"#,###",		PointCount:0,	UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35, MinimumValue: 0 },
			{Header:"자료입력유형|자료입력유형",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		//대상자 전부 조회
		$("#searchDpndntYn").val("");
		var famAllList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
		//공제대상자만 조회
		$("#searchDpndntYn").val("Y");
		famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeEduList&queryId=getFamCodeEduList",$("#sheetForm").serialize(),false).codeList, "");
		
		contributionCdList1 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getCommonCodeNoteEduList&note1=E","C00342"), "");
		contributionCdList2 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getCommonCodeNoteEduList&note1=D","C00342"), "");
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		var workTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00313"), "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");
		
		sheet2.SetColProperty("famres",			{ComboText:"|"+famAllList[0], ComboCode:"|"+famAllList[1]} );
		//sheet2.SetColProperty("restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );
		sheet2.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet2.SetColProperty("work_type",		{ComboText:"|"+workTypeList[0], ComboCode:"|"+workTypeList[1]} );
		sheet2.SetColProperty("feedback_type",	{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		
        sheet2.SetRangeBackColor(0,0,1, sheet2.LastCol(),"<%=headerColorA%>") ;

		$(window).smartresize(sheetResize); 
		sheetInit();
		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn01").hide() ;
            sheet1.SetEditable(false) ;
            sheet2.SetEditable(false) ;
		}
		parent.doSearchCommonSheet();
		doAction1("Search");
	});
	
	//연말정산 가족
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectYeaDataPerList", $("#sheetForm").serialize() ); 
			break;
		}
	}	
	
	//연말정산 교육비
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataEduRst.jsp?cmd=selectYeaDataEduList", $("#sheetForm").serialize() ); 
			break;
		case "Save":
			if(!parent.checkClose())return;
			
			for( var i = 2; i < sheet2.LastRow()+2; i++) {
				if(sheet2.GetCellValue(i, "adj_input_type") == "07" || sheet2.GetCellValue(i, "appl_mon") == "0") continue; 
				
				if( sheet2.GetCellValue(i, "sStatus") == "U" || 
					sheet2.GetCellValue(i, "sStatus") == "I" || 
					sheet2.GetCellValue(i, "sStatus") == "S") {
					
					if( sheet2.GetCellValue(i, "work_type") == "30" && sheet2.GetCellValue(i, "restrict_cd") == "10" ) {
						if( parseInt( sheet2.GetCellValue(i, "input_mon") , 10) > 500000 ) {
							alert("교육대상구분 초중고 > 교복구입비 입력금액한도는 개인별 최대 50만원까지 가능합니다.") ;
							sheet2.SelectCell(i, "input_mon") ;
							return ;
						}
					}
					
					if( sheet2.GetCellValue(i, "work_type") == "30" && sheet2.GetCellValue(i, "restrict_cd") == "20" ) {
                        if( parseInt( sheet2.GetCellValue(i, "input_mon") , 10) > 300000 ) {
                            alert("교육대상구분 초중고 > 체험학습비 입력금액한도는 개인별 최대 30만원까지 가능합니다.") ;
                            sheet2.SelectCell(i, "input_mon") ;
                            return ;
                        }
                    }
				}
			}
			
			tab_setAdjInputType(orgAuthPg, sheet2);
			
			sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataEduRst.jsp?cmd=saveYeaDataEdu&orgAuthPg="+orgAuthPg); 
			break;
		case "Insert":	
			if(!parent.checkClose())return;
			
			var newRow = sheet2.DataInsert(0) ;
			sheet2.CellComboItem(newRow, "famres", {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]});
			sheet2.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
			sheet2.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
			sheet2.SetCellValue( newRow, "sabun", $("#searchSabun").val() );
			
			tab_clickInsert(orgAuthPg, sheet2, newRow);
			break;
		case "Copy":
			
			var newRow = sheet2.DataCopy();
			var sumData = 0;
			
			for(var i=1; i < sheet2.LastRow()+1; i++){
				if((sheet2.GetCellValue(newRow,"famres") == sheet2.GetCellValue(i,"famres")) && (sheet2.GetCellValue(newRow,"restrict_cd") == sheet2.GetCellValue(i,"restrict_cd"))
						&& sheet2.GetCellValue(newRow,"restrict_cd") == "10"){
                    sumData = sumData + parseInt(sheet2.GetCellValue(i,"appl_mon"), 10);
                }
			}
			
			if(sumData > 500000){
                alert("교복구입비 한도금액이 초과되었습니다.");

				<%if( "Y".equals(adminYn) ){  %>
				    sheet2.SetCellValue(newRow,"appl_mon", "0") ;
				<%}else {  %>
				    sheet2.SetCellValue(newRow,"input_mon", "0") ;
				<%} %>
				return;
			}
			
			sumData = 0;
			
			for(var i=1; i < sheet2.LastRow()+1; i++){
                if((sheet2.GetCellValue(newRow,"famres") == sheet2.GetCellValue(i,"famres")) && (sheet2.GetCellValue(newRow,"restrict_cd") == sheet2.GetCellValue(i,"restrict_cd"))
                        && sheet2.GetCellValue(newRow,"restrict_cd") == "20"){
                    sumData = sumData + parseInt(sheet2.GetCellValue(i,"appl_mon"), 10);
                }
            }
			
			if(sumData > 300000){
                alert("체험학습비 한도금액이 초과되었습니다.");

                <%if( "Y".equals(adminYn) ){  %>
                    sheet2.SetCellValue(newRow,"appl_mon", "0") ;
                <%}else {  %>
                    sheet2.SetCellValue(newRow,"input_mon", "0") ;
                <%} %>
                return;
            }
			
			sheet2.SelectCell(newRow, 2);
			
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param); 
			break;
		}
	}
 	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Code == 1) {
				doAction2("Search");
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	} 	
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			
			if (Code == 1) { 
				for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++){
					if( sheet2.GetCellValue(i, "work_type") == "30" || sheet2.GetCellValue(i, "work_type") == "40" ) {
						
						var row = i;
						
						if(sheet2.GetCellValue(i, "work_type") == "30"){
							sheet2.CellComboItem(row,	"restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );
							sheet2.SetCellEditable(i, "restrict_cd", 1) ;
						}else if(sheet2.GetCellValue(i, "work_type") == "40"){
							//sheet2.CellComboItem(row,	"restrict_cd",	{ComboText:"|"+contributionCdList2[0], ComboCode:"|"+contributionCdList2[1]} );
							//2019-11-14. 교육대상구분이 '초중고_본인외'가 아니면 상세구분 비활성화 처리
							sheet2.SetCellValue(i,"restrict_cd", "");
							sheet2.SetCellEditable(i, "restrict_cd", 0) ;
						}
					} else {
						sheet2.SetCellEditable(i, "restrict_cd", 0) ;
					}
					
					if ( !tab_setAuthEdtitable(orgAuthPg, sheet2, i) ) continue;
				}
			}
			sheetResize(); 
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			parent.getYearDefaultInfoObj();
			if(Code == 1) {
				parent.doSearchCommonSheet();
				doAction2("Search");
			}
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	//값 변경시 발생
	function sheet2_OnChange(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "famres" || sheet2.ColSaveName(Col) == "work_type"){
				var sht1FamresIdx = sheet1.FindText("famres", sheet2.GetCellValue(Row, "famres"));
				var sht1FamCd = sheet1.GetCellText(sht1FamresIdx, "fam_cd");
				var sht1HndcpType = sheet1.GetCellText(sht1FamresIdx, "hndcp_type");
				
				/*
				본인에 대해 교육대상 구분 클릭시 event
				=> 취학전아동, 초중고교육비, 대학생교육비 선택하면 다음 안내멘트와 함께 선택불가능하도록 수정
				""취학전아동, 초중고교육비, 대학생교육비는 본인 이외의 대상자에 한해 선택 가능합니다.""
				 "|본인|취학전아동|초중고|대학교|장애인특수교육비"," |10|20|30|40|50"
				*/
				if(sht1FamCd == "0"){
					if(sheet2.GetCellValue(Row, "work_type") == "20" || sheet2.GetCellValue(Row, "work_type") == "30" || sheet2.GetCellValue(Row, "work_type") == "40"){
						alert("취학전아동, 초중고교육비, 대학생교육비는 본인 이외의 대상자에 한해 선택 가능합니다.");
						sheet2.SetCellValue(Row, "work_type", "") ;
						return;
					}
				}
				
				if(sht1FamCd == "1" || sht1FamCd == "2" ){
					if(sheet2.GetCellValue(Row, "work_type") != "" && sheet2.GetCellValue(Row, "work_type") != "50"){
						alert("대상자가 직계존속인 경우는 장애인 특수교육비만 선택 가능합니다.");
						sheet2.SetCellValue(Row, "work_type", "") ;
						return;
					}
				}
				
				if(sheet2.GetCellValue(Row, "work_type") == "10"){
					if(sht1FamCd != "0"){
						alert("교육대상구분(본인)은 본인만 입력 가능합니다.");
						sheet2.SetCellValue(Row, "work_type", "") ;
						return;
					}
				}
				
				if(sheet2.GetCellValue(Row, "work_type") == "50"){
					if(sht1HndcpType == ""){
						alert("장애인 특수교육비는 인적공제의 장애구분이 등록된 대상자에 한해 선택 가능합니다.");
						sheet2.SetCellValue(Row, "work_type", "") ;
						return;
					}
				}
			}
			
			//기타의료비 영수증  관련
			if(sheet2.ColSaveName(Col) == "work_type"){
				if(sheet2.GetCellValue(Row,"work_type") == "30"){
					sheet2.CellComboItem(Row,	"restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );
					sheet2.SetCellEditable(Row,"restrict_cd", 1) ;
					sheet2.SetCellValue(Row,"restrict_cd", "00") ;
				}else if(sheet2.GetCellValue(Row,"work_type") == "40"){
					/*
					sheet2.CellComboItem(Row,	"restrict_cd",	{ComboText:"|"+contributionCdList2[0], ComboCode:"|"+contributionCdList2[1]} );
					sheet2.SetCellEditable(Row,"restrict_cd", 1) ;
					*/
					//2019-11-14. 교육대상구분이 '초중고_본인외'가 아니면 상세구분 비활성화 처리
					sheet2.SetCellValue(Row,"restrict_cd", "");
					sheet2.SetCellEditable(Row,"restrict_cd", 0);
				}else{
					sheet2.SetCellEditable(Row,"restrict_cd", 0) ;
					sheet2.SetCellValue(Row,"restrict_cd", "") ;
					sheet2.SetCellEditable(Row,"nts_yn", 1) ;
				}
			}
			//상세제약구분 
			if(sheet2.ColSaveName(Col) == "restrict_cd"){
				if(sheet2.GetCellValue(Row,"restrict_cd") =="10"){
					//sheet2.CellEditable(Row,"nts_yn") = false;
					sheet2.SetCellEditable(Row,"nts_yn", 1) ;
					sheet2.SetCellValue(Row,"nts_yn", "N") ;
				}else{
					sheet2.SetCellEditable(Row,"nts_yn", 1) ;
				}	
			}
			inputChangeAppl(sheet2,Col,Row);
			
			
			//교복구입비 50만원 한도계산, 체험학습비 30만원 한도계산
			if(sheet2.ColSaveName(Col) == "famres" || sheet2.ColSaveName(Col) == "restrict_cd" || sheet2.ColSaveName(Col) == "appl_mon"){
				
				if(sheet2.GetCellValue(Row,"appl_mon") > 0){
					if(sheet2.GetCellValue(Row,"restrict_cd") == "10"){	
						var sumData = 0;	
						
						for(var i=1; i < sheet2.LastRow()+1; i++){
							if((sheet2.GetCellValue(Row,"famres") == sheet2.GetCellValue(i,"famres")) && (sheet2.GetCellValue(Row,"restrict_cd") == sheet2.GetCellValue(i,"restrict_cd"))){
								sumData = sumData + parseInt(sheet2.GetCellValue(i,"appl_mon"), 10);
							}
						}

						if(sumData > 500000){
							alert("교복구입비 한도금액이 초과되었습니다.");
<%--
							if(orgAuthPg == "A"){ 
								sheet2.SetCellValue(Row,"appl_mon", "0") ;
							}else { 
								sheet2.SetCellValue(Row,"input_mon", "0") ;
							}
--%>
							<%if( "Y".equals(adminYn) ){  %>
								sheet2.SetCellValue(Row,"appl_mon", "0") ;
							<%}else {  %>
								sheet2.SetCellValue(Row,"input_mon", "0") ;
							<%} %>
							return;
						}	
					}
					
					if(sheet2.GetCellValue(Row,"restrict_cd") == "20"){    
                        var sumData = 0;    
                        
                        for(var i=1; i < sheet2.LastRow()+1; i++){
                            if((sheet2.GetCellValue(Row,"famres") == sheet2.GetCellValue(i,"famres")) && (sheet2.GetCellValue(Row,"restrict_cd") == sheet2.GetCellValue(i,"restrict_cd"))){
                                sumData = sumData + parseInt(sheet2.GetCellValue(i,"appl_mon"), 10);
                            }
                        }

                        if(sumData > 300000){
                            alert("체험학습비 한도금액이 초과되었습니다.");
<%--
                            if(orgAuthPg == "A"){ 
                                sheet2.SetCellValue(Row,"appl_mon", "0") ;
                            }else { 
                                sheet2.SetCellValue(Row,"input_mon", "0") ;
                            }
--%>
                            <%if( "Y".equals(adminYn) ){  %>
                                sheet2.SetCellValue(Row,"appl_mon", "0") ;
                            <%}else {  %>
                                sheet2.SetCellValue(Row,"input_mon", "0") ;
                            <%} %>
                            return;
                        }   
                    }
				}
			}
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "sDelete" ) {
				tab_clickDelete(sheet2, Row);
				
				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet2.GetCellValue(Row, "adj_input_type") == "07" ) {
					sheet2.SetCellEditable(Row, "input_mon", 0);
					sheet2.SetCellEditable(Row, "appl_mon", 0);
					sheet2.SetCellEditable(Row, "nts_yn", 0);
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=B009",false);
		helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");
		
		//안내메세지
        $("#infoLayer").html(helpText).hide();
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
			
			$("#A060_03").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A060_03"),"input_mon"));
			$("#A060_05").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A060_05"),"input_mon"));
			$("#A060_07").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A060_07"),"input_mon"));
			$("#A060_09").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A060_09"),"input_mon"));
			$("#A060_11").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A060_11"),"input_mon"));
			
			if(comSheet.FindText("adj_element_cd", "A060_03") != '-1'){
				$("#A060_03_h").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A060_03"),"data_cnt") );
			} else {
				$("#A060_03_h").val(0);
			}
			
			if(comSheet.FindText("adj_element_cd", "A060_05") != '-1'){
				$("#A060_05_h").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A060_05"),"data_cnt") );
			} else {
				$("#A060_05_h").val(0);
			}
			
			if(comSheet.FindText("adj_element_cd", "A060_07") != '-1'){
				$("#A060_07_h").val(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A060_07"),"data_cnt"));
			} else {
				$("#A060_07_h").val(0);
			}
			
			if(comSheet.FindText("adj_element_cd", "A060_09") != '-1'){
				$("#A060_09_h").val(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A060_09"),"data_cnt"));
			} else {
				$("#A060_09_h").val(0);
			}
			
			if(comSheet.FindText("adj_element_cd", "A060_11") != '-1'){
				$("#A060_11_h").val(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A060_11"),"data_cnt"));
			} else {
				$("#A060_11_h").val(0);
			}			
		} else {
			$("#A060_03").val("0");
			$("#A060_05").val("0");
			$("#A060_07").val("0");
			$("#A060_09").val("0");
			$("#A060_11").val("0");

			$("#A060_03_h").val("0");
			$("#A060_05_h").val("0");
			$("#A060_07_h").val("0");
			$("#A060_09_h").val("0");
			$("#A060_11_h").val("0");	
		}
	} 
	
	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url 	= "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
	}

	function sheetChangeCheck() {
		var iTemp = sheet2.RowCount("I") + sheet2.RowCount("U") + sheet2.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}
	
	/* 안내 버튼 */
	$(document).ready(function(){
    	
    	$("#InfoMinus").hide("fast");
    	
    	/* 보험료안내 버튼 기능 Start */
    	//안내+ 버튼 선택시 안내- 버튼 호출 
    	$("#InfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id'); 
	    		if(btnId == "InfoPlus"){
	    			$("#InfoMinus").show("fast");
	    			$("#InfoPlus").hide("fast");
	    		}
    	});
    	
    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus").live("click",function(){
    			var btnId = $(this).attr('id'); 
	    		if(btnId == "InfoMinus"){
	    			$("#InfoPlus").show("fast");
	    			$("#InfoMinus").hide("fast");
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#InfoPlus").click(function(){
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
        });
    	
    	//안내- 선택시 화면 숨김
    	$("#InfoMinus").click(function(){
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
        });
    	/* 보험료안내 버튼 기능 End */
    });
	
  	//기본공제안내 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#infoLayerMain").fadeOut();
    		$("#InfoMinus").hide("fast");
    		$("#InfoPlus").show("fast");
    	}
    });
    
    
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchDpndntYn" name="searchDpndntYn" value="" />
	<input type="hidden" id="searchFamCd_s" name="searchFamCd_s" value="" />
	</form>	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">교육비 
				<!-- <a href="javascript:yeaDataExpPopup('교육비', helpText, 365);" class="cute_gray authR">교육비 안내</a> -->
				<!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >교육비 안내</a> -->
				<a href="#layerPopup" class="cute_gray" id="InfoPlus"><b>교육비 안내+</b></a>
	            <a href="#layerPopup" class="cute_gray" id="InfoMinus" style="display:none"><b>교육비 안내-</b></a>
			</li>
		</ul>
		</div>
	</div>
	<!-- Sample Ex&Image Start -->
    <div class="outer" style="display:none" id="infoLayerMain">
    	<table>
    		<tr>
    			<td style="padding:10px 5px 5px 5px;">
    				<div id="infoLayer"></div>
    			</td>
    		</tr>
    	</table>
    </div>
	<!-- Sample Ex&Image End -->
	<table border="0" cellpadding="0" cellspacing="0" class="default outer yeaData2">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="center">본인</th>
		<th class="center">취학전아동</th>
		<th class="center">초중고 교육비</th>
		<th class="center">대학생 교육비</th>
		<th class="center">장애인</th>
	</tr>
	<tr>
		<td class="right">
			<input id="A060_03_h" name="A060_03_h" type="text" class="text w25p right transparent"  readonly /> 명
		</td>
		<td class="right">
			<input id="A060_05_h" name="A060_05_h" type="text" class="text w25p right transparent" readOnly />명
		</td>
		<td class="right">
			<input id="A060_07_h" name="A060_07_h" type="text" class="text w25p right transparent" readOnly />명
		</td>
		<td class="right">
			<input id="A060_09_h" name="A060_09_h" type="text" class="text w25p right transparent" readOnly />명
		</td>
		<td class="right">
			<input id="A060_11_h" name="A060_11_h" type="text" class="text w25p right transparent" readOnly />명
		</td>
	</tr>
	<tr>
		<td class="right">
			<input id="A060_03" name="A060_03" type="text" class="text w50p right transparent"  readonly /> 원
		</td>
		<td class="right">
			<input id="A060_05" name="A060_05" type="text" class="text w50p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A060_07" name="A060_07" type="text" class="text w50p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A060_09" name="A060_09" type="text" class="text w50p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A060_11" name="A060_11" type="text" class="text w50p right transparent" readOnly />원
		</td>
	</tr>
	</table>

	<div class="outer">

	    <div>
	    	<font size='2'>	
			    <font style="color:blue;">※ 교복구입비(개인별 50만원한도)</font>:교육대상 구분 "초중고 > 교복구입비" 로 선택,  
					<font style="color:blue;">체험학습비(개인별 30만원한도)</font>:교육대상 구분 "초중고 > 체험학습비" 로 선택<br>
			    <font style="color:blue;">※ 해당연도 중 취학전 아동이 초등학생이 된 경우</font> 합산 300만원 이하로 수정 or 하나는 삭제하고 그외 항목에 합쳐서 기입 (개별 한도체크는 동작)<br>
			    <font style="color:blue;">※ 해당연도 중 고등학생이 대학생이 된 경우</font> 합산 900만원 초과시 각 구분별 한도내에 금액으로 수정(합산은 900만원이하)<br>
		    </font>
	    </div>
	    	
		<div class="sheet_title">
		<ul>
<!-- 			<li class="txt">※ 교복구입비(개인별 50만원한도):교육대상 구분 "초중고 > 교복구입비" 로 선택,  체험학습비(개인별 30만원한도):교육대상 구분 "초중고 > 체험학습비" 로 선택</li> -->
			<li class="btn">
<!-- 			<a href="javascript:parent.doReport('EDUCATION');"		class="cute authA">교육비명세서 양식</a> -->
			<a href="javascript:doAction2('Search');"		class="basic authR">조회</a>
			<span id="btnDisplayYn01">
			<a href="javascript:doAction2('Insert');"		class="basic authA">입력</a>
<%if("Y".equals(adminYn)) {%>
			<span id="copyBtn">
			<a href="javascript:doAction2('Copy');"			class="basic authA">복사</a>
			</span>
<%} %>
			<a href="javascript:doAction2('Save');"			class="basic authA">저장</a>
			</span>
			<a href="javascript:doAction2('Down2Excel');"	class="basic authR">다운로드</a>
		</li>
		</ul>
	</div>
	</div>
	<div style="height:380px">
	<script type="text/javascript">createIBSheet("sheet2", "100%", "380px"); </script>
	</div>	
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	</span>
</div>
</body>
</html>