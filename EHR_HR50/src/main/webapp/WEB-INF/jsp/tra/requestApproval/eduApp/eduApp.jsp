<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>교육신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {

		$("#searchSYmd").datepicker2({startdate:"searchEYmd"});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd"});
		
		init_sheet();
		
		
		setEmpPage();
	});

	//시트 초기화
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",  Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },

  			{Header:"applSeq",			Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:1,  SaveName:"applSeq"},
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",			Type:"${sDelTy}", Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='eduAppDel' mdef='교육신청|삭제'/>",		Type:"Html",	  Hidden:0,	Width:45,           Align:"Center",	ColMerge:1,	SaveName:"btnDel",  Sort:0 ,	Cursor:"Pointer"},
			
   			{Header:"<sht:txt mid='eduAppDetail' mdef='교육신청|세부\n내역'/>",	Type:"Image",	Hidden:0, Width:45,	 Align:"Center", ColMerge:1, SaveName:"detail",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='eduAppApplYmd' mdef='교육신청|신청일'/>",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", ColMerge:1, SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppStatusCd' mdef='교육신청|신청상태'/>",		Type:"Combo",	Hidden:0, Width:80,	 Align:"Center", ColMerge:1, SaveName:"applStatusCd",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },

			{Header:"<sht:txt mid='eduAppInout' mdef='교육신청|사내/외'/>",  	Type:"Combo",   Hidden:0, Width:50,  Align:"Center", ColMerge:1, SaveName:"inOutType",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppMethodCd' mdef='교육신청|시행방법'/>",  	Type:"Combo",   Hidden:0, Width:60,  Align:"Center", ColMerge:1, SaveName:"eduMethodCd",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppBranchCd' mdef='교육신청|교육구분'/>",  	Type:"Combo",   Hidden:0, Width:100, Align:"Center", ColMerge:1, SaveName:"eduBranchCd",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppMBranchCd' mdef='교육신청|교육분류'/>",		Type:"Combo",	Hidden:1, Width:150, Align:"Left",	 ColMerge:1, SaveName:"eduMBranchCd",	KeyField:0,	Format:"",		UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppCourseNm' mdef='교육신청|교육과정명'/>",  	Type:"Text",    Hidden:0, Width:250, Align:"Left",   ColMerge:1, SaveName:"eduCourseNm",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppSYmd' mdef='교육신청|교육시작일'/>", 	Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduSYmd",  		KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppEYmd' mdef='교육신청|교육종료일'/>", 	Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduEYmd",  		KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduAppCanYn' mdef='교육신청|취소\n여부'/>",	Type:"Combo",	Hidden:0, Width:60,  Align:"Center", ColMerge:1, SaveName:"updateYn",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0, FontColor:"#ff0000" },
			{Header:"<sht:txt mid='eduConfirmYn' mdef='수료\n여부|수료\n여부'/>",	Type:"Combo",	Hidden:0, Width:55,  Align:"Center", ColMerge:1, SaveName:"eduConfirmType",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0, FontColor:"#0000ff" },
			
			//만족도 조사
			{Header:"<sht:txt mid='eduSurvey' mdef='만족도\n조사|만족도\n조사'/>",
				                		Type:"Image",  Hidden:0,  Width:45, Align:"Center", ColMerge:1, SaveName:"selectImg",       KeyField:0, Format:"",      UpdateEdit:1,   InsertEdit:1,	Cursor:"Pointer" },
  			
			//결과보고			
  			{Header:"<sht:txt mid='eduResultApp' mdef='결과보고|신청'/>",		Type:"Html",   Hidden:0, Width:45,  Align:"Center", ColMerge:0,	SaveName:"btnApp2",  		Sort:0,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='eduResultDetail' mdef='결과보고|세부\n내역'/>",	Type:"Image",  Hidden:0, Width:45,  Align:"Center", ColMerge:0, SaveName:"detail2",         KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='eduResultApplYmd' mdef='결과보고|신청일'/>",		Type:"Date",   Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"applYmd2",        KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
  			{Header:"<sht:txt mid='eduResultApplStatus' mdef='결과보고|신청상태'/>",		Type:"Combo",  Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"applStatusCd2",   KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
  			{Header:"<sht:txt mid='eduResultDel' mdef='결과보고|삭제'/>",		Type:"Html",   Hidden:0, Width:45,  Align:"Center", ColMerge:0,	SaveName:"btnDel2",  		Sort:0,	Cursor:"Pointer" },
  						
  			//Hidden
  			{Header:"eduSeq",		Hidden:1, SaveName:"eduSeq"},
  			{Header:"eduEventSeq",	Hidden:1, SaveName:"eduEventSeq"},
  			{Header:"sabun",		Hidden:1, SaveName:"sabun"},
  			{Header:"applInSabun",	Hidden:1, SaveName:"applInSabun"},
  			{Header:"applInSabun",	Hidden:1, SaveName:"applInSabun2"},
  			{Header:"applSeq",		Hidden:1, SaveName:"applSeq2"},
  			{Header:"eduSurveyYn",	Hidden:1, SaveName:"eduSurveyYn"},

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_o.png");

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		var bcc = "#fdf0f5";
		sheet1.SetCellBackColor(0, "btnDel2", bcc);  sheet1.SetCellBackColor(1, "btnDel2", bcc);  
		sheet1.SetCellBackColor(0, "btnApp2", bcc);  sheet1.SetCellBackColor(1, "btnApp2", bcc);  
		sheet1.SetCellBackColor(0, "detail2", bcc);  sheet1.SetCellBackColor(1, "detail2", bcc);  
		sheet1.SetCellBackColor(0, "applYmd2", bcc);  sheet1.SetCellBackColor(1, "applYmd2", bcc);  
		sheet1.SetCellBackColor(0, "applStatusCd2", bcc);  sheet1.SetCellBackColor(1, "applStatusCd2", bcc);  

		//공통코드 한번에 조회
		var grpCds = "L20020,L10010,R10010,L10015,L10050";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} );  //  사내/외 구분
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );  //  교육구분
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );  //  교육분류
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+codeLists["L10050"][0], ComboCode:"|"+codeLists["L10050"][1]} );  // L10050 교육시행방법코드
		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );  //  결재상태
		sheet1.SetColProperty("applStatusCd2",  {ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );  //  결재상태
		sheet1.SetColProperty("updateYn", 		{ComboText:'||취소|취소진행중', ComboCode:"|N|Y|ING"} );
		sheet1.SetColProperty("eduConfirmType", {ComboText:'|미수료|수료', ComboCode:"|0|1"} );
		
		$(window).smartresize(sheetResize); sheetInit();
	}

	function chkInVal() {

		if ($("#searchSYmd").val() == "" && $("#searchEYmd").val() != "") {
			alert("<msg:txt mid='110391' mdef='신청기간 시작일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchSYmd").val() != "" && $("#searchEYmd").val() == "") {
			alert("<msg:txt mid='110256' mdef='신청기간 종료일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchSYmd").val() != "" && $("#searchEYmd").val() != "") {
			if (!checkFromToDate($("#searchSYmd"),$("#searchEYmd"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			var sXml = sheet1.GetSearchData("${ctx}/EduApp.do?cmd=getEduAppList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			break;
        case "Save":   
			if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet1); return;}
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/EduApp.do?cmd=deleteEduApp", $("#sheet1Form").serialize(), -1, 0); 
        	break;
        case "Save2":  
			if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet1); return;}
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/EduApp.do?cmd=deleteEduAppResult", $("#sheet1Form").serialize(), -1, 0); 
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
		    		
			   		showApplPopup2( Row , 1);
		    	}

		    }else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");

		    }else if( sheet1.ColSaveName(Col) == "btnApp2" && Value != ""){
	    		if( sheet1.GetCellValue(Row, "eduSurveyYn") == "N"){
					alert("<msg:txt mid='eduSurveyErrMsg' mdef='교육만족도조사를 먼저 진행 해주세요.'/>")
	    			return;
	    		}
	    	
	    		showApplPopup2( Row, 2 );
		    }else if( sheet1.ColSaveName(Col) == "btnDel2" && Value != ""){
		    	
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save2");	
		    
		    }else if( sheet1.ColSaveName(Col) == "selectImg" && Value != "" ) {
		    	
		    	if(!isPopup()) {return;}
				gPRow = "";
				pGubun = "viewEduSurveryPopup";

				const p = {
					searchApplSabun: $("#searchUserId").val(),
					searchApplSeq: sheet1.GetCellValue(Row, "applSeq"),
					searchEduSeq: sheet1.GetCellValue(Row, "eduSeq"),
					searchEduEventSeq: sheet1.GetCellValue(Row, "eduEventSeq"),
					authPg: sheet1.GetCellValue(Row, "eduSurveyYn") == "N" ? "A" : "R"
				};

				let eduSurveryLayer = new window.top.document.LayerModal({
					id : 'eduSurveryLayer',
					url : '${ctx}/EduApp.do?cmd=viewEduSurveryPopup',
					parameters : p,
					width : 880,
					height : 850,
					title : '<tit:txt mid='eduSurvery' mdef='교육만족도조사'/>',
					trigger :[
						{
							name : 'eduSurveryTrigger',
							callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});
				eduSurveryLayer.show();
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	

	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row ) {

		if(!isPopup()) {return;}
		
		var args = new Array(5);
		var auth    = "A"
		  , applCd = "130"
		  , applSeq = ""
		  , searchSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			searchSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			inOutType   = sheet1.GetCellValue(Row,"inOutType");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		} 
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: searchSabun
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
	//		 결과보고
	//-----------------------------------------------------------------------------------
	function showApplPopup2( Row, gubun ) {

		if(!isPopup()) {return;}
		
		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , searchSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		if( gubun == 1){
			if(sheet1.GetCellValue(Row, "applStatusCd2") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq2");
			searchSabun = sheet1.GetCellValue(Row,"applInSabun2");
			applYmd     = sheet1.GetCellValue(Row,"applYmd2");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd2");
		}

		var p = {
				searchApplCd: '131'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: searchSabun
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
	function getReturnValue(rv) {
		doAction1("Search");
	}

	//인사헤더에서 이름 변경 시 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<div class="sheet_search sheet_search_s outer">
			<table>
			<tr>
				<th><tit:txt mid='113497' mdef='신청기간 '/></th>
				<td>
					<input id="searchSYmd" name="searchSYmd" type="text" size="10" class="date2" value="<%= DateUtil.getThisYear()+"-01-01"%>"/> ~
					<input id="searchEYmd" name="searchEYmd" type="text" size="10" class="date2" value="<%= DateUtil.getThisYear()+"-12-31"%>"/>
				</td>
				<td> <a href="javascript:doAction1('Search');" class="btn dark" >조회</a> </td>
			</tr>
			</table>
		</div>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">교육신청</li> 
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray" ><tit:txt mid="download" mdef="다운로드"/></a>
					<a href="javascript:showApplPopup(-1);" 		class="btn filled"><tit:txt mid='appComLayout' mdef='신청'/></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	
</div>
</body>
</html>