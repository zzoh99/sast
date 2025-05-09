<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=yeaYear%>") ;
		$("#searchYmd1").mask("1111-11-11") ;	$("#searchYmd1").datepicker2({startdate:"searchYmd2"});
		$("#searchYmd2").mask("1111-11-11") ;	$("#searchYmd2").datepicker2({enddate:"searchYmd1"});

		var initdata = {};
		initdata.Cfg = {FrozenCol:9,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
   			{Header:"회사코드",            Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"enterCd", KeyField:0, PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
   			{Header:"대상년도",			Type:"Text",      Hidden:0,  Width:70,    Align:"Center",  ColMerge:0,   SaveName:"work_yy",			KeyField:1,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
	        {Header:"정산구분",			Type:"Combo",     Hidden:0,  Width:70,    Align:"Center",  ColMerge:0,   SaveName:"adjust_type",		KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"순번",			Type:"Text",     Hidden:0,  Width:70,    Align:"Center",  ColMerge:0,   SaveName:"seq",		KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"사번",			Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"sabun",				KeyField:0,		CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"성명",			Type:"Popup",	  Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"name",				KeyField:0,   	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"주민등록번호",		Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"res_no",		KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"사업자등록번호\n유가증권표준코드",			Type:"Text",      Hidden:0,  Width:120,    Align:"Left",  ColMerge:1,   SaveName:"b9_no",				KeyField:0,  Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100},
            {Header:"법인명",					Type:"Text",       Hidden:0,   Width:100,   Align:"Center",   ColMerge:0, SaveName:"b10_enter_nm",      KeyField:0, PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"우리사주\n취득일",                  Type:"Date",       Hidden:0,   Width:110,   Align:"Center",   ColMerge:0, SaveName:"b11_ymd",      KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"배당금 지급\n기준일",                  Type:"Date",       Hidden:0,   Width:110,   Align:"Center",   ColMerge:0, SaveName:"b12_ymd",      KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"증권금융회사\n예탁일",                  Type:"Date",       Hidden:0,   Width:110,   Align:"Center",   ColMerge:0, SaveName:"b13_ymd",      KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"우리사주\n인출일",                  Type:"Date",       Hidden:0,   Width:110,   Align:"Center",   ColMerge:0, SaveName:"b14_ymd",      KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"액면가액\n합계액",			Type:"AutoSum",	  Hidden:0,	Width:90,	Align:"Right",	 ColMerge:0,	SaveName:"b15_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"배당소득금액",			Type:"AutoSum",	  Hidden:0,	Width:90,	Align:"Right",	 ColMerge:0,	SaveName:"b16_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"구분",		Type:"Combo",	  Hidden:0,	Width:80,	Align:"Right",	 ColMerge:0,	SaveName:"b17_gubun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"납부세액",			Type:"AutoSum",	  Hidden:0,	Width:90,	Align:"Right",	 ColMerge:0,	SaveName:"b18_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"환급세액",			Type:"AutoSum",	  Hidden:0,	Width:90,	Align:"Right",	 ColMerge:0,	SaveName:"b19_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(1);sheet1.SetCountPosition(4);

        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
        <%-- //var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00325"), ""); --%>

        sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
        sheet1.SetColProperty("b17_gubun",     {ComboText:"납부세액|환급세액", ComboCode:"1|2"});

		$("#searchAdjustType").html(adjustTypeList[2]).val("1");

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
			sheet1.DoSearch( "<%=jspPath%>/wooriMgr/wooriMgrRst.jsp?cmd=selectYeaDataWooriList", $("#sheetForm").serialize() );
			break;
		case "Save":
			/* for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
				if( sheet1.GetCellValue(i, "sStatus") == "U" ||
					sheet1.GetCellValue(i, "sStatus") == "I" ||
					sheet1.GetCellValue(i, "sStatus") == "S"
				) {
				}
			} */

			sheet1.DoSave( "<%=jspPath%>/wooriMgr/wooriMgrRst.jsp?cmd=saveYeaDataWoori");
			break;
		case "Insert":

			if(chkRqr()){
                 break;
            }
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#searchAdjustType").val() ) ;
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
            var param  = {DownCols:"4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	function chkRqr(){

        var chkSearchAdjustType    = $("#searchAdjustType").val();

        var chkValue = false;

        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
    }

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

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

	var gPRow  = "";
	var pGubun = "";

	//팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//클릭시 발생
	function sheet1_OnClick(Row, Col, Value) {
		try{
			/* if(sheet1.ColSaveName(Col) == "sDelete" ) {
				if(sheet1.GetCellValue(Row,"sStatus") != "I" && sheet1.GetCellValue(Row,"adj_input_type")=="07") {
					alert('PDF업로드자료는 PDF등록 탭에서 반영제외하면 현재 화면에서 삭제됩니다.');
					sheet1.SetCellValue(Row,"sDelete", "0");
				}
			} */
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{

		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	//사원 조회
	function openEmployeePopup(Row){
	    try{
		    var args    = new Array();

		    if(!isPopup()) {return;}
		    gPRow = Row;
		    pGubun = "employeePopup";

		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");

	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "res_no", 	rv["res_no"] );
			
		}
	}

	function comma(str) {
		if (str == null || str == undefined || str == "") return 0;

		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td><span>년도</span>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사번/성명</span>
                    <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px" value=""/> 
                </td>
				<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a></td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">관리</li>
            <li class="btn">
            	<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>