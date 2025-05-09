<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
    		{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sdateV22' mdef='조직개편일'/>",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",	Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='changeYnV1' mdef='확정여부'/>",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"changeYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='changeJobV1' mdef='개편작업'/>",		Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnChange",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='endConfOrg' mdef='마감'/>",		Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"endConfOrg",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='bigoV2' mdef='비고'/>", 			Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			
	var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",        	Type:"Date",    Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",          KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
   			{Header:"가발령구분",										Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordGubun",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },		
			{Header:"<sht:txt mid='ordType' mdef='발령구분'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ordDetailCd' mdef='발령'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ordDetailReasonV1' mdef='발령사유'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ordYmd' mdef='발령일자'/>",			Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applySeq' mdef='적용순서'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='useYn' mdef='사용\n유무'/>",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"useYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2, TrueValue:"Y", FalseValue:"N" }			
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var ordTypeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdList",false).codeList, "");	//발령종류
		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList",false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//발령종류
		var ordReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComCodeNoteList&searchGrcodeCd=H40110",false).codeList, ""); //발령사유

		sheet2.SetColProperty("ordTypeCd", 		{ComboText:"|"+ordTypeCd[0], ComboCode:"|"+ordTypeCd[1]} );
		sheet2.SetColProperty("ordDetailCd",	{ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		sheet2.SetColProperty("ordReasonCd",	{ComboText:"|"+ordReasonCd[0], ComboCode:"|"+ordReasonCd[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#srchSYmd").val();
		let baseEYmd = $("#srchEYmd").val();

		var ordGubunCd  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40400", baseSYmd, baseEYmd), "");
		sheet2.SetColProperty("ordGubun",          {ComboText:"|"+ordGubunCd[0], ComboCode:"|"+ordGubunCd[1]} );
	}

	$(function() {

		$("#srchSYmd").datepicker2({ymdonly:true, startdate:"srchEYmd"});
		$("#srchEYmd").datepicker2({ymdonly:true, enddate:"srchSYmd"});
		$("#srchSYmd, #srchEYmd").bind("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#srchChangeYn").bind("change", function(event) {
			doAction1("Search");
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if (!chkInVal()) {break;}
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getOrgChangeSchemeMgrList", $("#srchFrm").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet1,"sdate|orgChartNm", true, true)){break;}

				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveOrgChangeSchemeMgr", $("#srchFrm").serialize() ); break;
			case "Insert":
				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "sdate", "${curSysYyyyMMdd}");
				sheet1.SetCellValue(Row,"orgChartNm","${ssnEnterNm} 조직도");
				sheet1.SetCellValue(Row, "btnChange", '<btn:a css="basic" mid='changeOrg' mdef="조직개편"/>');
				break;
			case "Down2Excel":
				sheet1.Down2Excel();
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
				sheet1.SetCellValue(i, "btnChange", '<btn:a css="basic" mid='changeOrg' mdef="조직개편"/>');
				var editable = 0;
				if(sheet1.GetCellValue(i, "changeYn") == 'Y') {
					sheet1.SetCellValue(i, "endConfOrg", '<btn:a css="basic" mid='appCloseV1' mdef="마감취소"/>');
				} else if(sheet1.GetCellValue(i, "changeYn") == 'N') {
					sheet1.SetCellValue(i, "endConfOrg", '<btn:a css="basic" mid='appClose' mdef="마감"/>');
					editable = 1;
				}
				// 마감 이후에는 다른 상태 변경 불가
				//sheet1.Reset();
				sheet1.SetCellEditable(i, "sDelete", editable);
				sheet1.SetCellEditable(i, "memo", editable);
				sheet1.SetCellValue(i, "sStatus", 'R');
			}
			
			$("#searchSdate").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate"));

			sheetResize();
			
			doAction2("Search");
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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

	// 저장 후 메시지
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if ( NewRow >= sheet1.HeaderRows() && OldRow != NewRow ) {
				$("#searchSdate").val(sheet1.GetCellValue(NewRow, "sdate"));
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row != 0) {
				if(sheet1.ColSaveName(Col) == "btnChange" && sheet1.GetCellValue(Row,"btnChange") != "") {
					if(sheet1.GetCellValue(Row, "sStatus") != "I") {
						if(!isPopup()) {return;}
	
						gPRow = Row;
						pGubun = "changeOrgPopup";
	
						var authPgTemp="${authPg}";
	
						var args = new Array();
						args["sdate"] = sheet1.GetCellValue(Row, "sdate");

						//var rv = openPopup("/Popup.do?cmd=viewIborgPopup&authPg=${authPg}", args, "1000","700");

						//var rv = openPopup("/OrgChangeSchemeMgr.do?cmd=viewSchemeSimulationPopup&authPg=${authPg}", args, "1000","700");

						let layerModal = new window.top.document.LayerModal({
							id : 'schemeSimulationLayer'
							, url : "/OrgChangeSchemeMgr.do?cmd=viewSchemeSimulationLayer&authPg=${authPg}"
							, parameters : args
							, width : 1200
							, height : 1000
							, title : '조직개편 시뮬레이션'
							, trigger :[
								{
									name : 'schemeSimulationLayerTrigger'
									, callback : function(result){
									}
								}
							]
						});
						layerModal.show();
					} else {
						alert("현재 입력상태인 조직개편입니다. 저장 후 작업이 가능합니다.");
					}
				} else if(sheet1.ColSaveName(Col) == "endConfOrg" && sheet1.GetCellValue(Row,"endConfOrg") != "") {
					var args = "";
					var editInf = {};
					args += "sdate=" + sheet1.GetCellValue(Row, "sdate");
					if(sheet1.GetCellValue(Row, "changeYn") == 'Y') {
						args += "&gubun=C";
					} else if(sheet1.GetCellValue(Row, "changeYn") == 'N') {
						args += "&gubun=S";
					}
					var result = ajaxCall("${ctx}/OrgChangeSchemeMgr.do?cmd=callPrcChgConpVer&authPg=${authPg}", args, false);
					if(result.Message != null && result.Message != undefined && result.Message != "") {
						alert(result.Message);
					} else {
						doAction1("Search");
					}
				}
				
				$("#searchSdate").val(sheet1.GetCellValue(Row, "sdate"));
				
			}
		}catch(ex){alert("sheet1_OnClick Event Error : " + ex);}
	}

	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getOrgChangeSchemeMgrList2", $("#srchFrm").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet2,"ordGubun", true, true)){break;}

				IBS_SaveName(document.srchFrm,sheet2);
				sheet2.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveOrgChangeSchemeMgr2", $("#srchFrm").serialize() ); break;
			case "Insert":
				var Row = sheet2.DataInsert(0);
				sheet2.SetCellValue(Row, "ordYmd", sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate") );
				sheet2.SetCellValue(Row, "sdate", sheet1.GetCellValue(sheet1.GetSelectRow(), "sdate") );
				break;
			case "Copy":        sheet2.DataCopy(); break;				
			case "Down2Excel":
				sheet2.Down2Excel();
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
				var lOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&ordTypeCd="+ sheet2.GetCellValue(i, "ordTypeCd"),false).codeList, " ");	//발령상세종류
				var lOrdReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+ sheet2.GetCellValue(i, "ordTypeCd"), "H40110"), " ");

				sheet2.InitCellProperty(i,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdDetailCd[1], ComboText:"|"+lOrdDetailCd[0]});
				sheet2.InitCellProperty(i,"ordReasonCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
	        }
			
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 셀 값이 바뀔때 발생
	function sheet2_OnChange(Row, Col, Value) {
		try{
            if( sheet2.ColSaveName(Col) == "ordTypeCd" ) {

				if(Value == "") {
					sheet2.InitCellProperty(Row,"ordDetailCd", {Type:"Combo", ComboCode:"", ComboText:""});
					sheet2.InitCellProperty(Row,"ordReasonCd", {Type:"Combo", ComboCode:"", ComboText:""});
				} else {
					var lOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&ordTypeCd="+ sheet2.GetCellValue(Row, "ordTypeCd"),false).codeList, " ");	//발령상세종류
					var lOrdReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+ sheet2.GetCellValue(Row, "ordTypeCd"), "H40110"), " ");

					sheet2.InitCellProperty(Row,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdDetailCd[1], ComboText:"|"+lOrdDetailCd[0]});
					sheet2.InitCellProperty(Row,"ordReasonCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
				}
            }
		}catch(ex){
			alert("OnChange Event Error : " + ex);
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


	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "changeOrgPopup"){
        }
	}


	// 필수값/유효성 체크
	function chkInVal() {
		// 시작일자와 종료일자 체크
		if ($("#srchSYmd").val() != "" && $("#srchEYmd").val() != "") {
			if (!checkFromToDate($("#srchSYmd"),$("#srchEYmd"),"조직개편일자","조직개편일자","YYYYMMDD")) {
				return false;
			}
		}

		return true;
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchSdate" name="searchSdate" value ="" />
		<input type="hidden" id="searchVersionNm" name="searchVersionNm" value ="" />
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='112539' mdef='조직개편일자'/></th>
				<td>
					<input id="srchSYmd" name="srchSYmd" type="text" maxlength="10" size="10" value="" class="${dateCss} w80" /> ~
					<input id="srchEYmd" name="srchEYmd" type="text" maxlength="10" size="10" value="" class="${dateCss} w80" />
				</td>
				<th><tit:txt mid='114305' mdef='확정여부'/></th>
				<td colspan="2">
					<select id="srchChangeYn" name="srchChangeYn">
						<option value="">전체</option>
						<option value="Y">확정</option>
						<option value="N">미확정</option>
					</select>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">조직개편관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Insert');" 		css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); 
	</script>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">가발령적용관리</li>
            <li class="btn">
              <btn:a href="javascript:doAction2('Copy')"   		css="btn outline-gray authA" mid='Copy' mdef="복사"/>
              <btn:a href="javascript:doAction2('Insert')" 		css="btn outline-gray authA" mid='insert' mdef="입력"/>
              <btn:a href="javascript:doAction2('Save')"   		css="btn filled authA" mid='save' mdef="저장"/>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
    	
</div>
</body>
</html>
