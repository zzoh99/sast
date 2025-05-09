<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>출퇴근시간변경신청 세부내역</title>
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
	
		parent.iframeOnLoad(220);
	
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
		

		// 기본 입력 사항
		if(authPg=="A"){
	  		$("#reqToDate").val(addDate("d", -1,"${curSysYyyyMMdd}", "-")); // 당일데이터 입력 불가
	  		
			// 근무일
		    $("#tdYmd").datepicker2({
				startdate:"reqToDate",
		    	onReturn: function(){
		    		dateCheck();
		    	}
		    });

			$("#bfShm").mask("99:99");
			$("#bfEhm").mask("99:99");
			$("#afShm").mask("99:99");
			$("#afEhm").mask("99:99");

	    }

		doAction("Search");
	});


	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/WorkAttendAdjApp.do?cmd=getWorkAttendAdjAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 

				$("#tdYmd"  ).val(formatDate(data.DATA.ymd, "-"));
				$("#bfShm").val(data.DATA.bfShm).mask("99:99");
				$("#bfEhm").val(data.DATA.bfEhm).mask("99:99");
				$("#afShm").val(data.DATA.afShm).mask("99:99");
				$("#afEhm").val(data.DATA.afEhm).mask("99:99");
				$("#reason" ).val(data.DATA.reason);

			}else{
				initSecomTime();
			}

			break;
		}
	}
	

	//근무일 변경 시 
	function dateCheck(){
		var data = ajaxCall("${ctx}/WorkAttendAdjApp.do?cmd=getWorkAttendAdjAppDetEndYn","&searchApplSabun="+searchApplSabun+"&tdYmd="+$("#tdYmd").val(),false);
		if(data.DATA != null && data.DATA.endYn == "Y"){
			alert("<msg:txt mid='2018081700021' mdef='해당월의 근무가 마감되었습니다. 관리자에게 문의바랍니다.'/>");
			$("#tdYmd").val("");
			return;
		}else{
			initSecomTime();
		}
	}

	// 변경 전 출퇴근 시간 조회
	function initSecomTime(){
		
		var param = "ymd="+$("#tdYmd").val()
		  + "&sabun="+$("#searchApplSabun").val()
		  + "&applSeq="+$("#searchApplSeq").val()
		  ;
		var data = ajaxCall("${ctx}/WorkAttendAdjApp.do?cmd=getWorkAttendAdjAppDetSecomTime", param, false);

		if(data.DATA == null){
			return;
		}

		$("#bfShm").val(data.DATA.shm);
		$("#bfEhm").val(data.DATA.ehm);
		
	}

	function checkDate(){

		if(authPg == "A") {
			if ( $("#tdYmd").val() == $("#reqToDate").val() ){
				// 전일 데이터는 12시 이후 입력 가능
				var currHour = "";
				var currDateTime = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCurrDateTime",false).codeList;
				if ( currDateTime != null && currDateTime[0] != null && currDateTime[0].currHour != null){
					currHour = currDateTime[0].currHour;
				}

				if (currHour < "12"){
					alert("<msg:txt mid='2018081700029' mdef='전일데이터는 12시 이후 부터 입력 가능합니다.'/>");
					return false;
				}
			}

			if ( $("#reqToDate").val() != null && $("#tdYmd").val() > $("#reqToDate").val() ){
				// 당일 데이터 입력불가
				alert("<msg:txt mid='2018081700028' mdef='당일 포함. 당일 이후 근무일은 신청하실 수 없습니다.'/>");
				return false;
			}
		}

		return true;
	}

	
	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;

		if (!checkDate()){
			return false;
		}

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		
		if( !ch  ) return;

		$(".requireLen").each(function(index){
			if($(this).val().length == 0){
				alert("<msg:txt mid='2018081700030' mdef='"+$(this).parent().prev().text()+"은 필수값입니다.'/>");
				$(this).focus();
				ch =  false;
				return ch;
			}
			if($(this).val().length < 5){
				//alert($(this).parent().prev().text()+"은 4자리 모두 입력하셔야 합니다.");
				alert("<msg:txt mid='2018081700031' mdef='"+$(this).parent().prev().text()+"은 4자리 모두 입력하셔야 합니다.'/>");
				$(this).focus();
				ch =  false;
				return ch;
			}
		});

		if( !ch  ) return;

		//기 신청 건 체크
		var data = ajaxCall("${ctx}/WorkAttendAdjApp.do?cmd=getWorkAttendAdjAppDetDupCheck", $("#searchForm").serialize(),false);

		if(data.DATA != null && data.DATA.dupCnt != "0"){
			alert("동일한 일자에 신청내역이 있습니다.");
			return false;
		}
		
		
		var data = ajaxCall("${ctx}/WorkAttendAdjApp.do?cmd=getBeginTime","&searchApplSabun="+searchApplSabun+"&tdYmd="+$("#tdYmd").val(),false);
		if(data.DATA != null ){

			if($("#afShm").val().replace(/:/, '') < data.DATA.beginShm ){
				alert("<msg:txt mid='2018081700032' mdef='"+data.DATA.beginShm.substr(0,2)+":"+data.DATA.beginShm.substr(2,2)+"보다 일찍 출근시간을 변경할 수 없습니다.'/>");
				$("#afShm").focus();
				return false;
			}

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
			var data = ajaxCall("${ctx}/WorkAttendAdjApp.do?cmd=saveWorkAttendAdjAppDet",$("#searchForm").serialize(),false);

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
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchSabun"		name="searchSabun"	 	 value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	
	<input type="hidden" id="reqToDate" 		name="reqToDate" 		value=""/><!-- 당일 -->

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='114682' mdef='신청내용'/></li>
		</ul>
	</div>

	<table class="table">
		<colgroup>
			<col width="100px" />
			<col width="100px" />
			<col width="120px" />
			<col width="100px" />
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='104060' mdef='근무일'/></th>
			<td colspan="4">
				<input type="text" id="tdYmd" name="tdYmd" class="${dateCss} ${required} w70" readonly maxlength="10" />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='befChg' mdef='변경전'/></th>
			<th><tit:txt mid='inTime_V1' mdef='출근시간'/></th>
			<td>
				<input type="text" id="bfShm" name="bfShm" class="${textCss} readonly" readonly/>
			</td>
			<th><tit:txt mid='outTime_V1' mdef='퇴근시간'/></th>
			<td>
				<input type="text" id="bfEhm" name="bfEhm"  class="${textCss} readonly" readonly/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='aftChg' mdef='변경후'/></th>
			<th><tit:txt mid='inTime_V1' mdef='출근시간'/></th>
			<td>
				<input type="text" id="afShm" name="afShm" class="${textCss} ${required} requireLen"  ${readonly}/>
			</td>
			<th><tit:txt mid='outTime_V1' mdef='퇴근시간'/></th>
			<td>
				<input type="text" id="afEhm" name="afEhm" class="${textCss} ${required} requireLen"  ${readonly}/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104467' mdef='사유'/></th>
			<td colspan="4">
				<textarea id="reason" name="reason" rows="4" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
	</form>
	
</div>
</body>
</html>