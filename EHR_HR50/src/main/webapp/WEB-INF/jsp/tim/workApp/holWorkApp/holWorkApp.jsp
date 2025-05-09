<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>휴일근무신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var appYn = "Y"; 

	$(function() {
		
		$("#searchAppSYmd").datepicker2().val("${curSysYear}-01-01");
		$("#searchAppEYmd").datepicker2().val("${curSysYear}-12-31");
		$("#searchAppSYmd, #searchAppEYmd").on("keyup", function(e) {
			if (e.keyCode === 13) {
				doAction1("Search");
			}
		})

		
		init_sheet();
		
		setEmpPage();
	});


	function init_sheet(){
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"Html",		Hidden:0,	 Width:45,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",	Hidden:0, Width:45,	 Align:"Center", SaveName:"detail",			Format:"",		Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='applYmdV5' mdef='신청일'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='applStatusCdV2' mdef='신청상태'/>",		Type:"Combo",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applStatusCd",	Format:"",		Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='sYmdV5' mdef='근무일'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"ymd",			Format:"Ymd", 	Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='inTime_V1' mdef='출근시간'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"reqSHm",			Format:"Hm", 	Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='outTime_V1' mdef='퇴근시간'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"reqEHm",			Format:"Hm", 	Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='eduHourV4' mdef='총시간'/>",		Type:"Text",	Hidden:0, Width:60,	 Align:"Center", SaveName:"requestHour",	Format:"", 		Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='rewardType' mdef='보상구분'/>",		Type:"Combo",	Hidden:0, Width:100, Align:"Center", SaveName:"reqTimeCd",		Format:"", 		Edit:0 },
			{Header:"<sht:txt mid='applyHolWork' mdef='휴일근무신청'/>|<sht:txt mid='substituteHoliday' mdef='대체휴무일'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"alterYmd",		Format:"Ymd", 	Edit:0 },
			
			{Header:"<sht:txt mid='rcgnWorkHour' mdef='인정 근무시간'/>|<sht:txt mid='inTime_V1' mdef='출근시간'/>",	Type:"Date",	Hidden:1, Width:60,	 Align:"Center", SaveName:"sHm",			Format:"Hm", 	Edit:0 },
			{Header:"<sht:txt mid='rcgnWorkHour' mdef='인정 근무시간'/>|<sht:txt mid='outTime_V1' mdef='퇴근시간'/>",	Type:"Date",	Hidden:1, Width:60,	 Align:"Center", SaveName:"eHm",			Format:"Hm", 	Edit:0 },
			{Header:"<sht:txt mid='rcgnWorkHour' mdef='인정 근무시간'/>|<sht:txt mid='applyHm' mdef='인정시간'/>",		Type:"Date",	Hidden:1, Width:60,	 Align:"Center", SaveName:"workTime",		Format:"Hm",	Edit:0 },
			
			
   			//대체휴가신청			
			/*{Header:"대체휴가신청|삭제\n/신청",	Type:"Html",   	Hidden:0, Width:60,  Align:"Center", SaveName:"btnDel2",  		Format:"",      Edit:0,	Cursor:"Pointer" },
  			{Header:"대체휴가신청|세부\n내역",	Type:"Image",  	Hidden:0, Width:45,  Align:"Center", SaveName:"detail2",        Format:"",      Edit:0, Cursor:"Pointer" },
			{Header:"대체휴가신청|신청일",		Type:"Date",   	Hidden:0, Width:80,  Align:"Center", SaveName:"applYmd2",       Format:"Ymd",   Edit:0 },
  			{Header:"대체휴가신청|신청상태",		Type:"Combo",  	Hidden:0, Width:80,  Align:"Center", SaveName:"applStatusCd2",  Format:"",      Edit:0 },
  			{Header:"대체휴가신청|근태종류", 		Type:"Text",	Hidden:0, Width:100, Align:"Center", SaveName:"gntNm",			Format:"",		Edit:0 },
  			{Header:"대체휴가신청|휴가일자",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"ymd2",			Format:"Ymd", 	Edit:0 },
  			*/
			
  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun2"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun2"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq2"}

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		//대체휴가신청 헤더 색상
		sheet1.SetRangeBackColor(0,sheet1.SaveNameCol("btnDel2"),1,sheet1.SaveNameCol("ymd2"), "#fdf0f5");
		
 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "R10010,T11010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		sheet1.SetColProperty("applStatusCd2", 	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		sheet1.SetColProperty("reqTimeCd",  	{ComboText:"|"+codeLists["T11010"][0], ComboCode:"|"+codeLists["T11010"][1]} );//  신청구분
		//==============================================================================================================================

		$(window).smartresize(sheetResize); sheetInit();

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/HolWorkApp.do?cmd=getHolWorkAppList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
        	break;	
        case "Save": //임시저장의 경우 삭제처리만함.      
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}  
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/HolWorkApp.do?cmd=deleteHolWorkApp", $("#sheet1Form").serialize(), -1, 0); 
        	break;
        case "Save2": //임시저장의 경우 삭제처리만함.      
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}  
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/HolWorkApp.do?cmd=deleteHolAlterApp", $("#sheet1Form").serialize(), -1, 0); 
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
		    	showApplPopup( Row );
		    	
		    }else if( sheet1.ColSaveName(Col) == "detail2" && Value != "" ) {
		    	if( sheet1.GetCellValue( Row, "applStatusCd" ) == "99" && sheet1.GetCellValue( Row, "applSeq2" ) != "" ) {
			   		showApplPopup2( Row );
		    	}

		    }else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
		    	sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
				
		    }else if( sheet1.ColSaveName(Col) == "btnDel2" && Value != ""){
		    	if( sheet1.GetCellValue(Row, "applSeq2") == "" ){ //신청
		    		showApplPopup2( Row );
		    	}else{
		    		sheet1.SetCellValue(Row, "sStatus", "D");
					doAction1("Save2");	
		    	}
		    }
		    
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	//-----------------------------------------------------------------------------------
	//		휴일근무신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row) {

		if( Row == -1  && $("#searchWorkType").val() == "B"){
			alert("사무직만 신청 가능합니다. \n생산직은 [연장근무사전신청]에서 신청 해주세요.");
			return;
		}
		
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
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
			initFunc = 'initResultLayer';
		}

		var p = {
				searchApplCd: '120'
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
			title: '신청서',
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

	//-----------------------------------------------------------------------------------
	//		대체휴가신청
	//-----------------------------------------------------------------------------------
	function showApplPopup2( Row ) {
		
		if(!isPopup()) {return;}
		
		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		  
		if( sheet1.GetCellValue(Row,"applSeq2") != ""  ){
			if(sheet1.GetCellValue(Row, "applStatusCd2") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq2");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun2");
			applYmd     = sheet1.GetCellValue(Row,"applYmd2");
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd2");
			initFunc = 'initResultLayer';
		}
		var p = {
				searchApplCd: '121'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			  , etc01: sheet1.GetCellValue(Row,"applSeq") 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
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

		//신청자정보 조회
		var user = ajaxCall( "${ctx}/HolWorkApp.do?cmd=getHolWorkAppUserMap", $("#sheet1Form").serialize(),false);
		if ( user != null && user.DATA != null ){ 
			$("#searchWorkType").val(user.DATA.workType);
		}
			
    	doAction1("Search");
    }
	
</script>
<style type="text/css">
.tit_noti {padding-left:10px; color:blue; font-weight:400; font-style:italic;}
</style>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	<input type="hidden" id="searchWorkType" name="searchWorkType" value=""/>
	<div class="sheet_search sheet_search_s outer">
		<table>
		<tr>
			<th><tit:txt mid="111928" mdef="근무기간" /></th>
			<td>
				<input id="searchAppSYmd" name="searchAppSYmd" type="text"  maxlength="10" class="text center date"/> ~
				<input id="searchAppEYmd" name="searchAppEYmd" type="text"  maxlength="10" class="text center date"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark"><tit:txt mid="104081" mdef="조회" /></a>
			</td>
		</tr>
		</table>
	</div>		
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid="applyHolWork" mdef="휴일근무신청" /><span class="tit_noti">( <msg:txt mid="notiHolWorkApp" mdef="생산직은 [연장근무사전신청]에서 신청 해주세요."/> )</span></li>
				<li class="btn">
					<a href="javascript:showApplPopup(-1);" 		class="btn filled" ><tit:txt mid="appTitleV1" mdef="신청" /></a>
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray" ><tit:txt mid="download" mdef="다운로드" /></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</body>
</html>
