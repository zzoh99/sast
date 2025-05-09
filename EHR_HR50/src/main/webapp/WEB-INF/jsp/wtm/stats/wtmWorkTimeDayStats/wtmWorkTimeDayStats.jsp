<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>일별근무현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var headerStartCnt = 0;
var locationCdList = "";
var titleList = null;
var isChangeDate = true;

	$(function() {

		// from - to 일자 근태대상기준일(TTIM004)에서 가져오도록 처리
		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getStandDtFromTTIM004",false);

		if(data != null && data.codeList[0] != null ) {
			$("#searchSymd").val(data.codeList[0].symd);
			$("#searchEymd").val(data.codeList[0].eymd);
		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:50, FrozenCol:0, MergeSheet:msNone};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
             {Header:"No",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" }
         ] ; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

  		if ("${ssnSearchType}" != "A"){
			var searchOrgUrl = "queryId=getTSYS319orgList&ssnSearchType=${ssnSearchType}&ssnGrpCd=${ssnGrpCd}&searchSabun=${ssnSabun}";
			var searchOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", searchOrgUrl,false).codeList, "");
			$("#searchOrgCd").html(searchOrgCdList[2]);
		}

        $("#searchSymd").datepicker2({
        	startdate:"searchEymd",
   			onReturn:function(date){
				getCommonCodeList();
   				isChangeDate = true; //날짜 변경 여부
   				//doAction1("Search");
   			}
        });
        $("#searchEymd").datepicker2({
        	enddate:"searchSymd",
   			onReturn:function(date){
				getCommonCodeList();
   				isChangeDate = true; //날짜 변경 여부
   				//doAction1("Search");
   			}
        });
		$("#searchSymd, #searchEymd").bind("keyup",function(event){
			isChangeDate = true; //날짜 변경 여부
			//if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); } // 2014.12.22 막음
		});

		getCommonCodeList();

		$("#searchWorkClassCd, #searchOrgCd, #searchJikweeCd, #searchManageCd, #searchBizPlaceCd").bind("change",function(event){
			//doAction1("Search");
		});
		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$("input[name='searchColFlag']").bind("change",function(event){
			
			var hdn_t = ( $("#searchColFlag1").is(':checked') == true )?0:1;
			var hdn_x = ( $("#searchColFlag2").is(':checked') == true )?0:1;
			var hdn_n = ( $("#searchColFlag3").is(':checked') == true )?0:1;
			var hdn_u = ( $("#searchColFlag4").is(':checked') == true )?0:1;

			sheet1.RenderSheet(0);
			for(var col = sheet1.SaveNameCol("manageNm")+1 ; col <= sheet1.LastCol(); col++) {
				var tmp = sheet1.ColSaveName(col).substring(0,1);
				if( tmp == "t" ) {
					sheet1.SetColHidden(col, hdn_t);
				} else if( tmp == "x" ) {
					sheet1.SetColHidden(col, hdn_x);
				} else if( tmp == "n" ) {
					sheet1.SetColHidden(col, hdn_n);
				} else if( tmp == "u" ) {
					sheet1.SetColHidden(col, hdn_u);
				}
			}
			sheet1.RenderSheet(1);
		});

		searchTitleList();
		$(window).smartresize(sheetResize);
		sheetInit();
	});

	async function getCommonCodeList() {
		//공통코드 한번에 조회
		let baseSYmd = $("#searchSymd").val();
		let baseEYmd = $("#searchEymd").val();

		let grpCds = "H20010,H10030,T11020";  // 직급, 사원구분, 근무그룹
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");

		$("#searchJikgubCd").html(codeLists["H20010"][2]);
		$("#searchManageCd").html(codeLists["H10030"][2]);

		await setWorkClassCdOptions();
	}

	async function setWorkClassCdOptions() {

		let searchSdate = $("#searchSymd").val();
		let searchEdate = $("#searchEymd").val();

		const data = await callFetch("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWtmWorkClassCdList&searchSdate=" + searchSdate + "&searchEdate=" + searchEdate);
		if (data.isError) {
			alert(data.errMsg);
			return;
		}

		const workClassCdList = data.codeList;
		for (const workClassCd of workClassCdList) {
			$("#searchWorkClassCd").append("<option value='" + workClassCd.workClassCd + "' data-workTypeCd='" + workClassCd.workTypeCd + "'>" + workClassCd.workClassNm + "</option>");
		}

		$("#searchWorkClassCd").on("change", function() {
			changeWorkClassCd();
		})
	}

	function changeWorkClassCd() {
		if ($("#searchWorkClassCd option:selected").attr("data-workTypeCd") !== "D") {
			sheet1.SetColHidden(sheet1.SaveNameCol("workGroupNm"), 1);
		} else {
			sheet1.SetColHidden(sheet1.SaveNameCol("workGroupNm"), 0);
		}
	}

	// 필수값/유효성 체크
	function chkInVal() {
		// 시작일자와 종료일자 체크
		if($("#searchSymd").val() == ""){
			alert("근무기간 시작일자를 입력 해주세요.");
			$("#searchSymd").focus();
			return false;
		}
		if($("#searchEymd").val() == ""){
			alert("근무기간 종료일자를 입력 해주세요.");
			$("#searchEymd").focus();
			return false;
		}

		if ($("#searchSymd").val() != "" && $("#searchEymd").val() != "") {
			if (!checkFromToDate($("#searchSymd"),$("#searchEymd"),"근무기간","근무기간","YYYYMMDD")) {
				return false;
			}
		}

		return true;
	}

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			searchTitleList();
			sheet1.DoSearch( "${ctx}/WtmWorkTimeDayStats.do?cmd=getWtmWorkTimeDayStatsList", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};

			sheet1.Down2Excel(param);

			break;
		}
	}

	/*SETTING HEADER LIST*/
	function searchTitleList() {
		if( !isChangeDate ) return;
		
		titleList = ajaxCall("${ctx}/WtmWorkTimeDayStats.do?cmd=getWtmWorkTimeDayStatsHeaderList", $("#sheetForm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var v=0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad,Page:10, MergeSheet:msHeaderOnly,FrozenCol:6};

			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

			initdata1.Cols = [];
			initdata1.Cols[v++] = {Header:"No|No|No",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" };
			initdata1.Cols[v++] = {Header:"근무유형|근무유형|근무유형",	Type:"Text",		Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"workClassNm",		KeyField:0,   CalcLogic:"",   Format:"",		 PointCount:0,	 UpdateEdit:0,	 InsertEdit:0};

			initdata1.Cols[v++] = {Header:"근무조|근무조|근무조",		Type:"Text",		Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"workGroupNm",		KeyField:0,   CalcLogic:"",   Format:"",		 PointCount:0,	 UpdateEdit:0,	 InsertEdit:0};

			initdata1.Cols[v++] = {Header:"소속|소속|소속",			Type:"Text",		Hidden:0,  Width:100,	Align:"Center",  ColMerge:1,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			initdata1.Cols[v++] = {Header:"사번|사번|사번",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"sabun",		   	KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0};
			initdata1.Cols[v++] = {Header:"성명|성명|성명",			Type:"Text",		Hidden:0,  Width:50,	Align:"Center",  ColMerge:1,   SaveName:"name",		   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0};
			initdata1.Cols[v++] = {Header:"직급|직급|직급",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"jikgubNm",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0};
			initdata1.Cols[v++] = {Header:"직책|직책|직책",			Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0};
			initdata1.Cols[v++] = {Header:"사원구분|사원구분|사원구분",Type:"Text",		Hidden:0,  Width:60,	Align:"Center",  ColMerge:1,   SaveName:"manageNm",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0};

			var hiddenFlag1 = ($("#searchColFlag1").is(':checked') == true)?0:1;
			var hiddenFlag2 = ($("#searchColFlag2").is(':checked') == true)?0:1;
			var hiddenFlag3 = ($("#searchColFlag3").is(':checked') == true)?0:1;
			var hiddenFlag4 = ($("#searchColFlag4").is(':checked') == true)?0:1;

			for(var i=0; i<titleList.DATA.length; i++) {
				initdata1.Cols[v++] = {Header:titleList.DATA[i].year+"|"+titleList.DATA[i].shortDayNm+"|근무",	Type:"Text",	Hidden:hiddenFlag1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].saveName,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 };
				initdata1.Cols[v++] = {Header:titleList.DATA[i].year+"|"+titleList.DATA[i].shortDayNm+"|연장",	Type:"Text",	Hidden:hiddenFlag2,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].extSaveName,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 };
				initdata1.Cols[v++] = {Header:titleList.DATA[i].year+"|"+titleList.DATA[i].shortDayNm+"|야간",	Type:"Text",	Hidden:hiddenFlag3,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].ltnSaveName,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 };
				initdata1.Cols[v++] = {Header:titleList.DATA[i].year+"|"+titleList.DATA[i].shortDayNm+"|계",		Type:"Text",	Hidden:hiddenFlag4,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:titleList.DATA[i].totSaveName,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 };
			}
			initdata1.Cols[v++] = {Header:"temp",Type:"AutoSum",		Hidden:1,  Width:50,   Align:"Center", 	ColMerge:1,   SaveName:"temp",		KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };

			IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			changeWorkClassCd();

	  		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
	  		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
			//sheet1.SetUseDefaultTime(0);
			///sheet1.SetDataAutoTrim(0);
	  		isChangeDate = false;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
			if( sheet1.RowCount() == 0 ) return;
			var row = sheet1.LastRow()-1;
			for(var col = sheet1.SaveNameCol("manageNm")+1 ; col <= sheet1.LastCol(); col++) {
				sheet1.SetSumValue(0, col, sheet1.GetCellValue(row, col) );
			}
			//sheet1.SetSumValue(0, sheet1.SaveNameCol("total")-1, "[ 합  계  ]");
			sheet1.SetRowHidden(row, 1);
			

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function getTimeHm(timeM){
		var tempValue = Number(timeM);
		if ( tempValue != 0){
			var tMM       = (tempValue % 60 < 10)? "0"+(tempValue % 60) : (tempValue % 60);
			var value =  Math.floor(tempValue / 60) + ":" + tMM;

			return value;
		} else {
			return "";
		}
	}

/*
	// 기본근무 ~ .. 시간 sum
	function sumWorkCd(colName){
		var sumData = 0;
		var val     = 0;
		var hh, mm;
		// 시간계산해서 마지막 row에 set
		for (var i=1;i<sheet1.LastRow();i++){
			val = sheet1.GetCellValue(i, colName);
			//if (val.length == 4){
				sumData += parseInt(val.substring(0, 2), 10) *60 + parseInt(val.substring(2, 4));
			//}
		}
		hh = Math.floor(sumData/60);
		mm = (sumData - Math.floor(sumData/60) *60);
		sheet1.SetCellValue(sheet1.LastRow(), colName, hh.toString() + ((mm.toString().length<2)?":0":":") + mm.toString());
	}*/

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

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
						$("#searchOrgCd").val(result["orgCd"]);
						$("#searchOrgNm").val(result["orgNm"]);
						doAction1("Search");
					}
				}
			]
		});
		layerModal.show();
	}

	function clearCode(num) {

		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
			//doAction1("Search");
		} else {
			$('#name').val("");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<input id="defaultRow" name="defaultRow" type="hidden" >
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>근무일</th>
					<td>
						<input type="text" id="searchSymd" name="searchSymd"  class="date2" value="" /> ~
						<input type="text" id="searchEymd" name="searchEymd"  class="date2" value="" />
					</td>
					<th>근무유형</th>
					<td>
						<select id="searchWorkClassCd" name="searchWorkClassCd" > </select>
					</td>
					<th>보기</th>
					<td>
						<input id="searchColFlag1" name="searchColFlag" type="checkbox" class="checkbox" value="1" checked /><label for="searchColFlag1">&nbsp;근무&nbsp;</label>&nbsp;
						<input id="searchColFlag2" name="searchColFlag" type="checkbox" class="checkbox" value="2" checked /><label for="searchColFlag2">&nbsp;연장&nbsp;</label>&nbsp;
						<input id="searchColFlag3" name="searchColFlag" type="checkbox" class="checkbox" value="3" checked /><label for="searchColFlag3">&nbsp;야간&nbsp;</label>&nbsp;
						<input id="searchColFlag4" name="searchColFlag" type="checkbox" class="checkbox" value="4" checked /><label for="searchColFlag4">&nbsp;계&nbsp;</label>&nbsp;
					</td>
				</tr>
				<tr>
					<th>소속</th>
					<td>
					<c:choose>
					<c:when test="${ssnSearchType =='A'}">
						<input type="hidden" id="searchOrgCd" name="searchOrgCd" />
						<input type="text" id="searchOrgNm" name="searchOrgNm"  class="text readonly" readonly/><a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/>하위포함
					</c:when>
					<c:otherwise>
						<select id="searchOrgCd" name="searchOrgCd" > </select>
					</c:otherwise>
					</c:choose>
					</td>
					<th>직급</th>
					<td>
						<select id="searchJikgubCd" name="searchJikgubCd" > </select>
					</td>
					<th>사원구분</th>
					<td>
						<select id="searchManageCd" name="searchManageCd" > </select>
					</td>
					<th>사번/성명</th>
					<td>
						<input type="text" id="searchName" name="searchName" class="text" />
					</td>
					<td><a href="javascript:doAction1('Search');" class="btn dark" >조회</a> </td>
				</tr>
			</table>
		</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">일별근무현황</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR" >다운로드</a>
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