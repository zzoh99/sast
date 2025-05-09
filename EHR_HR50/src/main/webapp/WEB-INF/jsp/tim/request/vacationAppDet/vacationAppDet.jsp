<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='vacationAppDet1' mdef='근태신청 세부내역'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var searchApplSeq    = "${searchApplSeq}";
	var adminYn          = "${adminYn}";
	var authPg           = "${authPg}";
	var searchSabun      = "${searchSabun}";
	var searchApplSabun  = "${searchApplSabun}";
	var searchApplInSabun= "${searchApplInSabun}";
	var searchApplYmd    = "${searchApplYmd}";
	var applStatusCd	 = "";
	var pGubun         = "";
	var gPRow = "";
	var codeLists;

	//0.5신청여부
	var halfYn = "N" ;
	var iframeHeight = 220;  /* 신청상세 iframe 높이 */

	$(function() {
		parent.iframeOnLoad(iframeHeight);  //220px보다 작으면 달력이 짤림.
		//----------------------------------------------------------------
		$("#searchSabun").val(searchSabun);
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}
		//----------------------------------------------------------------

		//유저 데이터
		//var user = ajaxCall("${ctx}/GetDataMap.do?cmd=getVacationAppDetUserMap","searchSabun="+searchApplSabun+"&searchApplYmd="+searchApplYmd ,false);

		//근태코드
		var params = "";
		if(authPg == "A"){ //신청,임시저장일 때는 근태신청 가능한 코드만 가져옴.
			params = "&searchAppYn=Y";
		}

		//근태종류  콤보
		var gntGubunCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getVacationAppDetGntGubunList", false).codeList
							, "gntUse"
							, "");
		$("#gntGubunCd").html(gntGubunCdList[2]);

		//경조구분 콤보
		var param = "&searchApplSabun=" + $("#searchApplSabun").val();
		var occFamCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getVacationAppDetOccCd" + param, false).codeList
		                 , "occHoliday,occCd,famCd,timAppDesc"
				         , "선택하세요");
		$("#occFamCd").html(occFamCdList[2]);

		if(authPg == "A") {
			$("#reqSHm").mask("11:11") ;
			$("#reqEHm").mask("11:11") ;

			$("#sYmd").datepicker2({
				onReturn: function(date) {
					$("#eYmd").val("");
					dateCheck(this);
				}
			});
			$("#eYmd").datepicker2({
				enddate:"sYmd",
				onReturn: function(date) {
					dateCheck(this);
					initUseTargetAnnual();
				}
			});
			$("#sYmd, #eYmd").bind("blur", function() {
				dateCheck(this); 
			});

			$("#applYmd").datepicker2({
				onReturn: function() {
					hourCheck(); 
					initUseTargetAnnual();
				}
			});
			
			$("#occYmd").datepicker2({
				onReturn: function() {
				}
			});
			
			
			$("#applYmd").bind("blur", function(){ 
				hourCheck(); 
			});
			$("#reqSHm, #reqEHm").bind("blur", function() {
				/*
				var reqUseType = $("#gntCd option:selected").attr("requestUseType");
				var gntUse     = getAttr("gntGubunCd", "gntUse");
				var baseCnt    = getAttr("gntCd", "baseCnt");
				
				// 시작시간 입력 시 종료시간 자동 입력
				if( $(this).attr("id") == "reqSHm" && $(this).val() != "" ) {
					// 반차, 반반차인 경우 시간 체크
					if( gntUse == "Y" && (reqUseType == "AM" || reqUseType == "PM") ) {
						var sHour = $(this).val().substring(0, $(this).val().indexOf(":"));
						var eHour = Number(sHour) + (8 * Number(baseCnt));
						if( eHour > 10 ) {
							$("#reqEHm").val(eHour + ":" + $(this).val().substring($(this).val().indexOf(":") + 1, $(this).val().length));
						} else {
							$("#reqEHm").val("0" + ":" + $(this).val().substring($(this).val().indexOf(":") + 1, $(this).val().length));
						}
					}
				}
				*/
				hourCheck(); 
			});
			
			$("#reqSHour").bind("change", function() {
				var endHour = getAttr("reqSHour", "endHour");
				$("#reqSHm").val($(this).val());
				$("#reqEHm").val(endHour);
				hourCheck();
			});
			
			//근태코드 변경 시
			$("#gntCd").bind("change", function() {
				changeGntCd($(this).val()) ;
			});

			//근태종류 변경 시
			$("#gntGubunCd").bind("change", function() {
				//근태코드
				var param = "queryId=getVacationAppDetGntCdList&searchSabun="+$("#searchSabun").val()+"&searchGntGubunCd="+$("#gntGubunCd").val()+"&restCntYn=Y";
				var gntCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", param, false).codeList
											, "requestUseType,vacationYn,baseCnt,gntGubunCd,baseCnt,maxCnt,holInclYn,gntCdDel1"
											, "");
				$("#gntCd").html(gntCdList[2]).change();
				
				// 사용연차휴가 정보 초기화
				$("#srcYy"     ).val("");
				$("#srcGntCd"  ).val("");
				$("#srcUseSYmd").val("");
				$("#srcUseEYmd").val("");
				
				// 연차휴가 차감 근태인 경우
				var gntUse = getAttr("gntGubunCd", "gntUse");
				if(gntUse == "Y") {
					// 사용연차휴가 콤보 생성
					initUseTargetAnnual();
					if( !$("#useTargetAnnual").hasClass("required") ) {
						$("#useTargetAnnual").addClass("required");
					}
				} else {
					if( $("#useTargetAnnual").hasClass("required") ) {
						$("#useTargetAnnual").removeClass("required");
					}
				}
			});
			$("#gntGubunCd").change();
			
			//경조구분 변경 시
			$("#occFamCd").bind("change", function() {
				var obj = $("#occFamCd option:selected");
				$("#occHoliday").val(obj.attr("occHoliday"));
				$("#occCd").val(obj.attr("occCd"));
				$("#famCd").val(obj.attr("famCd"));
				$("#span_occHoliday").html(obj.attr("occHoliday")+"일") ;
				if(obj.attr("timAppDesc") != "") {
					$("#span_occHoliday_desc").html("(" + obj.attr("timAppDesc") + ")");
				} else {
					$("#span_occHoliday_desc").html("");
				}
			});

			// 잔여연차휴가 변경 시
			$("#useTargetAnnual").bind("change", function() {
				if( $(this).val() != "" ) {
					var restCnt = Number(getAttr("useTargetAnnual", "restCnt"));
					var closeDay = Number($("#closeDay").val());
					var minusYn = getAttr("useTargetAnnual", "minusYn");
					
					// 적용일수가 선택한 잔여연차보다 큰 경우 선택 불가 처리
					if( minusYn == "N" && closeDay > restCnt ) {
						alert("사용할수 있는 잔여일수가 부족합니다.");
						$(this).val("");
						$(this).focus();
					}
				}
			});

		}else{
			//읽기전용 일때는 전체 근태코드를 가져 옴.
			//근태코드
			var gntCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getCpnGntCdList2"+params, false).codeList
					      , "requestUseType,vacationYn,baseCnt,gntGubunCd,baseCnt,maxCnt,holInclYn,gntCdDel1"
			              , "");
			$("#gntCd").html(gntCdList[2]);
		}

		doAction1("Search");
	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var params = "searchApplSeq="+searchApplSeq;
			var data = ajaxCall("${ctx}/VacationApp.do?cmd=getVacationAppDetList", params, false);

			if ( data != null && data.DATA != null ){

				$("#gntGubunCd").val( data.DATA.gntGubunCd );
				if(authPg == "A") {
					$("#gntGubunCd").change();
				}
				$("#gntCd").val( data.DATA.gntCd );
				changeGntCd($("#gntGubunCd").val()) ;

				var sdate = "", edate = "" ;
				var gntUse     = getAttr("gntGubunCd", "gntUse");
				var baseCnt    = getAttr("gntCd", "baseCnt");
				var reqUseType = getAttr("gntCd", "requestUseType");
				
				if( reqUseType == "D" || reqUseType == "AM" || reqUseType == "PM" ) {  //종일, 오전, 오후
					$("#sYmd").val( formatDate(data.DATA.sYmd,"-") ) ;
					$("#eYmd").val( formatDate(data.DATA.eYmd,"-") ) ;
				} else { //H 시간단위
					$("#applYmd").val( formatDate(data.DATA.sYmd,"-") ) ;
				}
				
				if( $("#gntGubunCd").val() == "15" || $("#gntGubunCd").val() == "16" ) {
					$("#applYmd").val( formatDate(data.DATA.sYmd,"-") ) ;
				}

				$("#holDay").val( data.DATA.holDay );
				$("#closeDay").val( data.DATA.closeDay );
				$("#reqSHm").val( data.DATA.reqSHm );
				$("#reqEHm").val( data.DATA.reqEHm );
				$("#requestHour").val(  data.DATA.requestHour );
				$("#gntReqReson").val( data.DATA.gntReqReson );

				$("#reqSHm").mask("11:11") ;
				$("#reqEHm").mask("11:11") ;
				
				// 반차인 경우
				if( gntUse == "Y" && baseCnt == 0.5 ) {
					$("#reqSHour").val( $("#reqSHm").val() );
				}

				//경조휴가
				$("#occFamCd").val( data.DATA.occFamCd );
				$("#occCd").val( data.DATA.occCd );
				$("#famCd").val( data.DATA.famCd );
				$("#occHoliday").val( data.DATA.occHoliday );
				$("#span_occHoliday").html( data.DATA.occHoliday+"일" );
				$("#occYmd").val( formatDate(data.DATA.occYmd,"-") ) ;
				
				// 연차/반차 휴가
				$("#srcYy").val( data.DATA.srcYy );
				$("#srcGntCd").val( data.DATA.srcGntCd );
				$("#srcUseSYmd").val( data.DATA.srcUseSYmd );
				$("#srcUseEYmd").val( data.DATA.srcUseEYmd );
				
				if( data.DATA.useTargetAnnual != undefined && data.DATA.useTargetAnnual != null ) {
					var gntUse = getAttr("gntGubunCd", "gntUse");
					if(authPg != "A" && gntUse == "Y") {
						initUseTargetAnnual();
					}
					$("#useTargetAnnual").val( data.DATA.useTargetAnnual );
					$("#useTargetAnnual").change();
				}
				
				//결재중일때 잔여휴가 표시
				if(applStatusCd == "11" || applStatusCd == "21" || applStatusCd == "31") {
					//잔여휴가 표시
					showRestDay();
				}

			}
			break;
		}
	}



	//--------------------------------------------------------------------------------
	//  적용시간 계산
	//--------------------------------------------------------------------------------
	function hourCheck(){
		var requestUseType = getAttr("gntCd", "requestUseType");
		var gntUse = getAttr("gntGubunCd", "gntUse");
		var baseCnt = getAttr("gntCd", "baseCnt");
		var validRequestHour = 0;
		
		// 근태종류가 반차,반반차휴가인 경우
		if($("#applYmd").val() != "" && gntUse == "Y" && baseCnt < 1 ) {
			$("#sYmd").val($("#applYmd").val());
			$("#eYmd").val($("#applYmd").val());
			dateCheck($("#sYmd"));
			
			// 적용시간값 입력
			if( baseCnt == 0.5 ) {
				validRequestHour = 5;
			} else if( baseCnt == 0.25 ) {
				validRequestHour = 3;
			} else if( baseCnt == 0.125 ) {
				//시간차일때는 최대신청가능 시간으로 보여주도록
				validRequestHour = getAttr("gntCd", "maxCnt")/baseCnt;
			}
			$("#requestHour").val( validRequestHour ) ;
		} else {
			validRequestHour = 8 * Number(baseCnt);
		}

		if( $("#reqSHm").val() != "" && $("#reqEHm").val() != "" && $("#applYmd").val() != "" ) {
			var param = "sabun="+searchApplSabun
			+"&gntCd="+$("#gntCd").val()
			+"&reqSHm="+$("#reqSHm").val().replace(":", "")
			+"&reqEHm="+$("#reqEHm").val().replace(":", "")
			+"&applYmd="+$("#applYmd").val().replace(/-/gi, "");
			
			// 적용시간 계산
			var holiDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetHour",param ,false);
			if( holiDayCnt != null && holiDayCnt != undefined && holiDayCnt.DATA != null && holiDayCnt.DATA != undefined ) {
				var requestHour = Number(holiDayCnt.DATA.restTime);

				//시간차 처리를 위한 산식 삽입
				if($("#closeDay").val() > 0 && baseCnt == 0.125) {
					$("#holDay").val(requestHour*baseCnt);
					$("#closeDay").val(requestHour*baseCnt);
				}
				// 근태종류가 반차휴가인 경우 시간 입력 체크
				if( (gntUse == "Y" && baseCnt < 1) && (requestHour > validRequestHour) ) {
					alert("신청시간을 " + validRequestHour + "단위로 입력하셔야 합니다.");
					$("#reqEHm").val( "" ) ;
					
				} else {
					$("#requestHour").val( requestHour ) ;
				}
			}
		}
	}

	//--------------------------------------------------------------------------------
	//  총일수, 적용일수 계산
	//--------------------------------------------------------------------------------
	function dateCheck(obj){
		try{
			var sYmd 	= $("#sYmd").val().replace(/-/gi, "");
			var eYmd 	= $("#eYmd").val().replace(/-/gi, "");
			var occYmd 	= $("#occYmd").val().replace(/-/gi, "");

			//반차휴가타입인경우 시작/종료일을 같이 간다.
			if( sYmd != "" && halfYn == "Y"  ) {
				$("#eYmd").val( $("#sYmd").val() ) ;
				eYmd = sYmd;
			}

			if(sYmd == "" || eYmd == "") return;

			if( eYmd < sYmd  ) {
				alert("시작일과 종료일을 정확히 입력하세요.");
				$(obj).val("");
				return;
			}

			//잔여휴가 표시
			if($("#gntCd").val() != ""){
				showRestDay();
			}

			//총일수 적용일수를 구한다.
			var param = "sabun="+$("#searchApplSabun").val()
			+"&applSeq="+$("#searchApplSeq").val()
			+"&gntCd="+$("#gntCd").val()
			+"&sYmd="+sYmd
			+"&eYmd="+eYmd;
			// 휴일 체크
			var map = ajaxCall("/VacationApp.do?cmd=getVacationAppDetHolidayCnt",param ,false);

			if( map.DATA.authYn == "N") {  // 2020.02.10 추가
				alert("신청 대상자가 아닙니다.");
				$(obj).val("");
				return;
			}

			var dayBetween = getDaysBetween(sYmd , eYmd ) ;
			if(halfYn == "N") {
				$("#holDay").val( dayBetween ) ;
				$("#closeDay").val( dayBetween - map.DATA.holidayCnt) ;
			} else {
				var maxCnt = getAttr("gntCd", "maxCnt");
				$("#holDay").val( maxCnt ) ;
				//$("#closeDay").val( maxCnt ) ;
				//반차, 반반차이면서 휴일로 신청하면 안되도록 수정 (2021.07.07)
				if(map.DATA.holidayCnt > 0) {
					$("#closeDay").val( "0" ) ;
				}else {
					$("#closeDay").val( maxCnt ) ;	
				}				
			}

		}catch(e){

		}

	}

	//근태코드 변경 시
	function changeGntCd(gntCd) {

		$("#inMod1").hide() ;
		$("#inMod2").hide() ;
		$("#inMod3").hide() ;
		$("#restDayCnt").hide();
		$("#span_occ").hide();

		if( $("#gntCd").val() == "" ) {
			clearHtml();
			halfYn = "N";
			return;
		}
		
		// 연차휴가 차감 근태인 경우
		var gntUse = getAttr("gntGubunCd", "gntUse");
		if(gntUse == "Y") {
			$("#inMod3").show();
			iframeHeight = 250;
		} else {
			iframeHeight = 220;
		}
		parent.iframeOnLoad(iframeHeight + "px");
		
		
		//------------------------------------------------------------------------------------------
		//잔여휴가 표시
		showRestDay();
		//------------------------------------------------------------------------------------------
		
		//------------------------------------------------------------------------------------------
		//현재 근태코드의 근태신청유형
		var reqUseType = getAttr("gntCd", "requestUseType");
		var baseCnt    = getAttr("gntCd", "baseCnt");
		//최소, 최대 기준일수를 보여줌
		$("#baseCnt").val( baseCnt ) ;
		$("#maxCnt").val( getAttr("gntCd", "maxCnt") ) ;
		
		
		//근태신청유형에 따라 신청폼을 바꿔주는 화면컨트롤 로직
		if( reqUseType == "D" || reqUseType == "AM" || reqUseType == "PM" ) {
			// 반차,반반차휴가 선택인 경우
			if( baseCnt < 1 ) {
				$("#inMod1").hide();
				$("#inMod2").show();
			} else {
				$("#inMod1").show();
				$("#inMod2").hide();
			}
			
			$("#reqSHm").val("");
			$("#reqEHm").val("");
			$("#requestHour").val("");
			
			if(reqUseType == "AM" || reqUseType == "PM") {
				halfYn = "Y";
				$("#span_eYmd").hide(); //종료일자 표시 여부
			}else{
				halfYn = "N";
				$("#span_eYmd").show();
			}
			
			// 반차인 경우
			if( baseCnt == 0.5 ) {
				initReqSHourCombo();
				$("#reqSHour").show();
				$("#reqSHm").hide();
				$("#reqEHm").addClass("readonly");
				$("#reqEHm").attr("readonly", true);
			} else {
				$("#reqSHour").hide();
				$("#reqSHm").show();
				$("#reqEHm").removeClass("readonly");
				$("#reqEHm").attr("readonly", false);
			}
			
			dateCheck($("#sYmd"));

		} else if( reqUseType == "H" ) {
			$("#inMod1").hide() ;	$("#inMod2").show() ;

			$("#sYmd").val("") ;
			$("#eYmd").val("") ;
			$("#holDay").val("") ;
			$("#closeDay").val("") ;

			//직출(210)일 경우
			if( $("#gntCd").val() == "210" ) {
				$("#txt_sTime").html( "현지출근시간" );
				$("#txt_eTime").html( "복귀예정시간" );

			//직퇴(22)일 경우
			}else if( $("#gntCd").val() == "220" ) {
				$("#txt_sTime").html( "출발예정시간" );
				$("#txt_eTime").html( "현지퇴근시간" );

			}else{
				$("#txt_sTime").html( "시작시간" );
				$("#txt_eTime").html( "종료시간" );
			}

		}
		//------------------------------------------------------------------------------------------
		//경조휴가(70)일 경우
		if( $("#gntCd").val() == "70" ) {
			$("#span_occ").show();
			$("#occFamCd").addClass("required1").addClass("required2");

		}else{
			$("#occFamCd").removeClass("required1").removeClass("required2");
			$("#occFamCd").val( "" );
			$("#occCd").val( "" );
			$("#occHoliday").val( "" );
			$("#occYmd").val( "" );
			$("#famCd").val( "" );
			$("#span_occHoliday").html( "" );
		}

	}


	//입력값 초기화
	function clearHtml() {

		$("#applYmd").val( "" ) ;
		$("#sYmd").val( "" ) ;
		$("#eYmd").val( "" ) ;
		$("#holDay").val( "" );
		$("#closeDay").val( "" );
		$("#gntReqReson").val( "" );
		$("#reqSHm").val( "" );
		$("#reqEHm").val( "" );
		$("#requestHour").val( "" );


		$("#restDayTitle").text("") ;
		$("#restDayCnt").text("") ;

		$("#maxCnt").val( "" );
		$("#occCd").val( "" );
		$("#occHoliday").val( "" );
		$("#occYmd").val( "" );
		$("#famCd").val( "" );
		$("#span_occHoliday").html( "" );
		$("#txt_sTime").html( "시작시간" );
		$("#txt_eTime").html( "종료시간" );
		
		// 사용연차휴가 정보 초기화
		$("#srcYy"     ).val("");
		$("#srcGntCd"  ).val("");
		$("#srcUseSYmd").val("");
		$("#srcUseEYmd").val("");
	}

	//--------------------------------------------------------------------------------
	//  잔여휴가 표시
	//--------------------------------------------------------------------------------
	function showRestDay() {
		var param = "";
		
		// 발생휴가 사용 여부
		var vacationYn 	= getAttr("gntCd", "vacationYn");
		if( vacationYn == "Y" ){
			if( $("#gntCd").val() =="" || $("#sYmd").val() =="" || $("#eYmd").val() ==""){
				$("#restDayCnt").hide();
				$("#restDayCnt").html("") ;
				return;
			}
			$("#restDayCnt").show();
			
			//잔여휴가 표시 로직
			param = "sabun="+searchApplSabun
			+"&gntCd="+$("#gntCd").val()
			+"&sYmd="+$("#sYmd").val().replace(/-/gi, "")
			+"&eYmd="+$("#eYmd").val().replace(/-/gi, "");
			
			//발생기준에 있는 근태코드의 잔여일수
			var holiDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetRestCnt",param ,false);

			if ( authPg == "A" && holiDayCnt != null && holiDayCnt.DATA != null ){
				$("#restDayCnt").text( "기 신청 건 산정 잔여일수 : " + holiDayCnt.DATA.restCnt + "일") ;
			} else {
				$("#restDayCnt").html("") ;
			}
			
		}else{
			$("#restDayCnt").hide();
			$("#restDayCnt").html("") ;
		}
	}



	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(){
		var ch = true;

		var reqUseType = $("#gntCd option:selected").attr("requestUseType");
		var gntUse     = getAttr("gntGubunCd", "gntUse");
		
		if( reqUseType == "D" || reqUseType == "AM" || reqUseType == "PM" ) {
	 		// 화면의 개별 입력 부분 필수값 체크
			$(".required1").each(function(index){
				if (!$(this).is(":visible")) return true;	// 숨겨진 컨트롤은 each 반복중 continue 함
				if($(this).val() == null || $(this).val() == ""){
					alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
					$(this).focus();
					ch =  false;
					return false;
				}
			});
			
			// 반차, 반반차인 경우 시간 체크
			if( gntUse == "Y" && (reqUseType == "AM" || reqUseType == "PM") ) {
				if( $("#reqSHm").val() == null || $("#reqSHm").val() == "" ){
					alert($("#txt_sTime").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
					$(this).focus();
					ch =  false;
					return false;
				}
				if( $("#reqEHm").val() == null || $("#reqEHm").val() == "" ){
					alert($("#txt_eTime").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
					$(this).focus();
					ch =  false;
					return false;
				}
			}
		}else{
			// 화면의 개별 입력 부분 필수값 체크
			$(".required2").each(function(index){
				if (!$(this).is(":visible")) return true;	// 숨겨진 컨트롤은 each 반복중 continue 함
				if($(this).val() == null || $(this).val() == ""){
					switch ($(this).attr("id")) {
					case "reqSHm":
						alert($("#txt_sTime").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
						break;
					case "reqEHm":
						alert($("#txt_eTime").text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
						break;
					default:
						alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은 필수값입니다.'/>");
						break;
					}
					$(this).focus();
					ch =  false;
					return false;
				}
			});
		}

		return ch;
	}


	//--------------------------------------------------------------------------------
	//  근태신청 체크
	//--------------------------------------------------------------------------------
	function logicValidation(Row) {
		var returnValue = true ;
		var sdate = "", edate = "" ;
		
		var occYmd 	= $("#occYmd").val().replace(/-/gi, "");

		var reqUseType = getAttr("gntCd", "requestUseType") ;
		if( reqUseType == "D" || reqUseType == "AM" || reqUseType == "PM" ) {
			sdate = $("#sYmd").val().replace(/-/gi, "") ;
			edate = $("#eYmd").val().replace(/-/gi, "") ;
		} else { //H
			sdate = $("#applYmd").val().replace(/-/gi, "") ;
			edate = $("#applYmd").val().replace(/-/gi, "") ;
			//시작일, 종료일 신청일로 세팅
			$("#sYmd").val( $("#applYmd").val() ) ;
			$("#eYmd").val( $("#applYmd").val() ) ;
		}

		// 연차휴가 차감 근태인 경우
		if(getAttr("gntGubunCd", "gntUse") == "Y" && $("#useTargetAnnual").val() != "" ) {
			$("#srcYy").val( getAttr("useTargetAnnual", "yy") );
			$("#srcGntCd").val( getAttr("useTargetAnnual", "gntCd") );
			$("#srcUseSYmd").val( getAttr("useTargetAnnual", "useSYmd") );
			$("#srcUseEYmd").val( getAttr("useTargetAnnual", "useEYmd") );
		}
		
		var param  = "sabun="+$("#searchApplSabun").val();
			param += "&applSeq="+$("#searchApplSeq").val();
			param += "&gntCd="+$("#gntCd").val();
			param += "&sYmd="+sdate;
			param += "&eYmd="+edate;
			param += "&occYmd="+occYmd;
			

		// 재직상태 및 신청대상자 체크-----------------------------------------------------------------------------------------------
		var statusMap = ajaxCall("/VacationApp.do?cmd=getVacationAppDetStatusCd",param ,false);
		if(statusMap.DATA.statusCd1 != "AA" || statusMap.DATA.statusCd2 != "AA") {
			alert("해당 신청기간에 재직상태가 아닙니다.");
			returnValue = false;
			return false;
		}
		
		if( statusMap.DATA != null && statusMap.DATA.msg  != "" ) {
			alert(statusMap.DATA.msg);
			returnValue = false;
			return false;
		}

		if( statusMap.DATA.authYn == "N") {  // 2020.02.10 추가
			alert("신청 대상자가 아닙니다.");
			returnValue = false;
			return false;
		}
		//---------------------------------------------------------------------------------------------------------

		//경조휴가
		if( $("#gntCd").val() == "70" ){
			var chkDays = $("#closeDay").val(); //휴일미포함 일수
			if( $("#gntCd option:selected").attr("holInclYn") =="Y" ){ //휴일포함
				chkDays = $("#holDay").val(); //총일수
			}

			if (parseFloat($("#occHoliday").val()) < parseFloat(chkDays)) {
				alert("경조휴가는 " + $("#occHoliday").val() + "일까지 신청 가능합니다.");
				returnValue = false;
				return false;
			}
		}else{
			
			// 연차휴가 차감 근태인 경우
			// 적용일수가 선택한 잔여연차보다 큰 경우 선택 불가 처리
			if(getAttr("gntGubunCd", "gntUse") == "Y") {
				if( getAttr("useTargetAnnual", "minusYn") == "N" && parseFloat( $("#closeDay").val() ) > parseFloat( getAttr("useTargetAnnual", "restCnt") ) ) {
					alert("사용 연차휴가의 잔여휴가일수가 부족합니다.");
					returnValue = false;
					return false;
				}
				
				if( $("#useTargetAnnual").val() == "" ) {
					alert("사용 연차휴가를 선택해 주시기 바랍니다.");
					returnValue = false;
					return false;
				}
				
				var useSYmd = getAttr("useTargetAnnual", "useSYmd");
				var useEYmd = getAttr("useTargetAnnual", "useEYmd");
				
				if( $("#gntGubunCd").val() == "15" || $("#gntGubunCd").val() == "16" ) {
					if( parseInt($("#applYmd").val().replace(/-/gi, "")) < parseInt(useSYmd)
						|| parseInt($("#applYmd").val().replace(/-/gi, "")) > parseInt(useEYmd) ) {
						alert("신청일자가 사용기간에 포함되지 않습니다.");
						returnValue = false;
						return false;
					}
				} else {
					if( parseInt($("#sYmd").val().replace(/-/gi, "")) < parseInt(useSYmd)
						|| parseInt($("#eYmd").val().replace(/-/gi, "")) > parseInt(useEYmd) ) {
						alert("신청일자가 사용기간에 포함되지 않습니다.");
						returnValue = false;
						return false;
					}
				}
			}
			
			// 근태신청 세부내역(잔여일수,휴일일수) 조회
			var holiDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetDayCnt",param ,false);

			if(holiDayCnt.DATA.valChk == 'EX') {
				alert("신청시작일과 종료일은 동일한 근태기준기간에 속해 있어야 합니다\.n근태기준기간에 맞게 나눠서 신청해 주시기 바랍니다.");
				return;
			} else if (holiDayCnt.DATA.valChk == 'NO') {
				alert("신청기간에 속하는 사용가능일이 부여되지 않았습니다.\n인사(근태)담당자에게 문의하여 주시기 바랍니다.");
				return;
			}

			if( $("#closeDay").val() == "0" ){
				alert("휴일은 신청할 수 없습니다.");
				returnValue = false ;
				return false;
			}

			if(holiDayCnt.DATA.minusYn == "N" && ( parseFloat(holiDayCnt.DATA.restCnt) - parseFloat($("#closeDay").val()) ) < 0 ) {
				alert("잔여휴가일수가 부족합니다.");
				returnValue = false;
				return false;
			}

			if( $("#closeDay").val() != "" && $("#maxCnt").val() != "" &&
				parseFloat( $("#closeDay").val() ) > parseFloat( $("#maxCnt").val() ) ) {
				alert("최대 "+$("#maxCnt").val()+"일 이하로 신청 하셔야 합니다.") ;
				returnValue = false;
				return false;
			}

			if( $("#closeDay").val() != "" && $("#baseCnt").val() != "" &&
				parseFloat( $("#closeDay").val() ) < parseFloat( $("#baseCnt").val() ) ) {
				alert("최소 "+$("#baseCnt").val()+"일 이상 신청 하셔야 합니다.") ;
				returnValue = false;
				return false;
			}
		}
		// 기 신청일수 여부 체크
		var applDayCnt = ajaxCall("/VacationApp.do?cmd=getVacationAppDetApplDayCnt",param ,false);
		if( parseInt( applDayCnt.DATA.cnt ) > 0) {
			alert("해당 신청기간에 기 신청건이 존재합니다.");
			$("#sYmd").focus();
			returnValue = false;
			return false;
		}


		return returnValue ;
	}


	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(){
		var returnValue = false;

		try{
			if ( authPg == "R" )  {
				return true;
			}

	        // 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }

	        // 로직체크
	        if ( !logicValidation() ) {
	            return false;
	        }


	      	//저장
			var data = ajaxCall("${ctx}/VacationApp.do?cmd=saveVacationAppDet",$("#dataFrm").serialize(),false);

            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }


		} catch (ex){
			alert("Script Errors Occurred While Saving." + ex);
			returnValue = false;
		}

		return returnValue;
	}

	function openPlan(){
		const p = {searchApplSabun};
		const url = '/VacationApp.do?cmd=viewVacationAppDetPlanLayer';
		var vacationAppDetPlanLayer = new window.top.document.LayerModal({
			id: 'vacationAppDetPlanLayer',
			url: url,
			parameters: p,
			width: 900,
			height: 600,
			title: '휴가계획',
			trigger: [
				{
					name: 'vacationAppDetPlanTrigger',
					callback: function(rv) {
						vacationPlanRtnFunc(rv);
					}
				}
			]
		});
		vacationAppDetPlanLayer.show();
	}

	function vacationPlanRtnFunc(param) {
		if (param) {
			$("#sYmd").val(param.sdateFormat) ;
			$("#eYmd").val(param.edateFormat) ;
			$("#gntGubunCd").val("1"); // 연차로 setting
			$("#gntGubunCd").change();
			setTimeout(function(){ $("#gntCd").val("14"); }, 20);	
		}
	}
	
	// 사용연차휴가 콤보 생성
	function initUseTargetAnnual() {
		var param  = "";
		var gntUse = getAttr("gntGubunCd", "gntUse");		// 연차휴가 차감 근태 여부
		var gntCdDel1 = getAttr("gntCd", "gntCdDel1");		// 휴가발생 공제연차 코드
		
		// 잔여연차휴가 목록 조회
		if( gntUse == "Y" ) {
			param  = "queryId=getVacationAppUseCdList";
			param += "&searchSabun="+searchApplSabun;
			param += "&searchGntCd1=" + $("#gntCd").val();
			param += "&searchGntCd2=" + gntCdDel1;
			param += "&sYmd="+$("#sYmd").val().replace(/-/gi, "");
			param += "&eYmd="+$("#eYmd").val().replace(/-/gi, "");
			
			var useTargetAnnualList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", param, false).codeList
												, "yy, gntCd, useSYmd, useEYmd, creCnt, useCnt, usedCnt, restCnt, minusYn"
												, "사용 연차휴가를 선택해주십시오.");
			//console.log('useTargetAnnualList', useTargetAnnualList);
			$("#useTargetAnnual").html(useTargetAnnualList[2]);
		}
	}

	// 지정 ID의 엘레멘트의 지정 속성값 반환
	function getAttr(eleId, attrNm) {
		var obj = $("#" + eleId);
		var tagName = obj.prop('tagName');
		
		
		if(tagName.toUpperCase() == "SELECT") {
			obj = $("option:selected", obj);
		}
		
		return obj.attr(attrNm);
	}
	
	// 반차 시작 시간 선택 콤보 생성
	function initReqSHourCombo() {
		var html = "";
			
		var reqUseType = getAttr("gntCd", "requestUseType");
		if( reqUseType == "AM" ) {
			html += "<option value=\"08:00\" endHour=\"12:00\">08:00</option>";
			html += "<option value=\"09:00\" endHour=\"14:00\">09:00</option>";
			html += "<option value=\"10:00\" endHour=\"15:00\">10:00</option>";
		} else if( reqUseType == "PM" ) {
			html += "<option value=\"12:00\" endHour=\"16:00\">12:00</option>";
			html += "<option value=\"14:00\" endHour=\"18:00\">14:00</option>";
			html += "<option value=\"15:00\" endHour=\"19:00\">15:00</option>";
		}
		$("#reqSHour").html(html);
		$("#reqSHour").change();
	}
</script>
<style type="text/css">
#restDayCnt {padding-left:20px;color:red;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="dataFrm" id="dataFrm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchSabun"       name="searchSabun"		 value=""/>
	<input type="hidden" id="baseCnt"           name="baseCnt"		     value=""/>
	<input type="hidden" id="maxCnt"            name="maxCnt"		     value=""/>

	<!-- 경조휴가 관련 -->
	<input type="hidden" id="occCd"             name="occCd"		     value=""/>
	<input type="hidden" id="famCd"             name="famCd"		     value=""/>
	<input type="hidden" id="occHoliday"        name="occHoliday"		 value=""/>

	<!-- 연차/반차휴가 관련 -->
	<input type="hidden" id="srcYy"             name="srcYy"		     value=""/>
	<input type="hidden" id="srcGntCd"          name="srcGntCd"		     value=""/>
	<input type="hidden" id="srcUseSYmd"        name="srcUseSYmd"	     value=""/>
	<input type="hidden" id="srcUseEYmd"        name="srcUseEYmd"	     value=""/>


	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="appTitle" mdef="신청내용" /></li>
			<li class="btn"><a href="javascript:openPlan();" class="button authA" >휴가계획가져오기</a></li>
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
		<th>근태구분</th>
		<td>
			<select id="gntGubunCd" name="gntGubunCd" class="${selectCss} ${required} required1 required2" ${selectDisabled}></select>
		</td>
		<th>근태</th>
		<td>
			<select id="gntCd" name="gntCd" class="${selectCss} ${required} required1 required2" ${selectDisabled}></select>
			<span id="restDayCnt"><!-- 잔여휴가 표시 --></span>
		</td>
	</tr>
	<tr id="span_occ" style="display:none;"><!-- 경조휴가 신청시 -->
		<th>경조구분</th>
		<td>
			<select id="occFamCd" name="occFamCd" class="${selectCss} ${required} required1 required2" ${selectDisabled}></select>
			<span style="padding-left:10px;">
				<b>휴가일수 : </b>&nbsp;&nbsp; 		<span id="span_occHoliday"></span> <span id="span_occHoliday_desc"></span>
			</span>  
		</td>
		<th>경조일자</th>
		<td>
			<input id="occYmd" name="occYmd" type="text" size="10" class="date2 w70 ${required} required1" readonly  />
		</td>
	</tr>
	<tr id="inMod1" style="display:none;">
		<th>신청일자</th>
		<td colspan="3">
			<input id="sYmd" name="sYmd" type="text" size="10" class="date2 w70 ${required} required1" readonly  />
			<span id="span_eYmd">
				<input type="text" class="text w10 left transparent center" value="~" readonly tabindex="-1"> <input id="eYmd" name="eYmd" type="text" size="10" class="date2 w70 ${required} required1" readonly  />
			</span>
			<span style="padding-left:30px;">
				<b>총일수 : </b>&nbsp;&nbsp; 		<input type="text" id="holDay"   name="holDay"   class="text w30 center" readonly maxlength="3"/>&nbsp;&nbsp;&nbsp;&nbsp;
				<b>적용일수 : </b>&nbsp;&nbsp;	<input type="text" id="closeDay" name="closeDay" class="text w30 center" readonly maxlength="4"/>&nbsp;&nbsp;&nbsp;&nbsp;
			</span>
		</td>
	</tr>
	<tr id="inMod2" style="display:none;">
		<th><tit:txt mid="104084" mdef="신청일자" /></th>
		<td colspan="3">
			<input id="applYmd" name="applYmd" type="text" size="10" class="date2  w70 ${readonly} ${required} required2 " readonly />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

			<!-- 시작시간 -->
			<b><span id="txt_sTime">시작시간</span> : </b>
			&nbsp;&nbsp;
			<select id="reqSHour" name="reqSHour" style="display:none;"></select>
			<input id="reqSHm" name="reqSHm" type="text" class="text center ${required} required2" ${readonly} maxlength="5"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			
			<!-- 종료시간 -->
			<b><span id="txt_eTime">종료시간</span> : </b>
			&nbsp;&nbsp;
			<input id="reqEHm" name="reqEHm" type="text" class="text center ${required} required2" ${readonly} maxlength="5"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			
			<b>적용시간 : </b>&nbsp;&nbsp;<input id="requestHour" name="requestHour" type="text" class="text w30 center ${readonly}" ${readonly} maxlength="4"/>&nbsp;&nbsp; 시간
		</td>
	</tr>
	<tr id="inMod3" style="display:none;"><!-- 근태종류 : 연차/반차휴가 신청시 -->
		<th>사용 연차휴가</th>
		<td colspan="3">
			<select id="useTargetAnnual" name="useTargetAnnual" class="${selectCss}" ${selectDisabled}></select>
		</td>
	</tr>
	<tr>
		<th>신청사유</th>
		<td colspan="3">
			<textarea id="gntReqReson" name="gntReqReson" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
		</td>
	</tr>
	</table>
	</form>
</div>
</body>
</html>