<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>조직도수정관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("input[type='text']").keydown(function(event){ 
			if(event.keyCode == 27){
				return false;
			}
		});
		
		// 토글버튼 기본 minus 세팅
		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet2.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet2.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet2.ShowTreeLevel(-1);
			}
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet2.ShowTreeLevel(-1):sheet2.ShowTreeLevel(0, 1);
		});

		$("#searchBaseDate").datepicker2();
		
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, DragMode : 1, DeferredVScroll:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='orgSchemeUseYn' mdef='현조직도\n사용여부'/>", 	Type:"CheckBox",  Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgSchemeUseYn",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1,	TrueValue:"1", FalseValue:"0" },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",			Type:"Text",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgCd",         	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",				Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
            {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>", 			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",         	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>", 			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='orgFullNm' mdef='조직명(FULL)'/>",		Type:"Text",      Hidden:1,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgFullNm",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='orgEngNm' mdef='조직명(영문)'/>",		Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgEngNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='orgType' mdef='조직유형'/>",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"orgType",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='inoutType' mdef='내외구분'/>",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"inoutType",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='telNoV2' mdef='대표전화번호'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"telNo",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='inoutTypeV2' mdef='조직구분'/>", 			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"objectType",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='coTelNo' mdef='내선번호'/>", 			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"coTelNo",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='locationCd_V2988' mdef='사업장\n(Location)'/>", 		Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"locationCd",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='workAreaCd' mdef='근무지역코드'/>",            Type:"Text",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"workAreaCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='workAreaNm' mdef='근무지역'/>",            Type:"PopupEdit",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"workAreaNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='mission' mdef='조직목적'/>", 			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"mission",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='roleMemo' mdef='조직역할'/>", 			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"roleMemo",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='keyJobMemo' mdef='조직KEYJOB'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"keyJobMemo",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='visualYnV1' mdef='보여주기\n여부'/>",		Type:"CheckBox",  Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"visualYn",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N" },
            {Header:"<sht:txt mid='armyMemo' mdef='비고'/>", 				Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"memo",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var orgType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20010"), "");	//조직유형
		var inoutType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20050"), "");	//내외구분
		var objectType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20030"), "");	//조직구분
		var locationCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION

		sheet1.SetColProperty("orgType", 			{ComboText:"|"+orgType[0], ComboCode:"|"+orgType[1]} );	//조직유형
		sheet1.SetColProperty("inoutType", 			{ComboText:"|"+inoutType[0], ComboCode:"|"+inoutType[1]} );	//내외구분
		sheet1.SetColProperty("objectType", 		{ComboText:"|"+objectType[0], ComboCode:"|"+objectType[1]} );	//조직구분
		sheet1.SetColProperty("locationCd", 		{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );	//LOCATION

		
		initdata = {};
		initdata.Cfg = {SearchMode:smGeneral};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0, DragMode : 1, DeferredVScroll:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",				Type:"Date",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",             KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='orgNmV6' mdef='조직도'/>",				Type:"Popup",     Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000,    TreeCol:1,  LevelSaveName:"sLevel" },
			{Header:"<sht:txt mid='directYn' mdef='직속\n여부'/>",			Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"directYn",          KeyField:0,   CalcLogic:"",   Format:"",     		  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",       Hidden:0,  Width:35,   Align:"Right",   ColMerge:0,   SaveName:"seq",               KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='orgLevel' mdef='조직\n레벨'/>",	Type:"Int",       Hidden:0,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"orgLevel",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='orgDispYn' mdef='화상조직도\n출력여부'/>",			Type:"CheckBox",  Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"orgDispYn",          KeyField:0,   CalcLogic:"",   Format:"",     		  PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N", DefaultValue:"Y" },			
			{Header:"<sht:txt mid='locType' mdef='행표시'/>",				Type:"Int",       Hidden:1,  Width:45,   Align:"Right",   ColMerge:0,   SaveName:"locType",           KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='xPos' mdef='X축'/>",				Type:"Int",       Hidden:1,  Width:30,   Align:"Right",   ColMerge:0,   SaveName:"xPos",              KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='yPos' mdef='Y축'/>",				Type:"Int",       Hidden:1,  Width:30,   Align:"Right",   ColMerge:0,   SaveName:"yPos",              KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",				Type:"CheckBox",  Hidden:1,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"select",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='priorOrgCdChange' mdef='상위조직\n변경코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"priorOrgCdChange",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orderSeq_V5466' mdef='직제순서'/>",			Type:"Int",       Hidden:1,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"orderSeq",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='priorOrgNmChange' mdef='상위조직\n변경'/>",		Type:"Popup",     Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"priorOrgNmChange",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetColProperty("directYn", {ComboText:"|YES|NO", ComboCode:"|Y|N"} );
		sheet2.SetFocusAfterProcess(0);
		sheet2.SetTreeActionMode(1);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchVisualYn").html("<option value=''><tit:txt mid='112598' mdef='사용안함'/></option>"); // 보여주기여부
		$("#searchVisualYn").change(function(){
			doAction1("Search");
		});


		$("#searchOrgCd,#searchOrgNm,#searchBaseDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#searchSdate").bind("change",function(event){
			doAction2("Search");
		});

		doAction1("Search");
		doAction2("Search");
	});
	
	if (this.setIBEvents) {
	    this.setIBEvents();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/OrgCdMgr.do?cmd=getOrgCdMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/OrgCdMgr.do?cmd=saveOrgCdMgr", $("#srchFrm").serialize() ); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
							//sheet1.SetCellValue(Row, "edate", "99991231");
							sheet1.SetCellValue(Row, "visualYn", "Y");
							sheet1.SelectCell(Row, "orgCd");
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/OrgSchemeMgr.do?cmd=getOrgSchemeMgrSheet2List", $("#srchFrm2").serialize(),1 ); break;
		case "Save":
					        if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") != "R" ) {
					            alert("<msg:txt mid='alertBfOrgHisSave' mdef='먼저 조직도이력을 저장해 주세요.'/>");
					            return;
					        }

					        if(!dupChk(sheet2,"orgCd", true, true)){break;}

					        /* 최상위 레벨을 제외한 화상조직도 레벨이 0일경우 저장막기 *
                            for( i = 2; i <= sheet2.LastRow(); i++) {
                                if(sheet2.GetCellValue(i,"orgLevel") == 0){
                                	alert(sheet2.GetCellValue(i,"orgNm")+"의 화상조직도 레벨은 0레벨 이상이어야 합니다.");
                                	return;
                                }
                            }
					        /**/
                            IBS_SaveName(document.srchFrm2,sheet2);
							sheet2.DoSave( "${ctx}/OrgSchemeMgr.do?cmd=saveOrgSchemeMgrSheet2", $("#srchFrm2").serialize() ); break;
		case "Insert":
							var Row = sheet2.DataInsert();

							sheet2.SetCellValue(Row,"sdate",$("#searchSdate").val());
							if( Row == 1 ) sheet2.SetCellValue(Row,"priorOrgCd","0");
							else sheet2.SetCellValue(Row,"priorOrgCd",sheet2.GetCellValue(Row-1, "orgCd"));

							sheet2.SelectCell(Row, "orgNm");
							break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,TreeLevel:0};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
	    case "ChangeOrgSet":        //Setting orgnm
					        if(sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd")){

					            for( i = 1; i <= sheet2.LastRow(); i++) {
					                if(sheet2.GetCellValue(i,"select") == 1){
					                    if(sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd") == sheet2.GetCellValue(i, "orgCd")){
					                        sheet2.SetCellValue(i, "priorOrgCdChange","");
					                        sheet2.SetCellValue(i, "priorOrgNmChange","");
					                    }else{
					                        sheet2.SetCellValue(i,"select",0);
					                        sheet2.SetCellValue(i, "priorOrgCdChange",sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd"));
					                        sheet2.SetCellValue(i, "priorOrgNmChange",sheet2.GetCellValue(sheet2.GetSelectRow(),"orgNm"));
					                    }
					                }
					            }
					        }
					        break;
	    case "ChangeOrgInit":        //Clear
				            for( i = 1; i <= sheet2.LastRow(); i++) {
				                if(sheet2.GetCellValue(i,"select") == 1){
				                        sheet2.SetCellValue(i,"select",0);
				                        sheet2.SetCellValue(i, "priorOrgCdChange","");
				                        sheet2.SetCellValue(i, "priorOrgNmChange","");
				                }
				            }
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
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try {
			if( sheet1.ColSaveName(NewCol) == "sDelete" ) {

				if( sheet1.GetCellEditable(NewRow,"sDelete") == false && sheet1.GetCellValue(NewRow,"sStatus") != "I" ) {
					alert("<msg:txt mid='alertNotDelOrgCd' mdef='조직에 해당하는 사원이 존재 합니다. 삭제할 수 없습니다.'/>");
					return;
				} else {
					sheet1.SetCellEditable(NewRow,"sDelete",true);
				}
			}
		}
		catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnPopupClick(Row, Col){
		try{

		  var colName = sheet1.ColSaveName(Col);
		  var args    = new Array();

		  var rv = null;

		  if(colName == "workAreaNm") {
			  if(!isPopup()) {return;}
			  gPRow = Row;
			  pGubun = "workAreaPop";
			  args["grpCd"]   = "H90202";
			  var rv = openPopup("/Popup.do?cmd=commonCodePopup&authPg=${authPg}", args, "740","520");
		  }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

	        // 조직도이력의 입력이나 복사한 행을 다시 선택한 경우 복사해온 조직도를 입력 상태로 바꾸어 주고 시작일 셋팅
	        if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
	            for( i = 1; i<=sheet2.LastRow(); i++ ) {
	                sheet2.SetCellValue(i, "sdate",sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate"));
	                sheet2.SetCellValue(i, "sStatus", "I");
	            }
	        }

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {alert(Msg);}
			orgSchemeSortCreate();
			doAction1("Search");
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		try {
			if( sheet2.ColSaveName(Col) == "orgNm" || sheet2.ColSaveName(Col) == "priorOrgNmChange" ) {
				popupGubun = sheet2.ColSaveName(Col);	//같은 팝업을 사용하므로 팝업구분으로 값을 셋팅
				orgBasicPopup(Row) ;
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
/* 	function sheet2_OnCellDropEnd(Obj, Row, Col, ToObj, sheet2Row, ToCol) {
        var bValue = ToObj.GetCellValue(sheet2Row, ToCol),
            aValue = Obj.GetCellValue(Row, Col);

        if (sheet2Row < 0) {
            return;
            sheet2Row = ToObj.DataInsert(sheet2Row);
            ToCol = ToObj.MouseCol();
        }

        if (ToObj && sheet2Row > 0 && ToCol >= 0) {
            ToObj.SetCellValue(sheet2Row, ToCol, aValue);

            if (bValue) {
                Obj.SetCellValue(Row, Col, bValue);
            } else {
                Obj.SetCellValue(Row, Col, "");
            }
        }
    }; */
	
     function setIBEvents() {
        window["sheet1_OnDropEnd"] = function(sheet1, sheet1Row, sheet2, sheet2Row, X, Y, Type) {
            //같은 시트에서는 데이터이동 안됨.
            if (sheet1 == sheet2) return;
            var rowjson = sheet1.GetRowData(sheet1Row);
            //행 데이터 복사
            sheet2.SetRowData(sheet2Row + 1, rowjson, {
                "Add": 1
            });
            //원본 데이터 삭제
            //sheet1.RowDelete(sheet1Row);
        };
        window["sheet2_OnDropEnd"] = function(sheet1, sheet1Row, sheet2, sheet2Row, X, Y, Type) {
            //드레그 한 행의 데이터를 json형태로 얻음
            var rowjson = sheet1.GetRowData(sheet1Row),
                posRow = sheet1Row;
            if (sheet1 == sheet2 && sheet2Row < sheet1Row) {
                //같은 시트내에서 이동은 신경을 써야 함.
                posRow++;
            }
            //드롭 지점의 레벨을 확인
            var lvl = sheet2.GetRowLevel(sheet2Row);
            //if (lvl < 1) return;
            //행 데이터 복사(트리임으로 레벨을 고려할 것)
            sheet2.SetRowData(sheet2Row + 1, rowjson, {
                "Add": 1,
                "Level": lvl + 1
            });

			sheet2.SetCellValue(sheet2Row+1,"sdate",$("#searchSdate").val());
			/* if( sheet2Row == 1 ) sheet2.SetCellValue(sheet2.GetParentRow(sheet2Row+1),"priorOrgCd","orgCd");
			else  */sheet2.SetCellValue(sheet2Row+1,"priorOrgCd",sheet2.GetCellValue(sheet2.GetParentRow(sheet2Row+1), "orgCd"));
			//sheet2.SetCellValue(sheet2Row+1,"orgLevel",lvl);
             
            //원본 데이터 삭제
            //sheet1.RowDelete(posRow);
        };
    } 
    
	//  조직코드 조회
	function orgBasicPopup(Row){
	    try{
	    	if(!isPopup()) {return;}

			var args = new Array();
			args["chkVisualYn"] = "N";

			gPRow = Row;
			pGubun = "orgBasicPopup";

	     	openPopup("/Popup.do?cmd=orgBasicPopup&authPg=${authPg}", args, "800","720");
	    } catch(ex){
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	

	// 직제 소팅을 위한 정렬 순서 생성, F_ORG_ORG_CHART_SORT 함수에서 SORT_SEQ 필드 참조
	function orgSchemeSortCreate() {
		var sdate = $("#searchSdate").val();
		var result = ajaxCall("/OrgSchemeMgr.do?cmd=prcOrgSchemeSortCreateCall","sdate="+sdate, false);
		/*
		if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
			if (result["Result"]["Code"] == "0" || result["Result"]["Code"] == "OK") {
				alert("<msg:txt mid='110061' mdef='정상 처리되었습니다.'/>");
			} else if (result["Result"]["Message"] != null) {
				alert(result["Result"]["Message"]);
			}
		} else {
			alert("<msg:txt mid='alertOrgSortErr' mdef='직제 소팅을 위한 정렬 순서 생성 오류입니다.'/>");
		}
		*/
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');
		
        if(pGubun == "workAreaPop"){
        	sheet1.SetCellValue(gPRow, "workAreaCd", rv["code"]);
        	sheet1.SetCellValue(gPRow, "workAreaNm", rv["codeNm"]);
        }else if(pGubun == "orgBasicPopup"){
            if( popupGubun == "orgNm" ) {
	        	sheet2.SetCellValue(gPRow, "orgCd",		rv["orgCd"]);
	        	sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
            } else if( popupGubun == "priorOrgNmChange" ) {
	        	sheet2.SetCellValue(gPRow, "priorOrgCdChange",		rv["orgCd"]);
	        	sheet2.SetCellValue(gPRow, "priorOrgNmChange",		rv["orgNm"]);
            }
            sheet2.SetFocusAfterProcess(0);
        }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
<form name="srchFrm" id="srchFrm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<th><tit:txt mid='112889' mdef='조직코드'/>  </th>
				<td>  <input id="searchOrgCd" name ="searchOrgCd" type="text" class="text" /> </td>
				<th><tit:txt mid='104514' mdef='조직명'/>  </th>
				<td>  <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>
				<th><tit:txt mid='103906' mdef='기준일자'/>  </th>
				<td>  <input id="searchBaseDate" name="searchBaseDate" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
				<!--  <td> <th ><tit:txt mid='114509' mdef='보여주기여부 '/></th> <select id="searchVisualYn" name="searchVisualYn"></td> -->

				<td>  <btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='110697' mdef="조회"/>  </td>
			</tr>
		</table>
		</div>
	</div>
</form>
		
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">조직코드</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy');" 	css="basic authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save');" 	css="basic authA" mid='110708' mdef="저장"/>
						<btn:a href="javascript:doAction1('Down2Excel');" 	css="basic authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</div>
		</td>
		<td class="sheet_right">
<form id="srchFrm2" name="srchFrm2" >
	<div class="sheet_search outer">
		<div>
			<table>
				<tr>
					<th><tit:txt mid='orgSchemeMgr' mdef='조직도'/>  </th>
					<td>
						<select id="searchSdate" name ="searchSdate" class="w250"></select>
					</td>
					<td>
						<btn:a href="javascript:doAction2('Search');" id="btnSearch" css="button" mid='110697' mdef="조회"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='112713' mdef='조직도'/>&nbsp;
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>
					</li>
					<li class="btn">
						<%-- <a href="javascript:doAction2('Search')" 	class="button authR"><tit:txt mid='104081' mdef='조회'/></a> --%>
						<!--  <a href="javascript:doAction2('ChangeOrgInit')" 	class="basic authA"><tit:txt mid='112391' mdef='초기화'/></a>
						<a href="javascript:doAction2('ChangeOrgSet')" 	class="basic authA"><tit:txt mid='113224' mdef='변경조직반영'/></a> -->
						<a href="javascript:doAction2('Insert');" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
						<a href="javascript:doAction2('Save');" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
						<a href="javascript:doAction2('Down2Excel');" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
			</div>
		</td>
</div>
</body>
</html>
