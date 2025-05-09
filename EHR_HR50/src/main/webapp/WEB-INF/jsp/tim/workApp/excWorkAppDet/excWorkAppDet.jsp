<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>당직신청 세부내역</title>
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
		//하루전
		//$("#searchYmdBase").val("<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-1)%>");
		
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
			$("#searchYmd").datepicker2({
				startdate:"searchYmdBase",
				onReturn:function(date){
					
				}
			});
			
			//근무시간 변경시 총 시간 계산
			$("#reqSh, #reqSm, #reqEh, #reqEm ").bind("change",function(event){
				getRequestHour(); //신청시간시간 
			});
			
	    }

		doAction("Search");

	});

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/ExcWorkApp.do?cmd=getExcWorkAppDet", $("#searchForm").serialize(),false);
			if(data.Message != "" ){
				alert(data.Message);
				return;
			}

			if ( data != null && data.DATA != null ){ 

				$("#searchYmd").val( formatDate(data.DATA.ymd, "-") );
				
				$("#reqSh").val( data.DATA.reqSh );
				$("#reqSm").val( data.DATA.reqSm );
				$("#reqEh").val( data.DATA.reqEh );
				$("#reqEm").val( data.DATA.reqEm );
				$("#note").val( data.DATA.note );
				$("#requestHour").val( data.DATA.requestHour );

		
			}

			break;
		}
	}

	
	//근무인정시간 조회
	function getRequestHour(){

		var param = $("#searchForm").serialize()
		          + "&sHm="+$("#reqSh").val()+$("#reqSm").val()
		          + "&eHm="+$("#reqEh").val()+$("#reqEm").val();
		// 날짜 체크 
		var data = ajaxCall("/ExcWorkApp.do?cmd=getExcWorkAppDetHour",param ,false);

		if(data.Message != "" ){
			alert(data.Message);
			return;
		}
		
		if(data.DATA != null && data.DATA.time != null && data.DATA.time != "null"){
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
		
		if( $("#requestHour").val() == "" ||  $("#requestHour").val()  == "0"){
			alert("신청시간이 없습니다.");
			return false;
		}
		
		//기 신청건 체크 
		var data = ajaxCall("${ctx}/ExcWorkApp.do?cmd=getExcWorkAppDetDupCnt", $("#searchForm").serialize(),false);
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
			var data = ajaxCall("${ctx}/ExcWorkApp.do?cmd=saveExcWorkAppDet",$("#searchForm").serialize(), false);

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
	
		
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="100px" />
			<col width="300px" />
			<col width="100px" />
			<col width="" />
		</colgroup> 
	
		<tr>
			<th>근무일</th>
			<td colspan="3">
				<input type="text" id="searchYmd" name="searchYmd" class="${dateCss} ${required} w70" readonly />
			</td>	
		</tr>
		<tr>
			<th>근무시간</th>
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
			<th>신청시간</th>
			<td>
				<input id="requestHour" name="requestHour" type="text" class="text w40 ${required}" readonly />
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td colspan="3">
				<textarea rows="3" id="note" name="note" class="${textCss}  w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
		
	</form>
</div>
		
</body>
</html>