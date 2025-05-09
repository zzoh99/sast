<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>교육비내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var adjustTypeList = null;
	var restrictCdList = null;
	var adjInputTypeList = null;
	var workTypeList = null;
	var workTypeList2 = null;

	// 교육 초중고/대학교 상세 구분 변수
	var contributionCdList1;
	var contributionCdList2;
	
	var famComboText = '';
	var famComboCode = '';

	$(function() {
        $("#menuNm").val($(document).find("title").text());
		$("#searchYear").val("<%=yeaYear%>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
	          <%// 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. => initdata 세팅으로 조정
	            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.%>
			{Header:"대상년도",		Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4, DefaultValue:"<%=yeaYear%>" },
			{Header:"정산구분",		Type:"Combo",		Hidden:0, 	Width:110,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성명",			Type:"Popup",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"데이터키값(수정금지)",			Type:"Text",		Hidden:1, 	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"seq",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"명의인",			Type:"Text",		Hidden:0,  	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"fam_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"명의인주민번호",	Type:"Text",		Hidden:0,  	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:1, Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"관계",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"fam_cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"교육대상구분",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"work_type",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"상세구분",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"restrict_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"금액(담당자용)",	Type:"Int",			Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"자료입력유형",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"국세청\n자료수정여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_modify_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0, TrueValue:"Y", FalseValue:"N" },
			{Header:"국세청\n자료원본",	Type:"Int",		Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"nts_original_appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
            {Header:"담당자확인",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"feedback_type",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"DOC_SEQ",		Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//양식다운로드 시트
		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
			{Header:"대상년도",		Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",		Type:"Combo",		Hidden:0, 	Width:110,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성명",			Type:"Text",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"데이터키값(수정금지)",			Type:"Text",		Hidden:0, 	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"seq",				KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"명의인",			Type:"Text",		Hidden:0,  	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"fam_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"명의인주민번호",	Type:"Text",		Hidden:0,  	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:1, Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"교육대상구분",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"work_type",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"금액(담당자용)",	Type:"Int",			Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"자료입력유형",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"담당자확인",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"feedback_type",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(false);sheet2.SetCountPosition(4);

		adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		restrictCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00340"), "");
		adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00325"), "전체");
		workTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00313"), "");
		workTypeList2 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00313"), "전체");

		contributionCdList1 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getCommonCodeNoteEduList&note1=E&searchYear=<%=yeaYear%>","C00342"), "");
		contributionCdList2 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getCommonCodeNoteEduList&note1=D&searchYear=<%=yeaYear%>","C00342"), "");

		sheet1.SetColProperty("work_type",		{ComboText:"|"+workTypeList[0], ComboCode:"|"+workTypeList[1]} );
		sheet1.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet1.SetColProperty("restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );

		$("#searchInputType").html(adjInputTypeList[2]);
		$("#searchWorkType").html(workTypeList2[2]);

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();

		getCprBtnChk();

		//doAction1("Search");
			
		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		templeteTitle1 += "주민번호 : " + " 숫자만 입력해 주십시오 "+ "\n\n";

		codeCdNm = "";
		codeNm = workTypeList[0].split("|"); codeCd = workTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "교육대상구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = contributionCdList1[0].split("|"); codeCd = contributionCdList1[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "상세구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = adjInputTypeList[0].split("|"); codeCd = adjInputTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "자료입력유형 : " + codeCdNm + "\n";

	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});
	
	function chkRqr(){

        var chkSearchAdjustType    = $("#searchAdjustType").val();

        var chkValue = false;

        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
    }

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/eduHisMgr/eduHisMgrRst.jsp?cmd=selectEduHisMgrList", $("#sheetForm").serialize() );
			break;
			
		case "Insert":
			if(chkRqr()){
	       		 break;
	       	}
         	
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#searchAdjustType").val() ) ;
			sheet1.SetCellValue(Row, "adj_input_type", '02' ) ;
         	
			break;	

        case "Save":

			for( var i = 1; i < sheet1.LastRow()+1; i++) {

				if(sheet1.GetCellValue(i, "adj_input_type") == "07" || sheet1.GetCellValue(i, "appl_mon") == "0") continue;

				if( sheet1.GetCellValue(i, "sStatus") == "U" ||
					sheet1.GetCellValue(i, "sStatus") == "I" ||
					sheet1.GetCellValue(i, "sStatus") == "S") {

					if( sheet1.GetCellValue(i, "work_type") == "30" && sheet1.GetCellValue(i, "restrict_cd") == "10" ) {
						if( parseInt( sheet1.GetCellValue(i, "input_mon") , 10) > 500000 ) {
							alert("교육대상구분 초중고 > 교복구입비 입력금액한도는 개인별 최대 50만원까지 가능합니다.") ;
							sheet2.SelectCell(i, "input_mon") ;
							return ;
						}
					}

					if( sheet1.GetCellValue(i, "work_type") == "30" && sheet1.GetCellValue(i, "restrict_cd") == "20" ) {
                        if( parseInt( sheet1.GetCellValue(i, "input_mon") , 10) > 300000 ) {
                            alert("교육대상구분 초중고 > 체험학습비 입력금액한도는 개인별 최대 30만원까지 가능합니다.") ;
                            sheet1.SelectCell(i, "input_mon") ;
                            return ;
                        }
                    }

					if(sheet1.GetCellValue(i, "work_type") == "20" || sheet1.GetCellValue(i, "work_type") == "30"|| sheet1.GetCellValue(i, "work_type") == "40"){
						if(sheet1.GetCellValue(i, "name") == sheet1.GetCellValue(i, "fam_nm")){
							alert("취학전아동, 초중고교육비, 대학생교육비는 본인 이외의 대상자에 한해 선택 가능합니다.");
							sheet1.SetCellValue(i, "work_type", "") ;
							sheet1.SetCellEditable(i, "work_type", 1) ;
							return;
						}
					}

					if(sheet1.GetCellValue(i, "work_type") == "10"){
						if(sheet1.GetCellValue(i, "name") != getFmNm(sheet1.GetCellValue(i, "fam_nm"), i)){
							alert("교육대상구분(본인)은 본인만 입력 가능합니다.");
							sheet1.SetCellValue(i, "work_type", "") ;
							sheet1.SetCellEditable(i, "work_type", 1) ;
							return;
						}
					}
				}
			}
            sheet1.DoSave( "<%=jspPath%>/eduHisMgr/eduHisMgrRst.jsp?cmd=saveEduHisMgr", $("#sheetForm").serialize());
            break;
            
        case "Copy":
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "adj_input_type") == "07") {
				alert("PDF업로드 자료는 복사할 수 없습니다.");
				return;
			}

			sheet1.DataCopy();
			break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;

		case "Down2Template":
			var param  = {DownCols:"adjust_type"
                                    +"|sabun|fam_nm|famres|work_type|restrict_cd|appl_mon|adj_input_type"
				,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1
				,UserMerge :"0,0,1,7"
				,menuNm:$(document).find("title").text()
                ,HiddenColumn:1 //  열숨김 반영 여부 (Default: 0)
                };
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
			if(chkRqr()){
	       		 break;
	       	}

            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.
            // 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. 
            //              work_yy     => initdata 세팅으로 조정 
            //              adjust_type => 엑셀 양식에서 key-in으로 조정
            //sheet1.SetColProperty(0, "work_yy", { DefaultValue: $("#searchYear").val() } );
            //sheet1.SetColProperty(0, "adjust_type", { DefaultValue: $("#searchAdjustType").val() } );

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if (Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
					if( sheet1.GetCellValue(i, "work_type") == "30" || sheet1.GetCellValue(i, "work_type") == "40" ) {
						sheet1.CellComboItem(i,	"restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );
						sheet1.SetCellEditable(i, "restrict_cd", 1) ;
					} else {
						sheet1.SetCellEditable(i, "restrict_cd", 0) ;
						sheet1.SetCellValue(i, "restrict_cd", "") ;
					}
					if (sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF
						sheet1.SetRowEditable(i, 0);
					}
				}
			}
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnLoadExcel(result) {

		try {
			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){				
				if( sheet1.GetCellValue(i, "work_type") == "30" || sheet1.GetCellValue(i, "work_type") == "40" ) {
					sheet1.CellComboItem(i,	"restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );
					sheet1.SetCellEditable(i, "restrict_cd", 1) ;
				} else {
					sheet1.SetCellEditable(i, "restrict_cd", 0) ;
					sheet1.SetCellValue2(i, "restrict_cd", "") ; // 20250428. 성능저하로 인하여 onChange 이벤트가 발생하지 않도록 SetCellValue2 사용.
				}
				if (sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF
					sheet1.SetRowEditable(i, 0);
				}
			}
		} catch(ex) {
			alert("OnLoadExcel Event Error " + ex);
		}
	}

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if(Code == 1) {
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    //값 변경시 발생
    function sheet1_OnChange(Row, Col, Value) {
        try{
        	if( sheet1.ColSaveName(Col) == "sabun" ) {
				if( sheet1.GetCellValue(Row, "sabun") != "" ) {
					setFamList( sheet1.GetCellValue(Row, "sabun") ) ;
				}
			}
			if( sheet1.ColSaveName(Col) == "fam_nm" ) {
				sheet1.SetCellValue(Row, "famres", sheet1.GetCellValue(Row, "fam_nm") ) ;
			}
        	if(sheet1.ColSaveName(Col) == "famres" || sheet1.ColSaveName(Col) == "work_type"){

				if(sheet1.GetCellValue(Row, "work_type") == "20" || sheet1.GetCellValue(Row, "work_type") == "30" || sheet1.GetCellValue(Row, "work_type") == "40"){
					if(sheet1.GetCellValue(Row, "name") == sheet1.GetCellValue(Row, "fam_nm")){
						alert("취학전아동, 초중고교육비, 대학생교육비는 본인 이외의 대상자에 한해 선택 가능합니다.");
						sheet1.SetCellValue(Row, "work_type", "") ;
						sheet1.SetCellEditable(Row, "work_type", 1) ;
						return;
					}
				}

				if(sheet1.GetCellValue(Row, "work_type") == "10"){
					if(sheet1.GetCellValue(Row, "name") != getFmNm(sheet1.GetCellValue(Row, "fam_nm"), Row)){
						alert("교육대상구분(본인)은 본인만 입력 가능합니다.");
						sheet1.SetCellValue(Row, "work_type", "") ;
						return;
					}
				}
			}

			//기타의료비 영수증  관련
			if(sheet1.ColSaveName(Col) == "work_type"){
				if(sheet1.GetCellValue(Row,"work_type") == "30"){
					sheet1.CellComboItem(Row,	"restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );
					sheet1.SetCellEditable(Row,"restrict_cd", 1) ;
					sheet1.SetCellValue(Row,"restrict_cd", "00") ;
				}else if(sheet1.GetCellValue(Row,"work_type") == "40"){
					//2019-11-14. 교육대상구분이 '초중고_본인외'가 아니면 상세구분 비활성화 처리
					sheet1.SetCellValue(Row,"restrict_cd", "");
					sheet1.SetCellEditable(Row,"restrict_cd", 0);
				}else{
					sheet1.SetCellEditable(Row,"restrict_cd", 0) ;
					sheet1.SetCellValue(Row,"restrict_cd", "") ;
					sheet1.SetCellEditable(Row,"nts_yn", 1) ;
				}
			}
			//상세제약구분
			if(sheet1.ColSaveName(Col) == "restrict_cd"){
				if(sheet1.GetCellValue(Row,"restrict_cd") =="10"){
					sheet1.SetCellEditable(Row,"nts_yn", 1) ;
					sheet1.SetCellValue(Row,"nts_yn", "N") ;
				}else{
					sheet1.SetCellEditable(Row,"nts_yn", 1) ;
				}
			}

			//교복구입비 50만원 한도계산, 체험학습비 30만원 한도계산
			if(sheet1.ColSaveName(Col) == "famres" || sheet1.ColSaveName(Col) == "restrict_cd" || sheet1.ColSaveName(Col) == "appl_mon"){

				if(sheet1.GetCellValue(Row,"appl_mon") > 0){
					if(sheet1.GetCellValue(Row,"restrict_cd") == "10"){
						var sumData = 0;

						for(var i=1; i < sheet1.LastRow()+1; i++){
							if((sheet1.GetCellValue(Row,"famres") == sheet1.GetCellValue(i,"famres")) && (sheet1.GetCellValue(Row,"restrict_cd") == sheet1.GetCellValue(i,"restrict_cd"))){
								sumData = sumData + parseInt(sheet1.GetCellValue(i,"appl_mon"), 10);
							}
						}

						if(sumData > 500000){
							alert("교복구입비 한도금액이 초과되었습니다.");
							sheet1.SetCellValue(Row,"appl_mon", "0") ;
							return;
						}
					}

					if(sheet1.GetCellValue(Row,"restrict_cd") == "20"){
                        var sumData = 0;

                        for(var i=1; i < sheet1.LastRow()+1; i++){
                            if((sheet1.GetCellValue(Row,"famres") == sheet1.GetCellValue(i,"famres")) && (sheet1.GetCellValue(Row,"restrict_cd") == sheet1.GetCellValue(i,"restrict_cd"))){
                                sumData = sumData + parseInt(sheet1.GetCellValue(i,"appl_mon"), 10);
                            }
                        }

                        if(sumData > 300000){
                            alert("체험학습비 한도금액이 초과되었습니다.");
                            sheet1.SetCellValue(Row,"appl_mon", "0") ;

                            return;
                        }
                    }
				}
			}
        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sDelete" ) {
				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet1.GetCellValue(Row, "adj_input_type") == "07" ) {
					sheet1.SetCellEditable(Row, "input_mon", 0);
					sheet1.SetCellEditable(Row, "appl_mon", 0);
					sheet1.SetCellEditable(Row, "nts_yn", 0);
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//사원 조회
	function openEmployeePopup(Row){
	    try{
		    var args    = new Array();

		    if(!isPopup()) {return;}
		    gPRow = Row;
		    pGubun = "employeePopup";

		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	     /*
	        if(rv!=null){
				sheet1.SetCellValue(Row, "name", 		rv["name"] );
				sheet1.SetCellValue(Row, "sabun", 		rv["sabun"] );
				sheet1.SetCellValue(Row, "org_nm", 		rv["org_nm"] );
	        }
	     */
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
		}
	}
	
	//명의인 셋팅
	function setFamList(searchSabun) {
		var params = "searchWorkYy="+$("#searchYear").val()
					+"&searchAdjustType="+$("#searchAdjustType").val()
					+"&searchSabun="+searchSabun
					+"&searchDpndntYn=Y"
					+"&searchFamCd_s=,6,7,8";

		//dynamic query 보안 이슈 때문에 queryId=getFamCodeList2 분기 처리
		var famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList2",params,false).codeList, "");

		if(famList[0] == null) {
			alert("정산가족사항 데이터가 존재하지 않습니다.") ;
		} else {
			//해당 대상자의 정산가족으로 세팅
			var info = {Type:"Combo", ComboText:"|"+famList[0], ComboCode:"|"+famList[1]} ;
			famComboText = famList[0].split("|");
			famComboCode = famList[1].split("|");
			sheet1.InitCellProperty(sheet1.GetSelectRow(),"fam_nm",info);
			sheet1.SetCellValue(sheet1.GetSelectRow(),"fam_nm","");
			sheet1.SetCellEditable(sheet1.GetSelectRow(),"fam_nm",1);
			
		}
	}
	
	function getFmNm(code, row){
		
		if(code.length != 13){
			// 업로드로 입력시, code 값은 이름이라 combo값에서 찾을 필요없이 return
			return code;
		}
		
		if(famComboText == ''){
			var sabun = sheet1.GetCellValue(row, "sabun");
			var params = "searchWorkYy="+$("#searchYear").val()
			+"&searchAdjustType="+$("#searchAdjustType").val()
			+"&searchSabun="+sabun
			+"&searchDpndntYn=Y"
			+"&searchFamCd_s=,6,7,8";

			var famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList2",params,false).codeList, "");
			famComboText = famList[0].split("|");
			famComboCode = famList[1].split("|");	
		}
		return famComboText[famComboCode.indexOf(code)];
	}
	
	//수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchYear").val() 
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
		
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
  			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
  			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
			</tr>
			<tr>
                <td>
                    <span>교육대상구분</span>
                    <select id="searchWorkType" name ="searchWorkType" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
		</table>
		</div>
	</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">교육비내역관리</li>
			<li class="btn">
<!-- 				<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a> -->
				<a href="javascript:doAction1('Down2Template')"	class="basic btn-download authR">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save');" class="basic btn-save authA">저장</a>
 				<a href="javascript:doAction1('Down2Excel')"	class="basic btn-download authR">다운로드</a> 
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
</div>
</body>
</html>