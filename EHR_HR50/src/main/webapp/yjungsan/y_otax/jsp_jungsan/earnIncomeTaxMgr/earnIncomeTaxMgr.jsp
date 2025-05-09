<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수이행상황신고서</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {

		$("#year").mask("1111");

		$("#year").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
    	initdata.Cols = [
    				{Header:"No",				Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
    				{Header:"삭제",				Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
    				{Header:"상태",				Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
    				{Header:"원천\n신고서",		    Type:"Image",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"detail1",			Cursor:"Pointer",				EditLen:1 },
    				{Header:"지방\n소득세",			Type:"Image",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"detail2",			Cursor:"Pointer",				EditLen:1 },
    				{Header:"사업소세",		    Type:"Image",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"detail3",			Cursor:"Pointer",				EditLen:1 },
    				{Header:"문서번호",			Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:1,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
    				{Header:"신고일자",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"report_ymd",		KeyField:1,		Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
    				{Header:"사업장",			    Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:1,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
    				{Header:"신고구분",			Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"rpt_cd",			KeyField:1,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
    				{Header:"귀속\n시작월",			Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:1,		Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
    				{Header:"귀속\n종료월",			Type:"Date",		Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"belong_eym",		KeyField:0,		Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
    				{Header:"지급\n시작월",			Type:"Date",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payment_ym",		KeyField:1,		Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
    				{Header:"지급\n종료월",			Type:"Date",		Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payment_eym",		KeyField:0,		Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
    				{Header:"원천신고구분",		    Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"origin_rpt_type",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
    				{Header:"연말정산\n포함여부",	    Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"yea_yn",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
    				{Header:"환급신청\n여부",		Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"refund_req_yn",		KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
    				{Header:"일괄납부\n여부",		Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Left",	ColMerge:0,	SaveName:"sum_payment_yn",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
    				{Header:"신고서부표\n여부",	    Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"tag_yb",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
    				{Header:"사업자단위\n과세여부",	Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"danwui_yn",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
    				{Header:"이월세액\n승계여부",	    Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"iwol_yn",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
    				{Header:"기납부세액\n제출여부",	Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"ginabbu_yn",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
    				{Header:"마감여부",			Type:"CheckBox",	Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"close_yn",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
       	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

		// 사업장(TCPN121)
		var bizPlaceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "");
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCd[0], ComboCode:"|"+bizPlaceCd[1]});

		// 원천세신고구분(C00500)
		var rptCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=<%=curSysYear%>"+"-"+"<%=curSysMon%>","C00500"), "");
		sheet1.SetColProperty("rpt_cd", {ComboText:"|"+rptCd[0], ComboCode:"|"+rptCd[1]});

		// 원천신고구분
		// 23.01.05 신고구분 반기(코드값 2) 제거, 현재 패키지에서 원천세 반기 신고는 되지 않아 혼선 방지를 위해 매월만 남겨놓음
		sheet1.SetColProperty("origin_rpt_type", {ComboText:"|매월", ComboCode:"|1"});


		sheet1.SetDataLinkMouse("detail1", 1);
		sheet1.SetDataLinkMouse("detail2", 1);
		sheet1.SetDataLinkMouse("detail3", 1);
		sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_popup.png");

		$(window).smartresize(sheetResize);
		sheetInit();

		$("#year").bind("keyup",function(event) {
			makeNumber(this, 'A');
		});
		$("#year").val("<%=curSysYear%>");

		doAction1("Search");
	});



	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchSbNm").val($("#searchKeyword").val());
			sheet1.DoSearch( "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=selectEarnIncomeTaxMgrList", $("#sheetForm").serialize() );
			break;
        case "Insert":
        	var Row = sheet1.DataInsert(0) ;
        	sheet1.SelectCell(Row, 2);
        	// 23.01.05 원천징수이행상황신고서 입력시 신고구분값은 매월로 고정, 해당 컬럼은 수정 못하게 속성에서 UpdateEdit:0,	InsertEdit:0 으로 변경
        	sheet1.SetCellValue(Row, "origin_rpt_type", "1");
        	break;
        case "Copy":
        	var Row = sheet1.DataCopy();
        	sheet1.SelectCell(Row, 2);
        	break;
		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "tax_doc_no|business_place_cd", false, true)) {break;}
			sheet1.DoSave( "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=saveEarnIncomeTaxMgr", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
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
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			var colName = sheet1.ColSaveName(Col);
			if (Row > 0) {
				if (colName == "detail1" || colName == "detail2" || colName == "detail3") {
					if (sheet1.GetCellValue(Row, "sStatus") == "I") {
						alert("입력후 세부\n내역을 등록해 주시기 바랍니다.");
						return;
					}

					// 원천신고서/지방세/사업소득세 호출
					openEarnIncomeTaxMgrDtlPopup(colName, Row);
				}
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 원천신고서/지방세/사업소득세 호출
	function openEarnIncomeTaxMgrDtlPopup(colName, Row) {
		var w	= 1024;
		var h	= 760;
		var url	= "";
		var args= new Array();

		if (colName == "detail1") {
			// 원천신고서
			w	= 1024;
			h	= 760;

			url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl1Popup.jsp";
			args["tax_doc_no"] = sheet1.GetCellValue(Row, "tax_doc_no");
			args["business_place_cd"] = sheet1.GetCellValue(Row, "business_place_cd");
			// 2015-08-31 YHCHOI ADD
			args["report_ymd"] = sheet1.GetCellValue(Row, "report_ymd");
			args["belong_ym"] = sheet1.GetCellValue(Row, "belong_ym");
			// 2016-09-19 YHCHOI ADD
			args["close_yn"] = sheet1.GetCellValue(Row, "close_yn");
		} else if (colName == "detail2") {
			// 지방세
			w	= 1000;
			h	= 780;
			
			url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl2Popup.jsp";
			args["tax_doc_no"] = sheet1.GetCellValue(Row, "tax_doc_no");
			args["business_place_cd"] = sheet1.GetCellValue(Row, "business_place_cd");
			// 2015-08-31 YHCHOI ADD
			args["report_ymd"] = sheet1.GetCellValue(Row, "report_ymd");
			args["belong_ym"] = sheet1.GetCellValue(Row, "belong_ym");
			// 2016-09-19 YHCHOI ADD
			args["close_yn"] = sheet1.GetCellValue(Row, "close_yn");
			args["payment_ym"] = sheet1.GetCellValue(Row, "payment_ym");
		} else {
			// 사업소득세 
			w	= 900;
			h	= 500;
			
			/* 20250318 
				신고자료의 귀속년월이 개정양식이 배포된 20250401 이후라면 
				earnIncomeTaxMgrDtl3Popup_2025.jsp 양식으로 이동
				url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl3Popup.jsp"; */
			if ( "202503" < sheet1.GetCellValue(Row, "belong_ym").replace(/\-/g,'') ) {				
				url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl3Popup_2025.jsp";
			} else {
				url = "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrDtl3Popup.jsp";
			}
			
			args["tax_doc_no"] = sheet1.GetCellValue(Row, "tax_doc_no");
			args["business_place_cd"] = sheet1.GetCellValue(Row, "business_place_cd");
			// 2015-08-31 YHCHOI ADD
			args["report_ymd"] = sheet1.GetCellValue(Row, "report_ymd");
			args["belong_ym"] = sheet1.GetCellValue(Row, "belong_ym");
			// 2016-09-19 YHCHOI ADD
			args["close_yn"] = sheet1.GetCellValue(Row, "close_yn");
		}

		openPopup(url+"?authPg=<%=authPg%>", args, w, h);
	}
	
	var pGubun = "";

	//옵션설정
	function optPop(){
		var args 	= new Array();
		args["searchWorkYy"]		= $("#year").val() ;
		//args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
		//args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
		//args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
		
		if(!isPopup()) {return;}
		var rv = openPopup("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxOptionPopup.jsp?authPg=<%=authPg%>",args,"800","450");
	}

</script>
</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
        <div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>신고년도</span> <input type="text" id="year" name="year" class="text center" value="" maxlength="4" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">원천징수이행상황신고서</li>
            <li class="btn">
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
				<a href="javascript:optPop();"					class="pink authA">원천세옵션</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>