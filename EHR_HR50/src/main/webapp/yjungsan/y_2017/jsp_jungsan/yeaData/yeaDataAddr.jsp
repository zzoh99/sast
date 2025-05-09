<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>주소사항</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<script type="text/javascript">
	var orgAuthPg = '<%=removeXSS(request.getParameter("orgAuthPg"), "1")%>';
	var zipcodePg = "";
	var zipcodeRefYn = "";
	var cpn_yea_paytax_yn = "";
	var cpn_yea_paytax_ins_yn = "";
	
	$(function(){

		$("#searchWorkYy").val($("#searchWorkYy", parent.document).val());
		$("#searchAdjustType").val($("#searchAdjustType", parent.document).val());
		$("#searchSabun").val($("#searchSabun", parent.document).val());

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"대상년도",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"우편번호",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"zip",				KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
			{Header:"주소",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"addr1",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"상세주소",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"addr2",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"감면시작일",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"reduce_s_ymd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"감면종료일",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"reduce_e_ymd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"세대주여부",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"house_owner_yn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"주택취득일",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"house_get_ymd",	KeyField:0,	Format:"Ymd",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"전용면적",			Type:"Float",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"house_area",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"공시지가",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"official_price",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"주택소유수",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"house_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"외국인단일세율 적용여부",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"foreign_tax_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"국적코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"national_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"국적코드명",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"national_nm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"거주지국코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"residency_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"거주자구분",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"residency_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"내외국인구분",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"citizen_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"외국법인소속 파견근로자여부",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"foreign_emp_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"세금분납신청여부",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tax_ins_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"세금분납신청개월수",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tax_ins_yn_month",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"원천징수세액율",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tax_rate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상태코드",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"input_status",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		//var foreign_tax_type_list = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00170"), "");
		var foreign_tax_type_list = ["3|5", "적용안함|19%단일세율"
			,"<option value='3'>적용안함</option>"
				+ "<option value='5'>19%단일세율</option>"
		];
		var national_cd_list = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","H20295"), "");

		$("#foreign_tax_type").html(foreign_tax_type_list[2]);  $("#foreign_tax_type").val("3") ; // 적용안함
		$("#national_cd").html("<option value=''></option>"+national_cd_list[2]);
		$("#residency_cd").html("<option value=''></option>"+national_cd_list[2]);

		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		zipcodeRefYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=ZIPCODE_REF_YN", "queryId=getSystemStdData",false).codeList;

		if ( zipcodeRefYn != null && zipcodeRefYn.length>0) {
			if(zipcodeRefYn[0].code_nm == "Y") {
                zipcodePg = "Ref";
            } else if(zipcodeRefYn[0].code_nm == "W") {
                zipcodePg = "new";
            }
		}
		
		/* 원천징수세액 등 옵션에 따라 show/hide (시스템사용기준 : CPN_YEA_PAYTAX_YN 원천징수세액 분납 신청 사용여부, CPN_YEA_PAYTAX_INS_YN 원천징수세액 조정 신청 사용여부) */
		if ( orgAuthPg == "A" ) {
			cpn_yea_paytax_yn = "Y";
			cpn_yea_paytax_ins_yn = "Y";
		} else {			
			var data = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_PAYTAX_YN", "queryId=getSystemStdData",false).codeList;
			if ( data != null && data.length>0) {
				cpn_yea_paytax_yn = data[0].code_nm;
			}
			
			data = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_PAYTAX_INS_YN", "queryId=getSystemStdData",false).codeList;
			if ( data != null && data.length>0) {
				cpn_yea_paytax_ins_yn = data[0].code_nm;
			}
		}
		
		if(cpn_yea_paytax_yn == "Y" || cpn_yea_paytax_ins_yn == "Y") {
			$("#tr_tax_ins_yn").hide();
			$("#tr_tax_rate").hide();
			$("#div_tax").show();
			
			if(cpn_yea_paytax_yn == "Y") {
				$("#tr_tax_ins_yn").show();
			} else {
				$("#tr_tax_ins_yn").hide();
			}
			
			if(cpn_yea_paytax_ins_yn == "Y") {
				$("#tr_tax_rate").show();
			} else {
				$("#tr_tax_rate").hide();
			}
		} else {
			$("#div_tax").hide();
		}
		
		doAction1("Search");
	});

	$(function(){
<%--
		// 관리자 화면인 경우 외국인 사항 입력 필드를 보여준다.
		if(orgAuthPg == "A") $("#div_foreign, #div_tax").show();
--%>
		/*마스크 셋업*/
		$("#house_get_ymd").mask("1111-11-11") ;
		$('#official_price').mask('000,000,000,000,000', {reverse: true});

		$("#house_area").keyup(function(){
			makeNumber(this,"C");
			commaText(this,3);
		});
		
		if("A" == "<%=authPg%>") {
			$("#house_get_ymd").datepicker2({ymdonly:true});
		}

		$("#reduce_s_ymd").mask("1111-11-11") ;
		$("#reduce_s_ymd").datepicker2({ymdonly:true});

		$("#reduce_e_ymd").mask("1111-11-11") ;
		$("#reduce_e_ymd").datepicker2({ymdonly:true});

		// 거주자여부 : 비거주자 선택시 거주지국 활성화, 그 외 거주지국 비활성화
		$("input[id=residency_type]").bind("change", residency_type_change);
		
	});

	//연말정산 대상자관리
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=selectYeaDataAddrList", $("#sheet1Form").serialize());
			break;
		case "Save":
			if(!parent.checkClose())return;
			
			// 비거주자 선택시 거주지국코드는 필수값
			if ( $("input[id='residency_type']:checked").val() == "2" ) {
				if ( $("#residency_cd").val() == "" ) {
					alert("비거주자로 선택하셨습니다. 거주지국 코드를 입력해 주십시오.");
					return;
				}
			}
			
			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=saveYeaDataAddr");
			break;
		case "confirm":
			
			if(!confirm($("#authText").text() + " 하시겠습니까?")){
				break;
			}
			
			var flag = 0;
			var inputStatus = sheet1.GetCellValue(1, "input_status");
			
		    var inputStatus = "1";
            
            if($("#authText").text() == "확정") {
                inputStatus = "1";       
            } else {
                inputStatus = "0";
            }
            
            var params = "input_status=" + inputStatus;
                params += "&work_yy="+$("#searchWorkYy").val();
                params += "&adjust_type="+$("#searchAdjustType").val();
                params += "&sabun="+$("#searchSabun").val();
            
            var result1 = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=saveYeaDataAddrConfirm",params,false);
            
            if( result1.Result.Code == "1") {
                doAction1("Search");
            }
			
            break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				sheetToZipCode();
				if("Y" == "<%=adminYn%>") {
					parent.getTotPay() ;
				}
				
				//확정 시 버튼 명 변경
			    var inputStatus = sheet1.GetCellValue(1, "input_status");
				
				if(inputStatus.substring(1,2) == "1") {
					$("#authTextA").show();
					$("#authText").text("확정취소");
				    $("#btnSave").hide();
				    $("#btnInit").hide();
				    
				    $("input:text").attr("disabled", true);
				    $("input:radio").attr("disabled", true);
				    $("select").attr("disabled", true);
				    $("#zipPopup").attr("disabled", true);
				} else {
			    	$("#authTextA").show();
					$("#authText").text("확정");
					$("#btnSave").show();
                    $("#btnInit").show();
                    
                    $("input:text").attr("disabled", false);
                    $("input:radio").attr("disabled", false);
                    $("select").attr("disabled", false);
                    $("#zipPopup").attr("disabled", false);
				}
				
				// 탭처리
				$("#inputStatus", parent.document).val(inputStatus);
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//시트에 내용을 우편번호 컨트롤에 맵핑
	function sheetToZipCode(){
		if(sheet1.RowCount() == 0){
			getPersonalAddr();
			return;
		}else{
			//세대주여부
			$("input[id='house_owner_yn']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"house_owner_yn")+"']").attr("checked",true);

			//주택소유수
			$("input[id='house_cnt']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"house_cnt")+"']").attr("checked",true);
			if(sheet1.GetCellValue(1, "house_cnt") == "1") {
				$("#houseinfo1").show() ;
				$("#houseinfo2").show() ;
				$("#houseinfo3").show() ;
			} else {
				$("#houseinfo1").hide() ;
				$("#houseinfo2").hide() ;
				$("#houseinfo3").hide() ;
			}

			if(sheet1.GetCellValue(sheet1.LastRow(), "zip") != "" ){
				$("#zipCode").val( sheet1.GetCellText(1, "zip") ) ;
				$("#addr1").val( sheet1.GetCellValue(1, "addr1") ) ;
				$("#addr2").val( sheet1.GetCellValue(1, "addr2") ) ;
			}else{
				getPersonalAddr();
			}

			$("#house_get_ymd").val( sheet1.GetCellText(1, "house_get_ymd") );
			$("#house_area").val( sheet1.GetCellText(1, "house_area") );
			$("#official_price").val( sheet1.GetCellText(1, "official_price") );

			$("#foreign_tax_type").val( sheet1.GetCellText(1, "foreign_tax_type") );
			$("#national_cd").val( sheet1.GetCellText(1, "national_cd") );
			$("#residency_cd").val( sheet1.GetCellText(1, "residency_cd") );
			$("input[id='residency_type']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"residency_type")+"']").attr("checked",true);
			$("input[id='citizen_type']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"citizen_type")+"']").attr("checked",true);
			$("#reduce_s_ymd").val( sheet1.GetCellText(1, "reduce_s_ymd") );
			$("#reduce_e_ymd").val( sheet1.GetCellText(1, "reduce_e_ymd") );
			
			$("#foreign_emp_type").val( sheet1.GetCellText(1, "foreign_emp_type") );
			
			// 세금분납신청개월수 관련 추가 2017-11-16
			var tax_ins_yn = sheet1.GetCellValue(sheet1.LastRow(),"tax_ins_yn");
			
			$("input[name='tax_ins_yn']:input[value='"+tax_ins_yn+"']").attr("checked",true);
			$("#tax_ins_yn_month").val( sheet1.GetCellText(1, "tax_ins_yn_month") );
			
			fn_checkTaxInsYn();
			
			$("input[name='tax_rate']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"tax_rate")+"']").attr("checked",true);
			$("#foreign_emp_type").change();
			
			
			
		}
		
		residency_type_change();
	}

	//인력관리 개인기본사항(주소정보)가져오기
	function getPersonalAddr() {
		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=selectYeaDataOrgAddr",$("#sheet1Form").serialize(),false);
		if(typeof result.Data.zip == "undefined") {
			return ;
		}
		
		if ( zipcodeRefYn != null && zipcodeRefYn.length>0) {
			if(zipcodeRefYn[0].code_nm == "Y") {
				$("#zipCode").val( result.Data.zip.replace("-","").substr(0,3)+result.Data.zip.replace("-","").substr(3) ) ;
				
			}
			else {
				$("#zipCode").val( result.Data.zip.replace("-","").substr(0,3)+"-"+result.Data.zip.replace("-","").substr(3) ) ;
				
			}
		}
		$("#addr1").val( result.Data.addr1 ) ;
		$("#addr2").val( result.Data.addr2 ) ;
	}

	//소유주주택에 따라 히든처리
	function houseInfo(){

		if($("input[id='house_cnt']:checked").val() == "0" || $("input[id='house_cnt']:checked").val() == "2") {
			$("#house_get_ymd").val("") ;
			$("#house_area").val("") ;
			$("#official_price").val("") ;
			$("#houseinfo1").hide() ;
			$("#houseinfo2").hide() ;
			$("#houseinfo3").hide() ;
		} else{
			$("#houseinfo1").show() ;
			$("#houseinfo2").show() ;
			$("#houseinfo3").show() ;
		}
	}

	//우편번호 초기화
	function initZipCode(){
		$("#zipCode").val("") ;
		$("#addr1").val("") ;
		$("#addr2").val("") ;
		$("#house_get_ymd").val("") ;
		$("#house_area").val("") ;
		$("#official_price").val("") ;

		$("input[id='house_owner_yn']").attr("checked",false);
		$("input[id='house_cnt']").attr("checked",false);
		
		/*
		$("input[name='tax_ins_yn']:input[value='N']").attr("checked",true);
		$("input[name='tax_rate']:input[value='']").attr("checked",true);
		
		
		$("#foreign_tax_type").val("3") ; //적용안함
		$("#foreign_emp_type").val("") ;
		$("#national_cd").val("") ;
		$("#residency_cd").val("") ;
		$("input[id='residency_type']:input[value='1']").attr("checked",true);
		$("input[id='citizen_type']:input[value='1']").attr("checked",true);
		$("#reduce_s_ymd").val("") ;
		$("#reduce_e_ymd").val("") ;
		*/
		
		residency_type_change();
	}

	//우편번호 저장
	function saveZipCode(){
		zipCodeToSheet();
	}

	//우편번호 컨트롤 내용을 시트에 맵핑
	function zipCodeToSheet(){

		if($("#zipCode").val() == ""){
			alert("우편번호를 입력해 주십시요.");
			return;
		}
		sheet1.SetCellValue(1, "zip", $("#zipCode").val());
		sheet1.SetCellValue(1, "addr1", $("#addr1").val());
		sheet1.SetCellValue(1, "addr2", $("#addr2").val());

		sheet1.SetCellValue(1, "house_get_ymd", $("#house_get_ymd").val());
		sheet1.SetCellValue(1, "house_area", $("#house_area").val());
		sheet1.SetCellValue(1, "official_price", $("#official_price").val());

		if( $("input[id='house_owner_yn']:checked").val() != null ) {
			sheet1.SetCellValue(1, "house_owner_yn", $("input[id='house_owner_yn']:checked").val() ) ;
		} else {
			alert("주소사항(주민등록상)에서 세대주 여부(본인)를 체크해 주십시오.");
			return ;
		}
		if( $("input[id='house_cnt']:checked").val() != null ) {
			sheet1.SetCellValue(1, "house_cnt", $("input[id='house_cnt']:checked").val() ) ;
		}
		// 1주택일 경우 전용면적 및 공시지가 입력 체크
		if(sheet1.GetCellValue(1, "house_cnt") == 1){
			if(sheet1.GetCellValue(1, "house_get_ymd")==''){
				alert('주택 취득일자를 입력해 주세요');
				return;
			}
			if(sheet1.GetCellValue(1, "house_area")==''){
				alert('주택 전용면적을 입력해 주세요');
				return;
			}
		}

		sheet1.SetCellValue(1, "foreign_tax_type", $("#foreign_tax_type").val());
		sheet1.SetCellValue(1, "national_cd", $("#national_cd").val());
		sheet1.SetCellValue(1, "national_nm", $("#national_cd option[selected]").text());
		sheet1.SetCellValue(1, "residency_cd", $("#residency_cd").val());

		if( $("input[id='residency_type']:checked").val() != null ) {
			sheet1.SetCellValue(1, "residency_type", $("input[id='residency_type']:checked").val() ) ;
		}
		if( $("input[id='citizen_type']:checked").val() != null ) {
			sheet1.SetCellValue(1, "citizen_type", $("input[id='citizen_type']:checked").val() ) ;
		}
		sheet1.SetCellValue(1, "reduce_s_ymd", $("#reduce_s_ymd").val());
		sheet1.SetCellValue(1, "reduce_e_ymd", $("#reduce_e_ymd").val());

		sheet1.SetCellValue(1, "foreign_emp_type", $("#foreign_emp_type").val());
		
		if( cpn_yea_paytax_yn == "Y" ) {
			if( $("input[name='tax_ins_yn']:checked").val() != null ) { sheet1.SetCellValue(1, "tax_ins_yn", $("input[name='tax_ins_yn']:checked").val() ) ; }
		} else {
			sheet1.SetCellValue(1, "tax_ins_yn", "N");
		}
		
		if( cpn_yea_paytax_ins_yn == "Y" ) {
			if( $("input[name='tax_rate']:checked").val() != null ) { sheet1.SetCellValue(1, "tax_rate", $("input[name='tax_rate']:checked").val() ) ; }
		} else {
			sheet1.SetCellValue(1, "tax_rate", "100");
		}
		
		sheet1.SetCellValue(1, "tax_ins_yn_month", $("#tax_ins_yn_month").val());
		sheet1.SetCellValue(1, "input_status","1");
		
		doAction1("Save");
	}

	var pGubun = "";
	
	//우편번호 팝업 호출
	function openZipCode(){
		if(!isPopup()) {return;}
		pGubun = "zipCodePopup";
		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		var rst = "";
		if(zipcodePg != "new") {
		    rst = openPopup("<%=jspPath%>/common/zipCode"+zipcodePg+"Popup.jsp", "", "740","620");
		}else{
			rst = openPopup("<%=jspPath%>/common/newZipCodePopup.jsp", "", "740","620");
		}
		/*
		if(rst != null){
			$("#zipCode").val(rst[0]);
			$("#addr1").val(rst[1]);
			$("#addr2").val(rst[2]);
		}
		*/
	}
	
	function getReturnValue(returnValue) {
		var rst = $.parseJSON('{'+ returnValue+'}');
		
		if ( pGubun == "zipCodePopup" ){
            //우편번호조회
			if(zipcodePg != "new"){
				$("#zipCode").val(rst[0]);
	            $("#addr1").val(rst[1]);
	            $("#addr2").val(rst[2]);
			}else {
	        	$("#zipCode").val(rst.zip);
				$("#addr1").val(rst.doroAddr);
				$("#addr2").val(rst.detailAddr);
			}
		}
	}
	
	//거주자구분 변경시
	function residency_type_change() {
		var sVal = $("input[id='residency_type']:checked").val();
		
		if ( sVal == "2" ) {
			$('#residency_cd').removeAttr('disabled');
		} else {
			$("#residency_cd").attr("disabled", "true");
			$("#residency_cd").val("");
		}
	}
	
	function sheetChangeCheck() {
		var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}

	function commaText(obj,fraLeng) { 
		var strValue = obj.value;
		
		var intNum = (strValue.indexOf('.') != -1)? strValue.substring(0,strValue.indexOf('.')):strValue ;
		var fraNum = (strValue.indexOf('.') != -1)? strValue.substr(strValue.indexOf('.'),fraLeng+1) : '' ;
		
		intNum = intNum.replace(/\D/g,"");

		if (intNum.substr(0,1)==0 ) {
			intNum = intNum.substr(1);
		}

		var l = intNum.length-3;
		while(l>0) {
			intNum = intNum.substr(0,l)+","+intNum.substr(l);
			l -= 3;
		}
		
		if(fraNum.length > 0) {
			obj.value = intNum+fraNum;
		} else {
			obj.value = intNum;
		}
	}
	
	function fn_checkTaxInsYn(){
		if($("input:radio[name=tax_ins_yn]:checked").val() == "Y"){
			$("#tax_ins_yn_month").css("display","inline");
		}else{
			$("#tax_ins_yn_month").css("display","none");
		}
	}
	
</script>
</head>
<body class="bodywrap" style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="tabName" name="tabName" value="addrTab" />
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="15%" />
		<col width="" />
	</colgroup>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">주소사항(주민등록상)</li>
			<li class="btn">
				<span id="btnDisplayYn01">
				  <a href="javascript:saveZipCode();" class="basic authA" id="btnSave">저장</a>
				  <a href="javascript:initZipCode();" class="basic authA" id="btnInit">초기화</a>
				  &nbsp;&nbsp;&nbsp;
				  <a href="javascript:doAction1('confirm');" class="button authA" id="authTextA"><b id="authText">확정</b></a>
				</span>
			</li>
		</ul>
		</div>
	</div>
	<tr>
		<th>우편번호</th>
		<td class="left">
			<input id="zipCode" name="zipCode" type="text" class="text transparent" readOnly/>
			<a href="javascript:openZipCode('0');" class="basic authA" id="zipPopup">우편번호</a>
			<font color='red'>☜ 지번주소가 등록되어 있으신 분은, 도로명 주소로 전환하여 주시기 바랍니다.</font>
		</td>
	</tr>
		<tr>
		<th>기본주소</th>
		<td class="left">
			<input id="addr1" name="addr1" type="text" class="text w100p transparent" readOnly />
		</td>
	</tr>
	<tr class="hide">
		<th>상세주소</th>
		<td class="left">
			<input id="addr2" name="addr2" type="text" class="<%=textCss%> w100p" <%=readonly%>/>
		</td>
	</tr>
	<tr>
		<th>세대주 여부(본인)</th>
		<td class="left">
			<input type="radio" class="radio <%=disabled%>" name="house_owner_yn" id="house_owner_yn" value = "Y" <%=disabled%>>&nbsp;본인이 세대주임
			<input type="radio" class="radio <%=disabled%>" name="house_owner_yn" id="house_owner_yn" value = "N" <%=disabled%>>&nbsp;본인이 세대주가 아님
			<font color='red'>☜ 주택자금공제에 입력할 데이터가 있는 경우에만 세대주 및 주택소유여부 등을 선택하십시오.</font>
		</td>
	</tr>
	<tr>
		<th>소유주택수</th>
		<td class="left">
			<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt" value = "0" onclick="houseInfo();" <%=disabled%>>&nbsp;무주택
			<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt" value = "1" onclick="houseInfo();" <%=disabled%>>&nbsp;1주택
			<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt" value = "2" onclick="houseInfo();" <%=disabled%>>&nbsp;2주택이상
			<font color='red'>☜ 주택자금공제를 위한 기초자료</font>
		</td>
	</tr>
	<tr id='houseinfo1' style="display:none;">
		<th>주택취득일자</th>
		<td class="left">
			<input id="house_get_ymd" name="house_get_ymd" type="text" class="<%=textCss%>" size="10" maxlength="10" <%=readonly%>>
			<font color='red'>☜ 주택자금공제 대상이 되는 주택의 취득일자</font>
		</td>
	</tr>
	<tr id='houseinfo2' style="display:none;">
		<th>주택전용면적</th>
		<td class="left">
			<input name="house_area" id="house_area" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="10" <%=readonly%> /> ㎡
			<a href='http://www.realtyprice.kr/notice/' target='_blank'><font color='blue'><u>☞ 전용면적 및 공시지가 조회(국토해양부) 바로가기</u></font></a>
		</td>
	</tr>
	<tr id='houseinfo3' style="display:none;">
		<th>주택공시지가</th>
		<td class="left">
			<input name="official_price" id="official_price" type="text" class="<%=textCss%> right w150" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /> 원
		</td>
	</tr>
	</table>

	<div id="div_tax" style="display:;">
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="15%" />
		<col width="" />
	</colgroup>
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">원천징수세액 등</li>
		</ul>
		</div>
	</div>
	<tr id="tr_tax_ins_yn">
		<th>분납신청 여부</th>
		<td class="left">
			<input type="radio" class="radio <%=disabled%>" name="tax_ins_yn" id="tax_ins_yn_2" value="N" <%=disabled%> onchange="javascript:fn_checkTaxInsYn();">&nbsp;미신청
			<input type="radio" class="radio <%=disabled%>" name="tax_ins_yn" id="tax_ins_yn_1" value="Y" <%=disabled%> onchange="javascript:fn_checkTaxInsYn();">&nbsp;신청
			
			<select id="tax_ins_yn_month" name="tax_ins_yn_month" style="display: none;" class="box" <%=disabled%>>
				<option value="2">2개월</option>
				<option value="3">3개월</option>
			</select>
		</td>
	</tr>
	<tr id="tr_tax_rate">
		<th>원천징수세액 선택</th>
		<td class="left">
			<input type="radio" class="radio <%=disabled%>" name="tax_rate" id="tax_rate_1" value = "" <%=disabled%> checked >&nbsp;미선택
			<input type="radio" class="radio <%=disabled%>" name="tax_rate" id="tax_rate_2" value = "120" <%=disabled%> checked >&nbsp;120%
			<input type="radio" class="radio <%=disabled%>" name="tax_rate" id="tax_rate_3" value = "100" <%=disabled%>>&nbsp;100%
			<input type="radio" class="radio <%=disabled%>" name="tax_rate" id="tax_rate_4" value = "80" <%=disabled%>>&nbsp;80%
		</td>
	</tr>
	</table>
	</div>
	
<%if("Y".equals(adminYn)) {%>
	<div id="div_foreign" style="display:;">
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="15%" />
		<col width="" />
		<col width="15%" />
		<col width="" />
	</colgroup>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">외국인여부 인적사항 등</li>
		</ul>
		</div>
	</div>
	<tr>
		<th>외국인단일세율 적용여부</th>
		<td class="left">
			<select id="foreign_tax_type" name ="foreign_tax_type" class="box" <%=disabled%> ></select>
		</td>
		<th>외국법인소속 파견근로여부</th>
		<td class="left">
			<select id="foreign_emp_type" name ="foreign_emp_type" class="box" <%=disabled%> >
				<option value="Y">Yes</option>
				<option value="N">No</option>
			</select>
		</td>
	</tr>
	<tr>
		<th>내외국인구분</th>
		<td class="left">
			<input type="radio" class="radio <%=disabled%>" name="citizen_type" id="citizen_type" value = "1" <%=disabled%> checked >&nbsp;내국인
			<input type="radio" class="radio <%=disabled%>" name="citizen_type" id="citizen_type" value = "9" <%=disabled%>>&nbsp;외국인
		</td>
		<th>국적코드</th>
		<td class="left">
			<select id="national_cd" name ="national_cd" class="box" <%=disabled%> ></select>
		</td>
	</tr>
	<tr>
		<th>거주자구분</th>
		<td class="left">
			<input type="radio" class="radio <%=disabled%>" name="residency_type" id="residency_type" value = "1" <%=disabled%> checked >&nbsp;거주자
			<input type="radio" class="radio <%=disabled%>" name="residency_type" id="residency_type" value = "2" <%=disabled%>>&nbsp;비거주자
		</td>
		<th>거주지국코드</th>
		<td class="left">
			<select id="residency_cd" name ="residency_cd" class="box" <%=disabled%> ></select>
		</td>
	</tr>
	<tr>
		<th>감면기간</th>
		<td class="left" colspan="3" >
			<input id="reduce_s_ymd" name="reduce_s_ymd" type="text" class="text" /> ~
			<input id="reduce_e_ymd" name="reduce_e_ymd" type="text" class="text" />
		</td>
	</tr>
	</table>
	<div>
		<font color='red'>
			☜ [소득세법 제 12조, 2013.1.1 개정]에 의거 외국인 단일세율 선택시 건강보험과 고용보험의 회사부담금은 과세대상입니다.<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;(국민연금은 2013년 1월 1일부터 과세대상이 아닙니다.)<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;연간소득관리의 건강보험과 고용보험 금액에 입력된 금액은 자동적으로 급여총액으로 합산됩니다.<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;신고미기재대상 비과세 항목인 차량비과세와 식대비과세도 자동 합산처리되나 신고대상비과세는 임의 조정하시기 바랍니다.
		</font>
	</div>
	</div>
<%}%>
	</form>
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "200px"); </script>
	</span>
</div>
</body>
</html>