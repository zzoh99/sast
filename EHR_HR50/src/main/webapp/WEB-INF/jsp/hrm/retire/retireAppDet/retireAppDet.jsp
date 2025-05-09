<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var searchApplSabun = "${searchApplSabun}";
	var searchApplYmd = "${searchApplYmd}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var pGubun = "";
	
	var retSurveyHdn = "${retSurveyHdn}";  // 0 -> 보임 / 1 -> 안보임
	//var retAgreeHdn = "${retAgreeHdn}";
	var retireGb = "";
	$(function() {
		retireGb = ajaxCall("${ctx}/RetireApp.do?cmd=getRetireGb","applSeq="+searchApplSeq,false).DATA.retireGb;

		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}	
		
		
		if("${retSurveyHdn}" == "0"){
			$("#retSurveyHdnDiv1").removeClass("hide");
			$("#retSurveyHdnDiv2").removeClass("hide");
		}else{
			$("#retSurveyHdnDiv1").addClass("hide");
			$("#retSurveyHdnDiv2").addClass("hide");
		}
		
		// retAgreeHdn YY : 비밀유지서약서,사직원사용 YN :비밀유지서약서사용, NY:사직원사용,NN:사용안함
		if("${retAgreeHdn}" == "YY"){
			$("#retAgreeHdnDiv1").removeClass("hide");
			$("#retAgreeHdnDiv2").removeClass("hide");
			$("#retAgreeHdnDiv3").removeClass("hide");
		}else if("${retAgreeHdn}" == "YN"){
			$("#retAgreeHdnDiv1").removeClass("hide");
			$("#retAgreeHdnDiv2").removeClass("hide");
			$("#retAgreeHdnDiv3").addClass("hide");
		}else if("${retAgreeHdn}" == "NY"){
			$("#retAgreeHdnDiv1").removeClass("hide");
			$("#retAgreeHdnDiv2").addClass("hide");
			$("#retAgreeHdnDiv3").removeClass("hide");
		}else{
			$("#retAgreeHdnDiv1").addClass("hide");
			$("#retAgreeHdnDiv2").addClass("hide");
			$("#retAgreeHdnDiv3").addClass("hide");
		}
		
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"신청일자",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:130 },
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:130 },
			{Header:"최종출근일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"finWorkYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직희망일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retSchYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직일",				Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직사유코드",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retReasonCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",				Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"면담자사번(현업)",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"convSabun1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:130 },
			{Header:"면담자성명(현업)",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"convName1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:130 },
			{Header:"퇴직사유코드(현업)",	Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retReasonCd1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"면담내용(현업)",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"convNote1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3000 },
			{Header:"이직회사",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"moveCompany",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3000 },
			{Header:"인수인계확인여부",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"confirmYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"면담자사번(인사)",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"convSabun2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:130 },
			{Header:"퇴직사유코드(인사)",	Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retReasonCd2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"퇴직후진로코드",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retPathCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"면담내용(인사)",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"convNote2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3000 },
			{Header:"신청상태",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"신청순번",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:350 },
			{Header:"업무인수자(사번)",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"takeoverSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:130},
			{Header:"업무인수자(성명)",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"takeoverName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:130},
			{Header:"퇴직후연락처",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retContractNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"업무인수인계시작일",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"takeoverSdate",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:80},
			{Header:"업무인수인계종료일",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"takeoverEdate",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:80 },
			{Header:"비밀유지서동의여부",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"agreeYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"비밀유지서동의일자",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"agreeDate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:80 },
			{Header:"비밀유지서명파일",	Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"signFileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:130},
			{Header:"사직원서서명파일 ",	Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"signFileSeq1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:130},
			{Header:"사직원여부",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"signYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:130},
			{Header:"2번째결재자",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"interview2Sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:130},
			{Header:"퇴직면담수",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"interviewCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:130},
			{Header:"rk",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"rk",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"rk2",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"rk2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1}
			
		]; IBS_InitSheet(sheet1, initdata1); sheet1.SetEditable(true); sheet1.SetVisible(true); sheet1.SetCountPosition(4);

		var retReasonCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=Y","H40100"), " ");
		var retPathCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40150"), " ");
		$("#retReasonCd").html(retReasonCd[2]);
		$("#retPathCd").html(retPathCd[2]);
		$(window).smartresize(sheetResize); sheetInit();
		parent.iframeOnLoad("220px");

		doAction1("Search");
	});

	$(function() {
		if(authPg == "A") {
			$("#finWorkYmd").datepicker2({
	            onReturn: function(date) {
	            	$("#takeoverEdate").val(date);
	            }
	        });
			$("#retSchYmd").datepicker2({
	            onReturn: function(date) {
	            	$("#retYmd").val(date);
	            }
	        });
			
			$("#takeoverSdate").datepicker2();
			$("#takeoverEdate").datepicker2();
			$("#nameBtn").show();
		} else {
			$("#nameBtn").hide();
		}

		$("#note").maxbyte(1000);
		$("#convNote1").maxbyte(3000);
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/RetireApp.do?cmd=getRetireAppDetList","applSeq="+searchApplSeq);
			break;
		case "Save":
			if(!userValidate(retireGb)) {
				return;
			}

			setFormToSheet();
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/RetireApp.do?cmd=saveRetireAppDet", $("#sheet1Form").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			setSheetToForm();
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "" && authPg != "A") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function setSheetToForm() {

		$("#applYmd").val(formatDate(searchApplYmd,"-"));

		if(sheet1.SearchRows() > 0) {

			$("#name").text(sheet1.GetCellValue(sheet1.LastRow(),"name"));
        	$("#finWorkYmd").val(formatDate(sheet1.GetCellValue(sheet1.LastRow(),"finWorkYmd"),"-"));
        	$("#retSchYmd").val(formatDate(sheet1.GetCellValue(sheet1.LastRow(),"retSchYmd"),"-"));
        	$("#retYmd").val(formatDate(sheet1.GetCellValue(sheet1.LastRow(),"retYmd"),"-"));
        	$("#retReasonCd").val(sheet1.GetCellValue(sheet1.LastRow(),"retReasonCd"));
        	$("#note").val(sheet1.GetCellValue(sheet1.LastRow(),"note"));
        	$("#moveCompany").val(sheet1.GetCellValue(sheet1.LastRow(),"moveCompany"));
        	$("#convNote1").val(sheet1.GetCellValue(sheet1.LastRow(),"convNote1"));
        	$("#convNote").val(sheet1.GetCellValue(sheet1.LastRow(),"convNote1"));
        	$("#convName").text(sheet1.GetCellValue(sheet1.LastRow(),"convName1"));
        	$("#retPathCd").val(sheet1.GetCellValue(sheet1.LastRow(),"retPathCd"));
        	
        	$("#takeoverSabun").val(sheet1.GetCellValue(sheet1.LastRow(),"takeoverSabun"));
        	$("#takeoverName").val(sheet1.GetCellValue(sheet1.LastRow(),"takeoverName"));
        	$("#takeoverSdate").val(formatDate(sheet1.GetCellValue(sheet1.LastRow(),"takeoverSdate"),"-"));
        	$("#takeoverEdate").val(formatDate(sheet1.GetCellValue(sheet1.LastRow(),"takeoverEdate"),"-"));

        	if(sheet1.GetCellValue(sheet1.LastRow(),"agreeYn") == "Y") {
        		$("#agreeYn").attr("checked",true);
        	} else {
        		$("#agreeYn").attr("checked",false);
        	}
        	
        	
        	if(sheet1.GetCellValue(sheet1.LastRow(),"signYn") == "Y") {
        		$("#signYn").attr("checked",true);
        	} else {
        		$("#signYn").attr("checked",false);
        	}
        	
        	$("#retContractNo").val(sheet1.GetCellValue(sheet1.LastRow(),"retContractNo"));
        	
        	$("#schSignFileSeq").val(sheet1.GetCellValue(sheet1.LastRow(),"signFileSeq"));
        	$("#schSignFileSeq1").val(sheet1.GetCellValue(sheet1.LastRow(),"signFileSeq1"));

        	if(sheet1.GetCellValue(sheet1.LastRow(),"applStatusCd") == "99") {
        		$("#convNote1").removeClass().addClass("w100p transparent readonly").attr("readonly",true);
        		$("#retPathCd").removeClass().addClass("readonly").attr("disabled",true);
        		$("#moveCompany").removeClass().addClass("readonly").attr("disabled",true);
        	}
        	
        	if(retireGb == "G" || adminYn == "Y") {
    			$("#retSurveyHdnDiv1").addClass("hide");
    			$("#retSurveyHdnDiv2").addClass("hide");
    			
    		} else if(retireGb == "H") {
    			
    			$("#retSurveyHdnDiv1").removeClass("hide");
    			$("#retSurveyHdnDiv2").removeClass("hide");
    		}
        	
		}else{
			var userData = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail","selectedUserId=${searchApplSabun}&searchStatusCd=A" ,false);
			$("#name").text(userData.map.name);			 
		}
		//설문지 등록여부 데이터
		var surveyData = ajaxCall("${ctx}/RetireApp.do?cmd=getRetireSurveyYnMap","applSeq="+searchApplSeq ,false);
		if ( surveyData != null && surveyData.DATA != null ){
			if(surveyData.DATA.surveyYn == "Y") {
				$("#surveyText").text("제출");
				$("#surveyText").css("color","##008fd5");
				$("#surveyYn").val("Y");
			}
		}
	}

	function setFormToSheet() {

		var row = "";
		if(sheet1.RowCount() == 0) {
			row = sheet1.DataInsert();
		} else {
			row = sheet1.LastRow();
		}
		sheet1.SetCellValue(row,"finWorkYmd",formatDate($("#finWorkYmd").val(),""));
		sheet1.SetCellValue(row,"retSchYmd",formatDate($("#retSchYmd").val(),""));
		sheet1.SetCellValue(row,"retYmd",formatDate($("#retYmd").val(),""));
		sheet1.SetCellValue(row,"retReasonCd",$("#retReasonCd").val());
		sheet1.SetCellValue(row,"note",$("#note").val());
		sheet1.SetCellValue(row,"convNote1",$("#convNote1").val());
		sheet1.SetCellValue(row,"moveCompany",$("#moveCompany").val());
		sheet1.SetCellValue(row,"retPathCd",$("#retPathCd").val());
		sheet1.SetCellValue(row,"applYmd",searchApplYmd);
		sheet1.SetCellValue(row,"applSeq",searchApplSeq);
		sheet1.SetCellValue(row,"sabun",searchApplSabun);
		sheet1.SetCellValue(row,"name",$("#name").text());
		
		sheet1.SetCellValue(row,"takeoverSabun",$("#takeoverSabun").val());					//업무인수자
		sheet1.SetCellValue(row,"takeoverSdate",formatDate($("#takeoverSdate").val(),""));	//업무인계기간(시작일)
		sheet1.SetCellValue(row,"takeoverEdate",formatDate($("#takeoverEdate").val(),""));	//업무인계기간(종료일)
		
		sheet1.SetCellValue(row,"signFileSeq",$("#schSignFileSeq").val());
		
		sheet1.SetCellValue(row,"signFileSeq1",$("#schSignFileSeq1").val()); //사직원
		
		sheet1.SetCellValue(row,"retContractNo",$("#retContractNo").val()); // 퇴직후 연락처
		
		
		if($("#agreeYn").is(":checked")==true) {
			sheet1.SetCellValue(row,"agreeYn","Y");	//비밀서약서 동의여부
		}
		
		if($("#signYn").is(":checked")==true) {
			sheet1.SetCellValue(row,"signYn","Y");	//사직원 동의여부
		}

		if(retireGb == "G" || adminYn == "Y") {
			sheet1.SetCellValue(row,"convSabun1", "${ssnSabun}");
			
		} else if(retireGb == "H") {
			sheet1.SetCellValue(row,"convSabun2", "${ssnSabun}");
		}

		for(var i = 1; i < sheet1.RowCount()+1; i++) {
			if(sheet1.GetCellValue(i,"sStatus") == "R") {
				sheet1.SetCellValue(i,"sStatus","U");
			}
		}
	}

	function userValidate(auth) {

		if(auth == "S") {
			
			
			if($("#finWorkYmd").val() == "") {
				alert("최종출근일을 입력하여 주십시오.");
				return false;
			}

			if($("#retSchYmd").val() == "") {
				alert("퇴직희망일을 입력하여 주십시오.");
				return false;
			}
			
			if($("#agreeYn").is(":checked")==false) {
				alert("비밀유지서에 동의하여 주십시오.");
				return false;
			}
			
			if($("#signYn").is(":checked")==false) {
				alert("사직원에 서명하여 주십시오.");
				return false;
			}
			
			//퇴직설문 제출여부
			
			if("${retSurveyHdn}" == "0" && ( $("#surveyYn").val() == "" || $("#surveyYn").val() == "N")) {
				alert("퇴직설문을 작성하여 주십시오.");
				return false;
			}
			
		}
		return true;
	}

	// 저장후 리턴함수
	function setValue(status){
		var saveStr;
		var rtn;
	
		try{
			
			if(authPg == "A") {
				if(!userValidate(retireGb)) {
					return;
				}
				setFormToSheet();
				saveStr = sheet1.GetSaveString(0);
				if(saveStr.match("KeyFieldError")) {
					return false;
				}
				
				IBS_SaveName(document.sheet1Form,sheet1);
				rtn = eval("("+sheet1.GetSaveData("${ctx}/RetireApp.do?cmd=saveRetireAppDet", saveStr + "&"+ $("#sheet1Form").serialize())+")");

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					return false;
				}

				//sheet1.LoadSaveData(rtn);

			} else{
				

				var agree2Sabun = "${ssnSabun}";
	    		var interview2Sabun =  sheet1.GetCellValue(sheet1.LastRow(),"interview2Sabun");
	    		var interviewCnt = sheet1.GetCellValue(sheet1.LastRow(),"interviewCnt");
	    		
	    		if(agree2Sabun == interview2Sabun && interviewCnt == 0 && status =="1" ){
	    			alert("퇴직면담내역이 없습니다. 퇴직면담을 진행 후 결재하시기 바랍니다.");
	    			return false;
	    		}
	    		
				if(  adminYn == "Y"  ||  retireGb == "G"  ){
				// retireGb : G : 결제자  / H :수신자
				
					//저장
					setFormToSheet();
	
					saveStr = sheet1.GetSaveString(0);
	
					if(saveStr.match("KeyFieldError")) {
						return false;
					}
					
					IBS_SaveName(document.sheet1Form,sheet1);
					rtn = eval("("+sheet1.GetSaveData("${ctx}/RetireApp.do?cmd=saveRetireAppDet", saveStr + "&"+ $("#sheet1Form").serialize())+")");
	
					if(rtn.Result.Code < 1) {
						alert(rtn.Result.Message);
						return false;
					}

				}
				//sheet1.LoadSaveData(rtn);
			} 

		} catch (ex){
			alert("Script Errors Occurred While Saving." + ex);
			return false;
		}

		return true;
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}	
	
	//비밀유지 MRD
	function showRdPopup(){
		if(!isPopup()) {return;}
		// args의 Y/N 구분자는 없으면 N과 같음
		var	sabun     = "";
		var	reqDate   = "";
		var	applSeq   = "";
		var	secretSeq = "";
		var Row = sheet1.LastRow();

		if(sheet1.GetCellValue(sheet1.LastRow(),"applSeq") == "신청순번") {
			sabun 	= searchApplSabun;
			reqDate = searchApplYmd;
			applSeq = searchApplSeq;
			secretSeq = $("#schSignFileSeq").val();
			const type = "1"

			const param = "sabun=" + sabun
					+ "&reqDate=" + reqDate
					+ "&secretSeq=" + secretSeq
					+ "&type=" + type

			let rkData;
			var data = ajaxCall("/RetireApp.do?cmd=getRdRk", param, false);
			if ( data != null && data.DATA != null ){
				rkData = {
					rk : data.DATA.rk,
					type: type
				};
			}

			if(rkData && !Number(sheet1.GetCellValue(sheet1.LastRow(), "signFileSeq")) && sheet1.GetCellValue(sheet1.LastRow(), "agreeYn") != "Y"){
				pGubun  = "rdSignRetireSecret"
				showRdSignLayer('/RetireApp.do?cmd=getEncryptRd', rkData, null, "비밀유지서약서");
			} else {
				pGubun  = "rdRetireSecret"
				window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', rkData, null,"비밀유지서약서");
			}

		} else {
			var Row = sheet1.LastRow();
			const data = {
				rk : sheet1.GetCellValue(Row, 'rk'),
				type : 1
			};

			window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', data, null,"비밀유지서약서");
		}

		//openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}

	//사직원 MRD
	function showRdPopup1(){
		if(!isPopup()) {return;}
		var sabun 	= "";
		var reqDate = "";
		var applSeq = "";
		var signFileSeq1 = "";
		var finWorkYmd = "";
		var retSchYmd = "";
		var Row = sheet1.LastRow();
		var note = "";
		var retContractNo = "";
		
		//처음신청할 경우 사번 등 데이터 넘겨받은 파라미터로 셋팅
		if(sheet1.GetCellValue(sheet1.LastRow(),"applSeq") == "신청순번") {
			sabun 	= searchApplSabun;
			reqDate = searchApplYmd;
			applSeq = searchApplSeq;
			signFileSeq1 = $("#schSignFileSeq1").val();
			finWorkYmd = $("#finWorkYmd").val();//비밀유지 서약
			retSchYmd = $("#retSchYmd").val(); //비밀유지 서약
			note = $("#note").val(); //비밀유지 서약
			retContractNo =  $("#retContractNo").val(); //퇴사후 연락처

			let type = ""
			if(sheet1.SearchRows() >0){
				type = "2"
			}else {
				type = "3"
			}

			const param = "sabun=" + sabun
					+ "&reqDate=" + reqDate
					+ "&applSeq=" + applSeq
					+ "&signFileSeq1=" + signFileSeq1
					+ "&finWorkYmd=" + finWorkYmd
					+ "&retSchYmd=" + retSchYmd
					+ "&note=" + note
					+ "&retContractNo=" + retContractNo
					+ "&type=" + type

			let rkData;
			var data = ajaxCall("/RetireApp.do?cmd=getRdRk", param, false);
			if ( data != null && data.DATA != null ){
				rkData = {
					rk : data.DATA.rk,
					type: type
				};
			}

			if(!Number(sheet1.GetCellValue(sheet1.LastRow(), "signFileSeq1")) && sheet1.GetCellValue(sheet1.LastRow(), "signYn") != "Y"){
				pGubun  = "rdSignRetireRetire"
				showRdSignLayer('/RetireApp.do?cmd=getEncryptRd', rkData, null, "사직원");
			} else {
				pGubun  = "rdRetireRetire"
				window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', rkData, null,"사직원");
			}
		} else {
			 <%--sabun = ",('${ssnEnterCd}','" + sheet1.GetCellValue(Row,"applSeq") + "')";--%>
			 <%--reqDate = sheet1.GetCellValue(Row,"applYmd");--%>
			 <%--applSeq = sheet1.GetCellValue(Row,"applSeq");--%>

			var Row = sheet1.LastRow();
			const data = {
				rk : sheet1.GetCellValue(Row, 'rk2'),
				type : 2
			};


			window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', data, null, "사직원");
		}
	}

	//최종출근일 선택시 업무인수인계기간 종료일 변경
	function changeTakeEdate(val) {
		$("#takeoverEdate").val(val);
	}
	
	//퇴직설문팝업
	function showSurveyPopup() {
		if(!isPopup()) {return;}
		var url    = "${ctx}/RetireApp.do?cmd=viewRetireSurveyLayer&authPg=" + authPg;
		var w = 835, h = 700;
		var title = '퇴직설문지';
		var sabun, reqDate, applSeq;
        if(sheet1.GetCellValue(sheet1.LastRow(),"applSeq") == "신청순번") {
			sabun 	= searchApplSabun;
			reqDate = searchApplYmd;
			applSeq = searchApplSeq;
		} else {
			sabun 	= sheet1.GetCellValue(sheet1.LastRow(),"sabun");
			reqDate = sheet1.GetCellValue(sheet1.LastRow(),"applYmd");
			applSeq = sheet1.GetCellValue(sheet1.LastRow(),"applSeq");
		}
        var p = {	sabun, reqDate, applSeq  };
        var layer = new window.top.document.LayerModal({
			id: 'retireSurveyLayer',
			url,
			parameters: p,
			width: w,
			height: h,
			title: title,
			trigger: [
				{
				  name: 'retireSurveyLayerTrigger',
				  callback: function(rv) {
					$("#surveyYn").val(rv.surveyYn);
					if(rv.surveyYn == "Y") {
						$("#surveyText").text("제출");
						$("#surveyText").css("color","##008fd5");
					}
				  }
				}
			]
		});
		layer.show();

	}

	// 사원 팝업
	function showEmployeePopup() {
		if(!isPopup()) {return;}
		pGubun = "employeePopup";
		var url    = "${ctx}/Popup.do?cmd=viewEmployeeLayer";
		var id = "employeeLayer";
		var title = "사원조회";
		var w = 740, h = 520;
		var p = {sType: 'T'};
		var layer = new window.top.document.LayerModal({
			id, url,
			parameters: p,
			width: w,
			height: h,
			title: title,
			trigger: [
				{
				  name: 'employeeTrigger',
				  callback: function(rv) {
					  $('#takeoverName').val(rv.name);
					  $('#takeoverSabun').val(rv.sabun);
				  }
				}
			]
		});
		layer.show();
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {

		if(pGubun == "retireSurveyPopup") {
			var rv = $.parseJSON('{' + rv+ '}');
			$("#surveyYn").val(rv["surveyYn"]);
			if(rv["surveyYn"] == "Y") {
				$("#surveyText").text("제출");
				$("#surveyText").css("color","##008fd5");
			}
		} else if(pGubun == "employeePopup"){
			var rv = $.parseJSON('{' + rv+ '}');
			$('#takeoverName').val(rv["name"]);
			$('#takeoverSabun').val(rv["sabun"]);
	    } else if(pGubun == "rdSignRetireSecret" && rv["fileSeq"] != undefined){
			sheet1.SetCellValue(sheet1.LastRow(), "signFileSeq", rv.fileSeq) ;
			$('#schSignFileSeq').val(rv.fileSeq);
			$("input:checkbox[name='agreeYn']").prop("checked", true);
		} else if(pGubun == "rdSignRetireRetire" && rv["fileSeq"] != undefined){
			sheet1.SetCellValue(sheet1.LastRow(), "signFileSeq1", rv.fileSeq) ;
			$('#schSignFileSeq1').val(rv.fileSeq);
			$("input:checkbox[name='signYn']").prop("checked", true);
		}
	}

	function showRdSignLayer(url, data, opt, title, cW, cH, top, left){
		//암호화 호출
		const result = ajaxTypeJson(url, data, false);

		let layerModal = new window.top.document.LayerModal({
			id : 'rdSignLayer' //식별자ID
			, url : '/viewRdSignLayer.do' //팝업에 띄울 화면 jsp
			, parameters : {
				"p" : result.DATA.path,
				"d" : result.DATA.encryptParameter,
				"o" : opt,
				"u" : url,
				"ud": data
			}
			, width : (cW != null && cW != undefined)?cW:1000
			, height : (cH != null && cH != undefined)?cH:800
			, top : (top != null && top != undefined) ? top : 0
			, left : (left != null && left != undefined) ? left : 0
			, title : (title != null && title != undefined)?title:'-'
			, trigger :[ //콜백
				{
					name : 'rdSignLayerTrigger'
					, callback : function(rv){
						getReturnValue(rv)
					}
				}
			]
		});
		layerModal.show();
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="retYmd" name="retYmd"/>
	<input type="hidden" id="surveyYn" name="surveyYn"/>
	<input type="hidden" id="schSignFileSeq" name="schSignFileSeq"/>	<!-- 서명파일_첨부파일 -->
	<input type="hidden" id="schSignFileSeq1" name="schSignFileSeq1"/>	<!-- 사직원서명파일_첨부파일 -->
	
	
</form>
<div class="wrapper">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">퇴직신청 세부내역</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default">
		<colgroup>
			<col width="12%" />
			<col width="39%" />
			<col width="12%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>성명</th>
			<td>
				<span id="name" name="name"></span>
			</td>
			<th>신청일자</th>
			<td>
				<input id="applYmd" name="applYmd" type="text" size="10" class="date2 transparent" readonly/>
			</td>
		</tr>
		<tr>
			<th>최종출근일</th>
			<td>
				<input id=finWorkYmd name="finWorkYmd" type="text" size="10" class="${dateCss} required " ${readonly} onchange="changeTakeEdate(this.value);"/>
			</td>
			<th>퇴직희망일</th>
			<td>
				<input id=retSchYmd name="retSchYmd" type="text" size="10" class="${dateCss} required" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>업무인수자</th>
			<td>
				<input id="takeoverSabun" name="takeoverSabun" type="hidden"/>
				<input id="takeoverName" name="takeoverName" type="text" class="${textCss} ${readonly}" readonly/>
				<span id="nameBtn"><a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a></span>
			</td>
			<th>업무인수인계기간</th>
			<td>
				<input id=takeoverSdate name="takeoverSdate" type="text" size="10" style="width: 70px;" class="${dateCss}" ${readonly} value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>&nbsp;~&nbsp;
				<input id=takeoverEdate name="takeoverEdate" type="text" size="10" style="width: 70px;" class="${dateCss}" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>퇴직후 연락처</th>
			<td colspan="3">
				<input id=retContractNo name="retContractNo" type="text" size="30" class="${textCss} required w200" ${readonly}/>		
			</td>
		</tr>
		
		<tr class="hide">
			<th>퇴직사유</th>
			<td colspan="3">
				<select id="retReasonCd" name="retReasonCd" class="${selectCss}  ${readonly}" ${disabled}>
				</select>
			</td>
		</tr>
		<tr>
			<th>퇴직사유<br>(상세기술)</th>
			<td colspan="3">
				<textarea id="note" name="note" rows="3" cols="" class="w100p ${textCss} required ${readonly}" ${readonly} ></textarea>
			</td>
		</tr>
	</table>
	
	
	
	<div class="outer" id="retAgreeHdnDiv1">
		<div class="sheet_title">
		<ul>
			<li class="txt">전자서명</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default" id="retAgreeHdnDiv2">
		<colgroup>
			<col width="12%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>비밀유지서약서</th>
			<td>
				<btn:a href="javascript:showRdPopup();"	css="basic" mid='insert' mdef="상세보기" style="background-color: #e1effb;"/>
				<input id="agreeYn" name="agreeYn" type="checkbox" value="" required disabled /><label for="agreeYn">동의여부</label>
			</td>		
		</tr>	
	</table>
	
	<table border="0" cellpadding="0" cellspacing="0" class="default" id="retAgreeHdnDiv3">
		<colgroup>
			<col width="12%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>사직원 </th>
			<td>
				<btn:a href="javascript:showRdPopup1();"	css="basic" mid='insert' mdef="상세보기" style="background-color: #e1effb;"/>
				<input id="signYn" name="signYn" type="checkbox" value="" required disabled /><label for="signYn">전자서명</label>
			</td>		
		</tr>	
	</table>
	
	
	<div class="outer hide" id="retSurveyHdnDiv1">
		<div class="sheet_title">
		<ul>
			<li class="txt">퇴직설문</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default hide" id="retSurveyHdnDiv2">
		<colgroup>
			<col width="12%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>제출여부</th>
			<td>
				<btn:a href="javascript:showSurveyPopup();"	css="basic" mid='insert' mdef="퇴직설문" style="background-color: #e1effb;"/>
				<span id="surveyText" name="surveyText" style="color: #ff1a33;">미제출</span>
			</td>		
		</tr>	
	</table>
	
	
	<div class="outer hide" id="basicUserDiv1" name="basicUserDiv1">
		<div class="sheet_title">
		<ul>
			<li class="txt">면담자 의견</li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default hide" id="basicUserTbl1" name="basicUserTbl1">
		<colgroup>
			<col width="12%" />
			<col width="" />			
		</colgroup>
		<tr>
			<th>면담자</th>
			<td>
				<span id="convName" name="convName"></span>
			</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>
				<textarea id="convNote" name="convNote" rows="3" cols="" class="w100p ${textCss} readonly" readonly ></textarea>
			</td>
		</tr>		
	</table>
	
	<!-- 결재자 화면 START -->
	<div class="outer hide" id="hdnUserDiv1" name="hdnUserDiv1">
		<div class="sheet_title">
		<ul>
			<li class="txt">면담작성</li>
		</ul>
		</div>
	</div>
	<table id="hdnUserTbl1" name="hdnUserTbl1" border="0" cellpadding="0" cellspacing="0" class="default hide">
	<colgroup>
		<col width="12%" />
		<col width="39%" />
		<col width="12%" />
		<col width="" />
	</colgroup>
	<tr>
		
		<th>퇴직후 진로</th>
		<td>
			<select id="retPathCd" name="retPathCd">
			</select>
		</td>
	</tr>
	<tr>
		<th>이직회사 </th>
		<td>
			<input type="text" id="moveCompany" name="moveCompany" class="w100p" />
		</td>
	</tr>
	<tr>
		<th>면담내용</th>
		<td>
			<textarea id="convNote1" name="convNote1" rows="3" cols="" class="w100p"></textarea>
		</td>
	</tr>
	</table>
	<!-- 결재자화면 END -->
	
	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>

</div>
</body>
</html>
