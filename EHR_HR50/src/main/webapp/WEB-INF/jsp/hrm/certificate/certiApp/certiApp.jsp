<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>제증명신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var userInfo = {};

	$(function() {
		
		$("#searchApplCd, #searchApplStatusCd").bind("change", function(){
			doAction1("Search");
		});
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();
	});
	

	//Sheet 초기화
	function init_sheet(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제",				Type:"Html",		Hidden:0,	Width:55,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },
			
			{Header:"세부\n내역",			Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청일",				Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"신청상태",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"신청서종류",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"관리번호",			Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"regNo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"용도",				Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"purpose",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"제출처",				Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"submitOffice",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"출력(다운)\n가능횟수",Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"prtCnt",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"출력\n여부",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"prtYn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"최대\n출력부수",		Type:"Int",			Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"selfPrtLimitCnt",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"출력(다운)",			Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnPrt",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"출력프로그램",		Type:"Text",		Hidden:1,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"prtRsc",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"시작일자",			Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"종료일자",			Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"년도",				Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"reqYy",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"주소",				Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"address",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"기타",				Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"etc",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2000 },
			{Header:"담당결재여부",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"damdangYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"도장출력여부",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"signPrtYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"신청서제목",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applTitle",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"rk"}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//sheet1.SetImageList(0,"/common/images/icon/icon_info.png");
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);

		var applCd  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getAddlCodeList","comboViewYn=Y&useYn=Y",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		var applCdAll  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getAddlCodeList","",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		var applStatusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "<tit:txt mid='103895' mdef='전체'/>");

		sheet1.SetColProperty("applCd",			{ComboText:applCdAll[0], ComboCode:applCdAll[1]} );
		sheet1.SetColProperty("applStatusCd",	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );

		$("#searchApplCd").html(applCd[2]);
		$("#searchApplStatusCd").html(applStatusCd[2]);

		$(window).smartresize(sheetResize); sheetInit();


	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/CertiApp.do?cmd=getCertiAppList", $("#sheetForm").serialize(),{Sync:1} );
			break;
		case "Save":
			pGubun = "save"; //임시저장의 경우 삭제처리.  
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/CertiApp.do?cmd=saveCertiApp", $("#sheetForm").serialize(), -1, 0);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "" && pGubun != "viewRdPopup2") {
				alert(Msg);
			}
			if( Code > -1) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
			if( sheet1.ColSaveName(Col) == "detail" ) {
			    showApplPopup( Row );

		    }else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
				
		    }else if( sheet1.ColSaveName(Col) == "btnPrt" && Value != ""){
		    	/* 2019년까지의 원천징수영수증의 경우 pdf 다운로드 처리함 */
		    	if( sheet1.GetCellValue(Row, "applCd") == "16" && parseInt(sheet1.GetCellValue(Row, "reqYy")) < 2020 ) {
		    		pdfDownload(Row);
		    	} else {
		    		//rdPopup(Row);
		    		showRd(Row);
		    	}
		    	
		    }
			
			
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}


	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row ) {

		if(!isPopup()) {return;}
				
		var args = new Array(5);
		var auth    = "A"
		  , applCd  = $("#searchApplCd").val()
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		  
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applCd      = sheet1.GetCellValue(Row,"applCd");
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}else{
			if( applCd == "" ) {
				alert("신청서종류를 선택 해주세요.");$("#searchApplCd").focus();
				return;
			}
			if(userInfo.statusCd != "RA" && ( applCd == 13 || applCd == 14 ) ) {
				alert("재직자는 경력증명서를 신청할 수 없습니다.");
				return;
			}
			if(userInfo.statusCd == "RA" && ( applCd == 11 || applCd == 12 ) ) {
				alert("퇴직자는 재직증명서를 신청할 수 없습니다.");
				return;
			}
		}

		var p = {
				searchApplCd: applCd
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};
		/*
		url += "&searchApplCd="+applCd
			+ "&searchApplSeq="+applSeq
			+ "&adminYn=N"
			+ "&authPg="+auth
			+ "&searchSabun="+applInSabun // 신청 내용을 입력 하는 사람
			+ "&searchApplSabun="+$("#searchUserId").val()// 대상자 사번
			+ "&searchApplYmd="+applYmd; */
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
	
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(row){

		if(!isPopup()) {return;}
		gPRow = row;
		pGubun = "viewRdPopup2";

  		var w 		= 800;
		var h 		= 800;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		var param = "applSeq="+sheet1.GetCellValue(row,"applSeq")
		           +"&applCd="+sheet1.GetCellValue(row,"applCd")
				   +"&sabun="+sheet1.GetCellValue(row,"sabun");

		var data = ajaxCall("${ctx}/CertiApp.do?cmd=getCertiAppDetList", param,false).DATA;
		if(!data||data.length==0){
			alert("조회에 실패하였습니다.");return;
		}

		var prtCnt = parseInt(data[0].prtCnt);
		var data = ajaxCall("${ctx}/CertiApp.do?cmd=prcP_BEN_REGNO_UPD","applSeq="+sheet1.GetCellValue(row,"applSeq"),false);
		if(data.Result.Code != "OK"){
			alert(data.Result.Message);
			return;
		}

		var rdMrd = sheet1.GetCellValue(row, "prtRsc"); // RD 출력프로그램
		var rdTitle = "";
		var rdParam = "";
		var rdZoomRatio = 100;
		var applCd = sheet1.GetCellValue(row,"applCd");
		var applSeq = sheet1.GetCellValue(row,"applSeq");
		var sabun = sheet1.GetCellValue(row,"sabun");
		var reqYy = sheet1.GetCellValue(row,"reqYy");
		var sYmd = sheet1.GetCellValue(row,"sYmd");
		var eYmd = sheet1.GetCellValue(row,"eYmd");
		var purpose = sheet1.GetCellValue(sheet1.LastRow(),"purpose");
		var submitOffice = sheet1.GetCellValue(sheet1.LastRow(),"submitOffice");
		
		var imgPath = "${baseURL}/OrgPhotoOut.do?enterCd=${ssnEnterCd}&logoCd=5&orgCd=0";
		var stamp = sheet1.GetCellValue( i, "signPrtYn" );

		if(applCd == "11") {
			rdTitle = "재직증명(한글)";
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";
		} else if(applCd == "12") {
			rdTitle = "재직증명(영문)";
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";
		} else if(applCd == "13") {
			rdTitle = "경력증명(한글)";
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "[N]"
					+ "[${baseURL}]";
		} else if(applCd == "14") {
			rdTitle = "경력증명(영문)";
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";
		}else if(applCd == "16") {
			/* OPTI_YEAR44의 getMigExistAppDetCnt 쿼리가 5.0 패키지에서 누락된 듯....
			var param2 = "&searchSabuns="+sabun;
				param2 += "&searchWorkYy="+reqYy;
				param2 += "&searchAdjustType=1";

			if(reqYy >= 2022){
				var data2  = ajaxCall("${ctx}/GetDataMap.do?cmd=getMigExistAppDetCnt", param2, false).DATA;
				if((data2||data2.length!=0 )&&data2.cnt > 0){
					rdMrd = "cpn/yearEnd/WorkIncomeWithholdReceipt"+reqYy+"_M.mrd";
				}else{
					if(reqYy >= 2007) {
						rdMrd = "cpn/yearEnd/WorkIncomeWithholdReceipt_"+reqYy+".mrd";
					} else {
						rdMrd = "cpn/yearEnd/WorkIncomeWithholdReceipt.mrd";
					}
				}
			}else{ */
				if(reqYy >= 2007) {
					rdMrd = "cpn/yearEnd/WorkIncomeWithholdReceipt_"+reqYy+".mrd";
				} else {
					rdMrd = "cpn/yearEnd/WorkIncomeWithholdReceipt.mrd";
				}
			/* }
			*/
			//imgPath = "${baseURL}" + "/hrfile/" + "${ssnEnterCd}" + "/company/";
			rdTitle = "원천징수영수증";
			rdParam = "[${ssnEnterCd}]"
					+ "["+reqYy+"]"
					+ "[1]"
					+ "['"+sabun+"']"
					+ "['']"
					+ "[ALL]"
					+ "[C]"
					+ "["+imgPath+"]"
					+ "[4]"
					+ "["+sabun+"]"
					+ "[1]"
					+ "[2]"
					+ "[${curSysYyyyMMdd}]"
					+ "[]"
					+ "["+stamp+"]" // stamp
					+ "[N]" // 사대보험 출력여부
					+ "[1]"; //일괄다운로드 adjust_type리스트
		} else if(applCd == "19") {
			if(reqYy >= 2008) {
				rdMrd = "cpn/yearEnd/EmpWorkIncomeWithholdReceiptBook_"+reqYy+".mrd";
			} else {
				rdMrd = "cpn/yearEnd/EmpWorkIncomeWithholdReceiptBook.mrd";
			}
			rdTitle = "원천징수부";
			rdParam = "[${ssnEnterCd}]"
					+ "["+reqYy+"]"
					+ "[1]"
					+ "['"+sabun+"']"
					+ "['']"
					+ "[ALL]"
					+ "[${curSysYyyyMMdd}]"
					+ "[4]"
					+ "["+sabun+"]"
					+ "[1]"
					+ "[]";
		} else if(applCd == "18") {
			rdTitle = "갑근세납입증명서";
			rdParam = "[${ssnEnterCd}]"
					+ "["+sYmd+"]["+eYmd+"]"
					+ "['"+sabun+"']"
					+ "[10]"
					+ "["+purpose+"]"
					+ "["+submitOffice+"]"
					+ "[]"
					+ "[${baseURL}]";
		} else if(applCd == "98") {
			rdTitle = "대출신청서";
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";
		} else if(applCd == "15") {
			rdTitle = "징계내역서";
			rdParam = "[${ssnEnterCd}]"
					+ "["+sabun+"]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";
		}else {
			rdTitle = sheet1.GetCellValue(lRow,"applTitle");
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";
		}

		args["rdTitle"] = rdTitle ;//rd Popup제목
		args["rdMrd"] = rdMrd ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = rdZoomRatio ;//확대축소비율

		args["rdSaveYn"] 	= "N" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "N" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "N" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "N" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "N" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "N" ;//기능컨트롤_PDF

		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}

	
	//신청 팝업에서  리턴
	function getReturnValue(returnValue) {
    	doAction1("Search");
	}
	
	// 헤더에서 호출
	function setEmpPage() {

    	$("#searchSabun").val($("#searchUserId").val());
		doAction1("Search");

		userInfo = ajaxCall("${ctx}/CertiApp.do?cmd=getEmployeeInfoMap", "searchSabun="+ $("#searchUserId").val(), false).DATA; //기준일
	}

	
	/**
	 * PDF 다운로드
	 */
	function pdfDownload(row){
		var param = "applSeq="+sheet1.GetCellValue(row,"applSeq")
		          + "&applCd="+sheet1.GetCellValue(row,"applCd")
		          + "&sabun="+sheet1.GetCellValue(row,"sabun");

		var data = ajaxCall("${ctx}/CertiApp.do?cmd=getCertiAppDetList", param,false).DATA;
		if(!data||data.length==0){
			alert("조회에 실패하였습니다.");return;
		}

		var prtCnt = parseInt(data[0].prtCnt);
		var data = ajaxCall("${ctx}/CertiApp.do?cmd=prcP_BEN_REGNO_UPD","applSeq="+sheet1.GetCellValue(row,"applSeq"),false);
		if(data.Result.Code != "OK"){
			alert(data.Result.Message);
			return;
		}
		
		var url = "${ctx}/FileDownload.do?cmd=getCertiAppPdfDownload&applSeq=" + sheet1.GetCellValue(row,"applSeq");
		$("#pdfDownloadIfrm").attr("src", url);
		doAction1("Search");
	}

function showRd(Row){

	gPRow = Row;
	pGubun = "rdPopup";

	var param = "applSeq="+sheet1.GetCellValue(Row,"applSeq")
			+"&applCd="+sheet1.GetCellValue(Row,"applCd")
			+"&sabun="+sheet1.GetCellValue(Row,"sabun");

	var chk = ajaxCall("${ctx}/CertiApp.do?cmd=getCertiAppDetList", param,false).DATA;
	if(!chk||chk.length==0){
		alert("조회에 실패하였습니다.");return;
	}

	var prtCnt = parseInt(chk[0].prtCnt);
	var chk = ajaxCall("${ctx}/CertiApp.do?cmd=prcP_BEN_REGNO_UPD","applSeq="+sheet1.GetCellValue(Row,"applSeq"),false);
	if(chk.Result.Code != "OK"){
		alert(chk.Result.Message);
		return;
	}

	const data = {
		rk : sheet1.GetCellValue(Row, "rk"),
		mrdPath : sheet1.GetCellValue(Row, "prtRsc"),	//RD경로
		rp : {
			applSeq : sheet1.GetCellValue(Row, "applSeq"),
			applCd : sheet1.GetCellValue(Row, "applCd"),
			sabun : sheet1.GetCellValue(Row, "sabun"),
			reqYy : sheet1.GetCellValue(Row, "reqYy"),
			sYmd : sheet1.GetCellValue(Row, "sYmd"),
			eYmd : sheet1.GetCellValue(Row, "eYmd"),
			purpose : sheet1.GetCellValue(Row, "purpose"),
			submitOffice : sheet1.GetCellValue(Row, "submitOffice"),
			imgPath : "/OrgPhotoOut.do?enterCd=${ssnEnterCd}&logoCd=5&orgCd=0",
			stamp : sheet1.GetCellValue(Row, "signPrtYn"),
			date : "${curSysYyyyMMdd}"
		}
	};
	window.top.showRdLayer('/CertiApp.do?cmd=getEncryptRd', data,'',sheet1.GetCellValue(Row, "applTitle"));

	doAction1("Search");
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">제증명신청</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel')" css="btn outline-gray" mid='down2excel' mdef="다운로드"/>
						<btn:a href="javascript:showApplPopup(-1);" css="btn filled" mid='applButton' mdef="신청"/>
						<btn:a href="javascript:doAction1('Search')" css="btn dark" mid='search' mdef="조회"/>
						<!-- btn:a href="javascript:doAction1('Save')" css="basic" mid='save' mdef="저장"/> -->
					</li>
				</ul>
				</div>
			</div>

			<form id="sheetForm" name="sheetForm">
			<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
			<table border="0" cellspacing="0" cellpadding="0" class="default inner">
			<colgroup>
				<col width="10%" />
				<col width="15%" />
				<col width="10%" />
				<col width="" />
			</colgroup>
			<tr>
				<th>신청서종류</th>
				<td>
					<select id="searchApplCd" name="searchApplCd"/>
				</td>
				<th>결재상태</th>
				<td>
					<select id="searchApplStatusCd" name="searchApplStatusCd"/>
				</td>
			</tr>
			</table>
			</form>
			<div class="h10 outer"></div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
<iframe id="pdfDownloadIfrm" src="about:blank" style="display:none;"></iframe>
</body>
</html>
