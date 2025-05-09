<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
$(function() {
	
	//시트 초기화 
	var initdata = {};
	initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22}; 
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		
		{Header:"No",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"), Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
		
		{Header:"발령번호"		, Type:"Text",    Hidden:0,   Width:120,  	Align:"Center", ColMerge:0, SaveName:"processNo",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
		{Header:"발령제목"		, Type:"Text",    Hidden:0,   Width:160,  	Align:"Center",   ColMerge:0, SaveName:"processTitle",    KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"담당부서"		, Type:"Text",    Hidden:1,   Width:70,  	Align:"Left",   ColMerge:0, SaveName:"orgCd",           KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:70 },
		{Header:"담당부서"		, Type:"Text",    Hidden:0,   Width:70,  	Align:"Center",   ColMerge:0, SaveName:"orgNm",           KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:70 },
		{Header:"담당자사번"	, Type:"Text",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"processSabun",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
		{Header:"담당자성명"	, Type:"Text",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"processName",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },		
		{Header:"등록일자"		, Type:"Date",    Hidden:0,   Width:90,  	Align:"Center", ColMerge:0, SaveName:"inputYmd",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"발령처리여부"	, Type:"CheckBox",Hidden:0,   Width:40,  	Align:"Center", ColMerge:0, SaveName:"actionYn",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
		{Header:"발령처리일자"	, Type:"Date",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"actionYmd",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"발령공지여부"	, Type:"CheckBox",Hidden:1,   Width:40,  	Align:"Center", ColMerge:0, SaveName:"noticeYn",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
		{Header:"품의번호SEQ"	, Type:"Text",    Hidden:1,   Width:70,  	Align:"Left",   ColMerge:0, SaveName:"processNoSeq",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		
		
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
	sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
	$(".sheet_search :input").bind("keyup",function(event){
		if( event.keyCode == 13){
			doAction1("Search");
		}
	});

	$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
	$("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

	$(sheet1).sheetAutocomplete({
	  	Columns: [{ ColSaveName : "processName" }]
	}); 	

	$(window).smartresize(sheetResize); sheetInit();
	doAction1("Search");
	
});
//************************************************************************************
// ibsheet 관련 func.
//************************************************************************************
//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search":		
		sheet1.DoSearch( "${ctx}/AppmtProcessNoMgr.do?cmd=getAppmtProcessNoMgrList",$("#sheet1Form").serialize() );
		break;
	case "Save":
		if(!dupChk(sheet1,"processNo", true, true)){break;}
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppmtProcessNoMgr.do?cmd=saveAppmtProcessNoMgr", $("#sheet1Form").serialize());
		break;
	case "Insert":
		var row = sheet1.DataInsert(1);
		//기본정보 set
		sheet1.SetCellValue(row,"processSabun","${sessionScope.ssnSabun}");
		sheet1.SetCellValue(row,"processName","${sessionScope.ssnName}");
		sheet1.SetCellValue(row,"orgCd","${sessionScope.ssnOrgCd}");
		sheet1.SetCellValue(row,"orgNm","${sessionScope.ssnOrgNm}");
		sheet1.SetCellValue(row,"inputYmd","<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
<%-- 		var paramProcessNo = "<%=DateUtil.getCurrentTime("yyyyMM")%>-${sessionScope.ssnOrgCd}"; --%>
// 		setProcessNo(row, paramProcessNo);
		
		break;
	case "Copy":
		var lRow = sheet1.DataCopy();
		sheet1.SetCellValue(lRow,"processNo","");
		sheet1.SetCellValue(lRow,"actionYn","N");
		
		
		break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
		var d = new Date();
		var fName = "발령번호관리_" + d.getTime();
		sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
		break;
	}
}
//발령품의번호 생성 & set
function setProcessNo(row, paramProcessNo){
	var processNoSeq = ajaxCall("${ctx}/AppmtProcessNoMgr.do?cmd=getAppmtProcessNoSeq",{"processNo":paramProcessNo},false);

	if(processNoSeq.DATA >-1){
		var maxProcessNo = parseFloat(processNoSeq.DATA);//조회된 max seq 값
		var paramProcessNo = paramProcessNo.split("-");
		urows = (sheet1.FindStatusRow("I")).split(";");
		if(urows.length > 1) { // 입력된 건이 2건 이상일때 
			for(var ind in urows){
				if ( urows[ind] == sheet1.GetSelectRow() ) continue; // 현재선택된 row는 skip
				var rowProcessNo = (sheet1.GetCellValue(urows[ind],"processNo")).split("-");
				if(rowProcessNo[0] == paramProcessNo[0] && rowProcessNo[1] == paramProcessNo[1]
					&& parseFloat(rowProcessNo[2]) > maxProcessNo
				){
					maxProcessNo = parseFloat(rowProcessNo[2]);
				}
			}
		}
		
		//일련번호 생성
		maxProcessNo = maxProcessNo+1;
		maxProcessNo = ""+maxProcessNo;
		var maxProcessNoPrefix = "";
		for(var i=0 ; i<3-maxProcessNo.length ; i++){
			maxProcessNoPrefix += "0";
		}
		sheet1.SetCellValue(sheet1.GetSelectRow(),"processNo",paramProcessNo[0]+"-"+paramProcessNo[1]+"-"+maxProcessNoPrefix+maxProcessNo);
		sheet1.SetCellValue(sheet1.GetSelectRow(),"processNoSeq",maxProcessNo);
	}else{
		alert(processNoSeq.Message);
	}
	
}
//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		sheetResize();
		//발령처리 상태는 삭제를 uneditable 로 처리
		for(var i=0 ; i<sheet1.RowCount();i++ ){
			if(sheet1.GetCellValue(i+1, "actionYn") == "Y") sheet1.SetCellEditable(i+1, "sDelete", 0);
			else sheet1.SetCellEditable(i+1, "sDelete", 1);
		}
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
		doAction1("Search");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

//키를 눌렀을때 발생.
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		if(sheet1.GetCellEditable(Row,Col) == true && KeyCode == 46) {
			switch(sheet1.ColSaveName(Col)){
			case "jobNm":
				sheet1.SetCellValue(Row,"jobCd","");
				break;
			case "orgNm":
				sheet1.SetCellValue(Row,"orgCd","");
				break;
			}
			
		}
	} catch (ex) {
		alert("OnKeyDown Event Error " + ex);
	}
}

// 팝업 클릭시 발생
function sheet1_OnPopupClick(Row,Col) {
	try {
		/* if(sheet1.ColSaveName(Col) == "jobNm") {
			if(!isPopup()) {return;}
			
			gPRow = Row;
			pGubun = "jobNm1";

	        var win = openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R", "", "800","750");
		} */
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}
// click 클릭시 발생
function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	/* if(sheet1.ColSaveName(Col) == "sDelete") {
		console.log("DDD");
	} */
}

function getReturnValue(returnValue) {
    var rv = $.parseJSON('{' + returnValue+ '}');

    sheet1.SetCellValue(gPRow, "processSabun",     rv["sabun"] );
    sheet1.SetCellValue(gPRow, "processName",      rv["name"] );
    sheet1.SetCellValue(gPRow, "orgNm",     rv["orgNm"] );
    sheet1.SetCellValue(gPRow, "orgCd",     rv["orgCd"] );
       
}



</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>등록일자</th>
						<td>
							<input id="searchFromYmd" 	name="searchFromYmd" type="text" size="10" class="date2" value="<%=DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-1)%>"/> ~
							<input id="searchToYmd" 	name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th>발령번호</th>
						<td>
                        	<input id="searchProcessNo" name ="searchProcessNo" type="text" class="text" />
                        </td>
						<th>발령제목</th>
                        <td>
                        	<input id="searchProcessTitle" name ="searchProcessTitle" type="text" class="text" />
                        </td>
                        
						<td>
							<a href="javascript:doAction1('Search');" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">발령번호관리</li>
			<li class="btn">				
				
				<a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="basic authA">복사</a>
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>	
	
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
</div>
</body>