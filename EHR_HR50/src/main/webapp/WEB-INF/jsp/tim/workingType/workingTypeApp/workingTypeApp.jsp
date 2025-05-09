<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='ceriApp' mdef='근로시간단축 신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var config1 = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		var info1 = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		var headers1 = [
			{Text:"No|삭제|상태|세부\n내역|신청일|결재상태|신청기간|신청기간|단축시간|단축시간|근무시간|신청서종류|조정여부",Align:"Center"},
			{Text:"No|삭제|상태|세부\n내역|신청일|결재상태|시작일|종료일|출근단축|퇴근단축|근무시간|신청서종류|조정여부",Align:"Center"}
		];

		var cols1 = [
			{Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"swtApplyStrYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"swtApplyEndYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"swtStrH",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"swtEndH",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appWorkHour",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:0,	Width:170,	Align:"Center",	ColMerge:0,	SaveName:"applNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"wtCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkCol",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			
			];

		sheet1.SetCountPosition(0);
		sheet1.SetConfig(config1);
		sheet1.InitHeaders(headers1, info1);
		sheet1.InitColumns(cols1);
		sheet1.SetEditable("${editable}");
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage",true);
	
		/* 결재상태 조회 */
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "전체");

		sheet1.SetColProperty("applStatusCd",	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );

		$("#applStatusCd").html(applStatusCd[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#searchUserId").val()
						+"&applStatusCd="+$("#applStatusCd").val();
			sheet1.DoSearch( "${ctx}/WorkingTypeApp.do?cmd=getWorkingTypeAppList", param );
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/WorkingTypeApp.do?cmd=saveWorkingTypeApp", $("#sheetForm").serialize());
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
			
			for(var i = 2; i <= sheet1.RowCount()+1; i++) {
				if(sheet1.GetCellValue(i,"chkCol") == '1'){
					
					sheet1.SetCellFontColor(i,6, "red"); 
					sheet1.SetCellFontColor(i,7, "red"); 
					
				}
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
		    if( sheet1.ColSaveName(Col) == "ibsImage" ) {

		    	var auth = "R";
		    	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}

	    		showApplPopup(auth,sheet1.GetCellValue(Row,"applSeq"),sheet1.GetCellValue(Row,"sabun"),sheet1.GetCellValue(Row,"applYmd"),sheet1.GetCellValue(Row,"applCd"),sheet1.GetCellValue(Row,"wtCd"));

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

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

	// 헤더에서 호출
	function setEmpPage() {
		/* $("#applCd").val(""); */
		$("#applStatusCd").val("");
		
		doAction1("Search");
	}

	//신청 팝업
	function showApplPopup(auth,seq,applInSabun,applYmd,applCd,wtCd) {

		if(!isPopup()) {return;}

		if(auth == "") {
			alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}

		if(applCd == "") {
			alert("신청서종류를 선택하여 주십시오.");
			$("#applCd").focus();
			return;
		}

		const p = {
			searchApplCd: applCd,
			searchApplSeq: seq,
			wtCd: wtCd,
			adminYn: 'N',
			authPg: auth,
			searchApplSabun: $("#searchUserId").val(),
			searchSabun: applInSabun,
			searchApplYmd: applYmd,
		}

		var url = "";

		if(auth == "A") {
			url ="/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		}

		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 900,
			height: 600,
			title: '근로시간단축 신청',
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
<div class="wrapper">

	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='ceriApp' mdef='근로시간단축 신청'/></li>
					<li class="btn">
						<btn:a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}','300','1');" css="basic" mid='applButton' mdef="신청"/>
						<btn:a href="javascript:doAction1('Search')" css="basic" mid='search' mdef="조회"/>
						<btn:a href="javascript:doAction1('Save')" css="basic" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction1('Down2Excel')" css="basic" mid='down2excel' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>

			<form id="sheetForm" name="sheetForm">
			<table border="0" cellspacing="0" cellpadding="0" class="default inner">
			<colgroup>
				<col width="10%" />
				<col width="90%" />
				<col width="" />
			</colgroup>
			<tr>
				<th><tit:txt mid='112999' mdef='결재상태'/></th>
				<td>
					<select id="applStatusCd" name="applStatusCd" ></select>
				</td>
			</tr>
			</table>
			</form>

			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
	
</div>
</body>
</html>
