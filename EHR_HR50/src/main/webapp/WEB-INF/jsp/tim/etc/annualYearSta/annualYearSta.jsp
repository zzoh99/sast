<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연차사용현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var subSumCols = "";
	$(function() {
		
		var date = "${curSysYear}"+"-12-31";
		
		$("#searchYmd").val(date);
		
		$("#searchYmd").datepicker2({onReturn:function(){doAction1("Search");}});
		
		$("#searchYmd,#searchName").keyup(function() {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		
		$("#searchGubunCd").bind("change", function(e) {
			
			if( $("#searchGubunCd").val() == "A" ){
				sheet1.SetColHidden("orgNm", 0);
				sheet1.SetColHidden("sabun", 0);
				sheet1.SetColHidden("name", 0);
				sheet1.SetColHidden("jikgubNm", 0);
				sheet1.SetColHidden("empYmd", 0);
			}else if( $("#searchGubunCd").val() == "B" ){
				sheet1.SetColHidden("orgNm", 0);
				sheet1.SetColHidden("sabun", 1);
				sheet1.SetColHidden("name", 1);
				sheet1.SetColHidden("jikgubNm", 1);
				sheet1.SetColHidden("empYmd", 1);
			}else if( $("#searchGubunCd").val() == "C" ){
				sheet1.SetColHidden("orgNm", 1);
				sheet1.SetColHidden("sabun", 1);
				sheet1.SetColHidden("name", 1);
				sheet1.SetColHidden("jikgubNm", 1);
				sheet1.SetColHidden("empYmd", 1);
			}
			sheetInit();
			
			doAction1("Search");
		});
		
		$("#searchWorkType").bind("change", function(e) {
			init_sheet1();
			doAction1("Search");
		});

		//공통코드 한번에 조회
		var grpCds = "H20010,H10050";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		$("#multiJikgubCd").html(codeLists["H20010"][2]); //직급
		$("#searchWorkType").html(codeLists["H10050"][2]); //직군
		
		$("#multiJikgubCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});
		$("#multiJikgubCd").bind("change", function(e) {
			$("#searchJikgubCd").val(($("#multiJikgubCd").val()==null?"":getMultiSelect($("#multiJikgubCd").val())));
			doAction1("Search");
		});
		

		
		//Sheet 초기화
		init_sheet1();

		doAction1("Search");

	});

	//Sheet 초기화
	function init_sheet1(){
		
		sheet1.Reset();
		subSumCols = "";
		var str = "월별 사용연차 현황|";
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:1,FrozenColRight:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [];
		var v = 0 ;
		initdata1.Cols[v++] = {Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 };
		initdata1.Cols[v++] = {Header:"본부|본부",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"pOrgNm", 		KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"부서|부서",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			KeyField:0, Edit:0};
			
		initdata1.Cols[v++] = {Header:"사번|사번",				Type:"Text",   	Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"성명|성명",				Type:"Text",    Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			KeyField:0, UpdateEdit:0,	InsertEdit:1};
		initdata1.Cols[v++] = {Header:"직급|직급",				Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		KeyField:0, Edit:0};
			
		initdata1.Cols[v++] = {Header:"입사일자|입사일자",		Type:"Date",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"empYmd", 		KeyField:0, Format:"Ymd", Edit:0};
		initdata1.Cols[v++] = {Header:"발생연차|발생연차",		Type:"AutoSum",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"creCnt", 		KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"이월연차|이월연차",		Type:"Text",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"frdCnt", 		KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"총연차|총연차",			Type:"AutoSum",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"useCnt", 		KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"사용연차|사용연차",		Type:"AutoSum",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"usedCnt", 		KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"잔여연차|잔여연차",		Type:"AutoSum",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"restCnt", 		KeyField:0, Edit:0};
		
		initdata1.Cols[v++] = {Header:"하계휴가|하계휴가",		Type:"AutoSum",   	Hidden:1, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"modCnt", 		KeyField:0, Edit:0};

		initdata1.Cols[v++] = {Header:"잔여율|잔여율",			Type:"Float",  	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"restPer", 		KeyField:0, CalcLogic:"|restCnt|/|useCnt|*100", Format:"##\\%", Edit:0};
		
		initdata1.Cols[v++] = {Header:"휴가계획|휴가계획",       Type:"AutoSum",     Hidden:0, Width:60,     Align:"Center", ColMerge:0,  SaveName:"planCnt",        KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"계획대비\n사용연차|계획대비\n사용연차",  Type:"AutoSum",     Hidden:0, Width:60,     Align:"Center", ColMerge:0,  SaveName:"planUseCnt",        KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"미계획\n사용연차|미계획\n사용연차",  Type:"AutoSum",     Hidden:0, Width:60,     Align:"Center", ColMerge:0,  SaveName:"planNoCnt",    CalcLogic:"|usedCnt|-|planUseCnt|", Format:"", Edit:0};
       
		
		var titleList = ajaxCall("${ctx}/AnnualYearSta.do?cmd=getAnnualYearStaTitleList", $("#sheet1Form").serialize(), false);
		if (titleList != null && titleList.DATA != null) {
			for(var i = 0 ; i<titleList.DATA.length; i++) {
				initdata1.Cols[v++] = {Header:str+ titleList.DATA[i].lev+"월",  Type:"AutoSum",    Hidden:0, Width:55, 	Align:"Center", ColMerge:0,  SaveName:titleList.DATA[i].saveName,  KeyField:0, Edit:0 };
				subSumCols = subSumCols  + titleList.DATA[i].saveName+ "|";
			}
		}
			
		
 
		
		subSumCols = subSumCols + "creCnt|useCnt|modCnt|usedCnt|restCnt";
		
		IBS_InitSheet(sheet1, initdata1);
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		$(window).smartresize(sheetResize); sheetInit();
	}

	
	function checkList(){
		if( $("#searchYmd").val() == "" ){
			alert("기준일자를 입력 해주세요");
			$("#searchYmd").focus();
			return false;
		}
		return true;
	}
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if( !checkList() ) return;

				if( $("#searchGubunCd").val() == "A" ){
		        	var info = [{StdCol:"orgNm" , SumCols:subSumCols, CaptionCol:"orgNm"}];
					sheet1.ShowSubSum(info); 
				}else if( $("#searchGubunCd").val() == "B" ){
		        	var info = [{StdCol:"pOrgNm" , SumCols:subSumCols, CaptionCol:"orgNm"}];
					sheet1.ShowSubSum(info); 
					
				}else if( $("#searchGubunCd").val() == "C" ){
				}

				sheet1.DoSearch( "${ctx}/AnnualYearSta.do?cmd=getAnnualYearStaList", $("#sheet1Form").serialize());
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
				<th>기준일자</th>
				<td>
					<input type="text" id="searchYmd" name="searchYmd" class="date2 required" />
				</td>
				<!-- 
				<th>직군</th>
				<td>
					<select id="searchWorkType" name="searchWorkType"></select>
				</td>
				 -->
				<th>직급</th>
				<td>
					<select id="multiJikgubCd" name="multiJikgubCd" multiple></select>
					<input type="hidden" id="searchJikgubCd" name="searchJikgubCd" value=""/>
				</td>
				<th>조회구분</th>
				<td>
					<select id="searchGubunCd" name="searchGubunCd">
						<option value="A">개인별</option>
						<option value="B">부서별</option>
						<option value="C">본부별</option>
					</select>
				</td>
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchName" name="searchName" class="text w100" style="ime-mode:active;"/>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="button">조회</a>
				</td>
			</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">연차사용현황</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
