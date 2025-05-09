<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>
<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",  	 		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='applSeqV3' mdef='신청순번'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='ibsImage' mdef='세부\n내역'/>",		Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applStatusCdV5' mdef='처리상태'/>",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			//{Header:"휴가계획기준명",			Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"vacationStdYmd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgNm' mdef='부서'/>",				Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"<sht:txt mid='jikchakCd' mdef='직책'/>",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",				Type:"Text",	Hidden:Number("${jgHdn}"),	Width:60,	Align:"Center", ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",				Type:"Text",	Hidden:Number("${jwHdn}"),	Width:60,	Align:"Center", ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='reqSabun' mdef='신청자사번'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='vacPlanNmV1' mdef='휴가계획기준명'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"vacPlanNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='days' mdef='계획일수'/>",				Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"days",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetCountPosition(0);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);


		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		$("#applStatusCd").html(applStatusCd[2]);

		//var vacationStdYmd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getAnnualPlanStandard"), "<tit:txt mid='103895' mdef='전체'/>");
		//$("#vacationStdYmd").html(vacationStdYmd[2]);


		var vSeq 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAnnualPlanAppReceiveList2",false).codeList, "");
		$("#seq").html(vSeq[2]);

        $("#name,#orgNm, #sYmd, #eYmd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
		$("#sYmd").datepicker2({startdate:"eYmd", onReturn: getManageCd});
		$("#eYmd").datepicker2({enddate:"sYmd", onReturn: getManageCd});

		// 사원구분코드(H10030)
		getManageCd();
	});

	function getManageCd() {
		let baseSYmd = $("#sYmd").val();
		let baseEYmd = $("#eYmd").val();

		const manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd, baseEYmd), "");
		$("#manageCd").html(manageCd[2]);
		$("#manageCd").select2({placeholder:" 선택"});
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#sYmd").val() == "") {
				alert("<msg:txt mid='alertSYmd' mdef='시작일자를 입력하여 주십시오.'/>");
				$("#sYmd").focus();
				return;
			}
			if($("#eYmd").val() == "") {
				alert("<msg:txt mid='alertEYmd' mdef='종료일자를 입력하여 주십시오.'/>");
				$("#eYmd").focus();
				return;
			}

			var param = "sYmd="+$("#sYmd").val().replace(/-/gi,"")
						+"&eYmd="+$("#eYmd").val().replace(/-/gi,"")
						+"&orgNm="+encodeURIComponent($("#orgNm").val())
						+"&applStatusCd="+$("#applStatusCd").val()
						+"&name="+encodeURIComponent($("#name").val())
						+"&seq="+$("#seq").val()
			            +"&multiManageCd="+getMultiSelect($("#manageCd").val());

			sheet1.DoSearch( "${ctx}/AnnualPlanApr.do?cmd=getAnnualPlanAprList",param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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


	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" ) {

		    	var applSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
	    		var applYmd = sheet1.GetCellValue(Row,"applYmd");

	    		showApplPopup("R",applSeq,applSabun,applInSabun,applYmd);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd) {

		if(auth == "") {
			alert("<msg:txt mid='alertInputAuth' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}

		var p = {
				searchApplCd: '26'
			  , searchApplSeq: seq
			  , adminYn: 'Y'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd 
			};
		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
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
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='104084' mdef='신청일자'/></th>
				<td>
					<input id="sYmd" name="sYmd" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-7)%>"/> ~
					<input id="eYmd" name="eYmd" type="text" size="10" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
				</td>
				<th><tit:txt mid='113596' mdef='결제상태'/></th>
				<td >
					<select id="applStatusCd" name="applStatusCd" onchange="javascript:doAction1('Search');">
					</select>
				</td>
				<th><tit:txt mid='annualPlanAppDet' mdef='휴가계획기준'/></th>
				<td >
					<select id="seq" name="seq" onchange="javascript:doAction1('Search');">
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td >
					<input id="orgNm" name="orgNm" type="text" class="text" />
				</td>
				<th><tit:txt mid='empNm' mdef='성명'/>/<tit:txt mid='103975' mdef='사번'/></th>
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
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='annualPlanApr' mdef='연차휴가계획승인'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>