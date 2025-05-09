<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>퇴직설문지</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>퇴직설문지</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<c:choose>
	<c:when test="${authPg == 'A'}">
		<c:set var="textCss"		value="text" />		
	</c:when>
	<c:otherwise>
		<c:set var="textCss" 		value="text transparent" />
	</c:otherwise>
</c:choose>
<style type="text/css">
	#table1 th {
		padding : 0px;
	}
	
	.GridMain1 .GridMain2 .GMRadio0Left, .GridMain1 .GridMain2 .GMRadio1Left, .GridMain1 .GridMain2 .GMRadio2Left, .GridMain1 .GridMain2 .GMRadio3Left, .GridMain1 .GridMain2 .GMRadioRO0Left, .GridMain1 .GridMain2 .GMRadioRO1Left, .GridMain1 .GridMain2 .GMRadioRO2Left, .GridMain1 .GridMain2 .GMRadioRO3Left {
		padding-left : 25px !important;
	}
	
	.txt_sub {
		font-size: 12px;
		font-weight: bold;
	}
	
	#surveyTable td {
		border: 1px solid #e7edf0;
	}
	
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var gPRow = "";
var pGubun = "";
var answerCd = "";
var authPg = "${authPg}";
	$(function(){
	
		//리스트 화면에서 넘어온값 셋팅(상세보기)
		var arg = p.popDialogArgumentAll();
		var sabun 			= arg["sabun"];
		var reqDate 		= arg["reqDate"];
		var applSeq 		= arg["applSeq"];
		$("#sabun").val(sabun);
		$("#reqDate").val(reqDate);
		$("#applSeq").val(applSeq);
		
		//만족도
		answerCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H91920"), "");

		
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msPrevColumnMerge};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"항목",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"gubun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
			{Header:"질의 내용",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"question",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100, ToolTip:1},
			{Header:"만족도",			Type:"Text",		Hidden:0,	Width:400,	Align:"Center",	ColMerge:0,	SaveName:"answer",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"신청서순번",		Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"순번",			Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"정렬순서",		Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sortNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"사유및개선사항",	Type:"Text",		Hidden:1,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"기타사항",		Type:"Text",		Hidden:1,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"surveyMemo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
		
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:0,	Width:45,	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"항목",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"gubun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"질의 내용",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"question",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ToolTip:1},
			{Header:"사유 및 개선사항",	Type:"Text",		Hidden:0,	Width:370,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000, EnterMode:1, MultiLineText:1, ToolTip:1}
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);
		
		
		//
		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
		
		doAction1("Search");
	});
	function setValue() {
		if(!checkList()) {
			return;
		}
		
		var saveStr;
		var rtn;

      	//저장
		try{
			saveStr = sheet1.GetSaveString(0);
			
			if(saveStr.match("KeyFieldError")) {
				return;
			}
			IBS_SaveName(document.srchFrm,sheet1);
			rtn = eval("("+sheet1.GetSaveData("${ctx}/RetireApp.do?cmd=saveRetireSurveyPopList", saveStr + "&"+ $("#srchFrm").serialize())+")");
			
			if(rtn.Result.Code < 1) {
				alert(rtn.Result.Message);
			}else{
				alert("퇴직설문지가 등록되었습니다.");
				var returnValue = new Array(1);
		    	returnValue["surveyYn"] 		= "Y";
		    	
				if(p.popReturnValue) p.popReturnValue(returnValue);
				p.self.close();
			}		
			
		} catch (ex){
			alert("저장중 스크립트 오류발생." + ex);
		}
	}
	
	function checkList() {
		var returnValue = true;
		
		var chkBool = false;
		for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
			if(sheet1.GetCellValue(r,"answer") == "") {
				chkBool = true;
				break;
			}
		}
		if(chkBool) {
			alert("만족도를 전부 선택해 주시기 바랍니다.");
			return false;
		}
		var chkBool_sheet2 = false;
		for(var r = sheet2.HeaderRows(); r<sheet2.RowCount()+sheet1.HeaderRows(); r++){
			if(sheet2.GetCellValue(r,"memo") == "") {
				chkBool_sheet2 = true;
				break;
			}
		}
		
		if(chkBool_sheet2) {
			alert("사유 및 개선사항을 전부 입력해주시기 바랍니다.");
			return false;
		}
		return returnValue;
	}
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/RetireApp.do?cmd=getRetireSurveyPopList", $("#srchFrm").serialize() );
			break;
		}
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/RetireApp.do?cmd=getRetireSurveyPopDisList", $("#srchFrm").serialize() );
			break;		
		case "Insert":
			var row = sheet1.GetSelectRow();
			
			//1.같은값이 있을경우 추가 안함
			var chkDup = false;
			for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
				if(sheet2.GetCellValue(i,"gubun") == sheet1.GetCellValue(row,"gubun") && sheet2.GetCellValue(i,"question") == sheet1.GetCellValue(row,"question")) {
					chkDup = true;
					break;
				}
			}
			if(!chkDup) {
				var row2 = sheet2.DataInsert(0);
				sheet2.SetCellValue(row2,"gubun",sheet1.GetCellValue(row,"gubun"));
				sheet2.SetCellValue(row2,"question",sheet1.GetCellValue(row,"question"));
			}
			
			break;			
		}
	}
	
	// Sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			var surveyMemo = "";
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				//만족도 Radio로 변경
				var info = {Type: "CheckBox", Align: "Left", ItemText: answerCd[0], ImgAlign:"Left", ItemCode: answerCd[1], MaxCheck: 1, RadioIcon: 1,ShowMobile: 0};
		        sheet1.InitCellProperty( r,"answer" ,info);
		        if(surveyMemo == "") {
		        	surveyMemo = sheet1.GetCellValue(r,"surveyMemo");
		        }
		        
		        if(sheet1.GetCellValue(r,"sStatus") == "R") {
					sheet1.SetCellValue(r,"sStatus","U");
				}
			}
			
			$("#surveyMemo").val(surveyMemo);
			$("#surveyMemoHid").val(surveyMemo);
			
			doAction2("Search");
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// Sheet2 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//답변값 변경시 발생.
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		try{
			if(sheet1.ColSaveName(Col) == "answer" && Row >= sheet1.HeaderRows()) {
				if(Value != OldValue) {
					//불만족 이하의 데이터일 경우에만 해당
					/*
					if(Value == "1" || Value == "2") {
						//1.같은값이 있을경우 추가 안함
						var chkDup = false;
						for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
							if(sheet2.GetCellValue(i,"gubun") == sheet1.GetCellValue(Row,"gubun") && sheet2.GetCellValue(i,"question") == sheet1.GetCellValue(Row,"question")) {
								chkDup = true;
								break;
							}
						}
						if(!chkDup) {
							var row2 = sheet2.DataInsert(0);
							sheet2.SetCellValue(row2,"gubun",sheet1.GetCellValue(Row,"gubun"));
							sheet2.SetCellValue(row2,"question",sheet1.GetCellValue(Row,"question"));
						}
					} else {
						var chkRow = "";
						for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
							if(sheet2.GetCellValue(i,"gubun") == sheet1.GetCellValue(Row,"gubun") && sheet2.GetCellValue(i,"question") == sheet1.GetCellValue(Row,"question")) {
								chkRow = i;
								break;
							}
						}
						sheet2.RowDelete(i,0);
						sheet1.SetCellValue(Row,"memo","");
					}
					*/
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	//답변값 변경시 발생.
	function sheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		try{
			if(sheet2.ColSaveName(Col) == "memo" && Row >= sheet2.HeaderRows()) {
				if(Value != OldValue) {
					//sheet2의 사유 및 개선사항이 변경될경우 sheet1에 저장
					//1.같은값이 있을경우 추가 안함
					for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
						if(sheet2.GetCellValue(Row,"gubun") == sheet1.GetCellValue(i,"gubun") && sheet2.GetCellValue(Row,"question") == sheet1.GetCellValue(i,"question")) {
							sheet2.SetCellValue(i,"sStatus","U");
							sheet1.SetCellValue(i,"memo",sheet2.GetCellValue(Row,"memo"));
							break;
						}
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	//기타사항 변경시 
	function changeMemo (val) {
		$("#surveyMemoHid").val(val);
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li>퇴직설문지</li>
			<li class="close"></li>
		</ul>
	</div>
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="sabun" name="sabun" />
		<input type="hidden" id="reqDate" name="reqDate" />
		<input type="hidden" id="applSeq" name="applSeq" />
		<input type="hidden" id="surveyMemoHid" name="surveyMemoHid" />
	</form>
	
	<div class="popup_main">
		<div class="outer">
			<div class="sheet_title">
			<ul>
				<li class="txt_sub">※ 회사와 선후배 및 동료를 아끼는 마음에서 진실하고 성의있는 답변을 바랍니다. </li>	
			</ul>
			</div>
		</div>
		
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "30%", "${ssnLocaleCd}"); </script>
		
		<div class="outer">
			<div class="sheet_title">
			<ul>
			<!-- <li class="txt_sub">※ 상기 내용중 불만족의 경우 그 사유나 개선사항은 무엇이라 생각하십니까?</li> -->	
				<li class="btn">
					<btn:a href="javascript:doAction2('Insert')" css="basic authA" mid='110700' mdef="입력"/>
				</li>				
			</ul>
			</div>
		</div>
		
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "200px", "${ssnLocaleCd}"); </script>
		
		<div class="outer">
			<div class="sheet_title">
			<ul>
				<li class="txt_sub">※ 기타 회사발전을 위한 제언이나 바라는 부분이 있으면 기술하여 주시기 바랍니다.</li>	
			</ul>
			</div>
			<table class="table" id="surveyTable">
                <colgroup>
                    <col width="">
                </colgroup>
                <tbody>
                    <tr>
                        <td colspan="3">
                        	<textarea id="surveyMemo" name="surveyMemo" rows="3" cols="" class="w100p ${textCss} ${readonly}" ${readonly} required onchange="changeMemo(this.value)"></textarea>
                        </td>
                    </tr>
                </tbody>
            </table>
		</div>
		<div class="popup_button">
		<ul>
			<li>
				<btn:a href="javascript:setValue();" css="pink large authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:p.self.close();" css="gray large authR" mid='close' mdef="닫기"/>
			</li>
		</ul>
	</div>
	</div>
	
</div>

</body>
</html>