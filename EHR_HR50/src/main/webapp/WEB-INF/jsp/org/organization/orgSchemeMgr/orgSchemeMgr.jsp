
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
	var confirmYn = true;
	var popupGubun = "";
	var gPRow = "";
	var pGubun = "";
	var NewRow = "";
	
	var _copyGubun = "";
	var _oldRow = "";
	var _oldPriorOrgCd = "";
	var _oldLevel = "";
	var _changeRow = "";
	var _oldValue = "";	

	$(function() {
		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#srchFrm"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
		sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

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
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
    		{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",		Type:"Text",      Hidden:0,  Width:150,  Align:"Center",    ColMerge:0,   SaveName:"orgChartNm",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:1,   Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",				Type:"Date",      Hidden:0,  Width:90,  Align:"Center",  ColMerge:0,   SaveName:"sdate",            KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 , EndDateCol: "edate"},
			{Header:"<sht:txt mid='edate' mdef='종료일'/>",				Type:"Date",      Hidden:0,  Width:90,  Align:"Center",  ColMerge:0,   SaveName:"edate",            KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , StartDateCol: "sdate"},
			{Header:"<sht:txt mid='version' mdef='버전'/>",				Type:"Text",      Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"version",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduRewardCdV2' mdef='개편구분'/>",		Type:"Combo",      Hidden:1,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"orgKindType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='memoV6' mdef='개편내용\n(줄바꿈 : Shift+Enter)'/>",				Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"memo",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000, MultiLineText:1, ToolTip:1},
			{Header:"<sht:txt mid='delYn' mdef='삭제가능여부'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"delYn",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",			Type:"Html",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {SearchMode:smGeneral,DragMode:1,DragRow:1};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",							Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",						Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",						Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"회사구분",													Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"enterCd",				KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",						Type:"Date",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sdate",				KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV4' mdef='조직코드'/>",					Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",				KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNm_V5096' mdef='조직도'/>",					Type:"Popup",     Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",				KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50,    TreeCol:1,  LevelSaveName:"sLevel" },
			{Header:"<sht:txt mid='directYn' mdef='직속\n여부'/>",				Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"directYn",			KeyField:0,   CalcLogic:"",   Format:"",     		  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"기타인원",													Type:"Int",       Hidden:1,  Width:35,   Align:"Right",   ColMerge:0,   SaveName:"subcontractCnt",		KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:23, Cursor:"Pointer" },
			{Header:"<sht:txt mid='seqV2' mdef='순서'/>",						Type:"Int",       Hidden:0,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"seq",					KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='orgLevel' mdef='조직\n레벨'/>",				Type:"Int",       Hidden:0,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"orgLevel",			KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='orgDispYn' mdef='화상조직도\n출력여부'/>",			Type:"CheckBox",  Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"orgDispYn",          KeyField:0,   CalcLogic:"",   Format:"",     		  PointCount:0,   UpdateEdit:1,   InsertEdit:1, TrueValue:"Y", FalseValue:"N", DefaultValue:"Y" },			
			{Header:"<sht:txt mid='locType' mdef='행표시'/>",						Type:"Int",       Hidden:1,  Width:45,   Align:"Right",   ColMerge:0,   SaveName:"locType",				KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='xPos' mdef='X축'/>",							Type:"Int",       Hidden:1,  Width:30,   Align:"Right",   ColMerge:0,   SaveName:"xPos",				KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='yPos' mdef='Y축'/>",							Type:"Int",       Hidden:1,  Width:30,   Align:"Right",   ColMerge:0,   SaveName:"yPos",				KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",					Type:"CheckBox",  Hidden:1,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"select",				KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='priorOrgCdChange' mdef='상위조직\n변경코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"priorOrgCdChange",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orderSeq_V5466' mdef='직제순서'/>",			Type:"Int",       Hidden:1,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"orderSeq",			KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='priorOrgNmChange' mdef='상위조직\n변경'/>",		Type:"Popup",     Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"priorOrgNmChange",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='vertYn' mdef='세로\n표시'/>",					Type:"CheckBox",  Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"vertYn",				KeyField:0,   CalcLogic:"",   Format:"",  TrueValue:'Y' , FalseValue : 'N' ,   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='leaderYn' mdef='조직장\n포함'/>",				Type:"CheckBox",  Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"leaderYn",			KeyField:0,   CalcLogic:"",   Format:"",  TrueValue:'Y' , FalseValue : 'N' ,   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"하위조직\n세로정렬여부",										Type:"CheckBox",  Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"vrtclOrderYn",		KeyField:0,   CalcLogic:"",   Format:"",  TrueValue:'Y', FalseValue : 'N',   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		sheet1.SetColProperty("orgKindType", 			{ComboText:"대개편|소개편", ComboCode:"0|1"} );

		$(window).smartresize(sheetResize); sheetInit();
		sheet2.SetFocusAfterProcess(0);
		sheet2.SetTreeActionMode(1);
		
		
		var Menu = [
					{Text: "입력", Code: "Insert"},
					{Text: "잘라내기", Code: "Copy" },
					{Text: "붙여넣기", Code: "Paste" },
					{Text: "삭제", Code: "Delete" },
					{Text: "*-"}

				];

		sheet2.SetActionMenu(Menu, 1);		
		
		
		doAction1("Search");
	});

	function chkInVal(sheet) {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet.GetCellValue(i, "sStatus") == "I" || sheet.GetCellValue(i, "sStatus") == "U") {
				if (sheet.GetCellValue(i, "edate") != null && sheet.GetCellValue(i, "edate") != "") {
					var sdate = sheet.GetCellValue(i, "sdate");
					var edate = sheet.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet.SelectCell(i, "edate");
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
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			sheet1.DoSearch( "${ctx}/OrgSchemeMgr.do?cmd=getOrgSchemeMgrSheet1List", $("#srchFrm").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"sdate", true, true)){break;}
			if (!chkInVal(sheet1)) {break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/OrgSchemeMgr.do?cmd=saveOrgSchemeMgrSheet1", $("#srchFrm").serialize() ); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row,"orgChartNm","${ssnEnterNm}<tit:txt mid='112713' mdef='조직도'/>");
							sheet1.SetCellValue(Row,"sdate","<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
							sheet1.SetCellValue(Row,"edate","99991231");
							sheet1.SetCellValue(Row,"delYn","0");

							sheet1.SelectCell(Row, "sdate");

							$("#searchSdate").val(sheet1.GetCellValue(Row, "sdate"));							
							
							//파일첨부 시작
							sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
							//파일첨부 끝							
							
							doAction2("Clear");
							break;
		case "Copy":
							if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I") {
								alert("<msg:txt mid='alertOrgSchemeCopy' mdef='저장되지 않은 조직도이므로 복사할 수 없습니다.'/>");
							  	return;
							}

					      	var Row = sheet1.DataCopy();
							$("#searchSdate").val(sheet1.GetCellValue(Row-1, "sdate"));

						    sheet1.SetCellValue(Row,"orgChartNm",sheet1.GetCellValue(Row-1, "orgChartNm"));
						    sheet1.SetCellValue(Row,"sdate","");
						    sheet1.SetCellValue(Row,"edate","99991231");
						    sheet1.SetCellValue(Row,"delYn","0");
						    sheet1.SetCellValue(Row, "languageCd", "" );
						    sheet1.SetCellValue(Row, "languageNm", "" );

						    sheet1.SelectCell(Row, "sdate");
	    					break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1, ['Html']);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/OrgSchemeMgr.do?cmd=getOrgSchemeMgrSheet2List", $("#srchFrm").serialize(),1 ); break;
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
                            IBS_SaveName(document.srchFrm,sheet2);
							sheet2.DoSave( "${ctx}/OrgSchemeMgr.do?cmd=saveOrgSchemeMgrSheet2", $("#srchFrm").serialize() ); break;
		case "Insert":
							var Row = sheet2.DataInsert();

							sheet2.SetCellValue(Row,"sdate",sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate"));
							if( Row == 1 ) sheet2.SetCellValue(Row,"priorOrgCd","0");
							else sheet2.SetCellValue(Row,"priorOrgCd",sheet2.GetCellValue(Row-1, "orgCd"));

							sheet2.SelectCell(Row, "orgNm");

							_changeRow	 = Row;
							_oldValue  = 100;
							_copyGubun = "Insert";
							// 자동 SEQ 부여. 사용하지 않음. CBS. 2019.01.30 
							//orgSeqSort(Row ,  0);		

							
							break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,TreeLevel:0};
			var d = new Date();
			var fName = " 조직도_" + d.getTime();
			sheet2.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
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
	    case "sortOrgLine":
	    	
	    	if (confirm("조직 계층구조와 순서에 따라 직제순서를 재정렬합니다.\n진행하시겠습니까?")){
		    	var sdate = $("#searchSdate").val();
				var result = ajaxCall("/OrgSchemeMgr.do?cmd=prcOrgSchemeSortCreateCall","sdate="+sdate, false);
				
				if ( result.Result["Code"] == "0" ){
	
					alert("조직도 직제순서가 재정렬되었습니다.");
					doAction2("Search");
				}else{
					
					alert(result.Result["Message"]);
				}
	    	}
	    	
	    	break;
		}
	}
	
	function sheet2_OnSelectMenu(Text, Code) {

		// text 또는 code값으로 Action수행

		switch(Code) {

			case "첫행입력" :
				sheet2.DataInsert(0);
				break;

			case "마지막행입력" :
				sheet2.DataInsert(-1);
				break;

			case "Insert" :
				doAction2("Insert");
				//sheet2.DataInsert();
				break;

			case "Copy":
				_oldRow = sheet2.GetSelectRow();
				_oldLevel = sheet2.GetRowLevel(_oldRow) ;
				_oldPriorOrgCd = sheet2.GetCellValue(_oldRow,"priorOrgCd");
				if(_oldRow < 0) {
					alert("Row 선택 되지 않았습니다.");
					return;
				}
				break;

			case "Paste":
				if(_oldRow == null || _oldRow == undefined || _oldRow == "") {
					alert("복사된 조직이 없습니다.");
					return;
				}
				var newRow = sheet2.GetSelectRow() + 1;
				//var level = sheet2.GetRowLevel(newRow) ;
				var level = sheet2.GetRowLevel(sheet2.GetSelectRow())+1 ;

				if(level == _oldLevel && _oldPriorOrgCd == sheet2.GetCellValue( sheet2.GetSelectRow() ,"orgCd") ) {
					alert("동일한 레벨에는 붙여넣기가 불가능 합니다.");
					return;
				}
				
				var moveRow = sheet2.DataMove(newRow , _oldRow, level);
				var pRow    = sheet2.GetParentRow(moveRow);
				var parentOrgCd = sheet2.GetCellValue(pRow , "orgCd");
				
				sheet2.SetCellValue(moveRow , "priorOrgCd", parentOrgCd );

				var children = sheet2.GetChildRows(moveRow).split("|") ;


				for(var i = 0; i < children.length; i++) {
					sheet2.SetCellValue(children[i] , "sStatus", "U" );
				}

				//var children = sheet2.GetChildRows(pRow).split("|") ;
				//var chLevel = 0;
				// 자동 SEQ 부여. 사용하지 않음. CBS. 2019.01.30 
				/*
				for(var i = 0; i < children.length; i++) {
					if(level == sheet2.GetRowLevel(children[i])) {
						sheet2.SetCellValue(children[i], "seq", chLevel);
						chLevel++;
					}
				}
				*/

				break;

			case "Delete":
				//sheet2.RowDelete();
				var sRow = sheet2.GetSelectRow();
				var selOrg = sheet2.GetCellValue(sRow, "orgCd"); // 삭제할 행의 조직코드
				var downOrg = sheet2.GetCellValue(sRow+1, "priorOrgCd"); // 삭제할 행의 바로 아래 행의 부모조직코드
				// 삭제할 조직의 자식조직이 존재하면 삭제 불가
				if(selOrg == downOrg) {
					alert("자식 행이 있으면 삭제가 불가능합니다.");
					return;
				} else {
					sheet2.SetCellValue(sRow, "sStatus", "D")
					sheet2.SetCellValue(sRow, "sDelete", "1")
				}
				
				break;
			case "Clear": //RemoveAll
				sheet2.RemoveAll();
				break;

			case "Download":

				sheet2.Down2Excel();

				break;
		}
	}
	
	// 드래그 행을 드랍위치에 추가하고 드래그 시트에서 삭제한다.
	function sheet2_OnDropEnd(FromSheet, FromRow, ToSheet, ToRow, X, Y, Type) {
		//드레그 한 행의 데이터를 json형태로 얻음
		var rowjson = FromSheet.GetRowData(FromRow);
		
		//드롭 지점의 레벨을 확인
		var lvl = ToSheet.GetRowLevel(ToRow);
		switch(Type) {
			case 2:
				ToRow = ToRow + 1;
				break;
			case 3 :
				ToRow += 1;
				lvl += 1;
				break;
		}
		//행 데이터 복사(트리임으로 레벨을 고려할 것)
		var moveRow = sheet2.DataMove(ToRow , FromRow, lvl);
		var pRow    = sheet2.GetParentRow(ToRow);
		var parentOrgCd = sheet2.GetCellValue(pRow , "orgCd");
		sheet2.SetCellValue(moveRow , "priorOrgCd", parentOrgCd );
		// sheet2.SetCellValue(ToRow , "sStatus", "U" );
		var children = sheet2.GetChildRows(moveRow).split("|") ;
		for(var i = 0; i < children.length; i++) {
			sheet2.SetCellValue(children[i] , "sStatus", "U" );
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			//파일 첨부 시작
			for(var i = 0; i < sheet1.RowCount(); i++) {

				if("${authPg}" == 'A'){
					if(sheet1.GetCellValue(i+1,"fileSeq") == ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(i+1,"fileSeq") != ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}
				}
			}

			//파일 첨부 끝
			sheetResize();


		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {alert(Msg);}
			//orgSchemeEdateCreate();
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			/*
			if ( sheet1.GetCellValue(NewRow, "sStatus") == "I" ) {
				doAction2("Clear");
				return;
			}
			*/

	        $("#searchSdate").val(sheet1.GetCellValue(NewRow, "sdate"));

	    	var sheet2EditYn = false;

	    	if( confirmYn && OldRow != NewRow ) {
	    		for( i = 1; i<=sheet2.LastRow(); i++ ) {
	    			if( sheet2.RowCount() != 0 && sheet2.GetCellValue(i, "sStatus") != "R" ) {
	    				sheet2EditYn = true;
	    				break;
	    			}
	    		}

	    		if( sheet2EditYn ) {
	    			if(confirm("<msg:txt mid='confirmOrgSchemeCreate' mdef='조직도를 생성 또는 수정 작업중 입니다.\n[확인] 을 선택하면 작업중인 조직도를 저장하지 않고 선택한 조직도로 새롭게 조회됩니다.\n[취소] 를 선택하면 현재 작업을 계속 하실수 있습니다.'/>") ) {
	    				doAction2("Search");
	    			}
	    			else {
	    				confirmYn = false;
	    				sheet1.SelectCell(OldRow, "orgChartNm");
	    				confirmYn = true;
	    			}
	    		} else {
	    			doAction2("Search");
	    		}
	    	}

	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if ( Row < sheet1.HeaderRows() ) return;

			if( sheet1.ColSaveName(Col) == "sDelete" ) {
				if ( sheet2.RowCount() == 0 ) return;

				//alert("해당 조직이력에 조직도가 존재하므로 삭제 할 수 없습니다.");
				alert("<msg:txt mid='110346' mdef='오른쪽의 조직도에서 해당 조직이력의 조직을 모두 삭제한 후 삭제가 가능합니다.'/>");
				sheet1.SetCellValue(Row, "sDelete", "0");
				return;
			}
			
			if(sheet1.ColSaveName(Col) == "btnFile"){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}
					fileMgrPopup(Row, Col);
				}	
			}	
		}catch(ex){alert("sheet1_OnClick Event Error : " + ex);}
	}

	// 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'fileMgrLayer'
			, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}'
			, parameters : {
				fileSeq : sheet1.GetCellValue(Row,"fileSeq"),
				fileInfo: getFileList(sheet1.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
			}
			, width : 740
			, height : 420
			, title : '파일 업로드'
			, trigger :[
				{
					name : 'fileMgrTrigger'
					, callback : function(result){
						addFileList(sheet1, Row, result); // 작업한 파일 목록 업데이트
						if(result.fileCheck == "exist"){
							sheet1.SetCellValue(Row, "btnFile", '<a class="basic">다운로드</a>');
							sheet1.SetCellValue(Row, "fileSeq", result.fileSeq);
						}else{
							sheet1.SetCellValue(Row, "btnFile", '<a class="basic">첨부</a>');
							sheet1.SetCellValue(Row, "fileSeq", "");
						}
					}
				}
			]
		});
        layerModal.show();
    }

    
    //파일첨부/다운로드 끝
	// 셀에 변경 됐을때 발생하는 이벤트
	function sheet1_OnChange(Row, Col, Value){
	  try{
	    if(sheet1.ColSaveName(Col) == "sdate"){

	        // 조직도이력의 입력이나 복사한 행을 다시 선택한 경우 복사해온 조직도를 입력 상태로 바꾸어 주고 시작일 셋팅
	        if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
	            for( i = 1; i<=sheet2.LastRow(); i++ ) {
	                sheet2.SetCellValue(i, "sdate", sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate"));
	                sheet2.SetCellValue(i, "sStatus", "I");
	            }
	        }
	        // *************************************************//
	    }
	  }catch(ex){alert("sheet1_OnChange Event Error : " + ex);}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet1", "torg103", "languageCd", "languageNm", "orgChartNm");
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
	
	// 셀에 변경 됐을때 발생하는 이벤트
	function sheet2_OnChange(Row, Col, Value){
		try{
			// 정렬 순서 변경			
			if(sheet2.ColSaveName(Col) == "seq"){
				if(_changeRow == Row) {
					_copyGubun = "orgMove";
					// 자동 SEQ 부여. 사용하지 않음. CBS. 2019.01.30 
					//orgSeqSort(Row, Value);
				}
			}


			if(sheet2.ColSaveName(Col) == "sDelete"){
				_copyGubun = "orgRemove";
				_changeRow = Row;
				// 자동 SEQ 부여. 사용하지 않음. CBS. 2019.01.30 
				//orgSeqSort(Row , Value);
			}
		}catch(ex){alert("sheet1_OnChange Event Error : " + ex);}
	}	

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet2.ColSaveName(Col) == "sDelete"){
				_changeRow = Row;
			}
			
			if(sheet2.ColSaveName(Col) == "subcontractCnt" && Row >= sheet2.HeaderRows()) {
				// 팝업띄우기
				if(!isPopup()) {return;}

				var url ="/View.do?cmd=viewOrgSchemeMgrSubConPopup";
				var args = new Array();
				gPRow = Row;
				args["authPg"] = "A";
				args["orgCd"] = sheet2.GetCellValue(Row, "orgCd");
				args["orgNm"] = sheet2.GetCellValue(Row, "orgNm");
				openPopup(url, args, 700, 500);
			}

		}catch(ex){alert("sheet1_OnClick Event Error : " + ex);}
	}
	
	function sheet2_OnBeforeCheck(Row, Col) {

		if(sheet2.ColSaveName(Col) == "sDelete") {
			if (sheet2.GetCellValue(Row, "sStatus") == "I") {
				_copyGubun = "orgInsRemove";
				sheet2.SetCellValue(Row, "orgCd" , "");
				// 자동 SEQ 부여. 사용하지 않음. CBS. 2019.01.30 
				//orgSeqSort(Row, sheet2.GetCellValue(Row, "seq"));
			}
		}
	}

	function sheet2_OnMouseDown(button, shift, x, y) {
		if(button == 2) {
			sheet2.SetSelectRow(sheet2.MouseRow());
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

	//  조직코드 조회
	function orgBasicPopup(Row){
	    try{
	    	if(!isPopup()) {return;}

			var args = new Array();
			args["chkVisualYn"] = "N";

			gPRow = Row;
			pGubun = "orgBasicPopup";

	     	<%--openPopup("/Popup.do?cmd=orgBasicPopup&authPg=${authPg}", args, "840","720");--%>
			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
				, parameters : args
				, width : 740
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							if(!result.length) return;
							sheet2.SetCellValue(gPRow, "orgCd",		result[0].orgCd);
							sheet2.SetCellValue(gPRow, "orgNm",		result[0].orgNm);
						}
					}
				]
			});
			layerModal.show();
	    } catch(ex){
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

function orgSeqSort(Row, Value) {
		
		if(_changeRow  == Row) {
			var changeValue = Value;
			var pRow = sheet2.GetParentRow(Row);
			var level = sheet2.GetRowLevel(Row);
			var orgCd = sheet2.GetCellValue(Row, "orgCd");
			var sStatus = sheet2.GetCellValue(Row, "sStatus");
			var children = sheet2.GetChildRows(pRow).split("|");
			var priorOrgCd = sheet2.GetCellValue(pRow, "orgCd");

			var idx = 1;
			
			var dupCnt = 0;
			for(var i = 0; i < children.length; i++) {
				
				if(level == sheet2.GetRowLevel(children[i])) {
					var status = "";
					var chSeq = sheet2.GetCellValue(children[i],"seq");
					var chOrgCd = sheet2.GetCellValue(children[i],"orgCd");
					var chOrgNm = sheet2.GetCellValue(children[i],"orgNm");
					if(_copyGubun != "orgRemove" && _copyGubun != "orgInsRemove") {
						if(orgCd != chOrgCd){
							if(idx >= changeValue && dupCnt == 0){
								dupCnt++;
								idx++;
							}
							sheet2.SetCellValue(children[i], "seq", idx);
							idx++;
						}
					} else {

						if (sheet2.GetCellValue(children[i], "sStatus") != "D" && sStatus != "R") {
							if (!gfn_isEmpty(sheet2.GetCellValue(children[i], "orgCd"))) {
								if (_copyGubun == "orgInsRemove") {
									sheet2.SetCellValue(children[i], "seq", idx - 1);
								} else {
									if (changeValue < parseInt(chSeq)) {
										sheet2.SetCellValue(children[i], "seq", idx );
									} else {
										sheet2.SetCellValue(children[i], "seq", idx);
									}
								}
							}
						} else if(sheet2.GetCellValue(children[i], "sStatus") != "D" && sStatus == "R") {
							sheet2.SetCellValue(children[i], "seq", idx);
						}
					}

				}
			}
		}
		sheet2.TreeChildSort(pRow ,"seq" , "ASC");
	}
	
	function gfn_isEmpty(val){
		var rst = false;
		if (val==undefined || val==null) return true;
		if(typeof val == "object"){
			var cnt = 0;
			for(var property in val){ cnt++ ;}
			if(cnt == 0) rst = true;
		} else if(typeof val == "string"){
			if(val === "") rst = true;
		} else if(typeof val == "number"){
		} else {
			if(val === "") rst = true;
		}
		return rst;
	}	
	
	// 조직이력 저장 후 EDATE 정리 프로시저
	function orgSchemeEdateCreate() {
		var sdate = $("#searchSdate").val();
		var result = ajaxCall("/OrgSchemeMgr.do?cmd=prcOrgCdSchemeEdateCreate","sdate="+sdate, false);
	}	
	
	// 직제 소팅을 위한 정렬 순서 생성, F_ORG_ORG_CHART_SORT 함수에서 SORT_SEQ 필드 참조
	function orgSchemeSortCreate() {
		var sdate = $("#searchSdate").val();
		var result = ajaxCall("/OrgSchemeMgr.do?cmd=prcOrgSchemeSortCreateCall","sdate="+sdate, false);
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "orgBasicPopup"){
            if( popupGubun == "orgNm" ) {
	        	sheet2.SetCellValue(gPRow, "orgCd",		rv["orgCd"]);
	        	sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
            } else if( popupGubun == "priorOrgNmChange" ) {
	        	sheet2.SetCellValue(gPRow, "priorOrgCdChange",		rv["orgCd"]);
	        	sheet2.SetCellValue(gPRow, "priorOrgNmChange",		rv["orgNm"]);
            }
            sheet2.SetFocusAfterProcess(0);
        }
        
        if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
        }        
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
        <input type="hidden" id="searchSdate" name="searchSdate">
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="40%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt1" class="txt"><tit:txt mid='orgSchemeHis' mdef='조직도이력'/>
					</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
						<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction1('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt2" class="txt"><tit:txt mid='112713' mdef='조직도'/>&nbsp;
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>
						<font color="blue">※ 오른쪽 마우스를 이용하여 편집 할 수 있습니다.</font>
					</li>
					<li class="btn">
						<!--<btn:a href="javascript:doAction2('sortOrgLine')" 	css="button authA" mid='autoApplyOrder' mdef="직제순서자동반영"/>-->
						<!--  <btn:a href="javascript:doAction2('ChangeOrgInit')" 	css="basic authA" mid='clear' mdef="초기화"/>
						<btn:a href="javascript:doAction2('ChangeOrgSet')" 	css="basic authA" mid='110947' mdef="변경조직반영"/> -->
						<!--	<btn:a href="javascript:doAction2('Insert')" css="basic authA" mid='insert' mdef="입력"/>		-->
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
						<btn:a href="javascript:doAction2('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction2('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
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