<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {
		var initdata1={};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"Html",  Hidden:0,	Width:45, Align:"Center", ColMerge:1, SaveName:"btnDel",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
   			{Header:"<sht:txt mid='ibsImageV3' mdef='세부\n내역'/>",  	Type:"Image", 	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
   			{Header:"<sht:txt mid='ibsImageV3' mdef='요청서'/>",  		Type:"Image", 	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"ibsImageApr",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
   			{Header:"<sht:txt mid='ibsImageV3' mdef='통보서'/>",  		Type:"Image", 	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"ibsImageNotify",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
   			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자'/>",  		Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
   			{Header:"<sht:txt mid='applStatusCdV5' mdef='신청상태'/>",  	Type:"Combo", 	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
   			{Header:"<sht:txt mid='vacPlanNmV1' mdef='휴가계획기준명'/>",	Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"vacPlanNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
   			{Header:"<sht:txt mid='days' mdef='계획일수'/>",  			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"days",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
   			{Header:"applSeq",  	Type:"Text", 	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
   			{Header:"<sht:txt mid='sabun' mdef='사번'/>",  				Type:"Text", 	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"seq",  		Type:"Text", 	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"<sht:txt mid='rk' mdef='rk'/>",                 Type:"Text",      Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"rk",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }

		];

		IBS_InitSheet(sheet2, initdata1);sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet2.SetDataLinkMouse("ibsImage",1);
		sheet2.SetDataLinkMouse("ibsImageApr",1);
		sheet2.SetDataLinkMouse("ibsImageNotify",1);

		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
		sheet2.SetColProperty("applStatusCd", 	{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction2("Search");
	});

	// 체크 되기 직전 발생.
	function sheet2_OnBeforeCheck(Row, Col) {
		try{
			sheet2.SetAllowCheck(true);
		    if(sheet2.ColSaveName(Col) == "sDelete") {
		        if(sheet2.GetCellValue(Row, "applStatusCd") != "11") {
		            alert("<msg:txt mid='alertAppDelChk' mdef='임시저장일 경우만 삭제할 수 있습니다.'/>");
		            sheet2.SetAllowCheck(false);
		            return;
		        }
		    }
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}


	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#searchUserId").val();
			sheet2.DoSearch( "${ctx}/AnnualPlanApp.do?cmd=getAnnualPlanAppList",param );
			break;
		case "Save":
			if( !confirm("<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?"/>")) { initDelStatus(sheet2); return;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/AnnualPlanApp.do?cmd=saveAnnualPlanApp", $("#sheet1Form").serialize(), -1, 0);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
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

	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet2.ColSaveName(Col) == "ibsImage" ) {

		    	var auth = "R";
		    	if(sheet2.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}

	    		showApplPopup(auth,sheet2.GetCellValue(Row,"applSeq"),sheet2.GetCellValue(Row,"sabun"),sheet2.GetCellValue(Row,"applYmd"));

			} else if(sheet2.ColSaveName(Col) == "ibsImageApr"){
				showRd(Row, "apr", "요청서");
			} else if(sheet2.ColSaveName(Col) == "ibsImageNotify"){
				if(sheet2.GetCellValue(Row, "applStatusCd") == "11") {
					alert("통보서는 신청완료 후 확인 가능합니다.")
					return false;
				} else {
					showRd(Row, "notify", "통보서");
				}

			} else if( sheet2.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet2.SetCellValue(Row, "sStatus", "D");
				doAction2("Save");
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 헤더에서 호출
	function setEmpPage() {
		doAction2("Search");
	}

	//신청 팝업
	function showApplPopup(auth,seq,applInSabun,applYmd) {
		if(!isPopup()) {return;}
		var p = {
				searchApplCd: '26'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};
		
		var url = "";
		var initFunc = '';
		if(auth == "A") {
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}
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
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}

	function getReturnValue(returnValue) {
		doAction2("Search");
	}

	// 현재 접수기간중인 항목이 있는지 체크
	function doApp(){
		var data   = ajaxCall("${ctx}/AnnualPlanApp.do?cmd=getAbleAnnualPlanCount","",false);
		if(data.DATA == null){
			return;
		}else{
			if(Number(data.DATA.cnt) > 0){
				showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');
			}else{
				alert("<msg:txt mid='alertAnnualPlanApp1' mdef='접수기간이 아닙니다.'/>");
				return;
			}
		}

	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 */
	function showRd(Row, type, title){

		const data = {
			rk : sheet2.GetCellValue(Row, 'rk'),
			type: type
		};
		window.top.showRdLayer('/AnnualPlanApp.do?cmd=getEncryptRd', data, null, title);
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">

	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='annualPlanApp' mdef='연차휴가계획신청'/></li>
			<li class="btn">
				<btn:a href="javascript:doApp();" css="btn filled authA" mid="applButton" mdef="신청"/>
				<%-- <btn:a href="javascript:doAction2('Save');" css="basic" mid="save" mdef="저장"/> --%>
				<btn:a href="javascript:doAction2('Down2Excel');" css="btn outline_gray authR" mid="download" mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>