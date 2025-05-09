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

		var orgCd = convCode( codeList("${ctx}/WtmPersonalTimeStats.do?cmd=getWtmPersonalTimeStatsOrgList",""), "");
		$("#orgCd").html(orgCd[2]);
		$("#sYm").val("<%= DateUtil.getCurrentTime("yyyy-MM")%>") ;

		//근무지 관리자권한만 전체근무지 보이도록, 그외는 권한근무지만.
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
        $("#searchSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#sYm").datepicker2({
			ymonly:true,
			onReturn:function(date){
				$("#sYm").val(date);
				getManageCd();
			}
		});

		$("#sYm").bind("keyup",function(event){
			if( event.keyCode == 13){ searchAll(); $(this).focus(); }
		});
		getManageCd();
	});

	function getManageCd() {
		// 사원구분코드(H10030)
		let searchYm = $("#sYm").val();

		if (searchYm === "") {
			return;
		}

		let baseSYmd = searchYm + "-01";
		let baseEYmd = getLastDayOfMonth(searchYm);

		const manageCd 	= convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd, baseEYmd), "");
		$("#manageCd").html(manageCd[2]);
		$("#manageCd").select2({
			placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")
		});
	}

	function getLastDayOfMonth(yearMonth) {
		const [year, month] = yearMonth.split('-').map(Number);
		const lastDate = new Date(year, month, 0);

		const yearStr = lastDate.getFullYear().toString();
		const monthStr = (lastDate.getMonth() + 1).toString().padStart(2, '0');
		const dayStr = lastDate.getDate().toString().padStart(2, '0');

		return yearStr + '-' + monthStr + '-' + dayStr;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#sYm").val() == "") {
				alert("<msg:txt mid='109806' mdef='기준월을 입력하여 주십시오.'/>");
				return;
			}

			searchTitleList();
			
			$("#multiManageCd").val(getMultiSelect($("#manageCd").val()));
			
			sheet1.DoSearch( "${ctx}/WtmPersonalTimeStats.do?cmd=getWtmPersonalTimeStatsList", $("#mySheetForm").serialize() );
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

		var titleList = ajaxCall("${ctx}/WtmPersonalTimeStats.do?cmd=getWtmPersonalTimeStatsHeaderList", param, false);

		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:3, MergeSheet:msHeaderOnly};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			var colIdx = 0;
			initdata1.Cols = [];
			//initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='sNoV1' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='locationCdV2' mdef='근무지|근무지'/>",Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='orgNmV2' mdef='소속|소속'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='suname' mdef='성명|성명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			//initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='2018050800009' mdef='결근'/>",	Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"absenceEmpCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			//initdata1.Cols[colIdx++]  = {Header:"<sht:txt mid='2018050800008' mdef='지각'/>",	Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"lateEmpCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

			var i = 0 ; 
			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols[colIdx++] = {Header:"<sht:txt mid='2018050800010' mdef='근태현황'/>|"+titleList.DATA[i].gntNm,	Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:titleList.DATA[i].saveName1Disp,		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 };
			}
			//initdata1.Cols[colIdx++] = {Header:"temp",Type:"AutoSum",		Hidden:1,  Width:50,   Align:"Center", 	ColMerge:1,   SaveName:"temp",		KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };

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
				<th><tit:txt mid='2017083001034' mdef='기준월'/></th>
				<td>
					<input id="sYm" name="sYm" type="text" class="date required"/>
				</td>
				<th><tit:txt mid='104330' mdef='사번/성명'/></th>
				<td>
					<input id="searchSabun" name="searchSabun" type="text" class="text"/>
				</td>
			</tr>
			<tr>
				<th>직군</th>
				<td colspan="6">
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