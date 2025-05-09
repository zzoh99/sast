<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	
	var usedCompClassCdList    = null;	// 사용역량평가등급(P00002)
	var notUsedCompClassCdList = null;	// 미사용역량평가등급(P00002)

	var bLink = false;
	if ( "${map.searchAppraisalCd_sub}" != "" ) {
		bLink = true;
	}

	 $(function() {

		notUsedCompClassCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&visualYn=N","P00002"), "");	// 미사용역량평가등급(P00002)
		usedCompClassCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&visualYn=Y","P00002"), "");	// 사용역량평가등급(P00002)

		 
		$("#searchAppOrgCd").bind("change",function(event){
			setAppEmployee();
		});


		$("#appUpMemo1, #appUpMemo2, #appUpMemo3").bind("change",function(event){
			sheet1.SetCellValue(1, "sheetAppUpMemo1", $("#appUpMemo1").val());
			sheet1.SetCellValue(1, "sheetAppUpMemo2", $("#appUpMemo2").val());
			sheet1.SetCellValue(1, "sheetAppUpMemo3", $("#appUpMemo3").val());
		});

		$("#appMemo1, #appMemo2").bind("change",function(event){
			sheet1.SetCellValue(1, "sheetAppMemo1", $("#appMemo1").val());
			sheet1.SetCellValue(1, "sheetAppMemo2", $("#appMemo2").val());
		});

		if ( $("#searchAppSeqCd").val() == '3' ){
			$("#appUpMemo1, #appUpMemo2, #appUpMemo3").attr("readonly",false).removeClass("readonly");
		}

		if ( $("#searchAppSeqCd").val() == '4' ){
			$("#appMemo1, #appMemo2").attr("readonly",false).removeClass("readonly");
		}
		
		if(bLink == true) {
			
			//성명,사번
			$("#searchAppraisalCd").val(decodeURI("${map.searchAppraisalCd_sub}"));
			$("#searchAppraisalNm").val(decodeURI("${map.searchAppraisalNm_sub}"));
			$("#searchAppOrgCd").val(decodeURI("${map.searchAppOrgCd_sub}"));
			$("#searchAppOrgNm").val(decodeURI("${map.searchAppOrgNm_sub}"));
			$("#searchAppSeqCd").val(decodeURI("${map.searchAppSeqCd_sub}"));
			$("#searchAppSabun").val(decodeURI("${map.searchAppSabun_sub}"));
			$("#searchAppName").val(decodeURI("${map.searchAppName_sub}"));
			$("#searchSabun").val(decodeURI("${map.searchSabun_sub}"));
			$("#searchName").val(decodeURI("${map.searchName_sub}"));

			$("#span_searchAppraisalNm").html(decodeURI("${map.searchAppraisalNm_sub}"));
			$("#span_searchAppOrgNm").html(decodeURI("${map.searchAppOrgNm_sub}"));
			$("#span_searchAppName").html(decodeURI("${map.searchAppName_sub}"));
			$("#span_searchName").html(decodeURI("${map.searchName_sub}"));

			$("#searchAppOrgCd").change();

			if($("#searchAppSeqCd").val() == "0"){
				$("#titleNm").text("본인평가");
			} else if($("#searchAppSeqCd").val() == "3"){
				$("#titleNm").text("상사평가");
			} else if($("#searchAppSeqCd").val() == "4"){
				$("#titleNm").text("동료평가");
			} else if($("#searchAppSeqCd").val() == "5"){
				$("#titleNm").text("부하평가");
			}

		} else {
			//성명,사번
			$("#searchSabun").val("${sessionScope.ssnSabun}");
			$("#searchName").val("${sessionScope.ssnName}");

			$("#span_searchName").html("${sessionScope.ssnName}");

			//평가명
			var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListSeqMbo&" + $("#srchFrm").serialize(),false).codeList, ""); // 평가명

			$("#searchAppraisalCd").html(appraisalCdList[2]);

			$("#searchAppraisalCd").change();
		}
	});


	$(function() {
		
		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.
		//var classCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00002"), ""); // 전체역량평가등급(P00002)

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenColRight:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,				 	Width:"${sDelWdt}",	Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			
			{Header:"구분",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:1, SaveName:"mainAppTypeNm",		KeyField:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
			{Header:"평가요소",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0, SaveName:"competencyNm",		KeyField:0, UpdateEdit:0, InsertEdit:1, EditLen:100 },
			{Header:"평가내용",		Type:"Text",	Hidden:0,	Width:400,	Align:"Left",	ColMerge:0, SaveName:"competencyDetail",	KeyField:0, UpdateEdit:0, InsertEdit:1, EditLen:100, Wrap:1, MultiLineText:1},

			{Header:"평가ID",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"appraisalCd"},
			{Header:"사번",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"sabun"},
			{Header:"평가소속",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"appOrgCd"},
			{Header:"평가차수",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"appSeqCd"},
			{Header:"평가자사번",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"appSabun"},
			{Header:"역량코드",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"competencyCd"},
			
			{Header:"평가의견1",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"sheetAppMemo1"},
			{Header:"평가의견2",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"sheetAppMemo2"},
			
			{Header:"평가u의견1",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"sheetAppUpMemo1"},
			{Header:"평가u의견2",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"sheetAppUpMemo2"},
			{Header:"평가u의견3",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"sheetAppUpMemo3"},
			
			{Header:"평가등급(점수)",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0, SaveName:"compClassCd",		KeyField:1, UpdateEdit:1, InsertEdit:1 }
			/*
			{Header:"평가점수",	Type:"CheckBox",    Hidden:0,                   Width:350,         	Align:"Left",   ColMerge:0, SaveName:"compClassCd",  KeyField:1, UpdateEdit:1, InsertEdit:1, ItemText:classCdList[0], ItemCode:classCdList[1], MaxCheck:1, Wrap:1}
			*/
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("compClassCd",	{ComboText : "|" + usedCompClassCdList[0],	ComboCode: "|" + usedCompClassCdList[1]} );

		
		//시트가 나중에 그려져서 .. 다시 적용 해줌.
		if( $("#searchStatusCd").val() == "Y" ){
			sheet1.SetEditable(0);
		}
		
		// 평가항목 시트
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,				 	Width:"${sDelWdt}",	Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },

			{Header:"평가ID",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"appraisalCd"},
			{Header:"평가소속",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"appOrgCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"sabun"},
			{Header:"평가차수",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"appSeqCd"},
			{Header:"순번",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"seq"},
			{Header:"평가항목",	Type:"Text",	Hidden:0,	Width:50,	Align:"Left",   ColMerge:0, SaveName:"appItem",		KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:1000, Wrap:1, MultiLineText:1},
			{Header:"평가의견",	Type:"Text",	Hidden:0,	Width:50,	Align:"Left",   ColMerge:0, SaveName:"appOpinion",	KeyField:0, UpdateEdit:1, InsertEdit:1, EditLen:1300, Wrap:1, MultiLineText:1}
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

	});
	 //평가소속 setting(평가명 change, 성명 팝업 선택 후)
	function setAppOrgCdCombo() {
		var addParams  = "queryId=getAppOrgCdListMboTarget";
			addParams += "&searchAppraisalCd="+$("#searchAppraisalCd").val();
			addParams += "&searchSabun="+$("#searchSabun").val();
			addParams += "&searchAppStepCd="+$("#searchAppStepCd").val();
			addParams += "&searchAppYn=Y";
			
		var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&",addParams,false).codeList, ""); // 평가소속

		$("#searchAppOrgCd").html("");
		$("#searchAppOrgCd").html(appOrgCdList[2]);

		$("#searchAppOrgCd").change();
	}

	//피평가자, 평가자정보조회(평가소속 change)
	function setAppEmployee() {

		$("#searchStatusCd").val("");
		$("#searchJikweeNm").val("");
		$("#searchStatus").val("");

		var data = ajaxCall("${ctx}/MltsrcEvlt.do?cmd=getMltsrcEvltMap",$("#srchFrm").serialize(),false);

		if(data != null && data.map != null) {
			$("#searchStatusCd").val(data.map.statusCd);// 완료여부
			$("#searchJikweeNm").val(data.map.jikweeNm);
			$("#searchStatus").val(data.map.statusNm);

			if ( $("#searchAppSeqCd").val() == '3' ){
				$("#appUpMemo1").val(data.map.appUpMemo1);
				$("#appUpMemo2").val(data.map.appUpMemo2);
				$("#appUpMemo3").val(data.map.appUpMemo3);
			}

			if ( $("#searchAppSeqCd").val() == '4' ){
				$("#appMemo1").val(data.map.appMemo1);
				$("#appMemo2").val(data.map.appMemo2);
			}

			$("#span_searchJikweeNm").html(data.map.jikweeNm);
			$("#span_searchStatus").html(data.map.statusNm);
		}

		//버튼제어
		var appcmplYn = $("#searchStatusCd").val();

		if(appcmplYn == "Y"){
			$("#btnApp").hide();
			$("#btnSave").hide();
			sheet1.SetEditable(0);

			if ( $("#searchAppSeqCd").val() == '3' ){
				$("#appUpMemo1, #appUpMemo2, #appUpMemo3, #appUpMemo4").addClass("readonly");
			}

			if ( $("#searchAppSeqCd").val() == '4' ){
				$("#appMemo1, #appMemo2").attr("readonly",true).addClass("readonly");
			}


		}else{
			$("#btnApp").show();
			$("#btnSave").show();
			sheet1.SetEditable(1);

			if ( $("#searchAppSeqCd").val() == '3' ){
				$("#appUpMemo1, #appUpMemo2, #appUpMemo3, #appUpMemo4").attr("readonly",false).removeClass("readonly");
			}

			if ( $("#searchAppSeqCd").val() == '4' ){
				$("#appMemo1, #appMemo2").attr("readonly",false).removeClass("readonly");
			}

		}

		doAction("Search");
	}

	//Sheet1 Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getMltsrcEvltList", $("#srchFrm").serialize() );
			sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getMltsrcEvltAppItemOpinionList", $("#srchFrm").serialize() );
			break;
		
		case "Save":
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if ( sheet1.GetCellValue(i, "compClassCd") == "" ) {
					 alert("평가등급 모두 입력하여 주세요");
					 sheet1.SetSelectRow(i);
					 return;
				}
			}
			
			/*
			if ( $("#searchAppSeqCd").val() == '3' ){
				var appUpMemo1 = $("#appUpMemo1").val().length;
				var appUpMemo2 = $("#appUpMemo2").val().length;

				if ( appUpMemo1 < 30 ){
					alert("보직자 장점 및 강점 내용을 30자 이상 입력해주세요.");
					break;
				}
				if ( appUpMemo2 < 30 ){
					alert("보직자 개선점을 30자 이상 입력해주세요.");
					break;
				}
			}
			*/

			var chkFlag = true;
			if(sheet2.RowCount() > 0) {
				for(var i = 1; i < sheet2.RowCount()+1; i++) {
					var seq = sheet2.GetCellValue( i, "seq" );
					var appItem = sheet2.GetCellValue( i, "appItem" );
					var appOpinion = $("#appOpinion" + seq);
					if( appOpinion.val() == "" ) {
						alert("[" + seq + ". " + appItem + "] 의 내용을 30자 이상 입력해주세요.");
						chkFlag = false;
						break;
					} else if(appOpinion.val().length < 30) {
						chkFlag = false;
						alert("[" + seq + ". " + appItem + "] 의 내용을 30자 이상 입력해주세요.");
						break;
					} else {
						sheet2.SetCellValue(i, "appOpinion", appOpinion.val());
					}
				}
			}
			if(!chkFlag) {
				return;
			}
			
			var sheet1Status = sheet1.FindStatusRow("I|U|D");
			var sheet2Status = sheet2.FindStatusRow("I|U|D");
			
			if(sheet2Status != "") {
				IBS_SaveName(document.srchFrm2,sheet2);
				var result = eval("(" + sheet1.GetSaveData("${ctx}/MltsrcEvlt.do?cmd=saveMltsrcEvltAppItemOpinion", $("#srchFrm2").serialize() + "&" + sheet2.GetSaveString() +  "&searchAppSabun=" + $("#searchAppSabun").val()) + ")");
				if(result.Result.Code < 1) {
					alert(result.Result.Message);
					return;
				} else {
					if(sheet1Status == "") {
						alert("저장되었습니다.");
					}
				}
			}

			if(sheet1Status != "") {
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/MltsrcEvlt.do?cmd=saveMltsrcEvlt", $("#srchFrm").serialize());
			}
			
			if(sheet1Status == "" && sheet2Status == "") {
				alert("변경된 내역이 없습니다.");
			}
			break;
			
		case "Copy":
			sheet1.DataCopy();
			break;
			
		case "Clear":
			sheet1.RemoveAll();
			break;
		
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
			
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
			
		case "ChkApp": //평가완료
			if($("#searchAppraisalCd").value == ""){
				alert("평가명이 존재하지 않습니다.");
				return;
			}

			//미완료 : N, 평가완료 : Y
			if($("#searchStatusCd").val() == "Y"){
				alert("이미 평가완료된 상태입니다.");
				return;
			}

			if($("#searchAppName").val() == "") {
				alert("평가자가 존재하지 않습니다.");
				return;
			}

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if ( sheet1.GetCellValue(i, "compClassCd") == "" ) {
					 alert("평가등급을 모두 입력하여 주세요");
					 return;
				}
			}
			
			var chkFlag = true;
			if(sheet2.RowCount() > 0) {
				for(var i = 1; i < sheet2.RowCount()+1; i++) {
					var seq = sheet2.GetCellValue( i, "seq" );
					var appItem = sheet2.GetCellValue( i, "appItem" );
					var appOpinion = $("#appOpinion" + seq);
					if( appOpinion.val() == "" ) {
						alert("[" + seq + ". " + appItem + "] 의 내용을 30자 이상 입력해주세요.");
						chkFlag = false;
						break;
					} else if(appOpinion.val().length < 30) {
						chkFlag = false;
						alert("[" + seq + ". " + appItem + "] 의 내용을 30자 이상 입력해주세요.");
						break;
					} else {
						sheet2.SetCellValue(i, "appOpinion", appOpinion.val());
					}
				}
			}
			if(!chkFlag) {
				return;
			}

			if(sheet1.RowCount("U") > 0 || sheet2.RowCount("U") > 0 ){
				alert("저장 후 평가완료 하시기 바랍니다.");
				return;
			}

			if(sheet1.RowCount("R") == 0){
				alert("평가할 항목이 없습니다. ");
				return;
			}

			if(!confirm("한번 평가를 완료하면 수정할 수 없습니다.\r\n평가를 완료하시겠습니까?")) return;

			var data = ajaxCall("${ctx}/MltsrcEvlt.do?cmd=prcMltsrcEvlt",$("#srchFrm").serialize(),false);
			if(data.Result.Code == null) {
				alert( "평가확정 처리되었습니다.");
				setAppEmployee();
			} else {
				alert(data.Result.Message);
			}

			break;
			
		case "GoList": //피평가자목록
			if(sheet1.RowCount("U") != "" ) {
				alert("저장되지 않은 데이터가 존재합니다. 저장 후 이동 해주세요.");
				return;
			}

			submitCall($("#linkFrm"),"_self","POST", $("#backPage").val());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			//sheetResize();
			
			if(sheet2.RowCount() > 0) {
				$("table tbody", "#srchFrm2").html("");
				for(var i = 1; i < sheet2.RowCount()+1; i++) {
					var seq = sheet2.GetCellValue( i, "seq" );
					var appItem = sheet2.GetCellValue( i, "appItem" );
					var appOpinion = sheet2.GetCellValue( i, "appOpinion" );
					var html = "";
					html += "<tr>";
					html += "<th>" + seq + ". " + appItem + "</th>";
					html += "</tr>";
					html += "<tr>";
					html += "<td>";
					html += "<textarea id='appOpinion" + seq + "' name='appOpinion" + seq + "' style=\"width:100%; height:60px;\"></textarea>";
					html += "</td>";
					html += "</tr>";
					$("table tbody", "#srchFrm2").append(html);
					$("#appOpinion" + seq).val(appOpinion);
					
					// 평가완료된 경우 "readonly" 처리
					if($("#searchStatusCd").val() == "Y") {
						$("#appOpinion" + seq).attr("readonly", "readonly");
					}
				}
				
			}
			
		}catch(ex){
			alert("[sheet2] OnSearchEnd Event Error : " + ex);
		}
	}

	//사원 팝업
	function employeePopup(){
		try{
			if(!isPopup()) {return;}

			var args = new Array();

			gPRow = "";
			pGubun = "searchEmployeePopup";

			openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "searchEmployeePopup"){
			$("#searchName").val(rv["name"]);
			$("#searchSabun").val(rv["sabun"]);
			setAppOrgCdCombo();
		}

	}
</script>
</head>
<body class="hidden" style="overflow-y:auto !important;">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" name="searchAppStepCd"	id="searchAppStepCd"	value="5" />
		<input type="hidden" name="searchAppSeqCd"	id="searchAppSeqCd"		value="${map.searchAppSeqCd_sub}" />
		<input type="hidden" name="searchAppSabun"	id="searchAppSabun" />
		<input type="hidden" name="searchStatusCd"	id="searchStatusCd" />
		<input type="hidden" name="searchOrgCd"		id="searchOrgCd" />
		<input type="hidden" name="searchOrgNm"		id="searchOrgNm" />
		<input type="hidden" name="searchAppYn"		id="searchAppYn" />
		<input type="hidden" name="fileSeq"			id="fileSeq" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span class="w50">평가명 </span>
				<c:choose>
					<c:when test="${map.searchAppraisalCd_sub == null || map.searchAppraisalCd_sub == ''}">
							<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
					</c:when>
					<c:otherwise>
							<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
							<input type="hidden" id="searchAppraisalNm" name="searchAppraisalNm" />
							<b id="span_searchAppraisalNm" class="txt"></b>
					</c:otherwise>
				</c:choose>
						</td>
						<td>
							<span class="w50">평가소속 </span>
				<c:choose>
					<c:when test="${map.searchAppraisalCd_sub == null || map.searchAppraisalCd_sub == ''}">
							<select id="searchAppOrgCd" name="searchAppOrgCd"></select>
					</c:when>
					<c:otherwise>
							<input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" />
							<input type="hidden" id="searchAppOrgNm" name="searchAppOrgNm" />
							<b id="span_searchAppOrgNm" class="txt"></b>
					</c:otherwise>
				</c:choose>
						</td>
						<td>
							<span class="w50">평가자 </span>
							<input type="hidden" id="searchAppName" name="searchAppName" />
							<b id="span_searchAppName" class="txt"></b>
						</td>
					</tr>
					<tr>
						<td><span class="w50">성명 </span>
							<input type="hidden" id="searchSabun" name ="searchSabun"/>
							<input type="hidden" id="searchName" name="searchName" />
							<b id="span_searchName" class="txt"></b>
						</td>
						<td>
							<span class="w50">직위 </span>
							<input type="hidden" id="searchJikweeNm" name="searchJikweeNm" />
							<b id="span_searchJikweeNm" class="txt"></b>
						</td>
						<td>
							<span class="w50">진행상태 </span>
							<input type="hidden" id="searchStatus" name="searchStatus" />
							<b id="span_searchStatus" class="txt"></b>
						</td>
						<td>
							<a href="javascript:setAppEmployee()" id="btnSearch" class="button" >조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="titleNm" class="txt"></li>
							<li class="btn">
								<a href="javascript:doAction('GoList')"		class="button authA" id="btnList">리스트</a>
								<a href="javascript:doAction('ChkApp')"		class="button authA" id="btnApp">평가완료</a>
								<a href="javascript:doAction('Save')"		class="basic authA" id="btnSave">저장</a>
								<a href="javascript:doAction('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","kr"); </script>
			</td>
		</tr>
		<tr>
			<td>
				<div class="inner mat10">
					<div class="sheet_title">
						<ul>
							<li class="txt">평가의견</li>
							<li class="btn">
							</li>
						</ul>
					</div>
				</div>
				<div id="sheet2_box" class="hide">
					<script type="text/javascript">createIBSheet("sheet2", "100%", "15%","kr"); </script>
				</div>
 				<form id="srchFrm2" name="srchFrm2" >
				<table class="table">
					<tbody>
<%-- 사용안함.
<c:if test="${map.searchAppSeqCd_sub eq '3'}">
						<tr>
							<th>1. 보직자 장점 및 강점</th>
						</tr>
						<tr>
							<td>
								<textarea id="appUpMemo1" name="appUpMemo1" style="width:100%; height:30px;"></textarea>
							</td>
						</tr>
						<tr>
							<th>2. 보직자 개선점</th>
						</tr>
						<tr>
							<td>
								<textarea id="appUpMemo2" name="appUpMemo2" style="width:100%; height:30px;"></textarea>
							</td>
						</tr>
						<tr>
							<th>3. 회사에 바라는 사항</th>
						</tr>
						<tr>
							<td>
								<textarea id="appUpMemo3" name="appUpMemo3" style="width:100%; height:30px;"></textarea>
							</td>
						</tr>
</c:if>
<c:if test="${map.searchAppSeqCd_sub eq '4'}">
						<tr>
							<th>1. 평가대상조직의 강점</th>
						</tr>
						<tr>
							<td>
								<textarea id="appMemo1" name="appMemo1" style="width:100%; height:30px;"></textarea>
							</td>
						</tr>
						<tr>
							<th>2. 평가대상조직의 개선점</th>
						</tr>
						<tr>
							<td>
								<textarea id="appMemo2" name="appMemo2" style="width:100%; height:30px;"></textarea>
							</td>
						</tr>
</c:if>
--%>
					</tbody>
				</table>
				</form>
			</td>

		</tr>
	</table>
</div>

<form id="linkFrm" name="linkFrm" >
	<input type="hidden" name="authPg" id="authPg" value="${authPg}"/>
	<input type="hidden" name="backPage" id="backPage" value="${map.backPage}"/>
	<input type="hidden" name="searchAppraisalCd_back"id="searchAppraisalCd_back" value="${map.searchAppraisalCd_back}"/>
	<input type="hidden" name="searchAppSabun_back"	 id="searchAppSabun_back" value="${map.searchAppSabun_back}"/>
	<input type="hidden" name="searchAppName_back"	id="searchAppName_back" value="${map.searchAppName_back}"/>
	<input type="hidden" name="searchAppSeqCd_back"	 id="searchAppSeqCd_back" value="${map.searchAppSeqCd_back}"/>
	<input type="hidden" name="searchAppGroupCd_back" id="searchAppGroupCd_back" value="${map.searchAppGroupCd_back}"/>
	<input type="hidden" name="searchAppOrgNm_back"	 id="searchAppOrgNm_back" value="${map.searchAppOrgNm_back}"/>
	<input type="hidden" name="searchAppJikweeNm_back"id="searchAppJikweeNm_back" value="${map.searchAppJikweeNm_back}"/>
	<input type="hidden" name="searchAppJikgubNm_back"id="searchAppJikgubNm_back" value="${map.searchAppJikgubNm_back}"/>
	<input type="hidden" name="searchAppJikchakNm_back" id="searchAppJikchakNm_back" value="${map.searchAppJikchakNm_back}"/>
</form>


</body>
</html>