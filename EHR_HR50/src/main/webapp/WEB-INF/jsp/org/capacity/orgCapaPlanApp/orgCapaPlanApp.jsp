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
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"Html",		Hidden:0,	 Width:10,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },
			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",   Type:"Image",  	Hidden:0, Width:40,  	Align:"Center", ColMerge:0,  SaveName:"detail",        	KeyField:0,   CalcLogic:"", Format:"",        Edit:0 },
			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자' />",     Type:"Date",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd",      	KeyField:0,   CalcLogic:"", Format:"Ymd",     Edit:0 },
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />",     Type:"Combo",  	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd", 	KeyField:0,   CalcLogic:"", Format:"",        Edit:0 },
			{Header:"<sht:txt mid='title' mdef='제목'/>",     Type:"Text",  	Hidden:0, Width:100,  	Align:"Center", ColMerge:0,  SaveName:"title", 		KeyField:0,   CalcLogic:"", Format:"",        Edit:0 },

			{Header:"<sht:txt mid='capaType' mdef='충원구분'/>",     Type:"Combo",  	Hidden:1, Width:80,  	Align:"Center", ColMerge:0,  SaveName:"reqGubun", 		KeyField:0,   CalcLogic:"", Format:"",        Edit:0 },
			{Header:"<sht:txt mid='reqHeadcount' mdef='요청인원'/>",     Type:"Int",  	Hidden:0, Width:80,  	Align:"Center", ColMerge:0,  SaveName:"reqCnt", 		KeyField:0,   CalcLogic:"", Format:"",        Edit:0 },

			//Hidden
			{Header:"sabun",		Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:0,  SaveName:"sabun"},
			{Header:"applInSabun",	Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:0,  SaveName:"applInSabun"},
			{Header:"applSeq",		Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:0,  SaveName:"applSeq"}
   		];
		IBS_InitSheet(sheet1, initdata1);sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);

		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");

		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			sheet1.SetAllowCheck(true);
			
		    if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
					alert("<msg:txt mid='alertAppDelChk' mdef='임시저장일 경우만 삭제할 수 있습니다.'/>");
		            sheet1.SetAllowCheck(false);
		            return;
		        }
		    }
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	//Sheet2 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#searchUserId").val();
			sheet1.DoSearch( "${ctx}/OrgCapaPlanApp.do?cmd=getOrgCapaPlanAppList",param );
			break;
		case "Save":
			sheet1.DoSave( "${ctx}/OrgCapaPlanApp.do?cmd=saveOrgCapaPlanApp");
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "detail" ) {

		    	var auth = "R";
		    	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}

	    		showApplPopup(auth,sheet1.GetCellValue(Row,"applSeq"),sheet1.GetCellValue(Row,"applInSabun"),sheet1.GetCellValue(Row,"applYmd"));

			} else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
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
				searchApplCd: '141'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			  , etc01: "1"
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
			width: 880,
			height: 850,
			title: '인력충원요청',
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
		//openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='orgCapaPlanAppList' mdef='인력예산인원신청내역'/></li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray"><tit:txt mid="download" mdef="다운로드"/></a>
				<a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');" class="btn filled"><tit:txt mid='appComLayout' mdef='신청'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>