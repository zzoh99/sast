<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>리조트신청</title>
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
	var pGubun           = "";
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
			$("#sdate").datepicker2({onReturn:function(){getDays(true);}, startdate:"edate"});
			$("#edate").datepicker2({onReturn:function(){getDays();}, enddate:"sdate"});
		} else if (authPg == "R") {
			if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //관리자거나 수신결재자이면
				if( applStatusCd == "31" ){ //수신처리중일 때만 지급정보 수정 가능
					/* $("#statusCd1").removeClass("transparent").removeClass("hideSelectButton").removeAttr("disabled");
					$("#applMon").removeClass("transparent").removeAttr("readonly"); */
				}
				adminRecevYn = "Y";
			}
		}
		//날짜 입력시 이벤트
		/* $('#searchForm').on('keyup', '#sdate',function() {
			getDays(true);
		});
		
		$('#searchForm').on('keyup', '#edate',function() {
			getDays();
		}); */
		
		var companyCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B49530"), "선택");
		$("#companyCd").html(companyCdList[2]);
		
		//대상자 선택시
		$('#searchForm').on('change', 'select[name="companyCd"]',function() {
			//리조트 회사 > 이름 콤보
			param = "&companyCd="+$("#companyCd").val();
			var resortList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getResortAppDetResortName"+param, false).codeList, "선택");
			$("#resortNm").html(resortList[2]);
		});
		
		//지원구분 선택시
		$('#searchForm').on('change', 'select[name="comMonYn"]',function() {
			var boolComMonYnCnt = getResortAppDetChkComMon(true); 
			if(!boolComMonYnCnt){
				$("#comMonYn").val("N");
			}
		});
		

        $("#cnt").on("keyup", function(event) {
            //신청년도 숫자만 입력
            makeNumber(this,'A');
        });
		
		
		doAction("Search"); 
	});
		
	//일수 계산
	function getDays(boolChk){
		var sdate = replaceAll($("#sdate").val(), "-", "");
		var edate = replaceAll($("#edate").val(), "-", "");
		if( sdate =="" || edate =="" || edate == null){
			$("#days").val("");
			$("#span_days").html("");
		}else{
			if( sdate > edate){
				alert('<msg:txt mid="110396" mdef="시작일자가 종료일자보다 큽니다." />');
				$("#edate").val("");
				return false;
			}
			var days = getDaysBetween(sdate, edate)-1;
			$("#days").val(days);
			/* $("#span_days").html(days+'<tit:txt mid="L19080600006" mdef="박" /> '+ (days+1)+'<tit:txt mid="day" mdef="일" />' ); */
			$("#span_days").html(days+'<tit:txt mid="L19080600006" mdef="박" />');
		}
		if (boolChk && sdate) {
			var data = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortTargetYn", $("#searchForm").serialize(),false);
			if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
				$("#targetYn").val("Y");
				$("select[name='comMonYn'] option[value*='Y']").prop('disabled',false);
			} else {
				$("#targetYn").val("N");
				$("#comMonYn").val("N");
				$("select[name='comMonYn'] option[value*='Y']").prop('disabled',true);
			}
		}
		return true;
		
	}

	//회사지원 가능여부 조회 return => 신청가능:true 신청불가능:false 
	function getResortAppDetChkComMon(boolAlert) {
		
		var comMonYn = $("#comMonYn").val();
		if (comMonYn == 'Y') {
			//신청건수가 리턴됨
			var data = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortAppDetChkComMon", $("#searchForm").serialize(),false);
			if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
				if (boolAlert) {
					alert("회사지원을 신청한 이력이 있어\n회사지원을 선택 할 수 없습니다.\n개인부담으로 신청 해주세요.");
				}
				return false;
			}
		}
		return true;
	}
	
	//성수기 사용기간 여부 체크
	function getResortAppDetChkSeasonDay() {
		var data = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortAppDetChkSeasonDay", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			alert("해당 기간은 성수기이며\n[성수기리조트신청]화면에서 신청 해주세요");
			return false;
		}
		return true;
	}

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search" :
			// 입력 폼 값 셋팅
			var map = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortAppDetMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){ 
				var data = map.DATA;
				
				$("#companyCd").val(data.companyCd);
				if(authPg == "A") {
					$('#companyCd').change();
					$("#resortNm").val(data.resortNm);
				} else {
					$('#companyCd').change();
					$("#resortNm").val(data.resortNm).hide(); $("#resortNmView").html(data.resortNm).show();
				}
				$("#sdate").val(formatDate(data.sdate, "-")).focusout();
				$("#edate").val(formatDate(data.edate, "-")).focusout();
				$("#roomType").val(data.roomType);
				$("#days").val(data.days);
				$("#cnt").val(data.cnt);
				$("#phoneNo").val(data.phoneNo);
				$("#mailId").val(data.mailId);
				$("#note").val(data.note);
				$("#planSeq").val(data.planSeq);
				$("#resortSeq").val(data.resortSeq);
				$("#hopeCd").val(data.hopeCd);
				$("#rsvNo1").val(data.rsvNo1);
				$("#rsvNo2").val(data.rsvNo2);
				$("#resortMon").val(data.resortMon);
				$("#comMon").val(data.comMon);
				$("#psnalMon").val(data.psnalMon);
				
				$('#comMonYn').val((data.comMonYn && data.comMonYn == "Y") ? "Y" : "N");
				$(':checkbox[name=waitYnView]').attr('checked', ( (data.waitYn && data.waitYn == "Y") ? true : false ));
				
				//span 박수 및 지원대상자여부 조회
				getDays(true);

			}else{
				var map2 = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortAppDetMap2",$("#searchForm").serialize(),false);
				if ( map2 != null && map2.DATA != null ){ 
					var data = map2.DATA;
					$("#phoneNo").val(data.phoneNo);
					$("#mailId").val(data.mailId);
					
				}
				
			}
			break;
		}
	}

	// 입력시 조건 체크
	function checkList() {
		var ch = true;
		
		//날짜 다시 한번 검색
		if(!getDays(true)){return false;};
		
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
		
		//지원구분 회사지원선택시 기신청건있는지 체크
		var boolComMonYnCnt = getResortAppDetChkComMon(true); 
		if(!boolComMonYnCnt){
			$("#comMonYn").focus();
			return false;
		}
		
		//성수기여부 체크
		var boolChkSeasonDayCnt = getResortAppDetChkSeasonDay(); 
		if(!boolChkSeasonDayCnt){
			$("#sdate").focus();
			return false;
		}

		return ch;
	}

	// 저장후 리턴함수
	function setValue() {
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
		        	
		        	$("#waitYn").val( $(':checkbox[name=waitYnView]').is(":checked") ? "Y" : "N" );
	
					var rtn = ajaxCall("${ctx}/ResortApp.do?cmd=saveResortAppDet", $("#searchForm").serialize(), false);
	
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

</script>
<style type="text/css">
/*---- checkbox ----*/
input[type="checkbox"]  { 
	display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none; 
 	-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}
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
	
	<%-- 성수기에 필요한 값 실제 미사용  --%>
	<input type="hidden" id="planSeq"		name="planSeq"	     value=""/>
	<input type="hidden" id="resortSeq"		name="resortSeq"	 value=""/>
	<input type="hidden" id="hopeCd"		name="hopeCd"	     value=""/>
	<input type="hidden" id="rsvNo1"		name="rsvNo1"	     value=""/>
	<input type="hidden" id="rsvNo2"		name="rsvNo2"	     value=""/>
	<input type="hidden" id="resortMon"		name="resortMon"	 value=""/>
	<input type="hidden" id="comMon"		name="comMon"	     value=""/>
	<input type="hidden" id="psnalMon"		name="psnalMon"	     value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="30%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
		<tr>
			<th>리조트명</th>
			<td colspan="3">
				<select id="companyCd" name="companyCd" class="${selectCss} ${required} w100 " ${disabled}></select>&nbsp;&nbsp;
				<select id="resortNm" name="resortNm" class="${selectCss} ${required} w200 " ${disabled}></select>
				<span id="resortNmView" name="resortNmView"></span>
			</td>
		</tr>
		<tr>
			<th>사용기간</th>
			<td colspan="3">
				<input type="text" id="sdate" name="sdate" class="${textCss} ${required}  w80" ${readonly}/>&nbsp;~&nbsp;
				<input type="text" id="edate" name="edate" class="${textCss} ${required}  w80" ${readonly}/>&nbsp;&nbsp;
				<input type="hidden" id="days" name="days" />
				<span id="span_days"></span>
			</td>
		</tr>
		<tr>
			<th>객실타입</th>
			<td>
				<input type="text" id="roomType" name="roomType" class="${textCss} ${required}  w250" ${readonly}/>
			</td>
			<th>사용인원</th>
			<td>
				<input type="text" id="cnt" name="cnt" class="${textCss} ${required}  w20" ${readonly} maxlength="2"/><span>&nbsp;명</span>
			</td>
		</tr>
		<tr>
			<th>예약대기여부</th>
			<td>
				<input type="checkbox" id="waitYnView" name="waitYnView" style="vertical-align:middle;" class="${required}" ${disabled}/>
				<input type="hidden" id="waitYn" name="waitYn"/>
			</td>
			<th>지원대상자여부</th>
			<td>
				<input type="text" id="targetYn" name="targetYn" class="${textCss} transparent  w100" readonly/>
			</td>
		</tr>
		<tr>
			<th>연락처</th>
			<td>
				<input type="text" id="phoneNo" name="phoneNo" class="${textCss} ${required} w250" ${readonly}/>
			</td>
			<th>메일주소</th>
			<td>
				<input type="text" id="mailId" name="mailId" class="${textCss} ${required} w250" ${readonly}/>
			</td>
		</tr>
		<tr>
			<th>지원구분</th>
			<td colspan="3">
				<select id=comMonYn name="comMonYn" class="${selectCss} w100 " ${disabled}>
					<option value="N">개인부담</option>
					<option value="Y">회사지원</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>기타요청사항</th>
			<td colspan="3">
				<input type="text" id="note" name="note" class="${textCss} w100p" ${readonly} maxlength="500"/>
			</td>
		</tr>
	</table>
</div>
</body>
</html>