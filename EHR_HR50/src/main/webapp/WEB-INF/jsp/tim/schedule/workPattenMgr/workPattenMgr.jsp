<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var weekArr = ["", "일", "월", "화", "수", "목", "금", "토"];

	$(function() {

		//근무조패턴 시작요일 (default 2(월))
		//var data = ajaxCall( "${ctx}/GetDataMap.do?cmd=getSystemStdData", "searchStdCd=TIM_STD_START_WEEK",false);
		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=TIM_STD_START_WEEK", "queryId=getSystemStdData", false).codeList;
		if ( data != null && data[0] != null ){
			$("#stdWeek").val(data[0].value);
		}else{
			$("#stdWeek").val("2");
		}



        $("#searchDate").datepicker2({
   			onReturn:function(date){
   				doAction1("Search");
   			}
        });
		$("#searchDate").bind("keydown",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		init_sheet1(); //근무조
		init_sheet2(); //근무패턴
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});


	// 근무조그룹 별 근무조
	function init_sheet1(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근무조|근무조",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workOrgCd",		KeyField:1,	Format:"",			UpdateEdit:0,	InsertEdit:1},
			{Header:"근무그룹|근무그룹",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workGrpCd",		KeyField:1,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"시작일|시작일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",		UpdateEdit:0,	InsertEdit:1},
			{Header:"요일|요일",				Type:"Combo",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sdateWeek",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0},
			{Header:"종료일|종료일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		UpdateEdit:0,	InsertEdit:0},
			{Header:"순서|순서",				Type:"Int",			Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"유의사항|유의사항",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

		// 세부내역
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);


		/*(1:일, 2:월, 3:화, 4:수, 5:목, 6:금, 7:토)*/
		sheet1.SetColProperty("sdateWeek", {ComboText:"|일|월|화|수|목|금|토", ComboCode:"|1|2|3|4|5|6|7"});
	}

	function getCommonCodeList() {
		//공통코드 한번에 조회
		var grpCds = "T11020";
		let params = "grpCd="+grpCds + "&baseSYmd=" + $("#searchDate").val();
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y",params,false).codeList, "");
		sheet1.SetColProperty("workGrpCd",  	{ComboText:"|"+codeLists["T11020"][0], ComboCode:"|"+codeLists["T11020"][1]} ); //근무조그룹
	}

	function init_sheet2(){

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근무조|근무조",	Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workOrgCd",	KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"시작일|시작일",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"순서|순서",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"요일|요일",		Type:"Text",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"weekNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0},
			{Header:"근무시간|근무시간",	Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"timeCd",		KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetDataAlternateBackColor(sheet2.GetDataBackColor()); //홀짝 배경색 같게
		sheet2.SetFocusAfterProcess(0);
		
		var workOrgCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonWorkOrgCdList"), "");
		sheet1.SetColProperty("workOrgCd", 		{ComboText:"|"+workOrgCdList[0], ComboCode:"|"+workOrgCdList[1]} );
		sheet2.SetColProperty("workOrgCd", 		{ComboText:"|"+workOrgCdList[0], ComboCode:"|"+workOrgCdList[1]} );
	
	}


	//Sheet2 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/WorkPattenMgr.do?cmd=getWorkPattenMgrList", $("#sheet1Form").serialize(),1 );
			break;
		case "Save":

			if(!dupChk(sheet1,"workOrgCd|sdate", true, true)){break;}

			IBS_SaveName(document.sheet1Form,sheet1);

			if(sheet1.RowCount("D") > 0) {
				if(confirm("<msg:txt mid='alertWorkPattenMgr1' mdef='삭제되는 근무소속에 해당하는 반복패턴이 모두 지워집니다.\n정말 삭제처리를 하시겠습니까?'/>")) {
					sheet1.DoSave( "${ctx}/WorkPattenMgr.do?cmd=saveWorkPattenMgr", $("#sheet1Form").serialize(), -1, 0);
				}
			} else {
				sheet1.DoSave( "${ctx}/WorkPattenMgr.do?cmd=saveWorkPattenMgr", $("#sheet1Form").serialize());
			}
			break;
		case "Save2":
    		sheet1.SetCellValue(gPRow, "memo", $("#note").val());
    		doAction1("Save");
			break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), "workOrgCd");
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}



	//Sheet4 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			/*입력상태일땐 디테일 조회 안함*/
			if(sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus") == "I") {doAction2("Clear");return ;}
			var param = "searchWorkOrgCd="+sheet1.GetCellValue(gPRow,"workOrgCd")+"&searchSdate="+sheet1.GetCellValue(gPRow,"sdate")+"&searchWorkGrpCd="+sheet1.GetCellValue(gPRow,"workGrpCd")
			sheet2.DoSearch( "${ctx}/WorkPattenMgr.do?cmd=getWorkPattenUserMgrList", param,1 );
			break;
		case "Save":

			if(!dupChk(sheet2,"workOrgCd|seq", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/WorkPattenMgr.do?cmd=saveWorkPattenUserMgr" , $("#sheet1Form").serialize());
			break;
		case "Insert":
			//sheet2.SelectCell(sheet2.DataInsert(0), "seq");

			var selectRow = sheet1.GetSelectRow();

			if(sheet1.RowCount("I") > 0 || sheet1.RowCount("U") > 0 || sheet1.RowCount("D") > 0) {
				alert("근무조를 먼저 저장 후 입력하여 주세요.");
				return;
			}
			if(sheet1.RowCount() <= 0) {
				alert("근무조가 없습니다.");
				return;
			}

			var row = sheet2.DataInsert();

			var workOrgCd = sheet1.GetCellValue(selectRow,"workOrgCd");
			var sdate = sheet1.GetCellValue(selectRow,"sdate");

			sheet2.SetCellValue(row,"workOrgCd",workOrgCd);
			sheet2.SetCellValue(row,"sdate",sdate);
			sheet2.SelectCell(row, "seq");
			break;
		case "Copy":
			sheet2.DataCopy();
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
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
			if( Code > -1 ) {
				doAction2("Clear");
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					gPRow = NewRow;
		    		$("#note").val(sheet1.GetCellValue(NewRow, "memo"));

		    		setPattenTimeCd(NewRow);


					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	function setPattenTimeCd(row){
		//근무조의 근무시간 그룹에서 조회
		var param = "&searchShortNameFlag=Y"
		          + "&searchWorkGrpCd="+sheet1.GetCellValue(row,"workGrpCd");

		var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkOrgTimeCdList"+param,false).codeList, "");
		sheet2.SetColProperty("timeCd",	{ComboText:timeCdList[0], ComboCode:timeCdList[1]} );

	}


	function sheet1_OnChange(Row, Col, Value) {
		 try{
			 if(sheet1.ColSaveName(Col) == "sdate") {
				 var d = new Date(sheet1.GetCellText(Row, Col)).getDay()+1;
				 sheet1.SetCellValue(Row, "sdateWeek", d);

			 }
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

  	function sheet1_OnValidation(Row, Col, Value){
  	  	try{
  	  		if(sheet1.ColSaveName(Col) == "sdateWeek") {
  	  			//단위기간
  	  			var ival = parseInt( sheet1.GetCellValue(sheet1.GetSelectRow(), "intervalCd") );

  	        	if(Value != $("#stdWeek").val() && ival % 7 == 0 ){  //주단위 일때는
  	        		alert("시작일자는 "+weekArr[$("#stdWeek").val()]+"요일이어야 합니다.");
  	            	sheet1.ValidateFail(1);
  	            	sheet1.SelectCell(Row, "sdate");
  	            	return;
  	        	}
  	    	}

  	  	}catch(ex){alert("OnValidation Event Error : " + ex);}
 	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) {
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="stdWeek" name="stdWeek" />
	<div class="sheet_search outer">
		<table>
		<tr>
			<th><tit:txt mid='104535' mdef='기준일'/></th>
			<td>
				<input id="searchDate" name="searchDate" type="text" class="date2 required" value="${curSysYyyyMMddHyphen}" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
			</td>
		</tr>
		</table>
	</div>
	</form>

	<table class="sheet_main">
	<colgroup>
		<col width="" />
		<col width="20px" />
		<col width="35%" />
	</colgroup>
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">근무조</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>

			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			<div class="inner">
				<!-- div class="sheet_title hide">
				<ul>
					<li id="txt" class="txt">근무조 유의사항</li>
					<li class="btn hide">
						<a href="javascript:doAction1('Save2')" 	class="basic authA">저장</a>
					</li>
				</ul>
				</div -->

				<!-- textarea id="note" name="note" rows="5" class="text w100p hide" style="padding:5px; line-height:24px;"></textarea -->
			</div>
		</td>
		<td class="sheet_right"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow2.png"/></div></td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">근무조 반복패턴</li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction2('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='save' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>