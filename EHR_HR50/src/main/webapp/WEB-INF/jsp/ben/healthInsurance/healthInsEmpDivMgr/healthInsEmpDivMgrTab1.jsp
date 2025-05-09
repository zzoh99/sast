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

		//Master Sheet(sheet1)
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,SumPosition:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo", Sort:0 },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"귀속년도|귀속년도", 	Type:"Int",         Hidden:0,  	Width:60,   Align:"Center",     ColMerge:0,   SaveName:"yy",    	KeyField:1,   Format:"####",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },

			{Header:"사업장관리번호|사업장관리번호",Type:"Text",	Hidden:0,	Width:80,	 Align:"Left",	     ColMerge:0,   SaveName:"text3",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150 },
			{Header:"차수|차수",			Type:"Text",		Hidden:0,	Width:80,	 Align:"Center",     ColMerge:0,   SaveName:"text4",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150 },
			{Header:"회계|회계",			Type:"Text",		Hidden:0,	Width:80,	 Align:"Left",	     ColMerge:0,   SaveName:"text5",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150 },
			{Header:"단위사업장|단위사업장",	Type:"Text",		Hidden:0,	Width:80,	 Align:"Left",	     ColMerge:0,   SaveName:"text6",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150 },
			{Header:"증번호|증번호",		Type:"Text",		Hidden:0,	Width:80,	 Align:"Left",	     ColMerge:0,   SaveName:"text7",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:150 },
			
			{Header:"순번|순번",		    Type:"Int",			Hidden:1,	Width:80,	 Align:"Left",	     ColMerge:0,   SaveName:"seqNo",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"사번|사번",      		Type:"Text",        Hidden:0,  	Width:60,    Align:"Center",     ColMerge:0,   SaveName:"sabun",   	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:20 },
			{Header:"성명|성명",      		Type:"Text",        Hidden:0,  	Width:60,    Align:"Center",     ColMerge:0,   SaveName:"name",    	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:15 },
			{Header:"주민번호|주민번호",		Type:"Text",		Hidden:0,	Width:120,	 Align:"Center",	 ColMerge:0,   SaveName:"resNo",	KeyField:1,	  Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:150 },
			{Header:"주민번호|주민번호",		Type:"Text",		Hidden:1,	Width:120,	 Align:"Center",	 ColMerge:0,   SaveName:"resNoEnc",	KeyField:0,	  Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			
			{Header:"부과한총보험료|계",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"sum1", 	KeyField:0,   CalcLogic:"|mon1|+|mon2|", Format:"Integer",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"부과한총보험료|건강",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon1", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"부과한총보험료|장기요양",	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon2", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			
			{Header:"연간보수총액|연간보수총액",Type:"AutoSum",    Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon3", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"근무월수|근무월수",		Type:"Int",     	Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mm", 	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"보수월액|보수월액",		Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon4", 	KeyField:1,   Format:"",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"등급|등급",		    Type:"Text",        Hidden:0,  	Width:100,   Align:"Center",     ColMerge:0,   SaveName:"grade", 	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"표준보수월액|표준보수월액",Type:"AutoSum",    Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon5", 	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },

			{Header:"확정보험료|계",  		Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"sum2", 	KeyField:0,   CalcLogic:"|mon6|+|mon7|", Format:"Integer",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"확정보험료|건강",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon6", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"확정보험료|장기요양",	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon7", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			
			{Header:"정산보험료계|계",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"sum3", 	KeyField:0,   CalcLogic:"|mon8|+|mon9|", Format:"Integer",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"정산보험료계|건강",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon8", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"정산보험료계|장기요양",	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon9", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			
			{Header:"가입자부담|계",  		Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"sum4", 	KeyField:0,   CalcLogic:"|mon10|+|mon11|", Format:"Integer",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"가입자부담|건강",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon10", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"가입자부담|장기요양",	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon11", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			
			{Header:"사용자부담|계",  		Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"sum5", 	KeyField:0,   CalcLogic:"|mon12|+|mon13|", Format:"Integer",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"사용자부담|건강",  	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon12", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사용자부담|장기요양",	Type:"AutoSum",     Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon13", 	KeyField:0,   Format:"Integer",  		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			
			{Header:"고지유예|고지유예",		Type:"Text",		Hidden:0,	Width:200,	 Align:"Left",	     ColMerge:0,   SaveName:"text1",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:250 },
			{Header:"비고|비고",			Type:"Text",		Hidden:0,	Width:200,	 Align:"Left",	     ColMerge:0,   SaveName:"text2",    KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:250 }
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetSumText("sNo" ,"합계");
		
		$("#searchYy").on("change", function(e) {
			$("#divCnt").html(getDivCnt($(this).val()));
	    }).change();
		$("#searchYy").mask("1111");

	    $("#searchBaseYmd").datepicker2().val("${curSysYyyyMMddHyphen}");

		$("#searchSabunName,#searchYy").bind("keyup",function(event){
	    	if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		 
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	
			if (!reqChk()) {break;}
			sheet1.DoSearch( "${ctx}/HealthInsEmpDivMgr.do?cmd=getHealthInsEmpDivMgrList", $("#srchFrm").serialize() ); 
			break;
		case "Save":
			if (!reqChk()) {break;}
			//if(!dupChk(sheet1,"yy|sabun", false, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/HealthInsEmpDivMgr.do?cmd=saveHealthInsEmpDivMgr", $("#srchFrm").serialize()); 
			break;
		case "Insert":	
			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "yy", $("#searchYy").val());
			//openEmployeePopup(newRow) ;
			break;
		case "Copy":	var Row = sheet1.DataCopy();
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20",UserMerge :"0,0,2,2"}; 
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			if (!reqChk()) {break;}
			if($("#searchBaseYmd").val() == ""){	alert("공제기준일을 선택해 주세요."); $("#searchBaseYmd").focus();	break; }
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); 
			break;
		case "DownTemplate":
			// 양식다운로드
			var exCols = "sNo|yy|sabun|sum1|sum2|sum3|sum4|sum5";
			var downCols = makeHiddenSkipExCol(sheet1,exCols);
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:downCols});
			break;
		}
	}

	//필수체크
	function reqChk(){
		if($("#searchYy").val() == "") {
			alert("귀속년도를 입력해 주세요.");
			$("#searchYy").focus();
			return false;
		}
		return true;
	}
	
	//엑셀 업로드 후 처리
	function sheet1_OnLoadExcel() {
		for(var i = sheet1.HeaderRows(); i<=sheet1.RowCount()+sheet1.HeaderRows(); i++) {
			sheet1.SetCellValue(i, "yy", $("#searchYy").val());
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			partPayPrc();
			if (Msg !== "") {
				alert(Msg);
			}
			doAction1('Search');
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			//사원검색
			switch(sheet1.ColSaveName(Col)){
			case "name":
				if(!isPopup()) {return;}

				sheet1.SelectCell(Row,"name");

				gPRow = Row;
				pGubun = "employeePopup";

				openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "740","520");
				break;
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
//  사원 조회
	function openEmployeePopup(Row){
	    try{
			if(!isPopup()) {return;}
			var args    = new Array();

			gPRow = Row;
			pGubun = "employeePopup";

			openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
	    }catch(ex){
	    	alert("Open Popup Event Error : " + ex);
	    }
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
	
	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup") {
        	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
        	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
        	sheet1.SetCellValue(gPRow, "name", rv["name"]);
        	sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
        	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        	sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
        	sheet1.SetCellValue(gPRow, "statusNm", rv["statusNm"]);
        }else if(pGubun == "searchOrgBasicPopup") {
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
		}
    }

	//분납생성
	function partPayPrc() {
		var params = "searchYy="+$("#searchYy").val();
		var ajaxCallCmd = "prcCreateHealthInsEmpDiv";
		var data = ajaxCall("/HealthInsEmpDivMgr.do?cmd="+ajaxCallCmd,params,false);

		if (!data.Result.Code) {
			alert("분납생성 되었습니다.");
			doAction1("Search") ;
		} else {
			alert("분납생성에 실패하였습니다.");
		}
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
						<td>
							<span>귀속년도</span>
							<input id="searchYy" name ="searchYy" type="text" class="text w70 required center" value="<%= DateUtil.getCurrentTime("yyyy")%>" maxlength="4"/>
						</td>
						<td class="hide">
							<span><tit:txt mid='112277' mdef='사번/성명 '/></span>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
						</td>
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
										<li>1. 공제기준일 : 주민번호 기준 사번 추출 용도 목적</li>
										<li>2. 처리 기준</li>
										<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 분납 : 연말정산 추가보험료(부과보험료 - 확정보험료)가 9,890원 이상 발생한 경우(건강보험으로만 판단), 연말정산 추가보험료 금액을 <span id="divCnt">5</span>회 분납 처리.</li>
										<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- 일시납 : 분납 처리 외 사항은 4월 일시납 처리.</li>
										<li>3. 공단자료업로드 후 저장 시 자동으로 처리기준에 따라 분납생성.</li>
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
	            <li class="txt">연말정산결과업로드</li>
	            <li class="btn">
                    <span>공제기준일</span>
	            	<span>
						<input type="text" id="searchBaseYmd" name="searchBaseYmd" class="date2 required" value="" />
					</span>
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
	            	<a href="javascript:doAction1('DownTemplate')" class="btn outline-gray authA">양식다운로드</a>
	            	<a href="javascript:doAction1('LoadExcel')" class="btn outline-gray authA">공단자료업로드</a>
					<!-- <a href="javascript:doAction1('Insert')" class="basic authA">입력</a> -->
					<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
	            </li>
	        </ul>
	        </div>
	    </div>
    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
    </form>
</div>
</body>
</html>
