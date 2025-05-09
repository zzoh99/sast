<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>교육취소신청 세부내역</title>
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
	var searchApApplSeq	 = "${etc01}";  //교육신청 신청서순번
	var applStatusCd	 = "";
	var pGubun         = "";
	var gPRow = "";
	var codeLists;

	$(function() {

		parent.iframeOnLoad(200);
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#searchApApplSeq").val(searchApApplSeq);
		applStatusCd = parent.$("#applStatusCd").val();

		if(authPg == "A") {
						
		} else{
		}
		

		//미참석사유 콤보 
		var gubunCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90100"), " ");
		$("#gubunCd").html(gubunCdList[2]);
		
		
		doAction1("Search");

	});
	

	// Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //신청내용 조회
				
				// 입력 폼 값 셋팅
				var data = ajaxCall( "${ctx}/EduCancelApp.do?cmd=getEduCancelAppDetMap", $("#searchForm").serialize(),false);
	
				if ( data != null && data.DATA != null ){ 
					$("#inOutType").val(data.DATA.inOutType);
					
					$("#eduSeq").val(data.DATA.eduSeq);
					$("#eduEventSeq").val(data.DATA.eduEventSeq);
					$("#searchApApplSeq").val(data.DATA.apApplSeq);
					
					$("#eduCourseNm").html(data.DATA.eduCourseNm);
					$("#eduBranchNm").html(data.DATA.eduBranchNm);
					$("#eduMBranchNm").html(data.DATA.eduMBranchNm);
					$("#inOutTypeNm").html(data.DATA.inOutTypeNm);
					$("#eduYmd").html(data.DATA.eduYmd);
					$("#eduOrgNm").html(data.DATA.eduOrgNm);
					$("#realExpenseMon").html(makeComma(data.DATA.realExpenseMon));
					$("#laborApplyYn").html(data.DATA.laborApplyYn);
					$("#eduPlace").html(data.DATA.eduPlace);
					$("#yearPlanYn").html(data.DATA.yearPlanYn);
					$("#jobNm").html(data.DATA.jobNm);
					$("#eduMemo").html(data.DATA.eduMemo);
					$("#gubunCd").val(data.DATA.gubunCd);		
					$("#appMemo").val(data.DATA.appMemo);		
					
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
			var data = ajaxCall("${ctx}/EduCancelApp.do?cmd=saveEduCancelAppDet",$("#searchForm").serialize(),false);
			
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
	<input type="hidden" id="searchApApplSeq"	name="searchApApplSeq"	 value=""/>
	
	
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
			<td>
				<span id="eduOrgNm" name="eduOrgNm" />
			</td>	
			<th><tit:txt mid='' mdef='사내/외구분'/></th>
			<td>
				<span id="inOutTypeNm" name="inOutTypeNm" />
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
			<td> 
				<span id="eduYmd" name="eduYmd" />
			</td>	
			<th><tit:txt mid='104078' mdef='교육장소'/></th>
			<td> 
				<span id="eduPlace" name="eduPlace" />
			</td>	
		</tr>
		<tr>
			<th><tit:txt mid='eduAppDetOutSideV3' mdef='교육비용'/></th>
			<td>
				<span id="realExpenseMon" name="realExpenseMon" />
			</td>	
			<th><tit:txt mid='empInsure' mdef='고용보험'/></th>
			<td>
				<span id="laborApplyYn" name="laborApplyYn" />
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='yearPlanYn' mdef='사업계획입안'/></th>
			<td> 
				<span id="yearPlanYn" name="yearPlanYn" />
			</td>	
			<th><tit:txt mid='103973' mdef='관련직무'/></th>
			<td>
				<span id="jobNm" name="jobNm" />
			</td>
			
		</tr>
		<tr>
			<th><tit:txt mid='104467' mdef='미참석사유'/></th>
			<td colspan="3"> 
				<select id="gubunCd" name="gubunCd" class="${selectCss} ${required} w80" ${disabled}></select>
			</td>	
			
		</tr>
		<tr>
			<th><tit:txt mid='112871' mdef='상세내용'/></th>
			<td colspan="3"><textarea id="appMemo" name="appMemo" rows="2" class="${textCss} ${required} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
	</table>
</div>

</body>
</html>

