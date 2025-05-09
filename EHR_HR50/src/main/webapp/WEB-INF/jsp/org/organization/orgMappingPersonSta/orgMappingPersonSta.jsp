<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
var pRow = "";
var pGubun = "";

var titleList = new Array();

	$(function() {

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='grpId' mdef='조직'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0},

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$("input[type='text'], textarea").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#searchDate").datepicker2();
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	switch(sAction){
		case "Search":	//조회
						searchTitleList();
						break;

		case "Down2Excel":  //엑셀내려받기
						sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
						break;

	}
}

function searchTitleList() {

	var dataList = ajaxCall("${ctx}/OrgMappingPersonSta.do?cmd=getOrgMappingPersonStaTitleList", $("#srchFrm").serialize(), false);

	for(var i=0; i < dataList.DATA.length; i++) {
		titleList["colSaveName"] = dataList.DATA[i].colSaveName.split("|");
		titleList["colHeader"] = dataList.DATA[i].colHeader.split("|");
		titleList["colName"] = dataList.DATA[i].colName.split("|");
	}

	sheet1.Reset();

	if (dataList != null && dataList.DATA != null) {

		var v = 0;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22 , FrozenCol:8 };
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

		initdata1.Cols = [];

		initdata1.Cols[v++] = {Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='grpId' mdef='조직'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",		Hidden:Number("${jgHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0};

		var columnInfo = "";
		var columnName = "";

		if(titleList["colSaveName"][0] != ""){
			for(var i=0; i<titleList["colSaveName"].length; i++){
				initdata1.Cols[v++]  = { Header:titleList["colHeader"][i],	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:titleList["colSaveName"][i],	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0};
				columnInfo = columnInfo + "'" + titleList["colSaveName"][i] + "' AS " + titleList["colName"][i]+",";
				columnName = columnName + titleList["colName"][i]+",";
	
			}
		}

		columnInfo = columnInfo.slice(0,columnInfo.length-1)
		columnName = columnName.slice(0,columnName.length-1)

		//$("#columnInfo").val(columnInfo);
		$("#columnName").val(columnName);

		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);
	 	$(window).smartresize(sheetResize);
		sheetInit();

		if(titleList["colSaveName"][0] != ""){
			sheet1.DoSearch( "${ctx}/OrgMappingPersonSta.do?cmd=getOrgMappingPersonStaList", $("#srchFrm").serialize() );
		} else {
			sheet1.DoSearch( "${ctx}/OrgMappingPersonSta.do?cmd=getOrgMappingPersonStaListNull", $("#srchFrm").serialize() );
		}
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function getMultiSelectValue( value ) {
	if( value == null || value == "" ) return "";
	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
	//return "'"+String(value).split(",").join("','")+"'";
		return value;
}

function orgSearchPopup(){
	try{
		let layerModal = new window.top.document.LayerModal({
			  id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=A'
			, parameters : {}
			, width : 840
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						$("#searchOrgCd").val(result[0]["orgCd"]);
						$("#searchOrgNm").val(result[0]["orgNm"]);
					}
				}
			]
		});
		layerModal.show();

	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

</script>



</head>
<body class="hidden">
<div class="wrapper">
<form id="srchFrm" name="srchFrm" >

<%--	<input type="hidden" id="columnInfo" name="columnInfo" value="" />--%>
	<input type="hidden" id="columnName" name="columnName" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='103906' mdef='기준일자'/></th>
						<td> 
						<input type="text" id="searchDate" name="searchDate" class="date2" value="${curSysYyyyMMddHyphen}" />
						<th><tit:txt mid='104279' mdef='소속'/></th>
						<td> <input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
						<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" readonly="readonly" style="width:120px" />
						<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif" /></a>
						<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif" /></a> </td>
						<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
						<td> 
						<input id="searchNm" name ="searchNm" type="text" class="text" /> </td>
					    <td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt">조직구분개인별현황</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')"	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
