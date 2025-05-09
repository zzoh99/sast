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

	// 교육 초중고/대학교 상세 구분 변수
	var contributionCdList1;
	var contributionCdList2;

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
			{Header:"대상년도",		Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",		Type:"Combo",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성명",			Type:"Text",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"순서",			Type:"Text",		Hidden:1, 	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"seq",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"명의인",			Type:"Text",		Hidden:0,  	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"fam_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"명의인주민번호",	Type:"Text",		Hidden:0,  	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:0, Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"관계",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"fam_cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"교육대상구분",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"work_type",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"상세구분",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"restrict_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"금액(담당자용)",	Type:"Int",			Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"자료입력유형",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
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
			{Header:"정산구분",		Type:"Combo",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성명",			Type:"Text",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"순서",			Type:"Text",		Hidden:1, 	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"seq",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"명의인",			Type:"Text",		Hidden:0,  	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"fam_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"명의인주민번호",	Type:"Text",		Hidden:0,  	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:1, Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"교육대상구분",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"work_type",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"금액(담당자용)",	Type:"Int",			Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"자료입력유형",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"담당자확인",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"feedback_type",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(false);sheet2.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
		var restrictCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00340"), "");
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "전체");
		var workTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00313"), "");
		var workTypeList2 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00313"), "전체");
		sheet1.SetColProperty("work_type",		{ComboText:"|"+workTypeList[0], ComboCode:"|"+workTypeList[1]} );
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );

		contributionCdList1 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getCommonCodeNoteEduList&note1=E","C00342"), "");
		contributionCdList2 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getCommonCodeNoteEduList&note1=D","C00342"), "");

		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
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

		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산구분 : " + codeCdNm + "\n";

		templeteTitle1 += "주민번호 : " + " 숫자만 입력해 주십시오 "+ "\n\n";

		codeCdNm = "";
		codeNm = workTypeList[0].split("|"); codeCd = workTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "교육대상구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = adjInputTypeList[0].split("|"); codeCd = adjInputTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "자료입력유형 : " + codeCdNm + "\n";

		//doAction1("Search");
	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/eduHisMgr/eduHisMgrRst.jsp?cmd=selectEduHisMgrList", $("#sheetForm").serialize() );
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
						if(sheet1.GetCellValue(i, "name") != sheet1.GetCellValue(i, "fam_nm")){
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

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;

		case "Down2Template":
			var param  = {DownCols:"work_yy"
				+"|adjust_type"
				+"|name"
				+"|sabun"
				+"|fam_nm"
				+"|famres"
				+"|work_type"
				+"|restrict_cd"
				+"|appl_mon"
				+"|adj_input_type"
				+"|nts_yn",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,10",menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);
			break;
        case "LoadExcel":
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

						var row = i;

						if(sheet1.GetCellValue(i, "work_type") == "30"){
							sheet1.CellComboItem(row,	"restrict_cd",	{ComboText:"|"+contributionCdList1[0], ComboCode:"|"+contributionCdList1[1]} );
							sheet1.SetCellEditable(i, "restrict_cd", 1) ;
						}else if(sheet1.GetCellValue(i, "work_type") == "40"){
							sheet1.SetCellValue(i,"restrict_cd", "");
							sheet1.SetCellEditable(i, "restrict_cd", 0) ;
						}
					} else {
						sheet1.SetCellEditable(i, "restrict_cd", 0) ;
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
					if(sheet1.GetCellValue(Row, "name") != sheet1.GetCellValue(Row, "fam_nm")){
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
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}%>
				</td>
				<td><span>작업구분</span>
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
				<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
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