<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근무코드/근무일집계설정</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='workDdCd' mdef='근무일집계코드'/>",	Type:"Combo",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"workDdCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='fromHour' mdef='유효시간\n(이상)'/>",Type:"Int",			Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"fromHour",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"<sht:txt mid='toHour' mdef='유효시간\n(미만)'/>",Type:"Int",			Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"toHour",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",		Type:"Text",		Hidden:1,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"<sht:txt mid='searchNm' mdef='검색설명'/>",		Type:"Popup",		Hidden:0,	Width:170,	Align:"Left",	ColMerge:0,	SaveName:"searchDesc",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var workDdCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10019"), "");		//그룹코드
		sheet1.SetColProperty("workDdCd", 		{ComboText:"|"+workDdCdList[0], ComboCode:"|"+workDdCdList[1]} );

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='workDdCd' mdef='근무일집계코드'/>",	Type:"Combo",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"workDdCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='workCd' mdef='근무코드'/>",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetColProperty("workDdCd", 		{ComboText:"|"+workDdCdList[0], ComboCode:"|"+workDdCdList[1]} );
		var workCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "");//getWorkCdList
		sheet2.SetColProperty("workCd", 		{ComboText:"|"+workCdList[0], ComboCode:"|"+workCdList[1]} );

		sheet2.SetFocusAfterProcess(0);


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/WorkTotalMgr.do?cmd=getWorkTotalMgrList", $("#mySheetForm").serialize(),1 );
			break;
		case "Save":

			if(!dupChk(sheet1,"workDdCd", true, true)){break;}
			var deleteFlag = false ;
			for(var i = 1; i < sheet1.LastRow()+1; i++) {
				if( sheet1.GetCellValue( i , "sStatus" ) == "D" ) {
					deleteFlag = "true" ;
				}
			}

			if(deleteFlag) {
				if(confirm("<msg:txt mid='alertWorkTotalMgr1' mdef='삭제되는 근무일집계코드에 해당하는 근무코드가 모두 지워집니다.\n정말 삭제처리를 하시겠습니까?'/>")) {
					IBS_SaveName(document.mySheetForm,sheet1);
					sheet1.DoSave( "${ctx}/WorkTotalMgr.do?cmd=saveWorkTotalMgr", $("#mySheetForm").serialize(), -1, 0);
				}
			} else {
				IBS_SaveName(document.mySheetForm,sheet1);
				sheet1.DoSave( "${ctx}/WorkTotalMgr.do?cmd=saveWorkTotalMgr", $("#mySheetForm").serialize());
			}
			break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), "workOrgCd");
			doAction2("Clear");
			break;
		case "Copy":
			sheet1.DataCopy();
			doAction2("Clear");
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

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			/*입력상태일땐 디테일 조회 안함*/
			if(sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus") == "I") {return ;}
			var param = "searchWorkDdCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"workDdCd");
			sheet2.DoSearch( "${ctx}/WorkTotalMgr.do?cmd=getWorkTotalMgrUserMgrList", param,1 );
			break;
		case "Save":

			if(!dupChk(sheet2,"workCd", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/WorkTotalMgr.do?cmd=saveWorkCdUserMgr" , $("#mySheetForm").serialize());
			break;
		case "Insert":
			var selectRow = sheet1.GetSelectRow();

			if(sheet1.RowCount("I") > 0) {
				alert("<msg:txt mid='alertWorkTotalMgr2' mdef='근무일수를 저장후 입력하여 주십시오.'/>");
				return;
			}
			if(sheet1.RowCount() <= 0) {
				alert("<msg:txt mid='alertWorkTotalMgr2' mdef='근무일수를 저장후 입력하여 주십시오.'/>");
				return;
			}
			var row = sheet2.DataInsert(0) ;

			var workDdCd = sheet1.GetCellValue(selectRow,"workDdCd");
			sheet2.SetCellValue(row,"workDdCd",workDdCd);
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
			doAction2("Clear");
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

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

			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{

		  var colName = sheet1.ColSaveName(Col);
		  var args    = new Array();
		  var rv = null;

		  if(colName == "searchDesc") {
			  if(!isPopup()) {return;}
			  gPRow = Row;
			  pGubun = "pwrSrchMgrPopup";
			  //openPopup("/Popup.do?cmd=pwrSrchMgrPopup&authPg=${authPg}", args, "850","620");
			  let layerModal = new window.top.document.LayerModal({
				  id : 'pwrSrchMgrLayer', 
				  url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=${authPg}',
				  parameters : {
					  searchSeq : sheet1.GetCellValue(Row, "searchSeq"), 
					  searchDesc : sheet1.GetCellValue(Row, "searchDesc")
				  }, 
				  width : 850, 
				  height : 620, 
				  title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>', 
				  trigger :[
					  {
						  name : 'pwrTrigger', 
						  callback : function(result){
							  getReturnValue(result);
						  }
					  }
				  ]
			  });
			  layerModal.show();
              /*
			  if(rv!=null){
                  sheet1.SetCellValue(Row, "searchSeq",   rv["searchSeq"] );
                  sheet1.SetCellValue(Row, "searchDesc", rv["searchDesc"] );
              }
              */
		  }

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;
	    if(pGubun == "pwrSrchMgrPopup"){
	    	sheet1.SetCellValue(gPRow, "searchSeq",   rv["searchSeq"] );
	        sheet1.SetCellValue(gPRow, "searchDesc",  rv["searchDesc"] );

	    }
	}

	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main w100p">
	<colgroup>
		<col width="70%" />
		<col width="30%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='workTotalMgr1' mdef='근무일수'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Search');" css="btn dark authA" mid='search' mdef="조회"/>
						<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
                        <btn:a href="javascript:doAction1('Down2Excel')"   css="btn outline_gray authR" mid='download' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "70%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='workTotalMgr2' mdef='근무코드'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='save' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "30%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>