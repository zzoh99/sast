<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>동호회가입/탈퇴신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var searchApplSeq    = "${searchApplSeq}";
	var adminYn          = "${adminYn}";
	var authPg           = "${authPg}";
	var searchApplSabun  = "${searchApplSabun}";
	var searchApplInSabun= "${searchApplInSabun}";
	var searchApplYmd    = "${searchApplYmd}";
	var applStatusCd	 = "";
	var applYn	         = "";
	var pGubun           = "";
	var pGubunSabun      = "";
	var gPRow 			 = "";
	var hdn 			 = 1;
	var adminRecevYn     = "N"; //수신자 여부
	var closeYn;				//마감여부
	var readonly = "${readonly}";
	var p = eval("${popUpStatus}");
	var divCd   = "${etc01}"; // 신청페이지에서 신청분기 전달해줌
	
	$(function() {
		
		parent.iframeOnLoad(220);
		
		$("#divCd").val(divCd);
		$("#spanActPlanTitleDivCd").text( (Number(divCd)+1) == 5 ? 1 : (Number(divCd)+1));
		$("#spanActPlanTitleYear").text( Number(divCd)+1 == 5 ? Number( $("#year").val() )+1 : $("#year").val() );
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		applStatusCd = parent.$("#applStatusCd").val();
		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		//----------------------------------------------------------------
			
		var param = "";
		
		// 신청, 임시저장
		if(authPg == "A") {
		} else if (authPg == "R") {
			$(".isView").hide();
			if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //관리자거나 수신결재자이면
				if( applStatusCd == "31" ){ //수신처리중일 때만 처리관련정보 수정가능
				}
				adminRecevYn = "Y";
			}
		}
		
		param = "&searchApplSabun="+$("#searchApplSabun").val();
		if (authPg == "R") { //보는 용도면 모든 콤보 리스트 가져오기 (빈값으로 나오는것을 막기 위함)
			param += "&searchAllYn=Y";	
		}
		var clubList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getClubpayAppDetClubCode"+param, false).codeList, "선택");
		$("#clubSeq").html(clubList[2]);
		
		//동호회명 선택시
		$('#searchForm').on('change', 'select[name="clubSeq"]',function() {
			if (!$("#clubSeq").val()) {
				$("#memerCnt").val("");
				$("#sabunAView").val("");
				$("#sabunBView").val("");
				$("#sabunCView").val("");
				$("#bankCd").val("");
				$("#accHolder").val("");
				$("#accNo").val("");
				sheet1.RemoveAll();
				return;
			}
			
			var isDisabled = $("#clubSeq").is(":disabled");
			$("#clubSeq").attr("disabled",false);
			
			//동호회 정보
			var map = ajaxCall( "${ctx}/ClubpayApp.do?cmd=getClubpayAppDetClubMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){
				var data = map.DATA;
				$("#memerCnt").val(data.memerCnt);
				$("#appMon").val(data.appMon).focusout();
				$("#sabunAView").val(data.sabunAView);
				$("#sabunBView").val(data.sabunBView);
				$("#sabunCView").val(data.sabunCView);
				$("#bankCd").val(data.bankCd);
				$("#accHolder").val(data.accHolder);
				$("#accNo").val(data.accNo);
			}
			
			$("#clubSeq").attr("disabled",isDisabled);
		});
		
		$('#appMon').mask('000,000,000,000,000', { reverse : true });
		$("#actPlan, #etcNote").maxbyte(4000);
		
		if(applStatusCd == "11") {
			hdn = 0;
		}
		
		init_sheet();
		
		doAction("Search");
		
		doAction("SearchSheet");
		
	});
	
function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0,FrozenColRight:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata.Cols = [
			
				{Header:"No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:1 },
				{Header:"상태",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus"},
				{Header:"삭제",			Type:"${sDelTy}", Hidden:hdn,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"활동구분",		Type:"Combo",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"actTypeCdSheet", 	KeyField:1, Edit:1},
				{Header:"일자",			Type:"Date",	Hidden:0, Width:80,		Align:"Center",	ColMerge:0,	 SaveName:"ymdSheet",			KeyField:1,	Format:"Ymd",	Edit:1 },
				{Header:"장소",			Type:"Text",   	Hidden:0, Width:100,	Align:"Left", 	ColMerge:0,  SaveName:"locationSheet", 		KeyField:0, Edit:1},
				{Header:"내용",			Type:"Text",   	Hidden:0, Width:150, 	Align:"Left", 	ColMerge:0,  SaveName:"actNoteSheet", 		KeyField:1, Edit:1},
				{Header:"예산집행",		Type:"AutoSum", Hidden:0, Width:70, 	Align:"Right",  ColMerge:0,  SaveName:"actMonSheet", 		KeyField:1, Edit:1},
				{Header:"비고",			Type:"Text",   	Hidden:0, Width:150, 	Align:"Left", 	ColMerge:0,  SaveName:"noteSheet", 			KeyField:0, Edit:1},
				
				//Hidden
  				{Header:"Hidden",	Hidden:1, SaveName:"seqSheet"},
	  			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(1); //편집불가 배경색 적용안함
		
		//==============================================================================================================================
		var grpCds = "B50720,H30001";
 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
 		sheet1.SetColProperty("actTypeCdSheet",  		{ComboText:"|"+codeLists["B50720"][0], ComboCode:"|"+codeLists["B50720"][1]} ); //활동구분
 		$("#bankCd").html(codeLists["H30001"][2]);
		//==============================================================================================================================
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if(sheet1.ColSaveName(Col) == "sDelete" && Value == 1 ) {
				sheet1.RowDelete(Row);
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search" :
			// 입력 폼 값 셋팅
			var map = ajaxCall( "${ctx}/ClubpayApp.do?cmd=getClubpayAppDetMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){
				var data = map.DATA;
				
				$("#clubSeq").val(data.clubSeq);
				$("#year").val(data.year);
				$("#spanActPlanTitleYear").text( Number(data.divCd)+1 == 5 ? Number(data.year)+1 : data.year );
				$("#divCd").val(data.divCd);
				$("#spanActPlanTitleDivCd").text( Number(data.divCd)+1 == 5 ? 1 : Number(data.divCd)+1 );
				$("#appMon").val(data.appMon).focusout();
				$("#bankCd").val(data.bankCd);
				$("#accHolder").val(data.accHolder);
				$("#accNo").val(data.accNo);
				$("#actPlan").val(data.actPlan);
				$("#etcNote").val(data.etcNote);
				$("#note").val(data.note);
				$("#memerCnt").val(data.memerCnt);
				$("#sabunAView").val(data.sabunAView);
				$("#sabunBView").val(data.sabunBView);
				$("#sabunCView").val(data.sabunCView);
			}
			break;
			
		case "SearchSheet" :
			var sXml = sheet1.GetSearchData("${ctx}/ClubpayApp.do?cmd=getClubpayAppDetaActInfo", $("#searchForm").serialize(),false);
			sheet1.LoadSearchData(sXml );
			break;
			
		case "Down2Excel" :
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
			
		case "Insert":
			var row = sheet1.DataInsert(-1);
			break;
				
		}
	}
	
	// 입력시 조건 체크
	function checkList() {
		var ch = true;
		
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
			return ch;
		});
		//필수값 문제 발생시 Stop
		if (!ch) {return ch;}
		
		if( $("#memerCnt").val() && Number($("#memerCnt").val()) < 15 ){
			alert("회원수 15명부터 신청가능합니다");
			return false;
		};
		
		//필수입력 항목 체크
        var saveStr1 = sheet1.GetSaveString(0);
        if(saveStr1.match("KeyFieldError")) { return false; }
		
		var data = ajaxCall( "${ctx}/ClubpayApp.do?cmd=getClubpayAppDetDupChk", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			alert("해당 동호회에 중복신청 건이 있어 신청 할 수 없습니다.");
			return false;
		}

		return ch;
	}

	// 저장후 리턴함수
	function setValue() {
		var returnValue = false;
		try{
			
			// 관리자 또는 수신담당자 경우 지급정보 저장
			if( adminRecevYn == "Y" ){
				returnValue = true;
			}else{

				if ( authPg == "R" )  {return true;}
				
		        // 항목 체크 리스트
		        if ( !checkList() ) {return false;}
		        
		        // 신청서 저장
		        if ( authPg == "A" ){
		        	
		        	for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
		        		sheet1.SetCellValue(i, "sStatus", "U", 0);
		        		sheet1.SetCellValue(i, "seqSheet", i, 0);
					}
		        	
		        	//폼에 시트 변경내용 저장
		        	IBS_SaveName(document.searchForm,sheet1);
		        	var saveStr = sheet1.GetSaveString(0);
					if(saveStr=="KeyFieldError"){
						return false;
					}
					var rtn = eval("("+sheet1.GetSaveData("${ctx}/ClubpayApp.do?cmd=saveClubpayAppDet", saveStr+"&"+$("#searchForm").serialize())+")");
	
					if(rtn.Result.Code < 1) {
						alert(rtn.Result.Message);
						returnValue = false;
					} else {
						returnValue = true;
					}
	
				}
			}
		}
		catch(ex){
			alert("Error!" + ex);
			returnValue = false;
		}
		return returnValue;
	}
	

</script>
<style type="text/css">
label {
	vertical-align:-2px;padding-right:10px;
}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	<input type="hidden" id="note"				name="note"	     		 value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="35%" />
			<col width="120px" />
			<col width="35%" />
		</colgroup>
		<tr>
			<th>동호회명</th>
			<td>
				<select id="clubSeq" name="clubSeq" class="${selectCss} ${required} w150 " ${disabled}></select>
			</td>
			<th>신청분기</th>
			<td>
				<input type="text" id="year" name="year" value="${curSysYear}" class="${textCss} ${required} transparent right w50" readonly />
				<span class="">년</span>
				<input type="text" id="divCd" name="divCd" class="${textCss} ${required} transparent right w10" readonly />
				<span class="">분기</span>
			</td>
		</tr>
		<tr>
			<th>회원수</th>
			<td colspan="3">
				<input type="text" id="memerCnt" name="memerCnt" class="${textCss} transparent right w20" readonly />
			</td>
		</tr>
		<tr>
			<th>회장</th>
			<td>
				<input type="text" id="sabunAView" name="sabunAView" class="${textCss} transparent w150" readonly />
			</td>
			<th>총무</th>
			<td>
				<input type="text" id="sabunBView" name="sabunBView" class="${textCss} transparent w150" readonly />
			</td>
			<th class="hide">고문</th>
			<td class="hide">
				<input type="text" id="sabunCView" name="sabunCView" class="${textCss} transparent w150" readonly />
			</td>
		</tr>
		<tr>
			<th>신청금액</th>
			<td>
				<input type="text" id="appMon" name="appMon" class="${textCss} ${required} w150" />
			</td>
			<th>입금은행</th>
			<td>
				<select id="bankCd" name="bankCd" class="${selectCss} ${required}" ${disabled}></select>
			</td>
		</tr>
		<tr>
			<th>예금주</th>
			<td>
				<input type="text" id="accHolder" name="accHolder" class="${textCss} ${required} w80" ${readonly} maxlength="30"/>
			</td>
			<th>계좌번호</th>
			<td>
				<input type="text" id="accNo" name="accNo" class="${textCss} ${required} w200" ${readonly} maxlength="50"/>
			</td>
		</tr>
	</table>
	<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">전분기 활동사항 (구체적으로 기재)</li> 
			<li class="btn"> 
				<a href="javascript:doAction('Insert');" class="btn outline-gray authA">입력</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "300px", "${ssnLocaleCd}"); </script>
	<div class="sheet_title">
		<ul>
			<li class="txt">
				<span id="spanActPlanTitleYear" class="f_blue">${curSysYear}</span>
				<span class="f_blue">년&nbsp;</span>
				<span id="spanActPlanTitleDivCd" class="f_blue"></span>
				<span class="f_blue"> 분기</span>
				<span class="">&nbsp;활동계획 (구체적으로 기재)</span>
			</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="" />
		</colgroup>
		<tr>
			<td class="hide">활동계획</td>
			<td colspan="2">
				<textarea id="actPlan" name="actPlan" rows="10" class="${textCss} ${required} w100p" ${readonly}  maxlength="1500"></textarea>
			</td>
		</tr>
	</table>
	<div class="sheet_title">
		<ul>
			<li class="txt">특기사항</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="" />
		</colgroup>
		<tr>
			<td colspan="2">
				<textarea id="etcNote" name="etcNote" rows="5" class="${textCss} w100p" ${readonly}  maxlength="1500"></textarea>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
</html>