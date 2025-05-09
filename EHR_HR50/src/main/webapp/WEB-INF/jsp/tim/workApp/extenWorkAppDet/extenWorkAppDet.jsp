<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>연장근무신청 세부내역</title>
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
var workObj ;

	$(function() {

		parent.iframeOnLoad(500);

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
		//하루전
		$("#searchYmdBase").val("<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-1)%>");
		
		//----------------------------------------------------------------
		
		//근무시간 콤보 박스 ---------------------------------------------------
		var hStr = "";
		for(var i=0; i<=23; i++){
			var h = ( i < 10 )?"0"+i:i;
			hStr +="<option value='"+h+"'>"+h+"</option>";
			
		}
		
		$("#reqSh").html(hStr);
		$("#reqEh").html(hStr);
		//-----------------------------------------------------------------
		
		
		// 신청, 임시저장
		if(authPg == "A") {
	    	$("#notiTr").show();
			
			//근무일
			$("#searchYmd").datepicker2({
				startdate:"searchYmdBase",
				onReturn:function(date){
					if( dateCheck() ){ // 날짜 체크
						getRequestHourForm(); //근무시간 입력 폼 조회
						getOtWorkInfo(); //스케쥴 조회
					}
					
				}
			});
			
			//근무시간 변경시 총 시간 계산
			$("#reqSh, #reqSm, #reqEh, #reqEm ").bind("change",function(event){
				getRequestHour(); //총시간 
			});
			
	    }

		doAction("Search");

	});

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/ExtenWorkApp.do?cmd=getExtenWorkAppDet", $("#searchForm").serialize(),false);
			if(data.Message != "" ){
				alert(data.Message);
				return;
			}

			if ( data != null && data.DATA != null ){ 

				$("#searchYmd").val( formatDate(data.DATA.ymd, "-") );
				getRequestHourForm(); //근무시간 입력 폼 조회
				
				$("#reqSh").val( data.DATA.reqSh );
				$("#reqSm").val( data.DATA.reqSm );
				$("#reqEh").val( data.DATA.reqEh );
				$("#reqEm").val( data.DATA.reqEm );
				$("#reason").val( data.DATA.reason );

				//퇴근시간
				$("#outHm").val(data.DATA.outHm);
				$("#span_outHm").html(data.DATA.outHm.substr(0,2)+":"+data.DATA.outHm.substr(2,2));
		
			}
			getOtWorkInfo();

			break;
		}
	}

	
	//연장근무시간 조회 
	function getOtWorkInfo(){

		$("#noti, #weekDate, #weekOtTime, #termOtTime").html("");
		
		var data = ajaxCall("/ExtenWorkApp.do?cmd=getExtenWorkAppDetWorkInfo",$("#searchForm").serialize() ,false);
		if(data.Message != "" ){
			alert(data.Message);
			return;
		}
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
			$("#noti").html("종료시간을 " + data.DATA.beginShm +" 이후로 입력 시 근무시간 계산이 안되므로 수기로 입력 해주세요.");
			
		}
		
	}
	
	//휴일 체크 
	function dateCheck(){

		// clear
		$("#outHm, #reqSh, #reqSm, #reqEh, #reqEm").val("");
		$("#span_outHm, #workTimeList").html("");
		
		// 날짜 체크 
		var data = ajaxCall("/ExtenWorkApp.do?cmd=getExtenWorkAppDetHoliChk",$("#searchForm").serialize() ,false);
		if(data.Message != "" ){
			alert(data.Message);
			return;
		}
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
			/*
			if(data.DATA.stdOtTime == "0" ){
				alert("해당일의 근무스케쥴에 연장근무 기준시간이 없어 신청 할 수 없습니다.\n담당자에게 문의 해주세요.");
				$("#searchYmd").val("");
				return false;
			}
			*/
			if(data.DATA.outHm == "" ){
				alert("해당일에 퇴근시간이 없어 신청 할 수 없습니다.");
				$("#searchYmd").val("");
				return false;
			}
			//퇴근시간
			$("#outHm").val(data.DATA.outHm);
			$("#span_outHm").html(data.DATA.outHm.substr(0,2)+":"+data.DATA.outHm.substr(2,2));

			$("#reqSh").val(data.DATA.outHm.substr(0,2));
			$("#reqSm").val(data.DATA.outHm.substr(2,2));
			$("#reqEh").val(data.DATA.outHm.substr(0,2));
			$("#reqEm").val(data.DATA.outHm.substr(2,2));
			

		}

		return true;
	}
	
	//근무시간별 입력 폼 조회
	function getRequestHourForm(){
		// 근무코드 조회
		workObj = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getExtenWorkAppDetWorkCd&"+$("#searchForm").serialize(),false).codeList
	    for(var i = 0; i < workObj.length; i++) {
	    	var requestHour = (workObj[i].requestHour==null)?"":workObj[i].requestHour;
			$("#workTimeList").append('<b>'+workObj[i].codeNm +' : </b><input type="text" id="requestHour'+(i+1)+'" name="requestHour'+(i+1)+'" style="width: 30px !important; margin-right: 10px;" class="requestHour textCss center " ${readonly} maxlength="4" workCd="'+workObj[i].code +'" workCdType="'+workObj[i].workCdType +'" value="'+requestHour +'"/>');
			$("#workTimeList").append('<input type="hidden" id="workCd'+(i+1)+'" name="workCd'+(i+1)+'" value="'+workObj[i].code +'"/>');
	    	
    		// 숫자만 입력가능 (C:소수점 허용)
    		$("#requestHour"+(i+1)).keyup(function() {
    			makeNumber(this,"C");
    		});
    		
	    }
		
	}
	
	//근무인정시간 조회
	function getRequestHour(){

		var param = $("#searchForm").serialize()
		          + "&sHm="+$("#reqSh").val()+$("#reqSm").val()
		          + "&eHm="+$("#reqEh").val()+$("#reqEm").val();
		// 날짜 체크 
		var data = ajaxCall("/ExtenWorkApp.do?cmd=getExtenWorkAppDetTime",param ,false);

		if(data.Message != "" ){
			alert(data.Message);
			return;
		}
		
		if(data.DATA != null && data.DATA.time1 != null && data.DATA.time1 != "null"){
			for(var i = 1; i <= 5; i++) {
				if( data.DATA["code"+i] != "undefined" && $("#requestHour"+i).attr("workCd") == data.DATA["code"+i] ){
					$("#requestHour"+i).val( data.DATA["time"+i] );
				}
				
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
		
		//if( !dateCheck()  ) return false;

		var cnt = 0, hap = 0.0, requestHour = 0.0;
		// 화면의 개별 입력 부분 필수값 체크
		$(".requestHour").each(function(){
			cnt ++;
			if( $(this).val() != "" ) hap += parseFloat ( $(this).val()); //전체 근무시간 합계
			if( $(this).val() != "" && $(this).attr("workCdType") == "2" ) requestHour += parseFloat ( $(this).val()); //심야 제외 근무시간 합계
		});
		if(cnt == 0 || hap == 0){
			alert("연장근무 신청시간이 없습니다.");
			return false;
		}


		//연장근무 한도 체크 
		var chkTime = ajaxCall("${ctx}/ExtenWorkApp.do?cmd=getExtenWorkAppDetCheckTime", $("#searchForm").serialize()+"&requestHour="+requestHour,false);
		if(chkTime.Message != "" ){
			alert("연장근무 한도 체크 시 오류가 발생 했습니다.");
			return false;
		}
		if(chkTime.DATA.chkMsg != "" ){
			alert(chkTime.DATA.chkMsg);
			return false;
		}
		
		//기 신청건 체크 
		var data = ajaxCall("${ctx}/ExtenWorkApp.do?cmd=getExtenWorkAppDetDupCnt", $("#searchForm").serialize(),false);
		if(data.Message != "" ){
			alert("기 신청건 체크  시 오류가 발생 했습니다.");
			return false;
		}
		if(data.DATA != null && data.DATA.dupCnt != "null" && data.DATA.dupCnt != "0"){
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
			var data = ajaxCall("${ctx}/ExtenWorkApp.do?cmd=saveExtenWorkAppDet",$("#searchForm").serialize(), false);

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
	
	
</script>
<style type="text/css">
table.pink th { background-color:#fdf0f5 !important; }
#notiTr { display:none; } 
#workTimeList div {display:flex; padding-bottom:3px;}
#workTimeList div b {align-self: center; min-width:70px;}

</style>

</head>
<body class="bodywrap">
	<div class="wrapper">

		<form name="searchForm" id="searchForm" method="post">
		<input type="hidden" id="searchSabun"		name="searchSabun"	 	value=""/>
		<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	value=""/>
		<input type="hidden" id="searchApplName"	name="searchApplName"	value=""/>
		<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	value=""/>
		<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	value=""/>
		<input type="hidden" id="searchYmdBase"		name="searchYmdBase"	value=""/>
		<input type="hidden" id="outHm"				name="outHm"	value=""/>
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid="otWorkHour" mdef="연장근무시간"/></li>
			</ul>
		</div>
		<table class="table pink">
			<colgroup>
				<col width="13%" />
				<col width="25%" />
				<col width="13%" />
				<col width="20%" />
				<col width="14%" />
				<col width="20%" />
			</colgroup> 
		
			<tr>
				<th><tit:txt mid="termDate" mdef="단위기간"/></th>
				<td id="weekDate" class="spacingN"></td>
				<th class="th01"><tit:txt mid="weekOt" mdef="주 연장근무"/></th>
				<td class="th01" id="weekOtTime" class="spacingN"></td>
				<th class="th01"><tit:txt mid="termOt" mdef="단위기간 연장근무"/></th>
				<td class="th01" id="termOtTime" class="spacingN"></td>
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
				<col width="100px" />
				<col width="350px" />
				<col width="100px" />
				<col width="" />
			</colgroup> 
		
			<tr>
				<th><tit:txt mid='104060' mdef='근무일'/></th>
				<td>
					<input type="text" id="searchYmd" name="searchYmd" class="${dateCss} ${required} w70" readonly />
				</td>	
				<th><tit:txt mid='outTime_V1' mdef='퇴근시간'/></th>
				<td>
					<span id="span_outHm"></span>
				</td>	
			</tr>
			<tr>
				<th><tit:txt mid='103861' mdef='근무시간'/></th>
				<td>
					<select id="reqSh" name="reqSh" class="${selectCss} ${required} spacingN" style="width:auto" ${disabled}> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
					<select id="reqSm" name="reqSm" class="${selectCss} ${required} spacingN" style="width:auto" ${disabled}>
						<option value="00">00</option> <option value="30">30</option>
					</select>&nbsp;&nbsp; ~ &nbsp;&nbsp;
					<select id="reqEh" name="reqEh" class="${selectCss} ${required} spacingN" style="width:auto" ${disabled}> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
					<select id="reqEm" name="reqEm" class="${selectCss} ${required} spacingN" style="width:auto" ${disabled}>
						<option value="00">00</option> <option value="30">30</option> 
					</select>
				<td colspan="2" id="workTimeList"></td>
			</tr>
			<tr id="notiTr">
				<th><tit:txt mid='psnlWorkScheduleMgr2' mdef='유의사항'/></th>
				<td colspan="3">
					<span id="noti"></span>
				</td>
			</tr>
			<tr>
				<th>사유</th>
				<td colspan="3">
					<textarea rows="3" id="reason" name="reason" class="${textCss}  ${required} w100p" ${readonly}  maxlength="1000"></textarea>
				</td>
			</tr>
		</table>
			
		</form>
	</div>
</body>
</html>