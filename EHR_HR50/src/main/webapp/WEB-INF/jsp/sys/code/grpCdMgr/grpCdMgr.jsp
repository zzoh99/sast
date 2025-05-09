
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		sheet1.SetDataLinkMouse("detail", 1);

		var initdata = {};
		initdata.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0},
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹\n코드'/>",		Type:"Text",		Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"grcodeCd",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='codeNm' mdef='코드명'/>",			Type:"Text",		Hidden:0,	Width:100,		Align:"Left",	ColMerge:0,	SaveName:"grcodeNm",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500,	MultiLineText:1},

			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},

			{Header:"<sht:txt mid='grcodeFullNm' mdef='코드설명'/>",		Type:"Text",		Hidden:0,	Width:200,		Align:"Left",	ColMerge:0,	SaveName:"grcodeFullNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500,	MultiLineText:1	},
			{Header:"<sht:txt mid='grcodeEngNm' mdef='코드영문명'/>",		Type:"Text",		Hidden:1,	Width:0,		Align:"Left",	ColMerge:0,	SaveName:"grcodeEngNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500,	MultiLineText:1	},
			{Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",	Type:"Combo",		Hidden:0,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"bizCd", KeyField:0, ComboDisabled:"||||||||||||15|",	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500},
			{Header:"<sht:txt mid='commonYn' mdef='참조여부'/>",		Type:"Combo",		Hidden:1,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"commonYn",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Combo",		Hidden:0,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"type",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='subCnt' mdef='세부\n코드수'/>",	Type:"Text",		Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"subCnt",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1}
		];
// 		sheetSplice(initdata.Cols,5,	"${localeCd2}",	"코드명",	true);
		IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
		//구분
		sheet1.SetColProperty("type", {ComboText:"<sht:txt mid='cbGrpCdMgrType' mdef='사용자코드|시스템코드'/>", ComboCode:"C|N"} );

		//참조여부
		sheet1.SetColProperty("commonYn", {ComboText:"Y|N", ComboCode:"Y|N"} );

		//업무구분
		var menuList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getMainMuPrgMainMenuList","",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("bizCd", 	{ComboText:"|" + menuList[0], ComboCode:"|"+menuList[1]} );


		$("#srchBizCd").html(menuList[2]);

		$("#srchBizCd").change(function(){
			doAction1("Search");
		});


		initdata = {};
		initdata.Cfg = {FrozenCol:6, SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"grcodeCd",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='grcodeNmV1' mdef='그룹코드명'/>",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"grcodeNm",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500, MultiLineText:1 },
			{Header:"<sht:txt mid='code_V299' mdef='세부\n코드'/>",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:1,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
			{Header:"<sht:txt mid='codeNmV2' mdef='세부코드명'/>",		Type:"Text",		Hidden:0,	Width:135,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='codeIdx' mdef='코드순번'/>",		Type:"Text",		Hidden:1,	Width:0, Align:"Center",	ColMerge:0,	SaveName:"codeIdx",	UpdateEdit:0, InsertEdit:0},
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",			Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,		CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"<sht:txt mid='visualYn' mdef='보여\n주기'/>",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='useYn' mdef='사용\n유무'/>",		Type:"Combo",		Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='codeFullNm' mdef='FULL명'/>",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"codeFullNm",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='codeEngNm' mdef='영문명'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"codeEngNm",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='grcodeFullNm' mdef='코드설명'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='note1' mdef='비고1'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note1",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1,EditLen:500 },
			{Header:"<sht:txt mid='note2' mdef='비고2'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note2",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1, EditLen:500 },
			{Header:"<sht:txt mid='note3' mdef='비고3'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note3",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1,EditLen:500 },
			{Header:"<sht:txt mid='note4' mdef='비고4'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note4",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	MultiLineText:1,EditLen:500 },
			{Header:"<sht:txt mid='numNote' mdef='비고(숫자형)'/>",	Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"numNote",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일'/>",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, EndDateCol: "eYmd" },
			{Header:"<sht:txt mid='eYmd' mdef='종료일'/>",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol: "sYmd" }
		];
// 		sheetSplice(initdata.Cols,7,	"${localeCd2}",	"세부코드명",	true);
		IBS_InitSheet(sheet2, initdata);sheet2.SetCountPosition(4);
			sheet2.SetColProperty("visualYn", {ComboText:"<sht:txt mid='yesOrNo|No' mdef='예|아니오'/>", ComboCode:"Y|N"} );
			sheet2.SetColProperty("useYn", {ComboText:"<sht:txt mid='useV1|useV2' mdef='사용|사용안함'/>", ComboCode:"Y|N"} );
			sheet2.SetFocusAfterProcess(0);
 		$(window).smartresize(sheetResize);
		sheetInit();sheetResize();

		$("#srchGrpCd,#srchGrpCodeNm,#srchWithDetailCodeNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#srchDetailCode,#srchDetailCodeNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction2("Search"); $(this).focus(); }
		});

		
		$("#srchType").change(function(){
			doAction1("Search");
		});

		$("#srchUseYn").change(function(){
			doAction2("Search");
		});

		//다른 페이지에서 호출할 경우 권한 및 화면 셋팅
		if ("${result.mainMenuCd}" != 11) {
			if ('${result.yjungsan}' === 'Y') {
				$("#srchBizCd").val("연말정산용업무구분코드") ;	//연말정산 업무 구분
			} else{
				$("#srchBizCd").val("${result.mainMenuCd}") ;	//업무 구분
			}
			//$("#srchBizCd").attr("disabled",true);
			sheet1.SetEditable(false);
			sheet2.SetColHidden("sDelete", true);

			$(".basic").each(function(i,v){v.id == "Btn1" ? $(v).hide() : "";});
		}

		//읽기 권한일 때 sheet edit false
		if ("${authPg}" === "R") {
			sheet1.SetEditable(false);
			sheet2.SetEditable(false);
		}

		//doAction1("Search");
	});


	function chkInVal() {
		// 시작일자와 종료일자 체크
		for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
			if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U") {
				if (sheet2.GetCellValue(i, "eYmd") != null && sheet2.GetCellValue(i, "eYmd") != "") {
					var sdate = sheet2.GetCellValue(i, "sYmd");
					var edate = sheet2.GetCellValue(i, "eYmd");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet2.SelectCell(i, "eYmd");
						return false;
					}
				}
			}
		}
		return true;
	}


	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			let params = $("#sheet1Form").serialize();
			if ('${result.yjungsan}' === 'Y') {
				params += "&srchBizCd=15";
			}

			sheet1.DoSearch( "${ctx}/GrpCdMgr.do?cmd=getGrpCdMgrList", params);
			break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
			    if(!dupChk(sheet1,"grcodeCd", true, true)){break;}
			}
// 			sheetLangSave(sheet1,	"tsys001",	"grcodeCd","grcodeNm"	);
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/GrpCdMgr.do?cmd=saveGrpCdMgr", $("#sheet1Form").serialize() );
		    break;
		case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
		case "Copy":		sheet1.DataCopy();break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);

							break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			if("${result.mainMenuCd}" != 11){
				if(sheet1.GetCellValue(sheet1.GetSelectRow(), "type") == "C"
				&& sheet1.GetCellValue(sheet1.GetSelectRow(), "bizCd") !== "15"){
					sheet2.SetEditable(true);
					$(".basic").each(function(i,v){
						v.id == "Btn2" ? $(v).show() : "";
					});
				} else {
					sheet2.SetEditable(false);
					$(".basic").each(function(i,v){v.id == "Btn2" ? $(v).hide() : "";});
				}

			} else if(sheet1.GetCellValue(sheet1.GetSelectRow(), "bizCd") === "15") {
				sheet2.SetEditable(false);
			}

			sheet2.DoSearch( "${ctx}/GrpCdMgr.do?cmd=getGrpCdMgrDetailList", $("#sheet2Form").serialize(), "1" );
			break;
		case "Save":
			var message = '';

			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}

			if(sheet2.FindStatusRow("I") != ""){
			    if(!dupChk(sheet2,"code|sYmd", true, true)){break;}
				//날짜간격 체크 ()

			  	var saveJson = sheet2.GetSaveJson({AllSave: true}).data;
				//code별 데이터를  그룹핑 후 그룹된 데이터 각각을 시작일자로 정렬
			  	var codeJson = groupBy(saveJson, 'code');
			  	codeJson = Object.keys(codeJson).reduce((a, c) => { a[c] = codeJson[c].sort((b1, b2) => b1.sYmd > b2.sYmd ? 1:-1); return a; }, {});
				var dvm = [];
				var dateValid = Object.keys(codeJson).reduce((a, c) => {
									var items = codeJson[c];
									var prev = null;
									var valid = items.reduce((aa, cc) => {
										var v = true;
										if (!prev) prev = cc;
										else v = !(prev.sYmd <= cc.eYmd && cc.sYmd <= prev.eYmd);
										return aa && v; 
									}, true);
									if (!valid) dvm.push(c);
									return valid && a;
								}, true);

				//valid 실패했을 경우
				if (!dateValid) {
					message = '[' + dvm.join(',') + '] 코드의 시작/종료일이 겹치는 일자가 존재합니다.';
				}
			}
			if (message == '') {
				IBS_SaveName(document.sheet1Form,sheet2);
	            sheet2.DoSave("${ctx}/GrpCdMgr.do?cmd=saveGrpCdMgrDetail", $("#sheet1Form").serialize()+"&"+$("#sheet2Form").serialize() );
			} else {
				alert(message);
			}
            break;
		case "Insert":
			var row = sheet2.DataInsert(0);
			var grcodeCd = sheet1.GetRowData(sheet1.GetSelectRow()).grcodeCd;
			sheet2.SetRowData(row, { grcodeCd });
			sheet2.SelectCell(row, 2); 
			break;
		case "Copy":
			var row = sheet2.DataCopy();
			sheet2.SetCellValue(row, "codeIdx", "");
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet2);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet2.Down2Excel(param);

							break;
		}
	}


	// LEFT 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			sheetResize();
			sheet1.LastRow() == 0 ?
			doAction2("Clear") : "";
			sheet1.SelectCell(1, "sStatus");

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// RIGHT 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }

		if(sheet1.GetCellValue(sheet1.GetSelectRow(),"grcodeCd") != -1) {
			$("#selectGroupCode").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"grcodeCd"));
		} else {
			$("#selectGroupCode").val("");
		}
		doAction2("Search");
	}
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		selectSheet = sheet1;
		const rowData = sheet1.GetRowData(OldRow);
		const bizCd = rowData.bizCd;
		if (bizCd === '15') {
			sheet1.SetRowEditable(OldRow, 0);
		}

		if( OldRow != NewRow ) {
			$("#selectGroupCode").val(sheet1.GetCellValue(NewRow, "grcodeCd"));
			doAction2("Search");
		}
	}

	// LEFT 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// RIGHT 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} if( Number(Code) > 0){doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		selectSheet = sheet2;
	}

	function sheet1_OnPopupClick(Row, Col){
		var	args	= new Array();
		try{
			if(Row > 0 &&  sheet1.ColSaveName(Col) == "languageNm" ){
				if(!isPopup()) {return;}

					args["openSheet"] 	= "sheet1";        //Sheet 명
					args["keyLevel"]	= "tsys001";       //레별
					args["keyId"]		= "languageCd";    //
					args["keyNm"]		= "languageNm";    //
					args["keyText"]		= "grcodeNm";      //항상 변경된다


					openPopup("/DictMgr.do?cmd=viewDict&is=_popup", args,  "1000","650", function(returnValue) {
						eval(args["openSheet"]).SetCellValue(Row, args["keyId"], returnValue["keyId"]);

						var chkData = { "keyLevel": args["keyLevel"], "languageCd": returnValue["keyId"] };
						var dtWord = ajaxCall( "${ctx}/LangId.do?cmd=getLangCdTword",chkData,false);
						eval(args["openSheet"]).SetCellValue(Row, args["keyNm"], dtWord.map.seqNumTword);
					});
		    }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function sheet1_OnChange(Row, Col, Value){
		try {
			if ( sheet1.ColSaveName(Col) == "languageNm" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd", "");
				}
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet2_OnPopupClick(Row, Col){
		var	args	= new Array();
		try{
			if(Row > 0 &&  sheet2.ColSaveName(Col) == "languageNm" ){
				if(!isPopup()) {return;}

					args["openSheet"] 	= "sheet2";        //Sheet 명
					args["keyLevel"]	= "tsys005";       //레별
					args["keyId"]		= "languageCd";    //
					args["keyNm"]		= "languageNm";    //
					args["keyText"]		= "codeNm";      //항상 변경된다


					openPopup("/DictMgr.do?cmd=viewDict&is=_popup", args,  "1000","650", function(returnValue) {
					eval(args["openSheet"]).SetCellValue(Row, args["keyId"], returnValue["keyId"]);

					var chkData = { "keyLevel": args["keyLevel"], "languageCd": returnValue["keyId"] };
					var dtWord = ajaxCall( "${ctx}/LangId.do?cmd=getLangCdTword",chkData,false);
					eval(args["openSheet"]).SetCellValue(Row, args["keyNm"], dtWord.map.seqNumTword);
					});
			    }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function sheet2_OnChange(Row, Col, Value){
		try {
			if ( sheet2.ColSaveName(Col) == "languageNm" ){
				if ( sheet2.GetCellValue( Row, Col ) == "" ){
					sheet2.SetCellValue( Row, "languageCd", "");
				}
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
	<div class="sheet_search sheet_search_s outer">
		<div>
		<table>
			<tr>
				<th><sch:txt mid='grpCd' mdef='그룹코드'/></th>
				<td>
					<input id="srchGrpCd" name="srchGrpCd" type="text" class="text" />
				</td>
				<th><sch:txt mid='grpCdNm' mdef='그룹코드명'/></th>
				<td>
					<input id="srchGrpCodeNm" name="srchGrpCodeNm" type="text" class="text" />
				</td>
				<th><sch:txt mid='withDetailCdNm' mdef='포함세부코드명'/></th>
				<td>
					<input id="srchWithDetailCodeNm" name="srchWithDetailCodeNm" type="text" class="text" />
				</td>
				<th><sch:txt mid='bizCdV1' mdef='구분'/></th>
				<td>
					<select id="srchType" name="srchType" >
						<option value="" selected><sch:txt mid='all' mdef='전체'/> </option>
						<option value="C"><sch:txt mid='grpCdType1' mdef='사용자코드'/></option>
						<option value="N"><sch:txt mid='grpCdType2' mdef='시스템코드'/></option>
					</select>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" id="srchBtn" mid="110697" mdef="조회" css="btn dark"/>
				</td>
			</tr>
		</table>
		</div>
	</div>
		</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='grpCd' mdef='그룹코드'/>		 </li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Down2Excel');" id="downBtn" mid="110698" mdef="다운로드" css="btn outline-gray authR"/>
						<c:if test="${result.mainMenuCd eq '11'}">
							<btn:a href="javascript:doAction1('Copy');" id="Btn1" mid="110696" mdef="복사" css="btn outline-gray authA"/>
							<btn:a href="javascript:doAction1('Insert');" id="Btn1" mid="110700" mdef="입력" css="btn outline-gray authA"/>
							<btn:a href="javascript:doAction1('Save');" id="Btn1" mid="110708" mdef="저장" css="btn filled authA"/>
						</c:if>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "30%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td>
					<form id="sheet2Form" name="sheet2Form">
					<input id="selectGroupCode" name="selectGroupCode" type="hidden" />
					<div class="sheet_search sheet_search_s inner">
						<table>
							<tr>
								<th><sch:txt mid='112330' mdef='세부코드'/></th>
								<td>
									<input id="srchDetailCode" name="srchDetailCode" type="text" class="text" />
								</td>
								<th><sch:txt mid='detailCdNm' mdef='세부코드명'/></th>
								<td>
									<input id="srchDetailCodeNm" name="srchDetailCodeNm" type="text" class="text" />
								</td>
								<th><sch:txt mid='useYn' mdef='사용유무'/></th>
								<td>
									<select id="srchUseYn" name="srchUseYn" >
										<option value="" selected><sch:txt mid='all' mdef='전체'/> </option>
										<option value="Y"><sch:txt mid='useY' mdef='사용'/></option>
										<option value="N"><sch:txt mid='useN' mdef='사용안함'/></option>
									</select>
								</td>
								<td>
									<btn:a href="javascript:doAction2('Search');" id="srchBtn" mid="110697" mdef="조회" css="btn dark"/>
								</td>
							</tr>
						</table>
					</div>
					</form>		
							
					<div class="sheet_title inner">
					<ul>
						<li class="txt"><tit:txt mid='103832' mdef='세부코드 '/></li>
						<li class="btn">
							<btn:a href="javascript:doAction2('Down2Excel');" id="downBtn" mid="110698" mdef="다운로드" css="btn outline-gray authR"/>
							<btn:a href="javascript:doAction2('Copy');" id="Btn2" mid="110696" mdef="복사" css="btn outline-gray authA"/>
							<btn:a href="javascript:doAction2('Insert');" id="Btn2" mid="110700" mdef="입력" css="btn outline-gray authA"/>
							<btn:a href="javascript:doAction2('Save');" id="Btn2" mid="110708" mdef="저장" css="btn filled authA"/>
						</li>
					</ul>
					</div>
					
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "70%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>
