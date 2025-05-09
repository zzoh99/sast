<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수대상자</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		$("#searchYm").datepicker2({ymonly : true});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
    	initdata.Cols = [
			{Header:"No|No",					Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:Number("1"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:Number("1"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"원천징수이행상황신고서|문서번호",		Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"tax_doc_no",		KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"원천징수이행상황신고서|신고일자",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"report_ymd",		KeyField:0,		Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"원천징수이행상황신고서|신고사업장명",	Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"bp_nm",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"원천징수이행상황신고서|구분",			Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"tax_ele_nm",		KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"개인기준정보|급여계산명",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_nm",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"개인기준정보|사번",				Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"개인기준정보|성명",				Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"개인기준정보|급여기준사업장",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"bp_nm_2",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"개인기준정보|Location",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"location_nm",		KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"개인기준정보|비고",				Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"bigo",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"생성내역|시간",					Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"생성내역|작업자",				Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"chkid",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
       	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);


		// 사업장(TCPN121)
		var bizPlaceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "전체");
		$("#searchBpCd").html(bizPlaceCd[2]);

		// locationCd
		var locationCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getLocationCdAllList") , "전체");
		$("#searchLocationCd").html(locationCd[2]);

		// 구분코드
		var taxEleCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+$("#searchYm").val(), "C00530") , "전체");
		$("#searchTaxEleCd").html(taxEleCd[2]);
		
		
		$(window).smartresize(sheetResize);
		sheetInit();

		doAction1("Search");
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxEmpRst.jsp?cmd=selectEarnIncomeTaxEmpList", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
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

</script>
</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <div class="sheet_search outer">
        <div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>신고연월</span>
							<input type="text" id="searchYm" name="searchYm" class="text center" maxlength="7" value="<%=curSysYyyyMMHyphen%>"/>
						</td>
						<td>
							<span>문서번호</span>
							<input type="text" id="searchTaxDocNo" name="searchTaxDocNo" class="text" value="" />
						</td>
						<td>
							<span>사번/성명</span>
							<input type="text" id="searchSbNm" name="searchSbNm" class="text" value="" />
						</td>
						<td>
							<span>구분</span>
							<select id="searchTaxEleCd" name="searchTaxEleCd"> </select>
						</td>
					</tr>
					<tr>
						<td>
							<span>급여기준사업장</span>
							<select id="searchBpCd" name="searchBpCd"> </select>
						</td>
						<td>
							<span>Location</span>
							<select id="searchLocationCd" name="searchLocationCd"> </select>
						</td>
						<td>
							<span>급여계산명</span>
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text" value="" />
						</td>
						<td>
							<a href="javascript:doAction1('Search')"	class="button authR">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">원천징수대상자</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>