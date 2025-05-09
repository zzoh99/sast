<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		initIBSheet($("#searchYy").val());
		initEvents();
		doAction1("Search");
	});

	function initIBSheet(curYear) {
		sheet1.Reset();

		//Master Sheet(sheet1)
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,SumPosition:1};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo", Sort:0 },
			{Header:"귀속년도|귀속년도", 	Type:"Int",        Hidden:0,  	Width:100,   Align:"Center",     ColMerge:0,   SaveName:"yy",    	KeyField:0,   Format:"####",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"소속|소속",           Type:"Text",        Hidden:0,  	Width:80,   Align:"Center",     ColMerge:0,   SaveName:"orgNm",   	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번|사번",      		Type:"Text",        Hidden:0,  	Width:60,    Align:"Center",     ColMerge:0,   SaveName:"sabun",   	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"성명|성명",      		Type:"Popup",       Hidden:0,  	Width:60,    Align:"Center",     ColMerge:0,   SaveName:"name",    	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"직종|직종",           Type:"Text",        Hidden:0,  	Width:80,   Align:"Center",     ColMerge:0,   SaveName:"jikjongNm",   	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"전년도\n부과보험료|전년도\n부과보험료", Type:"AutoSum",     Hidden:0,  	Width:100,   	 Align:"Right",      ColMerge:0,   SaveName:"bfMon1", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"전년도\n보수월액|전년도\n보수월액",  	Type:"AutoSum",     Hidden:0,  	Width:100,   	 Align:"Right",      ColMerge:0,   SaveName:"mon4", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"전년도\n확정보험료|전년도\n확정보험료",	Type:"AutoSum",     Hidden:0,  	Width:100,   	 Align:"Right",      ColMerge:0,   SaveName:"bfMon6", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"가입자분\n연말정산보험료|가입자분\n연말정산보험료",	Type:"AutoSum", Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"bfYyMon", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"당해년도\n월보험료|당해년도\n월보험료",			Type:"AutoSum", Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"yyMon", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"분납구분|분납구분",		    Type:"Text",        Hidden:0,  	Width:100,   Align:"Center",     ColMerge:0,   SaveName:"gubun", 	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0},
		];
		var yyMonCalcLogic = "";
		for (var i = 4 ; i < 4 + getDivCnt(curYear) ; i++) {
			initdata.Cols.push({Header:"연말정산보험료 납부|"+i+"월",		Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"yyMon"+i, 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0});
			if (i !== 4) yyMonCalcLogic += "+";
			yyMonCalcLogic += "|yyMon"+i+"|";
		}
		initdata.Cols.push({Header:"연말정산보험료 납부|계",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"totMon", 	KeyField:0,   CalcLogic:yyMonCalcLogic, Format:"Integer",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0});
		initdata.Cols.push({Header:"비고|비고",				Type:"Text",		Hidden:0,	Width:200,	 Align:"Left",	     ColMerge:0,   SaveName:"text2",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetSumText("sNo" ,"합계");

		$(window).smartresize(sheetResize); sheetInit();
	}

	function initEvents() {
		$("#searchYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if (event.keyCode === 13) {
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#searchYy").on("change", function(e) {
			initIBSheet($(this).val());
		});
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if (!reqChk()) {break;}
			sheet1.DoSearch( "${ctx}/HealthInsEmpDivMgr.do?cmd=getHealthInsEmpDivMgrList3", $("#srchFrm").serialize() ); 
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20",UserMerge :"0,0,2,2"}; 
			sheet1.Down2Excel(param);
			break;
		}
	}

	//필수체크
	function reqChk(){
		if($("#searchYy").val() == ""){	alert("귀속년도를 입력해 주세요."); $("#searchYy").focus();	return false; }
		return true;
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
			
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function makeHiddenSkipExCol(sobj,excols){
		var lc = sobj.LastCol();
		var colsArr = new Array();
		for(var i=0;i<=lc;i++){
			if(1==sobj.GetColHidden(i) || sobj.GetCellProperty(0, i, "Type")== "Status" || sobj.GetCellProperty(0, i, "Type")== "DelCheck"){
				colsArr.push(i);
			}
		}
		var excolsArr = excols.split("|");

		for(var i=0;i<=lc;i++){
			if($.inArray(sobj.ColSaveName(i),excolsArr) != -1){
				colsArr.push(i);
			}
		}

		var rtnStr = "";
		for(var i=0;i<=lc;i++){
			if($.inArray(i,colsArr) == -1){
				rtnStr += "|"+ i;
			}
		}
		return rtnStr.substring(1);
	}

	/**
	 * 분납 횟수 조회. 급여기타기준관리에서 조회.
	 * @param curYear
	 * @returns {number|*|number}
	 */
	function getDivCnt(curYear) {
		if (isNaN(curYear)) return 5;

		var divCntData = ajaxCall("${ctx}/HealthInsEmpDivMgr.do?cmd=getHealthInsEmpDivMgrTab1DivCnt", "searchYy="+$("#searchYy").val(), false);
		if (!divCntData || !divCntData.DATA || !divCntData.DATA.divCnt) return 5;
		if (isNaN(divCntData.DATA.divCnt)) return 5;

		return Number(divCntData.DATA.divCnt);
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td><span>귀속년도</span><input id="searchYy" name ="searchYy" type="text" class="text w70 required center" value="<%= DateUtil.getCurrentTime("yyyy")%>" maxlength="4"/></td>
						<td class="hide"><span><tit:txt mid='112277' mdef='사번/성명 '/></span>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
		
		<table class="sheet_main">
			<tr>
				<td class="bottom outer">
					<div class="explain">
						<div class="title"><tit:txt mid='114264' mdef='도움말'/></div>
						<div class="txt">
							<table>
								<tr>
									<td id="etcComment">
										<li>1. 귀속년도 : 조회 시 귀속년도 + 1231 기준으로 소속 및 직종 목적</li>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
		</table>
		
		
	    <div class="outer">
	        <div class="sheet_title">
	        <ul>
	            <li class="txt">연말정산보험료납부계획현황</li>
	            <li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
	            </li>
	        </ul>
	        </div>
	    </div>
    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
    </form>
</div>
</body>
</html>
