<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산계산내역(관리자)</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function(){

		$("#searchWorkYy").val( "<%=yeaYear%>" ) ;   
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		 
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
		$("#searchAdjustType").html( adjustTypeList[2]	) ;
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"work_yy",					Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"adjust_type",  			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"sabun",  					Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",  					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"enter_no",  				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"enter_no",  				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"adj_s_ymd",  				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adj_s_ymd",  				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"adj_e_ymd",  				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adj_e_ymd",  				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"residency_type",  			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"residency_type",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"citizen_type",  			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"citizen_type",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"residence_cd",  			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"residence_cd",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"residence_nm",  			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"residence_nm",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_pay_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_pay_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_bonus_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_bonus_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_etc_bonus_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_etc_bonus_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_tot_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_tot_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_pay_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_pay_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_bonus_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_bonus_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_etc_bonus_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_etc_bonus_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_tot_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_tot_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_tot_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_tot_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_abroad_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_abroad_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_work_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_work_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_etc_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_etc_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_ext_mon",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_ext_mon",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_tot_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_tot_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"notax_tot_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"notax_tot_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"other_pay_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"other_pay_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"other_notax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"other_notax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"taxable_pay_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"taxable_pay_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"income_mon",  				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"income_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"stand_deduct_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"stand_deduct_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"blnce_income_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"blnce_income_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"tax_base_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tax_base_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"clclte_tax_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"clclte_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"tot_tax_deduct_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tot_tax_deduct_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"fin_income_tax",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fin_income_tax",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"fin_inbit_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fin_inbit_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"fin_agrcl_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fin_agrcl_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"fin_tot_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fin_tot_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"fin_hel_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fin_hel_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_income_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_income_tax_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_inbit_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_inbit_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_agrcl_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_agrcl_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_tot_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_tot_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_hel_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_hel_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_income_tax_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_income_tax_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_inbit_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_inbit_tax_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_agrcl_tax_mMon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_agrcl_tax_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_tot_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_tot_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_hel_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_hel_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"blc_income_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"blc_income_tax_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"blc_inbit_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"blc_inbit_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"blc_agrcl_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"blc_agrcl_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"blc_tot_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"blc_tot_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"blc_hel_mon",  			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"blc_hel_mon",  			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"spc_income_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"spc_income_tax_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"spc_inbit_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"spc_inbit_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"spc_agrcl_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"spc_agrcl_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"spc_tot_tax_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"spc_tot_tax_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_baby_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_baby_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_forn_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_forn_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_notax_research_mon",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_notax_research_mon", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_baby_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_baby_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_forn_mon",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_forn_mon",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_research_mon",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_research_mon",  KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_abroad_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_abroad_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_work_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_work_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_etc_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_etc_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_notax_ext_mon",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_notax_ext_mon",       KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_stock_buy_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_stock_buy_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_stock_union_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_stock_union_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_stock_buy_mon",  		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_stock_buy_mon",  		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_stock_union_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_stock_union_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"curr_imwon_ret_over_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"curr_imwon_ret_over_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pre_imwon_ret_over_mon",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pre_imwon_ret_over_mon",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"limit_over_mon",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"limit_over_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"temp",						Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"temp",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"work_yy",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"adjust_type",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"sabun",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"business_place_cd",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pay_action_cd",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"zip",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"zip",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"addr1",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"addr1",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"org_cd",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"org_cd",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"org_nm",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"input_close_yn",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"input_close_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"apprv_yn",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"apprv_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"final_close_yn",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_close_yn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"pay_people_status",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pay_people_status",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"res_no",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"res_no",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"result_confirm_yn",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"result_confirm_yn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet3, initdata2);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetCountPosition(4);
	
		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata3.Cols = [
			{Header:"a00001", 		Type:"Int",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a000_01",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a01001", 		Type:"Int",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a010_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a01003", 		Type:"Int",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a010_03", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a01011", 		Type:"Int",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a010_11", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a02004", 		Type:"Int",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a020_04", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a02007", 		Type:"Int",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a020_07", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03001", 		Type:"Int",	    Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a04003_inp", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a040_03_inp", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a04004_inp",      	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a040_04_inp",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			<% //2015-04-23 추가,수정 start%>
            {Header:"a04005_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"a04005_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"a04007_inp",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"a04007_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            <% //2015-04-23 추가,수정 end%>
			{Header:"a05001_inp",      	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_01_inp",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a05001_std",      	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_01_std",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06001_inp",      	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_01_inp",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06001_std",      	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_01_std",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a05001", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06001", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07014", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_14", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07021", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_21", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07017", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_17", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07015", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_15", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07016", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_16", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07022", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_22", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07023", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_23", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			<%// 2015-04-22 Start %>
			{Header:"a07024",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_24",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a07025",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_25",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a07026",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_26",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a07027",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_27",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			<%// 2015-04-22 End %>
			
			{Header:"a08001", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10003", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_03", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10007", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_07", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10021", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_21", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10023", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_23", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10029", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_29", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10030", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_30", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10035", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_35", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10037", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_37", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10040", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_40", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01301", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b013_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a09901", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a099_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01001", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01003", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_03", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01005", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_05", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01007", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_07", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01014", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_14", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01015", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_15", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01016", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_16", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01017", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_17", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01014_inp", 	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_14_inp", 	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01015_inp", 	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_15_inp", 	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b0103031_inp", 	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_30_31_inp", 	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01017_inp", 	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_17_inp", 	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01013", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_13", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a02005", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a020_05", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06011", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_11", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b00001", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b000_01", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b00010", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b000_10", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },			
			<%//2015-04-23 start%>
            {Header:"b00010_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b000_10_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"b00120",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_20",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"b00130",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_30",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"b00120_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_20_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"b00130_cnt",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"b001_30_cnt",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            <%//2015-04-23 end%>
			{Header:"b01011", 		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_11", 		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a01011_cnt",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a010_11_cnt",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a02003_cnt",  	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a020_03_cnt",  	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a02005_cnt",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a020_05_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03001_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_01_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a04003",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a040_03",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a04004",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a040_04",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			<%//2015-04-23 start%>
            {Header:"a04005",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_05",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"a04007",       Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a040_07",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            <%//2015-04-23 end%>
			{Header:"a05005",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_05",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a05003",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_03",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a05007",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_07",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a05009",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_09",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06003",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_03",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06005_cnt",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_05_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06005",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_05",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06007_cnt",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_07_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06007",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_07",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06009_cnt",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_09_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06009",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_09",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06011_cnt",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_11_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07013",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_13",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07019",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_19",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07010_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_10_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07010_std",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_10_std",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07010",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_10",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07017_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_17_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07015_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_15_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07016_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_16_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07022_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_22_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a07023_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a070_23_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			
			<%//2015 추가사항 Start%>
			{Header:"a07024_inp",    Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_24_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a07025_inp",    Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_25_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a07026_inp",    Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_26_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a07027_inp",    Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a070_27_inp",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			<%//2015 추가사항 end%>
			
			{Header:"a08007",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_07",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08009",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_09",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08009_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_09_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08009_std",   Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a080_09_std",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a08010",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_10",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08011",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_11",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a09901",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a099_01",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10003_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_03_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10030_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_30_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10040_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_40_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10034",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_34",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10031",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_31",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10032",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_32",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10033",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_33",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10011",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_11",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10008",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_08",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10010",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_10",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10015",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_15",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10013",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_13",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10022",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_22",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10042",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_42",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10014",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_14",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10017",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_17",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10021_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_21_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10026",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_26",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10027",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_27",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10028",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_28",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10037_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_37_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10099",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_99",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01001_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_01_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01003_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_03_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01005_inp",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_05_inp",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01005_std",	Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_05_std",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"b01009",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"b010_09",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a02014",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a020_14",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03004",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_04",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03004_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_04_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03004_std",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_04_std",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03003",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_03",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03003_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_03_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03003_std",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_03_std",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10005",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_05",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10005_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_05_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10005_std",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_05_std",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a05020",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_20",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a05021",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a050_21",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06020",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_20",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a06021",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a060_21",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10009",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_09",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10012",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_12",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10055",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_55",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10056",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_56",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			<%//2015 추가사항 Start%>
			{Header:"a10057",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_57",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a10058",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_58",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			<%//2015 추가사항 end%>
			<%//2016 추가사항 Start%>
			{Header:"a10059",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_59",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a10060",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_60",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			<%//2016 추가사항 end%>
			<%//2017 추가사항 Start%>
			{Header:"a10071",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_71",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a10072",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_72",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			<%//2017 추가사항 end%>
			<%//2018 추가사항 Start%>
			{Header:"a10073",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_73",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"a10074",        Type:"Int",     Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"a100_74",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			<%//2018 추가사항 end%>
			{Header:"a10016",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_16",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10038",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_38",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10038_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_38_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10034_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_34_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10031_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_31_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a10033_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a100_33_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08005",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_05",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08005_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_05_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08005_std",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_05_std",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08003",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_03",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08003_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_03_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08003_std",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_03_std",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a080013",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_13",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08001011_inp",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_10_11_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a080013_std",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_13_std",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a09902",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a099_02",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a08020",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a080_20",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03011",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_11",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03012",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_12",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03002",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_02",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03013",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_13",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03011_inp",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_11_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03012_inp",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_12_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03002_inp",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_02_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"a03013_inp",				Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"a030_13_inp",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet5, initdata3);sheet5.SetEditable(false);sheet5.SetVisible(true);sheet5.SetCountPosition(4);

		sheet3.DoSearch( "<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=selectResList", $("#sheetForm").serialize(),1 );
	});
	
	$(function(){
		//Cancel 버튼 처리 
		$(".close").click(function(){
			p.self.close(); 
		});
	});
	
	/**
	 * 연말정산계산결과 시트를 각 항목에 입력 temp : TCPN841
	 */
	function sht2ToCtl(){
		if(sheet2.RowCount() > 0){
			$("#sht2_CurrPayMon").val( sheet2.GetCellText(1, "curr_pay_mon"));//현근무지급여 
			$("#sht2_CurrBonusMon").val( sheet2.GetCellText(1, "curr_bonus_mon"));//현근무지상여 
			$("#sht2_CurrEtcBonusMon").val( sheet2.GetCellText(1, "curr_etc_bonus_mon"));//현근무지인정상여
			$("#sht2_CurrStockBuyMon").val( sheet2.GetCellText(1, "curr_stock_buy_mon"));//현근무지주식매수선택권행사이익
			$("#sht2_CurrStockSnionMon").val( sheet2.GetCellText(1, "curr_stock_union_mon"));//현근무지우리사주조합인출금
			$("#sht2_CurrImwonRetOverMon").val( sheet2.GetCellText(1, "curr_imwon_ret_over_mon")) ;//현근무지임원퇴직소득금액한도초과액
			$("#sht2_CurrTotMon").val( sheet2.GetCellText(1, "curr_tot_mon")) ;//현근무지소득계
			$("#sht2_PrePayMon").val( sheet2.GetCellText(1, "pre_pay_mon")) ;//종전근무지급여 
			$("#sht2_PreBonusMon").val( sheet2.GetCellText(1, "pre_bonus_mon"));//종전근무지상여
			$("#sht2_PreEtcBonusMon").val( sheet2.GetCellText(1, "pre_etc_bonus_mon")) ;//종전근무지인정상여
			$("#sht2_PreStockBuyMon").val( sheet2.GetCellText(1, "pre_stock_buy_mon")) ;//종전근무지주식매수선택권행사이익
			$("#sht2_PreStockSnionMon").val( sheet2.GetCellText(1, "pre_stock_union_mon")) ;//종전근무지우리사주조합인출금
			$("#sht2_PreImwonRetOverMon").val( sheet2.GetCellText(1, "pre_imwon_ret_over_mon")) ;//종전근무지임원퇴직소득금액한도초과액
			$("#sht2_PreTotMon").val( sheet2.GetCellText(1, "pre_tot_mon")) ;//종전근무지소득계
			sheet2.SetCellValue(1, "temp", sheet2.GetCellValue(1, "curr_pay_mon")+sheet2.GetCellValue(1, "pre_pay_mon") ) ;
			$("#sumPayMon").val( sheet2.GetCellText(1, "temp"));
			sheet2.SetCellValue(1, "temp", sheet2.GetCellValue(1, "curr_bonus_mon")+sheet2.GetCellValue(1, "pre_bonus_mon") ) ;
			$("#sumBonusMon").val( sheet2.GetCellText(1, "temp"));
			sheet2.SetCellValue(1, "temp", sheet2.GetCellValue(1, "curr_etc_bonus_mon")+sheet2.GetCellValue(1, "pre_etc_bonus_mon") ) ;
			$("#sumEtcBonusMon").val( sheet2.GetCellText(1, "temp"));
			sheet2.SetCellValue(1, "temp", sheet2.GetCellValue(1, "curr_stock_buy_mon")+sheet2.GetCellValue(1, "pre_stock_buy_mon") ) ;
			$("#sumStockBuyMon").val( sheet2.GetCellText(1, "temp"));
			sheet2.SetCellValue(1, "temp", sheet2.GetCellValue(1, "curr_stock_union_mon")+sheet2.GetCellValue(1, "pre_stock_union_mon") ) ;
			$("#sumStockSnionMon").val( sheet2.GetCellText(1, "temp"));
			sheet2.SetCellValue(1, "temp", sheet2.GetCellValue(1, "curr_imwon_ret_over_mon")+sheet2.GetCellValue(1, "pre_imwon_ret_over_mon") ) ;
			$("#sumImwonRetOverMon").val( sheet2.GetCellText(1, "temp"));
			sheet2.SetCellValue(1, "temp", sheet2.GetCellValue(1, "curr_tot_mon")+sheet2.GetCellValue(1, "pre_tot_mon") ) ;
			$("#sumTotMon").val( sheet2.GetCellText(1, "temp"));
			$("#sht2_CurrNotaxAbroadMon").val( sheet2.GetCellText(1, "curr_notax_abroad_mon"));//현근무지국외근로비과세
			$("#sht2_CurrNotaxWorkMon").val( sheet2.GetCellText(1, "curr_notax_work_mon"));//현근무지야간근로수당비과세
			$("#sht2_CurrNotaxBabyMon").val( sheet2.GetCellText(1, "curr_notax_baby_mon"));//현근무지출산보육비과세
			$("#sht2_CurrNotaxFornMon").val( sheet2.GetCellText(1, "curr_notax_forn_mon"));//현근무지외국인근로자비과세
	        $("#sht2_CurrNotaxResMon").val( sheet2.GetCellText(1, "curr_notax_research_mon"));//현근무지연구보조비비과세						
			$("#sht2_CurrNotaxEtcMon").val( sheet2.GetCellText(1, "curr_notax_etc_mon"));//현근무지기타비과세
	        $("#sht2_CurrNotaxExtMon").val( sheet2.GetCellText(1, "curr_notax_ext_mon"));//현근무지그외비과세
			$("#sht2_CurrNotaxTotMon").val( sheet2.GetCellText(1, "curr_notax_tot_mon"));//현근무지비과세계
			$("#sht2_PreNotaxAbroadMon").val( sheet2.GetCellText(1, "pre_notax_abroad_mon"));//종전근무지국외근로비과세
			$("#sht2_PreNotaxWorkMon").val( sheet2.GetCellText(1, "pre_notax_work_mon"));//종전근무지야간근로수당비과세
			$("#sht2_PreNotaxBabyMon").val( sheet2.GetCellText(1, "pre_notax_baby_mon"));//종전근무지출산보육비과세
			$("#sht2_PreNotaxFornMon").val( sheet2.GetCellText(1, "pre_notax_forn_mon"));//종전근무지외국인근로자비과세
	        $("#sht2_PreNotaxResMon").val( sheet2.GetCellText(1, "pre_notax_research_mon"));//종전근무지연구보조비비과세
			$("#sht2_PreNotaxEtcMon").val( sheet2.GetCellText(1, "pre_notax_etc_mon"));//종전근무지기타비과세
	        $("#sht2_PreNotaxExtMon").val( sheet2.GetCellText(1, "pre_notax_ext_mon"));//종전근무지그외비과세
			$("#sht2_PreNotaxTotMon").val( sheet2.GetCellText(1, "pre_notax_tot_mon"));//종전근무지비과세계
			$("#sht2_NotaxTotMon").val( sheet2.GetCellText(1, "notax_tot_mon"));//비과세계
			$("#sht2_TaxablePayMon").val( sheet2.GetCellText(1, "taxable_pay_mon"));//과세대상급여총액
			$("#sht2_IncomeMon").val( sheet2.GetCellText(1, "income_mon"));//근로소득금액
			$("#sht2_TaxBaseMon").val( sheet2.GetCellText(1, "tax_base_mon")) ;//과세표준액
			$("#sht2_ClclteTaxMon").val( sheet2.GetCellText(1, "clclte_tax_mon"));//산출세액
			$("#sht2_BlnceIncomeMon").val( sheet2.GetCellText(1, "blnce_income_mon")) ;//차감소득금액
			$("#sht2_TotTaxDeductMon").val(	sheet2.GetCellText(1, "tot_tax_deduct_mon"));//세액공제액 
			$("#sht2_FinIncomeTax").val( sheet2.GetCellText(1, "fin_income_tax"));//결정소액(소득세)
			$("#sht2_FinIncomeTax2").val( sheet2.GetCellText(1, "fin_income_tax"));//결정소액(소득세)
			$("#sht2_FinInbitTaxMon").val( sheet2.GetCellText(1, "fin_inbit_tax_mon"));//결정세액(주민세)
			$("#sht2_FinAgrclTaxMon").val( sheet2.GetCellText(1, "fin_agrcl_tax_mon"));//결정세액(농어촌특별세)
			$("#sht2_FinSum").val( sheet2.GetCellText(1, "fin_tot_tax_mon"));//결정세액계
			$("#sht2_PreIncomeTax").val( sheet2.GetCellText(1, "pre_income_tax_mon")) ;//종(전)근무지(소득세)
			$("#sht2_PreInbitTaxMon").val( sheet2.GetCellText(1, "pre_inbit_tax_mon"));//종(전)근무지(주민세)
			$("#sht2_PreAgrclTaxMon").val( sheet2.GetCellText(1, "pre_agrcl_tax_mon"));//종(전)근무지(농어촌특별세)
			$("#sht2_PreSum").val( sheet2.GetCellText(1, "pre_tot_tax_mon"));//종(전)근무지계
			$("#sht2_CurrIncomeTax").val( sheet2.GetCellText(1, "curr_income_tax_mon")) ;//주(현)근무지(소득세)
			$("#sht2_CurrInbitTaxMon").val(	sheet2.GetCellText(1, "curr_inbit_tax_mon"));//주(현)근무지(주민세)
			$("#sht2_CurrAgrclTaxMon").val(	sheet2.GetCellText(1, "curr_agrcl_tax_mon"));//주(현)근무지(농어촌특별세)
			$("#sht2_CurrSum").val( sheet2.GetCellText(1, "curr_tot_tax_mon"));//주(현)근무지계
			$("#sht2_BlcIncomeTax").val( sheet2.GetCellText(1, "blc_income_tax_mon")) ;//차감징수세액(소득세)
			$("#sht2_BlcInbitTaxMon").val( sheet2.GetCellText(1, "blc_inbit_tax_mon"));//차감징수세액(주민세)
			$("#sht2_BlcAgrclTaxMon").val( sheet2.GetCellText(1, "blc_agrcl_tax_mon"));//차감징수세액(농어촌특별세)
			$("#sht2_BlcSum").val( sheet2.GetCellText(1, "blc_tot_tax_mon"));//차감징수세액계
			$("#sht2_LIMIT_OVER_MON").val( sheet2.GetCellText(1,"limit_over_mon"));//특별공제 종합한도 초과액

			$("#sht2_SpcIncomeTaxMon").val( sheet2.GetCellText(1, "spc_income_tax_mon"));//납부특례세액(소득세)
			$("#sht2_SpcInbitTaxMon").val( sheet2.GetCellText(1, "spc_inbit_tax_mon"));//납부특례세액(주민세)
			$("#sht2_SpcAgrclTaxMon").val( sheet2.GetCellText(1, "spc_agrcl_tax_mon"));//납부특례세액(농어촌특별세)
			$("#sht2_SpcSum").val( sheet2.GetCellText(1, "spc_tot_tax_mon"));//납부특례세액계

		} else{
			
			$("#sht2_CurrPayMon").val("0");//현근무지급여 
			$("#sht2_CurrBonusMon").val("0");//현근무지상여 
			$("#sht2_CurrEtcBonusMon").val("0");//현근무지인정상여
			$("#sht2_CurrStockBuyMon").val("0");//현근무지주식매수선택권행사이익
			$("#sht2_CurrStockSnionMon").val("0");//현근무지우리사주조합인출금
			$("#sht2_CurrImwonRetOverMon").val("0");//현근무지임원퇴직소득금액한도초과액
			$("#sht2_CurrTotMon").val("0");//현근무지소득계
			$("#sht2_PrePayMon").val("0");//종전근무지급여 
			$("#sht2_PreBonusMon").val("0");//종전근무지상여
			$("#sht2_PreEtcBonusMon").val("0");//종전근무지인정상여
			$("#sht2_PreStockBuyMon").val("0");//종전근무지주식매수선택권행사이익
			$("#sht2_PreStockSnionMon").val("0");//종전근무지우리사주조합인출금
			$("#sht2_PreImwonRetOverMon").val("0");//종전근무지임원퇴직소득금액한도초과액
			$("#sht2_PreTotMon").val("0");//종전근무지소득계
			$("#sumPayMon").val("0");
			$("#sumBonusMon").val("0");
			$("#sumEtcBonusMon").val("0");
			$("#sumStockBuyMon").val("0");
			$("#sumStockSnionMon").val("0");
			$("#sumImwonRetOverMon").val("0");
			$("#sumTotMon").val("0");
			$("#sht2_PreNotaxAbroadMon").val("0");//종전근무지국외근로비과세
			$("#sht2_PreNotaxWorkMon").val("0");//종전근무지야간근로수당비과세
			$("#sht2_PreNotaxEtcMon").val("0");//종전근무지기타비과세
	        $("#sht2_PreNotaxExtMon").val("0");//종전근무지그외비과세
	        $("#sht2_PreNotaxResMon").val("0");//종전근무지연구보조비비과세
			$("#sht2_PreNotaxFornMon").val("0");//종전근무지외국인근로자비과세			
			$("#sht2_PreNotaxBabyMon").val("0");//종전근무지출산보육비과세						
			$("#sht2_PreNotaxTotMon").val("0");//종전근무지비과세계
			$("#sht2_CurrNotaxAbroadMon").val("0");//현근무지국외근로비과세
			$("#sht2_CurrNotaxWorkMon").val("0");//현근무지야간근로수당비과세
			$("#sht2_CurrNotaxEtcMon").val("0");//현근무지기타비과세
	        $("#sht2_CurrNotaxExtMon").val("0");//현근무지그외비과세
	        $("#sht2_CurrNotaxResMon").val("0");//현근무지연구보조비비과세
			$("#sht2_CurrNotaxFornMon").val("0");//현근무지외국인근로자비과세			
			$("#sht2_CurrNotaxBabyMon").val("0");//현근무지출산보육비과세						
			$("#sht2_CurrNotaxTotMon").val("0");//현근무지비과세계
			
			//급여총액  현근무지급여총액+전근무지급여총액+기타급여
			
			$("#sht2_NotaxTotMon").val("0");//비과세계
			$("#sht2_TaxablePayMon").val("0");//과세대상급여총액
			$("#sht2_IncomeMon").val("0");//근로소득금액
			$("#sht2_TaxBaseMon").val("0") ;//과세표준액
			$("#sht2_ClclteTaxMon").val("0");//산출세액
			$("#sht2_BlnceIncomeMon").val("0");//차감소득금액
			$("#sht2_TotTaxDeductMon").val("0");//세액공제액 
			$("#sht2_FinIncomeTax").val("0");//결정소액(소득세)
			$("#sht2_FinIncomeTax2").val("0");//결정소액(소득세)
			$("#sht2_FinInbitTaxMon").val("0");//결정세액(주민세)
			$("#sht2_FinAgrclTaxMon").val("0");//결정세액(농어촌특별세)
			$("#sht2_FinSum").val("0");//결정세액계
			$("#sht2_PreIncomeTax").val("0") ;//종(전)근무지(소득세)
			$("#sht2_PreInbitTaxMon").val("0");//종(전)근무지(주민세)
			$("#sht2_PreAgrclTaxMon").val("0");//종(전)근무지(농어촌특별세)
			$("#sht2_PreSum").val("0");//종(전)근무지계
			$("#sht2_CurrIncomeTax").val("0") ;//주(현)근무지(소득세)
			$("#sht2_CurrInbitTaxMon").val("0");//주(현)근무지(주민세)
			$("#sht2_CurrAgrclTaxMon").val("0");//주(현)근무지(농어촌특별세)
			$("#sht2_CurrSum").val("0");//주(현)근무지계
			$("#sht2_BlcIncomeTax").val("0") ;//차감징수세액(소득세)
			$("#sht2_BlcInbitTaxMon").val("0");//차감징수세액(주민세)
			$("#sht2_BlcAgrclTaxMon").val("0");//차감징수세액(농어촌특별세)
			$("#sht2_BlcSum").val("0");//차감징수세액계
			$("#sht2_LIMIT_OVER_MON").val( "0");//특별공제 종합한도 초과액
			
			$("#sht2_SpcIncomeTaxMon").val("0");//납부특례세액(소득세)
			$("#sht2_SpcInbitTaxMon").val("0");//납부특례세액(주민세)
			$("#sht2_SpcAgrclTaxMon").val("0");//납부특례세액(농어촌특별세)
			$("#sht2_SpcSum").val("0");//납부특례세액계
		}	
	}
	
	/**
	 * 연말정산계산결과 상세시트를 각 항목에 입력 temp : TCPN843
	 */
	
	function sht5ToCtl(){
		if(sheet5.RowCount() > 0){
			for(var i = 0 ; i < $("input").length; i++) {
				if(($("input")[i].id).indexOf("sht5") > -1) {
					var shtValueName = (($("input")[i].id).toLowerCase()).replace("sht5_","");
					$("#"+$("input")[i].id).val( sheet5.GetCellText(1, shtValueName) );
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
	
	function finalCloseYnValueSet(){
		
		$("#sht2_CurrPayMon").val("");//현근무지급여 
		$("#sht2_CurrBonusMon").val("");//현근무지상여 
		$("#sht2_CurrEtcBonusMon").val("");//현근무지인정상여
		$("#sht2_CurrStockBuyMon").val("");//현근무지주식매수선택권행사이익
		$("#sht2_CurrStockSnionMon").val("");//현근무지우리사주조합인출금
		$("#sht2_CurrImwonRetOverMon").val("");//현근무지임원퇴직금액한도초과액
		$("#sht2_CurrTotMon").val("");//현근무지소득계
		$("#sht2_PrePayMon").val("");//종전근무지급여 
		$("#sht2_PreBonusMon").val("");//종전근무지상여
		$("#sht2_PreEtcBonusMon").val("");//종전근무지인정상여
		$("#sht2_PreStockBuyMon").val("");//종전근무지주식매수선택권행사이익
		$("#sht2_PreStockSnionMon").val("");//종전근무지우리사주조합인출금
		$("#sht2_PreImwonRetOverMon").val("");//종전근무지임원퇴직금액한도초과액
		$("#sht2_PreTotMon").val("");//종전근무지소득계
		$("#sumPayMon").val("");
		$("#sumBonusMon").val("");
		$("#sumEtcBonusMon").val("");
		$("#sumStockBuyMon").val("");
		$("#sumStockSnionMon").val("");
		$("#sumImwonRetOverMon").val("");
		$("#sumTotMon").val("");
		$("#sht2_PreNotaxAbroadMon").val("");//종전근무지국외근로비과세
		$("#sht2_PreNotaxWorkMon").val("");//종전근무지야간근로수당비과세
		$("#sht2_PreNotaxEtcMon").val("");//종전근무지기타비과세
		$("#sht2_PreNotaxFornMon").val("");//종전근무지외국인근로자비과세		
    	$("#sht2_PreNotaxResMon").val("");//종전근무지연구보조비비과세   
    	$("#sht2_PreNotaxExtMon").val("");//종전근무지그밖의비과세   	
		$("#sht2_PreNotaxBabyMon").val("");//종전근무지출산보육비과세						
		$("#sht2_PreNotaxTotMon").val("");//종전근무지비과세계
		$("#sht2_CurrNotaxAbroadMon").val("");//현근무지국외근로비과세
		$("#sht2_CurrNotaxWorkMon").val("");//현근무지야간근로수당비과세
		$("#sht2_CurrNotaxEtcMon").val("");//현근무지기타비과세
		$("#sht2_CurrNotaxFornMon").val("");//현근무지외국인근로자비과세
    	$("#sht2_CurrNotaxResMon").val("");//현근무지연구보조비비과세
    	$("#sht2_CurrNotaxExtMon").val("");//현근무지그밖의비과세			
		$("#sht2_CurrNotaxBabyMon").val("");//현근무지출산보육비과세						
		$("#sht2_CurrNotaxTotMon").val("");//현근무지비과세계
		//급여총액 = 현근무지급여총액+전근무지급여총액+기타급여
		$("#sht2_NotaxTotMon").val("");//비과세계
		$("#sht2_TaxablePayMon").val("");//과세대상급여총액
		$("#sht2_IncomeMon").val("");//근로소득금액
		$("#sht2_TaxBaseMon").val("");//과세표준액
		$("#sht2_ClclteTaxMon").val("");//산출세액
		$("#sht2_BlnceIncomeMon").val("");//차감소득금액
		$("#sht2_TotTaxDeductMon").val("");//세액공제액 
		$("#sht2_FinIncomeTax").val("");//결정소액(소득세)
		$("#sht2_FinIncomeTax2").val("");//결정소액(소득세)
		$("#sht2_FinInbitTaxMon").val("");//결정세액(주민세)
		$("#sht2_FinAgrclTaxMon").val("");//결정세액(농어촌특별세)
		$("#sht2_FinSum").val("");//결정세액계
		$("#sht2_PreIncomeTax").val("");//종(전)근무지(소득세)
		$("#sht2_PreInbitTaxMon").val("");//종(전)근무지(주민세)
		$("#sht2_PreAgrclTaxMon").val("");//종(전)근무지(농어촌특별세)
		$("#sht2_PreSum").val("");//종(전)근무지계
		$("#sht2_CurrIncomeTax").val("");//주(현)근무지(소득세)
		$("#sht2_CurrInbitTaxMon").val("");//주(현)근무지(주민세)
		$("#sht2_CurrAgrclTaxMon").val("");//주(현)근무지(농어촌특별세)
		$("#sht2_CurrSum").val("");//주(현)근무지계
		$("#sht2_BlcIncomeTax").val("");//차감징수세액(소득세)
		$("#sht2_BlcInbitTaxMon").val("");//차감징수세액(주민세)
		$("#sht2_BlcAgrclTaxMon").val("");//차감징수세액(농어촌특별세)
		$("#sht2_BlcSum").val("");//차감징수세액계
		$("#sht2_LIMIT_OVER_MON").val("");//특별공제 종합한도 초과액
		
		$("#sht2_SpcIncomeTaxMon").val("");//납부특례세액(소득세)
		$("#sht2_SpcInbitTaxMon").val("");//납부특례세액(주민세)
		$("#sht2_SpcAgrclTaxMon").val("");//납부특례세액(농어촌특별세)
		$("#sht2_SpcSum").val("");//납부특례세액계
		
		for(var i = 0 ; i < $("input").length; i++) {
			if(($("input")[i].id).indexOf("sht5") > -1) {
				var shtValueName = (($("input")[i].id).toLowerCase()).replace("sht5_","");
				$("#"+$("input")[i].id).val( "" );
			}
		}	
		/*
		$("#sht5_A000_01").val("");//근로소득공제 
		$("#sht5_A010_01").val("");//본인기본공제 
		$("#sht5_A010_03").val("");//배우자공제 
		$("#sht5_A010_11").val("");//부양가족공제 
		$("#sht5_A010_11_CNT").val("");//부양가족인원수
		$("#sht5_A020_04").val("");//경로우대공제
		$("#sht5_A020_05").val("");//장애자공제 
		$("#sht5_A020_07").val("");//부녀자공제 
		$("#sht5_A030_01").val("");//국민연금보험료공제 
		$("#sht5_A030_02").val("");//기타연금보험료공제 
		$("#sht5_A040_03").val("");//보험료공제-건강보험료  
    	$("#sht5_A040_04").val("");//보험료공제 -고용보험료
    	$("#sht5_A040_05").val("");//보험료공제 -보장성보험
    	$("#sht5_A040_07").val("");//보험료공제-장애인전용
		$("#sht5_A070_14").val("");//임차차입금 원리금공제  -- 대출기관
		$("#sht5_A070_21").val("");//임차차입금 원리금공제  -- 거주자
		$("#sht5_A070_17").val("");//임차차입금 이자금공제   -- 2011년 이전(15년미만)                 
		$("#sht5_A070_15").val("");//임차차입금 이자금공제   -- 2011년 이전(15년~29년)                
		$("#sht5_A070_16").val("");//임차차입금 이자금공제   -- 2011년 이전(30년이상)                  
		$("#sht5_A070_22").val("");//임차차입금 이자금공제   -- 2012년 이후(고정금리/비거치상환 대출)  
		$("#sht5_A070_23").val("");//임차차입금 이자금공제   -- 2012년 이후(기타 대출)                 
		$("#sht5_A100_03").val("");//개인연금저축공제  
		$("#sht5_A100_07").val("");//투조출자공제 
		$("#sht5_A100_21").val("");//우리사주공제
		$("#sht5_A100_23").val("");//신용카드공제   
		$("#sht5_A100_30").val("");//소기업.소상공인공제    
		$("#sht5_A100_37").val("");//임금삭감액공제   
		$("#sht5_B000_01").val("");//근로세액공제
		$("#sht5_B010_01").val("");//납세조합공제 
		$("#sht5_B010_03").val("");//주택자금세액공제 
		$("#sht5_B010_05").val("");//기부금세액공제 
		$("#sht5_B010_07").val("");//외국납부공제			
        $("#sht5_B010_14").val("");//소득세법		               
        $("#sht5_B010_15").val("");//조세특례제한법(제30조 제외)
        $("#sht5_B010_16").val("");//조세특례제한법 제30조		   
        $("#sht5_B010_17").val("");//조세조약		               
        $("#sht5_B010_14_INP").val("");//소득세법		               
        $("#sht5_B010_15_INP").val("");//조세특례제한법(제30조 제외)
        $("#sht5_B010_16_INP").val("");//조세특례제한법 제30조		   
        $("#sht5_B010_17_INP").val("");//조세조약		               
        $("#sht5_B010_13").val("");//세액감면 계		             			
		$("#sht5_A020_03_CNT").val("");//경로우대인원수
		$("#sht5_A020_05_CNT").val("");//장애인원수
		$("#sht5_A030_01_INP").val("");//국민연금보험료
		$("#sht5_A030_02_INP").val("");//기타연금보험료
		$("#sht5_A040_03_inp").val("");//건강보험공제
		$("#sht5_A040_04_inp").val("");//고용보험공제
		$("#sht5_A040_05_inp").val("");//보장성보험공제
		$("#sht5_A040_07_inp").val("");//장애인전용보험공제
		$("#sht5_A070_13").val("");//주택임차차입금원리금상환액
		$("#sht5_A070_19").val("");//주택임차차입금원리금상환액
		$("#sht5_A070_10_INP").val("");//월세액
		$("#sht5_A070_10").val("");//월세액공제
		$("#sht5_A070_17_INP").val("");//이자상환액(차입금상환기간 2011년 이전(15년미만)                 )
		$("#sht5_A070_15_INP").val("");//이자상환액(차입금상환기간 2011년 이전(15년~29년)                )
		$("#sht5_A070_16_INP").val("");//이자상환액(차입금상환기간 2011년 이전(30년이상)                 )
		$("#sht5_A070_22_INP").val("");//이자상환액(차입금상환기간 2012년 이후(고정금리/비거치상환 대출) )
		$("#sht5_A070_23_INP").val("");//이자상환액(차입금상환기간 2012년 이후(기타 대출)                )
		$("#sht5_A099_01").val("");//표준공제
		$("#sht5_A100_03_INP").val("");//개인연금저축소득
		$("#sht5_A100_30_INP").val("");//소기업·소상공인 공제부금
		$("#sht5_A100_34").val("");//주택청약저축
		$("#sht5_A100_31").val("");//주택청약종합저축
		$("#sht5_A100_33").val("");//근로자주택마련저축
		$("#sht5_A100_34_INP").val("");//주택청약저축
		$("#sht5_A100_31_INP").val("");//주택청약종합저축
		$("#sht5_A100_33_INP").val("");//근로자주택마련저축
     	$("#sht5_A100_11").val("");//투자조합출자(2011년 이전 출자)
    	$("#sht5_A100_08").val("");//투자조합출자(2012년 이후 출자(벤처기업 투자분 제외) )
     	$("#sht5_A100_10").val("");//투자조합출자(2012년 이후 출자(벤처기업 투자분))
		$("#sht5_A100_15").val("");//신용카드
		$("#sht5_A100_13").val("");//현금영수증
		$("#sht5_A100_22").val("");//직불(선불)카드
		$("#sht5_A100_14").val("");//전통시장사용분
		$("#sht5_A100_17").val("");//사업관련비용
		$("#sht5_A100_21_INP").val("");//우리사주조합출연금
		$("#sht5_A100_37_INP").val("");//고용유지중소기업근로자
		$("#sht5_A100_99").val("");//그밖의소득공제계
		$("#sht5_B010_01_INP").val("");//주택자금이자
		$("#sht5_B010_03_INP").val("");//납세조합공제
		$("#sht5_B010_05_INP").val("");//정치자금기부금
		$("#sht5_B010_09").val("");//국외근로소득
		$("#sht5_B010_11").val("");//외국납부세액
		
		$("#sht5_A020_14").val( "");
		$("#sht5_A030_04").val( "");
		$("#sht5_A030_04_INP").val( "");
		$("#sht5_A030_03").val( "");
		$("#sht5_A030_03_INP").val( "");
		$("#sht5_A100_05").val( "");
		$("#sht5_A100_05_INP").val( "");
		$("#sht5_A050_20").val( "");
		$("#sht5_A050_21").val( "");
		$("#sht5_A060_20").val( "");
		$("#sht5_A060_21").val( "");
		$("#sht5_A100_09").val( "");
		$("#sht5_A100_12").val( "");
		$("#sht5_A100_16").val( "");
		$("#sht5_A100_38").val( "");
		$("#sht5_A100_38_inp").val( "");
		$("#sht5_A080_05").val( "");
		$("#sht5_A080_03").val( "");
		$("#sht5_A080_09").val( "");
		$("#sht5_A080_10_11").val( "");
		$("#sht5_A099_02").val( "");
		
		$("#sht5_A030_11").val( "");
		$("#sht5_A030_12").val( "");
		$("#sht5_A030_02").val( "");
		$("#sht5_A030_13").val( "");
		$("#sht5_A030_11_INP").val( "");
		$("#sht5_A030_12_INP").val( "");
		$("#sht5_A030_02_INP").val( "");
		$("#sht5_A030_13_INP").val( "");
		*/
	}	
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				sht2ToCtl();
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}

	//조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				$("#searchPayActionCd").val(sheet3.GetCellValue(1, "pay_action_cd"));
				getLoad();
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	//조회 후 에러 메시지
	function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				sht5ToCtl();
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	function getLoad(){
		getCprBtnChk();
		sheet2.DoSearch( "<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=selectResList841", $("#sheetForm").serialize() );
		sheet5.DoSearch( "<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=selectResList843", $("#sheetForm").serialize() );	    
	}

	function reLoad(){
		getCprBtnChk();
		sheet3.DoSearch( "<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=selectResList", $("#sheetForm").serialize() );
		sheet2.DoSearch( "<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=selectResList841", $("#sheetForm").serialize() );
		sheet5.DoSearch( "<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=selectResList843", $("#sheetForm").serialize() );	    
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function print(printGbn){
		
		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		
		// args의 Y/N 구분자는 없으면 N과 같음
		var rdFileNm = "WorkIncomeWithholdReceipt_"+$("#searchWorkYy").val()+".mrd";
		
		
        //원천징수영수증 출력시 2014 이후에는 
		//재정산 이전의 결과를 출력할 수 있도록 별도의 작업(이전)버튼이 존재
		if(printGbn == "printBk") {
			rdFileNm = "WorkIncomeWithholdReceipt_"+$("#searchWorkYy").val()+"reCalc.mrd";	
		}
		
		var imgPath = '<%=removeXSS(rdStempImgUrl,"filePathUrl")%>';
		var imgFile = '<%=removeXSS(rdStempImgFile,"fileName")%>';
		var bpCd = "ALL" ;

		args["rdTitle"] = "원천징수영수증" ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>]"             // 1.ssnEnterCd
			            + " ["+$("#searchWorkYy").val()+"]"			              // 2.searchWorkYY
			            + " ["+$("#searchAdjustType").val()+"]"	                  // 3.searchAdjustType
			            + " ['"+$("#searchSabun").val()+"']"		              // 4.searchSabuns
			            + " ['']"									              // 5.allEmpSearch
			            + " ["+bpCd+"]"								              // 6.searchBizPlaceCd
			            + " [C]"									              // 7.searchPurposeCd
			            + " ["+imgPath+"]"							              // 8.imgPath
			            + " [4]"									              // 9.searchSort
			            + " ["+$("#searchSabun").val()+"]"			              // 10.searchSortSabuns
			            + " []"										              // 11.searchSortNos
			            + " []"										              // 12.searchPageLimit
			            + " []"										              // 13.searchPrintYMD
			            + " ["+ imgFile +"]"						              // 14.imgFile
			            + " [1]"									              // 15.stampChk
                        +"["+$("#searchOption").val()+"]";//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF
		
		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}		

	//이상없음 확인
	function do_result_close(){
		if(confirm("확인 하시겠습니까?")){
			//자료등록 화면의 본인 입력 마감 로직이다.
			var data = ajaxCall("<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=prcYeaResultConfirm",$("#sheetForm").serialize(),false);
			
			if(data.Result.Code == 1) {
		   		reLoad() ;
			}
		 }
	}	

	//이름 바뀌면 호출
	function setEmpPage() { 
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		
		sheet3.DoSearch( "<%=jspPath%>/yeaCalcLst/yeaCalcLstRst.jsp?cmd=selectResList", $("#sheetForm").serialize() );
	}
	
	function cprYeedAdjm(){
        var args = [];
        args["searchWorkYy"]        = $("#searchWorkYy").val();
        args["searchAdjustType"]    = $("#searchAdjustType").val() ;
        args["searchSabun"]         = $("#searchSabun").val() ;
        args["searchGubun"]         = "2";
        args["searchPayActionCd"]   = $("#searchPayActionCd").val() ;
        args["searchReCalcSeq"]     = $("#searchReCalcSeq").val() ;
        
        if(!isPopup()) {return;}
        var rv = openPopup("<%=jspPath%>/yeaCalcLst/yeaCalcLstResultPopup.jsp",args,"1000","750");  
        
    }   
	
	function getCprBtnChk(){
        var params = "searchWorkYy="+$("#searchWorkYy").val()
        +"&searchAdjustType="+$("#searchAdjustType").val()
        +"&searchSabun="+$("#searchSabun").val()
        +"&searchPayActionCd="+$("#searchPayActionCd").val();

        //재계산 차수 값 조회
        var searchReCalcSeq = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq842Bk", params,false).codeList;
        if(searchReCalcSeq[0].code != "") {
            
            $("#searchReCalcSeq").val(searchReCalcSeq[0].code);
            $("#cmpBtn").removeClass("hide");
            
            return ;
        }else{
            $("#searchReCalcSeq").val("");
            $("#cmpBtn").addClass("hide");
        }
    }
	
	
</script>
</head>
<body class="bodywrap" style="overflow:scroll;">
<div class="wrapper">

	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>

	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchReCalcSeq"   name="searchReCalcSeq"   value="" />
	<div class="sheet_search outer">
    <!-- 관리자 조회 조건 -->
        <div>
        <table>
        <tr>
            <td><span>대상년도</span>
				<input type="text" id="searchWorkYy" name="searchWorkYy" class="text readonly" maxlength="4" size="4" readonly/>
            </td>
            <td><span>작업구분</span>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:reLoad();" class="box"></select>
			</td>
            <td>
				<div class="outer">
					<ul>
						<li id="txt" class="txt"> </li>
						<li class="btn">
							<a href="javascript:reLoad();" class="basic">조회</a>
                            <a href="javascript:print('print');" class="basic">원천징수영수증</a>
                            출력옵션:
                            <select id="searchOption" name ="searchOption" onChange="" class="box">
                                <option value="N" >미출력</option>
                                <option value="Y" selected>출력</option>
                            </select>
                            <span id="cmpBtn" class="hide">
                            <a href="javascript:cprYeedAdjm();" class="cute" >과거 계산내역과 비교하기</a>&nbsp;
                            <a href="javascript:print('printBk');" class="cute">원천징수영수증(이전)</a>
                            </span>
						</li>
					</ul>
				</div>
            </td>
        </tr>
        </table>
        </div>
    </div>			
	</form>

	<div class="outer" >
		<!-- table1 -->
		<div class="outer">
		    <div class="sheet_title">
		        <ul>
		            <li class="txt">[소득명세]
		            </li>
		            <li class="btn">
		    		</li>
		        </ul>
		    </div>
	    </div>
	    <table border="0" cellpadding="0" cellspacing="0" class="default inner">
		<colgroup>
	        <col width="10%" />
	        <col width="8%" />
	        <col width="8%" />
	        <col width="8%" />
	        <col width="8%" />
	        <col width="8%" />
	        <col width="8%" />
	        <col width="" />
		</colgroup>
		<tr>
			<th class="center">구분</th>
			<th class="center">급여</th>
			<th class="center">상여</th>
			<th class="center">인정상여</th>
			<th class="center">주식매수선택권<br>행사이익</th>
			<th class="center">우리사주<br>조합인출금</th>
			<th class="center">임원퇴직소득금액<br>한도초과액</th>
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
		            <li class="btn">
		    		</li>
		        </ul>
		    </div>
	    </div>
	    <table border="0" cellpadding="0" cellspacing="0" class="default inner">
		<colgroup>
	        <col width="11%" />
	        <col width="11%" />
	        <col width="11%" />
	        <col width="11%" />
	        <col width="11%" />
	        <col width="11%" />
	        <col width="11%" />
	        <col width="11%" />
	        <col width="" />
		</colgroup>
		<tr>
			<th class="center">구분</th>
			<th class="center">국외근로</th>
			<th class="center">출산보육</th>
			<th class="center">생산(야간근로)</th>
			<th class="center">외국인</th>
			<th class="center">연구보조비</th>
			<th class="center">수련보조수당</th>
			<th class="center">그밖의비과세</th>
			<th class="center">계</th>
		</tr>
		<tr>
			<th class="right">주(현)</th>
			<td class="right"> 
				<input id="sht2_CurrNotaxAbroadMon" name="sht2_CurrNotaxAbroadMon" type="text" class="text w100p right" readOnly /> 
			</td>
			<td class="right"> 
				<input id="sht2_CurrNotaxBabyMon" name="sht2_CurrNotaxBabyMon" type="text" class="text w100p right" readOnly /> 
			</td>
			<td class="right"> 
				<input id="sht2_CurrNotaxWorkMon" name="sht2_CurrNotaxWorkMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_CurrNotaxFornMon" name="sht2_CurrNotaxFornMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_CurrNotaxResMon" name="sht2_CurrNotaxResMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_CurrNotaxEtcMon" name="sht2_CurrNotaxEtcMon" type="text" class="text w100p right" readOnly />
			</td>
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
				<input id="sht2_PreNotaxBabyMon" name="sht2_PreNotaxBabyMon" type="text" class="text w100p right" readOnly /> 
			</td>
			<td class="right"> 
				<input id="sht2_PreNotaxWorkMon" name="sht2_PreNotaxWorkMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_PreNotaxFornMon" name="sht2_PreNotaxFornMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_PreNotaxResMon" name="sht2_PreNotaxResMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_PreNotaxEtcMon" name="sht2_PreNotaxEtcMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_PreNotaxExtMon" name="sht2_PreNotaxExtMon" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht2_PreNotaxTotMon" name="sht2_PreNotaxTotMon" type="text" class="text w100p right" readOnly/> 
			</td>
		</tr>
		<tr>
			<td class="right" colspan="4">비과세총계</td>
			<td class="right" colspan="5"> 
				<input id="sht2_NotaxTotMon" name="sht2_NotaxTotMon" type="text" class="text w100p right" readOnly/> 
			</td>
		</tr>
		</table>
		<!-- table3 -->
		<div class="outer">
		    <div class="sheet_title">
		        <ul>
		            <li class="txt">[세액명세]
		            </li>
		            <li class="btn">
		    		</li>
		        </ul>
		    </div>
	    </div>
	    <table border="0" cellpadding="0" cellspacing="0" class="default inner">
		<colgroup>
	        <col width="10%" />
	        <col width="16%" />
	        <col width="16%" />
	        <col width="16%" />
	        <col width="16%" />
	        <col width="" />
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
		            <li class="txt">
		            </li>
		            <li class="btn">
		    		</li>
		        </ul>
		    </div>
	    </div>
	    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
	        <col width="15%" />
	        <col width="15%" />
	        <col width="15%" />
	        <col width="15%" />
	        <col width="10%" />
	        <col width="15%" />
	        <col width="15%" />
		</colgroup>
		<tr>
			<th class="center" colspan="5">구분</th>
			<th class="center">입력금액</th>
			<th class="center">공제금액</th>
		</tr>
		<tr>
			<th class="center" colspan="5">총 급 여( 과세대상급여 )</th>
			<th class="center"></th>
			<td class="right"> 
				<input id="sht2_TaxablePayMon" name="sht2_TaxablePayMon" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
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
			<th class="center" rowspan="15">특별소득공제</th>
			<th class="center" rowspan="2">보험료</th>
			<th class="center">건강보험료</th>
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
			<th class="center" colspan="2">2011년 이전(15년미만)</th>
			<td class="right"> 
				<input id="sht5_A070_17_INP" name="sht5_A070_17_INP" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht5_A070_17" name="sht5_A070_17" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<tr>
			<th class="center" colspan="2">2011년 이전(15년~29년)</th>
			<td class="right"> 
				<input id="sht5_A070_15_INP" name="sht5_A070_15_INP" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht5_A070_15" name="sht5_A070_15" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<tr>
			<th class="center" colspan="2">2011년 이전(30년이상)</th>
			<td class="right"> 
				<input id="sht5_A070_16_INP" name="sht5_A070_16_INP" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht5_A070_16" name="sht5_A070_16" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<tr>
			<th class="center" colspan="2">2012년 이후(고정금리/비거치상환)</th>
			<td class="right"> 
				<input id="sht5_A070_22_INP" name="sht5_A070_22_INP" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht5_A070_22" name="sht5_A070_22" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<tr>
			<th class="center" colspan="2">2012년 이후(기타 대출)</th>
			<td class="right"> 
				<input id="sht5_A070_23_INP" name="sht5_A070_23_INP" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht5_A070_23" name="sht5_A070_23" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		
		<% // 2015년 변경 start %>
		<tr>
            <th class="center" colspan="2">2015년 이후(15년이상 고정&비거치 상환)</th>
            <td class="right"> 
                <input id="sht5_A070_24_INP" name="sht5_A070_24_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right"> 
                <input id="sht5_A070_24" name="sht5_A070_24" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">2015년 이후(15년이상 고정/비거치 상환)</th>
            <td class="right"> 
                <input id="sht5_A070_25_INP" name="sht5_A070_25_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right"> 
                <input id="sht5_A070_25" name="sht5_A070_25" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">2015년 이후(15년이상 기타대출)</th>
            <td class="right"> 
                <input id="sht5_A070_26_INP" name="sht5_A070_26_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right"> 
                <input id="sht5_A070_26" name="sht5_A070_26" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <tr>
            <th class="center" colspan="2">2015년 이후(10년이상 고정/비거치 상환)</th>
            <td class="right"> 
                <input id="sht5_A070_27_INP" name="sht5_A070_27_INP" type="text" class="text w100p right" readOnly />
            </td>
            <td class="right"> 
                <input id="sht5_A070_27" name="sht5_A070_27" type="text" class="text w100p right" readOnly />
            </td>
        </tr>
        <% // 2015년 변경 end %>
        
        
		<tr>
			<th class="center" colspan="2">기부금(이월분)</th>
			<th class="center" colspan="2"></th>
			<th class="center" ></th>
			<td class="right"> 
				<input id="sht5_A080_20" name="sht5_A080_20" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
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
			<th class="center" rowspan="22">그 밖의<br>소득공제</th>
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
		<% //2016년 추가 Start %>
		<tr>
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
		</tr>
		<% //2016년 추가 End %>
		<% //2017년 추가 Start %>
		<tr>
			<th class="center" rowspan="2" >2017.1.1 ~ 2017.12.31</th>
			<th class="center" colspan="2">간접출자</th>
			<td class="right"> 
				<input id="sht5_A100_71" name="sht5_A100_71" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<tr>
			<th class="center" colspan="2">직접출자</th>
			<td class="right"> 
				<input id="sht5_A100_72" name="sht5_A100_72" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<% //2017년 추가 End %>
		<% //2018년 추가 Start %>
		<tr>
			<th class="center" rowspan="2" >2018.1.1 ~ 2018.12.31</th>
			<th class="center" colspan="2">간접출자</th>
			<td class="right"> 
				<input id="sht5_A100_73" name="sht5_A100_73" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<tr>
			<th class="center" colspan="2">직접출자</th>
			<td class="right"> 
				<input id="sht5_A100_74" name="sht5_A100_74" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<% //2018년 추가 End %>
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
			<th class="center" >도서공연사용분</th>
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
			<th class="center" colspan="2"></th>
			<td class="right"> 
				<input id="sht5_B010_14_INP" name="sht5_B010_14_INP" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht5_B010_14" name="sht5_B010_14" type="text" class="text w100p right" readOnly />
			</td>
		</tr>
		<tr>
			<th class="center" colspan="2">조세특례제한법(제30조 제외)</th>
			<th class="center" colspan="2"></th>
			<td class="right"> 
				<input id="sht5_B010_15_INP" name="sht5_B010_15_INP" type="text" class="text w100p right" readOnly />
			</td>
			<td class="right"> 
				<input id="sht5_B010_15" name="sht5_B010_15" type="text" class="text w100p right" readOnly />
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
			<th class="center" colspan="2"></th>
			<td class="right"> 
				<input id="sht5_B010_17_INP" name="sht5_B010_17_INP" type="text" class="text w100p right" readOnly />
			</td>
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
			<th class="center" rowspan="36">세액공제</th>
			<th class="center" colspan="2">근로소득</th>
			<th class="center" colspan="2"></th>
			<th class="center" ></th>
			<td class="right"> 
				<input id="sht5_B000_01" name="sht5_B000_01" type="text" class="text w100p right" readOnly />
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
			<th class="center" rowspan="6">연금계좌</th>
			<th class="center" rowspan="2">과학기술인공제</th>
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
			<th class="center" rowspan="2">근로자퇴직급여 보장법에<br> 따른 퇴직연금</th>
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
			<th class="center" rowspan="2">연금저축</th>
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
		
		<%//2015-04-23 start %>
        <tr>
            <th class="center" rowspan="20">특별세액공제</th>
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
			<th class="center" rowspan="10">기부금</th>
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
			<th class="center" rowspan="2">법정기부금</th>
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
			<th class="center" rowspan="2">지정기부금</th>
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
			<th class="center" colspan="4">특별세액공제 계</th>
			<td class="right"> 
				<input id="sht5_B013_01" name="sht5_B013_01" type="text" class="text w100p right" readOnly />
			</td>
		</tr>		
		<tr>
			<th class="center" colspan="4">표준세액공제</th>
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
			<th class="center" colspan="2" rowspan="2">외국납부</th>
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
		</table>
		<span class="hide">
			<script type="text/javascript">createIBSheet("sheet2", "100%", "100px"); </script>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "100px"); </script>
			<script type="text/javascript">createIBSheet("sheet5", "100%", "100px"); </script>
		</span>
	</div>
</div>

</body>
</html>