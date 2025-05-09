<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='113187' mdef='프로필카드출력'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
	var gPRow = "";

	// 공통코드
	var enterCdList;
	var jikweeCdList;
	var jobCdList;
	var statusCdList;

	$(function() {
		enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAuthEnterCdList&searchGrpCd=${ssnGrpCd}",false).codeList, "");
		jikweeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "<tit:txt mid='103895' mdef='전체'/>");
		jobCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getJobCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");	//직무코드
		statusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "<tit:txt mid='103895' mdef='전체'/>");
	});

	$(function() {

		$('input:checkbox[name="rdPapViewYn"]').each(function(){
		     if(this.value == "Y"){
		        this.checked = true;
		     }
		});

		$("#searchRetSYmd").datepicker2({startdate:"searchRetEYmd"});
		$("#searchRetEYmd").datepicker2({enddate:"searchRetSYmd"});

		$("#searchEnterCd, #searchJikweeCd, #searchJobCd").bind("change",function(event){
			doAction1("Search");
		});

		$("input[name='searchStatusCd']").bind("click",function(event){
			if($(this).val() == "RA") {
				$(".hdnYmd").hide();
			} else {
				$(".hdnYmd").show();
			}
		});

		$("#searchName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	$(function() {
		$("#searchEnterCd").html(enterCdList[2]);
		$("#searchJikweeCd").html(jikweeCdList[2]);
		$("#searchJobCd").html(jobCdList[2]);

		initSheet1();
		initSheet2();

		doAction("Search");
	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search":		doAction1("Search"); break;
		case "Add":		//추가
			var chk = "";

			var arrRow = sheet1.FindCheckedRow("chk").split("|");

	        for(var i=0; i < arrRow.length; i++) {
	        	var Row = arrRow[i];
	        	if( Row == "" ) continue;
	        	chk = "Y";

	        	//sheet1.SetCellValue(Row, "chk",	"0");

	        	// 이미 추가된 값이 있으면 continue
	        	var findText = sheet1.GetCellValue(Row, "enterCd") +"_"+ sheet1.GetCellValue(Row, "sabun");
	        	if ( sheet2.FindText("findText",findText) != -1 ) continue;

	        	// 행 추가
	        	var AddRow = sheet2.DataInsert(-1);

	        	sheet2.SetCellValue(AddRow, "chk",	"1");
	        	sheet2.SetCellValue(AddRow, "enterCd",		sheet1.GetCellValue(Row, "enterCd"));
	        	sheet2.SetCellValue(AddRow, "orgNm",		sheet1.GetCellValue(Row, "orgNm"));
	        	sheet2.SetCellValue(AddRow, "sabun",		sheet1.GetCellValue(Row, "sabun"));
	        	sheet2.SetCellValue(AddRow, "name",			sheet1.GetCellValue(Row, "name"));
	        	sheet2.SetCellValue(AddRow, "jikweeCd",		sheet1.GetCellText(Row, "jikweeCd"));
	        	sheet2.SetCellValue(AddRow, "seq",			i+1);
	        	sheet2.SetCellValue(AddRow, "findText",		findText );
	        	sheet2.SetCellValue(AddRow, "rk",           sheet1.GetCellText(Row, "rk"));
	        }

			if(chk == ""){
				alert("<msg:txt mid='109714' mdef='선택된 대상자가 없습니다. 대상자를 선택해 주십시요'/>");
				return;
			}

			for ( var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++) {
				sheet2.SetCellValue(i, "seq",	i);
			}

			break;

		case "Del":		//삭제
			var chk = "";

			var arrRow = sheet2.FindCheckedRow("chk").split("|");
	        for(var i = arrRow.length -1 ; 0 <= i ; i--) {
	        	var Row = arrRow[i];
	        	if( Row == "" ) continue;
	        	chk = "Y";

	        	sheet2.SetCellValue(Row, "sDelete", "1");
	        }

			if(chk == ""){
				alert("<msg:txt mid='109714' mdef='선택된 대상자가 없습니다. 대상자를 선택해 주십시요'/>");
				return;
			}

			break;
		}
	}

	function showRd(){

		const printOption = $("#printOption").val();
		if (printOption === "") {
			alert("<msg:txt mid='2018081300009' mdef='출력옵션을 선택하세요.'/>");
			return;
		}

		var checkedRowsCount = sheet2.CheckedRows('chk');
		if(checkedRowsCount === 0){
			alert('<msg:txt mid="109876" mdef="대상자를 선택하세요" />');
			return;
		}

		let searchEnterCdSabunStr = '';
		let searchSabunStr = '';
		let checkedRows = sheet2.FindCheckedRow('chk');
		let rkList = [];

		$(checkedRows.split("|")).each(function(index,value) {
			searchEnterCdSabunStr += ",('" + sheet2.GetCellValue(value,"enterCd") +"','" + sheet2.GetCellValue(value,"sabun") + "')";

			if(index > 0){
				searchSabunStr += ",'"+sheet2.GetCellValue(value,"enterCd")+"_"+sheet2.GetCellValue(value,"sabun")+"',"+sheet2.GetCellValue(value,"seq");
			}else{
				searchSabunStr += "'"+sheet2.GetCellValue(value,"enterCd")+"_"+sheet2.GetCellValue(value,"sabun")+"',"+sheet2.GetCellValue(value,"seq");
			}
			rkList[index] = sheet2.GetCellValue(value, 'rk');
		});

		if (searchEnterCdSabunStr === '') {
			alert("<msg:txt mid='109876' mdef='대상자를 선택하세요'/>");
			return;
		}
	    
	    //showRdLayer 암호화 파라미터 받기 
        let param = null;
        
		//암호화 할 데이터 생성
		var rdProfileName = $("#rdProfileName").val().trim(); 
        const data = {
			rk : rkList ,
			fileName : rdProfileName,
			printOption: printOption
        };
       
		window.top.showRdLayer('/ProfileCardPrt.do?cmd=getEncryptRd', data, null, "프로필카드");
	}
</script>

<!-- sheet1 -->
<script type="text/javascript">
	function initSheet1() {try{
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },

   			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",		Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",	Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='rk' mdef='rk'/>",                Type:"Text",       Hidden:1,   Width:0,    Align:"Center", ColMerge:0, SaveName:"rk",    KeyField:0, UpdateEdit:0,   InsertEdit:0,   EditLen:1000 }
   		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("enterCd", 			{ComboText:"|"+enterCdList[0], ComboCode:"|"+enterCdList[1]} );
		sheet1.SetColProperty("jikweeCd", 			{ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );
		sheet1.SetColProperty("jobCd", 			{ComboText:"|"+jobCdList[0], ComboCode:"|"+jobCdList[1]} );
		sheet1.SetColProperty("statusCd", 			{ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
	}catch(e){alert("initSheet1::" + e)}}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($('#searchType').val() == "O") {
				sheet1.DoSearch( "${ctx}/ProfileCardPrt.do?cmd=getProfileCardPrtAuthList",$("#sheetForm").serialize() );
			} else {
				sheet1.DoSearch( "${ctx}/ProfileCardPrt.do?cmd=getProfileCardPrtList",$("#sheetForm").serialize() );
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
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

	// 값 변경시 발생.
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if( sheet1.ColSaveName(Col) == "name" && sheet1.GetCellEditable(Row,"name") == true ) {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "employeePopup";
				var win = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "840","520");
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
</script>

<!-- sheet2 -->
<script type="text/javascript">
	function initSheet2() {try{
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",		Type:"Int",			Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"seq",			Format:"Integer",KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },   			
   			{Header:"",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"findText",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"<sht:txt mid='rk' mdef='rk'/>",                Type:"Text",       Hidden:1,   Width:0,    Align:"Center", ColMerge:0, SaveName:"rk",    KeyField:0, UpdateEdit:0,   InsertEdit:0,   EditLen:1000 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);

		sheet2.SetColProperty("enterCd", 			{ComboText:""+enterCdList[0], ComboCode:""+enterCdList[1]} );
		sheet2.SetColProperty("jikweeCd", 			{ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );
		
		//Autocomplete
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, "enterCd",	rv["enterCd"]);
						sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet2.SetCellValue(gPRow, "name",		rv["name"]);
						sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet2.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);

						var data = ajaxCall("/ProfileCardPrt.do?cmd=getEmpCardPrtRk", rv, false);
						if ( data != null && data.DATA != null ){
							sheet2.SetCellValue(gPRow, "rk",	data.DATA.rk);
						}
					}
				}
			]
		});			

		$(window).smartresize(sheetResize); sheetInit();
	}catch(e){alert("initSheet2::" + e)}}

	//Sheet Action
	function doAction2(sAction) {
		var searchEnterCd = (sheet1.GetSelectRow() < 0)? "" : sheet1.GetCellValue(sheet1.GetSelectRow(), "enterCd");
		var searchSabun = (sheet1.GetSelectRow() < 0)? "" : sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun");

		switch (sAction) {
		case "Insert":
			var Row = sheet2.DataInsert(0);
			sheet2.SelectCell(Row, "name");
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param	= {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|5|7"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if (Code != "-1") { doAction2("Search"); }
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if (Shift == 1 && KeyCode == 45) { doAction2("Insert"); }	// Insert KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") { sheet2.SetCellValue(Row, "sStatus", "D"); }	//Delete KEY
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet2_OnLoadExcel(result) {
		try {
			if (!result) {
				alert("엑셀 로딩중 오류가 발생하였습니다.");
				return;
			}
			for (var i = sheet2.HeaderRows(); i < sheet2.RowCount() + sheet2.HeaderRows(); i++) {
				const param = {
					"enterCd" : sheet2.GetCellValue(i, 'enterCd'),
					"sabun" : sheet2.GetCellValue(i, 'sabun')
				};
				const data = ajaxCall("/ProfileCardPrt.do?cmd=getEmpCardPrtRk", param, false);
				if ( data != null && data.DATA != null ){
					sheet2.SetCellValue(i, "rk", data.DATA.rk);
				}

			}
		} catch (ex) {
			alert("sheet2_OnLoadExcel Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input id="searchType" name="searchType" type="hidden" value="${ssnSearchType}">
		<input id="rdPapViewYn" name="rdPapViewYn" type="hidden" value="Y" />

		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='114232' mdef='회사'/></th>
				<td>  <select id="searchEnterCd" name="searchEnterCd" class="w150"></select> </td>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td>     <input type="text" id="searchOrgNm" name="searchOrgNm" class="text"/></td>
				<th><tit:txt mid='104330' mdef='사번/성명'/></th>
				<td>  <input id="searchName" name="searchName" type="text" class="text"/> </td>
				<td>
			<c:choose>
				<c:when test="${ssnSearchType == 'O'}">
					<input id="searchAdminYn" name="searchAdminYn" type="hidden" value="O">
					<input id="searchStatusCd" name="searchStatusCd" type="hidden" value="RA">
				</c:when>
				<c:otherwise>
					<input id="searchAdminYn" name="searchAdminYn" type="hidden" value="A">
					<input id="searchStatusCd" name="searchStatusCd" type="radio" value="RA" checked>&nbsp;<font style="vertical-align:middle;"><tit:txt mid='113521' mdef='퇴직자 제외'/></font>&nbsp;&nbsp;
					<input id="searchStatusCd" name="searchStatusCd"  type="radio" value="" >&nbsp;<font style="vertical-align:middle;"><tit:txt mid='114221' mdef='퇴직자 포함'/></font>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104104' mdef='직위'/></th>
				<td>  <select id="searchJikweeCd" name="searchJikweeCd" class="w150"></select> </td>
				<!-- td> <th><tit:txt mid='103973' mdef='직무'/></th> <select id="searchJobCd" name ="searchJobCd" class="w150"></select> </td -->
				<th><tit:txt mid='113181' mdef='프로필명'/></th>
			 	<td>
					<input id="rdProfileName" name="rdProfileName" type="text" class="text w150" value="프로필카드"/>
				</td>
				<th>출력옵션</th>
				<td> 
					<select id="printOption" name="printOption">
						<option value="">선택</option>
						<option value="0" selected="selected">3x1</option>
						<option value="1">3x2</option>
						<option value="2">3x3</option>
					</select>
				</td>
				<th class="hdnYmd" style="display:none;">퇴직일자</th>
				<td class="hdnYmd" style="display:none;">
					<input id="searchRetSYmd" name="searchRetSYmd" type="text" class="date2" style="width:60px"> ~
					<input id="searchRetEYmd" name="searchRetEYmd" type="text" class="date2" style="width:60px">
				</td>
				<td>
					<btn:a href="javascript:doAction('Search');" css="btn dark" mid='110697' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="35px" />
			<col width="%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113529' mdef='조회결과'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_arrow text-center">
				<a href="javascript:doAction('Add');" class="btn outline_gray icon authA"><i class="mdi-ico">chevron_right</i></a>
				<a href="javascript:doAction('Del');" class="btn outline_gray icon authA"><i class="mdi-ico">chevron_left</i></a>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113182' mdef='출력대상자'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('DownTemplate')" 	css="btn outline_gray authA" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction2('LoadExcel')"		css="btn outline_gray authA" mid='110703' mdef="업로드"/>
								<btn:a href="javascript:doAction2('Insert')" 		css="btn outline_gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Clear')" 		css="btn outline_gray authA" mid='110754' mdef="초기화"/>
								<btn:a href="javascript:showRd()"				css="btn outline_gray authA" mid='110727' mdef="출력"/>
								<btn:a href="javascript:doAction2('Down2Excel')"	css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>

		</tr>
	</table>

</div>
</body>
</html>
