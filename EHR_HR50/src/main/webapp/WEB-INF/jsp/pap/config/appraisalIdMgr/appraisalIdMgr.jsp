<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

//선택된 탭
	var newIframe;
	var oldIframe;
	var iframeIdx;

	//Sheet Action
	var selectTab = "tab1";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
		{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
		{Header:"평가년도",			Type:"Text",	  	Hidden:0,  Width:50,Align:"Center",  ColMerge:0,   SaveName:"appraisalYy",	KeyField:1,   CalcLogic:"",   Format:"####",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
		{Header:"평가종류",			Type:"Combo",	 	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appTypeCd",	KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"평가시기",			Type:"Combo",	 	Hidden:0,  Width:70,Align:"Center",  ColMerge:0,   SaveName:"appTimeCd",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"다면평가방법"	,		Type:"Combo",	 	Hidden:1,  Width:90,Align:"Center",  ColMerge:0,   SaveName:"dAppTypeCd",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"평가ID",			Type:"Text",	  	Hidden:0,  Width:60,Align:"Center",  ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
		{Header:"평가명",				Type:"Text",	  	Hidden:0,  Width:150,Align:"Left",   ColMerge:0,   SaveName:"appraisalNm",  KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		
		/* 190527 사용안함. hidden */
		{Header:"합산 대상 다면평가",	Type:"Combo",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"coworkAppraisalCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
		
		{Header:"어휘코드",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"어휘코드명",			Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		
		{Header:"평가\n시작일",		Type:"Date",	  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appSYmd",	  KeyField:1,   CalcLogic:"",   Format:"Ymd",		 PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , EndDateCol:"appEYmd"},
		{Header:"평가\n종료일",		Type:"Date",	  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appEYmd",		KeyField:1,   CalcLogic:"",   Format:"Ymd",		 PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , StartDateCol:"appSYmd"},
		// P20007(평가채점방식) : P(점수) or C(등급). DEFAULT는 C(등급). 기본 Hidden처리 되어 있으나 필요시 Hidden을 풀고 사용
		{Header:"평가채점방식",			Type:"Combo",	 	Hidden:1,  Width:70,Align:"Center",  ColMerge:0,   SaveName:"appGradingMethod",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"\n마감\n여부",		Type:"CheckBox",  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"closeYn",		KeyField:0,   CalcLogic:"",   Format:"",		 PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
		{Header:"\n피드백\n여부",		Type:"CheckBox",  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appFeedbackYn",KeyField:0,   CalcLogic:"",   Format:"",		 PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
        {Header:"\n이의제기\n사용여부",Type:"CheckBox",  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"exceptionYn",KeyField:0,   CalcLogic:"",   Format:"",		 PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" }

        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetUnicodeByte(3);

		var comboList4 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchAppTypeCd=D,&searchDAppTypeCd=DB,","queryId=getAppraisalCdList",false).codeList, ""); //평가명
		sheet1.SetColProperty("coworkAppraisalCd", 	{ComboText:"|"+comboList4[0],		 	ComboCode:"|"+comboList4[1]} );		
		
		$("#appraisalYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#appraisalNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		var sOption = "";
		var nowYY = parseInt("${curSysYear}", 10);
		for(var i = nowYY-5 ; i < nowYY+5; i++) {
			if ( i == nowYY ) sOption += "<option value='"+ i +"' selected>"+ i +"</option>";
			else sOption += "<option value='"+ i +"'>"+ i +"</option>";
		}
		$("#appraisalYy").html(sOption);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		$( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		//탭 높이 변경
		function setIframeHeight() {
		    var iframeTop = $("#tabs ul.tab_bottom").height() + 10;
		    $(".layout_tabs").each(function() {
		        $(this).css("top",iframeTop);
		    });
		}

	 	// 화면 리사이즈
		$(window).resize(setIframeHeight);
		setIframeHeight();
		showIframe();
	});

	function getCommonCodeList() {
		//공통코드 한번에 조회 [평가시기 : P10005, 평가종류 : P10003, 균형성과지표 : P00009, 평가채점방식 : P20007]
		let searchYear = $("#appraisalYy").val();
		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== '') {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}
		
		let grpCds = "P10005,P10003,P00009,P20007";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");

		sheet1.SetColProperty("appTimeCd",  {ComboText:codeLists["P10005"][0], ComboCode:codeLists["P10005"][1]} );
		sheet1.SetColProperty("appTypeCd",  {ComboText:codeLists["P10003"][0], ComboCode:codeLists["P10003"][1]} );
		sheet1.SetColProperty("dAppTypeCd", {ComboText:"|"+codeLists["P00009"][0], ComboCode:"|"+codeLists["P00009"][1]} );
		sheet1.SetColProperty("appGradingMethod",  {ComboText:codeLists["P20007"][0], ComboCode:codeLists["P20007"][1]} );
	}

	function chkInVal(sheet, sdate, edate) {
		// 시작일자와 종료일자 체크
		for (var i=sheet.HeaderRows(); i<=sheet.LastRow(); i++) {
			if (sheet.GetCellValue(i, "sStatus") == "I" || sheet.GetCellValue(i, "sStatus") == "U") {
				if (sheet.GetCellValue(i, edate) != null && sheet.GetCellValue(i, edate) != "") {
					var sdate = sheet.GetCellValue(i, sdate);
					var edate = sheet.GetCellValue(i, edate);
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet.SelectCell(i, edate);
						return false;
					}
				}
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkList()) return ;
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/AppraisalIdMgr.do?cmd=getAppraisalIdMgrList", $("#srchFrm").serialize() );
			break;

		case "Save":
			if(!chkInVal(sheet1, "appSYmd", "appEYmd")) {break;}
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"appraisalCd", true, true)){break;}
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppraisalIdMgr.do?cmd=saveAppraisalIdMgr", $("#srchFrm").serialize());
			break;

		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "appraisalYy", $("#appraisalYy").val());
			//sheet1.SetCellValue(row, "appTypeCd", "G");
			sheet1.SetCellValue(row, "appGradingMethod", "C");
			sheet1.SelectCell(row, "appraisalYy");
			break;

		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "appraisalCd", "");
			sheet1.SetCellValue(row, "languageCd", "");
            sheet1.SetCellValue(row, "languageNm", "");
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;

		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		}
	}

	function showIframe() {
		var Row = sheet1.GetSelectRow();
		if(sheet1.GetCellValue(Row, "sStatus") == "I"){
			hideIframe();
			return;
		}
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.jsp");
		}
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/AppraisalIdMgr.do?cmd=viewAppraisalIdMgrTab1"+"&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/AppraisalIdMgr.do?cmd=viewAppraisalIdMgrTab2"+"&authPg=${authPg}");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/AppraisalIdMgr.do?cmd=viewAppraisalIdMgrTab3"+"&authPg=${authPg}");
		} 
		
		
		/*  
		else if(iframeIdx == 3) {
			newIframe.attr("src","${ctx}/AppraisalIdMgr.do?cmd=viewAppraisalIdMgrTab4"+"&authPg=${authPg}");
		} */
	}

	function hideIframe(){
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/common/hidden.jsp");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/common/hidden.jsp");
		} else if(iframeIdx == 2) {
			newIframe.attr("src","${ctx}/common/hidden.jsp");
		} else if(iframeIdx == 3) {
			newIframe.attr("src","${ctx}/common/hidden.jsp");
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				dAppTypeCdCont(i);
				if (sheet1.GetCellValue(i, "appTypeCd") != "C") {
					sheet1.SetCellEditable(i, "coworkAppraisalCd", false);
				}

			}
			$("#searchAppraisalCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "appraisalCd"));
			showIframe();
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != "-1" ) {
				var comboList4 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchAppTypeCd=D,&searchDAppTypeCd=DB,","queryId=getAppraisalCdList",false).codeList, ""); //평가명
				sheet1.SetColProperty("coworkAppraisalCd", 	{ComboText:"|"+comboList4[0],		 	ComboCode:"|"+comboList4[1]} );
				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	    if(sheet1.ColSaveName(Col) == "exceptionYn"){
			if(sheet1.GetCellValue(Row, "exceptionYn") == "N"){
				alert("이의제기 여부를 해제 할 경우 이의제기일정을 참조하지 않습니다");
			}
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;
			$("#searchAppraisalCd").val(sheet1.GetCellValue(NewRow, "appraisalCd"));
			showIframe();
			// 조회...
			//doAction2('Search');
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
		    //평가단계별일정관리(TPAP105)테이블에 지우려는 평가ID 자료가 1건이라도 존재하면삭제할수없음
			if(sheet1.ColSaveName(Col) == "sDelete" && sheet1.GetCellValue(Row, "sDelete") == 1){
				existDataYn();
			}

			//평가 ID 및 평가명 자동 생성
			if(sheet1.ColSaveName(Col) == "appraisalYy" ||
		   		sheet1.ColSaveName(Col) == "appTimeCd"  ||
		   		sheet1.ColSaveName(Col) == "appTypeCd" ){

				//평가 아이디생성
				//입력/수정으로 상태인 레코드 중에 평가년도와 평가종류코드가 같은 필드가 없는 경우는
				//데이터베이스에서 최대값을 읽어오고 같은 필드가 있는 경우는  리스트에서 최대값을 구한다.
				//상태가 입력일 때만 평가아이디를 새로 생성
				if (sheet1.GetCellValue(Row, "sStatus") == "I") {
					var sAppraisalCodeSeq =  "";
					sAppraisalCodeSeq = getAppraisalCodeSeq()+"";

					if (sAppraisalCodeSeq.length > 2 ) {
						alert("자리수가 너무 많습니다.");
						return;
					}
					else if (sAppraisalCodeSeq.length == 1 ) {
						sAppraisalCodeSeq = "0"+sAppraisalCodeSeq;
					}

					if(sAppraisalCodeSeq == "01"){
						 createAppraisalCodeSeq();
					} else {
						sheet1.SetCellValue(Row, "appraisalCd"
								, sheet1.GetCellValue(Row, "appraisalYy").substr(2,4)
								+ sheet1.GetCellValue(Row, "appTypeCd")
								+ sAppraisalCodeSeq)
					}
				}

				//평가명 생성
				//평가년도 + 평가시기 + 직종 + 평가종류
				sheet1.SetCellValue(sheet1.GetSelectRow(), "appraisalNm", sheet1.GetCellValue(Row, "appraisalYy") +"년도 "+ sheet1.GetCellText(Row, "appTimeCd")+ " "+sheet1.GetCellText(Row, "appTypeCd"));
				//sheet1.SetCellValue(sheet1.GetSelectRow(), "appraisalNm", sheet1.GetCellValue(Row, "appraisalYy") +"년도 ");
			}

			//리스트내 평가 시작일자와 종료일자 체크
			if(sheet1.ColSaveName(Col) == "appSYmd" || sheet1.ColSaveName(Col) == "appEYmd"){
				//checkNMDate(sheet1, Row, Col, "평가", "appSYmd", "appEYmd");
			}

			if ( sheet1.ColSaveName(Col) == "appTypeCd" ){
				dAppTypeCdCont(Row);
			}
		} catch (ex) {
			alert("OnChange( Event Error : " + ex);
		}
	}

	function dAppTypeCdCont(Row){

		var appTypeCd = sheet1.GetCellValue( Row, "appTypeCd" );

		if ( appTypeCd == "D" ){
			sheet1.SetCellEditable( Row, "dAppTypeCd", 1 );
		}else{
			sheet1.SetCellValue( Row, "dAppTypeCd", "" );
			sheet1.SetCellEditable( Row, "dAppTypeCd", 0 );
		}
	}

	/*
	   function getAppraisalCodeSeq
		입력/수정 상태이고 년도와 평가종류가 같은 레코드가 리스트에 존재하는 경우 리스트에서 일련번호의 최대값을 구해 반환한다. 데이터베이스에 접근하지 않고 리스트에서 구하는 경우
	*/
	function  getAppraisalCodeSeq() {
		var sAppraisalYy = "";		  //평가년도
		var sAppTargetCd = "";		 //평가대상코드
		var sAppraisalCd = "";		  //평가아이디코드
		var sAppraisalSeq = 0;		  //일련번호
		var maxSeq = 0;			 //최대값

		var selectedAppraisalYy = "";
		var selectedAppTargetCd = "";

		selectedAppraisalYy = sheet1.GetCellValue(sheet1.GetSelectRow(), "appraisalYy");
		selectedAppTargetCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "appTypeCd");

		for ( i = 1 ; i <= sheet1.RowCount(); i++ ) {
			if (i == sheet1.GetSelectRow() ) continue;
			sAppraisalYy = sheet1.GetCellValue(i, "appraisalYy");
			sAppTargetCd = sheet1.GetCellValue(i, "appTypeCd");
			sAppraisalCd = sheet1.GetCellValue(i, "appraisalCd");
			sAppraisalSeq = (sheet1.GetCellValue(i, "appraisalCd")).substr(3,2);
			if ( sAppraisalYy == selectedAppraisalYy &&  sAppTargetCd == selectedAppTargetCd && (parseInt(sAppraisalSeq, 10) > parseInt(maxSeq, 10)))  {
				maxSeq = sAppraisalSeq;
		   }
		}

		return parseInt(maxSeq, 10)+1;
	}

	/*
		function createAppraisalCodeSeq
		입력/수정 상태이면서 년도와 평가종류가 같은 레코드가 리스트에 없는 경우
		데이터베이스에서 일련번호의 최대값을 구해 온다.
	*/
	function createAppraisalCodeSeq() {
		var row = sheet1.GetSelectRow();
		var sAppraisalYy = sheet1.GetCellValue(sheet1.GetSelectRow(), "appraisalYy");

		var data = ajaxCall("${ctx}/AppraisalIdMgr.do?cmd=getAppraisalIdMgrCodeSeq", "appraisalYy="+sAppraisalYy, false);

		if(data != null && data.map != null) {
			var appraisalSeq = data.map.appraisalSeq;

			if ( appraisalSeq == "" ) appraisalSeq = 0;
			else appraisalSeq = parseInt(appraisalSeq, 10);

			appraisalSeq = appraisalSeq + 1;

			if (appraisalSeq > 99 ) alert("자리수가 너무 많습니다.");
			else if (appraisalSeq < 10 )  appraisalSeq = "0"+appraisalSeq;

			sheet1.SetCellValue(row, "appraisalCd"
				, sheet1.GetCellValue(row, "appraisalYy").substr(2,4)
					+ sheet1.GetCellValue(row, "appTypeCd")
					+ appraisalSeq);
		}
	}

	function existDataYn() {
		var appraisalCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "appraisalCd");

		var data = ajaxCall("${ctx}/AppraisalIdMgr.do?cmd=getAppraisalIdMgrDelCheck", "appraisalCd="+appraisalCd, false);

		if(data != null && data.map != null) {
			if ( data.map.appraisalYn == "N" ) {
				sheet1.SetCellValue(sheet1.GetSelectRow(), "sDelete", 0);
				alert("해당 평가ID 관련자료가 있으므로 삭제할 수 없습니다.");
			}
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet1", "tpap101", "languageCd", "languageNm", "appraisalNm");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});

		if($("#appraisalYy").val().length < 4 ) {
			alert("년도를 올바르게 입력하세요.");
			ch =  false;
			return false;
		}
		return ch;
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가년도</span>
							<input id="appraisalYy" name ="appraisalYy" type="text" class="text w80 center" value="${curSysYear}" maxlength="4"/>
						</td>
						<td>
							<span>평가명</span>
							<input id="appraisalNm" name ="appraisalNm" type="text" class="text" />
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">평가기초관리</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>

	<div class="innertab inner" style="height:40%;">
		<div id="tabs" class="tab">
			<ul class="tab_bottom">
				<li><a href="#tabs-1" >일정</a></li>
				<li><a href="#tabs-2" >최종평가일정</a></li>
				<li><a href="#tabs-3" >이의제기일정</a></li>
              <!--   <li><a href="#tabs-2" >목표/실적일정</a></li>
				<li><a href="#tabs-3" >최종평가일정</a></li>
				<li><a href="#tabs-4" >이의제기일정</a></li> -->
			</ul>
			<div id="tabs-1">
				<div  class='layout_tabs'><iframe id="tab1" name="tab1" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
			<div id="tabs-2">
				<div  class='layout_tabs'><iframe id="tab2" name="tab2" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
			<div id="tabs-3">
				<div  class='layout_tabs'><iframe id="tab3" name="tab3" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div>
			</div>
<%-- 			<div id="tabs-4">
				<div  class='layout_tabs'><iframe id="tab4" name="tab4" src='${ctx}/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div>
			</div> --%>
		</div>
	</div>
</div>
</body>
</html>