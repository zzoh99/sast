<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='ceriAppDet' mdef='근로시간단축 신청 세부내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- <% request.setCharacterEncoding("UTF-8"); %> --%>

<script type="text/javascript">

	var searchApplSeq = "${searchApplSeq}";
	var searchApplCd = "${searchApplCd}";
	/* 단축근무유형 */
	var wtCd = "${wtCd}";
	var searchApplSabun = "${searchApplSabun}";
	var searchSabun = "${searchSabun}";
	var searchApplYmd = "${searchApplYmd}";
	var adminYn = "${adminYn}";
	var appTitle = "${appTitle}";
	var authPg = "${authPg}";
	var gPRow = "";
	var pGubun = "";
	var ssnSabun = "${ssnSabun}";

	$(function() {
		$("#swtStrH, #swtEndH").mask("9.9");

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='sabun' mdef='사번'/>",														Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='applSeq' mdef='신청서순번(thri103)'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='applCd' mdef='신청코드'/>",													Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='applYmd' mdef='신청일자'/>",												Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='joinYmd' mdef='입사일자'/>",												Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"joinYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='pregnancyYmd' mdef='임신일자'/>",											Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"pregnancyYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='dueDate' mdef='출산예정일'/>",											Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"dueDate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtApplyStrYmd' mdef='단축근무적용기간(근로자_시작)'/>",							Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtApplyStrYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtApplyEndYmd' mdef='단축근무적용기간(근로자_종료)'/>",							Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtApplyEndYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtCaStrYmd' mdef='단축근무적용기간(사업장 조정_시작)'/>",							Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtCaStrYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtCaEndYmd' mdef='단축근무적용기간(사업장 조정_종료)'/>",							Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtCaEndYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='gestatioYmd' mdef='임신주차(tsys005_WT9002)'/>",							Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"gestatioYmd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtStrH' mdef='출근단축시간'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtStrH",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtEndH' mdef='퇴근단축시간'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtEndH",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='appWorkHour' mdef='근로시간'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"appWorkHour",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='shortenHour' mdef='단축시간'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"shortenHour",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			/* {Header:"<sht:txt mid='swtStrH' mdef='단축근무시작시간(시)'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtStrH",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtStrM' mdef='단축근무시작시간(분)'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtStrM",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtEndH ' mdef='단축근무종료시간(시)'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtEndH",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtEndM' mdef='단축근무종료시간(분)'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtEndM",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }, */
   			{Header:"<sht:txt mid='approvalYn' mdef='신청자 인정 확인'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"approvalYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='childrenCd' mdef='신청자 자녀명 코드'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"childrenCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='childrenNm' mdef='신청자 자녀명'/>",											Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"childrenNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='birthYmd' mdef='신청자 자녀 생년월일'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"birthYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='childrenYear' mdef='신청자 자녀 학년'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"childrenYear",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='familyNm' mdef='신청자 가족명'/>",											Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"familyNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='familyRelations' mdef='신청자 가족관계'/>",									Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"familyRelations",		KeyField:0,	F0rmat:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='swtCaReason' mdef='단축근무 조정 사유'/>",										Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"swtCaReason",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='lookAfterReason' mdef='가족돌봄 사유(tsys005_WT9004)'/>",						Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"lookAfterReason",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='reason' mdef='사유'/>",													Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"reason",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='causeOfReturn' mdef='반려사유(tsys005_WT9003/num_note:1-육아, 2-가족돌봄)'/>",	Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"causeOfReturn",		KeyField:0,	F0rmat:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='replaceAction' mdef='대체조치(tsys005_WT9005) '/>",							Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"replaceAction",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='agreeSabun ' mdef='결재자사번'/>",											Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"agreeSabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='applStatusCd' mdef='상태 '/>",												Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

   			]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		parent.iframeOnLoad("0px");

		doAction1("Search");
	});

	$(function() {
		var dt = new Date();
	    var Year = dt.getFullYear();
	    var Month = "" + (dt.getMonth()+1);
	    var Day = "" + dt.getDate();

	    if(Month.length < 2) Month = "0" + Month;
	    if(Day.length < 2) Day = "0" + Day;

	    var chkDt = Year.toString() +'-'+ Month +'-'+ Day;

		var applCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getWorkingTypeCodeList&useYn=Y",""), "");

		sheet1.SetColProperty("applCd", {ComboText:applCd[0], ComboCode:applCd[1]} );

		$("#wtCd").html(applCd[2]);

		var gestatio = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGestatioList",false).codeList, " ");

		$("#gestatioYmd").html(gestatio[2]);

		/* 가족명 */
		var familyNm = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getFamilyList&sabun="+searchApplSabun,false).codeList, "");
		$("#familyNm").html(familyNm[2]);

		/* 자녀명 */
		var childrenCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getChildrenList&sabun="+searchApplSabun,false).codeList, "");
		$("#childrenCd").html(childrenCd[2]);
		$("#childrenNm").val($("#childrenCd option:selected").text());

		/* 사유 */
		var reason = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReasonList",false).codeList, "");
		$("#lookAfterReason").html(reason[2]);

		//출근단축시간.
		$("#swtStrH").focusout(function(){

			 var vnStrH = 0;

			 vnStrH = $(this).val();
			 if(vnStrH == null || vnStrH== ""){

					$(this).val("0");

			}else if(vnStrH.length < 3){

				 $(this).val(vnStrH.replace(".", ".0"));

				 if(vnStrH.length < 2){

					 $(this).val($(this).val() + ".0");

				 }

			 }

			if(vnStrH % 0.5 > 0){

				alert("시간은 1시간 또는 30분 단위로 입력이 가능합니다.\n ex> 1시간 - 1.0, 30분 - 0.5");
				$(this).val(null);
				return;
			}

			//임신기단축 시간제한 최대 2시간.
			if($("#wtCd").val() == 1){

				var vnEnd = $("#swtEndH").val();
				    vnStrH = $(this).val();

				    vnEnd*=1;
				    vnStrH*=1;

				if(vnEnd == null){

					vnEnd = 0;

				}

				if((vnStrH + vnEnd) > 2){

					alert("임신기 단축근무는 2시간 이상 사용하실 수 없습니다.");
					$(this).val(null);
					$("#swtEndH").val(null);
					$("#appWorkHour").val(null);
					return;
				}else{

					$("#appWorkHour").val(8-(vnStrH + vnEnd));

				}

			}else{
				//임신기 외 단축근무는 1일 최대 5시간까지 가능.
				var vnEnd = $("#swtEndH").val();
			    vnStrH = $(this).val();

			    vnEnd*=1;
			    vnStrH*=1;

				if(vnEnd == null){

					vnEnd = 0;

				}

				if((vnStrH + vnEnd) > 5){

					alert("단축근무는 5시간 이상 사용하실 수 없습니다.");
					$(this).val(null);
					$("#swtEndH").val(null);
					$("#appWorkHour").val(null);
					return;


				}else{

					$("#appWorkHour").val(8-(vnStrH + vnEnd));

				}

			}

		});


		//퇴근단축시간.
		$("#swtEndH").focusout(function(){

			 var vnEndH = 0;

			 vnEndH = $(this).val();

			if(vnEndH == null || vnEndH== ""){

				$(this).val("0");

			}else if(vnEndH.length < 3){

				 $(this).val(vnEndH.replace(".", ".0"));

				 if(vnEndH.length < 2){

					 $(this).val($(this).val() + ".0");

				 }

			 }

			if(vnEndH % 0.5 > 0){

				alert("시간은 1시간 또는 30분 단위로 입력이 가능합니다.\n ex> 1시간 - 1.0, 30분 - 0.5");
				$(this).val(null);
				return;
			}

			//임신기단축 시간제한 최대 2시간.
			if($("#wtCd").val() == 1){

				var vnStrH = $("#swtStrH").val();
				    vnEnd = $(this).val();

				    vnEnd*=1;
				    vnStrH*=1;

				if(vnEnd == null){

					vnEnd = 0;

				}

				if((vnStrH + vnEnd) > 2){

					alert("임신기 단축근무는 2시간 이상 사용하실 수 없습니다.");
					$(this).val(null);
					$("#swtStrH").val(null);
					$("#appWorkHour").val(null);
					return;


				}else{

					$("#appWorkHour").val(8-(vnStrH + vnEnd));

				}

			}else{
				//임신기 외 단축근무는 1일 최대 5시간까지 가능.
				var vnStrH = $("#swtStrH").val();
			    vnEnd = $(this).val();

			    vnEnd*=1;
			    vnStrH*=1;

				if(vnEnd == null){

					vnEnd = 0;

				}

				if((vnStrH + vnEnd) > 5){

					alert("단축근무는 5시간 이상 사용하실 수 없습니다.");
					$(this).val(null);
					$("#swtStrH").val(null);
					$("#appWorkHour").val(null);
					return;


				}else{

					$("#appWorkHour").val(8-(vnStrH + vnEnd));

				}

			}


		});


		/* 단축근무 적용기간 (조정)*/
		if(adminYn == 'Y'){
			$("#swtCaStrYmd, #swtCaEndYmd").attr('readonly', false);
			$("#swtCaStrYmd").datepicker2({

				onReturn:function(){

					var num = getDaysBetween(formatDate($("#swtCaStrYmd").val(),""),formatDate($("#swtCaEndYmd").val(),""));
					if(formatDate($("#swtCaStrYmd").val(),"") != "" && formatDate($("#swtCaEndYmd").val(),"") != "") {
						if(num <= 0) {
							alert("시작일이 종료일보다 큽니다.");
							$("#swtCaStrYmd").val("");
						}else{
							if($("#swtCaStrYmd").val() < chkDt) {
								alert("금일 이후로 신청해 주십시오.");
								$("#swtCaStrYmd").val("");
							}
						}
					}
				}
			});

			$("#swtCaEndYmd").datepicker2({
				onReturn:function(){

					var num = getDaysBetween(formatDate($("#swtCaStrYmd").val(),""),formatDate($("#swtCaEndYmd").val(),""));

					if(formatDate($("#swtCaStrYmd").val(),"") != "" && formatDate($("#swtCaEndYmd").val(),"") != "") {
						if(num <= 0) {
							alert("종료일이 시작일보다 작습니다.");
							$("#swtCaEndYmd").val("");
						}
					}
				}
			});
		}

		if(authPg == "A") {

			/* 단축근무 적용기간 */
			$("#swtApplyStrYmd").datepicker2({
				onReturn:function(){
					var num = getDaysBetween(formatDate($("#swtApplyStrYmd").val(),""),formatDate($("#swtApplyEndYmd").val(),""));
					if(formatDate($("#swtApplyStrYmd").val(),"") != "" && formatDate($("#swtApplyEndYmd").val(),"") != "") {
						if(num <= 0) {
							alert("시작일이 종료일보다 큽니다.");
							$("#swtApplyStrYmd").val("");
						}else{
							if($("#swtApplyStrYmd").val() < chkDt) {
								alert("금일 이후로 신청해 주십시오.");
								$("#swtApplyStrYmd").val("");
							}
						}
					}
				}
			});

			$("#swtApplyEndYmd").datepicker2({
				onReturn:function(){
					var num = getDaysBetween(formatDate($("#swtApplyStrYmd").val(),""),formatDate($("#swtApplyEndYmd").val(),""));
					if(formatDate($("#swtApplyStrYmd").val(),"") != "" && formatDate($("#swtApplyEndYmd").val(),"") != "") {
						if(num <= 0) {
							alert("종료일이 시작일보다 작습니다.");
							$("#swtApplyEndYmd").val("");
						}
					}
				}
			});

			/* 임신일자 */
			$("#pregnancyYmd").datepicker2({
				onReturn:function(){
					if($("#pregnancyYmd").val() > chkDt) {
						alert("임신일자(금일이전) 다시 입력해 주시기 바랍니다.");
						$("#pregnancyYmd").val("");
						$("#pregnancyWeek").val("");
					}


					var rtn = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonWeek","queryId=getCommonWeek&ymd="+$("#pregnancyYmd").val()+"&symd="+$("#swtApplyStrYmd").val(), false);
					if(rtn.chkWeek[0].week > 0){
						$("#pregnancyWeek").val(rtn.chkWeek[0].week);
						$("#pregnancyWeek12").val(rtn.chkWeek[0].week12);
					}


					if(rtn.chkWeek[0].week > 0 && rtn.chkWeek[0].week < 13){
						$("#gestatioYmd").val('1');
					}else if(rtn.chkWeek[0].week > 35){
						$("#gestatioYmd").val('2');
					}else{
						$("#gestatioYmd").val('3');
					}
				}
			});

			$("#dueDate").datepicker2({});


			/* 년월별 날짜조회 */
			$("#childrenCd").change( function() {
				$("#childrenNm").val($("#childrenCd option:selected").text()); 	//2022.12.05 자녀 2명 이상일 때, 대상자 선택 오류

				var famNm = encodeURI($("#childrenCd option:selected").text());

				var rtn = ajaxCall("${ctx}/WorkingTypeAppDet.do?cmd=getBirthYmd","queryId=getBirthYmd&famCd="+$("#childrenCd").val()+"&famNm="+famNm+"&sabun="+searchApplSabun, false);
				if(rtn.birthYmd.length > 0){
					if(rtn.birthYmd[0].codeNm != ""){
						var yyyymmdd = rtn.birthYmd[0].codeNm.substr(0,4) +"-"+ rtn.birthYmd[0].codeNm.substr(4,2) +"-"+ rtn.birthYmd[0].codeNm.substr(6,2);
						$("#birthYmd").val(yyyymmdd);
						$("#age").val(rtn.birthYmd[0].age);
						$("#childrenAge").val("(만 "+rtn.birthYmd[0].age +"세)");
					}
				}

			});

			/* 가족관계 조회 */
			$("#familyNm").change( function() {

				var rtn = ajaxCall("${ctx}/CommonCode.do?cmd=getFamilyRelations","queryId=getFamilyRelations&code="+$("#familyNm").val(), false);

				$("#familyRelationCd").val(rtn.familyRelation[0].code);
				$("#familyRelations").val(rtn.familyRelation[0].codeNm);
			});

			/* 단축근무유형 변경시 */
			$("#wtCd").change( function() {

				var vsChangeval = $(this).val();
				/* 임신기 */
				if(vsChangeval == 1){

					// parent.jQuery("#authorForm").height(620);

					var gestatio = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGestatioList",false).codeList, " ");

					$("#gestatioYmd").html(gestatio[2]);

					$("#applCd0201").hide();
					$("#applCd0202").hide();
					$("#applCd0301").hide();
					$(".applCd0302").hide();
					$("#applCd0303").hide();
					//$("#applCd0401").hide();

					$(".applCd0101").show();
					$("#applCd0401").show();
				}
				/* 육아기 */
				else if(vsChangeval == 2){

					// parent.jQuery("#authorForm").height(620);

					/* 자녀명 */
					var childrenCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getChildrenList&sabun="+searchApplSabun,false).codeList, "");
					$("#childrenCd").html(childrenCd[2]);

					$("#childrenNm").val(sheet1.GetCellText(sheet1.LastRow(),"childrenNm")); 	//2022.12.05 자녀 2명 이상일 때, 대상자 선택 오류

					var famNm = encodeURI($("#childrenCd option:selected").text());

					/* 생년월일 */
					var rtn = ajaxCall("${ctx}/WorkingTypeAppDet.do?cmd=getBirthYmd","queryId=getBirthYmd&famCd="+$("#childrenCd").val()+"&famNm="+famNm+"&sabun="+searchApplSabun, false);

					if(rtn.birthYmd.length > 0){
						if(rtn.birthYmd[0].codeNm != ""){
							var yyyymmdd = rtn.birthYmd[0].codeNm.substr(0,4) +"-"+ rtn.birthYmd[0].codeNm.substr(4,2) +"-"+ rtn.birthYmd[0].codeNm.substr(6,2);
							$("#birthYmd").val(yyyymmdd);
							$("#age").val(rtn.birthYmd[0].age);
							$("#childrenAge").val("(만 "+rtn.birthYmd[0].age +"세)");

						}
					}

					/* $("#birthD").html(gestatio[2]); */

					$(".applCd0101").hide();
					$("#applCd0301").hide();
					$(".applCd0302").hide();
					$("#applCd0303").hide();
					//$("#applCd0401").hide();

					$("#applCd0201").show();
					$("#applCd0202").show();

					$("#applCd0401").show();
				}
				/* 가족돌봄 */
				else if(vsChangeval == 3){

					parent.jQuery("#authorFrame").height(390);

					/* 가족명 */
					var familyNm = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getFamilyList&sabun="+searchApplSabun,false).codeList, "");
					$("#familyNm").html(familyNm[2]);

					/* 가족관계 */
					var rtn = ajaxCall("${ctx}/CommonCode.do?cmd=getFamilyRelations","queryId=getFamilyRelations&code="+$("#familyNm").val(), false);
					if(rtn.familyRelation[0].codeNm != ""){

						$("#familyRelationCd").val(rtn.familyRelation[0].code);
						$("#familyRelations").val(rtn.familyRelation[0].codeNm);
					}

					var reason = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReasonList",false).codeList, "");

					$("#lookAfterReason").html(reason[2]);

					$(".applCd0101").hide();
					$("#applCd0201").hide();
					$("#applCd0202").hide();
					$("#applCd0401").hide();

					$("#applCd0301").show();
					$(".applCd0302").show();
					$("#applCd0303").show();
				}
				/* 기타 */
				else if(vsChangeval == 4){

					// parent.jQuery("#authorForm").height(600);

					$(".applCd0101").hide();
					$("#applCd0201").hide();
					$("#applCd0202").hide();
					$("#applCd0301").hide();
					$(".applCd0302").hide();
					$("#applCd0303").hide();

					$("#applCd0401").show();
				}
			});
		}
	});



	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "applSeq="+searchApplSeq
						+"&wtCd="+wtCd
						+"&sabun="+searchApplSabun;

			sheet1.DoSearch( "${ctx}/WorkingTypeAppDet.do?cmd=getWorkingTypeAppDetList", param);
			break;
		}
	}

	//결재진행시(저장or반려)
	function adminDoSave2(obj){

		/* obj : 1 - 저장(기간수정시) / 2 - 반려처리시  */
		if(obj == '1'){
			if($("#swtCaStrYmd").val() == ""){
				alert("근무기간을 입력해 주십시오.");
				$("#swtCaStrYmd").focus();
				return 0;
			}

			if($("#swtCaEndYmd").val() == ""){
				alert("근무기간을 입력해 주십시오.");
				$("#swtCaEndYmd").focus();
				return 0;
			}

			if($("#swtCaReason").val() == ""){
				alert("조정사유를 입력해 주십시오.");
				$("#swtCaReason").focus();
				return 0;
			}
		}

		var row = sheet1.LastRow();

		/* 단축근무 적용기간 */
		sheet1.SetCellValue(row,"swtApplyStrYmd",$("#swtApplyStrYmd").val().replace(/-/gi,""));
		sheet1.SetCellValue(row,"swtApplyEndYmd",$("#swtApplyEndYmd").val().replace(/-/gi,""));

		/* 단축근무 적용시간 */
		sheet1.SetCellValue(row,"swtStrHm",$("#swtStrHm").val());
		sheet1.SetCellValue(row,"swtEndHm",$("#swtEndHm").val());
		/* sheet1.SetCellValue(row,"swtStrH",$("#shourH").val());
		sheet1.SetCellValue(row,"swtStrM",$("#shourM").val());
		sheet1.SetCellValue(row,"swtEndH",$("#ehourH").val());
		sheet1.SetCellValue(row,"swtEndM",$("#ehourM").val()); */

		/* 신청서순번(THRI103) */
		sheet1.SetCellValue(row,"applSeq",searchApplSeq);
		/* 신청코드 */
		sheet1.SetCellValue(row,"applCd",$("#wtCd").val());

		/* 단축근무 적용기간(전) */
		sheet1.SetCellValue(row,"swtCaStrYmd",$("#swtCaStrYmd").val());
		/* 단축근무 적용기간(후) */
		sheet1.SetCellValue(row,"swtCaEndYmd",$("#swtCaEndYmd").val());
		/* 조정사유 */
		sheet1.SetCellValue(row,"swtCaReason",$("#swtCaReason").val());

		/* 임신기 */
		if($("#wtCd").val() == 1){
			/* 임신일자 */
			sheet1.SetCellValue(row,"pregnancyYmd",$("#pregnancyYmd").val());

			//출산예정일
			sheet1.SetCellValue(row,"dueDate",$("#dueDate").val());

			/* 단축근무임신주차 */
			sheet1.SetCellValue(row,"gestatioYmd",$("#gestatioYmd").val());
		}
		/* 육아기 */
		else if($("#wtCd").val() == 2){

			if(obj == '2'){
				if($("#causeOfReturn").val() == ""){
					alert("반려사유를 입력해 주십시오.");
					$("#causeOfReturn").focus();
					return 0;
				}
			}

			/* 반려사유 */
			sheet1.SetCellValue(row,"causeOfReturn",$("#causeOfReturn").val());
		}
		/* 가족돌봄 */
		else if($("#wtCd").val() == 3){

			if(obj == '2'){
				if($("#causeOfReturn2").val() == ""){
					alert("반려사유를 입력해 주십시오.");
					$("#causeOfReturn2").focus();
					return 0;
				}
				if($("#replaceAction").val() == ""){
					alert("대체조치를 입력해 주십시오.");
					$("#replaceAction").focus();
					return 0;
				}
			}

			/* 반려사유 */
			sheet1.SetCellValue(row,"causeOfReturn",$("#causeOfReturn2").val());
			/* 대체조치 */
			sheet1.SetCellValue(row,"replaceAction",$("#replaceAction").val());
		}

		var saveStr = sheet1.GetSaveString(0);

		if(saveStr == ""){
			return 2;
		}

		if(saveStr.match("KeyFieldError")) {
			return false;
		}

		var rtn = eval("("+sheet1.GetSaveData("${ctx}/WorkingTypeAppDet.do?cmd=saveWorkingTypeAppDet", saveStr)+")");

		doAction1("Search");

		return 1;
	}

	//신청서 결재상태 설정
	function applSetting(obj){

		/* 임신기 */
		if(($('#wtCd').val() == 1 && $('#wtCd').val() == 4) || (wtCd == 1 && wtCd == 4)){
			/* 결재/승인 처리중일 경우 */
			if(obj == '21' || obj == '31' ){
				$("#etc0101").show();
			/* 결재/승인 반려일 경우 */
			}else if(obj == '23' || obj == '33' ){
				$("#etc0101").hide();
			}else{
				$("#etc0101").hide();
			}
		}

		/* 육아기 */
		else if(($('#wtCd').val() == 2) && (wtCd == 2)){

			/* 결재/승인 처리중일 경우 */
			if(obj == '21' || obj == '31' ){
				$("#etc0101").show();
				$("#etc0102").hide();
			/* 결재/승인 반려일 경우 */
			}else if(obj == '23' || obj == '33' ){
				$("#etc0102").show();
				$("#etc0101").hide();
			}else{
				$("#etc0101").hide();
				$("#etc0102").hide();
			}
		}

		/* 가족돌봄 */
		else if(($('#wtCd').val() == 3) || (wtCd == 3)){
			/* 결재/승인 처리중일 경우 */
			if(obj == '21' || obj == '31' ){
				$("#etc0101").show();
				$("#etc0103").hide();
			/* 결재/승인 반려일 경우 */
			}else if(obj == '23' || obj == '33' ){
				$("#etc0103").show();
				$("#etc0101").hide();
			}else{
				$("#etc0101").hide();
				$("#etc0103").hide();
			}
		}
	}



	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {

		try {
			if (Msg != "") {
				alert(Msg);
			}

			/* 공통 */
			/* 신청유형 */
			if(sheet1.GetCellText(sheet1.LastRow(),"applCd") === '') {
				$("#wtCd").prop("selectedIndex", 0);
				$("#wtCd").change();
			} else {
				$("#wtCd").val(sheet1.GetCellText(sheet1.LastRow(),"applCd"));
			}
			/* 신청일자 */
			$("#applYmd").val(sheet1.GetCellText(sheet1.LastRow(),"applYmd"));
			/* 입사일자 */
			$("#joinYmd").val(sheet1.GetCellText(sheet1.LastRow(),"joinYmd"));
			/* 단축근무적용기간 */
			$("#swtApplyStrYmd").val(sheet1.GetCellText(sheet1.LastRow(),"swtApplyStrYmd"));
			/* 단축근무적용기간 */
			$("#swtApplyEndYmd").val(sheet1.GetCellText(sheet1.LastRow(),"swtApplyEndYmd"));
			/* 단축근무시작시간(시) */
			$("#swtStrH").val(sheet1.GetCellText(sheet1.LastRow(),"swtStrH"));
			/* 단축근무시작시간(분) */
			$("#swtEndH").val(sheet1.GetCellText(sheet1.LastRow(),"swtEndH"));

			if($("#swtStrH").val() != "" || $("#swtEndH").val() != ""){
				$("#appWorkHour").val(8-(Number($("#swtStrH").val()) + Number($("#swtEndH").val())));
			}

			/* 임신기, 육아기일때 상세사유 추가 페타시스 윤규미 20210225 by ktw*/
			if($("#wtCd").val() == 1 || $("#wtCd").val() == 2){
				$("#reason2").val(sheet1.GetCellText(sheet1.LastRow(),"reason"));
			}

			/* 단축근무종료시간(시) */
			/* $("#ehourH").val(sheet1.GetCellText(sheet1.LastRow(),"swtEndH")); */
			/* 단축근무종료시간(분) */
			/* $("#ehourM").val(sheet1.GetCellText(sheet1.LastRow(),"swtEndM")); */

			if(wtCd == null || wtCd == "" ){
				wtCd = sheet1.GetCellText(sheet1.LastRow(),"applCd");
			}

			if(sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "11"){
				$("#swtCaStrYmd").val(sheet1.GetCellText(sheet1.LastRow(),"swtCaStrYmd"));
				$("#swtCaEndYmd").val(sheet1.GetCellText(sheet1.LastRow(),"swtCaEndYmd"));

				/* 조정사유 */
				$("#swtCaReason").val(sheet1.GetCellText(sheet1.LastRow(),"swtCaReason"));
			}


			/* 근무적용기간 조정 */
			/* if(ssnSabun == sheet1.GetCellText(sheet1.LastRow(),"agreeSabun")){ */
			if(adminYn == 'N' && ssnSabun != sheet1.GetCellText(sheet1.LastRow(),"agreeSabun")){

				/* 공통 */
				$("#swtCaReason").attr("disabled",true).attr("readonly",false);

				/* 육아기 */
				if(wtCd == 2){
					$("#causeOfReturn").attr("disabled",true).attr("readonly",false);
				}

				/* 가족돌봄 */
				if(wtCd == 3){
					$("#causeOfReturn2").attr("disabled",true).attr("readonly",false);
					$("#replaceAction").attr("disabled",true).attr("readonly",false);
				}
			}else if(adminYn == 'N' && ssnSabun == sheet1.GetCellText(sheet1.LastRow(),"agreeSabun")){

				var dt = new Date();
			    var Year = dt.getFullYear();
			    var Month = "" + (dt.getMonth()+1);
			    var Day = "" + dt.getDate();

			    if(Month.length < 2) Month = "0" + Month;
			    if(Day.length < 2) Day = "0" + Day;

			    var chkDt = Year.toString() +'-'+ Month +'-'+ Day;


				$("#swtCaStrYmd").datepicker2({

					onReturn:function(){

						var num = getDaysBetween(formatDate($("#swtCaStrYmd").val(),""),formatDate($("#swtCaEndYmd").val(),""));
						if(formatDate($("#swtCaStrYmd").val(),"") != "" && formatDate($("#swtCaEndYmd").val(),"") != "") {

							if(num <= 0) {
								alert("시작일이 종료일보다 큽니다.");
								$("#swtCaStrYmd").val("");
							}else{
								if($("#swtCaStrYmd").val() < chkDt) {
									alert("금일 이후로 신청해 주십시오.");
									$("#swtCaStrYmd").val("");
								}
							}
						}
					}
				});

				$("#swtCaEndYmd").datepicker2({
					onReturn:function(){

						var num = getDaysBetween(formatDate($("#swtCaStrYmd").val(),""),formatDate($("#swtCaEndYmd").val(),""));

						if(formatDate($("#swtCaStrYmd").val(),"") != "" && formatDate($("#swtCaEndYmd").val(),"") != "") {
							if(num <= 0) {
								alert("종료일이 시작일보다 작습니다.");
								$("#swtCaEndYmd").val("");
							}
						}
					}
				});
			}

			/* 임신기 */
			if(wtCd == 1){
				if(sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "" && sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "11"){
					// parent.jQuery("#authorFrame").height(300);
					$("#etc0101").show();
				}

				/* 임신일자 */
				$("#pregnancyYmd").val(sheet1.GetCellText(sheet1.LastRow(),"pregnancyYmd"));
				/* 출산예정일*/
				$("#dueDate").val(sheet1.GetCellText(sheet1.LastRow(),"dueDate"));

				/* 단순근무임신주차 */
				$("#gestatioYmd").val(sheet1.GetCellText(sheet1.LastRow(),"gestatioYmd"));

				/* 임신주차 */
				var ret = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonWeek","queryId=getCommonWeek&ymd="+$("#pregnancyYmd").val()+"&symd="+$("#swtApplyStrYmd").val(), false);

				if(ret.chkWeek[0].week > 0){
					$("#pregnancyWeek").val(ret.chkWeek[0].week);
					$("#pregnancyWeek12").val(ret.chkWeek[0].week12);

				}

				$("#gestatioYmd").attr("disabled",true).attr("readonly",false);

				$("#applCd0201").hide();
				$("#applCd0202").hide();
				$("#applCd0301").hide();
				$(".applCd0302").hide();
				$("#applCd0303").hide();
				//$("#applCd0401").hide();

				$(".applCd0101").show();

				$("#applCd0401").show();
			}

			/* 육아기 */
			else if(wtCd == 2){
				if(sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "" && sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "11"){
					// parent.jQuery("#authorFrame").height(340);
					$("#etc0101").show();
					$("#etc0102").show();
				}else{
					// parent.jQuery("#authorForm").height(620);
				}


				/* 반려 사유 */
				var causeOfReturn = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCauseOfReturnList",false).codeList, " ");
				$("#causeOfReturn").html(causeOfReturn[2]);

				/* 반려사유 */
				if(sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "11"){
					$("#causeOfReturn").val(sheet1.GetCellText(sheet1.LastRow(),"causeOfReturn"));
				}

				/* 자녀명 */ //2022.12.05 자녀 2명 이상일 때, 대상자 선택 오류
				var childrenNm =  encodeURIComponent(sheet1.GetCellText(sheet1.LastRow(),"childrenNm"));
				var childrenCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getChildrenList&sabun="+searchApplSabun+"&childrenNm="+childrenNm,false).codeList, "");

				$("#childrenCd").html(childrenCd[2]);

				$("#childrenCd").val(sheet1.GetCellText(sheet1.LastRow(),"childrenCd"));

				/* 자녀명 */
				$("#childrenNm").val(sheet1.GetCellText(sheet1.LastRow(),"childrenNm")); 	//2022.12.05 자녀 2명 이상일 때, 대상자 선택 오류

				/* 학년 */
				$("#childrenYear").val(sheet1.GetCellText(sheet1.LastRow(),"childrenYear"));

				/* 생년월일 */
				$("#birthYmd").val(sheet1.GetCellText(sheet1.LastRow(),"birthYmd"));

				//var famNm = encodeURI($("#childrenCd option:selected").text());
				var famNm = sheet1.GetCellText(sheet1.LastRow(),"childrenNm");				//2022.12.05 자녀 2명 이상일 때, 대상자 선택 오류

				var rtn = ajaxCall("${ctx}/WorkingTypeAppDet.do?cmd=getBirthYmd","queryId=getBirthYmd&famCd="+$("#childrenCd").val()+"&famNm="+famNm+"&sabun="+searchApplSabun, false);
				if(rtn.birthYmd.length > 0){
					if(rtn.birthYmd[0].age != ""){
						var yyyymmdd = rtn.birthYmd[0].codeNm.substr(0,4) +"-"+ rtn.birthYmd[0].codeNm.substr(4,2) +"-"+ rtn.birthYmd[0].codeNm.substr(6,2);
						$("#birthYmd").val(yyyymmdd);
						$("#age").val(rtn.birthYmd[0].age);
						$("#childrenAge").val("(만 "+rtn.birthYmd[0].age +"세)");
					}
				}

				/* $("#birthY").val(sheet1.GetCellText(sheet1.LastRow(),"birthYmd").substr(0,4));
				$("#birthM").val(sheet1.GetCellText(sheet1.LastRow(),"birthYmd").substr(4,2));
				$("#birthD").prepend("<option value=''>"+sheet1.GetCellText(sheet1.LastRow(),"birthYmd").substr(6,2)+"</option>"); */


				if(sheet1.GetCellText(sheet1.LastRow(),"approvalYn") == 'Y'){
					$("input:checkbox[id='approvalYn']").prop("checked", true);
				}

				$(".applCd0101").hide();
				$("#applCd0301").hide();
				$(".applCd0302").hide();
				$("#applCd0303").hide();
				//$("#applCd0401").hide();

				$("#applCd0201").show();
				$("#applCd0202").show();

				$("#applCd0401").show();
			}

			/* 가족돌봄 */
			else if(wtCd == 3){

				if(sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "" && sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "11"){
					// parent.jQuery("#authorFrame").height(390);
					$("#etc0101").show();
					$("#etc0103").show();
				}else{
					// parent.jQuery("#authorForm").height(650);
				}

				/* 반려 사유 */
				var causeOfReturn2 = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCauseOfReturnList2",false).codeList, " ");
				$("#causeOfReturn2").html(causeOfReturn2[2]);

				/* 대체 조치 */
				var replaceAction = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReplaceActionList",false).codeList, " ");
				$("#replaceAction").html(replaceAction[2]);


				if(sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "11"){
					/* 반려사유 */
					$("#causeOfReturn2").val(sheet1.GetCellText(sheet1.LastRow(),"causeOfReturn"));
					/* 대체조치 */
					$("#replaceAction").val(sheet1.GetCellText(sheet1.LastRow(),"replaceAction"));
				}


				/* 가족명 */
				$("#familyNm").val(sheet1.GetCellText(sheet1.LastRow(),"familyNm"));

				/* 가족관계 */
				var rtn = ajaxCall("${ctx}/CommonCode.do?cmd=getFamilyRelations","queryId=getFamilyRelations&code="+$("#familyNm").val(), false);
				if(rtn.familyRelation[0].codeNm != ""){

					$("#familyRelations").val(rtn.familyRelation[0].codeNm);
				}

				/* 사유 */
				$("#lookAfterReason").val(sheet1.GetCellText(sheet1.LastRow(),"lookAfterReason"));

				/* 상세사유 */
				$("#reason").val(sheet1.GetCellText(sheet1.LastRow(),"reason"));


				if(sheet1.GetCellText(sheet1.LastRow(),"approvalYn") == 'Y'){
					$("input:checkbox[id='approvalYn2']").prop("checked", true);
				}

				$(".applCd0101").hide();
				$("#applCd0201").hide();
				$("#applCd0202").hide();
				$("#applCd0401").hide();

				$("#applCd0301").show();
				$(".applCd0302").show();
				$("#applCd0303").show();
			}

			/* 기타 */
			else if(wtCd == 4){

				if(sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "" && sheet1.GetCellText(sheet1.LastRow(),"applStatusCd") != "11"){
					// parent.jQuery("#authorFrame").height(300);
					$("#etc0101").show();
				}else{
					// parent.jQuery("#authorForm").height(600);
				}

				/* 상세사유 */
				$("#reason2").val(sheet1.GetCellText(sheet1.LastRow(),"reason"));

				$(".applCd0101").hide();
				$("#applCd0201").hide();
				$("#applCd0202").hide();
				$("#applCd0301").hide();
				$(".applCd0302").hide();
				$("#applCd0303").hide();

				$("#applCd0401").show();
			}


			if(parent.$("#statusCd").val() != null){
				applSetting(parent.$("#statusCd").val());
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//신청 클릭시 체크
	function setValue(){
		var saveStr;
		var rtn;

		try{
			if(adminYn == "Y"){
				if("${ssnGrpCd}" == "10" || "${ssnGrpCd}" == "14"){
					authPg = "A";
				}
			}
			authPg = "A";
			if(authPg == "A") {

				/* 공통 */
				if($("#swtApplyEndYmd").val() == ""){
					alert("단축근무 적용기간 종료일자를 입력해 주십시오.");
					$("#swtApplyEndYmd").focus();
					return;
				}



				/* 임신기 */
				if($("#wtCd").val() == 1){
					var vnPregnancyWeek = 0;

					//var vsSwtStrYmd       = $("#swtApplyStrYmd").val().replace(/-/gi,"");
					var vsSwtEndYmd       = $("#swtApplyEndYmd").val().replace(/-/gi,"");
					var vsPregnancyWeek12 = $("#pregnancyWeek12").val().replace(/-/gi,"");

					vnPregnancyWeek = Number($("#pregnancyWeek").val());



					if($("#pregnancyYmd").val() == ""){
						alert("임신일자를 입력해 주십시오.");
						$("#pregnancyYmd").focus();
						return;
					}

					if( 12 < vnPregnancyWeek && vnPregnancyWeek <= 35){
					   alert("임신기 단축신청은 \n임신주차가 12주이내 36주 이후로 사용가능합니다.");
					   return;
					}


					if(vnPregnancyWeek <= 12 && vsSwtEndYmd > vsPregnancyWeek12){
					   alert("12주 이내 임신기의 경우 \n임신일자로 부터 12주이내로 사용가능합니다." + "\n ("+vsPregnancyWeek12+"까지 사용가능.)");
					   return;
					}
				}

				/* 육아기 */
				else if($("#wtCd").val() == 2){

					//최소신청일자 체크  90일(3개월)이상 신청.
					var vsSwtStrYmd       = $("#swtApplyStrYmd").val().split("-");
					var vsSwtEndYmd       = $("#swtApplyEndYmd").val().split("-");

					var vsStartDate = new Date(vsSwtStrYmd[0], vsSwtStrYmd[1]-1, vsSwtStrYmd[2]);
					var vsEndDate   = new Date(vsSwtEndYmd[0], vsSwtEndYmd[1]-1, vsSwtEndYmd[2]);

					var calDate     = (vsEndDate.getTime() - vsStartDate.getTime())/ 1000 /60 / 60 / 24;


					if($("#childrenYear").val() == "" && $("#age").val() > 8){
						alert("학년을 입력해 주십시오.");
						$("#childrenYear").focus();
						return;
					}

					if($("input:checkbox[id='approvalYn']").is(":checked") == false){
						alert("확인란에 체크해 주십시오.");
						return;
					}

					if(calDate <= 90){
						alert("육아기 단축신청은 최소 90일 이상 신청 해주셔야 합니다.");
						return;

					}
				}

				/* 가족돌봄 */
				else if($("#wtCd").val() == 3){

					if($("#reason").val() == ""){
						alert("상세사유 입력해 주십시오.");
						$("#reason").focus();
						return;
					}

					if($("input:checkbox[id='approvalYn2']").is(":checked") == false){
						alert("확인란에 체크해 주십시오.");
						return;
					}
				}

				/* 기타 */
				else if($("#wtCd").val() == 4){

					if($("#reason2").val() == ""){
						alert("상세사유 입력해 주십시오.");
						$("#reason2").focus();
						return;
					}
				}

				var row = sheet1.LastRow();

				/* 단축근무 적용기간 */
				sheet1.SetCellValue(row,"swtApplyStrYmd",$("#swtApplyStrYmd").val().replace(/-/gi,""));
				sheet1.SetCellValue(row,"swtApplyEndYmd",$("#swtApplyEndYmd").val().replace(/-/gi,""));

				if($("#swtStrH").val() == null || $("#swtStrH").val() == ""){

					$("#swtStrH").val("0");

				}

				if($("#swtEndH").val() == null || $("#swtEndH").val() == ""){

					$("#swtEndH").val("0");

				}

				if(Number($("#swtStrH").val()) == 0 && Number($("#swtEndH").val()) == 0){

				    alert("단축근무 적용시간을 입력해주세요.");
				    $("#swtStrH").focus();
					return;

				}

				/* 단축근무 적용시간 */
				sheet1.SetCellValue(row,"swtStrH",$("#swtStrH").val());
				sheet1.SetCellValue(row,"swtEndH",$("#swtEndH").val());

				var vnStrH = 0;
				var vnEndH = 0;

				vnStrH = Number($("#swtStrH").val());
				vnEndH = Number($("#swtEndH").val());

				sheet1.SetCellValue(row,"appWorkHour",$("#appWorkHour").val());
				sheet1.SetCellValue(row,"shortenHour",vnStrH+vnEndH);

				/* sheet1.SetCellValue(row,"swtStrH",$("#shourH").val());
				sheet1.SetCellValue(row,"swtStrM",$("#shourM").val());
				sheet1.SetCellValue(row,"swtEndH",$("#ehourH").val());
				sheet1.SetCellValue(row,"swtEndM",$("#ehourM").val()); */

				/* 신청서순번(THRI103) */
				sheet1.SetCellValue(row,"applSeq",searchApplSeq);
				/* 신청코드 */
				sheet1.SetCellValue(row,"applCd",$("#wtCd").val());

				/* 임신기 */
				if($("#wtCd").val() == 1){

					/* 임신일자 */
					sheet1.SetCellValue(row,"pregnancyYmd",$("#pregnancyYmd").val());

					//출산예정일
					sheet1.SetCellValue(row,"dueDate", $("#dueDate").val());

					/* 단축근무임신주차 */
					sheet1.SetCellValue(row,"gestatioYmd",$("#gestatioYmd").val());

					//상세사유 추가 20210224 by ktw 페타 윤규미 요청
					sheet1.SetCellValue(row,"reason",$("#reason2").val());

					if(sheet1.GetCellText(row,"applStatusCd") == "11"){
						sheet1.SetCellValue(row,"sStatus",'U');
						sheet1.SetCellValue(row,"swtCaStrYmd",'');
						sheet1.SetCellValue(row,"swtCaEndYmd",'');
						sheet1.SetCellValue(row,"swtCaReason",'');
					}

				}
				/* 육아기 */
				else if($("#wtCd").val() == 2){
					/* 자녀명 */
					sheet1.SetCellValue(row,"childrenCd",$("#childrenCd").val());
					sheet1.SetCellValue(row,"childrenNm",$("#childrenNm").val());

					//alert("육아기는 2" + $("#wtCd").val());
					//alert("#childrenNm.val : " + $("#childrenNm").val());
					//alert("childrenNm sheet : " + sheet1.GetCellValue(row,"childrenNm"));

					/* 학년 */
					sheet1.SetCellValue(row,"childrenYear",$("#childrenYear").val());

					//상세사유 추가 20210224 by ktw 페타 윤규미 요청
					sheet1.SetCellValue(row,"reason",$("#reason2").val());

					/* 생년월일 */
					/* var dd;

					if($("#birthD").val() < 10){
						dd = "0"+$("#birthD").val();
					}else{
						dd = $("#birthD").val();
					}

					var birthDt = $("#birthY").val() + $("#birthM").val() + dd; */

					sheet1.SetCellValue(row,"birthYmd",$("#birthYmd").val());

					/* 확인여부 */
					sheet1.SetCellValue(row,"approvalYn",$("#approvalYn").val());

					if(sheet1.GetCellText(row,"applStatusCd") == "11"){
						sheet1.SetCellValue(row,"sStatus",'U');
						sheet1.SetCellValue(row,"swtCaStrYmd",'');
						sheet1.SetCellValue(row,"swtCaEndYmd",'');
						sheet1.SetCellValue(row,"swtCaReason",'');
						sheet1.SetCellValue(row,"causeOfReturn",'');
					}

				}
				/* 가족돌봄 */
				else if($("#wtCd").val() == 3){
					/* 가족명 */
					sheet1.SetCellValue(row,"familyNm",$("#familyNm").val());

					/* 가족관계 */
					sheet1.SetCellValue(row,"familyRelations",$("#familyRelationCd").val());

					/* 사유 */
					sheet1.SetCellValue(row,"lookAfterReason",$("#lookAfterReason").val());

					/* 사유 */
					sheet1.SetCellValue(row,"reason",$("#reason").val());

					/* 확인여부 */
					sheet1.SetCellValue(row,"approvalYn",$("#approvalYn2").val());

					if(sheet1.GetCellText(row,"applStatusCd") == "11"){
						sheet1.SetCellValue(row,"sStatus",'U');
						sheet1.SetCellValue(row,"swtCaStrYmd",'');
						sheet1.SetCellValue(row,"swtCaEndYmd",'');
						sheet1.SetCellValue(row,"swtCaReason",'');
						sheet1.SetCellValue(row,"causeOfReturn",'');
						sheet1.SetCellValue(row,"replaceAction",'');
					}

				}
				/* 기타 */
				else if($("#wtCd").val() == 4){
					/* 사유 */
					sheet1.SetCellValue(row,"reason",$("#reason2").val());

					if(sheet1.GetCellText(row,"applStatusCd") == "11"){
						sheet1.SetCellValue(row,"sStatus",'U');
						sheet1.SetCellValue(row,"swtCaStrYmd",'');
						sheet1.SetCellValue(row,"swtCaEndYmd",'');
						sheet1.SetCellValue(row,"swtCaReason",'');
					}
				}

				//유연근무 사용체크....
				/*
				var rtn = ajaxCall("${ctx}/WorkingTypeAppDet.do?cmd=getFlexChk","queryId=getFlexChk&swtApplyStrYmd="+$("#swtApplyStrYmd").val().replace(/-/gi,"")+"&swtApplyEndYmd="+$("#swtApplyEndYmd").val().replace(/-/gi,"")+"&sabun="+searchApplSabun, false);

				if(rtn.flexChk[0].auto > 0 || rtn.flexChk[0].diff > 0 || rtn.flexChk[0].elas > 0){
                    alert("현재 유연근무제를 사용 중 입니다. \n유연근무 종료후 신청해주세요. \n(인사담당자에게 문의바랍니다.)");
					return false;
				}
				*/
				saveStr = sheet1.GetSaveString(0);

				if(saveStr.match("KeyFieldError")) {
					return false;
				}

				rtn = eval("("+sheet1.GetSaveData("${ctx}/WorkingTypeAppDet.do?cmd=saveWorkingTypeAppDet", saveStr)+")");

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					return false;
				}

				sheet1.LoadSaveData(rtn);

			}

		} catch (ex){
			alert("저장중 스크립트 오류발생." + ex);
			return false;
		}

		return true;
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "" || strDate == null) {
			return "";
		}

		try {
			if(strDate.length == 10) {
				return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
			} else if(strDate.length == 8) {
				return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
			} else {
				return "";
			}
		} catch(e) {
			return "";
		}
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='ceriAppDet' mdef='근로시간단축 신청'/></li>
		</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default">
		<colgroup>
			<col width="15%" />
			<col width="35%" />
			<col width="15%" />
		</colgroup>

		<tr>
			<th><tit:txt mid='104102' mdef='신청일자'/></th>
			<td>
				<input id="applYmd" name="applYmd" style="border:none; background-color:white;" disabled="disabled"/>
			</td>
			<th><tit:txt mid='104102' mdef='입사일자'/></th>
			<td>
				<input id="joinYmd" name="joinYmd" style="border:none; background-color:white;" disabled="disabled"/>
			</td>
		</tr>

		<tr>
			<th><tit:txt mid='104102' mdef='단축근무유형'/></th>
			<td colspan="5">
				<select id=wtCd name="wtCd" ${selectDisabled} style="width: 300px;"></select>
			</td>
		</tr>

		<tr>
			<th><tit:txt mid='104102' mdef='단축근무 적용기간<br>(근로자 신청)'/></th>

			<td colspan="3">
				<input id="swtApplyStrYmd" name="swtApplyStrYmd" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>  &nbsp;~&nbsp;
				<input id="swtApplyEndYmd" name="swtApplyEndYmd" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104102' mdef='출근단축 적용시간'/></th>
			<td>
				<input type="text" id="swtStrH" name="swtStrH" class="text w40 center required" ${disabled} validator="required" maxlength="3" />
			</td>
		    <th><tit:txt mid='104102' mdef='퇴근단축 적용시간'/>
		    </th>
		    <td>
		    <input type="text" id="swtEndH" name="swtEndH" class="text w40 center required" ${disabled} validator="required" maxlength="3"/>
		    &nbsp;/&nbsp;
		         <strong>예상근로시간</strong>&nbsp;:&nbsp;
		    <input id="appWorkHour" name="appWorkHour" type="text" size="10" class="text w40 center required  ${readonly}" validator="required" maxlength="3" readonly/>
		    </td>
		</tr>
		<tr id="etc0101" style="display: none">
			<th><span style="background-color:yellow; font-size: 10px">단축근무 적용기간<br>(사업장 조정)</span></th>
			<td>
				<input id="swtCaStrYmd" name="swtCaStrYmd" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>  &nbsp;~&nbsp;
				<input id="swtCaEndYmd" name="swtCaEndYmd" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>
			</td>
			<th><span style="background-color:yellow; font-size: 10px">조정사유</span></th>
			<td>
				<input id="swtCaReason" name="swtCaReason" type="text" size="38" />
			</td>
		</tr>
		<tr class="applCd0101">
			<th><tit:txt mid='104102' mdef='임신일자 / 출산예정일'/></th>
			<td colspan="3">
				<input id="pregnancyYmd" name="pregnancyYmd" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>

				<input id="pregnancyWeek12" name="pregnancyWeek12" type="hidden" />
				<input id="pregnancyWeek" name="pregnancyWeek" type="text" size="5" style="border:none;" />

				 &nbsp;주/ &nbsp;

				<input id="dueDate" name="dueDate" type="text" size="10" class="${dateCss} required ${readonly}" readonly/>
			</td>
		</tr>
		<tr class="applCd0101">
			<th><tit:txt mid='104102' mdef='단순근무임신주차'/></th>
			<td>
				<select id="gestatioYmd" name="gestatioYmd" ${selectDisabled} ></select>
			</td>
		</tr>

		<tr id="applCd0201">
			<th><tit:txt mid='104102' mdef='자녀명 / 학년'/></th>
			<td>
				<%-- <input id="childrenNm" name="childrenNm" ${selectDisabled} type="text" style="width: 111px;">  &nbsp;/&nbsp; --%>
				<input id="childrenNm" name="childrenNm" type="hidden">
				<select id=childrenCd name="childrenCd" ${selectDisabled} ></select> &nbsp;/&nbsp;
				<select id="childrenYear" name="childrenYear" ${selectDisabled} style="width: 45px;"/>
					<option value=""></option>
					<c:forEach var="i" begin="1" end="2" step="1">
						<option value="${i}">${i}</option>
					</c:forEach>
				</select>
			</td>
			<th><tit:txt mid='104102' mdef='생년월일'/></th>
			 <td>
			 	<input id="birthYmd" name="birthYmd" size="10" style="border:none; background-color:white;" disabled="disabled"/>
			 	<input id="childrenAge" name="childrenAge" type="text" size="10" style="border:none;" disabled="disabled"/>
			 	<input id="age" name="age" type="hidden"/>
			</td>
		</tr>
		<tr id="applCd0301">
			<th><tit:txt mid='104102' mdef='가족명'/></th>
			<td>
				<select id="familyNm" name="familyNm" ${selectDisabled} ></select>
			</td>
			<th><tit:txt mid='104102' mdef='가족관계'/></th>
			<td>
				<input id="familyRelations" name="familyRelations" type="text" size="10" style="border:none;" />
				<input id="familyRelationCd" name="familyRelationCd" type="hidden" />
			</td>
		</tr>
		<tr class="applCd0302">
			<th><tit:txt mid='104102' mdef='사유'/></th>
			<td>
				<select id="lookAfterReason" name="lookAfterReason" ${selectDisabled} ></select>
			</td>
		</tr>
		<tr class="applCd0302">
			<th><tit:txt mid='104102' mdef='상세사유'/></th>
			<td colspan="3">
				<input id="reason" name="reason" type="text" ${selectDisabled} size="38" />
				<span id="applCd0303" class="check-wrap">
					<input id="approvalYn2" name="approvalYn2" type="checkbox" value="Y" ${disabled}>
					<span>해당 대상자를 돌볼 수 있는 다른 가족이 없음을 확인합니다.</span>
				</span>
			</td>
		</tr>

		<tr id="applCd0401">
			<th><tit:txt mid='104102' mdef='상세사유'/></th>
			<td colspan="3">
				<input id="reason2" name="reason2" type="text" ${selectDisabled} style="width: 98%;"/>
				<span id="applCd0202" class="check-wrap">
					<input id="approvalYn" name="approvalYn" type="checkbox" value="Y" ${disabled}>
					<span>위 자녀에 대해서 배우자가 육아휴직 중이 아님을 확인합니다.</span>
				</span>
			</td>
		</tr>

		<tr id="etc0102" style="display: none">
			<th><span style="background-color:yellow; font-size: 10px">반려 사유</span></th>
			<td colspan="3">
				<select id="causeOfReturn" name="causeOfReturn" ></select>
			</td>
		</tr>
		<tr id="etc0103" style="display: none">
			<th><span style="background-color:yellow; font-size: 10px">반려 사유</span></th>
			<td>
				<select id="causeOfReturn2" name="causeOfReturn2" >
				<option value=""></option></select>
			</td>
			<th><span style="background-color:yellow; font-size: 10px">대체 조치</span></th>
			<td>
				<select id="replaceAction" name="replaceAction" ></select>
			</td>
		</tr>
	</table>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>

	<div id="" class="popup_button">
		<ul>
			<li>
				<a id="adminBtn" href="javascript:adminDoSave();" class="pink large" style="display:none">저장</a>
			</li>
		</ul>
	</div>
</div>
</body>
</html>
