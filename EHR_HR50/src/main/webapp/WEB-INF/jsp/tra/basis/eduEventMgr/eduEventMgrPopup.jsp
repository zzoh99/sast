<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>교육회차관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
/*
html, body {
	overflow:auto;
}
*/
.overAuto {overflow:auto;}
</style>
<script type="text/javascript">
	
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	
	/*
	 * sheet Init
	 */
	$(function(){
	
		 var initdata = {};
			initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				
				{Header:"교육과정순번(TTRA101)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSeq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"교육과정별회차순번(TTRA121)",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduEventSeq",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='eduEventNm' mdef='회차명'/>",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduEventNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='teacherNo' mdef='강사번호'/>",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
				{Header:"<sht:txt mid='teacherNmV1' mdef='강사성명'/>",					Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
				{Header:"<sht:txt mid='lecture' mdef='강의과목'/>",					Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"subjectLecture",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
				{Header:"<sht:txt mid='telNo' mdef='연락처'/>",						Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20, AcceptKeys:"N|[-]" },
				{Header:"강의료",						Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"lectureFee",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",						Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
				{Header:"교육과정별회차_강사순번",			Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
				
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");
		
		$(window).smartresize(sheetResize); sheetInit();
	});
	
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회

			sheet1.DoSearch( "${ctx}/EduEventMgr.do?cmd=getEduEventLecturerPopupList", $("#srchFrm").serialize());
			break;
		case "Save": //저장
			IBS_SaveName(document.srchFrm, sheet1);
			sheet1.DoSave( "${ctx}/EduEventMgr.do?cmd=saveEduEventLecturerPopup", $( "#srchFrm").serialize());
			break;

		case "Insert": //입력

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "eduSeq", $("#eduSeq").val());
			sheet1.SetCellValue(Row, "eduEventSeq", $("#eduEventSeq").val());

			break;

		case "Copy": //행복사

			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "eduEventSeq", "");

			sheet1.SelectCell(Row, "eduEventNm");
			break;

		case "Down2Excel": //엑셀내려받기

			sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
			break;

		}
	}

	$(function() {
		if ("${authPg}" == "R") {
			$("a#uploadBtn").hide();
			$("a#deleteBtn").hide();
			$("div#DIV_mainUpload").hide();
		}

		$('#lecturerCost').mask('000,000,000,000,000', { reverse : true });
		$('#establishmentCost').mask('000,000,000,000,000', { reverse : true });
		$('#foodCost').mask('000,000,000,000,000', { reverse : true });
		$('#transpCost').mask('000,000,000,000,000', { reverse : true });
		$('#eduRewardCnt').on("keyup", function(e) { $(this).val($(this).val().replace(/[^0-9.]/g, "")); });
		$('#perExpenseMon').mask('000,000,000,000,000', { reverse : true });
		$('#laborMon').mask('000,000,000,000,000', { reverse : true });
		$('#realExpenseMon').mask('000,000,000,000,000', { reverse : true });
		
		$('#maxPerson').mask('000');
		
		$("#eduSHm").mask("24:59", { reverse : true });
		$("#eduEHm").mask("24:59", { reverse : true });
		
		if ("${authPg}" == "A") {
			$("#eduSYmd").datepicker2({ startdate : "eduEYmd" });
			$("#eduEYmd").datepicker2({ enddate : "eduSYmd" });
			
			$("#applSYmd").datepicker2({ startdate : "applEYmd" });
			$("#applEYmd").datepicker2({ enddate : "applSYmd" });
			
		}
		
		var eduStatusCd = convCode(codeList( "${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10190"), ""); //회차상태
		var currencyCd = convCode(codeList( "${ctx}/CommonCode.do?cmd=getCommonCodeList", "S10030"), "");//통화단위
		var eduRewardCd = convCode(codeList( "${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10110"), " ");
		var comboLaborApplyYn = convCode([ { codeNm : "YES", code : "Y" }, { codeNm : "NO", code : "N" } ], "");
		var comboInnerYn = convCode([ { codeNm : "YES", code : "Y" }, { codeNm : "NO", code : "N" } ], "");
		
		$("#eduStatusCd").html(eduStatusCd[2]);
		$("#currencyCd").html(currencyCd[2]);
		$("#eduRewardCd").html(eduRewardCd[2]);
		$("#laborApplyYn").html(comboLaborApplyYn[2]);
		$("#innerYn").html(comboInnerYn[2]);
		
		var arg = p.popDialogArgumentAll();
		
		var eduSeq = arg["eduSeq"];
		var eduCourseNm = arg["eduCourseNm"];
		var eduCourseSub = arg["eduCourseSub"];
		var eduEventSeq = arg["eduEventSeq"];
		var eduEventNm = arg["eduEventNm"];
		var eduStatusCd = arg["eduStatusCd"];
		var eduOrgCd = arg["eduOrgCd"];
		var eduOrgNm = arg["eduOrgNm"];
		var eduPlace = arg["eduPlace"];
		var eduPlaceEtc = arg["eduPlaceEtc"];
		var eduDay = arg["eduDay"];
		var eduHour = arg["eduHour"];
		var eduSYmd = arg["eduSYmd"];
		var eduSHm = arg["eduSHm"];
		var eduEYmd = arg["eduEYmd"];
		var eduEHm = arg["eduEHm"];
		var applSYmd = arg["applSYmd"];
		var applEYmd = arg["applEYmd"];
		var minPerson = arg["minPerson"];
		var maxPerson = arg["maxPerson"];
		var lecturerCost = arg["lecturerCost"];
		var establishmentCost = arg["establishmentCost"];
		var foodCost = arg["foodCost"];
		var transpCost = arg["transpCost"];

		var currencyCd = arg["currencyCd"];
		var perExpenseMon = arg["perExpenseMon"];
		var totExpenseMon = arg["totExpenseMon"];
		var laborApplyYn = arg["laborApplyYn"];
		var laborMon = arg["laborMon"];
		var realExpenseMon = arg["realExpenseMon"];
		var innerYn = arg["innerYn"];
		var chargeSabun = arg["chargeSabun"];
		var chargeName = arg["chargeName"];
		var orgCd = arg["orgCd"];
		var orgNm = arg["orgNm"];
		var telNo = arg["telNo"];
		var lecturerNm = arg["lecturerNm"];
		var lecturerTelNo = arg["lecturerTelNo"];

		var eduRewardCd = arg["eduRewardCd"];
		var eduRewardCnt = arg["eduRewardCnt"];

		$("#eduSeq").val(eduSeq);
		$("#eduCourseNm").val(eduCourseNm);
		$("#eduCourseSub").val(eduCourseSub);
		$("#eduEventSeq").val(eduEventSeq);
		$("#eduEventNm").val(eduEventNm);
		$("#eduStatusCd").val(eduStatusCd);
		$("#eduOrgCd").val(eduOrgCd);
		$("#eduOrgNm").val(eduOrgNm);
		$("#eduPlace").val(eduPlace);
		$("#eduPlaceEtc").val(eduPlaceEtc);
		$("#eduDay").val(eduDay);
		$("#eduHour").val(eduHour);
		$("#eduSYmd").val(eduSYmd);
		$("#eduSHm").val(eduSHm);
		$("#eduEYmd").val(eduEYmd);
		$("#eduEHm").val(eduEHm);
		$("#applSYmd").val(applSYmd);
		$("#applEYmd").val(applEYmd);
		$("#minPerson").val(minPerson);
		$("#maxPerson").val(maxPerson);
		$("#lecturerCost").val(addComma(lecturerCost));
		$("#establishmentCost").val(addComma(establishmentCost));
		$("#foodCost").val(addComma(foodCost));
		$("#transpCost").val(addComma(transpCost));
		$("#currencyCd").val(currencyCd);
		$("#perExpenseMon").val(addComma(perExpenseMon));
		$("#totExpenseMon").val(addComma(totExpenseMon));
		$("#laborApplyYn").val(laborApplyYn);
		$("#laborMon").val(addComma(laborMon));
		$("#realExpenseMon").val(addComma(realExpenseMon));
		$("#innerYn").val(innerYn);
		$("#chargeSabun").val(chargeSabun);
		$("#chargeName").val(chargeName);
		$("#orgCd").val(orgCd);
		$("#orgNm").val(orgNm);
		$("#telNo").val(telNo);
		$("#lecturerNm").val(lecturerNm);
		$("#lecturerTelNo").val(lecturerTelNo);
		$("#eduRewardCd").val(eduRewardCd);
		$("#eduRewardCnt").val(eduRewardCnt);

		$("#fileSeq").val(arg["fileSeq"]);
		upLoadInit($("#fileSeq").val(), "");

		//Cancel 버튼 처리
		$(".close").click(function() {
			p.self.close();
		});

		doAction1("Search");
		
		// 필수값 체크
		var msg = {};
		//msg.chk = "체크해주세요";
		setValidate($("#srchFrm"), msg);

	});

	function setValue() {
		$("#srchFrm>#fileSeq").val($("#uploadForm>#fileSeq").val());
		/* IBLeader > ibupload 모듈 사용으로 인한 주석 처리..
		if (supSheet.RowCount() == 0) {
			$("#srchFrm>#fileSeq").val("");
		}
		*/
		var attFileCnt = $('#myUpload').IBUpload('fileList');
		if (attFileCnt == 0) {
			$("#srchFrm>#fileSeq").val("");
		}

		if (!$("#srchFrm").valid())
			return;

		var rv = new Array(41);
		rv["eduSeq"] = $("#eduSeq").val();
		rv["eduCourseNm"] = $("#eduCourseNm").val();
		rv["eduCourseSub"] = $("#eduCourseSub").val();
		rv["eduEventSeq"] = $("#eduEventSeq").val();
		rv["eduEventNm"] = $("#eduEventNm").val();
		rv["eduStatusCd"] = $("#eduStatusCd").val();
		rv["eduOrgCd"] = $("#eduOrgCd").val();
		rv["eduOrgNm"] = $("#eduOrgNm").val();
		rv["eduPlace"] = $("#eduPlace").val();
		rv["eduPlaceEtc"] = $("#eduPlaceEtc").val();
		rv["eduDay"] = $("#eduDay").val();
		rv["eduHour"] = $("#eduHour").val();
		rv["eduSYmd"] = $("#eduSYmd").val();
		rv["eduSHm"] = $("#eduSHm").val();
		rv["eduEYmd"] = $("#eduEYmd").val();
		rv["eduEHm"] = $("#eduEHm").val();
		rv["applSYmd"] = $("#applSYmd").val();
		rv["applEYmd"] = $("#applEYmd").val();
		rv["minPerson"] = $("#minPerson").val();
		rv["maxPerson"] = $("#maxPerson").val();
		rv["lecturerCost"] = $("#lecturerCost").val();
		rv["establishmentCost"] = $("#establishmentCost").val();
		rv["foodCost"] = $("#foodCost").val();
		rv["transpCost"] = $("#transpCost").val();
		rv["currencyCd"] = $("#currencyCd").val();
		rv["perExpenseMon"] = $("#perExpenseMon").val();
		rv["totExpenseMon"] = $("#totExpenseMon").val();
		rv["laborApplyYn"] = $("#laborApplyYn").val();
		rv["laborMon"] = $("#laborMon").val();
		rv["realExpenseMon"] = $("#realExpenseMon").val();
		rv["innerYn"] = $("#innerYn").val();
		rv["chargeSabun"] = $("#chargeSabun").val();
		rv["chargeName"] = $("#chargeName").val();
		rv["orgCd"] = $("#orgCd").val();
		rv["orgNm"] = $("#orgNm").val();
		rv["telNo"] = $("#telNo").val();
		rv["lecturerNm"] = $("#lecturerNm").val();
		rv["lecturerTelNo"] = $("#lecturerTelNo").val();
		rv["eduRewardCd"] = $("#eduRewardCd").val();
		rv["eduRewardCnt"] = $("#eduRewardCnt").val();
		rv["fileSeq"] = $("#fileSeq").val();
		rv["eduMBranchCd"] = $("#eduMBranchCd").val();
		rv["eduBranchCd"] = $("#eduBranchCd").val();

		p.popReturnValue(rv);
		p.window.close();
	}

	function addComma(n) {
		if (isNaN(n)) {
			return 0;
		}
		var reg = /(^[+-]?\d+)(\d{3})/;
		n += '';
		while (reg.test(n))
			n = n.replace(reg, '$1' + ',' + '$2');
		return n;
	}

	//교육과정 팝업
	function doSearchEduCourseNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "eduCoursePopup";

		openPopup("${ctx}/Popup.do?cmd=eduCoursePopup&authPg=R", "", "550", "520");
	}

	function employeePopup() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "employeePopup";

		openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "840", "520");
	}

	function orgSearchPopup() {
		try {
			if (!isPopup()) {
				return;
			}

			var args = new Array();

			gPRow = "";
			pGubun = "orgBasicPopup";

			openPopup("${ctx}/Popup.do?cmd=orgBasicPopup", args, "740", "520");
			
		} catch (ex) {
			alert("Open Popup Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "eduCoursePopup") {
			$("#eduCourseNm").val(rv["eduCourseNm"]);
			$("#eduSeq").val(rv["eduSeq"]);

			$("#eduOrgCd").val(rv["eduOrgCd"]);
			$("#eduOrgNm").val(rv["eduOrgNm"]); //교육기관
			$("#eduSYmd").val(rv["eduSYmd"]);
			$("#eduSYmd").focus();
			$("#eduSYmd").blur(); //교육시작일
			$("#eduEYmd").val(rv["eduEYmd"]);
			$("#eduEYmd").focus();
			$("#eduEYmd").blur(); //교육종료일
			$("#maxPerson").val(rv["maxPerson"]); //교육인원
			$("#eduDay").val(rv["eduTerm"]); //교육기간
			$("#eduHour").val(rv["eduHour"]); //총시간
			//진행언어
			$("#eduRewardCd").val(rv["eduRewardCd"]); //보상종류
			$("#eduRewardCnt").val(rv["eduRewardCnt"]); //보상내역
			$("#chargeName").val(rv["chargeName"]); //담당자성명
			//담당자사번
			$("#orgNm").val(rv["orgNm"]); //조직명
			$("#orgCd").val(rv["orgCd"]); //조직코드

			$("#eduMBranchCd").val(rv["eduMBranchCd"]); //조직코드
			$("#eduBranchCd").val(rv["eduBranchCd"]); //조직코드
		} else if (pGubun == "employeePopup") {
			$("#chargeName").val(rv["name"]);
			$("#orgNm").val(rv["orgNm"]);
			$("#telNo").val(rv["officeTel"]);
			$("#orgCd").val(rv["orgCd"]);
		} else if (pGubun == "orgBasicPopup") {
			$("#orgNm").val(rv["orgNm"]);
			$("#orgCd").val(rv["orgCd"]);
		} else 	if(pGubun == "viewEduEventLecturerNmPopup"){

			sheet1.SetCellValue(gPRow, "teacherSeq",		rv["teacherSeq"] );
			sheet1.SetCellValue(gPRow, "teacherGb",			rv["teacherGb"] );
			sheet1.SetCellValue(gPRow, "teacherNo",			rv["teacherNo"] );
			sheet1.SetCellValue(gPRow, "teacherNm",			rv["teacherNm"] );
			sheet1.SetCellValue(gPRow, "telNo",				rv["telNo"] );
			sheet1.SetCellValue(gPRow, "subjectLecture",	rv["subjectLecture"] );
			sheet1.SetCellValue(gPRow, "lectureFee",		rv["lectureFee"] );
		}
	}

	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				location.href = "/JSP/ErrorPage.jsp?errorMsg=" + ErrMsg;
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}
	
	function sheet1_OnPopupClick(Row, Col){
		try{


			if(sheet1.ColSaveName(Col) == "teacherNm"){
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "viewEduEventLecturerNmPopup";

				var args	= new Array();
				args["eduSeq"]	= sheet1.GetCellValue( Row, "eduSeq" );

				openPopup("/EduEventMgr.do?cmd=viewEduEventLecturerNmPopup", args, "550","520");
			}
		}catch(ex){
			alert("OnPopupClick Event Error : " + ex);
		}
	}
</script>
</head>
<body>

<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='eduEventMgrPop' mdef='교육회차관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='eduEventMgrPopV1' mdef='교육과정 기본내역'/></li>
			</ul>
			</div>
		</div>

		<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="eduMBranchCd" name="eduMBranchCd" />
		<input type="hidden" id="eduBranchCd" name="eduBranchCd" />
		<input type="hidden" id="fileSeq" name="fileSeq" />

		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='104168' mdef='과정명'/></th>
				<td  colspan="5">
					<input id="eduSeq" name="eduSeq" type="hidden" class="text w100p"/>
					<input id="eduCourseNm" name="eduCourseNm" type="text" class="text readonly w90p required" validator="required" vtxt="과정명" readonly/>
					<a href="javascript:doSearchEduCourseNm();" class="button6 authA" id="btnEduCourseCd" ><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>

			<tr>
				<th><tit:txt mid='104070' mdef='회차명'/></th>
				<td colspan="5">
					<input id="eduEventSeq" name="eduEventSeq" type="hidden" class="text w100p"/>
					<input id="eduEventNm" name="eduEventNm" type="text" class="text w100p ${readonly} required" ${readonly} validator="required" vtxt="회차명"/>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104075' mdef='회차상태'/></th>
				<td >
					<select id="eduStatusCd" name="eduStatusCd" class="${readonly} required" ${disabled} />
				</td>
				<th><tit:txt mid='201705160000121' mdef='수강인원'/></th>
				<td><input id="maxPerson" name="maxPerson" type="text" class="text right w30 ${readonly}" ${readonly}/> 명</td>
			</tr>
			<tr>
				<th><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></th>
				<td>
					<input id="eduOrgCd" name="eduOrgCd" type="hidden" class="text"/>
					<input id="eduOrgNm" name="eduOrgNm" type="text" class="text w100p readonly" readonly/>
				</td>
				<th><tit:txt mid='104078' mdef='교육장소'/></th>
				<td><input id="eduPlace" name="eduPlace" type="text" class="text w100p ${readonly}" ${readonly}/></td>
			</tr>
		</table>

		<table style="width:100%">
			<colgroup>
				<col width="30%"/>
				<col width="20%"/>
				<col width="20%"/>
				<col width="30%"/>
			</colgroup>
			<tr>
				<td>
				<div class="inner" >
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='eduEventMgrPopV2' mdef='교육기간'/></li>
						</ul>
					</div>
				</div>
				<table class="table">
					<colgroup>
						<col width="30%">
						<col width="*">
					</colgroup>
					<tr>
						<th><tit:txt mid='104497' mdef='시작일'/></th>
						<td>
							<input id="eduSYmd" name="eduSYmd" type="text" class="date2 center w70p ${readonly} required" ${readonly} validator="required" vtxt="시작일"/>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='111909' mdef='종료일'/></th>
						<td>
							<input id="eduEYmd" name="eduEYmd" type="text" class="date2 center w70p ${readonly} required" ${readonly} validator="required" vtxt="종료일"/>
						</td>
					</tr>
				</table>
				</td>
				<td style="padding-left:10px">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='eduEventMgrPopV3' mdef='교육시간'/></li>
						</ul>
					</div>
				</div>
				<table class="table">
					<tr>
						<th><tit:txt mid='104061' mdef='시작시간'/></th>
						<td>
							<input id="eduSHm" name="eduSHm" type="text" class="text center w50 ${readonly}" ${readonly}/>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104553' mdef='종료시간'/></th>
						<td>
							<input id="eduEHm" name="eduEHm" type="text" class="text center w50 ${readonly}" ${readonly}/>
						</td>
					</tr>
				</table>
				</td>
				<td style="padding-left:10px">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='eduEventMgrPopV4' mdef='총시간'/></li>
						</ul>
					</div>
				</div>
				<table class="table">
						<tr>
							<th>교육일</th>
							<td>
								<input id="eduDay" name="eduDay" type="text" class="text right w30 ${readonly}" ${readonly}/> 일
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='eduEventMgrPopV3' mdef='교육시간'/></th>
							<td>
								<input id="eduHour" name="eduHour" type="text" class="text right w30 ${readonly}" ${readonly}/> 시간
							</td>
						</tr>
					</table>
				</td>
				<td style="padding-left:10px">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">교육신청</li>
						</ul>
					</div>
				</div>
				<table class="table">
					<tr>
					<th><tit:txt mid='104389' mdef='신청일'/></th>
					<td>
						<input id="applSYmd" name="applSYmd" type="text" class="date2 center w60p ${readonly} required" ${readonly} validator="required"/>
					</td>
					</tr>
					<tr>
					<th><tit:txt mid='titCloseDate' mdef='마감일'/></th>
					<td>
						<input id="applEYmd" name="applEYmd" type="text" class="date2 center w60p ${readonly} required" ${readonly} validator="required"/>
					</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>

		<table style="width:100%">
			<colgroup>
				<col width="40%" />
				<col width="25%" />
				<col width="35%" />
			</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='eduEventMgrPopV6' mdef='교육비'/></li>
					</ul>
					</div>
				</div>
				<table class="table">
					<tr>
						<th><tit:txt mid='114146' mdef='통화'/></th>
						<td>
							<select id="currencyCd" name="currencyCd" class="${readonly}" ${disabled} />
						</td>
						<th><tit:txt mid='eduAppDetOutSideV3' mdef='교육비용'/></th>
						<td>
							<input id="perExpenseMon" name="perExpenseMon" type="text" class="text w30p ${readonly}" ${readonly}/>
						</td>
					<tr>
						<th><tit:txt mid='104458' mdef='고용보험적용여부'/></th>
						<td>
							<select id="laborApplyYn" name="laborApplyYn" class="${readonly}" ${disabled} />
						</td>
						<th><tit:txt mid='114147' mdef='환급금액'/></th>
						<td>
							<input id="laborMon" name="laborMon" type="text" class="text w30p ${readonly}" ${readonly}/>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='titActExpn' mdef='실교육비'/></th>
						<td colspan="3">
							<input id="realExpenseMon" name="realExpenseMon" type="text" class="text w50p ${readonly}" ${readonly}/>
						</td>
					</tr>
				</table>
			</td>
			<td style="vertical-align:top; padding-left:10px">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='eduEventMgrPopV7' mdef='담당내역'/></li>
					</ul>
					</div>
				</div>
				<table class="table">
					<tr>
						<th><tit:txt mid='manager' mdef='담당자'/></th>
						<td>
							<input id="chargeName" name="chargeName" type="text" class="text w30p ${readonly}" ${readonly}/>
							<a href="javascript:employeePopup();" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='103968' mdef='담당부서'/></th>
						<td>
							<input id="orgNm" name="orgNm" type="text" class="text w30p ${readonly}" ${readonly}/>
							<input type="hidden" id="orgCd" name="orgCd" value="" />
							<a onclick="javascript:orgSearchPopup();return false;" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='contact' mdef='연락처'/></th>
						<td>
							<input id="telNo" name="telNo" type="text" class="text w30p ${readonly}" ${readonly}/>
						</td>
					</tr>
				</table>
			</td>
			<td style="vertical-align:top; padding-left:10px">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='eduEventMgrPopV8' mdef='보상'/></li>
					</ul>
					</div>
				</div>
				<table class="table">
					<tr>
						<th><tit:txt mid='titRewardType' mdef='보상종류'/></th>
						<td>
							<select id="eduRewardCd" name="eduRewardCd" class="${readonly}" ${disabled} />
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='titRewardDetails' mdef='내역'/></th>
						<td>
							<input id="eduRewardCnt" name="eduRewardCnt" type="text" class="text w100p ${readonly}" ${readonly}/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</table>
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduEventMgrPopV9' mdef='강사 내역'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search')" css="button" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>

							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "150px","${ssnLocaleCd}"); </script>
			</td>
		</tr>
		</table>

			<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
