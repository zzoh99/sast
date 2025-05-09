<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>부서별월근태현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("#searchYm").datepicker2({
		    ymonly:true, 
			onReturn:function(){
				getCommonCodeList();
				setOrgCombo();
		        $("#searchOrgCd").val($("#oldSearchOrgCd").val());
		        init_sheet1();
				doAction1("Search");
			}
		});
		
		$("#searchWorkType, #searchOrgCd").bind("change", function(e) {
			doAction1("Search");
		});

		//공통코드 한번에 조회
		getCommonCodeList();
		$("#searchJikgubCd").bind("change", function(e) {
			$("#jikgubCd").val(($("#searchJikgubCd").val()==null?"":getMultiSelect($("#searchJikgubCd").val())));
			doAction1("Search");
		});
		
		setOrgCombo(); //조직콤보
        $("#searchOrgCd").val("${ssnOrgCd}");
		
		//Sheet 초기화
		init_sheet1();

		doAction1("Search");

	});

	function getCommonCodeList() {
		let searchYm = $("#searchYm").val();

		if (searchYm === "") {
			return;
		}
		let baseSYmd = searchYm + "-01";
		let baseEYmd = getLastDayOfMonth(searchYm);

		let grpCds = "H20010,H10050";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd  + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");
		$("#searchJikgubCd").html(codeLists["H20010"][2]); //직급
		$("#searchWorkType").html("<option value=''>전체</option>"+codeLists["H10050"][2]); //직군

		$("#searchJikgubCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
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
	
	//조직콤보
	function setOrgCombo(){
		var orgCd = convCode( ajaxCall("${ctx}/OrgMonthWorkSta.do?cmd=getOrgMonthWorkStaOrgList","searchYmd="+$("#searchYm").val(),false).DATA, "");
		$("#searchOrgCd").html(orgCd[2]);
	}

	//Sheet 초기화
	function init_sheet1(){
	    
	    if( $("#oldSearchYm").val() == $("#searchYm").val() ) return; 
	    
		sheet1.Reset();
		
		var str = "[ " +($("#searchYm").val()).substring(0,4)+"년 " + ($("#searchYm").val()).substring(5,7)+"월 ] 일별 근태 현황|";
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:1,FrozenColRight:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [];
		var v = 0 ;
		initdata1.Cols[v++] = {Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 };
        initdata1.Cols[v++] = {Header:"세부\n내역|세부\n내역",   Type:"Image",   Hidden:0, Width:45,     Align:"Center", ColMerge:0,  SaveName:"detail",         Edit:0, Sort:0, Cursor:"Pointer" };
		initdata1.Cols[v++] = {Header:"본부|본부",				Type:"Text",   	Hidden:1, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"pOrgNm", 		KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"부서|부서",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			KeyField:0, Edit:0};
			
		initdata1.Cols[v++] = {Header:"사번|사번",				Type:"Text",   	Hidden:1, Width:70, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"성명|성명",				Type:"Text",    Hidden:0, Width:70,		Align:"Center", ColMerge:0,  SaveName:"name", 			KeyField:0, UpdateEdit:0,	InsertEdit:1};
		initdata1.Cols[v++] = {Header:"직급|직급",				Type:"Text",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		KeyField:0, Edit:0};
			
		initdata1.Cols[v++] = {Header:"입사일자|입사일자",		Type:"Date",   	Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"empYmd", 		KeyField:0, Format:"Ymd", Edit:0};

		var titleList = ajaxCall("${ctx}/OrgMonthWorkSta.do?cmd=getOrgMonthWorkStaTitleList", $("#sheet1Form").serialize(), false);
		if (titleList != null && titleList.DATA != null) {
			for(var i = 0 ; i<titleList.DATA.length; i++) {
			    var map = titleList.DATA[i];
				initdata1.Cols[v++] = {Header:str+map.vDay,  Type:"Text",    Hidden:0, Width:30, 	Align:"Center", ColMerge:0,  SaveName:map.saveName,  KeyField:0, Edit:0, FontColor:map.fontColor };
			}
		}
			
		initdata1.Cols[v++] = {Header:"휴직/\n병가계|휴직/\n병가계",  Type:"AutoSum", Hidden:0, Width:60, Align:"Center", ColMerge:0,  SaveName:"cnt1", KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"지각/\n조퇴계|지각/\n조퇴계",  Type:"AutoSum", Hidden:0, Width:60, Align:"Center", ColMerge:0,  SaveName:"cnt2", KeyField:0, Edit:0};
		initdata1.Cols[v++] = {Header:"당직계|당직계",              Type:"AutoSum", Hidden:0, Width:60, Align:"Center", ColMerge:0,  SaveName:"cnt3", KeyField:0, Edit:0};
        initdata1.Cols[v++] = {Header:"건강/\n휴가계|건강/\n휴가계",  Type:"AutoSum", Hidden:0, Width:60, Align:"Center", ColMerge:0,  SaveName:"cnt4", KeyField:0, Edit:0};
        initdata1.Cols[v++] = {Header:"년/\n월차계|년/\n월차계",     Type:"AutoSum", Hidden:0, Width:60, Align:"Center", ColMerge:0,  SaveName:"cnt5", KeyField:0, Edit:0};
		
		
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
		if (titleList != null && titleList.DATA != null) {
            for(var i = 0 ; i<titleList.DATA.length; i++) {
                var map = titleList.DATA[i];
                sheet1.SetCellFontColor( 1, map.saveName, map.fontColor);
            }
        }
		

		$(window).smartresize(sheetResize); sheetInit();
	}

	// 입력시 조건 체크
	function checkList(){
		if($("#searchYm").val() === '') {
			alert('기준년월을 입력하세요.');
			return false;
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if(!checkList()) return ;
				$("#oldSearchYm").val($("#searchYm").val());
                $("#oldSearchOrgCd").val($("#searchOrgCd").val());
				sheet1.DoSearch( "${ctx}/OrgMonthWorkSta.do?cmd=getOrgMonthWorkStaList", $("#sheet1Form").serialize());
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
                pGubun = "OrgMonthWorkStaPop";

                // openPopup("/OrgMonthWorkSta.do?cmd=viewOrgMonthWorkStaPop&authPg=R", args, "850", "650");

				const p = {
					ym: $("#searchYm").val(),
					sabun: sheet1.GetCellValue(Row, "sabun"),
					name: sheet1.GetCellValue(Row, "name"),
					orgNm: sheet1.GetCellValue(Row, "orgNm"),
					jikgubNm: sheet1.GetCellValue(Row, "jikgubNm")
				};

				var layer = new window.top.document.LayerModal({
					id : 'orgMonthWorkStaLayer'
					, url : '/OrgMonthWorkSta.do?cmd=viewOrgMonthWorkStaLayer&authPg=${authPg}'
					, parameters: p
					, width : 850
					, height : 650
					, title : "개인별 월근태현황"
					, trigger :[
						{
							name : 'orgMonthWorkStaLayerTrigger'
							, callback : function(rv){
								var sabun = rv["sabun"];
								var enterCd = rv["enterCd"];
								goMenu(sabun,enterCd);
							}
						}
					]
				});
				layer.show();
                
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
        <input type="hidden" id="oldSearchYm" name="oldSearchYm" />
        <input type="hidden" id="oldSearchOrgCd" name="oldSearchOrgCd" />
		<div class="sheet_search outer">
			<table>
			<tr>
				<th>기준년월</th>
				<td>
					<input type="text" id="searchYm" name="searchYm" class="date2" value="${curSysYyyyMMHyphen}"/>
				</td>
				<th>부서</th>
				<td>
					<select id="searchOrgCd" name="searchOrgCd"></select>
				</td>
				<th>직군</th>
				<td>
					<select id="searchWorkType" name="searchWorkType"></select>
				</td>
			</tr>
			<tr>
				<th>직급</th>
				<td colspan="4">
					<select id="searchJikgubCd" name="searchJikgubCd" multiple ></select>
					<input type="hidden" id="jikgubCd" name="jikgubCd" value=""/>
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
			<li class="txt">부서별월근태현황</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray  authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
