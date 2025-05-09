<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
	var pRow      = "";
	var pGubun    = "";
	var titleList = new Array();

	$(function() {
		
		$("input[type='text'], textarea").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});
		
		// 기준일자
		$("#searchDate").datepicker2({
			// onReturn: getCommonCodeList
		});

		$("#searchDate, #searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#statusCd").change(function(){
			if($(this).val() == null){
				 $(this).select2({placeholder:"선택"});
			}
		});
		
		// 재직상태코드(H10010)
		getCommonCodeList();
		
<c:if test="${ ssnAdmin eq 'Y' }">
		// 회사코드
		var grpCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGrpCdMgrGrpCdList",false).codeList, "");
		$("#searchGrpCd").html(grpCdList[2]);
		$("#searchGrpCd").on("change",function(){
			doAction1("Search");
		});
</c:if>
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		//$(window).smartresize(sheetResize);
		sheetInit();

		doAction1("Search");
	});

	function getCommonCodeList() {
		// 재직상태코드(H10010)
		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", $("#searchDate").val()), "");
		$("#statusCd").html(statusCd[2]);
		$("#statusCd").select2({placeholder:""});
		$("#statusCd").val(["AA","CA"]).trigger("change");
	}

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction) {
		switch(sAction){
			case "Search":	//조회
				if($("#searchDate").val() == "") {
					alert("기준일자를 입력하세요.");
					return;
				}

				searchTitleList();
			break;
	
			case "Down2Excel":  //엑셀내려받기
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
			break;
		}
	}

	function searchTitleList() {
	
		var dataList = ajaxCall("${ctx}/EmpList.do?cmd=getEmpListTitleList", $("#srchFrm").serialize(), false);
	
		for(var i=0; i < dataList.DATA.length; i++) {
			titleList["colSaveName"] = dataList.DATA[i].colSaveName.split("|");
			titleList["colHeader"]   = dataList.DATA[i].colHeader.split("|");
			titleList["colName"]     = dataList.DATA[i].colName.split("|");
			titleList["colValue"]    = dataList.DATA[i].colValue.split("|");
			titleList["colWidth"]    = dataList.DATA[i].colWidth.split("|");
			titleList["colType"]     = dataList.DATA[i].colType.split("|");
			titleList["colFormat"]   = dataList.DATA[i].colFormat.split("|");
			titleList["colAlign"]    = dataList.DATA[i].colAlign.split("|");
		}
	
		sheet1.Reset();
	
		if (titleList["colSaveName"].length > 1) {
	
			var v = 0;
	
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:5};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	
			initdata1.Cols = [];
			initdata1.Cols[v++] = {Header:"<sht:txt mid='sNo' mdef='No'/>", Type:"${sNoTy}", Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
	
			//var columnInfo = "";
			var columnAlign = "";
	
			for(var i=0; i<titleList["colSaveName"].length; i++){
				columnAlign = titleList["colAlign"][i];
				if(columnAlign == undefined || columnAlign == "" || columnAlign == null) {
					columnAlign = "Center";
				}
				initdata1.Cols[v++]  = { Header:titleList["colHeader"][i],	Type:titleList["colType"][i],	Hidden:0,	Width:titleList["colWidth"][i],	Align:columnAlign,	ColMerge:0,	SaveName:titleList["colSaveName"][i],	KeyField:0,	Format:(titleList["colFormat"][i]==" "?"":titleList["colFormat"][i]),	PointCount:0,	UpdateEdit:0,	InsertEdit:0, Wrap : 1, MultiLineText : 1};
			//	columnInfo = columnInfo + titleList["colHeader"][i] + " AS " + titleList["colName"][i]+",";
			}
	
			//columnInfo = columnInfo.slice(0,columnInfo.length-1)
	
			//$("#columnInfo").val(columnInfo);
	
			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);
	
			$("#multiStatusCd").val(getMultiSelect($("#statusCd").val()));
			
			sheet1.DoSearch( "${ctx}/EmpList.do?cmd=getEmpListList", $("#srchFrm").serialize() );
		} else {
			alert("조회할 항목이 설정되지 않았습니다. 담당자에게 문의하세요.");
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( sheet1.LastCol() < 10 ) {
				sheetResize();
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
</script>

</head>
<body class="hidden">
<div class="wrapper">
<form id="srchFrm" name="srchFrm" >

<%--	<input type="hidden" id="columnInfo"    name="columnInfo"    value="" />--%>
	<input type="hidden" id="multiStatusCd" name="multiStatusCd" value="" />
	
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
<c:if test="${ ssnAdmin eq 'Y' }">
						<th>그룹코드</th>
						<td>
							<select id="searchGrpCd" name ="searchGrpCd"></select>
						</td>
</c:if>
						<th>기준일자</th>
						<td>
							<input id="searchDate" name="searchDate" type="text" class="text required date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
						</td>
						<th>사번/성명 </th>
						<td>
							<input id="searchNm" name ="searchNm" type="text" class="text" style="ime-mode:active;" />
						</td>
					</tr>
					<tr>
						<th>재직상태</th>
						<td colspan="4">
							<select id="statusCd" name="statusCd" multiple=""></select>
						</td>
						<td><btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">인원명부</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
