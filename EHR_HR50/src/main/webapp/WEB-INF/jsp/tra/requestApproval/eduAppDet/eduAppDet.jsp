<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>교육신청 세부내역</title>
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
	var applStatusCd	 = "";
	var pGubun         = "";
	var gPRow = "";
	var codeLists;
	var chooseEduEvtSeq;
	var isDupSearch = false;

	$(function() {

		parent.iframeOnLoad(400);
		
		// 세부내역 일 경우는 신청내용이 보이도록
		if(authPg == 'R') {
			$("#newEduCourse").show();
			parent.iframeOnLoad($(".bodywrap").height());
		}
		
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);

		applStatusCd = parent.$("#applStatusCd").val();

		
  		//공통코드 한번에 조회
		var grpCds = "L20020,L10010,L10015";
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","useYn=Y&grpCd="+grpCds,false).codeList, " ");
		$("#eduBranchCd").html(codeLists["L10010"][2]);
		$("#inOutType").html(codeLists["L20020"][2]);
		
		
		if(authPg == "A") {
			//교육구분 선택 시 교육분류 조회
			/* 교육분류코드의  Note1 정리가 안돼서 일단 막아 둠.
			$("#eduBranchCd").bind("change",function(e){
				
				var param = "&searchEduBranchCd="+$("#eduBranchCd").val();
				var cdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getEduMBranchCdList"+param, false).codeList, " ");
				$("#eduMBranchCd").html(cdList[2]);
				
			}).change();*/
			$("#eduMBranchCd").html(codeLists["L10015"][2]);

			//과정명 엔터 시
			$("#eduCourseNm").bind("keyup",function(event){
				if( event.keyCode == 13){ doAction1('SearchEdu'); }
			})
			//교육기관명 엔터 시
			$("#eduOrgNm").bind("keyup",function(event){
				$("#eduOrgDupChk").val("N");
				if( event.keyCode == 13){ doSearchEduOrgNm(); }
			})
			//직무명 엔터 시
			$("#jobNm").bind("keyup",function(event){
				if( event.keyCode == 13){ doSearchEduJobNm(); }
			})
			
			if( applStatusCd == "" ){
				$("#searchEduCourseNm").bind("keyup",function(event){
					if( event.keyCode == 13){ doAction1("SearchEdu"); $(this).focus(); }
				});
				
				$("#searchEduSYmd").datepicker2({startdate:"searchEduEYmd"});
				$("#searchEduEYmd").datepicker2({enddate:"searchEduSYmd"});
			}

			//교육비용
			$("#realExpenseMon").mask('000,000,000,000,000', { reverse : true });
			
			//입력제한
			$("#eduCourseNm").maxbyte(100);
			$("#eduPlace").maxbyte(30);
			$("#eduOrgNm").maxbyte(30);
			$("#realExpenseMon").maxbyte(20);
			$("#note").maxbyte(1000);
			$("#eduSYmd, #eduEYmd").maxbyte(10);

			$("#eduSYmd").datepicker2({onReturn:function(){dupCheckEduYmd(0);}, startdate:"eduEYmd"});  //회차중복체크 초기화
			$("#eduEYmd").datepicker2({onReturn:function(){dupCheckEduYmd(0);}, enddate:"eduSYmd"});
			$("#eduSYmd, #eduEYmd").bind("change",function(event){
				dupCheckEduYmd(0);
			});
			
		} else{

			//교육분류
			$("#eduMBranchCd").html(codeLists["L10015"][2]);
		}
		doAction1("Search");

	});
	


	//교육과정리스트
	function init_sheet1(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, FrozenCol:0};
		initdata.Cols = [ 
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo" },
			
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",		Hidden:0,	Width:55,	Align:"Center",	SaveName:"detail",			Format:"",		Edit:0,	Cursor:"Pointer", Sort:0},
			{Header:"<sht:txt mid='eduCourseCd' mdef='과정코드'/>",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	SaveName:"eduSeq",			Format:"",		Edit:0 },
			{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",				Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	SaveName:"eduCourseNm",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='inOutCd' mdef='사내/외\n구분'/>",			Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	SaveName:"inOutType",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",			Type:"Combo",		Hidden:1,	Width:150,	Align:"Left",	SaveName:"eduBranchCd",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='eduMBranchCd' mdef='교육분류'/>",			Type:"Combo",		Hidden:1,	Width:150,	Align:"Left",	SaveName:"eduMBranchCd",	Format:"",		Edit:0 },
			{Header:"<sht:txt mid='eduSYmdV1' mdef='교육시작일'/>",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	SaveName:"eduSYmd",			Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='eduEYmdV1' mdef='교육종료일'/>",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	SaveName:"eduEYmd",			Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",  				Type:"Html",    	Hidden:0,   Width:55,   Align:"Center", SaveName:"selBtn",  		Sort:0 },
			//Hidden
			{Header:"교육기관코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	SaveName:"eduOrgCd",		Format:"",		Edit:0 },
			{Header:"교육기관명",			Type:"Text",		Hidden:1,	Width:110,	Align:"Left",	SaveName:"eduOrgNm",		Format:"",		Edit:0 },
			{Header:"직무코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	SaveName:"jobCd",			Format:"",		Edit:0 },
			{Header:"직무명",				Type:"Text",		Hidden:1,	Width:110,	Align:"Left",	SaveName:"jobNm",			Format:"",		Edit:0 },
			{Header:"교육비",				Type:"Text",		Hidden:1,	Width:100,	Align:"Right",	SaveName:"realExpenseMon",	Format:"",		Edit:0 },	
			{Header:"고용보험적용여부",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	SaveName:"laborApplyYn",	Format:"",		Edit:0 },	
			{Header:"교육장소",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	SaveName:"eduPlace",		Format:"",		Edit:0 },	
			
			{Header:"Hidden", 			Type:"Text",		Hidden:1, SaveName:"eduMemo"},
			{Header:"Hidden", 			Type:"Text",		Hidden:1, SaveName:"eduEventSeq"},
			
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);
  		sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
  		sheet1.SetDataLinkMouse("detail", 1);
  		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
  		sheet1.SetRowBackColorD("#d5d5d5"); sheet1.SetRowBackColorU("#d5d5d5");
  		
		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} );// L20020 사내/외 구분
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );// L10010 교육구분코드
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );// L10015 교육분류코드
		
	}
	

	// Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //신청내용 조회
				
				// 입력 폼 값 셋팅
				var data = ajaxCall( "${ctx}/EduApp.do?cmd=getEduAppDetMap", $("#searchForm").serialize(),false);
	
				if ( data != null && data.DATA != null ){ 
					$("#inOutType").val(data.DATA.inOutType);
					
					$("#eduSeq").val(data.DATA.eduSeq);
					$("#eduEventSeq").val(data.DATA.eduEventSeq);
					$("#eduCourseNm").val(data.DATA.eduCourseNm);
					$("#eduBranchCd").val(data.DATA.eduBranchCd);
					$("#eduMBranchCd").val(data.DATA.eduMBranchCd);
					$("#eduSYmd").val(formatDate(data.DATA.eduSYmd,"-"));
					$("#eduEYmd").val(formatDate(data.DATA.eduEYmd,"-"));
					$("#eduOrgCd").val(data.DATA.eduOrgCd);
					$("#eduOrgNm").val(data.DATA.eduOrgNm);
					$("#realExpenseMon").val(makeComma(data.DATA.realExpenseMon));
					$("#laborApplyYn").val(data.DATA.laborApplyYn);
					$("#eduPlace").val(data.DATA.eduPlace);
					$("#yearPlanYn").val(data.DATA.yearPlanYn);
					$("#jobCd").val(data.DATA.jobCd);
					$("#jobNm").val(data.DATA.jobNm);
					$("#eduMemo").val(data.DATA.eduMemo);
					$("#note").val(data.DATA.note);		
					$("#eduEditYn").val(data.DATA.eduEditYn); //교육과정 수정 가능 여부 ( 내가 등록한 교육과정 이면 수정 가능 - 임시저장 상태에서 )
					$("#evtEditYn").val(data.DATA.evtEditYn); //교육회차 수정 가능 여부 ( 내가 등록한 교육과정 이면 수정 가능 - 임시저장 상태에서 )
					
					if(authPg == "A") {
						changeEditForm("0");  //임시저장일때 수정 불가, 교육과정,교육회차,교육기관이 저장되어 있어서 수정할 수 있으면 쓰레기 데이터 생성
						$("#clearBtn").hide(); //신규과정 버튼
						$("#evtClearBtn").hide(); //신규회차 버튼
						dupCheckEduYmd(1); //회차중복체크 완료 ( 최초는 OK 상태 )
						
						
						// [2021.08.23 추가] 임시저장 상태인 신청건의 경우 신청내용 정보 미출력 현상 수정
						chooseEduEvtSeq = data.DATA.eduEventSeq;
						$("#divEdiList").show();
						init_sheet1();
						$(window).smartresize(sheetResize); sheetInit();
						doAction1("SearchEdu");
					}
				}else{
					dupCheckEduYmd(1); //회차중복체크 완료 ( 최초는 OK 상태 )
					//저장된 값이 없을 때만 과정리스트 보여 줌
					$("#evtClearBtn").hide(); //신규회차버튼 숨김
					$("#divEdiList").show();
					init_sheet1();
					$(window).smartresize(sheetResize); sheetInit();
					doAction1("SearchEdu"); 
				}
				
				
				break;
			case "SearchEdu": //신청가능한 교육과정 리스트
				sheet1.DoSearch( "${ctx}/EduApp.do?cmd=getEduAppDetSelList", $("#sheet2Form").serialize() );
				break;
			case "DupCheck":
				isDupSearch = true;
				if( $("#eduCourseNm").val() == "" ){
					alert("과정명을 입력해주세요.");
					$("#eduCourseNm").focus();
					return;
				}
				$("#searchEduCourseNm").val($("#eduCourseNm").val());
				doAction1("SearchEdu");
				break;
		}
	}


	//--------------------------------------------------------------------------------
	//  sheet1 Events
	//--------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// [2021.08.23 추가] 임시저장 상태인 신청건의 경우 신청내용 정보 미출력 현상 수정
			if(authPg == "A" && applStatusCd == "11") {
				var _chooseRow = -1;
				for(var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
					if(sheet1.GetCellValue(i, "eduEventSeq") == chooseEduEvtSeq) {
						_chooseRow = i;
					}
				}
				sheet1.SetSelectRow(_chooseRow);
				sheetToForm(_chooseRow);
				$("#newEduCourse").show();
				parent.iframeOnLoad($(".bodywrap").height());
			}

			// 중복 조회인 경우
			if(isDupSearch) {
				if(sheet1.GetDataLastRow() > 0) {
					if(!(confirm("입력한 교육과정명과 유사한 교육과정이 있습니다. 신규과정을 생성하시겠습니까?"))){
						//입력값 초기화
						$("#eduCourseNm, #eduEventSeq, #eduSYmd, #eduEYmd").val(""); //회차정보
						$("#yearPlanYn, #note").val("");//신청정보
						$("#eduOrgDupChk").val("Y"); //교육기관 중복체크
					}
				}
				isDupSearch = false;
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	if (!isPopup()) {
					return;
				}

				var args = new Array(3);
				args["eduSeq"] 		= sheet1.GetCellValue(Row, "eduSeq");
				args["eduEventSeq"] = sheet1.GetCellValue(Row, "eduEventSeq");

				var url = "${ctx}/EduApp.do?cmd=viewEduMgrLayer&authPg=R";
				
				gPRow = -1;
				pGubun = "eduMgrPopup";

				let eduMgrLayer = new window.top.document.LayerModal({
					id: 'eduMgrLayer',
					url: url,
					parameters: args,
					width: 1000,
					height: 1000,
					title: '교육과정 세부내역',
					trigger :[
						{
							name : 'eduMgrLayerTrigger',
							callback : function(returnValue){
							}
						}
					]
				});

				eduMgrLayer.show();
				
		    }else if( sheet1.ColSaveName(Col) == "selBtn"){
		    	sheetToForm(Row);
		    	$("#newEduCourse").show();
		    	parent.iframeOnLoad($(".bodywrap").height());
		    }
		    
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//시트 과정 정보를 폼에 셋팅
	function sheetToForm(Row){
		try {
			for(var i = sheet1.SaveNameCol("eduSeq"); i <= sheet1.LastCol() ; i++) {
	    		var cellType = sheet1.GetCellProperty(Row, i, "Type");
	    		if( cellType == "Text" || cellType == "Date" || cellType == "Int"){
	    			$("#"+sheet1.ColSaveName(0, i)).val(sheet1.GetCellText(Row, i));
	    		}else if( cellType == "Combo" ){
	    			$("#"+sheet1.ColSaveName(0, i)).val(sheet1.GetCellValue(Row, i));	
	    		}
			}

			changeEditForm("0"); //전체 수정 불가.
			dupCheckEduYmd(1); //교육기간 중복체크 OK
			if( $("#inOutType").val() == "OUT" ){
				$("#evtClearBtn").show(); //신규회차버튼
			}else if( $("#inOutType").val() == "IN" ){
				$("#evtClearBtn").hide(); //신규회차버튼 ( 사내교육은 신규 회차 없음 ) 
			} 
			
		} catch (ex) {
			alert("sheetToForm() Script Error : " + ex);
		}
	}
	//사내외 구분에 따라 폼 입력 변경
	function changeEditForm(type){
		try {

			switch (type) {
				case "0": //전부 수정불가 
					//입력불가.
					$(".inSel1, .inSel2").addClass("transparent").addClass("hideSelectButton").attr("disabled",true).removeClass("required");
					$(".inText1, .inText2").addClass("transparent").attr("readonly",true).removeClass("required");
					$(".inImg").hide();
					$(".ui-datepicker-trigger", $("#searchForm")).hide();
					$("#eduOrgDupChk").val("Y");//교육기관 중복체크
					break;
				case "1": //전부 수정가능 
					$(".inSel1, .inSel2").removeClass("transparent").removeClass("hideSelectButton").attr("disabled",false).addClass("required");
					$(".inText1, .inText2").removeClass("transparent").attr("readonly",false).addClass("required");
					$("#eduSYmd, #eduEYmd").attr("readonly",true);
					$(".inImg").show();
					$(".ui-datepicker-trigger", $("#searchForm")).show();
					$("#realExpenseMon").removeClass("required");
					$("#realExpenseMon").mask('000,000,000,000,000', { reverse : true });
					$("#eduOrgDupChk").val("N");//교육기관 중복체크
					
					break;
				case "2": //과정 수정불가 , 회차 수정 가능  
					//입력가능.
					$(".inSel1").addClass("transparent").addClass("hideSelectButton").attr("disabled",true).removeClass("required");
					$(".inText1").addClass("transparent").attr("readonly",true).removeClass("required");
					$(".inSel2").removeClass("transparent").removeClass("hideSelectButton").attr("disabled",false).addClass("required");
					$(".inText2").removeClass("transparent").attr("readonly",false).addClass("required");
					$("#eduSYmd, #eduEYmd").attr("readonly",true);
					$(".inImg").hide();
					$(".ui-datepicker-trigger", $("#searchForm")).show();

					$("#realExpenseMon").removeClass("required");
					$('#realExpenseMon').mask('000,000,000,000,000', { reverse : true });
					$("#eduOrgDupChk").val("Y");//교육기관 중복체크
					
					break;
			}
				
		} catch (ex) {
			alert("changeEditForm() Script Error : " + ex);
		}
	}
	//신규과정등록
	function newEduCourse(){
		try {
			/**
			* inOutType값을 받기 위해 신규과정 버튼을 눌렀을때 신청내용 양식이 보이도록 변경 2021.06.30
			*/
			$("#newEduCourse").show();
			parent.iframeOnLoad($(".bodywrap").height());
			
			changeEditForm("1"); //전체 수정 가능
			//입력값 초기화
			$("#eduSeq, #eduCourseNm, #eduBranchCd, #eduMBranchCd, #eduOrgCd, #eduOrgNm, #eduMemo").val("");  //과정정보
			$("#eduEventSeq, #eduSYmd, #eduEYmd, #realExpenseMon, #laborApplyYn, #eduPlace").val(""); //회차정보
			$("#yearPlanYn, #jobCd, #jobNm, #note").val(""); //신청정보
			$("#inOutType").val("OUT");  //사외
			$("#eduOrgDupChk").val("N"); //교육기관 중복체크
			
			$("#evtClearBtn").hide(); //신규회차 버튼
			dupCheckEduYmd(1); //회차중복체크 완료
			
		} catch (ex) {
			alert("changeEditForm() Script Error : " + ex);
		}
	}
	//신규회차
	function newEduEvent(){
		try {
			$("#evtClearBtn").hide(); //신규회차 버튼
			changeEditForm("2"); //과정 수정불가 , 회차 수정 가능  
			//입력값 초기화
			$("#eduEventSeq, #eduSYmd, #eduEYmd").val(""); //회차정보
			$("#yearPlanYn, #note").val("");//신청정보
			$("#eduOrgDupChk").val("Y"); //교육기관 중복체크
			dupCheckEduYmd(0); //회차중복체크
			
		} catch (ex) {
			alert("newEduEvent() Script Error : " + ex);
		}
	}

	//교육기간 중복 체크 
	function checkEduYmd(){
		try {
			
			if( $("#eduSeq").val() == "" ) {
				dupCheckEduYmd(1); //중복체크 필요 없음.
			}
			if( $("#eduSYmd").val() == "" || $("#eduSYmd").val() == "" ){
				alert("<msg:txt mid='insertEduYmdMsg' mdef='교육기간을 입력 해주세요.'/>")
				dupCheckEduYmd(0); //초기화
				return;
			}
			$("#evtDupChk").val("Y");
			//중복체크 확인
			var map = ajaxCall( "${ctx}/EduApp.do?cmd=getEduAppDetEduEvtDup",$("#searchForm").serialize(),false);
			if ( map != null && map.DATA != null && map.DATA.eduEventSeq != "" ){
				$("#realExpenseMon").val(makeComma(map.DATA.realExpenseMon));
				$("#laborApplyYn").val(map.DATA.laborApplyYn);
				$("#eduPlace").val(map.DATA.eduPlace);	
				$("#eduEventSeq").val(map.DATA.eduEventSeq);
				changeEditForm("0"); //회차입력 불가.
			}
			dupCheckEduYmd(1); //중복체크 완료
		} catch (ex) {
			alert("checkEduYmd() Script Error : " + ex);
		}
	}
	

	//교육기간 중복 체크 
	function dupCheckEduYmd(gubun){
		if(  $("#eduSeq").val() == "" && gubun == 0 ){ //초기화
			$("#evtDupChkBtn").show();
			$("#evtDupChk").val("N");
			
		}else if( gubun == 1 ){ //OK
			$("#evtDupChkBtn").hide();
			$("#evtDupChk").val("Y");
		}
	}
	/**
	 * 상세내역 window open event
	 */
	function eduCourseMgrPopup(Row){
		if(!isPopup()) {return;}

		var w 		= 1050;
		var h 		= 600;
		var url 	= "${ctx}/EduApp.do?cmd=viewEduCourseMgrPopup&authPg=R";
		var args 	= new Array(34);
		args["eduSeq"]     = sheet2.GetCellValue(Row, "eduSeq");	
		
		gPRow = Row;
		pGubun = "eduCourseMgrPopup";

		openPopup(url,args,w,h);
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
		
		if( ch ){
			
			if( $("#eduOrgDupChk").val() == "N"){
				alert("<msg:txt mid='eduOrgDupChkMsg' mdef='교육기관을 입력 해주세요.'/>")
				$("#eduOrgNm").focus();
				ch =  false;
				return false;
			}
			
			if( $("#evtDupChk").val() == "N"){
				alert("<msg:txt mid='eduOrgDupChkMsg' mdef='교육기관을 입력 해주세요.'/>")
				ch =  false;
				return false;
			}
			
			//중복체크 확인
			var map = ajaxCall( "${ctx}/EduApp.do?cmd=getEduAppDetDupChk",$("#searchForm").serialize(),false);
			if ( map != null && map.DATA != null ){
				if( map.DATA.cnt != "0" ){
					alert("<msg:txt mid='appDupErrMsg' mdef='동일한 신청 건이 있어 신청 할 수 없습니다.'/>")
					ch =  false;
					return false;
				}

			}
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
			var data = ajaxCall("${ctx}/EduApp.do?cmd=saveEduAppDet",$("#searchForm").serialize(),false);
			
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
	

	//--------------------------------------------------------------------------------
	//  팝업
	//--------------------------------------------------------------------------------
	//교육기관 팝업
	function doSearchEduOrgNm() {
		if (!isPopup()) { return;}

		gPRow = "";
		pGubun = "searchEduOrgPopup";
		var args = new Array();
		args["searchEduOrgNm"] = $("#eduOrgNm").val();
		args["authPg"] = "A";

		$("#eduOrgDupChk").val("Y");

		let eduOrgLayer = new window.top.document.LayerModal({
			id: 'eduOrgLayer',
			url: '/Popup.do?cmd=viewEduOrgLayer&authPg=A',
			parameters: {},
			width: 620,
			height: 570,
			title: '교육기관 리스트 조회',
			trigger :[
				{
					name : 'eduOrgLayerTrigger',
					callback : function(rv){
						$("#eduOrgCd").val(rv["eduOrgCd"]); //교육기관
						$("#eduOrgNm").val(rv["eduOrgNm"]); //교육기관
					}
				}
			]
		});

		eduOrgLayer.show();
	}
	//직무팝업
	function doSearchEduJobNm() {
		if (!isPopup()) { return;}

		gPRow = "";
		pGubun = "jobPopup";
		
		var args = new Array();
		args["searchJobNm"] = $("#jobNm").val();

		let jobPopupLayer = new window.top.document.LayerModal({
			id : 'jobPopupLayer'
			, url : "${ctx}/Popup.do?cmd=jobPopup&authPg=${authPg}"
			, parameters: args
			, width : 840
			, height : 520
			, title : "직무 리스트 조회"
			, trigger :[
				{
					name : 'jobPopupTrigger'
					, callback : function(rv){
						$("#jobCd").val(rv.jobCd); //직무코드
						$("#jobNm").val(rv.jobNm); //직무명
					}
				}
			]
		});
		jobPopupLayer.show();
	}
</script>
<style type="text/css">
select[disabled] {color:#000;}
span.noti { color:#454545; font-weight: normal;font-style : oblique; font-size:11px;padding-right:10px;}
</style> 
</head>
<body class="bodywrap">
<div class="wrapper">
<c:if test="${authPg == 'A' }">
	<div id="divEdiList" style="background-color:#fff;padding:15px;border:1px solid #b1b1b1;display:none;">
		<form id="sheet2Form" name="sheet2Form" >
		<!-- 조회조건 -->
		<div class="sheet_search sheet_search_noimg">
			<table>
			<tr>
				<th><tit:txt mid='201707040000006' mdef='교육시작일'/></th>
				<td>
					<input id="searchEduSYmd" name="searchEduSYmd" type="text" class="date2" value=""/>&nbsp;&nbsp;~&nbsp;&nbsp;
					<input id="searchEduEYmd" name="searchEduEYmd" type="text" class="date2" value=""/>
				</td>	
				<th><tit:txt mid='113788' mdef='교육과정명'/></th>
				<td>
					<input id="searchEduCourseNm" name ="searchEduCourseNm" type="text" class="text w110"/>
				</td>
				<td>
					<a href="javascript:doAction1('SearchEdu')" class="button">조회</a>
				</td>
			</tr>
			</table>
		</div>
		</form>
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='eduCoursePop' mdef='교육과정 리스트 조회'/></li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "200px", "${ssnLocaleCd}"); </script>
	</div>
</c:if>

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
	
	<input type="hidden" id="eduSeq"			name="eduSeq"	     	 value=""/>
	<input type="hidden" id="eduEventSeq"		name="eduEventSeq"	     value=""/>
	<input type="hidden" id="inOutType"			name="inOutType"	     value=""/>
	
	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
			<li class="btn">
				<a href="javascript:newEduCourse();" class="button authA" id="clearBtn">신규과정</a>
			</li>
		</ul>
	</div>
	<table id="newEduCourse" class="table" style="display:none;">
		<colgroup>
			<col width="110px" />
			<col width="" />
			<col width="110px" />
			<col width="35%" />
		</colgroup>
	
		<tr>
			<th><tit:txt mid='113788' mdef='교육과정명'/></th>
			<td colspan="3">
				<input type="text" id="eduCourseNm" name="eduCourseNm" class="${textCss} ${required} inText1" ${readonly} style="max-width: 500px;"/>
				<a onclick="javascript:doAction1('DupCheck');return false;" class="inImg basic authA" id="eduDupChkBtn">중복조회</a>
			</td>
		</tr>	
		<tr>
			<th><tit:txt mid='104566' mdef='교육구분'/></th>
			<td>
				<select id="eduBranchCd" name="eduBranchCd" class="${selectCss} ${required} inSel1 w90p" ${disabled}></select>
			</td> 
			<th><tit:txt mid='eduMBranchPopV1' mdef='교육분류'/></th>
			<td>
				<select id="eduMBranchCd" name="eduMBranchCd" class="${selectCss} ${required} inSel1 w90p" ${disabled}></select>
			</td>
		</tr>	 
		<tr>
			<th><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></th>
			<td>
				<input type="hidden" id="eduOrgDupChk" name="eduOrgDupChk" value="N"/>
				<input type="hidden" id="eduOrgCd" name="eduOrgCd" />
				<input type="text" id="eduOrgNm" name="eduOrgNm" class="${textCss} w200 ${required} inText1 readonly" readonly/>
				<a onclick="javascript:doSearchEduOrgNm();return false;" class="inImg button6 authA" id="eduOrgDupChkBtn"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>		
			<th><tit:txt mid='103973' mdef='관련직무'/></th>
			<td>
				<input type="hidden" id="jobCd" name="jobCd" />
				<input type="text" id="jobNm" name="jobNm" class="${textCss} w70p ${required} inText1 readonly" readonly/>
				<a onclick="javascript:doSearchEduJobNm();return false;" class="inImg button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104071' mdef='교육내용'/></th>
			<td colspan="3"><textarea id="eduMemo" name="eduMemo" rows="4" class="${textCss} w100p ${required} inText1" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		<tr>
			<th><tit:txt mid='eduEventMgrPopV2' mdef='교육기간'/></th>
			<td> 
				<input type="hidden" id="evtDupChk" name="evtDupChk"/>
				<input type="text" id="eduSYmd" name="eduSYmd" class="${dateCss} w80 ${required} inText2" readonly/> ~ 
				<input type="text" id="eduEYmd" name="eduEYmd" class="${dateCss} w80 ${required} inText2" readonly/>
				<a onclick="javascript:checkEduYmd();return false;" class="basic authA" id="evtDupChkBtn">중복체크</a>
				<span style="float:right;"><a href="javascript:newEduEvent();" class="button authA" id="evtClearBtn">신규회차</a></span>
			</td>	
			<th><tit:txt mid='104078' mdef='교육장소'/></th>
			<td> 
				<input type="text" id="eduPlace" name="eduPlace" class="${dateCss} w80p inText2" ${readonly} maxlength="30"/>
			</td>	
		</tr>
		<tr>
			<th><tit:txt mid='eduAppDetOutSideV3' mdef='교육비용'/></th>
			<td> 
				<input type="text" id="realExpenseMon" name="realExpenseMon" class="${dateCss} w80 inText2" ${readonly}/>
			</td>	
			<th><tit:txt mid='empInsure' mdef='고용보험'/></th>
			<td>
				<select id="laborApplyYn" name="laborApplyYn" class="${selectCss} ${required} inSel2 w80" ${disabled}>
					<option value="N"><tit:txt mid='laborApplyN' mdef='미환급'/></option>
					<option value="Y"><tit:txt mid='laborApplyY' mdef='환급'/></option>
				</select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='yearPlanYn' mdef='사업계획입안'/></th>
			<td colspan="3"> 
				<select id="yearPlanYn" name="yearPlanYn" class="${selectCss} ${required} w80" ${disabled}>
					<option value="N"><tit:txt mid='yearPlanN' mdef='미입안'/></option>
					<option value="Y"><tit:txt mid='yearPlanY' mdef='입안'/></option>
				</select>
			</td>	
			
		</tr>
		<tr>
			<th><tit:txt mid='103783' mdef='비고' /></th>
			<td colspan="3"><textarea id="note" name="note" rows="2" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
	</table>
</div>

</body>
</html>

