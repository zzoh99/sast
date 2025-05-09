<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>세금계산 결과보기</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>
<%@ include file="../common/commonTooltip.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<style type="text/css">
    #don_detail_pop { width: 800px; height: 250px; padding: 0.5em; }
    #foreign_pay_detail_pop { width: 800px; height: 250px; padding: 0.5em; }
</style>

<script>
// 기부금상세  팝업
$(function() {
  $("#menuNm").val($(document).find("title").text());
  $( "#don_detail_pop" ).draggable();
  $( "#don_detail_pop" ).css("display","none");
});

// 기부금 상세 팝업 open
function viewPopup(){

    var tableX = $( '#wkp_table' ).offset().left + 50;
    var tableY = $( '#donDetailBtn' ).offset().top + 30;

    $("#don_detail_pop").attr("style","left:"+tableX+"px;position:absolute;top:"+tableY+"px;z-index:1;background:white;border:solid gray;");
    $("#don_detail_pop").css("display","block");

    searchData();
}
// 기부금 상세팝업 close
function hidePopup(){
    $("#don_detail_pop").hide();
}
function searchData(){
    var params = "searchWorkYy="+$("#searchWorkYy", parent.document).val();
        params +="&searchAdjustType="+$("#searchAdjustType", parent.document).val();
        params +="&searchSabun="+$("#searchSabun", parent.document).val();

    sheet4.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectDonDetailList", params);
}

// 외국납부 상세팝업
$(function() {
    $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
    $( "#foreign_pay_detail_pop" ).draggable();
    $( "#foreign_pay_detail_pop" ).css("display","none");
});

// 외국납부 상세 팝업 open
function viewForeignPayPopup(){

    var tableX = $( '#wkp_table' ).offset().left + 50;
    var tableY = $( '#donDetailBtn' ).offset().top + 30;

    $("#foreign_pay_detail_pop").attr("style","left:"+tableX+"px;position:absolute;top:"+tableY+"px;z-index:1;background:white;border:solid gray;");
    $("#foreign_pay_detail_pop").css("display","block");

    searchForeignPayData();
}
// 외국납부 상세팝업 close
function hideForeignPayPopup(){
    $("#foreign_pay_detail_pop").hide();
}
function searchForeignPayData(){
    var params = "searchWorkYy="+$("#searchWorkYy", parent.document).val();
    params +="&searchAdjustType="+$("#searchAdjustType", parent.document).val();
    params +="&searchSabun="+$("#searchSabun", parent.document).val();

    sheet6.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectForeignPayDetailList", params);
}
<%-- //50세이상확인 유무 조회(2021.11)
function getAgeChk(){

    var params = $("#yeaResultShtForm").serialize();
        params += "&queryId=getAgeChk";

    var ageChkYn = ajaxCall("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=getAgeChk",params,false);

    if(ageChkYn.Data.age_chk != "N" && ageChkYn.Data.age_chk.length > 0) {
        $(':checkbox[name=ageChkYn]').attr('checked', true);
    } else {
        $(':checkbox[name=ageChkYn]').attr('checked', false);
    }
} --%>
//외국인단일세율적용 조회
function getFrgTaxChk(){

    var params = $("#yeaResultShtForm").serialize();
        params += "&queryId=getFrgTaxChk";

    var frgChk = ajaxCall("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=getFrgTaxChk",params,false);

    if(frgChk.Data.frg_chk == "5" && frgChk.Data.frg_chk.length > 0) {
    	$("#displayYn1").css("display","");
    	$("#displayYn2").css("display","none");
    	$("#displayYn3").css("display","");
        alert("외국인 단일세율이 적용되어 세금계산시 비과세, 인적공제, 소득공제, 세액공제등이 적용되지 않습니다.");
    } else {
    	$("#displayYn1").css("display","none");
    	$("#displayYn2").css("display","");
    	$("#displayYn3").css("display","none");
    }
}
</script>

<script type="text/javascript">
//관리자권한
var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
var waitFlag = false;
//true: 모의계산 조회 활성, false: 모의계산 조회 비활성
//비정상적인 접근시 모의계산 버튼 조회 차단
var yeaDefault = false;

    $(function() {
        /*필수 기본 세팅*/
        $("#searchWorkYy").val(     $("#searchWorkYy", parent.document).val()       ) ;
        $("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()   ) ;
        $("#searchSabun").val(      $("#searchSabun", parent.document).val()        ) ;

        //N:마감전, Y: 마감 상태 체크
        yeaDefaultInfo = getYearDefaultInfoObj();

        if(yeaDefaultInfo.Data.final_close_yn == "N") {
            yeaDefault = true;
        }else{
            yeaDefault = false;
            return;
        }
        // 표준세액공제 적용 문구
        $("#sht5_A099_01_font").hide();
    });

    $(function(){

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"work_yy",                  Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"work_yy",                 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"adjust_type",              Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adjust_type",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"sabun",                    Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",                   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"enter_no",                 Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"enter_no",                KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"adj_s_ymd",                Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adj_s_ymd",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"adj_e_ymd",                Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adj_e_ymd",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"residency_type",           Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"residency_type",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"citizen_type",             Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"citizen_type",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"residence_cd",             Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"residence_cd",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"residence_nm",             Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"residence_nm",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_pay_mon",              Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_pay_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_bonus_mon",            Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_bonus_mon",           KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_etc_bonus_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_etc_bonus_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_tot_mon",              Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_tot_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_pay_mon",             Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_pay_mon",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_bonus_mon",           Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_bonus_mon",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_etc_bonus_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_etc_bonus_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_tot_mon",             Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_tot_mon",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_tot_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_tot_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_abroad_mon",    Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_abroad_mon",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_food_mon",    	Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_food_mon",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_work_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_work_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_etc_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_etc_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_job_invt_mon",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_job_invt_mon", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
            {Header:"curr_notax_rpt_mon",	    Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_rpt_mon", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_ext_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_ext_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_tot_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_tot_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"notax_tot_mon",            Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"notax_tot_mon",           KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"other_pay_mon",            Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"other_pay_mon",           KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"other_notax_mon",          Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"other_notax_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"taxable_pay_mon",          Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"taxable_pay_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"income_mon",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"income_mon",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"stand_deduct_mon",         Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"stand_deduct_mon",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"blnce_income_mon",         Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"blnce_income_mon",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"tax_base_mon",             Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"tax_base_mon",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"clclte_tax_mon",           Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"clclte_tax_mon",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"tot_tax_deduct_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"tot_tax_deduct_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"fin_income_tax",           Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"fin_income_tax",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"fin_inbit_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"fin_inbit_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"fin_agrcl_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"fin_agrcl_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"fin_tot_tax_mon",          Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"fin_tot_tax_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"fin_hel_mon",              Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"fin_hel_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_income_tax_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_income_tax_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_inbit_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_inbit_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_agrcl_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_agrcl_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_tot_tax_mon",          Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_tot_tax_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_hel_mon",              Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_hel_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_income_tax_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_income_tax_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_inbit_tax_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_inbit_tax_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_agrcl_tax_mMon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_agrcl_tax_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_tot_tax_mon",         Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_tot_tax_mon",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_hel_mon",             Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_hel_mon",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"blc_income_tax_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"blc_income_tax_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"blc_inbit_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"blc_inbit_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"blc_agrcl_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"blc_agrcl_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"blc_tot_tax_mon",          Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"blc_tot_tax_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"blc_hel_mon",              Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"blc_hel_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"spc_income_tax_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"spc_income_tax_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"spc_inbit_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"spc_inbit_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"spc_agrcl_tax_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"spc_agrcl_tax_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"spc_tot_tax_mon",          Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"spc_tot_tax_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"eff_tax_rate",         Type:"Float",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"eff_tax_rate",        KeyField:0, Format:"##0.0", PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_baby_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_baby_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_child_birth_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_child_birth_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_forn_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_forn_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_notax_research_mon",  Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_notax_research_mon", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_baby_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_baby_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_child_birth_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_child_birth_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_forn_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_forn_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_research_mon",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_research_mon",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_abroad_mon",     Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_abroad_mon",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_food_mon",     	Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_food_mon",    	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_work_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_work_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_etc_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_etc_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_notax_job_invt_mon",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_job_invt_mon",  KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
            {Header:"pre_notax_rpt_mon",	    Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_rpt_mon",  KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_ext_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_notax_ext_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_stock_buy_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_stock_buy_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_stock_union_mon",     Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_stock_union_mon",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_stock_buy_mon",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_stock_buy_mon",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_stock_union_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_stock_union_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_imwon_ret_over_mon",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"curr_imwon_ret_over_mon",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pre_imwon_ret_over_mon",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pre_imwon_ret_over_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"curr_job_invt_ovr_mon",    Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_job_invt_ovr_mon", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_job_invt_ovr_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_job_invt_ovr_mon",  KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"limit_over_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"limit_over_mon",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"temp",                     Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"temp",                    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 }
        ]; IBS_InitSheet(yeaResultSht2, initdata1);yeaResultSht2.SetEditable(false);yeaResultSht2.SetVisible(true);yeaResultSht2.SetCountPosition(4);

        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata2.Cols = [
            {Header:"work_yy",              Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"work_yy",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"adjust_type",          Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adjust_type",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"sabun",                Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"business_place_cd",    Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"business_place_cd",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pay_action_cd",        Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pay_action_cd",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"zip",                  Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"zip",                 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"addr1",                Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr1",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"org_cd",               Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"org_cd",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"org_nm",               Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"org_nm",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"input_close_yn",       Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"input_close_yn",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"apprv_yn",             Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"apprv_yn",            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"final_close_yn",       Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"final_close_yn",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"pay_people_status",    Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"pay_people_status",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"res_no",               Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"res_no",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"result_confirm_yn",    Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"result_confirm_yn",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 }
        ]; IBS_InitSheet(yeaResultSht3, initdata2);yeaResultSht3.SetEditable(false);yeaResultSht3.SetVisible(true);yeaResultSht3.SetCountPosition(4);

        var initdata3 = {};
        initdata3.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata3.Cols = [
            {Header:"a00001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a000_01",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a01001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a010_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a01003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a010_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a01011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a010_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02004",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_04",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04003_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_03_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04004_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_04_inp",      KeyField:0,    Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% //2015-04-23 추가,수정 start%>
                {Header:"a04005_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04005_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04007_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04007_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% //2015-04-23 추가,수정 end%>
                {Header:"a05001_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_01_inp",      KeyField:0,    Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05001_std",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_01_std",      KeyField:0,    Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06001_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_01_inp",      KeyField:0,    Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06001_std",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_01_std",      KeyField:0,    Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07021",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_21",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07017",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_17",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07015",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_15",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07016",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_16",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07022",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_22",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07023",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_23",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2015년 추가 start%>
                {Header:"a07024",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_24",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07025",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_25",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07026",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_26",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07027",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_27",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2015년 추가 end%>
                {Header:"a08001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10021",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_21",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10023",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_23",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10029",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_29",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10030",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_30",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10035",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_35",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10037",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_37",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10040",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_40",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10041",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_41",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01301",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b013_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a09901",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a099_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01015",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_15",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"ex_b01016",    Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"ex_b010_16",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01016",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_16",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01017",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_17",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01014_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_14_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01015_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_15_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"ex_b01016_inp",    Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"ex_b010_16_inp",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b0103031_inp",     Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_30_31_inp",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01017_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_17_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01013",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00001",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b000_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00010",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b000_10",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                // 24.11.01 결혼세액공제 신설
                {Header:"b00210",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b002_10",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <%//2015-04-23 start%>
                {Header:"b00010_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b000_10_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00120",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00130",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_30",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00120_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_20_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b00130_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_30_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <%//2015-04-23 end%>
                {Header:"b01011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a01011_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a010_11_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02003_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_03_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02005_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_05_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03001_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_01_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04004",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_04",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <%//2015-04-23 start%>
                {Header:"a04005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a04007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <%//2015-04-23 end%>
                {Header:"a05005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06005_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_05_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06007_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_07_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06009_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_09_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06011_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_11_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07013",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07019",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_19",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07010_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_10_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07010_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_10_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07010",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_10",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07017_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_17_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07015_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_15_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07016_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_16_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07022_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_22_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07023_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_23_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2015년 추가 start%>
                {Header:"a07024_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_24_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07025_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_25_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07026_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_26_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a07027_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_27_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2015년 추가 end%>
                {Header:"a08007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08009_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_09_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08009_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_09_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08010",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_10",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a09901",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a099_01",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10003_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_03_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10030_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_30_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10040_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_40_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10041_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_41_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10034",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_34",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10031",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_31",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10032",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_32",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10033",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_33",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10011",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10008",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_08",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10010",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_10",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10015",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_15",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10013",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10022",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_22",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10042",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_42",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10017",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_17",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10021_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_21_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10026",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_26",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10027",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_27",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10028",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_28",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10037_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_37_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10099",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_99",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01001_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_01_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01003_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_03_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01005_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_05_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01005_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_05_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"b01009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b010_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a02014",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a020_14",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03004",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_04",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03004_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_04_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03004_std",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_04_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03003",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03003_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_03_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03003_std",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_03_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10005_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_05_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10005_std",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_05_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"isa_mon",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"isa_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"isa_mon_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"isa_mon_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"isa_mon_std",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"isa_mon_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05020",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a05021",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a050_21",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06020",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a06021",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a060_21",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10009",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_09",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10012",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_12",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10055",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_55",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10056",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_56",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10057",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_57",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10058",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_58",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2016년 추가 start%>
                {Header:"a10057",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_59",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10058",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_60",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2016년 추가 end%>
                <% // 2017년 추가 start%>
                {Header:"a10071",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_71",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10072",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_72",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2017년 추가 end%>
                <% // 2018년 추가 start%>
                {Header:"a10073",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_73",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10074",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_74",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2018년 추가 end%>
                {Header:"a10075",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_75",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10076",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_76",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2019년 추가 end%>
                <% // 2020년 추가 start%>
                {Header:"a10077",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_77",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10078",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_78",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2020년 추가 end%>
                <% // 2021년 추가 start%>
                {Header:"a10079",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_79",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10080",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_80",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10081",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_81",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10082",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_82",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10083",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_83",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2021년 추가 end%>
                <% // 2022년 추가 start%>
                {Header:"a10084",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_84",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10085",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_85",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10086",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_86",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2022년 추가 end%>
                <% // 2023년 추가 start%>
                {Header:"a10087",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_87",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10088",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_88",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10089",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_89",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2023년 추가 end%>
                <% // 2024년 추가 start%>
                {Header:"a10090",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_90",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10091",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_91",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10092",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_92",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                <% // 2024년 추가 end%>
                {Header:"a10016",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_16",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10038",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_38",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10038_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_38_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10034_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_34_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10031_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_31_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a10033_inp",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_33_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08005",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08005_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_05_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08005_std",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_05_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08015",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_15",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08015_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_15_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08015_std",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_15_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08017",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_17",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08017_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_17_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08017_std",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_17_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08003",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_03",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08003_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_03_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08003_std",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_03_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a080013",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08001011_inp",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_10_11_inp",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a080013_std",      Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_13_std",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a09902",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a099_02",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a08020",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03011",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_11",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03012",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_12",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03002",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_02",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03013",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_13",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03011_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_11_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03012_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_12_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03002_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_02_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"a03013_inp",               Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a030_13_inp",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 }
            ]; IBS_InitSheet(yeaResultSht5, initdata3);yeaResultSht5.SetEditable(false);yeaResultSht5.SetVisible(true);yeaResultSht5.SetCountPosition(4);

            var initdata4 = {};
            initdata4.Cfg = {SearchMode:smLazyLoad,Page:22};
            initdata4.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
            initdata4.Cols = [
                {Header:"기부금코드",                Type:"Text",    Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"contribution_cd",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"기부금종류",                Type:"Text",    Hidden:0,   Width:130,  Align:"Center", ColMerge:0, SaveName:"contribution_nm",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"기부연도",             Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"donation_yy",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"기부금액(A)",              Type:"Int",     Hidden:0,   Width:100,  Align:"Right",  ColMerge:0, SaveName:"donation_mon",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"전년까지 \n 공제된금액(B)", Type:"Int",     Hidden:0,   Width:100,  Align:"Right",  ColMerge:0, SaveName:"prev_ded_mon",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"공제대상금액(A-B)",      Type:"Int",     Hidden:0,   Width:100,  Align:"Right",  ColMerge:0, SaveName:"ded_mon_obj",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"해당연도공제금액",         Type:"Int",     Hidden:0,   Width:100,  Align:"Right",  ColMerge:0, SaveName:"ded_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"소멸금액",             Type:"Int",     Hidden:0,   Width:100,  Align:"Right",  ColMerge:0, SaveName:"extinction_mon",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"이월금액",             Type:"Int",     Hidden:0,   Width:100,  Align:"Right",  ColMerge:0, SaveName:"carried_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 }
            ]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable(false);sheet4.SetVisible(true);sheet4.SetCountPosition(4);

            var initdata6 = {};
            initdata6.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
            initdata6.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
            initdata6.Cols = [
                {Header:"납부정보|납부연도",		Type:"Text", 	Hidden:0, 	Width:50, 	Align:"Center", 	ColMerge:0, 	SaveName:"pay_yy", 			KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"납부정보|국가",		Type:"Text", 	Hidden:0, 	Width:80, 	Align:"Center", 	ColMerge:0, 	SaveName:"national_nm", 	KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"납부정보|국외원천소득",  Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"base_mon", 		KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"납부정보|외납세액",	    Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"pay_tax_mon", 	KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"세액공제|전기이월",		Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"prev_carried_mon",KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"세액공제|공제대상액",	Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"cur_ded_mon", 	KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"세액공제|실공제액",		Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"ded_mon", 		KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"세액공제|공제한도",		Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"limit_mon", 		KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"이월배제|한도초과",		Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"limit_ov_mon", 	KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"이월배제|배제확정",		Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"no_carried_mon", 	KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"소멸금액|소멸금액",		Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"extinction_mon", 	KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"이월금액|한도초과분",	Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"carried_mon", 	KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 },
                {Header:"이월금액|미공제분",	    Type:"Int", 	Hidden:0, 	Width:80, 	Align:"Right", 		ColMerge:0, 	SaveName:"carried_mon_841", KeyField:0, 	Format:"", 	PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, EditLen:500 }
            ]; IBS_InitSheet(sheet6, initdata6);sheet6.SetEditable(false);sheet6.SetVisible(true);sheet6.SetCountPosition(4);


            //관리자일 경우
            if(orgAuthPg == "A") {
                     yeaResultSht3.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes3List", $("#yeaResultShtForm").serialize() );
                     yeaResultSht2.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes2List871", $("#yeaResultShtForm").serialize() );
                     yeaResultSht5.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes5List873", $("#yeaResultShtForm").serialize() );
            //아닐경우
            }else{
                //true: 모의계산 조회 활성, false: 모의계산 조회 비활성
                if(yeaDefault == true){
                     yeaResultSht3.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes3List", $("#yeaResultShtForm").serialize() );
                     yeaResultSht2.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes2List871", $("#yeaResultShtForm").serialize() );
                     yeaResultSht5.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes5List873", $("#yeaResultShtForm").serialize() );
                }else{
                    alert("연말정산 작업이 마감되었습니다.");
                }
            }
            //getAgeChk();    //연금계좌 50세이상 유무 조회
            //getFrgTaxChk(); //외국인단일세율적용 조회
    });


    /**
     * 연말정산계산결과 시트를 각 항목에 입력 temp : TCPN871
     */
    function sht2ToCtl(){
        if(yeaResultSht2.RowCount() > 0){
            $("#sht2_CurrPayMon").val(          yeaResultSht2.GetCellText(1, "curr_pay_mon"));//현근무지급여
            $("#sht2_CurrBonusMon").val(        yeaResultSht2.GetCellText(1, "curr_bonus_mon"));//현근무지상여
            $("#sht2_CurrEtcBonusMon").val(     yeaResultSht2.GetCellText(1, "curr_etc_bonus_mon"));//현근무지인정상여
            $("#sht2_CurrStockBuyMon").val(     yeaResultSht2.GetCellText(1, "curr_stock_buy_mon"));//현근무지주식매수선택권행사이익
            $("#sht2_CurrStockSnionMon").val(   yeaResultSht2.GetCellText(1, "curr_stock_union_mon"));//현근무지우리사주조합인출금
            $("#sht2_CurrImwonRetOverMon").val( yeaResultSht2.GetCellText(1, "curr_imwon_ret_over_mon")) ;//현근무지임원퇴직소득금액한도초과액
            $("#sht2_CurrJobInvtOvrMon").val( yeaResultSht2.GetCellText(1, "curr_job_invt_ovr_mon")) ;//현근무지직무발명보상금한도초과액
			$("#sht2_CurrTotMon").val(          yeaResultSht2.GetCellText(1, "curr_tot_mon")) ;//현근무지소득계
            $("#sht2_PrePayMon").val(           yeaResultSht2.GetCellText(1, "pre_pay_mon")) ;//종전근무지급여
            $("#sht2_PreBonusMon").val(         yeaResultSht2.GetCellText(1, "pre_bonus_mon"));//종전근무지상여
            $("#sht2_PreEtcBonusMon").val(      yeaResultSht2.GetCellText(1, "pre_etc_bonus_mon")) ;//종전근무지인정상여
            $("#sht2_PreStockBuyMon").val(      yeaResultSht2.GetCellText(1, "pre_stock_buy_mon")) ;//종전근무지주식매수선택권행사이익
            $("#sht2_PreStockSnionMon").val(    yeaResultSht2.GetCellText(1, "pre_stock_union_mon")) ;//종전근무지우리사주조합인출금
            $("#sht2_PreImwonRetOverMon").val( yeaResultSht2.GetCellText(1, "pre_imwon_ret_over_mon")) ;//종전근무지임원퇴직소득금액한도초과액
            $("#sht2_PreJobInvtOvrMon").val( yeaResultSht2.GetCellText(1, "pre_job_invt_ovr_mon")) ;//종전직무발명보상금한도초과액
			$("#sht2_PreTotMon").val(           yeaResultSht2.GetCellText(1, "pre_tot_mon")) ;//종전근무지소득계
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_pay_mon")+yeaResultSht2.GetCellValue(1, "pre_pay_mon") ) ;
            $("#sumPayMon").val(            yeaResultSht2.GetCellText(1, "temp"));
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_bonus_mon")+yeaResultSht2.GetCellValue(1, "pre_bonus_mon") ) ;
            $("#sumBonusMon").val(          yeaResultSht2.GetCellText(1, "temp"));
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_etc_bonus_mon")+yeaResultSht2.GetCellValue(1, "pre_etc_bonus_mon") ) ;
            $("#sumEtcBonusMon").val(       yeaResultSht2.GetCellText(1, "temp"));
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_stock_buy_mon")+yeaResultSht2.GetCellValue(1, "pre_stock_buy_mon") ) ;
            $("#sumStockBuyMon").val(       yeaResultSht2.GetCellText(1, "temp"));
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_stock_union_mon")+yeaResultSht2.GetCellValue(1, "pre_stock_union_mon") ) ;
            $("#sumStockSnionMon").val(     yeaResultSht2.GetCellText(1, "temp"));
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_imwon_ret_over_mon")+yeaResultSht2.GetCellValue(1, "pre_imwon_ret_over_mon") ) ;
            $("#sumImwonRetOverMon").val( yeaResultSht2.GetCellText(1, "temp"));
            yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_job_invt_ovr_mon")+yeaResultSht2.GetCellValue(1, "pre_job_invt_ovr_mon") ) ;
			$("#sumJobInvtOvrMon").val( yeaResultSht2.GetCellText(1, "temp"));
			yeaResultSht2.SetCellValue(1, "temp", yeaResultSht2.GetCellValue(1, "curr_tot_mon")+yeaResultSht2.GetCellValue(1, "pre_tot_mon") ) ;
            $("#sumTotMon").val(            yeaResultSht2.GetCellText(1, "temp"));
            $("#sumPayMon").val(        $("#sumPayMon").val()       );
            $("#sumBonusMon").val(      $("#sumBonusMon").val()     );
            $("#sumEtcBonusMon").val(   $("#sumEtcBonusMon").val()  );
            $("#sumStockBuyMon").val(   $("#sumStockBuyMon").val()  );
            $("#sumStockSnionMon").val( $("#sumStockSnionMon").val());
            $("#sumTotMon").val(        $("#sumTotMon").val()       );
            $("#sht2_CurrNotaxAbroadMon").val(      yeaResultSht2.GetCellText(1, "curr_notax_abroad_mon"));//현근무지국외근로비과세
            $("#sht2_CurrNotaxFoodMon").val(      	yeaResultSht2.GetCellText(1, "curr_notax_food_mon"));//현근무지식대비과세
            $("#sht2_CurrNotaxWorkMon").val(        yeaResultSht2.GetCellText(1, "curr_notax_work_mon"));//현근무지야간근로수당비과세
            $("#sht2_CurrNotaxBabyMon").val(        yeaResultSht2.GetCellText(1, "curr_notax_baby_mon"));//현근무지보육비과세
            $("#sht2_CurrNotaxBirthMon").val(        yeaResultSht2.GetCellText(1, "curr_notax_child_birth_mon"));//현근무지출산지원금과세
            $("#sht2_CurrNotaxFornMon").val(        yeaResultSht2.GetCellText(1, "curr_notax_forn_mon"));//현근무지외국인근로자비과세
            $("#sht2_CurrNotaxResMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_research_mon"));//현근무지연구보조비비과세
            $("#sht2_CurrNotaxEtcMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_etc_mon"));//현근무지기타비과세
            $("#sht2_CurrNotaxJobInvtMon").val(     yeaResultSht2.GetCellText(1, "curr_notax_job_invt_mon"));//현근무지직무발명보상금비과세
            $("#sht2_CurrNotaxRptMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_rpt_mon"));//현근무지취재수당비과세
	        $("#sht2_CurrNotaxExtMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_ext_mon"));//현근무지그외비과세
            $("#sht2_CurrNotaxTotMon").val(         yeaResultSht2.GetCellText(1, "curr_notax_tot_mon"));//현근무지비과세계
            $("#sht2_PreNotaxAbroadMon").val(       yeaResultSht2.GetCellText(1, "pre_notax_abroad_mon"));//종전근무지국외근로비과세
            $("#sht2_PreNotaxFoodMon").val(      	yeaResultSht2.GetCellText(1, "pre_notax_food_mon"));//종전근무지식대비과세
            $("#sht2_PreNotaxWorkMon").val(         yeaResultSht2.GetCellText(1, "pre_notax_work_mon"));//종전근무지야간근로수당비과세
            $("#sht2_PreNotaxBabyMon").val(         yeaResultSht2.GetCellText(1, "pre_notax_baby_mon"));//종전근무지보육비과세
            $("#sht2_PreNotaxBirthMon").val(        yeaResultSht2.GetCellText(1, "pre_notax_child_birth_mon"));//종전근무지출산지원금과세
            $("#sht2_PreNotaxFornMon").val(         yeaResultSht2.GetCellText(1, "pre_notax_forn_mon"));//종전근무지외국인근로자비과세
            $("#sht2_PreNotaxResMon").val(          yeaResultSht2.GetCellText(1, "pre_notax_research_mon"));//종전근무지연구보조비비과세
            $("#sht2_PreNotaxEtcMon").val(          yeaResultSht2.GetCellText(1, "pre_notax_etc_mon"));//종전근무지기타비과세
            $("#sht2_PreNotaxJobInvtMon").val(      yeaResultSht2.GetCellText(1, "pre_notax_job_invt_mon"));//종전근무지직무발명보상금비과세	        
            $("#sht2_PreNotaxRptMon").val(          yeaResultSht2.GetCellText(1, "pre_notax_rpt_mon"));//종전근무지취재수당비과세
	        $("#sht2_PreNotaxExtMon").val(          yeaResultSht2.GetCellText(1, "pre_notax_ext_mon"));//종전근무지그외비과세
            $("#sht2_PreNotaxTotMon").val(          yeaResultSht2.GetCellText(1, "pre_notax_tot_mon"));//종전근무지비과세계
            $("#sht2_NotaxTotMon").val(     yeaResultSht2.GetCellText(1, "notax_tot_mon"));//비과세계
            $("#sht2_TaxablePayMon").val(   yeaResultSht2.GetCellText(1, "taxable_pay_mon"));//과세대상급여총액
            $("#sht2_IncomeMon").val(       yeaResultSht2.GetCellText(1, "income_mon"));//근로소득금액
            $("#sht2_TaxBaseMon").val(      yeaResultSht2.GetCellText(1, "tax_base_mon")) ;//과세표준액
            $("#sht2_ClclteTaxMon").val(    yeaResultSht2.GetCellText(1, "clclte_tax_mon"));//산출세액
            $("#sht2_BlnceIncomeMon").val(  yeaResultSht2.GetCellText(1, "blnce_income_mon")) ;//차감소득금액
            $("#sht2_TotTaxDeductMon").val( yeaResultSht2.GetCellText(1, "tot_tax_deduct_mon"));//세액공제액
            $("#sht2_FinIncomeTax").val(    yeaResultSht2.GetCellText(1, "fin_income_tax"));//결정소액(소득세)
            $("#sht2_FinIncomeTax2").val(   yeaResultSht2.GetCellText(1, "fin_income_tax"));//결정소액(소득세)
            $("#sht2_FinInbitTaxMon").val(  yeaResultSht2.GetCellText(1, "fin_inbit_tax_mon"));//결정세액(주민세)
            $("#sht2_FinAgrclTaxMon").val(  yeaResultSht2.GetCellText(1, "fin_agrcl_tax_mon"));//결정세액(농어촌특별세)
            $("#sht2_FinSum").val(          yeaResultSht2.GetCellText(1, "fin_tot_tax_mon"));//결정세액계
            $("#sht2_PreIncomeTax").val(    yeaResultSht2.GetCellText(1, "pre_income_tax_mon")) ;//종(전)근무지(소득세)
            $("#sht2_PreInbitTaxMon").val(  yeaResultSht2.GetCellText(1, "pre_inbit_tax_mon"));//종(전)근무지(주민세)
            $("#sht2_PreAgrclTaxMon").val(  yeaResultSht2.GetCellText(1, "pre_agrcl_tax_mon"));//종(전)근무지(농어촌특별세)
            $("#sht2_PreSum").val(          yeaResultSht2.GetCellText(1, "pre_tot_tax_mon"));//종(전)근무지계
            $("#sht2_CurrIncomeTax").val(   yeaResultSht2.GetCellText(1, "curr_income_tax_mon")) ;//주(현)근무지(소득세)
            $("#sht2_CurrInbitTaxMon").val( yeaResultSht2.GetCellText(1, "curr_inbit_tax_mon"));//주(현)근무지(주민세)
            $("#sht2_CurrAgrclTaxMon").val( yeaResultSht2.GetCellText(1, "curr_agrcl_tax_mon"));//주(현)근무지(농어촌특별세)
            $("#sht2_CurrSum").val(         yeaResultSht2.GetCellText(1, "curr_tot_tax_mon"));//주(현)근무지계
            $("#sht2_BlcIncomeTax").val(    yeaResultSht2.GetCellText(1, "blc_income_tax_mon")) ;//차감징수세액(소득세)
            $("#sht2_BlcInbitTaxMon").val(  yeaResultSht2.GetCellText(1, "blc_inbit_tax_mon"));//차감징수세액(주민세)
            $("#sht2_BlcAgrclTaxMon").val(  yeaResultSht2.GetCellText(1, "blc_agrcl_tax_mon"));//차감징수세액(농어촌특별세)
            $("#sht2_BlcSum").val(          yeaResultSht2.GetCellText(1, "blc_tot_tax_mon"));//차감징수세액계
            $("#sht2_LIMIT_OVER_MON").val( yeaResultSht2.GetCellText(1,"limit_over_mon"));//특별공제 종합한도 초과액

            $("#sht2_SpcIncomeTaxMon").val( yeaResultSht2.GetCellText(1, "spc_income_tax_mon"));//납부특례세액(소득세)
            $("#sht2_SpcInbitTaxMon").val( yeaResultSht2.GetCellText(1, "spc_inbit_tax_mon"));//납부특례세액(주민세)
            $("#sht2_SpcAgrclTaxMon").val( yeaResultSht2.GetCellText(1, "spc_agrcl_tax_mon"));//납부특례세액(농어촌특별세)
            $("#sht2_SpcSum").val(yeaResultSht2.GetCellText(1, "spc_tot_tax_mon"));//납부특례세액계
            $("#sht2_EffTaxRate").val(yeaResultSht2.GetCellText(1, "eff_tax_rate"));//실효세율
        } else{

            $("#sht2_CurrPayMon").val(           "0");//현근무지급여
            $("#sht2_CurrBonusMon").val(         "0");//현근무지상여
            $("#sht2_CurrEtcBonusMon").val(      "0");//현근무지인정상여
            $("#sht2_CurrStockBuyMon").val(      "0");//현근무지주식매수선택권행사이익
            $("#sht2_CurrStockSnionMon").val(    "0");//현근무지우리사주조합인출금
            $("#sht2_CurrImwonRetOverMon").val("0");//현근무지임원퇴직소득금액한도초과액
            $("#sht2_CurrJobInvtOvrMon").val("0");//현근무지직무발명보상금한도초과액			
			$("#sht2_CurrTotMon").val(           "0");//현근무지소득계
            $("#sht2_PrePayMon").val(            "0");//종전근무지급여
            $("#sht2_PreBonusMon").val(          "0");//종전근무지상여
            $("#sht2_PreEtcBonusMon").val(       "0");//종전근무지인정상여
            $("#sht2_PreStockBuyMon").val(       "");//종전근무지주식매수선택권행사이익
            $("#sht2_PreStockSnionMon").val(     "0");//종전근무지우리사주조합인출금
            $("#sht2_PreImwonRetOverMon").val("0");//종전근무지임원퇴직소득금액한도초과액
            $("#sht2_PreJobInvtOvrMon").val("0");//종전근무지직무발명보상금한도초과액			
			$("#sht2_PreTotMon").val(            "0");//종전근무지소득계
            $("#sumPayMon").val(                 "0");
            $("#sumBonusMon").val(               "0");
            $("#sumEtcBonusMon").val(            "0");
            $("#sumImwonRetOverMon").val("0");
            $("#sumJobInvtOvrMon").val("0");
			$("#sumTotMon").val(                 "0");
            $("#sht2_PreNotaxAbroadMon").val(        "0");//종전근무지국외근로비과세
            $("#sht2_PreNotaxFoodMon").val(        	 "0");//종전근무지식대비과세
            $("#sht2_PreNotaxWorkMon").val(          "0");//종전근무지야간근로수당비과세
            $("#sht2_PreNotaxEtcMon").val(           "0");//종전근무지기타비과세
            $("#sht2_PreNotaxJobInvtMon").val(       "0");//종전근무지직무발명보상금비과세
			$("#sht2_PreNotaxRptMon").val(           "0");//종전근무지취재수당비과세
	        $("#sht2_PreNotaxExtMon").val(           "0");//종전근무지그외비과세
            $("#sht2_PreNotaxResMon").val(           "0");//종전근무지연구보조비비과세
            $("#sht2_PreNotaxFornMon").val(          "0");//종전근무지외국인근로자비과세
            $("#sht2_PreNotaxBabyMon").val(          "0");//종전근무지보육비과세
            $("#sht2_PreNotaxBirthMon").val(        "0");//종전근무지출산지원금과세
            $("#sht2_PreNotaxTotMon").val(           "0");//종전근무지비과세계
            $("#sht2_CurrNotaxAbroadMon").val(       "0");//현근무지국외근로비과세
            $("#sht2_CurrNotaxFoodMon").val(         "0");//현근무지식대비과세
            $("#sht2_CurrNotaxWorkMon").val(         "0");//현근무지야간근로수당비과세
            $("#sht2_CurrNotaxEtcMon").val(          "0");//현근무지기타비과세
            $("#sht2_CurrNotaxJobInvtMon").val(      "0");//현근무지직무발명보상금비과세
	        $("#sht2_CurrNotaxRptMon").val(          "0");//현근무지취재수당비과세
	        $("#sht2_CurrNotaxExtMon").val(          "0");//현근무지그외비과세
            $("#sht2_CurrNotaxResMon").val(          "0");//현근무지연구보조비비과세
            $("#sht2_CurrNotaxFornMon").val(         "0");//현근무지외국인근로자비과세
            $("#sht2_CurrNotaxBabyMon").val(         "0");//현근무지보육비과세
            $("#sht2_CurrNotaxBirthMon").val(        "0");//현근무지출산지원금과세
            $("#sht2_CurrNotaxTotMon").val(          "0");//현근무지비과세계

            //급여총액  현근무지급여총액+전근무지급여총액+기타급여

            $("#sht2_NotaxTotMon").val(      "0");//비과세계
            $("#sht2_TaxablePayMon").val(    "0");//과세대상급여총액
            $("#sht2_IncomeMon").val(        "0");//근로소득금액
            $("#sht2_TaxBaseMon").val(       "0") ;//과세표준액
            $("#sht2_ClclteTaxMon").val(     "0");//산출세액
            $("#sht2_BlnceIncomeMon").val(   "0");//차감소득금액
            $("#sht2_TotTaxDeductMon").val(  "0");//세액공제액
            $("#sht2_FinIncomeTax").val(     "0");//결정소액(소득세)
            $("#sht2_FinIncomeTax2").val(    "0");//결정소액(소득세)
            $("#sht2_FinInbitTaxMon").val(   "0");//결정세액(주민세)
            $("#sht2_FinAgrclTaxMon").val(   "0");//결정세액(농어촌특별세)
            $("#sht2_FinSum").val(           "0");//결정세액계
            $("#sht2_PreIncomeTax").val(     "0") ;//종(전)근무지(소득세)
            $("#sht2_PreInbitTaxMon").val(   "0");//종(전)근무지(주민세)
            $("#sht2_PreAgrclTaxMon").val(   "0");//종(전)근무지(농어촌특별세)
            $("#sht2_PreSum").val(           "0");//종(전)근무지계
            $("#sht2_CurrIncomeTax").val(    "0") ;//주(현)근무지(소득세)
            $("#sht2_CurrInbitTaxMon").val(  "0");//주(현)근무지(주민세)
            $("#sht2_CurrAgrclTaxMon").val(  "0");//주(현)근무지(농어촌특별세)
            $("#sht2_CurrSum").val(          "0");//주(현)근무지계
            $("#sht2_BlcIncomeTax").val(     "0") ;//차감징수세액(소득세)
            $("#sht2_BlcInbitTaxMon").val(   "0");//차감징수세액(주민세)
            $("#sht2_BlcAgrclTaxMon").val(   "0");//차감징수세액(농어촌특별세)
            $("#sht2_BlcSum").val(           "0");//차감징수세액계
            $("#sht2_LIMIT_OVER_MON").val( "0");//특별공제 종합한도 초과액

            $("#sht2_SpcIncomeTaxMon").val("0");//납부특례세액(소득세)
            $("#sht2_SpcInbitTaxMon").val("0");//납부특례세액(주민세)
            $("#sht2_SpcAgrclTaxMon").val("0");//납부특례세액(농어촌특별세)
            $("#sht2_SpcSum").val("0");//납부특례세액계
            $("#sht2_EffTaxRate").val("0");//실효세율
        }
    }


    /**
     * 연말정산계산결과 상세시트를 각 항목에 입력 temp : TCPN873
     */

     function sht5ToCtl(){
        if(yeaResultSht5.RowCount() > 0){
            if(yeaResultSht5.RowCount() > 0){
                for(var i = 0 ; i < $("input").length; i++) {
                    if(($("input")[i].id).indexOf("sht5") > -1) {
                        var shtValueName = (($("input")[i].id).toLowerCase()).replace("sht5_","");
                        $("#"+$("input")[i].id).val( yeaResultSht5.GetCellText(1, shtValueName) );
                    }
                }
            }
        }else{
            for(var i = 0 ; i < $("input").length; i++) {
                if(($("input")[i].id).indexOf("sht5") > -1) {
                    var shtValueName = (($("input")[i].id).toLowerCase()).replace("sht5_","");
                    $("#"+$("input")[i].id).val( "0" );
                }
            }
        }
    }

    //조회 후 에러 메시지
    function yeaResultSht2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                sht2ToCtl();

                //마감체크하여 마감되었으면 권한을 R로 넘겨서 수정 못하게 막음
                var authPg = (getYeaCloseYn()=="Y")?"R":"A";
                <%
                //회사코드가 서흥,젤텍 이면 적용
                if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
                %>
                        //$("#sheetCalc").show();
                <%} else {%>
                    if(authPg == "R" ){
                        $("#sheetCalc").hide();
                    } else {
                        $("#sheetCalc").show();
                    }
                <%}%>
            }
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    //조회 후 에러 메시지
    function yeaResultSht5_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                sht5ToCtl();
                // 표준세액공제
                if(yeaResultSht5.GetCellValue(1, "a099_01") <= 0 || yeaResultSht5.GetCellValue(1, "a099_01") == null){
                    $("#sht5_A099_01_font").hide();
                }else{
                    $("#sht5_A099_01_font").show();
                    alert("표준세액공제가 적용되어 보험료, 의료비, 교육비, 기부금 등\n특별세액공제 계산되지 않습니다.");
                    return;
                }
                getFrgTaxChk();
            }
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    //마감정보 조회
    function getYeaCloseYn() {
        var closeYn = "N";
        var yeaCloseInfo = getYearDefaultInfoObj();

        $("#spanMagam").hide();
        $("#spanMagamCancel").hide();

        if(yeaCloseInfo.Result.Code == 1) {
            if(typeof yeaCloseInfo.Data.sabun == "undefined") {
                closeYn = "Y";
                $("#tdStatusView").html("<font size=2><b>[<font class='red'>대상자가 아닙니다.</font>]</b></font>");
            } else if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"|| yeaCloseInfo.Data.input_close_yn == "Y") {
                closeYn = "Y";
                if(yeaCloseInfo.Data.final_close_yn == "Y"){
                    $("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>최종마감</font> 상태입니다.]</b></font>");
                } else if(yeaCloseInfo.Data.apprv_yn == "Y"){
                    $("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>담당자마감</font> 상태입니다.]</b></font>");
                } else if(yeaCloseInfo.Data.input_close_yn == "Y"){
                    $("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>본인마감</font> 상태입니다.]</b></font>");
                    $("#spanMagamCancel").show();
                }
            } else {
                closeYn = "N";
                $("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>본인 마감전</font> 상태입니다.]</b></font>");
                    $("#spanMagam").show();
            }
        }
        return closeYn;
    }

    function IncomeCalc(){
        parent.fnIncomeCalc();
    }


    function TaxCalcCheck(){
        if(waitFlag) return;

        var yeaDefaultInfo = getYearDefaultInfoObj();

        if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
            alert("대상자가 아닙니다.");
            return;
        }
        if(yeaDefaultInfo.Data.apprv_yn == "Y") {
            alert('담당자마감된 자료는 모의계산을 할 수 없습니다.');
            return;
        }
        if(yeaDefaultInfo.Data.final_close_yn == "Y") {
            alert('최종마감된 자료는 모의계산을 할 수 없습니다.');
            return;
        }

        // 1. 입력마감 2. 담당자확인

        var statusFlag = false;
        var calcFlag = true;

        /* if(yeaDefaultInfo.Data.apprv_yn == "Y") {
            if(!confirm("담당자확인된 자료는 계산된 결과값이 다를 수 있습니다.")){
                return;
            } else {
                statusFlag = true;
            }
        } */

        if(yeaDefaultInfo.Data.input_close_yn == "Y" && !statusFlag) {
            if(!confirm('입력마감된 자료는 담당자가 서류검토를 진행하여 데이터를 조정할 수 있어 계산된 결과값이 다를 수 있습니다.')){
                return;
            } else {
                statusFlag = true;
            }
        }

        if(!statusFlag) {
            if(confirm("현재까지 입력하신 공제자료를 기준으로 계산됩니다.\n계산 된 금액은 확정 금액이 아님을 다시 한번 더 알려드립니다. \n\n[ 모의계산 ]을 진행하시겠습니까?")) {
                calcFlag = true;
            } else {
                calcFlag = false;
            }
        }

        if(calcFlag) {

            var param = "searchPayActionCd="+yeaDefaultInfo.Data.pay_action_cd
            param += "&searchWorkYy="+yeaDefaultInfo.Data.work_yy
            param += "&searchAdjustType="+yeaDefaultInfo.Data.adjust_type
            param += "&searchSabun="+yeaDefaultInfo.Data.sabun;

            var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=prcYeaCalc",param,true
                    ,function(){
                        waitFlag = true;
                        $("#progressCover").show();
                    }
                    ,function(){
                        waitFlag = false;
                        $("#progressCover").hide();
                        goSearch();
                    }
            );

        }
    }

    function goSearch() {
        yeaResultSht3.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes3List", $("#yeaResultShtForm").serialize() );
        yeaResultSht2.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes2List871", $("#yeaResultShtForm").serialize() );
        yeaResultSht5.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectRes5List873", $("#yeaResultShtForm").serialize() );
    }

    //기본정보 조회
    function getYearDefaultInfoObj() {
        /*Tab별로 카운트 표시
        tabs-1 : 주소사항
        tabs-2 : 인적공제
        tabs-3 : PDF등록
        tabs-4 : 연 금
        tabs-5 : 보험료
        tabs-6 : 주택자금1
        tabs-7 : 주택자금2
        tabs-8 : 저축
        tabs-9 : 카드등
        tabs-10 : 기타공제
        tabs-11 : 의료비
        tabs-12 : 교육비
        tabs-13 : 기부금
        tabs-14 : 세액감면/기타세액공제*/

        var param = "searchWorkYy="+$("#searchWorkYy").val() + "&searchAdjustType="+$("#searchAdjustType").val() + "&searchSabun="+$("#searchSabun").val() ;
        var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectTabCnt", param,false);
        if(result.Result.Code == 1) {

            if(result.Data.cnt2 > 0) result.Data.cnt2 = "<font class='red'>"+result.Data.cnt2+"</font>";
            if(result.Data.cnt3 > 0) result.Data.cnt3 = "<font class='red'>"+result.Data.cnt3+"</font>";
            if(result.Data.cnt4 > 0) result.Data.cnt4 = "<font class='red'>"+result.Data.cnt4+"</font>";
            if(result.Data.cnt5 > 0) result.Data.cnt5 = "<font class='red'>"+result.Data.cnt5+"</font>";
            if(result.Data.cnt6 > 0) result.Data.cnt6 = "<font class='red'>"+result.Data.cnt6+"</font>";
            if(result.Data.cnt7 > 0) result.Data.cnt7 = "<font class='red'>"+result.Data.cnt7+"</font>";
            if(result.Data.cnt8 > 0) result.Data.cnt8 = "<font class='red'>"+result.Data.cnt8+"</font>";
            if(result.Data.cnt9 > 0) result.Data.cnt9 = "<font class='red'>"+result.Data.cnt9+"</font>";
            if(result.Data.cnt10> 0) result.Data.cnt10 = "<font class='red'>"+result.Data.cnt10+"</font>";
            if(result.Data.cnt11> 0) result.Data.cnt11 = "<font class='red'>"+result.Data.cnt11+"</font>";
            if(result.Data.cnt12> 0) result.Data.cnt12 = "<font class='red'>"+result.Data.cnt12+"</font>";
            if(result.Data.cnt13> 0) result.Data.cnt13 = "<font class='red'>"+result.Data.cnt13+"</font>";
            if(result.Data.cnt14> 0) result.Data.cnt14 = "<font class='red'>"+result.Data.cnt14+"</font>";
            if(result.Data.cnt16> 0) result.Data.cnt16 = "<font class='red'>"+result.Data.cnt16+"</font>";

            //$("#tabs1").html("주소사항("+result.Data.cnt1+")");
            $("#tabs2").html("인적공제("+result.Data.cnt2+")");
            $("#tabs3").html("PDF등록("+result.Data.cnt3+")");
            $("#tabs4").html("보험료("+result.Data.cnt5+")");
            $("#tabs5").html("주택자금("+result.Data.cnt6+")");
            $("#tabs6").html("주택자금2("+result.Data.cnt7+")");
            $("#tabs7").html("저축("+result.Data.cnt8+")");
            $("#tabs8").html("신용카드("+result.Data.cnt9+")");
            $("#tabs9").html("기타소득공제("+result.Data.cnt10+")");
            $("#tabs10").html("연금계좌("+result.Data.cnt4+")");
            $("#tabs11").html("의료비("+result.Data.cnt11+")");
            $("#tabs12").html("교육비("+result.Data.cnt12+")");
            $("#tabs13").html("기부금("+result.Data.cnt13+")");
            $("#tabs14").html("세액감면/기타세액공제("+result.Data.cnt14+")");
            $("#tabs16").html("종전근무지("+result.Data.cnt16+")");

            $("#inputStatus").val(result.Data.input_status);
        }
        return ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectYeaDataDefaultInfo", $("#yeaResultShtForm").serialize(),false);
    }

    // Tooltip 메세지 호출부
    $(function() {

        setTooltip_yjungsan("tooltip_1", "<b>test tooltip 입니다.111</b> test tooltip 입니다. test tooltip 입니다. test tooltip 입니다. test tooltip 입니다."
                +"test tooltip 입니다. test tooltip 입니다. test tooltip 입니다."
                +"<br/><font class='red'>테스트 툴팁1 입니다.</font>");

        setTooltip_yjungsan("tooltip_2", "<u>test tooltip 입니다.222</u> test tooltip 입니다. test tooltip 입니다. test tooltip 입니다. test tooltip 입니다."
                +"test tooltip 입니다. test tooltip 입니다. test tooltip 입니다."
                +"<br/><font class='blue'>테스트 툴팁2 입니다.</font>");
    });

	/* function f_ageChkYn($this) {
		if($this.prop("checked")) {
			alert("대상자에 해당하면 연금계좌 탭에서\n50세이상 체크박스를 확인 해주세요.");
		}
		else {
			alert("대상자에 해당하지 않으면 연금계좌 탭에서\n50세이상 체크박스를 확인 해주세요.");
		}
		return;
	} */

</script>
</head>
<body class="bodywrap">

<div id="don_detail_pop" class="ui-widget-content" style="display:none">
    <form id="sheetFormPop" name="sheetFormPop" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="sheet_title">
                    <ul>
                        <li class="txt">■ 기부금 상세내역
                        </li>
                        <li class="btn">
                            <a href="javascript:searchData();" class="basic">조회</a>
                            <a href="javascript:hidePopup();" class="basic">닫기</a>
                        </li>
                    </ul>
                </div>
                <span id="donDetailSheet">
                    <script type="text/javascript">createIBSheet("sheet4", "800px", "200px"); </script>
                </span>
            </td>
        </tr>
    </table>
    </form>
</div>

<div id="foreign_pay_detail_pop" class="ui-widget-content" style="display:none">
    <form id="foreignSheetFormPop" name="foreignSheetFormPop" >
        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
            <tr>
                <td>
                    <div class="sheet_title">
                        <ul>
                            <li class="txt">■ 외국납부 상세내역
                            </li>
                            <li class="btn">
                                <a href="javascript:searchForeignPayData();" class="basic">조회</a>
                                <a href="javascript:hideForeignPayPopup();" class="basic">닫기</a>
                            </li>
                        </ul>
                    </div>
                    <span id="foreignPayDetailSheet">
					<script type="text/javascript">createIBSheet("sheet6", "800px", "200px"); </script>
				</span>
                </td>
            </tr>
        </table>
    </form>
</div>

<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%; z-index:99;"></div>
<div class="wrapper" style="overflow:scroll;">
    <form id="yeaResultShtForm" name="yeaResultShtForm" >
        <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
        <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
        <input type="hidden" id="searchSabun" name="searchSabun" value="" />
        <input type="hidden" id="searchGubun" name="searchGubun" value="1" />
        <input type="hidden" id="searchReCalcSeq" name="searchReCalcSeq" value="" />
        <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />

        <input type="hidden" id="searchRegNo" name="searchRegNo" value="" />
        <input type="hidden" id="inputStatus" name="inputStatus" value="" />
        <input type="hidden" id="searchAuthPg" name="searchAuthPg" value="" />
        <input type="hidden" id="searchTemp" name="searchTemp" value="" />
<%
    //회사코드가 서흥,젤텍 이면 적용
    if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
%>
    <div class="outer">
        <div class="sheet_title">
            <ul>
                <li class="txt" id="sheetCalcLi">[소득명세]</li>
                <li style="float: left; line-height: 35px; display:none;" id="displayYn1" name="displayYn1">
						&nbsp;외국인단일세율 적용일 경우, "급여"액에 미신고 비과세액이 포함됩니다.
				</li>
                <li class="btn">
                <%if("A".equals(request.getParameter("orgAuthPg") ) ) {%>
                    <font class='blue'>해당 화면은 모의계산이며 실제 계산은 담당자가 [연말정산계산] 화면에서 세금계산 작업 해야합니다.</font>
                <%}else{%>
                    <font class='blue'>과세대상급여액의 차이 등으로 원천징수의무자(회사)가 실제로 연말정산한 금액과 차이가 발생할 수 있습니다.</font>
                <%}%>
                    <a href="javascript:TaxCalcCheck();" class="basic btn-red ico-calc" id="sheetCalc"><b>세금모의계산</b></a>
                    <!-- <a href="javascript:IncomeCalc();" class="basic btn-white out-line">소득공제서</a> -->
                </li>
            </ul>
        </div>
    </div>

    <table border="0" cellpadding="0" cellspacing="0" class="default line inner">
    <colgroup>
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
	    <col width="11%" />
        <col width="12%" />
    </colgroup>
    <tr>
        <th class="center">구분</th>
        <th class="center">급여</th>
        <th class="center">상여</th>
        <th class="center">인정상여</th>
        <th class="center">주식매수선택권<br>행사이익</th>
        <th class="center">우리사주<br>조합인출금</th>
        <th class="center">임원퇴직소득금액<br>한도초과액</th>
		<th class="center">직무발명보상금<br>한도초과액</th>
        <th class="center">계</th>
    </tr>
    <tr>
        <th class="right">주(현)</th>
        <td class="right">
            <input id="sht2_CurrPayMon" name="sht2_CurrPayMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrBonusMon" name="sht2_CurrBonusMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrEtcBonusMon" name="sht2_CurrEtcBonusMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrStockBuyMon" name="sht2_CurrStockBuyMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrStockSnionMon" name="sht2_CurrStockSnionMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
                <input id="sht2_CurrImwonRetOverMon" name="sht2_CurrImwonRetOverMon" type="text" class="text w100p right" readOnly />
            </td>
        <td class="right">
				<input id="sht2_CurrJobInvtOvrMon" name="sht2_CurrJobInvtOvrMon" type="text" class="text w100p right" readOnly />
			</td>
		<td class="right">
            <input id="sht2_CurrTotMon" name="sht2_CurrTotMon" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right">종(전)</th>
        <td class="right">
            <input id="sht2_PrePayMon" name="sht2_PrePayMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreBonusMon" name="sht2_PreBonusMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreEtcBonusMon" name="sht2_PreEtcBonusMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreStockBuyMon" name="sht2_PreStockBuyMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreStockSnionMon" name="sht2_PreStockSnionMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
                <input id="sht2_PreImwonRetOverMon" name="sht2_PreImwonRetOverMon" type="text" class="text w100p right" readOnly />
            </td>
        <td class="right">
				<input id="sht2_PreJobInvtOvrMon" name="sht2_PreJobInvtOvrMon" type="text" class="text w100p right" readOnly />
			</td>
		<td class="right">
            <input id="sht2_PreTotMon" name="sht2_PreTotMon" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right">합계</th>
        <td class="right">
            <input id="sumPayMon" name="sumPayMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sumBonusMon" name="sumBonusMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sumEtcBonusMon" name="sumEtcBonusMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sumStockBuyMon" name="sumStockBuyMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sumStockSnionMon" name="sumStockSnionMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
                <input id="sumImwonRetOverMon" name="sumImwonRetOverMon" type="text" class="text w100p right" readOnly />
            </td>
        <td class="right">
				<input id="sumJobInvtOvrMon" name="sumJobInvtOvrMon" type="text" class="text w100p right" readOnly />
			</td>
        <td class="right">
            <input id="sumTotMon" name="sumTotMon" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    </table>
    <!-- table2 -->
    <div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">[비과세소득]
            </li>
			<li style="float: left; line-height: 35px;" id="displayYn2" name="displayYn2">
				&nbsp;미신고 금액은 표시하지 않습니다. [정산계산내역조회]에서 확인하세요.
			</li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default line inner">
    <colgroup>
        <col width="4%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <col width="8.6%" />
        <%--<col width="8.6%" /> --%>
        <col width="10%" />
	</colgroup>
       <tr>
           <th class="center">구분</th>
           <th class="center">국외근로</th>
           <th class="center">야간근로<br>(생산)</th>
           <th class="center">보육수당</th>
           <th class="center">출산지원금</th>
           <th class="center">연구보조<br>(H09)</th>
		<th class="center">취재수당</th>          <%-- sht2_CurrNotaxRptMon --%>
           <th class="center">식대</th>
		<th class="center">수련보조<br>수당</th>       <%-- sht2_CurrNotaxEtcMon --%>
		<th class="center">직무발명<br>보상금</th>      <%-- sht2_CurrNotaxJobInvtMon --%>
           <%-- <th class="center">외국인</th> --%>
		<th class="center">그밖의<br>비과세</th>       <%-- sht2_CurrNotaxExtMon --%>
		<th class="center">계</th>              <%-- sht2_CurrNotaxTotMon --%>
	</tr>
    <tr>
        <th class="right">주(현)</th>
        <td class="right">
            <input id="sht2_CurrNotaxAbroadMon" name="sht2_CurrNotaxAbroadMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrNotaxWorkMon" name="sht2_CurrNotaxWorkMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrNotaxBabyMon" name="sht2_CurrNotaxBabyMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
			<input id="sht2_CurrNotaxBirthMon" name="sht2_CurrNotaxBirthMon" type="text" class="text w100p right" readOnly />
		</td>
        <td class="right">
            <input id="sht2_CurrNotaxResMon" name="sht2_CurrNotaxResMon" type="text" class="text w100p right" readOnly />
        </td>
		<td class="right">
			<input id="sht2_CurrNotaxRptMon" name="sht2_CurrNotaxRptMon" type="text" class="text w100p right" readOnly />
		</td>
        <td class="right">
            <input id="sht2_CurrNotaxFoodMon" name="sht2_CurrNotaxFoodMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrNotaxEtcMon" name="sht2_CurrNotaxEtcMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
			<input id="sht2_CurrNotaxJobInvtMon" name="sht2_CurrNotaxJobInvtMon" type="text" class="text w100p right" readOnly />
		</td>
        <%--
        <td class="right">
            <input id="sht2_CurrNotaxFornMon" name="sht2_CurrNotaxFornMon" type="text" class="text w100p right" readOnly />
        </td>
         --%>
        <td class="right">
            <input id="sht2_CurrNotaxExtMon" name="sht2_CurrNotaxExtMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrNotaxTotMon" name="sht2_CurrNotaxTotMon" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right">종(전)</th>
        <td class="right">
            <input id="sht2_PreNotaxAbroadMon" name="sht2_PreNotaxAbroadMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreNotaxWorkMon" name="sht2_PreNotaxWorkMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreNotaxBabyMon" name="sht2_PreNotaxBabyMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
			<input id="sht2_PreNotaxBirthMon" name="sht2_PreNotaxBirthMon" type="text" class="text w100p right" readOnly />
		</td>
        <td class="right">
            <input id="sht2_PreNotaxResMon" name="sht2_PreNotaxResMon" type="text" class="text w100p right" readOnly />
        </td>
		<td class="right">
			<input id="sht2_PreNotaxRptMon" name="sht2_PreNotaxRptMon" type="text" class="text w100p right" readOnly />
		</td>
        <td class="right">
            <input id="sht2_PreNotaxFoodMon" name="sht2_PreNotaxFoodMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreNotaxEtcMon" name="sht2_PreNotaxEtcMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
			<input id="sht2_PreNotaxJobInvtMon" name="sht2_PreNotaxJobInvtMon" type="text" class="text w100p right" readOnly />
		</td>
        <%--
        <td class="right">
            <input id="sht2_PreNotaxFornMon" name="sht2_PreNotaxFornMon" type="text" class="text w100p right" readOnly />
        </td> --%>
        <td class="right">
            <input id="sht2_PreNotaxExtMon" name="sht2_PreNotaxExtMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreNotaxTotMon" name="sht2_PreNotaxTotMon" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right" colspan="4">비과세총계</th>
        <td class="right" colspan="7">
            <input id="sht2_NotaxTotMon" name="sht2_NotaxTotMon" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    </table>
<%  } %>
    <!-- table3 -->
<%
    //회사코드가 서흥,젤텍 이면 적용);
    if("SH".equals(session.getAttribute("ssnEnterCd")) || "GT".equals(session.getAttribute("ssnEnterCd")) || "FMS".equals(session.getAttribute("ssnEnterCd")) || "CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
%>
    <div class="outer">
        <div class="sheet_title">
            <ul>
                <!-- <li class="txt" id="sheetCalcLi">[소득명세]</li> -->
                <li class="btn">
                <%if("A".equals(request.getParameter("orgAuthPg") ) ) {%>
                    <strong class='blue'>[해당 화면에서의 계산은 시뮬레이션용 임시 데이터이며 실제 계산은 담당자가 '연말정산계산' 화면에서 세금계산 체크 후 작업 해야합니다.]</strong>
                <%}else{%>
                    <font class='blue'></font>
                <%}%>
                    <a href="javascript:TaxCalcCheck();" class="basic btn-red ico-calc" id="sheetCalc"><b>모의계산</b></a>
                    <!-- <a href="javascript:IncomeCalc();" class="basic btn-white out-line">소득공제서</a> -->
                </li>
            </ul>
        </div>
    </div>


<%} %>
    <table border="0" cellpadding="0" cellspacing="0" class="default line inner">
    <colgroup>
        <col width="14%" />
        <col width="14%" />
        <col width="18%" />
        <col width="18%" />
        <col width="18%" />
        <col width="18%" />
    </colgroup>
    <tr>
        <th class="center" colspan="2">구분</th>
        <th class="center">소득세</th>
        <th class="center">지방소득세</th>
        <th class="center">농어촌특별세</th>
        <th class="center">계</th>
    </tr>
    <tr>
        <th class="right" colspan="2">결정세액</th>
        <td class="right">
            <input id="sht2_FinIncomeTax" name="sht2_FinIncomeTax" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_FinInbitTaxMon" name="sht2_FinInbitTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_FinAgrclTaxMon" name="sht2_FinAgrclTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_FinSum" name="sht2_FinSum" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right" rowspan="2">기납부 세액</th>
        <th class="right" >종(전)근무지</th>
        <td class="right">
            <input id="sht2_PreIncomeTax" name="sht2_PreIncomeTax" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreInbitTaxMon" name="sht2_PreInbitTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreAgrclTaxMon" name="sht2_PreAgrclTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_PreSum" name="sht2_PreSum" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right">주(현)근무지</th>
        <td class="right">
            <input id="sht2_CurrIncomeTax" name="sht2_CurrIncomeTax" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrInbitTaxMon" name="sht2_CurrInbitTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrAgrclTaxMon" name="sht2_CurrAgrclTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_CurrSum" name="sht2_CurrSum" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right" colspan="2">납부특례세액</th>
        <td class="right">
            <input id="sht2_SpcIncomeTaxMon" name="sht2_SpcIncomeTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_SpcInbitTaxMon" name="sht2_SpcInbitTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_SpcAgrclTaxMon" name="sht2_SpcAgrclTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_SpcSum" name="sht2_SpcSum" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    <tr>
        <th class="right" colspan="2">차감징수세액</th>
        <td class="right">
            <input id="sht2_BlcIncomeTax" name="sht2_BlcIncomeTax" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_BlcInbitTaxMon" name="sht2_BlcInbitTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_BlcAgrclTaxMon" name="sht2_BlcAgrclTaxMon" type="text" class="text w100p right" readOnly />
        </td>
        <td class="right">
            <input id="sht2_BlcSum" name="sht2_BlcSum" type="text" class="text w100p right" readOnly/>
        </td>
    </tr>
    </table>
    <div align="right">(금액이 '+' 인 경우 납부할 세금 / '-' 인 경우 환급받을 세금 입니다.)</div>
    <!-- table4 big! -->
    <div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt"></li>
            <li class="btn"></li>
            <li style="float: right; line-height: 35px; display:none;" id="displayYn3" name="displayYn3">
				&nbsp;외국인단일세율 적용일 경우, "총급여"액에 건강보험액, 고용보험액이 포함됩니다.
			</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default line outer" id="wkp_table" name="wkp_table">
        <colgroup>
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <col width="25%" />
            <col width="25%" />
        </colgroup>
        <tr>
            <th class="center" colspan="5">구분</th>
            <th class="center">입력금액</th>
            <th class="center">공제금액</th>
        </tr>
<%
    //회사코드가 서흥,젤텍 이면 적용
    if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
%>
        <tr>
            <th class="center" colspan="5">총 급 여( 과세대상급여 )</th>
            <th class="center"></th>
            <td class="right">
                <input id="sht2_TaxablePayMon" name="sht2_TaxablePayMon" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
<% } %>
        <tr>
            <th class="center" colspan="5">근로소득공제</th>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A000_01" name="sht5_A000_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="5">근로소득금액</th>
            <th class="center"></th>
            <td class="right">
                <input id="sht2_IncomeMon" name="sht2_IncomeMon" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="3">기본공제</th>
            <th class="center" colspan="2">본인</th>
            <th class="center" colspan="2"></th>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A010_01" name="sht5_A010_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">배우자</th>
            <th class="center" colspan="2"></th>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A010_03" name="sht5_A010_03" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">부양가족</th>
            <td class="right" colspan="2">
                <input id="sht5_A010_11_CNT" name="sht5_A010_11_CNT" type="text" class="text w100p right" readOnly />
            </td>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A010_11" name="sht5_A010_11" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="4">추가공제</th>
            <th class="center" colspan="2">경로우대(70세이상)</th>
            <td class="right" colspan="2">
                <input id="sht5_A020_03_CNT" name="sht5_A020_03_CNT" type="text" class="text w100p right" readOnly />
            </td>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A020_04" name="sht5_A020_04" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">장애인</th>
            <td class="right" colspan="2">
                <input id="sht5_A020_05_CNT" name="sht5_A020_05_CNT" type="text" class="text w100p right" readOnly />
            </td>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A020_05" name="sht5_A020_05" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">부녀자</th>
            <th class="center" colspan="2"></th>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A020_07" name="sht5_A020_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">한부모가족</th>
            <th class="center" colspan="2"></th>
            <th class="center"></th>
            <td class="right">
                <input id="sht5_A020_14" name="sht5_A020_14" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="5">연금보험료<br>공제</th>
            <th class="center" colspan="4">국민연금보험료</th>
            <td class="right">
                <input id="sht5_A030_01_INP" name="sht5_A030_01_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A030_01" name="sht5_A030_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="4">공적연금보험료</th>
            <th class="center">공무원연금</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A030_11_INP" name="sht5_A030_11_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A030_11" name="sht5_A030_11" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">군인연금</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A030_12_INP" name="sht5_A030_12_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A030_12" name="sht5_A030_12" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">사립학교교직원연금</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A030_02_INP" name="sht5_A030_02_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A030_02" name="sht5_A030_02" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">별정우체국연금</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A030_13_INP" name="sht5_A030_13_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A030_13" name="sht5_A030_13" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="14">특별소득공제</th>
            <th class="center" rowspan="2">보험료</th>
            <th class="center" >건강보험료</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A040_03_INP" name="sht5_A040_03_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A040_03" name="sht5_A040_03" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >고용보험료</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A040_04_INP" name="sht5_A040_04_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A040_04" name="sht5_A040_04" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="11">주택자금</th>
            <th class="center" rowspan="2">주택임차차입금</th>
            <th class="center" colspan="2">원리금상환액(대출기관)</th>
            <td class="right">
                <input id="sht5_A070_13" name="sht5_A070_13" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_14" name="sht5_A070_14" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">원리금상환액(거주자)</th>
            <td class="right">
                <input id="sht5_A070_19" name="sht5_A070_19" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_21" name="sht5_A070_21" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="9">장기주택저당차입금</th>
			<th class="center" rowspan="5">2011년 이전</th>
			<th class="center">15년미만</th>
            <td class="right">
                <input id="sht5_A070_17_INP" name="sht5_A070_17_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_17" name="sht5_A070_17" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
			<th class="center">15년이상</th>
            <td class="right">
                <input id="sht5_A070_15_INP" name="sht5_A070_15_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_15" name="sht5_A070_15" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
			<th class="center">30년이상</th>
            <td class="right">
                <input id="sht5_A070_16_INP" name="sht5_A070_16_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_16" name="sht5_A070_16" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <% // 2024년 변경 start %>
        <tr>
            <th class="center">15년이상 고정&비거치</th>
            <td class="right">
                <input id="sht5_A070_22_INP" name="sht5_A070_22_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_22" name="sht5_A070_22" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">15년이상 고정/비거치</th>
            <td class="right">
                <input id="sht5_A070_23_INP" name="sht5_A070_23_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_23" name="sht5_A070_23" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="4">2012년 이후</th>
			<th class="center">15년이상 고정&비거치</th>
            <td class="right">
                <input id="sht5_A070_24_INP" name="sht5_A070_24_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_24" name="sht5_A070_24" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">15년이상 고정/비거치</th>
            <td class="right">
                <input id="sht5_A070_25_INP" name="sht5_A070_25_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_25" name="sht5_A070_25" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">15년이상 기타대출</th>
            <td class="right">
                <input id="sht5_A070_26_INP" name="sht5_A070_26_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_26" name="sht5_A070_26" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">10년이상 고정/비거치</th>
            <td class="right">
                <input id="sht5_A070_27_INP" name="sht5_A070_27_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_27" name="sht5_A070_27" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <% // 2024년 변경 end %>
        <tr>
            <th class="center" colspan="5">계</th>
            <td class="right">
                <input id="sht5_A099_02" name="sht5_A099_02" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="6">차감소득금액</th>
            <td class="right">
                <input id="sht2_BlnceIncomeMon" name="sht2_BlnceIncomeMon" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="26">그 밖의<br>소득공제</th>
            <th class="center" colspan="2">개인연금저축</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_03_INP" name="sht5_A100_03_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_03" name="sht5_A100_03" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">소기업ㆍ소상공인 공제부금 소득공제</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_30_INP" name="sht5_A100_30_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_30" name="sht5_A100_30" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="3">주택마련저축</th>
            <th class="center" >청약저축</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_34_INP" name="sht5_A100_34_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_34" name="sht5_A100_34" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >주택청약종합저축</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_31_INP" name="sht5_A100_31_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_31" name="sht5_A100_31" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >근로자주택마련저축</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_33_INP" name="sht5_A100_33_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_33" name="sht5_A100_33" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <!--
        <tr>
            <th class="center" rowspan="6">투자조합 출자공제</th>
            <th class="center" rowspan="2" >2014.1.1 ~ 2014.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right">
                <input id="sht5_A100_55" name="sht5_A100_55" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="6">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right">
                <input id="sht5_A100_56" name="sht5_A100_56" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
         -->
        <% //2015년 추가 Start %>
        <!-- <tr>
            <th class="center" rowspan="6">투자조합 출자공제</th>
            <th class="center" rowspan="2" >2015.1.1 ~ 2015.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right">
                <input id="sht5_A100_57" name="sht5_A100_57" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="6">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right">
                <input id="sht5_A100_58" name="sht5_A100_58" type="text" class="text w100p right" readOnly />
            </td>
        </tr> -->
        <% //2015년 추가 End %>
        <% //2016년 추가 Start %>
        <!--  <tr>
            <th class="center" rowspan="6">투자조합 출자공제</th>
            <th class="center" rowspan="2" >2016.1.1 ~ 2016.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right">
                <input id="sht5_A100_59" name="sht5_A100_59" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="6">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right">
                <input id="sht5_A100_60" name="sht5_A100_60" type="text" class="text w100p right" readOnly />
            </td>
        </tr> -->
        <% //2016년 추가 End %>
        <% //2017년 추가 Start %>
        <!--
        <tr>
            <th class="center" rowspan="6">투자조합 출자공제</th>
            <th class="center" rowspan="2" >2017.1.1 ~ 2017.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right">
                <input id="sht5_A100_71" name="sht5_A100_71" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="6">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right">
                <input id="sht5_A100_72" name="sht5_A100_72" type="text" class="text w100p right" readOnly />
            </td>
        </tr> -->
        <% //2017년 추가 End %>
        <% //2018년 추가 Start %>
        <!--
        <tr>
            <th class="center" rowspan="6">투자조합 출자공제</th>
            <th class="center" rowspan="2" >2018.1.1 ~ 2018.12.31</th>
            <th class="center" colspan="2">간접출자</th>
            <td class="right">
                <input id="sht5_A100_73" name="sht5_A100_73" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="6">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">직접출자</th>
            <td class="right">
                <input id="sht5_A100_74" name="sht5_A100_74" type="text" class="text w100p right" readOnly />
            </td>
        </tr>-->
        <% //2018년 추가 End%>
        <% //2019년 추가 Start %>
        <!-- 
        <tr>
            <th class="center" rowspan="9">투자조합 출자공제</th>
            <th class="center" rowspan="3" >2019.1.1 ~ 2019.12.31</th>
            <th class="center" rowspan="2">간접출자</th>
            <th class="center">조합1</th>
            <td class="right">
                <input id="sht5_A100_75" name="sht5_A100_75" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="9">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">조합2</th>
            <td class="right">
                <input id="sht5_A100_79" name="sht5_A100_79" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">직접출자</th>
            <th class="center">벤처등</th>
            <td class="right">
                <input id="sht5_A100_76" name="sht5_A100_76" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
         -->
        <% //2019년 추가 End%>
        <% //2020년 추가 Start %>
        <!-- 
        <tr>
        	<th class="center" rowspan="9">투자조합 출자공제</th>
            <th class="center" rowspan="3" >2020.1.1 ~ 2020.12.31</th>
            <th class="center" rowspan="2">간접출자</th>
            <th class="center">조합1</th>
            <td class="right">
                <input id="sht5_A100_77" name="sht5_A100_77" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="9">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>            
        </tr>
        <tr>
            <th class="center">조합2</th>
            <td class="right">
                <input id="sht5_A100_80" name="sht5_A100_80" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">직접출자</th>
            <th class="center">벤처등</th>
            <td class="right">
                <input id="sht5_A100_78" name="sht5_A100_78" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        -->
        <% //2020년 추가 End%>
        <% //2021년 추가 Start %>
        <%--<tr>
            <th class="center" rowspan="9">투자조합 출자공제</th>
            <th class="center" rowspan="3" >2021.1.1 ~ 2021.12.31</th>
            <th class="center" rowspan="2">간접출자</th>
            <th class="center">조합1</th>
            <td class="right">
                <input id="sht5_A100_81" name="sht5_A100_81" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="9">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>   
        </tr>
        <tr>
            <th class="center">조합2</th>
            <td class="right">
                <input id="sht5_A100_82" name="sht5_A100_82" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">직접출자</th>
            <th class="center">벤처등</th>
            <td class="right">
                <input id="sht5_A100_83" name="sht5_A100_83" type="text" class="text w100p right" readOnly />
            </td>
        </tr>--%>
        <% //2021년 추가 End%>
        <% //2022년 추가 Start %>
        <tr>
            <th class="center" rowspan="9">투자조합 출자공제</th>
            <th class="center" rowspan="3" >2022.1.1 ~ 2022.12.31</th>
            <th class="center" rowspan="2">간접출자</th>
            <th class="center">조합1</th>
            <td class="right">
                <input id="sht5_A100_84" name="sht5_A100_84" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="9">
                <input id="sht5_A100_07" name="sht5_A100_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">조합2</th>
            <td class="right">
                <input id="sht5_A100_85" name="sht5_A100_85" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">직접출자</th>
            <th class="center">벤처등</th>
            <td class="right">
                <input id="sht5_A100_86" name="sht5_A100_86" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <% //2022년 추가 End%>
        <% //2023년 추가 Start %>
        <tr>
            <th class="center" rowspan="3" >2023.1.1 ~ 2023.12.31</th>
            <th class="center" rowspan="2">간접출자</th>
            <th class="center">조합1</th>
            <td class="right">
                <input id="sht5_A100_87" name="sht5_A100_87" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">조합2</th>
            <td class="right">
                <input id="sht5_A100_88" name="sht5_A100_88" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">직접출자</th>
            <th class="center">벤처등</th>
            <td class="right">
                <input id="sht5_A100_89" name="sht5_A100_89" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <% //2023년 추가 End%>
        <% //2024년 추가 Start %>
        <tr>
            <th class="center" rowspan="3" >2024.1.1 ~ 2024.12.31</th>
            <th class="center" rowspan="2">간접출자</th>
            <th class="center">조합1</th>
            <td class="right">
                <input id="sht5_A100_90" name="sht5_A100_90" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">조합2</th>
            <td class="right">
                <input id="sht5_A100_91" name="sht5_A100_91" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">직접출자</th>
            <th class="center">벤처등</th>
            <td class="right">
                <input id="sht5_A100_92" name="sht5_A100_92" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <% //2024년 추가 End%>
        <tr>
            <th class="center" rowspan="7">신용카드등 사용액 <br>소득공제</th>
            <th class="center" >신용카드 등</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_15" name="sht5_A100_15" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="7">
                <input id="sht5_A100_23" name="sht5_A100_23" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >현금영수증</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_13" name="sht5_A100_13" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >직불카드 등</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_22" name="sht5_A100_22" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >도서공연등사용분</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_42" name="sht5_A100_42" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >전통시장사용분</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_14" name="sht5_A100_14" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        
        <tr>
            <th class="center" >대중교통이용분</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_16" name="sht5_A100_16" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >사업관련비용</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_17" name="sht5_A100_17" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">우리사주조합 출연금</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_21_INP" name="sht5_A100_21_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_21" name="sht5_A100_21" type="text" class="text w100p right" readOnly />
            </td>
        </tr>

        <tr>
            <th class="center" colspan="2">고용유지 중소기업 근로자 소득공제</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_37_INP" name="sht5_A100_37_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_37" name="sht5_A100_37" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">목돈 안드는 전세 이자상환액</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_38_INP" name="sht5_A100_38_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_38" name="sht5_A100_38" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">장기집합투자증권저축</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_40_INP" name="sht5_A100_40_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_40" name="sht5_A100_40" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">청년형장기집합투자증권저축</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_A100_41_INP" name="sht5_A100_41_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_41" name="sht5_A100_41" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="6">그 밖의 소득공제 계</th>
            <td class="right">
                <input id="sht5_A100_99" name="sht5_A100_99" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="6">특별공제 종합한도 초과액</th>
            <td class="right">
                <input id="sht2_LIMIT_OVER_MON" name="sht2_LIMIT_OVER_MON" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="6">종합소득 과세표준</th>
            <td class="right">
                <input id="sht2_TaxBaseMon" name="sht2_TaxBaseMon" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="6">산출세액</th>
            <td class="right">
                <input id="sht2_ClclteTaxMon" name="sht2_ClclteTaxMon" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="5">세액감면</th>
            <th class="center" colspan="2">소득세법</th>
            <th class="center" colspan="3"></th>
            <!-- 2020.12.14 주석처리
            <td class="right">
                <input id="sht5_B010_14_INP" name="sht5_B010_14_INP" type="text" class="text w100p right" readOnly />
            </td>
            -->
            <td class="right">
                <input id="sht5_B010_14" name="sht5_B010_14" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">조세특례제한법(제30조 제외)</th>
            <th class="center" colspan="3"></th>
            <!-- 2020.12.14 주석처리
            <td class="right">
                <!-- 조세특례제한법 제19조, 제26조의6 추가 - 2019.12.24.
                <!-- <input id="sht5_B010_15_INP" name="sht5_B010_15_INP" type="text" class="text w100p right" readOnly />
                <input id="sht5_EX_B010_16_INP" name="sht5_EX_B010_16_INP" type="text" class="text w100p right" readOnly />
            </td>
            -->
            <td class="right">
                <!-- 조세특례제한법 제19조, 제26조의6 추가 - 2019.12.24. -->
                <!-- <input id="sht5_B010_15" name="sht5_B010_15" type="text" class="text w100p right" readOnly /> -->
                <input id="sht5_EX_B010_16" name="sht5_EX_B010_16" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">조세특례제한법 제30조</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_B010_30_31_INP" name="sht5_B010_30_31_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_B010_16" name="sht5_B010_16" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">조세조약</th>
            <th class="center" colspan="3"></th>
            <!-- 2020.12.14 주석처리
            <td class="right">
                <input id="sht5_B010_17_INP" name="sht5_B010_17_INP" type="text" class="text w100p right" readOnly />
            </td>
            -->
            <td class="right">
                <input id="sht5_B010_17" name="sht5_B010_17" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="5">세액감면 계</th>
            <td class="right">
                <input id="sht5_B010_13" name="sht5_B010_13" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="42">세액공제</th>
            <th class="center" colspan="2">근로소득</th>
            <th class="center" colspan="2"></th>
            <th class="center" ></th>
            <td class="right">
                <input id="sht5_B000_01" name="sht5_B000_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <%// 2024-11-01 결혼세액공제 신설 %>
        <tr>
            <th class="center" colspan="2">결혼 세액공제</th>
            <th class="center" colspan="2"></th>
            <th class="center" ></th>
            <td class="right">
                <input id="sht5_B002_10" name="sht5_B002_10" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <%//2015-04-23 수정,추가 start %>
        <tr>
            <th class="center" colspan="2" rowspan="2">자녀 세액공제</th>
            <th class="center" >자녀</th>
            <td class="center" ><input id="sht5_B000_10_CNT" name="sht5_A010_11_CNT" type="text" class="text w90p right" readOnly /> 명</td>
            <th class="center" ></th>
            <td class="right">
                <input id="sht5_B000_10" name="sht5_B000_10" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" >출산입양공제</th>
            <td class="center" ><input id="sht5_B001_30_CNT" name="sht5_B001_30_CNT" type="text" class="text w90p right" readOnly /> 명</td>
            <th class="center" ></th>
            <td class="right">
                <input id="sht5_B001_30" name="sht5_B001_30" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <%//2015-04-23 수정,추가 end %>
        <tr>
            <th class="center" rowspan="8">연금계좌</th>
            <th class="center" rowspan="2">과학기술인공제<br>(ISA미포함)</th>
            <th class="center" colspan="2">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A030_04_INP" name="sht5_A030_04_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A030_04_STD" name="sht5_A030_04_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">세액공제액</th>
            <td class="right">
                <input id="sht5_A030_04" name="sht5_A030_04" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">근로자퇴직급여 보장법에<br>따른 퇴직연금<br>(ISA미포함)</th>
            <th class="center" colspan="2">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A030_03_INP" name="sht5_A030_03_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A030_03_STD" name="sht5_A030_03_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">세액공제액</th>
            <td class="right">
                <input id="sht5_A030_03" name="sht5_A030_03" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">연금저축<br>(ISA미포함)</th>
            <th class="center" colspan="2">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A100_05_INP" name="sht5_A100_05_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A100_05_STD" name="sht5_A100_05_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">세액공제액</th>
            <td class="right">
                <input id="sht5_A100_05" name="sht5_A100_05" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">ISA 추가납입액</th>
            <th class="center" colspan="2">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_ISA_MON_INP" name="sht5_ISA_MON_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_ISA_MON_STD" name="sht5_ISA_MON_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">세액공제액</th>
            <td class="right">
                <input id="sht5_ISA_MON" name="sht5_ISA_MON" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <%//2015-04-23 start %>
        <tr>
            <th class="center" rowspan="24">특별세액공제</th>
            <th class="center" rowspan="4">보험료</th>
            <th class="center" rowspan="2">보장성보험료</th>
            <th class="center" >공제대상금액</th>
            <td class="right"  rowspan="2">
                <input id="sht5_A040_05_INP" name="sht5_A040_05_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A040_05_STD" name="sht5_A040_05_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A040_05" name="sht5_A040_05" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">장애인 전용</br>보장성보험료</th>
            <th class="center" >공제대상금액</th>
            <td class="right"  rowspan="2">
                <input id="sht5_A040_07_INP" name="sht5_A040_07_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A040_07_STD" name="sht5_A040_07_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A040_07" name="sht5_A040_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <%//2015-04-23 end %>
        <tr>
            <th class="center" rowspan="2">의료비</th>
            <th class="center" colspan="2">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A050_01_INP" name="sht5_A050_01_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A050_01_STD" name="sht5_A050_01_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">세액공제액</th>
            <td class="right">
                <input id="sht5_A050_01" name="sht5_A050_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">교육비</th>
            <th class="center" colspan="2">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A060_01_INP" name="sht5_A060_01_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A060_01_STD" name="sht5_A060_01_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">세액공제액</th>
            <td class="right">
                <input id="sht5_A060_01" name="sht5_A060_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="14">기부금<br><br><br>
                <a href="javascript:viewPopup();" class="basic" id="donDetailBtn">기부금 상세내역</a>
            </th>
            <th class="center" rowspan="2">정치자금기부금 (10만원이하)</th>
            <th class="center">공제대상금액</th>
            <td class="right" rowspan="4">
                <input id="sht5_A080_05_INP" name="sht5_A080_05_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_B010_05_STD" name="sht5_B010_05_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_B010_05" name="sht5_B010_05" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">정치자금기부금 (10만원초과)</th>
            <th class="center">공제대상금액</th>
            <td class="right">
                <input id="sht5_A080_05_STD" name="sht5_A080_05_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A080_05" name="sht5_A080_05" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">고향사랑기부금 (10만원이하)</th>
            <th class="center">공제대상금액</th>
            <td class="right" rowspan="4">
                <input id="sht5_A080_17_INP" name="sht5_A080_17_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A080_15_STD" name="sht5_A080_15_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A080_15" name="sht5_A080_15" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">고향사랑기부금 (10만원초과)</th>
            <th class="center">공제대상금액</th>
            <td class="right">
                <input id="sht5_A080_17_STD" name="sht5_A080_17_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A080_17" name="sht5_A080_17" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">특례기부금</th>
            <th class="center">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A080_03_INP" name="sht5_A080_03_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A080_03_STD" name="sht5_A080_03_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A080_03" name="sht5_A080_03" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" rowspan="2">우리사주조합 기부금</th>
            <th class="center">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A080_09_INP" name="sht5_A080_09_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A080_09_STD" name="sht5_A080_09_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A080_09" name="sht5_A080_09" type="text" class="text w100p right" readOnly />
            </td>
        </tr>

        <tr>
            <th class="center" rowspan="2">일반기부금</th>
            <th class="center">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A080_10_11_INP" name="sht5_A080_10_11_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A080_13_STD" name="sht5_A080_13_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center">세액공제액</th>
            <td class="right">
                <input id="sht5_A080_13" name="sht5_A080_13" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="4">특별세액공제 계
                <!-- <img id="tooltip_1" class="tooltip_custom" /> -->
                <!-- <i id="tooltip_1" class="tooltip_custom circle bg-red ico-exclamation"></i> -->
            </th>
            <td class="right">
                <input id="sht5_B013_01" name="sht5_B013_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="4">표준세액공제
                <!-- <img id="tooltip_2" class="tooltip_custom" src="/yjungsan/common_jungsan/images/icon/icon_quest.png" /> -->
                <!-- <i id="tooltip_2" class="tooltip_custom circle ico-question" /></i> -->
                &nbsp;&nbsp;&nbsp;<font id="sht5_A099_01_font" class='blue'>(표준세액공제 적용시 특별세액공제 계산되지 않음)</font></th>
            <td class="right">
                <input id="sht5_A099_01" name="sht5_A099_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">납세조합공제</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_B010_01_INP" name="sht5_B010_01_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_B010_01" name="sht5_B010_01" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">주택차입금</th>
            <th class="center" colspan="2"></th>
            <td class="right">
                <input id="sht5_B010_03_INP" name="sht5_B010_03_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_B010_03" name="sht5_B010_03" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <%if("A".equals(request.getParameter("orgAuthPg") ) ) {%>
            <th class="center" colspan="2" rowspan="2">외국납부
                <a href="javascript:viewForeignPayPopup();" class="basic" id="foreignPayDetailBtn">외국납부 상세내역</a>
            </th>
            <%}else{%>
            <th class="center" colspan="2" rowspan="2">외국납부</th>
            <%}%>

            <th class="center" colspan="2">소득금액</th>
            <td class="right">
                <input id="sht5_B010_09" name="sht5_B010_09" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right" rowspan="2">
                <input id="sht5_B010_07" name="sht5_B010_07" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">납부세액</th>
            <td class="right">
                <input id="sht5_B010_11" name="sht5_B010_11" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2" rowspan="2">월세</th>
            <th class="center" colspan="2">공제대상금액</th>
            <td class="right" rowspan="2">
                <input id="sht5_A070_10_INP" name="sht5_A070_10_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right">
                <input id="sht5_A070_10_STD" name="sht5_A070_10_STD" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">세액공제액</th>
            <td class="right">
                <input id="sht5_A070_10" name="sht5_A070_10" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="5">세액공제 계</th>
            <td class="right">
                <input id="sht2_TotTaxDeductMon" name="sht2_TotTaxDeductMon" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="6">결정세액</th>
            <td class="right">
                <input id="sht2_FinIncomeTax2" name="sht2_FinIncomeTax2" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="6">실효세율</th>
            <td class="right">
                <input id="sht2_EffTaxRate" name="sht2_EffTaxRate" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        </table>
    </form>
    <span class="hide">
        <script type="text/javascript">createIBSheet("yeaResultSht2", "100%", "100%"); </script>
        <script type="text/javascript">createIBSheet("yeaResultSht3", "100%", "100%"); </script>
        <script type="text/javascript">createIBSheet("yeaResultSht5", "100%", "100%"); </script>
    </span>
</div>

</body>
</html>