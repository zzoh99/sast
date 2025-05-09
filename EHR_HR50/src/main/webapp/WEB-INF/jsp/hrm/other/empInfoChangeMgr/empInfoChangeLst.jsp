<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var pGubun = "";
var statusRows = [];
	$(function() {
		
		//sheet1
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll,FrozenCol:6};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택", 	Type:"CheckBox",    Hidden:1,   Width:45,  	Align:"Center", ColMerge:0, SaveName:"applSel",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }, 
			{Header:"사원번호", 	Type:"Text",    Hidden:0,   Width:60,  	Align:"Center", ColMerge:0, SaveName:"sabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"성명",			Type:"Text",   	Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"name", 		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"부서명",		Type:"Text",	Hidden:0,   Width:100,  Align:"Left", 	ColMerge:0, SaveName:"orgNm",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },			           			
			{Header:"신청순번", 	Type:"Text",    Hidden:1,   Width:0,  	Align:"Center", ColMerge:0, SaveName:"applSeq",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"신청일자", 	Type:"Text",    Hidden:0,   Width:75,  	Align:"Center", ColMerge:0, SaveName:"applYmd",     KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"업무구분", 	Type:"Combo",   Hidden:0,   Width:55,  	Align:"Center", ColMerge:0, SaveName:"empTable",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },			
			{Header:"작업\n구분",	Type:"Combo",   Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"applType",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"처리\n상태",	Type:"Combo",   Hidden:0,   Width:50,  	Align:"Center", ColMerge:0, SaveName:"applStatusCd",KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"",				Type:"Text",   	Hidden:1,   Width:10,  	Align:"Center", ColMerge:0, SaveName:"applStatusCdTmp",KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"반영일자",		Type:"Text",    Hidden:0,   Width:75,   Align:"Center", ColMerge:0, SaveName:"apprYmd",   	KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"담당자",		Type:"Text",	Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"apprName",  	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"회답",			Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"returnMessage",KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"오류내용",		Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"errorLog",  	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"메모",			Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"memo",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		
		//콤보박스
		
		var empTable = convCode(ajaxCall("${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeTableMgrList","searchUseYn=Y&searchCodeNm=Y",false).DATA,"전체");
		sheet1.SetColProperty("empTable", 		{ComboText:empTable[0], ComboCode:empTable[1]} );
		
		sheet1.SetColProperty("applType", 		{ComboText:"입력|수정|삭제", ComboCode:"I|U|D"} );
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90028"), "전체");
		sheet1.SetColProperty("applStatusCd", 		{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
		
		
		//sheet2
		initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll,FrozenCol:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			
			{Header:"항목", 	Type:"Text",    Hidden:0,   Width:100,  	Align:"Center", ColMerge:0, SaveName:"columnNm",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"신청전", 	Type:"Html",   Hidden:0,   Width:100,  	Align:"Center", ColMerge:0, SaveName:"preValue",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2000 },
			{Header:"신청후", 	Type:"Html",    Hidden:0,   Width:100,  	Align:"Center", ColMerge:0, SaveName:"aftValue",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2000 },
			{Header:"", 	Type:"Text",    Hidden:1,   Width:70,  	Align:"Left", ColMerge:0, SaveName:"cType",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },

		]; IBS_InitSheet(sheet2, initdata2);sheet1.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		//event정의
		$("#dataTable :input").change(function(){
			var objid = $(this).attr("id");
			//console.log(objid);
			sheet1.SetCellValue(sheet1.GetSelectRow(),objid,$(this).val());
		});
		
		/******************************************************************************************/
		//search zone 정리
		//달력
    	$(".date2", $("#srchFrm")).each(function(){
    		$(this).datepicker2();
    	});
		// 기간 default 값
		$("#searchToApplYmd").val("${curSysYyyyMMddHyphen}");
		$("#searchFromApplYmd").val("<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>");
		//업무구분
		$("#searchEmpTable").html(empTable[2]);
		//처리상태
		$("#searchApplStatusCd").html(applStatusCd[2]);
		$("#searchApplStatusCd").val("1");
		//event
		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).parent().find("a").trigger("click");
			}
		});
		/******************************************************************************************/
// 		$("#searchSabun").bind("keyup",function(event){
// 			if( event.keyCode == 13){
// 				doAction1("Search");
// 			}
// 		});
		
		$("#searchSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ 
            	doAction1("Search"); $(this).focus(); 
            	}
        });		
		
		setPageDisable();
		
		//search zone 값 setting한 후 조회
		doAction1("Search");
		
	});
	
	function setPageDisable(cmd){
		sheet1.SetEditable("0");			
		$("._hideArea").hide();
		$("#searchSabunName").val("<%=(String)session.getAttribute("ssnSabun")%>");
		$("#dataTable").find(":input").each(function(){
			$(this).attr("readonly",true);
			
		});
	}
	//Sheet1 Action
	function doAction1(sAction) {
		statusRows = [];
		switch (sAction) {
		case "Search": 	 	
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSearch( "${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeMgrList", $("#srchFrm").serialize() );
							//우측 회답, 오류내용, 메모, sheet2 clear
							sheet2.RemoveAll();
							$("#dataTable :input").val("");
							break;
 		case "Save": 		
							
 							IBS_SaveName(document.srchFrm,sheet1);
 							sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpInfoChangeMgr", getParamSave());

					
 							break;
		
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		
		case "Accept": 
		
			var cnt = 0;
			for(var i=1 ; i<sheet1.RowCount()+1; i++){
				if(sheet1.GetCellValue(i,"applSel") == "1" && sheet1.GetCellValue(i, "applStatusCdTmp") == "1"){
					cnt ++;
					sheet1.SetCellValue(i, "applStatusCd", "2");
				}
			}
			if(cnt==0){
				alert("반영할 항목을 선택하세요.");
			}else{
				doAction1("Save");
			}
			break;
		
		case "Reject":
			var cnt = 0;
			for(var i=1 ; i<sheet1.RowCount()+1; i++){
				if(sheet1.GetCellValue(i,"applSel") == "1" && sheet1.GetCellValue(i, "applStatusCdTmp") == "1"){
					cnt ++;
					sheet1.SetCellValue(i, "applStatusCd", "3");
				}
			}
			if(cnt==0){
				alert("반려할 항목을 선택하세요.");
			}else{
				doAction1("Save");
			}			
			
			break;
		}
	}
	function getParamSave() {
		var param = $("#srchFrm").serialize();
		if($("#mailYn:checked").val() != undefined) {
			param += "&mailYn="+$("#mailYn").val();
		}
		if($("#smsYn:checked").val() != undefined) {
			param += "&smsYn="+$("#smsYn").val();
		}
		if($("#gwYn:checked").val() != undefined) {
			param += "&gwYn="+$("#gwYn").val();
		}
		param += "&empTableNm=" + sheet1.GetCellText(sheet1.GetSelectRow(),"empTable");
		
		return param;
	}
	function doAction2(sAction){
		statusRows = [];
		switch(sAction){
		case "Search":
			var param = "applSeq="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applSeq")+"&empTable="+sheet1.GetCellValue(sheet1.GetSelectRow(),"empTable");
			param += "&applType="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applType");
			param += "&applStatusCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"applStatusCd");
		
			sheet2.DoSearch("${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeMgrList2",param);
			
			break;
		case "Accept":
			//신청인지 체크 
			if(sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCdTmp") == "1"){
				//var data = sheet1.GetRowData(sheet1.GetSelectRow());
				
				for(var i=1 ; i<sheet1.RowCount()+1 ; i++){
					if(i==sheet1.GetSelectRow()){
						sheet1.SetCellValue(i,"applStatusCd","2");//반영
					}else if(sheet1.GetCellValue(i,"sStatus")!="R"){
						statusRows.push({"sStatus":sheet1.GetCellValue(i,"sStatus"),"row":i});
						sheet1.SetCellValue(i,"sStatus","R");
					}
				}
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpInfoChangeMgr", getParamSave());
			}else{
				alert("처리상태가 신청상태 일때만 반영처리할 수 있습니다.");
			}
			break;
		case "Reject":
			if(sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCdTmp") == "1"){
				for(var i=1 ; i<sheet1.RowCount()+1 ; i++){
					if(i==sheet1.GetSelectRow()){
						sheet1.SetCellValue(i,"applStatusCd","3");//반려
					}else if(sheet1.GetCellValue(i,"sStatus")!="R"){
						statusRows.push({"sStatus":sheet1.GetCellValue(i,"sStatus"),"row":i});
						sheet1.SetCellValue(i,"sStatus","R");
					}
				}
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpInfoChangeMgr", getParamSave());
			}else{
				alert("처리상태가 신청상태 일때만 반려처리할 수 있습니다.");
			}
			break;
		}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		if(sheet1.GetSelectRow()<0)return;
		if(OldRow!=NewRow) doAction2("Search");		
		$("#dataTable :input").each(function(){			
			$(this).val(sheet1.GetCellValue(sheet1.GetSelectRow(),$(this).attr("id")));
		});
		
	}
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag){
		
		if(sheet1.ColSaveName(Col) == "applSel"){
			sheet1.SetCellValue(Row,"sStatus","R");
		}
	}
	

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			//신청건만 삭제가능, 처리상태 변경가능 , 체크가능
			for(var i=1 ; i<sheet1.RowCount()+1 ; i++){
				sheet1.SetCellEditable(i,"sDelete",sheet1.GetCellValue(i,"applStatusCdTmp") == "1");
				sheet1.SetCellEditable(i,"applSel",sheet1.GetCellValue(i,"applStatusCdTmp") == "1");
				sheet1.SetCellEditable(i,"applStatusCd",sheet1.GetCellValue(i,"applStatusCdTmp") == "1");
			}
			
			
			sheetResize(); 
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			sheetResize();
			for(var i=1 ; i<sheet2.RowCount()+1; i++){
				//console.log(i+"::"+sheet2.GetCellValue(i,"preValue")+","+sheet2.GetCellValue(i,"aftValue"));
				if( sheet2.GetCellValue(i,"preValue") != sheet2.GetCellValue(i,"aftValue")){					
					sheet2.SetCellFontColor(i,"preValue", "blue");
					sheet2.SetCellFontColor(i,"aftValue", "blue");
					
				}
				
				//첨부파일인 경우 button
				if(sheet2.GetCellValue(i,"cType") == "F"){
					
					if(sheet2.GetCellValue(i,"preValue")!=""){
						sheet2.SetCellValue(i, "preValue", '<a class="basic" onclick="javascript:viewAttachFile(\''+sheet2.GetCellValue(i,"preValue")+'\');">첨부</a>');
					}
					if(sheet2.GetCellValue(i,"aftValue")!=""){
						sheet2.SetCellValue(i, "aftValue", '<a class="basic" onclick="javascript:viewAttachFile(\''+sheet2.GetCellValue(i,"aftValue")+'\');">첨부</a>');
					}
				}
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}

			doAction1("Search"); 
			/* for(var i in statusRows){
				var t = statusRows[i];
				if(t){
					sheet1.SetCellValue(t.row, "sStatus", t.sStatus);
				}
			} */
			
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	
	/*******************************************************************************************************/
	function popup(opt){
		pGubun = opt;
		if(opt == "org"){
			openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");	
		}
		
	}
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
		
		if(pGubun == "org") {
	    	$("#searchOrgCd").val(rv["orgCd"]);
	    	$("#searchOrgNm").val(rv["orgNm"]);
	    	$("#searchOrgSdate").val(rv["sdate"]);
	    }
	
	}
	
	function viewAttachFile(fileSeq){
		var param = [];
		param["fileSeq"] = fileSeq;
		var win = openPopup("/Upload.do?cmd=fileMgrPopup&authPg=R", param, "740","620");
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr style="display:none;" class="_hideArea">	
						<th>사번/성명</th>		
						<td>  <input type="text" class="text" id="searchSabunName" name="searchSabunName"/></td>
						<th>부서명</th>
						<td colspan=2>  <input id="searchOrgCd" name ="searchOrgCd" type="text" readonly class="text" style="width:60px;"  />
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text"  /> 
							<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a> 
							<input type="checkbox" id="searchIncChldOrg" name="searchIncChldOrg" value="Y"/>하위부서포함
							<input type="hidden" id="searchOrgSdate" name="searchOrgSdate"/>
						</td>
					</tr>
					<tr>
						<th>신청일자</th>
						<td>  <input type="text" class="text date2" id="searchFromApplYmd" name="searchFromApplYmd"/>
							~
							<input type="text" class="text date2" id="searchToApplYmd" name="searchToApplYmd"/>
						</td>
						<th>업무구분</th>
						<td>
							<select id="searchEmpTable" name="searchEmpTable" style="min-width:100px;"></select>
						</td>
						<th>처리상태</th>
						<td>
							<select id="searchApplStatusCd" name="searchApplStatusCd" style="min-width:100px;"></select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="60%" />
		<col width="" />
	</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">개인정보변경 신청관리</li>
							<li class="btn _hideArea" style="display:none;">
								<table><tr>
								<td><input type="checkbox" id="mailYn" name="mailYn" style="margin-bottom:-2px;" value="Y" checked/>&nbsp; 메일</td>
								<td><input type="checkbox" id="smsYn" name="smsYn" style="margin-bottom:-2px;" value="Y"/>&nbsp; SMS</td>
								<td><input type="checkbox" id="gwYn" name="gwYn" style="margin-bottom:-2px;" value="Y" />&nbsp; 그룹웨어알림</td>
								<td><a href="javascript:doAction1('Save')" 	class="basic authA">저장</a></td>
								<td><a href="javascript:doAction1('Accept')" class="basic authA">일괄반영</a></td>
								<td><a href="javascript:doAction1('Reject')" 	class="basic authA">일괄반려</a></td>
								</tr></table>
								
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "65%", "100%","kr"); </script>
				
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">개인정보변경 상세내역</li>
							<li class="btn _hideArea" style="display:none;">
								<a href="javascript:doAction2('Accept')" class="basic authA">반영</a>
								<a href="javascript:doAction2('Reject')" 	class="basic authA">반려</a>
								
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "35%", "50%","kr"); </script>
				<table border="0" cellpadding="0" cellspacing="0" class="default" id="dataTable">
					<colgroup>
						<col width="50" />
						<col width="" />
					</colgroup>
					<tr>
						<th>회답</th>
						<td>
							<textarea id="returnMessage" name="returnMessage" style="width:100%;" rows=5></textarea>
						</td>
					</tr>
					<tr class="_hideArea" style="display:none;">	
						<th>오류내용</th>
						<td>
							<textarea id="errorLog" name="errorLog" style="width:100%;" rows=5 readonly></textarea>
						</td>
					</tr>
					<tr class="_hideArea" style="display:none;">	
						<th>메모</th>
						<td>
							<textarea id="memo" name="memo" style="width:100%;" rows=5></textarea>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>