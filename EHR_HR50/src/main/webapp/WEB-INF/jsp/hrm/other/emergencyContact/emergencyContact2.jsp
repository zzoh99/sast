<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">


	$(function() {
		$("#searchRows,#searchRetSYmd,#searchRetEYmd").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchRetSYmd,#searchRetEYmd").keypressEnter(function(){
			doAction1("Search");
		});
		
		init_sheet1();
	
		doAction1("Search");
	});


	function init_sheet1(){ 
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'          mdef='No'/>",			Type:"${sNoTy}",Hidden:0,   Width:45,   Align:"Center", SaveName:"sNo" },
			{Header:"<sht:txt mid='sabun'        mdef='사번'/>",			Type:"Text",    Hidden:"${sabunHdn}",   Width:70,   Align:"Center", SaveName:"sabun",       Edit:0 },
			{Header:"<sht:txt mid='name'         mdef='성명'/>",			Type:"Text",    Hidden:0,   Width:70,   Align:"Center", SaveName:"name",        Edit:0 },
			{Header:"<sht:txt mid='orgYn'        mdef='소속'/>",			Type:"Text",    Hidden:0,   Width:150,  Align:"Center", SaveName:"orgNm",       Edit:0 },
			{Header:"<sht:txt mid='jikgubNm'     mdef='직급'/>",			Type:"Text",    Hidden:Number("${jgHdn}"),   Width:70,   Align:"Center", SaveName:"jikgubNm",    Edit:0 },		
			{Header:"<sht:txt mid='officeTel'    mdef='사무실전화'/>",		Type:"Text",    Hidden:0,   Width:90,   Align:"Center", SaveName:"contactOt",   Edit:0 },
			{Header:"<sht:txt mid='officeTelV2'  mdef='사내전화(4자리)'/>",Type:"Text",    Hidden:1,   Width:90,   Align:"Center", SaveName:"contactOt2",  Edit:0 },
			{Header:"<sht:txt mid='L17082800752' mdef='자택전화'/>",		Type:"Text",    Hidden:0,   Width:90,   Align:"Center", SaveName:"contactHt",   Edit:0 },
			{Header:"<sht:txt mid='L17082800753' mdef='휴대전화'/>",		Type:"Text",    Hidden:0,   Width:90,   Align:"Center", SaveName:"contactHp",   Edit:0 },
			{Header:"<sht:txt mid='faxNo'        mdef='팩스번호'/>",		Type:"Text",    Hidden:0,   Width:90,   Align:"Center", SaveName:"contactFt",   Edit:0 },
			{Header:"<sht:txt mid='L17082800755' mdef='사내이메일'/>",		Type:"Text",    Hidden:0,   Width:120,  Align:"Center", SaveName:"contactIm",   Edit:0 },
			{Header:"<sht:txt mid='L17082500541' mdef='비상연락망'/>",	Type:"Text",    Hidden:0,   Width:90,   Align:"Center", SaveName:"contactSc1",  Edit:0 },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(0); sheet1.SetVisible(true);

		$("#searchRetSYmd").datepicker2({startdate:"searchRetEYmd"});
		$("#searchRetEYmd").datepicker2({enddate:"searchRetSYmd"});

		$("input[id='statusCd']").click(function(){
			if($(this).val() == "RA") {
			//	$("#hdnYmd").hide();
				$(".hdnYmd").hide();
			} else {
			//	$("#hdnYmd").show();
				$(".hdnYmd").show();
			}
		});
		

		$(window).smartresize(sheetResize); sheetInit();
	}



	function init_sheet2(){
		
		if($("#searchRows").val() == "") return;
		
		var rows = parseInt($("#searchRows").val()); //전체직원수
		var totalRows = sheet1.RowCount() + 25; // 조직수 대략 30이람 봄. 넉넉하게..
		if( totalRows == 0 ) return; 
		
		var cols = parseInt ( totalRows / rows );  //가로 컬럼 수
		if( totalRows > (cols * rows)  ) cols = cols + 1;
		
		sheet2.Reset(); //리셋
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};

		var idx=0, colIdx = 1, colcnt = 2;
		initdata.Cols = [];
		for( var colIdx=1; colIdx<=cols ; colIdx++){ 
			colcnt = 2; //표시 항목 수
			initdata.Cols[idx++] = {Header:"<sht:txt mid='name'         mdef='성명'/>",		Type:"Text",    Hidden:0,   Width:70,   Align:"Center", SaveName:"name"+colIdx,        Edit:0 };
			initdata.Cols[idx++] = {Header:"<sht:txt mid='jikgubNm'     mdef='직급'/>",		Type:"Text",    Hidden:Number("${jgHdn}"),   Width:70,   Align:"Center", SaveName:"jikgubNm"+colIdx,    Edit:0 };
			
			if( $("#contactOt").is(":checked")  == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='officeTel'    mdef='사무실전화'/>",		Type:"Text", Hidden:0, Width:90,  Align:"Center", SaveName:"contactOt"+colIdx,   Edit:0 }; colcnt++; }
			if( $("#contactOt2").is(":checked") == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='officeTelV2'  mdef='사내전화(4자리)'/>",	Type:"Text", Hidden:0, Width:60,  Align:"Center", SaveName:"contactOt2"+colIdx,   Edit:0 }; colcnt++; }
			if( $("#contactHt").is(":checked")  == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='L17082800752' mdef='자택전화'/>",		Type:"Text", Hidden:0, Width:90,  Align:"Center", SaveName:"contactHt"+colIdx,   Edit:0 }; colcnt++; }
			if( $("#contactHp").is(":checked")  == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='L17082800753' mdef='휴대전화'/>",		Type:"Text", Hidden:0, Width:110,  Align:"Center", SaveName:"contactHp"+colIdx,   Edit:0 }; colcnt++; }
			if( $("#contactFt").is(":checked")  == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='faxNo'        mdef='팩스번호'/>",		Type:"Text", Hidden:0, Width:70,  Align:"Center", SaveName:"contactFt"+colIdx,   Edit:0 }; colcnt++; }
			if( $("#contactIm").is(":checked")  == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='L17082800755' mdef='사내이메일'/>",		Type:"Text", Hidden:0, Width:150, Align:"Center", SaveName:"contactIm"+colIdx,   Edit:0 }; colcnt++; }
			if( $("#contactOm").is(":checked")  == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='L17082500540' mdef='사외이메일'/>",		Type:"Text", Hidden:0, Width:150, Align:"Center", SaveName:"contactOm"+colIdx,   Edit:0 }; colcnt++; }
			if( $("#contactSc1").is(":checked") == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='L17082500541' mdef='비상연락망1'/>",		Type:"Text", Hidden:0, Width:90,  Align:"Center", SaveName:"contactSc1"+colIdx,  Edit:0 }; colcnt++; }
			if( $("#contactSc2").is(":checked") == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='L17082500542' mdef='비상연락망2'/>",		Type:"Text", Hidden:0, Width:90,  Align:"Center", SaveName:"contactSc2"+colIdx,  Edit:0 }; colcnt++; }
			if( $("#contactSc3").is(":checked") == true) { initdata.Cols[idx++] = {Header:"<sht:txt mid='L17082500543' mdef='비상연락망3'/>",		Type:"Text", Hidden:0, Width:90,  Align:"Center", SaveName:"contactSc3"+colIdx,  Edit:0 }; colcnt++; }
		}
		IBS_InitSheet(sheet2, initdata); sheet2.SetEditable(0); sheet2.SetVisible(true);
		sheet2.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		//sheet2.SetRowHidden(0,1); //헤더행 숨김
		sheet2.RenderSheet(0); //랜더링
		
		//입력한 row 만큼 생성
		for( var i=0; i <= rows ; i++){
			sheet2.DataInsert();
		}
		//컬럼 배열
		var arrCols = ["name","jikgubNm","contactOt","contactOt2","contactHt","contactHp","contactFt","contactIm","contactOm","contactSc1","contactSc2","contactSc3"];
		
		var orgNm = "", row = 1, col = 1;
		for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
			if( orgNm != sheet1.GetCellValue(i, "orgNm")){ //조직명을 상단에 표시 하기 위함
				
				if( row == rows+1){ //조직명이 마지막라인일 경우 
					row = 1; col++; 
				}
				orgNm = sheet1.GetCellValue(i, "orgNm");
				sheet2.SetCellValue(row, "name"+col, orgNm );

				sheet2.SetMergeCell(row, sheet2.SaveNameCol("name"+col), 1, colcnt); //조직명 강제 머지
				sheet2.SetCellBackColor(row, "name"+col, "#f4f4f4"); //조직명 색상
				sheet2.SetCellFontBold(row, "name"+col, 1) //조직명 글자 굵기
				row++;
			}
			if( row > rows+1 ){  row = 1; col++; } //row수 넘어가면 다음 컬럼으로
			
			if( row == 1 ){ //첫라인에 부서명 표시
				sheet2.SetCellValue(row, "name"+col, orgNm );
				sheet2.SetMergeCell(row, sheet2.SaveNameCol("name"+col), 1, colcnt); //조직명 강제 머지
				sheet2.SetCellBackColor(row, "name"+col, "#f4f4f4"); //조직명 색상
				sheet2.SetCellFontBold(row, "name"+col, 1) //조직명 글자 굵기
				row++;
			}
			if( row > rows+1 ){  row = 1; col++; } //row수 넘어가면 다음 컬럼으로
			
			for( var j=0; j<arrCols.length; j++){ //데이터 셋팅
				sheet2.SetCellValue(row, arrCols[j]+col, sheet1.GetCellValue(i, arrCols[j]), 0 );
			}
			
			row++;
			if( row > rows+1 ){  row = 1; col++; }
		}
		if( row > 1 ) col++;
		//Hidden
		for( var i = col; i<= cols; i++ ){
			for( var j=0; j<arrCols.length; j++){
				sheet2.SetColHidden(arrCols[j]+i, 1 );
			}
		}
		sheet2.HideProcessDlg();
		sheet2.RenderSheet(1);
		sheetInit();sheetResize();
	}

	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			sheet2.ShowProcessDlg("Search");

			setTimeout(function(){
				sheet1.DoSearch( "${ctx}/EmergencyContact.do?cmd=getEmergencyContactList", $("#sheet1Form").serialize() );
			}, 100);

			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
			}

			sheet2.ShowProcessDlg("Search");
			setTimeout(function(){init_sheet2();}, 100);
			//sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
		<!--
			<td rowspan="2">
				<span>Row</span>
				<input type="text" id="searchRows" name="searchRows" class="text w30" value="30" maxlength="3" />
			</td>
			

			
			<td rowspan="2"><span>&nbsp;조회항목&nbsp;</span></td>
			<td><input type="checkbox" id="contactOt" name="contactOt" style="margin-bottom:-2px;"><label for="contactOt">&nbsp; 사무실전화 &nbsp;</label></td>
			<td><input type="checkbox" id="contactHp" name="contactHp" checked style="margin-bottom:-2px;"><label for="contactHp">&nbsp;휴대전화&nbsp;</label></td>
			<td><input type="checkbox" id="contactHt" name="contactHt"  style="margin-bottom:-2px;"><label for="contactHt">&nbsp;자택전화&nbsp;</label></td>
			<td>&nbsp;</td>
			
			<td rowspan="2">			
			<input id="statusCd" name="statusCd" type="radio" value="RA" checked>퇴직자제외&nbsp;
			<input id="statusCd" name="statusCd"  type="radio" value="" >퇴직자포함&nbsp;
			<span id="hdnYmd" style="display:none;">
			퇴직일자&nbsp;
			<input id="searchRetSYmd" name="searchRetSYmd" type="text" class="date2" style="width:60px"> ~
			<input id="searchRetEYmd" name="searchRetEYmd" type="text" class="date2" style="width:60px">
			</span>

			<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
			</td>
		-->
			<th rowspan="2">Row</th>
			<td rowspan="2">
				<input type="text" id="searchRows" name="searchRows" class="text w30" value="30" maxlength="3" />
			</td>
			

			<th rowspan="2">조회항목</th>
			<td rowspan="2"></td>
			<td><input type="checkbox" id="contactOt" name="contactOt" style="margin-bottom:-2px;"><label for="contactOt">&nbsp; 사무실전화 &nbsp;</label></td>
			<td><input type="checkbox" id="contactHp" name="contactHp" checked style="margin-bottom:-2px;"><label for="contactHp">&nbsp;휴대전화&nbsp;</label></td>
			<td><input type="checkbox" id="contactHt" name="contactHt"  style="margin-bottom:-2px;"><label for="contactHt">&nbsp;자택전화&nbsp;</label></td>
			<td>&nbsp;</td>
			
			<td rowspan="2">			
			<input id="statusCd" name="statusCd" type="radio" value="RA" checked>퇴직자제외&nbsp;
			<input id="statusCd" name="statusCd"  type="radio" value="" >퇴직자포함&nbsp;
			
			<th rowspan="2" class="hdnYmd" style="display:none;">퇴직일자</th>
			<td rowspan="2" class="hdnYmd" style="display:none;">
				<input id="searchRetSYmd" name="searchRetSYmd" type="text" class="date2" style="width:60px"> ~
				<input id="searchRetEYmd" name="searchRetEYmd" type="text" class="date2" style="width:60px">
			</td>
			</td>
			<td rowspan="2"><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
		</tr>
		<tr>
			<td><input type="checkbox" id="contactFt" name="contactFt"  style="margin-bottom:-2px;"><label for="contactFt">&nbsp;팩스번호&nbsp;</label></td>
			<td><input type="checkbox" id="contactIm" name="contactIm"  style="margin-bottom:-2px;"><label for="contactIm">&nbsp;사내이메일&nbsp;</label></td>
			<td><input type="checkbox" id="contactSc1" name="contactSc1"  style="margin-bottom:-2px;"><label for="contactSc1">&nbsp;비상연락망&nbsp;</label></td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="emergencyContact" mdef="비상연락망" /></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "300px", "${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>
