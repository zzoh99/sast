<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>개인별주근무현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
        $("#searchSymd").datepicker2({
            startdate:"searchEymd",
            onReturn:function(date){
				getCommonCodeList();
                setOrgCombo();
            }
        }).val("${curSysYyyyMMHyphen}-01");
		
        $("#searchEymd").datepicker2({
            enddate:"searchSymd",
            onReturn:function(date){
				getCommonCodeList();
            }
        }).val('<%=DateUtil.getLastDateOfMonthString(DateUtil.getCurrentTime("yyyy-MM-dd"))%>'); //말일

        $("#searchSymd, #searchEymd").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); } 
        });
        

		$("#searchWorkType, #searchOrgCd, #searchOrgType").bind("change", function(e) {
			doAction1("Search");
		});

		//공통코드 한번에 조회
		getCommonCodeList();

		$("#multiJikgubCd").bind("change", function(e) {
			$("#searchJikgubCd").val(($("#multiJikgubCd").val()==null?"":getMultiSelect($("#multiJikgubCd").val())));
			doAction1("Search");
		});
		
		setOrgCombo(); //조직콤보
        $("#searchOrgCd").val("${ssnOrgCd}");
		
		//Sheet 초기화
		init_sheet1();

		doAction1("Search");

	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchSymd").val();
		let baseEYmd = $("#searchEymd").val();

		let grpCds = "H20010,H10050";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params,false).codeList, "");
		$("#multiJikgubCd").html(codeLists["H20010"][2]); //직급
		$("#searchWorkType").html("<option value=''>전체</option>"+codeLists["H10050"][2]); //직군

		$("#multiJikgubCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});
	}
	
	//조직콤보
	function setOrgCombo(){
		var param ="&searchYmd="+$("#searchSymd").val();
		var orgCdlist = convCode( ajaxCall("${ctx}/WtmPsnlWeekWorkSta.do?cmd=getPsnlWeekWorkStaOrgList", param, false).DATA, "");
		$("#searchOrgCd").html(orgCdlist[2]);
        $("#searchOrgCd").val($("#oldSearchOrgCd").val());
	}

	//Sheet 초기화
	function init_sheet1(){
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:1,FrozenColRight:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

        initdata1.Cols = [
            {Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
            {Header:"본부|본부",				Type:"Text",   	Hidden:1, Width:120, 	Align:"Center", ColMerge:0,  SaveName:"pOrgNm", 		KeyField:0, Edit:0},
            {Header:"부서|부서",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Center", ColMerge:0,  SaveName:"orgNm", 			KeyField:0, Edit:0},
			
            {Header:"사번|사번",				Type:"Text",   	Hidden:0, Width:70, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:0, Edit:0},
			{Header:"성명|성명",				Type:"Text",    Hidden:0, Width:70,		Align:"Center", ColMerge:0,  SaveName:"name", 			KeyField:0, UpdateEdit:0,	InsertEdit:1},
			{Header:"직급|직급",				Type:"Text",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		KeyField:0, Edit:0},
			{Header:"직군|직군",              Type:"Text",    Hidden:0, Width:70,    Align:"Center", ColMerge:0,  SaveName:"workTypeNm",       KeyField:0, Edit:0},
            
			{Header:"정상근무|정상근무",       Type:"AutoSum",    Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"workTime",     KeyField:0, Edit:0},
			{Header:"연장근무|연장근무",       Type:"AutoSum",    Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"otTime",       KeyField:0, Edit:0},
			{Header:"기본휴게시간|기본휴게시간",       Type:"AutoSum",    Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"refTime",      KeyField:0, Edit:0},
			{Header:"연장휴게시간|연장휴게시간",  Type:"AutoSum",    Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"otRefTime",    KeyField:0, Edit:0},
			{Header:"실근무시간|실근무시간",    Type:"AutoSum",    Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"realTime",     KeyField:0, Edit:0},
			{Header:"주평균|주평균",          Type:"AutoAvg",    Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"weekAvg",      KeyField:0, Edit:0, Format:"#0.#"},
			{Header:"잔여시간|잔여시간",       Type:"AutoSum",    Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"weekRem",      KeyField:0, Edit:0},
		];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
		$(window).smartresize(sheetResize); sheetInit();
	}

    function checkList(){
        if( $("#searchSymd").val() == "" ){
            alert("근무일을 입력 해주세요");
            $("#searchSymd").focus();
            return false;
        }
        if( $("#searchEymd").val() == "" ){
            alert("근무일을 입력 해주세요");
            $("#searchEymd").focus();
            return false;
        }
        return true;
    }
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":

                if( !checkList() ) return;
                
                $("#oldSearchOrgCd").val($("#searchOrgCd").val());
                
                var sXml = sheet1.GetSearchData("${ctx}/WtmPsnlWeekWorkSta.do?cmd=getPsnlWeekWorkStaList", $("#sheet1Form").serialize() );
                sXml = replaceAll(sXml,"weekAvgColor", "weekAvg#FontColor");
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
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sheet1Form" id="sheet1Form" method="post">
        <input type="hidden" id="oldSearchOrgCd" name="oldSearchOrgCd" />
		<div class="sheet_search outer">
			<table>
			<tr>
				<th>근무일</th>
				<td>
                    <input id="searchSymd" name="searchSymd" type="text" class="date required" readonly/> ~
                    <input id="searchEymd" name="searchEymd" type="text" class="date required" readonly/>
				</td>   
                <th>직군</th>
                <td>
                    <select id="searchWorkType" name="searchWorkType"></select>
                </td>
			</tr>
			<tr>
                <th>부서</th>
                <td>
                    <select id="searchOrgCd" name="searchOrgCd"></select>
                    <input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/>하위포함
                </td>
				<th>직급</th>
				<td>
					<select id="multiJikgubCd" name="multiJikgubCd" multiple></select>
					<input type="hidden" id="searchJikgubCd" name="searchJikgubCd" value=""/>
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
			<li class="txt">개인별주근무현황</li>
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
