<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<title>개인업무(TASK)상세</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var authPg	= "${authPg}";
	
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();

	$(function(){
		//리스트 화면에서 넘어온값 셋팅(상세보기)
		var arg = p.popDialogArgumentAll();
		$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
		$("#searchAppStepCd").val(arg["searchAppStepCd"]); //평가단계
		$("#searchAppOrgCd").val(arg["searchAppOrgCd"]); //평가소속
		$("#searchAppSabun").val(arg["searchAppSabun"]); //평가자사번
		$("#searchAppName").val(arg["searchAppName"]); //평가자
		$("#searchSabun").val(arg["searchSabun"]); //피평가자사번
		$("#searchPriorSeq").val(arg["searchPriorSeq"]);
		$("#searchSeq").val(arg["searchSeq"]);
		$("#closeYn").val(arg["closeYn"]);	// 마감여부
		$("#searchStatusCd").val(arg["searchStatusCd"]);
		$("#adminCheck").val(arg["adminCheck"]);

		if( arg != "undefined" ) {
			authPg = arg["authPg"];

			// 팀과제
			var priorSeqList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getTeamAppPriorSeqList&searchAppraisalCd="+$('#searchAppraisalCd').val()+"&searchAppStepCd="+$('#searchAppStepCd').val()+"&searchSabun="+$('#searchSabun').val()+"&searchAppOrgCd="+$('#searchAppOrgCd').val()+"&searchAppSabun="+$('#searchAppSabun').val(),false).codeList, ""); // 평가명
			$("#priorSeq").html(priorSeqList[2]);

			$("#btnSave").show(); //저장
			$("#btnApp").hide(); //승인
			$("#btnReturn").hide(); //반려

			if (authPg == "A") {
				$("#termSdate").datepicker2({
					onReturn:function(date){
						var num = getDaysBetween(formatDate(date,""),formatDate($("#termEdate").val(),""));
						if(date != "" && $("#termEdate").val() != "") {
							if(num <= 0) {
								alert("<msg:txt mid='109757' mdef='종료일이 시작일보다 작습니다.'/>");
								$("#termEdate").val("");
							}
						}
					}
				});

				$("#termEdate").datepicker2({
					onReturn:function(date){
						var num = getDaysBetween(formatDate($("#termSdate").val(),""),formatDate(date,""));
						if($("#termSdate").val() != "" && date != "") {
							if(num <= 0) {
								alert("<msg:txt mid='109757' mdef='종료일이 시작일보다 작습니다.'/>");
								$("#termEdate").val("");
							}
						}
					}
				});

				$("#termSdate,#termEdate").blur(function(){
					var num = getDaysBetween(formatDate($("#termSdate").val(),""),formatDate($("#termEdate").val(),""));
					if(formatDate($("#termSdate").val(),"") != "" && formatDate($("#termEdate").val(),"") != "") {
						if(num <= 0) {
							alert("<msg:txt mid='109757' mdef='종료일이 시작일보다 작습니다.'/>");
							$("#termEdate").val("");
						}
					}
				});
			} else if (authPg == "R"){
				if($("#searchStatusCd").val() == "21"){
					$("#btnSave").hide(); //저장
					if($("#adminCheck").val() == "ADMIN") {
						$("#btnApp").show(); //승인
						$("#btnReturn").show(); //반려
					}
					$("#btnSabunPop").hide(); //성과관리자팝업검색커튼
					$("#btnSabunClear").hide(); //성과관리자초기화커튼
					
					$("#btnJobPop").hide(); //직무첫번째팝업검색버튼
					$("#btnJobDetailPop").hide(); //직무두번째팝업검색버튼
				}

				$("#btnSabunPop").hide(); //성과관리자팝업검색커튼
				$("#btnSabunClear").hide(); //성과관리자초기화커튼
				$("#btnJobPop").hide(); //직무첫번째팝업검색버튼
				$("#btnJobDetailPop").hide(); //직무두번째팝업검색버튼
				$("#btnSave").addClass("hide");
			}
		}

		// sheet1 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"업무명",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workTitle", 	KeyField:1},
			{Header:"상시평가방법",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"quaCd",		KeyField:1},
			{Header:"성과관리자",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workManageSabun"},
			{Header:"성과관리자",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workManageName"},
			{Header:"상시기간",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"term"},
			{Header:"상시기간단위",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"termCd"},
			{Header:"상시성과시작일자",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"termSdate"},
			{Header:"상시성과종료일자",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"termEdate"},
			{Header:"완료수준",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"completeLevel"},
			{Header:"수준_적정성",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"level1"},
			{Header:"수준_적시성",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"level2"},
			{Header:"수준_연계성",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"level3"},
			{Header:"종합수준",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"totalLevel"},
			{Header:"직무코드",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobCd"},
			{Header:"직무코드",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobNm"},
			{Header:"직무세부코드",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobDetailCd"},
			{Header:"직무세부코드",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobDetailNm"},
			{Header:"동료",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"coworker"},
			{Header:"핵심과제여부",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"keyTaskYn"},
			{Header:"상세내용",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"contents"},
			{Header:"비고",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bigo"},
			
			{Header:"평가ID",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"팀목표순번",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq", 	KeyField:1},
			{Header:"업무순번",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq", 		KeyField:1},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(false);sheet1.SetUnicodeByte(3);

		// sheet2 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='sabun_V2956' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"coworkerSabun",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='name_V3316' mdef='성명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"coworkerName",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:110 },
			{Header:"<sht:txt mid='orgNm_V3425' mdef='소속'/>",		Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm_V8' mdef='직위'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm_V8' mdef='직책'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm_V8' mdef='재직상태'/>",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"팀목표순번",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq", 		KeyField:1},
			{Header:"업무순번",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq", 			KeyField:1},
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetUnicodeByte(3);

		//Autocomplete
		$(sheet2).sheetAutocompletePap({
			Columns: [
				{
					ColSaveName  : "coworkerName",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow,"coworkerName", rv["name"]);
						sheet2.SetCellValue(gPRow,"coworkerSabun", rv["sabun"]);
						sheet2.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
						sheet2.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet2.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet2.SetCellValue(gPRow,"statusNm", rv["statusNm"]);
					}
				}
			]
		});

		$(window).smartresize(sheetResize); sheetInit();

		// 상시성과방법
		var quaCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30004"), "선택"); // 상시평가방법
		$("#quaCd").html( quaCd[2] );

		// 상시기간단위
		var termCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30002"), " "); // 상시기간단위
		$("#termCd").html( termCd[2] );

		// 상시업무수준
		var levelCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30001"), " "); // 상시업무수준
		$("#level1").html( levelCd[2] );
		$("#level2").html( levelCd[2] );
		$("#level3").html( levelCd[2] );
		$("#totalLevel").html( levelCd[2] );

		//직무콤보 조회
		//var jobCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getJobCdList",false).codeList, " "); // 직무명
		//$("#jobCd").html(jobCdList[2]);
		//$("#jobDetailCd").html(jobCdList[2]);

		$("#completeLevel").maxbyte(4000); //완료수준
		$("#contents").maxbyte(4000); //상세내용

		// 닫기 버튼
		$(".close").click(function() 	{
			p.self.close();
		});

		// 숫자만 입력가능
		$("#term").keyup(function() {
			makeNumber(this,'A');
			if($("#term").val() == "") {
				$("#termCd").attr("disabled","disabled");
			}else{
				$("#termCd").removeAttr("disabled","disabled");
			}
			$("#termSdate").val("");
			$("#termEdate").val("");
			$("#termCd").val("");
		});
		
		//정성/정량이 선택되지 않았을 경우 기간과 기간일자가 입력되지 않게 처리
		if($("#quaCd").val() == "") {
			$("#termSdate").val("");
			$("#termEdate").val("");
			$("#termSdate").addClass("readonly").attr("readOnly","readOnly");
			$("#termEdate").addClass("readonly").attr("readOnly","readOnly");
			$(".ui-datepicker-trigger").hide();
			$("#term").val("");
			$("#termCd").val("");
			$("#term").addClass("readonly").attr("readOnly","readOnly");
			$("#termCd").attr("disabled","disabled");
		}
			
		// 정성/정량 선택 시
		$("#quaCd").change(function(){
			//기간 readonly처리
			if($("#quaCd").val() == "20"){ //정량 : 기간,기간일자 활성화
				$("#termSdate").val("");
				$("#termEdate").val("");
				$("#term").removeClass("readonly").removeAttr("readOnly","readOnly");
				if($("#term").val() == "") {
					$("#termCd").attr("disabled","disabled");
				}
				$("#termSdate").addClass("readonly").attr("readOnly","readOnly");
				$("#termEdate").addClass("readonly").attr("readOnly","readOnly");
				$(".ui-datepicker-trigger").hide();
			} else if($("#quaCd").val() == "10"){ //정성
				$("#term").val("");
				$("#termCd").val("");
				$("#term").addClass("readonly").attr("readOnly","readOnly");
				$("#termCd").attr("disabled","disabled");
				$("#termSdate").removeClass("readonly").removeAttr("readOnly","readOnly");
				$("#termEdate").removeClass("readonly").removeAttr("readOnly","readOnly");
				$(".ui-datepicker-trigger").show();
			} else {
				$("#termSdate").val("");
				$("#termEdate").val("");
				$("#termSdate").addClass("readonly").attr("readOnly","readOnly");
				$("#termEdate").addClass("readonly").attr("readOnly","readOnly");
				$(".ui-datepicker-trigger").hide();
				$("#term").val("");
				$("#termCd").val("");
				$("#term").addClass("readonly").attr("readOnly","readOnly");
				$("#termCd").attr("disabled","disabled");
			}
		});
		
		// 기간 선택 시
		$("#termCd").change(function(){
			if($("#term").val() != "" && $("#termCd").val() != ""){
				var term = $("#term").val();
				var termCd = $("#termCd").val();
				if(termCd == "10"){ //연
					if(term == 0 || term > 1){
						alert("<msg:txt mid='2023082801333' mdef='1년만 입력 가능합니다.'/>");
						return;
					} else {
						$("#termSdate").val(formatDate(y+"0101","-"));
						$("#termEdate").val(formatDate(y+"1231","-"));
					}
				} else if(termCd == "20"){ //분기
					if(term == 0 || term > 4){
						alert("<msg:txt mid='2023082801332' mdef='4분기까지 입력 가능합니다.'/>");
						return;
					} else {
						if(term == 1){
							var sMonth = "01";
							var eMonth = "03";
							$("#termSdate").val(formatDate(y + sMonth + "01","-"));
							$("#termEdate").val(formatDate(y + eMonth + getMonthEndDate(y, eMonth),"-"));
						} else if(term == 2){
							var sMonth = "04";
							var eMonth = "06";
							$("#termSdate").val(formatDate(y + sMonth + "01","-"));
							$("#termEdate").val(formatDate(y + eMonth + getMonthEndDate(y, eMonth),"-"));
						} else if(term == 3){
							var sMonth = "07";
							var eMonth = "09";
							$("#termSdate").val(formatDate(y + sMonth + "01","-"));
							$("#termEdate").val(formatDate(y + eMonth + getMonthEndDate(y, eMonth),"-"));
						} else if(term == 4){
							var sMonth = "10";
							var eMonth = "12";
							$("#termSdate").val(formatDate(y + sMonth + "01","-"));
							$("#termEdate").val(formatDate(y + eMonth + getMonthEndDate(y, eMonth),"-"));
						}
					}
				} else if(termCd == "30"){ //월
					if(term == 0 || term > 12){
						alert("<msg:txt mid='2023082801331' mdef='1~12월까지 입력 가능합니다.'/>");
						return;
					} else {
						if(term.length == 1){
							term = "0"+term;
						}
						$("#termSdate").val(formatDate(y + term + "01","-"));
						$("#termEdate").val(formatDate(y + term + getMonthEndDate(y, term),"-"));
					}
				}
			} else {
				$("#termSdate").val("");
				$("#termEdate").val("");
			}
		});
		
		// 수준 선택 시
		$("#level1, #level2, #level3").change(function(){
			var lv_1 = 0;
			var lv_2 = 0;
			var lv_3 = 0;
			var tot_lv = 0;
			
			if($("#level1").val() != "" && $("#level2").val() != "" && $("#level3").val() != ""){
				lv_1 = $("#level1").val();
				lv_2 = $("#level2").val();
				lv_3 = $("#level3").val();
				
				tot_lv = Round((parseInt(lv_1) + parseInt(lv_2) + parseInt(lv_3)) / 3, 0);
				$("#totalLevel").val(tot_lv); //종합수준
			}
		});

		doAction1("Search");
	});
	
	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegDet1", $("#srchFrm").serialize() );
			break;
		}
	}

	// Sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			setSheetToForm();

			doAction2("Search");

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// Sheet1 -> Form 데이터 처리
	function setSheetToForm() {
		if(sheet1.RowCount() == 0) {
			$("#workManageSabun").val($("#searchAppSabun").val()); //평가자사번
			$("#workManageName").val($("#searchAppName").val()); //평가자
		} else {
			$("#priorSeq").val(sheet1.GetCellValue(sheet1.LastRow(), "priorSeq"));
			$("#seq").val(sheet1.GetCellValue(sheet1.LastRow(), "seq"));
			$("#workTitle").val(sheet1.GetCellValue(sheet1.LastRow(), "workTitle"));
			$("#quaCd").val(sheet1.GetCellValue(sheet1.LastRow(), "quaCd"));
			$("#workManageSabun").val(sheet1.GetCellValue(sheet1.LastRow(), "workManageSabun"));
			$("#workManageName").val(sheet1.GetCellValue(sheet1.LastRow(), "workManageName"));
			$("#term").val(sheet1.GetCellValue(sheet1.LastRow(), "term"));
			$("#termCd").val(sheet1.GetCellValue(sheet1.LastRow(), "termCd"));
			$("#termSdate").val(sheet1.GetCellValue(sheet1.LastRow(), "termSdate"));
			$("#termEdate").val(sheet1.GetCellValue(sheet1.LastRow(), "termEdate"));
			$("#completeLevel").val(sheet1.GetCellValue(sheet1.LastRow(), "completeLevel"));
			$("#level1").val(sheet1.GetCellValue(sheet1.LastRow(), "level1"));
			$("#level2").val(sheet1.GetCellValue(sheet1.LastRow(), "level2"));
			$("#level3").val(sheet1.GetCellValue(sheet1.LastRow(), "level3"));
			$("#totalLevel").val(sheet1.GetCellValue(sheet1.LastRow(), "totalLevel"));
			$("#jobCd").val(sheet1.GetCellValue(sheet1.LastRow(), "jobCd"));
			$("#jobDetailCd").val(sheet1.GetCellValue(sheet1.LastRow(), "jobDetailCd"));
			$("#jobNm").val(sheet1.GetCellValue(sheet1.LastRow(), "jobNm"));
			$("#jobDetailNm").val(sheet1.GetCellValue(sheet1.LastRow(), "jobDetailNm"));
			$("#contents").val(sheet1.GetCellValue(sheet1.LastRow(), "contents"));

			if(sheet1.GetCellValue(sheet1.LastRow(),"keyTaskYn") == "Y") {
				$("#keyTaskYn").attr("checked",true);
			} else {
				$("#keyTaskYn").attr("checked",false);
			}
		}
	}

	// Form -> Sheet1 데이터 처리
	function setFormToSheet() {
		var row = "";

		if(sheet1.RowCount() == 0) {
			row = sheet1.DataInsert();

			// 업무순번 조회
			var resultSeq = ajaxCall("${ctx}/OkrWorkReg.do?cmd=getMaxSeqOkr",$("#srchFrm").serialize(),false);

			if(resultSeq.DATA >-1){
				var maxSeq = resultSeq.DATA;//조회된 max seq 값
			} else {
				alert("<msg:txt mid='2023082801335' mdef='개인업무(TASK) 등록 시 오류가 발생 했습니다.(순번조회오류)'/>");
				return;
			}

			sheet1.SetCellValue(row, "appraisalCd", 	$("#searchAppraisalCd").val());
			sheet1.SetCellValue(row, "appOrgCd", 		$("#searchAppOrgCd").val());
			sheet1.SetCellValue(row, "sabun", 			$("#searchSabun").val());
			sheet1.SetCellValue(row, "priorSeq", 		$("#priorSeq").val());
			sheet1.SetCellValue(row, "seq", 			maxSeq);

		} else {
			row = sheet1.LastRow();
		}

		sheet1.SetCellValue(row, "workTitle", 		$("#workTitle").val());
		sheet1.SetCellValue(row, "quaCd", 			$("#quaCd").val());
		sheet1.SetCellValue(row, "workManageSabun",	$("#workManageSabun").val());
		sheet1.SetCellValue(row, "term", 			$("#term").val());
		sheet1.SetCellValue(row, "termCd", 			$("#termCd").val());
		sheet1.SetCellValue(row, "termSdate", 		formatDate($("#termSdate").val(),""));
		sheet1.SetCellValue(row, "termEdate", 		formatDate($("#termEdate").val(),""));
		sheet1.SetCellValue(row, "completeLevel", 	$("#completeLevel").val());
		sheet1.SetCellValue(row, "level1", 			$("#level1").val());
		sheet1.SetCellValue(row, "level2", 			$("#level2").val());
		sheet1.SetCellValue(row, "level3", 			$("#level3").val());
		sheet1.SetCellValue(row, "totalLevel", 		$("#totalLevel").val());
		sheet1.SetCellValue(row, "jobCd", 			$("#jobCd").val());
		sheet1.SetCellValue(row, "jobDetailCd", 	$("#jobDetailCd").val());
		sheet1.SetCellValue(row, "jobNm", 			$("#jobNm").val());
		sheet1.SetCellValue(row, "jobDetailNm", 	$("#jobDetailNm").val());
		sheet1.SetCellValue(row, "contents", 		$("#contents").val());

		if($("#keyTaskYn").is(":checked")==true) {
			sheet1.SetCellValue(row, "keyTaskYn", "Y");
		}

		// sheet1
		for(var i = 1; i < sheet1.RowCount()+1; i++) {
			if(sheet1.GetCellValue(i,"sStatus") == "R") {
				sheet1.SetCellValue(i,"sStatus","U");
			}
		}

		// sheet2
		if(sheet2.RowCount() > 0){
			for(var i = 1; i < sheet2.RowCount()+1; i++) {
				sheet2.SetCellValue(i, "appraisalCd", 	$("#searchAppraisalCd").val());
				sheet2.SetCellValue(i, "appOrgCd", 		$("#searchAppOrgCd").val());
				sheet2.SetCellValue(i, "sabun", 		$("#searchSabun").val());
				sheet2.SetCellValue(i, "priorSeq", 		$("#priorSeq").val());
				sheet2.SetCellValue(i, "seq", 			sheet1.GetCellValue(row, "seq"));
			}
		}
	}

	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch("${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegDet2", $("#srchFrm").serialize());
			break;

		case "Insert":
			if(sheet2.RowCount() > 4){
				alert("<msg:txt mid='2023082801336' mdef='Co-worker 는 최대 5명까지 등록 할 수 있습니다.'/>");
				return;
			}

			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
			sheet2.SetCellValue(Row, "appOrgCd", 	$("#searchAppOrgCd").val());
			sheet2.SetCellValue(Row, "sabun", 		$("#searchSabun").val());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 입력시 조건 체크
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
		//필수값 문제 발생시 Stop
		if (!ch) {return ch;}

		return ch;
	}

	// 저장
	function setValue() {

		// 항목 체크 리스트
		if ( !checkList() ) {return false;}

		//저장
		try{
			setFormToSheet();

			//폼에 시트 변경내용 저장
			var saveStr1 = sheet1.GetSaveString(0);
			if(saveStr1.match("KeyFieldError")) {
				return false;
			}

			var saveStr2 = sheet2.GetSaveString(0);
			if(saveStr2.match("KeyFieldError")) {
				return false;
			}
			
			if(!confirm("<msg:txt mid='저장 하시겠습니까?' mdef='저장 하시겠습니까?'/>")) return;

			// 상세내용-마스터
			IBS_SaveName(document.srchFrm,sheet1);
			var rtn1  = eval("("+sheet1.GetSaveData("${ctx}/OkrWorkReg.do?cmd=saveOkrWorkReg1", saveStr1 + "&"+ $("#srchFrm").serialize())+")");

			if(rtn1.Result.Code < 1){
				alert(rtn1.Result.Message);
				return false;
			} else {
				// 상세내용-동료
				var sheet2SaveYn = "N";
				if(sheet2.RowCount() > 0){
					for(var i = 1; i < sheet2.RowCount()+1; i++) {
						if(sheet2.GetCellValue(i,"sStatus") != "R") {
							sheet2SaveYn = "Y";
						}
					}
				}

				if(sheet2SaveYn == "Y"){
					IBS_SaveName(document.srchFrm,sheet2);
					var rtn2 = eval("("+sheet2.GetSaveData("${ctx}/OkrWorkReg.do?cmd=saveOkrWorkReg2", saveStr2 + "&"+ $("#srchFrm").serialize())+")");

					if(rtn2.Result.Code < 1) {
						alert(rtn2.Result.Message);
						return false;
					}else{
						alert("<msg:txt mid='110063' mdef='저장되었습니다.'/>");
					}
				} else {
					alert("<msg:txt mid='110063' mdef='저장되었습니다.'/>");
				}
			}

		} catch (ex){
			alert("Script Errors Occurred While Saving." + ex);
			return false;
		}

		p.popReturnValue([]);
		p.self.close();
	}
	
	function setWorkConfirm(val){
		var msg = "";
		var appYn = "";
		
		if(val == "app"){
			msg = "<tit:txt mid='113326' mdef='승인'/>";
			$("#searchAppYn").val("Y");
		} else if(val == "return"){
			msg = "<tit:txt mid='103917' mdef='반려'/>";
			$("#searchAppYn").val("N");
		}
		
		if(!confirm(msg+" <msg:txt mid='2023082801318' mdef='하시겠습니까?'/>")) return;
		
		var data = ajaxCall("${ctx}/OkrWorkReg.do?cmd=prcOkrWorkReg",$("#srchFrm").serialize(),false);

		if(data.Result.Code == null) {
			alert(msg+" <msg:txt mid='110120' mdef='처리되었습니다.'/>");
			
			p.popReturnValue([]);
			p.self.close();
		} else {
			alert(msg+" <msg:txt mid='109651' mdef='처리 시 오류가 발생하였습니다.'/>");
		}
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
	
	//사원 팝업
	function employeePopup(obj){
		try{
			if(!isPopup()) {return;}

			var args = new Array();

			gPRow = "";
			pGubun = "searchEmployeePopup";

			openPopup("${ctx}/Popup.do?cmd=employeePapPopup", args, "740","520");
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}
	
	//직무 팝업
	function jobPopup(obj){
		try{
			if(!isPopup()) {return;}

			var args = new Array();

			gPRow = "";
			pGubun = obj;

			openPopup("${ctx}/Popup.do?cmd=jobPopup", args, "740","520");
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "searchEmployeePopup") {
			$("#workManageName").val(rv["name"]);
			$("#workManageSabun").val(rv["sabun"]);
		}else if(pGubun == "searchJobCd") {
			$("#jobCd").val(rv["jobCd"]);
			$("#jobNm").val(rv["jobNm"]);
		}else if(pGubun == "searchJobDetailCd") {
			$("#jobDetailCd").val(rv["jobCd"]);
			$("#jobDetailNm").val(rv["jobNm"]);
		}
	}
	
	//특정자리 반올림
	function Round(n, pos) {
		var digits = Math.pow(10, pos);

		var sign = 1;
		if (n < 0) {
		sign = -1;
		}

		// 음수이면 양수처리후 반올림 한 후 다시 음수처리
		n = n * sign;
		var num = Math.round(n * digits) / digits;
		num = num * sign;

		return num.toFixed(pos);
	}

</script>


</head>
<body class="bodywrap">

	<div class="wrapper popup_scroll">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='2023082801319' mdef='개인업무(TASK)상세'/></li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
		<form id="srchFrm" name="srchFrm">
		<input id="authPg" 				name="authPg" 				type="hidden" 	value="" />
		<input id="searchAppraisalCd"	name="searchAppraisalCd" 	type="hidden" 	value="" />
		<input id="searchAppStepCd" 	name="searchAppStepCd" 		type="hidden" 	value="" />
		<input id="searchAppOrgCd" 		name="searchAppOrgCd" 		type="hidden" 	value="" />
		<input id="searchAppSabun" 		name="searchAppSabun" 		type="hidden" 	value="" />
		<input id="searchAppName" 		name="searchAppName" 		type="hidden" 	value="" />
		<input id="searchSabun" 		name="searchSabun"		 	type="hidden" 	value="" />
		<input id="searchPriorSeq" 		name="searchPriorSeq" 		type="hidden" 	value="" />
		<input id="searchSeq" 			name="searchSeq" 			type="hidden" 	value="" />
		<input id="searchStatusCd" 		name="searchStatusCd" 		type="hidden" 	value="" />
		<input id="searchAppYn" 		name="searchAppYn" 			type="hidden" 	value="" />
		<input id="closeYn" 			name="closeYn" 				type="hidden" 	value="" />	<!-- 마감여부 -->
		<input id="adminCheck" 			name="adminCheck" 			type="hidden" 	value="" />
		
		<input type="hidden" id="searchEmpType"  name="searchEmpType" value="P"/> <!-- Include에서  사용 -->
		<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" /><!-- in ret -->
				
		<table class="table" style="width:100%">
			<tbody>
				<colgroup>
					<col width="13%" />
					<col width="35%" />
					<col width="13%" />
					<col width="*" />
				</colgroup>

				<tr>
					<th><tit:txt mid='2023082801321' mdef='팀목표'/></th>
					<td class="content" colspan="3">
						<select id="priorSeq" name="priorSeq" class="${selectCss} ${required} required box w100p" ${disabled}></select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='112534' mdef='업무명'/></th>
					<td class="content" colspan="3">
						<input id="workTitle" name="workTitle" class="${textCss} ${readonly} ${required} required w100p" ${readonly} type="text" />
						<input id="seq" name="seq" type="hidden" readonly />
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='2023082500932' mdef='정성/정량'/></th>
					<td class="content">
						<select id="quaCd" name="quaCd" class="${selectCss} ${required} required box w30p" ${disabled}></select>
					</td>
					<th><tit:txt mid='2023082801320' mdef='성과관리자'/></th>
					<td class="content" colspan="3">
						<input id="workManageSabun" name ="workManageSabun" type="hidden" />
						<input id="workManageName" name ="workManageName" type="text" class="${textCss} ${readonly}" ${readonly}/>
						<a onclick="javascript:employeePopup('workManageName');" class="button6" id="btnSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
						<a onclick="$('#workManageSabun,#workManageName').val('');" class="button7" id="btnSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104420' mdef='기간'/></th>
					<td class="content">
						<input id="term" name="term" class="${textCss} ${readonly} w20p center number" ${readonly} type="text" maxlength="2" />
						<select id="termCd" name="termCd" class="${selectCss} box w30p" ${disabled}></select>
					</td>
					<th><tit:txt mid='2023082801322' mdef='기간일자'/></th>
					<td class="content" colspan="3">
						<input id="termSdate" name="termSdate" type="text" size="10" class="${dateCss} ${readonly}" ${readonly} />  ~
						<input id="termEdate" name="termEdate" type="text" size="10" class="${dateCss} ${readonly}" ${readonly} />
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='2023082801323' mdef='완료수준'/></th>
					<td class="content" colspan="3">
						<textarea id="completeLevel" name="completeLevel" rows="4" class="${textCss} ${readonly} w100p" ${readonly} maxlength="500" ></textarea>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='113600' mdef='수준'/></th>
					<td class="content" colspan="3">
						<tit:txt mid='2023082801329' mdef='적정성'/> <select id="level1" name="level1" class="${selectCss} ${required} required box" style="width:95px;" ${disabled}></select>&nbsp;&nbsp;&nbsp;&nbsp;
						<tit:txt mid='2023082801328' mdef='적시성'/> <select id="level2" name="level2" class="${selectCss} ${required} required box" style="width:93px;" ${disabled}></select>&nbsp;&nbsp;&nbsp;&nbsp;
						<tit:txt mid='2023082801327' mdef='연계성'/> <select id="level3" name="level3" class="${selectCss} ${required} required box" style="width:95px;" ${disabled}></select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<b><tit:txt mid='2023082501238' mdef='종합수준'/></b> <select id="totalLevel" name="totalLevel" class="${selectCss} box" style="width:95px;" disabled></select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='113439' mdef='직무'/></th>
					<td class="content">
						<input id="jobCd" name ="jobCd" type="hidden" />
						<input id="jobNm" name ="jobNm" type="text" class="${textCss} ${readonly} w30p" ${readonly}/>
						<a onclick="javascript:jobPopup('searchJobCd');" class="button6" id="btnJobPop"><img src="/common/images/common/btn_search2.gif"/></a>
						<input id="jobDetailCd" name ="jobDetailCd" type="hidden" />
						<input id="jobDetailNm" name ="jobDetailNm" type="text" class="${textCss} ${readonly} w30p" ${readonly}/>
						<a onclick="javascript:jobPopup('searchJobDetailCd');" class="button6" id="btnJobDetailPop"><img src="/common/images/common/btn_search2.gif"/></a>
					</td>
					<th><tit:txt mid='2023082801330' mdef='핵심과제여부'/></th>
					<td class="content">
						<input id="keyTaskYn" name="keyTaskYn" type="checkbox" ${disabled} style="margin-left:5px; vertical-align:middle;" />
					</td>
				</tr>
				<tr>
					<th>Co-worker</th>
					<td class="content" colspan="3">
						<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
							<tr>
								<td>
									<div class="sheet_title">
										<ul>
											<li class="btn">
												<a href="javascript:doAction2('Insert')" class="basic authA"><tit:txt mid='110700' mdef='입력'/></a>
											</li>
										</ul>
									</div>
									<script type="text/javascript">createIBSheet("sheet2", "100%", "26%","kr"); </script>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='112871' mdef='상세내용'/></th>
					<td class="content" colspan="3">
						<textarea id="contents" name="contents" rows="4" class="${textCss} ${readonly} w100p" ${readonly} maxlength="500" ></textarea>
					</td>
				</tr>
			</tbody>
		</table>

		<!-- sheet1 -->
		<div class="hide">
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
		</div>
		</form>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();"				class="pink large" id="btnSave"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:setWorkConfirm('app');"		class="pink large" id="btnApp"><tit:txt mid='113326' mdef='승인'/></a>
					<a href="javascript:setWorkConfirm('return');"	class="pink large" id="btnReturn"><tit:txt mid='103917' mdef='반려'/></a>
					<a href="javascript:p.self.close();"			class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>