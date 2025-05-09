<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>종전1근무지정보</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">

	var titleList  = new Array();
	var dataList   = new Array();
	var colCnt = 0;
	var colData = "";

	$(function() {

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), ""); //작업구분(C00303)

		$("#searchWorkYy").val("<%=yeaYear%>") ;

		//종전1근무지정보
		var v = 0;
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [];
		initdata.Cols[v++] = {Header:"No",			Type:"<%=sNoTy%>",		Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata.Cols[v++] = {Header:"삭제",			Type:"<%=sDelTy%>",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workYy",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[v++] = {Header:"상태",			Type:"<%=sSttTy%>",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		KeyField:0,	Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

		initdata.Cols[v++] = {Header:"회사코드",					Type:"Text",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enter_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata.Cols[v++] = {Header:"귀속년도",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata.Cols[v++] = {Header:"정산구분",					Type:"Combo",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[v++] = {Header:"사원번호",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[v++] = {Header:"성명",						Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata.Cols[v++] = {Header:"9.근무처명",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[v++] = {Header:"10.사업자등록번호",			Type:"Text",			Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"regino",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[v++] = {Header:"11.근무기간시작일",			Type:"Text",			Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"adj_s_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 };
		initdata.Cols[v++] = {Header:"11.근무기간종료일",			Type:"Text",			Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"adj_e_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 };
		initdata.Cols[v++] = {Header:"12.감면기간시작일",			Type:"Text",			Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"reduce_s_ymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 };
		initdata.Cols[v++] = {Header:"12.감면기간종료일",			Type:"Text",			Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"reduce_e_ymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 };

		//동적 컬럼 세팅
		var headerList = ajaxCall("<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=selectHeaderList", $("#sheetForm").serialize(), false);

		//헤더 세팅
		if (headerList != null && headerList.Data != null) {
			//헤더명 추출
			for(var i=0; i < headerList.Data.length; i++) {
				titleList["headerListNm"] = headerList.Data[i].header_nm.split("|");
			}
			//동적생성
			for(var i=0; i<titleList["headerListNm"].length; i++){
				var h = i+1;
				initdata.Cols[v++]  = { Header:titleList["headerListNm"][i],	Type:"Int",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"Data_"+[h],	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 };
			}
			colCnt = titleList["headerListNm"].length;
		}
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

		sheet1.SetColProperty("adjust_type",  {ComboText:"|"+adjustTypeList[0], 	ComboCode:"|"+adjustTypeList[1]});
		$("#searchAdjustType").val(parent.searchAdjustType.value);
		doAction1("Search");
        $(window).smartresize(sheetResize); sheetInit();
	});

	//조회
	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(parent.searchSbNm.value != "" || parent.searchSbNm.value != null){
				$("#searchSbNm").val(parent.searchSbNm.value);	
			}
			sheet1.DoSearch( "<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=selectMigBefWp2MgrList", $("#sheetForm").serialize()+"&colCnt="+colCnt );
			break;
		case "Save":
			sheet1.DoSave( "<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=saveMigUploadMgr",$("#sheetForm").serialize()+"&colCnt="+colCnt);
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row,"work_yy",$("#searchWorkYy").val());
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row,"work_yy",$("#searchWorkYy").val());
			sheet1.SetCellValue(Row,"name","");
			break;
		case "Down2Template":
            var titleText  = "작성방법 \n 1. 귀속년도, 정산구분, 사원번호는 필수입니다.\n"+
            			     "2.저장시 해당 Row 삭제 저장 후 Upload 해주시기 바랍니다.\n";
			var param  = {DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1,DownRows:0,FileName:'Template',SheetName:'sheet1',TitleText:titleText,UserMerge:"0,0,1,19", ExcelRowHeight:100 ,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var	params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
	}
	
	//조회
	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

    //조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			//동적 필드 데이터 세팅
			colDataSet();
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1('Search');
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//동적 필드 데이터 세팅
	function colDataSet(){
		//컬럼 데이터 조회
		colData = ajaxCall("<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=getColDataList", 	$("#sheetForm").serialize()+"&colCnt="+colCnt, false);
		
		if (colData != null && colData.Data != null) {
			if(colData.Data.length > 0 ){
				for(var k=1; k<colCnt+1; k++){
					for (var i = 0; i < colData.Data.length; i++) {
						sheet1.SetCellValue(i+1,"Data_"+k,colData.Data[i].col_data.split("_")[k-1]);
						sheet1.SetCellValue(i+1,"sStatus","R");
					}
				}
			}
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm"  name="menuNm"  value="" />
    <input type="hidden" id="tabNum"  name="tabNum"  value="5"/>
    <input type="hidden" id="searchWorkYy"  	name="searchWorkYy"  	 value=""/>
    <input type="hidden" id="searchAdjustType"  name="searchAdjustType"  value=""/>
    <input type="hidden" id="searchSbNm"  		name="searchSbNm"  		 value=""/>
    </form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">종전1근무지정보</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Template')"   	class="basic btn-download">양식 다운로드</a>
				<a href="javascript:doAction1('LoadExcel')"   		class="basic btn-upload">업로드</a>
				<a href="javascript:doAction1('Insert')" 			class="basic ">입력</a>
				<a href="javascript:doAction1('Copy')" 				class="basic ">복사</a>
				<a href="javascript:doAction1('Save')" 				class="basic btn-save">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 		class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "620px"); </script>
</div>
</body>
</html>