<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='eduLecturerMgr' mdef='교육강사관리'/></title>
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

//===================================================================================================================================================

		var searchTeacherGb = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20020"), "<tit:txt mid='103895' mdef='전체'/>"); // 강사구분(L20020)
		var searchBankCd    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "<tit:txt mid='103895' mdef='전체'/>"); // 은행구분(H30001)

		$("#searchTeacherGb").html(searchTeacherGb[2]);

//===================================================================================================================================================

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"강사순번",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherSeq",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='teacherGbV1' mdef='강사구분'/>",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherGb",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='teacherNo' mdef='강사번호'/>",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='lecture' mdef='강의과목'/>",			Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"subjectLecture",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"강사명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherNm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"enterNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='telNoV1' mdef='전화번호'/>",			Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='hosTelNo' mdef='자택연락처'/>",			Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"homeTelNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",			Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"zip",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",				Type:"Text",		Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"addr",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"경력",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"career",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"강의료",				Type:"Int",			Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"lectureFee",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='noteV2' mdef='특이사항'/>",			Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='bankCdV1' mdef='은행구분'/>",			Type:"Combo",		Hidden:0,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"bankCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>",			Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"accHolder",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20, AcceptKeys:"N|[-]" },
			{Header:"계좌명",				Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"accNo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("teacherGb", 		{ComboText:"|"+searchTeacherGb[0], ComboCode:"|"+searchTeacherGb[1]} );
		sheet1.SetColProperty("bankCd", 		{ComboText:"|"+searchBankCd[0], ComboCode:"|"+searchBankCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

		$("#searchTeacherNm, #searchSubjectLecture").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchTeacherGb").bind("change",function(event){
			doAction1("Search");
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						sheet1.RemoveAll();
						sheet1.DoSearch( "${ctx}/EduLecturerMgr.do?cmd=getEduLecturerMgrList", $("#sendForm").serialize() );
						break;
		case "Save":
						//if(!dupChk(sheet1,"teacherGb|teacherNo", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/EduLecturerMgr.do?cmd=saveEduLecturerMgr", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
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

			for (var i = sheet1.HeaderRows() ; i < sheet1.HeaderRows() + sheet1.RowCount() ; i++) {
				sheetInfoChange(i, false, "R");
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

	function sheet1_OnPopupClick(Row, Col){
		try{

			var colName = sheet1.ColSaveName(Col);

			if(colName == "teacherNm") {
				
				if (!isPopup()) {
					return;
				}
				employeePopup(Row);
			}
			
			if (colName == "zip") {
				if (!isPopup()) {
					return;
				}

				gPRow = Row;
				pGubun = "ZipCodePopup";
				<%--openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740", "620");--%>

				var url = '/ZipCodePopup.do?cmd=viewZipCodeLayer&authPg=${authPg}';
				var layer = new window.top.document.LayerModal({
					id : 'zipCodeLayer'
					, url : url
					, width : 740
					, height : 620
					, title : '우편번호 검색'
					, trigger :[
						{
							name : 'zipCodeLayerTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				layer.show();
			}

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{

			var colName = sheet1.ColSaveName(Col);

			if( colName == "teacherGb" ) {
				sheetInfoChange(Row, true, "I");
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheetReset(Row){

		sheet1.SetCellValue( Row, "teacherNo",	"");
		sheet1.SetCellValue( Row, "teacherNm",	"");
		sheet1.SetCellValue( Row, "enterNm",	"");
		sheet1.SetCellValue( Row, "orgNm",		"");
		sheet1.SetCellValue( Row, "jikweeNm",	"");
		sheet1.SetCellValue( Row, "jikchakNm",	"");

	}

	function sheetInfoChange(Row, resetFlag, status){

		if ( resetFlag ){
			sheetReset(Row);
		}

		var tearchGb = sheet1.GetCellValue( Row, "teacherGb" );

		if ( tearchGb == "IN" ){

			if ( status == "I" ){
				sheet1.InitCellProperty(Row, "teacherNm",	{Type: "Popup", Align: "Left",   Edit:1});
			}else{
				sheet1.InitCellProperty(Row, "teacherNm",	{Type: "Text", Align: "Center",   Edit:0});
			}
			sheet1.InitCellProperty(Row, "enterNm",		{Type: "Text",		Align: "Left",   Edit:0});
			sheet1.InitCellProperty(Row, "orgNm",		{Type: "Text",		Align: "Left",   Edit:0});

		}else if ( tearchGb == "OUT" ){

			sheet1.InitCellProperty(Row, "teacherNm",	{Type: "Text",		Align: "Center", Edit:1});
			sheet1.InitCellProperty(Row, "enterNm",		{Type: "Text",		Align: "Left",   Edit:1});
			sheet1.InitCellProperty(Row, "orgNm",		{Type: "Text",		Align: "Left",   Edit:1});
		}

	}

	//  사원 팝입
	function employeePopup(Row){
		try {
			if(!isPopup()) {return;}

			gPRow = Row;
			pGubun = "employeePopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
				, parameters : {}
				, width : 840
				, height : 520
				, title : '사원조회'
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(result){
							getReturnValue(result)
						}
					}
				]
			});
			layerModal.show();

		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getReturnValue(rv) {

		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "teacherNo",	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "teacherNm",	rv["name"] );
			sheet1.SetCellValue(gPRow, "enterNm",	rv["enterNm"] );
			sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
		}else if (pGubun == "ZipCodePopup") {
			sheet1.SetCellValue(gPRow, "zip", rv.zip);
			sheet1.SetCellValue(gPRow, "addr", rv.doroFullAddr);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='teacherGb' mdef='강사구분'/></th>
			<td>
				<select id="searchTeacherGb" name="searchTeacherGb" class="box"></select>
			</td>
			<th>강사명</th>
			<td>
				<input id="searchTeacherNm" name="searchTeacherNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<th><tit:txt mid='lecture' mdef='강의과목'/></th>
			<td>
				<input id="searchSubjectLecture" name="searchSubjectLecture" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='eduLecturerMgr' mdef='교육강사관리'/></li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 		class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
				<a href="javascript:doAction1('Insert');" 			class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
				<a href="javascript:doAction1('Save');" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
