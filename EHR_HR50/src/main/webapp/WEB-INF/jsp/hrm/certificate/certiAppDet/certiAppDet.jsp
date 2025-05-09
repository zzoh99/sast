<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>제증명신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var searchApplCd = "${searchApplCd}";
	var searchApplSabun = "${searchApplSabun}";
	var searchSabun = "${searchSabun}";
	var searchApplYmd = "${searchApplYmd}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var gPRow = "";
	var pGubun = "";
	var certiPurpose = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"신청일자",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"시작일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",			KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"종료일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",			KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"입사일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"현재일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"currYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"입사일차이년",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"year",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"입사일차이월",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"month",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"주소",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"address",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"근무처코드",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"locationCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"근무처주소",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"사원구분",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"신청순번",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"신청코드",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"출력물",			Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"prtRsc",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"출력가능횟수",		Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"prtCnt",			KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"신청자사번",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"reqSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"신청년도",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"reqYy",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"용도",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"purpose",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"제출처",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"submitOffice",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"기타항목",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"etc",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"주민번호인쇄여부",	Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"resNoYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"신청상태",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조직표시여부",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"orgYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"인쇄여부",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"prtYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"인쇄부수",			Type:"Int",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"prtCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"최대인쇄부수"	,		Type:"Int",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"selfPrtLimitCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"신청서제목"	,		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applTitle",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },

			{Header:"Hidden",			Type:"Text",   Hidden:1, SaveName:"rk"}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//제증명 용도 코드 세팅
		var queryId = "getComCodeNoteList";
		if(searchApplCd == "12" || searchApplCd == "14") {
			queryId = "getCertiAppDetEngCode";
		}
		certiPurpose = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId="+queryId+"&searchGrcodeCd=C80001&searchNote1=" + $(this).val(),false).codeList, "<tit:txt mid='111914' mdef='선택'/>");

		$(window).smartresize(sheetResize); sheetInit();
		parent.iframeOnLoad("250px");

		doAction1("Search");
	});

	$(function() {
		var locCds = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");
		$("#locationCd").html(locCds[2]);

		//용도 SELECT 박스로 변경
		$("#purposeCD").html(certiPurpose[2]);

		//'갑근세납입증명서'인 경우, 제출처 show, 그 외 hide
		/*
		if(searchApplCd != '18') {
			$("#thSubmitOffice").addClass("hide");
			$("#submitOffice").attr("readonly", true).addClass("transparent");
		}
		*/

		if(authPg == "A") {


			$("#sYmd").datepicker2({
				ymonly:true,
				onReturn:function(date){
					var num = getDaysBetween(formatDate(date+"-01",""),formatDate($("#eYmd").val()+"-01",""));
					if(date != "" && $("#eYmd").val() != "") {
						if(num <= 0) {
							alert("종료월이 시작월보다 작습니다.");
							$("#eYmd").val("");
						}
					}
				}
			});

			$("#eYmd").datepicker2({
				ymonly:true,
				onReturn:function(date){
					var num = getDaysBetween(formatDate($("#sYmd").val()+"-01",""),formatDate(date+"-01",""));
					if($("#sYmd").val() != "" && date != "") {
						if(num <= 0) {
							alert("종료월이 시작월보다 작습니다.");
							$("#eYmd").val("");
						}
					}
				}
			});

			$("#sYmd,#eYmd").blur(function(){
				var num = getDaysBetween(formatDate($("#sYmd").val()+"-01",""),formatDate($("#eYmd").val()+"-01",""));
				if(formatDate($("#sYmd").val(),"") != "" && formatDate($("#eYmd").val(),"") != "") {
					if(num <= 0) {
						alert("종료월이 시작월보다 작습니다.");
						$("#eYmd").val("");
					}
				}
			});

			// 근무처가 바뀔때 근무처 코드도 자동갱신
			$("#locationCd").bind("change", function(event) {
				var data = ajaxCall("${ctx}/CertiApp.do?cmd=getLocAddrByCd&locationCd=" + $("#locationCd").val(), "", false).DATA;
				$("#locationNm").val(data.addr);
			});

			$("#locationCd").change();
		}

		$("#reqYy").bind("keyup",function(event){
			makeNumber(this,"A");
		});

		/* 20171030. 제직,경력 출력시 근무처는 사실상 필요없음. MJ */
		if(searchApplCd == '11' || searchApplCd == '12' || searchApplCd == '13' || searchApplCd == '14'){
			$("#hdnLocation").hide();
		}

		$("#etc").maxbyte(4000);
		$("#purpose").maxbyte(100);
		$("#submitOffice").maxbyte(100);
		$("#address").maxbyte(200);
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "applSeq="+searchApplSeq
						+"&applCd="+searchApplCd
						+"&sabun="+searchApplSabun;

			sheet1.DoSearch( "${ctx}/CertiApp.do?cmd=getCertiAppDetList", param);
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

			$("#applYmd").val(formatDate(searchApplYmd,"-"));

			if(sheet1.SearchRows() > 0) {

				$("#empYmd").val(sheet1.GetCellText(sheet1.LastRow(),"empYmd"));
				$("#currYmd").val(sheet1.GetCellText(sheet1.LastRow(),"currYmd"));
				$("#year").text(sheet1.GetCellValue(sheet1.LastRow(),"year"));
				$("#month").text(sheet1.GetCellValue(sheet1.LastRow(),"month"));

				if(searchApplCd == '11' || searchApplCd == '12') {

					$("#hdnReqYy").hide();
					$("#hdnSYmd").hide();
					//$("#hdnAddress").hide();
					$("#hdnResNoChk").hide();
					$("#address").val(sheet1.GetCellValue(sheet1.LastRow(),"address"));
					$("#locationCd").val(sheet1.GetCellValue(sheet1.LastRow(),"locationCd"));
					$("#locationNm").val(sheet1.GetCellValue(sheet1.LastRow(),"locationNm"));

					$("#hdnTerms").hide();
					$("#hdnLocation").hide();

				} else if(searchApplCd == '13' || searchApplCd == '14') {

					//$("#hdnEmpYmd").hide();
					$("#hdnReqYy").hide();
					$("#hdnSYmd").hide();
					//$("#hdnAddress").hide();
					$("#hdnResNoChk").hide();
					$("#hdnOrgChk").show();
					$("#address").val(sheet1.GetCellValue(sheet1.LastRow(),"address"));
					$("#locationCd").val(sheet1.GetCellValue(sheet1.LastRow(),"locationCd"));
					$("#locationNm").val(sheet1.GetCellValue(sheet1.LastRow(),"locationNm"));
					if(searchApplCd == '14')
						$("#hdnTerms").hide();

					$("#hdnLocation").hide();

				} else if(searchApplCd == '15') {

					$("#hdnEmpYmd").hide();
					$("#hdnReqYy").hide();
					$("#hdnSYmd").hide();
					$("#address").val(sheet1.GetCellValue(sheet1.LastRow(),"address"));
					$("#locationCd").val(sheet1.GetCellValue(sheet1.LastRow(),"locationCd"));
					$("#locationNm").val(sheet1.GetCellValue(sheet1.LastRow(),"locationNm"));
					if(searchApplCd == '14')
						$("#hdnTerms").hide();

					$("#hdnLocation").hide();

				} else if(searchApplCd == '16' || searchApplCd == '19') {

					$("#hdnEmpYmd").hide();
					$("#hdnSYmd").hide();
					$("#hdnAddress").hide();
					$("#hdnLocation").hide();
					$("#hdnResNoChk").hide();
					$("#reqYy").val(sheet1.GetCellValue(sheet1.LastRow(),"reqYy"));
					$("#hdnTerms").hide();

				} else if(searchApplCd == '18') {

					$("#hdnEmpYmd").hide();
					$("#hdnReqYy").hide();
					$("#hdnResNoChk").hide();
					$("#sYmd").val(sheet1.GetCellText(sheet1.LastRow(),"sYmd"));
					$("#eYmd").val(sheet1.GetCellText(sheet1.LastRow(),"eYmd"));
					$("#address").val(sheet1.GetCellValue(sheet1.LastRow(),"address"));
					$("#locationCd").val(sheet1.GetCellValue(sheet1.LastRow(),"locationCd"));
					$("#locationNm").val(sheet1.GetCellValue(sheet1.LastRow(),"locationNm"));
					$("#hdnTerms").hide();

				} else if(searchApplCd == '40' || searchApplCd == '41') {

					$("#hdnEmpYmd").hide();
					$("#hdnSYmd").hide();
					$("#hdnReqYy").hide();
					$("#hdnResNoChk").hide();
					$("#hdnAddress").hide();
					$("#hdnLocation").hide();
					$("#hdnTerms").hide();

				} else {
					$("#hdnEmpYmd").hide();
					$("#hdnReqYy").hide();
					$("#hdnSYmd").hide();
					$("#hdnAddress").hide();
					$("#hdnLocation").hide();
					$("#hdnTerms").hide();
				}

				if (sheet1.GetCellValue(sheet1.LastRow(), "purpose") !== "")
					$("select[name='purposeCD'] option:contains('"+ sheet1.GetCellValue(sheet1.LastRow(),"purpose") +"')").attr("selected", "selected");
				$("#purpose").val(sheet1.GetCellValue(sheet1.LastRow(),"purpose"));
				$("#submitOffice").val(sheet1.GetCellValue(sheet1.LastRow(),"submitOffice"));
				$("#etc").val(sheet1.GetCellValue(sheet1.LastRow(),"etc"));

				if(sheet1.GetCellValue(sheet1.LastRow(),"resNoYn") == "Y") {
					$("#resNoYn").attr("checked",true);
				} else {
					$("#resNoYn").attr("checked",false);
				}

				if(sheet1.GetCellValue(sheet1.LastRow(),"orgYn") == "Y") {
					$("#orgYn").attr("checked",true);
				} else {
					$("#orgYn").attr("checked",false);
				}

				if(authPg == "R" && sheet1.GetCellValue(sheet1.LastRow(),"applStatusCd") == 99 && sheet1.GetCellValue(sheet1.LastRow(),"prtYn") == 'N') {
					var vPurpose = sheet1.GetCellValue(sheet1.LastRow(),"purpose");
					
					$("select[name='purposeCD'] option:contains('"+ vPurpose +"')").attr("selected", "selected");
					
					$("#btnPrint").show();
					
					// 2019년 귀속이하의 원천징수영수증인 경우 PDF 파일 다운로드
					if( searchApplCd == '16' && parseInt($("#reqYy").val()) < 2020 ) {
						$("#btnPdfDownload").show();
					} else {
						$("#btnRd").show();
					}
				}
			}
			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장후 리턴함수
	function setValue(){
		var saveStr;
		var rtn;

		try{
			if(authPg == "A") {

				if(searchApplCd == '11' || searchApplCd == '12' || searchApplCd == '13' || searchApplCd == '14') {

					if($("#address").val() == "") {
						alert("주소를 입력하여 주십시오.");
						return false;
					}

					if($("#submitOffice").val() == "") {
						alert("제출처를 입력하여 주십시오.");
						return false;
					}
					
				}else if(searchApplCd == '17'){
					if($("#submitOffice").val() == "") {
						alert("제출처를 입력하여 주십시오.");
						return false;
					}

				} else if(searchApplCd == '16' || searchApplCd == '19') {
					if($("#reqYy").val() == "") {

						alert("신청년도를 입력하여 주십시오.");
						return false;
					}
					
					if($("#submitOffice").val() == "") {
						alert("제출처를 입력하여 주십시오.");
						return false;
					}

				} else if(searchApplCd == '18') {
					
					var term = getMonthTerm($("#sYmd").val(), $("#eYmd").val());
					if(term > 12){
						alert("신청기간(납부개월수)은 12개월을 초과할 수 없습니다.");
						return false;
					}

					if($("#sYmd").val() == "" || $("#eYmd").val() == "") {
						alert("신청기간을 입력하여 주십시오.");
						return false;
					}

					if($("#address").val() == "") {
						alert("주소를 입력하여 주십시오.");
						return false;
					}

					if($("#locationNm").val() == "") {
						alert("근무지 주소를 입력하여 주십시오.");
						return false;
					}
					
					if($("#submitOffice").val() == "") {
						alert("제출처를 입력하여 주십시오.");
						return false;
					}
				}

				if($("#purpose").val() == "") {
					alert("용도를 입력하여 주십시오.");
					return false;
				}

				if(searchApplCd == '16' || searchApplCd == '19') {	// [16] 원천징수영수증, [19] 원천징수부
					var cmd   = "getCertiAppDetCheck";
					// 2019년 귀속이하의 원천징수영수증인 경우 PDF 파일 다운로드 프로세스임에 따라 PDF 파일 존재 유무 체크 설정
					if( searchApplCd == '16' && parseInt($("#reqYy").val()) < 2020 ) {
						cmd = "getCertiAppDetCheckPdfExist";
					}
					var param = "payCd=Y1&payYm=" + $("#reqYy").val() + "&searchApplSabun=" + searchApplSabun;
					var data = ajaxCall("${ctx}/CertiApp.do?cmd="+cmd,param,false);

					if(data != null && data.DATA != null) {
						if(data.DATA.searchYn == "N") {
							alert("해당 신청년도의 연말정산이 미완료 상태입니다.\r\n다시 신청하여 주십시오.");
							return false;
						}
					} else {
						alert(data.Message);
						return false;
					}
				} else if(searchApplCd == '18') {	// 갑근세증명원
					var manageCd = sheet1.GetCellValue(sheet1.LastRow(),"manageCd");
					var payCd = "001";
					var param = "payCd="+payCd+"&payYm="+($("#eYmd").val().replace(/-/gi,""))+"&paysYm="+($("#sYmd").val().replace(/-/gi,""))+"&searchApplSabun=" + searchApplSabun;
					var data = ajaxCall("${ctx}/CertiApp.do?cmd=getCertiAppDetCheck",param,false);

					if(data != null && data.DATA != null) {
						if(data.DATA.searchYn == "N") {
							alert("해당 신청기간의 급여작업이 미완료 상태입니다.\r\n다시 신청하여 주십시오.");
							return false;
						}
					} else {
						alert(data.Message);
						return false;
					}
				}

				var row = sheet1.LastRow();

				sheet1.SetCellValue(row,"sYmd",$("#sYmd").val().replace(/-/gi,""));
				sheet1.SetCellValue(row,"eYmd",$("#eYmd").val().replace(/-/gi,""));
				sheet1.SetCellValue(row,"address",$("#address").val());
				sheet1.SetCellValue(row,"locationCd",$("#locationCd").val());
				sheet1.SetCellValue(row,"locationNm",$("#locationNm").val());
				sheet1.SetCellValue(row,"reqYy",$("#reqYy").val());
				sheet1.SetCellValue(row,"purpose",$("#purpose").val());
				sheet1.SetCellValue(row,"etc",$("#etc").val());
				sheet1.SetCellValue(row,"submitOffice",$("#submitOffice").val());
				sheet1.SetCellValue(row,"resNoYn",($("#resNoYn").is(":checked")==true)?"Y":"N");
				sheet1.SetCellValue(row,"orgYn",($("#orgYn").is(":checked")==true)?"Y":"N");
				sheet1.SetCellValue(row,"applCd",searchApplCd);
				sheet1.SetCellValue(row,"applYmd",searchApplYmd);
				sheet1.SetCellValue(row,"applSeq",searchApplSeq);
				sheet1.SetCellValue(row,"sabun",searchApplSabun);
				sheet1.SetCellValue(row,"reqSabun",searchSabun);

				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					if(sheet1.GetCellValue(i,"sStatus") == "R") {
						sheet1.SetCellValue(i,"sStatus","U");
					}
				}

				saveStr = sheet1.GetSaveString(0);

				if(saveStr.match("KeyFieldError")) {
					return false;
				}
/*
				if(saveStr == "KeyFieldError") {
					return false;
				}
*/
				rtn = eval("("+sheet1.GetSaveData("${ctx}/CertiApp.do?cmd=saveCertiAppDet", saveStr)+")");

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					return false;
				}

				sheet1.LoadSaveData(rtn);

			}

		} catch (ex){
			alert("Script Errors Occurred While Saving." + ex);
			return false;
		}

		return true;
	}
	
	// 시작년월과 종료년월의 차이를 구하는 메소드
	function getMonthTerm(sYmd, eYmd) {
		try {
			if(sYmd == null || sYmd == "") return null;
			if(eYmd == null || eYmd == "") return null;
			
			sYmd = sYmd.replace(/\-/g, "").replace(/\./g, "");
			eYmd = eYmd.replace(/\-/g, "").replace(/\./g, "");
			
			if(sYmd.length != 6 || eYmd.length != 6) return null;
			
			var sY = parseInt(sYmd.substring(1, 4));
			var sM = parseInt(sYmd.substring(5, 6));
			var eY = parseInt(eYmd.substring(1, 4));
			var eM = parseInt(eYmd.substring(5, 6));
			
			var betMon = (eY - sY) * 12 + (eM - sM);
			
			return betMon;
		} catch (e) {
			return null;
		}
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		try {
			if(strDate.length == 10) {
				return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
			} else if(strDate.length == 8) {
				return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
			} else {
				return "";
			}
		} catch(e) {
			return "";
		}
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "viewRdPopup";

  		var w 		= 800;
		var h 		= 600;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		var data = ajaxCall("${ctx}/CertiApp.do?cmd=prcP_BEN_REGNO_UPD","applSeq="+searchApplSeq,false);
		if(data.Result.Code != "OK"){
			alert(data.Result.Message);
			return;
		}

		var lRow = sheet1.LastRow();

		var rdMrd = sheet1.GetCellValue(lRow, "prtRsc");
		var rdTitle = "";
		var rdParam = "";
		var rdZoomRatio = 100;
		var applCd = sheet1.GetCellValue(lRow,"applCd");
		var applSeq = sheet1.GetCellValue(lRow,"applSeq");
		var sabun = sheet1.GetCellValue(lRow,"sabun");
		var reqYy = sheet1.GetCellValue(lRow,"reqYy");
		var sYmd = sheet1.GetCellValue(lRow,"sYmd");
		var eYmd = sheet1.GetCellValue(lRow,"eYmd");
		var purpose = sheet1.GetCellValue(lRow,"purpose");
		var submitOffice = sheet1.GetCellValue(lRow,"submitOffice");
		
		var orgPrt = $("#termType").val();
		
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
			var rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
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
			/* } */
				
			rdTitle = "원천징수영수증";
			rdParam = "[${ssnEnterCd}]"
					+ "["+reqYy+"]"
					+ "[1]"
					+ "['"+sabun+"']"
					+ "['']"
					+ "[ALL]"
					+ "[C]"
					+ "[${baseURL}/hrfile/${ssnEnterCd}/company/]"
					+ "[4]"
					+ "["+sabun+"]"
					+ "[1]"
					+ "[2]"
					+ "[]"
					+ "[]"
					+ "[1]" // stamp
					+ "[N]" // 사대보험출력여부
					+ "[1]" //일괄다운로드 adjust_type리스트
					;
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
		} else {
			rdTitle = sheet1.GetCellValue(lRow,"applTitle");
			rdParam = "[${ssnEnterCd}]"
					+ "["+applSeq+"]"
					+ "[${baseURL}]";
		}

		var imgPath = " " ;
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
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "viewRdPopup"){
			if(rv!=null && rv["printResultYn"] == "Y"){
				var param = "applSeq="+applSeq  + "&prtYn=Y";
				var data = ajaxCall("${ctx}/CertiApp.do?cmd=updateCertiAppDetPrint",param,false);
				$("#btnPrint").hide();
			}
		}
	}


	function chageLangSelect(){
		var certiSelect = document.getElementById("purposeCD");

		// select element에서 선택된 option의 text가 저장된다.
		$("#purpose").val(certiSelect.options[certiSelect.selectedIndex].text);
	}
	
	// PDF 다운로드
	function pdfDownload() {
		var data = ajaxCall("${ctx}/CertiApp.do?cmd=prcP_BEN_REGNO_UPD","applSeq=" + searchApplSeq,false);
		if(data.Result.Code != "OK"){
			alert(data.Result.Message);
			return;
		}

		var url = "${ctx}/FileDownload.do?cmd=getCertiAppPdfDownload&applSeq=" + searchApplSeq;
		$("#pdfDownloadIfrm").attr("src", url);
	}

	function showRd(){
		var Row = sheet1.LastRow();
		gPRow = Row;
		pGubun = "rdPopup";
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
				imgPath : "${baseURL}/OrgPhotoOut.do?enterCd=${ssnEnterCd}&logoCd=5&orgCd=0",
				stamp : sheet1.GetCellValue(Row, "signPrtYn"),
				date : "${curSysYyyyMMdd}"
			}
		};
		window.top.showRdLayer('/CertiApp.do?cmd=getEncryptRd', data,'',sheet1.GetCellValue(Row, "applTitle"));
	}

</script>
</head>
<body class="bodywrap">
<input id="applYmd" name="applYmd" type="hidden"/>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">제증명신청 세부내역</li>
			<li id="btnPrint" class="btn" style="display:none;">
				<a href="javascript:showRd();" id="btnRd" class="basic" style="display:none;">출력</a>
				<a href="javascript:pdfDownload();" id="btnPdfDownload" class="basic" style="display:none;">PDF 다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default">
		<colgroup>
			<col width="11%" />
			<col width="39%" />
			<col width="11%" />
			<col width="" />
		</colgroup>
		<tr id="hdnEmpYmd">
			<th>재직기간</th>
			<td colspan="3">
				<input id="empYmd" name="empYmd" type="text" size="10" class="${dateCss} transparent readonly" readonly/>  ~
				<input id="currYmd" name="currYmd" type="text" size="10" class="${dateCss} transparent readonly" readonly/>
				(<span id="year"></span>년  <span id="month"></span>개월)
			</td>
		</tr>
		<tr id="hdnReqYy">
			<th>신청년도</th>
			<td colspan="3">
				<input id="reqYy" name="reqYy" type="text" maxlength="4" class="${textCss} required ${readonly}" ${readonly}/>
			</td>
		</tr>
		<tr id="hdnSYmd">
			<th>신청기간</th>
			<td colspan="3">
				<input id="sYmd" name="sYmd" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>  ~
				<input id="eYmd" name="eYmd" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>
			</td>
		</tr>
	
		<tr id="hdnAddress">
			<th>주소</th>
			<td colspan="3">
				<input id="address" name="address" type="text" class="w100p ${textCss} required ${readonly}" ${readonly}/>
			</td>
		</tr>
		<tr id="hdnLocation">
			<th>근무처</th>
			<td colspan="3">
				<select id="locationCd" name="locationCd" class="w25p required" ${disabled}></select>
				<input id="locationNm" name="locationNm" type="text" class="w70p ${textCss} required ${readonly}" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>용도</th>
			<td>
				<select id="purposeCD" name="purposeCD" class="text ${required} ${readonly}" onchange="chageLangSelect()" ${disabled}></select>
				<input id="purpose" name="purpose" type="hidden" value="" />
			</td>
			<th><span id="thSubmitOffice">제출처</span></th>
			<td>
				<input id="submitOffice" name="submitOffice" type="text" class="w100p required ${textCss} ${readonly}" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>기타</th>
			<td colspan="3">
				<textarea id="etc" name="etc" rows="3" cols="" class="w100p ${textCss} ${readonly}" ${readonly} ></textarea>
			</td>
		</tr>
		<tr id="hdnResNoChk">
			<th>인쇄항목선택</th>
			<td colspan="3">
				주민번호 <input id="resNoYn" name="resNoYn" type="checkbox" ${disabled} style="margin-left:10px; vertical-align:middle;" />
			</td>
		</tr>
		<tr id="hdnOrgChk" style="display:none;">
			<th>경력사항표시</th>
			<td colspan="3">
				표시여부 <input id="orgYn" name="orgYn" type="checkbox" ${disabled} style="margin-left:10px; vertical-align:middle;" />
			</td>
		</tr>
	</table>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>
	</form>
</div>
<iframe id="pdfDownloadIfrm" src="about:blank" style="display:none;"></iframe>
</body>
</html>
