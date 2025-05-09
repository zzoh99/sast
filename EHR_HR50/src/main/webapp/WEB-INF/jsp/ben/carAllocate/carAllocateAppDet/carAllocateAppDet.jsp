<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>업무차량배차신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<link rel="stylesheet" href="/common/plugin/jquery-timepicker-1.11.12/css/jquery.timepicker.css" />
<script src="${ctx}/common/plugin/jquery-timepicker-1.11.12/js/jquery.timepicker.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var searchApplSabun = "${searchApplSabun}";
	var searchSabun = "${searchSabun}";

	//선택 업무차량기준 데이터
	var _carAllocateData;

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

		// 업무차량
		var carNo = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCarAllocateCdList&useYn=Y",false).codeList, "업무차량을 선택하여 주세요.");
		$("#carNo").html(carNo[2]);
		$("#carNo").bind("change", function(e) {
			_carAllocateData = ajaxCall("${ctx}/CarAllocateApp.do?cmd=getCarAllocateInfo", "searchCarNo="+$(this).val(), false).DATA;
			if(_carAllocateData != null && _carAllocateData != undefined) {
				//$("#chargeOrgCd").val(_carAllocateData.chargeOrgCd);
				$("#chargeOrgNm").val(_carAllocateData.chargeOrgNm);
				$("#chargeSabun").val(_carAllocateData.chargeSabun);
				$("#chargeName").val(_carAllocateData.chargeName);
			}
		});

		//if(authPg=="A" || (adminYn == 'Y' && applStatusCd != '99')) {
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
			$("#carNo").attr("disabled", true);
	    	$("#fromYmd").attr("readonly", true);
	    	$("#toYmd").attr("readonly", true);
	    	$("#fromTime").attr("readonly", true);
	    	$("#toTime").attr("readonly", true);
	    	$("#usePurpose").attr("readonly", true);
	    	$("#useArea").attr("readonly", true);
	    	$("#shourH, #shourM, #ehourH, #ehourM").attr("disabled", true);

	    	$(".button6, .button7").hide();
	    }

	    // 운행목적
	    $("#usePurpose").maxbyte(100);
	    // 운행지역
	    $("#useArea").maxbyte(100);

	    if(adminYn=="Y"){
	    	if(applStatusCd != "99"){
	 			$("#carNo").attr("disabled", false).removeClass("readonly transparent");
	 			$("#fromYmd, #fromTime, #toYmd, #toTime").attr("readonly", false).removeClass("readonly transparent");
	    	}else{
	    		//관리자이고 처리완료인 경우, 결재내용 수정 불가
	 			$("#carNo").attr("disabled", true).addClass("readonly transparent");
	 			$("#fromYmd, #fromTime, #toYmd, #toTime").attr("readonly", true).addClass("readonly transparent");
	    	}
	    }

	  //신청일자
	    $("#searchApplYmd").text("${curSysYyyyMMddHyphen}");
	    
		doAction1("Search");

		parent.iframeOnLoad("240px");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall("${ctx}/CarAllocateApp.do?cmd=getCarAllocateAppDetMap","&searchApplSeq="+searchApplSeq,false);

			if(data.DATA == null){
				return;
			}

			// 업무차량
			$("#carNo").val(data.DATA.carNo).change();

			// 차량배차 시작일
			$("#fromYmd").val(data.DATA.fromYmd);

			// 차량배차 시작시간
			$("#fromTime").val(data.DATA.fromTime);
			var fromTimeArr = data.DATA.fromTime.split(":");
			$("#shourH").val(fromTimeArr[0]);
			$("#shourM").val(fromTimeArr[1]);

			// 차량배차 종료일
			$("#toYmd").val(data.DATA.toYmd);

			// 차량배차 종료시간
			$("#toTime").val(data.DATA.toTime);
			var toTimeArr = data.DATA.toTime.split(":");
			$("#ehourH").val(toTimeArr[0]);
			$("#ehourM").val(toTimeArr[1]);

			// 운행목적
			$("#usePurpose").val(data.DATA.usePurpose);

			// 운행지역
			$("#useArea").val(data.DATA.useArea);

			// 담당자의견
			$("#note").val(data.DATA.note);
			
			//신청일자
			$('#searchApplYmd').text(data.DATA.applYmd);

			break;
		}
	}

	// 업무차량 배차 validate
	function validateApp() {
		/* 해당 신청기간에 신청 가능한지 체크 */
		var params = "" +
		"searchCarNo=" + $("#carNo").val() +
		"&searchFromYmd=" + $("#fromYmd").val().replace(/-/gi, "") +
		"&searchFromTime=" + $("#fromTime").val().replace(/:/gi, "") +
		"&searchToYmd=" + $("#toYmd").val().replace(/-/gi, "") +
		"&searchToTime=" + $("#toTime").val().replace(/:/gi, "") +
		"&searchApplSabun=" + $("#searchApplSabun").val();
		var data = ajaxCall("${ctx}/CarAllocateApp.do?cmd=getEnableCarAllocateApp",params,false);

 		// 배차정보를 확인하여 배차 신청일자를 비교 하게 된다.
		if(data.DATA != null){
			if(data.DATA.length > 0){
				if(data.DATA.length == 1) {
					alert("해당시간에 업무차량이 이미 배차예약되어 있습니다.\n(신청자: " + data.DATA[0].name + ", 사용일시: " + data.DATA[0].fromYmd + " " + data.DATA[0].fromTime + " ~ " + data.DATA[0].toYmd + " " + data.DATA[0].toTime + ")");
				} else {
					alert("해당시간에 업무차량이 이미 " + data.DATA.length + "건 배차 예약되어 있습니다.");
				}
	 			return false;
			}
		}

		return true;
	}

	// 입력시 조건 체크
	function checkList(){

		var ch = true;

    	$("#carNo").removeAttr('disabled');

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

    	//해당 경조기준 사용여부가 Y인지 체크
		if(_carAllocateData.useYn == 'N') {
			alert("해당 업무차량은 배차를 신청할 수 없습니다. (사용여부:N)");
			ch = false;
			return ch;
		}
/*
		var fy = $("#fromYmd").val().replace(/-/gi, "");
		var ty = $("#toYmd").val().replace(/-/gi, "");
		var ft = $("#fromTime").val().replace(/:/gi, "");
		var tt = $("#toTime").val().replace(/:/gi, "");

		if(fy > ty || ( fy == ty && ft >= tt )) {
			alert("업무차량 배차시간을 확인해주세요.");
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
			alert("배차시작, 배차종료 일시를 확인하세요");
			return;
		}

		if(!validateApp()) {
			return;
		}

    	$("#carNo").attr("disabled", true);

		return ch;
	}

	// 저장후 리턴함수
	function setValue(){
		//var rtn;
		var returnValue = false;

		// 항목 체크 리스트
		if(checkList()){

			try{
		    	$("#carNo").attr('disabled', false);

				var rtn = ajaxCall("${ctx}/CarAllocateApp.do?cmd=saveCarAllocateAppDet",$("#dataForm").serialize(),false);

				$("#carNo").attr("disabled", true);

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
						<li class="txt">업무차량배차신청</li>
					</ul>
				</div>
				<table class="table">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="" />
					</colgroup>
					 <tr>
						<th align="center"><tit:txt mid='104084' mdef='신청일자'/></th>
						<td colspan="3">
							<span id="searchApplYmd" class="${dateCss} ${readonly} w4p"></span>
						</td>
					</tr>					
					<tr>
						<th align="center">업무차량</th>
						<td colspan="3">
							<select id="carNo" name="carNo" class="${textCss} ${readonly} required" ${readonly}></select>
						</td>
					</tr>
					<tr>
						<th align="center">배차시작일</th>
						<td colspan="3">
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
						<th align="center">배차종료일</th>
						<td colspan="3">
							<input type="text" id="toYmd" name="toYmd" value="" class="${textCss} ${readonly} required" ${readonly} required/>
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
						<th align="center">운행목적</th>
						<td colspan="3">
							<input type="text" id="usePurpose" name="usePurpose" class="${textCss}  required w100p"  required/>
						</td>
					</tr>
					<tr>
						<th align="center">운행지역</th>
						<td colspan="3">
							<input type="text" id="useArea" name="useArea" class="${textCss}  required w100p"  required/>
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