<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>휴가내역관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchYmd").datepicker2();//.val("${curSysYyyyMMddHyphen}");
		$("#searchYear").val("${curSysYear}");

		$("#searchYear").change(function (){
			getCommonCodeList();
		})

		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
		});
		
		$("#searchGntCd, #searchAgreeYn1, #searchAgreeYn2, #searchEmpYm, #searchSortm, #searchManageCd, #searchOneyearYn, #searchWorkType").bind("change", function(event) {
			doAction1("Search") ;
		});
		
        $("#searchYear, #searchYmd, #searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		init_sheet();

		doAction1("Search");
	});
		
	function init_sheet(){ 


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:6};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo'       mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete'   mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd'  mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='gntCdV7'   mdef='휴가구분'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"<sht:txt mid='orgNm'     mdef='소속'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='sabun'     mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='name'      mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"<sht:txt mid='jikgubNm'  mdef='직급'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"사원구분",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"직군",											Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='empYmdV3'  mdef='입사일자'/>",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"연차기산일",										Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"yearYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='retYmdV1'  mdef='퇴사일자'/>",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='inqSYmd'   mdef='사용시작일'/>",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"useSYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='inqEYmd'   mdef='사용종료일'/>",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"useEYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			
			{Header:"<sht:txt mid='gntCnt'    mdef='발생일수'/>\n(A)",		Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"creCnt",			KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"<sht:txt mid='frdCntV1'  mdef='이월일수'/>\n(B)",		Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"frdCnt",			KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			
			{Header:"하계휴가비\n차감일수\n(C)",								Type:"Float",		Hidden:1,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"modCnt",			KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"<sht:txt mid='useCntV1'  mdef='사용가능일수'/>\n(C=A+B)",	Type:"Float",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"useCnt",			KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"<sht:txt mid='usedCntV1' mdef='사용일수'/>\n(D)",		Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"usedCnt",			KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"<sht:txt mid='restCntV1' mdef='잔여일수'/>\n(C-D)",		Type:"Float",		CalcLogic:"|useCnt|-|usedCnt|",	Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"restCnt",	KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"1년미만\n여부",									Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"oneyearUnderYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			
			{Header:"<sht:txt mid='comCnt'    mdef='보상일'/>",		Type:"Float",		Hidden:1,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"comCnt",			KeyField:0,	Format:"Float",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"<sht:txt mid='note'      mdef='비고'/>",			Type:"Text",		Hidden:0,	Width:165,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

			{Header:"년도",	Hidden:1,	SaveName:"yy"},
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetHeaderRowHeight(50);

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
						sheet1.SetCellValue(gPRow, "name",		rv["name"] );
						sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
						sheet1.SetCellValue(gPRow, "yearYmd",	rv["yearYmd"] );
						sheet1.SetCellValue(gPRow, "retYmd",	rv["retYmd"] );
						sheet1.SetCellValue(gPRow, "manageNm",	rv["manageNm"] );
						sheet1.SetCellValue(gPRow, "workTypeNm",rv["workTypeNm"] );
					}
				}
			]
		});
		
		var gntCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getGntListTTIM007"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("gntCd", 		{ComboText:"|"+gntCd[0], ComboCode:"|"+gntCd[1]} );
		$("#searchGntCd").html(gntCd[2]);

		getCommonCodeList();

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		/*
		var bizPlaceCdList = "";
		if ("${ssnSearchType}" != "A"){
			var param = "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList"+param,false).codeList, "");	//사업장
		} else {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "<tit:txt mid='103895' mdef='전체' />");	//사업장
		}
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		*/
		
		$(window).smartresize(sheetResize); sheetInit();
	}

	function getCommonCodeList() {
		let searchYear = $("#searchYear").val();
		let baseSYmd = "";
		let baseEYmd = "";

		if (searchYear !== "") {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}

		//사원구분
		var manageCdList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchManageCd").html(manageCdList[2]);
		//직군
		var workTypeList     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchWorkType").html(workTypeList[2]);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			/*if($("#searchYear").val() == "" && $("#searchYmd").val() == "") {
				alert("기준년도 또는 기준일자를 입력 해주세요.");
				$("#searchYear").focus();
				return;
			}*/
			sheet1.DoSearch( "${ctx}/AnnualHoliday.do?cmd=getAnnualHolidayList", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "yy",$("#searchYear").val());
			sheet1.SetCellValue(row, "gntCd",$("#searchGntCd").val());

			break;
		case "Save":

			if(!dupChk(sheet1,"yy|sabun|gntCd|useSYmd", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AnnualHoliday.do?cmd=saveAnnualHoliday&method=batch", $("#srchFrm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Copy":		sheet1.DataCopy();
			break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"yy|gntCd|sabun|useSYmd|useEYmd|creCnt|useCnt|usedCnt|comCnt"});
			break;
		case "Prc1":

			if( $("#searchYear").val() == "" ){
		    	alert("기준년도를 입력 해주세요.");
		    	$("#searchYear").focus();
		    	return;
			}
					
			
	        if (!confirm("${curSysYyyyMMddHyphen} 하계휴가차감 갯수를 생성 하시겠습니까?")) return;
	        
			progressBar(true) ;

			setTimeout(
				function(){
					var param = "&searchWorkType=A&searchYear="+$("#searchYear").val();
			    	
					var data = ajaxCall("${ctx}/AnnualHoliday.do?cmd=annualHolidayPrc", param,false);
					if(data.Result.Code == null) {
						doAction1("Search");
			    		alert("정상 처리되었습니다.");
				    	progressBar(false) ;
			    	} else {
				    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
				    	progressBar(false) ;
			    	}
				}
			, 100);
			break;	
		case "Prc2":

			if( $("#searchYear").val() == "" ){
		    	alert("기준년도를 입력 해주세요.");
		    	$("#searchYear").focus();
		    	return;
			}
					
			
	        if (!confirm("${curSysYyyyMMddHyphen} 하계휴가를 생성 하시겠습니까?")) return;
	        
			progressBar(true) ;

			setTimeout(
				function(){
					var param = "&searchWorkType=B&searchYear="+$("#searchYear").val();
			    	
					var data = ajaxCall("${ctx}/AnnualHoliday.do?cmd=annualHolidayPrc", param,false);
					if(data.Result.Code == null) {
						doAction1("Search");
			    		alert("정상 처리되었습니다.");
				    	progressBar(false) ;
			    	} else {
				    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
				    	progressBar(false) ;
			    	}
				}
			, 100);
			break;	
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "name" && KeyCode == 46) {
	                sheet1.SetCellValue(Row, "sabun",	"" );
	                sheet1.SetCellValue(Row, "name",	"" );
	                sheet1.SetCellValue(Row, "orgNm",	"" );
	                sheet1.SetCellValue(Row, "jikgubNm","" );
	                sheet1.SetCellValue(Row, "empYmd",	"" );
	                sheet1.SetCellValue(Row, "yearYmd",	"" );
	                sheet1.SetCellValue(Row, "retYmd",	"" );
	                sheet1.SetCellValue(Row, "manageNm",	"" );
	                sheet1.SetCellValue(Row, "workTypeNm",	"" );
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
			/*if(sheet1.ColSaveName(Col) == "creCnt" || sheet1.ColSaveName(Col) == "usedCnt" || sheet1.ColSaveName(Col) == "frdCnt" || sheet1.ColSaveName(Col) == "useCnt") {
				if (parseInt(sheet1.GetCellValue(Row, "restCnt")) > 32){
					sheet1.SetCellValue(Row, "comCnt",	"32");
				} else {
					sheet1.SetCellValue(Row, "comCnt",	sheet1.GetCellValue(Row, "restCnt"));
				}
			}*/
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}


	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			/* 20210106 자동완성 사용으로 인한 주석 처리
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup";
				var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
			}
			*/
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
            sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
            sheet1.SetCellValue(gPRow, "name",		rv["name"] );
            sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
            sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
            sheet1.SetCellValue(gPRow, "yearYmd",	rv["yearYmd"] );
            sheet1.SetCellValue(gPRow, "retYmd",	rv["retYmd"] );
            sheet1.SetCellValue(gPRow, "manageNm",	rv["manageNm"] );
            sheet1.SetCellValue(gPRow, "workTypeNm",rv["workTypeNm"] );
	    }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="sheet_search outer">
	<form id="srchFrm" name="srchFrm" >
		<table>
		<tr>
			<th><tit:txt mid='112270' mdef='기준년도'/></th>
			<td>
				<input id="searchYear" name="searchYear" type="text" class="text w50 center" maxlength="4"/>
			</td>
			<th class="hide">기준일자</th>
			<td class="hide">
				<input id="searchYmd" name="searchYmd" type="text" class="date2 w80 center"/>
			</td>
			<th><tit:txt mid='L1705100000155' mdef='휴가구분'/></th>
			<td>
				<select id="searchGntCd" name="searchGntCd">
				</select>
			</td>
			<th>연차기산월(입사월)</th>
			<td>
				<select id="searchEmpYm" name="searchEmpYm">
					<option value="">전체</option>
					<option value="01">1월</option><option value="02">2월</option><option value="03">3월</option>
					<option value="04">4월</option><option value="05">5월</option><option value="06">6월</option>
					<option value="07">7월</option><option value="08">8월</option><option value="09">9월</option>
					<option value="10">10월</option><option value="11">11월</option><option value="12">12월</option>
				</select>
			</td>
			<th class="hide">정렬</th>
			<td class="hide">
				<select id="searchSort" name="searchSort">
					<option value="">직제순</option>
					<option value="day">일자순</option>
				</select>
			</td>
			
			<th><label for="searchOneyearYn">&nbsp;1년미만연차&nbsp;</label></th>
			<td>
				<input id="searchOneyearYn" name="searchOneyearYn" type="checkbox" class="checkbox" value="Y" checked/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid="104279" mdef="소속" /> </th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" />
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchSabunName" name="searchSabunName" type="text" class="text"/>
			</td>
			<th>직군</th>
			<td>
				<select id="searchWorkType" name="searchWorkType"></select>
			</td>
			<th><tit:txt mid='103784' mdef='사원구분' /></th>
			<td>
				<select id="searchManageCd" name="searchManageCd"></select>
			</td>
			
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid="search" mdef="조회"/>
			</td>
		</tr>
		</table>
		</form>
	</div>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">휴가내역관리</li>
			<li class="btn">
				<%--
				<a href="javascript:doAction1('Prc1')" class="button authA ">하계휴가차감(사무직)</a>
				<a href="javascript:doAction1('Prc2')" class="button authA ">하계휴가생성(생산직)</a>
				--%>
				&nbsp;&nbsp;&nbsp;
				<btn:a href="javascript:doAction1('LoadExcel')" css="btn outline_gray authA" mid='upload' mdef="업로드"/>
				<btn:a href="javascript:doAction1('DownTemplate')" css="btn outline_gray authA" mid='down2ExcelV1' mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>