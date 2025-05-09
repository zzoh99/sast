<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의료비내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	
	$(function() {
		$("#searchYear").val("<%=yeaYear%>") ;
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },	
			{Header:"삭제",				Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
			{Header:"상태",				Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
			{Header:"대상년도",			Type:"Text",		Hidden:0, Width:60,	Align:"Center",	ColMerge:1,		SaveName:"work_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Combo",		Hidden:0, Width:70,	Align:"Center",	ColMerge:1,		SaveName:"adjust_type",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서명",			Type:"Text",		Hidden:0, Width:90,	Align:"Left",	ColMerge:1,		SaveName:"org_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",				Type:"Text",		Hidden:0, Width:70,	Align:"Center",	ColMerge:1,		SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",				Type:"Text",		Hidden:0, Width:80,	Align:"Center",	ColMerge:1,		SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"순서",				Type:"Text",		Hidden:1, Width:0,	Align:"Center",	ColMerge:1,		SaveName:"seq",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"명의인",			Type:"Text",		Hidden:0, Width:70,	Align:"Center",	ColMerge:1,		SaveName:"fam_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"명의인주민번호",		Type:"Text",		Hidden:0, Width:100,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:0, Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"구분",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"special_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"의료비증빙코드",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:1,	SaveName:"medical_imp_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"상세구분",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"restrict_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"재가/시설급여",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"medical_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사업자번호",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"enter_no",		KeyField:0,	Format:"SaupNo",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상호",				Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"firm_nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"의료비내용",		Type:"Text",		Hidden:1,	Width:90,	Align:"Left",	ColMerge:1,	SaveName:"contents",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"건수",				Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"cnt",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"금액자료(직원용)",	Type:"AutoSum",		Hidden:1,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"금액(담당자용)",	Type:"AutoSum",		Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"자료입력유형",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"지급일자",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"ymd",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"관계",					Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"adj_fam_cd",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"난임시술비\n해당여부",   Type:"CheckBox",    Hidden:0,   Width:80,   Align:"Center", ColMerge:1, SaveName:"nanim_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"담당자확인",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"feedback_type",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );		
		var medicalImpCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00308"), "");
		var restrictCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00340"), "");
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "전체");

		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("special_yn",		{ComboText:" |65세이상|장애인", ComboCode:" |B|A"} );
		sheet1.SetColProperty("medical_type",	{ComboText:" |재가급여|시설급여", ComboCode:" |1|2"} );
		sheet1.SetColProperty("medical_imp_cd",	{ComboText:"|"+medicalImpCdList[0], ComboCode:"|"+medicalImpCdList[1]} );
		sheet1.SetColProperty("restrict_cd",	{ComboText:"|"+restrictCdList[0], ComboCode:"|"+restrictCdList[1]} );
		sheet1.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchInputType").html(adjInputTypeList[2]);

		// 사업장
        var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
        
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//doAction1("Search");
	});
	
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
			sheet1.DoSearch( "<%=jspPath%>/medHisMgr/medHisMgrRst.jsp?cmd=selectMedHisMgrList", $("#sheetForm").serialize() ); 
			break;
			
        case "Save":
            sheet1.DoSave( "<%=jspPath%>/medHisMgr/medHisMgrRst.jsp?cmd=saveMedHisMgr", $("#sheetForm").serialize());
            break;
            
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param	= {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
			
		case "Down2Template":
			var param  = {DownCols:"work_yy"
				+"|adjust_type"
				+"|name"
				+"|sabun"
				+"|seq"
				+"|fam_nm"
				+"|famres"
				+"|special_yn"
				+"|medical_imp_cd"
				+"|restrict_cd"
				+"|medical_type"
				+"|enter_no"
				+"|firm_nm"
				+"|cnt"
				+"|appl_mon"
				+"|adj_input_type"
				+"|nts_yn",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:""};
			sheet1.Down2Excel(param); 
			break;
        case "LoadExcel":  
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet1.LoadExcel(params); 
			break;
		}
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			
			if (Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
					if (sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF
						sheet1.SetRowEditable(i, 0);
					}
				}
			}
			
			sheetResize(); 
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            
            if(Code == 1) {
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/> </td>
				
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box"></select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
		</table>
		</div>
	</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">의료비내역관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>