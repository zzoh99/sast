<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112863' mdef='근태신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>


<script type="text/javascript">
	$(function() {

		$("#searchBaseYmd").datepicker2({
			onReturn:function(date){
				doAction1("Search");
			}
		});

		$("#searchAppSYmd, #searchAppEYmd").datepicker2({
			onReturn:function(date){
				doAction2("Search");
			}
		})

		$("#searchBaseYmd").val("${curSysYyyyMMddHyphen}");
		$("#searchAppSYmd").val("${curSysYear}-01-01");
		$("#searchAppEYmd").val("${curSysYear}-12-31");

	    $("#searchBaseYmd").bind("keyup",function(event){
	    	if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	    $("#searchAppSYmd, #searchAppEYmd").bind("keyup",function(event){
	    	if( event.keyCode == 13){
				doAction2("Search");
			}
		});
	    $("#searchVacationYn").bind("change",function(event){
	    	doAction2("Search");
		});
	    

		init_sheet();

		setEmpPage();
	});

	function init_sheet() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='gntCdV1' mdef='근태코드|근태코드'/>",					Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",						Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='yearV1' mdef='사용기준년도|사용기준년도'/>",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"<sht:txt mid='gntNm' mdef='근태명|근태명'/>",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발생기준일|발생기준일",				Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"baseYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='useSYmd' mdef='사용기준|시작일'/>",					Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useSYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='useEYmd' mdef='사용기준|종료일'/>",					Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useEYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='creLeaveDays_dbl' mdef='발생일수|발생일수'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"creCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='cryfwdLeaveDays_dbl' mdef='이월일수|이월일수'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"frdCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='smrVctnMnsDays_dbl' mdef='하계휴가비\n차감일수|하계휴가비\n차감일수'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"modCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='usedCnt_dbl' mdef='사용일수|사용일수'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"usedCnt",		KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
			{Header:"<sht:txt mid='remainCnt_dbl' mdef='현 잔여일수|현 잔여일수'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"restCnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
   		];
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",  Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
  			{Header:"applSeq",				Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:1,  SaveName:"applSeq"},
  			
   			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",	Type:"${sDelTy}", Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",	Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },

   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='delete' mdef='삭제'/>",			Type:"Html",	Hidden:0, Width:55,  Align:"Center", ColMerge:1, SaveName:"btnDel",  		Sort:0 , 	Cursor:"Pointer" },
			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",	Hidden:0, Width:45,	 Align:"Center", ColMerge:1, SaveName:"detail",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0, 	Cursor:"Pointer"  },
			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='applYmdV5' mdef='신청일'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", ColMerge:1, SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='applStatusCd' mdef='신청상태'/>",	Type:"Combo",	Hidden:0, Width:80,	 Align:"Center", ColMerge:1, SaveName:"applStatusCd",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },

   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='gntCdV3' mdef='근태종류'/>", 		Type:"Text",	Hidden:0, Width:100, Align:"Center", ColMerge:1, SaveName:"gntNm",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='occCd_V763' mdef='경조구분'/>", 	Type:"Text",	Hidden:0, Width:100, Align:"Center", ColMerge:1, SaveName:"occNm",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='eduSYmd' mdef='시작일'/>", 			Type:"Date",	Hidden:0, Width:80,	 Align:"Center", ColMerge:1, SaveName:"sYmd",			KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='eYmdV1' mdef='종료일'/>", 			Type:"Date",	Hidden:0, Width:80,	 Align:"Center", ColMerge:1, SaveName:"eYmd",			KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='dayCnt' mdef='총일수'/>", 			Type:"Text",	Hidden:0, Width:60,	 Align:"Right",	 ColMerge:1, SaveName:"holDay",			KeyField:0,	Format:"Number",UpdateEdit:0,	InsertEdit:0 },
   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='closeDayV1' mdef='적용\n일수'/>", 	Type:"Text",	Hidden:0, Width:60,	 Align:"Right",	 ColMerge:1, SaveName:"closeDay",		KeyField:0,	Format:"",	    UpdateEdit:0,	InsertEdit:0 },
   			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='cancelYn' mdef='취소여부'/>",		Type:"Combo",	Hidden:0, Width:70,  Align:"Center", ColMerge:1, SaveName:"updateYn",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0, FontColor:"#ff0000" },
			{Header:"<sht:txt mid='112863' mdef='근태신청'/>|<sht:txt mid='eduMemoV2' mdef='사유'/>", 		Type:"Text",	Hidden:1, Width:120, Align:"Left",	 ColMerge:1, SaveName:"gntReqReson",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },

   			//취소신청
			{Header:"<sht:txt mid='appChgGnt_dbl' mdef='근태변경\n신청|근태변경\n신청'/>",        Type:"Html",      Hidden:0, Width:60,  Align:"Center", ColMerge:0, SaveName:"btnApp3",                Sort:0 },
			{Header:"<sht:txt mid='vacationUpdApp2' mdef='근태취소신청'/>|<sht:txt mid='cancelApp' mdef='취소신청'/>",		Type:"Html",   	Hidden:0, Width:60,  Align:"Center", ColMerge:0, SaveName:"btnApp2",  		Sort:0, 	Cursor:"Pointer" },
			{Header:"<sht:txt mid='vacationUpdApp2' mdef='근태취소신청'/>|<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",  	Hidden:0, Width:45,  Align:"Center", ColMerge:0, SaveName:"detail2",        KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 , 	Cursor:"Pointer" },
			{Header:"<sht:txt mid='vacationUpdApp2' mdef='근태취소신청'/>|<sht:txt mid='applYmdV5' mdef='신청일'/>",		Type:"Date",   	Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"applYmd2",       KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
  			{Header:"<sht:txt mid='vacationUpdApp2' mdef='근태취소신청'/>|<sht:txt mid='applStatusCd' mdef='신청상태'/>",	Type:"Combo",  	Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"applStatusCd2",  KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
  			{Header:"<sht:txt mid='vacationUpdApp2' mdef='근태취소신청'/>|<sht:txt mid='delete' mdef='삭제'/>",			Type:"Html",    Hidden:0, Width:"${sDelWdt}",  Align:"Center", ColMerge:0, SaveName:"btnDel2",  		Sort:0,	Cursor:"Pointer" },
			
  			//Hidden
  			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"gntCd"},
  			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"applInSabun2"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"cancleApplCd"},
  			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"applSeq2"},
  			{Header:"Hidden", Type:"AutoSum", Hidden:1, SaveName:"sumDay"}

   		];IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

   		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet2.SetImageList(0,"/common/images/icon/icon_popup.png");

		//근태취소신청 헤더 색상
		sheet1.SetRangeBackColor(0,sheet1.SaveNameCol("btnDel2"),1,sheet1.SaveNameCol("applStatusCd2"), "#fdf0f5");  //분홍이

		//결재상태
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
		sheet2.SetColProperty("applStatusCd", 	{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );
		sheet2.SetColProperty("applStatusCd2",  {ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );
		sheet2.SetColProperty("updateYn", 		{ComboText:'||취소', ComboCode:"|N|Y"} );

		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/VacationApp.do?cmd=getVacationAppList",$("#sheet1Form").serialize()  );
			
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/VacationApp.do?cmd=getVacationAppExList",$("#sheet1Form").serialize()+"&"+$("#sheet2Form").serialize() );
			break;
        case "Save":
			if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet2); return;}
        	IBS_SaveName(document.sheet1Form,sheet2);
        	sheet2.DoSave( "${ctx}/VacationApp.do?cmd=deleteVacationApp", $("#sheet1Form").serialize(), -1, 0);
        	break;
        case "Save2":
			if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet2); return;}
       		IBS_SaveName(document.sheet1Form,sheet2);
       		sheet2.DoSave( "${ctx}/VacationApp.do?cmd=deleteVacationAppUpd", $("#sheet1Form").serialize(), -1, 0);
        	break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2, ['Html']);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
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

			doAction2('Search');

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet2 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( sheet2.RowCount() > 0 ){
				sheet2.SetSumValue(0, "closeDay", sheet2.GetCellValue(sheet2.LastRow()-1, "sumDay"));
			}else{
				sheet2.SetSumValue(0, "closeDay", "");
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
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			if( Row < sheet2.HeaderRows() ) return;

		    if( sheet2.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );

		    }else if( sheet2.ColSaveName(Col) == "detail2" && Value != "" ) {
		    	if( sheet2.GetCellValue( Row, "applStatusCd" ) == "99" && sheet2.GetCellValue( Row, "applSeq2" ) != "" ) {
			   		showApplPopup2( Row , 1);
		    	}

		    }else if( sheet2.ColSaveName(Col) == "btnDel" && Value != ""){
		    	sheet2.SetCellValue(Row, "sStatus", "D");
				doAction2("Save");

		    }else if( sheet2.ColSaveName(Col) == "btnDel2" && Value != ""){
		    	
	    		sheet2.SetCellValue(Row, "sStatus", "D");
				doAction2("Save2");
	    	
		    }else if( sheet2.ColSaveName(Col) == "btnApp2" && Value != ""){
	    		
	    		showApplPopup2( Row, 2 );
		    }else if( sheet2.ColSaveName(Col) == "btnApp3" && Value != ""){
	    		
	    		showApplPopup2( Row, 3 );
		    }

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup(Row) {
		if(!isPopup()) {return;}

		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}"
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
		  //, initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";

		if( Row > -1  ){
			if(sheet2.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
				//initFunc = 'initResultLayer';
			}
			applSeq     = sheet2.GetCellValue(Row,"applSeq");
			applInSabun = sheet2.GetCellValue(Row,"applInSabun");
			applYmd     = sheet2.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = sheet2.GetCellValue(Row, "applStatusCd");
		}

		var p = {
				searchApplCd: '22'
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

	//-----------------------------------------------------------------------------------
	//		 취소신청
	//-----------------------------------------------------------------------------------
	function showApplPopup2( Row,  gubun ) {
		if(!isPopup()) {return;}

		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}"
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
		  //, initFunc = 'initLayer';

		args["applStatusCd"] = "11";

		if( gubun == 1){
			if(sheet2.GetCellValue(Row, "applStatusCd2") != "11") {
				auth = "R";
				url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
				//initFunc = 'initResultLayer';
			}
			applSeq     = sheet2.GetCellValue(Row,"applSeq2");
			applInSabun = sheet2.GetCellValue(Row,"applInSabun2");
			applYmd     = sheet2.GetCellValue(Row,"applYmd2");
			args["applStatusCd"] = sheet2.GetCellValue(Row, "applStatusCd2");
		}

		var p = {
				searchApplCd: '22'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			  , etc01: sheet2.GetCellValue(Row,"applSeq")
			};
		
		if(gubun == "1") { //기신청내역 조회
			p.searchApplCd = sheet2.GetCellValue(Row,"cancleApplCd");
		} else if(gubun == "2") { //취소신청
			p.searchApplCd = '23';
		} else { //변경신청
			p.searchApplCd = '24';
		}

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
<body class="bodywrap">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="vacationApp1" mdef="잔여휴가내역"/></li>
			<li class="btn">
				<tit:txt mid='104352' mdef='기준일자'/>&nbsp;:&nbsp;
				<input type="text" id="searchBaseYmd" name="searchBaseYmd"  maxlength="10" class="text center" value="${ curSysYyyyMMddHyphen }"/>
				<a href="javascript:doAction1('Search');" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
				<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	</form>
	<div class="outer">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "150px"); </script>
	</div>

	<form id="sheet2Form" name="sheet2Form">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appLeaves' mdef='휴가신청내역'/></li>
			<li class="btn">
				<tit:txt mid='104102' mdef='신청기간'/>&nbsp;:&nbsp;
				<input id="searchAppSYmd" name="searchAppSYmd" type="text"  maxlength="10" class="text center date"/> ~
				<input id="searchAppEYmd" name="searchAppEYmd" type="text"  maxlength="10" class="text center date"/>
				<label for="searchVacationYn">&nbsp;<tit:txt mid='onlyShowAnnualLeaves' mdef='연차만'/>&nbsp;</label>
				<input id="searchVacationYn" name="searchVacationYn" type="checkbox" class="checkbox" value="Y" checked/>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:showApplPopup(-1);"       class="btn filled authR"><tit:txt mid='112863' mdef='근태신청'/></a>
				<a href="javascript:doAction2('Search');"     class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
				<a href="javascript:doAction2('Down2Excel');" class="btn outline_gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	</form>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>

</div>
</body>
</html>