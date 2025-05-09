<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>휴일근무신청 세부내역</title>
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

	$(function() {

		parent.iframeOnLoad(260);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchSabun").val(searchApplSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();  //신청서상태
		applYn = parent.$("#applYn").val(); //결재자 여부

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		//----------------------------------------------------------------

		//출근예정시간 콤보 박스 ---------------------------------------------------
		var hStr = "";
		for(var i=0; i<=23; i++){
			var h = ( i < 10 )?"0"+i:i;
			hStr +="<option value='"+h+"'>"+h+"</option>";

		}
		$("#reqSh").html(hStr); $("#reqEh").html(hStr);
		//-----------------------------------------------------------------

		var param = "&searchSabun="+$("#searchSabun").val()+"&searchApplYmd="+searchApplYmd;
		if(authPg == "A") param = "&useYn=Y";
		
		//보상구분 콤보
		var reqTimeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+param,"T11010"), " ");//보상구분(T11010)
		$("#reqTimeCd").html(reqTimeCdList[2]);
		//-----------------------------------------------------------------
		

		// 신청, 임시저장
		if(authPg == "A") {

			//근무일
			$("#searchYmd").datepicker2({
				onReturn:function(date){
					dateCheck(); //휴일 체크
					getOtWorkInfo(); //스케쥴 조회
				}
			});

			//-----------------------------------------------------------------
			//대체휴가 사용가능 여부
<c:choose>
	<c:when test="${user.appYn == 'Y'}">
			$("#appType").val("Y");
			//대체휴일
			$("#alterYmd").datepicker2({
				onReturn:function(date){
					var days = getDaysBetween(replaceAll($("#searchYmd").val(),"-",""), replaceAll($("#alterYmd").val(),"-",""));
					if(days > 90){
						alert("대체휴일은 90일 이내에 사용 해주세요.");
						$("#alterYmd").val("");
					}
				}
			});
			$("#requestHour").bind("change", function(e){
				$("#reqTimeCd").val($("#requestHour").val()); 
				$("#reqSh").change();
				
			}).change();

			$("#reqSh").bind("change", function(e){
				var reqSh = $("#reqSh").val();
				if( reqSh.substring(0,1) == "0") reqSh = reqSh.substring(1);
				var ihour = parseInt(reqSh) + parseInt($("#requestHour").val()); 
				if( ihour > 24 ) ihour = ihour - 24;
				var reqEh = (( ihour < 10 )?"0":"") + ihour;
				$("#reqEh").val(reqEh);
				$("#reqEm").val($("#reqSm").val());
			});
			$("#reqSm").bind("change", function(e){
				$("#reqEm").val($("#reqSm").val());
			});
	</c:when>
	<c:otherwise>
			$("#appType").val("N");
			$("#reqTimeCd").val("0"); //별정직 수당 보상
			
			//근무시간 변경시 총 시간 계산
			$("#reqSh, #reqSm, #reqEh, #reqEm ").bind("change",function(event){
				getRequestHour(); //총시간 
			});
	</c:otherwise>
</c:choose>
			//-----------------------------------------------------------------

	    }

		doAction("Search");

	});

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/HolWorkApp.do?cmd=getHolWorkAppDetMap", $("#searchForm").serialize(),false);

					
			if ( data != null && data.DATA != null ){

				$("#searchYmd").val( formatDate(data.DATA.ymd, "-") );
				$("#reqTimeCd").val( data.DATA.reqTimeCd );
				$("#requestHour").val( data.DATA.requestHour );
				$("#reqSh").val( data.DATA.reqSh );
				$("#reqSm").val( data.DATA.reqSm );
				$("#reqEh").val( data.DATA.reqEh );
				$("#reqEm").val( data.DATA.reqEm );
				$("#reason").val( data.DATA.reason );
				$("#timeCd").val(data.DATA.timeCd);
				$("#workOrgCd").val(data.DATA.workOrgCd);
				
				
				//대체휴가 신청 여부
				var appYn = ( data.DATA.reqTimeCd == "0" )?"N":"Y";
				$("#appType").val(appYn);
				if( appYn == "Y" ){
					$("#alterYmd").val( formatDate(data.DATA.alterYmd, "-") ).addClass("required");
				}else{
					$("#alterYmd").attr("readonly","readonly").addClass("transparent");
				}
				
				getOtWorkInfo();

			}

			break;
		}
	}


	//스케쥴 조회
	function getOtWorkInfo(){

		$("#weekDate").html("");$("#weekOtTime").html( "" ); $("#termOtTime").html( "" );

		var data = ajaxCall("/ExtenWorkApp.do?cmd=getExtenWorkAppDetWorkInfo",$("#searchForm").serialize() ,false);
		if(data.DATA == null){
		}else {
			//주단위 근무시간 표시
			$("#weekDate").html( formatDate(data.DATA.weekSdate, "-") + " ~ " + formatDate(data.DATA.weekEdate, "-") );

			//주 연장근무 시간
			if( data.DATA.sumWeekOtTime != null &&  data.DATA.sumWeekOtTime != "") {
				$("#weekOtTime").html( data.DATA.sumWeekOtTime + " 시간" );
			}

			//단위기간 연장근무 시간
			if( data.DATA.sumTermOtTime != null &&  data.DATA.sumTermOtTime != "") {
				$("#termOtTime").html( data.DATA.sumTermOtTime + " 시간" );
			}
			
			//기본 연장근무시작시간 , 30분
			if($("#reqSh").val() == "00"){ 
				$("#reqSh").val(data.DATA.workShm.substr(0,2));
				$("#reqSm").val(data.DATA.workShm.substr(2,2));

				var reqEh = parseInt(data.DATA.workShm.substr(0, 2)) + 4;
				$("#reqEh").val(reqEh.toString());
				$("#reqEm").val(data.DATA.workShm.substr(2,2));
			}
		}

	}

	//스케쥴 및 휴일 체크
	function dateCheck(){

		// 날짜 체크
		var data = ajaxCall("/ExtenWorkApp.do?cmd=getExtenWorkAppDetHoliChk" ,$("#searchForm").serialize() ,false);
		if(data.DATA == null){
			alert("해당일("+$("#searchYmd").val()+")에 근무스케쥴이 생성되지 않았습니다.\n담당자에게 문의 해주세요.");
			$("#searchYmd").val("");
			return false;
		}else {

			if(data.DATA.statusCd != "AA" ){
				alert("해당일에 재직상태가 아닙니다.");
				$("#searchYmd").val("");
				return false;
			}
			if(data.DATA.holidayCnt == "0" ){
				alert("해당일은 휴일이 아닙니다.");
				$("#searchYmd").val("");
				return false;
			}

			if(data.DATA.fixWorkTimeYn == "Y" ){
				alert("연장근무를 신청 할 수 없는 근무조 입니다.\n담당자에게 문의 해주세요.");
				$("#searchYmd").val("");
				return false;
			}

			if( $("#searchYmd").val() < data.DATA.holAppStOtYmd) { //TIM_DAY_HOLWORK_APP
				alert("휴일근무는 "+data.DATA.holAppStOtYmd+"부터 신청 할 수 있습니다.");
				$("#searchYmd").val("");
				return false;
			}

			$("#timeCd").val(data.DATA.timeCd);
			$("#workOrgCd").val(data.DATA.workOrgCd);

		}

		return true;
	}
	
	
	//근무시간 계산 (별정직만)
	function getRequestHour(){
		if( $("#searchYmd").val() == "" ) return;

		$("#requestHour").val( "" );
		var param = $("#searchForm").serialize()
		          + "&sHm="+$("#reqSh").val()+$("#reqSm").val()
		          + "&eHm="+$("#reqEh").val()+$("#reqEm").val()
		          + "&workCd=0070";
		// 날짜 체크 
		var data = ajaxCall("/HolWorkApp.do?cmd=getHolWorkAppDetTime",param ,false);


		if(data.DATA != null){
			if(data.DATA.time != null ){
				$("#requestHour").val( parseFloat(data.DATA.time) );
			}	
		}
	}


	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
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
		});

		if( !ch  ) return false;

		if( !dateCheck()  ) return false;

		//연장근무 한도 체크
		if( $("#appType").val() == "Y" ) {
			$("#requestHour").val( $("#reqTimeCd").val() );	
		}else{
			getRequestHour();
		}
		if( $("#requestHour").val() == "0" ){
			alert("근무시간을 입력 해주세요.");
			return false;
		}
		
		var chkTime = ajaxCall("${ctx}/ExtenWorkApp.do?cmd=getExtenWorkAppDetCheckTime", $("#searchForm").serialize(),false);
		if(chkTime.DATA != null && chkTime.DATA.chkMsg != ""){
			alert(chkTime.DATA.chkMsg);
			return false;
		}



		//기 신청건 체크
		var data = ajaxCall("${ctx}/HolWorkApp.do?cmd=getHolWorkAppDetDupCnt", $("#searchForm").serialize(),false);

		if(data.DATA != null && data.DATA.dupCnt != "0"){
			alert("동일한 일자에 신청내역이 있습니다.");
			return false;
		}



		return ch;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		var returnValue = false;
		try {

			if ( authPg == "R" )  {
				return true;
			}

			// 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }

	      	//저장
			var data = ajaxCall("${ctx}/HolWorkApp.do?cmd=saveHolWorkAppDet",  GetParamAll("searchForm"), false);

            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }


		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}

	/**
		disabled 포함 Form 데이터 리턴
	**/
	function GetParamAll(formId){
		var t = $("#"+formId);
		var disabled = t.find(":disabled").removeAttr("disabled");
		var params = t.serialize();
		disabled.attr("disabled", "disabled");
		return params;
	}
</script>
<style type="text/css">
table.pink th { background-color:#fdf0f5 !important; }
.type02 {display:none;}
</style>

</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchSabun"		name="searchSabun"	 	 value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>

	<input type="hidden" id="appType"			name="appType"	 	 	value=""/> <!-- 대체휴가신청여부 -->
	<input type="hidden" id="timeCd"			name="timeCd"	 	 	value=""/> 
	<input type="hidden" id="workOrgCd"			name="workOrgCd"	 	value=""/> 

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="otWorkHour" mdef="연장근무시간"/></li>
		</ul>
	</div>
	<table class="table pink">
		<colgroup>
			<col width="120px" />
			<col width="200px" />
			<col width="120px" />
			<col width="120px" />
			<col width="120px" />
			<col width="" />
		</colgroup>

		<tr>
			<th><tit:txt mid="termDate" mdef="단위기간"/></th>
			<td id="weekDate" class="spacingN"></td>
			<th><tit:txt mid="weekOt" mdef="주 연장근무"/></th>
			<td id="weekOtTime" class="spacingN"></td>
			<th><tit:txt mid="termOt" mdef="단위기간 연장근무"/></th>
			<td id="termOtTime" class="spacingN"></td>
		</tr>
	</table>

	<div class="h10"></div>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="330px" />
			<col width="120px" />
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='104060' mdef='근무일'/></th>
			<td colspan="3">
				<input id="searchYmd" name="searchYmd" type="text" class="${dateCss} ${required} w70" readonly maxlength="10" />
			</td>
		</tr>
<c:choose>
	<c:when test="${user.appYn == 'Y'}">
		<tr>
			<th><tit:txt mid='103861' mdef='근무시간'/></th>
			<td>
				<select id="reqSh" name="reqSh" class="${selectCss} ${required} spacingN" style="width:auto" ${disabled}> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
				<select id="reqSm" name="reqSm" class="${selectCss} ${required} spacingN" style="width:auto" ${disabled}>
					<option value="00">00</option> <option value="30">30</option>
				</select>&nbsp;&nbsp; ~ &nbsp;&nbsp;
				<select id="reqEh" name="reqEh" class="${selectCss} ${required} spacingN" style="width:auto" disabled> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
				<select id="reqEm" name="reqEm" class="${selectCss} ${required} spacingN" style="width:auto" disabled>
					<option value="00">00</option> <option value="30">30</option> 
				</select>
			</td>
			<th><tit:txt mid='workHmV1' mdef='신청시간'/></th>
			<td>
				<select id="requestHour" name="requestHour" class="${selectCss} ${required} spacingN" ${disabled}>
					<option value="4">4<tit:txt mid='titHour' mdef='시간'/></option>
					<option value="8">8<tit:txt mid='titHour' mdef='시간'/></option>
				</select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='rewardType' mdef='보상구분'/></th>
			<td>
				<select id="reqTimeCd" name="reqTimeCd" class="transparent hideSelectButton " disabled></select>
			</td>
			<th><tit:txt mid='substituteHoliday' mdef='대체휴일'/></th>
			<td>
				<input id="alterYmd" name="alterYmd" type="text" class="${dateCss} ${required} w70" readonly maxlength="10" />
			</td>
		</tr>
	</c:when>
	<c:otherwise>
		<tr>
			<th><tit:txt mid='103861' mdef='근무시간'/></th>
			<td>
				<select id="reqSh" name="reqSh" class="${selectCss} ${required} spacingN" ${disabled}> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
				<select id="reqSm" name="reqSm" class="${selectCss} ${required} spacingN" ${disabled}>
					<option value="00">00</option> <option value="30">30</option>
				</select>&nbsp;&nbsp; ~ &nbsp;&nbsp;
				<select id="reqEh" name="reqEh" class="${selectCss} ${required} spacingN" ${disabled}> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
				<select id="reqEm" name="reqEm" class="${selectCss} ${required} spacingN" ${disabled}>
					<option value="00">00</option> <option value="30">30</option> 
				</select>
			</td>
			<th><tit:txt mid='workHmV1' mdef='신청시간'/></th>
			<td>
				<input id="requestHour" name="requestHour" type="text" class="text transparent" readonly />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='rewardType' mdef='보상구분'/></th>
			<td colspan="3">
				<select id="reqTimeCd" name="reqTimeCd" class="transparent hideSelectButton " disabled></select>
				<input type="hidden" id="alterYmd" name="alterYmd" />
			</td>
		</tr>
	</c:otherwise>
</c:choose>
		<tr>
			<th><tit:txt mid='104467' mdef='사유'/></th>
			<td colspan="3" >
				<textarea rows="3" id="reason" name="reason" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>

	</form>
</div>

</body>
</html>
