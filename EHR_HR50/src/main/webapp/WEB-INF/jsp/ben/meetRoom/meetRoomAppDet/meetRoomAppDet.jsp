<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>회의실신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var searchApplSabun = "${searchApplSabun}";
	var searchSabun = "${searchSabun}";

	//선택 회의실 신청 기준 데이터
	var _meetRoomData;

	// 사용자 교체 확인 플래그
	var flag = false;
	$(function() {

		$("#rdPrint").hide();

		applStatusCd = parent.$("#applStatusCd").val();
		if(applStatusCd == "99"){
			$("#rdPrint").show();
		}

		// 신청 상태가 없을 경우는 무조건 임시정장으로 본다.
		if(applStatusCd == ""){
			applStatusCd = "11";
		}

		// 세션 사번
		$("#searchSabun").val(searchSabun);

		// 신청자
		$("#searchApplSabun").val(searchApplSabun);

		// 신청순번
		$("#searchApplSeq").val(searchApplSeq);

		// 회의실
		var meetRoom = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getMeetRoomCdList&useYn=Y",false).codeList, "회의실을 선택하여 주세요.");		
		$("#meetRoom").html(meetRoom[2]);
		$("#meetRoom").bind("change", function(e) {
			_meetRoomData = ajaxCall("${ctx}/MeetRoomApp.do?cmd=getMeetRoomInfo", "searchMeetRoomNo="+$(this).val(), false).DATA;
			if(_meetRoomData != null && _meetRoomData != undefined) {
				//$("#chargeOrgCd").val(_meetRoomData.chargeOrgCd);
				$("#chargeOrgNm").val(_meetRoomData.chargeOrgNm);
				$("#chargeSabun").val(_meetRoomData.chargeSabun);
				$("#chargeName").val(_meetRoomData.chargeName);
			}
		});

		//if(authPg=="A"){
		if(applStatusCd != "99"){
			//신청화면 세팅 (admin화면, 처리완료 아닐때)

			// 시작일자
			$("#fromYmd").datepicker2({
				startdate:"toYmd"
			});

			// 시작시간
			/*
			$("#fromTime").timepicker({
				timeFormat:"H:i",
				scrollDefault:"now"
			});
			*/

			// 종료일자
			$("#toYmd").datepicker2({
				enddate:"fromYmd"
			});

			// 종료시간
			/*
			$("#toTime").timepicker({
				timeFormat:"H:i",
				scrollDefault:"now"
			});
			*/

			// 숫자와 : 외의 입력값 방지
			$("#fromTime, #toTime").on("keyup", function(e) {
				var str = $(this).val().replace(/[^0-9:]/g, "");
				$(this).val(str);
			})

	    } else{
			//결재화면 세팅
			$("#meetRoom").attr("disabled", true);
	    	$("#fromYmd").attr("readonly", true);
	    	$("#toYmd").attr("readonly", true);
	    	$("#fromTime").attr("readonly", true);
	    	$("#toTime").attr("readonly", true);
	    	$("#usePurpose").attr("readonly", true);
	    	$("#shourH, #shourM, #ehourH, #ehourM").attr("disabled", true);

	    	$(".button6, .button7").hide();
	    }

	    // 담당자의견
	    $("#usePurpose").maxbyte(1000);

	    if(adminYn=="Y"){
	    	if(applStatusCd != "99"){
	 			$("#meetRoom").attr("disabled", false).removeClass("readonly transparent");
	    	}else{
	    		//관리자이고 처리완료인 경우, 결재내용 수정 불가
	 			$("#meetRoom").attr("disabled", true).addClass("readonly transparent");
	    	}
	    }
		
	    //신청일자
	    $("#searchApplYmd").text("${curSysYyyyMMddHyphen}");
	    
		doAction1("Search");

		parent.iframeOnLoad("200px");
	});

	// 숫자를 변환..
	function addComma(n) {
	 if(isNaN(n)){return 0;}
	  var reg = /(^[+-]?\d+)(\d{3})/;
	  n += '';
	  while (reg.test(n))
	    n = n.replace(reg, '$1' + ',' + '$2');
	  return n;
	}

	// 숫자를 변환..
	function addDash(n) {
		if(n == null || n.length != 8) {
			return n;
		}

		var r = "" +
		n.substr(0, 4) +
		"-" +
		n.substr(4, 2) +
		"-" +
		n.substr(6, 2);

		return r;
	}

    //시간입력 form 체크 (숫자,0~23/0~59)
    function onKeyUpEvent_timeForm(obj,HorM) {
    	var val = obj.value+"";

   		val = val.replace(/[^0-9.]/g,'');

    	if(HorM == "h" && val*1 >= 24){
    		val = "";
    		alert("<msg:txt mid='2020052500273' mdef='0-23의 범위에서 입력해주세요.'/>");
    	}else if(HorM == "m" && val*1 >= 60){
    		val = "";
    		alert("<msg:txt mid='2020052500275' mdef='0-59의 범위에서 입력해주세요.'/>");
    	}

    	obj.value = val;
    }

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall("${ctx}/MeetRoomApp.do?cmd=getMeetRoomAppDetMap","&searchApplSeq="+searchApplSeq,false);

			if(data.DATA == null){
				return;
			}

			// 회의실
			$("#meetRoom").val(data.DATA.meetRoomNo);
			$("#meetRoom").change();

			// 회의시작일
			$("#fromYmd").val(data.DATA.fromYmd);

			// 회의시작시간
			$("#fromTime").val(data.DATA.fromTime);
			var fromTimeArr = data.DATA.fromTime.split(":");
			$("#shourH").val(fromTimeArr[0]);
			$("#shourM").val(fromTimeArr[1]);

			// 회의종료일
			$("#toYmd").val(data.DATA.toYmd);

			// 회의종료시간
			$("#toTime").val(data.DATA.toTime);			
			var toTimeArr = data.DATA.toTime.split(":");
			$("#ehourH").val(toTimeArr[0]);
			$("#ehourM").val(toTimeArr[1]);

			// 회의목적
			$("#usePurpose").val(data.DATA.usePurpose);

			// 담당자의견
			$("#note").val(data.DATA.note);
			
			//신청일자
			$('#searchApplYmd').text(data.DATA.applYmd);

			break;
		}
	}

	// 회의실 대여 validate
	function validateApp() {
		/* 해당 신청기간에 신청 가능한지 체크 */
		var params = "" +
		"searchMeetRoomNo=" + $("#meetRoom").val() +
		"&searchFromYmd=" + $("#fromYmd").val().replace(/-/gi, "") +
		"&searchFromTime=" + $("#fromTime").val().replace(/:/gi, "") +
		"&searchToYmd=" + $("#toYmd").val().replace(/-/gi, "") +
		"&searchToTime=" + $("#toTime").val().replace(/:/gi, "") +
		"&searchApplSabun=" + $("#searchApplSabun").val();
		var data = ajaxCall("${ctx}/MeetRoomApp.do?cmd=getEnableMeetRoomApp",params,false);
 		// 회의실 신청정보를 확인하여 신청 일시를 비교 하게 하고, 이미 존재하는 경우 경고창을 띄움.
		if(data.DATA != null){
			if(data.DATA.length > 0){
				if(data.DATA.length == 1) {
					alert("해당시간에 회의실이 이미 예약되어 있습니다.\n(신청자: " + data.DATA[0].name + ", 사용일시: " + data.DATA[0].fromYmd + " " + data.DATA[0].fromTime + " ~ " + data.DATA[0].toYmd + " " + data.DATA[0].toTime + ")");
				} else {
					alert("해당시간에 회의실이 이미 " + data.DATA.length + "건 예약되어 있습니다.");
				}
	 			return false;
			}
		}

		return true;
	}

	// 입력시 조건 체크
	function checkList(status){

		var ch = true;

    	$("#meetRoom").removeAttr('disabled');

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($.trim($(this).val()).length == 0){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
				$(this).focus();
				ch =  false;
				return ch;
			}
		});
		
		if(!ch) return ch;

    	//해당 회의실 기준의 사용여부가 Y인지 체크
		if(_meetRoomData.useYn == 'N') {
			alert("해당 회의실은 신청할 수 없습니다. (사용여부:N)");
			ch = false;
			return ch;
		}
/*
		var fy = $("#fromYmd").val().replace(/-/gi, "");
		var ty = $("#toYmd").val().replace(/-/gi, "");
		var ft = $("#fromTime").val().replace(/:/gi, "");
		var tt = $("#toTime").val().replace(/:/gi, "");

		if(fy > ty || ( fy == ty && ft >= tt )) {
			alert("회의실 사용 시간을 확인해주세요.");
			ch = false;
			return ch;
		}
*/

		$("#fromTime").val($("#shourH").val()+$("#shourM").val());
		$("#toTime").val($("#ehourH").val()+$("#ehourM").val());
		
		var fullFrom = $("#fromYmd").val().split("-").join('');
		fullFrom +=$("#fromTime").val();
		var fullTo = $("#toYmd").val().split("-").join('');
		fullTo +=$("#toTime").val();
		
		if (fullFrom >= fullTo) {
			alert("사용시작일, 사용종료일을 확인하세요");
			return;
		}

		if(!validateApp()) {
			return;
		}

    	$("#meetRoom").attr("disabled", true);

		return ch;
	}

	// 저장후 리턴함수
	function setValue(status){
		var returnValue = false;

		// 항목 체크 리스트
		if(checkList()){

			try{
		    	$("#meetRoom").attr('disabled', false);
				var rtn = ajaxCall("${ctx}/MeetRoomApp.do?cmd=saveMeetRoomAppDet",$("#dataForm").serialize(),false);

				$("#meetRoom").attr("disabled", true);

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				}else{
					returnValue = true;
				}

			} catch (ex){
				alert("Script Errors Occurred While Saving." + ex);
				returnValue = false;
			}
		}else{
			return false;
		}
		return returnValue;
	}

</script>
</head>
<body class="bodywrap">
	<form id="dataForm" name="dataForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
		<input type="hidden" id="searchApplSeq" name="searchApplSeq" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
		<input type="hidden" id="gntCd" name="gntCd" value=""/>
		<input type="hidden" id="dupChkYn" name="dupChkYn" value="N"/>

		<div class="wrapper">
			<div class="outer">
				<div class="sheet_title">
					<ul>
						<li class="txt">회의실 신청</li>
					</ul>
				</div>
				<table class="table">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="" />
					</colgroup>
					 <tr class="hide">
						<th align="center"><tit:txt mid='104084' mdef='신청일자'/></th>
						<td colspan="3">
							<span id="searchApplYmd" class="${dateCss} ${readonly} w4p"></span>
						</td>
					</tr>					
					<tr>
						<th align="center">회의실</th>
						<td colspan="3">
							<select id="meetRoom" name="meetRoom" class="${textCss} ${readonly} required" ${readonly}></select>
						</td>
					</tr>
					<tr>	
						<th align="center">사용시작일</th>
						<td  colspan="3">
							<input type="text" id="fromYmd" name="fromYmd" value="${curSysYyyymmdd}" class="${textCss} ${readonly} required" ${readonly}>
							<select id="shourH" name="shourH"  class="required">
								<option value=""></option>
							<c:forEach var="i" begin="0" end="23" step="1">
							<c:choose>
								<c:when test="${i < 10}">
									<option value="0${i}">0${i}</option>
								</c:when>
								<c:otherwise>
									<option value="${i}">${i}</option>
								</c:otherwise>
							</c:choose>
							</c:forEach>
							</select> :
							<select id="shourM" name="shourM"  class="required">
								<option value=""></option>
							<c:forEach var="i" begin="0" end="50" step="30">
							<c:choose>
								<c:when test="${i < 10}">
									<option value="0${i}">0${i}</option>
								</c:when>
								<c:otherwise>
									<option value="${i}">${i}</option>
								</c:otherwise>
							</c:choose>
							</c:forEach>
							</select>
							<input type="hidden" id="fromTime" name="fromTime" maxlength="5" class="${textCss} ${readonly}" ${readonly}>
						</td>
					</tr>
					<tr>
						<th align="center">사용종료일</th>
						<td colspan="3">
							<input type="text" id="toYmd"   name="toYmd"   value=""                  class="${textCss} ${readonly} required" ${readonly}/>
							<select id="ehourH" name="ehourH"  class="required">
								<option value=""></option>
							<c:forEach var="i" begin="0" end="23" step="1">
							<c:choose>
								<c:when test="${i < 10}">
									<option value="0${i}">0${i}</option>
								</c:when>
								<c:otherwise>
									<option value="${i}">${i}</option>
								</c:otherwise>
							</c:choose>
							</c:forEach>
							</select> :
							<select id="ehourM" name="ehourM"  class="required">
								<option value=""></option>
							<c:forEach var="i" begin="0" end="50" step="30">
							<c:choose>
								<c:when test="${i < 10}">
									<option value="0${i}">0${i}</option>
								</c:when>
								<c:otherwise>
									<option value="${i}">${i}</option>
								</c:otherwise>
							</c:choose>
							</c:forEach>
							</select>
							<input type="hidden" id="toTime" name="toTime" maxlength="5" class="${textCss} ${readonly}" ${readonly}>							
						</td>
					</tr>
					<tr>
						<th align="center">사용 목적</th>
						<td colspan="3">
							<input type="text" id="usePurpose" name="usePurpose" class="${textCss} required w100p" required/>
						</td>
					</tr>
					<tr>
						<th align="center">담당부서</th>
						<td>
							<!-- <input type="text" id="chargeOrgCd" name="chargeOrgCd" class="text transparent readonly" readonly> -->
							<input type="text" id="chargeOrgNm" name="chargeOrgNm" class="text transparent readonly" readonly>
						</td>
						<th align="center">담당자</th>
						<td>
							<input type="text" id="chargeSabun" name="chargeSabun" class="text transparent readonly" readonly>
							<input type="text" id="chargeName" name="chargeName" class="text transparent readonly" readonly>
						</td>
					</tr>					
					<tr style="display:none;">
						<th align="center">담당자의견</th>
						<td colspan="3">
							<input type="text" id="note" name="note" class="${adminTextCss} ${adminReadonly} w100p" ${adminReadonly}/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</body>
</html>