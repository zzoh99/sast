<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {


		$("#year").keyup(function() {
			makeNumber(this,'A');
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",Hidden:Number("${sNoHdn}"),	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"<sht:txt mid='sChk' mdef='선택'/>",				Type:"CheckBox",Hidden:0,	Width:40,  Align:"Center",	ColMerge:0,	SaveName:"check1",    	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='sabun' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"sabun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='name' mdef='성명'/>",				Type:"Text",	Hidden:0,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"name",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"alias",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='orgNm' mdef='소속'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='jikchakCd' mdef='직책'/>",		Type:"Text",	Hidden:0,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",KeyField:0,Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:60,	Align:"Center", ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
		{Header:"<sht:txt mid='creCntV2' mdef='발생\n일수'/>",	Type:"Int",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"creCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='usedCntV2' mdef='사용\n일수'/>",	Type:"Int",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"usedCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='restCntV2' mdef='잔여\n일수'/>",	Type:"Int",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"restCnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='daysV2' mdef='계획\n일수'/>",		Type:"Int",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"days",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"<sht:txt mid='confirmYnV1' mdef='확정\n여부'/>",Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"confirmYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },

		//{Header:"기준일",		Type:"Text",	Hidden:1,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"vacationStdYmd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		//{Header:"사용기준일",	Type:"Text",	Hidden:1,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"useSYmd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		//{Header:"사용기준일",	Type:"Text",	Hidden:1,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"useEYmd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		//{Header:"SEQ",	Type:"Text",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"vSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 }
		{Header:"yy",		Type:"Text",	Hidden:1,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"yy",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var vSeq 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAnnualPlanAppReceiveList",false).codeList, "");
		$("#vSeq").html(vSeq[2]);

		//var vacationStdYmd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getAnnualPlanStandard"), "");
		//$("#vacationStdYmd").html(vacationStdYmd[2]);

		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:35,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:35,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sdateV14' mdef='시작\n일자'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",	KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='edateV9' mdef='종료\n일자'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",	KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='totDays' mdef='총일수'/>",				Type:"Int",			Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"totalDays",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"<sht:txt mid='holDayV3' mdef='적용\n일수'/>",			Type:"Int",			Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"days",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='note' mdef='비고'/>",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"note",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"sabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='applSeqV13' mdef='신청번호'/>",			Type:"Text",		Hidden:1,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"applSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"SEQ",				Type:"Text",		Hidden:1,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"seq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 }
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);


		// 사원구분코드(H10030)
		var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
		$("#manageCd").html(manageCd[2]);
		$("#manageCd").select2({placeholder:" 선택"});


		$("#searchGntCd").bind("change", function(event) {
			doAction1("Search") ;
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $("#name, #orgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			sheet1.DoSearch( "${ctx}/AnnualPlanStaMgr.do?cmd=getAnnualPlanStaMgrList",$("#searchForm").serialize());
			break;
		case "Confirm":
			if(sheet1.RowCount() > 0 && sheet1.CheckedRows("check1") > 0) {
				if(confirm("<msg:txt mid='alertAnnualPlanStaMgr1' mdef='확정 처리를 하시겠습니까?'/>")){
					var saveStr;
					var rtn;
					saveStr = sheet1.GetSaveString(0);
					rtn = eval("("+sheet1.GetSaveData("${ctx}/AnnualPlanStaMgr.do?cmd=saveAnnualPlanStaMgrConfirm", saveStr+"&vSeq="+$("#vSeq").val())+")");
					//rtn = sheet1.DoSave( "${ctx}/AnnualPlanStaMgr.do?cmd=saveAnnualPlanStaMgrConfirm",$("#searchForm").serialize()+"&vSeq="+$("#vSeq").val());
					if(rtn["Result"]!=null){
						alert(rtn["Result"]["Message"]);
						if(rtn["Result"]["Code"] >= 0){
							doAction1("Search");
						}
					}
				}
			} else {
				alert("<msg:txt mid='alertNoSelect' mdef='선택된 행이 없거나 데이터가 없습니다.'/>");
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param="sabun="+sheet1.GetCellValue(sheet1.GetSelectionRows(), "sabun")+"&seq="+$("#vSeq").val();
			sheet2.DoSearch( "${ctx}/AnnualPlanStaMgr.do?cmd=getAnnualPlanStaMgrList2",param);
			break;
		case "Insert":
			var Row = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row,"sabun",sheet1.GetCellValue(sheet1.GetSelectionRows(),"sabun"));
			sheet2.SetCellValue(Row,"seq",$("#vSeq").val());
			//sheet2.SetCellValue(Row,"vacationStdYmd",sheet1.GetCellValue(sheet1.GetSelectionRows(),"vacationStdYmd"));
			break;
		case "Save":
			if(!dupChk(sheet2,"sdate|edate", true, true)){break;}
			IBS_SaveName(document.searchForm,sheet2);
			sheet2.DoSave( "${ctx}/AnnualPlanStaMgr.do?cmd=saveAnnualPlanStaMgr",$("#searchForm").serialize());
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesin:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
		case "Copy":
			var Row=sheet2.DataCopy();
		break;
		}
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(OldRow!=NewRow && sheet1.ColSaveName(NewCol) != "check1"){
	    		doAction2("Search");
			}
			if(sheet1.GetCellValue(NewRow,"confirmYn")=="Y"){
				$("a[id*=hideTarget]").hide();
				sheet2.SetColHidden("sDelete",true);
			}else{
				$("a[id*=hideTarget]").show();
				sheet2.SetColHidden("sDelete",false);
			}
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if(sheet1.RowCount() > 0) {
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
					if( sheet1.GetCellValue(i,"days")=="" || sheet1.GetCellValue(i,"days")==0 || sheet1.GetCellValue(i,"confirmYn")=="" || sheet1.GetCellValue(i,"confirmYn")=="Y" ){
						sheet1.SetCellEditable(i,"check1",false);
					}
				}
			}

			doAction2("Clear");

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	// 셀 값이 바뀔때 발생
	function sheet2_OnChange(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "sdate" || sheet2.ColSaveName(Col) == "edate"){
				if(sheet2.GetCellValue(Row,"sdate") != "" && sheet2.GetCellValue(Row,"edate") != ""){
					if( sheet2.GetCellValue(Row,"edate").replace(/-/gi, '') < sheet2.GetCellValue(Row,"sdate").replace(/-/gi, '')){
						sheet2.SetCellValue(Row,sheet2.ColSaveName(Col),"");
						alert("<msg:txt mid='alertInputSdateEdate2' mdef='시작일과 종료일을 정확히 입력하세요.'/>");
						return;
					}
					var resultValue=false;
					for ( var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++) {
						var selSdate=sheet2.GetCellValue(i,"sdate").replace(/-/gi, '');
						var selEdate=sheet2.GetCellValue(i,"edate").replace(/-/gi, '');
						if(selSdate!="" && selEdate!=""){
							for ( var j = sheet2.HeaderRows(); j < sheet2.RowCount()+sheet2.HeaderRows(); j++) {
									var tempSdate=sheet2.GetCellValue(j,"sdate").replace(/-/gi, '');
									var tempEdate=sheet2.GetCellValue(j,"edate").replace(/-/gi, '');
								if(i!=j && tempSdate!="" && tempEdate!=""){
									if( (selSdate >=tempSdate && selSdate<=tempEdate) || (selEdate >=tempSdate && selEdate<=tempEdate) || (selSdate < tempSdate && selEdate > tempEdate) ){
										//alert("i="+i+" j="+j);
										//alert("selSdate="+selSdate+" tempSdate="+tempSdate+" selEdate="+selEdate+" tempEdate="+tempEdate);
										//alert("1="+(selSdate >=tempSdate && selSdate<=tempEdate));
										//alert("2="+(selEdate >=tempSdate && selEdate<=tempEdate));
										//alert("3="+(selSdate < tempSdate && selEdate > tempEdate));
										alert("<msg:txt mid='alertAnnualPlanAppDet6' mdef='선택하신 기간은 이미 입력하신 기간과 겹칩니다.'/>");
										sheet2.SetCellValue(Row,sheet2.ColSaveName(Col),"");
										sheet2.SetCellValue(Row,"totalDays","");
										sheet2.SetCellValue(Row,"days","");
										sheet2.SelectCell(Row, sheet2.ColSaveName(Col));
										return;
									}
								}
							}
						}
					}
					//총일수 적용일수를 구한다.
					var param = "sabun="+sheet2.GetCellValue(Row,"applSabun")
					+"&gntCd=14"
					+"&sYmd="+sheet2.GetCellValue(Row,"sdate").replace(/-/gi, "")
					+"&eYmd="+sheet2.GetCellValue(Row,"edate").replace(/-/gi, "");
					// 근태신청 세부내역(잔여일수,휴일일수,재직상태) 조회
					var holiDayCnt = ajaxCall("/GetDataMap.do?cmd=getVacationAppDetHolidayCnt",param ,false);

					var dayBetween = getDaysBetween(sheet2.GetCellValue(Row,"sdate").replace(/-/gi,"") , sheet2.GetCellValue(Row,"edate").replace(/-/gi,"") ) ;
					sheet2.SetCellValue(Row,"totalDays",dayBetween);
					sheet2.SetCellValue(Row,"days",dayBetween - holiDayCnt.DATA.holidayCnt);

					// 기 신청일수 여부 체크
					var applDayCnt = ajaxCall("/GetDataMap.do?cmd=getVacationAppDetApplDayCnt",param ,false);

					if( parseInt( applDayCnt.DATA.cnt ) > 0) {
						alert("<msg:txt mid='alertVacationAppDet3' mdef='해당 신청기간에 기 신청건이 존재합니다.'/>");
						sheet2.SetCellValue(Row,sheet2.ColSaveName(Col),"");
						sheet2.SetCellValue(Row,"totalDays","");
						sheet2.SetCellValue(Row,"days","");
						sheet2.SelectCell(Row, sheet2.ColSaveName(Col));
						return;
					}
					//중복체크
					param = "sabun="+'${searchApplSabun}'
					+"&seq="+$("#vSeq").val()
					+"&applSeq="+$("#applSeq").val()
					+"&sYmd="+sheet2.GetCellValue(Row,"sdate").replace(/-/gi, "")
					+"&eYmd="+sheet2.GetCellValue(Row,"edate").replace(/-/gi, "");
					var annualPlanCheck = ajaxCall("/AnnualPlanAppDet.do?cmd=getAnnualPlanAppDetDupCheck",param ,false);
					if(annualPlanCheck.Message!=""){
						alert("<msg:txt mid='2017083001028' mdef='데이터 중복체크도중 에러가 발생하였습니다.'/>");
						sheet2.SetCellValue(Row,sheet1.ColSaveName(Col),"");
						sheet2.SetCellValue(Row,"totalDays","");
						sheet2.SetCellValue(Row,"days","");
						sheet2.SelectCell(Row, sheet2.ColSaveName(Col));
						return;
					}else if(Number(annualPlanCheck.DATA.cnt) > 0){
						alert("<msg:txt mid='alertVacationAppDet3' mdef='해당 신청기간에 기 신청건이 존재합니다.'/>");
						sheet2.SetCellValue(Row,sheet2.ColSaveName(Col),"");
						sheet2.SetCellValue(Row,"totalDays","");
						sheet2.SetCellValue(Row,"days","");
						sheet2.SelectCell(Row, sheet2.ColSaveName(Col));
						return;
					}
				}
			}

		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="sheet_search outer">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="multiManageCd" name="multiManageCd" />
		<div>
		<table>
		<tr>
			<th><tit:txt mid='annualPlanAppDet' mdef='휴가계획기준'/></th>
			<td>
				<select id="vSeq" name="vSeq" onchange="doAction1('Search');">
				</select>
			</td>
			<th><tit:txt mid='orgNm' mdef='조직'/></th>
			<td>
				<input id="orgNm" name="orgNm" type="text" class="text"/>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="name" name="name" type="text" class="text"/>
			</td>
			<th><tit:txt mid='103784' mdef='사원구분'/></th>
			<td>  <select id="manageCd" name="manageCd" multiple></select></td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid="search" mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
		</form>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='annualPlanStaMgr2' mdef='휴가계획내역'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Confirm');" css="btn filled authA" mid="confirm" mdef="확정"/>
						<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray" mid="download" mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='annualPlanStaMgr3' mdef='휴가계획등록'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Insert')" 	css="btn outline_gray authA" id="hideTarget1"  mid="insert" mdef="입력"/>
						<btn:a href="javascript:doAction2('Copy');" css="btn outline_gray authA" id="hideTarget2"  mid="copy" mdef="복사"/>
						<btn:a href="javascript:doAction2('Save');" css="btn filled authA" id="hideTarget3"  mid="save" mdef="저장"/>
						<btn:a href="javascript:doAction2('Down2Excel');" css="btn outline_gray" mid="download" mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>