<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>종전근무지관리</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var arg = p.window.dialogArguments;

	var arrObjId = [ "srchYear"
		, "enter_nm"
		, "napse_yn"
		, "enter_no"
		, "work_s_ymd"
		, "work_e_ymd"
		, "reduce_s_ymd"
		, "reduce_e_ymd"
		, "pay_mon"
		, "bonus_mon"
		, "etc_bonus_mon"
		, "stock_buy_mon"
		, "stock_union_mon"
		, "imwon_ret_over_mon"
		, "income_tax_mon"
		, "inhbt_tax_mon"
		, "rural_tax_mon"
		, "pen_mon"
		, "etc_mon1"
		, "etc_mon2"
		, "etc_mon3"
		, "etc_mon4"
		, "hel_mon"
		, "emp_mon"
		, "notax_abroad_mon"
		, "notax_work_mon"
		, "notax_baby_mon"
		, "notax_research_mon"
		, "notax_reporter_mon"
		, "notax_train_mon"
		, "notax_etc_mon"
		, "fin_tot_tax_mon"
		, "notax_food_mon"
	];

	$(function() {
		$("#work_s_ymd").mask("1111-11-11") ;	$("#work_s_ymd").datepicker2({startdate:"work_e_ymd"});
		$("#work_e_ymd").mask("1111-11-11") ;	$("#work_e_ymd").datepicker2({enddate:"work_s_ymd"});
		$("#reduce_s_ymd").mask("1111-11-11") ;	$("#reduce_s_ymd").datepicker2({startdate:"reduce_e_ymd"});
		$("#reduce_e_ymd").mask("1111-11-11") ;	$("#reduce_e_ymd").datepicker2({enddate:"reduce_s_ymd"});
		$("#pay_mon").mask('000,000,000,000,000', {reverse: true});
		$("#bonus_mon").mask("000,000,000,000,000", {reverse: true});
		$("#etc_bonus_mon").mask("000,000,000,000,000", {reverse: true});
		$("#stock_buy_mon").mask("000,000,000,000,000", {reverse: true});
		$("#stock_union_mon").mask("000,000,000,000,000", {reverse: true});
		$("#imwon_ret_over_mon").mask("000,000,000,000,000", {reverse: true});
		$("#income_tax_mon").mask("000,000,000,000,000", {reverse: true});
		$("#inhbt_tax_mon").mask("000,000,000,000,000", {reverse: true});
		$("#rural_tax_mon").mask("000,000,000,000,000", {reverse: true});
		//$("#pen_mon").mask("000,000,000,000,000", {reverse: true});
		$("#etc_mon1").mask("000,000,000,000,000", {reverse: true});
		$("#etc_mon2").mask("000,000,000,000,000", {reverse: true});
		$("#etc_mon3").mask("000,000,000,000,000", {reverse: true});
		$("#etc_mon4").mask("000,000,000,000,000", {reverse: true});
		//$("#hel_mon").mask("000,000,000,000,000", {reverse: true});
		//$("#emp_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_abroad_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_work_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_baby_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_research_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_reporter_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_train_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_etc_mon").mask("000,000,000,000,000", {reverse: true});
		$("#fin_tot_tax_mon").mask("000,000,000,000,000", {reverse: true});
		$("#notax_food_mon").mask("000,000,000,000,000", {reverse: true});

		//국민연금 keyup
		$("#pen_mon").keyup(function(event){
            var str;
            if(event.keyCode != 8){ //백스페이스키
                if (!(event.keyCode >=37 && event.keyCode<=40)) { //방향키
                    var inputVal = $(this).val();

                    str = inputVal.replace(/[^-0-9]/gi,'');

                    if(str.lastIndexOf("-")>0){ //중간에 -가 있다면 replace
                        if(str.indexOf("-")==0){ //음수라면 replace 후 - 붙여준다.
                            str = "-"+str.replace(/[-]/gi,'');
                        }else{
                            str = str.replace(/[-]/gi,'');
                        }
                    }

                    var minus = str.substring(0, 1);

                    str = str.replace(/[^\d]+/g, '');
                    str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                  	//음수일 경우
                    if(minus == "-") str = "-"+str;

                    $(this).val(str);
                }
            }
        });
		//건강보험 keyup
		$("#hel_mon").keyup(function(event){
            var str;
            if(event.keyCode != 8){
                if (!(event.keyCode >=37 && event.keyCode<=40)) {
                    var inputVal = $(this).val();

                    str = inputVal.replace(/[^-0-9]/gi,'');

                    if(str.lastIndexOf("-")>0){ //중간에 -가 있다면 replace
                        if(str.indexOf("-")==0){ //음수라면 replace 후 - 붙여준다.
                            str = "-"+str.replace(/[-]/gi,'');
                        }else{
                            str = str.replace(/[-]/gi,'');
                        }
                    }

                    var minus = str.substring(0, 1);

                    str = str.replace(/[^\d]+/g, '');
                    str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                  	//음수일 경우
                    if(minus == "-") str = "-"+str;

                    $(this).val(str);
                }
            }
        });
		//고용보험 keyup
		$("#emp_mon").keyup(function(event){
            var str;
            if(event.keyCode != 8){
                if (!(event.keyCode >=37 && event.keyCode<=40)) {
                    var inputVal = $(this).val();

                    str = inputVal.replace(/[^-0-9]/gi,'');

                    if(str.lastIndexOf("-")>0){ //중간에 -가 있다면 replace
                        if(str.indexOf("-")==0){ //음수라면 replace 후 - 붙여준다.
                            str = "-"+str.replace(/[-]/gi,'');
                        }else{
                            str = str.replace(/[-]/gi,'');
                        }
                    }

                    var minus = str.substring(0, 1);

                    str = str.replace(/[^\d]+/g, '');
                    str = str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
                  	//음수일 경우
                    if(minus == "-") str = "-"+str;

                    $(this).val(str);
                }
            }
        });


	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	$(function() {
		for(var i=0; i<arrObjId.length; i++) {
			var objId = arrObjId[i];

			if( arg != undefined ) {
				$("#"+ objId).val( arg[objId] );
			}else{
				$("#"+ objId).val( p.popDialogArgument(objId) );
			}
			
			//음수 입력을 위하여 mask 설정이 주석처리되었기 때문에 콤마 처리를 추가함
			if(objId == "pen_mon") {
				$("#pen_mon").val($("#pen_mon").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
			} else if(objId == "hel_mon") {
				$("#hel_mon").val($("#hel_mon").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
			} else if(objId == "emp_mon") {
				$("#emp_mon").val($("#emp_mon").val().replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'));
			}

			$("#"+ objId).focus();
			$("#"+ objId).blur();
		}

		if ( $("#napse_yn").attr("readonly") ) {
			$("#napse_yn").attr("disabled", true);
		}
	});

	//데이타 리턴
	function setValue() {
		if (isInvalid()) return;

		var rv = new Array( arrObjId.length );

		for(var i=0; i<arrObjId.length; i++) {
			var objId = arrObjId[i];

			rv[ objId ] = $("#"+ objId).val();
		}

		if(p.popReturnValue) p.popReturnValue(rv);

		p.self.close();
	}
	
	// 유효성 체크 
	// 유효하면 false 리턴
    // 유효하지 않으면 true 리턴
	function isInvalid() {
		if ( $("#enter_nm").val() == "" ) {
			alert("근무처명을 입력하세요");
			$("#enter_nm").focus();
			return true ;
		}

		if ( $("#enter_no").val() == "" ) {
			alert("사업자등록번호를 입력하세요");
			$("#enter_no").focus();
			return true ;
		}

		if ( $("#work_s_ymd").val() == "" ) {
			alert("근무기간을 입력하세요");
			$("#work_s_ymd").focus();
			return true ;
		}

		if ( $("#work_e_ymd").val() == "" ) {
			alert("근무기간을 입력하세요");
			$("#work_e_ymd").focus();
			return true ;
		}
/* 		if ( $("#fin_tot_tax_mon").val() == "" ) {
			alert("결정세액을 입력하세요");
			$("#fin_tot_tax_mon").focus();
			return true ;
		} */
		
         var workSYmd = $("#work_s_ymd").val(); //근무기간시작일
         var workEYmd = $("#work_e_ymd").val(); //근무기간종료일
         var redcSYmd = $("#reduce_s_ymd").val(); //감면기간시작일
         var redcEYmd = $("#reduce_e_ymd").val(); //감면기간종료일

         //귀속년도 체크 param
         var workSYy = (workSYmd != null && workSYmd != "" && workSYmd.length >= 4 ) ? workSYmd.substring(0,4) : "" ;
         var workEYy = (workEYmd != null && workEYmd != "" && workEYmd.length >= 4 ) ? workEYmd.substring(0,4) : "" ;
         var redcSYy = (redcSYmd != null && redcSYmd != "" && redcSYmd.length >= 4 ) ? redcSYmd.substring(0,4) : "" ;
         var redcEYy = (redcEYmd != null && redcEYmd != "" && redcEYmd.length >= 4 ) ? redcEYmd.substring(0,4) : "" ;

         /* 근무기간 체크 */
         if($("#srchYear").val() != workSYy && workSYy != "") {
             alert(" 근무 시작일을 확인하십시오.\n 근무기간은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
             $("#work_s_ymd").focus();
             return true ;
         } else if($("#srchYear").val() != workEYy && workEYy != "") {
             alert(" 근무 종료일을 확인하십시오.\n 근무기간은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
             $("#work_e_ymd").focus();
             return true ;
         } else if(workSYmd != "" && workEYmd != "" && workSYmd > workEYmd) {
             alert(" 근무기간이 유효하지 않습니다.\n 시작일과 종료일을 확인하십시오.");
             $("#work_s_ymd").focus();
             return true ;
         }

         /* 감면기간 체크 */
		if(redcSYmd != "" || redcEYmd != "") {
			if($("#srchYear").val() != redcSYy) {
				alert(" 감면 시작일을 확인하십시오.\n 감면기간은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
				$("#reduce_s_ymd").focus();
				return true ;
			} else if($("#srchYear").val() != redcEYy){
				alert(" 감면 종료일을 확인하십시오.\n 감면기간은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
				$("#reduce_e_ymd").focus();
				return true ;
			} else if(!(redcSYmd >= workSYmd && redcSYmd <= workEYmd)) {
				alert(" 감면 시작일을 확인하십시오.\n 감면기간은 근무기간에 포함되어야 합니다.\n "+$("#work_s_ymd").val()+" ~ "+$("#work_e_ymd").val());
				$("#reduce_s_ymd").focus();
				return true ;
			} else if(!(redcEYmd >= workSYmd && redcEYmd <= workEYmd)) {
				alert(" 감면 종료일을 확인하십시오.\n 감면기간은 근무기간에 포함되어야 합니다.\n "+$("#work_s_ymd").val()+" ~ "+$("#work_e_ymd").val());
				$("#reduce_e_ymd").focus();
				return true ;
			} else if(redcEYmd != "" && !(redcSYmd <= redcEYmd)) {
				alert(" 감면기간이 유효하지 않습니다.\n 시작일과 종료일을 확인하십시오.");
				$("#reduce_s_ymd").focus();
				return true ;
			}
		}
		
		return false ;
	}
</script>

</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>종전근무지 세부내역</li>
				<!--<li class="close"></li>-->
			</ul>
		</div>
		<form id="sheetForm" name="sheetForm" >
			<input type="hidden" id="srchYear" name="srchYear" value="" />
			<input type="hidden" id="srchAdjustType" name="srchAdjustType" value="" />
			<input type="hidden" id="srchSabun" name="srchSabun" value="" />
		</form>
        <div class="popup_main">

			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
			<colgroup>
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
				<col width="" />
			</colgroup>
			<tr>
				<th>근무처명(1)(<font class="red" >*</font>)</th>
				<td class="left"><input name="enter_nm" id="enter_nm" type="text" class="<%=textCss%>" onFocus="this.select()" value="" maxlength="100" <%=readonly%> /></td>
				<th>납세조합구분</th>
				<td class="left">
					<select id="napse_yn" name="napse_yn" <%=readonly%>>
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</td>
				<th>사업자등록번호(<font class="red" >*</font>)</th>
				<td class="left" colspan="3"><input name="enter_no" id="enter_no" type="text" class="<%=textCss%> center" onFocus="this.select()" value="" maxlength="100" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>근무기간<br/>시작일(11)(<font class="red" >*</font>)</th>
				<td class="left"><input name="work_s_ymd" id="work_s_ymd" type="text" class="<%=textCss%> center" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>근무기간<br/>종료일(11)(<font class="red" >*</font>)</th>
				<td class="left"><input name="work_e_ymd" id="work_e_ymd" type="text" class="<%=textCss%> center" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>감면기간<br/>시작일(12)</th>
				<td class="left"><input name="reduce_s_ymd" id="reduce_s_ymd" type="text" class="<%=textCss%> center" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>감면기간<br/>종료일(12)</th>
				<td class="left"><input name="reduce_e_ymd" id="reduce_e_ymd" type="text" class="<%=textCss%> center" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>급여액(13)</th>
				<td class="left"><input name="pay_mon" id="pay_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>상여액(14)</th>
				<td class="left"><input name="bonus_mon" id="bonus_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>인정상여(15)</th>
				<td class="left"><input name="etc_bonus_mon" id="etc_bonus_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<%-- <th>결정세액(72)</th> --%>
				<td></td>
				<td class="left" colspan="2"><input style="display:none" name="fin_tot_tax_mon" id="fin_tot_tax_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>주식매수선택권<br/>행사이익(15-1)</th>
				<td class="left"><input name="stock_buy_mon" id="stock_buy_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>우리사주조합<br/>인출금(15-2)</th>
				<td class="left"><input name="stock_union_mon" id="stock_union_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>임원퇴직소득금액<br/>한도초과액(15-3)</th>
				<td class="left"><input name="imwon_ret_over_mon" id="imwon_ret_over_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>소득세<br/>(73행 79열)</th>
				<td class="left"><input name="income_tax_mon" id="income_tax_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>지방소득세<br/>(73행 80열)</th>
				<td class="left"><input name="inhbt_tax_mon" id="inhbt_tax_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>농특세<br/>(73행 81열)</th>
				<td class="left"><input name="rural_tax_mon" id="rural_tax_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>국민연금</th>
				<td class="left"><input name="pen_mon" id="pen_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>사립학교<br/>교직원연금</th>
				<td class="left"><input name="etc_mon1" id="etc_mon1" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>공무원연금</th>
				<td class="left"><input name="etc_mon2" id="etc_mon2" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>군인연금</th>
				<td class="left"><input name="etc_mon3" id="etc_mon3" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>별정우체국연금</th>
				<td class="left" colspan="3"><input name="etc_mon4" id="etc_mon4" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>건강보험</th>
				<td class="left"><input name="hel_mon" id="hel_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>고용보험</th>
				<td class="left"><input name="emp_mon" id="emp_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>국외근로<br/>비과세(18)</th>
				<td class="left"><input name="notax_abroad_mon" id="notax_abroad_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>야간근로(생산)<br/>비과세(18-1)</th>
				<td class="left"><input name="notax_work_mon" id="notax_work_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>보육<br/>비과세(18-2)</th>
				<td class="left"><input name="notax_baby_mon" id="notax_baby_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			<tr>
				<th>연구보조(H09)<br/>비과세(18-4)</th>
				<td class="left"><input name="notax_research_mon" id="notax_research_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>취재수당<br/>비과세(18-5)</th>
				<td class="left"><input name="notax_reporter_mon" id="notax_reporter_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>식대<br/>비과세(18-40)</th>
				<td class="left"><input name="notax_food_mon" id="notax_food_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<th>수련보조수당<br/>비과세(19)</th>
				<td class="left"><input name="notax_train_mon" id="notax_train_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
				<!-- 2019.12.09.기타 비과세의 display:none를 삭제시 위 수련보조수당 비과세의 colspan="3"삭제해야함  -->
				<th style="display:none;" >기타<br/>비과세</th>
				<td class="left" style="display:none;"><input name="notax_etc_mon" id="notax_etc_mon" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /></td>
			</tr>
			</table>
        </div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large">확인</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>