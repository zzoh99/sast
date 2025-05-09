<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>필수교육대상자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {

		$("#searchEduCourseNm,#searchSabunName").keyup(function() {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchYear").change(function () {
			getCommonCodeList();
		});

		$("#searchGubunCd, #searchEduAppYn, #searchEduConfYn, #searchReAppYn, #searchJikgubCd").on("change", function(e) {
			doAction1("Search");
		})
		
		$("#searchEduYm").datepicker2({ymonly:true,onReturn:function(){doAction1("Search");}});
		
		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	//Sheet 초기화
	function init_sheet1(){
		var str = "월별 과목 이수현황|";
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:1,FrozenColRight:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			//{Header:"삭제|삭제",				Type:"${sDelTy}", Hidden:Number("${sDelTy}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			//{Header:"상태|상태",				Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"교육구분|교육구분",			Type:"Combo",   Hidden:0, Width:170, 	Align:"Center", ColMerge:0,  SaveName:"gubunCd", 		KeyField:0, UpdateEdit:0,	InsertEdit:1},
			{Header:"과정난이도|과정난이도",		Type:"Combo",   Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"eduLevel", 		KeyField:0, UpdateEdit:0,	InsertEdit:1},
			{Header:"과정명|과정명",			Type:"Text",    Hidden:0, Width:250, 	Align:"Left", 	ColMerge:0,  SaveName:"eduCourseNm", 	KeyField:0, UpdateEdit:0,	InsertEdit:1},
			{Header:"본부|본부",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"pOrgNm", 		KeyField:0, Edit:0},
			{Header:"부서|부서",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			KeyField:0, Edit:0},
			
			{Header:"사번|사번",				Type:"Text",   	Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:0, Edit:0},
			{Header:"성명|성명",				Type:"Text",    Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			KeyField:0, UpdateEdit:0,	InsertEdit:1},
			{Header:"직위|직위",				Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		KeyField:0, Edit:0},
			{Header:"직책|직책",				Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		KeyField:0, Edit:0},
			{Header:"직급|직급",				Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		KeyField:0, Edit:0},
			{Header:"직급년차|직급년차",			Type:"Int",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"jikgubYear", 	KeyField:0, Edit:0},
			{Header:"직무명|직무명",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Center", ColMerge:0,  SaveName:"jobNm", 			KeyField:0, Edit:0},
			
			{Header:str+"1월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon01", 			KeyField:0, Edit:0 },
			{Header:str+"2월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon02", 			KeyField:0, Edit:0 },
			{Header:str+"3월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon03", 			KeyField:0, Edit:0 },
			{Header:str+"4월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon04", 			KeyField:0, Edit:0 },
			{Header:str+"5월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon05", 			KeyField:0, Edit:0 },
			{Header:str+"6월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon06", 			KeyField:0, Edit:0 },
			{Header:str+"7월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon07", 			KeyField:0, Edit:0 },
			{Header:str+"8월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon08", 			KeyField:0, Edit:0 },
			{Header:str+"9월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon09", 			KeyField:0, Edit:0 },
			{Header:str+"10월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon10", 			KeyField:0, Edit:0 },
			{Header:str+"11월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon11", 			KeyField:0, Edit:0 },
			{Header:str+"12월",				Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"mon12", 			KeyField:0, Edit:0 },
			{Header:"최종\n이수여부|최종\n이수여부",Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"eduConfYn", 		KeyField:0, Edit:0},
			
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");
		getCommonCodeList();
	}

	function getCommonCodeList() {
		if( $("#searchYear").val() == ""  || $("#searchYear").val().length != 4  ){
			return;
		}

		let searchYear = $("#searchYear").val();
		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== '') {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}
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
				sheet1.ShowProcessDlg("Search");
				setTimeout(function(){
					var sXml = sheet1.GetSearchData("${ctx}/RequiredSta.do?cmd=getRequiredStaList", $("#sheet1Form").serialize() );
					for( var i=1 ; i<=12 ; i++){
						var str = (i<10)?"0":"";
						sXml = replaceAll(sXml,"mon"+str+i+"FontColor", "mon"+str+i+"#FontColor");
					}
					sXml = replaceAll(sXml,"eduConfYnFontColor", "eduConfYn#FontColor");
					sheet1.LoadSearchData(sXml );
				},100);
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
				<th>교육구분</th>
				<td>
					<select id="searchGubunCd" name="searchGubunCd"></select>
				</td>
				<th>최종수료여부</th>
				<td>
					<select id="searchEduConfYn" name="searchEduConfYn">
						<option value="">전체</option>
						<option value="1">수료</option>
						<option value="0">미수료</option>
					</select>
				</td>
			</tr>
			<tr>	
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text w100" style="ime-mode:active;" />
				</td>
				<th>직급</th>
				<td>
					<select id="searchJikgubCd" name="searchJikgubCd"></select>
				</td>
				<th>과정명</th>
				<td>
					<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w150" style="ime-mode:active;" />
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
			<li class="txt">필수교육 이수현황</li>
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
