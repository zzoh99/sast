<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>동호회가입/탈퇴신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<c:set var="curSysYyyyMMddHHmmssHyphen"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm:ss" /></c:set>
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
	
	var curSysYyyyMMddHyphen = "${curSysYyyyMMddHyphen}";
	var curSysYyyyMMddHHmmssHyphen = "${curSysYyyyMMddHHmmssHyphen}";
	
	

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
			$("#todaydate").datepicker2().val(curSysYyyyMMddHyphen);
			
			$("#sdateA").datepicker2( { enddate:"todaydate" } ).val(curSysYyyyMMddHyphen);
			//$("#edateA").datepicker2( { enddate:"sdateA" } );
			
			//$("#sdateD").datepicker2( { startdate:"edateD" } );
			$("#edateD").datepicker2( { enddate:"sdateD" } );
		} else if (authPg == "R") {
			if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //관리자거나 수신결재자이면
				if( applStatusCd == "31" ){ //수신처리중일 때만 처리관련정보 수정가능
				}
				adminRecevYn = "Y";
			}
		}
		
		//신청구분 선택시
		$('#searchForm').on('click', 'input:radio[name="rdoJoinType"]',function() {
			if (authPg == "R") {return;}
			var rdoJoinType = $('input:radio[name="rdoJoinType"]:checked').val();
			$("#joinType").val(rdoJoinType);
			
			param = "&joinType="+$("#joinType").val();
			param += "&sabun="+$("#searchApplSabun").val();
			if (rdoJoinType == 'A') {
				$("#sdateA").val(curSysYyyyMMddHyphen);
				$('.joinTypeA').show();
				$('.joinTypeB').hide();
			}else if (rdoJoinType == 'D') {
				$("#searchForm #fileSeq").val("");
				$("#agreeDate").val("");
				$("#fileUrl").attr("src","");
				$('#fileUrl').hide();
				$("#edateD").val("");
				$('.joinTypeB').show();
				$('.joinTypeA').hide();
			}
			
			var clubList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getClubAppDetClubName"+param, false).codeList, "선택");
			$("#clubSeq").html(clubList[2]);
			$("#clubSeq").change();
		});

		//동호회명 선택시
		$('#searchForm').on('change', 'select[name="clubSeq"]',function() {

			$("#sabunAView").val("");
			$("#sabunCView").val("");
			$("#clubFee").val("");
			$("#sdateD").val("");

			if (!$("#clubSeq").val()) {return;}

			//동호회 콤보
			var map = ajaxCall( "${ctx}/ClubApp.do?cmd=getClubAppDetClubMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){
				if (map.DATA.orgANm) {
					$("#sabunAView").val(map.DATA.orgANm+" / "+map.DATA.sabunAName);
				}
				if (map.DATA.orgCNm) {
					$("#sabunCView").val(map.DATA.orgCNm+" / "+map.DATA.sabunCName);
				}
				$("#clubFee").val(map.DATA.clubFee).focusout();
				$("#sdateD").val(map.DATA.sdateD);
			}
		});
		
		$('#clubFee').mask('000,000,000,000,000', { reverse : true });
		
		$('.joinTypeA, .joinTypeB, #clubNm, #fileUrl, #rdoJoinTypeNm').hide();
		
		doAction("Search"); 
	});
		
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search" :
			// 입력 폼 값 셋팅
			var map = ajaxCall( "${ctx}/ClubApp.do?cmd=getClubAppDetMap",$("#searchForm").serialize(),false);

			if ( map != null && map.DATA != null ){
				var data = map.DATA;
				
				var isDisabled = $('input:radio[name="rdoJoinType"]').is(":disabled");
				$('input:radio[name="rdoJoinType"]').attr("disabled",false);
				$("#joinType").val(data.joinType);
				if (data.joinType == "A") {
					$('#rdoJoinTypeA').attr("checked", "checked");
					$('#rdoJoinTypeA').click();
				} else {
					$('#rdoJoinTypeD').attr("checked", "checked");
					$('#rdoJoinTypeD').click();
					$("#sdateD").val($("#sdate").val());
				}
				
				if(authPg == "R") {
					$('.rdoJoinType').hide();
					$('#rdoJoinTypeNm').val((data.joinType == "A")?"가입":"탈퇴").show();
				}
				
				$("#clubSeq").val(data.clubSeq);
				$("#clubSeq").change();
				$("#sdate").val(data.sdate);
				$("#edate").val(data.edate);
				//정식 신청시 가입일자, 제공동의 재입력 받기 위함.
				//if(!(applStatusCd == '11')){
					$("#sdateA").val(formatDate(data.sdate, "-"));
					$("#sdateD").val(formatDate(data.sdate, "-"));
					$("#edateD").val(formatDate(data.edate, "-"));
					$("#agreeYn").val(data.agreeYn);
					$("#agreeDate").val(data.agreeDate);
					$("#searchForm #fileSeq").val(data.fileSeq);
					if (data.fileSeq) {
						$("#fileUrl").attr("src","/SignPhotoOut.do?enterCd="+data.enterCd+"&fileSeq="+data.fileSeq);
						$('#fileUrl').show();
					}
					if (data.orgANm) {
						$("#sabunAView").val(data.orgANm+" / "+data.sabunAName);
					}
					if (data.orgCNm) {
						$("#sabunCView").val(data.orgCNm+" / "+data.sabunCName);
					}
					$("#clubFee").val(data.clubFee).focusout();
					$("#clubSeq").hide();
					$("#agreePopup").hide();
					$("#clubNm").val(data.clubNm).show();
					if (data.joinType == "A") {
						$('.joinTypeA').show();
						$('.joinTypeB').hide();
					}else {
						$('.joinTypeB').show();
						$('.joinTypeA').hide();
					}
				//}
				$("#note").val(data.note);
				
				$('input:radio[name="rdoJoinType"]').attr("disabled",isDisabled);
				
			}else{
				
			}
		}
	}

	// 입력시 조건 체크
	function checkList() {
		var ch = true;
		
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
		
		var rdoJoinType = $('input:radio[name="rdoJoinType"]:checked').val();
		if (!rdoJoinType) { alert("신청구분은 필수값입니다."); }
		
		if (rdoJoinType == 'A') {
			
			$("#sdate").val($("#sdateA").val());
			$("#edate").val("");
			if (!$("#sdate").val()) { alert("가입일자는 필수값입니다."); $("#sdateA").focus(); return false; }
			if (!$("#searchForm #fileSeq").val()) { alert("급여제공동의는 필수입니다."); return false; }
			
		} else if (rdoJoinType == 'D') {
			
			$("#sdate").val($("#sdateA").val());
			$("#edate").val($("#edateD").val());
			if (!$("#edate").val()) { alert("탈퇴일자는 필수값입니다."); $("#edateD").focus(); return false; }
			
		} else {
			return false; // 잘못된 진입 방지			
		}
		
		var data = ajaxCall( "${ctx}/ClubApp.do?cmd=getClubAppDetDupChk", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			alert("동일한 신청 건이 있어 신청 할 수 없습니다.");
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
		        	
					var rtn = ajaxCall("${ctx}/ClubApp.do?cmd=saveClubAppDet", $("#searchForm").serialize(), false);
	
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
	
	//-----------------------------------------------------------------------------------
	//	 팝업
	//-----------------------------------------------------------------------------------
	function showAgreePopup() {

		if(!isPopup()) {return;}

		var args = new Array(5);
		//var url     = "/Popup.do?cmd=signComPopup";

		//var result = openPopup(url, args, 600, 360);
		
		let layerModal = new window.top.document.LayerModal({
			id : 'signComLayer'
			, url : '/Popup.do?cmd=viewSignComLayer'
			, parameters : {}
			, width : 450
			, height :400
			, title : '서명공통팝업'
			, trigger :[
				{
					name : 'signComTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();

	}
	
	//신청 후 리턴
	function getReturnValue(rv) {
		//var rv = $.parseJSON('{'+ returnValue+'}');
		if(rv && rv["fileSeq"]){
			$("#searchForm #fileSeq").val(rv["fileSeq"]);
			if (!$("#agreeDate").val()) {
				$("#agreeDate").val(curSysYyyyMMddHHmmssHyphen);
			}
			$("#agreeYn").val("Y");
			$("#fileUrl").attr("src","/SignPhotoOut.do?enterCd=${ssnEnterCd}&fileSeq="+rv["fileSeq"]);
			$('#fileUrl').show();
		}
	}

</script>
<style type="text/css">
/*---- checkbox ----*/
input[type="radio"]  { 
	display:inline-block; width:18px; height:18px; cursor:pointer; 
 	-moz-appearance:radio; -webkit-appearance:radio; margin-top:2px;background:none;
    vertical-align:middle;
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
	
	<input type="hidden" id="joinType"		name="joinType"	     value=""/>
	<input type="hidden" id="fileSeq"		name="fileSeq"		 value=""/>
	<input type="hidden" id="agreeYn"		name="agreeYn"	 	 value=""/>
	<input type="hidden" id="sdate"			name="sdate"	 	 value=""/>
	<input type="hidden" id="edate"			name="edate"	 	 value=""/>

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
			<th>신청구분</th>
			<td colspan="3">
				<input type="text" id="rdoJoinTypeNm" name="rdoJoinTypeNm" class="${textCss} transparent w150" readonly/>
				<span><input type="radio" id="rdoJoinTypeA" name="rdoJoinType" value="A" class="rdoJoinType"><label for="rdoJoinTypeA" class="rdoJoinType"> 가입 </label></span>
                <span><input type="radio" id="rdoJoinTypeD" name="rdoJoinType" value="D" class="rdoJoinType"><label for="rdoJoinTypeD" class="rdoJoinType"> 탈퇴 </label></span>
			</td>
		</tr>
		<tr>
			<th>동호회명</th>
			<td>
				<select id="clubSeq" name="clubSeq" class="${selectCss} ${required} w100 " ${disabled}></select>
				<input type="text" id="clubNm" name="clubNm" class="${textCss} transparent w150" readonly/>
			</td>
			<th>회장</th>
			<td>
				<input type="text" id="sabunAView" name="sabunAView" class="${textCss} transparent w150" readonly/>
			</td>
		</tr>
		<tr>
			<th>동호회비</th>
			<td>
				<input type="text" id="clubFee" name="clubFee" class="${textCss} transparent w150" readonly/>
			</td>
			<th>총무</th>
			<td>
				<input type="text" id="sabunCView" name="sabunCView" class="${textCss} transparent w150" readonly/>
			</td>
		</tr>
		<tr>
			<th>가입일자</th>
			<td>
				<div class="hide" ><input type="hidden" id="todaydate" name="todaydate"/></div>
				<div class="joinTypeA" style="display: none;"><input type="text" id="sdateA" name="sdateA" class="${textCss} w80" ${readonly}/></div>
				<div class="joinTypeB" style="display: none;"><input type="text" id="sdateD" name="sdateD" class="${textCss} transparent w80" readonly/></div>
			</td>
			<th>탈퇴일자</th>
			<td>
				<div class="joinTypeA" style="display: none;"><input type="text" id="edateA" name="edateA" class="${textCss} transparent w80" readonly/></div>
				<div class="joinTypeB" style="display: none;"><input type="text" id="edateD" name="edateD" class="${textCss} w80" ${readonly}/></div>
			</td>
		</tr>
		<tr class="joinTypeA">
			<th>급여제공동의</th>
			<td colspan="3">
				<span><img id="fileUrl" class="w80 h30" src=""/></span>
				<input type="text" id="agreeDate" name="agreeDate" class="${textCss} transparent w150" readonly/>
				<a href="javascript:showAgreePopup();" id="agreePopup" class="button">동의</a>
			</td>
		</tr>
		<tr>
			<th>
				<tit:txt mid='103783' mdef='비고' />
			</th>
			<td colspan="3">
				<textarea id="note" name="note" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
</html>