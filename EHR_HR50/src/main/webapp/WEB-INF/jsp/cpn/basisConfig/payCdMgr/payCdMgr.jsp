<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='payCdMgr' mdef='급여코드관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
             {Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
             {Header:"<sht:txt mid='resultV2' mdef='결과'/>",       Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
             {Header:"<sht:txt mid='payActionCdV4' mdef='급여코드'/>",						Type:"Text",      Hidden:0,  Width:50,   Align:"Left",    ColMerge:0,   SaveName:"payCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
             {Header:"<sht:txt mid='payNmV1' mdef='급여명'/>",						Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"payNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },

             {Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
 			 {Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},

             {Header:"<sht:txt mid='businessPlaceCdV3' mdef='급여사업장'/>",					Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"businessPlaceCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1},
             {Header:"<sht:txt mid='payCd' mdef='급여구분'/>",						Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"runType",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='mmV1' mdef='지급월'/>",						Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"paymentMm",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='incomeAnnualPaymentYmd' mdef='지급일자'/>",						Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"paymentDd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
             {Header:"<sht:txt mid='sepBonYn' mdef='퇴직상여\n포함여부'/>",				Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sepBonYn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
             {Header:"<sht:txt mid='bpCalYn' mdef='고용보험\n포함여부'/>",				Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"bpCalYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
             {Header:"<sht:txt mid='elementSetCdV1' mdef='계산대상\n항목그룹'/>",			Type:"Combo",     Hidden:0,  Width:120,   Align:"Left",  ColMerge:0,   SaveName:"elementSetCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='sepPayCd' mdef='퇴직급여\n코드맵핑'/>",				Type:"Combo",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sepPayCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='searchSeqV4' mdef='검색설명코드'/>",					Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"searchSeq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='searchSeqNm' mdef='지급대상자'/>",						Type:"PopupEdit", Hidden:0,  Width:230,  Align:"Left",    ColMerge:0,   SaveName:"searchSeqNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='bonRate' mdef='상여지급율'/>",						Type:"Float",     Hidden:1,  Width:65,   Align:"Right",   ColMerge:0,   SaveName:"bonRate",       KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
             {Header:"<sht:txt mid='accountType' mdef='계좌구분'/>",						Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"accountType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='currencyCd' mdef='통화단위'/>",						Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='manDedYn' mdef='인적공제\n(세금계산시)'/>",			Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"manDedYn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
             {Header:"<sht:txt mid='spcDedYn' mdef='연금/특별공제\n(세금계산시)'/>",		Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"spcDedYn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
             {Header:"<sht:txt mid='group1' mdef='그룹1'/>",						Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"group1",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
             {Header:"<sht:txt mid='group2' mdef='그룹2'/>",						Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"group2",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
             {Header:"<sht:txt mid='group3' mdef='그룹3'/>",						Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"group3",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
             {Header:"<sht:txt mid='group4' mdef='그룹4'/>",						Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"group4",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
             {Header:"<sht:txt mid='group5' mdef='정산여부'/>",						Type:"Combo",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"group5",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		     ];

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4);

		//소속구분항목(급여사업장)
		var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgMapItemBpCdList",false).codeList, "");
		sheet1.SetColProperty("businessPlaceCd",      {ComboText:"전체|"+businessPlaceCd[0], ComboCode:"|"+businessPlaceCd[1]} );
		//급여구분
        var payTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00001"), "");
        sheet1.SetColProperty("runType",            {ComboText:"|"+payTypeList[0], ComboCode:"|"+payTypeList[1]} );
        //계좌구분
        var accountTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00180"), "");
        sheet1.SetColProperty("accountType",            {ComboText:"|"+accountTypeList[0], ComboCode:"|"+accountTypeList[1]} );
        //통화단위
        var currencyCdList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), "");
        sheet1.SetColProperty("currencyCd",            {ComboText:"|"+currencyCdList[0], ComboCode:"|"+currencyCdList[1]} );

        // 퇴직급여 코드매핑
        var sepPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "");
        sheet1.SetColProperty("sepPayCd", {ComboText:"|"+sepPayCdList[0], ComboCode:"|"+sepPayCdList[1]} );

        //지급일자
		sheet1.SetColProperty("paymentDd", {ComboText:"01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31",
			                                ComboCode:"01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31"} );
		//퇴직상여\n포함여부
		sheet1.SetColProperty("sepBonYn", {ComboText:"YES|NO", ComboCode:"Y|N"} );
		//고용보험\n포함여부
		sheet1.SetColProperty("bpCalYn", {ComboText:"YES|NO", ComboCode:"Y|N"} );
	    //항목그룹\n코드
		var elementSetCdList  = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnElementSetCdList",false).codeList, "");
	    sheet1.SetColProperty("elementSetCd", {ComboText:"|"+elementSetCdList[0], ComboCode:"|"+elementSetCdList[1]} );
		//인적공제\n(세금계산시)
	    sheet1.SetColProperty("manDedYn", {ComboText:"YES|NO", ComboCode:"Y|N"} );
		//인적공제\n(세금계산시)
	    sheet1.SetColProperty("spcDedYn", {ComboText:"YES|NO", ComboCode:"Y|N"} );
		//지급월
	    sheet1.SetColProperty("paymentMm", {ComboText:"당월|익월", ComboCode:"thatM|nextM"} );

		//정산여부
	    sheet1.SetColProperty("group5", {ComboText:"YES|NO", ComboCode:"Y|N"} );
	    
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PayCdMgr.do?cmd=getPayCdMgrList", $("#sheet1Form").serialize() ); break;
		case "Save":
				if(!dupChk(sheet1,"payCd", false, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/PayCdMgr.do?cmd=savePayCdMgr", $("#sheet1Form").serialize()); break;
		case "Insert":
				sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":
				var Row = sheet1.DataCopy();
				sheet1.SetCellValue(Row, "languageCd", "" );
				sheet1.SetCellValue(Row, "languageNm", "" );
				break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
        		var downcol = makeHiddenSkipCol(sheet1);
        		var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}


// 	Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{

		  var colName = sheet1.ColSaveName(Col);
		  // var args    = new Array();
		  //
		  // args["searchSeq"]   = sheet1.GetCellValue(Row, "searchSeq");
          // args["searchDesc"]  = sheet1.GetCellValue(Row, "searchSeqNm");
		  //
		  // var rv = null;

		  if(colName == "searchSeqNm") {
			  let layerModal = new window.top.document.LayerModal({
				  id : 'pwrSrchMgrLayer'
				  , url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R'
				  , parameters : {
					  searchSeq : sheet1.GetCellValue(Row, "searchSeq")
					  , searchDesc : sheet1.GetCellValue(Row, "searchSeqNm")
				  }
				  , width : 1100
				  , height : 520
				  , title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>'
				  , trigger :[
					  {
						  name : 'pwrTrigger'
						  , callback : function(result){
							  sheet1.SetCellValue(Row, "searchSeq",   result.searchSeq);
							  sheet1.SetCellValue(Row, "searchSeqNm", result.searchDesc);
						  }
					  }
				  ]
			  });
			  layerModal.show();



			  <%--if(!isPopup()) {return;}--%>
			  <%--gPRow = Row;--%>
			  <%--pGubun = "pwrSrchMgrPopup";--%>
			  <%--var rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup&authPg=${authPg}", args, "1100","520");--%>
              /*
			  if(rv!=null){
                  sheet1.SetCellValue(Row, "searchSeq",   rv["searchSeq"] );
                  sheet1.SetCellValue(Row, "searchSeqNm", rv["searchDesc"] );
              }
              */
		  }else if(colName == "languageNm"){
        	  lanuagePopup(Row, "sheet1", "tcpn051", "languageCd", "languageNm", "payNm");
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

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "pwrSrchMgrPopup"){
            sheet1.SetCellValue(gPRow, "searchSeq",   rv["searchSeq"] );
            sheet1.SetCellValue(gPRow, "searchSeqNm", rv["searchDesc"] );
	    }
	}

	/**
     * 상세내역 window open event
     */
//     function detailPopup(url,args,width,height){
//         window.showModalDialog(url, args, "dialogHeight="+height+"px; dialogWidth="+width+"px; scroll=no; status=no; help=no; center=yes");
//     }
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='payCdMgr' mdef='급여코드관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Search')" css="button" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction('Down2Excel')"   css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
