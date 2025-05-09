<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var authPg = "";
	var gPRow = "";
	var pGubun = "";

	var arg = p.popDialogArgumentAll();

	$(function() {
		$(".close").click(function() {
			p.self.close();
		});

		var eduMethodCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10050"), " ");//시행방법
		var eduBranchCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10010"), " ");//교육구분
		var eduMBranchCdList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10015"), " ");//교육분류
		var currencyCdList 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), "");//통화단위

		$("#eduMethodCd").html(eduMethodCdList[2]);
		$("#eduBranchCd").html(eduBranchCdList[2]);
		$("#eduMBranchCd").html(eduMBranchCdList[2]);
		$("#currencyCd").html(currencyCdList[2]);

		// 최대길이
		$("#eduCourseGoal").maxbyte(2000);
		$("#eduMemo").maxbyte(4000);

		//금액
		$('#perExpenseMonView').mask('000,000,000,000,000', {reverse: true});
		$('#laborMonView').mask('000,000,000,000,000', {reverse: true});

		$("#eduHour").mask('11111');
		// 달력
		$("#eduSYmdView").datepicker2({startdate:"eduEYmdView"});
		$("#eduEYmdView").datepicker2({enddate:"eduSYmdView"});
		$("#applSYmdView").datepicker2();

		// 필수값 체크
		var msg = {};
		//msg.chk = "체크해주세요";
		setValidate( $("#srchFrm"),msg );

		if( arg != "undefined" ) {
			authPg = arg["authPg"];

			//$("#checkType").val(checkType);
		}
	});

	function save(){
		$("#eduSYmd").val($("#eduSYmdView").val().replace(/-/g, ''));
		$("#eduEYmd").val($("#eduEYmdView").val().replace(/-/g, ''));
		$("#applSYmd").val($("#applSYmdView").val().replace(/-/g, ''));

		$("#perExpenseMon").val($("#perExpenseMonView").val().replace(/,/g, ''));
		$("#laborMon").val($("#laborMonView").val().replace(/,/g, ''));

		//if( !$("#srchFrm").valid() ) return;

		if( !checkList()){ return };

		if($("#eduCourseNmChk").val() != "Y"){
			alert("<msg:txt mid='alertEduAppDetOutSide1' mdef='과정명의 [중복확인]을 하지 않으셨습니다. \n[중복확인 => 확인] 후 저장해 주십시요.'/>");
			return;
		}

		if($("#applSYmd").val() > $("#eduSYmd").val()){
			alert("<msg:txt mid='alertEduAppDetOutSide2' mdef='교육신청일이 교육시작일보다 큽니다.'/>");
			$("#applSYmd").focus();
			return;
		}

		if(!confirm("외부교육과정을 등록하시겠습니까?")) return;

		var data = ajaxCall("${ctx}/EduAppDet.do?cmd=prcEduAppDetPopOutside",$("#srchFrm").serialize(),false);

		if(data.Result.Code == null) {
			alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");

			var eduSeqOut = data.Result.eduSeqOut;
			var eduEventSeqOut = data.Result.eduEventSeqOut;

			$("#eduSeq").val(eduSeqOut);
    		$("#eduEventSeq").val(eduEventSeqOut);

			// 단건조회
			var data = ajaxCall("${ctx}/EduAppDet.do?cmd=getEduAppDetPopOutsideMap",$("#srchFrm").serialize(),false);

			if(data != null && data.map != null) {
				$("#eduEventNm").val(data.map.eduEventNm);
			}

    		var rv = new Array();
    		rv["eduSeq"		] = $("#eduSeq").val();

    		rv["eduCourseNm"] = $("#eduCourseNm").val();
    		rv["eduEventSeq"] = $("#eduEventSeq").val();
    		rv["eduEventNm" ] = $("#eduEventNm" ).val();

    		rv["eduBranchNm" ] = $("#eduBranchCd option:selected" ).text();
    		rv["eduMBranchNm"] = $("#eduMBranchCd option:selected" ).text();

    		rv["eduOrgCd"    ] = $("#eduOrgCd"   ).val();
    		rv["eduOrgNm"    ] = $("#eduOrgNm"   ).val();
    		rv["eduPlace"    ] = $("#eduPlace"   ).val();

    		rv["eduSYmd"      ] = $("#eduSYmd"     ).val();
    		rv["eduEYmd"      ] = $("#eduEYmd"     ).val();
    		rv["eduHour"      ] = $("#eduHour"     ).val();
    		rv["perExpenseMon"] = $("#perExpenseMonView"    ).val();
    		rv["laborMon"     ] = $("#laborMonView"    ).val();

    		rv["eduMemo"     ]  = $("#eduMemo"    ).val();

    		p.popReturnValue(rv);
    		p.window.close();

		} else {
			alert(data.Result.Message);
		}
	}

	function dupPop(){
		if(!isPopup()) {return;}

		var url = "${ctx}/EduAppDet.do?cmd=viewEduAppDetPopOutsideDup";
		var args	= new Array(2);

		args["authPg"] = "A";
		args["eduCourseNm"] = $("#eduCourseNm").val();

		gPRow = "";
		pGubun = "viewEduAppDetPopOutsideDup";

		openPopup(url,args,500,500);
	}

	function eduOrgPopup(){
		if(!isPopup()) {return;}

		gPRow = "";
		pGubun = "eduOrgPopup";

		openPopup("${ctx}/Popup.do?cmd=eduOrgPopup&authPg=A", "", "680","520");
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "viewEduAppDetPopOutsideDup"){
			$("#eduSeq").val( rv["eduSeq"]);
			$("#eduCourseNm").val( rv["eduCourseNm"]);
			$("#eduOrgCd").val( rv["eduOrgCd"]);
			$("#eduOrgNm").val( rv["eduOrgNm"]);
			$("#eduCourseGoal").val( rv["eduCourseGoal"]);
			$("#eduMemo").val( rv["eduMemo"]);
			$("#eduCourseThema").val( rv["eduCourseThema"]);
			$("#eduMethodCd").val( rv["eduMethodCd"]);
			$("#eduBranchCd").val( rv["eduBranchCd"]);
			$("#eduMBranchCd").val( rv["eduMBranchCd"]);

			$("#eduOrgNm").removeAttr("readonly");
			$("#eduOrgNm").removeClass("readonly");
			$("#eduOrgNm").attr("readonly", true);
			$("#eduOrgNm").addClass("readonly");

			$("#eduCourseNmChk").val("Y");

			alert("과정명을 변경하실 경우에는 \n[중복확인] 버튼을 사용하여 과정명을 \n변경해 주시기 바랍니다.");

        } else if(pGubun == "eduOrgPopup") {
	    	$("#eduOrgCd").val(rv["eduOrgCd"]);
	    	$("#eduOrgNm").val(rv["eduOrgNm"]);
        }
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}

			return ch;
		});

		return ch;
	}
</script>

</head>
<body class="bodywrap">
<form id="srchFrm" name="srchFrm" >
<input type="hidden" id="eduSeq" name="eduSeq" value="" />
<input type="hidden" id="eduCourseThema" name="eduCourseThema" />
<input type="hidden" id="lecturerNm" name="lecturerNm" />
<input type="hidden" id="lecturerTelNo" name="lecturerTelNo" />
<input type="hidden" id="eduSHm" name="eduSHm" />
<input type="hidden" id="eduEHm" name="eduEHm" />
<input type="hidden" id="eduEventSeq" name="eduEventSeq" />
<input type="hidden" id="eduEventNm" name="eduEventNm" />

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='eduAppDetOutSide' mdef='외부교육과정등록'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
        	<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='eduEventMgrPopV1' mdef='교육과정 기본내역'/></li>
					<li class="btn">
					  <btn:a href="javascript:save();" 	css="basic authA" mid='save' mdef="저장"/>
					</li>
				</ul>
			</div>

			<table class="table">
				<colgroup>
					<col width="20%">
					<col width="%">
				</colgroup>
				<tbody>
					<tr>
						<th><tit:txt mid='113788' mdef='교육과정명'/></th>
						<td colspan=3>
							<input type="text" id="eduCourseNm" name="eduCourseNm" class="text required w80p" validator="required" vtxt="교육과정명" />
							<input type="hidden" id="eduCourseNmChk" name="eduCourseNmChk" value="N" />
							<btn:a href="javascript: dupPop();" 	css="basic" mid='111623' mdef="중복확인"/>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></th>
						<td colspan=3>
							<input type="text" id="eduOrgNm" name="eduOrgNm" class="text required readonly w80p" validator="required" vtxt="교육기관" readonly/>
							<input type="hidden" id="eduOrgCd" name="eduOrgCd" />
		                  	<a href="javascript: eduOrgPopup();" class="button6">
		                  		<img src="/common/${theme}/images/btn_search2.gif"/>
		                  	</a>
						</td>
					</tr>
					<tr>
					    <th><tit:txt mid='104078' mdef='교육장소'/></th>
						<td>
							<input type="text" id="eduPlace" name="eduPlace" class="text required w100p" validator="required" vtxt="교육장소" />
						</td>
					</tr>
					<tr class="hide">
						<th><tit:txt mid='112703' mdef='시행방법'/></th>
						<td>
							<select id="eduMethodCd" name="eduMethodCd" vtxt="시행방법" ></select>
						</td>
					</tr>
					<tr class="hide">
						<th><tit:txt mid='104566' mdef='교육구분'/></th>
						<td>
							<select id="eduBranchCd" name="eduBranchCd" vtxt="교육구분" ></select>
						</td>
						<th><tit:txt mid='eduMBranchPopV1' mdef='교육분류'/></th>
						<td>
							<select id="eduMBranchCd" name="eduMBranchCd" vtxt="교육분류" ></select>
						</td>
					</tr>
					<tr class="hide">
						<th>교육목표</th>
						<td colspan=3>
							<textarea id="eduCourseGoal" name="eduCourseGoal" class="text w100p" validator="" vtxt="교육목표" rows="4"></textarea>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104071' mdef='교육내용'/></th>
						<td colspan=3>
							<textarea id="eduMemo" name="eduMemo" class="text required w100p" validator="required" vtxt="교육내용" rows="4"></textarea>
						</td>
					</tr>
				</tbody>
			</table>

			<table style="width:100%">
			<colgroup>
				<col width="50%" />
				<col width="*" />
			</colgroup>
		<tr>
			<td style="vertical-align:top;">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='eduAppDetOutSideV2' mdef='교육기간/총시간'/></li>
					</ul>
					</div>
				</div>
				<table class="table">
					<tr>
						<th><tit:txt mid='201707040000006' mdef='교육시작일'/></th>
						<td>
							<input type="text" id="eduSYmdView" name="eduSYmdView" class="text required date2" validator="required" vtxt="시작일" />
							<input type="hidden" id="eduSYmd" name="eduSYmd" />

						</td>
						<th><tit:txt mid='201704270000012' mdef='교육종료일'/></th>
						<td>
							<input type="text" id="eduEYmdView" name="eduEYmdView" class="text required date2" validator="required" vtxt="종료일" />
							<input type="hidden" id="eduEYmd" name="eduEYmd" />
						</td>
					</tr>
					<tr>
					<th><tit:txt mid='eduEventMgrPopV4' mdef='총시간'/></th>
						<td colspan="3">
							<input type="text" id="eduHour" name="eduHour" class="text required right w35p" validator="required" vtxt="총시간" /> &nbsp;시간
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='113087' mdef='신청시작일'/></th>
						<td>
							<input type="text" id="applSYmdView" name="applSYmdView" class="text date2"  vtxt="신청시작일" />
							<input type="hidden" id="applSYmd" name="applSYmd" class="text required date2" />
						</td>

					</tr>
				</table>
			</td>
			<td style="vertical-align:top; padding-left:10px">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='eduAppDetOutSideV3' mdef='교육비용'/></li>
					</ul>
					</div>
				</div>
				<table class="table">
					<tr>
						<th><tit:txt mid='114146' mdef='통화'/></th>
						<td>
							<select id="currencyCd" name="currencyCd"></select>
						</td>
						<th><tit:txt mid='eduAppDetOutSideV3' mdef='교육비용'/></th>
						<td>
							<input type="text" id="perExpenseMonView" name="perExpenseMonView" class="text required right w100p" validator="required" vtxt="교육비용" />
							<input type="hidden" id="perExpenseMon" name="perExpenseMon" />
						</td>
					</tr>
					<tr>
						<th>고용보험적용여부(환급)</th>
						<td>
							<select id="laborApplyYn" name="laborApplyYn" validator="required" >
							    <option value="">선택</option>
								<option value="Y">YES</option>
								<option value="N">NO</option>
							</select>
						</td>
						<th><tit:txt mid='114147' mdef='환급금액'/></th>
						<td>
							<input type="text" id="laborMonView" name="laborMonView" class="text right w100p" />
							<input type="hidden" id="laborMon" name="laborMon" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</table>

			<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
			</div>
		</div>
	</div>
</form>
</body>
</html>
