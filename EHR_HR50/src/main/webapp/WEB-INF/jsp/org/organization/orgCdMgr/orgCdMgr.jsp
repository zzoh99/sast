<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchBaseDate").datepicker2();
		//$("#searchBaseDate").val("<%//=DateUtil.getCurrentDay()%>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='orgSchemeUseYn' mdef='현조직도\n사용여부'/>", 	Type:"CheckBox",  Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgSchemeUseYn",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1,	TrueValue:"1", FalseValue:"0" },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",			Type:"Text",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgCd",         	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",				Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
            {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>", 			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",         	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 , EndDateCol: "edate" },
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>", 			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",         	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , StartDateCol: "sdate"},
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
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var locationCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION
		sheet1.SetColProperty("locationCd", 		{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );	//LOCATION


		$("#searchVisualYn").html("<option value=''><tit:txt mid='112598' mdef='사용안함'/></option>"); // 보여주기여부
		$("#searchVisualYn").change(function(){
			doAction1("Search");
		});


		$("#searchOrgCd,#searchOrgNm,#searchBaseDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function getCommonCodeList() {
		var orgType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20010", $("#searchBaseDate").val()), "");	//조직유형
		var inoutType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20050", $("#searchBaseDate").val()), "");	//내외구분
		var objectType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20030", $("#searchBaseDate").val()), "");	//조직구분
		sheet1.SetColProperty("orgType", 			{ComboText:"|"+orgType[0], ComboCode:"|"+orgType[1]} );	//조직유형
		sheet1.SetColProperty("inoutType", 			{ComboText:"|"+inoutType[0], ComboCode:"|"+inoutType[1]} );	//내외구분
		sheet1.SetColProperty("objectType", 		{ComboText:"|"+objectType[0], ComboCode:"|"+objectType[1]} );	//조직구분
	}

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
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/OrgCdMgr.do?cmd=getOrgCdMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			if (!chkInVal(sheet1)) {break;}
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

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 	if (Msg != "") { alert(Msg); }
		  sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
/*
	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnClick(Row, Col, Value){
		alert("onclick");
		try {
		    if( sheet1.ColSaveName(Col) == "sDelete" ) {
		    	alert(sheet1.GetCellEditable(Row,"sDelete")+"=="+sheet1.GetCellValue(Row,"sStatus")+"===="+Row);
		        if( sheet1.GetCellEditable(Row,"sDelete") == false && sheet1.GetCellValue(Row,"sStatus") != "I" ) {
		            alert("<msg:txt mid='alertNotDelOrgCd' mdef='조직에 해당하는 사원이 존재 합니다. 삭제할 수 없습니다.'/>");

		            return;
		        } else {
		            sheet1.SetCellEditable(Row,"sDelete",true);
		        }
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
*/
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
			  //var rv = openPopup("/Popup.do?cmd=commonCodePopup&authPg=${authPg}", args, "740","520");
			  commonCodePopup(Row, Col);
		  }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

    // 근무지역 팝입
    function commonCodePopup(Row, Col) {
        var authPgTemp="${authPg}";
        let layerModal = new window.top.document.LayerModal({
              id : 'commonCodeLayer'
            , url : '/CommonCodeLayer.do?cmd=viewCommonCodeLayer&authPg=${authPg}'
            , parameters : {
            	grpCd : "H90202"
              }
            , width : 740
            , height : 520
            , title : '코드검색'
            , trigger :[
                {
                      name : 'commonCodeTrigger'
                    , callback : function(result){
                        sheet1.SetCellValue(gPRow, "workAreaCd", result.code);
                        sheet1.SetCellValue(gPRow, "workAreaNm", result.codeNm);
                    }
                }
            ]
        });
        layerModal.show();
    }

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "workAreaPop"){
        	sheet1.SetCellValue(gPRow, "workAreaCd", rv["code"]);
        	sheet1.SetCellValue(gPRow, "workAreaNm", rv["codeNm"]);
        }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
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

						<td>  <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>  </td>
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
							<li id="txt" class="txt"><tit:txt mid='orgCdMgr' mdef='조직코드관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
