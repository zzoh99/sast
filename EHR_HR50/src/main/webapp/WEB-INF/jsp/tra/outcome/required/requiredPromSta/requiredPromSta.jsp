<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>승격대상자 필수교육 이수이력</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {

		$("#searchOrgName,#searchSabunName").keyup(function() {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				setBaseYmdCombo();
				doAction1("Search");
			}
		});
		$("#searchYear").change(function() {
			setBaseYmdCombo();
			getCommonCodeList();
		});


		$("#searchGubunCd, #searchEduConfYn, #searchBaseYmd, #searchJikgubCd, #searchDelayGubun").on("change", function(e) {
			doAction1("Search");
		})
		
		setBaseYmdCombo();
		
		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchBaseYmd").change();

	});
	function setBaseYmdCombo(){
		if( $("#searchYear").val() == ""  || $("#searchYear").val().length != 4  ){
			return;
		}
		//승진기준일 콤보
		var ymdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getRequiredPromStaBaseYmd&searchYear="+$("#searchYear").val(), false).codeList, "");
		$("#searchBaseYmd").html(ymdList[2]);
		
	}

	//Sheet 초기화
	function init_sheet1(){
		var str1 = "Lv1. 역량강화 교육(승격자, 사원1년차)";
		var str2 = "Lv2. 사전 역량강화 교육";
		var str3 = "승격누락자 보충교육";
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:2,FrozenColRight:2};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			//{Header:"삭제|삭제",				Type:"${sDelTy}", Hidden:Number("${sDelTy}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			//{Header:"상태|상태",				Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"세부\n내역|세부\n내역",		Type:"Image", 	Hidden:0, Width:45, 	Align:"Center", ColMerge:0,  SaveName:"detail",			Edit:0, Sort:0, Cursor:"Pointer" },
			{Header:"승진기준일|승진기준일",		Type:"Date",	Hidden:1, Width:100, 	Align:"Center",	ColMerge:0,	 SaveName:"baseYmd",   		KeyField:0,	Format:"Ymd", 	Edit:0 },
			{Header:"본부|본부",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"pOrgNm", 		KeyField:0, Edit:0},
			{Header:"부서|부서",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			KeyField:0, Edit:0},
			
			{Header:"사번|사번",				Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:0, Edit:0},
			{Header:"성명|성명",				Type:"Text",    Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			KeyField:0, Edit:0},
			{Header:"직급|직급",				Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		KeyField:0, Edit:0},

			{Header:"현 직급|승격일",			Type:"Date",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"pmtCurrYmd", 	KeyField:0, Format:"Ymd", 	Edit:0 },
			{Header:"현 직급|년차",				Type:"Int",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"pmtCurrYear", 	KeyField:0, Edit:0},
			{Header:"지체여부|지체여부",			Type:"Text",  	Hidden:0, Width:70,		Align:"Center", ColMerge:0,  SaveName:"delayGubun",		KeyField:0, Edit:0},
			
			{Header:str1+"|대상여부",			Type:"Image",   Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"eduYnA", 		KeyField:0, Edit:0 },
			{Header:str1+"|격",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"a1", 			KeyField:0, Edit:0 },
			{Header:str1+"|익",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"a2", 			KeyField:0, Edit:0 },
			{Header:str1+"|동",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"a3", 			KeyField:0, Edit:0 },
			{Header:str2+"|대상여부",			Type:"Image",   Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"eduYnB", 		KeyField:0, Edit:0 },
			{Header:str2+"|격",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"b1", 			KeyField:0, Edit:0 },
			{Header:str2+"|익",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"b2", 			KeyField:0, Edit:0 },
			{Header:str2+"|동",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"b3", 			KeyField:0, Edit:0 },
			{Header:str3+"|대상여부",			Type:"Image",   Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"eduYnC", 		KeyField:0, Edit:0 },
			{Header:str3+"|격",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"c1", 			KeyField:0, Edit:0 },
			{Header:str3+"|익",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"c2", 			KeyField:0, Edit:0 },
			{Header:str3+"|동",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"c3", 			KeyField:0, Edit:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jikgubCd"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"promCnt"},
  			
			{Header:"필수교육\n이수건수|필수교육\n이수건수",Type:"Text",   Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"finEduCnt", 		KeyField:0, Edit:0},
			{Header:"최종\n이수여부|최종\n이수여부",Type:"Text",   Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"finEduYn", 		KeyField:0, Edit:0},
			
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");

 		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

 		getCommonCodeList();
	}

	function getCommonCodeList() {
		if( $("#searchYear").val() == ""  || $("#searchYear").val().length != 4  ){
			return;
		}

		let baseSYmd = $("#searchYear").val() + "-01-01";
		let baseEYmd = $("#searchYear").val() + "-12-31";

		//공통코드 한번에 조회
		let grpCds = "L16010,L10090,H20010";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		sheet1.SetColProperty("gubunCd",  	{ComboText:"|"+codeLists["L16010"][0], ComboCode:"|"+codeLists["L16010"][1]} ); //교육구분
		sheet1.SetColProperty("eduLevel",  	{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} ); //과정난이도

		$("#searchGubunCd").html(codeLists["L16010"][2]); //교육구번
		$("#searchJikgubCd").html(codeLists["H20010"][2]); //직급
		$("#searchEduLevel").html(codeLists["L10090"][2]); //과정난이도
	}
	
	function checkList(){
		if( $("#searchYear").val() == "" ){
			alert("기준년도를 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}

		if( $("#searchYear").val().length != 4 ){
			alert("기준년도를 정확히 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}
		return true;
	}
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if( !checkList() ) return;
				var sXml = sheet1.GetSearchData("${ctx}/RequiredPromSta.do?cmd=getRequiredPromStaList", $("#sheet1Form").serialize() );
				sXml = replaceAll(sXml,"a1FontColor", "a1#FontColor");
				sXml = replaceAll(sXml,"a2FontColor", "a2#FontColor");
				sXml = replaceAll(sXml,"a3FontColor", "a3#FontColor");
				sXml = replaceAll(sXml,"b1FontColor", "b1#FontColor");
				sXml = replaceAll(sXml,"b2FontColor", "b2#FontColor");
				sXml = replaceAll(sXml,"b3FontColor", "b3#FontColor");
				sXml = replaceAll(sXml,"c1FontColor", "c1#FontColor");
				sXml = replaceAll(sXml,"c2FontColor", "c2#FontColor");
				sXml = replaceAll(sXml,"c3FontColor", "c3#FontColor");
				sheet1.LoadSearchData(sXml );
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

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

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;

			if( sheet1.ColSaveName(Col) == "detail" ) {

				gPRow = Row;
				pGubun = "eduListPopup";
				var args 	= new Array();
				args["baseYmd"]  = sheet1.GetCellValue(Row, "baseYmd");
				args["sabun"]    = sheet1.GetCellValue(Row, "sabun");  
				args["jikgubCd"] = sheet1.GetCellValue(Row, "jikgubCd");
				args["promCnt"] = sheet1.GetCellValue(Row, "promCnt");
				args["name"] = sheet1.GetCellValue(Row, "name");
				args["jikgubNm"] = sheet1.GetCellValue(Row, "jikgubNm");
				args["delayGubun"] = sheet1.GetCellValue(Row, "delayGubun");

				let modalLayer = new window.top.document.LayerModal({
					id: 'requiredPromStaLayer',
					url: '/RequiredPromSta.do?cmd=viewRequiredPromStaLayer&authPg=R',
					parameters: args,
					width: 700,
					height: 650,
					title: '필수교육 리스트',
					trigger: [
						{
							name: 'requiredPromStaLayerTrigger',
							callback: function(rv) {
							}
						}
					]
				});
				modalLayer.show();

			}
		}
		catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sheet1Form" id="sheet1Form" method="post">
		<div class="sheet_search outer">
			<table>
			<tr>
				<th>기준년도</th>
				<td>
					<input type="text" id="searchYear" name="searchYear" class="text required w70 center" value="${curSysYear}" maxlength="4"/>
				</td>
				<th>승진기준일</th>
				<td>
					<select id="searchBaseYmd" name="searchBaseYmd"></select>
				</td>
				<th>지체여부</th>
				<td>
					<select id="searchDelayGubun" name="searchDelayGubun">
						<option value="">전체</option>
						<option value="0">적시</option>
						<option value="1">지체</option>
					</select>
				</td>
				<th>최종이수여부</th>
				<td>
					<select id="searchEduConfYn" name="searchEduConfYn">
						<option value="">전체</option>
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</td>
			</tr>
			<tr>	
				<th>부서명</th>
				<td>
					<input type="text" id="searchOrgName" name="searchOrgName" class="text w100" style="ime-mode:active;" />
				</td>
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text w100" style="ime-mode:active;" />
				</td>
				<th>직급</th>
				<td>
					<select id="searchJikgubCd" name="searchJikgubCd"></select>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">승격대상자 교육이수현항</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>

