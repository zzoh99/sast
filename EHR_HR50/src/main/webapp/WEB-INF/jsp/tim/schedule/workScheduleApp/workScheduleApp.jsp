<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근무스케쥴신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchYear").val("${curSysYear}");
		$('#searchYear').mask('0000', { reverse : true });

		$("#searchYear").on("keyup", function(event) {
			if( event.keyCode === 13 && $("#searchYear").val().length == 4 ) {
				initWorkTermCombo();
			}
		});
		$("#searchWorkTerm").bind("change",function(event){
	    	doAction2("Search");
		});
		
		
		init_sheet1(); init_sheet2();
		$(window).smartresize(sheetResize); sheetInit();
		
		setEmpPage();
	});


	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제",		Type:"Html",		Hidden:0,	 Width:45,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"세부\n내역",	Type:"Image",	Hidden:0, Width:45,	 Align:"Center", SaveName:"detail",			Format:"",			Edit:0 },
			{Header:"신청일",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applYmd",		Format:"Ymd",		Edit:0 },
			{Header:"신청상태",	Type:"Combo",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applStatusCd",	Format:"",			Edit:0 },
			
			{Header:"근무조",		Type:"Text",	Hidden:0, Width:100, Align:"Center", SaveName:"workOrgNm",		Format:"",			Edit:0 },
			{Header:"단위기간",	Type:"Combo",	Hidden:0, Width:100, Align:"Center", SaveName:"intervalCd",		Format:"",			Edit:0 },
			{Header:"기준일자",	Type:"Date",	Hidden:0, Width:100, Align:"Center", SaveName:"ymd",			Format:"Ymd",		Edit:0 },
			{Header:"신청단위",	Type:"Text",	Hidden:0, Width:100, Align:"Center", SaveName:"dayGubunNm",		Format:"",			Edit:0 },
			{Header:"시작일자",	Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"sdate",			Format:"Ymd", 		Edit:0 },
			{Header:"종료일자",	Type:"Date",	Hidden:0, Width:80,  Align:"Center", SaveName:"edate",			Format:"Ymd", 		Edit:0 },
			
  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"}

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "R10010,T90200";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		sheet1.SetColProperty("intervalCd",  	{ComboText:"|"+codeLists["T90200"][0], ComboCode:"|"+codeLists["T90200"][1]} );//  단위기간
		//==============================================================================================================================


	}

	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:" ",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
  		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(0);
  		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
	}
	

	//근무기간콤보
	function initWorkTermCombo() {
		const isNumber = (_value) => {
			return /[0-9]/.test(_value);
		}

		if ( !($("#searchYear").val()) || $("#searchYear").val().length != 4 || !isNumber($("#searchYear").val()) ) {
			$("#searchWorkTerm").html("");
			sheet2.RemoveAll();
			return;
		}
		
		var param = "&searchSabun="+$("#searchSabun").val()
		          + "&searchYmd="+$("#searchYear").val()+"0101"
		          + "&searchSelYmd=${curSysYyyyMMdd}"
		          + "&searchYear="+$("#searchYear").val();
		var workTermCdList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTimWeekTermCodeList"+param, false).codeList
				           , "sYmd,eYmd,workGrpCd,workOrgCd,selYn"
				           , "");
		$("#searchWorkTerm").html(workTermCdList[2]);
		
		
		$("#searchWorkTerm").find("option").each(function() {
			if( $(this).attr("selYn") == "Y" ){
				$(this).attr("selected", "selected");
			}
		});
		$("#searchWorkTerm").change();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
        	break;	
        case "Save": //임시저장의 경우 삭제처리만함.      
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}  
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/WorkScheduleApp.do?cmd=deleteWorkScheduleApp", $("#sheet1Form").serialize(), -1, 0); 
        	break;
        	
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}
	

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Title" :
			$("#searchSYmd").val( $("#searchWorkTerm option:selected").attr("sYmd") );
			$("#searchEYmd").val( $("#searchWorkTerm option:selected").attr("eYmd") );	
			$("#workGrpCd").val( $("#searchWorkTerm option:selected").attr("workGrpCd") );		
			
			var titleList = ajaxCall("${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppHeaderList", $("#sheet1Form").serialize(), false);
			if (titleList != null && titleList.DATA != null) {
				sheet2.Reset();
				var initdata = {};
				initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
				initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
				initdata.Cols = [];
				var v = 0 ;
				initdata.Cols[v++] = {Header:"구분", Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"gubun", KeyField:0, Format:"", Edit:0, BackColor:"#f4f4f4"};
				
				for(i = 0 ; i<titleList.DATA.length; i++) {
					initdata.Cols[v++] = {Header:titleList.DATA[i].title, Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:titleList.DATA[i].saveName, KeyField:0, Format:"", Edit:0, FontColor:titleList.DATA[i].fontColor};
				}

				IBS_InitSheet(sheet2, initdata); sheet2.SetEditable(0);sheet2.SetCountPosition(0);
		  		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		  		sheet2.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		  		sheet2.SetDataAlternateBackColor(sheet1.GetDataBackColor());
		  		clearSheetSize(sheet2);sheetInit();
			}
			
			break;
		case "Search":

			//sheet1 헤더 생성
			doAction2("Title");
			sheet2.DoSearch( "${ctx}/WorkScheduleApp.do?cmd=getWorkScheduleAppWorkList", $("#sheet1Form").serialize());
        	break;	
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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

		    }else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row) {
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
				url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}

		var p = {
				searchApplCd: '301'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			};
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 1200,
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
	}
	
	//신청 후 리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

	//인사헤더에서 이름 변경 시 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());

		//근무기간 콤보
		initWorkTermCombo();
		
    	doAction1("Search");
    	doAction2("Search");
    }
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	<input type="hidden" id="searchSYmd" name="searchSYmd" value=""/>
	<input type="hidden" id="searchEYmd" name="searchEYmd" value=""/>
	<input type="hidden" id="workGrpCd" name="workGrpCd" value=""/>
	</form>
	
	
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li class="txt">근무스케쥴</li>
				<li class="btn">
					<b>기준년도 &nbsp;:&nbsp;</b>
					<input type="text" id="searchYear" name="searchYear" class="text required w50" maxLength="4"/>
					&nbsp;&nbsp;
					<b>근무기간 &nbsp;:&nbsp;</b>
					<select id="searchWorkTerm" name="searchWorkTerm" class="text required" style="padding:3px;"></select>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:doAction1('Search');doAction2('Search');" 		class="btn dark authR" >조회</a>
					<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray authR" >다운로드</a>
				</li>
			</ul>
		</div>
		<script type="text/javascript">createIBSheet("sheet2", "100%", "136px"); </script>
	</div>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">근무스케쥴신청</li>
				<li class="btn">
					<a href="javascript:showApplPopup(-1);" 		class="btn filled authA" >신청</a>
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR" >다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</body>
</html>
