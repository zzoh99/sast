<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>[연차촉진]휴가계획신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {
		init_sheet();

		setEmpPage();
	});


	function init_sheet(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='type' mdef='구분'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"planNm",		Edit:0 },

			{Header:"<sht:txt mid='annualPlanSeq' mdef='촉진차수'/>",	Type:"Int",		Hidden:1,	Width:60,	Align:"Center",	SaveName:"planSeq",		Format:"##\\차",	Edit:0 },
			{Header:"<sht:txt mid='annualLeaveUsePeriod' mdef='연차사용기간'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"useSYmd",		Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='annualLeaveUsePeriod' mdef='연차사용기간'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"useEYmd",		Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='useCntV1'  mdef='사용가능일수'/>",		Type:"Float",	Hidden:1,	Width:60,	Align:"Center",	SaveName:"useCnt",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='usedCntV1' mdef='사용일수'/>",		Type:"Float",	Hidden:1,	Width:50,	Align:"Center",	SaveName:"usedCnt",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='restCntV1' mdef='잔여일수'/>",		Type:"Float",	Hidden:0,	Width:50,	Align:"Center",	SaveName:"restCnt",		Format:"",		Edit:0 },

			{Header:"<sht:txt mid='appPeriod' mdef='신청가능기간'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"planStdYmd",	Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='appPeriod' mdef='신청가능기간'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"planEndYmd",	Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='detailV6' mdef='신청'/>",			Type:"Html",	Hidden:0,	Width:50,   Align:"Center",	SaveName:"btnApp",  	Sort:0 },

			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",	Hidden:0, 	Width:45,	Align:"Center", SaveName:"detail",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='applYmdV5' mdef='신청일'/>",			Type:"Date",	Hidden:0, 	Width:80,	Align:"Center", SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />",	Type:"Combo",	Hidden:0, 	Width:80,	Align:"Center", SaveName:"applStatusCd",Format:"",		Edit:0 },

			{Header:"<sht:txt mid='agreeYn_V2158' mdef='동의여부'/>",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	SaveName:"agreeYn",		Format:" ",		Edit:0 },
			{Header:"<sht:txt mid='agreeTime' mdef='동의일시'/>",		Type:"Date",	Hidden:0,	Width:120,	Align:"Center",	SaveName:"agreeTime",	Format:"YmdHms",Edit:0 },

			{Header:"<sht:txt mid='rejectedDelete' mdef='반려삭제'/>",		Type:"Html",	Hidden:0,	 Width:50,  Align:"Center",	SaveName:"btnDel",  Sort:0 },


  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeqAp"}

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "R10010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");

		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		//==============================================================================================================================

		$(window).smartresize(sheetResize); sheetInit();

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/AnnualPlanAgrApp.do?cmd=getAnnualPlanAgrAppList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
        	break;
        case "Save": //임시저장의 경우 삭제처리만함.
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/AnnualPlanAgrApp.do?cmd=deleteAnnualPlanAgrApp", $("#sheet1Form").serialize(), -1, 0);
        	break;

        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;

		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	if ( sheet1.GetCellValue(Row, "applSeqAp") == "" ){
		    		alert("신청내역이 없습니다.");
		    		return;
		    	}

		    	showApplPopup( Row );

		    } else if( sheet1.ColSaveName(Col) == "btnApp" && Value != ""){
		    	showApplPopup( Row );

		    } else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row) {

		if(!isPopup()) {return;}

		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}"
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';

		args["applStatusCd"] = "11";
		if( Row > -1  ){
			var applStatusCd = sheet1.GetCellValue(Row, "applStatusCd");
			if (applStatusCd == "") applStatusCd = "11";

			if(applStatusCd != "11") {
				auth = "R";
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = applStatusCd;
			initFunc = 'initResultLayer';
		}
		var p = {
				searchApplCd: '27'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};
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

	//신청 후 리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

	//인사헤더에서 이름 변경 시
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
   	</form>

	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid="appVacationPlan" mdef="휴가계획신청"/></li>
				<li class="btn">
					<a href="javascript:doAction1('Search')"		class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray" ><tit:txt mid='download' mdef='다운로드'/></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</body>
</html>
