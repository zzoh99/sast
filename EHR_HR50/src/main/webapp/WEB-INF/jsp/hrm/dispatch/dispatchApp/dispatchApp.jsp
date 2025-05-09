<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var applCd		= 98;
	var gPRow = "";
	var pGubun = "";
	var rdPopupSign = "";

	$(function() {

	//========================================================================================================================
		// 조회조건
		
		var allText = "<sch:txt mid='all' mdef='전체' />";

        // 결재상태
        var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList"), allText);
		$("#searchApplStatusCd").html(applStatusCd[2]);

	//========================================================================================================================

		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='detail_V3360' mdef='세부내역|세부내역'/>",		Type:"Image",	Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"detail",		Sort:0, Cursor:"Pointer" },
			//{Header:"<sht:txt mid='btnPrt' mdef='휴복직계|휴복직계'/>",			Type:"Html",	Hidden:0,	Width:60,		Align:"Center",	ColMerge:0,	SaveName:"btnPrt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chargeSabun' mdef='사번'/>",						Type:"Text",	Hidden:1,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applCd_V3737' mdef='신청서코드'/>",				Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applSabunV7' mdef='신청서순번'/>",				Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applNm_V3775' mdef='신청종류|신청종류'/>",		Type:"Text",	Hidden:1,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"applNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='applYmdV10' mdef='신청일|신청일'/>",				Type:"Date",	Hidden:0,	Width:90,		Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCd_V697' mdef='결재상태코드'/>",		Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCdV6' mdef='결재상태|결재상태'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applStatusNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgCd_V697' mdef='파견지코드'/>",				Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"dispatchOrgCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='dispatchOrgNmV111' mdef='파견지|파견지'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dispatchOrgNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='202005200000041' mdef='파견기간|시작일'/>",		Type:"Date",	Hidden:0,	Width:90,		Align:"Center",	ColMerge:0,	SaveName:"dispatchSymd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='202005200000042' mdef='파견기간|종료일'/>",		Type:"Date",	Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"dispatchEymd",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='202005200000044' mdef='파견사유|파견사유'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Left", 	ColMerge:0,	SaveName:"dispatchReason",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ToolTip:1 },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",				Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청입력자사번'/>",			Type:"Text",	Hidden:1,	Width:0,		Align:"Center", ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabun111' mdef='신청자|신청자'/>",			Type:"Text",	Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"applInSabunNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
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
			case "Search":		
				sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getDispatchAppList", $("#sheetForm").serialize() ); 
				break;

			case "Save":
				IBS_SaveName(document.sheetForm,sheet1);
				sheet1.DoSave("${ctx}/SaveData.do?cmd=deleteDispatchApp", $("#sheetForm").serialize() );
				break;

			case "Down2Excel":	sheet1.Down2Excel({Merge:1}); break;
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(Row<1) return;
			if( sheet1.ColSaveName(Col) == "detail" ) {
				if(sheet1.GetCellImage(Row,"detail")!= ""){

					var applSeq		= sheet1.GetCellValue(Row,"applSeq");
					var applSabun 	= sheet1.GetCellValue(Row,"applSabun");
					var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
					var applCd 		= sheet1.GetCellValue(Row,"applCd");
					var applYmd 	= sheet1.GetCellValue(Row,"applYmd");

					showApplPopup2("A",applSeq,applCd,applSabun,applInSabun,applYmd);
				}
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }

		for(var i = 2; i < sheet1.RowCount()+2; i++) {
			//임시저장일때 버튼 출력 조건
			if(sheet1.GetCellValue(i, "applStatusCd") == "11") {
				if($("#searchUserId").val() ==  "${ssnSabun}") {//본인일 경우 전자서명버튼
					sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',1)"><tit:txt mid='' mdef='전자서명'/></a>');
				}else{//본인이 아닐경우 출력버튼
					sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="rdPopup('+i+',2)"><tit:txt mid='103799' mdef='출력'/></a>');
				}
				sheet1.SetCellValue(i, "sStatus", 'R');
			}else{
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

		alert("<msg:txt mid='202007030000001' mdef='파견지의 부실점장을 추가하여 신청바랍니다.\n유의사항을 반드시 참조하세요.'/>");
		
		var searchStatusCd  = "${ssnStatusCd}";
		var p = {
				searchApplCd: '98'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			  , etc01: 'Y' 
			};
		var url = "";
		var initFunc = '';
		if(auth == "A") {				
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
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

	//신청 임시저장 팝업
	function showApplPopup2(auth,seq,applCd,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		var statusCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCd");

		if(statusCd != "11") { auth = "R";}
		var param = "searchApplCd=98"
					+"&searchApplSeq="+seq
					+"&adminYn=N"
					+"&authPg="+auth
					+"&searchApplSabun="+applSabun
					+"&searchSabun="+applInSabun
					+"&searchApplYmd="+applYmd;
		if(statusCd == "11") {
			if(applSabun == applInSabun){
				param += "&etc01=Y";
			}
			url ="/ApprovalMgr.do?cmd=viewApprovalMgr&"+param;
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResult&"+param;
		}

		gPRow = "";
		pGubun = "viewApprovalMgr";

		openPopup(url,"",900,800);
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
		gPRow = row;
		pGubun = "viewRdPopup";

  		var w 		= 800;
		var h 		= 600;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음


		var rdMrd = "";
		var rdTitle = "";
		var rdParam = "";
		var rdZoomRatio = 100;
		//var applCd = sheet1.GetCellValue(row,"applCd");
		var applCd = "98";
		var applSeq = sheet1.GetCellValue(row,"applSeq");
		//var sabun = sheet1.GetCellValue(row,"sabun");
		//var reqYy = sheet1.GetCellValue(row,"reqYy");
		//var sYmd = sheet1.GetCellValue(row,"sYmd");
		//var eYmd = sheet1.GetCellValue(row,"eYmd");
		//var purpose = sheet1.GetCellValue(sheet1.LastRow(),"purpose");
		//var submitOffice = sheet1.GetCellValue(sheet1.LastRow(),"submitOffice");
		//var imgPath = "${baseURL}/OrgPhotoOut.do?enterCd=${ssnEnterCd}&logoCd=5&orgCd=0";
		//var stamp = sheet1.GetCellValue( i, "signPrtYn" );

		rdMrd = "hrm/dispatch/DispatchAppDet.mrd";
		rdTitle = "파견신청";

		rdParam = "[${ssnEnterCd}]["+applSeq+"][${baseURL}]["+sheet1.GetCellValue(row, "applInSabun")+"]["+sheet1.GetCellValue(row, "applCd")+"]["+sheet1.GetCellValue(row, "applYmd")+"]" ; //rd파라매터

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

		// 전자서명 기능 활성화(동의 되지 않은 경우에 활성화)
		var rdSignUse = "N";
		if (asd_type == "1" ) {
			//서명 영역 활성화
			rdSignUse="Y";
		}

		args["rdSignUse"] 		= rdSignUse;
		args["rdSignHandler"] 	= "dispatchRetireApp";
		args["rdSignParam"] 	= "[${ssnEnterCd}]["+sheet1.GetCellValue(row, "applInSabun")+"]["+sheet1.GetCellValue(row, "applSeq")+"]["+sheet1.GetCellValue(row, "applCd")+"]["+sheet1.GetCellValue(row, "applYmd")+"]";

		rdPopupSign =  openPopup(url,args,w,h);//알디출력을 위한 팝업창
	 }

	function getReturnValue(returnValue) {
       	var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "viewApprovalMgr"){
    		doAction1("Search");
        }
        //신청팝업일 경우
        if(pGubun == "viewApplButton"){
        	if($("#searchUserId").val() ==  "${ssnSabun}") {//본인일 경우
				alert("휴복직계 전자서명 후 신청 됩니다. 전자서명을 진행하여 주시기바랍니다.");
			}else{//본인이 아닐경우
				alert("휴복직계 출력 후 본인서명 스캔파일을 첨부하여 세부내역에서 신청 해 주세요.");
			}
        	doAction1("Search");
        }

		// 전자서명 제출이 정상 처리된 경우 진행
		if( pGubun == "viewRdPopup" && rv["flag"] == "rdSignUse" ) {
			//alert("status : " + rv["status"] + ", message : " + rv["message"] + ", timestamp : " + rv["timestamp"]);
			var params  = "enterCd=${ssnEnterCd}";
			    params += "&sabun=" + sheet1.GetCellValue(gPRow, "applInSabun");
			    params += "&applSeq=" + sheet1.GetCellValue(gPRow, "applSeq");
			    params += "&applCd=" + sheet1.GetCellValue(gPRow, "applCd");
			    params += "&applYmd=" + sheet1.GetCellValue(gPRow, "applYmd");
			    params += "&referApplGubun=1";

			var data = ajaxCall("${ctx}/DispatchApp.do?cmd=saveDispatchAppSignData", params, false);
			//console.log(data);
			doAction1("Search");

			alert("신청되었습니다");

			setTimeout(function(){
				rdPopupSign.close();//전자서명 후
			}, 3000);

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
					<th><tit:txt mid='112999' mdef='결재상태'/></th>
					<td>
						<select id="searchApplStatusCd" name="searchApplStatusCd" onchange="javascript:doAction1('Search');">
						</select>
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
							<li class="txt"><tit:txt mid='202005200000040' mdef='파견신청 '/></li>
							<li class="btn">
								<btn:a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');" css="button" mid='applButton' mdef="신청"/>
								<btn:a href="javascript:doAction1('Save')" css="basic" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" css="basic" mid='down2excel' mdef="다운로드"/>
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
