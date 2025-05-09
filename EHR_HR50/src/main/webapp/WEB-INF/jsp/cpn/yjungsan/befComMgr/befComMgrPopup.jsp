<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>종전근무지관리</title>
	<%@ page import="yjungsan.util.*"%>
	<%@ page import="java.util.Map"%>
	<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.window.dialogArguments;

	var arrObjId = [ "enterNm"
		, "napseYn"
		, "enterNo"
		, "workSYmd"
		, "workEYmd"
		, "reduceSYmd"
		, "reduceEYmd"
		, "payMon"
		, "bonusMon"
		, "etcBonusMon"
		, "stockBuyMon"
		, "stockUnionMon"
		, "imwonRetOverMon"
		, "incomeTaxMon"
		, "inhbtTaxMon"
		, "ruralTaxMon"
		, "penMon"
		, "etcMon1"
		, "etcMon2"
		, "etcMon3"
		, "etcMon4"
		, "helMon"
		, "empMon"
		, "notaxAbroadMon"
		, "notaxWorkMon"
		, "notaxBabyMon"
		, "notaxResearchMon"
		, "notaxReporterMon"
		, "notaxTrainMon"
		, "notaxEtcMon"
		, "finTotTaxMon"
		, "notaxFoodMon"
	];

	$(function() {
		$("#workSYmd").mask("1111-11-11") ;	$("#workSYmd").datepicker2({startdate:"workEYmd"});
		$("#workEYmd").mask("1111-11-11") ;	$("#workEYmd").datepicker2({enddate:"workSYmd"});
		$("#reduceSYmd").mask("1111-11-11") ;	$("#reduceSYmd").datepicker2({startdate:"reduceEYmd"});
		$("#reduceEYmd").mask("1111-11-11") ;	$("#reduceEYmd").datepicker2({enddate:"reduceSYmd"});
		$("#payMon").mask('000,000,000,000,000', {reverse: true});
		$("#bonusMon").mask("000,000,000,000,000", {reverse: true});
		$("#etcBonusMon").mask("000,000,000,000,000", {reverse: true});
		$("#stockBuyMon").mask("000,000,000,000,000", {reverse: true});
		$("#stockUnionMon").mask("000,000,000,000,000", {reverse: true});
		$("#imwonRetOverMon").mask("000,000,000,000,000", {reverse: true});
		$("#incomeTaxMon").mask("000,000,000,000,000", {reverse: true});
		$("#inhbtTaxMon").mask("000,000,000,000,000", {reverse: true});
		$("#ruralTaxMon").mask("000,000,000,000,000", {reverse: true});
		//$("#penMon").mask("000,000,000,000,000", {reverse: true});
		$("#etcMon1").mask("000,000,000,000,000", {reverse: true});
		$("#etcMon2").mask("000,000,000,000,000", {reverse: true});
		$("#etcMon3").mask("000,000,000,000,000", {reverse: true});
		$("#etcMon4").mask("000,000,000,000,000", {reverse: true});
		//$("#helMon").mask("000,000,000,000,000", {reverse: true});
		//$("#empMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxAbroadMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxWorkMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxBabyMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxResearchMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxReporterMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxTrainMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxEtcMon").mask("000,000,000,000,000", {reverse: true});
		$("#finTotTaxMon").mask("000,000,000,000,000", {reverse: true});
		$("#notaxFoodMon").mask("000,000,000,000,000", {reverse: true});

		//국민연금 keyup
		$("#penMon").keyup(function(event){
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
		//건강보험 keyup
		$("#helMon").keyup(function(event){
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
		$("#empMon").keyup(function(event){
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

			$("#"+ objId).focus();
			$("#"+ objId).blur();
		}

		if ( $("#napseYn").attr("readonly") ) {
			$("#napseYn").attr("disabled", true);
		}
	});

	//데이타 리턴
	function setValue() {
		if ( $("#enterNm").val() == "" ) {
			alert("근무처명을 입력하세요");
			$("#enterNm").focus();
			return;
		}

		if ( $("#enterNo").val() == "" ) {
			alert("사업자등록번호를 입력하세요");
			$("#enterNo").focus();
			return;
		}

		if ( $("#workSYmd").val() == "" ) {
			alert("근무기간을 입력하세요");
			$("#workSYmd").focus();
			return;
		}

		if ( $("#workEYmd").val() == "" ) {
			alert("근무기간을 입력하세요");
			$("#workEYmd").focus();
			return;
		}
/* 		if ( $("#finTotTaxMon").val() == "" ) {
			alert("결정세액을 입력하세요");
			$("#finTotTaxMon").focus();
			return;
		} */
		var rv = new Array( arrObjId.length );

		for(var i=0; i<arrObjId.length; i++) {
			var objId = arrObjId[i];

			rv[ objId ] = $("#"+ objId).val();
		}

		if(p.popReturnValue) p.popReturnValue(rv);

		p.self.close();
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
				<td class="left"><input name="enterNm" id="enterNm" type="text" class="${textCss}" onFocus="this.select()" value="" maxlength="100" ${readonly} /></td>
				<th>납세조합구분</th>
				<td class="left">
					<select id="napseYn" name="napseYn" ${readonly}>
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
				</td>
				<th>사업자등록번호(<font class="red" >*</font>)</th>
				<td class="left" colspan="3"><input name="enterNo" id="enterNo" type="text" class="${textCss} center" onFocus="this.select()" value="" maxlength="100" ${readonly} /></td>
			</tr>
			<tr>
				<th>근무기간<br/>시작일(11)(<font class="red" >*</font>)</th>
				<td class="left"><input name="workSYmd" id="workSYmd" type="text" class="${textCss} center" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>근무기간<br/>종료일(11)(<font class="red" >*</font>)</th>
				<td class="left"><input name="workEYmd" id="workEYmd" type="text" class="${textCss} center" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>감면기간<br/>시작일(12)</th>
				<td class="left"><input name="reduceSYmd" id="reduceSYmd" type="text" class="${textCss} center" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>감면기간<br/>종료일(12)</th>
				<td class="left"><input name="reduceEYmd" id="reduceEYmd" type="text" class="${textCss} center" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>급여액(13)</th>
				<td class="left"><input name="payMon" id="payMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>상여액(14)</th>
				<td class="left"><input name="bonusMon" id="bonusMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>인정상여(15)</th>
				<td class="left"><input name="etcBonusMon" id="etcBonusMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>결정세액(72)</th>
				<td class="left" colspan="2"><input name="finTotTaxMon" id="finTotTaxMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>주식매수선택권<br/>행사이익(15-1)</th>
				<td class="left"><input name="stockBuyMon" id="stockBuyMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>우리사주조합<br/>인출금(15-2)</th>
				<td class="left"><input name="stockUnionMon" id="stockUnionMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>임원퇴직소득금액<br/>한도초과액(15-3)</th>
				<td class="left" colspan="3"><input name="imwonRetOverMon" id="imwonRetOverMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>소득세(73-79)</th>
				<td class="left"><input name="incomeTaxMon" id="incomeTaxMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>지방소득세(73-80)</th>
				<td class="left"><input name="inhbtTaxMon" id="inhbtTaxMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>농특세(73-81)</th>
				<td class="left" colspan="3"><input name="ruralTaxMon" id="ruralTaxMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>국민연금</th>
				<td class="left"><input name="penMon" id="penMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>사립학교<br/>교직원연금</th>
				<td class="left"><input name="etcMon1" id="etcMon1" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>공무원연금</th>
				<td class="left" colspan="3"><input name="etcMon2" id="etcMon2" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>군인연금</th>
				<td class="left" colspan="3"><input name="etcMon3" id="etcMon3" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>별정우체국연금</th>
				<td class="left" colspan="3"><input name="etcMon4" id="etcMon4" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>건강보험</th>
				<td class="left" colspan="3"><input name="helMon" id="helMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>고용보험</th>
				<td class="left" colspan="3"><input name="empMon" id="empMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>국외<br/>비과세(18)</th>
				<td class="left"><input name="notaxAbroadMon" id="notaxAbroadMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>생산직<br/>비과세(18-1)</th>
				<td class="left"><input name="notaxWorkMon" id="notaxWorkMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>출산보육<br/>비과세(18-2)</th>
				<td class="left" colspan="3"><input name="notaxBabyMon" id="notaxBabyMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
			</tr>
			<tr>
				<th>연구보조<br/>비과세(18-4)</th>
				<td class="left"><input name="notaxResearchMon" id="notaxResearchMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>취재수당<br/>비과세(18-6)</th>
				<td class="left"><input name="notaxReporterMon" id="notaxReporterMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>수련보조수당<br/>비과세(19)</th>
				<td class="left"><input name="notaxTrainMon" id="notaxTrainMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<th>식대비과세</th>
				<td class="left"><input name="notaxFoodMon" id="notaxFoodMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
				<!-- 2019.12.09.기타 비과세의 display:none를 삭제시 위 수련보조수당 비과세의 colspan="3"삭제해야함  -->
				<th style="display:none;" >기타<br/>비과세</th>
				<td class="left" style="display:none;"><input name="notaxEtcMon" id="notaxEtcMon" type="text" class="${textCss} right" onFocus="this.select()" value="" maxlength="20" ${readonly} /></td>
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