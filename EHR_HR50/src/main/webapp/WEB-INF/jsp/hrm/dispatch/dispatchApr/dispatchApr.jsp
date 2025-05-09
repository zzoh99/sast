<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/execAppmt.js"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var POST_ITEMS = [];
	
	$(function() {
		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;
		
		var applStstusCd= convCode( ajaxCall("${ctx}/GetDataList.do?cmd=getApplStatusCdList&applStatusNotCd=11,","",false).DATA, "전체");

		$("#applStatusCd").html(applStstusCd[2]);

		$("#applStatusCd").change(function(){
			doAction1("Search");
		});

		$("#sdate").datepicker2({ startdate:"edate"});
		$("#edate").datepicker2({ enddate:"sdate"});

		//엔터키 조회
		$("#saNm, #orgNm, #sdate, #edate").on("keyup", function(e) {
			if(e.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		$("#searchPhotoYn").attr('checked', 'checked');
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:10, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",      							Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",    						Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",    						Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='selectImgV1' mdef='세부\n내역|세부\n내역'/>",			Type:"Image",	Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"detail",					Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='applCd_V3263' mdef='신청서코드'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applCd",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applSabunV7' mdef='신청서순번'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSeq",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='photoV1' mdef='사진|사진'/>",							Type:"Image",	Hidden:0,  	MinWidth:55, 	Align:"Center", ColMerge:0,	SaveName:"photo",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",							Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"sabun",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='suname' mdef='성명|성명'/>",								Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"name",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='qOrgNmV4' mdef='소속|소속'/>",							Type:"Text",	Hidden:0,	Width:120,		Align:"Center",	ColMerge:0,	SaveName:"orgNm",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책코드|직책코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직책|직책",															Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위코드|직위코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직위|직위",															Type:"Text",	Hidden:Number("${jwHdn}"),	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급코드|직급코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직급|직급",															Type:"Text",	Hidden:Number("${jgHdn}"),	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applYmdV2' mdef='신청일자|신청일자'/>",					Type:"Date",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"applYmd",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCd_V698' mdef='결재상태|결재상태'/>",			Type:"Combo",	Hidden:0,	Width:100,		Align:"Center", ColMerge:0,	SaveName:"applStatusCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabunV1' mdef='결재자사번'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"agreeSabun",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeYm' mdef='결재자일자'/>",							Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"agreeYm",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgCdV6' mdef='파견지코드|파견지코드'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dispatchOrgCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgNmV6' mdef='파견지|파견지'/>",						Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dispatchOrgNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='dispatchSdate_V1' mdef='파견기간|시작일'/>",				Type:"Date",	Hidden:0,	Width:90,		Align:"Center",	ColMerge:0,	SaveName:"dispatchSymd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='dispatchEdate_V1' mdef='파견기간|종료일'/>",				Type:"Date",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"dispatchEymd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"발령종료(예정)일|발령종료(예정)일",									Type:"Text",	Hidden:1,	Width:100,	Align:"Center", ColMerge:0, SaveName:"ordEYmd", KeyField:0, Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:8 },  
			{Header:"<sht:txt mid='dispatchReason_V1' mdef='파견사유|파견사유'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left", 	ColMerge:0,	SaveName:"dispatchReason",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100, ToolTip:1 },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSabun",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청입력자사번'/>",					Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applInSabun",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='noteV1' mdef='비고|비고'/>",								Type:"Text",	Hidden:0,	Width:150,		Align:"Left", ColMerge:0,	SaveName:"memo",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100, ToolTip:1 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청자|신청자'/>",					Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"applInSabunNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chkV2' mdef='선택|선택'/>",								Type:"DummyCheck",Hidden:1,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"chkBx",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			//{Header:"<sht:txt mid='ordYn_V543' mdef='발령연계\n처리|발령연계\n처리'/>",		Type:"Text",	Hidden:0,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"ordYn",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},			// 발령연계처리
			{Header:"발령연계\n처리|발령연계\n처리",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"발령연계\n처리|발령연계\n처리",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"발령|발령",						Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세|발령상세",				Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령일|발령일",					Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령seq|발령seq",					Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발령확정\n여부|발령확정\n여부",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"발령확정\n여부|발령확정\n여부",	Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);

		//applStstusCd = convCode( ajaxCall("${ctx}/GetDataList.do?cmd=getApplStatusCdList&applStatusNotCd=11,","",false).DATA, "");
		applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "");
		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		
		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd=J&useYn=Y",false).codeList, "");
		sheet1.SetColProperty("ordDetailCd",       {ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		
		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet1.SetImageList(3,"/common/images/icon/icon_popup.png");
		
		$(window).smartresize(sheetResize);
		sheetInit();
		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getDispatchAprList", $("#sheetForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/DispatchApr.do?cmd=updateDispatchApr", $("#sheetForm").serialize());
			break;
		case "Down2Excel":
			sheet1.Down2Excel({Merge:1});
			break;
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(Row<1) return;
			if( sheet1.ColSaveName(Col) == "detail" ) {
					var applSeq		= sheet1.GetCellValue(Row,"applSeq");
					var applSabun 	= sheet1.GetCellValue(Row,"applSabun");
					var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
					var applYmd 	= sheet1.GetCellValue(Row,"applYmd");
					showApplPopup(applSeq,"98",applSabun,applInSabun,applYmd);
			}

	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}

	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "dispatchEymd"  ) {
				sheet1.SetCellValue(Row,"ordEYmd",sheet1.GetCellValue(Row,"dispatchEymd"));
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
		orgSearchPopup(Row);
	}

	// 소속 팝업
	function orgSearchPopup(Row) {
		if(!isPopup()) {return;}

		var w		= 680;
		var h		= 520;
		var url		= "${ctx}/Popup.do?cmd=orgBasicPopup";
		var args	= new Array();

		gPRow = Row;
		pGubun = "orgBasicPopup";

		openPopup(url+"&authPg=R", args, w, h);
	}

		//팝업 콜백 함수.
		function getReturnValue(returnValue) {
			var rv = $.parseJSON('{' + returnValue+ '}');

			if(pGubun == "orgBasicPopup"){
				sheet1.SetCellValue(gPRow, "dispatchOrgCd", rv["orgCd"]);
				sheet1.SetCellValue(gPRow, "dispatchOrgNm", rv["orgNm"]);
			}
		}


	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}
			
			if(sheet1.RowCount() > 0) {
				for(var i = 2; i < sheet1.RowCount()+2; i++) {
					if(sheet1.GetCellValue(i,"ordYn") == "Y" || sheet1.GetCellValue(i,"prePostYn") == "Y") {
						sheet1.SetRowEditable(i,0);
					}
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

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

	//신청 임시저장 팝업
	function showApplPopup(seq,applCd,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}
		
		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: seq
			  , adminYn: 'Y'
			  , authPg: 'R'
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd 
			};
		gPRow = "";
		pGubun = "viewApprovalMgrResult";
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

	function processBatch(){
		if( sheet1.CheckedRows("chkBx") == "0") return alert("<msg:txt mid='109724' mdef='선택된 자료가 없습니다.'/>");
		var prcNo 	= $("#prcNo").val();
		if(prcNo=="") return alert("<msg:txt mid='109570' mdef='품의 번호를 선택해 주세요.'/>");
		for(var i=1; i<sheet1.LastRow()+1; i++){
			if(sheet1.GetCellValue(i, "chkBx")=="1"){
				sheet1.SetCellValue(i,"processNo",prcNo );
			}
		}
	}

	function ordBatch(){

		if( sheet1.CheckedRows("prePostYn") == "0") {
			alert("<msg:txt mid='109724' mdef='선택된 자료가 없습니다.'/>");
			return;
		}

		var arrRow = sheet1.FindCheckedRow("prePostYn");
		var errRow = "";

		$(arrRow.split("|")).each(function(index,value){
			if(sheet1.GetCellValue(value,"applStatusCd") != 99) {
				errRow = value;
				return false;
			}
		});

		if(errRow != "") {
			alert(errRow+"행은 결재완료 상태가 아닙니다.\n발령연계처리는 결재완료 상태에서만 가능합니다.");
			return;
		};

		/* if(!confirm("발령연계처리 하시겠습니까?")) {
			return;
		} */
		IBS_SaveName(document.sheetForm,sheet1);

		// 발령연계처리 로직확정후 작업예정 2020.05.04 YSH
		//sheet1.DoSave("${ctx}/DispatchApr.do?cmd=saveDispatchAprOrd", $("#sheetForm").serialize(),-1,0);
		//var paramStr = setAppmtParamSet(POST_ITEMS, sheet1, null, $("#sheetForm"));
		//sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegNew", $("#sheetForm").serialize()+paramStr+"&ordGubun=J");
		sheet1.DoSave( "${ctx}/OrdBatch.do?", $("#sheetForm").serialize());
	}



</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input id="ordEnterCd" 	name="ordEnterCd" 	type="hidden"/>
		<input id="ordApplSeq" 	name="ordApplSeq" 	type="hidden"/>
		<input id="ordSabun" 	name="ordSabun" 	type="hidden"/>

		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><tit:txt mid='104389' mdef='신청일'/></th>
					<td colspan="5">
						<input id="sdate" name="sdate" type="text" class="date2" /> ~
						<input id="edate" name="edate" type="text" class="date2" />
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='112999' mdef='결재상태'/></th>
					<td>
						<select id="applStatusCd" name="applStatusCd">
						</select>
					</td>
					<th><tit:txt mid='104279' mdef='소속'/></th>
					<td>
						<input id="orgNm" name="orgNm" type="text" class="text" style="" />
						<!--
						<input id="orgCd" name="orgCd" type="hidden" class="text" style="" readonly/>
						<a href="# " class="button6"><img id="findOrg" src="/common/${theme}/images/btn_search2.gif"/></a>
						<a href="#" class="button7"><img id="clsOrg" src="/common/${theme}/images/icon_undo.gif"/></a>
						 -->
					</td>
					<th><tit:txt mid='112947' mdef='성명/사번'/></th>
					<td>
						<input id="saNm" name="saNm" type="text" class="text" style=""/>
					</td>
					<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
					<td>
						<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
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
							<li class="txt"><tit:txt mid='113258' mdef=' 파견신청현황 '/></li>
							<li class="btn">
								<!--
								품의번호<input id="prcNo" name="prcNo" type="text" class="text w100" readonly/>
								<a href="#" class="button6"><img id="findPrc" src="/common/${theme}/images/btn_search2.gif"/></a>
								<a href="#" class="button7"><img id="clsPrc" src="/common/${theme}/images/icon_undo.gif"/></a>
								<btn:a href="javascript:processBatch()" 			css="basic authA" mid='111058' mdef="품의일괄적용"/>
								 -->
								<btn:a href="javascript:ordBatch()" 				css="basic authA" mid='111513' mdef="발령연계처리"/>
								<btn:a href="javascript:doAction1('Save')" 			css="basic authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authA" mid='down2excel' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
