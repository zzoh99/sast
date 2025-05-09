<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>인적공제</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var scrolling = true;
	var loadSheetFlag = false;
	
	var agent = navigator.userAgent.toLowerCase();
	
	if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
	} else{
		window.addEventListener('scroll', handleScroll);
	}
	
	// 스크롤 이벤트 핸들러
	function handleScroll() {
	    if (scrolling) {
	        // 스크롤 중일 때 추가 동작을 막음 - 페이지 로딩시에 스크롤 되는동작 막음
	        window.scrollTo(0, 0);
	    }
	}

    var orgAuthPg = "<%=orgAuthPg%>";
    //도움말
    var helpText1;
    var helpText2;
    //기준년도
    var systemYY;
  	//총급여
    var paytotMonStr;
    //총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
    var yeaMonShowYn;
    var zipcodePg = "";
    //기본공제 붉은색 표시 시 원래 색상 돌리기 위한 array
    var defaultColor = new Array();
    //기본공제 미체크->체크 여부를 확인하기 위한 array
    var defaultValue = new Array();
    //전년도
    var yeaYear = "<%=yeaYear%>";
    yeaYear = yeaYear-1;
    //0:확정, 1:확정취소
	var confirmCheckYn ="";
	var mAge = 0;
	/* 2023.10.31수정:장애구분(국세청 참조용) 사용안함
	var hndcp_yn_nts ='N'; 
	var hndcp_yn_nts_match ='N';*/
    /* 과거인적공제현황 버튼 기능 */
    $(document).ready(function(){
    	//장애인등록증현황, 과거인적공제현황 hide() 혹은 show()에 파라미터 입력 후 버튼 클릭시 간헐적으로 시트에 버그 발생하여 파라미터 제거 
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
    	$("#buttonMinus").hide();
    	//jQuery('#buttonMinus').css("display", "none");
		$("#openYeaDataPerBef_main").hide();
		$("#createIBSheet").hide();
		$('#searchBfYear').val(yeaYear);
		//$("#sheet_search").hide("fast");

		$("#searchBfYear").bind("keyup",function(event){
            makeNumber(this,"A");
            if( event.keyCode == 13){
                doAction2("Search");
                $(this).focus();
            }
        });

    	//과거 인적공제 현황+ 버튼 선택시 과거 인적공제 현황- 버튼 호출
    	$("#buttonPlus").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "buttonPlus"){
	    			$("#buttonMinus").show();
	    			$("#buttonPlus").hide();
	    		}
    	});

    	//과거 인적공제 현황- 버튼 선택시 과거 인적공제 현황+ 버튼 호출
    	$("#buttonMinus").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "buttonMinus"){
	    			$("#buttonPlus").show();
	    			$("#buttonMinus").hide();
	    		}
		});

    	//과거 인적공제 현황+ 선택시 화면 호출
    	//장애인등록증현황, 과거인적공제현황 hide() 혹은 show()에 파라미터 입력 후 버튼 클릭시 간헐적으로 시트에 버그 발생하여 파라미터 제거
    	$("#buttonPlus").click(function(){
    		$("#createIBSheet").show();
            $("#buttonPlus2").hide();
            $("#buttonMinus2").show();
            $("#openYeaDataPerBef_main").show();

            setTimeout(function() {
                sheetResize();
            }, 500);
        });

    	//과거 인적공제 현황- 선택시 화면 숨김
    	//장애인등록증현황, 과거인적공제현황 hide() 혹은 show()에 파라미터 입력 후 버튼 클릭시 간헐적으로 시트에 버그 발생하여 파라미터 제거
    	$("#buttonMinus").click(function(){
    		$("#createIBSheet").hide();
            $("#buttonPlus2").show();
            $("#buttonMinus2").hide();
            $("#openYeaDataPerBef_main").hide();
        });

    	//과거 인적공제 현황+ 선택시 화면 호출
    	//장애인등록증현황, 과거인적공제현황 hide() 혹은 show()에 파라미터 입력 후 버튼 클릭시 간헐적으로 시트에 버그 발생하여 파라미터 제거
    	$("#buttonPlus2").click(function(){
    		$("#createIBSheet").show();
            $("#buttonPlus").hide();
            $("#buttonMinus").show();
            $("#openYeaDataPerBef_main").show();

            setTimeout(function() {
                sheetResize();
            }, 500);
        });

    	//과거 인적공제 현황- 선택시 화면 숨김
    	//장애인등록증현황, 과거인적공제현황 hide() 혹은 show()에 파라미터 입력 후 버튼 클릭시 간헐적으로 시트에 버그 발생하여 파라미터 제거
    	$("#buttonMinus2").click(function(){
    		$("#createIBSheet").hide();
            $("#buttonPlus").show();
            $("#buttonMinus").hide();
            $("#openYeaDataPerBef_main").hide();
        });

    	//장애인등록증 현황+ 선택시 화면 호출
    	//장애인등록증현황, 과거인적공제현황 hide() 혹은 show()에 파라미터 입력 후 버튼 클릭시 간헐적으로 시트에 버그 발생하여 파라미터 제거
    	$(".buttonPlus3").click(function(){
    		//$("#createIBSheet").show("slow");
            $(".buttonPlus3").hide();
            $(".buttonMinus3").show();
            $("#hndcpRegInfo").show();

            setTimeout(function() {
            	sheetResize();
			}, 500);
        });

    	//장애인등록증 현황- 선택시 화면 숨김
    	//장애인등록증현황, 과거인적공제현황 hide() 혹은 show()에 파라미터 입력 후 버튼 클릭시 간헐적으로 시트에 버그 발생하여 파라미터 제거
    	$(".buttonMinus3").click(function(){
    		//$("#createIBSheet").hide("fast");
            $(".buttonPlus3").show();
            $(".buttonMinus3").hide();
            $("#hndcpRegInfo").hide();
        });


    	/* 기본공제안내 버튼 기능 Start */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#basicInfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "basicInfoPlus"){
	    			$("#basicInfoMinus").show();
	    			$("#basicInfoPlus").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#basicInfoMinus").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "basicInfoMinus"){
	    			$("#basicInfoPlus").show();
	    			$("#basicInfoMinus").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#basicInfoPlus").click(function(){
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#basicInfoMinus").click(function(){
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
        });
    	/* 기본공제안내 버튼 기능 End */


    	/* 추가공제안내 버튼 기능 Start */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#addInfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "addInfoPlus"){
	    			$("#addInfoMinus").show();
	    			$("#addInfoPlus").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#addInfoMinus").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "addInfoMinus"){
	    			$("#addInfoPlus").show();
	    			$("#addInfoMinus").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#addInfoPlus").click(function(){
    		$("#infoLayer2").show("fast");
    		$("#infoLayerMain2").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#addInfoMinus").click(function(){
    		$("#infoLayer2").hide("fast");
    		$("#infoLayerMain2").hide("fast");
        });
    	/* 추가공제안내 버튼 기능 End */

    });

  	//기본공제안내 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#infoLayerMain").fadeOut();
    		$("#addInfoMinus").hide();
    		$("#addInfoPlus").show();
    		$("#basicInfoMinus").hide();
    		$("#basicInfoPlus").show();
    	}
    });

  	//추가공제안내 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer2 div").is(e.target)&&$("#infoLayer2 div").has(e.target).length==0){
    		$("#infoLayer2").fadeOut();
    		$("#infoLayerMain2").fadeOut();
    		$("#addInfoMinus").hide();
    		$("#addInfoPlus").show();
    		$("#basicInfoMinus").hide();
    		$("#basicInfoPlus").show();
    	}
    });

    //기본정보
    $(function() {
        $("#searchWorkYy").val($("#searchWorkYy", parent.document).val());
        $("#searchAdjustType").val($("#searchAdjustType", parent.document).val());
        $("#searchSabun").val($("#searchSabun", parent.document).val());
        systemYY = $("#searchWorkYy", parent.document).val();

        //기본정보 조회(도움말 등등).
        initDefaultData();

        //총급여 옵션이 Y이면 총급여 버튼 보여준다.
        if( yeaMonShowYn == "Y"){
            $("#paytotMonViewYn").show() ;
        }else if(yeaMonShowYn == "A"){
            if(orgAuthPg == "A") {
                $("#paytotMonViewYn").show() ;
            }else{
                $("#paytotMonViewYn").hide() ;
            }
        }else{
            $("#paytotMonViewYn").hide() ;
        }
    });

    //쉬트 초기화
    $(function() {
        /* 1번 그리드 */
        var initdata1 = {};
        initdata1.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",             Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제",           Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태",           Type:"<%=sSttTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"년도",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"work_yy",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adjust_type",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사번",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"관계",                Type:"Combo",       Hidden:0,   Width:100,   Align:"Center", ColMerge:0, SaveName:"fam_cd",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"성명",                Type:"Text",        Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"fam_nm",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"주민등록번호",        Type:"Text",        Hidden:0,    Width:100,   Align:"Center", ColMerge:0, SaveName:"famres",              KeyField:1, Format:"IdNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200, FullInput:1 },
            {Header:"주민등록번호\n체크",   Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"famresChk",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"만 나이",                Type:"Text",        Hidden:0,   Width:45,   Align:"Center", ColMerge:0, SaveName:"age",                 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"연령대",              Type:"Combo",       Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"age_type",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"소득금액\n기준\n초과 여부",Type:"CheckBox",    Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"exceed_income_yn",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"학력",                Type:"Combo",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"aca_cd",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"기본\n공제",          Type:"CheckBox",    Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"dpndnt_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"기본\n공제",          Type:"CheckBox",    Hidden:1,   Width:40,   Align:"Center", ColMerge:0, SaveName:"dpndnt_sts",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"배우자\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"spouse_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"경로\n우대",          Type:"CheckBox",    Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"senior_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애인\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"hndcp_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애구분",          Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"hndcp_type",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            /* 2022.12.30 국세청에서 제공하는 장애인자료제공 용 */
            //{Header:"장애구분\n국세청제공(참조용)",          Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"hndcp_type_nts",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"부녀자\n공제",         Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"woman_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"사업장",              Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"business_place_cd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"보험료",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"insurance_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"의료비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"medical_yn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"교육비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"education_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"신용\n카드등",        Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"credit_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"우편번호",            Type:"Popup",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"zip",                 KeyField:0, Format:"PostNo",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:6 },
            {Header:"주소",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr1",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"상세주소",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr2",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"다른곳에 등록된 수",  Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"incnt",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            /* 20181101 6세이하 자녀양육 제거 및 관련 로직 제거 */
            //{Header:"6세이하\n자녀양육",   Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"child_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"자녀세액\n공제",      Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"add_child_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"출산/입양\n공제",      Type:"CheckBox",    Hidden:0,   Width:55,   Align:"Center", ColMerge:0, SaveName:"adopt_born_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"자녀\n순서",          Type:"Combo",       Hidden:0,   Width:75,   Align:"Center", ColMerge:0, SaveName:"child_order",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"한부모\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"one_parent_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"자녀세액\n공제해제",  Type:"Html",  	Hidden:0,  Width:80,	Align:"Center",  	ColMerge:0,   SaveName:"init",   	 	KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:1},
            {Header:"전년도\n대상여부",    Type:"Text",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"pre_equals_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"갱신일시",    Type:"Text",    Hidden:0,   Width:150,   Align:"Center", ColMerge:0, SaveName:"chkdate",           KeyField:0, Format:"YmdHms",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"확정 여부",           Type:"Text",    Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"input_status",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var famCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00309"), "");
		var acaCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20130"), "");
		var childOrder = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00326"), "");

        sheet1.SetColProperty("child_order", {ComboText:"|"+childOrder[0], ComboCode:"|"+childOrder[1]} );
        sheet1.SetColProperty("fam_cd", {ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
        sheet1.SetColProperty("aca_cd", {ComboText:"|"+acaCdList[0], ComboCode:"|"+acaCdList[1]} );
        sheet1.SetColProperty("hndcp_type", {ComboText:"|장애인복지법에 따른 장애인|국가유공자 등 예우 및 지원에 관한 법률에 따른 자|그 외 중증환자", ComboCode:"|1|2|3"});
        //sheet1.SetColProperty("hndcp_type_nts", {ComboText:"|장애인복지법에 따른 장애인|국가유공자 등 예우 및 지원에 관한 법률에 따른 자|그 외 중증환자", ComboCode:"|1|2|3"});
        sheet1.SetColProperty("age_type", {ComboText:"|만18세미만|만20세이하|만60세이상", ComboCode:"|18-|20-|60+"} );

		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		var zipcodeRefYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=ZIPCODE_REF_YN", "queryId=getSystemStdData",false).codeList;
		if ( zipcodeRefYn != null && zipcodeRefYn.length>0) {
			if(zipcodeRefYn[0].code_nm == "Y") {
                zipcodePg = "Ref";
            } else if(zipcodeRefYn[0].code_nm == "W") {
                zipcodePg = "new";
            }
		}

        checkWoman();
        // checkHndcpMapping();
        parent.doSearchCommonSheet();
        //doAction1("Search");


        /* 2번 그리드 */

        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata2.Cols = [
            {Header:"No",             Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제",           Type:"<%=sDelTy%>", Hidden:1,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태",           Type:"<%=sSttTy%>", Hidden:1,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"귀속년도",            Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"work_yy",             KeyField:1, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adjust_type",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사번",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"관계",                Type:"Combo",       Hidden:0,   Width:100,   Align:"Center", ColMerge:0, SaveName:"fam_cd",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"성명",                Type:"Text",        Hidden:0,   Width:60,   Align:"Center",   ColMerge:0, SaveName:"fam_nm",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"주민등록번호",        Type:"Text",        Hidden:0,   Width:100,   Align:"Center", ColMerge:0, SaveName:"famres",              KeyField:1, Format:"IdNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200, FullInput:1 },
            {Header:"주민등록번호\n체크",   Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"famresChk",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"나이",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"age",                 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"연령대",              Type:"Combo",       Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"age_type",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"학력",                Type:"Combo",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"aca_cd",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"소득금액\n기준\n초과 여부",Type:"CheckBox",    Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"exceed_income_yn",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"기본\n공제",          Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"dpndnt_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"기본\n공제",          Type:"CheckBox",    Hidden:1,   Width:40,   Align:"Center", ColMerge:0, SaveName:"dpndnt_sts",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"배우자\n공제",        Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"spouse_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"경로\n우대",          Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"senior_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애인\n공제",        Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"hndcp_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애\n구분",          Type:"Combo",       Hidden:0,   Width:100,   Align:"Center", ColMerge:0, SaveName:"hndcp_type",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"부녀자\n공제",        Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"woman_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"사업장",              Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"business_place_cd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"보험료",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"insurance_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"의료비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"medical_yn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"교육비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"education_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"신용\n카드등",        Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"credit_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"우편번호",            Type:"Popup",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"zip",                 KeyField:0, Format:"PostNo",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:6 },
            {Header:"주소",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr1",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"상세주소",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr2",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"다른곳에 등록된 수",  Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"incnt",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"자녀세액\n공제",      Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"add_child_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"6세이하\n자녀양육",   Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"child_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"출산입양\n공제",      Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adopt_born_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"한부모\n공제",        Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"one_parent_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"전년도\n대상여부",    Type:"Text",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_equals_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var famCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00309"), "");
		var acaCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20130"), "");

        sheet2.SetColProperty("fam_cd", {ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
        sheet2.SetColProperty("aca_cd", {ComboText:"|"+acaCdList[0], ComboCode:"|"+acaCdList[1]} );
        sheet2.SetColProperty("hndcp_type", {ComboText:"|장애인복지법에 따른 장애인|국가유공자 등 예우 및 지원에 관한 법률에 따른 자|그 외 중증환자", ComboCode:"|1|2|3"} );
        sheet2.SetColProperty("age_type", {ComboText:"|만18세미만|만20세이하|만60세이상", ComboCode:"|18-|20-|60+"} );

	    /* 3번 그리드 - 장애인등록증 현황 */
        var initdata3 = {};
        initdata3.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
        initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata3.Cols = [
        	{Header:"No|No",             		Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", 	ColMerge:0, SaveName:"sNo" },
            {Header:"삭제|삭제",           		Type:"<%=sDelTy%>", Hidden:0,			Width:"<%=sDelWdt%>",   Align:"Center", 	ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",           		Type:"<%=sSttTy%>", Hidden:0,			Width:"<%=sSttWdt%>",   Align:"Center", 	ColMerge:0, SaveName:"sStatus", Sort:0 },
        	{Header:"사번|사번",			    	Type:"Text",		Hidden:1,   		Width:60,   			Align:"Center",   	ColMerge:1, SaveName:"sabun",			KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
        	{Header:"등록년도|등록년도",			    Type:"Text",		Hidden:0,   		Width:40,   			Align:"Center",   	ColMerge:1, SaveName:"work_yy",			KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
        	{Header:"정산구분|정산구분",				Type:"Combo",		Hidden:1,   		Width:60,   			Align:"Center",   	ColMerge:1, SaveName:"adjust_type",		KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"장애구분|장애구분",				Type:"Combo",		Hidden:0,   		Width:150,   			Align:"Center",   	ColMerge:1, SaveName:"hndcp_type",		KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"성명|성명",			    	Type:"Text",		Hidden:0,   		Width:60,   			Align:"Center",   	ColMerge:1, SaveName:"fam_nm",			KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"주민등록번호|주민등록번호",        Type:"Text",        Hidden:0,    		Width:100,   			Align:"Center", 	ColMerge:0, SaveName:"famres",          KeyField:0, Format:"IdNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200, FullInput:1 },
			{Header:"주민등록번호|주민등록번호\n체크",   Type:"Text",        Hidden:1,   			Width:60,   			Align:"Center", 	ColMerge:0, SaveName:"famresChk",       KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"적용기간|시작일",				Type:"Date",    	Hidden:0,   		Width:90,   			Align:"Center",		ColMerge:1, SaveName:"sdate",       	KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"적용기간|종료일",				Type:"Date",    	Hidden:0,   		Width:90,   			Align:"Center",		ColMerge:1, SaveName:"edate",       	KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"비고|비고",			    	Type:"Text",		Hidden:0,   		Width:150,   			Align:"Center",   	ColMerge:1, SaveName:"bigo",			KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:300 }


		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("<%=editable%>");sheet3.SetVisible(true);sheet3.SetCountPosition(0);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );

		sheet3.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet3.SetColProperty("hndcp_type", {ComboText:"|장애인복지법에 따른 장애인|국가유공자 등 예우 및 지원에 관한 법률에 따른 자|그 외 중증환자", ComboCode:"|1|2|3"} );


		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn01").hide() ;
			$("#btnDisplayYn02").hide() ;
			$("#btnDisplayYn03").hide() ;
			try { sheet1.SetEditable(false) ; } catch(e) { /* alert("sheet1" + e); */ }
			try { sheet2.SetEditable(false) ; } catch(e) { /* alert("sheet2" + e); */ }
			try { sheet3.SetEditable(false) ; } catch(e) { /* alert("sheet3" + e); */ }
		}

        $("#hndcpRegInfo").hide();

        // 2021.02.22 - 갱신일자 활성화(관리자 페이지일 경우에만)
        if(orgAuthPg == "A"){
        	sheet1.SetColHidden("chkdate",0);
        	$("#chgSelfInfo").show() ; //본인정보변경
        }else{
        	sheet1.SetColHidden("chkdate",1);
        	$("#chgSelfInfo").hide();
        }
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    //sheet1 action
    function doAction1(sAction) {

        switch (sAction) {
        case "Search":
            //인적공제 조회
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectYeaDataPerList", $("#sheetForm").serialize() );
            break;
        case "Save":
            if(!parent.checkClose())return;

        	var saveMsgYn = "N" ;
        	var status = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");

			if(sheet1.RowCount("D") > 0) {
				if(! confirm("부양가족 정보 삭제시 해당 부양가족의 공제 자료도 같이 삭제됩니다. 삭제하시겠습니까?"))
					return;
			}

            for(var row = 1; row <= sheet1.GetTotalRows(); row++) {
                if( sheet1.GetCellValue(row, "famres") != "" ) {
                    //연령계산
                    var age = 0 ;
                    if( sheet1.GetCellValue(row, "famres").substring(6,7) == "3"
                            || sheet1.GetCellValue(row, "famres").substring(6,7) == "4"
                            || sheet1.GetCellValue(row, "famres").substring(6,7) == "7"
                            || sheet1.GetCellValue(row, "famres").substring(6,7) == "8"  ) {
                        age = systemYY - parseInt("20" + sheet1.GetCellValue(row, "famres").substring(0,2) , 10) ;
                    } else {
                        age = systemYY - parseInt("19" +  sheet1.GetCellValue(row, "famres").substring(0,2) , 10) ;
                    }

                    //2022.11.10 - 소득자의 직계존속, 배우자의 직계존속일 경우 본인(근로자)보다 어릴경우 입력불가.
                    if( sheet1.GetCellValue(row, "fam_cd") == "1" || sheet1.GetCellValue(row, "fam_cd") == "2" ) {
                        if(sheet1.GetCellValue(row, "sStatus") == "I" || sheet1.GetCellValue(row, "sStatus") == "U"){
							if(mAge > sheet1.GetCellValue(row, "age")){
								alert("직계존속으로 저장이 가능하지 않습니다.\n관계 또는 주민등록번호 다시 확인 바랍니다.");
								sheet1.SetSelectRow(row);
								return;
							}
                        }

                        if( sheet1.GetCellValue(row, "dpndnt_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_yn") == "N" ) {
                            if(age < 60) {
                                alert("직계존속 연령은 만 60세 이상이어야 합니다. <"+sheet1.GetCellValue(row, "fam_nm")+">") ;
                                return ;
                            }
                        }
                    }

                    if( sheet1.GetCellValue(row, "fam_cd") == "4" || sheet1.GetCellValue(row, "fam_cd") == "5" ) {
                        if( sheet1.GetCellValue(row, "dpndnt_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_yn") == "N" ) {
                            if(age > 20) {
                                alert( "직계비속 연령은 만 20세 이하이어야 합니다. <"+sheet1.GetCellValue(row, "fam_nm")+">" ) ;
                                return ;
                            }
                        }
                    }

                    /*
                    라. 저장시 "장애인공제"에 체크되어 있는 상태에서 "장애 구분"이 미 선택되어 있으면, 다음 안내 멘트와 함께 저장 불가
                        "장애인공제 대상자의 장애구분을 선택하여 주시기 바랍니다."
                    */
                    if ( sheet1.GetCellValue(row, "hndcp_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_type") == "" ) {
                        alert("장애인공제 대상자의 장애구분을 선택하여 주시기 바랍니다.");
                        return;
                    }

                    /*
                    마. 저장시 "기본공제" 대상자로 체크되어 있는데, "장애인공제"에 체크가 안되어 있고, "장애 구분"에 체크되어 있으면, 다음 안내 멘트와 함께 저장 불가
                        "장애 구분이 선택된 기본 공제 대상자는 장애인공제 대상자입니다. 장애인공제에 클릭하여 주시거나, 장애구분을 선택하지 마십시오."
                    */
                    if ( sheet1.GetCellValue(row, "dpndnt_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_yn") == "N" && sheet1.GetCellValue(row, "hndcp_type") != "" ) {
                        alert("장애 구분이 선택된 기본 공제 대상자는 장애인공제 대상자입니다. 장애인공제에 클릭하여 주시거나, 장애구분을 선택하지 마십시오.");
                        return;
                    }

                }
                /*기본공제가 미체크에서 체크 된 경우를 발라내어 해당 경우에 다른 저장 경고메시지를 뿌릴 수 있도록 한다.(수정시만 해당됨)*/
                if( (sheet1.GetCellValue(row, "dpndnt_yn") != defaultValue[row] &&
                	sheet1.GetCellValue(row, "dpndnt_yn") == "Y" &&
                	sheet1.GetCellValue(row, "sStatus") == "U") || (sheet1.GetCellValue(row, "sStatus") == "I" && sheet1.GetCellValue(row, "dpndnt_yn") == "Y") ) {
                	saveMsgYn = "Y" ;
                }

                if(sheet1.GetCellValue(row, "adopt_born_yn") == "Y" && sheet1.GetCellValue(row, "child_order") == ""){
                	alert("출산입양 공제 항목이 선택 되어 있을 경우, 자녀 순서를 선택하여 주시기 바랍니다.");
                	return;
                }                
            }
            
            /* 22.12.21 입력시 화면단에서 먼저 중복 체크 */
            if (! dupChk(sheet1, "work_yy|adjust_type|famres", false, true)) {
            	break;
            }

            if( saveMsgYn == "Y") {
            	if( !confirm("기본공제 및 추가공제 사항의 요건을\n정확히 확인하여 주시기 바랍니다.\n저장 하시겠습니까? ") ) return ;
	            	if ( 0 < status ){
	            		sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveYeaDataPer", "", -1, false);
	            	}
            } else {
            	if(confirmCheckYn == "0"){
            		if ( 0 < status ){
            			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveYeaDataPer", "", -1, false);
            		}
            	}
            }

            break;
        case "Insert":
            if(!parent.checkClose())return;

            var newRow = sheet1.DataInsert(0) ;
            sheet1.SetCellBackColor( newRow, "dpndnt_yn", "#FF0000" );
            sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
            sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
            sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

            sheet1.SetCellBackColor( newRow, "last_fam_yn", "#6CC5EA" );
            sheet1.SetCellValue( newRow, "last_fam_yn", "N" );

            sheet1.SetCellEditable(newRow,"child_order", 0) ;

            sheet1.SelectCell(newRow, 2) ;
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
            sheet1.Down2Excel(param);
            break;
        case "confirm":
        	
        	/* 2022.12.30 국세청에서 제공하는 장애인자료제공 용 */
        	/* 2023.10.31수정:장애구분(국세청 참조용) 사용안함
            if(hndcp_yn_nts_match =='Y'&& sheet1.GetCellValue(1, "input_status")=="01"){
            	if(!confirm("'장애구분(사용자입력)'과 '장애구분 국세청제공(참조용)'이 일치하지 않는 대상자가 존재합니다.\n이대로 진행하시겠습니까?")){
                    break;
                }
            }
        */
	        for(var row = 1; row <= sheet1.GetTotalRows(); row++) {
	        	 if ( sheet1.GetCellValue(row, "hndcp_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_type") == "" ) {
                     alert("장애인공제 대상자의 장애구분을 선택하여 주시기 바랍니다.");
                     return;
                 }
	        }
        
        	if(!confirm($("#authText").text() + " 하시겠습니까?")){
                break;
            }

        	var inputStatus = "1";

        	if($("#authText").text() == "확정") {
                var authChk = ajaxCall("<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectAuthChk","work_yy="+$("#searchWorkYy").val(),false);

                if(authChk.Data.chk_823 != null && authChk.Data.chk_851 != null ){
                    if(authChk.Data.chk_823 > authChk.Data.chk_851){
                        alert("인적공제 정보가 변경된 인원에 대해서는 해당 인원의\nPDF파일을 재업로드 해야합니다.");
                    }
                }
                inputStatus = "1";
        	} else {
        		inputStatus = "0";
        	}

        	var params = "input_status=" + inputStatus;
                params += "&work_yy="+$("#searchWorkYy").val();
                params += "&adjust_type="+$("#searchAdjustType").val();
                params += "&sabun="+$("#searchSabun").val();

            var result1 = ajaxCall("<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveYeaDataPerConfirm",params,false);

            if( result1.Result.Code == "1") {
            	doAction1("Save");
            }
            doAction1("Search");

        	break;
        }
    }

    //여자인지 남자인지 체크하여 부여자가장 yeaSheet6 컬럼 보여주지 않기
    function checkWoman() {
        var resNo = $("#searchRegNo", parent.document).val();

        if(resNo != "") {
            var flag = resNo.substring(6,7);
            if(flag == "1" || flag == "3" || flag == "5" || flag == "7"){
                sheet1.SetCellEditable(1,"woman_yn", 0) ;
                sheet1.SetColHidden("woman_yn", 1) ;
                //여성만 인적공제 3천만원 확인버튼 나오도록 처리 - 2020.01.16
                $("#paytotMonViewYn").hide() ;
            }else{
                sheet1.SetColHidden("woman_yn", 0) ;
            }
        }
    }
    
    /*
    2023.10.31수정:장애구분(국세청 참조용) 사용안함
    function checkHndcpMapping() {
    	
        var loop = sheet1.LastRow();
        for(loop = 1 ; loop <= sheet1.LastRow() ; loop++){
            if(  sheet1.GetCellValue(loop,"hndcp_type") != sheet1.GetCellValue(loop,"hndcp_type_nts")  ) {
            	hndcp_yn_nts_match='Y'; //국세청 자료에 장애인증명자료와 설정된 장애인여부와 다른지 체크
            	break;
            }else{
            	hndcp_yn_nts_match='N';
            }
        	
        }

    }
    */

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            //alertMessage(Code, Msg, StCode, StMsg);
			
            if (Code == 1) {
            	//sheetSet() ;
                var loop = sheet1.LastRow();
                var inputStatus = sheet1.GetCellValue(1, "input_status");
                for(loop = 1 ; loop <= sheet1.LastRow() ; loop++){
					//본인 삭제 불가
                	if(sheet1.GetCellValue(loop, "fam_cd") == "0") {
                        sheet1.SetCellEditable(loop, "sDelete", 0);
                	}

                    //본인이면은
                    if(sheet1.GetCellValue(loop, "famres") == $("#searchRegNo", parent.document).val()){
                        sheet1.SetCellEditable(loop, "fam_cd", 0);
                        sheet1.SetCellEditable(loop, "dpndnt_yn", 0);
                        sheet1.SetCellEditable(loop, "spouse_yn", 0);
                        sheet1.SetCellEditable(loop, "woman_yn", 1);
                        sheet1.SetCellEditable(loop, "one_parent_yn", 1);
                        //sheet1.SetCellEditable(loop, "child_yn", 0);
                        sheet1.SetCellEditable(loop, "adopt_born_yn", 0);
                        // 22.11.14 본인일 때 소득금액 기준 초과 여부 비활성화
                        sheet1.SetCellEditable(loop, "exceed_income_yn", 0);

                        if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "3" || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7" || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8") {
                            age = systemYY - parseInt("20"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
                        } else {
                            age = systemYY - parseInt("19"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
                        }
                        //경로우대 체크
                        if( sheet1.GetCellValue(loop,"famres").substring(6,7) == "1"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "3"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7" ){
                            if( age >= 70){
                                //sheet1.SetCellValue(loop,"senior_yn", "Y") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 1) ;
                            } else{
                                sheet1.SetCellValue(loop,"senior_yn", "N") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 0) ;
                            }
                        } else if( sheet1.GetCellValue(loop,"famres").substring(6,7) == "2"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "6"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8" ){
                            if( age >= 70){
                                //sheet1.SetCellValue(loop,"senior_yn", "Y") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 1) ;
                            } else{
                                sheet1.SetCellValue(loop,"senior_yn", "N") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 0) ;
                            }
                        }
                    } else{
                        sheet1.SetCellEditable(loop, "woman_yn", 0) ;
                        sheet1.SetCellEditable(loop, "one_parent_yn", 0);
                        resetCheckCtr(loop);
                    }

                    /*
                    //주민번호 체크
                    var rResNo = sheet1.GetCellValue(loop,"famres");

                    //외국인 주민번호 체크
                    if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "6"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8"){

                        if(fgn_no_chksum(rResNo) != true){
                        	sheet1.SetCellValue(loop,"famresChk", "부적합");
                        	sheet1.SetCellValue(loop,"sStatus", "R");
                        }
                    } else {
                        if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) != true){
                        	sheet1.SetCellValue(loop,"famresChk", "부적합");
                        	sheet1.SetCellValue(loop,"sStatus", "R");
                        }
                    }
                    */

                    //나이, 연령대
                    var age = 0;
                    if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "3"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8") {
					    age = systemYY - parseInt("20"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
					} else {
					    age = systemYY - parseInt("19"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
					}
                    sheet1.SetCellValue(loop, "age", age);
                    if ( age < 18 ) sheet1.SetCellValue(loop, "age_type", "18-");
                    else if ( age <= 20 ) sheet1.SetCellValue(loop, "age_type", "20-");
                    else if ( 60 <= age ) sheet1.SetCellValue(loop, "age_type", "60+");
                    else sheet1.SetCellValue(loop, "age_type", "");

                    //2019-11-14. 자녀가 7세 미만일 경우 자녀세액공제 활성화
                    //직계비속이면서 장애인이면서 기본공제 대상이면 자녀세액공제 활성화 - 2020.01.20.
                    //자녀세액공제는 나이에 상관없이 활성화 시키기로 함 - 2020.01.30.

                    /*===========================================================================================

                    if((sheet1.GetCellValue(loop, "fam_cd") == "4" || sheet1.GetCellValue(loop, "fam_cd") == "8") && sheet1.GetCellValue(loop,"hndcp_yn") == "Y") {
                    	if(age < 7 || age > 20) {
                    		sheet1.SetCellEditable(loop,"add_child_yn", 1);
                    	} else {
                    		sheet1.SetCellEditable(loop,"add_child_yn", 0);
                    	}
                    }

                    //자녀세액공제는 나이에 상관없이 활성화 시키기로 함 - 2020.01.30.
                    if(sheet1.GetCellValue(loop, "fam_cd") == "4" || sheet1.GetCellValue(loop, "fam_cd") == "8") {
                    	sheet1.SetCellEditable(loop,"add_child_yn", 1);
                    }

                    ===========================================================================================*/

                    

                    defaultColor[loop] = sheet1.GetCellBackColor(loop, "dpndnt_yn") ;
                    defaultValue[loop] = sheet1.GetCellValue(loop, "dpndnt_yn") ;

                    if( sheet1.GetCellValue(loop,"dpndnt_yn") == "N" ) {
                    	sheet1.SetCellBackColor(loop,"dpndnt_yn", "#FF0000") ;
                    } else {
                    	sheet1.SetCellBackColor(loop,"dpndnt_yn", defaultColor[loop]) ;
                    }
                    
                    
                    /*
                    2023.10.31수정:장애구분(국세청 참조용) 사용안함
                    if(sheet1.GetCellValue(loop,"hndcp_type_nts") != ''){
                    	hndcp_yn_nts='Y';  //국세청 자료에 장애인증명자료가 존재
                    	sheet1.SetCellBackColor(loop,"hndcp_type_nts", "#76d7f5");
                    }else{
                    	sheet1.SetCellBackColor(loop,"hndcp_type_nts", defaultColor[loop]) ;
                    }
                    */
                    
                    
                    
                	if ( sheet1.GetCellValue(loop,"hndcp_yn") == "Y" ) {
                		sheet1.SetCellEditable(loop, "hndcp_type", 1) ;
                	}

                    /* 2023.01.27 
                     * 자녀세액공제 해제 - 직계비속(자녀,입양자) */
                	if(sheet1.GetCellValue(loop,"fam_cd") == "4"){
                		if(inputStatus.substring(0,1) == "1"){
                			sheet1.SetCellValue(loop,"init","");
                		}else{
                			if(sheet1.GetCellValue(loop,"dpndnt_yn") == 'Y' && sheet1.GetCellValue(loop,"add_child_yn") == 'Y'){
                				sheet1.SetCellValue(loop,"init","<a href=\"javascript:initChildYn('"+loop+"')\" class='basic'>해제</a>");	
                			} else {
                				sheet1.SetCellValue(loop,"init","");
                			}
                		}
                	}else{
               			sheet1.SetCellValue(loop,"init","");
                	}
                    
                    

					//값 세팅 후 상태값 초기화
                	sheet1.SetCellValue(loop,"sStatus", "R");
                }

				//확정 시 버튼 명 변경
				
				if(sheet1.RowCount() > 0 && inputStatus != null && inputStatus != "" && inputStatus.substring(0,1) == "1") {
					$("#authTextA").removeClass("out-line");
					$("#authText").text("확정 취소");
					$("#btnInsert").hide();
					$("#btnSave").hide();
					$("#btnSaveHndcp").hide();
					if(orgAuthPg == "A"){
						$("#chgSelfInfo").show();
					}else{
						$("#chgSelfInfo").hide();
					}
                	sheet1.SetCellValue(loop,"init","");

					//doAction1("nConfirm");
					sheet1.SetEditable(false);
					sheet3.SetEditable(false);
					confirmCheckYn = "1";
				}else{
					$("#authTextA").addClass("out-line");
					$("#authText").text("확정");
					$("#btnInsert").show();
					$("#btnSave").show();
					$("#btnSaveHndcp").show();
                    if(orgAuthPg == "A"){
                        $("#chgSelfInfo").show();
                    }else{
                        $("#chgSelfInfo").hide();
                    }
					confirmCheckYn = "0";
					//sheet1.SetCellValue(loop,"init","<a href=\"javascript:initChildYn('"+loop+"')\" class='basic'>해제</a>");
					sheet1.SetEditable(true);
					sheet3.SetEditable(true);
				}

				$("#inputStatus", parent.document).val(sheet1.GetCellValue(1, "input_status"));
				doAction2("Search");
				doAction3("Search");

            }
            sheetResize();

            sheet1.FitSize(0, 1);
            
            /* 2022.12.30 국세청에서 제공하는 장애인자료제공 용 */
            /*2023.10.31수정:장애구분(국세청 참조용) 사용안함
            checkHndcpMapping();  
            if(hndcp_yn_nts =='Y' && sheet1.GetCellValue(1, "input_status")=="01"){
            	alert("국세청자료인 '장애구분 국세청제공(참조용)' 존재합니다.\n해당자료는 참조용입니다.\n장애인 공제를 받기위해서는 반드시 '장애구분(사용자입력)' 구분을\n선택하여 저장하세요.");
            }
            */
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
    
    function sheet1_OnValidation(Row, Col, Value) {
    	// 2023.10.17수정 - html 태그 값이 넘어갈때 오류방지: ""로 초기화
    	sheet1.SetCellValue(Row,"init","");
    }

    //저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {

        	// 0:저장시, null:확정/확정취소
        	var inputStatus = sheet1.GetCellValue(1, "input_status");
    		var subInputStatus = inputStatus.substring(0,1)

    		if(subInputStatus == "0"){
    			alertMessage(Code, Msg, StCode, StMsg);
    			parent.getYearDefaultInfoObj();
    		}

            if(Code == 1) {
                parent.doSearchCommonSheet();
                doAction1("Search") ;
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    //변경시 발생.
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{
        	//본인이 이미 등록되어있을 시에 추가 등록 안됨
        	if(sheet1.GetCellValue(Row,"fam_cd") == "0"){
               
                for(var i=1; i <= sheet1.LastRow(); i++){

                    if(Row != i && sheet1.GetCellValue(Row,"fam_cd") == sheet1.GetCellValue(i,"fam_cd")){
                    	alert("이미 가족관계(본인)가 등록되어 있습니다. 다시 입력해 주십시요.");
                        sheet1.SetCellValue(Row,"fam_cd", "") ;
                        return;
                    }
                }
            }

        	if(sheet1.ColSaveName(Col) == "exceed_income_yn" ){
        		if(sheet1.GetCellValue(Row,"exceed_income_yn") == "Y"){
        			if(sheet1.GetCellValue(Row,"dpndnt_yn") == "Y"){
        			    alert("기본공제 대상자는 소득금액기준 초과여부(소득요건100만원, \n근로소득만 있는경우 총급여액 500만원)를 선택할 수 없습니다.\n체크 필요시 기본공제 체크 해제 후 진행해주시기 바랍니다.");
        			    sheet1.SetCellValue(Row,"exceed_income_yn","N");
                    }	
        		}

				//소득금액 초과여부 체크 해제시 소득기준 초과여부를 한번 더 확인하도록 안내
				if (sheet1.GetCellValue(Row,"dpndnt_yn") == "N" && sheet1.GetCellValue(Row, "exceed_income_yn") == "N" && OldValue == "Y") {
					var exceedIncomeFamNm = sheet1.GetCellValue(Row, "fam_nm") == "" ? "대상자" : sheet1.GetCellValue(Row, "fam_nm");
					var exceedIncomeYnMsg = "<안내>\n"
											+sheet1.GetCellText(Row, "fam_cd")+"("+exceedIncomeFamNm+")을(를) 기본공제 받는 경우 \n"
											+"연 소득기준 초과 여부를 반드시 다시 확인하시기 바랍니다.\n"
											+"(근로자)24년 총급여 500만원 이하\n"
											+"(그 외)24년 종합소득금액 100만원 이하"
					if (!confirm(exceedIncomeYnMsg)) {
						sheet1.SetCellValue(Row, "exceed_income_yn", "Y");
					}
				}
        	}
            /*
            한부모공제 클릭시 부녀자공제에 체크되어 있으면, 안내멘트(부녀자공제와 한부모공제는 동시에 선택할 수 없습니다. 한부모공제를 선택하시겠습니까?)
            */
            if(sheet1.ColSaveName(Col) == "woman_yn" || sheet1.ColSaveName(Col) == "one_parent_yn") {
                if(sheet1.GetCellValue(Row, "one_parent_yn") == "Y" && sheet1.GetCellValue(Row, "woman_yn") == "Y"){

                    if(sheet1.ColSaveName(Col) == "woman_yn" ) alert("부녀자공제와 한부모공제는 동시에 선택할 수 없습니다. 한부모공제를 선택 해제 하여 주십시요.");
                    else                                       alert("부녀자공제와 한부모공제는 동시에 선택할 수 없습니다. 부녀자공제를 선택 해제 하여 주십시요.");

                    sheet1.SetCellValue(sheet1.GetSelectRow(), sheet1.ColSaveName(Col), "N") ;
                }
            }

            if(sheet1.ColSaveName(Col) == "fam_cd") {
                if((sheet1.GetCellValue(Row, "fam_cd") == "4" || sheet1.GetCellValue(Row, "fam_cd") == "5") && sheet1.GetCellValue(Row, "adopt_born_yn") == "Y"){
                    sheet1.SetCellEditable(Row, "child_order", 1) ;
                } else {
                    sheet1.SetCellEditable(Row, "child_order", 0) ;
                    sheet1.SetCellValue(Row, "child_order","") ;
                }
            }

            if(sheet1.ColSaveName(Col) == "one_parent_yn") {

            	var chkYn = "N";
            	for(var i=1; i <= sheet1.LastRow(); i++){

                    if(Row != i && sheet1.GetCellValue(i,"fam_cd") == '4' && sheet1.GetCellValue(i,"dpndnt_yn") == 'Y'){
                    	chkYn = "Y";
                    }
                }

            	if(chkYn == 'N' && sheet1.GetCellValue(Row,"one_parent_yn")=='Y'){

            		alert("한부모 공제는 직계비속(자녀,입양자)이면서 기본공제로 등록되어 있을 경우에만 가능 합니다. ");
            		sheet1.SetCellValue(Row,"one_parent_yn", "") ;
            		return false;

            	}

            	if(sheet1.GetCellValue(Row,"one_parent_yn")=='Y'){
	            	for(var i=1; i <= sheet1.LastRow(); i++){
	                    if(Row != i && sheet1.GetCellValue(i,"fam_cd") == '3'){
	                    	alert("한부모 공제는 배우자가 없는 경우에만 가능 합니다. ");
	                		sheet1.SetCellValue(Row,"one_parent_yn", "") ;
	                		return false;
	                    }
	                }
            	}

            }

            if(sheet1.ColSaveName(Col) == "dpndnt_yn") {

                var chkYn = "N";
                for(var i=1; i <= sheet1.LastRow(); i++){

                    if(Row != i && sheet1.GetCellValue(i,"fam_cd") == '4' && sheet1.GetCellValue(i,"dpndnt_yn") == 'Y'){
                        chkYn = "Y";
                    }
                }

                if(chkYn == 'N'){
                    sheet1.SetCellValue(Row,"one_parent_yn", "") ;
                    for(var i=1; i <= sheet1.LastRow(); i++){
                    	sheet1.SetCellValue(i,"one_parent_yn", "") ;
                    }
                }
            }


            if(sheet1.ColSaveName(Col) == "woman_yn") {
                if(sheet1.GetCellValue(Row, "woman_yn") == "Y"){

                    if(paytotMonStr != ""){
                        if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 41470588 ) {
                            alert("근로소득금액 3,000만원(총급여만으로는 41,470,588원) 이하인 자에 한해 부녀자 공제가 가능합니다.");
                            sheet1.SetCellValue(sheet1.GetSelectRow(),"woman_yn", "N") ;
                            sheet1.SetCellEditable(sheet1.GetSelectRow(),"woman_yn", 0);
                            return;
                        }
                    }

                    if( confirm("부녀자공제는 근로자본인이 기혼인 여성이거나 혹은  미혼이면서 기본공제를 받는 부양가족이 존재할 경우에 해당합니다.\n근로소득금액 3,000만원(총급여만으로는 41,470,588원) 이하인 자에 한해 가능합니다.\n부녀자 공제를 선택 하시겠습니까?")){
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"woman_yn", "Y") ;
                    } else{
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"woman_yn", "N") ;
                    }
                }
            }

            if(sheet1.ColSaveName(Col) == "dpndnt_yn" || sheet1.ColSaveName(Col) == "spouse_yn"){
            	if ( sheet1.GetCellValue(Row,"fam_cd") == '3' && Value == "Y" ) {
	            	for(var i=1; i <= sheet1.LastRow(); i++){
	                    if(Row != i && sheet1.GetCellValue(i,"one_parent_yn") == 'Y'){
	                    	alert("한부모 공제는 배우자가 없는 경우에만 가능 합니다. ");
	                		sheet1.SetCellValue(Row, Col, OldValue, 0) ;
	                		return;
	                    }
	                }
            	}
            }

            if(sheet1.ColSaveName(Col) == "dpndnt_yn" || sheet1.ColSaveName(Col) == "hndcp_yn"){
                resetCheckCtr(Row);
            } else if(sheet1.ColSaveName(Col) == "fam_cd"){
                sheet1.SetCellValue(Row,"dpndnt_yn","N");
                sheet1.SetCellEditable(Row,"dpndnt_yn", 1);

                //가족관계를 본인으로 입력할 때 기존에 등록된 본인이 있는지 체크
                var chk = "Y";
                if(sheet1.GetCellValue(Row,"fam_cd") == "0"){
                    // 본인은 무조건 기본공제 체크한다.
                    sheet1.SetCellValue(Row,"dpndnt_yn","Y");
                    sheet1.SetCellEditable(Row,"dpndnt_yn", 0);

                    for(var i=1; i <= sheet1.LastRow(); i++){

                        if(Row != i && sheet1.GetCellValue(Row,"fam_cd") == sheet1.GetCellValue(i,"fam_cd")){
                            chk = "N";
                        }
                    }

                    if(chk == "N"){
                        alert("이미 가족관계(본인)가 등록되어 있습니다. 다시 입력해 주십시요.");
                        sheet1.SetCellValue(Row,"fam_cd", "") ;
                        return;
                    } else {
                        checkFamCd(Row);
                    }
                }
                //가족관계를 배우자으로 입력할 때 기존에 등록된 배우자가 있는지 체크
                else if(sheet1.GetCellValue(Row,"fam_cd") == "3"){

                    for(var i=1; i <= sheet1.LastRow(); i++){

                        if(Row != i && sheet1.GetCellValue(Row,"fam_cd") == sheet1.GetCellValue(i,"fam_cd")){
                            chk = "N";
                        }
                    }

                    if(chk == "N"){
                        alert("이미 가족관계(배우자)가 등록되어 있습니다. 다시 입력해 주십시요.");
                        sheet1.SetCellValue(Row,"fam_cd", "") ;
                        return;
                    } else {
                        checkFamCd(Row);
                    }
                } else {
                    checkFamCd(Row);
                }

            } else if(sheet1.ColSaveName(Col) == "famres"){

                if(sheet1.GetCellValue(Row,"famres")!= ""){
                    //주민번호 유효성체크
                    //  var fResNo = sheet1.GetCellValue(Row,"famres").substring(0,6);
                    var rResNo = sheet1.GetCellValue(Row,"famres");

                    //외국인 주민번호 체크
                    if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(Row,"famres").substring(6,7) == "6"
                            || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
                            || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8"){

                        if(fgn_no_chksum(rResNo) == true){
                            checkFamCd(Row);
                        } else{
                        	/* 2022.11.10 - 주석처리
                              if (!confirm("2020년 10월 신법(뒷자리 랜덤부여)적용 전 기준으로는 주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) {
                            	sheet1.SetCellValue(Row,"famres", "");
                            	return;
                            }*/
                        }
                    } else {
                        //if(isValid_socno_sheet(rResNo) == true){
                        if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) == true){
                            checkFamCd(Row);
                        } else{
                            /* 2022.11.10 - 주석처리
                              if (!confirm("2020년 10월 신법(뒷자리 랜덤부여)적용 전 기준으로는 주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) {
                            	sheet1.SetCellValue(Row,"famres", "");
                            	return;
                            }*/
                        }
                    }

                    var age = 0;
                    if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
					        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
					        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
					        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
					    age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
					} else {
					    age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
					}
                    sheet1.SetCellValue(Row, "age", age);
                    if ( age < 18 ) sheet1.SetCellValue(Row, "age_type", "18-");
                    else if ( age <= 20 ) sheet1.SetCellValue(Row, "age_type", "20-");
                    else if ( 60 <= age ) sheet1.SetCellValue(Row, "age_type", "60+");
                    else sheet1.SetCellValue(Row, "age_type", "");

					// 24.10.15 자녀가 0세(당해년도 출산)가 아닌데 출산/입양 공제가 체크되어 있다면 기본공제, 출산/입양공제, 자녀순서 초기화
					if(age != 0) {
						if(sheet1.GetCellValue(Row,"adopt_born_yn") == "Y") {
							sheet1.SetCellValue(Row,"adopt_born_yn", "N") ;
							sheet1.SetCellValue(Row,"child_order", "") ;
							sheet1.SetCellValue(Row,"dpndnt_yn", "N") ;
						}
					}

                }
            }
            if(sheet1.ColSaveName(Col) == "dpndnt_yn" ){
                if( sheet1.GetCellValue(Row,"dpndnt_yn") == "Y"){
                    if(sheet1.GetCellValue(Row,"fam_cd") != "0"){ //본인이 아닌 경우 체크
                        if(sheet1.GetCellValue(Row,"famres") =='' || sheet1.GetCellValue(Row,"fam_cd") == ''){
                           alert('가족관계 및 주민번호를 먼저 입력하셔야 합니다');
                           sheet1.SetCellValue(Row,"dpndnt_yn", "N") ;
                           return;
                        }
                    }

                    var flag = false;
                    if( confirm("선택한 대상자의 소득요건 충족여부를 확인하십시오.\n\n" +
                    			"소득요건 : 종합소득+퇴직소득+양도소득\n" +
                    			"종합소득 : 사업소득, 이자·배당소득, 근로소득, 연금소득, 기타소득\n\n" +
                    			"* 소득요건이 1백만원 이하(근로소득만 있는 경우 총급여액 5백만원)\n\n" +
                    		    "* 선택한 대상자가 타인의 기본공제대상자가 아니여야 합니다.")){
                        flag = true;
                    } else{
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"dpndnt_yn", "N") ;
                    }
                    if(sheet1.GetCellValue(Row,"dpndnt_yn") == "Y"){
                        sheet1.SetCellValue(Row,"exceed_income_yn", "N");
                    }
                    if(sheet1.GetCellValue(Row,"fam_cd") == "3"){


                        if(flag) {
                        	sheet1.SetCellValue(sheet1.GetSelectRow(),"spouse_yn", "Y") ;
                            sheet1.SetCellEditable(sheet1.GetSelectRow(),"spouse_yn", 0) ;
                        } else {
                        	sheet1.SetCellValue(sheet1.GetSelectRow(),"dpndnt_yn", "N") ;
                            sheet1.SetCellEditable(sheet1.GetSelectRow(),"spouse_yn", 0) ;
                        }

                        //배우자 나이체크 후 경로우대 여부 판단
                        var spouse_age = 0;
                        if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
                            spouse_age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        } else {
                            spouse_age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        }
                        if( spouse_age >= 70 && flag){
                            sheet1.SetCellValue(Row,"senior_yn", "Y") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        } else{
                            sheet1.SetCellValue(Row,"senior_yn", "N") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        }
                    //수급자의 경우 경로우대 체크
                    } else if(sheet1.GetCellValue(Row,"fam_cd") == "7" && flag ){
                        //배우자 나이체크 후 경로우대 여부 판단
                        var sugub_age = 0;
                        if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
                            sugub_age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        } else {
                            sugub_age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        }
                        if( sugub_age >= 70){
                            sheet1.SetCellValue(Row,"senior_yn", "Y") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        } else{
                            sheet1.SetCellValue(Row,"senior_yn", "") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        }
                    } else if(sheet1.GetCellValue(Row,"fam_cd") == "4" || sheet1.GetCellValue(Row,"fam_cd") == "8" ){
                    	/* 2019-11-11. 자녀세액공제 : 7세이상(or 7세미만 미취학아동 선택해야하는 개념 추가되어서 세금계산시 자동체크, 20세이하 무조건이던 부분을 변경
						 * 2020-11-02. 자녀세액공제 : 7세이상이고  20세이하 일 경우에만 해당 (변경됨)
                    	 * 2023-10-25. 자녀세액공제 : 8세이상이고  20세이하 일 경우에만 해당 (변경됨)
                    	 * PKG_CPN_YEA_2019_SYNC.TCPN843_INS 참고
                    	 */
                    	//sheet1.SetCellValue(sheet1.GetSelectRow(),"add_child_yn", "Y");

                    	// 직계비속이면서 장애인이면서 기본공제 대상이면 자녀세액공제 활성화
                    	var sugub_age = 0;
                        if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
                            sugub_age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        } else {
                            sugub_age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        }

                        if(sugub_age > 20) {
                        	sheet1.SetCellEditable(sheet1.GetSelectRow(),"add_child_yn", 1);
                        } else {
                        	if(sugub_age <= 7 || flag == false){ // 2023.10.25 수정: 자녀세액공제 나이 개정(7세 이상-> 8세 이상)
                        		sheet1.SetCellValue(sheet1.GetSelectRow(),"add_child_yn", "N");
                        	}else{

                        		sheet1.SetCellValue(sheet1.GetSelectRow(),"add_child_yn", "Y");
	                        	/*if(flag) {
		                        	sheet1.SetCellValue(sheet1.GetSelectRow(),"add_child_yn", "Y");
	                        	}
	                        	else {
		                        	sheet1.SetCellValue(sheet1.GetSelectRow(),"add_child_yn", "N");
	                        	}    */
                        	}
                        	//자녀세액공제는 나이에 상관없이 활성화 시키기로 함 - 2020.01.30.
                        	//sheet1.SetCellEditable(sheet1.GetSelectRow(),"add_child_yn", 1);
                        }

                    }
                } else{
                    sheet1.SetCellValue(sheet1.GetSelectRow(),"spouse_yn", "N");
                    sheet1.SetCellEditable(sheet1.GetSelectRow(),"spouse_yn", 0);
                    sheet1.SetCellValue(sheet1.GetSelectRow(),"add_child_yn", "N");
                    return;
                }
            }

            if(sheet1.ColSaveName(Col) == "dpndnt_yn" && (Value == "Y" || Value == "1")){
                if(sheet1.GetCellValue(Row,"hndcp_yn") == "Y") {
					/*
					 *  기본공제대상조건(도움말참조)이 아닌 인원에 대한 기본공제는 \n [장애인] 만 해당합니다. \n 기본공제대상여부를 확인바랍니다."
					 + "\n 장애인일 경우에는 장애구분에 해당 코드를 선택하셔야 합니다."
					 + "\n "
					 + "\n※ 장애인공제 대상이 맞습니까?"
					 */
        			if(confirm("※ 장애인공제 대상이 맞습니까?")){
                        if(sheet1.GetCellValue(Row,"fam_cd") == "4"){

							if(sugub_age > 20){

							}else{
								sheet1.SetCellValue(Row,"add_child_yn", "Y");
							}
                        }
        			}else{
        				sheet1.SetCellValue(Row,"dpndnt_yn","N");
        				sheet1.SetCellValue(Row,"hndcp_yn","N");
        				return;
        			}

                }

                //직계비속이면서 장애인이면서 기본공제 대상이면 자녀세액공제 활성화 - 2020.01.20
                //비활성화 처리 - 2020-11.02
                if((sheet1.GetCellValue(Row,"fam_cd") == "4" || sheet1.GetCellValue(Row,"fam_cd") == "8") && sheet1.GetCellValue(Row,"hndcp_yn") == "Y"){
                	//sheet1.SetCellEditable(Row,"add_child_yn", 1);
                }
            }

            if ( sheet1.ColSaveName(Col) == "hndcp_yn" ) {
                //2022.11.10 - 직접선택하게끔 디폴트 세팅 주석처리
            	/*if ( sheet1.GetCellValue(Row,"hndcp_yn") == "Y" ) {
                    if ( sheet1.GetCellValue(Row, "hndcp_type") == "" ) sheet1.SetCellValue(Row, "hndcp_type", "1");
                } else {
                    sheet1.SetCellValue(Row, "hndcp_type", "");
            	}*/
            	


            	// 22.11.14 장애인 여부 해제될 때, 장애 구분도 초기화 되도록 수정
            	if ( sheet1.GetCellValue(Row,"hndcp_yn") == "N" )
            		sheet1.SetCellValue(Row, "hndcp_type", "");
            }
            
            // 22.12.30 장애인 타입클릭시 장애인 구분을 체크하도록 로직 추가
            if ( sheet1.ColSaveName(Col) == "hndcp_type" ) {
            	if(sheet1.GetCellValue(Row,"hndcp_type") != "" && sheet1.GetCellValue(Row,"hndcp_yn") == "N" ){
            		 alert("장애인공제 여부를 체크해주세요.");
            		 sheet1.SetCellValue(Row, "hndcp_type", "");
            		 
            	}
            	// checkHndcpMapping();
            }

            /* if ( sheet1.ColSaveName(Col) == "fam_nm" ) {
                if ( !checkMetaChar(sheet1.GetCellValue(Row,"fam_nm")) ) {
                    alert("특수문자는 입력 할 수 없습니다.");
                    sheet1.SetCellValue(Row,Col,"");
                }
            } */

            if ( sheet1.ColSaveName(Col) == "child_order") {
            	var target = sheet1.GetCellValue(Row,Col);
            	var chkFlag = true;

           		for(var i = 1; i <= sheet1.LastRow(); i++){

                    if(i != Row && target == sheet1.GetCellValue(i,Col) && target != "A5" && target != ""){
                        chkFlag = false;
                    }
                }

           		if(!chkFlag){
           	        alert("자녀 순서를 확인하시기 바랍니다.\n셋째 이상을 제외한 값을 중복으로 입력 하실 수 없습니다.");
           	        sheet1.SetCellValue(Row,Col,"");
           	        return;
           		}
            }

            if( sheet1.ColSaveName(Col) == "adopt_born_yn") {
            	sheet1.SetCellEditable(Row,"child_order", sheet1.GetCellValue(Row,Col) == "Y" ? 1 : 0) ;
            	if(sheet1.GetCellValue(Row,Col) != "Y") {
            		   sheet1.SetCellValue(Row,"child_order", "") ;
            	}
            }

            if(sheet1.ColSaveName(Col) == "add_child_yn" ){
            	/* 2019-11-11. 자녀세액공제 : 7세이상(or 7세미만 미취학아동 선택해야하는 개념 추가되어서 세금계산시 자동체크, 20세이하 무조건이던 부분을 변경
            	 * 2020-11-02. 자녀세액공제 : 7세이상이고  20세이하 일 경우에만 해당 (변경됨)
            	 * 2023-10-25. 자녀세액공제 : 8세이상이고  20세이하 일 경우에만 해당 (변경됨)
            	 * PKG_CPN_YEA_2019_SYNC.TCPN843_INS 참고
            	 */
            	//나이
                var age = 0;
                if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
				        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
				        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
				        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
				    age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
				} else {
				    age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
				}

                if( sheet1.GetCellValue(Row,"add_child_yn") == "Y"){
                	if(age >= 8 && age <= 20) {
                    	sheet1.SetCellValue(Row,"add_child_yn", "Y");
                    	//sheet1.SetCellEditable(Row,"add_child_yn", 0);
                    	//자녀세액공제는 나이에 상관없이 활성화 시키기로 함 - 2020.01.30.
                    	//비활성화 처리 - 2020.11.02
                    	//sheet1.SetCellEditable(Row,"add_child_yn", 1);
                    }else if(sheet1.GetCellValue(Row,"fam_cd") == "4"
                		&& (sheet1.GetCellValue(Row,"dpndnt_yn") == "Y" || sheet1.GetCellValue(Row,"dpndnt_yn") == "1")
                		&& sheet1.GetCellValue(Row,"hndcp_yn") == "Y"){
                    		sheet1.SetCellEditable(Row,"add_child_yn", 1);
                    		if(confirm('대상자의 연간소득금액 100만원 초과시에는 공제 받을 수 없습니다.')){
                    			sheet1.SetCellValue(Row,"add_child_yn", "Y");
    						}else{
    							sheet1.SetCellValue(Row,"add_child_yn", "N");
    						}

                    	//sheet1.SetCellValue(Row,"add_child_yn", "Y");
                    }else {
                    	sheet1.SetCellValue(Row,"add_child_yn", "N");
                    	sheet1.SetCellEditable(Row,"add_child_yn", 0);
                    }
                }
            }

        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }



    function sheet1_OnClick(Row, Col, Value){
	   	try{
	   		//기본공제 미체크에 대하여 붉은색 표기 및 체크시 붉은색 표기 해제 원래색상 돌리기 by JSG 20161201
            if ( sheet1.ColSaveName(Col) == "dpndnt_yn" ) {
	            if( sheet1.GetCellValue(Row, Col) == "N" ) {
	            	sheet1.SetCellBackColor(Row, Col, "#FF0000") ;
	            } else {
	            	sheet1.SetCellBackColor(Row, Col, defaultColor[Row]) ;
	            }
	            //확정인 경우
                if($("#authText").text() != "확정"){
                    alert("인적공제가 확정되었습니다. \n변경을 원하시면 확정 취소를 해주십시오.");
                }
            }
//            	if(sheet1.ColSaveName(Col) == "hndcp_yn"){
//      			if(sheet1.GetCellValue(Row, "dpndnt_sts") == "N" && sheet1.GetCellValue(Row, "dpndnt_yn") == "Y" && sheet1.GetCellValue(Row, "hndcp_yn") == "Y"){
//      				alert("기본 공제를 먼저 해제하셔야합니다. ");
//      			}
// 	    	}
	   	}catch(ex){alert("OnClick Event Error : " + ex);}
   	}

    //기본정보 조회(도움말 등등).
    function initDefaultData() {

        var params1 = "searchWorkYy="+$("#searchWorkYy").val();
        params1 += "&adjProcessCd=A010";
        params1 += "&queryId=getYeaDataHelpText";

        var params2 = "searchWorkYy="+$("#searchWorkYy").val();
        params2 += "&adjProcessCd=A020";
        params2 += "&queryId=getYeaDataHelpText";

        //개인별 총급여
        var params3 = "searchWorkYy="+$("#searchWorkYy").val();
        params3 += "&searchAdjustType="+$("#searchAdjustType").val();
        params3 += "&searchSabun="+$("#searchSabun").val();
        params3 += "&queryId=getYeaDataPayTotMon";

        var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params1,false);
        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params2,false);
        var result3 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params3+"&searchNumber=1",false);

        helpText1 = result1.Data.help_text1 + result1.Data.help_text2 + result1.Data.help_text3;
        helpText2 = result2.Data.help_text1 + result2.Data.help_text2 + result2.Data.help_text3;

      	//기본공제 안내. 
        $("#infoLayer").html(helpText1).hide();
      	//추가공제 안내
        $("#infoLayer2").html(helpText2).hide();
        //안내-버튼 숨김
		$("#basicInfoMinus").hide();
		$("#addInfoMinus").hide();

        paytotMonStr = nvl(result3.Data.paytot_mon,"");

        //총급여 확인 버튼 유무
        var result4 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result4[0].code_nm,"");
    }

    //연말정산 안내
    <%-- function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
        openYeaDataExpPopup(url, width, height, title, helpText);
    } --%>

    function convertText(yn) {
    	if(yn == null || yn == undefined || yn == "") {
    		return "";
    	}

    	if(yn == 'Y') {
    		return "예";
    	} else if(yn == 'N') {
    		return "아니오";
    	} else {
    		return "";
    	}

    }

    //기본자료 설정.
    function sheetSet(){
        var comSheet = parent.commonSheet;

        if(comSheet.RowCount() > 0){
        	//공제여부가 라디오버튼으로 표현하다고니 누르고 싶어하는 분들이 발생해서 텍스트 형식으로 변경 - 2020.01.17.
            //$("input[id='A010_03']:input[value='"+comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_03"),"data_yn")+"']").attr("checked",true);
            //$("input[id='A020_07']:input[value='"+comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_07"),"data_yn")+"']").attr("checked",true);
            //$("input[id='A020_14']:input[value='"+comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_14"),"data_yn")+"']").attr("checked",true);
            $("#A010_03").val( convertText(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_03"),"data_yn")) );
            $("#A020_07").val( convertText(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_07"),"data_yn")) );
            $("#A020_14").val( convertText(comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_14"),"data_yn")) );

            $("#A010_05").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_05"),"data_cnt") );
            $("#A010_07").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_07"),"data_cnt") );
            $("#A010_09").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_09"),"data_cnt") );
            $("#A020_03").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_03"),"data_cnt") );
            $("#A020_05").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_05"),"data_cnt") );
            $("#B000_10").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "B000_10"),"data_cnt") );
            $("#B001_20").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "B001_20"),"data_cnt") );
            $("#B001_30").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "B001_30"),"data_cnt") );


        }else{
        	$("#A010_03").val( "" );
            $("#A020_07").val( "" );
            $("#A020_14").val( "" );

            $("#A010_05").val( "0" ) ;
            $("#A010_07").val( "0" ) ;
            $("#A010_09").val( "0" ) ;
            $("#A020_03").val( "0" ) ;
            $("#A020_05").val( "0" ) ;
            $("#B000_10").val( "0" ) ;
            $("#B001_20").val( "0" ) ;
            $("#B001_30").val( "0" ) ;
        }
    }

    //가족사항 등록및수정시(sheet1)시 부양가족체크 여부에 따라 체크박스 Editable 여부확인
    function resetCheckCtr(row){
//alert("resetCheckCtr 00");
        sheet1.SetCellEditable(row, "spouse_yn", 0) ;
        sheet1.SetCellEditable(row, "senior_yn", 0) ;
        /* 2024.03.22 기본공제 대상자가 아니더라도 장애인체크 가능하도록 수정 
        사유 : 의료비, 교육비에서 장애인 공제 받아야함 */
        //sheet1.SetCellEditable(row, "hndcp_yn", 0) ;

        //sheet1.SetCellEditable(row, "child_yn", 0) ;
        sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
        //sheet1.SetCellEditable(row, "add_child_yn", 0) ;

        if(sheet1.GetCellValue(row, "dpndnt_yn") == "Y"){
            sheet1.SetCellEditable(row, "hndcp_yn", 1);
            checkFamCd(row);
        } else{
            checkFamCd(row);
        }
    }

    //가족사항 등록및수정시(sheet1)시 가족관계에 따라 체크박스 Editable 여부확인
    function checkFamCd(row){
/**
alert("checkFamCd 00");
alert("famres ="+ sheet1.GetCellValue(row,"famres")
    + "\n fam_cd ="+ sheet1.GetCellValue(row,"fam_cd")
);
/**/
		var age = 0;
        if(sheet1.GetCellValue(row,"famres").substring(6,7) == "3"
                || sheet1.GetCellValue(row,"famres").substring(6,7) == "4"
                || sheet1.GetCellValue(row,"famres").substring(6,7) == "7"
                || sheet1.GetCellValue(row,"famres").substring(6,7) == "8") {
            age = systemYY - parseInt("20"+sheet1.GetCellValue(row, "famres").substring(0,2), 10);
        } else {
            age = systemYY - parseInt("19"+sheet1.GetCellValue(row, "famres").substring(0,2), 10);
        }

        //부양가족인지 확인
        if(sheet1.GetCellValue(row, "dpndnt_yn") == "Y"){

        	//자녀세액공제 활성화
            if(sheet1.GetCellValue(row,"fam_cd") == "4" || sheet1.GetCellValue(row,"fam_cd") == "8"){
            	if(age < 8 || age > 20) {
            		//sheet1.SetCellEditable(row, "add_child_yn", 1) ;
            	}
            }

            //경로우대,자녀양육비 체크 가능한지
            if(sheet1.GetCellValue(row,"famres") != ""){
                if(sheet1.GetCellValue(row,"fam_cd") == "1"
                        || sheet1.GetCellValue(row,"fam_cd") == "2"){ //(소득자의 직계존속 : 1, 배우자의 직계존속 : 2)
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellValue(row,"spouse_yn", "N") ;

                    if(age < 60){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    }

                    //sheet1.SetCellEditable(row, "child_yn", 0) ;
                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    //sheet1.SetCellValue(row,"child_yn", "N") ;

                } else if(sheet1.GetCellValue(row,"fam_cd") == "4" || sheet1.GetCellValue(row,"fam_cd") == "5"){
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellValue(row,"spouse_yn", "N") ;

                    if(age > 20){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    	if(sheet1.GetCellValue(row,"fam_cd") == "4"){
                    		sheet1.SetCellEditable(row, "add_child_yn", 1);
                    	}
                    }

                    /* 20181101 6세이하 자녀양육 제거 및 관련 로직 제거 */
                    /* if( age <= 6){
                        sheet1.SetCellEditable(row, "child_yn", 1) ;
                        if(sheet1.GetCellValue(row, "sStatus") != "R"){
                            if(sheet1.GetCellValue(row,"child_yn")=="N"){
                                //if(confirm('자녀양육을 선택 하시겠습니까?')){
                                    sheet1.SetCellValue(row,"child_yn", "Y") ;
                                //}
                            }
                        }
                    } else{
                        sheet1.SetCellEditable(row, "child_yn", 0) ;
                    } */
                  //직계 비속일 경우에 입양_출산 체크를 한다.
                    if( age <= 20){
                        //출산입양체크
                        //2018-07-27 직계비속(자녀,입양자) 일 경우에만 입양_출산 체크
						if(sheet1.GetCellValue(row,"fam_cd") == "4"){
	                        if( age == 0){
	                            sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
	                           	sheet1.SetCellValue(row,"adopt_born_yn", "Y") ;
	                            sheet1.SetCellEditable(row,"child_order", 1) ;
	                        } else{
	                            sheet1.SetCellEditable(row, "adopt_born_yn", 1) ;
	                        }
						} else{
							sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
	                    }
                    } else{
                        sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    }

                } else if(sheet1.GetCellValue(row,"fam_cd") == "6") {  //형제자매 : 6
                    if(age > 20 && age < 60){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    }

                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    //sheet1.SetCellEditable(row, "child_yn", 0) ;
                    //sheet1.SetCellValue(row,"child_yn", "N") ;

                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellValue(row,"spouse_yn", "N") ;
                } else if(sheet1.GetCellValue(row,"fam_cd") == "0"){      //본인 : 0
                	sheet1.SetCellEditable(row, "fam_cd", 0) ;
                    sheet1.SetCellEditable(row, "dpndnt_yn", 0) ;
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellEditable(row, "woman_yn", 1) ;

                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    //sheet1.SetCellEditable(row, "child_yn", 0) ;

                } else if(sheet1.GetCellValue(row,"fam_cd") == "3"){      //배우자 : 3
                    sheet1.SetCellEditable(row, "dpndnt_yn", 1) ;
                    //sheet1.SetCellEditable(row, "spouse_yn", 1) ;

                    //sheet1.SetCellEditable(row, "child_yn", 0) ;
                    //sheet1.SetCellValue(row,"child_yn", "N") ;

                } else if(sheet1.GetCellValue(row,"fam_cd") == "8"){      //위탁아동 : 8
                   if( age <= 20){  //아동복지법상 18세 미만. -> 2020변경. 보호기간이 연장된 위탁아동 포함(20세이하)
                        sheet1.SetCellEditable(row, "dpndnt_yn", 1) ;
                        sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                        sheet1.SetCellEditable(row, "woman_yn", 0) ;

                        //위탁아동에서 장애인공제 로직 삭제 - 2019.12.09
                        //sheet1.SetCellEditable(row, "hndcp_yn", 1) ;

                        sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                        /* 20181101 6세이하 자녀양육 제거 및 관련 로직 제거 */
                        /* if( age <= 6){
                            sheet1.SetCellEditable(row, "child_yn", 1) ;
                            if(sheet1.GetCellValue(row, "sStatus")!="R"){
                                if(sheet1.GetCellValue(row,"child_yn")=="N"){
                                	//if(confirm('자녀양육을 선택 하시겠습니까?')){
                                        sheet1.SetCellValue(row,"child_yn", "Y") ;
                                    //}
                                }
                            }
                        } else{
                            sheet1.SetCellEditable(row, "child_yn", 0) ;
                        } */
                    }
                	/* 위탁아동에서 장애인공제 로직 삭제 - 2019.12.09
                    if(age >= 18){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    }
                     */
                } else if(sheet1.GetCellValue(row,"fam_cd") == "7"){      //수급자 : 7
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellEditable(row, "woman_yn", 0) ;
                    sheet1.SetCellEditable(row, "hndcp_yn", 1);

                    //sheet1.SetCellEditable(row, "child_yn", 0) ;
                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;

                    sheet1.SetCellValue(row,"spouse_yn", "N") ;
                    sheet1.SetCellValue(row,"woman_yn", "N") ;

                    //sheet1.SetCellValue(row,"child_yn", "N") ;
                    sheet1.SetCellValue(row,"adopt_born_yn", "N") ;


                } else{                                            //기타 : 7
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellEditable(row, "hndcp_yn", 0) ;
                    sheet1.SetCellValue(row,"hndcp_yn", "N") ;

                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    sheet1.SetCellValue(row,"hndcp_yn", "N") ;

                }//end if(가족관계)

                /*공통적으로 기본공제 대상자중에 70세이상이면 경로우대*/
                if( age >= 70){
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellValue(row,"senior_yn", "Y") ;
                } else{
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellValue(row,"senior_yn", "N") ;
                }

            }//end if(주민등록번호 입력여부)
        } else{
            //가족관계확인해서 남남인경우..
            if(sheet1.GetCellValue(row,"fam_cd") == "1" || sheet1.GetCellValue(row,"fam_cd") == "2" || sheet1.GetCellValue(row,"fam_cd") == "4" || sheet1.GetCellValue(row,"fam_cd") == "5" ||
               sheet1.GetCellValue(row,"fam_cd") == "6" || sheet1.GetCellValue(row,"fam_cd") == "3" || sheet1.GetCellValue(row,"fam_cd") == "7" || sheet1.GetCellValue(row,"fam_cd") == "8"){

                sheet1.SetCellEditable(row, "senior_yn", 0) ;
                sheet1.SetCellValue(row,"senior_yn", "N") ;
                sheet1.SetCellValue(row,"spouse_yn", "N") ;

                //위탁아동에서 장애인공제 로직 삭제 - 2019.12.09
                if(sheet1.GetCellValue(row,"fam_cd") != "8") {
                	/* 2024.03.22 기본공제 대상자가 아니더라도 장애인체크 가능하도록 수정 
                    사유 : 의료비, 교육비에서 장애인 공제 받아야함 */
                	/* sheet1.SetCellEditable(row, "hndcp_yn", 0) ;
                    sheet1.SetCellValue(row,"hndcp_yn", "N") ; */
                }
                
                //sheet1.SetCellEditable(row, "child_yn", 0) ;
                sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                sheet1.SetCellValue(row,"adopt_born_yn", "N") ;

                /* 20181101 6세이하 자녀양육 제거 및 관련 로직 제거 */
                /* if(sheet1.GetCellValue(row,"fam_cd") == "4" || sheet1.GetCellValue(row,"fam_cd") == "5"){
                    if( age <= 6){
                        //sheet1.SetCellEditable(row, "child_yn", 1) ;
                        if(sheet1.GetCellValue(row, "sStatus")!="R"){
                            if(sheet1.GetCellValue(row,"child_yn")=="Y"){
                            	sheet1.SetCellValue(row,"child_yn", "N") ;
//                                 if(confirm('자녀양육 선택을 해제 하시겠습니까?')){
//                                     sheet1.SetCellValue(row,"child_yn", "N") ;
//                                 }
                            }
                        }
                    }else{
                        sheet1.SetCellEditable(row, "child_yn", 0) ;
                        sheet1.SetCellValue(row,"child_yn", "N") ;
                    }
                } */

            }//end if(가족관계코드 비교)
        }
    }

    function sheetChangeCheck() {
        var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");
        if ( 0 < iTemp ) return true;
        return false;
    }

    //[총급여] 보이기
    function paytotMonView(){
    	//개인별 총급여
        var params = "searchWorkYy="+$("#searchWorkYy").val();
        params += "&searchAdjustType="+$("#searchAdjustType").val();
        params += "&searchSabun="+$("#searchSabun").val();
        params += "&queryId=getYeaDataPayTotMon";

        var result = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params+"&searchNumber=1",false);

        paytotMonStr = nvl(result.Data.paytot_mon,"");
        
        if(paytotMonStr != ""){
            if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 41470588 ) {
                $("#span_paytotMonView").html("<B>(3000만원 초과)</B>&nbsp;<a class='under-line bold' href='javascript:paytotMonViewClose()'>닫기</a>");
                $("#span_paytotMonView").css("color", "red");
            } else {
                $("#span_paytotMonView").html("<B>(3000만원 미초과)</B>&nbsp;<a cl	ass='under-line bold' href='javascript:paytotMonViewClose()'>닫기</a>");
                $("#span_paytotMonView").css("color", "green");
            }
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
        }
    }

    //[총급여] 닫기
    function paytotMonViewClose(){
        $("#span_paytotMonView").html("");
    }

    /*과거인적공제 현황 조회 및 엑셀다운로드*/
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			if($("#searchBfYear").val() == "") {
                alert("대상년도를 입력하여 주십시오.");
                return;
            }
			//과거인적공제 현황 조회
            sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectPastYeaDataPerList", $("#sheetForm").serialize() );
            break;
		case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet2);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
            sheet2.Down2Excel(param);
            break;
		}
    }

	//과거인적공제 현황 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
            	var systemYY = parseInt($("#searchWorkYy").val(), 10);

                //sheetSet() ;
                var loop = sheet2.LastRow();
                for(loop = 1 ; loop <= sheet2.LastRow() ; loop++){

                    //본인이면은
                    if(sheet2.GetCellValue(loop, "famres") == $("#searchRegNo", parent.document).val()){
                    	var age = 0;
                        if(sheet2.GetCellValue(loop,"famres").substring(6,7) == "3" || sheet2.GetCellValue(loop,"famres").substring(6,7) == "4"
                            || sheet2.GetCellValue(loop,"famres").substring(6,7) == "7" || sheet2.GetCellValue(loop,"famres").substring(6,7) == "8") {
                            age = systemYY - parseInt("20"+sheet2.GetCellValue(loop, "famres").substring(0,2), 10);
                        } else {
                            age = systemYY - parseInt("19"+sheet2.GetCellValue(loop, "famres").substring(0,2), 10);
                        }
						mAge = age;
                        //경로우대 체크
                        if( sheet2.GetCellValue(loop,"famres").substring(6,7) == "1"
                            || sheet2.GetCellValue(loop,"famres").substring(6,7) == "3"
                            || sheet2.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet2.GetCellValue(loop,"famres").substring(6,7) == "7" ){
                            if( age >= 70){
                                sheet2.SetCellValue(loop,"senior_yn", "Y") ;
                            } else{
                                sheet2.SetCellValue(loop,"senior_yn", "N") ;
                            }
                        } else if( sheet2.GetCellValue(loop,"famres").substring(6,7) == "2"
                                || sheet2.GetCellValue(loop,"famres").substring(6,7) == "4"
                                || sheet2.GetCellValue(loop,"famres").substring(6,7) == "6"
                                || sheet2.GetCellValue(loop,"famres").substring(6,7) == "8" ){
                            if( age >= 70){
                                sheet2.SetCellValue(loop,"senior_yn", "Y") ;
                            } else{
                                sheet2.SetCellValue(loop,"senior_yn", "N") ;
                            }
                        }
                    } else{
                    }

                    //주민번호 체크
                    var rResNo = sheet2.GetCellValue(loop,"famres");

                    //외국인 주민번호 체크
                    if(sheet2.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet2.GetCellValue(loop,"famres").substring(6,7) == "6"
                            || sheet2.GetCellValue(loop,"famres").substring(6,7) == "7"
                            || sheet2.GetCellValue(loop,"famres").substring(6,7) == "8"){

                        if(fgn_no_chksum(rResNo) != true){
                        	sheet2.SetCellValue(loop,"famresChk", "부적합");
                        	sheet2.SetCellValue(loop,"sStatus", "R");
                        }
                    } else {
                        if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) != true){
                        	sheet2.SetCellValue(loop,"famresChk", "부적합");
                        	sheet2.SetCellValue(loop,"sStatus", "R");
                        }
                    }

                    //나이, 연령대
                    var age = 0;
                    if(sheet2.GetCellValue(loop,"famres").substring(6,7) == "3"
					        || sheet2.GetCellValue(loop,"famres").substring(6,7) == "4"
					        || sheet2.GetCellValue(loop,"famres").substring(6,7) == "7"
					        || sheet2.GetCellValue(loop,"famres").substring(6,7) == "8") {
					    age = systemYY - parseInt("20"+sheet2.GetCellValue(loop, "famres").substring(0,2), 10);
					} else {
					    age = systemYY - parseInt("19"+sheet2.GetCellValue(loop, "famres").substring(0,2), 10);
					}
                    sheet2.SetCellValue(loop, "age", age);
                    if ( age < 18 ) sheet2.SetCellValue(loop, "age_type", "18-");
                    else if ( age <= 20 ) sheet2.SetCellValue(loop, "age_type", "20-");
                    else if ( 60 < age ) sheet2.SetCellValue(loop, "age_type", "60+");
                    else sheet2.SetCellValue(loop, "age_type", "");

                    sheet2.SetCellValue(loop,"sStatus", "R");
                }

            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

	//장애인등록증현황
	function doAction3(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet3.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectYeaDataHndcpRegInfoList", $("#sheetForm").serialize());
            break;
		case "Save":
            //if(!parent.checkClose())return;
            for(var row = 2; row <= sheet3.LastRow(); row++) {
            	if( sheet3.GetCellValue(row, "sStatus") == "U" ) {
            		var sdate = sheet3.GetCellValue(row, "sdate");
            		var edate = sheet3.GetCellValue(row, "edate");
            		if($.trim(sdate) == "") {
            			alert("시작일자를 입력해주세요.");
            			return;
            		}

            		if(parseInt(sdate.substring(0,4),10) > systemYY) {
            			alert("시작일자는 귀속년도("+systemYY+")를 초과할 수 없습니다.");
            			return;
            		}

            		if(sdate > edate && $.trim(edate).length != 0) {
            			alert("시작일자는 종료일자 이전으로 입력해주세요.");
            			return;
            		}
            	}
            }
            sheet3.DoSave( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveYeaDataHndcpRegDetail",$("#sheetForm").serialize());
            break;
		case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet3);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
            sheet3.Down2Excel(param);
            break;
		}
    }

	//장애인등록증현황 조회 후 에러 메시지
    function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
            }
            sheetResize();
            
            scrolling = false;
            window.scrollTo(0, 0);
            
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

  	//저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	//본인정보변경 팝업(관리자)
    function openChgSelfInfoPopup(){
        try{
            if(!isPopup()) {return;}

            pGubun = "ChgSelfInfoPopup";

            var args    = new Array();

                args["searchWorkYy"]   = $("#searchWorkYy").val();
                args["fam_cd"]         = sheet1.GetCellValue(1, "fam_cd");
                args["sabun"]          = sheet1.GetCellValue(1, "sabun");
                args["adjust_type"]    = sheet1.GetCellValue(1, "adjust_type");

            var rv = openPopup("<%=jspPath%>/yeaData/yeaChgSelfInfoPopup.jsp?authPg=<%=authPg%>",args,"500","300");
        } catch(ex) {
            alert("Open Popup Event Error : " + ex);
        }
    }

    function getReturnValue(returnValue) {

        var rv = $.parseJSON('{'+ returnValue+'}');

        if ( pGubun == "ChgSelfInfoPopup" ){
            doAction1('Search');
        }
    }
    /* 2023.01.27 
     * 자녀세액공제 해제 - 직계비속(자녀,입양자) */
    function initChildYn(row){
    	var stsCnt = 0;

    	if(sheet1.GetCellValue(row,"sStatus") == "U") {
    		sheet1.SetCellValue(row,"sStatus","R");
    	}
    	for(i = 1 ; i <= sheet1.LastRow() ; i++){
    		if(sheet1.GetCellValue(i,"sStatus") == "U" || sheet1.GetCellValue(i,"sStatus") == "D"){
    			stsCnt++;
    		}
    	}
    	if(stsCnt > 0){
    		alert("작업중인 내역이 있습니다.");
    		return;
		}
    	sheet1.SetCellValue(row,"sStatus","U");
    	sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=updateChildYn", $("#sheetForm").serialize());
    	
    	sheet1.SetCellValue(row,"sStatus","R");
    }
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
    <input type="hidden" id="searchSabun" name="searchSabun" value="" />
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="33.33%" />
			<col width="66.66%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="outer">
			        <div class="sheet_title">
			        <ul>
			            <li class="txt">기본공제
			                <a href="#layerPopup" class="basic btn-white ico-question" id="basicInfoPlus"><b>기본공제 안내+</b></a>
				            <a href="#layerPopup" class="basic btn-white ico-question" id="basicInfoMinus" style="display:none"><b>기본공제 안내-</b></a>
			            </li>
			        </ul>
			        </div>
			    </div>
				<div id="infoLayer" class="new" style="display:none"></div>

				<!-- Sample Ex&Image End -->
			    <table border="0" cellpadding="0" cellspacing="0" class="default line outer">
				    <colgroup>
				        <col width="50%" />
				        <col width="50%" />
				    </colgroup>
				    <tr>
				        <th class="center">배우자 공제 여부</th>
				        <th class="center">직계존속</th>
				    </tr>
				    <tr>
				        <td class="center">
				        	<!--
				            <input name="A010_03" id="A010_03" type="radio" class="radio" value="Y" disabled />&nbsp;예
				            <input name="A010_03" id="A010_03" type="radio" class="radio" value="N" disabled />&nbsp;아니오
				            -->
				            <input name="A010_03" type="text" class="text w25p center transparent" id="A010_03" readonly />
				        </td>
				        <td class="right">
				            <input name="A010_05" type="text" class="text w25p right transparent" id="A010_05" readonly /> 명
				        </td>
				    </tr>
				    <colgroup>
				        <col width="50%" />
				        <col width="50%" />
				    </colgroup>
				    <tr>
				        <th class="center">직계비속, 입양자, 위탁아동, 수급자</th>
				        <th class="center">형제자매</th>
				    </tr>
				    <tr>
				        <td class="right">
				            <input id="A010_07" name="A010_07" type="text" class="text w25p right transparent" readOnly /> 명
				        </td>
				        <td class="right">
				            <input id="A010_09" name="A010_09" type="text" class="text w25p right transparent" readOnly /> 명
				        </td>
				    </tr>
			    </table>
			</td>
			<td class="sheet_right">
				<div class="outer">
			        <div class="sheet_title">
			        <ul>
			            <li class="txt">추가공제
			                <!-- <a href="javascript:yeaDataExpPopup('추가공제', helpText2, 590, 650);"       class="cute_gray authR">추가공제 안내</a> -->
			                <!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >추가공제 안내 원본</a> -->
			                <a href="#layerPopup" class="basic btn-white ico-question" id="addInfoPlus"><b>추가공제 안내+</b></a>
				            <a href="#layerPopup" class="basic btn-white ico-question" id="addInfoMinus" style="display:none"><b>추가공제 안내-</b></a>
			            </li>
			            <li class="btn">
			            	<span id="btnDisplayYn01">
			            		<a href="javascript:doAction1('confirm');" class="basic btn-orange out-line authA" id="authTextA"><b id="authText">확정</b></a>
			            	</span>
			            </li>
			        </ul>
			        </div>
			    </div>

    			<div id="infoLayer2"  class="new" style="display:none"></div>

			    <table border="0" cellpadding="0" cellspacing="0" class="default line outer">
				    <colgroup>
				        <col width="33.33%" />
				        <col width="33.33%" />
				        <col width="33.33%" />
				    </colgroup>
				    <tr>
				        <th class="center">경로우대공제</th>
				        <th class="center">장애인공제</th>
				        <th class="center">부녀자공제여부</th>
				    </tr>
				    <tr>
				        <td class="right">
				            <input name="A020_03" type="text" class="text w25p right transparent" id="A020_03" readonly /> 명
				        </td>
				        <td class="right">
				            <input name="A020_05" type="text" class="text w25p right transparent" id="A020_05" readonly /> 명
				        </td>
				        <td class="center">
				            <!--
				            <input name="A020_07" id="A020_07" type="radio" class="radio" value="Y" disabled />&nbsp;예
				            <input name="A020_07" id="A020_07" type="radio" class="radio" value="N" disabled />&nbsp;아니오
				            -->
				            <input name="A020_07" type="text" class="text w25p center transparent" id="A020_07" readonly />
				        </td>
				    </tr>
				    <colgroup>
				        <col width="33.33%" />
				        <col width="33.33%" />
				        <col width="33.33%" />
				    </colgroup>
				    <tr>
				        <th class="center">한부모공제여부</th>
				        <th class="center">자녀세액공제</th>
				<!--         <th class="center">6세이하자녀양육세액공제</th> -->
				        <th class="center">출산입양세액공제</th>
				    </tr>
				    <tr>
				        <td class="center">
				        	<!--
				            <input name="A020_14" id="A020_14" type="radio" class="radio" value="Y" disabled />&nbsp;예
				            <input name="A020_14" id="A020_14" type="radio" class="radio" value="N" disabled />&nbsp;아니오
				            -->
				            <input name="A020_14" type="text" class="text w25p center transparent" id="A020_14" readonly />
				
				        </td>
				        <td class="right">
				            <input name="B000_10" type="text" class="text w25p right transparent" id="B000_10" readonly /> 명
				        </td>
				<!--         <td class="right"> -->
				<!--             <input id="B001_20" name="B001_20" type="text" class="text w25p right transparent"  readonly /> 명 -->
				<!--         </td> -->
				        <td class="right">
				            <input id="B001_30" name="B001_30" type="text" class="text w25p right transparent"  readonly /> 명
				        </td>
				    </tr>
			    </table>
			</td>
		</tr>
	</table>

		<!-- 과거인적공제 현황 Start -->
		<div class="openYeaDataPerBef_main" id="openYeaDataPerBef_main" style="display:none;">
			<div class="sheet_title" id="openYeaDataPerBef">
				<ul>
				    <li class="txt">과거인적공제 현황</li>
				    <li class="btn">
				    	<a href="javascript:void(0);" class="basic btn-white out-line authA" id="buttonPlus2"><b id="authText2">과거 인적공제 현황+</b></a>
			        	<a href="javascript:void(0);" class="basic btn-white out-line authA" id="buttonMinus2" style="display:none"><b id="authText3">과거 인적공제 현황-</b></a>
				    </li>
				</ul>
			</div>
			<div class="sheet_search outer">
		        <div>
			        <table>
				        <tr>
				            <td>
				                <span>전년도</span>
				                <input id="searchBfYear" name ="searchBfYear" type="text" class="text" maxlength="4" style="width:35px" value=""/>
				            </td>
				            <td><a href="javascript:doAction2('Search')" class="basic authR">조회</a></td>
				        </tr>
			        </table>
		        </div>
			</div>
			<div class="outer" id="outer">
				<div class="sheet_title">
		        	<ul><li class="btn"><a href="javascript:doAction2('Down2Excel')" class="basic btn-download authR">다운로드</a></li></ul>
		        </div>
			</div>
		</div>
		<div style="height:290px" id="createIBSheet"><script type="text/javascript">createIBSheet("sheet2", "100%", "290px"); </script></div>
		<!-- 과거인적공제 현황 End -->

		<!-- 장애인등록증 현황 Start -->
		<div id="hndcpRegInfo">
			<div class="outer">
				<div class="sheet_title">
					<ul>
					    <li class="txt">장애인등록증 현황</li>
					    <li class="btn">
					    	<span><font class="txt red" style="text-overflow: ellipsis; white-space: nowrap;">&nbsp;현황은 참고용입니다. 실제 공제는 아래 장애인공제 체크를 하셔야 합니다.&nbsp;</font></span>
					    	<a href="javascript:void(0);" class="basic btn-white out-line authA buttonPlus3"><b>장애인등록증 현황+</b></a>
				        	<a href="javascript:void(0);" class="basic btn-white out-line authA buttonMinus3" style="display:none"><b>장애인등록증 현황-</b></a>
				        	<span id="btnDisplayYn02">
				        		<a href="javascript:doAction3('Save');"     class="basic btn-save authA" id="btnSaveHndcp">저장</a>
				        	</span>
				        	<a href="javascript:doAction3('Down2Excel')" class="basic btn-download authR">다운로드</a>
					    </li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "150px"); </script>
		</div>
		<!-- 장애인등록증 현황 End -->

	</form>
    <div class="outer">
    	   <div style="padding-top:10px;">
	    	<font size='2'>
			    <font class="blue">※ 귀속연도 중에 출생한 주민등록번호가 없는 내국인의 경우</font> 생년월일(YYMMDD:6자리)+남녀구분(남:3,여:4)+‘000000’<br>
			    <font class="red" style="font-weight: bold;" >※ 주민등록번호 입력시 하이픈(-)을 제외한 숫자 13자리로 입력바랍니다</font><br>
		    </font>
	    </div>

        <div class="sheet_title">
        <ul>
            <li class="txt">인적공제
                <span id="paytotMonViewYn">
                	<a href="javascript:paytotMonView();" class="basic btn-red-outline authA">근로소득금액 3000만원 초과여부</a>
                </span>
                <span id="span_paytotMonView"></span>
			   
			    <font style="font-size: 12px;" class="blue">※ 자녀장려금을 받은 경우 하단 "자녀세액공제해제" 버튼을 클릭하여 자녀세액공제 해제 가능</font>
            </li>
            <li class="btn">
	            <!-- <a href="javascript:openYeaDataPerBefPopup();" class="button authA" id="button_authA"><b>과거 인적공제 현황 원본</b></a> -->
                <a href="javascript:openChgSelfInfoPopup();" class="basic ico-popup authA" id="chgSelfInfo"><b>본인정보변경</b></a>
	            <a href="javascript:void(0);" class="basic btn-white out-line authA buttonPlus3"><b>장애인등록증 현황+</b></a>
		        <a href="javascript:void(0);" class="basic btn-white out-line authA buttonMinus3" style="display:none"><b>장애인등록증 현황-</b></a>
	            <a href="javascript:void(0);" class="basic btn-white out-line authA" id="buttonPlus"><b>과거 인적공제 현황+</b></a>
	            <a href="javascript:void(0);" class="basic btn-white out-line authA" id="buttonMinus" style="display:none"><b>과거 인적공제 현황-</b></a>
	            <a href="javascript:doAction1('Search');"   class="basic authR" id="btnSearch">조회</a>
	            <span id="btnDisplayYn03">
		            <a href="javascript:doAction1('Insert');"   class="basic authA" id="btnInsert">입력</a>
		            <a href="javascript:doAction1('Save');"     class="basic btn-save authA" id="btnSave">저장</a>
	            </span>
        	</li>
        </ul>
        </div>
    </div>
    <div style="height:450px">
    <script type="text/javascript">createIBSheet("sheet1", "100%", "450px"); </script>
    </div>
</div>
</body>
</html>