<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>조직의지식등록</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

$(function() {
	// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
	initIbFileUpload($("#sheetForm"));

	// 파일 목록 변수의 초기화 작업 시점 정의
	// clearBeforeFunc(function object)
	// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
	//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
	//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
	sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
	sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

	//Sheet 초기화
	init_sheet();
	
	//사번셋팅
	setEmpPage();

	//기준일자 날짜형식, 날짜선택 시
	$("#searchApplYmd").datepicker2({
		onReturn:function(){
			doAction1("Search");
		}
	});

	$("#searchApplYmd").bind("keyup",function(event){
		if( event.keyCode == 13){
			doAction1("Search");
		}
	});
	
	doAction1("Search");
});

//Sheet 초기화
function init_sheet(){

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

	initdata.Cols = [
		{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		
		{Header:"부서|부서",				Type:"Combo",		Hidden:0,	Width:30,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직무|직무",				Type:"Combo",		Hidden:0,	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"필요지식|필요지식", 		Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"knowledge"	,KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },
		{Header:"문서화된 정보|문서화된 정보", Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"docInfo"		,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
		{Header:"저장\n매체|저장\n매체", 	Type:"Combo",		Hidden:0,	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"storageType"	,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },	
		
		{Header:"접근권한|전체",			Type:"CheckBox",Hidden:0, 	Width:13 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthAll",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
		{Header:"접근권한|전사",			Type:"CheckBox",Hidden:0, 	Width:13 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthComp",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
		{Header:"접근권한|본부",			Type:"CheckBox",Hidden:0, 	Width:13 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthHq",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
		{Header:"접근권한|팀",				Type:"CheckBox",Hidden:0, 	Width:13 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthTeam",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
		{Header:"접근권한|직무\n유관",		Type:"CheckBox",Hidden:0, 	Width:13 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthRelate",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
		{Header:"접근권한|직무\n담당",		Type:"CheckBox",Hidden:0, 	Width:13 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthCharge",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
		
		{Header:"최신정보\n확보계획|최신정보\n확보계획",Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"infoPlan",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },	
		{Header:"첨부파일|첨부파일",					Type:"Html",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		Edit:0 },

		{Header:"등록일|등록일",			Type:"Date",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"갱신일|갱신일",			Type:"Date",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"udate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"종료일|종료일",			Type:"Date",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },

		{Header:"Hidden",	Hidden:1, SaveName:"edate" },
		{Header:"Hidden",	Hidden:1, SaveName:"fileSeq" },
		{Header:"Hidden",	Hidden:1, SaveName:"seq" }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
	// 콥보 리스트
	/* ########################################################################################################################################## */
	var orgCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&searchApplSabun="+$("#searchUserId").val(), "queryId=getJobOrgCdList", false).codeList
	            , "code,codeNm"
	            , " ");
	$("#orgCd").html(orgCdList[2]);

// 	var orgCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobOrgList", false).codeList
//             , "code,codeNm"
//             , " ");
// 	sheet1.SetColProperty("orgCd", 		  {ComboText:"|"+orgCd[0], ComboCode:"|"+orgCd[1]} );					   		   //부서
	/* ########################################################################################################################################## */

	$(window).smartresize(sheetResize); sheetInit();
	
}

function getCommonCodeList() {
	let grpCds = "H90014";
	let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchApplYmd").val();
	const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");
	sheet1.SetColProperty("storageType",  {ComboText:"|"+codeLists["H90014"][0], ComboCode:"|"+codeLists["H90014"][1]} );  //저장매체(H90014)
}

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			fnJobCd();
			getCommonCodeList();
			sheet1.DoSearch("${ctx}/OrgKnowledgeReg.do?cmd=getOrgKnowledgeRegList", $("#sheetForm").serialize()+ "&pageType=0" );
        	break;	
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "orgCd", $("#orgCd").val());
			sheet1.SetCellValue(Row, "sdate", $("#searchApplYmd").val());
			sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');

			break;
		case "Copy":
			var Row = sheet1.SelectCell(sheet1.DataCopy(), 2);
			sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			sheet1.SetCellValue(Row, "fileSeq", '');
			break;
        case "Save":
        	// 중복체크
			if (!dupChk(sheet1, "orgCd|jobCd|knowledge", false, true)) {break;}
        	
        	IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/OrgKnowledgeReg.do?cmd=saveOrgKnowledgeReg", $("#sheetForm").serialize());
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
	}
}

//-----------------------------------------------------------------------------------
//		sheet1 이벤트
//-----------------------------------------------------------------------------------
// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { 
			alert(Msg); 
		} 
		if( Code > -1 ) doAction1("Search"); 
	} catch (ex) { 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

// 셀 클릭시 발생
function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		
		if( Row < sheet1.HeaderRows() ) return;
		
	    if( sheet1.ColSaveName(Col) == "detail" ) {
	    	showApplPopup( Row );

	    }else if(sheet1.ColSaveName(Col) == "btnFile"){
	    	// var param = [];
			// param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
			if(sheet1.GetCellValue(Row,"btnFile") != ""){

				gPRow = Row;
				pGubun = "viewFilePopup";
				
				// openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg=A&uploadType=benSeal", param, "740","620");

				let layerModal = new window.top.document.LayerModal({
					id : 'fileMgrLayer'
					, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=A'
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
								addFileList(sheet1, gPRow, result); // 작업한 파일 목록 업데이트
								if(result.fileCheck == "exist"){
									sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
									sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
								}else{
									sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
									sheet1.SetCellValue(gPRow, "fileSeq", "");
								}
							}
						}
					]
				});
				layerModal.show();
			}
	    }else if(sheet1.ColSaveName(Col) == "accessAuthAll"){
	    	if(sheet1.GetCellValue(Row,"accessAuthAll") == "Y"){
	    		sheet1.SetCellValue(Row, "accessAuthComp", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "Y");
	    	}else{
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "N");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "N");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "N");
	    	}
	    	
	    }else if(sheet1.ColSaveName(Col) == "accessAuthComp"){
	    	if(sheet1.GetCellValue(Row,"accessAuthComp") == "Y"){
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "Y");
	    	}else{
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "N");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "N");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "N");
	    	}
	    }else if(sheet1.ColSaveName(Col) == "accessAuthHq"){
	    	if(sheet1.GetCellValue(Row,"accessAuthHq") == "Y"){
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "Y");
	    	}else{
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "N");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "N");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "N");
	    	}
	    }else if(sheet1.ColSaveName(Col) == "accessAuthTeam"){
	    	if(sheet1.GetCellValue(Row,"accessAuthTeam") == "Y"){
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "Y");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "Y");
	    	}else{
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "N");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "N");
	    	}
	    }else if(sheet1.ColSaveName(Col) == "accessAuthRelate"){
	    	if(sheet1.GetCellValue(Row,"accessAuthRelate") == "Y"){
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "N");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "Y");
	    	}else{
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "N");
	    		sheet1.SetCellValue(Row, "accessAuthCharge", "N");
	    	}
	    }else if(sheet1.ColSaveName(Col) == "accessAuthCharge"){
	    	if(sheet1.GetCellValue(Row,"accessAuthCharge") == "Y"){
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "N");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "N");
	    	}else{
	    		sheet1.SetCellValue(Row, "accessAuthAll", "N");
	    		sheet1.SetCellValue(Row, "accessAuthComp", "N");
	    		sheet1.SetCellValue(Row, "accessAuthHq", "N");
	    		sheet1.SetCellValue(Row, "accessAuthTeam", "N");
	    		sheet1.SetCellValue(Row, "accessAuthRelate", "N");
	    	}
	    }
	    
	    
	} catch (ex) {
		alert("OnClick Event Error : " + ex);
	}
}

//인사헤더에서 이름 변경 시 호출 됨 
function setEmpPage() {
	$("#searchSabun").val($("#searchUserId").val());
	$("#searchApplSabun").val($("#searchUserId").val());
	
	var orgCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&searchApplSabun="+$("#searchSabun").val(), "queryId=getJobOrgCdList", false).codeList
           , "code,codeNm"
           , " ");
	
	var orgCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&searchApplSabun="+$("#searchSabun").val()+"&pageType=1", "queryId=getJobOrgList", false).codeList
            , "code,codeNm"
            , " ");
	
	sheet1.SetColProperty("orgCd", 		  {ComboText:"|"+orgCd[0], ComboCode:"|"+orgCd[1]} );					   		   //부서
   	
   	$("#orgCd").html(orgCdList[2]);
   	
   	$("#orgCd option:eq(1)").prop("selected", true);
   	
	doAction1("Search");
}

function fnJobCd(){
	var jobCdParam = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&orgCd="+$("#orgCd").val(), "queryId=getJobCdList2", false).codeList
            , "code,codeNm"
            , " ");
   	
   	sheet1.SetColProperty("jobCd", 		  {ComboText:"|"+jobCdParam[0], ComboCode:"|"+jobCdParam[1]} );					   //직무코드
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
		<input type="hidden" id="searchTitleYn" name="searchTitleYn" value="Y"/>
		
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th>부서</th>
						<td>
							<select id="orgCd" name="orgCd"></select>
						</td>
						<th>기준일</th>
						<td>
							<input type="text" class="text date2" id="searchApplYmd" name="searchApplYmd" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">조직의 지식 등록</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')"	class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
					<a href="javascript:doAction1('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</body>
</html>
