<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='vacationUpdAppDet1' mdef='근태취소신청 세부내역'/></title>
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
	var searchBApplSeq	 = "${etc01}";
	var applStatusCd	 = "";
	var pGubun           = "";
	var gPRow            = "";

	$(function() {

		parent.iframeOnLoad(300);
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#searchBApplSeq").val(searchBApplSeq);
		
		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		//----------------------------------------------------------------
		
		if(authPg == "A") {
		} else{
			
		}	

		//근태코드 변경 시 
		$("#gntCd").bind("change", function() {
			changeGntCd($(this).val()) ;
		});

		
		//근태종류  콤보
		var gntGubunCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getVacationAppDetGntGubunList", false).codeList, "");
		$("#gntGubunCd").html(gntGubunCdList[2]);

		//경조구분 콤보
		var param = "&searchApplSabun=" + $("#searchApplSabun").val();
		var occFamCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getVacationAppDetOccCd" + param, false).codeList
		                 , "occHoliday,occCd,famCd"
				         , "선택하세요");
		$("#occFamCd").html(occFamCdList[2]);
		
		//근태코드
		var gntCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnGntCdList2", false).codeList
		          , "requestUseType,gntUse,baseCnt,gntGubunCd,baseCnt,maxCnt"
				  , "");
		$("#gntCd").html(gntCdList[2]);
		

		doAction("Search"); 

	});


	//근태코드 변경 시
	function changeGntCd(gntCd) {
		
		//현재 근태코드의 근태신청유형
		var reqUseType = $("#gntCd option:selected").attr("requestUseType");
		//근태신청유형에 따라 신청폼을 바꿔주는 화면컨트롤 로직
		if( reqUseType == "D" || reqUseType == "AM" || reqUseType == "PM" ) {
			$("#inMod1").show() ;	$("#inMod2").hide() ;
			if(reqUseType == "AM" || reqUseType == "PM") {
				$("#span_eYmd").hide(); //종료일자 표시 여부
			}else{
				$("#span_eYmd").show();
			}
		} else if( reqUseType == "H" ) {
			$("#inMod1").hide() ;	$("#inMod2").show() ;
		}

		//경조휴가(70)일 경우 
		if( $("#gntCd").val() == "70" ) {
			$("#span_occ").show();
			
		}else{
			$("#span_occ").hide();
		}
		
	}
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/VacationApp.do?cmd=getVacationUpdAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 

				$("#gntGubunCd").val( data.DATA.gntGubunCd );
	        	$("#gntCd").val(data.DATA.gntCd);
	        	$("#searchGntCd").val(data.DATA.gntCd);
	        	$("#gntCd").change();
	        	
	        	$("#sYmd").val(formatDate(data.DATA.sYmd,"-"));
	        	$("#eYmd").val(formatDate(data.DATA.eYmd,"-"));
	        	$("#applYmd").val(formatDate(data.DATA.sYmd,"-"));
	        	$("#closeDay").val(data.DATA.closeDay);
	        	$("#holDay").val(data.DATA.holDay);
				$("#reqSHm").val( data.DATA.reqSHm );
				$("#reqEHm").val( data.DATA.reqEHm );
				$("#requestHour").val(  data.DATA.requestHour );
	        	$("#gntReqReason").val(data.DATA.gntReqReason);  

				$("#reqSHm").mask("11:11") ;	
				$("#reqEHm").mask("11:11") ;

				//경조휴가
				$("#occFamCd").val( data.DATA.occFamCd );
				$("#occCd").val( data.DATA.occCd );
				$("#famCd").val( data.DATA.famCd );
				$("#occHoliday").val( data.DATA.occHoliday );
				$("#span_occHoliday").html( data.DATA.occHoliday+"일" );
			}

			break;
		}
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

			if($("#gntReqReason").val() == "") {
				alert("<msg:txt mid='alertVacationUpdAppDet2' mdef='취소사유를 입력하여 주십시오.'/>");
				$("#gntReqReason").focus();
				return false;
			}
	        

	      	//저장
			var data = ajaxCall("${ctx}/VacationApp.do?cmd=saveVacationUpdAppDet",$("#searchForm").serialize(),false);

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
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchSabun"       name="searchSabun"		 value=""/>
	<input type="hidden" id="searchBApplSeq"    name="searchBApplSeq"	 value=""/>
	<input type="hidden" id="searchGntCd"       name="searchGntCd"	     value=""/>
	
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
		</ul>
	</div>

	<table class="default outer" style="table-layout: fixed;">
	<colgroup>
		<col width="100px" />
		<col width="250px" />
		<col width="100px" />
		<col width="" />
	</colgroup>
	<tr>
		<th>근태종류</th>
		<td>
			<select id="gntGubunCd" name="gntGubunCd" class="transparent hideSelectButton required1 required2" disabled></select>
		</td>
		<th>근태명</th>
		<td>
			<select id="gntCd" name="gntCd" class="transparent hideSelectButton required1 required2" disabled></select>
		</td>
	</tr>
	<tr id="span_occ" style="display:none;"><!-- 경조휴가 신청시 -->
		<th>경조구분</th>
		<td>
			<select id="occFamCd" name="occFamCd" class="transparent hideSelectButton required1 required2" disabled ></select>
		</td>
		<th>경조휴가일수</th>
		<td>
			<span id="span_occHoliday"></span>
		</td>
	</tr>
	<tr id="inMod1" style="display:none;">
		<th>신청일자</th>
		<td colspan="3">
			<input id="sYmd" name="sYmd" type="text" size="10" class="date2 center" readonly   /> 
			<span id="span_eYmd">
				<input type="text" class="text w10 left transparent center" value="~" readonly tabindex="-1"> <input id="eYmd" name="eYmd" type="text" size="10" class="date2 center " readonly />
			</span>
			<span style="padding-left:30px;">	
				<b>총일수 : </b>&nbsp;&nbsp;<input type="text" id="holDay" name="holDay" class="text w30 center" readonly />&nbsp;&nbsp;&nbsp;&nbsp;
				<b>적용일수 : </b>&nbsp;&nbsp;<input type="text" id="closeDay" name="closeDay" class="text w30 center" readonly />&nbsp;&nbsp;&nbsp;&nbsp;
			</span>	
		</td>
	</tr>
	<tr id="inMod2" style="display:none;">
		<th>신청일자</th>
		<td colspan="3">
			<input id="applYmd" name="applYmd" type="text" size="10" class="date2 center" readonly />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

			<b>시작시간 : </b>&nbsp;&nbsp;<input id="reqSHm" name="reqSHm" type="text" class="text w40 center " readonly maxlength="5"/>&nbsp;&nbsp;&nbsp;&nbsp;
			<b>종료시간 : </b>&nbsp;&nbsp;<input id="reqEHm" name="reqEHm" type="text" class="text w40 center " readonly maxlength="5"/>&nbsp;&nbsp;&nbsp;&nbsp;
			<b>적용시간 : </b>&nbsp;&nbsp;<input id="requestHour" name="requestHour" type="text" class="text w30 center " readonly maxlength="4"/>시간
		</td>
	</tr>
	<tr>
		<th><tit:txt mid="104562" mdef="취소사유" /></th>
		<td colspan="3">
			<textarea id="gntReqReason" name="gntReqReason" rows="3" cols="30" class="${textCss} w100p ${required}" ${readonly}></textarea>
		</td>
	</tr>
	</table>

</div>
</form>
</body>
</html>