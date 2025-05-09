<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>연장근무신청 세부내역(안씀)</title>
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
			
			//근무일
			$("#tdYmd").datepicker2({
				onReturn:function(date){
					dateCheck(); // 날짜 체크
					
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
			var data = ajaxCall( "${ctx}/OtWorkAppDet.do?cmd=getOtWorkAppDet", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 

				$("#tdYmd").val( formatDate(data.DATA.ymd, "-") );
				
				$("#reqSh").val( data.DATA.reqSh );
				$("#reqSm").val( data.DATA.reqSm );
				$("#reqEh").val( data.DATA.reqEh );
				$("#reqEm").val( data.DATA.reqEm );
				$("#requestHour").val( data.DATA.requestHour );
				$("#reason").val( data.DATA.reason );
			}else{

				//오늘날짜로 셋팅
				$("#tdYmd").val("${curSysYyyyMMddHyphen}");
				$("#reqSh").val("19");
				$("#reqEh").val("20").change();
			}

			break;
		}
	}

	//휴일 체크 
	function dateCheck(){
		
		// 날짜 체크 
		var data = ajaxCall("/OtWorkAppDet.do?cmd=getOtWorkAppDetHoliChk",$("#searchForm").serialize() ,false);
			
		if(data.DATA.statusCd != "AA" ){
			alert("해당일에 재직상태가 아닙니다.");
			$("#tdYmd").val("");
			return false;
		}			
		if(data.DATA.holidayCnt != "0" ){
			alert("해당일은 휴일입니다.");
			$("#tdYmd").val("");
			return false;
		}
		
		
		if( $("#tdYmd").val() < data.DATA.stOtYmd) { //TIM_DAY_OT_APP
			alert("연장근무는 "+data.DATA.stOtYmd+"부터 신청 할 수 있습니다.");
			$("#tdYmd").val("");
			return false;
		} 
		

		return true;
	}
	
	//근무시간 계산
	function getRequestHour(){

		$("#requestHour").val( "" );
		var param = "sHm="+$("#reqSh").val()+$("#reqSm").val()
		          + "&eHm="+$("#reqEh").val()+$("#reqEm").val();
		// 날짜 체크 
		var data = ajaxCall("/OtWorkAppDet.do?cmd=getOtWorkAppDetTime",param ,false);


		if(data.DATA != null){
			
			$("#requestHour").val( data.DATA.time );
			
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

		var requestHour = parseFloat($("#requestHour").val()); //신청시간

		if($("#requestHour").val() == "" || $("#requestHour").val() == "0"){
			alert("신청시간이 없습니다.");
			$("#reqEh").focus();
			return false;
		}


		//신청시간 및 연장근무 한도 체크 
		var chkTime = ajaxCall("${ctx}/OtWorkAppDet.do?cmd=getHolWorkAppDetCheckTime", $("#searchForm").serialize(),false);
		if(chkTime.DATA != null && chkTime.DATA.chkYn == "N"){
			alert("당일 연장근무는 "+chkTime.DATA.time+"까지 신청 가능합니다.");
			return false;
		}
		if(chkTime.DATA != null && chkTime.DATA.chkMsg != ""){
			alert(chkTime.DATA.chkMsg);
			return false;
		}
		
		//기 신청건 체크 
		var data = ajaxCall("${ctx}/OtWorkAppDet.do?cmd=getOtWorkAppDetDupCnt", $("#searchForm").serialize(),false);
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
			var data = ajaxCall("${ctx}/OtWorkAppDet.do?cmd=saveOtWorkAppDet",$("#searchForm").serialize(),false);

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
/*.th01 { display:none; }*/ 
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
	
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="" />
			<col width="120px" />
			<col width="200px" />
		</colgroup> 
	
		<tr>
			<th>근무일</th>
			<td>
				<input id="tdYmd" name="tdYmd" type="text" class="${dateCss} ${required} w70" readonly maxlength="10" />
				&nbsp;
				<select id="reqSh" name="reqSh" class="${selectCss} ${required} spacingN" ${disabled}> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
				<select id="reqSm" name="reqSm" class="${selectCss} ${required} spacingN" ${disabled}>
					<option value="00">00</option> <option value="30">30</option>
				</select>&nbsp;&nbsp; ~ &nbsp;&nbsp;
				<select id="reqEh" name="reqEh" class="${selectCss} ${required} spacingN" ${disabled}> </select>&nbsp;&nbsp;&nbsp;:&nbsp;
				<select id="reqEm" name="reqEm" class="${selectCss} ${required} spacingN" ${disabled}>
					<option value="00">00</option> <option value="30">30</option> 
				</select>
			</td>
			<th>총시간</th>
			<td>
				<input id="requestHour" name="requestHour" type="text" class="text transparent" readonly />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104467' mdef='사유'/></th>
			<td colspan="3" >
				<textarea rows="5" id="reason" name="reason" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
		
	</form>
</div>
		
</body>
</html>