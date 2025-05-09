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

		init_sheet();
		
		//doAction1("Search");
		
	});

	

	function init_sheet(){ 

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"과정명",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	Format:"",		Edit:0},
			{Header:"교육시작일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",			KeyField:0,	Format:"Ymd",	Edit:0},	
			{Header:"교육종료일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",			KeyField:0,	Format:"Ymd",	Edit:0},	
			{Header:"사내/외",		Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"inOutType",		KeyField:0,	Format:"",		Edit:0},
			{Header:"시행방법",		Type:"Combo",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduMethodCd",		KeyField:0,	Format:"",		Edit:0},
			{Header:"교육구분",		Type:"Combo",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:0,	Format:"",		Edit:0},
			{Header:"교육분류",		Type:"Combo",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:0,	Format:"",		Edit:0},
			
			{Header:"사번",			Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:1,	Edit:0},
			{Header:"성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			UpdateEdit:0,	InsertEdit:1 },
			{Header:"부서",			Type:"Text",   		Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"직책",			Type:"Text",   		Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"직위",			Type:"Text",   		Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"직급",			Type:"Text",   		Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"직군",			Type:"Text",   		Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"worktypeNm", 	Edit:0},
			
			{Header:"교육신청\n처리상태",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",		Edit:0},
			{Header:"결과보고\n처리상태",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd2",	KeyField:0,	Format:"",		Edit:0},
			
			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"eduSeq"},
  			{Header:"Hidden",	Hidden:1, SaveName:"eduEventSeq"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Hidden:1, SaveName:"chkResult"},
  			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//공통코드 한번에 조회
		var grpCds = "L20020,L10010,L10015,L10050,R10010";
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","useYn=Y&grpCd="+grpCds,false).codeList, "전체");
		
		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} );// L20020 사내/외 구분
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );// L10010 교육구분코드
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );// L10015 교육분류코드
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+codeLists["L10050"][0], ComboCode:"|"+codeLists["L10050"][1]} );// L10050 교육시행방법코드
		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );// R10010 결재상태
		sheet1.SetColProperty("applStatusCd2", 	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );// R10010 결재상태
	
		$(window).smartresize(sheetResize); sheetInit();

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "worktypeNm", rv["worktypeNm"]);
					}
				}
			]
		});

	}

	function checkList(){
		if($("#searchEduSeq").val()==""){
			alert("교육과정을 선택 해주세요.");
			return false;
		}

		return true;
	}
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				if( !checkList() ) return;
				var sXml = sheet1.GetSearchData("${ctx}/EduInTypePeopleMgr.do?cmd=getEduInTypePeopleMgrList", $("#sheet1Form").serialize() );
				sXml = replaceAll(sXml,"rowEdit", "Edit");
				sheet1.LoadSearchData(sXml );
				break;

			case "Save":		//저장
				if( !checkList() ) return;

				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/EduInTypePeopleMgr.do?cmd=saveEduInTypePeopleMgr", $("#sheet1Form").serialize() );
				break;

			case "Insert":		//입력
				if( !checkList() ) return;
				var Row = sheet1.DataInsert(0);
				sheet1.SelectCell(Row, 'name');
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				if( !checkList() ) return;

				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;

			case "DownTemplate":  //양식다운로드

				var downcol = "sabun";
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:downcol});

				break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			progressBar(false);
			
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
			
			var cnt = 0;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if( sheet1.GetCellValue(i, "chkResult") == "0" ){
					sheet1.SetRowBackColor(i, "#fdf0f5");
					cnt++;
				}
			}
			if( cnt > 0 ) alert("기 신청 건이 있습니다. 확인 해주세요.");
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	// 저장 후 에러 메시지
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	// 팝업 클릭시
	function sheet1_OnPopupClick(Row,Col) {
		try{
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 엑셀업로드 후 저장 처리
	function sheet1_OnLoadExcel(result) {
		try {
			if(result) {

				progressBar(true, "처리 중입니다. 잠시만 기다려주세요.");
				
				setTimeout(
					function(){
			            IBS_SaveName(document.sheet1Form, sheet1);
						var params = $("#sheet1Form").serialize()+"&"+sheet1.GetSaveString(0);
						var sXml = sheet1.GetSearchData("${ctx}/EduInTypePeopleMgr.do?cmd=getEduInTypePeopleMgrChk", params );
						sheet1.LoadSearchData(sXml );
					}
				, 100);
				
				
			} else {
				alert("엑셀파일 로드 중 오류가 발생하였습니다.");
			}

		} catch (ex) {
			alert("OnLoadExcel Event Error : " + ex);
		}
	}

	// 저장전 체크
	function sheet1_OnValidation(Row, Col, Value) {
		try {
			if( sheet1.ColSaveName(Col) == "chkResult" && Value == "0"  ) {
				alert("이미 신청 되어 있어 등록할 수 없습니다.");
				sheet1.ValidateFail(1);
				sheet1.SetRowBackColor(Row, "#fdf0f5");
			}
		} catch (ex) {
			alert("OnValidation Event Error " + ex);
		}
	}
//---------------------------------------------------------------------------------------------------------------
// 교육과정 팝업
//---------------------------------------------------------------------------------------------------------------
function eduCourseEvtMgrPopup() {

	if (!isPopup()) {  return; }

	let modalLayer = new window.top.document.LayerModal({
		id: 'eduCourseEvtLayer',
		url: '/Popup.do?cmd=viewEduCourseEvtLayer&authPg=R',
		parameters: {},
		width: 950,
		height: 620,
		title: '필수교육과정 선택',
		trigger: [
			{
				name: 'eduCourseEvtLayerTrigger',
				callback: function(rv) {
					$("#searchEduSeq").val(rv["eduSeq"]);
					$("#searchEduEventSeq").val(rv["eduEventSeq"]);
					$("#searchEduCourseNm").val(rv["eduCourseNm"]);
					$("#searchEduSYmd").val(rv["eduSYmd"]);
					$("#searchEduEYmd").val(rv["eduEYmd"]);
					$("#searchEduYmd").val(formatDate(rv["eduSYmd"],"-") + " ~ " + formatDate(rv["eduEYmd"],"-"));
					doAction1("Search");
				}
			}
		]
	});
	modalLayer.show();
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchEduSeq" name="searchEduSeq">
		<input type="hidden" id="searchEduEventSeq" name="searchEduEventSeq" >
		<input type="hidden" id="searchEduSYmd" name="searchEduSYmd" >
		<input type="hidden" id="searchEduEYmd" name="searchEduEYmd" >

		<div class="sheet_search outer">
			<table>
			<tr>
				<th>교육과정선택</th>
				<td>
					<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w350" readonly/>
					<a onclick="javascript:eduCourseEvtMgrPopup();" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
				<th>교육기간</th>
				<td>
					<input type="text" id="searchEduYmd" name="searchEduYmd" class="text w200" readonly/>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">교육일괄신청</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
					<a href="javascript:doAction1('LoadExcel')"		class="btn outline-gray authA">자료업로드</a>
					<a href="javascript:doAction1('Insert')"		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save')"			class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		
</div>
</body>
</html>
