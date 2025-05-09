<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='vacationUpdAppDet1' mdef='휴가취소신청 세부내역'/></title>
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
	var searchBApplSeq	 = "${etc01}";
	var applStatusCd	 = "";
	var pGubun           = "";
	var gPRow            = "";
	var holDay           = "0";

	$(function() {
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"No",	  Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",	  Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"gntCd", Type:"Text", Hidden:0, SaveName:"gntCd"},
  			{Header:"sabun", Type:"Text", Hidden:0, SaveName:"sabun"},
  			{Header:"applSeq", Type:"Text", Hidden:0, SaveName:"applSeq"},
  			{Header:"휴가일자",  Type:"Date",	Hidden:0, minWidth:80,	 Align:"Center", ColMerge:1, SaveName:"vacationYmd", KeyField:0,Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
  			{Header:"적용시간",  Type:"Text",	Hidden:0, minWidth:80,	 Align:"Center", ColMerge:1, SaveName:"holDay", KeyField:0,Format:"",	UpdateEdit:0,	InsertEdit:0 },
  			{Header:"종료시간",  Type:"Date",	Hidden:0, minWidth:80,	 Align:"Center", ColMerge:1, SaveName:"reqSHm", KeyField:0,Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
  			{Header:"시작시간",  Type:"Date",	Hidden:0, minWidth:80,	 Align:"Center", ColMerge:1, SaveName:"reqEHm", KeyField:0,Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		parent.iframeOnLoad();
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#searchBApplSeq").val(searchBApplSeq);
		
		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		//----------------------------------------------------------------
		
		if(authPg == "A") {
		} else{
			
		}	
 

		
		//휴가종류  콤보
		var gntGubunCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getVacationAppDetGntGubunList", false).codeList, "");
		$("#gntGubunCd").html(gntGubunCdList[2]);

		//경조구분 콤보
		var occFamCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getVacationAppDetOccCd", false).codeList
		                 , "occHoliday,occCd,famCd"
				         , "선택하세요");
		$("#occFamCd").html(occFamCdList[2]);
		
		//휴가코드
		var gntCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnGntCdList2", false).codeList
		          , "requestUseType,gntUse,baseCnt,gntGubunCd,baseCnt,maxCnt"
				  , "");
		$("#gntCd").html(gntCdList[2]);
		

		doAction("Search"); 
		doAction1("Search");

		$("#startDate, #endDate, #changeDate1, #setDate").bind("blur", function() {
			hourCheck();
		}) ;

	});
	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/VacationApp.do?cmd=getVacationChangeAppDetChangeList", $("#searchForm").serialize() );
			break;
		}
	}

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			
			if(sheet1.RowCount() == 0) { 
				//대체 휴가일자가 입력되지 않았으면 기존 휴가 일자를 보여준다. 
				var list = ajaxCall( "${ctx}/VacationApp.do?cmd=getVacationChangeAppDetList", $("#searchForm").serialize(),false);
				if(list.DATA != null){
					// closeDay가 비어 있을 경우 1로 처리해준다.
					var closeDay = $("#closeDay").val();
					if (isEmpty(closeDay)) closeDay = 1;
					for(var i=0; i < closeDay; i++) {
						$("#changeDate"+ (i+1) ).datepicker2();
						//시작일자부터 +1영업일을 세팅해준다. 
						$("#changeDate"+ (i+1) ).val(formatDate(list.DATA[i].ymd,"-"));
					}
				}
			} else {
				//sheet에 저장된 날짜를 html에 표기하여 준다. 
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){ // i==1
					if(authPg == "A") {
						$("#changeDate"+ i ).datepicker2();
					}
					$("#changeDate"+ i).val(formatDate(sheet1.GetCellValue(i, "vacationYmd"),"-"));	
				}
			}
			
			sheetResize(); 
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	} 
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/VacationApp.do?cmd=getVacationChangeAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 

				$("#gntGubunCd").val( data.DATA.gntGubunCd );
	        	$("#gntCd").val(data.DATA.gntCd);
	        	$("#searchGntCd").val(data.DATA.gntCd);
	        	$("#gntCd").change();
	        	
	        	$("#sYmd").val(formatDate(data.DATA.sYmd,"-"));
	        	$("#eYmd").val(formatDate(data.DATA.eYmd,"-"));
	        	$("#applYmd").val(formatDate(data.DATA.sYmd,"-"));
	        	$("#closeDay").val(data.DATA.closeDay);
	        	$("#holDay").val(data.DATA.holDay);
				$("#reqSHm").val( data.DATA.reqSHm );
				$("#reqEHm").val( data.DATA.reqEHm );
				$("#requestHour").val(  data.DATA.requestHour );
	        	$("#gntReqReason").val(data.DATA.gntReqReason);  

				$("#reqSHm").mask("11:11") ;	
				$("#reqEHm").mask("11:11") ;

				//경조휴가
				$("#occFamCd").val( data.DATA.occFamCd );
				$("#occCd").val( data.DATA.occCd );
				$("#famCd").val( data.DATA.famCd );
				$("#occHoliday").val( data.DATA.occHoliday );
				$("#span_occHoliday").html( data.DATA.occHoliday+"일" );
				var closeDay = data.DATA.closeDay;
				if(closeDay == 0.5){
					closeDay = closeDay * 2;
				}else if (closeDay == 0.25){
					closeDay = closeDay * 4;
				}else{

				}
				// closeDay가 비어 있을 경우 1로 처리해준다.
				if (isEmpty(closeDay)) closeDay = 1;
				holDay = data.DATA.holDay;
				//적용일수에 맞춰서 대체일자 입력폼 보여주기
				changeDateTr = "<tr><th rowspan="+ closeDay +">대체신청일자</th>";
				for(var i=1; i <= closeDay; i++) {
					changeDateTr += "<td colspan='3'>";
					changeDateTr +=	"<input id='changeDate" + i +"' name='changeDate" + i +"' type='text' size='10' class='date2 w70 ${required} required1' ${readonly} />&nbsp;&nbsp;&nbsp;&nbsp;";
					// 종일단위가 아닌 경우 시간을 입력받도록 한다.
					//if(data.DATA.gntGubunCd == '15' ||data.DATA.gntGubunCd == '16'){
					if (data.DATA.requestUseType != 'D') {
						changeDateTr += '<b>시작시간 : </b>&nbsp;&nbsp;<input id="startDate" name="startDate" type="text" class="text w40 center " ${readonly} maxlength="5"/>&nbsp;&nbsp;&nbsp;&nbsp;';
						changeDateTr += '<b>종료시간 : </b>&nbsp;&nbsp;<input id="endDate" name="endDate" type="text" class="text w40 center " ${readonly} maxlength="5"/>&nbsp;&nbsp;&nbsp;&nbsp';
						changeDateTr += '<b>적용시간 : </b>&nbsp;&nbsp;<input id="setDate" name="setDate" type="text" class="text w30 center "  ${readonly} maxlength="4"/>시간</td>';
					}
					changeDateTr += "</tr>"
					if(i+1 < closeDay){
						changeDateTr += "<tr>"
					}
				}

				$("#vacationChangeAppDetTable > tbody > tr").eq(3).after(changeDateTr);
				//console.log(data.DATA);
				if(data.DATA.bReqSHm != ''){

					$("#startDate").val( data.DATA.bReqSHm );
					$("#endDate").val( data.DATA.bReqEHm );
					$("#setDate").val( data.DATA.bRequestHour );
					$("#startDate").mask("11:11") ;
					$("#endDate").mask("11:11") ;
				}


			}
			break;
		}
	}
	function getAttr(eleId, attrNm) {
		var obj = $("#" + eleId);
		var tagName = obj.prop('tagName');


		if(tagName.toUpperCase() == "SELECT") {
			obj = $("option:selected", obj);
		}

		return obj.attr(attrNm);
	}
	//--------------------------------------------------------------------------------
	//  총일수, 적용일수 계산
	//--------------------------------------------------------------------------------
	function dateCheck(obj){
		try{
			var sYmd = $("#startDate").val().replace(/-/gi, "");
			var eYmd = $("#endDate").val().replace(/-/gi, "");

			//반차휴가타입인경우 시작/종료일을 같이 간다.
			if( sYmd != "" && halfYn == "Y"  ) {
				$("#endDate").val( $("#startDate").val() ) ;
				eYmd = sYmd;
			}

			if(sYmd == "" || eYmd == "") return;

			if( eYmd < sYmd  ) {
				alert("시작일과 종료일을 정확히 입력하세요.");
				$(obj).val("");
				return;
			}

			//잔여휴가 표시
			if($("#gntCd").val() != ""){
				showRestDay();
			}

			//총일수 적용일수를 구한다.
			var param = "sabun="+$("#searchApplSabun").val()
					+"&applSeq="+$("#searchApplSeq").val()
					+"&gntCd="+$("#gntCd").val()
					+"&sYmd="+sYmd
					+"&eYmd="+eYmd;
			// 휴일 체크
			var map = ajaxCall("/VacationApp.do?cmd=getVacationAppDetHolidayCnt",param ,false);
			if( map.DATA.authYn == "N") {  // 2020.02.10 추가
				alert("신청 대상자가 아닙니다.");
				$(obj).val("");
				return;
			}
			var dayBetween = getDaysBetween(sYmd , eYmd ) ;
			if(halfYn == "N") {
				$("#holDay").val( dayBetween ) ;
				$("#closeDay").val( dayBetween - map.DATA.holidayCnt) ;
			} else {
				var maxCnt = getAttr("gntCd", "maxCnt");
				$("#holDay").val( maxCnt ) ;
				$("#closeDay").val( maxCnt ) ;
			}

		}catch(e){

		}

	}
	//--------------------------------------------------------------------------------
	//  적용시간 계산
	//--------------------------------------------------------------------------------
	function hourCheck(){
		var requestUseType = getAttr("gntCd", "requestUseType");
		var baseCnt = getAttr("gntCd", "baseCnt");
		var validRequestHour = 0;

		// 휴가종류가 반차,반반차휴가인 경우
		if($("#changeDate1").val() != "" && ( $("#gntGubunCd").val() == "15" || $("#gntGubunCd").val() == "16" )) {
			dateCheck($("#startDate"));

			// 적용시간값 입력
			validRequestHour = 8 * Number(baseCnt);
			$("#setDate").val( validRequestHour ) ;
		}

		if( $("#startDate").val() != "" && $("#endDate").val() != "" && $("#changeDate1").val() != "" ) {
			var param = "sabun="+searchApplSabun
					+"&gntCd="+$("#gntCd").val()
					+"&reqSHm="+$("#startDate").val().replace(":", "")
					+"&reqEHm="+$("#endDate").val().replace(":", "")
					+"&applYmd="+$("#changeDate1").val().replace(/-/gi, "");

			// 적용시간 계산
			var holiDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetHour",param ,false);
			if( holiDayCnt != null && holiDayCnt != undefined && holiDayCnt.DATA != null && holiDayCnt.DATA != undefined ) {
				var requestHour = Number(holiDayCnt.DATA.restTime);

				// 휴가종류가 반차휴가인 경우 시간 입력 체크
				if($("#gntGubunCd").val() == "15" || $("#gntGubunCd").val() == "16")  {
					if( requestHour != validRequestHour ) {
						alert("신청시간을 " + validRequestHour + "단위로 입력하셔야 합니다.");
						$("#endDate").val( "" ) ;
					}
				} else {
					$("#setDate").val( requestHour ) ;
				}
			}
		}
	}

	function logicValidation() {
		
		var returnValue = true;
		
		//대체 입력한 일자별로 확인
		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			
			var param  = "sabun="+sheet1.GetCellValue(i, "sabun");
				param += "&applSeq="+$("#searchBApplSeq").val();
				param += "&gntCd="+sheet1.GetCellValue(i, "gntCd");
				param += "&sYmd="+sheet1.GetCellValue(i, "vacationYmd");
				param += "&eYmd="+sheet1.GetCellValue(i, "vacationYmd");
			// 입력한 일자와 중복되는 신청건이 있는지
			// 입력한 일자가 휴일은 아닌지?
			// 재직상태 및 신청대상자 체크-----------------------------------------------------------------------------------------------
			var statusMap = ajaxCall("/VacationApp.do?cmd=getVacationAppDetStatusCd",param ,false);
			if(statusMap.DATA.statusCd1 != "AA" || statusMap.DATA.statusCd2 != "AA") {
				alert("해당 신청기간에 재직상태가 아닙니다.");
				returnValue = false;
				return false;
			}
	
			if( statusMap.DATA.authYn == "N") {  // 2020.02.10 추가
				alert("신청 대상자가 아닙니다.");
				returnValue = false;
				return false;
			}
			//---------------------------------------------------------------------------------------------------------
			
			// 휴가신청 세부내역(잔여일수,휴일일수) 조회
			var holiDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetDayCnt",param ,false);

			if(holiDayCnt.DATA.valChk == 'EX') {
				alert("신청시작일과 종료일은 동일한 휴가기준기간에 속해 있어야 합니다\.n휴가기준기간에 맞게 나눠서 신청해 주시기 바랍니다.");
				return;
			} else if (holiDayCnt.DATA.valChk == 'NO') {
				alert("신청기간에 속하는 사용가능일이 부여되지 않았습니다.\n인사(휴가)담당자에게 문의하여 주시기 바랍니다.");
				return;
			}
			
			// 기 신청일수 여부 체크
			var applDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetApplDayCnt",param ,false);
			if( parseInt( applDayCnt.DATA.cnt ) > 0) {
				alert("해당 신청기간에 기 신청건이 존재합니다.");
				$("#sYmd").focus();
				returnValue = false;
				return false;
			}
			
			var vacationCheck = ajaxCall("VacationApp.do?cmd=getVacationChangeAppCheck", param, false);
			 /*
			if(vacationCheck.DATA.useYmdYn == "N"){
				alert("신청일자가 사용기간에 포함되지 않습니다.");
				returnValue = false;
				return false;
			} */
			
			if( vacationCheck.DATA.bizDayYn == "N" ){
				alert("휴일이 포함되어 있습니다.");
				returnValue = false ;
				return false;
			}
		}
		return returnValue;
	}
	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		var returnValue = false;
		var count=holDay;
		try {

			if ( authPg == "R" )  {
				return true;
			}

			sheet1.RemoveAll();
			if($("#closeDay").val() == 0.5||$("#closeDay").val() == 0.25){
				count  = 1;
			}
			for(var i=1; i <= count; i++) {
				if($("#changeDate"+i).val() != "") {
					var row = sheet1.DataInsert(0);
					sheet1.SetCellValue(row, "gntCd", $("#searchGntCd").val());
					sheet1.SetCellValue(row, "applSeq", $("#searchApplSeq").val());
					sheet1.SetCellValue(row, "sabun", $("#searchApplSabun").val());
					sheet1.SetCellValue(row, "vacationYmd", $("#changeDate"+i).val());	
				}
			}
			if($("#closeDay").val() == 0.5||$("#closeDay").val() == 0.25){
				count = 0;
			}
			if(count > sheet1.RowCount()) {
				alert("휴가일자를 전부 선택하여 주십시오.");
				return false;
			}
			
			var dupRow  = sheet1.ColValueDup("vacationYmd");
			
			if(dupRow > -1 ) {
				alert("선택된 날짜가 중복 되었습니다." + dupRow);
				return false;
			}
			
			if($("#gntReqReason").val() == "") {
				alert("사유를 작성 바랍니다.");
				$("#gntReqReason").focus();
				return false;
			}
			
			// 로직체크
	        if ( !logicValidation() ) {
	            return false;
	        }

	      	//저장
	      	IBS_SaveName(document.searchForm,sheet1);
	      	var saveStr = sheet1.GetSaveString(0);
			if(saveStr=="KeyFieldError"){	
				return false;
			}
			//신청화면에 시트가 추가 되어 아래행으로 변경
			//var data = ajaxCall("${ctx}/VacationChangeAppDet.do?cmd=saveVacationChangeAppDet",saveStr+"&"+$("#searchForm").serialize(),false);
			var data = eval("("+sheet1.GetSaveData("${ctx}/VacationApp.do?cmd=saveVacationChangeAppDet", saveStr+"&"+$("#searchForm").serialize())+")");
			
            if(data.Result.Code > 0) {
            //  alert(data.Result.Message);
				returnValue = true;
            }else{
			//	alert(data.Result.Message);
				returnValue = false;
            }
		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchSabun"       name="searchSabun"		 value=""/>
	<input type="hidden" id="searchBApplSeq"    name="searchBApplSeq"	 value=""/>
	<input type="hidden" id="searchGntCd"       name="searchGntCd"	     value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>

	<table class="default outer" style="table-layout: fixed;" id="vacationChangeAppDetTable" name="vacationChangeAppDetTable">
	<colgroup>
		<col width="100px" />
		<col width="250px" />
		<col width="100px" />
		<col width="" />
	</colgroup>
	<tr>
		<th>휴가종류</th>
		<td>
			<select id="gntGubunCd" name="gntGubunCd" class="transparent hideSelectButton required1 required2" disabled></select>
		</td>
		<th>휴가명</th>
		<td>
			<select id="gntCd" name="gntCd" class="transparent hideSelectButton required1 required2" disabled></select>
		</td>
	</tr>
	<tr id="span_occ" style="display:none;"><!-- 경조휴가 신청시 -->
		<th>경조구분</th>
		<td>
			<select id="occFamCd" name="occFamCd" class="transparent hideSelectButton required1 required2" disabled ></select>
		</td>
		<th>경조휴가일수</th>
		<td>
			<span id="span_occHoliday"></span>
		</td>
	</tr>
	<tr id="inMod1" style="display:none;">
		<th>신청일자</th>
		<td colspan="3">
			<input id="sYmd" name="sYmd" type="text" size="10" class="date2 center" readonly   />
			<span id="span_eYmd">
				<input type="text" class="text w10 left transparent center" value="~" readonly tabindex="-1"> <input id="eYmd" name="eYmd" type="text" size="10" class="date2 center " readonly />
			</span>
			<span style="padding-left:30px;">
				<b>총일수 : </b>&nbsp;&nbsp;<input type="text" id="holDay" name="holDay" class="text w30 center" readonly />&nbsp;&nbsp;&nbsp;&nbsp;
				<b>적용일수 : </b>&nbsp;&nbsp;<input type="text" id="closeDay" name="closeDay" class="text w30 center" readonly />&nbsp;&nbsp;&nbsp;&nbsp;
			</span>
		</td>
	</tr>

	<!-- 적용일수 만큼 생성 -->

	<tr id="inMod2" style="display:none;">
		<th>신청일자</th>
		<td colspan="3">
			<input id="applYmd" name="applYmd" type="text" size="10" class="date2 center" readonly />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

			<b>시작시간 : </b>&nbsp;&nbsp;<input id="reqSHm" name="reqSHm" type="text" class="text w40 center " readonly maxlength="5"/>&nbsp;&nbsp;&nbsp;&nbsp;
			<b>종료시간 : </b>&nbsp;&nbsp;<input id="reqEHm" name="reqEHm" type="text" class="text w40 center " readonly maxlength="5"/>&nbsp;&nbsp;&nbsp;&nbsp;
			<b>적용시간 : </b>&nbsp;&nbsp;<input id="requestHour" name="requestHour" type="text" class="text w30 center " readonly maxlength="4"/>시간
		</td>
	</tr>
	<tr>
		<th><tit:txt mid="104101" mdef="변경사유" /></th>
		<td colspan="3">
			<textarea id="gntReqReason" name="gntReqReason" rows="3" cols="30" class="${textCss} w100p ${required}" ${readonly}></textarea>
		</td>
	</tr>
	</table>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100px"); </script>
	</form>
</div>

</body>
</html>