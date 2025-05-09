<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid="202005180000017" mdef="시간외근무(기원)" /> <tit:txt mid="appTitleV1" mdef="신청" /></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var searchApplSabun = "${searchApplSabun}";
	var searchSabun = "${searchSabun}";
	var searchApplYmd = "${searchApplYmd}";
	var applStatusCd = parent.$("#applStatusCd").val();

	var holidayGubun = "0";

	$(function() {

		// 신청 상태가 없을 경우는 무조건 임시정장으로 본다.
		if(applStatusCd == ""){
			applStatusCd = "11";
		}

		$("#searchSabun").val(searchSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplSeq").val(searchApplSeq);
		$("#applYmd").val(searchApplYmd);

		parent.iframeOnLoad("300px");

		// 아침시작시간 
		var morningSH = ["02","03","04","05"];
		var morningSHtxt = ["2","3","4","5"];		

		var morningSM = ["00","10","20","30","40","50"];
		var morningSMtxt = ["0","10","20","30","40","50"];

		// 근무시간
		var reqSH = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"];
		var reqSHtxt = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"];
		// reqSM = morningSM

		// 총시간
		//workHourH = reqSH
		//workHourM = morningSM
		var selectText = "<sch:txt mid='select' mdef='선택' />";
		var hText = "<tbl:txt mid='h' mdef='시' />";
		var minuteText = "<tbl:txt mid='minute' mdef='분' />";
		var hourText = "<tbl:txt mid='hour' mdef='시간' />";

		var optionMorningSH = "<option value=''>"+ selectText + "</option>";
		var optionMorningSM = "<option value=''>"+ selectText + "</option>";

		var optionReqSH = "<option value=''>"+ selectText + "</option>";
		var optionReqSM = "<option value=''>"+ selectText + "</option>";

		var optionWorkHourH = "<option value=''>"+ selectText + "</option>";
		var optionWorkHourM = "<option value=''>"+ selectText + "</option>";

		for(var i = 0; i < morningSH.length; i++) {
			optionMorningSH += "<option value="+morningSH[i]+">"+morningSHtxt[i]+hText+"</option>";
		}
		for(var i = 0; i < morningSM.length; i++) {
			optionMorningSM += "<option value="+morningSM[i]+">"+morningSMtxt[i]+minuteText+"</option>";
		}
		for(var i = 0; i < reqSH.length; i++) {
			optionReqSH += "<option value="+reqSH[i]+">"+reqSHtxt[i]+hText+"</option>";
			optionWorkHourH += "<option value="+reqSH[i]+">"+reqSHtxt[i]+hourText+"</option>";
		}
		optionReqSM = optionMorningSM;
		optionWorkHourM = optionMorningSM;

		$("#morningSH").html(optionMorningSH);
		$("#morningSM").html(optionMorningSM);
		$("#reqSH").html(optionReqSH);
		$("#reqSM").html(optionReqSM);
		$("#workHourH").html(optionWorkHourH);
		$("#workHourM").html(optionWorkHourM);

		//시작시간 및 근로시간 변경 시
		$("#reqSH, #reqSM, #workHourH, #workHourM").bind("change", function(e){
			if($("#reqSH").val() == "" || $("#reqSM").val() == "" || $("#workHourH").val() == "" || $("#workHourM").val() == ""){
				$("#reqSHm").val("");
				$("#reqEHm").val("");
				$("#span_reqEH").html("");
				$("#span_reqEM").html("");
				return;
			}

			var reqSH = parseInt($("#reqSH").val());  //시작(시)
			var reqSM = parseInt($("#reqSM").val());  //시작(분)

			var workH = parseInt($("#workHourH").val());  //총시간(시)
			var workM = parseInt($("#workHourM").val());    //총시간(분)

			var reqEH = reqSH + workH;   //종료(시)

			var reqEM = reqSM + workM; //종료(분)
			if( reqEM >= 60 ){
				reqEH = reqEH + 1;
				reqEM = reqEM - 60;
			}

			//if( ( reqEH == 24 && reqEM > 0 ) || reqEH > 24){
			if( reqEH >= 24){
				reqEH = reqEH - 24;
			}

			var reqEHs = (reqEH < 10)?"0"+reqEH:reqEH+"";
			var reqEMs = (reqEM == 0)?"00":reqEM+"";

			$("#reqSHm").val($("#reqSH").val() + "" + $("#reqSM").val());
			$("#reqEHm").val(reqEHs + reqEMs);
			$("#workHour").val($("#workHourH").val() + "" + $("#workHourM").val());
			$("#span_reqEH").html(reqEH+"<tbl:txt mid='h' mdef='시' />");
			$("#span_reqEM").html(reqEM+"<tbl:txt mid='minute' mdef='분' />");
		});

		// 아침시작시간 변경시
		$("#morningSH").bind("change", function(e){
			// 아침시작시간 02시 ~ 06시
			if($("#morningSH").val() == "06"){
				$("#morningSM").val("00");
			}
		});

		// 아침시작시간 변경시
		$("#morningSM").bind("change", function(e){
			// 아침시작시간 02시 ~ 06시
			if($("#morningSH").val() == "06"){

				alert("<msg:txt mid='202005180000043' mdef='분이 잘못되었습니다. 아침시작시간은 02:00 부터 06:00 사이입니다.' />");
				$("#morningSM").val("00");
			}
		});

		// 근무구분 변경 시
		$("#workGubun").bind("change", function(e){
			var $this = $(this);
			var val = $this.val();

			$("#reqSH").val("");
    		$("#reqSM").val("");
			$("#workHourH").val("");
    		$("#workHourM").val("");
			$("#reqSHm").val("");
			$("#reqEHm").val("");
			$("#span_reqEH").html("");
			$("#span_reqEM").html("");
			$("#golfYn").val("");
			$("#morningSH").val("");
    		$("#morningSM").val("");

			if(val == "S") {
				// 특별수당 선택시
	    		$("#reqSH").attr("disabled", false).addClass("transparent");
	    		$("#reqSM").attr("disabled", false).addClass("transparent");

				// 아침근무 시간 히든처리
				$("#morningSH").attr("disabled", true)
				$("#morningSM").attr("disabled", true);
				$('#trMorningSHM').hide();

				// 골프장 여부 활성화
				$("#trGolfYn").show();
				$("#golfYn").attr("disabled", false).addClass("transparent").addClass("required");

			} else if(val == "N") {
				// 야근수당 선택시
				$("#reqSH").val("20");
	    		$("#reqSM").val("00");

	    		$("#reqSH").attr("disabled", true).removeClass("transparent");
	    		$("#reqSM").attr("disabled", true).removeClass("transparent");

				// 골프장 여부 히든처리
				$("#golfYn").attr("disabled", true).removeClass("transparent").removeClass("required");
				$("#trGolfYn").hide();

				// 아침근무 시간 활성화
				$("#trMorningSHM").show();
				$("#morningSH").attr("disabled", false);
				$("#morningSM").attr("disabled", false);

			}
		});

		// 골프장 여부 히든처리( 디폴트 야근수당)
		$("#golfYn").attr("disabled", true);
		$("#trGolfYn").hide();

		if(applStatusCd != "11"){
			$("#reqSH").attr("disabled", true);
			$("#reqSM").attr("disabled", true);
			$("#workHour").attr("disabled", true);
			$("#workGubun").attr("disabled", true);
			$("#workHourH").attr("disabled", true);
			$("#workHourM").attr("disabled", true);
			$("#morningSH").attr("disabled", true);
			$("#morningSM").attr("disabled", true);
			$("#golfYn").attr("disabled", true)

		}else{

			$("#baseDateE").mask("1111-11-11");
			$("#baseDateS").mask("1111-11-11");
			$("#baseDateE").val( addDate("d", -1, "${curSysYyyyMMddHyphen}", "-"));
			$("#baseDateS").val( addDate("d", -30, "${curSysYyyyMMddHyphen}", "-"));

			$("#sdate").datepicker2({
				startdate : "baseDateE",
				enddate : "baseDateS",
				onReturn:function(date){
					// 휴일 선택 체크 실행
					checkHoliday(date);
				}
			});
		    $("#reason").maxbyte(1300);
			$("#sdate").val($("#baseDateE").val());


		    // 신청 작성중인 경우..
		    if(applStatusCd == "11") {
		    	// "야근수당"으로 설정
		    	$("#workGubun").val("N");
		    	// 야근수당 인 경우 20시로 선택
		    	$("#reqSH").val("20");
		    	$("#reqSM").val("00");

	    		$("#reqSH").attr("disabled", true);
	    		$("#reqSM").attr("disabled", true);
		    }
		}

		// 휴일정보 조회
		var holidayInfo = getHolidayInfo($("#sdate").val());

		// 근무일자 선택에 따른 이벤트 설정
		$("#sdate").bind("change", function(e){
			// 휴일 선택 체크 실행
			checkHoliday($(this).val());
		});

		$("#sdate").trigger('change');

		doAction1("Search");

	});

	//Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall("${ctx}/GetDataMap.do?cmd=getExWorkDriverAppDet",$("#dataForm").serialize(),false);

			if(data.DATA != null){
				$("#sdate").val(formatDate(data.DATA.sdate,"-"));
				getHolidayInfo($("#sdate").val());

				// 근무구분값 셋팅
			    $("#workGubun").val(data.DATA.workGubun);
			    //$("#preWorkGubun").val(data.DATA.workGubun);
			    initWorkHourComboByWorkGubun(data.DATA.workGubun);

				$("#reqSHm").val(data.DATA.reqSHm);
			    $("#reqSH").val(data.DATA.reqSH);
			    $("#reqSM").val(data.DATA.reqSM);

			    $("#reqEHm").val(data.DATA.reqEHm);
				$("#span_reqEH").html(data.DATA.reqEH+"<tbl:txt mid='h' mdef='시' />");
				$("#span_reqEM").html(data.DATA.reqEM+"<tbl:txt mid='minute' mdef='분' />");

			    $("#workHour").val(data.DATA.workHour);
			    $("#reason").val(data.DATA.reason);
			    $("#workHourH").val(data.DATA.workHourH);
			    $("#workHourM").val(data.DATA.workHourM);

			    //$("#morningSHM").val(data.DATA.morningSHM);

			    $("#morningSH").val(data.DATA.morningSH);
			    $("#morningSM").val(data.DATA.morningSM);

			    $("#golfYn").val(data.DATA.golfYn);


			};


			break;
		}
	}


	// 입력시 조건 체크
	function checkList(){

		var ch = true;

		if(authPg == "A" || applStatusCd == "11"){

			var workYmd = replaceAll($("#sdate").val(), "-", "");

			// 화면의 개별 입력 부분 필수값 체크
			$(".required").each(function(index){
				if($(this).val() == null || $(this).val() == ""){
					alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은 필수값입니다.' />");
					$(this).focus();
					ch =  false;
					return false;
				}
				return ch;
			});

			if( ch ){

				if( workYmd >= "${curSysYyyyMMdd}" ){
					alert("<msg:txt mid='202005180000044' mdef='근무일자를 확인하세요. 근무일자는 오늘과 같거나 클수 없습니다.' />");
					$("#sdate").focus();
					ch =  false;
					return ch;
				}

				if( workYmd < replaceAll($("#baseDateS").val(), "-", "")){
					alert("<msg:txt mid='202005180000045' mdef='신청기간이 지난 근무일자 입니다.' />");
					$("#sdate").focus();
					ch =  false;
					return ch;
				}

				if($("#reason").val().length < 1){
					alert("<msg:txt mid='110384' mdef='근무내용을 입력하세요.' />");
					$("#reason").focus();
					ch =  false;
					return ch;
				}

				if($("#morningSH").val().length + $("#morningSM").val().length != 0 &&  $("#morningSH").val().length + $("#morningSM").val().length < 4){
					alert("아침시작시간을 정확히 입력해 주세요.");
					alert("<msg:txt mid='202005180000046' mdef='아침시작시간을 정확히 입력해 주세요.' />");
					$("#morningSM").focus();
					ch =  false;
					return ch;
				}

				if($("#workHourH").val() < "01" && $("#workGubun").val() == "S" ){
					alert("<msg:txt mid='202005180000047' mdef='특근수당은 근무시간이 1시간 이상이여야 합니다.' />");
					ch =  false;
					return;
				}

				var data = ajaxCall("${ctx}/GetDataMap.do?cmd=getExWorkDriverAppDetDayCnt",$("#dataForm").serialize(),false);
				if( parseInt( data.DATA.cnt ) > 0) {
					alert("<msg:txt mid='202005180000048' mdef='해당 근무일자에 기 신청건 또는 임시저장상태인 건이 존재합니다.' />");
					ch =  false;
					return ch;
				}
			}

		}
		return ch;
	}

	// 저장후 리턴함수
	function setValue(){
		var rtn;
		var returnValue = false;

		// 항목 체크 리스트
		if(checkList()){

			try{

			  	$("#reqSH").attr("disabled", false);
			    $("#reqSM").attr("disabled", false);
			    $("#workHour").attr("disabled", false);
			    $("#workGubun").attr("disabled", false);
			    $("#morningSH").attr("disabled", false);
			    $("#morningSM").attr("disabled", false);
			    $("#golfYn").attr("disabled", false);


				var rtn = ajaxCall("${ctx}/SaveData.do?cmd=saveExWorkDriverAppDet"
						          , $("#dataForm").serialize(), false);

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				}else{
					returnValue = true;
				}

			} catch (ex){
				alert(<msg:txt mid='109829' mdef='"저장중 스크립트 오류발생."+ex' />);
				returnValue = false;
			}

		}else{
			returnValue = false;
		}

		return returnValue;

	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}
		try {
			if(strDate.length == 10) {
				return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
			} else if(strDate.length == 8) {
				return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
			} else {
				return "";
			}
		} catch(e) {
			return "";
		}
	}

	// 시작시간 및 총 근로시간 콤보박스 변경
	function initWorkHourComboByWorkGubun(workGubun) {
		var val = workGubun;

		if(val == "S") {
			// 특별수당 선택시
			// 아침근무 시간 히든처리
			$('#trMorningSHM').hide();
			// 골프장 여부 활성화
			$("#trGolfYn").show();

		} else if(val == "N") {
			// 야근수당 선택시
			// 골프장 여부 히든처리
			$("#trGolfYn").hide();

			// 아침근무 시간 활성화
			$("#trMorningSHM").show();
		}
	}

	// 휴일정보 조회
	function getHolidayInfo(date) {
		var $txtHolidayInfo = $("#txt_holidayInfo");
		var params = {
			"sdate" : date.replace(/-/gi, "")
		};

		$txtHolidayInfo.removeClass("f_red");
		$txtHolidayInfo.removeClass("strong");

		// 휴일정보 조회
		var data = ajaxCall("${ctx}/GetDataMap.do?cmd=getExWorkAppDetHolidayInfo", params, false);
		if(data != null && data != undefined && data.DATA != null && data.DATA != undefined) {
			holidayGubun = data.DATA.gubun;


			// 휴일인 경우
			if(data.DATA.gubun == "1") {
				$txtHolidayInfo.addClass("f_red");
				$txtHolidayInfo.addClass("strong");
			}

			// 정보 출력
			$txtHolidayInfo.html(data.DATA.dayText);
		}
		return data;
	}

	// 휴일 선택 체크 실행
	function checkHoliday(date) {
		var $workGubun = $("#workGubun");

		var params = {
			"sdate" : date.replace(/-/gi, "")
		};

		// 휴일정보 조회
		var data = getHolidayInfo(date);


		// 정상 조회시..
		if(data != null && data != undefined && data.DATA != null && data.DATA != undefined) {
			var changeWorkGubun = "N";
			// 휴일
			if(data.DATA.gubun == "1") {
				changeWorkGubun = "S";
			}
			// 근무구분 변경
			$workGubun.val(changeWorkGubun);
			// 근무구분 값 변경 이벤트 실행
			$workGubun.trigger('change');
		}
	}

</script>

<style type="text/css">
td span { letter-spacing:0 !important; }
</style>
</head>
<body class="bodywrap">
<form id="dataForm" name="dataForm" >
<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
<input type="hidden" id="searchApplSeq" name="searchApplSeq" value=""/>
<input type="hidden" id="applYmd" name="applYmd" />
<input type="hidden" id="baseDateE" name="baseDateE" />
<input type="hidden" id="baseDateS" name="baseDateS" />

<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="sStatus"/>
<input type="hidden" id="sStatus" name="sStatus" value="U"/>
<input type="hidden" id="reqSHm" name="reqSHm" />
<input type="hidden" id="reqEHm" name="reqEHm" />
<input type="hidden" id="workHour" name="workHour" />
<input type="hidden" id="encReason" name="encReason" />

<div class="wrapper">
	<div class="outer mat10">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="202005180000017" mdef="시간외근무(기원)" /> <tit:txt mid="appTitleV1" mdef="신청" /></li>
		</ul>
		</div>
	</div>
	<table class="table">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
			<col width="" />
		</colgroup>
		<tr>
			<th align="center"><tit:txt mid="103962" mdef="근무일자" /></th>
			<td>
				<input id="sdate" name="sdate" class="required ${dateCss} ${readonly} center" ${readonly} />
				&nbsp;&nbsp;
				<span id="txt_holidayInfo"></span>
			</td>
			<th align="center"><tit:txt mid="202005180000018" mdef="수당구분" /></th>
			<td>
				<select id="workGubun" name="workGubun" class="${textCss} ${required} ${selectDisabled}"  disabled>
					<option value="N"><tbl:txt mid='searchWorkGubunN_V121' mdef='야근수당' /></option>
					<option value="S"><tbl:txt mid='searchWorkGubunS_V121' mdef='특근수당' /></option>
				</select>
			</td>
		</tr>
		<tr id="trMorningSHM">
			<th align="center"><tit:txt mid="202005180000042" mdef="아침시작시간" /></th>
			<td colspan="3">
				<select id="morningSH" name="morningSH" class="${textCss} ${required} ${selectDisabled}">
				</select>&nbsp;&nbsp;
				<select id="morningSM" name="morningSM" class="${textCss} ${required} ${selectDisabled}">
				</select>
			</td>
		</tr>
		<tr id="trGolfYn">
			<th align="center"><tit:txt mid="202005180000038" mdef="골프장여부" /></th>
			<td colspan="3">
				<select id="golfYn" name="golfYn" class="required transparent ${textCss} ${selectDisabled}">
				<option value=""><sch:txt mid='select' mdef='선택 ' /></option>
				<option value="N">N</option>
				<option value="Y">Y</option>
				</select>
			</td>
		</tr>
		<tr>
			<th align="center"><tit:txt mid="103861" mdef="근무시간" /></th>
			<td>
				<select id="reqSH" name="reqSH" class="required  transparent ${textCss} ${selectDisabled}">
				</select>&nbsp;&nbsp;
				<select id="reqSM" name="reqSM" class="required transparent ${textCss} ${selectDisabled}">
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;&nbsp;
				<span id="span_reqEH"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="span_reqEM"></span>
			</td>
			<th align="center"><tit:txt mid="202005180000086" mdef="총 시간" /></th>
			<td>
				<select id="workHourH" name="workHourH" class="required transparent ${textCss} ${selectDisabled}">
				</select>&nbsp;&nbsp;
				<select id="workHourM" name="workHourM" class="required transparent ${textCss} ${selectDisabled}">
				</select>
			</td>
		</tr>

		<tr>
			<th align="center"><tit:txt mid="103867" mdef="근무내용" /></th>
			<td colspan="3">
				<textarea rows="6" id="reason" name="reason" class="w100p ${textCss} ${required}" ${readonly}></textarea>
			</td>
		</tr>
	</table>

</div>
</form>
</body>
</html>