<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>동호회()가입/탈퇴신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<c:set var="curSysYyyyMMddHHmmssHyphen"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm:ss" /></c:set>
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
	var adminRecevYn     = "N"; //수신자 여부
	var closeYn;				//마감여부
	var readonly = "${readonly}";
	

	$(function() {
		
		parent.iframeOnLoad(220);
		
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
		var clubList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getClubrefAppDetClubCode"+param, false).codeList, "선택");
		$("#clubSeq").html(clubList[2]);
		
		//동호회명 선택시
		$('#searchForm').on('change', 'select[name="clubSeq"]',function() {
			if (!$("#clubSeq").val()) {
				$("#clubNm").val("");
				$("#clubFee").val("");
				$("#sabunA").val("");
				$("#sabunB").val("");
				$("#sabunC").val("");
				$("#sabunAView").val("");
				$("#sabunBView").val("");
				$("#sabunCView").val("");
				$("#yearInCnt").val("");
				$("#yearOutCnt").val("");
				$("#memerCnt").val("");
				sheet1.RemoveAll();
				inOutCountViewChk();
				return;
			}
			
			var isDisabled = $("#clubSeq").is(":disabled");
			$("#clubSeq").attr("disabled",false);
			
			//동호회 정보
			var map = ajaxCall( "${ctx}/ClubrefApp.do?cmd=getClubrefAppDetClubMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){
				var data = map.DATA;
				$("#clubNm").val(data.clubNm);
				$("#clubFee").val(data.clubFee).focusout();
				$("#sabunA").val(data.sabunA);
				$("#sabunB").val(data.sabunB);
				$("#sabunC").val(data.sabunC);
				$("#sabunAView").val(data.sabunAView);
				$("#sabunBView").val(data.sabunBView);
				$("#sabunCView").val(data.sabunCView);
				$("#yearInCnt").val(data.yearInCnt);
				$("#yearOutCnt").val(data.yearOutCnt);
			}
			
			getClubrefAppDetMember();
			$("#clubSeq").attr("disabled",isDisabled);
			
			inOutCountViewChk();
		});
		
		$('#clubFee').mask('000,000,000,000,000', { reverse : true });
		$("#actPlan, #budPlan, #etcNote, #note").maxbyte(4000);
		$("#purpose").maxbyte(1000);
		
		inOutCountViewChk();
		
		init_sheet();
		
		doAction("Search"); 
		
	});
	
function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0,FrozenColRight:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata.Cols = [
			
				{Header:"No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:1 },
				{Header:"상태",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus"},
				{Header:"부서",			Type:"Text",   	Hidden:0, Width:90, 	Align:"Left",   ColMerge:0,  SaveName:"orgNmSheet", 		Edit:0},
				{Header:"성명",			Type:"Text",   	Hidden:0, Width:70,		Align:"Center", ColMerge:0,  SaveName:"nameSheet", 			Edit:0},
				{Header:"직위",			Type:"Text",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNmSheet", 		Edit:0},
				{Header:"급여공제동의일시",Type:"Date",	Hidden:0, Width:110,	Align:"Center",	ColMerge:0,	 SaveName:"agreeDateSheet",		KeyField:0,	Format:"YmdHm",	Edit:0 },
				{Header:"서명이미지", 	Type:"Image", 	Hidden:0, Width:80,		Align:"Center", ColMerge:1,  SaveName:"fileSeqUrlSheet", 	Format:"", 	UpdateEdit:0, InsertEdit:0, ImgWidth:80, ImgHeight:30},
				{Header:"비고",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left", 	ColMerge:0,  SaveName:"noteSheet", 			Edit:1},
				
				//Hidden
  				{Header:"Hidden",	Hidden:1, SaveName:"sabunSheet"},
  				{Header:"Hidden",	Hidden:1, SaveName:"clubSeqSheet"},
  				{Header:"Hidden",	Hidden:1, SaveName:"sdateSheet"},
  				{Header:"Hidden",	Hidden:1, SaveName:"cntSheet"},
	  			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(1); //편집불가 배경색 적용안함
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			$("#memerCnt").val("");
			if (sheet1.LastRow() > 0) {
				var cnt      = sheet1.GetCellValue(sheet1.LastRow(),"cntSheet");
				$("#memerCnt").val(nvl(cnt,''));
			}
			inOutCountViewChk();
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search" :
			// 입력 폼 값 셋팅
			var map = ajaxCall( "${ctx}/ClubrefApp.do?cmd=getClubrefAppDetMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){
				var data = map.DATA;
				
				$("#year").val(data.year);
				$("#clubSeq").val(data.clubSeq);
				$("#clubSeq").change();
				$("#clubNm").val(data.clubNm);
				$("#clubFee").val(data.clubFee).focusout();
				$("#sabunA").val(data.sabunA);
				$("#sabunB").val(data.sabunB);
				$("#sabunC").val(data.sabunC);
				$("#sabunAView").val(data.sabunAView);
				$("#sabunBView").val(data.sabunBView);
				$("#sabunCView").val(data.sabunCView);
				$("#memerCnt").val(data.memerCnt);
				$("#yearInCnt").val(data.yearInCnt);
				$("#yearOutCnt").val(data.yearOutCnt);
				$("#purpose").val(data.purpose);
				$("#actPlan").val(data.actPlan);
				$("#budPlan").val(data.budPlan);
				$("#etcNote").val(data.etcNote);
				$("#note").val(data.note);
			}else{
			}
			inOutCountViewChk();
			break;
			
		}
	}
	
	function getClubrefAppDetMember(){
		var sXml = sheet1.GetSearchData("${ctx}/ClubrefApp.do?cmd=getClubrefAppDetMember", $("#searchForm").serialize(),false);
		sheet1.LoadSearchData(sXml );
	}
	
	function downClubrefAppDetMember(){
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
		sheet1.Down2Excel(param);
	}

	// 입력시 조건 체크
	function checkList(status) {
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
		
		var data = ajaxCall( "${ctx}/ClubrefApp.do?cmd=getClubrefAppDetDupChk", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			alert("해당 동호회에 중복신청 건이 있어 신청 할 수 없습니다.");
			return false;
		}

		return ch;
	}

	// 저장후 리턴함수
	function setValue(status) {
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
		        		sheet1.SetCellValue(i, "sStatus", "U");
					}
		        	
		        	//폼에 시트 변경내용 저장
		        	IBS_SaveName(document.searchForm,sheet1);
		        	var saveStr = sheet1.GetSaveString(0);
					if(saveStr=="KeyFieldError"){
						return false;
					}
					var rtn = eval("("+sheet1.GetSaveData("${ctx}/ClubrefApp.do?cmd=saveClubrefAppDet", saveStr+"&"+$("#searchForm").serialize())+")");
	
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
	
	function inOutCountViewChk() {
		if ($("#memerCnt").val()) {
			$(".memerCntArea").show();
		} else {
			$(".memerCntArea").hide();
		}
		
		if ($("#yearInCnt").val()) {
			$(".inOutCountArea").show();
		} else {
			$(".inOutCountArea").hide();
		}
	}
	
	//-----------------------------------------------------------------------------------
	//	 팝업
	//-----------------------------------------------------------------------------------
	function empSearchClean(targetId) {
		$( ("#"+targetId) ).val("");
		$( ("#"+targetId+"View") ).val("");
	}
	
	function empSearchPopup(targetId) {
		var rv = null;
		if(!isPopup()) {return;}
		pGubun = "employeePopup";
		pGubunSabun = targetId;
		var args    = new Array();
		
		//openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
        let layerModal = new window.top.document.LayerModal({
            id : 'employeeLayer'
            , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
            , parameters : args
            , width : 740
            , height : 520
            , title : '사원조회'
            , trigger :[
                {
                    name : 'employeeTrigger'
                    , callback : function(result){
                        $( ("#"+pGubunSabun) ).val(result.sabun);
                        $( ("#"+pGubunSabun+"View") ).val(result.name);
                    }
                }
            ]
        });
        layerModal.show();
        
	}
	
	//신청 후 리턴
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "employeePopup"){
			$( ("#"+pGubunSabun) ).val(rv["sabun"]);
			$( ("#"+pGubunSabun+"View") ).val(rv["name"]);
		}
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
			<th>신청년도</th>
			<td colspan="3">
				<input type="text" id="year" name="year" class="${textCss} ${required} transparent w150" readonly value="${curSysYear}"/>
			</td>
		</tr>
		<tr>
			<th>동호회명</th>
			<td>
				<select id="clubSeq" name="clubSeq" class="${selectCss} ${required} w150 " ${disabled}></select>
			</td>
			<th>동호회명(수정)</th>
			<td>
				<input type="text" id="clubNm" name="clubNm" class="${textCss} w150" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>목적</th>
			<td colspan="3">
				<input type="text" id="purpose" name="purpose" class="${textCss} ${required} w100p" ${readonly} maxlength="1000"/>
			</td>
		</tr>
		<tr>
			<th>동호회비</th>
			<td colspan="3">
				<input type="text" id="clubFee" name="clubFee" class="${textCss} ${required} w150" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>회장</th>
			<td>
				<input type="text" id="sabunAView" name="sabunAView" class="${textCss} ${required} transparent w130" disabled style="border: 1px solid #0ab260 ${authPg eq 'A' ? '!important' : '' }; margin-right: 5px;"/>
				<input type="hidden" id="sabunA" name="sabunA" class="${required}"/>
				<a href="javascript:empSearchClean('sabunA');" id="empSearchCleanA" class="button6 isView" style="margin-right: 5px;"/><img src="/common/${theme}/images/icon_undo.gif"/></a>
				<a href="javascript:empSearchPopup('sabunA');" id="empSearchPopupA" class="button6 isView"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
			<th>총무</th>
			<td>
				<input type="text" id="sabunBView" name="sabunBView" class="${textCss} transparent w130" disabled style="margin-right: 5px;"/>
				<input type="hidden" id="sabunB" name="sabunB"/>
				<a href="javascript:empSearchClean('sabunB');" id="empSearchCleanB" class="button6 isView" style="margin-right: 5px;"/><img src="/common/${theme}/images/icon_undo.gif"/></a>
				<a href="javascript:empSearchPopup('sabunB');" id="empSearchPopupB" class="button6 isView"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
			<th class="hide">고문</th>
			<td class="hide">
				<input type="text" id="sabunCView" name="sabunCView" class="${textCss} transparent w130" disabled style="margin-right: 5px;"/>
				<input type="hidden" id="sabunC" name="sabunC"/>
				<a href="javascript:empSearchClean('sabunC');" id="empSearchCleanC" class="button6 isView"style="margin-right: 5px;"/><img src="/common/${theme}/images/icon_undo.gif"/></a>
				<a href="javascript:empSearchPopup('sabunC');" id="empSearchPopupC" class="button6 isView"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
		</tr>
		<tr>
			<th>회원수</th>
			<td>
				<input type="text" id="memerCnt" name="memerCnt" class="${textCss} transparent right w30" readonly />
				<span class="memerCntArea">명</span>
			</td>
			<th>전년도 가입/탈퇴</th>
			<td>
				<span class="inOutCountArea">가입</span>
				<input type="text" id="yearInCnt" name="yearInCnt" class="inOutCountArea ${textCss} transparent right w20" readonly />
				<span class="inOutCountArea">명&nbsp; / &nbsp;탈퇴&nbsp;</span>
				<input type="text" id="yearOutCnt" name="yearOutCnt" class="inOutCountArea ${textCss} transparent right w20" readonly />
				<span class="inOutCountArea">명</span>
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td colspan="3">
				<input type="text" id="note" name="note" class="${textCss} w100p" ${readonly} maxlength="1000"/>
			</td>
		</tr>
		<tr>
			<th>활동계획<br>(구체적 작성)</th>
			<td colspan="3">
				<textarea id="actPlan" name="actPlan" rows="10" class="${textCss} ${required} w100p" ${readonly}  maxlength="1500"></textarea>
			</td>
		</tr>
		<tr>
			<th>예산계획</th>
			<td colspan="3">
				<textarea id="budPlan" name="budPlan" rows="10" class="${textCss} ${required} w100p" ${readonly}  maxlength="1500"></textarea>
			</td>
		</tr>
		<tr>
			<th>특기사항</th>
			<td colspan="3">
				<textarea id="etcNote" name="etcNote" rows="5" class="${textCss} w100p" ${readonly}  maxlength="1500"></textarea>
			</td>
		</tr>
	</table>
	<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">동호회 급여공제동의이력</li> 
			<li class="btn"> 
				<btn:a href="javascript:downClubrefAppDetMember();" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
	</div>
	</form>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "300px", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>