<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>대체휴가신청 세부내역</title>
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
var searchBfApplSeq	 = "${etc01}";
var applStatusCd	 = "";
var applYn	         = "";

	$(function() {

		parent.iframeOnLoad(220);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchSabun").val(searchApplSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#searchBfApplSeq").val(searchBfApplSeq); 

		applStatusCd = parent.$("#applStatusCd").val();  //신청서상태
		applYn = parent.$("#applYn").val(); //결재자 여부

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		//----------------------------------------------------------------
		
		// 신청, 임시저장
		if(authPg == "A") {
			
			//근무일
			$("#tdYmd").datepicker2({
				onReturn:function(date){
					if( date < "${curSysYyyyMMddHyphen}"){
						alert("과거 일자는 신청 할 수 없습니다.");
						$("#tdYmd").val("");
						return;
					}else{
						dateCheck(); //날짜 체크
					}
				}
			});
			
	    }

		doAction("Search");

	});

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/HolAlterApp.do?cmd=getHolAlterAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 
				
				$("#span_holWorkInfo").html(formatDate(data.DATA.holYmd, "-")
					//+"&nbsp;&nbsp;&nbsp;"+data.DATA.holShm.substring(0,2)+":"+data.DATA.holShm.substring(2,4)
					//+" ~ "+data.DATA.holEhm.substring(0,2)+":"+data.DATA.holEhm.substring(2,4)
					//+"&nbsp;&nbsp;(&nbsp;"+data.DATA.holReqTimeNm+"&nbsp;)"
				);

				$("#span_holTimeCd").html(data.DATA.holReqTimeNm);
				if( data.DATA.holWorkTime != null ){
					$("#span_holWorkTime").html(data.DATA.holWorkTime +"시간");
				}

				$("#holYmd").val(data.DATA.holYmd);
				$("#holTimeCd").val(data.DATA.reqTimeCd);
				$("#holWorkTime").val(data.DATA.holWorkTime);
				
				if(authPg == "R") {
					$("#searchBfApplSeq").val(data.DATA.bfApplSeq)
				}
				
				//근태코드
				var gntCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getHolAlterAppDetGntCd&searchBfApplSeq="+$("#searchBfApplSeq").val(), false).codeList, "");
				$("#gntCd").html(gntCdList[2]);
				
				$("#tdYmd").val( formatDate(data.DATA.ymd, "-") );
				$("#gntCd").val( data.DATA.gntCd );
				$("#note").val( data.DATA.note );
				
				
			}

			break;
		}
	}


	//스케쥴 및 휴일 체크 
	function dateCheck(){

		// 날짜 체크 
		var data = ajaxCall("/HolAlterApp.do?cmd=getHolAlterAppDetHoliChk",$("#searchForm").serialize() ,false);
		if(data.DATA == null){
			alert("해당일("+$("#tdYmd").val()+")에 근무스케쥴이 생성되지 않았습니다.\n담당자에게 문의 해주세요.");
			$("#tdYmd").val("");
			return false;
		}else {
			
			if(data.DATA.statusCd != "AA" ){
				alert("해당일에 재직상태가 아닙니다.");
				$("#tdYmd").val("");
				return false;
			}			
			if(data.DATA.holidayCnt != "0" ){
				alert("해당일은 휴일입니다.");
				$("#tdYmd").val("");
				return false;
			}			
			if( $("#tdYmd").val() > data.DATA.dedlineDate ){
				alert("대체휴가는 "+data.DATA.dedlineDate+" (근무일로 부터 "+data.DATA.dedline+"일) 까지 신청 가능합니다.");
				$("#tdYmd").val("");
				return false;
			}
		}

		return true;
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
		});

		if( !ch  ) return false;
		
		if( !dateCheck()  ) return false;
		var holTimeCd =  parseFloat($("#holTimeCd").val()); 
		var holWorkTime = parseFloat($("#holWorkTime").val()); 
		
		// 인정근무시간 체크
		if( $("#span_holWorkTime").html() == "" ||  holTimeCd > holWorkTime ){
			alert("해당 근무일에 인정근무시간이 부족하여 신청 할 수 없습니다.");
			return false;
		}

		var param = "sabun="+$("#searchApplSabun").val()
		+"&applSeq="+$("#searchApplSeq").val()
		+"&gntCd="+$("#gntCd").val()
		+"&sYmd="+$("#tdYmd").val().replace(/-/gi, "") 
		+"&eYmd="+$("#tdYmd").val().replace(/-/gi, "")  ;
		//기 신청건 체크  (근태신청에서 체크 )
		var data = ajaxCall("${ctx}/VacationApp.do?cmd=getVacationAppDetApplDayCnt", param,false);

		if(data.DATA != null && data.DATA.cnt != null && data.DATA.cnt != "null" && data.DATA.cnt != "0"){
			alert("동일한 일자에 신청내역이 있습니다.");
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

			if ( authPg == "R" )  {
				return true;
			} 
			
			// 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }

	      	//저장
			var data = ajaxCall("${ctx}/HolAlterApp.do?cmd=saveHolAlterAppDet",$("#searchForm").serialize(),false);

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
<style type="text/css">
th.pink { background-color:#fdf0f5 !important; } 
</style>

</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchSabun"		name="searchSabun"	 	 value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchBfApplSeq"	name="searchBfApplSeq"	 value=""/>
	
	<input type="hidden" id="holYmd"			name="holYmd"	 		 value=""/> <!-- 휴일근무일 -->
	<input type="hidden" id="holTimeCd"			name="holTimeCd"	 	 value=""/> <!-- 휴일근무구분 -->
	<input type="hidden" id="holWorkTime"		name="holWorkTime"	 	 value=""/> <!-- 휴일인정근무시간-->
	
	
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="holHour" mdef="휴일근무"/></li>
		</ul>
	</div>
	<table class="table pink">
		<colgroup>
			<col width="100px" />
			<col width="150px" />
			<col width="100px" />
			<col width="150px" />
			<col width="100px" />
			<col width="" />
		</colgroup> 
		<tr>
			<th class="pink"><tit:txt mid='104060' mdef='근무일'/></th>
			<td>
				<span id="span_holWorkInfo" class="spacingN"></span>	
			</td>
			<th class="pink"><tit:txt mid='compTimeOffType' mdef='대체휴가구분'/></th>
			<td>
				<span id="span_holTimeCd" class="spacingN"></span>	
			</td>
			<th class="pink"><tit:txt mid='rcgnWorkHour' mdef='인정근무시간'/></th>
			<td>
				<span id="span_holWorkTime" class="spacingN"></span>	
			</td>
		</tr>
	</table>
	
	<div class="h10"></div>	
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='114682' mdef='신청내용'/></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="200px" />
			<col width="120px" />
			<col width="" />
		</colgroup> 
	
		<tr>
			<th><tit:txt mid='leaveDate' mdef='휴가일자'/></th>
			<td>
				<input id="tdYmd" name="tdYmd" type="text" size="10" class="${dateCss} w70 ${required} " readonly maxlength="10"  /> 
			</td>
			<th><tit:txt mid='103963' mdef='근태종류'/></th>
			<td colspan="3">
				<select id="gntCd" name="gntCd" class="${selectCss} ${required}" ${selectDisabled}></select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='103783' mdef='비고' /></th>
			<td colspan="5" >
				<textarea rows="5" id="note" name="note" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
		
	</form>
</div>
		
</body>
</html>