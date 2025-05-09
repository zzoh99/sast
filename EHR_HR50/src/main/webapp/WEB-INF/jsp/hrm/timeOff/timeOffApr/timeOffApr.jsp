<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/execAppmt.js"></script>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var POST_ITEMS = [];
	
	$(function() {
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}	

		$("#sYmd").datepicker2({startdate:"eYmd"});
		$("#eYmd").datepicker2({enddate:"sYmd"});
		
		var applCd		= convCode( ajaxCall("${ctx}/TimeOffApr.do?cmd=getTimeOffAprApplCodeList","",false).DATA, "전체");
		var applStstusCd= convCode( ajaxCall("${ctx}/TimeOffApr.do?cmd=getApplStatusCdList&applStatusNotCd=11,","",false).DATA, "전체");
		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;
		
		$("#applCd").html(applCd[2]);
		$("#applStatusCd").html(applStstusCd[2]);

		$("#applCd, #applStatusCd").change(function(){
			doAction1("Search");
		});

		$("#orgNm, #saNm").bind("keyup",function(e){
			if(e.keyCode==13)doAction1("Search");
		});

		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		var initdata = {};
		initdata.Cfg = {FrozenCol:10, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",      						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",    						Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",    						Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			
			{Header:"<sht:txt mid='selectImgV1' mdef='세부\n내역|세부\n내역'/>",				Type:"Image",	Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"detail",					Sort:0, Cursor:"Pointer" },
			{Header:"휴복직계\n출력|휴복직계\n출력",											Type:"CheckBox",	Hidden:0,  Width:80,   Align:"Center",	ColMerge:1,	SaveName:"selectcheck",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='applCd_V3263' mdef='신청서코드'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applCd",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applSabunV7' mdef='신청서순번'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSeq",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='photoV1' mdef='사진|사진'/>",							Type:"Image",	Hidden:0,  	MinWidth:55, 		Align:"Center", ColMerge:0,		SaveName:"photo",			UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",							Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"sabun",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='suname' mdef='성명|성명'/>",								Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"name",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='qOrgNmV4' mdef='소속|소속'/>",							Type:"Text",	Hidden:0,	Width:120,		Align:"Center",	ColMerge:0,	SaveName:"orgNm",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책코드|직책코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직책|직책",															Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위코드|직위코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직위|직위",															Type:"Text",	Hidden:Number("${jwHdn}"),	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급코드|직급코드",													Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직급|직급",															Type:"Text",	Hidden:Number("${jgHdn}"),	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applNm_V3775' mdef='신청종류|신청종류'/>",				Type:"Text",	Hidden:0,	Width:100,		Align:"Center",	ColMerge:0,	SaveName:"applNm",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='applYmdV2' mdef='신청일자|신청일자'/>",					Type:"Text",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"applYmd",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCdV6' mdef='결재상태|결재상태'/>",				Type:"Combo",	Hidden:0,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applStatusCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			//{Header:"<sht:txt mid='applStatusCdV6' mdef='결재상태|결재상태'/>",			Type:"Text",	Hidden:0,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applStatusCdNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refSdate' mdef='휴직기간|시작일'/>",					Type:"Text",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"refSdate",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refEdate' mdef='휴직기간|종료일'/>",					Type:"Date",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"refEdate",				KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refEdate_V1' mdef='휴직기간|신청일수'/>",				Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"refDayCnt",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='actualEdate_V2' mdef='육아휴직|실제종료일'/>",			Type:"Text",	Hidden:1,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"actualEdate",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"<sht:txt mid='famNmV2' mdef='육아휴직|대상자famres'/>",			Type:"Text",	Hidden:1,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"famres",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"<sht:txt mid='famNmV2' mdef='육아휴직|대상자'/>",						Type:"Text",	Hidden:1,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"famNm",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='returnYmdV2' mdef='복직예정일|복직예정일'/>",			Type:"Text",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"returnYmd",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='noteV1' mdef='휴복직사유|휴복직사유'/>",								Type:"Text",	Hidden:0,	Width:150,		Align:"Center", ColMerge:0,	SaveName:"refReason",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ToolTip:1 },
			{Header:"<sht:txt mid='noteV1' mdef='비고|비고'/>",								Type:"Text",	Hidden:0,	Width:150,		Align:"Center", ColMerge:0,	SaveName:"etc",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ToolTip:1 },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSabun",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청입력자사번'/>",					Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applInSabun",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청자|신청자'/>",					Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"applInSabunName",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabunV1' mdef='결재자사번'/>",						Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"agreeSabun",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeYm' mdef='결재자일자'/>",							Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"agreeYm",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chkV2' mdef='선택|선택'/>",								Type:"CheckBox",Hidden:1,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"chkBx",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='processNoV1' mdef='품의번호|품의번호'/>",				Type:"Popup",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"processNo",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			//{Header:"<sht:txt mid='ordYn_V543' mdef='발령연계\n처리|발령연계\n처리'/>",	Type:"CheckBox",	Hidden:0,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"ordYn",					KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100},
			{Header:"발령\n연계처리|발령\n연계처리",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"발령\n연계처리|발령\n연계처리",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"발령일|발령일",					Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령종료(예정)일|발령종료(예정)일",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center", ColMerge:0, SaveName:"ordEYmd", KeyField:0, Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:10 },
			{Header:"발령|발령",						Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세|발령상세",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"재직상태|재직상태",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"발령seq|발령seq",					Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발령확정\n여부|발령확정\n여부",	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"발령확정\n여부|발령확정\n여부",	Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet1.SetImageList(3,"/common/images/icon/icon_popup.png");
		/*
		$("#clsOrg").click(function(){ $("#orgNm").val("");$("#orgCd").val(""); });
		$("#findOrg").click(function(){
			if(!isPopup()) {return;}

			gPRow = "";
			pGubun = "searchOrgBasicPopup";

			openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
		});
		*/
		applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), ""); //11, 오타 아님
		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );

		// $(window).smartresize(sheetResize);
		sheetInit();
		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/TimeOffApr.do?cmd=getTimeOffAprList", $("#sheetForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/SaveData.do?cmd=saveTimeOffApr", $("#sheetForm").serialize() );
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
					var applCd		= sheet1.GetCellValue(Row,"applCd");
					var applSabun 	= sheet1.GetCellValue(Row,"applSabun");
					var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
					var applYmd 	= sheet1.GetCellValue(Row,"applYmd");
					showApplPopup(applSeq,applCd,applSabun,applInSabun,applYmd);
			}else if(sheet1.ColSaveName(Col) == "processNo" && sheet1.GetCellEditable(Row,Col) == 1) {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "viewAppmtConfirmPopup";

	            openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=R", "", "740","520");

			}

	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
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
					if(sheet1.GetCellValue(i,"ordYn") == "Y") {
						sheet1.SetCellEditable(i,"processNo",0);
						sheet1.SetCellEditable(i,"chkBx",0);
					}
					if(sheet1.GetCellValue(i,"prePostYn") == "Y") {
						sheet1.SetRowEditable(i, 0);
						sheet1.SetCellEditable(i,"selectcheck",1);
					}else{
						if(sheet1.GetCellValue(i,"applCd") == "155") {
							sheet1.SetCellValue(i,"statusCd","AA");
						}else{
							sheet1.SetCellValue(i,"statusCd","CA");
							sheet1.SetCellValue(i,"ordEYmd", sheet1.GetCellValue(i,"refEdate"));
						}
						sheet1.SetCellValue(i, "sStatus", "R");
					}
					
					if(sheet1.GetCellValue(i,"ordYn") == "Y") {
						sheet1.SetRowEditable(i, false);
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
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: seq
			  , adminYn: 'Y'
			  , authPg: 'R'
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd
			};
		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		gPRow = "";
		var initFunc = 'initResultLayer';
		pGubun = "viewApprovalMgrResult";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '휴복직신청',
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
			alert((errRow-1)+"행은 결재완료 상태가 아닙니다.\n발령연계처리는 결재완료 상태에서만 가능합니다.");
			return;
		};

		//if(!confirm("발령연계처리 하시겠습니까?")) {
			//return;
		//}
		//IBS_SaveName(document.sheetForm,sheet1);
		//sheet1.DoSave("${ctx}/TimeOffApr.do?cmd=saveTimeOffAprOrd", $("#sheetForm").serialize(),-1,0);
		
		IBS_SaveName(document.sheetForm,sheet1);
		//var paramStr = setAppmtParamSet(POST_ITEMS,sheet1,sheet1.FindStatusRow("U")+"".split(";"),$("#sendForm"));
		// var paramStr = setAppmtParamSet(POST_ITEMS, sheet1, null, $("#sheetForm"));
		//sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegNew", $("#sheetForm").serialize()+paramStr+"&ordGubun=C");
		sheet1.DoSave( "${ctx}/OrdBatch.do?", $("#sheetForm").serialize());
	}

	function getReturnValue(rv) {

        if(pGubun == "searchOrgBasicPopup"){
            $("#orgCd").val(rv["orgCd"]);
            $("#orgNm").val(rv["orgNm"]);
        } else if(pGubun == "viewAppmtConfirmPopup") {
            sheet1.SetCellValue(gPRow, "processNo", rv["processNo"] );
        } else if(pGubun == "viewApprovalMgrResult") {
    		doAction1("Search");
        }
	}
	

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	 function rdPopup(){
		//debugger;
		if(!isPopup()) {return;}
		/*
		if($("#applCd").val() == "") {
			alert("출력할 신청서 종류를 선택 하세요.");
			$("#applCd").focus();
			return;
		}
		*/
		pGubun = "viewRdPopup";

		var applSeq = "";
		
		if(sheet1.RowCount() != 0){
			
			var sRow = sheet1.FindCheckedRow("selectcheck");
			$(sRow.split("|")).each(function(index,value){				
			//	applSeq  += ",'" + sheet1.GetCellValue(value,"applSeq")+"'";
				applSeq += ",('${ssnEnterCd}','" + sheet1.GetCellValue(value,"applSeq") + "')";
			});

			if( applSeq == "" ){
				alert("<msg:txt mid='109876' mdef='출력 대상자를 선택하세요'/>");
				return;
			}
			
	  		var w 		= 800;
			var h 		= 600;
			var url 	= "${ctx}/RdPopup.do";
			var args 	= new Array();
			// args의 Y/N 구분자는 없으면 N과 같음
	
			
			var rdMrd = "";
			var rdTitle = "";
			var rdParam = "";
			var rdZoomRatio = 100;
			var applCd = $("#applCd").val();
			//var sabun = sheet1.GetCellValue(row,"sabun");
			//var reqYy = sheet1.GetCellValue(row,"reqYy");
			//var sYmd = sheet1.GetCellValue(row,"sYmd");
			//var eYmd = sheet1.GetCellValue(row,"eYmd");
			//var purpose = sheet1.GetCellValue(sheet1.LastRow(),"purpose");
			//var submitOffice = sheet1.GetCellValue(sheet1.LastRow(),"submitOffice");
			//var imgPath = "${baseURL}/OrgPhotoOut.do?enterCd=${ssnEnterCd}&logoCd=5&orgCd=0";
			//var stamp = sheet1.GetCellValue( i, "signPrtYn" );
			
			/*
			if(applCd == "151") {
				rdMrd = "hrm/timeOff/TimeOffAppPatDet.mrd";
				rdTitle = "육아휴직계";
			}else 
			*/
		//	if(applCd == "151" || applCd == "153" || applCd == "154" ||  applCd == "156" || applCd == "157" || applCd == "159") {
				rdMrd = "hrm/timeOff/TimeOffAppDet.mrd";
				rdTitle = "휴복직계";
	//		}else if(applCd == "155") {
	//			rdMrd = "hrm/timeOff/TimeOffAppReturnWorkAppDet.mrd";
	//			rdTitle = "복직계";
	//		}
			//rdParam = "[${ssnEnterCd}]["+applSeq+"][${baseURL}]["+sheet1.GetCellValue(row, "applInSabun")+"]["+sheet1.GetCellValue(row, "applCd")+"]["+sheet1.GetCellValue(row, "applYmd")+"]" ; //rd파라매터
			
			rdParam = "[${ssnEnterCd}]["+applSeq+"][${baseURL}]";
			
			var imgPath = " " ;
			args["rdTitle"] = rdTitle ;//rd Popup제목
			args["rdMrd"] = rdMrd ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
	
			args["rdParam"] = rdParam;//rd파라매터
			args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
			args["rdToolBarYn"] = "Y" ;//툴바여부
			args["rdZoomRatio"] = rdZoomRatio ;//확대축소비율
	
			args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
			args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
			args["rdExcelYn"] 	= "N" ;//기능컨트롤_엑셀
			args["rdWordYn"] 	= "N" ;//기능컨트롤_워드
			args["rdPptYn"] 	= "N" ;//기능컨트롤_파워포인트
			args["rdHwpYn"] 	= "N" ;//기능컨트롤_한글
			args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF
	
			openPopup(url,args,w,h);//알디출력을 위한 팝업창
	
			doAction1("Search");
		}else{
			alert("출력할 대상이 없습니다. 조회 후 사용해주십시요.");
		}
	 }

	 function showRd(){
		 let checkedRowCount = sheet1.CheckedRows('selectcheck');
		 if(checkedRowCount === 0){
			 alert('<msg:txt mid="109876" mdef="대상자를 선택하세요" />');
			 return;
		 }

		 let checkedRows = sheet1.FindCheckedRow('selectcheck');
		 let searchApplSeq = '';
		 $(checkedRows.split("|")).each(function(index,value){
			 searchApplSeq += ",(\'" + '${ssnEnterCd}' + "\',\'" + sheet1.GetCellValue(value,"applSeq") + "\')";
		 });

		 let parameters = Utils.encase('${ssnEnterCd}');
		 parameters += Utils.encase(searchApplSeq);
		 parameters += Utils.encase('${imageBaseUrl}');
		 
		 /*
         const data2 = {
             rdMrd : '/hrm/timeOff/TimeOffAppDet.mrd'
             , parameterType : 'rp'//rp 또는 rv
             , parameters : parameters
         };
         console.log(data2);
         */
		 //암호화 할 데이터 생성
		 const data = {
			parameters : searchApplSeq
		 };

		 window.top.showRdLayer('/TimeOffApr.do?cmd=getEncryptRd', data, "휴복직계");
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
					<th><tit:txt mid='104351' mdef='신청종류'/></th>
					<td>
						<select id="applCd" name="applCd">
						</select>
					</td>
					<th><tit:txt mid='104389' mdef='신청일'/></th>
					<td colspan="3">
						<input id="sYmd" name="sYmd" type="text" size="10" class="date2" value="<%//= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),365)%>"/> ~
						<input id="eYmd" name="eYmd" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
					</td>
				</tr>
				<tr>	
					<th><tit:txt mid='104279' mdef='소속'/></th>				
					<td>
						<input id="orgNm" name="orgNm" type="text" class="text" style="" />						
						<input id="orgCd" name="orgCd" type="hidden" class="text" style="" readonly/>
						<!-- 
						<a href="# " class="button6"><img id="findOrg" src="/common/${theme}/images/btn_search2.gif"/></a>
						<a href="#" class="button7"><img id="clsOrg" src="/common/${theme}/images/icon_undo.gif"/></a>
						 -->
					</td>
					<th><tit:txt mid='112947' mdef='성명/사번'/></th>
					<td>
						<input id="saNm" name="saNm" type="text" class="text" style=""/>
					</td>
					<th><tit:txt mid='112999' mdef='결재상태'/></th>
					<td>
						<select id="applStatusCd" name="applStatusCd">
						</select>
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
							<li class="txt"><tit:txt mid='113258' mdef=' 휴복직 신청현황/관리 '/></li>
							<li class="btn">
								<!--
								품의번호<input id="prcNo" name="prcNo" type="text" class="text w100" readonly/>
								<a href="#" class="button6"><img id="findPrc" src="/common/${theme}/images/btn_search2.gif"/></a>
								<a href="#" class="button7"><img id="clsPrc" src="/common/${theme}/images/icon_undo.gif"/></a>
								<btn:a href="javascript:processBatch()" 			css="basic authA" mid='111058' mdef="품의일괄적용"/>
								 -->
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authA" mid='down2excel' mdef="다운로드"/>
								<btn:a href="javascript:showRd()"					css="btn outline-gray authA" mid='printV1' mdef="출력"/>
								<btn:a href="javascript:doAction1('Save')" 			css="btn soft authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:ordBatch()" 				css="btn filled authA" mid='111513' mdef="발령연계처리"/>
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
