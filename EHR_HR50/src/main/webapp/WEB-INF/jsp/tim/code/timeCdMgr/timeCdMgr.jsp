<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='timeCdMgr' mdef='근태코드관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	$(function() {
        $("#searchGntNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
        $("#searchGntGubunCd, #searchApplYn, #searchPayYn").bind("change", function(e){
        	doAction1("Search");
        });
		
		//Sheet 초기화
		init_sheet1();
		doAction1("Search");
	});
	
	function init_sheet1(){	
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22,FrozenCol:5};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' 			mdef='No|No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1' 		mdef='\n삭제|\n삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatusV1' 		mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='gntCdV1' 		mdef='근태코드|근태코드'/>",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",			KeyField:1,	Format:"",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='gntNm' 			mdef='근태명|근태명'/>",				Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"gntNm",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='languageCd' 		mdef='어휘코드'/>",					Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm1' 	mdef='어휘코드명|어휘코드명'/>",			Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='gntCdV6' 		mdef='근태종류|근태종류'/>",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntGubunCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"신청단위|신청단위",														Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"requestUseType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:18 },
			{Header:"근태신청\n여부|근태신청\n여부",											Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N", HeaderCheck:0 },
			{Header:"발생휴가\n사용|발생휴가\n사용",											Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"vacationYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N", HeaderCheck:0 },
			{Header:"<sht:txt mid='orderSeq' 		mdef='순서|순서'/>",					Type:"Text",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='holInclYn' 		mdef='휴일포함\n여부|휴일포함\n여부'/>",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"holInclYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N", HeaderCheck:0 },
			{Header:"<sht:txt mid='baseCnt' 		mdef='신청일수|최소'/>",				Type:"Float",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"baseCnt",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='maxCnt' 			mdef='신청일수|최대'/>",				Type:"Float",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"maxCnt",			KeyField:0,	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='maxUnit'	 		mdef='최대한도\n단위|최대한도\n단위'/>",	Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"maxUnit",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"<sht:txt mid='stdApplyHourV1' 	mdef='적용시간|적용시간'/>",				Type:"Text",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"stdApplyHour",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"근무코드|근무코드",														Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"대상자|대상자선택",		Type:"Popup",	 Hidden:0, Width:200, Align:"Left",	  SaveName:"searchDesc",KeyField:0,	Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"대상자|조건검색순번",	Type:"Text",	 Hidden:0, Width:100, Align:"Center", SaveName:"searchSeq",	KeyField:0,	Format:"", 		UpdateEdit:0, InsertEdit:0 },
<c:if test="${ssnGrpCd == '10'}">			
			{Header:"대상자|상세",			Type:"Image",	 Hidden:0, Width:45,  Align:"Center", SaveName:"searchDtl",	KeyField:0,	Format:"", 		UpdateEdit:0, InsertEdit:0, Cursor:"Pointer" },
</c:if>			
			/*2022.03.16 근태신청 체크 사항 추가*/
			{Header:"신청가능\n기준일|신청가능\n기준일",		Type:"Combo",     	Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"useStdDateCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"신청가능일\n(이전)|신청가능일\n(이전)",	Type:"Combo",     	Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"useSdateCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"신청가능일\n(이후)|신청가능일\n(이후)",	Type:"Combo",     	Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"useEdateCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"신청\n마감일수|신청\n마감일수", 		Type:"Text",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"applLimitDay",	KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"분할가능\n회차|분할가능\n회차",		Type:"Text",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"occDivCnt",		KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			{Header:"<sht:txt mid='note1V3' 		mdef='근태설명|근태설명'/>",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note1",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='note2V2' 		mdef='참고사항|참고사항'/>",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note2",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='noteV1' 			mdef='비고|비고'/>",					Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note3",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");

		//공통코드 한번에 조회
		var grpCds = "T10003,T10006,S10050";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("gntGubunCd", 		{ComboText:"|"+codeLists["T10003"][0], ComboCode:"|"+codeLists["T10003"][1]} );
		sheet1.SetColProperty("requestUseType", 	{ComboText:"|"+codeLists["T10006"][0], ComboCode:"|"+codeLists["T10006"][1]} );
		sheet1.SetColProperty("maxUnit", 			{ComboText:"|"+codeLists["S10050"][0], ComboCode:"|"+codeLists["S10050"][1]} );
		
		/*2022.03.16 근태신청 체크 사항 추가*/
		var useStdDateCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10035"), "");
		var useSdateCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10037"), "");
		var useEdateCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10039"), "");
		
		sheet1.SetColProperty("useStdDateCd", 		{ComboText:"|" + useStdDateCd[0], ComboCode:"|"+ useStdDateCd[1]} );
		sheet1.SetColProperty("useSdateCd", 		{ComboText:"|" + useSdateCd[0], ComboCode:"|"+ useSdateCd[1]} );
		sheet1.SetColProperty("useEdateCd", 		{ComboText:"|" + useEdateCd[0], ComboCode:"|"+ useEdateCd[1]} );
		
		
		
		//근태 종류
		$("#searchGntGubunCd").html("<option value=''>전체</option>"+codeLists["T10003"][2]);

		//일근무스케쥴
		var workCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "<tit:txt mid='2017082900840' mdef='해당없음'/>");
		sheet1.SetColProperty("workCd", 	{ComboText:"|"+workCdList[0], ComboCode:"|"+workCdList[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/TimeCdMgr.do?cmd=getTimeCdMgrList",$("#sheet1Form").serialize() );
			break;
		case "Save":

			if(!dupChk(sheet1,"gntCd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/TimeCdMgr.do?cmd=saveTimeCdMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue( Row, "languageCd", "" );
			sheet1.SetCellValue( Row, "languageNm", "" );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
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
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, 'sheet1', "ttim014", "languageCd", "languageNm", "gntNm");
			}else if(sheet1.ColSaveName(Col) == "searchDesc") {
					if(!isPopup()) {return;}
					pGubun = "pwrSrchMgrPopup";
					const url = '/Popup.do?cmd=viewPwrSrchMgrLayer';
					const p = { srchBizCd: '08', srchType: '3', srchDesc: '근태신청' };
					var pwrMgrLayer = new window.top.document.LayerModal({
							id : 'pwrSrchMgrLayer',
							url: url,
							parameters: p,
							width: 850,
							height: 620,
							title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>',
							trigger :[
								  {
									  name : 'pwrTrigger'
									  , callback : function(result){
										  getReturnValue(result);
									  }
								  }
							  ]
						});
					pwrMgrLayer.show();
				}
		} catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
<c:if test="${ssnGrpCd == '10'}">			
	function sheet1_OnClick(Row, Col, Value){
		try{
			if(sheet1.ColSaveName(Col) == "searchDtl") {
				if( sheet1.GetCellValue(Row, "searchSeq") == "" ) return;
				if( sheet1.GetCellValue(Row, "sStatus") != "R" ) {
					alert("저장 먼저 해주세요.");
					return;
				}
		  		if(!isPopup()) {return;}
		  		const url = "${ctx}/PwrSrchAdminPopup.do?cmd=viewPwrSrchAdminLayer&authPg=${authPg}";
				////searchSeq, searchDesc, chartType
				var searchSeq = sheet1.GetCellValue( sheet1.GetSelectRow(), "searchSeq" ) ;
				var searchDesc = sheet1.GetCellValue( sheet1.GetSelectRow(), "searchDesc" ) ;
				var chartType = sheet1.GetCellValue( sheet1.GetSelectRow(), "chartType" ) ;
		  		
		  		const p = { searchSeq, searchDesc, chartType };
		  		var pwrSrchAdminLayer = new window.top.document.LayerModal({
						id: 'pwrSrchAdminLayer',
						url: url,
						parameters: p,
						width: 1000,
						height: 800,
						title: '<tit:txt mid='pwrSrchMgr' mdef='조건검색'/>'
			  		});
		  		pwrSrchAdminLayer.show();
				/* var args 	= new Array();
				args["openSheet"] 	= "sheet1";
				openPopup("${ctx}/PwrSrchAdminPopup.do?cmd=pwrSrchAdminPopup&authPg=${authPg}", args,  1000, 800); */
			}

			
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
</c:if>	
	function getReturnValue(returnValue) {
		var rv = returnValue;
		if(pGubun == "pwrSrchMgrPopup"){
			sheet1.SetCellValue(sheet1.GetSelectRow(), "searchSeq", 	rv["searchSeq"] );
			sheet1.SetCellValue(sheet1.GetSelectRow(), "searchDesc",	rv["searchDesc"] );
	    }
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="sheet_search outer">
		<form id="sheet1Form" name="sheet1Form">
		<table>
		<tr>
			<th><tit:txt mid='201705100000139' mdef='근태명'/></th>
			<td>
				<input id="searchGntNm" name="searchGntNm" type="text" class="text"/>
			</td>
			<th>근태종류</th>
			<td>
				<select id="searchGntGubunCd" name="searchGntGubunCd"></select>
			</td>
			<th>근태신청여부</th>
			<td>
				<select id="searchApplYn" name="searchApplYn">
					<option value=""><tit:txt mid='103895' mdef='전체'/></option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<th class="hide"><tit:txt mid='201705100000140' mdef='유급여부'/></th>
			<td class="hide">
				<select id="searchPayYn" name="searchPayYn">
					<option value=""><tit:txt mid='103895' mdef='전체'/></option>
					<option value="1">Y</option>
					<option value="3">N</option>
				</select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
			</td>
		</tr>
		</table>
		</form>
	</div>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='timeCdMgr' mdef='근태코드관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>