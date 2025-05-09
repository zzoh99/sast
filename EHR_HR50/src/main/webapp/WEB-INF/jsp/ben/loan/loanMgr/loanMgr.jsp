<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>대출이자생성관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	
	$(function() {
	
		$("#searchSYmd").datepicker2({startdate:"searchEYmd", onReturn: getComboList});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd", onReturn: getComboList});

		
		$("#searchYm").datepicker2({
			ymonly:true,
			onReturn:function(){
				doAction1("Search");}
		});//.val("${curSysYyyyMMHyphen}");
		
		// 급여년월
		$("#btnPayYymm").datepicker2({ymonly:true});

		$("#searchSYmd, #searchEYmd, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		

		$("#searchRepayType,#searchWorkType,#searchfinYn,#searchLoanYn").on("change", function(e) {
			doAction1("Search");
		})
		
		init_sheet();
		
		
		//doAction1("Search");
	});

	

	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:6, FrozenColRight:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",			Type:"${sDelTy}", Hidden:"${sDelHdn}",			Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"선택|선택",				Type:"DummyCheck",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"chsn",	Sort:0 },
			
			//신청자정보
			{Header:"대상자|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"대상자|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"대상자|부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"대상자|직책",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"대상자|직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"대상자|직급",			Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"대상자|직군",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"worktypeNm", 		Edit:0},
			{Header:"대상자|재직",			Type:"Text",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"statusNm",	KeyField:0,	Format:"", 			Edit:0 },
			
			//신청내용
			{Header:"대출정보|대출구분",		Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"loanCd",		KeyField:0,	Format:"",			Edit:0 },
			{Header:"대출정보|대출지급일",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"loanYmd",		KeyField:0,	Format:"Ymd",		Edit:0 },
			{Header:"대출정보|대출금액",		Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"loanMon",		KeyField:0,	Format:"",			Edit:0 },
			{Header:"대출정보|상환기간\n(개월)",Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"loanPeriod",	KeyField:0,	Format:"",			Edit:0 },
			{Header:"대출정보|이율",			Type:"Float",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"intRate",		KeyField:0,	Format:"##.#\\%",	Edit:0 },
			{Header:"대출정보|월상환금",		Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"loanRepMon",	KeyField:0,	Format:"",			Edit:0 },
			
			{Header:"상환내역|상환회차",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"repSeq",		KeyField:0,	Format:"",			Edit:0 },
			{Header:"상환내역|상환구분",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"repayType",	KeyField:0,	Format:"",			Edit:0},
			{Header:"상환내역|상환일자",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"repYmd",		KeyField:0,	Format:"Ymd",		Edit:0 },
			{Header:"상환내역|이자계산기간",	Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"applyYmd",	KeyField:0,	Format:"",			Edit:0 },
			{Header:"상환내역|적용일수",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applyDay",	KeyField:0,	Format:"",			Edit:0 },
			{Header:"상환내역|기준금액\n(전월잔액)",
											Type:"Int",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"loanStdMon",	KeyField:0,	Format:"",			Edit:0 },
			{Header:"상환내역|상환금액",		Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"repMon",		KeyField:0,	Format:"",			Edit:1 },
			{Header:"상환내역|이자금액",		Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"intMon",		KeyField:0,	Format:"",			Edit:1 },
			{Header:"상환내역|합계",			Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"totMon",		CalcLogic:"|repMon|+|intMon|",	Format:"",	Edit:0 },
			{Header:"상환내역|대출잔액",		Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"loanRemMon",	Format:"",						Edit:0 },
			{Header:"급여정보|급여년월",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"payYm",		KeyField:0,	Format:"Ym",		UpdateEdit:1,	InsertEdit:1},
			{Header:"급여정보|마감\n여부",		Type:"CheckBox",Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"급여정보|비고",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1 },
			
			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Hidden:1, SaveName:"payActionCd"}
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//헤더 배경색
		var bcc = "#fdf0f5";
		sheet1.SetCellBackColor(0, "repMon", bcc);  sheet1.SetCellBackColor(1, "repMon", bcc);  
		sheet1.SetCellBackColor(0, "intMon", bcc);  sheet1.SetCellBackColor(1, "intMon", bcc);  
		sheet1.SetCellBackColor(0, "note", bcc);   sheet1.SetCellBackColor(1, "note", bcc);  

		getComboList();
		$(window).smartresize(sheetResize); sheetInit();
		
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchSYmd").val();
		let baseEYmd = $("#searchEYmd").val();

		let grpCds = "B50010,B50050";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");
		sheet1.SetColProperty("loanCd", 		{ComboText:"|"+codeLists["B50010"][0], ComboCode:"|"+codeLists["B50010"][1]} );
		sheet1.SetColProperty("repayType", 		{ComboText:"|"+codeLists["B50050"][0], ComboCode:"|"+codeLists["B50050"][1]} ); //상환구분
	}

	function getComboList() {
		let baseSYmd = $("#searchSYmd").val();
		let baseEYmd = $("#searchEYmd").val();

		let grpCds = "B50050,H10050";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");

		$("#searchRepayType").html(codeLists["B50050"][2]);
		$("#searchWorkType").html(codeLists["H10050"][2]);
	}


	function chkInVal() {

		if ($("#searchSYmd").val() == "" && $("#searchEYmd").val() != "") {
			alert('상환일자 시작일을 입력하세요.');
			return false;
		}

		if ($("#searchSYmd").val() != "" && $("#searchEYmd").val() == "") {
			alert('상환일자 종료일을 입력하세요.');
			return false;
		}

		if ($("#searchSYmd").val() != "" && $("#searchEYmd").val() != "") {
			if (!checkFromToDate($("#searchSYmd"),$("#searchEYmd"),"상환일자","상환일자","YYYYMMDD")) {
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
			getCommonCodeList();
			var sXml = sheet1.GetSearchData("${ctx}/LoanMgr.do?cmd=getLoanMgrList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"rowEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
		case "Save":   
	   		IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/LoanMgr.do?cmd=saveLoanMgr", $("#sheet1Form").serialize()); 
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		case "Prc":

			if( $("#searchPayActionCd").val() == "" ){
				alert("급여일자를 선택 해주세요");
				return;
			}


			if (!confirm("대출상환내역 생성 하시겠습니까?\n(삭제 후 다시 생성 됩니다.)")) return;
			
			progressBar(true) ;
			
			setTimeout(
				function(){
					
					var data = ajaxCall("${ctx}/LoanMgr.do?cmd=prcLoanMgr", $("#sheet1Form").serialize(),false);
					if(data.Result.Message == null) {
						doAction1("Search");
						alert("처리되었습니다.");
						progressBar(false) ;
					} else {
						alert(data.Result.Message);
						progressBar(false) ;
					}
				}
			, 100);
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
			
			if( sheet1.RowCount() > 0 ) {
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					if (sheet1.GetCellValue(i,"closeYn") == "Y"){
						sheet1.SetRowEditable(i, 0);
						sheet1.SetCellEditable(i, "closeYn", true);
					} else {
						sheet1.SetRowEditable(i, 1);
					}
				}
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
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 셀 변경 시 
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if (sheet1.ColSaveName(Col) == "loanMon") {

				var param = "searchApplSabun="+ sheet1.GetCellValue(Row, "sabun")
						  + "&loanMon="+ sheet1.GetCellValue(Row, "loanMon")
						  + "&loanPeriod="+ sheet1.GetCellValue(Row, "loanPeriod");
				var info = ajaxCall( "${ctx}/LoanAppDet.do?cmd=getLoanAppDetMon", param,false);
				if ( info != null && info.DATA != null ){ 
					sheet1.SetCellValue(Row, "repMon", info.DATA.mon);
				}
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}


	//급여일자 검색 팝업
	function payActionSearchPopup() {
		var w 		= 840;
		var h 		= 520;
		var url 	= "/PayDayPopup.do?cmd=payDayPopup";
		var args 	= new Array();
		//args["runType"] = "00001"; // 급여구분(C00001-00001.급여)

		gPRow = "";
		pGubun = "searchPayDayPopup";

		//openPopup(url+"&authPg=R", args, w, h);
	    let layerModal = new window.top.document.LayerModal({
	          id : 'payDayLayer'
	          , url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
	          , parameters : {}
	          , width : w
	          , height : h
	          , title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
	          , trigger :[
	              {
	                  name : 'payDayTrigger'
	                  , callback : function(rv){
						  $("#sheet1Form")[0].reset();
						  $("#searchPayActionCd").val(rv["payActionCd"]);
						  $("#searchPayActionNm").val(rv["payActionNm"]);
						  $("#span_payYm").html(formatDate(rv["payYm"],"-"));
						  //$("#searchYm").val(formatDate(rv["payYm"],"-"));

						  $("#searchfinYn" ).prop( "checked", false );
						  $("#searchLoanYn" ).prop( "checked", false );


						  //10  성과장려금 (생산직)
						  //01  급여 (사무직)
						  if( rv["payCd"] == "01" ){
							  $("#searchWorkType").val("A");
						  }else if( rv["payCd"] == "10" ){
							  $("#searchWorkType").val("B");
						  }
						  doAction1("Search");
	                  }
	              }
	          ]
	      });
	      layerModal.show();
	}

	//  중도상환 팝업
	function showRepPopup(){
		try{
			if(!isPopup()) {return;}
			gPRow = "";
			pGubun = "repPopup";
			var args	= new Array();
			var sRow			= sheet1.GetSelectRow();
			if( sRow > 0 ) {
				args["sabun"]	= sheet1.GetCellValue(sRow, "sabun");
				args["name"]	= sheet1.GetCellValue(sRow, "name");
			}
	
			//openPopup("/LoanMgr.do?cmd=viewLoanMgrRepPop&authPg=${authPg}", args, "840","500");
		    let layerModal = new window.top.document.LayerModal({
	              id : 'loanMgrRepLayer'
	              , url : '/LoanMgr.do?cmd=viewLoanMgrRepLayer&authPg=${authPg}'
	              , parameters : args
	              , width : 840
	              , height : 500
	              , title : '중도상환'
	              , trigger :[
	                  {
	                      name : 'loanMgrRepTrigger'
	                      , callback : function(result){
	                          doAction1('Search');
	                      }
	                  }
	              ]
	          });
	          layerModal.show();
	
		} catch(ex) {
			alert("Open Popup Event Error : " + ex);
		}
	}
	
	function seletedApply() {
		var btnPayYymm = $("#btnPayYymm").val();
		if (btnPayYymm==''){
			alert("급여년월을 선택하세요.");
			return;
		} else {
			btnPayYymm = btnPayYymm.replace(/-/g, '');
		}

		var cnt = 0;
		var firstRow = sheet1.GetDataFirstRow();
		var lastRow	 = sheet1.GetDataLastRow();
		var sDate;
		var eDate;

		for (i=firstRow; i<=lastRow;i++) {
			if (sheet1.GetCellValue(i,"chsn") == 1 /* && sheet1.GetCellValue(i,"repCd")=="01" */) {
				cnt++;
				sheet1.SetCellValue(i, "payYm", btnPayYymm, 0);
			}
		}
		if(cnt == 0){
			alert("급여년월 변경 대상을 선택하세요.");
			return;
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>상환일자</th>
			<td>
				<input type="text" id="searchSYmd" name="searchSYmd" class="date2" value=""> ~ 
				<input type="text" id="searchEYmd" name="searchEYmd" class="date2" value="">
			</td>
			<th>급여년월</th>
			<td>
				<input type="text" id="searchYm" name="searchYm" class="date2" value="">
			</td>
			<th>최종상환내역</th>
			<td>
				<input type="checkbox" id="searchfinYn" name="searchfinYn" value="Y" checked>
			</td>
			<th>대출잔액여부</th>
			<td>
				<input type="checkbox" id="searchLoanYn" name="searchLoanYn" value="Y" checked>
			</td>
		</tr>
		</tr>	
			<th>사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text w150" style="ime-mode:active;" />
			</td>
			<th>상환구분</th>
			<td>
				<select id="searchRepayType" name="searchRepayType"></select>
			</td>
			<th>직군</th>
			<td>
				<select id="searchWorkType" name="searchWorkType"></select>
			</td>
			
			<td colspan="2">
				<a href="javascript:doAction1('Search')" class="button">조회</a>
			</td>
		</tr>
		</table>
	</div>
	<table class="table mat10 outer" >
	<colgroup>
		<col width="100px"/>
		<col width="300px"/>
		<col width="100px"/>
		<col width="100px"/>
		<col width=""/>
	</colgroup>
	<tr>
		<th>급여일자</th>
		<td>
			<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
			<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text required readonly" value="" readonly style="width:180px !important;" />
			<a onclick="javascript:payActionSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
		</td>
		<th>급여년월</th>
		<td>
		   <span id="span_payYm"></span>
		</td>
		<td>
			<a href="javascript:doAction1('Prc');" class="btn filled authA">이자생성</a>
		</td>
	</tr>
	</table>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">대출상환내역</li> 
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Save');" 		class="btn soft authA">저장</a>
					<a href="javascript:showRepPopup();" 			class="btn filled authA">중도상환</a>
					<label for="btnloanYmd">
						<span class="f_bold par10">급여년월</span>
					</label>
					<input type="text" id="btnPayYymm" name ="btnPayYymm" class="date2" />
					<a href="javascript:seletedApply();" 	class="btn filled">적용</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
