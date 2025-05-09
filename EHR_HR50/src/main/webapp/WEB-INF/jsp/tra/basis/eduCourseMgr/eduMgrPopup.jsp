<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>교육과정/회차 등록 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
.overAuto {overflow:auto;}
</style>
<script type="text/javascript">
	
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var codeLists ;
	var ssnTelNo = "";

	$(function() {

		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			$("#eduSeq").val(arg["eduSeq"]);
			$("#eduEventSeq").val(arg["eduEventSeq"]);
		}

		//사용자정보 조회
		var user = ajaxCall( "${ctx}/EduApp.do?cmd=getEduCourseMgrUserInfo", "",false);
		if ( user != null && user.DATA != null ){ 
			ssnTelNo = user.DATA.telNo;
		}

		$("#mngSabun").val("${ssnSabun}");
		$("#mngName").val("${ssnName}");
		$("#mngOrgNm").val("${ssnOrgNm}");
		$("#mngTelNo").val(ssnTelNo);

		//alert($("#s_RSAURL").val());
		//공통코드 한번에 조회
		var grpCds = "L20020,L10010,L10015,L10050,L10170,H20300,L10190,L10110,S10030";
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, " ");
		
		$("#eduStatusCd").html(codeLists["L10170"][2]);//과정상태
		$("#inOutType").html(codeLists["L20020"][2]);// 사내/외
		$("#eduMethodCd").html(codeLists["L10050"][2]);// 시행방법
		$("#eduBranchCd").html(codeLists["L10010"][2]);// 교육구분
		$("#eduMBranchCd").html(codeLists["L10015"][2]);// 교육분류

		$("#eduEvtStatusCd").html(codeLists["L10190"][2]);// 회차상태
		$("#eduRewardCd").html(codeLists["L10110"][2]);// 보상종류
		$("#currencyCd").html(codeLists["S10030"][2]).val("100");//통화단위
		
		
		// 숫자만 입력가능
		$("#eduRewardCnt, #perExpenseMon, #laborMon, #realExpenseMon, #eduRewardCnt, #maxPerson").keyup(function() {
			makeNumber(this,'A');
		})
		
		$('#perExpenseMon').mask('000,000,000,000,000', { reverse : true });
		$('#laborMon').mask('000,000,000,000,000', { reverse : true });
		$('#realExpenseMon').mask('000,000,000,000,000', { reverse : true });
		$('#eduRewardCnt').mask('000', { reverse : true });
		$('#maxPerson').mask('000');
		
		$("#eduSHm").mask("24:59", { reverse : true });
		$("#eduEHm").mask("24:59", { reverse : true });
		
		if ("${authPg}" == "A") {
			$("#eduSYmd").datepicker2({ startdate : "eduEYmd" });
			$("#eduEYmd").datepicker2({ enddate : "eduSYmd" });
			
			$("#applSYmd").datepicker2({ startdate : "applEYmd" });
			$("#applEYmd").datepicker2({ enddate : "applSYmd" });
			
		}
		
		//Sheet 초기화
		init_sheet1(); init_sheet2();
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("SearchDetail");

		//Cancel 버튼 처리
		$(".close").click(function() {
			p.self.close();
		});

	});
	
	/*
	 * sheet Init
	 */
	function init_sheet1(){
	
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"강의순서",	Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"강사명",		Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"강의과목",	Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"subjectLecture",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"연락처",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20, AcceptKeys:"N|[-]" },
			{Header:"강의료",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"lectureFee",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
				
			//Hidden
			{Header:"Hidden", Hidden:1, SaveName:"teacherSeq"},
				
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
		
	}
	/*
	 * sheet Init
	 */
	function init_sheet2(){
	
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"역량군",		Type:"Text",		Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"priorCompetencyNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"역량",		Type:"Popup",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"competencyNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},
				
			//Hidden
			{Header:"Hidden", Hidden:1, SaveName:"competencyCd"},
				
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);
		
	}
	
	/**
	 * Sheet1 ( 강사내역 )
	 */
	function doAction1(sAction) {
		switch (sAction) {
		case "SearchDetail": 
			
			var data;
			if($("#eduEventSeq").val() == ""){  //회차순번이 없을 경우 과정만 조회
				var params = "searchDtl=Y&searchEduSeq="+$("#eduSeq").val();
				data = ajaxCall( "${ctx}/EduApp.do?cmd=getEduCourseMgrList", params,false);
			}else{
				var params = "searchDtl=Y&searchEduSeq="+$("#eduSeq").val()+"&searchEduEventSeq="+$("#eduEventSeq").val();
				data = ajaxCall( "${ctx}/EduApp.do?cmd=getEduEventMgrList", params,false);
			}
			
			if ( data != null && data.DATA != null && data.DATA[0] != null){
				var rtn = data.DATA[0];

				//교육과정정보
				$("#eduSeq").val(rtn.eduSeq);
				$("#eduCourseNm").val(rtn.eduCourseNm);
				$("#eduStatusCd").val(rtn.eduStatusCd);
				$("#inOutType").val(rtn.inOutType);
				$("#eduOrgCd").val(rtn.eduOrgCd);
				$("#eduOrgNm").val(rtn.eduOrgNm);
				$("#eduMethodCd").val(rtn.eduMethodCd);
				$("#eduBranchCd").val(rtn.eduBranchCd);
				$("#eduMBranchCd").val(rtn.eduMBranchCd);
				$("#jobCd").val(rtn.jobCd);
				$("#jobNm").val(rtn.jobNm);
				$("#eduMemo").val(rtn.eduMemo);

				$("#mngSabun").val(rtn.mngSabun);
				$("#mngName").val(rtn.mngName);
				$("#mngOrgNm").val(rtn.mngOrgNm);
				$("#mngTelNo").val(rtn.mngTelNo);

				$("#data1Form>#fileSeq").val(rtn.fileSeq);
				$("#uploadForm>#fileSeq").val(rtn.fileSeq)
				
				upLoadInit(rtn.fileSeq, "");
				
				if($("#eduEventSeq").val() != ""){
					//회차정보
					$("#eduEventSeq").val(rtn.eduEventSeq);
					$("#eduEventNm").val(rtn.eduEventNm);
					$("#eduEvtStatusCd").val(rtn.eduEvtStatusCd);
					$("#maxPerson").val(rtn.maxPerson);
					$("#eduPlace").val(rtn.eduPlace);
		        	$("#resultAppSkipYn").attr("checked",(rtn.resultAppSkipYn == "Y")?true:false);
		        	$("#eduSatiSkipYn").attr("checked",(rtn.eduSatiSkipYn == "Y")?true:false);
					
	
					$("#eduSYmd").val(formatDate(rtn.eduSYmd,"-"));
					$("#eduEYmd").val(formatDate(rtn.eduEYmd,"-"));
					$("#eduSHm").val(rtn.eduSHm).mask("24:59", { reverse : true });
					$("#eduEHm").val(rtn.eduEHm).mask("24:59", { reverse : true });
					$("#eduDay").val(rtn.eduDay);
					$("#eduHour").val(rtn.eduHour);
					$("#applSYmd").val(formatDate(rtn.applSYmd,"-"));
					$("#applEYmd").val(formatDate(rtn.applEYmd,"-"));
					
					$("#currencyCd").val(rtn.currencyCd);
					$("#perExpenseMon").val(makeComma(rtn.perExpenseMon));
					$("#laborApplyYn").val(rtn.laborApplyYn);
					$("#laborMon").val(makeComma(rtn.laborMon));
					$("#realExpenseMon").val(makeComma(rtn.realExpenseMon));
					
					$("#eduRewardCd").val(rtn.eduRewardCd);
					$("#eduRewardCnt").val(rtn.eduRewardCnt);
					
					doAction1("Search"); //강사내역
				}else{
					upLoadInit("", "");
				}
				doAction2("Search"); //관련역량
			}
			break;
		case "Search": //강사 조회
			var params = "eduSeq="+$("#eduSeq").val()+"&eduEventSeq="+$("#eduEventSeq").val()
			sheet1.DoSearch( "${ctx}/EduApp.do?cmd=getEduEventLecturerPopupList", params);
			break;
		case "Insert": //입력

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "eduSeq", $("#eduSeq").val());
			sheet1.SetCellValue(Row, "eduEventSeq", $("#eduEventSeq").val());

			doSearchLecturerNm(Row);
			
			break;

		}
	}

	/**
	 * Sheet2 ( 관련역량 )
	 */
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": //조회
			var params = "searchEduSeq="+$("#eduSeq").val();
			sheet2.DoSearch( "${ctx}/EduApp.do?cmd=getEduMgrComptyList", params );
            break;
		case "Insert":
			var Row = sheet2.DataInsert(0);
			competencyPop(Row);
			break;
		}
		
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "teacherNm"){
				doSearchLecturerNm(Row);
			}
		}catch(ex){
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	//삭제클릭 시 삭제
	function sheet1_OnBeforeCheck(Row,Col) {
		try {
			if( sheet1.ColSaveName(Col) == "sDelete" ){
				sheet1.RowDelete(Row, 0);
			}
		} catch (ex) { alert("OnBeforeCheck Event Error : " + ex); }
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	function sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnPopupClick(Row, Col){
		try {
			if (sheet2.ColSaveName(Col) == "competencyNm") {
				if (!isPopup()) {  return; }
				competencyPop(Row);
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	//삭제클릭 시 삭제
	function sheet2_OnBeforeCheck(Row,Col) {
		try {
			if( sheet2.ColSaveName(Col) == "sDelete" ){
				sheet2.RowDelete(Row, 0);
			}
		} catch (ex) { alert("OnBeforeCheck Event Error : " + ex); }
	}
	

	
	
	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList() {
		var ch = true;

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}

			return ch;
		});
		return ch;
	}
	
	//--------------------------------------------------------------------------------
	//  저장 
	//--------------------------------------------------------------------------------
	function saveData(status) {
		
		try {
			if( status == 2 ){ //회차 새로 저장
				$("#eduEventSeq").val("");
			}
			if(!checkList()) return;
			$("#data1Form>#fileSeq").val($("#uploadForm>#fileSeq").val());
			/* IBLeader > ibupload 모듈 사용으로 인한 주석 처리..
			if (supSheet.RowCount() == 0) {
				$("#data1Form>#fileSeq").val("");
			}
			*/
			var attFileCnt = $('#myUpload').IBUpload('fileList');
			if (attFileCnt == 0) {
				$("#data1Form>#fileSeq").val("");
			}
	
	        //전체 삭제 후 다시 저장 하기 때문에 입력으로 변경
	        for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
	        	sheet1.SetCellValue(i, "sStatus", "I", 0);
	        }
	        //전체 삭제 후 다시 저장 하기 때문에 입력으로 변경
	        var sheet2_param ="";
	        for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
	        	sheet2.SetCellValue(i, "sStatus", "I", 0);
	        	sheet2_param +="&competencyCd="+sheet2.GetCellValue(i, "competencyCd");
	        }
            //필수입력 항목 체크
	        var saveStr1 = sheet1.GetSaveString(0);
            if( sheet1.RowCount() > 0 ){
            	if(saveStr1.match("KeyFieldError")) { return false; }
            }

            //필수입력 항목 체크
	        var saveStr2 = sheet2.GetSaveString(0);
            if( sheet2.RowCount() > 0 ){
            	if(saveStr1.match("KeyFieldError")) { return false; }
            }
            
            IBS_SaveName(document.data1Form, sheet1);
            var params = $("#data1Form").serialize()+"&"+$("#data2Form").serialize()+sheet2_param +"&"+ saveStr1;

			var rtn = ajaxCall("${ctx}/EduApp.do?cmd=saveEduCourseMgrDet", params, false);

            alert(rtn.Result.Message);
            
            if(rtn.Result.Code > 0) {
            	try{ p.popReturnValue(); /*p.self.close();*/ } catch(ee) {}
            }

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}


	}

	//--------------------------------------------------------------------------------
	//  팝업
	//--------------------------------------------------------------------------------
	//교육과정 팝업
	function doSearchEduCourseNm() {
		if (!isPopup()) { return;}

		gPRow = "";
		pGubun = "eduCoursePopup";

		openPopup("${ctx}/Popup.do?cmd=eduCoursePopup&authPg=R", "", "550", "520");
	}
	
	//교육기관 팝업
	function doSearchEduOrgNm() {
		if (!isPopup()) { return;}

		gPRow = "";
		pGubun = "searchEduOrgPopup";

		openPopup("/Popup.do?cmd=eduOrgPopup&authPg=R", "", "650", "520");
	}
	//임직원 팝업
	function employeePopup() {
		if (!isPopup()) { return;}

		gPRow = "";
		pGubun = "employeePopup";

		openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "840", "520");
	}
	//직무팝업
	function doSearchEduJobNm() {
		if (!isPopup()) { return;}

		gPRow = "";
		pGubun = "jobPopup";

		openPopup("${ctx}/Popup.do?cmd=jobPopup", "", "840", "520");
	}


	//강사팝업
	function doSearchLecturerNm(Row) {
		if(!isPopup()) {return;}
	
		gPRow = Row;
		pGubun = "viewEduEventLecturerNmPopup";
	
		var args	= new Array();
		args["eduSeq"]	= sheet1.GetCellValue( Row, "eduSeq" );
	
		openPopup("/EduApp.do?cmd=viewEduEventLecturerNmPopup", args, "550","520");
		
	}
	//역량팝업
	function competencyPop(Row){
		if (!isPopup()) {  return; }

		gPRow = Row;
		pGubun = "competencyPop";
		
		var args	= new Array();
		args["selectType"] = "C"; //선택 가능

		openPopup("/Popup.do?cmd=competencySchemePopup", args,"740", "720");
	}

	
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "eduCoursePopup") { //교육과정명
			resetForm();
			$("#eduCourseNm").val(rv["eduCourseNm"]);
			$("#eduSeq").val(rv["eduSeq"]);
			$("#eduOrgCd").val(rv["eduOrgCd"]); //교육기관
			$("#eduOrgNm").val(rv["eduOrgNm"]); //교육기관
			$("#inOutType").val(rv["inOutType"]); //사내/외
			$("#eduMethodCd").val(rv["eduMethodCd"]); //시행방법
			$("#eduBranchCd").val(rv["eduBranchCd"]); //교육구분
			$("#eduMBranchCd").val(rv["eduMBranchCd"]); //교육분류
			$("#eduStatusCd").val(rv["eduStatusCd"]); //교육상태
			$("#inOutType").val(rv["inOutType"]); //사내/외 구분
			$("#eduLevel").val(rv["eduLevel"]); //강의난이도
			$("#mandatoryYn").val(rv["mandatoryYn"]); //필수여부
			$("#jobCd").val(rv["jobCd"]); //관련직무
			$("#jobNm").val(rv["jobNm"]); //관련직무

		} else if (pGubun == "searchEduOrgPopup") { //교육기관
			$("#eduOrgCd").val(rv["eduOrgCd"]); //교육기관
			$("#eduOrgNm").val(rv["eduOrgNm"]); //교육기관
			
		} else if (pGubun == "employeePopup") { //담당자
			$("#mngSabun").val(rv["sabun"]);
			$("#mngName").val(rv["name"]);
			$("#mngOrgNm").val(rv["orgNm"]);
			$("#mngTelNo").val(rv["officeTel"]);
			
		} else if (pGubun == "jobPopup") { //직무팝업
			$("#jobCd").val(rv["jobCd"]); //직무코드
			$("#jobNm").val(rv["jobNm"]); //직무명
			
		} else 	if(pGubun == "viewEduEventLecturerNmPopup"){ //강사팝업

			sheet1.SetCellValue(gPRow, "teacherSeq",		rv["teacherSeq"] );
			sheet1.SetCellValue(gPRow, "teacherGb",			rv["teacherGb"] );
			sheet1.SetCellValue(gPRow, "teacherNo",			rv["teacherNo"] );
			sheet1.SetCellValue(gPRow, "teacherNm",			rv["teacherNm"] );
			sheet1.SetCellValue(gPRow, "telNo",				rv["telNo"] );
			sheet1.SetCellValue(gPRow, "subjectLecture",	rv["subjectLecture"] );
			sheet1.SetCellValue(gPRow, "lectureFee",		rv["lectureFee"] );

		} else if (pGubun == "competencyPop") { 

			sheet2.SetCellValue(gPRow, "priorCompetencyNm", rv["priorCompetencyNm"]);
			sheet2.SetCellValue(gPRow, "competencyCd", 		rv["competencyCd"]);
			sheet2.SetCellValue(gPRow, "competencyNm", 		rv["competencyNm"]);
				
		} 
	}

	//초기화 버튼 클릭 시
	function resetForm(flag){
		if( flag == 0 ){ //과정 초기화
			$("#data1Form")[0].reset();
			sheet2.RemoveAll(); //관련역량
			/* IBLeader > ibupload 모듈 사용으로 인한 주석 처리..
			supSheet.RemoveAll(); //첨부파일
			*/
			doIBUAction("removeall");
			//교육담당자 디폴트 값
			$("#mngSabun").val("${ssnSabun}");
			$("#mngName").val("${ssnName}");
			$("#mngOrgNm").val("${ssnOrgNm}");
			$("#mngTelNo").val(ssnTelNo);
		}
		//회차 초기화
		$("#data2Form")[0].reset();
		sheet1.RemoveAll(); //강사내역
		$("#currencyCd").val("100");
		
	}
	
</script>
<style type="text/css">
table.eduInfo th {background-color:#f4f4f4;}

/*---- checkbox ----*/
input[type="checkbox"]  { 
	display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none; 
 	-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}
label {
	vertical-align:-2px;padding-right:10px;
}

div.popup_main_box { position: absolute;top:50px; bottom:70px; left:0; right:0;overflow:auto;overflow-x:hidden}
div.popup_main { padding:20px;}
div.popup_button  { position:absolute;bottom:40px; left:0;padding:0;}

div.eduTitle {
	width:100%; height:35px; background-color:#555;
}
div.eduTitle ul li { padding:5px 0 5px 20px;font-size:1.3em; font-weight:bold; color:#ffffff; float:left;}
div.eduTitle ul li.btn_wrap {padding:0;margin:1px 5px 0 0;float:right; }
div.eduTitle ul li.btn_wrap a.basic {background-color:#fff;}

div.eduBox, div.eduBox2 {border-left: 1px solid #b1b1b1;border-right: 1px solid #b1b1b1; padding:10px 20px 10px 20px;}
div.eduBox2 {border-bottom: 1px solid #b1b1b1;padding-top:0;}
</style>
</head>
<body>

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>교육과정 세부내역</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main_box">
	<div class="popup_main">


		<div class="eduTitle">
			<ul>
				<li>교육과정</li>
				<li class="btn_wrap">
					<!-- a href="javascript:doSearchEduCourseNm();" class="button authA">과정선택</a -->
					<a href="javascript:resetForm(0);" 			class="basic authA">초기화</a>
				</li>
			</ul>
		</div>
		<div class="eduBox">
			<form id="data1Form" name="data1Form" >
			<input type="hidden" id="fileSeq" name="fileSeq" />
			<table style="width:100%;">
				<colgroup>
					<col width=""/>
					<col width="250px"/>
				</colgroup>
				<tr>
					<td>
						<table class="table eduInfo">
						<colgroup>
							<col width="12%" />
							<col width="20%" />
							<col width="12%" />
							<col width="20%" />
							<col width="12%" />
							<col width="*%" />
						</colgroup>
						<tr>
							<th>과정명</th>
							<td colspan="5">
								<input id="eduSeq" name="eduSeq" type="hidden" />
								<input id="eduCourseNm" name="eduCourseNm" type="text" class="${textCss} w80p ${required}" />
							</td>
						</tr>
						<tr>
							<th>과정상태</th>
							<td><select id="eduStatusCd" name="eduStatusCd" class="${selectCss} ${required} " ${disabled}></select></td>
							<th>사내/외</th>
							<td><select id="inOutType" name="inOutType" class="${selectCss} ${required} " ${disabled}></select></td>
							<th>교육기관</th>
							<td>
								<input id="eduOrgCd" name="eduOrgCd" type="hidden" class=""/>
								<input id="eduOrgNm" name="eduOrgNm" type="text" class="${textCss} w70p ${required} "/>
								<a onclick="javascript:doSearchEduOrgNm();return false;" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							</td>
						</tr>
						<tr>
							<th>시행방법</th>
							<td colspan="3"><select id="eduMethodCd" name="eduMethodCd" class="${selectCss} ${required} " ${disabled}></select></td>
							<th>관련직무</th>
							<td>
								<input id="jobCd" name="jobCd" type="hidden" class=""/>
								<input id="jobNm" name="jobNm" type="text" class="${textCss} w70p ${required}"/>
								<a onclick="javascript:doSearchEduJobNm();return false;" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							</td>
						</tr>
						<tr>	
							<th>교육구분</th>
							<td colspan="3"><select id="eduBranchCd" name="eduBranchCd" class="${selectCss} ${required} " ${disabled}></select></td>
							<th>교육분류</th>
							<td><select id="eduMBranchCd" name="eduMBranchCd" class="${selectCss} ${required} " ${disabled}></select></td>
						</tr>
						<tr>
							<th>교육내용</th>
							<td colspan="5">
								<textarea id="eduMemo" name="eduMemo" rows="5" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
							</td>
						</tr>
						
						</table>
					
					</td>
					<td style="vertical-align: top;padding-left:10px;">
	
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">관련역량</li>
									<li class="btn">
										<a href="javascript:doAction2('Search')" class="basic authA">조회</a>
										<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet2", "100%", "210px","${ssnLocaleCd}"); </script>				
					</td>
				</tr>
				<tr>
					<td colspan="2" style="padding-top:5px;">
						<table class="table eduInfo">
						<colgroup>
							<col width="12%" />
							<col width="20%" />
							<col width="12%" />
							<col width="20%" />
							<col width="12%" />
							<col width="*%" />
						</colgroup>
						<tr>
							<th>교육담당자</th>
							<td>
								<input type="hidden" id="mngSabun" name="mngSabun" />
								<input id="mngName" name="mngName" type="text" class="${textCss} w80" readonly/>
<c:if test="${ssnGrpCd == '10' || ssnGrpCd == '15'}">
								<a href="javascript:employeePopup();" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>	
</c:if>
							</td>
							<th>소속</th>
							<td>
								<input id="mngOrgNm" name="mngOrgNm" type="text" class="${textCss}  w180" readonly/>
							</td>
							<th>연락처</th>
							<td>
								<input id="mngTelNo" name="mngTelNo" type="text" class="${textCss}  w120" ${readonly}/>
							</td>
						</tr>
						</table>
					</td>
				</tr>
			</table>	
			</form>	
	
			<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>	
		</div>
				
		<div class="eduTitle">
			<ul>
				<li>교육회차</li>
				<li class="btn_wrap">
					<a href="javascript:resetForm(2);" 			class="basic authA">초기화</a>
				</li>
			</ul>
		</div>
		
		<form id="data2Form" name="data2Form" >
		<div class="eduBox">
			<table class="table" >
			<colgroup>
				<col width="80px" />
				<col width="150px" />
				<col width="80px" />
				<col width="" />
				<col width="80px" />
				<col width="160px" />
				<col width="130px" />
				<col width="100px" />
			</colgroup>
			<tr>
				<th>회차명</th>
				<td colspan="3">
					<input id="eduEventSeq" name="eduEventSeq" type="hidden" />
					<input id="eduEventNm" name="eduEventNm" type="text" class="${textCss} w100p ${required}" ${readonly} />
				</td>
				<th>회차상태</th>
				<td><select id="eduEvtStatusCd" name="eduEvtStatusCd" class="${selectCss} ${required} " ${disabled}/></td>
				<th>결과보고SKIP</th>
				<td><input type="checkbox" id="resultAppSkipYn" name="resultAppSkipYn" style="vertical-align:middle;" value="Y" ${radioDisabled}/></td>
			</tr>
			<tr>
				<th>교육장소</th>
				<td colspan="3"><input id="eduPlace" name="eduPlace" type="text" class="${textCss} w100p " ${readonly}/></td>
				<th>수강인원</th>
				<td><input id="maxPerson" name="maxPerson" type="text" class="${textCss} right w30 " ${readonly}/> 명</td>
				<th>교육만족도조사SKIP</th>
				<td><input type="checkbox" id="eduSatiSkipYn" name="eduSatiSkipYn" style="vertical-align:middle;"  value="Y" ${radioDisabled}/></td>
			</tr>
			</table>
	
			<table style="width:100%">
				<colgroup>
					<col width="25%"/>
					<col width="25%"/>
					<col width=""/>
				</colgroup>
				<tr>
					<td style="padding-right:10px">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt">교육신청기간</li>
								</ul>
							</div>
						</div>
						<table class="table">
						<colgroup>
							<col width="70px" />
							<col width="" />
						</colgroup>
						<tr>
							<th>신청일</th>
							<td>
								<input id="applSYmd" name="applSYmd" type="text" class="${dateCss} center w80 ${required}" ${readonly} />
							</td>
							</tr>
							<tr>
							<th>마감일</th>
							<td>
								<input id="applEYmd" name="applEYmd" type="text" class="${dateCss} center w80 ${required}" ${readonly} />
							</td>
						</tr>
						</table>
					</td>
					<td>
						<div class="inner" >
							<div class="sheet_title">
								<ul>
									<li class="txt">교육기간</li>
								</ul>
							</div>
						</div>
						<table class="table">
							<colgroup>
								<col width="70px" />
								<col width="" />
							</colgroup>
							<tr>
								<th>시작일</th>
								<td>
									<input id="eduSYmd" name="eduSYmd" type="text" class="${dateCss} center w80  ${required}" ${readonly} />
								</td>
							</tr>
							<tr>
								<th>종료일</th>
								<td>
									<input id="eduEYmd" name="eduEYmd" type="text" class="${dateCss} center w80 ${required}" ${readonly} />
								</td>
							</tr>
						</table>
					</td>
					<td style="padding-left:10px">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt">교육시간</li>
								</ul>
							</div>
						</div>
						<table class="table">
						<colgroup>
							<col width="70px" />
							<col width="" />
							<col width="70px" />
							<col width="" />
						</colgroup>
						<tr>
							<th>시작시간</th>
							<td>
								<input id="eduSHm" name="eduSHm" type="text" class="${textCss}  center w50" ${readonly}/>
							</td>
							<th>총 일수</th>
							<td>
								<input id="eduDay" name="eduDay" type="text" class="${textCss}  right w30" ${readonly}/> 일
							</td>
						</tr>
						<tr>
							<th>종료시간</th>
							<td>
								<input id="eduEHm" name="eduEHm" type="text" class="${textCss}  center w50" ${readonly}/>
							</td>
							<th>총 시간</th>
							<td>
								<input id="eduHour" name="eduHour" type="text" class="${textCss}  right w30" ${readonly}/> 시간
							</td>
						</tr>
						</table>
					</td>
				</tr>
			</table>
			<table style="width:100%">
			<colgroup>
				<col width="50%" />
				<col width="50%" />
			</colgroup>
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt">교육비</li>
						</ul>
						</div>
					</div>
					<table class="table">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="" />
						</colgroup>
						<tr>
							<th>통화</th>
							<td>
								<select id="currencyCd" name="currencyCd" class="${selectCss} " ${disabled} ></select>
							</td>
							<th>실교육비</th>
							<td>
								<input id="realExpenseMon" name="realExpenseMon" type="text" class="${textCss}  w30p" ${readonly}/>
							</td>
						</tr>	
						<tr>
							<th>고용보험</th>
							<td>
								<select id="laborApplyYn" name="laborApplyYn" class="${selectCss} " ${disabled} >
									<option value="N">미환급</option>
									<option value="Y">환급</option>
								</select>
							</td>
							<th>환급금액</th>
							<td>
								<input id="laborMon" name="laborMon" type="text" class="${textCss}  w30p" ${readonly}/>
							</td>
						</tr>
						<tr class="hide">
							<th>인당교육비</th>
							<td colspan="3">
								<input id="perExpenseMon" name="perExpenseMon" type="text" class="${textCss}  w30p" ${readonly}/>
							</td>
						</tr>
					</table>
				</td>
				<td style="vertical-align:top; padding-left:10px">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt">보상</li>
						</ul>
						</div>
					</div>
					<table class="table">
						<colgroup>
							<col width="70px" />
							<col width="" />
						</colgroup>
						<tr>
							<th>보상종류</th>
							<td>
								<select id="eduRewardCd" name="eduRewardCd" class="${selectCss}" ${disabled} />
							</td>
						</tr>
						<tr>
							<th>내역</th>
							<td>
								<input id="eduRewardCnt" name="eduRewardCnt" type="text" class="${textCss} w30" ${readonly}/>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
		
		</div>	
		</form>

		<div class="eduBox2">
			<table class="sheet_main" >
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='eduEventMgrPopV9' mdef='강사 내역'/></li>
								<li class="btn">
									<a href="javascript:doAction1('Search')" class="basic authA">조회</a>
									<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100px","${ssnLocaleCd}"); </script>
				</td>
			</tr>
			</table>
		</div>
		
	</div> <!-- popup_main -->
	</div> <!-- popup_main_box -->
	<div class="popup_button">
		<ul>
			<li>
				<a href="javascript:saveData(1);" class="pink large authA">수정저장</a>
				<a href="javascript:saveData(2);" class="pink large authA">신규저장(회차)</a>
				<a href="javascript:p.self.close();" class="gray large authR">닫기</a>
			</li>
		</ul>
	</div>
</div>

</body>
</html>
