<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style>
.select2-input{
	width: 300px;
}
</style>
<script type="text/javascript">
	$(function() {

		$("#sYmd").val("<%= DateUtil.getCurrentTime("yyyy-MM-dd")%>") ;

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getLocationCdListAuth";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}		
		var locationCdList = "";
		if(allFlag) {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장	
		} else {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchLocationCd").html(locationCdList[2]);
		
		$(window).smartresize(sheetResize);
		sheetInit();
		
		doAction1("Search");
	});

	$(function() {

        $("#searchLocationCd, #orgCd").bind("change",function(event){
			doAction1("Search");
		});
        $("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#sYmd").datepicker2({
			ymonly:false,
			onReturn:function(date){
				$("#sYmd").val(date);
				getManageCd();
			}
		});

		$("#sYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ searchAll(); $(this).focus(); }
		});

		getManageCd();
	});

	function getManageCd() {
		// 직군(H10030)
		let baseSYmd = $("#sYmd").val();
		const manageCd 	= convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd), "");
		$("#manageCd").html(manageCd[2]);
		$("#manageCd").select2({
			placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")
		});
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#sYmd").val() == "") {
				alert("<msg:txt mid='110025' mdef='기준일을 입력하여 주십시오.'/>");
				return;
			}

			searchTitleList();
			
			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			
			sheet1.DoSearch( "${ctx}/WtmOrgDailyTimeStats.do?cmd=getWtmOrgDailyTimeStatsList", $("#mySheetForm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}
	
	function searchTitleList() {
		var param = "";

		var titleList = ajaxCall("${ctx}/WtmOrgDailyTimeStats.do?cmd=getWtmOrgDailyTimeStatsHeaderList", param, false);

		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:3, MergeSheet:msHeaderOnly};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			var colIdx = 0;
			initdata1.Cols = [];
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='locationCdV2' mdef='근무지|근무지'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100};
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='departmentV2' mdef='부서|부서'/>",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 ,TreeCol:1,  LevelSaveName:"sLevel"};
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='empCnt_V2' mdef='인원|인원'/>",		Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empCnt",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='2018050800007' mdef='출근인원|출근인원'/>",	Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workEmpCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };

			var i = 0 ; 
			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols[colIdx++] = {Header:"<sht:txt mid='2018050800010' mdef='근태현황'/>|"+titleList.DATA[i].gntNm,	Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:titleList.DATA[i].saveName1Disp,		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 };
			}

			IBS_InitSheet(sheet1, initdata1);
			sheet1.SetCountPosition(0);
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			$(window).smartresize(sheetResize);	
			sheetInit();
			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		let layerModal = new window.top.document.LayerModal({
			id : 'orgTreeLayer'
			, url : '/Popup.do?cmd=viewOrgTreeLayer&authPg=${authPg}'
			, parameters : {searchEnterCd : ''}
			, width : 740
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직도 조회'/>'
			, trigger :[
				{
					name : 'orgTreeLayerTrigger'
					, callback : function(result){
						$("#orgCd").val(result["orgCd"]);
						$("#orgNm").val(result["orgNm"]);
					}
				}
			]
		});
		layerModal.show();
	}

	function clearCode(num) {
		if(num == 1) {
			$("#orgCd").val("");
			$("#orgNm").val("");
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id="mySheetForm" name="mySheetForm" >
<input type="hidden" id="multiManageCd" name="multiManageCd" value="" />
	
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='104281' mdef='근무지'/></th>
				<td class="">
					<select id="searchLocationCd" name="searchLocationCd"> </select>
				</td>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td>
					<input type="hidden" id="orgCd" name="orgCd" />
					<input type="text" id="orgNm" name="orgNm"  class="text readonly w100" readonly/><a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
					<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/>하위포함
				</td>
				<th><tit:txt mid='104535' mdef='기준일'/></th>
				<td>
					<input id="sYmd" name="sYmd" type="text" class="date required"/>
				</td>
			</tr>
			<tr>
				<th>직군</th>
				<td colspan="4">
					<select id="manageCd" name="manageCd" multiple=""></select>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="btn dark" mid="search" mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='orgTimeStats' mdef='소속원근태현황'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>