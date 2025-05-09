<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='vacationUpdApp2' mdef='근태취소신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"근태코드|근태코드",					Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번|사번",						Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"사용기준년도|사용기준년도",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"근태명|근태명",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발생기준일|발생기준일",				Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"baseYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사용기준|시작일",					Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useSYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사용기준|종료일",					Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useEYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발생일수|발생일수",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"creCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"이월일수|이월일수",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"frdCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"하계휴가\n차감일수|하계휴가\n차감일수",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"modCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"사용일수|사용일수",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"usedCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
			{Header:"현 잔여일수|현 잔여일수",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"restCnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
   		];
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		sheet1.SetEditable(false);
		sheet1.SetVisible(true);

   		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>", Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>", Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>", Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='gntCdV1' mdef='근태코드|근태코드'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"<sht:txt mid='yearV1' mdef='사용기준년도|사용기준년도'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
   			{Header:"<sht:txt mid='detail' mdef='세부\n내역|세부\n내역'/>", Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
   			{Header:"<sht:txt mid='applYmdV10' mdef='신청일|신청일'/>", Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='applStatusCdV8' mdef='신청상태|신청상태'/>", Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='gntCdV4' mdef='취소대상|근태종류'/>",Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='sYmdV3' mdef='취소대상|시작일'/>",Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='eYmdV3' mdef='취소대상|종료일'/>",Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='closeDay' mdef='적용\n일수|적용\n일수'/>", Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"holDay",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
   			{Header:"<sht:txt mid='gntReqReason' mdef='사유|사유'/>", Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"gntReqReason",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2000},
   			{Header:"<sht:txt mid='applSeqV9' mdef='신청순번|신청순번'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='bApplSeq' mdef='원신청순번|원신청순번'/>",Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"bApplSeq",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='applSabunV10' mdef='신청순번|신청순번'/>",Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='applInSabunV8' mdef='신청자사번|신청자사번'/>",Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
   		];

   		IBS_InitSheet(sheet2, initdata2);
   		sheet2.SetCountPosition(4);
		//sheet2.SetConfig(config2);
		//sheet2.InitHeaders(headers2, info2);
		//sheet2.InitColumns(cols2);
		sheet2.SetEditable("${editable}");
		sheet2.SetVisible(true);

		sheet2.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet2.SetDataLinkMouse("ibsImage", 1);

		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");

		sheet2.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function() {
        $("#year").bind("keyup",function(event){
        	makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#year").val() == "") {
				alert("<msg:txt mid='alertHolidayMgr1' mdef='년도를 입력하여 주십시오.'/>");
				return;
			}

			var param = "sabun="+$("#searchUserId").val()
						+"&year="+$("#year").val();

			sheet1.DoSearch( "${ctx}/VacationUpdApp.do?cmd=getVacationUpdAppList",param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#searchUserId").val()
						+"&year="+$("#year").val();

			sheet2.DoSearch( "${ctx}/VacationUpdApp.do?cmd=getVacationUpdAppExList",param );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/VacationUpdApp.do?cmd=saveVacationUpdAppEx", $("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
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

			doAction2('Search');
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

	    		showApplPopup(auth,sheet2.GetCellValue(Row,"applSeq"),sheet2.GetCellValue(Row,"applInSabun"),sheet2.GetCellValue(Row,"applYmd"));
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

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

	// 헤더에서 호출
	function setEmpPage() {
		doAction1("Search");
	}

	//신청 팝업
	function showApplPopup(auth,seq,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}

		var p = {
				searchApplCd: '23'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			};
		
		var url = '';
		var initFunc = '';
		if(auth == "A") {
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
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
	
	function getReturnValue(returnValue) {
		doAction1("Search");
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
			<li class="txt"><tit:txt mid='vacationUpdApp1' mdef='잔여근태내역'/></li>
			<li class="btn">
				<tit:txt mid='201705100000147' mdef='근태연도'/> <input id="year" name="year" type="text"  maxlength="4" class="text required center date" value="${curSysYear}"/>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<div class="outer">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "150px","${ssnLocaleCd}"); </script>
	</div>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='vacationUpdApp2' mdef='근태취소신청'/></li>
			<li class="btn">
				<btn:a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');" css="button authR" mid='applButton' mdef="신청"/>
				<btn:a href="javascript:doAction2('Save');" css="basic" mid='save' mdef="저장"/>
				<a href="javascript:doAction2('Down2Excel');" class="basic"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>

</div>
</body>
</html>
