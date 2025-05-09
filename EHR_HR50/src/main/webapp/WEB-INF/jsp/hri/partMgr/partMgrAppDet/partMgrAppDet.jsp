<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>서무변경신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var searchApplSabun = "${searchApplSabun}"; //신청대상자사번
	var searchSabun = "${searchSabun}"; // 신청자사번
	var searchApplYmd = "${searchApplYmd}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var applStatusCd = parent.$("#applStatusCd").val(); //신청서상태
	var reqUseType ="";
	
	var searchOrgCd = "${searchOrgCd}";
	
	var chooseGntAllowYn = null;

	$(function() {
		/* 신청상세 iframe 높이 */
		parent.iframeOnLoad("230px");

		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);  // 신청대상자사번 
		
		// 세션 사번
		$("#searchSabun").val(searchSabun);
		$("#applYmd").val(searchApplYmd);
		$("#searchOrgCd").val(searchOrgCd); // 소속코드 
				
		// 사번으로 OrgCd 조회
		var param = "searchSabun="+searchApplSabun;
		var data = ajaxCall("${ctx}/GetDataList.do?cmd=getPartMgrAppOrgCd",param,false);

		$("#searchOrgCd").val(data.DATA[0].orgCd);
		
		// 2020.02.05 임시저장이 아닌경우 비활성화로 변경
		if(applStatusCd != "11" && applStatusCd != null && applStatusCd != "") {
			$("#sYmd").attr("readonly", true).addClass("transparent");
		} else {
			
			// 최초 loading 시 보여줄날짜 및 선택 범위 셋팅
			$("#baseDate").mask("1111-11-11");
			$("#baseDate").val( "${curSysYyyyMMddHyphen}"	);
			$("#sYmd").datepicker2({enddate : "baseDate"});
			
			//$("#sYmd").datepicker2();
		}
		
		// 변경구분 getPartMgrAppAtCdList		
		var applTypeCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getPartMgrAppDetAtCdList", false).codeList, "");
		$("#applTypeCd").html(applTypeCdList[2]);
  		
		$(window).smartresize(sheetResize);sheetInit(); 		

		// data 조회 
		if(searchApplSeq != null && searchApplSeq != "") {
			doAction("Search");
		}
		
		// 처리완료인 경우 비활성화
		// 2020.02.05 임시저장이 아닌경우 비활성화로 변경
		if(applStatusCd != "11" && applStatusCd != null && applStatusCd != "") {	
			$("#applTypeCd").attr("disabled", true).removeClass("transparent");
			
			//$("#curEmp").attr("disabled", true).removeClass("transparent");
			$("#curEmp").hide();
			$("#span_curEmp").show();

			$(".newEmp").hide();

			$("#bigo").hide();
			$("#span_bigo").show();
			$("#sYmd").hide();
			$("#span_sYmd").show();
		} else {
			$("#span_bigo").hide();
			$("#span_sYmd").hide();
			$("#span_curEmp").hide();
		}
		
		// 변경구분 레이아웃 설정		
		//onChangeApplyTypeCd($("#applTypeCd").val());
		
		// 기존 대상 서무  
		//onChangeCurEmp($("#curEmp").val());
		
	});

	function setDataForm(data) {

		if(data != null && data.DATA != null) {			
						
			var applTypeCd = data.DATA.applTypeCd;
						
			// 변경구분
			$("#applTypeCd").val(data.DATA.applTypeCd);
			
			// 적용시작일
			$("#sYmd").val(data.DATA.sYmd.substring(0,4)+"-"+data.DATA.sYmd.substring(4,6)+"-"+data.DATA.sYmd.substring(6,8));
			$("#span_sYmd").text(data.DATA.sYmd.substring(0,4)+"-"+data.DATA.sYmd.substring(4,6)+"-"+data.DATA.sYmd.substring(6,8));
			
			// 신규서무대상자
			$("#newName").val(data.DATA.newName);
			$("#newSabun").val(data.DATA.newSabun);
			
			$("#span_newSabun").text(data.DATA.newSabun);
			$("#span_newOrgNm").text(data.DATA.newOrgNm);
			$("#span_newJikweeNm").text(data.DATA.newJikweeNm);
			
			//비고
			$("#bigo").text(data.DATA.bigo);
			$("#span_bigo").text(data.DATA.bigo);
			
			onChangeApplyTypeCd(applTypeCd);
						 
			// 기존대상서무
			if(data.DATA.curSabun !=null || data.DATA.curSabun !="") {				
				$("#curEmp").bind("option:selected").val(data.DATA.curSabun).change();
				
				$("#span_curEmp").text(data.DATA.curName);
				$('#span_curSabun').text(data.DATA.curSabun);
				$('#span_curJikweeNm').text(data.DATA.curJikweeNm);
				$('#span_curOrgNm').text(data.DATA.curOrgNm);	
			}
			
		} else {
			onChangeApplyTypeCd("1");
		}
		
	}


	//Sheet1 Action
	function doAction(sAction) {
		switch (sAction) {
			case "Search":				
			var data = ajaxCall( "${ctx}/GetDataMap.do?cmd=getPartMgrAppDet", $("#dataForm").serialize(), false);			
			setDataForm(data);			
			break;
		}
	}	

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		
 		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				var txt = $(this).parent().prev().text();
				if( txt ==  "" ){
					txt = $(this).parent().parent().prev().text();
				}
				alert(txt+"은 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
 		
		if($("#sYmd").val() < $("#baseDate").val() ) {
			alert("오늘 이후 일자를 선택해 주세요.");
			return false;
		}
 		
		return ch;
	}
	

	/*----------------------------------------------------------------------------------
		신청서 공통 팝업에서 신청 또는 임시저장 클릭 시 호출 됨.
	----------------------------------------------------------------------------------*/
	function setValue(){
		var saveStr;
		var rtn;
		try{
			//쓰기권한에 임시서장일때만 저장
			if(authPg == "A" && ( applStatusCd == "" || applStatusCd == "11" )) {

				// 입력체크
				if(!checkList()) return ;

				var rtn = ajaxCall("${ctx}/SaveFormData.do?cmd=savePartMgrApp",$("#dataForm").serialize(),false);
					
				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					return  false;
				}
			}
		} catch (ex){
			alert("저장중 스크립트 오류발생." + ex);
			return false;
		}
		return true;
	}

	
// 초기화
function clearCode() {

	 //데이터 삭제
	$('#newName').val("");
	$('#newSabun').val("");
	
	$('#span_newSabun').text("");
	$('#span_newJikweeNm').text("");
	$('#span_newOrgNm').text("");
  
}

// 사원 팝업
function showEmpPopup() {	
    
    if(!isPopup()) {return;}
    gPRow = "";
    pGubun = "empPopup";    
    
    var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}&searchOrgCd=" + $("#searchOrgCd").val() + "&searchQueryId="+ "getPartMgrAppDetOrgEmpList", "", "740","520");    

}

// 
function onChangeApplyTypeCd(val) { 
	
	// val 1: 추가신청, 2:변경신청, 3:삭제신청
	if(val == "1") {
			$('#curEmpTr').hide();
			$('#newEmpTr').show();
			
			// 기존 대상 서무
			$("#curEmp").html("");
			$("#curEmp").removeClass("required");
			
			onChangeCurEmp();
			
			$("#newName").addClass("required");	
			
	} else if(val == "2") {
			$('#curEmpTr').show();
			$('#newEmpTr').show();
			
			setCurEmpCombe();
			$("#curEmp").addClass("required");
			
	} else if(val == "3") {
			$('#curEmpTr').show();
			$('#newEmpTr').hide();

			clearCode();
			
			// 기존 대상 서무
			setCurEmpCombe();
			$("#curEmp").addClass("required");			
			$("#newName").removeClass("required");
	}
}

function setCurEmpCombe() {
	
	// 기존 대상 서무			
	var param = "&searchOrgCd="+$("#searchOrgCd").val();
	var curEmpCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getPartMgrAppDetCurEmpList"+param, false).codeList, "선택");		
	$("#curEmp").html(curEmpCdList[2]);
	
	onChangeCurEmp($("#curEmp").val());
	
}

function onChangeCurEmp(val) {	
		
	if ( val != null && val != "" ) {
		var param = "sabun="+val;
		
		data = ajaxCall("${ctx}/GetDataMap.do?cmd=getPartMgrAppDetCurEmp",param,false);
		
		$('#span_curSabun').text(data.DATA.sabun);
		$('#span_curJikweeNm').text(data.DATA.jikweeNm);
		$('#span_curOrgNm').text(data.DATA.orgNm);

	} else { 
		$('#span_curSabun').text("");
		$('#span_curJikweeNm').text("");
		$('#span_curOrgNm').text("");
	}
	
}


function getReturnValue(returnValue) {
    var rv = $.parseJSON('{' + returnValue+ '}');
    
    if(pGubun == "empPopup"){
    	
    	// 소속코드 검증
    	if($("#searchOrgCd").val()  !=  rv["orgCd"] ){
    		alert("소속이 일치하지 않습니다.");
    		clearCode();
    		return false;
    	}
    	
    	//dataClear();
        $("#newSabun").val(rv["sabun"]);
        $("#newName").val(rv["name"]);
        
    	$('#span_newSabun').text(rv["sabun"]);
    	$('#span_newJikweeNm').text(rv["jikweeNm"]);
    	$('#span_newOrgNm').text(rv["orgNm"]);

    } 
}


	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id="dataForm" name="dataForm" >
	<input type="hidden" id="searchSabun"		name="searchSabun" 		value=""/>
	<input type="hidden" id="searchApplSabun" 	name="searchApplSabun" 	value=""/>
	<input type="hidden" id="searchApplSeq" 	name="searchApplSeq" 	value=""/>
	<input type="hidden" id="searchOrgCd" 	name="searchOrgCd" 	value=""/>
	<input type="hidden" id="subFile" 			name="subFile" 			value=""/>
	<input type="hidden" id="applYmd" name="applYmd" />
	<input type="hidden" id="baseDate" name="baseDate" />
		
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">서무변경신청 세부내역</li>
			<li class="btn">
			</li>
		</ul>
		</div>
	</div>

	<table class="table outer">
	<colgroup>
		<col width="25%" />
		<col width="25%" />
		<col width="25%" />
		<col width="25%" />		
		<!-- <col width="" /> -->
	</colgroup>
	<tr>
		<th>변경구분</th>
		<td>
			<select id="applTypeCd" name="applTypeCd" class="required transparent"  onChange="javaScript:onChangeApplyTypeCd(this.value);" > </select>
		</td>
		<th>적용시작일</th>
		<td>
			<input id="sYmd"" name ="sYmd" class="date2 required" type="text" value="<%=DateUtil.getCurrentDate()%>" />
			<span id="span_sYmd"></span>
		</td>
	</tr>
	<tr id="curEmpTr" >
		<th>기존 대상 서무</th>
		<td colspan ="3">
			<select id="curEmp" name="curEmp" class="required transparent" onChange="javaScript:onChangeCurEmp(this.value);" > </select>
			<span id="span_curEmp"></span>
		</td>
		<!--
		<th>사번 / 조직 / 직위</th>
		<td>
			<span id="span_curSabun"></span> / <span id="span_curOrgNm"></span> / <span id="span_curJikweeNm"></span>
		</td>
		-->
		
	</tr>
	<tr id="newEmpTr" >
		<th>신규 서무 대상자</th>
		<td colspan ="3">
			<input id="newName" name="newName" type="text" class="text w50p readonly required"  readonly/>
			<input id="newSabun" name="newSabun" type="hidden" class="text newEmp"/>
			<a href="javascript:showEmpPopup();" class="button6 newEmp"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			<a href="javascript:clearCode()" class="button7 newEmp"><img src="/common/${theme}/images/icon_undo.gif"/></a>
		</td>
		<!-- 
		<th>사번 / 조직 / 직위</th>
		<td>
			<span id="span_newSabun"></span> / <span id="span_newOrgNm"></span> / <span id="span_newJikweeNm"></span>
		</td>
		 -->
	</tr>	

	<tr>
		<th>비고</th>
		<td colspan="4">
			<textarea id="bigo" name="bigo" rows="3" cols="30" class="${textCss} w100p" ${readonly}></textarea>
			<span id="span_bigo"></span>
		</td>
	</tr>
	<!-- 
	<tr>
		<th>신청사유</th>
		<td colspan="4">
			<textarea id="gntReqReson" name="gntReqReson" rows="3" cols="30" class="${textCss} w100p" ${readonly}></textarea>
			<span id="span_gntReqReson"></span>
		</td>
	</tr>
	<tr>
		<th>증빙서류</th>
		<td colspan="4">
			<span id="span_subFile"></span>
		</td>
	</tr>
	 -->
	</table>
	</form>	
</div>

</html>

