<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>연금보험료</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=orgAuthPg%>";
	//도움말
	var helpText3;
	//기준년도
	var systemYY;
	//총급여
    var paytotMonStr;
	//총급여 확인 버튼 유무
	var yeaMonShowYn ;

	//기본정보
	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchWorkYy").val($("#searchWorkYy", parent.document).val());
		$("#searchAdjustType").val($("#searchAdjustType", parent.document).val());
		$("#searchSabun").val($("#searchSabun", parent.document).val());
		systemYY = $("#searchWorkYy", parent.document).val();

		//기본정보 조회(도움말 등등).
		initDefaultData();
	});

	//쉬트 초기화
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

 		//연말정산 연금보험료 쉬트.
 		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",							Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",							Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",							Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"년도|년도",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"구분|구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"saving_deduct_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직연금\n구분|퇴직연금\n구분",	Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"ret_pen_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"금융기관코드|금융기관코드",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"finance_org_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"가입일자|가입일자",                        Type:"Date",       Hidden:0,   Width:70,   Align:"Center",   ColMerge:1, SaveName:"reg_dt",      KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"납입횟수코드|납입횟수코드",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"paying_num_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"계좌번호\n(또는증권번호)|계좌번호\n(또는증권번호)",Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"account_no",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"금액자료\n(당해 연도 ISA계좌전환금 포함)|직원용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",			KeyField:0,	Format:"#,###",			PointCount:0,	UpdateEdit:<%=inputEdit%>,	InsertEdit:<%=inputEdit%>,	EditLen:35, MinimumValue: 0 },
			{Header:"금액자료\n(당해 연도 ISA계좌전환금 포함)|담당자용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",			KeyField:1,	Format:"#,###",			PointCount:0,	UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35, MinimumValue: 0 },
			{Header:"공제금액\n(당해 연도 ISA계좌전환금 포함)|공제금액",						Type:"Int",			Hidden:1,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"ded_mon",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
            {Header:"당해 연도 ISA계좌전환 금액자료|직원용",          Type:"AutoSum",         Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"input_mon_isa",            KeyField:0, Format:"#,###",         PointCount:0,   UpdateEdit:<%=inputEdit%>,   InsertEdit:<%=inputEdit%>,   EditLen:35, MinimumValue: 0 },
            {Header:"당해 연도 ISA계좌전환 금액자료|담당자용",          Type:"AutoSum",         Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"appl_mon_isa",            KeyField:0, Format:"#,###",         PointCount:0,   UpdateEdit:<%=applEdit%>,   InsertEdit:<%=applEdit%>,   EditLen:35, MinimumValue: 0 },
            {Header:"당해 연도 ISA계좌전환 금액자료|공제금액",          Type:"Int",         Hidden:1,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"ded_mon_isa",            KeyField:0, Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"자료입력유형|자료입력유형",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"50세이상여부|50세이상여부",					Type:"CheckBox",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"age_chk",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:0, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00325"), "");
		var financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00319"), "");
		//dynamic query 보안 이슈 때문에 queryId=getSavingDeductList2 분기 처리
		var savingDeductTypeList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getSavingDeductList2&searchYear="+<%=yeaYear%>,"searchGubun=2,3",false).codeList, "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00329"), "");
		var retPenTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00318"), "");

		sheet1.SetColProperty("adj_input_type",		{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet1.SetColProperty("finance_org_cd",		{ComboText:"|"+financeOrgCdList[0], ComboCode:"|"+financeOrgCdList[1]} );
		sheet1.SetColProperty("saving_deduct_type",	{ComboText:savingDeductTypeList[0], ComboCode:savingDeductTypeList[1]} );
		sheet1.SetColProperty("feedback_type",		{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		sheet1.SetColProperty("ret_pen_type",		{ComboText:"|"+retPenTypeList[0], ComboCode:"|"+retPenTypeList[1]} );

<%--         sheet1.SetRangeBackColor(0,0,1, sheet1.LastCol(),"<%=headerColorA%>") ; --%>

		$(window).smartresize(sheetResize);
		sheetInit();
		parent.doSearchCommonSheet();
		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn01").hide() ;
            sheet1.SetEditable(false) ;
		}
		doAction1("Search");
		
		/* 2023년도 50세 이상 나이 요건 삭제 */
		// 50세이상확인 여부 조회
		//getAgeChk();

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

				/*
					1.연금저축 등록시 가입일자 체크
					   ㄱ.가입일자 미등록시 경고창 띄움
					   ㄴ.가입일자가 2001.1.1 이전이면 등록 못하게 처리
					   ㄷ.pdf데이터는 체크 안함
				*/
				if( sheet1.GetCellValue(i, "saving_deduct_type") == "22" && !(sheet1.GetCellValue(i, "adj_input_type") == "07") ) {
					var reg_dt = sheet1.GetCellValue(i, "reg_dt");

					if ( reg_dt == "" ) {
						alert("연금저축의 가입일자는 필수입력입니다.");
						sheet1.SetSelectRow(i);
						return;
					}

					if ( reg_dt < "20010101" ) {
						alert("연금저축의 가입일자는 2001년 1월 1일 이후이어야 합니다.");
						sheet1.SetSelectRow(i);
						return;
					}
				}
			}

			sheet1.DoSave("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=saveYeaDataPen&orgAuthPg="+orgAuthPg);
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

		case "Copy":
            var newRow = sheet1.DataCopy();

			if(sheet1.GetCellValue(newRow, "saving_deduct_type") == "11" || sheet1.GetCellValue(newRow, "saving_deduct_type") == "12") {
				sheet1.SetCellEditable(newRow, "ret_pen_type", true);
			} else {
				sheet1.SetCellValue(newRow, "ret_pen_type", "");
				sheet1.SetCellEditable(newRow, "ret_pen_type", false);
			}

            sheet1.SelectCell(newRow, 2) ;

            break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
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
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{
			// 연금금액과 ISA계좌금액의 대소비교 체크로직
			if(sheet1.ColSaveName(Col) == "input_mon" && (sheet1.GetCellValue(Row,"input_mon") != "" || sheet1.GetCellValue(Row,"input_mon") == "0")) {
				if(sheet1.GetCellValue(Row,"input_mon") < sheet1.GetCellValue(Row,"input_mon_isa")) {
					alert("연금금액은 ISA계좌금액보다 작을 수 없습니다.");
					sheet1.SetCellValue(Row, "input_mon", OldValue, 0);
					return false;
				}
			}
			else if(sheet1.ColSaveName(Col) == "appl_mon" && (sheet1.GetCellValue(Row,"appl_mon") != "" || sheet1.GetCellValue(Row,"appl_mon") == "0")) {
				if(sheet1.GetCellValue(Row,"appl_mon") < sheet1.GetCellValue(Row,"appl_mon_isa")) {
					alert("연금금액은 ISA계좌금액보다 작을 수 없습니다.");
					sheet1.SetCellValue(Row, "appl_mon", OldValue, 0);
					return false;
				}
			}
			else if(sheet1.ColSaveName(Col) == "input_mon_isa" && (sheet1.GetCellValue(Row,"input_mon_isa") != "" || sheet1.GetCellValue(Row,"input_mon_isa") == "0")) {
				if(sheet1.GetCellValue(Row,"input_mon_isa") > sheet1.GetCellValue(Row,"input_mon")) {
					alert("ISA계좌금액은 연금금액보다 클 수 없습니다.");
					sheet1.SetCellValue(Row, "input_mon_isa", OldValue, 0);
					return false;
				}
			}
			else if(sheet1.ColSaveName(Col) == "appl_mon_isa" && (sheet1.GetCellValue(Row,"appl_mon_isa") != "" || sheet1.GetCellValue(Row,"appl_mon_isa") == "0")) {
				if(sheet1.GetCellValue(Row,"appl_mon_isa") > sheet1.GetCellValue(Row,"appl_mon")) {
					alert("ISA계좌금액은 연금금액보다 클 수 없습니다.");
					sheet1.SetCellValue(Row, "appl_mon_isa", OldValue, 0);
					return false;
				}
			}

			if(sheet1.ColSaveName(Col) == "input_mon") {
				sheet1.SetCellValue(Row,"appl_mon", sheet1.GetCellValue(Row,Col), 0);
			}
			if(sheet1.ColSaveName(Col) == "input_mon_isa") {
				sheet1.SetCellValue(Row,"appl_mon_isa", sheet1.GetCellValue(Row,Col), 0);
			}

			if(sheet1.GetCellValue(Row, "saving_deduct_type") == "11" || sheet1.GetCellValue(Row, "saving_deduct_type") == "12") {
				sheet1.SetCellEditable(Row, "ret_pen_type", true);
			} else {
				sheet1.SetCellValue(Row, "ret_pen_type", "");
				sheet1.SetCellEditable(Row, "ret_pen_type", false);
			}

			/*
			1.연금저축 등록시 가입일자 체크
			   ㄱ.가입일자 미등록시 경고창 띄움
			   ㄴ.가입일자가 2001.1.1 이전이면 등록 못하게 처리
			*/
			if(sheet1.ColSaveName(Col) == "reg_dt") {
				if(sheet1.GetCellValue(Row, "saving_deduct_type") == "22"){
					if ( Value.length == 8 && Value < '20010101' ) {
						alert("가입일자는 2001년 1월 1일 이후이어야 합니다.");
						sheet1.SetCellValue(Row, "reg_dt", OldValue);
					}
				}
			}

		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sDelete" ) {
				tab_clickDelete(sheet1, Row);

				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet1.GetCellValue(Row, "adj_input_type") == "07" ) {
					sheet1.SetCellEditable(Row, "input_mon", 0);
					sheet1.SetCellEditable(Row, "appl_mon", 0);
					sheet1.SetCellEditable(Row, "input_mon_isa", 0);
					sheet1.SetCellEditable(Row, "appl_mon_isa", 0);
					sheet1.SetCellEditable(Row, "nts_yn", 0);
					sheet1.SetCellEditable(Row, "reg_dt", 0);
				}
				sheet1.SetCellEditable(Row, "ret_pen_type", 0);
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//기본정보 조회(도움말 등등).
	function initDefaultData() {
		var params = "searchWorkYy="+$("#searchWorkYy").val();
		params += "&adjProcessCd=B003";
		params += "&queryId=getYeaDataHelpText";

        var param2 = "searchWorkYy="+$("#searchWorkYy").val();
        param2 += "&searchAdjustType="+$("#searchAdjustType").val();
        param2 += "&searchSabun="+$("#searchSabun").val();
        param2 += "&queryId=getYeaDataPayTotMon";

		var result = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params,false);

		// 총급여
        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
        paytotMonStr = nvl(result2.Data.paytot_mon,"");

		//총급여 확인 버튼 유무
		var result3 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN&searchWorkYy="+$("#searchWorkYy").val(), "queryId=getYeaSystemStdData",false).codeList;
		yeaMonShowYn = nvl(result3[0].code_nm,"");

		helpText3 = result.Data.help_text1 + result.Data.help_text2 + result.Data.help_text3;
		//안내메세지
        $("#infoLayer").html(helpText3).hide();
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

			$("#A030_031").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_031"),"input_mon") ) ;
			$("#A030_041").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_041"),"input_mon") ) ;
			$("#A100_051").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_051"),"input_mon") ) ;
			$("#A030_03_ALL").val( comma(parseInt(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A030_03"),"input_mon"))
					             + parseInt(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A030_031"),"input_mon"))) ) ;
			$("#A030_04_ALL").val( comma(parseInt(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A030_04"),"input_mon"))
					             + parseInt(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A030_041"),"input_mon"))) ) ;
			$("#A100_05_ALL").val( comma(parseInt(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A100_05"),"input_mon"))
					             + parseInt(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A100_051"),"input_mon"))) ) ;
		}else{
			$("#A030_01").val("0");
			$("#A030_02").val("0");
			$("#A030_03").val("0");
			$("#A030_04").val("0");
			$("#A100_05").val("0");
			$("#A100_03").val("0");

			$("#A030_031").val("0");
			$("#A030_041").val("0");
			$("#A100_051").val("0");
			$("#A030_03_ALL").val("0");
			$("#A030_04_ALL").val("0");
			$("#A100_05_ALL").val("0");
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

    /* 주택자금 안내 버튼 */
	$(document).ready(function(){

    	$("#InfoMinus").hide();

    	/* 보험료안내 버튼 기능 Start */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#InfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "InfoPlus"){
	    			$("#InfoMinus").show();
	    			$("#InfoPlus").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "InfoMinus"){
	    			$("#InfoPlus").show();
	    			$("#InfoMinus").hide();
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
    		$("#InfoMinus").hide();
    		$("#InfoPlus").show();
    	}
    });

	//[총급여] 보이기
    function paytotMonView(){

        if(paytotMonStr != ""){
            if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 120000000 ) {
                $("#span_paytotMonView").html("<B>YES</B>&nbsp;<a class='under-line bold' href='javascript:paytotMonViewClose()'>닫기</a>");
            }else{
                $("#span_paytotMonView").html("<B>NO</B>&nbsp;<a class='under-line bold' href='javascript:paytotMonViewClose()'>닫기</a>");
            }
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
        }
    }

    //[총급여] 닫기
    function paytotMonViewClose(){
       $("#span_paytotMonView").html("");
    }

    /* 2023년도 50세 이상 나이 요건 삭제 */	
    /* function chkReset(){
		if($("#saveAgeChk").is(":checked") == true) $(':checkbox[name=saveAgeChk]').attr('checked', false);
		else $(':checkbox[name=saveAgeChk]').attr('checked', true);
		return;
    } */

    /* 2023년도 50세 이상 나이 요건 삭제 */	
    //50세이상 확인유무 저장
	<%-- function saveAgeChk(){

    	var params = $("#sheetForm").serialize();

		if($("#saveAgeChk").is(":checked") == false){
			params += "&searchAgeChk=N";
			ajaxCall("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=saveAgeChk",params,false);
		}else{
			//연령
			var age = 0 ;
			//주민번호
            var resNo = "";
            params += "&queryId=getResNo";
			var getResNo = ajaxCall("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=getResNo",params,false);

			if(getResNo != "" && getResNo != null ){
				resNo = getResNo.Data.res_no;

	            if( resNo.substring(6,7) == "3" || resNo.substring(6,7) == "4" || resNo.substring(6,7) == "7" || resNo.substring(6,7) == "8"  ) {
	                age = systemYY - parseInt("20" + resNo.substring(0,2) , 10) ;
	            } else {
	                age = systemYY - parseInt("19" +  resNo.substring(0,2) , 10) ;
	            }

	            if(age < 50){
	                alert("대상자 나이 요건이 맞지 않습니다.");
	                chkReset();
	            }else if(( paytotMonStr.replace(/,/gi, "") *1 ) > 120000000){
	                alert("총급여가 1억2천만원이 초과하여 적용 대상이 아닙니다.");
	                chkReset();
	            }else {
	                var confirmMsg = "총급여 1억2천이 초과하거나 금융소득 종합과세대상자"
	                                +"\n (금융소득금액 2천만원 초과자)인 경우 적용 대상이 아닙니다."
	                                +"\n 확인하셨습니까?";

	                if(confirm(confirmMsg)){

	                    var params = $("#sheetForm").serialize();
	                        params += "&searchAgeChk=Y";

	                    ajaxCall("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=saveAgeChk",params,false);
	                } else{
	                    chkReset();
	                }
	            }
			}
    	}
	} --%>
	
	/* 2023년도 50세 이상 나이 요건 삭제 */
	//50세이상확인 유무 조회
	<%-- function getAgeChk(){

		var params = $("#sheetForm").serialize();
			params += "&queryId=getAgeChk";

        var ageChkYn = ajaxCall("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=getAgeChk",params,false);

		if(ageChkYn.Data.age_chk != "N" && ageChkYn.Data.age_chk.length > 0) {
			$(':checkbox[name=saveAgeChk]').attr('checked', true);
		} else {
			$(':checkbox[name=saveAgeChk]').attr('checked', false);
		}
	} --%>

    function comma(str) {
    	if ( str == "" ) return 0;

		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}

</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	   <input type="hidden" id="menuNm" name="menuNm" value="" />
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">연금
				<!-- <a href="javascript:yeaDataExpPopup('연금', helpText3, 400);" class="cute_gray authR">연금 안내</a> -->
				<!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >연금 안내</a> -->
				<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus"><b>연금 안내+</b></a>
	            <a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus" style="display:none"><b>연금 안내-</b></a>
			</li>
		</ul>
		</div>
	</div>
	<!-- Sample Ex&Image Start -->
    <div class="outer" style="display:none" id="infoLayer">
    	<table>
    		<tr>
    			<td style="padding:10px 5px 5px 5px;">
    				<div id="infoLayer"></div>
    			</td>
    		</tr>
    	</table>
    </div>
	<!-- Sample Ex&Image End -->
	<table border="0" cellpadding="0" cellspacing="0" class="default line outer">
	<colgroup>
		<col width="11.11%" />
		<col width="11.11%" />
		<col width="11.11%" />
		<col width="11.11%" />
		<col width="11.11%" />
		<col width="11.11%" />
		<col width="11.11%" />
		<col width="11.11%" />
		<col width="11.12%" />
	</colgroup>
	<!--
	<tr class="hide">
		<th class="center" colspan=2 >연금보험료공제</th>
		<th class="center"  >그밖의 소득공제</th>
		<th class="center" colspan=3>연금계좌 세액공제</th>
	</tr>
	-->
	<tr>
		<!--
		<th class="center hide" >국민연금보험료</th>
		<th class="center hide" >기타 연금보험</th>
		<th class="center hide" >개인연금저축<br>(2000.12.31 이전 가입)</th>
		-->
		<th class="center" colspan="3">과학기술인공제 퇴직연금</th>
		<th class="center" colspan="3">퇴직연금납입금액</th>
		<th class="center" colspan="3">연금저축 (2001.1.1 이후 가입)</th>
	</tr>
	<tr>
		<th class="center">전체금액<br/>(ISA계좌 포함)</th>
		<th class="center">연금금액<br/>(ISA계좌 미포함)</th>
		<th class="center">ISA계좌<br/>전환금액</th>
		<th class="center">전체금액<br/>(ISA계좌 포함)</th>
		<th class="center">연금금액<br/>(ISA계좌 미포함)</th>
		<th class="center">ISA계좌<br/>전환금액</th>
		<th class="center">전체금액<br/>(ISA계좌 포함)</th>
		<th class="center">연금금액<br/>(ISA계좌 미포함)</th>
		<th class="center">ISA계좌<br/>전환금액</th>
	</tr>
	<tr>
		<!--
		<td class="right hide">
			<input id="A030_01" name="A030_01" type="text" class="text w70p right transparent" readonly /> 원
		</td>
		<td class="right hide">
			<input id="A030_02" name="A030_02" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right hide">
			<input id="A100_03" name="A100_03" type="text" class="text w70p right transparent" readonly /> 원
		</td>
		-->
		<td class="right">
			<input id="A030_04_ALL" name="A030_04_ALL" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A030_04" name="A030_04" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A030_041" name="A030_041" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A030_03_ALL" name="A030_03_ALL" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A030_03" name="A030_03" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A030_031" name="A030_031" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A100_05_ALL" name="A100_05_ALL" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A100_05" name="A100_05" type="text" class="text w70p right transparent" readOnly />원
		</td>
		<td class="right">
			<input id="A100_051" name="A100_051" type="text" class="text w70p right transparent" readOnly />원
		</td>
	</tr>
	</table>
     <div class="sheet_title">
        <!-- <ul>
            <li class="txt"> 50세이상확인
            	<span id="paytotMonViewYn">
                    <a href="javascript:paytotMonView();" class="basic btn-red-outline authA">총급여 1억2천만원 초과여부</a>
                </span>
                <span id="span_paytotMonView"></span>
            </li>
        </ul>

    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="15%" />
			<col width="85%" />
		</colgroup>
    	<tr>
    		<th>50세이상
    			&nbsp;&nbsp;<input type="checkbox" class="checkbox" id="saveAgeChk" name="saveAgeChk" onclick="saveAgeChk();" value="" style="vertical-align: middle;">
    		</th>
    		<td>
    			<font class='red'>1) 만 50세 이상<br>2) 총급여 1억2천만원 이하<br>3) 금융소득 종합과세대상자(금융소득금액 2천만원 초과자)가 아님<br>※ 위 3가지 요건을 전부 충족할 경우 체크해주십시오.</font>
    		</td>
    	</tr>
    </table> -->

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"></li>
			<li class="btn">

			<a href="javascript:doAction1('Search');"		class="basic authR">조회</a>
			<span id="btnDisplayYn01">
				<a href="javascript:doAction1('Insert');"		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy');"		class="basic authA">복사</a>
				<a href="javascript:doAction1('Save');"			class="basic btn-save authA">저장</a>
			</span>
			<a href="javascript:doAction1('Down2Excel');"	class="basic btn-download authR">다운로드</a>

		</li>
		</ul>
	</div>
	</div>
	</div> 
	<div style="height:430px">
	<script type="text/javascript">createIBSheet("sheet1", "100%", "430px"); </script>
	</div>
	<span class="hide">
		<script type="text/javascript">createIBSheet("yeaSheet1", "100%", "100%"); </script>
		<script type="text/javascript">createIBSheet("yeaSheet7", "100%", "100%"); </script>
	</span>
</div>
</body>
</html>