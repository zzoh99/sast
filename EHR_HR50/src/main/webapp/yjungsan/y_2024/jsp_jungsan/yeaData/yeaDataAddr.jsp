<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>주소사항</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%
	String engAddrUseStatus = (String)request.getParameter("engAddrUseStatus");
%>

<script type="text/javascript">
	var orgAuthPg = "<%=request.getParameter("orgAuthPg")%>";
	var zipcodePg = "";
	var zipcodeRefYn = "";
	var cpn_yea_paytax_yn = "";
	var cpn_yea_paytax_ins_yn = "";
	//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
	var confirmYn ="";
	var pGubun = "";
	var oneHouseYn = ""; //2019-11-12. 1주택 추가정보 사용 여부

	$(function(){
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		selectTargetZipCodeList();

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
			/*추후 연구후 로직 개발 {Header:"원천징수세액율old",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tax_rate_old",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }, */
			{Header:"상태코드",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"input_status",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"관리자여부",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"admin_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결혼세액공제신청여부",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"wed_tax_ded_check",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결혼세액공제신청확인일",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"wed_tax_ded_check_date",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"혼인신고일자",		Type:"Date",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"wed_ymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		//var foreign_tax_type_list = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00170"), "");
		var foreign_tax_type_list = ["3|5", "적용안함|19%단일세율"
			,"<option value='3'>적용안함</option>"
				+ "<option value='5'>19%단일세율</option>"
		];
		var national_cd_list = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20295"), "");

		$("#foreign_tax_type").html(foreign_tax_type_list[2]);  $("#foreign_tax_type").val("3") ; // 적용안함
		$("#national_cd").html("<option value=''></option>"+national_cd_list[2]);
		$("#residency_cd").html("<option value=''></option>"+national_cd_list[2]);

		//2019-11-12. 1주택 추가정보 사용 여부(주택취득일자, 주택전용면적, 주택공시지가)
		oneHouseYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_HOU_INFO_YN", "queryId=getSystemStdData",false).codeList;

		/* if ( oneHouseYn != null && oneHouseYn.length>0) {
			if(oneHouseYn[0].code_nm == "N") {
				$("#houseinfo1").hide() ;
				$("#houseinfo2").hide() ;
				$("#houseinfo3").hide() ;
            }
		} */

		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		zipcodeRefYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=ZIPCODE_REF_YN", "queryId=getSystemStdData",false).codeList;

		if ( zipcodeRefYn != null && zipcodeRefYn.length>0) {
			if(zipcodeRefYn[0].code_nm == "Y") {
                zipcodePg = "Ref";
            } else if(zipcodeRefYn[0].code_nm == "W") {
                zipcodePg = "new";
            } else if(zipcodeRefYn[0].code_nm == "D") {
            	$("#buttonPlus").hide();
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
		
		$("#wed_ymd").datepicker2({ymdonly:true,onReturn:function(){

            var sYy   = $("#wed_ymd").val();
            var chkYy = sYy.substr(0,4);

            if(chkYy != $("#searchWorkYy").val()){
            	alert("혼인신고일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#searchWorkYy").val()+".01.01 ~ "+$("#searchWorkYy").val()+".12.31");
                $("#wed_ymd").val("");
            }
        }});
	
		$("#wed_ymd").mask("1111-11-11") ;

		$("#reduce_s_ymd").mask("1111-11-11") ;
		$("#reduce_s_ymd").datepicker2({ymdonly:true});
		$("#reduce_e_ymd").mask("1111-11-11") ;
		$("#reduce_e_ymd").datepicker2({ymdonly:true});

		// 거주자여부 : 비거주자 선택시 거주지국 활성화, 그 외 거주지국 비활성화
		$("input[name=residency_type]").bind("change", residency_type_change);

		// 2018-07-25 원천징수세액 선택 시 신청여부 확인
		<%-- 추후 로직 연구후 개발
		$("[name='tax_rate']").on("click", function(){
			var params = "sabun="+$("#searchSabun").val();
            params += "&work_yy=" + $("#searchWorkYy").val();

         	var result1 = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=selectITaxRateApp",params,false);
         	if(Number(result1.Data.cnt) > 0){
         		alert("원천징수세액조정 신청내역이 존재하여 수정할 수 없습니다.");
         		$("input[name='tax_rate']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"tax_rate")+"']").attr("checked",true);
         		return;
         	}
		}); --%>

	});

	$(function() {
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smServerPaging,Page:20};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [

			{Header:"No",			Type:"<%=removeXSS(sNoTy, '1')%>",	Hidden:Number("<%=removeXSS(sNoHdn, '1')%>"),	Width:"<%=removeXSS(sNoWdt, '1')%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=removeXSS(sDelTy, '1')%>",	Hidden:1,					Width:"<%=removeXSS(sDelWdt, '1')%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태",			Type:"<%=removeXSS(sSttTy, '1')%>",	Hidden:1,					Width:"<%=removeXSS(sSttWdt, '1')%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"seq",			Type:"Text", Hidden:1,  Width:0,  Align:"Center",  SaveName:"idx",  		  EditLen:6 },
			{Header:"우편번호",		Type:"Text", Hidden:0,  Width:100,Align:"Center",  SaveName:"zipcode",    	  EditLen:6 },
			{Header:"도로명주소",		Type:"Text", Hidden:1,  Width:400,Align:"Left",    SaveName:"juso",     	  EditLen:200 },
			{Header:"신주소",			Type:"Text", Hidden:0,  Width:400,Align:"Left",    SaveName:"juso_s",     	  EditLen:200 },
			{Header:"지번주소",		Type:"Text", Hidden:0,  Width:200,Align:"Left",    SaveName:"juso_g",     	  EditLen:200 },
			{Header:"영문주소",		Type:"Text", Hidden:0,  Width:200,Align:"Left",    SaveName:"juso_e",     	  EditLen:200 },
			{Header:"시도",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sido",     	  EditLen:10 },
			{Header:"시도영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sido_e",    	  EditLen:20 },
			{Header:"시군구",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungu",  	  EditLen:20 },
			{Header:"시군구영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungu_e", 	  EditLen:50 },
			{Header:"읍면",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyon",   	  EditLen:20 },
			{Header:"읍면영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyon_e",  	  EditLen:20 },
			{Header:"도로명코드",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"road_code", 	  EditLen:20 },
			{Header:"도로명",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"road_name",      EditLen:20 },
			{Header:"도로명영문",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"road_name_e",	  EditLen:20 },
			{Header:"지하여부",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"isUnder",  	  EditLen:20 },
			{Header:"건물번호본번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdno_m",    	  EditLen:20 },
			{Header:"건물번호부번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdno_s",    	  EditLen:20 },
			{Header:"건물관리번호",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"bdno_d",    	  EditLen:20 },
			{Header:"다량배달처명",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"mass_delevery",  EditLen:20 },
			{Header:"시군구용건물명",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"sigungubd_name", EditLen:20 },
			{Header:"법정동코드",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"law_dong_code",  EditLen:20 },
			{Header:"법정동명",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"law_dong_name",  EditLen:20 },
			{Header:"리명",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"ri",             EditLen:20 },
			{Header:"행정동명",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"gov_dong_name",  EditLen:20 },
			{Header:"산여부",			Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"is_mountin",     EditLen:20 },
			{Header:"지번본번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"jibun_m",        EditLen:20 },
			{Header:"을면동일련번호",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"upmyundong_no",  EditLen:20 },
			{Header:"지번부번",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"jibun_s",        EditLen:20 },
			{Header:"우편번호6",		Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"old_zipcode",    EditLen:20 },
			{Header:"우편번호일련번호6",	Type:"Text", Hidden:1,  Width:0,  Align:"Left",    SaveName:"old_zipcodeNo",  EditLen:20 }
		]; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(4); sheet2.SetEditable(false);sheet2.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력

	 	$("#searchWord").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); return $(this).focus();
			}
		});

		$("#notFindAddrStatus").bind("click",function(event){
			if( !$("#notFindAddrStatus").is(":checked") ){
				$("#zipCode").attr("readonly", "readonly");
				$("#zipCode").addClass("readonly");

			}else{
				$("#zipCode").removeAttr("readonly");
				$("#zipCode").removeClass("readonly");
			}
		});

		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
        if(orgAuthPg == "A"){
            if(empStatus == "close_3" || empStatus == "close_4"){
            	$("#btnDisplayYn00").hide() ;
                $("#btnDisplayYn01").hide() ;
                sheet1.SetEditable(false) ;
                sheet2.SetEditable(false) ;
            }else{
                //자료등록 필수기입사항 msg(F_YEA_ALERT)
                /*var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=selectYeaAlert", $("#sheet1Form").serialize()+"&orgAuthPg="+orgAuthPg,false);
                if(result.Data.msg != ""){
                    alert(result.Data.msg);
                }*/
            }
        }else{
            if(empStatus != "close_2"){
                //본인마감
                //자료등록 필수기입사항 msg(F_YEA_ALERT)
                /*var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=selectYeaAlert", $("#sheet1Form").serialize()+"&orgAuthPg="+orgAuthPg,false);
                if(result.Data.msg != ""){
                    alert(result.Data.msg);
                }*/
            }
        }
		$(window).smartresize(sheetResize);
		/* doAction("Search"); */
	});

	//TD_CD 값 CPN_YEA_ADDR_POP_YN 의 STD_CD_VALUE 값이 없거나 N인경우 자료등록 우편번호+버튼 보이지 않도록
	function selectTargetZipCodeList(){
		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=selectTargetZipCodeList", $("#sheet1Form").serialize(),false);
		if((nvl(result.Data.cnt) > 0)){
			$("#buttonPlus").hide("fast");
			$("#buttonMinus").hide("fast");
		}
	}

	function engCheck(){
		if("${engAddrUseStatus}" != "Y"){
			$("#doroFullAddrEngTR").hide();
			$("#dtlAddrEngTR").hide();
		}
	}

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			//getZipCodePopupDoroList
			var param = {"Param":"cmd=getZipCodePopupDoroList&defaultRow=20&"+$("#sheet1Form").serialize()};
			sheet2.DoSearchPaging( "<%=jspPath%>/common/zipCodeRefPopupRst.jsp", param );
			break;
		}
    }

	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnClick(Row, Col){
		try{
			setAddr();
		} catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//2013-05-27 김장현 - 주소 부분에 세팅
	function setAddr(){
		//직접입력이 아닐 경우에만 주소 부분에 세팅
		if( !$("#notFindAddrStatus").is(":checked") ){
			//2013-05-27 김장현 - 팝업 주소창에서 상세주소까지 입력 하게 변경
			$("#zipCode").val(sheet2.GetCellValue(sheet2.GetSelectRow(), "zipcode"));
			$("#doroFullAddr").val(sheet2.GetCellValue(sheet2.GetSelectRow(), "juso_s"));
			$("#doroAddr").val(sheet2.GetCellValue(sheet2.GetSelectRow(), "juso"));
			var addrNote = "";
			var lawDongName = sheet2.GetCellValue(sheet2.GetSelectRow(), "law_dong_name");
			var sigungubdName = sheet2.GetCellValue(sheet2.GetSelectRow(), "sigungubd_name");
			if(lawDongName != ""){
				addrNote += "("+lawDongName;
				if(sigungubdName != "")	addrNote += ", "+sigungubdName;
				addrNote += ")";
			}
			$("#addrNote").val(addrNote);
			$("#doroFullAddrEng").val(sheet2.GetCellValue(sheet2.GetSelectRow(), "juso_e"));

		}else{
			alert("직접입력의 경우, 조회 내역을 사용 할 수 없습니다.\n조회 내역을 사용하시려면 직접입력 체크박스를 해제해주십시오.");
			return;
		}
	}

	function setValue(){
		var resDoroFullAddr = "";
		var resDoroFullAddrEng = $("#doroFullAddrEng").val();
		var resDoroAddr = $("#doroAddr").val();
		var resDtlAddr = $("#dtlAddr").val();
		var resAddrNote = $("#addrNote").val();
		var resZipCode = $("#zipCode").val();
		var resDtlAddrEng = $("#dtlAddrEng").val();

		//직접입력시
		if( $("#notFindAddrStatus").is(":checked") ){
			resDoroFullAddr = $("#dtlAddr").val();


			if( resZipCode == null || $.trim(resZipCode) == "" || resZipCode.length != 5){
				alert("우편번호를 입력하여 주십시오.");
				$("#zipCode").focus();
				return;
			}

			if( resDoroFullAddr == null || $.trim(resDoroFullAddr) == "" ){
				alert("상세주소를 입력하여 주십시오.");
				$("#dtlAddr").focus();
				return;
			}

			$("#zipCodeResult").val(resZipCode);	//직접 입력시 우편번호 set
			$("#addr1").val(resDoroFullAddr);		//직접 입력시 기본주소 set
			$("#addr2").val("");		//직접 입력시 기본주소 set

		//직접입력 아닐시
		} else{
			//우편번호 및 도로명주소 체크
			var checkzipCode = $("#zipCode").val();
			var checkDoroAddr =	$("#doroFullAddr").val();

			if( checkDoroAddr.length < 1 || checkzipCode.length < 1 ){
				alert( "주소찾기 기능을 통해 주소를 검색 한 후, 도로명 주소를 선택하여 주십시오." );
				return;
			}

			resDoroFullAddr = resDoroAddr;

			//상세 주소가 있다면 구분을 위해 사이에 ', ' 문자열 삽입.
			if(resDtlAddr.length > 0 ){
				resDoroFullAddr += ", "+resDtlAddr;
				$("#addr1").val(resDoroFullAddr);
			}

			//법정동 및 공동주택명이 있다면 구분을 위해 사이에 ' ' 문자열 삽입.
			if(resAddrNote.length > 0 ){
				resDoroFullAddr += " "+resAddrNote;
			}

			//영문도로명주소 조합
			resDoroFullAddrEng = resDtlAddrEng + ", " + resDoroFullAddrEng;

			$("#zipCodeResult").val(checkzipCode);		//직접 입력 아닐시 우편번호 set
			$("#addr1").val(resDoroFullAddr);			//직접 입력 아닐시 우편번호 set
			$("#addr2").val("");			//직접 입력 아닐시 우편번호 set
		}
		//확인버튼 선택시 화면 닫기
		$("#buttonMinus").hide("fast");
		$("#buttonPlus").show("fast");
	}

	/* 버튼 기능 */
	$(document).ready(function(){
		//우편번호- 버튼 선택시 우편번호+ 버튼 호출
		$("#buttonMinus").live("click",function(){
				var btnId = $(this).attr('id');
	    		if(btnId == "buttonMinus"){
	    			$("#buttonPlus").show("fast");
	    			$("#buttonMinus").hide("fast");
	    		}
		});

		//우편번호- 선택시 화면 숨김
		$("#buttonMinus").click(function(){
			$("#zipCodeMain").hide("fast");
	    });
		/* 우편번호 버튼 End */

	});

	//연말정산 대상자관리
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=selectYeaDataAddrList", $("#sheet1Form").serialize());
			break;
		case "Save":
			//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
			confirmYn = "";

			if(!parent.checkClose())return;

			// 비거주자 선택시 거주지국코드는 필수값
			if ( $("input[name='residency_type']:checked").val() == "2" ) {
				if ( $("#residency_cd").val() == "" ) {
					alert("비거주자로 선택하셨습니다. 거주지국 코드를 입력해 주십시오.");
					return;
				}
			}

			// 결혼세액공제 선택시 날짜입력 체크
			if ($("input[name='wed_tax_ded_check']:checked").val() == "Y") {
				// 신청이면서 혼인신고일자 미입력
				if ($("#wed_ymd").val() == "") {
					alert("결혼세액공제 신청을 선택하셨습니다. 혼인신고 일자를 입력해 주십시오.");
					return;
				}
				
				var wedYy = $("#wed_ymd").val();
				if (wedYy != "" && wedYy.length === 10) {
					wedYy = wedYy.substring(0, 4);
					
					if (wedYy != '2024') {
				    	alert("혼인신고일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#searchWorkYy").val()+".01.01 ~ "+$("#searchWorkYy").val()+".12.31");
				        //$("#wed_ymd").val("");
						return;
				    }
				} else {
					alert("혼인신고 일자는 yyyy-mm-dd의 형태로 입력해 주십시오.");
					return;
				}
				
			} else {
				//미신청이면서 혼인신고일자 입력
				if ($("#wed_ymd").val() != "") {
					alert("결혼세액공제 미신청을 선택하셨습니다. 결혼세액공제 신청을 선택 후 일자를 입력해 주십시오.");
					return;
				}
			}

			// 관리자여부값 입력
			for(var i = 1; i < sheet1.RowCount()+1; i++) {
           		sheet1.SetCellValue(i, "admin_yn", "<%=adminYn%>");
            }
			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=saveYeaDataAddr", $("#sheet1Form").serialize());
			$("#zipCodeMain").hide("fast");
			break;
		case "Confirm":
			//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
			confirmYn='confirm';

			if(!confirm($("#authText").text() + " 하시겠습니까?")){
				break;
			}
			//확정,확정취소시 체크
			subDoActionCheck();
          	//확정버튼 선택시 상태 업데이트
            sheet1.SetCellValue(1, "input_status","2");

            break;
		case "nConfirm":
			//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
			confirmYn='confirm';

			if(!confirm($("#authText").text() + " 하시겠습니까?")){
				break;
			}
			//확정,확정취소시 체크
			subDoActionCheck();
          	//확정취소버튼 선택시 상태 업데이트
            sheet1.SetCellValue(1, "input_status","1");

            break;
		}
	}

	// 감면기간 시작,종료일 체크
	function reduceDateCheck(){
		var rtn = true;
		var flag = true;
		var flag2 = true;

    	var reSYmd =  $("#reduce_s_ymd").val(); //감면기간시작일
    	var reEYmd =  $("#reduce_e_ymd").val(); //감면기간종료일

    	var subReSYmd = reSYmd.substring(0,4);
    	var subReEYmd = reEYmd.substring(0,4);

    	// 감면기간 시작,종료일이 존재할때
    	if(reSYmd != "" || reEYmd != ""){

    		// 감면기간 시작일의 연도가 귀속연도와 다를때
    		if(subReSYmd != $("#searchWorkYy").val()){
    			$("#reduce_s_ymd").val("");
    			flag = false;
    			rtn = false;
    		}

    		// 감면기간 종료일의 연도가 귀속연도와 다를때
    		if(subReEYmd != $("#searchWorkYy").val()){
    			$("#reduce_e_ymd").val("");
    			flag = false;
    			rtn = false;
    		}

    		if(reSYmd != "" && reEYmd != ""){
	    		// 감면기간 시작일 > 종료일
	    		if(reSYmd > reEYmd){
	    			$("#reduce_s_ymd").val("");//감면기간시작일
	    			$("#reduce_e_ymd").val("");//감면기간종료일
	    			flag2 = false;
	    			rtn = false;
	    		}
    		}
    	}
    	if(flag == false){
    		alert("감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#searchWorkYy").val()+".01.01 ~ "+$("#searchWorkYy").val()+".12.31");
    		return;
    	}else if (flag2 == false ){
			alert("감면기간 시작일자는 감면기간 종료일자보다 작아야합니다.");
			return;
    	}

		return rtn;
	}

	function subDoActionCheck() {

		var inputStatus = sheet1.GetCellValue(1, "input_status");
		//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
		confirmYn='confirm';

        if($("#authText").text() == "확정") {

        	if($("#zipCodeResult").val() != "" && $.trim($("#zipCode").val()) == ""){
        		alert("저장후 확정해주시기 바랍니다.");
        		return;
        	}

        	if($.trim($("#zipCode").val()) == ""){
				alert("우편번호를 입력해 주십시요.");
				return;
			}

			if($.trim($("#addr1").val()) == ""){
				alert("기본주소를 입력해 주십시요.");
				return;
			}

			//1주택 추가정보 사용여부에 따라 1주택 선택시 필수값 체크 추가 - 2020.01.16
			if ( oneHouseYn != null && oneHouseYn.length>0) {
				if(oneHouseYn[0].code_nm == "Y" && $("input:radio[name=house_cnt]:checked").val() == "1") {

					if($.trim($("#house_get_ymd").val()) == ""){
						alert("주택취득일자를 입력해 주십시요.");
						return;
					}

					if($.trim($("#house_area").val()) == ""){
						alert("주택전용면적을 입력해 주십시요.");
						return;
					}

					if($.trim($("#official_price").val()) == ""){
						alert("주택공시지가를 입력해 주십시요.");
						return;
					}
				}
			}

			// 결혼세액공제 선택시 날짜입력 체크
			if ($("input[name='wed_tax_ded_check']:checked").val() == "Y") {
				// 신청이면서 혼인신고일자 미입력
				if ($("#wed_ymd").val() == "") {
					alert("결혼세액공제 신청을 선택하셨습니다. 혼인신고 일자를 입력해 주십시오.");
					return;
				}

				var wedYy = $("#wed_ymd").val();
				if (wedYy != "" && wedYy.length === 10) {
					wedYy = wedYy.substring(0, 4);

					if (wedYy != '2024') {
						alert("혼인신고일은 귀속연도에 포함되어야 합니다.\n Ex) " + $("#searchWorkYy").val() + ".01.01 ~ " + $("#searchWorkYy").val() + ".12.31");
						return;
					}
				} else {
					alert("혼인신고 일자는 yyyy-mm-dd의 형태로 입력해 주십시오.");
					return;
				}
			} else {
				//미신청이면서 혼인신고일자 입력
				if ($("#wed_ymd").val() != "") {
					alert("결혼세액공제 미신청을 선택하셨습니다. 결혼세액공제 신청을 선택 후 일자를 입력해 주십시오.");
					return;
				}
			}
			
			//확정시 우편번호 비활성화
			$("#zipCodeResult").attr("readonly", "readonly");
			$("#zipCodeResult").addClass("readonly");

			//확정시 기본주소 비활성화
			 $("#addr1").attr("readonly", "readonly");
			$("#addr1").addClass("readonly");


            inputStatus = "1";
        } else {
            inputStatus = "0";
          	//확정시 우편번호 활성화
            $("#zipCodeResult").removeAttr("readonly");
			$("#zipCodeResult").removeClass("readonly");
			//확정시 기본주소 활성화
			$("#addr1").removeAttr("readonly");
			$("#addr1").removeClass("readonly");

        }

         var params = "input_status=" + inputStatus;
             params += "&work_yy="+$("#searchWorkYy").val();
             params += "&adjust_type="+$("#searchAdjustType").val();
             params += "&sabun="+$("#searchSabun").val();

         var result1 = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=saveYeaDataAddrConfirm",params,false);

        if( result1.Result.Code == "1") {
			//2024.10.31
			//DoSave의 세번째 파라미터를 공백으로 넘길 경우 sheet에 있는 데이터가 안넘어감으로 기본값인 -1로 세팅해줌
			<%--sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=saveYeaDataAddr",$("#sheet1Form").serialize(),"","0");--%>
			sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=saveYeaDataAddr",$("#sheet1Form").serialize(),-1,"0");
        	location.reload();
            doAction1("Search");
        }else{
        	location.reload();
        	doAction1("Search");
        }
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				sheetToZipCode();
				sheetToEtc();
				if("Y" == "<%=adminYn%>" || "N" == "<%=adminYn%>") {
					parent.getTotPay() ;
				}

				//확정 시 버튼 명 변경
			   var inputStatus = sheet1.GetCellValue(1, "input_status");

				if(sheet1.RowCount() > 0 && inputStatus != null && inputStatus != "" && inputStatus.substring(1,2) == "1") {
					$("#authTextA").show();
					$("#authTextA").removeClass("out-line");
					$("#authText").text("확정취소");
				    $("#btnSave").hide();
				    $("#btnInit").hide();

				    $("input:text").attr("disabled", true);
				    $("input:radio").attr("disabled", true);
				    $("input:checkbox").attr("disabled", true);
				    $("select").attr("disabled", true);
				    $("#zipPopup").attr("disabled", true);
				    $("#buttonPlus").attr("disabled", true);


				} else {
			    	$("#authTextA").show();
					$("#authTextA").addClass("out-line");
					$("#authText").text("확정");
					$("#btnSave").show();
                    $("#btnInit").show();

                    $("input:text").attr("disabled", false);
                    $("input:radio").attr("disabled", false);
                    $("input:checkbox").attr("disabled", false);
                    $("select").attr("disabled", false);
                    $("#zipPopup").attr("disabled", false);
                    $("#buttonPlus").attr("disabled", false);

					// 24.10.30 과거에 결혼세액공제를 받았을 경우(과거년도 TCPN811.WED_TAX_DED_CHECK 컬럼이 NULL값이 아닌 경우)
					// 공제를 받을 수 없기 때문에 결혼세액공제 관련 자료 수정 불가하도록 막는다.
					var checkWedTaxDedPrevious = ajaxCall("<%=jspPath%>/yeaData/yeaDataAddrRst.jsp?cmd=checkWedTaxDedPrevious", $("#sheet1Form").serialize(),false);
					if(checkWedTaxDedPrevious.Data != null && (nvl(checkWedTaxDedPrevious.Data.cnt) > 0)) {
						$("input[name='wed_tax_ded_check']").attr("disabled", true);
						$("#wed_ymd").attr("disabled", true);
						// datepicker2 달력 아이콘 숨김 처리
						$(".ui-datepicker-trigger").hide();
					}
					else {
						$("input[name='wed_tax_ded_check']").attr("disabled", false);
						$("#wed_ymd").attr("disabled", false);
						$(".ui-datepicker-trigger").show();
					}
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
			//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
			if(confirmYn == ""){
				alertMessage(Code, Msg, StCode, StMsg);
			}

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
			if(parent.getYeaCloseYn() == "N") {
				getPersonalAddr();
				return;
			}
		}else{
			//세대주여부
			$("input[name='house_owner_yn']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"house_owner_yn")+"']").attr("checked",true);

			//주택소유수
			$("input[name='house_cnt']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"house_cnt")+"']").attr("checked",true);
			
			var houseCnt = sheet1.GetCellValue(1, "house_cnt");
			// 1주택일 경우
			if(houseCnt == "1") {
				if ( oneHouseYn != null && oneHouseYn.length > 0) {
					// 주택 추가정보 입력 옵션 비활성화 상태인 경우에는 입력란 전부 숨김 처리
					if(oneHouseYn[0].code_nm == "N") {
						$("#houseinfo1").hide() ;
						$("#houseinfo2").hide() ;
						$("#houseinfo3").hide() ;
		            } else {
		            	$("#houseinfo1").show() ;
						$("#houseinfo2").show() ;
						$("#houseinfo3").show() ;
		            }
				}

			} else {
				// 2주택일 경우에는 추가 정보 전부 숨김 처리
				if(houseCnt == "2") {					
					$("#houseinfo1").hide() ;
					$("#houseinfo2").hide() ;
					$("#houseinfo3").hide() ;
				}
				// 무주택일 경우에는 국민주택규모여부만 표시
				else {
					$("#houseinfo1").hide() ;
					$("#houseinfo2").show() ;
					$("#houseinfo3").hide() ;
				}
			}

			if(sheet1.GetCellValue(sheet1.LastRow(), "zip") != "" ){
				$("#zipCode").val( sheet1.GetCellText(1, "zip") ) ;
				$("#zipCodeResult").val( sheet1.GetCellText(1, "zip") ) ;
				$("#addr1").val( sheet1.GetCellValue(1, "addr1") ) ;
				$("#addr2").val( sheet1.GetCellValue(1, "addr2") ) ;
			}else{
				getPersonalAddr();
			}

			$("#house_get_ymd").val( sheet1.GetCellText(1, "house_get_ymd") );
			//$("#house_area").val( sheet1.GetCellText(1, "house_area") );
			sheet1.GetCellText(1, "house_area") == 1 ? $(':checkbox[name=house_area]').attr('checked', true) : $(':checkbox[name=house_area]').attr('checked', false) ;
			$("#official_price").val( sheet1.GetCellText(1, "official_price") );

			$("#foreign_tax_type").val( sheet1.GetCellText(1, "foreign_tax_type") );
			$("#national_cd").val( sheet1.GetCellText(1, "national_cd") );
			$("#residency_cd").val( sheet1.GetCellText(1, "residency_cd") );
			$("input[name='residency_type']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"residency_type")+"']").attr("checked",true);
			$("input[name='citizen_type']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"citizen_type")+"']").attr("checked",true);
			$("#reduce_s_ymd").val( sheet1.GetCellText(1, "reduce_s_ymd") );
			$("#reduce_e_ymd").val( sheet1.GetCellText(1, "reduce_e_ymd") );

			$("#foreign_emp_type").val( sheet1.GetCellText(1, "foreign_emp_type") );

			// 세금분납신청개월수 관련 추가 2017-11-16
			var tax_ins_yn = sheet1.GetCellValue(sheet1.LastRow(),"tax_ins_yn");

			$("input[name='tax_ins_yn']:input[value='"+tax_ins_yn+"']").attr("checked",true);
			$("#tax_ins_yn_month").val( sheet1.GetCellText(1, "tax_ins_yn_month") );

			fn_checkTaxInsYn();


			/* 추후 로직 연구 후 개발 $("#taxRateOld").val(sheet1.GetCellValue(sheet1.LastRow(),"tax_rate_old")); */
			$("input[name='tax_rate']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"tax_rate")+"']").attr("checked",true);
			$("#foreign_emp_type").change();

			//$("#zipCodeResult").val(sheet1.GetCellValue(1, "zip"));
		}

		residency_type_change();
	}

	//시트에 내용을 기타사항 컨트롤에 맵핑
	function sheetToEtc(){
		
		if(sheet1.RowCount() != 0){
			//결혼세액공제신청여부
			$("input[name='wed_tax_ded_check']:input[value='"+sheet1.GetCellValue(sheet1.LastRow(),"wed_tax_ded_check")+"']").attr("checked",true);

			//혼인신고일
			$("#wed_ymd").val( sheet1.GetCellText(1, "wed_ymd") );
			
			var wedTaxDedCheck = sheet1.GetCellValue(1, "wed_tax_ded_check");
			// 혼인신고일 활성화
			if(wedTaxDedCheck != "Y") {
				$("input[name='wed_tax_ded_check']:input[value='N']").attr("checked",true);
			}
			
			$("#span_wedTaxDeCheckDt").html(sheet1.GetCellValue(1, "wed_tax_ded_check_date"));
            $("#span_wedTaxDeCheckDt").css("color", "red");
		}
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
				$("#zipCodeResult").val( result.Data.zip.replace("-","").substr(0,3)+result.Data.zip.replace("-","").substr(3) );
			}
			else {
				$("#zipCode").val( result.Data.zip.replace("-","").substr(0,3)+"-"+result.Data.zip.replace("-","").substr(3) ) ;
				$("#zipCodeResult").val( result.Data.zip.replace("-","").substr(0,3)+"-"+result.Data.zip.replace("-","").substr(3) );
			}
		}
		$("#addr1").val( result.Data.addr1 ) ;
		$("#addr2").val( result.Data.addr2 ) ;
	}

	//소유주주택에 따라 히든처리
	function houseInfo(){
		var houseCnt = $("input[name='house_cnt']:checked").val();
		
		if(houseCnt == "2") {
			$("#house_get_ymd").val("") ;
			$("#house_area").attr("checked", false) ;
			$("#official_price").val("") ;
			$("#houseinfo1").hide() ;
			$("#houseinfo2").hide() ;
			$("#houseinfo3").hide() ;
		} else if(houseCnt == "0") {
			// 무주택일 경우에는 국민주택규모여부만 확인
			$("#house_get_ymd").val("") ;
			$("#house_area").attr("checked", false) ;
			$("#official_price").val("") ;
			$("#houseinfo1").hide() ;
			$("#houseinfo2").show() ;
			$("#houseinfo3").hide() ;
		} else{
			if ( oneHouseYn != null && oneHouseYn.length>0) {
				if(oneHouseYn[0].code_nm == "N") {
					$("#houseinfo1").hide() ;
					$("#houseinfo2").hide() ;
					$("#houseinfo3").hide() ;
	            } else {
	            	$("#houseinfo1").show() ;
					$("#houseinfo2").show() ;
					$("#houseinfo3").show() ;
	            }
			}
		} 
	}

	//우편번호 초기화
	function initZipCode(){
		$("#zipCodeResult").val("") ;
		$("#addr1").val("") ;
		$("#addr2").val("") ;
		//$("#house_get_ymd").val("") ;
		//$("#house_area").val("") ;
		//$("#official_price").val("") ;
		//$("input[id='house_owner_yn']").attr("checked",false);
		//$("input[name='house_cnt']").attr("checked",false);

		residency_type_change();
	}

	//우편번호 저장
	function saveConfirmYn(sAction){

		if("Y" =="<%=adminYn%>"){
			if(!reduceDateCheck()) {return;}
		}

		// [확정버튼 상태값]  2:확정, 1:확정취소
		var inputStatus = sheet1.GetCellValue(1, "input_status");
		var subInputStatus = inputStatus.substring(1,2)

		//저장버튼 클릭시
		if(sAction == 'Save'){
			//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
			confirmYn = "";
			saveConfirmSheet();
		//확정버튼 클릭시
		}else{
			//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
			confirmYn='confirm';
			//확정시
			if(inputStatus.substring(1,2) == 1){
				if(subInputConfirmYn("N")) {
					sheet1.SetCellValue(1, "input_status","2");
					doAction1("Confirm");
				}
			//확정취소시
			}else{
				if(subInputConfirmYn("Y")) {
					sheet1.SetCellValue(1, "input_status","1");
					doAction1("nConfirm");
				}
			}
		}
	}

	//저장 버튼시
	function saveConfirmSheet(){
		//저장,확정 버튼 구분코드[null:저장, confirm:확정/확정취소]
		confirmYn = "";
		//저장,확정,확정취소 시 setvalue
		if(subInputConfirmYn("Y")) {
			doAction1("Save");
		}

	}

	function subInputConfirmYn(addrChkYn){

		if(addrChkYn != "N") {
			if($.trim($("#zipCodeResult").val()) == ""){
				alert("우편번호를 입력해 주십시요.");
				return false;
			}

			if($.trim($("#addr1").val()) == ""){
				alert("기본주소를 입력해 주십시요.");
				return false;
			}

			//1주택 추가정보 사용여부에 따라 1주택 선택시 필수값 체크 추가 - 2020.01.16
			// 23.11.16 주택정보 필수 입력 방지
			/*if ( oneHouseYn != null && oneHouseYn.length>0) {
				if(oneHouseYn[0].code_nm == "Y" && $("input:radio[name=house_cnt]:checked").val() == "1") {

					if($.trim($("#house_get_ymd").val()) == ""){
						alert("주택취득일자를 입력해 주십시요.");
						return false;
					}

					if($.trim($("#house_area").val()) == ""){
						alert("주택전용면적을 입력해 주십시요.");
						return false;
					}

					if($.trim($("#official_price").val()) == ""){
						alert("주택공시지가를 입력해 주십시요.");
						return false;
					}
				}
			}*/

		}

		if( $("input[name='house_owner_yn']:checked").val() != null ) {
			sheet1.SetCellValue(1, "house_owner_yn", $("input[name='house_owner_yn']:checked").val() ) ;
		} else {
			alert("주소사항(주민등록상)에서 세대주 여부(본인)를 체크해 주십시오.");
			return false;
		}

		if( $("input[name='house_cnt']:checked").val() != null ) {
			sheet1.SetCellValue(1, "house_cnt", $("input[name='house_cnt']:checked").val() ) ;
		}

		if( $("input[name='residency_type']:checked").val() != null ) {
			sheet1.SetCellValue(1, "residency_type", $("input[name='residency_type']:checked").val() ) ;
		}

		if( $("input[name='citizen_type']:checked").val() != null ) {
			sheet1.SetCellValue(1, "citizen_type", $("input[name='citizen_type']:checked").val() ) ;
		}

		if( cpn_yea_paytax_yn == "Y" ) {
			if( $("input[name='tax_ins_yn']:checked").val() != null ) { sheet1.SetCellValue(1, "tax_ins_yn", $("input[name='tax_ins_yn']:checked").val() ) ; }
		} else {
			sheet1.SetCellValue(1, "tax_ins_yn", "N");
		}
		sheet1.SetCellValue(1, "tax_rate", $("input[name='tax_rate']:checked").val());
		
		if( $("input[name='wed_tax_ded_check']:checked").val() != null ) {
			sheet1.SetCellValue(1, "wed_tax_ded_check", $("input[name='wed_tax_ded_check']:checked").val() ) ;
		}
		
// 		if( cpn_yea_paytax_ins_yn == "Y" ) {
// 			if( $("input[name='tax_rate']:checked").val() != null ) { sheet1.SetCellValue(1, "tax_rate", $("input[name='tax_rate']:checked").val() ) ; }
// 		} else {
// 			sheet1.SetCellValue(1, "tax_rate", "100");
// 		}

 		sheet1.SetCellValue(1, "zip", $("#zipCodeResult").val());
		sheet1.SetCellValue(1, "addr1", $("#addr1").val());
		sheet1.SetCellValue(1, "addr2", $("#addr2").val());
		sheet1.SetCellValue(1, "house_get_ymd", $("#house_get_ymd").val());
		sheet1.SetCellValue(1, "house_area", $("#house_area").is(":checked") == true ? 1 : 0);
		sheet1.SetCellValue(1, "official_price", $("#official_price").val());
		sheet1.SetCellValue(1, "foreign_tax_type", $("#foreign_tax_type").val());
		sheet1.SetCellValue(1, "national_cd", $("#national_cd").val());
		sheet1.SetCellValue(1, "national_nm", $("#national_cd option[selected]").text());
		sheet1.SetCellValue(1, "residency_cd", $("#residency_cd").val());
		sheet1.SetCellValue(1, "reduce_s_ymd", $("#reduce_s_ymd").val());
		sheet1.SetCellValue(1, "reduce_e_ymd", $("#reduce_e_ymd").val());
		sheet1.SetCellValue(1, "foreign_emp_type", $("#foreign_emp_type").val());
		sheet1.SetCellValue(1, "tax_ins_yn_month", $("#tax_ins_yn_month").val());
		sheet1.SetCellValue(1, "wed_ymd", $("#wed_ymd").val());
		return true;
	}

	function getReturnValue(returnValue) {
		var rst = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "zipCodePopup" ){
            //우편번호조회
			if(zipcodePg != "new"){
				$("#zipCodeResult").val(rst[0]);
	            $("#addr1").val(rst[1]);
	            $("#addr2").val(rst[2]);
			}else {
	        	$("#zipCodeResult").val(rst.zip);
				$("#addr1").val(rst.doroFullAddr);
				//상세주소까지 포함된 데이터가 ADDR1으로 전될되므로 ADDR2는 NULL 처리 - 2020.01.29
				//$("#addr2").val(rst.detailAddr);
				$("#addr2").val("");
			}
		}
	}

	//거주자구분 변경시
	function residency_type_change() {
		var sVal = $("input[name='residency_type']:checked").val();

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

	//우편번호 팝업 호출
	function openZipCode(){
		if(!isPopup()) {return;}
		pGubun = "zipCodePopup";
		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		var rst = "";
		if(zipcodePg != "new") {
		    <%-- rst = openPopup("<%=jspPath%>/common/zipCode"+zipcodePg+"Popup.jsp", "", "740","620"); --%>
		    $("#buttonMinus").show("fast");
		    $("#buttonPlus").hide("fast");
		    $("#zipCodeMain").show("fast");
		    doAction("Search");
		}else{
			rst = openPopup("<%=jspPath%>/common/newZipCodePopup.jsp", "", "740","620");
		}
	}
	
	function fn_wedTaxDedCheck(){
		var wedTaxDedCheck = $("input[name='wed_tax_ded_check']:checked").val();
			
		if(wedTaxDedCheck == "Y") {	
			alert("24~26년에 혼인신고를 한 거주자에 한하여 생애 1회 공제 받는 것을 확인하였습니다.");
		} else {
			$("#wed_ymd").val("");
			$("#span_wedTaxDeCheckDt").html("");
		}
	}

</script>
</head>
<body class="bodywrap" style="overflow-x:hidden;overflow-y:auto;" onLoad="engCheck();">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="tabName" name="tabName" value="addrTab" />
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="taxRateOld" name="taxRateOld" value="" />
	<input type="hidden" name="hangle_giha" value="지하" />
	<input type="hidden" name="hangle_san" value="산" />
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="15%" />
			<col width="" />
		</colgroup>
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="txt">주소사항(주민등록상)</li>
					
					<li class="btn" style="float:left; padding-left: 10px">
						<span id="btnDisplayYn00">
							<a href="javascript:initZipCode();" class="basic btn-white authA" id="btnInit">주소초기화</a>
						</span>
					</li>
						  
					<li class="btn">
						<span id="btnDisplayYn01">
						  <a href="javascript:saveConfirmYn('Save');" class="basic btn-save authA" id="btnSave"> 저장 </a>
						  &nbsp;
						  <a href="javascript:saveConfirmYn('Confirm');" class="basic btn-orange out-line authA" id="authTextA"><b id="authText"> 확정 </b></a>
						</span>
					</li>
				</ul>
			</div>
		</div>
		<tr>
			<th>우편번호</th>
			<td>
				<input id="zipCodeResult" name="zipCodeResult" type="text" class="text"/>
				<!-- <a href="javascript:openZipCode('0');" class="basic authA" id="zipPopup">우편번호 원본</a> -->
				<a href="javascript:openZipCode();" class="basic authA" id="buttonPlus"><b>우편번호+</b></a>
		        <a href="javascript:void(0);" class="basic authA" id="buttonMinus" style="display:none;"><b>우편번호-</b></a>
				<font class='red'>☜ 지번주소가 등록되어 있으신 분은, 도로명 주소로 전환하여 주시기 바랍니다.</font>
			</td>
		</tr>
		<tr>
			<th>기본주소</th>
			<td>
				<input id="addr1" name="addr1" type="text" class="text w100p" />
			</td>
		</tr>
		<tr class="hide">
			<th>상세주소</th>
			<td class="left">
				<input id="addr2" name="addr2" type="text" class="<%=textCss%> w100p" <%=readonly%>/>
			</td>
		</tr>
		<%-- <tr>
			<th>세대주 여부(본인)</th>
			<td class="left">
				<input type="radio" class="radio <%=disabled%>" name="house_owner_yn" id="house_owner_yn" value = "Y" <%=disabled%>>&nbsp;본인이 세대주임
				<input type="radio" class="radio <%=disabled%>" name="house_owner_yn" id="house_owner_yn" value = "N" <%=disabled%>>&nbsp;본인이 세대주가 아님
				<font class='red'>☜ 주택자금공제에 입력할 데이터가 있는 경우에만 세대주 및 주택소유여부 등을 선택하십시오.</font>
			</td>
		</tr>
		<tr>
			<th>소유주택수</th>
			<td class="left">
				<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt" value = "0" onclick="houseInfo();" <%=disabled%>>&nbsp;무주택
				<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt" value = "1" onclick="houseInfo();" <%=disabled%>>&nbsp;1주택
				<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt" value = "2" onclick="houseInfo();" <%=disabled%>>&nbsp;2주택이상
				<font class='red'>☜ 주택자금공제를 위한 기초자료</font>
			</td>
		</tr>
		<tr id='houseinfo1' style="display:none;">
			<th>주택취득일자</th>
			<td class="left">
				<input id="house_get_ymd" name="house_get_ymd" type="text" class="<%=textCss%>" size="10" maxlength="10" <%=readonly%>>
				<font class='red'>☜ 주택자금공제 대상이 되는 주택의 취득일자</font>
			</td>
		</tr>
		<tr id='houseinfo2' style="display:none;">
			<th>주택전용면적</th>
			<td class="left">
				<input name="house_area" id="house_area" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="10" <%=readonly%> /> ㎡
				<a href='http://www.realtyprice.kr/notice/' target='_blank'><font class='blue'><u>☞ 전용면적 및 공시지가 조회(국토교통부) 바로가기</u></font></a>
			</td>
		</tr>
		<tr id='houseinfo3' style="display:none;">
			<th>주택공시지가</th>
			<td class="left">
				<input name="official_price" id="official_price" type="text" class="<%=textCss%> right w150" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /> 원
			</td>
		</tr> --%>
	</table>

	<!-- 우편번호 조회 Start -->
	<div id="zipCodeMain" style="display:none;">
		<table>
			<div class="sheet_title" id="zipCodeSearch">
				<ul><li class="txt">우편번호 조회</li></ul>
			</div>
		</table>
		<div id="zipCodeSearchEx">
			<tr>
				<td><span>* 검색방법</span></br>
				1. 도로명/건물명 입력 <B>예)</B> 사평대로 84, 남부순환로 2406, 예술의전당<br/>
				2. 지번주소 입력 <B>예)</B> 반포동 112-4, 서초동 700<br/>
				<span class="red"><b>3. 도로명주소가 존재하지 않을 경우에만, 직접입력을 통해 주소를 입력 하십시오.</b></span>
				</td>
			</tr>
		</div><br/>
		<div class="sheet_search outer" id="zipCodeSearchMain">
			<div>
				<table>
					<tr>
						<td>
							<span>검색어</span>
							<input id="searchWord" name ="searchWord" type="text" class="text"  style="width:300px"/>
						</td>
						<td><input type="checkbox" id="notFindAddrStatus" name="notFindAddrStatus" style="vertical-align:middle;"/>직접입력</td>
						<td><a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a></td>
						<td><a href="javascript:setValue();" class="basic authA">확인</a></td>
					</tr>
				</table>
			</div>
		</div>
		<br>
		<div class="outer" id="zipCodeSearchList">
			<span><script type="text/javascript">createIBSheet("sheet2", "100%", "200px"); </script></span>
		</div>
		<br/>
		<div class="outer" id="zipCodeSearchDetail">
			<table class="default">
					<colgroup>
							<col width="17%" />
							<col width="" />
					</colgroup>
					<tr>
							<td>우편번호</td>
							<td><input type="text" id="zipCode" name="zipCode" size="30" maxlength="7" class="readonly" readOnly/></td>
					</tr>
					<tr>
							<td>도로명주소</td>
							<td><input type="text" id="doroFullAddr" name="doroFullAddr" size="70" class="readonly" readOnly/></td>
					</tr>
					<tr>
							<td>상세주소</td>
							<td><input type="text" id="dtlAddr" name="dtlAddr" size="70"/></td>
					</tr>
					<tr id="doroFullAddrEngTR" >
							<td>영문도로명주소</td>
							<td><input type="text" id="doroFullAddrEng" name="doroFullAddr" size="70" class="readonly" readOnly/></td>
					</tr>
					<tr id="dtlAddrEngTR" >
							<td>영문상세주소</td>
							<td><input type="text" id="dtlAddrEng" name="dtlAddr" size="70"/></td>
					</tr>
					<input type="hidden" id="doroAddr" name="doroAddr" />
				<input type="hidden" id="addrNote" name="addrNote" />
			</table>
		</div>
	</div>
	<!-- 우편번호 조회 End -->
	
	<div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">주택정보 <span id="houseInfo"></span>
            </li>
        </ul>
        </div>
    </div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<tr>
			<th>세대주 여부(본인)</th>
			<td class="left">
				<input type="radio" class="radio <%=disabled%>" name="house_owner_yn" id="house_owner_yn1" value = "Y" <%=disabled%>>&nbsp;본인이 세대주임
				<input type="radio" class="radio <%=disabled%>" name="house_owner_yn" id="house_owner_yn2" value = "N" <%=disabled%>>&nbsp;본인이 세대주가 아님
				<font class='red'>☜ 주택자금공제에 입력할 데이터가 있는 경우에만 세대주 및 주택소유여부 등을 선택하십시오.</font>
			</td>
		</tr>
		<tr>
			<th>소유주택수</th>
			<td class="left">
				<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt1" value = "0" onclick="houseInfo();" <%=disabled%>>&nbsp;무주택
				<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt2" value = "1" onclick="houseInfo();" <%=disabled%>>&nbsp;1주택
				<input type="radio" class="radio <%=disabled%>" name="house_cnt" id="house_cnt3" value = "2" onclick="houseInfo();" <%=disabled%>>&nbsp;2주택이상
				<font class='red'>☜ 주택자금공제를 위한 기초자료</font>
			</td>
		</tr>
		<tr id='houseinfo1' style="display:none;">
			<th>주택취득일자</th>
			<td class="left">
				<input id="house_get_ymd" name="house_get_ymd" type="text" class="<%=textCss%>" size="10" maxlength="10" <%=readonly%>>
				<font class='red'>☜ 주택자금공제 대상이 되는 주택의 취득일자</font>
			</td>
		</tr>
		<tr id='houseinfo2' style="display:none;">
			<th>국민주택규모 여부</th>
			<td class="left">
				<%-- <input name="house_area" id="house_area" type="text" class="<%=textCss%> right" onFocus="this.select()" value="" maxlength="10" <%=readonly%> /> ㎡ --%>
				<input type="checkbox" id="house_area" name="house_area" value=1 class="checkbox" <%=readonly%> />
				<a href='http://www.realtyprice.kr/notice/' target='_blank'><font class='blue'><u>☞ 전용면적 및 기준시가 조회(국토교통부) 바로가기</u></font></a>
				<font class='red'>☜  수도권 : 전용면적 기준 85㎡ 이하, 수도권 외 읍면동 : 100㎡ 이하.</font>
			</td>
		</tr>
		<tr id='houseinfo3' style="display:none;">
			<th>주택기준시가</th>
			<td class="left">
				<input name="official_price" id="official_price" type="text" class="<%=textCss%> right w150" onFocus="this.select()" value="" maxlength="20" <%=readonly%> /> 원
				<font class='red'>☜ 취득당시 기준시가 확인 후 입력해주시기 바랍니다. 미입력시 주택자금공제 검증을 하지 않습니다.</font>
			</td>
		</tr>
	</table>
	<div id="infoLayer" class="new" style="display:none"></div>
	
	<div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기타사항</li>
        </ul>
        </div>
    </div>
	<div>
		<font class="red">※ 결혼세액공제 대상 : 24~26년에 혼인신고를 한 거주자. (생애 1회)</font>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="15%" />
			<col width="31%" />
			<col width="15%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>결혼세액공제 신청</th>
			<td class="left">
				<input type="radio" class="radio <%=disabled%>" name="wed_tax_ded_check" id="wed_tax_ded_check1" value = "N" onchange="fn_wedTaxDedCheck();" <%=disabled%>>&nbsp;미신청
				<input type="radio" class="radio <%=disabled%>" name="wed_tax_ded_check" id="wed_tax_ded_check2" value = "Y" onchange="fn_wedTaxDedCheck();" <%=disabled%>>&nbsp;신청
				<span id="span_wedTaxDeCheckDt"></span>
			</td>
			<th>혼인신고 일자</th>
			<td class="left">
				<input id="wed_ymd" name="wed_ymd" type="text" class="date2" size="10" maxlength="10">
			</td>
		</tr>
	</table>

	<div id="div_tax" >
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
			<input type="radio" class="radio <%=disabled%>" name="tax_rate" id="tax_rate_2" value = "120" <%=disabled%>>&nbsp;120%
			<input type="radio" class="radio <%=disabled%>" name="tax_rate" id="tax_rate_3" value = "100" <%=disabled%>>&nbsp;100%
			<input type="radio" class="radio <%=disabled%>" name="tax_rate" id="tax_rate_4" value = "80" <%=disabled%>>&nbsp;80%
			<font class='red'>☜ 1년단위 신청</font>
		</td>
	</tr>
	</table>
	</div>

<%if("Y".equals(adminYn)) {%>
	<div id="div_foreign">
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
			<input type="radio" class="radio <%=disabled%>" name="citizen_type" id="citizen_type1" value = "1" <%=disabled%> checked >&nbsp;내국인
			<input type="radio" class="radio <%=disabled%>" name="citizen_type" id="citizen_type9" value = "9" <%=disabled%>>&nbsp;외국인
		</td>
		<th>국적코드</th>
		<td class="left">
			<select id="national_cd" name ="national_cd" class="box" <%=disabled%> ></select>
		</td>
	</tr>
	<tr>
		<th>거주자구분</th>
		<td class="left">
			<input type="radio" class="radio <%=disabled%>" name="residency_type" id="residency_type1" value = "1" <%=disabled%> checked >&nbsp;거주자
			<input type="radio" class="radio <%=disabled%>" name="residency_type" id="residency_type2" value = "2" <%=disabled%>>&nbsp;비거주자
		</td>
		<th>거주지국코드</th>
		<td class="left">
			<select id="residency_cd" name ="residency_cd" class="box" <%=disabled%> ></select>
		</td>
	</tr>
	<tr>
		<th>감면기간</th>
		<td class="left" colspan="3" >
			<input id="reduce_s_ymd" name="reduce_s_ymd" type="text" class="date2" /> ~
			<input id="reduce_e_ymd" name="reduce_e_ymd" type="text" class="date2" />
		</td>
	</tr>
	</table>
	<div>
		<font class='red'>
			☜ [소득세법 제 12조, 2013.1.1 개정]에 의거 외국인 단일세율 선택시 건강보험과 고용보험의 회사부담금은 과세대상입니다.<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;(국민연금은 2013년 1월 1일부터 과세대상이 아닙니다.)<br/>
			&nbsp;&nbsp;&nbsp;&nbsp;연간소득관리의 건강보험과 고용보험 금액에 입력된 금액은 자동적으로 급여총액으로 합산됩니다.<br/>
			<%-- 20231229 &nbsp;&nbsp;&nbsp;&nbsp;신고미기재대상 비과세 항목인 차량비과세와 식대비과세도 자동 합산처리되나 신고대상비과세는 임의 조정하시기 바랍니다. --%>
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