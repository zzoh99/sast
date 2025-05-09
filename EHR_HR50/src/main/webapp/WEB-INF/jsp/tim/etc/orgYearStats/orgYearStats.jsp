<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104539' mdef='소속원연차사용현황'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22,FrozenCol:5};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No|No",								Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"세부\n내역|세부\n내역|세부\n내역",			Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"근무지|근무지|근무지",						Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationCd",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속|소속",							Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번|사번|사번",							Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명|성명",							Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"호칭|호칭|호칭",							Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직종|직종|직종",							Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"급여유형|급여유형|급여유형",					Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"payTypeNm",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"직급|직급|직급",							Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"직위|직위|직위",							Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"입사일|입사일|입사일",						Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"구분|구분|구분",							Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"gntCd",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"구분|구분|구분",							Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"gntNm",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"퇴직일|퇴직일|퇴직일",						Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",   	KeyField:0,		Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"연차|당해년도\n발생일수|당해년도\n발생일수",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"yUseCnt",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"연차|전년도\n이월일수|전년도\n이월일수",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"frdCnt",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"연차|당해년도\n사용일수|당해년도\n사용일수",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"yUsedCnt",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"연차|잔여일수|잔여일수",						Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"yRestCnt",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"사용합계|1월~12월|연차",					Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"sumYCnt",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"사용합계|1월~12월|연차",					Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"sumYH1Cnt",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|1월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt1",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|1월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt1",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|2월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt2",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|2월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt2",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|3월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt3",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|3월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt3",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|4월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt4",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|4월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt4",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|5월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt5",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|5월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt5",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|6월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt6",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|6월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt6",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|7월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt7",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|7월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt7",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|8월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt8",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|8월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt8",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|9월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt9",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|9월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt9",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|10월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt10",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|10월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt10",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|11월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt11",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|11월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt11",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|12월|연차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yCnt12",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"월별사용현황|12월|반차",						Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"yH1Cnt12",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"년월|년월|년월",							Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"sYm",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:6 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);


		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var bizPlaceCdList = "";
		if(allFlag) {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		//근무지 관리자권한만 전체근무지 보이도록, 그외는 권한근무지만.
		url     = "queryId=getLocationCdListAuth";
		allFlag = true;
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
		sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCdList[0], ComboCode:"|"+locationCdList[1]});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $("#name,#orgCd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
        $("#searchBizPlaceCd").bind("change",function(event){
			doAction1("Search");
		});

        $("#sYmd").datepicker2();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#sYmd").val() == "") {
				alert("<msg:txt mid='110025' mdef='기준일을 입력하여 주십시오.'/>");
				return;
			}

			/*var param = "sYmd="+$("#sYmd").val().replace(/-/gi,"")
					  + "&name="+$("#name").val()
					  + "&orgCd="+$("#orgCd").val()
					  + "&retireYn="+$(':radio[name="retireYn"]:checked').val();
			*/

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getOrgYearStatsList", $("#mySheetForm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
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

	// 팝업 클릭시 발생
	function sheet1_OnClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "ibsImage") {
				if(!isPopup()) {return;}
				gPRow = "";
				pGubun = "viewPsnlAnnualStaPop";

				var args    = new Array();
				args["searchSabun"] = sheet1.GetCellValue(Row,"sabun");
				//args["searchYm"] = sheet1.GetCellValue(Row,"sYm");
				args["sdate"] = sheet1.GetCellValue(Row,"sYm").substring(0,4)+"0101";
				args["edate"] = sheet1.GetCellValue(Row,"sYm").substring(0,4)+"1231";
				var rv = openPopup("/View.do?cmd=viewPsnlAnnualStaPop", args, "740","520");
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='104281' mdef='근무지'/></th>
				<td>
					<select id="searchLocationCd" name="searchLocationCd"> </select>
				</td>
				<th><tit:txt mid='113824' mdef='사업장'/></th>
				<td>
					<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
				</td>
				<th><tit:txt mid='104279' mdef='소속'/></th>
				<td>
					<input type="text" id="orgCd" name="orgCd" class="text"/>
				</td>
				<th><tit:txt mid='104330' mdef='사번/성명'/></th>
				<td>
					<input id="name" name="name" type="text" class="text"/>
				</td>
				<th><tit:txt mid='104535' mdef='기준일'/></th>
				<td>
					<input id="sYmd" name="sYmd" type="text" class="date2 required" value="${curSysYyyyMMdd}"/>
				</td>
				<td>
					<span><tit:txt mid='104540' mdef='퇴직자포함&nbsp;'/><input name="retireYn" type="radio" value="Y" class="radio" checked/></span>
				</td>
				<td>
					<span><tit:txt mid='103941' mdef='퇴직자제외&nbsp;'/><input name="retireYn" type="radio" value="N" class="radio"/></span>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='orgYearStats' mdef='휴가사용추이'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>