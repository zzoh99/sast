<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var applCd		= null;
	var gPRow = "";
	var pGubun = "";
	var rdPopupSign = "";
	var statusCd = "";

	$(function() {

		var allText = "<sch:txt mid='all' mdef='전체' />";

		applCd		= convCode( ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppApplCodeList","",false).DATA, allText);
		$("#applCd").html(applCd[2]);
		$("#applCd").change(function(){
			doAction1("Search");
		});

		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			//{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",					Type:"Html",  		Hidden:0,	Width:45, 	Align:"Center", ColMerge:1, SaveName:"btnDel",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='detail_V3360' mdef='세부내역|세부내역'/>",			Type:"Image",	Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"detail",		Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='btnPrt' mdef='휴복직계|휴복직계'/>",				Type:"Html",	Hidden:0,	Width:60,		Align:"Center",	ColMerge:0,	SaveName:"btnPrt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chargeSabun' mdef='사번'/>",					Type:"Text",	Hidden:1,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applCd_V3737' mdef='신청서코드'/>",				Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applSabunV7' mdef='신청서순번'/>",				Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applNm_V3775' mdef='신청종류|신청종류'/>",			Type:"Text",	Hidden:0,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"applNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='applYmdV10' mdef='신청일|신청일'/>",				Type:"Text",	Hidden:0,	Width:90,		Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCd_V697' mdef='결재상태코드'/>",		Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCdV6' mdef='결재상태|결재상태'/>",		Type:"Text",	Hidden:0,	Width:100,		Align:"Center",	ColMerge:0,	SaveName:"applStatusCdNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refSdate_V1' mdef='휴직기간|시작일'/>",			Type:"Date",	Hidden:0,	Width:90,		Align:"Center",	ColMerge:0,	SaveName:"refSdate",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refEdate_V1' mdef='휴직기간|종료일'/>",			Type:"Date",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"refEdate",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refEdate_V1' mdef='휴직기간|신청일수'/>",			Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"refDayCnt",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='actualEdate_V1' mdef='육아휴직|실제종료일'/>",		Type:"Text",	Hidden:1,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"actualEdate",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='202005210000079' mdef='육아휴직|대상자'/>",				Type:"Text",	Hidden:1,	Width:80,		Align:"Center", ColMerge:0,	SaveName:"famNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='returnYmdV2' mdef='복직예정일|복직예정일'/>",		Type:"Text",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"returnYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='contiYn' mdef='연장\n여부|연장\n여부'/>",			Type:"Text",	Hidden:1,	Width:50,		Align:"Center", ColMerge:0,	SaveName:"contiYn",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refReason_V1' mdef='휴복직\n사유|휴복직\n사유'/>",	Type:"Text",	Hidden:0,	Width:300,		Align:"Left", 	ColMerge:0,	SaveName:"refReason",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ToolTip:1 },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",				Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청입력자사번'/>",			Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabun111' mdef='신청자|신청자'/>",			Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"applInSabunName",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='signCnt' mdef='사인여부|사인여부'/>",			Type:"Text",	Hidden:1,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"signCnt",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"rk",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rk",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0}

		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
		sheet1.SetImageList(1,"/common/images/icon/icon_popup.png");

		$(window).smartresize(sheetResize);
		sheetInit();
		setEmpPage();
	});
	function setEmpPage() {
		$("#searchApplSabun").val($("#searchUserId").val());
		doAction1("Search");
	}
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		sheet1.DoSearch( "${ctx}/TimeOffApp.do?cmd=getTimeOffAppList", $("#sheetForm").serialize() ); break;
		case "Save": 
			if(sheet1.FindStatusRow("I|U") != ""){
			    if(!dupChk(sheet1,"applCd|sdate", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/TimeOffApp.do?cmd=saveTimeOffApp" , $("#sheetForm").serialize() ,-1,0);  break;
		case "Copy":      	sheet1.DataCopy();	break;
		case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
		case "Down2Excel":	sheet1.Down2Excel({Merge:1}); break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#rsSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
			sheet2.DoSearch( "${ctx}/TimeOffApp.do?cmd=getTimeOffAppDetailList", $("#sheetForm").serialize());
			break;
		case "Save":
// 			if(sheet2.FindStatusRow("I|U") != ""){
// 			    if(!dupChk(sheet2,"questionSeq", true, true)){break;}
// 			}
			$("#rsSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
			//IBS_SaveName(document.sheetForm,sheet2);
			//sheet2.DoSave("${ctx}/TimeOffApp.do?cmd=saveTimeOffAppDetail", $("#sheetForm").serialize() );
            break;
		case "Insert":
			var iRow = sheet2.DataInsert(sheet2.LastRow()+1);
			sheet2.SelectCell(iRow, 4);
			sheet2.SetCellImage(iRow,"detail",1);
			sheet2.SetCellValue(iRow, "researchSeq",sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
			break;
		case "Copy":
			var cRow = sheet2.DataCopy();
			sheet2.SetCellValue(cRow, "questionSeq","");
			break;
		}
	}
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(Row<1) return;
			if( sheet1.ColSaveName(Col) == "detail" && Row >= sheet1.HeaderRows()) {

					var applSeq		= sheet1.GetCellValue(Row,"applSeq");
					var applSabun 	= sheet1.GetCellValue(Row,"applSabun");
					var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
					var applCd 		= sheet1.GetCellValue(Row,"applCd");
					var applYmd 	= sheet1.GetCellValue(Row,"applYmd");

					var signCnt ="Y";
					
					showApplPopup2("A",applSeq,applCd,applSabun,applInSabun,applYmd,signCnt);
			}else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
		    	if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }

		for(var i = 2; i < sheet1.RowCount()+2; i++) {
			//임시저장일때 버튼 출력 조건
			/*
			if(sheet1.GetCellValue(i, "applStatusCd") == "11") {
				if($("#searchUserId").val() ==  "${ssnSabun}") {//본인일 경우 전자서명버튼
					if(sheet1.GetCellValue(i, "signCnt") > 0) {
						sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',2)"><tit:txt mid='202005200000022' mdef='서명완료'/></a>');
					}else{
						sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',1)" style="color:#FF0000"><tit:txt mid='104386' mdef='전자서명'/></a>');
					}
				}else{//본인이 아닐경우 출력버튼
					sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',2)"><tit:txt mid='103799' mdef='출력'/></a>');
				}
				sheet1.SetCellValue(i, "sStatus", 'R');
			}else{
				if($("#searchUserId").val() ==  "${ssnSabun}") {//본인일 경우 전자서명버튼
					sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',2)"><tit:txt mid='202005200000022' mdef='서명완료'/></a>');
				}else{
					sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',2)"><tit:txt mid='103799' mdef='출력'/></a>');
				}
				sheet1.SetCellValue(i, "sStatus", 'R');
			}
			*/
			
			if(sheet1.GetCellValue(i, "applStatusCd") == "99") {
				sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',2)"><tit:txt mid='103799' mdef='출력'/></a>');
				sheet1.SetCellValue(i, "sStatus", 'R');
			}
		}

		sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	//신청 팝업
	function showApplPopup(auth,seq,applInSabun,applYmd) {
		if(!isPopup()) {return;}
		
		if(auth == "") {
			alert("<msg:txt mid='110262' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}
		if($("#applCd").val() == "") {
			alert("<msg:txt mid='110450' mdef='신청종류를 선택해 주세요.'/>"); return;
		}
		var data = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppMap","searchApplCd="+$("#applCd").val(),false);
		//재직상태
		var statusdata = ajaxCall("${ctx}/TimeOffApp.do?cmd=getStatusCd", "searchSabun=" + $("#searchApplSabun").val() , false).DATA;
		statusCd=statusdata.statusCd;
		if(statusCd == 'RA'){//퇴직
			alert("<msg:txt mid='202005200000026' mdef='퇴직 직원은 신청할 수 없습니다.'/>");
			return;
		}else{
			if(data != null && data.DATA != null) {
				if(data.DATA.ordTypeCd == 'N'){//복직
					if(statusCd != 'CA'){
						alert("<msg:txt mid='202005210000064' mdef='휴직 직원인 경우만 복직신청할 수 있습니다.'/>");
						return;
					}
				}
			}
		}

		var p = {
				searchApplCd: $("#applCd").val()
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			  , etc01: 'Y' 
			};
		var url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
		var initFunc = 'initLayer';

		gPRow = "";
		pGubun = "viewApplButton";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: ' ',
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

	//신청 임시저장 팝업
	function showApplPopup2(auth,seq,applCd,applSabun,applInSabun,applYmd,signCnt) {
		if(!isPopup()) {return;}

		var statusCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCd");

		if(statusCd != "11") { auth = "R";}
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd
			  , etc02: signCnt
		};

		var url = '';
		var initFunc = '';
		if(statusCd == "11") {
			if($("#searchUserId").val() !=  "${ssnSabun}") {//본인이 아닐경우
				p['etc01'] = 'N'; 
			}
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
			
		}

		gPRow = "";
		pGubun = "viewApprovalMgr";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: ' ',
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

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	 function rdPopup(row,asd_type){
		if(!isPopup()) {return;}

		const data = {
			rk : sheet1.GetCellValue(row, 'rk'),
			asd_type : asd_type
		};

		window.top.showRdLayer('/TimeOffApp.do?cmd=getEncryptRd', data, null, "휴복직계");


		<%--gPRow = row;--%>
		<%--pGubun = "viewRdPopup";--%>

  		<%--var w 		= 900;--%>
		<%--var h 		= screen.availHeight-110;--%>
		<%--var url 	= "${ctx}/RdPopup.do";--%>
		<%--var args 	= new Array();--%>
		<%--// args의 Y/N 구분자는 없으면 N과 같음--%>


		<%--var rdMrd = "";--%>
		<%--var rdTitle = "";--%>
		<%--var rdParam = "";--%>
		<%--var rdZoomRatio = 100;--%>
		<%--var applCd = sheet1.GetCellValue(row,"applCd");--%>
		<%--var applSeq1 = sheet1.GetCellValue(row,"applSeq");--%>
		<%--var applSeq = "";--%>
		<%--//var sabun = sheet1.GetCellValue(row,"sabun");--%>
		<%--//var reqYy = sheet1.GetCellValue(row,"reqYy");--%>
		<%--//var sYmd = sheet1.GetCellValue(row,"sYmd");--%>
		<%--//var eYmd = sheet1.GetCellValue(row,"eYmd");--%>
		<%--//var purpose = sheet1.GetCellValue(sheet1.LastRow(),"purpose");--%>
		<%--//var submitOffice = sheet1.GetCellValue(sheet1.LastRow(),"submitOffice");--%>
		<%--//var imgPath = "${baseURL}/OrgPhotoOut.do?enterCd=${ssnEnterCd}&logoCd=5&orgCd=0";--%>
		<%--//var stamp = sheet1.GetCellValue( i, "signPrtYn" );--%>

		<%--/*--%>
		<%--if(applCd == "151") {--%>
		<%--	rdMrd = "hrm/timeOff/TimeOffAppPatDet.mrd";--%>
		<%--	rdTitle = "육아휴직계";--%>
		<%--}else--%>
		<%--*/--%>
		
		<%-- applSeq += ",('${ssnEnterCd}','" +applSeq1 + "')";--%>
		
		<%--if(applCd == "151" || applCd == "153" || applCd == "154"  || applCd == "156" || applCd == "157" || applCd == "159" || applCd == "158") {--%>
		<%--	rdMrd = "hrm/timeOff/TimeOffAppDet.mrd";--%>
		<%--	rdTitle = "휴직계";--%>
		<%--}else if(applCd == "155") {--%>
		<%--	rdMrd = "hrm/timeOff/TimeOffAppReturnWorkAppDet.mrd";--%>
		<%--	rdTitle = "복직계";--%>
		<%--}--%>

		<%--//rdParam = "[${ssnEnterCd}]["+applSeq+"][${baseURL}]["+sheet1.GetCellValue(row, "applInSabun")+"]["+sheet1.GetCellValue(row, "applCd")+"]["+sheet1.GetCellValue(row, "applYmd")+"]" ; //rd파라매터--%>

		<%--rdParam = "[${ssnEnterCd}]["+applSeq+"][${baseURL}]";--%>

		<%--var imgPath = " " ;--%>
		<%--args["rdTitle"] = rdTitle ;//rd Popup제목--%>
		<%--args["rdMrd"] = rdMrd ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명--%>

		<%--args["rdParam"] = rdParam;//rd파라매터--%>
		<%--args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)--%>
		<%--args["rdToolBarYn"] = "Y" ;//툴바여부--%>
		<%--args["rdZoomRatio"] = rdZoomRatio ;//확대축소비율--%>

		<%--args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장--%>
		<%--args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄--%>
		<%--args["rdExcelYn"] 	= "N" ;//기능컨트롤_엑셀--%>
		<%--args["rdWordYn"] 	= "N" ;//기능컨트롤_워드--%>
		<%--args["rdPptYn"] 	= "N" ;//기능컨트롤_파워포인트--%>
		<%--args["rdHwpYn"] 	= "N" ;//기능컨트롤_한글--%>
		<%--args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF--%>
		<%--args["rdParamZoomYn"] 	= "0.75" ;//확대축소비율 75%--%>

		<%--// 전자서명 기능 활성화(동의 되지 않은 경우에 활성화)--%>
		<%--var rdSignUse = "N";--%>
		<%--if (asd_type == "1" ) {--%>
		<%--	//서명 영역 활성화--%>
		<%--	rdSignUse="Y";--%>
		<%--}--%>

		<%--args["rdSignUse"] 		= rdSignUse;--%>
		<%--args["rdSignHandler"] 	= "TimeOffRetireApp";--%>
		<%--args["rdSignParam"] 	= "[${ssnEnterCd}]["+sheet1.GetCellValue(row, "applInSabun")+"]["+sheet1.GetCellValue(row, "applSeq")+"]["+sheet1.GetCellValue(row, "applCd")+"]["+sheet1.GetCellValue(row, "applYmd")+"]";--%>

		<%--rdPopupSign =  openPopup(url,args,w,h);//알디출력을 위한 팝업창--%>
	 }

	function getReturnValue(returnValue) {
		//console.log(returnValue);
       	//var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "viewApprovalMgr"){
    		doAction1("Search");
        }
        //신청팝업일 경우
        if(pGubun == "viewApplButton"){
        	doAction1("Search");
        }

	}

</script>
</head>
<body class="bodywrap">
<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input id="searchApplSabun" name="searchApplSabun" value="" type="hidden"/>
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><tit:txt mid='104351' mdef='신청종류'/></th>
					<td>
						<select id="applCd" name="applCd">
						</select>
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
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
							<li class="txt"><tit:txt mid='112139' mdef='휴복직신청 '/>&nbsp;&nbsp;</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" css="btn outline-gray" mid='down2excel' mdef="다운로드"/>
								<btn:a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');" css="btn filled" mid='applButton' mdef="휴복직신청"/>
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
