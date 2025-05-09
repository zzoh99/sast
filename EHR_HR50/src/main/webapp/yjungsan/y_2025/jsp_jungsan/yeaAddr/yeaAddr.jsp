<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산주소반영</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=removeXSS(yeaYear, '1')%>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=removeXSS(sNoTy, '1')%>",	Hidden:Number("<%=removeXSS(sNoHdn,'1')%>"),	Width:"<%=removeXSS(sNoWdt,'1')%>",	Align:"Center", ColMerge:0,		SaveName:"sNo" },
			{Header:"상태",			Type:"<%=removeXSS(sSttTy,'1')%>", Hidden:0,  						Width:"<%=removeXSS(sSttWdt,'1')%>", 	Align:"Center", ColMerge:0,   	SaveName:"sStatus" , Sort:0},
			{Header:"대상년도",		Type:"Text",		Hidden:1, 						Width:50,				Align:"Center",	ColMerge:1,		SaveName:"workyy",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",		Type:"Combo",      	Hidden:0,  						Width:60,    			Align:"Center", ColMerge:1,   	SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0, 						Width:50,				Align:"Center",	ColMerge:1,		SaveName:"sabun",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"성명",			Type:"Text",		Hidden:0, 						Width:50,				Align:"Center",	ColMerge:1,		SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서명",			Type:"Text",		Hidden:0, 						Width:60,				Align:"Center",	ColMerge:1,		SaveName:"org_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"우편번호",		Type:"Text",		Hidden:0, 						Width:50,				Align:"Center",	ColMerge:1,		SaveName:"zip",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기본주소",		Type:"Text",		Hidden:0, 						Width:150,				Align:"Left",	ColMerge:1,		SaveName:"addr1",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"기본주소상세",		Type:"Text",		Hidden:0, 						Width:0,				Align:"Left",	ColMerge:1,		SaveName:"addr2",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"주소구분",		Type:"Text",		Hidden:1, 						Width:0,				Align:"Center",	ColMerge:1,		SaveName:"addType",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"선택",			Type:"CheckBox",  	Hidden:0,  						Width:30,    			Align:"Center",	ColMerge:1,   	SaveName:"chk",				KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:6 , TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
		// 작업구분
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		
		// 주소구분
		var addTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "H20185"), "" );

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=ssnSearchType%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        $("#addType").html(addTypeList[2]);

		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");
	});

	$(function() {
		$("#searchSbNm, #searchOrgNm").bind("keyup",function(event){
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
			sheet1.DoSearch( "<%=jspPath%>/yeaAddr/yeaAddrRst.jsp?cmd=selectYeaAddrList", $("#sheetForm").serialize() );
			break;

        case "Save":

        	// 저장항목 선택여부
        	var checkYn = "N";
			var rowCnt = sheet1.RowCount();
			for (var i=1; i<=rowCnt; i++) {
				if (sheet1.GetCellValue(i, "chk") == "Y") {
					checkYn = "Y";
					// 주소구분 선택값 저장
					sheet1.SetCellValue(i, "addType", $("#addType").val());
				}
			}
			if (checkYn == "N") {
				alert("저장할 주소가 없습니다.");
				return;
			}

        	if(confirm("저장하시겠습니까?")){
        		sheet1.DoAllSave("<%=jspPath%>/yeaAddr/yeaAddrRst.jsp?cmd=saveYeaAddrList", $("#sheetForm").serialize());
        	}
            break;

        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
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
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<%-- 무의미한 분기문 주석 처리 20240919
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				--%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%-- 무의미한 분기문 주석 처리 20240919}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}--%>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
				<td><span>부서명</span>
					<input id="searchOrgNm" name ="searchOrgNm" class="text" />
				</td>
                <td>
                    <span>급여사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
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
			<li class="txt">주소현황</li>
			<li class="btn">
				<select id="addType" name="addType" class="box"></select>
				<a href="javascript:doAction1('Save');" class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic btn-download authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>