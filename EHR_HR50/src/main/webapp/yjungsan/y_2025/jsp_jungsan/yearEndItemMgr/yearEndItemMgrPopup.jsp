<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산항목관리 팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var workYy  	 = "" ;
	var adjProcessCd = "" ;
	var adjProcessNm = "" ;
	var seq  		 = "" ;
	var helpText1  	 = "" ;
	var helpText2  	 = "" ;
	var helpText3  	 = "" ;
	var sheet1 = null;
	var sRow = "";

	$(function(){
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
		/*
			workYy  		= arg["workYy"];
			adjProcessCd  	= arg["adjProcessCd"];
			adjProcessNm  	= arg["adjProcessNm"];
			seq  			= arg["seq"];
			helpText1  		= arg["helpText1"];
			helpText2  		= arg["helpText2"];
			helpText3  		= arg["helpText3"];
		*/
			sheet1  		= arg["sheet1"];

		}else{
		/*
			if(p.window.workYy)			workYy 	  		= p.window.workYy.value;
			if(p.window.adjProcessCd)	adjProcessCd  	= p.window.adjProcessCd.value;
			if(p.window.adjProcessNm)	adjProcessNm    = p.window.adjProcessNm.value;
			if(p.window.seq)			seq 			= p.window.seq.value;
			if(p.window.helpText1)		helpText1 		= p.window.helpText1.value;
			if(p.window.helpText2)		helpText2 		= p.window.helpText2.value;
			if(p.window.helpText3)		helpText3 		= p.window.helpText3.value;
		*/
			sheet1 			= p.window.opener.sheet1;
		}

		sRow 		= sheet1.GetSelectRow();

		workYy = sheet1.GetCellValue(sRow,"work_yy");
		adjProcessCd = sheet1.GetCellValue(sRow,"adj_process_cd");
		adjProcessNm = sheet1.GetCellValue(sRow,"adj_process_nm");
		seq = sheet1.GetCellValue(sRow,"seq");
		helpText1 = sheet1.GetCellValue(sRow,"help_text1");
		helpText2 = sheet1.GetCellValue(sRow,"help_text2");
		helpText3 = sheet1.GetCellValue(sRow,"help_text3");

		getValue() ;

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
				
		load_sheet2();
 		$(window).smartresize(sheetResize);
		sheetInit();

		doAction2("Search");
		
	});

	function getValue() {
		var param = "srchYear="+workYy
					+"&srchAdjProcessCd="+adjProcessCd;

		var result = ajaxCall("<%=jspPath%>/yearEndItemMgr/yearEndItemMgrRst2.jsp?cmd=selectYearEndItemMgrPopup",param,false);
		 $("#helpText1").val(result["Data"]["help_text1"]) ;
		 $("#helpText2").val(result["Data"]["help_text2"]) ;
		 $("#helpText3").val(result["Data"]["help_text3"]) ;
	}

	function setValue() {
		/*
		var rv = new Array(6);

		rv["workYy"] 		= workYy ;
		rv["adjProcessCd"]	= adjProcessCd ;
		rv["adjProcessNm"] 	= adjProcessNm ;
		rv["seq"] 			= seq ;
		rv["helpText1"]		= $("#helpText1").val() ;
		rv["helpText2"]		= $("#helpText2").val() ;
		rv["helpText3"]		= $("#helpText3").val() ;

		//p.window.returnValue = rv;

		if(p.popReturnValue) p.popReturnValue(rv);
		*/
		sheet1.SetCellValue(sRow, "work_yy", 			workYy );
		sheet1.SetCellValue(sRow, "adj_process_cd", 	adjProcessCd );
		sheet1.SetCellValue(sRow, "adj_process_nm", 	adjProcessNm );
		sheet1.SetCellValue(sRow, "seq", 				seq );
		sheet1.SetCellValue(sRow, "help_text1", 		$("#helpText1").val() );
		sheet1.SetCellValue(sRow, "help_text2", 		$("#helpText2").val() );
		sheet1.SetCellValue(sRow, "help_text3", 		$("#helpText3").val() );

		p.window.close();
	}

	<!-- sheet2 -->
	function load_sheet2() {
		//공통코드(YEA994) : 연말정산도움말관리(SUB)
		var initdata = {};
		initdata.Cfg = {FrozenCol:6, SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"그룹코드",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"grcode_cd",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상년도",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note1",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"프로세스코드",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note2",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			
			{Header:"세부\n코드",  	Type:"Text",		Hidden:0,	Width:15,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:1,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"세부코드명",		Type:"Text",		Hidden:0,	Width:40,	Align:"Left",	ColMerge:0,	SaveName:"code_nm",		KeyField:1,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"FULL명",		Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"code_full_nm",KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"도움말",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, MultiLineText:1 },
			{Header:"도움말\n그룹",	Type:"Text",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"note3",		KeyField:1,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200, ToolTip:"4천 byte 초과 시, 분리해서 저장" },
			{Header:"순\n서",			Type:"Int",			Hidden:0,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,		CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			/*
			{Header:"보여\n주기",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"visual_yn",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"사용\n유무",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"use_yn",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"영문명",		    Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"code_eng_nm",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고4",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note4",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"비고(숫자형)",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"num_note",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
			*/
		];
		IBS_InitSheet(sheet2, initdata);sheet2.SetCountPosition(4);
			sheet2.SetColProperty("visualYn", {ComboText:"예|아니오", ComboCode:"Y|N"} );
			sheet2.SetColProperty("useYn", {ComboText:"사용|사용안함", ComboCode:"Y|N"} );
			sheet2.SetFocusAfterProcess(0);
	}
		
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			<%-- 그룹코드(YEA994) : 연말정산도움말관리(SUB) --%>
			var param = "srchGrcodeCd=YEA994" + "&srchYear="+workYy + "&srchAdjProcessCd=" + adjProcessCd ;			
		 	sheet2.DoSearch( "<%=jspPath%>/yearEndItemMgr/yearEndItemMgrRst2.jsp?cmd=selectYearEndItemMgrPopupSub",param );
			break;
		case "Save":
			if(!dupChk(sheet2,"code", true, true)){break;}
			var param = "srchGrcodeCd=YEA994" + "&srchYear="+workYy + "&srchAdjProcessCd=" + adjProcessCd ;		
			sheet2.DoSave( "<%=jspPath%>/yearEndItemMgr/yearEndItemMgrRst2.jsp?cmd=saveYearEndItemMgrPopupSub",param);			
            break;
		case "Insert":
            var newRow = sheet2.DataInsert(0) ;
            sheet2.SetCellValue( newRow, "grcode_cd", "YEA994" ); // 공통코드(YEA994) = 연말정산도움말관리(SUB)
            sheet2.SetCellValue( newRow, "note1", workYy );       // 대상년도
            sheet2.SetCellValue( newRow, "note2", adjProcessCd ); // 프로세스코드
			break;
		case "Copy":		
			sheet2.SelectCell(sheet2.DataCopy(), 2);			
			break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet2);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
            sheet2.Down2Excel(param);
			break;
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction2("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">

	<form id="mySheetForm" name="mySheetForm" />
	
	<div class="popup_title">
		<ul>
			<li>도움말 관리</li>
			<!--<li class="close"></li>-->
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="9%" />
				<col width="91%" />
			</colgroup>
			<tr>
				<th>도움말_1</th>
				<td>
					<textarea id="helpText1" name="helpText1"rows="13" class="w100p"></textarea>
				</td>
			</tr>

			<tr>
				<th>도움말_2</th>
				<td>
					<textarea id="helpText2" name="helpText2"rows="7" class="w100p"></textarea>
				</td>
			</tr>

			<tr>
				<th>도움말_3</th>
				<td>
					<textarea id="helpText3" name="helpText3"rows="4" class="w100p"></textarea>
				</td>
			</tr>

		</table>
		
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt">도움말(SUB)</li>
							<li class="btn">
							    <strong class='blue'>세부코드(도움말그룹)는 귀속년도2자리^프로세스코드를 접미사로 지정 (ex. yy^A070_)</strong>
							    <a href="javascript:doAction2('Search');" class="basic authA">조회</a>
								<a href="javascript:doAction2('Insert');" class="basic authA">입력</a>
								<a href="javascript:doAction2('Copy');" class="basic authA">복사</a>
								<a href="javascript:doAction2('Save');" class="basic btn-save authA">저장</a>
								<a href="javascript:doAction2('Down2Excel');" class="basic btn-download authR">다운로드</a>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet2", "100%", "30%"); </script>
				</td>
			</tr>
		</table>
		
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:setValue();" class="blue large authA">확인</a>
					<a href="javascript:p.self.close();" class="gray large authR">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>