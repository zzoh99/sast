<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>리조트(성수기)신청</title>
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
	var gPRow 			 = "";
	var adminRecevYn     = "N"; //수신자 여부
	var closeYn;				//마감여부
	var readonly		 = "${readonly}";
	var planSeq		 	 = "${etc01}"; // 신청페이지에서 성수기 순번값 (planSeq)를 전달해줌

	$(function() {
		
		parent.iframeOnLoad(220);
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#planSeqSheet").val(planSeq);
		$("#planSeq").val(planSeq);
		applStatusCd = parent.$("#applStatusCd").val();
		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		$('.money').mask('000,000,000,000,000', { reverse : true });
		//----------------------------------------------------------------
			
		var param = "";
		
		// 신청, 임시저장
		if(authPg == "A") {
		} else if (authPg == "R") {
			if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //관리자거나 수신결재자이면
				if( applStatusCd == "31" ){ //수신처리중일 때만 지급정보 수정 가능
					/* $("#statusCd1").removeClass("transparent").removeClass("hideSelectButton").removeAttr("disabled");
					$("#applMon").removeClass("transparent").removeAttr("readonly"); */
				}
				adminRecevYn = "Y";
			}
		}
		
		var hopeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B49550"), "선택");
		$("#hopeCd").html(hopeCdList[2]);
		
		var companyCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B49530"), "");
		$("#companyCd").html(companyCdList[2]);
		
		init_sheet();
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//form 조회
		doAction("Search");
		
		//sheet 조회
		doAction("SearchSheet");
		
		if (authPg == "R") {$("#DIV_sheet1").hide();}
	});
	
	//Sheet 초기화
	function init_sheet(){
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"선택",			Type:"Html",		Hidden:(authPg != "A")?1:0, 	Width:60,	 Align:"Center", SaveName:"btnSel",		Edit:0 },

			{Header:"리조트명",		Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"companyCd",	Edit:0 },
			{Header:"지점명",		Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"resortNm",	Edit:0 },
			{Header:"객실타입",		Type:"Text",		Hidden:0,	Width:170,	Align:"Left",	ColMerge:0,	SaveName:"roomType",	Edit:0 },
			{Header:"체크인",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		Format:"Ymd", 	Edit:0 },
			{Header:"체크아웃",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"edate",		Format:"Ymd", 	Edit:0 },
			{Header:"박수",			Type:"Text",		Hidden:0,	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"days",		Edit:0 },
			{Header:"이용금액",		Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"resortMon",	Format:"",	Edit:0 },
			{Header:"지원금액",		Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"comMon",		Format:"",	Edit:0 },
			{Header:"개인부담금",	Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"psnalMon",	Format:"",	Edit:0 },
			{Header:"신청\n건수",	Type:"Text",		Hidden:0,	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"applCnt",		Edit:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"planSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"resortSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"rsvNo1"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"rsvNo2"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"companyCdNm"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"targetYn"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"closeYn"},

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);
  		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

		
 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "B49530";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("companyCd",  	{ComboText:"|"+codeLists["B49530"][0], ComboCode:"|"+codeLists["B49530"][1]} ); //리조트명 
		//==============================================================================================================================
			
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
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
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "btnSel" ) {
		    	$("#companyCd").val(sheet1.GetCellValue(Row, "companyCd"));
		    	$("#resortNm").val(sheet1.GetCellValue(Row, "resortNm"));
		    	$("#roomType").val(sheet1.GetCellValue(Row, "roomType"));
		    	$("#sdate").val(sheet1.GetCellValue(Row, "sdate"));
		    	$("#edate").val(sheet1.GetCellValue(Row, "edate"));
		    	$("#days").val(sheet1.GetCellValue(Row, "days"));
		    	$("#span_days").html(sheet1.GetCellValue(Row, "days")+'<tit:txt mid="L19080600006" mdef="박" />');
		    	$("#resortMon").val(sheet1.GetCellValue(Row, "resortMon")).focusout();
		    	$("#comMon").val(sheet1.GetCellValue(Row, "comMon")).focusout();
		    	$("#psnalMon").val(sheet1.GetCellValue(Row, "psnalMon")).focusout();
		    	$("#planSeq").val(sheet1.GetCellValue(Row, "planSeq"));
		    	$("#resortSeq").val(sheet1.GetCellValue(Row, "resortSeq"));
		    	$("#rsvNo1").val(sheet1.GetCellValue(Row, "rsvNo1"));
		    	$("#rsvNo2").val(sheet1.GetCellValue(Row, "rsvNo2"));
		    	$("#targetYn").val(sheet1.GetCellValue(Row, "targetYn"));
		    	$("#closeYn").val(sheet1.GetCellValue(Row, "closeYn"));
		    	$("#companyCdNm").val(sheet1.GetCellValue(Row, "companyCdNm"));
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
		
	//지원받은 신청건 있는지 조회 return => 신청가능:true 신청불가능:false 
	function getResortSeasonAppDetChkComMon(boolAlert) {
	
		//신청건수가 리턴됨
		var data = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortSeasonAppDetChkComMon", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			if (boolAlert) {
				alert("이미 지원받은 이력이 있어 신청할 수 없습니다.");
			}
			return false;
		}	
		return true;
	}
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search" :
			// 입력 폼 값 셋팅
			var map = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortSeasonAppDetMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){ 
				var data = map.DATA;
				
				$("#companyCd").val(data.companyCd);
				$("#companyCdNm").val(data.companyCdNm);
				$("#resortNm").val(data.resortNm);
				$("#sdate").val(formatDate(data.sdate, "-"));
				$("#edate").val(formatDate(data.edate, "-"));
				$("#roomType").val(data.roomType);
				$("#days").val(data.days);
				$("#phoneNo").val(data.phoneNo);
				$("#mailId").val(data.mailId);
				//$("#cnt").val(data.cnt);
				$("#note").val(data.note);
				$("#planSeq").val(data.planSeq);
				$("#resortSeq").val(data.resortSeq);
				$("#targetYn").val(data.targetYn);
				
				$("#hopeCd").val(data.hopeCd);
				$("#rsvNo1").val(data.rsvNo1);
				$("#rsvNo2").val(data.rsvNo2);
				$("#resortMon").val(makeComma(data.resortMon));
				$("#comMon").val(makeComma(data.comMon));
				$("#psnalMon").val(makeComma(data.psnalMon));

			}else{
				var map2 = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortSeasonAppDetMap2",$("#searchForm").serialize(),false);
				if ( map2 != null && map2.DATA != null ){ 
					var data = map2.DATA;
					$("#phoneNo").val(data.phoneNo);
					$("#mailId").val(data.mailId);
				}
			}
			
		case "SearchSheet":
			var sXml = sheet1.GetSearchData("${ctx}/ResortApp.do?cmd=getResortSeasonAppDetResortList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
        	break;
        	
		}
	} 

	// 입력시 조건 체크
	function checkList() {
		var ch = true;
		
		if(!$("#resortSeq").val()){alert("리조트를 선택하여 주시기 바랍니다."); return false;}
		
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
		
		if($("#targetYn").val() && $("#targetYn").val() == 'Y'){
			
			var data = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortSeasonAppDetTargetYn", $("#searchForm").serialize(),false);
			if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			} else {
				alert("해당 사용기간의 지원대상자가 아닙니다.\n대상자 신청후 다시 신청 바랍니다.");
				return false;
			}
			
			//지원받은 기신청건있는지 체크
			var boolChkComMonYn = getResortSeasonAppDetChkComMon(true);
			if (!boolChkComMonYn) { return false;}
			
		}
		
		var data = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortSeasonAppDetChkDupAppl", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			alert("해당 성수기에 동일 희망순번이 존재합니다.\n확인 바랍니다.");
			$("#hopeCd").focus();
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
	
					var rtn = ajaxCall("${ctx}/ResortApp.do?cmd=saveResortSeasonAppDet", $("#searchForm").serialize(), false);
	
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
/*---- checkbox ----*/
input[type="checkbox"]  { 
	display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none; 
 	-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}
label {
	vertical-align:-2px;padding-right:10px;
}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="planSeqSheet"	  name="planSeqSheet"	 value=""/>
	</form>

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
		
	<input type="hidden" id="planSeq"		name="planSeq"	     value=""/>
	<input type="hidden" id="resortSeq"		name="resortSeq"	 value=""/>
	<input type="hidden" id="targetYn"		name="targetYn"	     value=""/>
	<input type="hidden" id="rsvNo1"		name="rsvNo1"	     value=""/>
	<input type="hidden" id="rsvNo2"		name="rsvNo2"	     value=""/>
	<input type="hidden" id="note"			name="note"	    	 value=""/>
	<script type="text/javascript">createIBSheet("sheet1", "100%", (authPg == 'A' ? '150px' : '0px' )); </script>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="30%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
		<tr>
			<th>리조트명</th>
			<td>
				<input type="hidden"  id="companyCd" name="companyCd"/>
				<input type="text" id="companyCdNm" name="companyCdNm" class="text transparent w150" readonly/>
			</td>
			<th>지점명</th>
			<td>
				<input type="text" id="resortNm" name="resortNm" class="text transparent w150" readonly/>
			</td>
		</tr>
		<tr>
			<th>사용기간</th>
			<td>
				<input type="text" id="sdate" name="sdate" class="text transparent w80" readonly/>&nbsp;~&nbsp;
				<input type="text" id="edate" name="edate" class="text transparent w80" readonly/>&nbsp;&nbsp;
				<input type="hidden" id="days" name="days"/><span id="span_days"></span>
			</td>
			<th>희망순번</th>
			<td>
				<select id="hopeCd" name="hopeCd" class="${selectCss} ${required} w100" ${disabled}></select>
			</td>
		</tr>
		<tr>
			<th>객실타입</th>
			<td>
				<input type="text" id="roomType" name="roomType" class="text transparent w150" readonly/>
			</td>
			<th>이용금액</th>
			<td>
				<input type="text" id="resortMon" name="resortMon" class="text transparent w120 money" readonly/>
			</td>
		</tr>
		<tr>
			<th>지원금액</th>
			<td>
				<input type="text" id="comMon" name="comMon" class="text transparent w120 money" readonly/>
			</td>
			<th>개인부담금</th>
			<td>
				<input type="text" id="psnalMon" name="psnalMon" class="text transparent w120 money" readonly/>
			</td>
		</tr>
		<tr>
			<th>연락처</th>
			<td>
				<input type="text" id="phoneNo" name="phoneNo" class="${textCss} ${required} w250" ${readonly}/>
			</td>
			<th>메일주소</th>
			<td>
				<input type="text" id="mailId" name="mailId" class="${textCss} ${required} w250" ${readonly}/>
			</td>
		</tr>
	</table>
</div>
</body>
</html>