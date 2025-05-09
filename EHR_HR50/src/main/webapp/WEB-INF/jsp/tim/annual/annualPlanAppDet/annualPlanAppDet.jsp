<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var authPg= "${authPg}";
	var searchApplSabun = "${searchApplSabun}";
	var insertable = true;
	var hdn 			= 1;
	var applStatusCd	 = "";
	var vsGubun = "A";

	$(function() {
		parent.iframeOnLoad("350px");
		
		applStatusCd = parent.$("#applStatusCd").val();
		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		if(applStatusCd == "11") {
			hdn = 0;
		}

		if(applStatusCd != '11' && applStatusCd != ""){
			vsGubun = 'B';
		}

		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:hdn,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0,UpdateEdit:1,	InsertEdit:1 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:8 },
			{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"<sht:txt mid='totDays' mdef='총일수'/>",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totalDays",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"<sht:txt mid='daysV1' mdef='적용일수'/>",	Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"days",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"<sht:txt mid='note' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"SEQ",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"seq",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
			{Header:"dummy",	Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"dummy",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
			{Header:"<sht:txt mid='applSeqV3' mdef='신청순번'/>",	Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		$(window).smartresize(sheetResize); sheetInit();

		const seq = $("#seq").val();
		if (authPg === "A") {

			if ($("#seq option").length === 0) {
				alert("신청 가능한 휴가계획기준이 없습니다. 담당자에게 문의 바랍니다.");
				if (typeof parent.closeApprovalMgrLayer === "function")
					parent.closeApprovalMgrLayer();
			}
		}

		if (seq) {
			getAnnualPlanInfos(seq);
			if (authPg === "A") {
				if (parseFloat($("#info3").val()) > 0) {
					insertable = true;
				} else {
					//insertable = false;
					insertable = true; // 메카로는 -5개 이상 부터는 급여에서  제외하는 제도이기에  잔여일수에 상관없이  연차사용 가능 하다.
				}

				$("#seq").change(function() {
					sheet1.RemoveAll();
					if ($(this).val()) {
						getAnnualPlanInfos(seq);
						if (parseFloat($("#info3").val()) > 0) {
							insertable = true;
						} else {
							//insertable = false;
							insertable = true; // 메카로는 -5개 이상 부터는 급여에서  제외하는 제도이기에  잔여일수에 상관없이  연차사용 가능 하다.
						}

						if(sheet1.RowCount() > 0) {
							for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
								sheet1.SetCellValue(i,"sdate","");
								sheet1.SetCellValue(i,"edate","");
								sheet1.SetCellValue(i,"totalDays","");
								sheet1.SetCellValue(i,"days","");
								sheet1.SetCellValue(i,"note","");
							}
						}
					}
				});
			} else {
				$("#seq").attr("disabled", true);
			}
		}
/*
		if(authPg=="A"){
			if($("#seq").val() != ""){

				var data   = ajaxCall("${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanInfo","&seq="+$("#seq").val()+"&searchApplSabun="+searchApplSabun,false);
				if(data.DATA != null && data.DATA != ""){
					$("#info1").html(data.DATA.usecnt);
					$("#info2").html(data.DATA.usedcnt);
					$("#info3").html(data.DATA.restcnt);
					if(data.DATA.restcnt > 0){
						insertable = true;
					}else{
						//insertable = false;
						insertable = true; // 메카로는 -5개 이상 부터는 급여에서  제외하는 제도이기에  잔여일수에 상관없이  연차사용 가능 하다.
					}
				}


			}else{
				alert("<msg:txt mid='alertErrData' mdef='데이터 로딩 중 오류입니다. 담당자에게 문의하세요.'/>");
			}

			$("#seq").change(function(){
				sheet1.RemoveAll();
				if($("#seq").val() != ""){
					var data   = ajaxCall("${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanInfo","&seq="+$("#seq").val()+"&searchApplSabun="+searchApplSabun,false);
					if(data.DATA != null && data.DATA != ""){
						$("#info1").html(data.DATA.usecnt);
						$("#info2").html(data.DATA.usedcnt);
						$("#info3").html(data.DATA.restcnt);

						if(data.DATA.restcnt > 0){
							insertable = true;
						}else{
							//insertable = false;
							insertable = true; // 메카로는 -5개 이상 부터는 급여에서  제외하는 제도이기에  잔여일수에 상관없이  연차사용 가능 하다.
						}
					}
					if(sheet1.RowCount() > 0) {
						for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
							sheet1.SetCellValue(i,"sdate","");
							sheet1.SetCellValue(i,"edate","");
							sheet1.SetCellValue(i,"totalDays","");
							sheet1.SetCellValue(i,"days","");
							sheet1.SetCellValue(i,"note","");
						}
					}
				}
			});
	    }else{
	    	$("#seq").attr("disabled", true);
	    }
*/
	    doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanAppDetList", $("#dataForm").serialize() );

			var data = ajaxCall("${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanAppDetMap",$("#dataForm").serialize() ,false);

			if(data.map == null){
				return;
			}
			// 지역 구분

			$("#seq").val(data.map.seq);

			if(data.map.seq != ""){

				var data   = ajaxCall("${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanInfo","&seq="+data.map.seq+"&searchApplSabun="+searchApplSabun+"&gubunCd="+vsGubun,false);
				if(data.DATA != null && data.DATA != ""){
					$("#info1").html(data.DATA.usecnt);
					$("#info2").html(data.DATA.usedcnt);
					$("#info3").html(data.DATA.restcnt);

					$("#usedCnt").val(data.DATA.usedcnt);
					$("#useCnt").val(data.DATA.usecnt);
					$("#restCnt").val(data.DATA.restcnt);
					$("#creCnt").val(data.DATA.crecnt);
					$("#gntCd").val(data.DATA.gntcd);
				}
			}else{
				alert("<msg:txt mid='alertErrData' mdef='데이터 로딩 중 오류입니다. 담당자에게 문의하세요.'/>");
			}

			break;
		case "Insert":

			if(insertable){

			}else{
				alert("<msg:txt mid='alertAnnualPlanAppDet1' mdef='연차 잔여일수가 없습니다.'/>");
				return;
			}

			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, "sdate");
			sheet1.SetCellValue(Row, "seq",$("#seq").val());
			sheet1.SetCellValue(Row, "sabun",$("#searchApplsabun").val());
			sheet1.SetCellValue(Row, "applSeq",$("#applSeq").val());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}


	// 저장후 리턴함수
	function setValue(){
		if(authPg=="A"){
			var rtn;
			var returnValue = false;
			if(!dupChk(sheet1,"sdate|", true, true)){return;}

			if(sheet1.RowCount()==0){
				alert("<msg:txt mid='alertAnnualPlanAppDet2' mdef='그리드에 데이터를 입력해주세요.'/>");
				return;
			}

			var data   = ajaxCall("${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanAppDetPreAppliedPlan","&seq="+$("#seq").val()+"&searchApplSabun="+searchApplSabun,false);
			if(data.DATA != null && data.DATA != ""){

				if(parseInt(data.DATA.cnt) > 0){
					alert("<msg:txt mid='alertAnnualPlanAppDet3' mdef='해당 휴가계획기준에 기 신청건이 있습니다.'/>");
					return;
				}
			}

			try{
				
				sheet1.SetCellValue(1, "dummy", "1");
				
				saveStr = sheet1.GetSaveString(0);
				if(saveStr=="KeyFieldError"){
					return;
				}
				var rtn = eval("("+sheet1.GetSaveData("${ctx}/AnnualPlanApp.do?cmd=saveAnnualPlanAppDet", saveStr+"&"+$("#dataForm").serialize())+")");
				//var rtn = ajaxCall("${ctx}/AnnualPlanAppDet.do?cmd=saveAnnualPlanAppDet", saveStr+"&"+$("#dataForm").serialize(),false);

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				}else{
					returnValue = true;
				}

			} catch (ex){
				alert("Script Errors Occurred While Saving." + ex);
				returnValue = false;
			}
		}else{
			returnValue=true;
		}
		return returnValue;

	}

	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sdate" || sheet1.ColSaveName(Col) == "edate"){
				if(sheet1.GetCellValue(Row,"sdate") != "" && sheet1.GetCellValue(Row,"edate") != ""){
					if( sheet1.GetCellValue(Row,"edate").replace(/-/gi, '') < sheet1.GetCellValue(Row,"sdate").replace(/-/gi, '')){
						sheet1.SetCellValue(Row,sheet1.ColSaveName(Col),"");
						alert("<msg:txt mid='alertInputSdateEdate2' mdef='시작일과 종료일을 정확히 입력하세요.'/>");
						return;
					}

					var paramA = "seq="+$("#seq").val()
					+"&sYmd="+sheet1.GetCellValue(Row,"sdate").replace(/-/gi, "")
					+"&eYmd="+sheet1.GetCellValue(Row,"edate").replace(/-/gi, "");
					var getAnnualPlanAppDetAbleCheck = ajaxCall("/AnnualPlanApp.do?cmd=getAnnualPlanAppDetAbleCheck",paramA ,false);
					if(getAnnualPlanAppDetAbleCheck.Message!=""){
						alert("<msg:txt mid='alertAnnualPlanAppDet4' mdef='데이터 체크도중 에러가 발생하였습니다.'/>");
						sheet1.SetCellValue(Row,sheet1.ColSaveName(Col),"");
						sheet1.SetCellValue(Row,"totalDays","");
						sheet1.SetCellValue(Row,"days","");
						sheet1.SelectCell(Row, sheet1.ColSaveName(Col));
						return;
					}else if(Number(getAnnualPlanAppDetAbleCheck.DATA.cnt) <= 0){
						alert("<msg:txt mid='alertAnnualPlanAppDet5' mdef='연차신청 가능 기간을 확인하세요.'/>");
						sheet1.SetCellValue(Row,sheet1.ColSaveName(Col),"");
						sheet1.SetCellValue(Row,"totalDays","");
						sheet1.SetCellValue(Row,"days","");
						sheet1.SelectCell(Row, sheet1.ColSaveName(Col));
						return;
					}

					var resultValue=false;
					for ( var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
						var selSdate=sheet1.GetCellValue(i,"sdate").replace(/-/gi, '');
						var selEdate=sheet1.GetCellValue(i,"edate").replace(/-/gi, '');
						if(selSdate!="" && selEdate!=""){
							for ( var j = sheet1.HeaderRows(); j < sheet1.RowCount()+sheet1.HeaderRows(); j++) {
									var tempSdate=sheet1.GetCellValue(j,"sdate").replace(/-/gi, '');
									var tempEdate=sheet1.GetCellValue(j,"edate").replace(/-/gi, '');
								if(i!=j && tempSdate!="" && tempEdate!=""){
									if( (selSdate >=tempSdate && selSdate<=tempEdate) || (selEdate >=tempSdate && selEdate<=tempEdate) || (selSdate < tempSdate && selEdate > tempEdate) ){
										alert("<msg:txt mid='alertAnnualPlanAppDet6' mdef='선택하신 기간은 이미 입력하신 기간과 겹칩니다.'/>");
										sheet1.SetCellValue(Row,sheet1.ColSaveName(Col),"");
										sheet1.SetCellValue(Row,"totalDays","");
										sheet1.SetCellValue(Row,"days","");
										sheet1.SelectCell(Row, sheet1.ColSaveName(Col));
										return;
									}
								}
							}
						}
					}
					//총일수 적용일수를 구한다.
					var param = "sabun="+'${searchApplSabun}'
					+"&gntCd="+$("#gntCd").val()
					+"&sYmd="+sheet1.GetCellValue(Row,"sdate").replace(/-/gi, "")
					+"&eYmd="+sheet1.GetCellValue(Row,"edate").replace(/-/gi, "");
					// 근태신청 세부내역(잔여일수,휴일일수,재직상태) 조회
					var holiDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetHolidayCnt",param ,false);

					var dayBetween = getDaysBetween(sheet1.GetCellValue(Row,"sdate").replace(/-/gi,"") , sheet1.GetCellValue(Row,"edate").replace(/-/gi,"") ) ;
					sheet1.SetCellValue(Row,"totalDays",dayBetween);
					sheet1.SetCellValue(Row,"days",dayBetween - holiDayCnt.DATA.holidayCnt);

					// 기 신청일수 여부 체크 ttim405기준
					/*
					var applDayCnt = ajaxCall("/GetDataMap.do?cmd=getVacationAppDetApplDayCnt2",param ,false);

					if( parseInt( applDayCnt.DATA.cnt ) > 0) {
						alert("<msg:txt mid='alertVacationAppDet3' mdef='해당 신청기간에 기 신청건이 존재합니다.'/>");
						sheet1.SetCellValue(Row,sheet1.ColSaveName(Col),"");
						sheet1.SetCellValue(Row,"totalDays","");
						sheet1.SetCellValue(Row,"days","");
						sheet1.SelectCell(Row, sheet1.ColSaveName(Col));
						return;
					}
					*/
					//중복체크 TTIM542 기준
					param = "sabun="+'${searchApplSabun}'
					+"&seq="+$("#seq").val()
					+"&applSeq="+$("#applSeq").val()
					+"&sYmd="+sheet1.GetCellValue(Row,"sdate").replace(/-/gi, "")
					+"&eYmd="+sheet1.GetCellValue(Row,"edate").replace(/-/gi, "");
					var annualPlanCheck = ajaxCall("/AnnualPlanApp.do?cmd=getAnnualPlanAppDetDupCheck",param ,false);
					if(annualPlanCheck.Message!=""){
						alert("<msg:txt mid='2017083001028' mdef='데이터 중복체크도중 에러가 발생하였습니다.'/>");
						sheet1.SetCellValue(Row,sheet1.ColSaveName(Col),"");
						sheet1.SetCellValue(Row,"totalDays","");
						sheet1.SetCellValue(Row,"days","");
						sheet1.SelectCell(Row, sheet1.ColSaveName(Col));
						return;
					}else if(Number(annualPlanCheck.DATA.cnt) > 0){
						alert("<msg:txt mid='alertVacationAppDet3' mdef='해당 신청기간에 기 신청건이 존재합니다.'/>");
						sheet1.SetCellValue(Row,sheet1.ColSaveName(Col),"");
						sheet1.SetCellValue(Row,"totalDays","");
						sheet1.SetCellValue(Row,"days","");
						sheet1.SelectCell(Row, sheet1.ColSaveName(Col));
						return;
					}
				}
			}

		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function getAnnualPlanInfos(seq) {
		var data = ajaxCall("${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanInfo", "&seq="+seq+"&searchApplSabun="+searchApplSabun+"&gubunCd="+vsGubun, false);
		if(data.DATA) {
			$("#info1").html(data.DATA.usecnt);
			$("#info2").html(data.DATA.usedcnt);
			$("#info3").html(data.DATA.restcnt);

			$("#usedCnt").val(data.DATA.usedcnt);
			$("#useCnt").val(data.DATA.usecnt);
			$("#restCnt").val(data.DATA.restcnt);
			$("#creCnt").val(data.DATA.crecnt);
			$("#gntCd").val(data.DATA.gntcd);
		}
	}

</script>
</head>
<body class="bodywrap">
<form id="dataForm" name="dataForm" >
	<input type="hidden" id="searchApplsabun" name="searchApplsabun" value="${searchApplSabun}" />
	<input type="hidden" id="applSeq" name="applSeq" value="${searchApplSeq}" />
	<input type="hidden" id="creCnt"  name="creCnt"  value="" />
	<input type="hidden" id="usedCnt" name="usedCnt" value="" />
	<input type="hidden" id="useCnt"  name="useCnt"  value="" />
	<input type="hidden" id="restCnt" name="restCnt" value="" />
	<input type="hidden" id="gntCd" name="gntCd" value="" />
<div class="wrapper">
	<div class="outer">
		<div class="outer">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='annualPlanAppDet' mdef='휴가계획기준'/>
					<select id="seq" name="seq" class="${selectCss} ${readonly} required" required>
					<c:forEach var="a" items="${annualPlanStandardLast}">
						<option value="${a.seq}">${a.vacPlanNm} &nbsp; (<tit:txt mid="vacStdSymd" mdef="연차기간"/>: ${a.vacStdSymd} ~ ${a.vacStdEymd}) </option>
  					</c:forEach>
  					</select>
<%--
					<input type="text" class="text w50p ${readonly} ${required}" disabled="disabled" value="${annualPlanStandardLast.vacPlanNm }" />
					<input type="hidden" id="searchVacationStdYmd" name="searchVacationStdYmd" value="${annualPlanStandardLast.vacStdSYmd }"  />
					--%>
				</li>
				<li class="btn">
				</li>
			</ul>
			</div>
		</div>
		<table class="table">
			<colgroup>
				<col width="33%" />
				<col width="33%" />
				<col width="34%" />
			</colgroup>

			<tr>
				<th style="text-align: center;"><tit:txt mid='2017083001029' mdef='사용가능일수'/></th>
				<th style="text-align: center;"><tit:txt mid='2017083001030' mdef='사용일수'/></th>
				<th style="text-align: center;"><tit:txt mid='2017083001031' mdef='잔여일수'/></th>
			</tr>
			<tr>
				<td style="text-align: center;" ><span id="info1"></span></td>
				<td style="text-align: center;" ><span id="info2"></span></td>
				<td style="text-align: center;" ><span id="info3"></span></td>
			</tr>
		</table>
		<div class="outer">
			<div class="sheet_title">
			<ul>
				<li class="txt2">&nbsp;</li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Insert')" 	css="btn filled authA" mid="insert" mdef="입력"/>
					<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid="download" mdef="다운로드"/>
				</li>
			</ul>
			</div>
		</div>
		<div style="height: 150px">
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "150px", "${ssnLocaleCd}"); </script>
		</div>

	</div>
</div>
</form>
</body>
</html>