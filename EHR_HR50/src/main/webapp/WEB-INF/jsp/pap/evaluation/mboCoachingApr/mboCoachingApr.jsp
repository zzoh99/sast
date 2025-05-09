<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"성명",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속",	    	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직위",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직책",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"입사일",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"진행상태",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APPRAISAL_CD",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APP_ORG_CD",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"STATUS_CD",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APP_SHEET_TYPE",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSheetType",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"APPRAISAL_YY",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYy",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"ORG_CD",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"ORG_NM",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가ID코드(TPAP101)",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사원번호",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수코드",			Type:"Text",	Hidden:1,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가자사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"코칭일자",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"coaYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"코칭장소",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"coaPlace",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1330 },
			{Header:"코칭내용",				Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1330,  MultiLineText:1,Wrap:1, ToolTip:1  }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		 sheet2.SetEditEnterBehavior("newline");

		var coboCodeList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListMobOrgTargetReg&searchAppStepCd=3&searchAppTypeCd=F&searchAppraisalSeq=0",false).codeList, "");	//평가명
		var coboCodeList2 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppIndexGubunCdList",false).codeList, "");	//지표구분

		$("#searchAppraisalCd").html(coboCodeList1[2]);
		sheet2.SetColProperty("appIndexGubunCd", 			{ComboText:coboCodeList2[0], ComboCode:coboCodeList2[1]} );

		var papAdmin = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegPapAdminMap","&searchSabun="+$("#searchSabun").val(),false); //admin 여부
     	if(papAdmin != null && papAdmin.map != null) {
     		if(papAdmin.map.papAdminYn == 'N'){
     			$(".button6").hide();
     			$(".button7").hide();
     		}
     	}

     	//평가기간 체크 하여 버튼 보임 안보임 처리
        var data2 = ajaxCall("/MboOrgTargetReg.do?cmd=getTargetButtonVislYnMap","searchAppraisalCd="
        		+$("#searchAppraisalCd").val()+"&searchappStepCd=3",false);
        if(data2 != null && data2.map != null) {
        	if(data2.map.vislYn == "N"){
     			$(".group2").hide();
     		}
        }

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/MboCoachingApr.do?cmd=getMboCoachingAprList1", $("#srchFrm").serialize() ); break;
		//case "Save":
		//					IBS_SaveName(document.srchFrm,sheet1);
		//					sheet1.DoSave( "${ctx}/MboCoachingApr.do?cmd=saveMboCoachingApr1", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/MboCoachingApr.do?cmd=getMboCoachingAprList2", $("#srchFrm").serialize() ); break;
		case "Save":
			if(sheet2.FindStatusRow("I") != ""){
			    if(!dupChk(sheet2,"appraisalCd|sabun|appOrgCd|appSeqCd|appSabun|coaYmd", true, true)){break;}
			}
			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave( "${ctx}/MboCoachingApr.do?cmd=saveMboCoachingApr", $("#srchFrm").serialize()); break;
		case "Insert":
			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue (Row, "appraisalCd", $("#appraisalCd").text() );
			sheet2.SetCellValue (Row, "sabun", $("#sabun").text() );
			sheet2.SetCellValue (Row, "appOrgCd", $("#appOrgCd").text() );
			sheet2.SetCellValue (Row, "appSeqCd", $("#appSeqCd").text() );
			sheet2.SetCellValue (Row, "appSabun", $("#appSabun").text() );
			break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			if(sheet1.RowCount() == 0){
				$("#searchAppSabun").val("");
				doAction2("Search");
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			var coboCodeList3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTargetIndexKpiCdList&searchAppSabun="+$("#searchSabun").val()+"&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");
		     sheet2.SetColProperty("targetIndexKpi", 			{ComboText:coboCodeList3[0], ComboCode:coboCodeList3[1]} );

		     var tmpSttsCd = sheet1.GetCellValue(sheet1.GetSelectRow(),"statusCd");
		     if(tmpSttsCd != "21"){
		     	sheet2.SetColEditable("chkMemo1",0);
		     }else{
		    	sheet2.SetColEditable("chkMemo1",1);
		     }


		     //합계 행 다듬기
			 var lr = sheet1.LastRow();
			 sheet2.SetSumValue("sNo","합계");
			 sheet2.SetMergeCell(lr, 0, 1,3);

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
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}



	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction2("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{

			var rv = null;
			var args    = new Array();

			args["elementType"] = sheet1.GetCellValue(Row, "elementType");
			args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
			args["elementNm"]   = sheet1.GetCellValue(Row, "elementNm");
			args["sdate"]       = sheet1.GetCellValue(Row, "sdate");

			if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
				var rv = openPopup("/PayAllowanceElementPropertyPopup.do?cmd=payAllowanceElementPropertyPopup", args, "1000","520");
				if(rv!=null){
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}


  //사원 팝입
    function employeePopup(){
        try{

         var args    = new Array();
         var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
            if(rv!=null){


	            $("#searchName").val(rv["name"]);
	            $("#searchSabun").val(rv["sabun"]);
	            $("#searchOrgNm").val(rv["orgNm"]);
	            $("#searchJikweeNm").val(rv["jikweeNm"]);
	            $("#searchJikchakNm").val(rv["jikchakNm"]);

	         	doAction1("Search");
            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

 	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {

			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					$("#iAppraisalNm").text($("#searchAppraisalCd option:selected").text());
					$("#iAppName").text($("#searchName").val());
					$("#iStatus").text(sheet1.GetCellValue(NewRow,"statusNm"));
					$("#iName").text(sheet1.GetCellValue(NewRow,"name"));
					$("#iOrgnm").text(sheet1.GetCellValue(NewRow,"orgNm"));
					$("#iJikwee").text(sheet1.GetCellValue(NewRow,"jikweeNm"));
					$("#iJikchak").text(sheet1.GetCellValue(NewRow,"jikchakNm"));
					$("#searchAppSabun").val(sheet1.GetCellValue(NewRow,"sabun"));

					$("#appraisalCd").text($("#searchAppraisalCd option:selected").val());
					$("#sabun").text(sheet1.GetCellValue(NewRow,"sabun"));
					$("#appOrgCd").text(sheet1.GetCellValue(NewRow,"appOrgCd"));
					$("#appSeqCd").text('99');
					$("#appSabun").text($("#searchSabun").val());
				}
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	//승인
	function Approval(){

		if($("#searchAppSabun").val() == ""){
			alert("승인 처리할 피평가자를 선택 하시기 바랍니다.");
			return;
		}

		var chkCnt = 0;
        chkCnt = sheet2.RowCount("U") + sheet2.RowCount("I") + sheet2.RowCount("D");
		if(chkCnt > 0){
			alert("저장 후 승인 하시기 바랍니다.");
			return;
		}

		var tmpSttsCd = sheet1.GetCellValue(sheet1.GetSelectRow(),"statusCd");

		if(tmpSttsCd == "15" || tmpSttsCd == "11")
		{
			alert("작성중인 건에 대해서는 승인 처리하실 수 없습니다.");
			return;
		}

		if(tmpSttsCd == "23")
		{
			alert("이미 처리된 반려건에 대해서는 다시 처리하실 수 없습니다.");
			return;
		}
		else if(tmpSttsCd == "25" || tmpSttsCd == "27" || tmpSttsCd == "29" || tmpSttsCd == "99")
		{
			alert("이미 처리된 승인건에 대해서는 다시 처리하실 수 없습니다.");
			return;
		}


		for(var i = 1; i < sheet2.RowCount ; i++ ) {
			if(sheet2.GetCellValue(i, "chkMemo1") == "") {
				alert(" [ " + sheet2.GetCellValue(i, "target") + " ] 에 대한 의견을 등록해 주시기 바랍니다.");
				return;
			}
		}

		if(!confirm("승인 하시겠습니까?")){
	       return;
	    }
		$("#searchYn").val("Y");

	 	// 화면단
       	 var data = ajaxCall("/MboOrgTargetApr.do?cmd=prcMboOrgTargetAprAprv",$("#srchFrm").serialize(),false);

  		 if(data.Result.Code == null) {
   			alert("처리되었습니다.");
   			doAction1("Search");
  		 }else{
  			alert(data.Result.Message);
  		 }


	}

	//반려
	function Return(){
		if($("#searchAppSabun").val() == ""){
			alert("반려 처리할 피평가자를 선택 하시기 바랍니다.");
			return;
		}


		var chkCnt = 0;
        chkCnt = sheet2.RowCount("U") + sheet2.RowCount("I") + sheet2.RowCount("D");
		if(chkCnt > 0){
			alert("저장 후 반려처리 하시기 바랍니다.");
			return;
		}

		var tmpSttsCd = sheet1.GetCellValue(sheet1.GetSelectRow(),"statusCd");

		if(tmpSttsCd == "15" || tmpSttsCd == "11")
		{
			alert("작성중인 건에 대해서는 반려 처리하실 수 없습니다.");
			return;
		}



		if(tmpSttsCd == "23")
		{
			alert("이미 처리된 반려건에 대해서는 다시 처리하실 수 없습니다.");
			return;
		}
		else if(tmpSttsCd == "25" || tmpSttsCd == "27" || tmpSttsCd == "29" || tmpSttsCd == "99" )
		{
			alert("이미 처리된 승인건에 대해서는 다시 처리하실 수 없습니다.");
			return;
		}



		if(!confirm("반려 하시겠습니까?")){
		       return;
	    }

		$("#searchYn").val("N");

		// 화면단
      	 var data = ajaxCall("/MboOrgTargetApr.do?cmd=prcMboOrgTargetAprAprv",$("#srchFrm").serialize(),false);

 		 if(data.Result.Code == null) {
  			alert("처리되었습니다.");
  			doAction1("Search");
 		 }else{
 			alert(data.Result.Message);
 		 }

	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input id="searchAppSabun" 	name ="searchAppSabun" type="hidden" value="" />
	<input id="searchYn" 	name ="searchYn" type="hidden" value="" />

<div class="hide"> <%-- 2013.12.12  99 하드코딩 by SJ --%>
	<span id="appraisalCd"></span>
	<span id="sabun"></span>
	<span id="appOrgCd"></span>
	<span id="appSeqCd"></span>
	<span id="appSabun"></span>
</div>
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td colspan="2">
				<span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"> </select>
			</td>
			<td><span>성명 </span>
				<input id="searchName" name ="searchName" value="${sessionScope.ssnName}" type="text" class="text readonly " readOnly />
				<input id="searchSabun" name ="searchSabun" value="${sessionScope.ssnSabun}" type="hidden" class="text"  />
				<a onclick="javascript:employeePopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
				<a onclick="$('#searchSabun,#searchName').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
			</td>
			<td>
			</td>
		</tr>
		<tr>
			<td> <span>소속 </span> <input id="searchOrgNm" 	    name ="searchOrgNm" type="text" class="text readonly w150" value="${sessionScope.ssnOrgNm}" readOnly /> </td>
			<td> <span>직급 </span> <input id="searchJikgubNm"   name ="searchJikgubNm" type="text" class="text readonly" value="${sessionScope.ssnJikgubNm}" readOnly /> </td>
			<td> <span>직책 </span> <input id="searchJikchakNm"  name ="searchJikchakNm" type="text" class="text readonly"  value="${sessionScope.ssnJikchakNm}"  readOnly /> </td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="27%" />
		<col width="15px" />
		<col width="73%" />
	</colgroup>
	<tr>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">피평가자</li>
					<li class="btn">
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
		<td></td>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">피평가자정보</li>
					<li class="btn">

					</li>
				</ul>
				</div>
			</div>
			<div class="inner">
				<table class="table w100p" id="htmlTable">
					<colgroup>
						<col width="9%" />
						<col width="16%" />
						<col width="9%" />
						<col width="16%" />
						<col width="9%" />
						<col width="16%" />
						<col width="11%" />
						<col width="14%" />
					</colgroup>
					<tr>
						<th>평가명</th>
						<td colspan="3">
							<span id="iAppraisalNm" name="iAppraisalNm"></span>
						</td>
						<th>평가자</th>
						<td>
							<span id="iAppName" name="iAppName" type="text"></span>
						</td>
						<th>진행상태</th>
						<td>
							<span id="iStatus" name="iStatus" type="text"></span>
						</td>
					</tr>
					<tr>
						<th>성명</th>
						<td>
							<span id="iName" name="iName" type="text"></span>
						</td>
						<th>소속</th>
						<td>
							<span id="iOrgnm" name="iOrgnm" type="text"></span>
						</td>
						<th>직위</th>
						<td>
							<span id="iJikwee" name="iJikwee" type="text"></span>
						</td>
						<th>직책</th>
						<td>
							<span id="iJikchak" name="iJikchak" type="text"></span>
						</td>
					</tr>
				</table>
			</div>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">목표합의서코칭</li>
					<li class="btn">
						<a href="javascript:doAction2('Insert')" 	class="basic authA group2">입력</a>
						<a href="javascript:doAction2('Save')" 	class="basic authA group2">저장</a>
<!-- 						<a href="javascript:Approval();" id="btnSearch" class="basic authA group2">승인</a>
						<a href="javascript:Return();" id="btnSearch" class="basic authA group2">반려</a>
						<a class="basic authA">출력</a>
						<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a> -->
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>