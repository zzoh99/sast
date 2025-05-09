<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>의료비신청 세부내역</title>
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
	var readonly 		 = "${readonly}";
	var user;
	var medStd;					//의료비 기준관리 정보

	$(function() {
		
		parent.iframeOnLoad(220);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#searchYmd").val(searchApplYmd);
		
		$('#applMon').mask('000,000,000,000,000', { reverse : true });
		$('#payMon').mask('000,000,000,000,000', { reverse : true });

		applStatusCd = parent.$("#applStatusCd").val();
		$("#famRealNm").hide();
		
		applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부
		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		
		
		if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //담당자거나 수신결재자이면
			
			if( applStatusCd == "31") { //수신처리중일 때만 지급정보 수정 가능
				$("#applMon").removeClass("transparent").removeAttr("readonly");
				$("#payMon").removeClass("transparent").removeAttr("readonly");
				$("#payYm").removeClass("transparent").removeAttr("readonly");
				$("#payNote").removeClass("transparent").removeAttr("readonly");
				$("#payYm").datepicker2({ymonly:true});
			}

			adminRecevYn = "Y";
			
			$(".payInfo").show();
			parent.iframeOnLoad(300);
		}
		
		var param = "";
		$("#btnPopup").hide();
		
		if(authPg == "A") {
			$("#payYm").datepicker2({ymonly:true});
			$("#btnPopup").show();
		} else if (authPg == "R") {
		}
		
		var param = "&searchApplSabun="+$("#searchApplSabun").val();
		//대상자 콤보
		var famCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getMedAppDetFamCdList"+param, false).codeList, "선택");
		$("#famNm").html(famCdList[2]);
		
		//대상자 선택시
		$('#searchForm').on('change', 'select[name="famNm"]',function() {
			if(!isPopup()) {return;}
			$("#medCode").val("");
			$("#medCodeNm").val("");
			$("#famYmd").val("");
			$("#famCdNm").val("");
			$("#buyangYn").val("");
			$("#totalPayMon").val("");
			doAction("ReLoad");
		});
		
		$(".stdMonView").hide();
		doAction("Search");
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){
				$("#famNm").val(data.DATA.famResNo);
				$("#famCd").val(data.DATA.famCd);
				$("#famRealNm").val(data.DATA.famNm);
				$("#medCode").val(data.DATA.medCode);
				$("#medCodeNm").val(data.DATA.medName);
				$("#medSYm").val(formatDate(data.DATA.medSYm, "-"));
				$("#note").val(data.DATA.note);
				$("#famYmdReal").val(data.DATA.famYmd);
				closeYn = data.DATA.closeYn;
				
				if (authPg == "R") {
					$("#famRealNm").show();
					$("#famNm").hide();
					$("#famYmd").val(formatDate(data.DATA.famYmd, "-")+" / "+data.DATA.sexTypeNm);
					$("#famCdNm").val(data.DATA.famCdNm);
					
					
					// 전년도 연말정산 부양가족여부
					var data2 = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetDpndntYn", $("#searchForm").serialize(),false);
					if ( data2 != null && data2.DATA != null){
						$("#buyangYn").val(data2.DATA.buyangYn);
					}
					
					// 년간지원받은금액 조회
					var data3 = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetTotalPayMon", $("#searchForm").serialize(),false);
					if ( data3 != null && data3.DATA != null){
						$("#totalPayMon").val( ((data3.DATA.totalPayMon == 0) ? 0 : makeComma(data3.DATA.totalPayMon)) );
					}
					medStd = chkMedStd();
				} else {
					doAction("ReLoad");
					getMedSYm();
				}

				if( adminRecevYn == "Y" ){
					$("#applMon").val(makeComma(data.DATA.applMon));
					$("#payMon").val(makeComma(data.DATA.payMon));
					$("#payYm").val(formatDate(data.DATA.payYm, "-"));
					$("#payNote").val(data.DATA.payNote);
				}
			}
			break;
			
		case "ReLoad":
			
			if(!$("#famNm").val()){$(".stdMonView").hide(); break;};
			// 생년월일/성별 , 관계 조회
			var famNmIsDisabled = $("#famNm").is(":disabled");
			$('#famNm').attr("disabled",false);
			var data = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetFamCdList", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){
				$("#famYmd").val(formatDate(data.DATA.famYmd, "-")+" / "+data.DATA.sexType);
				$("#famCdNm").val(data.DATA.famCdNm);
				$("#famCd").val(data.DATA.famCd);
				$("#famRealNm").val(data.DATA.famNm);
				$("#famYmdReal").val(data.DATA.famYmd);
			}
			
			// 전년도 연말정산 부양가족여부
			var data2 = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetDpndntYn", $("#searchForm").serialize(),false);
			if ( data2 != null && data2.DATA != null){
				$("#buyangYn").val(data2.DATA.buyangYn);
			}
			
			// 년간지원받은금액 조회
			var data3 = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetTotalPayMon", $("#searchForm").serialize(),false);
			if ( data3 != null && data3.DATA != null){
				$("#totalPayMon").val( ((data3.DATA.totalPayMon == 0) ? 0 : makeComma(data3.DATA.totalPayMon)) );
			}
			medStd = chkMedStd();
			$('#famNm').attr("disabled",famNmIsDisabled);

			break;
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
				if ($(this).attr('id') == "medCode") {
					$("#btnPopup").focus();
				} else {
					$(this).focus();
				}
				ch =  false;
				return false;
			}
			return ch;
		});
		//필수값 문제 발생시 Stop
		if (!ch) {return ch;}
		
		//의료비 기준 정보 가져오기
		medStd = chkMedStd();
		if( medStd != null && medStd.yearendYn == 'Y'){
			if ($("#buyangYn").val() == 'N') {
				alert("<msg:txt mid='medAppDetErrMsg1' mdef='전년도 연말정산 부양가족이어야 신청 가능합니다.'/>")
				return false;
			}
		}
		
		var famNmIsDisabled = $("#famNm").is(":disabled");
		$('#famNm').attr("disabled",false);
		
		//지원시작년월 및 1년지났는지 조회
		var data = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetPayYm", $("#searchForm").serialize(),false);
		$('#famNm').attr("disabled",famNmIsDisabled);
		if( data != null && data.DATA != null && data.DATA.yearYn == 'true'){
		}else{
			alert("<msg:txt mid='medAppDetErrMsg2' mdef='동일 병명으로 1년이상 신청하실 수 없습니다.'/>")
			return false;
		}
		
		//재직자 상태 체크(재직 AA, 휴직자 CA만 가능) , 근속년수 체크
		data = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetUserStsCd", $("#searchForm").serialize(),false);
		if( data != null && data.DATA != null && (data.DATA.stsCd == 'AA' || data.DATA.stsCd == 'CA')){
		}else{
			alert("<msg:txt mid='medAppDetErrMsg3' mdef='재직자 또는 휴직자만 신청 가능합니다.'/>")
			return false;
		}
		if( data != null && data.DATA != null && (medStd.workYear == null || data.DATA.workYear >= medStd.workYear)){
		}else{
			alert("근속년수 "+medStd.workYear+"년 이상 신청하실 수 있습니다.");
			return false;
		}
		
		//년간 의료비 초과 여부 조회
		data = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetFreelPayMon", $("#searchForm").serialize(),false);
		if( data != null && data.DATA != null ){
			
			var freePayMon = data.DATA.freePayMon;
			
			if(freePayMon > 0){
			} else {
				alert("<msg:txt mid='medAppDetErrMsg4' mdef='년간 의료비가 초과되어 신청하실 수 없습니다.'/>")
				return false;
			}
			
		}else{
			alert("<msg:txt mid='medAppDetErrMsg5' mdef='잠시 후 다시 신청 바랍니다.'/>");//예외 가능성있어 작성.
			return false;
		}
		

		return ch;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		
		$('#medCode').attr("disabled",false);
		$('#medCodeNm').attr("disabled",false);
		var returnValue = false;
		try {

			//관리자 또는 수신담당자 경우 지급정보 저장
			if( adminRecevYn == "Y" ){
				
				if( applStatusCd != "31") { //수신처리중이 아니면 저장 처리 하지 않음
					return true;
				}
				//년간 의료비 초과 여부 조회
				data = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetFreelPayMon", $("#searchForm").serialize(),false);
				/* if( !$("#applMon").val() ){
					alert("신청금액은 필수 값입니다.");
					$("#applMon").focus();
					return false;
				}
				if( !$("#payMon").val() ){
					alert("지급금액은 필수 값입니다.");
					$("#payMon").focus();
					return false;
				}
				if( !$("#payYm").val() ){
					alert("급여년월은 필수 값입니다.");
					$("#payYm").focus();
					return false;
				} */
				var applMon 	= Number( replaceAll( $("#applMon").val(), "," , "") );
				var payMon 		= Number( replaceAll( $("#payMon").val(), "," , "") );
				var stdMon		= Number( replaceAll( medStd.stdMon+'', "," , "") ); 
				var empYearMon 	= Number( replaceAll( medStd.empYearMon+'', "," , "") ); 
				var totalPayMon = Number( replaceAll( $("#totalPayMon").val(), "," , "") ); 
				
				//결재자 자유도를 위해 빈값 허용과 더불어 체크 안함 && status 반려는 체크안함
				if (applMon+payMon != 0 && status != 0) {
					
					if (applMon <= stdMon) {
						alert("<msg:txt mid='medAppDetErrMsg6' mdef='신청금액이 기준금액보다 적습니다.'/>")
						$("#applMon").focus();
						return false;
					}
					if (payMon > applMon) {
						alert("<msg:txt mid='medAppDetErrMsg7' mdef='지급금액이 신청금액보다 많습니다.'/>")
						$("#payMon").focus();
						return false;
					}
					if (payMon > applMon-stdMon) {
						alert("<msg:txt mid='medAppDetErrMsg8' mdef='지급금액이 지급 가능 금액(신청금액-기준금액)보다 많습니다.'/>")
						$("#payMon").focus();
						return false;
					}
					if (payMon+totalPayMon > empYearMon) {
						alert("지급금액과 현재까지 지원받은금액의 합계가\n년간한도금액 ( "+makeComma(empYearMon)+" 원 ) 보다 많습니다.");
						$("#payMon").focus();
						return false;
					}
				}

				var rtn = ajaxCall("${ctx}/MedApp.do?cmd=saveMedAppDetAdmin", $("#searchForm").serialize(), false);

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				} else {
					returnValue = true;
				}
				
			}else{
			
				if ( authPg == "R" )  {return true;}
				
		        // 항목 체크 리스트
		        if ( !checkList() ) {
		        	$('#medCode').attr("disabled",true);
					$('#medCodeNm').attr("disabled",true);
		        	return false;
	        	}
		        var famNmIsDisabled = $("#famNm").is(":disabled");
		        $('#famNm').attr("disabled",false);
		      	//저장
				var data = ajaxCall("${ctx}/MedApp.do?cmd=saveMedAppDet",$("#searchForm").serialize(),false);
				$('#medCode').attr("disabled",true);
				$('#medCodeNm').attr("disabled",true);
				$('#famNm').attr("disabled",famNmIsDisabled);
	
	            if(data.Result.Code < 1) {
	                alert(data.Result.Message);
					returnValue = false;
	            }else{
					returnValue = true;
	            }
				
			}    

		} catch (ex){
			$('#medCode').attr("disabled",true);
			$('#medCodeNm').attr("disabled",true);
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}
	
	//질병코드 검색 팝업 오픈
	function showMedCodeMgrPopup() {
		if(!isPopup()) {return;}
		if(!$("#famNm").val()){
			alert("<msg:txt mid='medAppDetErrMsg9' mdef='대상자부터 선택하여 주시기 바랍니다.'/>")
			$("#famNm").focus();
			return;
		};
		
	
		var url    = "${ctx}/MedApp.do?cmd=viewMedAppDetPopup";
        var args    = new Array();
        /*
        //리턴 함수를 활용하여 값 받기 및 받은 후 지원시작년월 구하기
        openPopup(url, args, "740","480", function (rv){
        	var rvMedCode 	= rv["medCode"];
        	var rvMedCodeNm = rv["medCodeNm"];
        	if (rvMedCode) {
				$("#medCode").val(rvMedCode);
				$("#medCodeNm").val(rvMedCodeNm);
				getMedSYm();
			}
			
		});*/
		  let layerModal = new window.top.document.LayerModal({
		        id : 'medAppDetLayer'
		        , url : '${ctx}/MedApp.do?cmd=viewMedAppDetLayer'
		        , parameters : args
		        , width : 740
		        , height : 600
		        , title : '질병분류코드 검색'
		        , trigger :[
		            {
		                name : 'medAppDetTrigger'
		                , callback : function(result){
		                	
		                    $("#medCode").val(result.medCode);
		                    $("#medCodeNm").val(result.medCodeNm);
		                    getMedSYm();
		                }
		            }
		        ]
		    });
		    layerModal.show();
	}
	
	//지원시작년월 및 1년지났는지 조회
	function getMedSYm() {
		
		if( !$("#famNm" ).val()){ return false; };
		if( !$("#medCode" ).val()){ return false; };
		var famNmIsDisabled = $("#famNm").is(":disabled");
		$('#famNm').attr("disabled",false);
		$('#medCode').attr("disabled",false);
		var data = ajaxCall( "${ctx}/MedApp.do?cmd=getMedAppDetPayYm", $("#searchForm").serialize(),false);
		$('#medCode').attr("disabled",true);
		$('#famNm').attr("disabled",famNmIsDisabled);
		if ( data != null && data.DATA != null && data.DATA.medSYm != null){
			$("#medSYm").val(formatDate(data.DATA.medSYm, "-"));
		}
		
	}
	
	//의료비 기준 단건 조회
	function chkMedStd() {
		//의료비 기준 단건 조회
		data = ajaxCall( "${ctx}/MedStd.do?cmd=getMedStd", $("#searchForm").serialize(),false);
		if( data != null && data.DATA != null ){
			$("#stdMonView").text(makeComma(data.DATA.stdMon));
			$(".stdMonView").show();
			stdMonView
			return data.DATA;
		}else{
			$(".stdMonView").hide();
			return null;
		}
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

.payInfo { display:none; }
.payInfo th {background-color:#f4f4f4 !important; }
</style>

</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchYmd"			name="searchYmd"	 	value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	
	<input type="hidden" id="famCd"			name="famCd"	     value=""/>
	<input type="hidden" id="famYmdReal"	name="famYmdReal"	 value=""/>
	
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
			<th><tit:txt mid='103863' mdef='대상자'/></th>
			<td>
				<select id="famNm" name="famNm" class="${selectCss} ${required} " ${disabled}></select>
				<input type="text" id="famRealNm"		name="famRealNm"	 class="text transparent w120" readonly/>
			</td>
			<th><tit:txt mid='birYmdSex' mdef='생년월일/성별'/></th>
			<td>
				<input type="text" id="famYmd" name="famYmd" class="text transparent w120" readonly/>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='104316' mdef='관계'/></th>
			<td>
				<input type="text" id="famCdNm" name="famCdNm" class="text transparent w80" readonly/>
			</td>
			<th><tit:txt mid='buyangYn' mdef='전년도 연말정산</br>부양가족여부'/></th>
			<td>
				<input type="text" id="buyangYn" name="buyangYn" class="text transparent w80" readonly/>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='medName' mdef='병명'/></th>
			<td colspan="3">
				<input type="text" id="medCode" name="medCode" class="text transparent w110 ${required}" disabled="disabled"/>
				<input type="text" id="medCodeNm" name="medCodeNm" class="text transparent w350" disabled="disabled"/>
				<a href="javascript:showMedCodeMgrPopup()" id="btnPopup" class="btn dark">검색</a>
			</td> 
		</tr>
		<tr>
			<th><tit:txt mid='medSYm' mdef='지원시작년월'/></th>
			<td> 
				<input type="text" id="medSYm" name="medSYm" class="text transparent w100" readonly/>
			</td>
			<th><tit:txt mid='totalPayMon' mdef='년간지원받은금액(근로자1인기준)'/></th>
			<td> 
				<input type="text" id="totalPayMon" name=totalPayMon class="text transparent w150 right" readonly/> <span> 원</span>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='basePayMon' mdef='기준금액</br>(초과금액지원)'/></th>
			<td colspan="3">
				<span class="stdMonView"><tit:txt mid='stdMonTxt1' mdef='신청금액이'/> </span><span id="stdMonView" class="stdMonView"></span><span class="stdMonView"><tit:txt mid='stdMonTxt2' mdef='원 이상만 지급가능 합니다.'/></span>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='103783' mdef='비고' /></th>
			<td colspan="3"><textarea id="note" name="note" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
	</table>
			
	<div class="sheet_title payInfo">
		<ul>
			<li class="txt"><tit:txt mid='payInfo' mdef='지급정보'/></li>
		</ul>
	</div>
	<table class="table payInfo">
		<colgroup>
			<col width="100px" />
			<col width="20%" />
			<col width="100px" />
			<col width="20%" />
			<col width="100px" />
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='applMonReceipt' mdef='신청금액</br>(영수증)'/></th>
			<td><input type="text" id="applMon" name="applMon" class="text transparent w120" readonly/></td>
			<th><tit:txt mid='payMon' mdef='지급금액'/></th>
			<td><input type="text" id="payMon" name="payMon" class="text transparent w120" readonly/></td>
			<th><tit:txt mid='113327' mdef='급여년월'/></th>
			<td><input type="text" id="payYm" name="payYm" class="date2 transparent w90" readonly maxlength="10"/></td>
		</tr>
		<tr>
			<th><tit:txt mid='payNote' mdef='지급메모'/></th>
			<td colspan="5"><textarea id="payNote" name="payNote" rows="3" class="${textCss} w100p transparent" readonly maxlength="1000"></textarea></td>
		</tr>
	</table>
		
	</form>
</div>
		
</body>
</html>