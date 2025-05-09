<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>사내강사료신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>

<script type="text/javascript">

	var searchApplSeq    = "${searchApplSeq}";
	var adminYn          = "${adminYn}";
	var authPg           = "${authPg}";
	var searchApplSabun  = "${searchApplSabun}";
	var searchApplInSabun= "${searchApplInSabun}";
	var searchApplYmd    = "${searchApplYmd}";
	var eduSeq	 		 = "${etc01}";  //교육신청 교육과정순번
	var eduEventSeq	 	 = "${etc02}";  //교육신청 교육과정회차순번
	var applStatusCd	 = "";
	var applYn	         = "";
	var pGubun           = "";
	var pGubunSabun      = "";
	var gPRow 			 = "";
	var adminRecevYn     = "N"; //수신자 여부
	var closeYn;				//마감여부

	$(function() {

		parent.iframeOnLoad(220);
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#eduSeq").val(eduSeq);
		$("#eduEventSeq").val(eduEventSeq);
		applStatusCd = parent.$("#applStatusCd").val();
		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부
		//----------------------------------------------------------------
		
		var param = "";
		
		// 신청, 임시저장
		if(authPg == "A") {
		} else if (authPg == "R") {
			
			$(".isView").hide();
			//관리자거나 수신결재자이면
			if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){
				
				if( applStatusCd == "31" ){ //수신처리중일 때만 처리관련정보 수정가능
					$("#payMon").removeClass("transparent").removeAttr("readonly");
					$("#payNote").removeClass("transparent").removeAttr("readonly");
					$("#payYm").datepicker2({ymonly:true});
				}
				adminRecevYn = "Y";
				$(".payInfo").show();
				
			}
			
		}
		
		$("#lectureFee").mask('000,000,000,000,000', { reverse : true });
		$("#payMon").mask('000,000,000,000,000', { reverse : true });
		$("#note").maxbyte(2000);
		$("#payNote").maxbyte(4000);

		doAction1("Search");

	});

	

	// Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //신청내용 조회
			
				if (eduSeq) {
					
					//강의과목 강의료 조회
					var data = ajaxCall( "${ctx}/LectureFeeApp.do?cmd=getLectureFeeAppDetInfo", $("#searchForm").serialize(),false);
					
					if ( data != null && data.DATA != null ){ 
						
						$("#subjectLecture").html(data.DATA.subjectLecture);
						$("#lectureFee").val(data.DATA.lectureFee).focusout();
						
					}
					
				}
			
				//교육과정정보 조회
				var data = ajaxCall( "${ctx}/LectureFeeApp.do?cmd=getLectureFeeAppDetMap", $("#searchForm").serialize(),false);
				
				if ( data != null && data.DATA != null ){ 
					
					$("#eduCourseNm").html(data.DATA.eduCourseNm);
					$("#eduBranchNm").html(data.DATA.eduBranchNm);
					$("#eduMBranchNm").html(data.DATA.eduMBranchNm);
					$("#eduOrgNm").html(data.DATA.eduOrgNm);
					$("#eduMemo").html(data.DATA.eduMemo);
					$("#eduYmd").html(data.DATA.eduYmd);
					//신청서가 있을 경우만
					if (data.DATA.appedApplSeq) {
						$("#lectureFee").val(data.DATA.lectureFee).focusout();
						$("#note").val(data.DATA.note);
						$("#payMon").val(makeComma(data.DATA.payMon));
						$("#payYm").val(formatDate(data.DATA.payYm, "-"));
						$("#payNote").val(data.DATA.payNote);
					}
					
					closeYn = data.DATA.closeYn;
					
					$("#eduSeq").val(data.DATA.eduSeq);
					$("#eduEventSeq").val(data.DATA.eduEventSeq);
					
					//강의과목 강의료 조회(신청,승인 외 메뉴에서 들어왔을때 대비)
					var data = ajaxCall( "${ctx}/LectureFeeApp.do?cmd=getLectureFeeAppDetInfo", $("#searchForm").serialize(),false);
					
					if ( data != null && data.DATA != null ){ 
						
						$("#subjectLecture").html(data.DATA.subjectLecture);
						
					}
					
				}
				
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
				$(this).focus();
				ch =  false;
				return false;
			}

			return ch;
		});
		
		//필수값 문제 발생시 Stop
		if (!ch) {return ch;}
		
		var data = ajaxCall( "${ctx}/LectureFeeApp.do?cmd=getLectureFeeAppDetDupChk", $("#searchForm").serialize(),false);
		if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
			alert("<msg:txt mid='dupAppErrMsg' mdef='중복신청 건이 있어 신청 할 수 없습니다.'/>")
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
			//관리자 또는 수신담당자 경우 지급정보 저장
			if( adminRecevYn == "Y" ){
				
				if( applStatusCd != "31") { //수신처리중이 아니면 저장 처리 하지 않음
					return true;
				}
				
				if(closeYn == "Y") {
					alert("<msg:txt mid='110404' mdef='해당 급여작업이 마감되었습니다.'/>");
					return true;
				}
				
				//저장
				var data = ajaxCall("${ctx}/LectureFeeApp.do?cmd=saveLectureFeeAppDetAdmin",$("#searchForm").serialize(),false);
				
	            if(data.Result.Code < 1) {
	                alert(data.Result.Message);
					returnValue = false;
	            }else{
					returnValue = true;
	            }
	            
			}else{

				if ( authPg == "R" )  {
					return true;
				}
				
		        // 항목 체크 리스트
		        if ( !checkList() ) {
		            return false;
		        }
		        
		      	//저장
				var data = ajaxCall("${ctx}/LectureFeeApp.do?cmd=saveLectureFeeAppDet",$("#searchForm").serialize(),false);
				
	            if(data.Result.Code < 1) {
	                alert(data.Result.Message);
					returnValue = false;
	            }else{
					returnValue = true;
	            }
	            
			}

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}
	
</script>
<style type="text/css">
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
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	
	<input type="hidden" id="eduSeq"			name="eduSeq"	     	 value=""/>
	<input type="hidden" id="eduEventSeq"		name="eduEventSeq"	     value=""/>
	
	
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
			<li class="btn">&nbsp;</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="35%" />
			<col width="120px" />
			<col width="" />
		</colgroup>
	
		<tr>
			<th><tit:txt mid='113788' mdef='교육과정명'/></th>
			<td colspan="3">
				<span id="eduCourseNm" name="eduCourseNm" />
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='104566' mdef='교육구분'/></th>
			<td>
				<span id="eduBranchNm" name="eduBranchNm" />
			</td> 
			<th><tit:txt mid='eduMBranchPopV1' mdef='교육분류'/></th>
			<td>
				<span id="eduMBranchNm" name="eduMBranchNm" />
			</td>
		</tr>	 
		<tr>
			<th><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></th>
			<td colspan="3">
				<span id="eduOrgNm" name="eduOrgNm" />
			</td>	
		</tr>
		<tr>
			<th><tit:txt mid='104071' mdef='교육내용'/></th>
			<td colspan="3">
				<span id="eduMemo" name="eduMemo" />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='eduEventMgrPopV2' mdef='교육기간'/></th>
			<td colspan="3"> 
				<span id="eduYmd" name="eduYmd" />
			</td>	
		</tr>
		<tr>
			<th><tit:txt mid='lecture' mdef='강의과목'/></th>
			<td colspan="3"> 
				<span id="subjectLecture" name="subjectLecture" />
			</td>	
		</tr>
		<tr>
			<th><tit:txt mid='lectureFee' mdef='강의료'/></th>
			<td colspan="3">
				<input type="text" id="lectureFee" name="lectureFee" class="${textCss} w150" ${readonly} /> <span>&nbsp;원</span>
			</td>
			
		</tr>
		<tr>
			<th><tit:txt mid='103783' mdef='비고' /></th>
			<td colspan="3"><textarea id="note" name="note" rows="2" class="${textCss} w100p" ${readonly} ></textarea></td>
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
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='payMon' mdef='지급금액'/></th>
			<td><input type="text" id="payMon" name="payMon" class="text transparent w120" readonly/></td>
			<th><tit:txt mid='113327' mdef='급여년월'/></th>
			<td><input type="text" id="payYm" name="payYm" class="date2 transparent w90" readonly/></td>
		</tr>
		<tr>
			<th><tit:txt mid='payNote' mdef='지급메모'/></th>
			<td colspan="3"><textarea id="payNote" name="payNote" rows="3" class="${textCss} w100p transparent" readonly ></textarea></td>
		</tr>
	</table>
</div>
</body>
</html>

